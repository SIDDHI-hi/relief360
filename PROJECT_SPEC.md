# RELIEF360 — Project Specification
## Emergency Relief Allocation, Reconciliation & Audit System

**Version:** 1.0.0 (Baseline Architecture)  
**Project Lead & Integration Owner:** Siddhi  
**Document Classification:** Master Technical Specification & Architecture Reference  

---

## 1. Project Overview

**RELIEF360** is an enterprise-grade z/OS batch processing system engineered to orchestrate emergency disaster relief management across multi-agency operational environments. The platform ingests large volumes of intake relief applications, performs automated deduplication and structural validation, evaluates multi-factor vulnerability and urgency criteria, enforces statutory aid caps, matches approved disbursements against financial institution payment transaction logs, isolates discrepancies into actionable exception streams, and maintains an unalterable audit and operational run history.

Operating natively within the IBM z/OS mainframe architecture, RELIEF360 leverages the deterministic execution, high I/O throughput, decimal arithmetic precision, and transactional integrity inherent to Enterprise COBOL, JCL, DFSORT, and Db2 for z/OS.

---

## 2. Problem Statement

Public and humanitarian relief initiatives during crises regularly suffer from systemic operational failure modes:
1. **Rampant Duplicate Claims:** Opportunistic or accidental multiple submissions under identical or subtly modified national/household identifiers deplete relief reserves.
2. **Disbursement Disconnects:** Relief aid approved by case officers often fails to reconcile with third-party banking records due to incorrect account numbering, system transmission drops, or timing mismatches.
3. **Subjective or Inconsistent Allocation:** Without standardized algorithmic evaluation, aid distribution risks inequity, failing to prioritize highly vulnerable populations (e.g., severe structural damage, high elderly/infant ratios, acute medical urgency).
4. **Fraud & Invalid Identity Ingestion:** Incomplete documentation and invalid banking identifiers contaminate core transaction ledgers.
5. **Absence of Restartability & Auditability:** Batch job failures during high-volume processing windows can lead to duplicate payment creation or corrupted dataset states if restart boundaries are ill-defined.

---

## 3. Objectives

- **Automated High-Speed Ingestion:** Ingest fixed-width sequential application files with automated record deduplication using DFSORT.
- **Rigorous Data Quality Gates:** Enforce pre-processing record-count reconciliations before invoking resource-intensive processing routines.
- **Deterministic Evaluation:** Implement COBOL business engines that calculate priority scores and statutory aid caps using standardized decimal arithmetic.
- **Two-Way Financial Reconciliation:** Automatically compare approved relief grants with external bank disbursement feeds, classifying records as matched, mismatched, or missing.
- **Exception Routing:** Segregate invalid, unverified, duplicate, over-cap, and mismatched records into dedicated exception datasets with standardized reason codes.
- **Comprehensive Audit & Restart Safety:** Record every transition in an append-only audit trail and track job execution boundaries in Db2 to ensure checkpoint restart capability.
- **Operational Oversight:** Supply operators with automated REXX status scripts and 3270/ISPF dialogs for seamless mainframe monitoring.

---

## 4. System Architecture

The RELIEF360 architecture is divided into five cohesive layers:

```
+-----------------------------------------------------------------------------------+
| 1. DATA INGESTION & STAGING LAYER                                                 |
|    - Beneficiary application flat files (PS / GDG)                                |
|    - Bank disbursement flat files (PS / GDG)                                      |
+-----------------------------------------┬-----------------------------------------+
                                          │
                                          ▼
+-----------------------------------------------------------------------------------+
| 2. JCL BATCH ORCHESTRATION & PREPROCESSING LAYER                                  |
|    - Master Job: RELIEF360                                                        |
|    - DFSORT: Fast sort, field extraction, duplicate elimination                   |
|    - Quality Gate: Step condition codes (COND / IF-THEN-ELSE), count check        |
+-----------------------------------------┬-----------------------------------------+
                                          │
                                          ▼
+-----------------------------------------------------------------------------------+
| 3. COBOL BUSINESS LOGIC LAYER                                                     |
|    - AT01VAL: Schema, format, identity, and banking validation                    |
|    - AT02ELIG: Multi-variable scoring, eligibility ranking, aid capping           |
|    - AT03DUP: Complex cross-household duplicate resolution                       |
|    - AT04REC: Dual-file sequential matching against bank payment files            |
|    - AT05OPS: Centralized audit logging, batch state tracking                     |
|    - AT06RPT: Formatted summary, disbursement, and exception reports              |
+-----------------------------------------┬-----------------------------------------+
                                          │
                                          ▼
+-----------------------------------------------------------------------------------+
| 4. PERSISTENCE & DATA MANAGEMENT LAYER                                            |
|    - Db2 for z/OS Tables: Relational state, referential integrity                 |
|    - VSAM / Sequential Datasets: Audit logs, exception dumps, summary listings    |
+-----------------------------------------┬-----------------------------------------+
                                          │
                                          ▼
+-----------------------------------------------------------------------------------+
| 5. OPERATIONAL MONITORING & OPERATOR INTERFACE                                    |
|    - REXX Utilities: RMONITOR, RSTATUS, RREPORT, RRESTART, RDEDUP                 |
|    - ISPF / 3270 Panels: Application review, batch trigger, exception viewing     |
+-----------------------------------------------------------------------------------+
```

