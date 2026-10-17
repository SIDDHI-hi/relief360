# RELIEF360 — Team Roles & Responsibilities Matrix

This document defines the roles, primary responsibilities, owned codebase artifacts, and handoff boundaries for the four members of the **RELIEF360** engineering team.

---

## 1. Team Directory & Ownership Overview

```
                          +------------------------------------------+
                          |                  SIDDHI                  |
                          | Project Lead & Integration Owner         |
                          | Architecture • Db2 • Overall Integration |
                          +--------------------+---------------------+
                                               │
               ┌───────────────────────────────┼───────────────────────────────┐
               │                               │                               │
               ▼                               ▼                               ▼
+------------------------------+ +------------------------------+ +------------------------------+
|            RITIK             | |            ANANYA            | |          RISHIKESH           |
| COBOL & Business Logic Lead  | | JCL & Batch Processing Lead  | | Test Data, QA & Runbook Lead |
| COBOL Progs • Copybooks      | | JCL Streams • DFSORT Cards   | | Test Datasets • Runbooks     |
| Scoring • Reconciliation     | | Step RCs • Restart Flow      | | Test Cases • Documentation   |
+------------------------------+ +------------------------------+ +------------------------------+
```

---

## 2. Individual Member Profiles & Responsibilities

### 2.1 Siddhi
- **Role:** Project Lead + Final Integration + Db2 + Architecture
- **Git Branch:** `siddhi-integration`
- **Primary Responsibilities:**
  - Lead overall system architecture and design governance.
  - Design, maintain, and review Db2 relational DDL schemas (`BENEFICIARY`, `APPLICATION`, `PAYMENT`, `COMPLAINT`, `EXCEPTION_LOG`, `AUDIT_LOG`, `BATCH_RUN`).
  - Oversee cross-component interfaces between COBOL, JCL, DFSORT, and Db2.
  - Manage GitHub repository branching, pull request reviews, and merge approvals.
  - Lead final integration testing on the college z/OS environment.
  - Coordinate the final project demonstration and presentation.
- **Owned Artifacts & Directories:**
  - `sql/` (DDL, DML, queries, db2 plans)
  - `docs/architecture/`
  - Root repository governance (`README.md`, `PROJECT_SPEC.md`, `CONTRIBUTING.md`)

---

### 2.2 Ritik
- **Role:** COBOL + Business Logic Lead
- **Git Branch:** `ritik-cobol`
- **Primary Responsibilities:**
  - Design and implement Enterprise COBOL source programs (`AT01VAL`, `AT02ELIG`, `AT03DUP`, `AT04REC`, `AT05OPS`, `AT06RPT`).
  - Define, normalize, and document shared data structures in `copybook/` (`APPREC`, `PAYREC`, `BENREC`, `EXCREC`, `AUDREC`).
  - Code input validation, banking formatting logic, and duplicate detection routines.
  - Code the weighted 3-factor priority scoring algorithm ($0.50 \times \text{Damage} + 0.30 \times \text{Vulnerability} + 0.20 \times \text{Urgency}$) and aid cap logic.
  - Implement two-file sequential reconciliation logic (Assignment #2 integration) matching approved allocations with bank disbursements.
- **Owned Artifacts & Directories:**
  - `cobol/` (`validation/`, `eligibility/`, `reconciliation/`, `audit/`, `reports/`)
  - `copybook/`

---

### 2.3 Ananya
- **Role:** JCL + DFSORT + Batch Processing Lead
- **Git Branch:** `ananya-jcl`
- **Primary Responsibilities:**
  - Create, optimize, and maintain all Job Control Language (JCL) job streams (`SETUP`, `PREPAPP`, `VALCNT`, `VALID`, `ELIG`, `RECON`, `REPORT`, `AUDIT`, `MONITOR`).
  - Develop DFSORT / ICETOOL control statements (`sort/`) for high-performance sorting and duplicate record elimination (`SUM FIELDS=NONE`).
  - Implement conditional step orchestration using `COND` parameters and `IF-THEN-ELSE-ENDIF` constructs.
  - Define proper dataset dispositions (`DISP=(NEW,CATLG,DELETE)`, `DISP=SHR`, `DISP=OLD`) and GDG generations (`(+1)`, `(0)`).
  - Design robust return-code handling (`RC=0000`, `RC=0004`, `RC=0008`) and restart-safe batch job structures.
- **Owned Artifacts & Directories:**
  - `jcl/` (`setup/`, `preparation/`, `validation/`, `processing/`, `reconciliation/`, `reporting/`, `master/`)
  - `sort/`

---

### 2.4 Rishikesh
- **Role:** Test Data + Documentation + Testing Lead
- **Git Branch:** `rishikesh-testdocs`
- **Primary Responsibilities:**
  - Generate comprehensive, synthetic test datasets for batch ingestion (positive, negative, and edge scenarios).
  - Construct expected output datasets to validate reconciliation accuracy and exception routing.
  - Author and maintain the system test strategy (`TEST_STRATEGY.md`) and test case catalog (`TEST_CASES.md`).
  - Write detailed operator and student runbooks (`ZOS_WORKFLOW.md`).
  - Execute basic integration test runs on z/OS, capturing JES logs and dataset dumps for analysis.
- **Owned Artifacts & Directories:**
  - `testdata/` (`input/`, `expected/`, `scenarios/`)
  - `docs/testing/`
  - `docs/runbook/`

---

## 3. Mutual Understanding & Shared Ownership

While each teammate owns specific subdirectories and components:
- **Every member must understand the end-to-end processing pipeline.**
- Any proposed change to record layouts in `copybook/` must be reviewed jointly by Ritik, Ananya, and Siddhi.
- Rishikesh tests against interfaces provided by Ritik and Ananya.
- Siddhi coordinates all merges into `main` after mutual verification.
