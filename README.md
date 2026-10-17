# RELIEF360
## Emergency Relief Allocation, Reconciliation & Audit System

---

## 1. What RELIEF360 Is

**RELIEF360** is a mission-critical, z/OS-based batch processing system engineered to manage emergency relief allocation, financial reconciliation, and compliance auditing. Built strictly for the mainframe environment, RELIEF360 processes incoming disaster and crisis assistance applications, verifies beneficiary and payment data, computes eligibility and weighted priority scores, enforces government/organizational aid caps, reconciles approved disbursements against actual bank transactions, flags anomalies, and preserves an immutable audit trail.

---

## 2. The Problem It Solves

During natural disasters and humanitarian crises, relief organizations and government agencies receive massive volumes of relief applications under extreme time pressure. Manual and ad-hoc processing leads to severe systemic failures:
- **Duplicate Applications:** Multiple submissions from the same household or individual draining finite relief funds.
- **Payment Disbursement Discrepancies:** Approved amounts failing to match bank transaction files, or missing payments going undetected.
- **Fraud & Invalid Financial Data:** Incomplete records, invalid bank routing/account identifiers, and unverified applicant claims.
- **Lack of Transparent Prioritization:** Failure to systematically triage relief aid based on quantifiable metrics such as property damage, family vulnerability, and acute urgency.
- **Absence of Auditability & Operational Continuity:** Inability to safely restart failed batch runs without duplicating payments or corrupting financial ledgers.

RELIEF360 solves these challenges using high-throughput, restart-safe z/OS batch processing, deterministic COBOL business logic, robust DFSORT deduplication, relational integrity via Db2 for z/OS, and real-time operational monitoring via REXX and ISPF.

---

## 3. High-Level Architecture

RELIEF360 operates on a layered mainframe batch architecture:

```
+-----------------------------------------------------------------------+
|                             INPUT DATA                                |
|   Sequential Beneficiary Applications (PS/GDG), Bank Transaction Files|
+-----------------------------------┬-----------------------------------+
                                    │
                                    ▼
+-----------------------------------------------------------------------+
|                    STEP 1: PREPARATION & QUALITY GATE                 |
|   - DFSORT: Fast sort, validation, record deduplication               |
|   - JCL Quality Gate: Record count verification & RC checking         |
+-----------------------------------┬-----------------------------------+
                                    │
                                    ▼
+-----------------------------------------------------------------------+
|                 STEP 2: COBOL CORE PROCESSING ENGINE                  |
|   - AT01VAL: Comprehensive schema, rule, & bank account validation    |
|   - AT02ELIG: Multi-factor priority scoring & aid cap enforcement     |
|   - AT04REC: Two-way reconciliation against actual bank transaction data|
|   - AT05OPS: Centralized audit logging & batch run state management   |
+-----------------------------------┬-----------------------------------+
                                    │
                                    ▼
+-----------------------------------------------------------------------+
|                     STEP 3: PERSISTENCE & STORAGE                     |
|   - Db2 for z/OS: Relational persistence (Applications, Beneficiaries,|
|                   Payments, Exceptions, Batch Run Status)              |
|   - Sequential Files: Formatted Reports, Exception Files, Audit Logs   |
+-----------------------------------┬-----------------------------------+
                                    │
                                    ▼
+-----------------------------------------------------------------------+
|             STEP 4: OPERATIONAL MONITORING & INTERFACE                |
|   - REXX Scripts: Automated batch monitoring, run status, restart safe |
|   - ISPF / 3270: Operator dialogs, review screens, parameter controls |
+-----------------------------------------------------------------------+
```

---

## 4. Technology Stack

- **Host Operating System:** IBM z/OS
- **Primary Programming Language:** Enterprise COBOL
- **Batch Control & Orchestration:** Job Control Language (JCL)
- **High-Performance Sorting / Filtering:** DFSORT / IBM SORT
- **Database Management System:** IBM Db2 for z/OS
- **System Automation & Scripting:** REXX
- **Interactive User Interface:** ISPF / 3270 Panels & Dialogs
- **File Systems & Datasets:** Physical Sequential (PS) Datasets, Generation Data Groups (GDGs), Partitioned Datasets (PDS/PDSE)
- **Source Code Management:** Git & GitHub
- **Mainframe Integration & Tooling:** Zowe Explorer (VS Code / CLI)

*Note: RELIEF360 is built exclusively on mainframe technologies. It does not use modern web or non-mainframe stacks (such as Node.js, React, Python web frameworks, or NoSQL databases).*