---

## 5. Technology Responsibilities

| Technology | Architectural Responsibility in RELIEF360 |
| :--- | :--- |
| **COBOL** | Core transactional and algorithmic processing: field validation, priority formula evaluation, aid cap calculations, two-file sequential reconciliation logic, formatted report writing, and embedded SQL cursor handling. |
| **JCL** | Batch job definition, step sequencing, dataset dynamic allocation (`DISP=(NEW,CATLG,DELETE)`), conditional execution logic (`COND` / `IF-THEN-ELSE`), temporary workspace management, and GDG rollover. |
| **DFSORT** | Ultra-efficient sorting of millions of fixed-width records by primary keys, record filtering (`INCLUDE`/`OMIT`), and duplicate elimination (`SUM FIELDS=NONE`). |
| **Db2 for z/OS** | System of record for beneficiary identities, persistent application master states, bank payment reconciliations, audit logs, and batch run checkpoints. |
| **REXX** | Operational automation, console message parsing, batch status reporting, restart verification, and ad-hoc utility execution without requiring full JCL compile loops. |
| **ISPF / 3270** | Menu-driven green-screen interface for emergency relief supervisors and operators to query application statuses, view exception logs, and inspect batch progress. |
| **GitHub** | Centralized distributed version control, pull request code reviews, release tagging, and team collaboration. |
| **Zowe Explorer** | Developer tooling bridging VS Code/local workstations with z/OS USS, MVS datasets, and JES spool output. |

---

## 6. End-to-End Processing Flow

The system processes data across sequential phases:

```
[ Application Input (PS / GDG) ]
                 │
                 ▼
[ DFSORT Preprocessing / Deduplication (PREP-APP) ]
                 │
                 ▼
[ Input / Count Validation Quality Gate (VALIDATE-COUNT) ]
                 │
                 ▼
[ COBOL Application Validation (AT01VAL / VALID) ]
                 │
                 ▼
[ Db2 Relational Storage (Staging & Verification) ]
                 │
                 ▼
[ Eligibility & Priority Calculation (AT02ELIG / ELIG) ]
                 │
                 ▼
[ Payment Reconciliation vs. Bank Records (AT04REC / RECON) ]
                 │
                 ▼
[ Exception Handling & Routing (EXCREC / Exception Datasets) ]
                 │
                 ▼
[ Audit Trail Recording (AT05OPS / AUDIT_LOG / AUDIT) ]
                 │
                 ▼
[ Management & Operational Reports (AT06RPT / REPORT) ]
                 │
                 ▼
[ REXX Operational Monitoring & Verification (RMONITOR, RSTATUS) ]
                 │
                 ▼
[ ISPF / 3270 Operator Interface Query & Administration ]
```

---

## 7. Main Components

### 7.1 Enterprise COBOL
COBOL programs represent the deterministic core. All COBOL programs adhere to standard IBM Enterprise COBOL coding standards (Area A/B boundaries, structured programming, explicit scope terminators, structured error handling).

### 7.2 Job Control Language (JCL)
JCL controls the automated execution on z/OS. It defines resources, assigns physical datasets to logical DD statements, and uses step return code evaluations to halt processing if any anomaly occurs.

