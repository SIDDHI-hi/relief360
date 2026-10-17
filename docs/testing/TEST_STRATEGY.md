# RELIEF360 — Master Test Strategy

**Author:** Rishikesh (Test Data & QA Lead)  
**Reviewed By:** Siddhi (Project Lead & Integration Owner)  
**Status:** Planned / Baseline Strategy (Phase 0)  

---

## 1. Overview & Objectives

The **RELIEF360** test strategy outlines the verification framework for all batch processing components, including DFSORT deduplication, JCL conditional flow control, COBOL algorithmic scoring, two-way payment reconciliation, Db2 persistence, and restart recovery.

The primary objective is to guarantee 100% deterministic, error-tolerant execution across standard allocations, edge-case financial discrepancies, and abnormal system terminations.

---

## 2. Planned Test Dimensions

The testing lifecycle is structured around twelve foundational scenarios:

### 1. Valid Application (Happy Path)
- **Objective:** Verify end-to-end processing of a verified, complete, unique application with valid banking credentials.
- **Expected Outcome:** Application scores correctly, aid approved within cap, Db2 records inserted, payment matched, return code `RC=0000`.

### 2. Unverified Application
- **Objective:** Verify that applications with `STATUS != 'VERIFIED'` or incomplete documents are rejected before eligibility scoring.
- **Expected Outcome:** Record routed to exception dataset with code `NOT_VERIFIED`; no Db2 payment record created.

### 3. Duplicate Application
- **Objective:** Validate DFSORT primary key deduplication and COBOL secondary household cross-check.
- **Expected Outcome:** Duplicate application suppressed or routed to exception file with code `DUPLICATE`; only one instance proceeds.

### 4. Invalid Bank Credentials
- **Objective:** Ingest records with non-numeric bank routing numbers or malformed account strings.
- **Expected Outcome:** Flagged during `AT01VAL` processing; routed to exception dataset with code `BANK_INVALID`.

### 5. Over-Cap Requested Amount
- **Objective:** Ingest an application requesting aid exceeding the statutory cap.
- **Expected Outcome:** `AT02ELIG` clamps approved aid to configured ceiling; audit record logged with code `OVER_CAP`.

### 6. Payment Exact Match
- **Objective:** Process approved application against external bank feed with matching Application ID and identical disbursement amount.
- **Expected Outcome:** Reconciled successfully; status updated to `'MATCHED'`; logged in reconciliation summary report.

### 7. Payment Missing
- **Objective:** Approved application present in batch master, but no corresponding transaction exists in bank payment file.
- **Expected Outcome:** Identified by sequential two-file matching in `AT04REC`; flagged as `PAYMENT_MISSING` in reconciliation report.

### 8. Payment Amount Mismatch
- **Objective:** Approved amount in application record differs from amount reported in bank payment feed (e.g., partial disbursement or fee deduction).
- **Expected Outcome:** Flagged as `PAYMENT_MISMATCH` with differential variance logged; routed to discrepancy review file.

### 9. Complaint Pending
- **Objective:** Application holds an open, unresolved dispute in the `COMPLAINT` table.
- **Expected Outcome:** Processing held; exception code `COMPLAINT_PENDING` generated; funds withheld until resolved.

### 10. High-Priority Allocation
- **Objective:** Application with severe damage (100), high vulnerability (90), and critical urgency (95).
- **Expected Outcome:** Priority score calculates to $0.50(100) + 0.30(90) + 0.20(95) = 96.0$; classified as `CRITICAL`; placed in top disbursement tranche.

### 11. JCL Pipeline Failure & Quality Gate Check
- **Objective:** Inject an input file where record count differs from control trailer, or induce `RC=0008` in validation step.
- **Expected Outcome:** JCL conditional logic (`COND` / `IF-THEN-ELSE`) traps error; subsequent calculation steps bypass execution; system halts cleanly.

### 12. Restart & Recovery Scenario
- **Objective:** Simulate a mid-stream step abend (e.g., synthetic `S0C7`), trigger `RRESTART`, and resume batch from checkpoint.
- **Expected Outcome:** REXX restart utility identifies checkpoint in `BATCH_RUN`; job resumes at failed step without re-allocating or duplicating payments.

---

## 3. Test Environment & Tooling

- **Host Platform:** IBM z/OS (College Mainframe Environment)
- **Local Tooling:** Antigravity IDE, Git, VS Code Zowe Explorer
- **Test Datasets:** Synthetic fixed-width sequential files in `testdata/input/`
- **Output Inspection:** JES Spool / SDSF, Db2 queries via SPUFI/Batch SQL, formatted reports in `testdata/expected/`