---

## 5. Main Processing Pipeline

The end-to-end batch execution pipeline flows through the following sequenced phases:

1. **SETUP:** Allocates temporary and permanent working datasets, establishes GDG bases, and validates environment prerequisites.
2. **PREP-APP (Assignment #1 Integration):** Ingests raw beneficiary application files and utilizes DFSORT to sort keys and purge identical duplicate records.
3. **VALIDATE-COUNT (Assignment #4 Integration):** Executes a JCL quality gate to compare input record counts against control headers, halting execution upon discrepancy.
4. **VALID (AT01VAL):** Invokes the primary COBOL validation module to enforce field rules, applicant identity flags, and banking routing codes.
5. **ELIG (AT02ELIG):** Calculates vulnerability metrics, applies the 3-factor priority formula, caps requested relief amounts, and logs status to Db2.
6. **RECON (AT04REC - Assignment #2 Integration):** Performs a dual-file sequential matching pass between approved relief allocations and actual bank disbursement transaction files.
7. **AUDIT (AT05OPS):** Updates the immutable audit trail and writes checkpoint records to `BATCH_RUN` to guarantee restart safety.
8. **REPORT (AT06RPT):** Generates management summaries, detailed financial disbursement listings, and exception manifests.
9. **MONITOR (REXX):** Employs REXX utilities (`RMONITOR`, `RSTATUS`) to track execution return codes, dataset generations, and alert operators.

---

## 6. Repository Structure

```
RELIEF360/
├── cobol/                 # COBOL source programs (.cbl)
│   ├── validation/        # Input and duplicate validation (AT01VAL, AT03DUP)
│   ├── eligibility/       # Scoring, rules, and cap logic (AT02ELIG)
│   ├── reconciliation/    # Payment matching engine (AT04REC)
│   ├── audit/             # Operational status and audit logging (AT05OPS)
│   └── reports/           # Management and audit reporting (AT06RPT)
│
├── copybook/              # Shared COBOL data structures (.cpy)
│                          # (APPREC, PAYREC, BENREC, EXCREC, AUDREC)
│
├── jcl/                   # Job Control Language streams (.jcl)
│   ├── setup/             # Environment & dataset allocation jobs (SETUP)
│   ├── preparation/       # Preprocessing and sorting jobs (PREPAPP)
│   ├── validation/        # Validation & count gate jobs (VALCNT, VALID)
│   ├── processing/        # Core business calculation jobs (ELIG)
│   ├── reconciliation/    # Payment reconciliation batch jobs (RECON)
│   ├── reporting/         # Report generation jobs (REPORT)
│   └── master/            # Master pipeline and monitoring JCL (RELIEF360)
│
├── rexx/                  # REXX monitoring, restart, & utility scripts (.rex)
│
├── sql/                   # Relational database artifacts (.sql)
│   ├── ddl/               # Table and index creation definitions
│   ├── dml/               # Reference data and seed scripts
│   ├── queries/           # Operational and verification queries
│   └── db2/               # Embedded SQL routines and plan binds
│
├── sort/                  # DFSORT / ICETOOL control statements (.srt)
│
├── testdata/              # Synthetic test datasets and test fixtures
│   ├── input/             # Sample raw input sequential records
│   ├── expected/          # Expected output files for assertions
│   └── scenarios/         # Edge-case scenarios (over-cap, mismatch, etc.)
│
├── docs/                  # Project specifications and guides (.md)
│   ├── architecture/      # Detailed architectural diagrams & topology
│   ├── design/            # Business rules & assignment mappings
│   ├── testing/           # Test strategies, cases, and acceptance matrices
│   ├── runbook/           # z/OS dataset conventions & operations
│   └── team/              # Team roles, responsibilities, & workflows
│
├── ispf/                  # ISPF dialog components (Panels, Skeletons, Messages)
├── config/                # Environment configuration templates (sanitized)
├── README.md              # Project root overview
├── PROJECT_SPEC.md        # Definitive technical specification
├── CONTRIBUTING.md        # Branching, review, and Git procedures
├── .gitignore             # Mainframe and editor file exclusions
└── LICENSE                # Project license
```

---

## 7. Team Responsibilities

| Member | Primary Role | Core Focus Areas |
| :--- | :--- | :--- |
| **Siddhi** | **Project Lead & Integration Owner** | System architecture, Db2 relational schema & embedded SQL, repository governance, cross-component integration, end-to-end z/OS execution & final demonstration. |
| **Ritik** | **COBOL & Business Logic Lead** | COBOL program development (`AT01VAL` through `AT06RPT`), copybook definitions, eligibility & priority scoring engines, payment reconciliation logic. |
| **Ananya** | **JCL & Batch Orchestration Lead** | JCL job stream creation, DFSORT control cards, conditional step branching (`COND` / `IF-THEN-ELSE`), return code handling, restartability. |
| **Rishikesh** | **Test Data, Runbook & QA Lead** | Test dataset generation (positive/negative/edge cases), test execution documentation, runbooks, verification matrices, QA reporting. |

---

## 8. Development Workflow

All four team members adhere to a structured, branch-based Git workflow to ensure code stability and seamless integration:

1. **Pull Latest Main:** Sync local workspace before initiating work.
2. **Work in Dedicated Feature Branch:**
   - Siddhi: `siddhi-integration`
   - Ritik: `ritik-cobol`
   - Ananya: `ananya-jcl`
   - Rishikesh: `rishikesh-testdocs`
3. **Local Syntax & Sanity Verification:** Verify source formats (columns 8-72 for COBOL, uppercase JCL conventions).
4. **Commit with Meaningful Messages:** State clearly what component was updated.
5. **Push to Remote & Open Pull Request:** Submit PR targeting `main`.
6. **Code Review & Integration Sign-Off:** Siddhi reviews all integration-impacting changes before merging.
7. **Pull Updated Main:** Maintain branch synchronization.

---

## 9. z/OS Development Workflow

Once source code is validated in the repository, it is deployed to the z/OS host environment using Zowe Explorer:

1. **Upload Source:** Transfer local code into target partitioned datasets (PDS/PDSE) on z/OS using Zowe Explorer or scripted CLI commands.
2. **Compile / Assemble:** Submit compile JCL procedures on z/OS (e.g., standard IBM COBOL compiler procs with Db2 coprocessor/precompiler).
3. **Execute Batch Jobs:** Submit job streams (e.g., `SETUP`, `PREPAPP`, `VALCNT`, `RELIEF360`).
4. **Monitor in JES/SDSF:** Review job execution status, step return codes (targeting `RC=0000` or expected warnings `RC=0004`), and spool output (`SYSOUT`, `SYSPRINT`).
5. **Inspect Datasets:** Check output sequential files, exception files, and Db2 table states using SPUFI or query jobs.
6. **Troubleshoot & Fix:** Resolve errors locally, commit changes, re-upload to z/OS, and re-run.

---

## 10. How GitHub and z/OS Fit Together

It is vital to understand the distinct operational boundaries between GitHub and z/OS:

- **GitHub is the Source of Truth for Source Code:** GitHub hosts version control, change history, peer reviews, issues, and collaboration artifacts. GitHub **does not** execute mainframe JCL, compile COBOL, or run Db2 for z/OS.
- **z/OS is the Execution Environment:** The mainframe host owns the datasets, compilers, runtime libraries, Db2 subsystem, JES job queue, and execution processor.
- **Zowe Explorer Bridges the Gap:** Zowe provides the communication bridge between modern developer environments (VS Code / Git) and z/OS, enabling dataset upload, job submission, and spool viewing without replacing the mainframe execution layer.

```
+-------------------------------------------------------------------+
|                        LOCAL / GIT / GITHUB                       |
|   - Workstation / Antigravity IDE                                 |
|   - Git Version Control                                           |
|   - GitHub Remote Repository (Single Source of Truth for Code)    |
+---------------------------------┬---------------------------------+
                                  │
                  Zowe Explorer / Approved Transfer
                                  │
                                  ▼
+-------------------------------------------------------------------+
|                     IBM z/OS MAINFRAME HOST                       |
|   - Partitioned Datasets (<HLQ>.RELIEF360.COBOL, .JCL, etc.)      |
|   - COBOL Compiler & Link-Editor                                  |
|   - JES Spool (JES2/JES3, SDSF)                                   |
|   - Db2 for z/OS Subsystem                                        |
|   - Batch Execution Engine & DFSORT                               |
+-------------------------------------------------------------------+
```

---

## 11. Current Project Status

- **Phase:** **Phase 0 — Repository Architecture, Baseline Structure & Governance Setup**
- **Implementation Status:** Structural setup complete. Clean placeholder members established for COBOL programs, copybooks, JCL jobs, REXX scripts, and test data specifications.
- **Next Milestone:** Phase 1 — Copybook finalization, Db2 DDL staging, and Assignment module integration.
