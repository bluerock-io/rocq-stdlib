(************************************************************************)
(*         *      The Rocq Prover / The Rocq Development Team           *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

From Stdlib Require Export FunInd.
From Stdlib Require Import PeanoNat.
From Stdlib Require Compare_dec.
From Stdlib Require Wf_nat.

Section Iter.
Variable A : Type.

Fixpoint iter (n : nat) : (A -> A) -> A -> A :=
  fun (fl : A -> A) (def : A) =>
  match n with
  | O => def
  | S m => fl (iter m fl def)
  end.
End Iter.

Theorem le_lt_SS x y : x <= y -> x < S (S y).
Proof.
 intros. now apply Nat.lt_succ_r, Nat.le_le_succ_r.
Qed.

Theorem Splus_lt x y : y < S (x + y).
Proof.
 apply Nat.lt_succ_r. apply Nat.le_add_l.
Qed.

Theorem SSplus_lt x y : x < S (S (x + y)).
Proof.
 apply le_lt_SS, Nat.le_add_r.
Qed.

Inductive max_type (m n:nat) : Set :=
  cmt : forall v, m <= v -> n <= v -> max_type m n.

Definition max m n : max_type m n.
Proof.
 destruct (Compare_dec.le_gt_dec m n) as [h|h].
 - exists n; [exact h | apply le_n].
 - exists m; [apply le_n | apply Nat.lt_le_incl; exact h].
Defined.

Definition Acc_intro_generator_function := fun A R => @Acc_intro_generator A R 100.
