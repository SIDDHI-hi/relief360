# RELIEF360 — Master Batch Pipeline & Orchestration JCL

This directory contains master pipeline orchestration streams and overarching batch controllers:

- **`RELIEF360.jcl`:** End-to-end master job running all pipeline steps sequentially with condition-code safeguards (`COND=(4,LT)`).
- **`AUDIT.jcl`:** Standalone audit finalization and checkpoint persistence job.
- **`MONITOR.jcl`:** Batch TSO job invoking REXX monitoring utilities via `IKJEFT01`.
