(************************************************************************)
(*         *      The Rocq Prover / The Rocq Development Team           *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

From Stdlib Require Import ZAxioms ZMulOrder GenericMinMax.

(** * Properties of minimum and maximum specific to integer numbers *)

Module Type ZMaxMinProp (Import Z : ZAxiomsMiniSig').
Include ZMulOrderProp Z.

(** The following results are concrete instances of [max_monotone]
    and similar lemmas. *)

(** Succ *)

Lemma succ_max_distr n m : S (max n m) == max (S n) (S m).
Proof.
 destruct (le_ge_cases n m);
  [rewrite 2 max_r | rewrite 2 max_l]; now rewrite <- ?succ_le_mono.
Qed.

Lemma succ_min_distr n m : S (min n m) == min (S n) (S m).
Proof.
 destruct (le_ge_cases n m);
  [rewrite 2 min_l | rewrite 2 min_r]; now rewrite <- ?succ_le_mono.
Qed.

(** Pred *)

Lemma pred_max_distr n m : P (max n m) == max (P n) (P m).
Proof.
 destruct (le_ge_cases n m);
  [rewrite 2 max_r | rewrite 2 max_l]; now rewrite <- ?pred_le_mono.
Qed.

Lemma pred_min_distr n m : P (min n m) == min (P n) (P m).
Proof.
 destruct (le_ge_cases n m);
  [rewrite 2 min_l | rewrite 2 min_r]; now rewrite <- ?pred_le_mono.
Qed.

(** Add *)

Lemma add_max_distr_l n m p : max (p + n) (p + m) == p + max n m.
Proof.
 destruct (le_ge_cases n m);
  [rewrite 2 max_r | rewrite 2 max_l]; now rewrite <- ?add_le_mono_l.
Qed.

Lemma add_max_distr_r n m p : max (n + p) (m + p) == max n m + p.
Proof.
 destruct (le_ge_cases n m);
  [rewrite 2 max_r | rewrite 2 max_l]; now rewrite <- ?add_le_mono_r.
Qed.

Lemma add_min_distr_l n m p : min (p + n) (p + m) == p + min n m.
Proof.
 destruct (le_ge_cases n m);
  [rewrite 2 min_l | rewrite 2 min_r]; now rewrite <- ?add_le_mono_l.
Qed.

Lemma add_min_distr_r n m p : min (n + p) (m + p) == min n m + p.
Proof.
 destruct (le_ge_cases n m);
  [rewrite 2 min_l | rewrite 2 min_r]; now rewrite <- ?add_le_mono_r.
Qed.

(** Opp *)

Lemma opp_max_distr n m : -(max n m) == min (-n) (-m).
Proof.
 destruct (le_ge_cases n m).
 - rewrite max_r by trivial. symmetry. apply min_r. now rewrite <- opp_le_mono.
 - rewrite max_l by trivial. symmetry. apply min_l. now rewrite <- opp_le_mono.
Qed.

Lemma opp_min_distr n m : -(min n m) == max (-n) (-m).
Proof.
 destruct (le_ge_cases n m).
 - rewrite min_l by trivial. symmetry. apply max_l. now rewrite <- opp_le_mono.
 - rewrite min_r by trivial. symmetry. apply max_r. now rewrite <- opp_le_mono.
Qed.

(** Sub *)

Lemma sub_max_distr_l n m p : max (p - n) (p - m) == p - min n m.
Proof.
 destruct (le_ge_cases n m).
 - rewrite min_l by trivial. apply max_l. now rewrite <- sub_le_mono_l.
 - rewrite min_r by trivial. apply max_r. now rewrite <- sub_le_mono_l.
Qed.

Lemma sub_max_distr_r n m p : max (n - p) (m - p) == max n m - p.
Proof.
 destruct (le_ge_cases n m);
  [rewrite 2 max_r | rewrite 2 max_l]; try order; now apply sub_le_mono_r.
Qed.

Lemma sub_min_distr_l n m p : min (p - n) (p - m) == p - max n m.
Proof.
 destruct (le_ge_cases n m).
 - rewrite max_r by trivial. apply min_r. now rewrite <- sub_le_mono_l.
 - rewrite max_l by trivial. apply min_l. now rewrite <- sub_le_mono_l.
Qed.

Lemma sub_min_distr_r n m p : min (n - p) (m - p) == min n m - p.
Proof.
 destruct (le_ge_cases n m);
  [rewrite 2 min_l | rewrite 2 min_r]; try order; now apply sub_le_mono_r.
Qed.

(** Mul *)

Lemma mul_max_distr_nonneg_l n m p : 0 <= p ->
 max (p * n) (p * m) == p * max n m.
Proof.
 intros. destruct (le_ge_cases n m);
  [rewrite 2 max_r | rewrite 2 max_l]; try order; now apply mul_le_mono_nonneg_l.
Qed.

Lemma mul_max_distr_nonneg_r n m p : 0 <= p ->
 max (n * p) (m * p) == max n m * p.
Proof.
 intros. destruct (le_ge_cases n m);
  [rewrite 2 max_r | rewrite 2 max_l]; try order; now apply mul_le_mono_nonneg_r.
Qed.

Lemma mul_min_distr_nonneg_l n m p : 0 <= p ->
 min (p * n) (p * m) == p * min n m.
Proof.
 intros. destruct (le_ge_cases n m);
  [rewrite 2 min_l | rewrite 2 min_r]; try order; now apply mul_le_mono_nonneg_l.
Qed.

Lemma mul_min_distr_nonneg_r n m p : 0 <= p ->
 min (n * p) (m * p) == min n m * p.
Proof.
 intros. destruct (le_ge_cases n m);
  [rewrite 2 min_l | rewrite 2 min_r]; try order; now apply mul_le_mono_nonneg_r.
Qed.

Lemma mul_max_distr_nonpos_l n m p : p <= 0 ->
 max (p * n) (p * m) == p * min n m.
Proof.
 intros. destruct (le_ge_cases n m).
 - rewrite min_l by trivial. rewrite max_l by now apply mul_le_mono_nonpos_l. reflexivity.
 - rewrite min_r by trivial. rewrite max_r by now apply mul_le_mono_nonpos_l. reflexivity.
Qed.

Lemma mul_max_distr_nonpos_r n m p : p <= 0 ->
 max (n * p) (m * p) == min n m * p.
Proof.
 intros. destruct (le_ge_cases n m).
 - rewrite min_l by trivial. rewrite max_l by now apply mul_le_mono_nonpos_r. reflexivity.
 - rewrite min_r by trivial. rewrite max_r by now apply mul_le_mono_nonpos_r. reflexivity.
Qed.

Lemma mul_min_distr_nonpos_l n m p : p <= 0 ->
 min (p * n) (p * m) == p * max n m.
Proof.
 intros. destruct (le_ge_cases n m).
 - rewrite max_r by trivial. rewrite min_r by now apply mul_le_mono_nonpos_l. reflexivity.
 - rewrite max_l by trivial. rewrite min_l by now apply mul_le_mono_nonpos_l. reflexivity.
Qed.

Lemma mul_min_distr_nonpos_r n m p : p <= 0 ->
 min (n * p) (m * p) == max n m * p.
Proof.
 intros. destruct (le_ge_cases n m).
 - rewrite max_r by trivial. rewrite min_r by now apply mul_le_mono_nonpos_r. reflexivity.
 - rewrite max_l by trivial. rewrite min_l by now apply mul_le_mono_nonpos_r. reflexivity.
Qed.

End ZMaxMinProp.
