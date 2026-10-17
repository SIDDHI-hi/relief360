# RELIEF360 — Master Test Case Catalog

**Lead QA Engineer:** Rishikesh  
**Integration Lead:** Siddhi  
**Baseline Status:** Planned (Phase 0 — Not Started)  

The following matrix documents the baseline test cases planned for RELIEF360. All test statuses are strictly **Planned / Not Started** pending implementation on the z/OS host environment.

---

## Master Test Matrix

| Test ID | Input | Expected Result | Component | Status |
| :---: | :--- | :--- | :--- | :---: |
| **TC-01** | Valid application record: verified status, damage=70, vuln=60, urgency=50, valid bank details, amount <= cap | Processed successfully; score=63.0 (HIGH); Db2 updated; return code RC=0000 | `AT01VAL`, `AT02ELIG`, JCL `VALID` | Planned |
| **TC-02** | Application with `STATUS = 'PENDING'` or incomplete verification flag | Rejected at intake validation; routed to exception dataset with code `NOT_VERIFIED` | `AT01VAL` | Planned |
| **TC-03** | Two identical application records sharing the same National ID / Household Key | First record ingested; second record eliminated by DFSORT or flagged as `DUPLICATE` in `AT03DUP` | `PREPAPP`, `AT03DUP` | Planned |
| **TC-04** | Application with alphabetic routing number or malformed bank account number | Validation fails; record written to exception file with reason code `BANK_INVALID` | `AT01VAL` | Planned |
| **TC-05** | Application with requested amount $12,500 where configured cap is $10,000 | Approved amount adjusted to $10,000 cap; warning/audit entry generated with code `OVER_CAP` | `AT02ELIG` | Planned |
| **TC-06** | Approved allocation of $5,000 paired with bank transaction file showing $5,000 payment | Reconciliation status marked `MATCHED`; audit log recorded; zero discrepancy balance | `AT04REC`, JCL `RECON` | Planned |
| **TC-07** | Approved allocation of $7,500 with no corresponding entry in bank payment file | Reconciliation flags record as `PAYMENT_MISSING`; routed to missing disbursement report | `AT04REC` | Planned |
| **TC-08** | Approved allocation of $6,000 paired with bank transaction file showing $4,500 payment | Reconciliation flags record as `PAYMENT_MISMATCH`; variance of $1,500 logged to exception file | `AT04REC` | Planned |
| **TC-09** | Application associated with an active, unresolved record in `COMPLAINT` table | Application disbursement placed on administrative hold; exception code `COMPLAINT_PENDING` | `AT01VAL`, `AT02ELIG` | Planned |
| **TC-10** | High-severity disaster record: damage=100, vuln=90, urgency=95 | Priority score=96.0; assigned to priority band `CRITICAL`; expedited tranche output | `AT02ELIG` | Planned |
| **TC-11** | Intake file with record count mismatch between data records and control trailer card | JCL quality gate traps discrepancy in `VALCNT`; batch stream aborts prior to business logic | JCL `VALCNT`, `VALIDATE-COUNT` | Planned |
| **TC-12** | Forced abend in `ELIG` step; execution of `RRESTART` followed by resubmission | Checkpoint detected in `BATCH_RUN`; job resumes at `ELIG` without duplicating prior steps | REXX `RRESTART`, JCL `master` | Planned |
