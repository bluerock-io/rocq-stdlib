(************************************************************************)
(*         *      The Rocq Prover / The Rocq Development Team           *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)
(*                                                                      *)
(* Micromega: A reflexive tactic using the Positivstellensatz           *)
(*                                                                      *)
(*  Frédéric Besson (Irisa/Inria)                                       *)
(*                                                                      *)
(************************************************************************)

From Stdlib Require Import OrderedRing.
From Stdlib Require Import RingMicromega.
From Stdlib Require Import Refl.
From Stdlib Require Import QArith_base.
From Stdlib Require Import Qfield.

Lemma Qsor : SOR 0 1 Qplus Qmult Qminus Qopp Qeq  Qle Qlt.
Proof.
  constructor; intros ; subst ; try (intuition (subst; auto with qarith)).
  - apply Q_Setoid.
  - rewrite H ; rewrite H0 ; reflexivity.
  - rewrite H ; rewrite H0 ; reflexivity.
  - rewrite H ; auto ; reflexivity.
  - rewrite <- H ; rewrite <- H0 ; auto.
  - rewrite H ; rewrite H0 ; auto.
  - rewrite <- H ; rewrite <- H0 ; auto.
  - rewrite H ; rewrite  H0 ; auto.
  - apply Qsrt.
  - eapply Qle_trans ; eauto.
  - apply (Qlt_not_eq n m H H0) ; auto.
  - destruct(Q_dec n m) as [[H1 |H1] | H1 ] ; tauto.
  - apply (Qplus_le_compat  p p n m  (Qle_refl p) H).
  - generalize (Qmult_lt_compat_r 0 n m H0 H).
    rewrite Qmult_0_l.
    auto.
  - compute in H.
    discriminate.
Qed.


Lemma QSORaddon :
  SORaddon 0 1 Qplus Qmult Qminus Qopp  Qeq  Qle (* ring elements *)
  0 1 Qplus Qmult Qminus Qopp (* coefficients *)
  Qeq_bool Qle_bool
  (fun x => x) (fun x => x) (pow_N 1 Qmult).
Proof.
  constructor.
  - constructor ; intros ; try reflexivity.
    apply Qeq_bool_eq; auto.
  - constructor.
    reflexivity.
  - intros x y.
    apply Qeq_bool_neq ; auto.
  - apply Qle_bool_imp_le.
Qed.


(*Definition Zeval_expr :=  eval_pexpr 0 Z.add Z.mul Z.sub Z.opp  (fun x => x) (fun x => Z.of_N x) (Z.pow).*)
From Stdlib Require Import EnvRing.

Fixpoint Qeval_expr (env: PolEnv Q) (e: PExpr Q) : Q :=
  match e with
    | PEc c =>  c
    | PEX j =>  env j
    | PEadd pe1 pe2 => (Qeval_expr env pe1) + (Qeval_expr env pe2)
    | PEsub pe1 pe2 => (Qeval_expr env pe1) - (Qeval_expr env pe2)
    | PEmul pe1 pe2 => (Qeval_expr env pe1) * (Qeval_expr env pe2)
    | PEopp pe1 => - (Qeval_expr env pe1)
    | PEpow pe1 n => Qpower (Qeval_expr env pe1)  (Z.of_N n)
  end.

Lemma Qeval_expr_simpl : forall env e,
  Qeval_expr env e =
  match e with
    | PEc c =>  c
    | PEX j =>  env j
    | PEadd pe1 pe2 => (Qeval_expr env pe1) + (Qeval_expr env pe2)
    | PEsub pe1 pe2 => (Qeval_expr env pe1) - (Qeval_expr env pe2)
    | PEmul pe1 pe2 => (Qeval_expr env pe1) * (Qeval_expr env pe2)
    | PEopp pe1 => - (Qeval_expr env pe1)
    | PEpow pe1 n => Qpower (Qeval_expr env pe1)  (Z.of_N n)
  end.
