# RELIEF360 — System Architecture

**Lead Architect:** Siddhi  
**Document Status:** Baseline Architecture (Phase 0)  

---

## 1. Architectural Philosophy & Mainframe Principles

RELIEF360 is engineered according to core mainframe architectural tenets:
1. **Decoupled Sequential Pipeline:** Batch steps run sequentially with clean data handoffs via datasets or Generation Data Groups (GDGs).
2. **Defensive Processing:** Fail fast at the ingestion boundaries using DFSORT deduplication and JCL record-count validation before invoking COBOL engines.
3. **Decimal Precision:** All financial amounts are processed using COBOL packed-decimal arithmetic (`COMP-3`), preventing binary floating-point rounding errors.
4. **Restartability:** Every execution step is either idempotent or checkpointed in Db2 `BATCH_RUN`, ensuring safe resumption upon abend.

---

## 2. High-Level Data Flow Diagram

```
[ Beneficiary Applications (PS/GDG) ]      [ Bank Transaction File (PS/GDG) ]
                 │                                         │
                 ▼                                         │
+---------------------------------+                        │
| STEP 01: PREP-APP (DFSORT)      |                        │
| - Primary key sort              |                        │
| - SUM FIELDS=NONE (dedup)       |                        │
+----------------┬----------------+                        │
                 │                                         │
                 ▼                                         │
+---------------------------------+                        │
| STEP 02: VALIDATE-COUNT (JCL)   |                        │
| - Verify control count          |                        │
| - Quality Gate (RC <= 4)        |                        │
+----------------┬----------------+                        │
                 │                                         │
                 ▼                                         │
+---------------------------------+                        │
| STEP 03: AT01VAL (COBOL)        |                        │
| - Schema & identity validation  |                        │
| - Bank routing validation       |                        │
+--------┬------------------------+                        │
         │ (Invalid records) ──> [ Exception Log ]         │
         │ (Valid records)                                 │
         ▼                                                 │
+---------------------------------+                        │
| STEP 04: AT02ELIG (COBOL)       |                        │
| - 3-factor priority formula     |                        │
| - Statutory aid cap enforcement |                        │
| - Priority band classification  |                        │
+--------┬------------------------+                        │
         │ (Approved allocations)                          │
         ▼                                                 ▼
+----------------------------------------------------------+
| STEP 05: AT04REC (COBOL Two-Way Reconciliation Engine)   |
| - Sequential match between approved allocations & bank   |
| - Classify: MATCHED, MISMATCH, MISSING                   |
+--------┬-------------------------------------------------+
         │
         ▼
+---------------------------------+
| STEP 06: AT05OPS (Db2 / Audit)  |
| - Update Db2 tables             |
| - Log append-only audit trail   |
| - Checkpoint BATCH_RUN status   |
+--------┬------------------------+
         │
         ▼
+---------------------------------+
| STEP 07: AT06RPT (Reporting)    |
| - Executive summary report      |
| - Reconciliation balance sheet  |
| - Exception resolution manifest |
+--------┬------------------------+
         │
         ▼
+---------------------------------+
| STEP 08: REXX MONITORING        |
| - RMONITOR & RSTATUS execution  |
| - Return code verification      |
+---------------------------------+
```