### 7.3 DFSORT / IBM SORT
DFSORT performs high-speed sorting and duplicate removal on primary keys prior to invoking COBOL, minimizing CPU cycles and memory usage on the mainframe.

### 7.4 Db2 for z/OS
Db2 maintains transactional data integrity across tables, enforcing foreign keys, non-null constraints, and timestamped audit logs. Embedded SQL (`EXEC SQL`) connects COBOL to Db2.

### 7.5 REXX (Restructured Extended Executor)
REXX handles automation, system dataset inspection, return code verification, and operator alerts.

### 7.6 ISPF / 3270
The Interactive System Productivity Facility dialogs provide menu-driven panels (`PANELS`), message definitions (`MSGS`), and command tables for operations personnel.

### 7.7 GitHub & Zowe Explorer
GitHub stores and manages all codebase revisions. Zowe Explorer interacts with z/OS REST APIs to upload members, submit jobs to JES, and inspect job logs.

---

## 8. Db2 Entities (Planned Schema)

The following relational entities are planned for implementation in Db2 for z/OS. *(Note: DDL scripts will be finalized during Phase 1 using site-appropriate storage parameters).*

1. **`BENEFICIARY`:** Master demographic record of citizen/applicant (National ID, Full Name, Household ID, Region, Contact Information).
2. **`APPLICATION`:** Disaster assistance application record (Application ID, Beneficiary ID, Damage Assessment Score, Vulnerability Score, Urgency Score, Calculated Priority, Aid Requested, Aid Approved, Status).
3. **`PAYMENT`:** Bank disbursement record received from external financial institutions (Payment Ref ID, Application ID, Account Number, Bank Routing Code, Amount Paid, Disbursement Timestamp, Reconciliation Status).
4. **`COMPLAINT`:** Grievance or dispute logged against an application or payment (Complaint ID, Application ID, Category, Description, Status, Assigned Officer).
5. **`EXCEPTION_LOG`:** Segregated record log of all processing anomalies (Exception ID, Batch Run ID, Entity Ref, Exception Code, Message, Timestamp).
6. **`AUDIT_LOG`:** Append-only compliance log capturing every state transition (Audit ID, Batch Run ID, Program ID, Action Performed, Previous Value, New Value, Timestamp, User/Job ID).
7. **`BATCH_RUN`:** Execution checkpoint ledger tracking job run instances (Run ID, Job Name, Start Time, End Time, Records Ingested, Records Processed, Records Errored, Final Return Code, Status).

---

## 9. Planned COBOL Programs

