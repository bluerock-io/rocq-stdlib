(************************************************************************)
(*         *      The Rocq Prover / The Rocq Development Team           *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

(** This module proves some logical properties of the axiomatic of Reals.

- Decidability of arithmetical statements.
- Derivability of the Archimedean "axiom".
- Decidability of negated formulas.
*)

From Stdlib Require Import PeanoNat.
From Stdlib Require Import Zabs.
From Stdlib Require Import Zorder.
From Stdlib Require Import RIneq.

(** * Decidability of arithmetical statements *)

(** One can iterate this lemma and use classical logic to decide any
statement in the arithmetical hierarchy. *)

Section Arithmetical_dec.

Variable P : nat -> Prop.
Hypothesis HP : forall n, {P n} + {~P n}.

Lemma sig_forall_dec : {n | ~P n} + {forall n, P n}.
Proof.
assert (Hi: (forall n, 0 < INR n + 1)%R). {
  intros n.
  apply Rplus_le_lt_0_compat with (1 := (pos_INR n)); apply Rlt_0_1.
}
set (u n := (if HP n then 0 else / (INR n + 1))%R).
assert (Bu: forall n, (u n <= 1)%R). {
  intros n.
  unfold u.
  case HP ; intros _.
  - apply Rle_0_1.
  - rewrite <- S_INR, <- Rinv_1.
    apply Rinv_le_contravar with (1 := Rlt_0_1).
    apply (le_INR 1); apply -> Nat.succ_le_mono; apply Nat.le_0_l.
}
set (E y := exists n, y = u n).
destruct (completeness E) as [l [ub lub]].
- exists R1.
  intros y [n ->].
  apply Bu.
- exists (u O).
  now exists O.
- assert (Hnp: forall n, not (P n) -> ((/ (INR n + 1) <= l)%R)). {
    intros n Hp.
    apply ub.
    exists n.
    unfold u.
    now destruct (HP n).
  }
  destruct (Rle_lt_dec l 0) as [Hl|Hl].
  + right.
    intros n.
    destruct (HP n) as [H|H].
    * exact H.
    * exfalso.
      apply Rle_not_lt with (1 := Hl).
      apply Rlt_le_trans with (/ (INR n + 1))%R.
      -- now apply Rinv_0_lt_compat.
      -- now apply Hnp.
  + left.
    set (N := Z.abs_nat (up (/l) - 2)).
    assert (H1l: (1 <= /l)%R). {
      rewrite <- Rinv_1.
      apply Rinv_le_contravar with (1 := Hl).
      apply lub.
      now intros y [m ->].
    }
    assert (HN: (INR N + 1 = IZR (up (/ l)) - 1)%R). {
      unfold N.
      rewrite INR_IZR_INZ.
      rewrite inj_Zabs_nat.
      replace (IZR (up (/ l)) - 1)%R with (IZR (up (/ l) - 2) + 1)%R.
      - apply (f_equal (fun v => IZR v + 1)%R).
        apply Z.abs_eq.
        apply Zle_minus_le_0.
        apply (Zlt_le_succ 1).
        apply lt_IZR.
        apply Rle_lt_trans with (1 := H1l).
        apply archimed.
      - rewrite minus_IZR.
        simpl.
        ring.
    }
    assert (Hl': (/ (INR (S N) + 1) < l)%R). {
      rewrite <- (Rinv_inv l).
      apply Rinv_0_lt_contravar.
      { now apply Rinv_0_lt_compat. }
      rewrite S_INR.
      rewrite HN.
      ring_simplify.
      apply archimed.
    }
    exists N.
    intros H.
    apply Rle_not_lt with (2 := Hl').
    apply lub.
    intros y [n ->].
    unfold u.
    destruct (HP n) as [_|Hp].
    * apply Rlt_le.
      now apply Rinv_0_lt_compat.
    * apply Rinv_le_contravar.
      -- apply Hi.
      -- apply Rplus_le_compat_r.
         apply le_INR.
         destruct (Nat.le_gt_cases n N) as [Hn|Hn].
         2: now apply Nat.le_succ_l.
         exfalso.
         destruct (proj1 (Nat.lt_eq_cases _ _) Hn) as [Hn'| ->].
         2: now apply Hp.
         apply Rlt_not_le with (2 := Hnp _ Hp).
         rewrite <- (Rinv_inv l).
         apply Rinv_0_lt_contravar.
         ++ apply Rplus_le_lt_0_compat.
            ** apply pos_INR.
            ** apply Rlt_0_1.
         ++ apply Rlt_le_trans with (INR N + 1)%R.
            ** apply Rplus_lt_compat_r.
               now apply lt_INR.
            ** rewrite HN.
               apply Rplus_le_reg_r with (-/l + 1)%R.
               ring_simplify.
               apply archimed.
Qed.

End Arithmetical_dec.

(** * Derivability of the Archimedean axiom *)

(** This is a standard proof (it has been taken from PlanetMath). It is
formulated negatively so as to avoid the need for classical
logic. Using a proof of [{n | ~P n}+{forall n, P n}], we can in
principle also derive [up] and its specification. The proof above
cannot be used for that purpose, since it relies on the [archimed] axiom. *)

Theorem not_not_archimedean :
  forall r : R, ~ (forall n : nat, (INR n <= r)%R).
Proof.
intros r H.
set (E := fun r => exists n : nat, r = INR n).
assert (exists x : R, E x) by
  (exists 0%R; simpl; red; exists 0%nat; reflexivity).
assert (bound E) by (exists r; intros x (m,H2); rewrite H2; apply H).
destruct (completeness E) as (M,(H3,H4)); try assumption.
set (M' := (M + -1)%R).
assert (H2 : ~ is_upper_bound E M'). {
  intro H5.
  assert (M <= M')%R by (apply H4; exact H5).
  apply (Rlt_not_le M M'). {
    unfold M'.
    pattern M at 2.
    rewrite <- Rplus_0_l.
    pattern (0 + M)%R.
    rewrite Rplus_comm.
    rewrite <- (Rplus_opp_r 1).
    apply Rplus_lt_compat_l.
    rewrite Rplus_comm.
    apply Rplus_pos_gt, Rlt_0_1.
  }
  assumption.
}
apply H2.
intros N (n,H7).
rewrite H7.
unfold M'.
assert (H5 : (INR (S n) <= M)%R) by (apply H3; exists (S n); reflexivity).
rewrite S_INR in H5.
assert (H6 : (INR n + 1 + -1 <= M + -1)%R). {
  apply Rplus_le_compat_r.
  assumption.
}
rewrite Rplus_assoc in H6.
rewrite Rplus_opp_r in H6.
rewrite (Rplus_comm (INR n) 0) in H6.
rewrite Rplus_0_l in H6.
assumption.
Qed.

(** * Decidability of negated formulas *)

Lemma sig_not_dec : forall P : Prop, {not (not P)} + {not P}.
Proof.
intros P.
set (E := fun x => x = R0 \/ (x = R1 /\ P)).
destruct (completeness E) as [x H].
- exists R1.
  intros x [->|[-> _]].
  + apply Rle_0_1.
  + apply Rle_refl.
- exists R0.
  now left.
- destruct (Rle_lt_dec 1 x) as [H'|H'].
  + left.
    intros HP.
    elim Rle_not_lt with (1 := H').
    apply Rle_lt_trans with (2 := Rlt_0_1).
    apply H.
    intros y [->|[_ Hy]].
    * apply Rle_refl.
    * now elim HP.
  + right.
    intros HP.
    apply Rlt_not_le with (1 := H').
    apply H.
    right.
    now split.
Qed.