Proof.
  destruct e ; reflexivity.
Qed.

Definition Qeval_expr' := eval_pexpr  Qplus Qmult Qminus Qopp (fun x => x) (fun x => x) (pow_N 1 Qmult).

Lemma QNpower : forall r n, r ^ Z.of_N n = pow_N 1 Qmult r n.
Proof.
  destruct n ; reflexivity.
Qed.


Lemma Qeval_expr_compat : forall env e, Qeval_expr env e = Qeval_expr' env e.
Proof.
  induction e ; simpl ; subst ; try congruence.
  - reflexivity.
  - rewrite IHe.
    apply QNpower.
Qed.

Definition Qeval_pop2 (o : Op2) : Q -> Q -> Prop :=
match o with
| OpEq =>  Qeq
| OpNEq => fun x y  => ~ x == y
| OpLe => Qle
| OpGe => fun x y => Qle y x
| OpLt => Qlt
| OpGt => fun x y => Qlt y x
end.


Definition Qlt_bool (x y : Q) :=
  (Qnum x * QDen y <? Qnum y * QDen x)%Z.

Definition Qeval_bop2 (o : Op2) : Q -> Q -> bool :=
  match o with
  | OpEq  => Qeq_bool
  | OpNEq => fun x y => negb (Qeq_bool x y)
  | OpLe  => Qle_bool
  | OpGe  => fun x y => Qle_bool y x
  | OpLt  => Qlt_bool
  | OpGt  => fun x y => Qlt_bool y x
  end.

Lemma Qlt_bool_iff : forall q1 q2,
    Qlt_bool q1 q2 = true <-> q1 < q2.
Proof.
  unfold Qlt_bool.
  unfold Qlt. intros.
  apply Z.ltb_lt.
Qed.

Lemma pop2_bop2 :
  forall (op : Op2) (q1 q2 : Q), is_true (Qeval_bop2 op q1 q2) <-> Qeval_pop2 op q1 q2.
Proof.
  unfold is_true.
  destruct op ; simpl; intros.
  - apply Qeq_bool_iff.
  - rewrite <- Qeq_bool_iff.
    rewrite negb_true_iff.
    destruct (Qeq_bool q1 q2) ; intuition congruence.
  - apply Qle_bool_iff.
  - apply Qle_bool_iff.
  - apply Qlt_bool_iff.
  - apply Qlt_bool_iff.
Qed.

Definition Qeval_op2 (k:Tauto.kind) :  Op2 ->  Q -> Q -> Tauto.rtyp k:=
  if k as k0 return (Op2 -> Q -> Q -> Tauto.rtyp k0)
  then Qeval_pop2 else Qeval_bop2.


Lemma Qeval_op2_hold : forall k op q1 q2,
    Tauto.hold k (Qeval_op2 k op q1 q2) <-> Qeval_pop2 op q1 q2.
Proof.
  destruct k.
  - simpl ; tauto.
  - simpl. apply pop2_bop2.
Qed.

Definition Qeval_formula (e:PolEnv Q) (k: Tauto.kind) (ff : Formula Q) :=
  let (lhs,o,rhs) := ff in Qeval_op2 k o (Qeval_expr e lhs) (Qeval_expr e rhs).

Definition Qeval_formula' :=
  eval_formula  Qplus Qmult Qminus Qopp Qeq Qle Qlt (fun x => x) (fun x => x) (pow_N 1 Qmult).

 Lemma Qeval_formula_compat : forall env b f, Tauto.hold b (Qeval_formula env b f) <-> Qeval_formula' env f.
Proof.
  intros.
  unfold Qeval_formula.
  destruct f.
  repeat rewrite Qeval_expr_compat.
  unfold Qeval_formula'.
  unfold Qeval_expr'.
  simpl.
  rewrite Qeval_op2_hold.
  split ; destruct Fop ; simpl; auto.