| Program ID | Name / Purpose | Description & Functional Responsibility |
| :--- | :--- | :--- |
| **`AT01VAL`** | **Application Validation Engine** | Ingests preprocessed application records. Validates mandatory fields, numeric formats, national ID checksums, bank routing syntax, and applicant verification flags. Flags invalid records with specific exception codes. |
| **`AT02ELIG`** | **Eligibility & Priority Engine** | Reads validated applications. Evaluates eligibility rules, calculates weighted priority score using the 3-factor formula, computes approved aid subject to statutory caps, and assigns priority bands (CRITICAL, HIGH, NORMAL, LOW). |
| **`AT03DUP`** | **Duplicate Resolution Utility** | Inspects cross-household and multi-applicant submissions to detect secondary duplicate patterns not caught by single-key sort deduplication. |
| **`AT04REC`** | **Payment Reconciliation Engine** | Dual-file sequential matching program (Assignment #2 integration). Matches approved aid records against external bank transaction files. Detects matched amounts, under/over payments, missing payments, and invalid accounts. |
| **`AT05OPS`** | **Audit & Operations Controller** | Centralized module that records transactional events to `AUDIT_LOG` and updates `BATCH_RUN` table checkpoints to guarantee safe restartability. |
| **`AT06RPT`** | **Reporting & Summary Generator** | Formats and outputs structured management reports: executive summary, detail disbursement report, exception manifest, and reconciliation balance sheets. |

---

## 10. Planned REXX Programs

| Script Name | Purpose & Operational Function |
| :--- | :--- |
| **`RMONITOR`** | Real-time monitoring script that inspects JES spool status, tracks active RELIEF360 batch jobs, and outputs console health metrics. |
| **`RSTATUS`** | Queries Db2 `BATCH_RUN` table or sequential run status datasets to report completion percentages, record counts, and step return codes. |
| **`RREPORT`** | Extracts summary metrics from batch run outputs and generates an operational digest for administrators. |
| **`RRESTART`** | Validates batch state prior to restart. Determines the last successful step, verifies dataset integrity, and prepares restart JCL parameters. |
| **`RDEDUP`** | Standalone REXX deduplication and validation utility (Assignment #3 integration) for operational dataset cleanup outside the heavy batch cycle. |

---

## 11. Planned JCL Pipeline

The complete batch pipeline is orchestrated through these sequenced jobs:

1. **`SETUP`:** Allocates working datasets, initializes Generation Data Group (GDG) base catalogs, and clears transient work areas.
2. **`PREP-APP` (PREPAPP.jcl):** Executes DFSORT to clean, sort, and deduplicate raw application intake files (Assignment #1).
3. **`VALIDATE-COUNT` (VALCNT.jcl):** Verifies header/trailer record counts and file completeness quality gate (Assignment #4).
4. **`VALID` (VALID.jcl):** Submits COBOL program `AT01VAL` to perform deep field and bank validation.
5. **`ELIG` (ELIG.jcl):** Submits COBOL program `AT02ELIG` to score priority and calculate approved relief funds.
6. **`RECON` (RECON.jcl):** Submits COBOL program `AT04REC` to perform two-file reconciliation against bank transaction files (Assignment #2).
7. **`AUDIT` (AUDIT.jcl):** Submits `AT05OPS` to finalize audit trails and close the batch execution checkpoint.
8. **`REPORT` (REPORT.jcl):** Submits `AT06RPT` to print formatted operational, financial, and exception reports.
9. **`MONITOR` (MONITOR.jcl):** Triggers automated REXX checks (`RMONITOR`, `RSTATUS`) to confirm end-to-end job completion and notify operators.

---

## 12. Business Rules

### 12.1 Eligibility & Intake Rules
- **Rule 1.1 (Verification Gate):** Only records with `STATUS = 'VERIFIED'` and `COMPLETE = 'Y'` proceed to eligibility scoring. Unverified applications are routed to exceptions (`NOT_VERIFIED`).
- **Rule 1.2 (Banking Validation):** Bank routing code and account number must pass numeric and length checks. Failures are rejected (`BANK_INVALID`).
- **Rule 1.3 (Duplicate Suppression):** Applications matching an existing National ID or Household ID within the active cycle are halted (`DUPLICATE`).
- **Rule 1.4 (Grievance Hold):** Any application with an unresolved active dispute in `COMPLAINT` with status `'OPEN'` is placed on hold (`COMPLAINT_PENDING`).

### 12.2 Priority Scoring Formula
Priority scores are deterministically calculated using weighted multi-variable evaluation:

$$\text{Priority Score} = (0.50 \times \text{Damage}) + (0.30 \times \text{Vulnerability}) + (0.20 \times \text{Urgency})$$

Where:
- $\text{Damage} \in [0, 100]$: Physical property and livelihood destruction score.
- $\text{Vulnerability} \in [0, 100]$: Socio-economic vulnerability (dependent ratio, elderly, infants, disability).
- $\text{Urgency} \in [0, 100]$: Acute need index (medical emergency, shelterless state, potable water lack).

### 12.3 Priority Classification Bands
| Score Range | Priority Band | Processing SLA / Allocation Rule |
| :---: | :---: | :--- |
| **80 – 100** | **CRITICAL** | Immediate disbursement tranche; top allocation priority. |
| **60 – 79** | **HIGH** | Secondary allocation tranche. |
| **40 – 59** | **NORMAL** | Standard batch distribution window. |
| **Below 40** | **LOW** | Deferred until critical and high cohorts are satisfied. |

### 12.4 Financial & Aid Capping Rules
- **Rule 4.1 (Aid Cap):** Approved aid cannot exceed the configured statutory maximum aid cap:
  $$\text{Approved Aid} = \min(\text{Requested Aid}, \text{Configured Aid Cap})$$
  Any requested aid exceeding the cap is adjusted, and an audit note is generated (`OVER_CAP`).
- **Rule 4.2 (Payment Reconciliation Match):** An approved application must match a corresponding bank transaction:
  - If $\text{Paid Amount} = \text{Approved Amount}$ $\rightarrow$ **MATCHED**
  - If $\text{Paid Amount} \ne \text{Approved Amount}$ $\rightarrow$ **PAYMENT_MISMATCH**
  - If approved record exists but no bank record $\rightarrow$ **PAYMENT_MISSING**

### 12.5 Planned Exception Codes
- `NOT_VERIFIED`: Application documentation unverified or incomplete.
- `BANK_INVALID`: Invalid bank account number or routing transit number.
- `DUPLICATE`: Duplicate citizen or household submission identified.
- `OVER_CAP`: Requested relief exceeds allowable administrative limit.
- `PAYMENT_MISSING`: Approved allocation has no matching bank disbursement record.
- `PAYMENT_MISMATCH`: Bank transaction amount differs from approved allocation amount.
- `COMPLAINT_PENDING`: Unresolved grievance blocking automated processing.

---

## 13. Audit and Restart Strategy

### 13.1 Append-Only Audit Trail
Every business event (status change, score calculation, cap adjustment, reconciliation decision) triggers a write to `AUDIT_LOG`. Audit records include timestamp, job name, program ID, applicant ID, action code, and before/after images.

### 13.2 Restart-Safe Batch Processing
- JCL steps are designed to be idempotent.
- Intermediate datasets use GDG generations (`(+1)` on creation, `(0)` on consumption) or conditional disposition (`DISP=(MOD,CATLG)` / pre-deletion steps) to prevent dataset catalog collisions.
- Checkpoints are committed to the Db2 `BATCH_RUN` table at the end of each logical step. If a step abends (e.g., `S0C7`, `S0C4`, or `RC > 4`), REXX script `RRESTART` inspects `BATCH_RUN` to determine the exact failure point and configure the restart step parameter (`RESTART=STEPNAME`).

---

## 14. Testing Strategy

The system undergoes rigorous multi-tier testing:
1. **Unit Testing:** Individual COBOL modules tested with synthetic sequential test vectors covering Area A/B formatting, decimal rounding, and conditional logic.
2. **Quality Gate Testing:** Validation that JCL conditional statements (`COND=(4,LT)`) halt execution on invalid record counts or abnormal return codes.
3. **Reconciliation Boundary Testing:** Verifying two-file matching scenarios (exact match, partial payment, overpayment, missing transaction, duplicate bank record).
4. **Restart & Recovery Testing:** Deliberate injection of abends to verify that the restart procedure successfully resumes processing without double-disbursing funds or creating orphan records.

---

## 15. Future ISPF / 3270 Interface

An interactive 3270 user interface will be developed in later phases to provide non-technical staff with operational capabilities:
- **Panel `R360MNU`:** Primary selection menu for RELIEF360 operations.
- **Panel `R360APP`:** Application query and manual status review screen.
- **Panel `R360REC`:** Real-time reconciliation summary and mismatch investigator.
- **Panel `R360EXC`:** Exception resolution and override screen.
- **Panel `R360OPS`:** Batch job submission and REXX monitor trigger interface.

---

## 16. Open Environment-Specific Configuration

The following parameters are strictly **environment-dependent** and depend on the host college/institutional z/OS mainframe configuration. **They must NOT be hardcoded or fabricated:**

- **`<HLQ>` (High-Level Qualifier):** User or project dataset high-level qualifier (e.g., `USERID`, `PROD`, `TEST`).
- **`<DB2_SSID>`:** Db2 Subsystem identifier (e.g., `DSN1`, `DB2P`, `DSNA`).
- **`<DB2_LOCATION>`:** Network location and relational database directory.
- **`<COBOL_COMP_PROC>`:** Site-specific COBOL compilation JCL procedure (e.g., `IGYWC`, `IGYWCLG`, or custom institution proc).
- **`<LKED_PROC>`:** Site-specific link-edit and bind procedure.
- **`<INSTITUTION_LIBS>`:** System libraries for COBOL runtimes (`CEE.SCEERUN`), Db2 load libraries (`DSN.SDSNLOAD`), and copybook libraries.
- **`<ZOWE_PROFILE>`:** Personal Zowe CLI connection profiles and secure team credentials.

*All project files use symbolic parameters (e.g., `&HLQ`, `&DB2SSID`) or clear placeholders (`<HLQ>`) until target environment specifications are provided.*
