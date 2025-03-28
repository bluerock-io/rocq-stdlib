From Stdlib Require Import ZArith Nnat Lia.
Open Scope Z_scope.

(** Test of the zify preprocessor for (R)Omega *)
(* Starting from Coq 8.9 (late 2018), `romega` tactics are deprecated.
   The tests in this file remain but now call the `lia` tactic. *)

(* More details in file PreOmega.v
*)

(* zify_op *)

Goal forall a:Z, Z.max a a = a.
intros.
lia.
Qed.

Goal forall a b:Z, Z.max a b = Z.max b a.
intros.
lia.
Qed.

Goal forall a b c:Z, Z.max a (Z.max b c) = Z.max (Z.max a b) c.
intros.
lia.
Qed.

Goal forall a b:Z, Z.max a b + Z.min a b = a + b.
intros.
lia.
Qed.

Goal forall a:Z, (Z.abs a)*(Z.sgn a) = a.
intros.
intuition; subst; lia.
Qed.

Goal forall a:Z, Z.abs a = a -> a >= 0.
intros.
lia.
Qed.

Goal forall a:Z, Z.sgn a = a -> a = 1 \/ a = 0 \/ a = -1.
intros.
lia.
Qed.

(* zify_nat *)

Goal forall m: nat, (m<2)%nat -> (0<= m+m <=2)%nat.
intros.
lia.
Qed.

Goal forall m:nat, (m<1)%nat -> (m=0)%nat.
intros.
lia.
Qed.

Goal forall m: nat, (m<=100)%nat -> (0<= m+m <=200)%nat.
intros.
lia.
Qed.
(* 2000 instead of 200: works, but quite slow *)

Goal forall m: nat, (m*m>=0)%nat.
intros.
lia.
Qed.

(* zify_positive *)

Goal forall m: positive, (m<2)%positive -> (2 <= m+m /\ m+m <= 2)%positive.
intros.
lia.
Qed.

Goal forall m:positive, (m<2)%positive -> (m=1)%positive.
intros.
lia.
Qed.

Goal forall m: positive, (m<=1000)%positive -> (2<=m+m/\m+m <=2000)%positive.
intros.
lia.
Qed.

Goal forall m: positive, (m*m>=1)%positive.
intros.
lia.
Qed.

(* zify_N *)

Goal forall m:N, (m<2)%N -> (0 <= m+m /\ m+m <= 2)%N.
intros.
lia.
Qed.

Goal forall m:N, (m<1)%N -> (m=0)%N.
intros.
lia.
Qed.

Goal forall m:N, (m<=1000)%N -> (0<=m+m/\m+m <=2000)%N.
intros.
lia.
Qed.

Goal forall m:N, (m*m>=0)%N.
intros.
lia.
Qed.

(* mix of datatypes *)

Goal forall p, Z.of_N (N.of_nat (N.to_nat (Npos p))) = Zpos p.
intros.
lia.
Qed.