Qed.


Definition Qeval_nformula :=
  eval_nformula 0 Qplus Qmult  Qeq Qle Qlt (fun x => x) .

Definition Qeval_op1 (o : Op1) : Q -> Prop :=
match o with
| Equal => fun x : Q => x == 0
| NonEqual => fun x : Q => ~ x == 0
| Strict => fun x : Q => 0 < x
| NonStrict => fun x : Q => 0 <= x
end.


Lemma Qeval_nformula_dec : forall env d, (Qeval_nformula env d) \/ ~ (Qeval_nformula env d).
Proof.
  exact (fun env d =>eval_nformula_dec Qsor (fun x => x)  env d).
Qed.

Definition QWitness := Psatz Q.

Register QWitness as micromega.QWitness.type.


Definition QWeakChecker := check_normalised_formulas 0 1 Qplus Qmult Qeq_bool Qle_bool.

From Stdlib Require Import List.

Lemma QWeakChecker_sound :   forall (l : list (NFormula Q)) (cm : QWitness),
  QWeakChecker l cm = true ->
  forall env, make_impl (Qeval_nformula env) l False.
Proof.
  intros l cm H.
  intro.
  unfold Qeval_nformula.
  apply (checker_nf_sound Qsor QSORaddon l cm).
  unfold QWeakChecker in H.
  exact H.
Qed.

From Stdlib.micromega Require Import Tauto.

Definition Qnormalise := @cnf_normalise Q 0 1 Qplus Qmult Qminus Qopp Qeq_bool Qle_bool.

Definition Qnegate := @cnf_negate Q 0 1 Qplus Qmult Qminus Qopp Qeq_bool Qle_bool.

Definition qunsat := check_inconsistent 0 Qeq_bool Qle_bool.

Definition qdeduce := nformula_plus_nformula 0 Qplus Qeq_bool.

Definition normQ  := norm 0 1 Qplus Qmult Qminus Qopp Qeq_bool.
Declare Equivalent Keys normQ RingMicromega.norm.

Definition cnfQ (Annot:Type) (TX: Tauto.kind -> Type)  (AF: Type) (k: Tauto.kind) (f: TFormula (Formula Q) Annot TX AF k) :=
  rxcnf qunsat qdeduce (Qnormalise Annot) (Qnegate Annot) true f.

Definition QTautoChecker  (f : BFormula (Formula Q) Tauto.isProp) (w: list QWitness)  : bool :=
  @tauto_checker (Formula Q) (NFormula Q) unit
  qunsat qdeduce
  (Qnormalise unit)
  (Qnegate unit) QWitness (fun cl => QWeakChecker (List.map fst cl)) f w.



Lemma QTautoChecker_sound : forall f w, QTautoChecker f w = true -> forall env, eval_bf  (Qeval_formula env)  f.
Proof.
  intros f w.
  unfold QTautoChecker.
  apply tauto_checker_sound  with (eval:= Qeval_formula) (eval':= Qeval_nformula).
  - apply Qeval_nformula_dec.
  - intros until env.
    unfold eval_nformula. unfold RingMicromega.eval_nformula.
    destruct t.
    apply (check_inconsistent_sound Qsor QSORaddon) ; auto.
  - unfold qdeduce. intros. revert H. apply (nformula_plus_nformula_correct Qsor QSORaddon);auto.
  - intros.
    rewrite Qeval_formula_compat.
    eapply (cnf_normalise_correct Qsor QSORaddon)  ; eauto.
  - intros. rewrite Tauto.hold_eNOT. rewrite Qeval_formula_compat.
    now eapply (cnf_negate_correct Qsor QSORaddon);eauto.
  - intros t w0.
    unfold eval_tt.
    intros.
    rewrite make_impl_map with (eval := Qeval_nformula env).
    + eapply QWeakChecker_sound; eauto.
    + tauto.
Qed.
