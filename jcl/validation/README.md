# RELIEF360 — Validation JCL

This directory contains JCL jobs responsible for pre-processing quality gates and deep COBOL validation:

- **`VALCNT.jcl`:** JCL copy and count validation quality gate (Assignment #4 integration).
- **`VALID.jcl`:** Job invoking COBOL program `AT01VAL` for schema, ID, and bank credential validation.
