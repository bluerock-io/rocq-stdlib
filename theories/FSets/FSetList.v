(************************************************************************)
(*         *      The Rocq Prover / The Rocq Development Team           *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

(** * Finite sets library *)

(** This file proposes an implementation of the non-dependent
    interface [FSetInterface.S] using strictly ordered list. *)

From Stdlib Require Export FSetInterface.
Set Implicit Arguments.
Unset Strict Implicit.

(** This is just a compatibility layer, the real implementation
    is now in [MSetList] *)

From Stdlib Require FSetCompat MSetList Orders OrdersAlt.

Module Make (X: OrderedType) <: S with Module E := X.
 Module X' := OrdersAlt.Update_OT X.
 Module MSet := MSetList.Make X'.
 Include FSetCompat.Backport_Sets X MSet.
End Make.
