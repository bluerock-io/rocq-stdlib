(lang dune 3.8)
(name rocq-stdlib)

; We use directory targets in documentation
(using directory-targets 0.1)

(using coq 0.8)

(formatting
 (enabled_for ocaml))

(generate_opam_files true)

(license LGPL-2.1-only)
(maintainers "The Rocq standard library development team")
(authors "The Rocq development team, INRIA, CNRS, and contributors")
; This generates bug-reports and dev-repo
(source (github coq/stdlib))
(homepage https://coq.inria.fr/)
(documentation "https://coq.github.io/doc/")
(version dev)

(package
 (name rocq-stdlib)
 (depends
  rocq-runtime
  (rocq-core (= :version)))
 (synopsis "The Rocq Proof Assistant -- Standard Library")
 (description "Rocq is a formal proof management system. It provides
a formal language to write mathematical definitions, executable
algorithms and theorems together with an environment for
semi-interactive development of machine-checked proofs.

Typical applications include the certification of properties of
programming languages (e.g. the CompCert compiler certification
project, or the Bedrock verified low-level programming library), the
formalization of mathematics (e.g. the full formalization of the
Feit-Thompson theorem or homotopy type theory) and teaching.

This package includes the Rocq Standard Library, that is to say, the
set of modules usually bound to the Stdlib.* namespace."))

(package
 (name coq-stdlib)
 (allow_empty)
 (depends
  coq-core
  (rocq-stdlib (= :version)))
 (synopsis "Compatibility metapackage for Coq Stdlib library after the Rocq renaming"))

(package
 (name rocq-stdlib-doc)
 (allow_empty)
 (license "OPUBL-1.0")
 (depends
  (conf-python-3 :build)
  (rocq (and :build (= :version))))
 (synopsis "The Rocq Proof Assistant Standard Library --- Reference Manual")
 (description "Rocq is a formal proof management system. It provides
a formal language to write mathematical definitions, executable
algorithms and theorems together with an environment for
semi-interactive development of machine-checked proofs.

This package provides the Reference Manual for the Standard Library."))
