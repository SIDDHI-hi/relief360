# RELIEF360 — Academic Assignment Integration Architecture

This document formalizes how the four academic mainframe assignments are directly integrated into the production architecture of **RELIEF360**. Rather than functioning as standalone academic exercises, each assignment serves as an indispensable subsystem of the end-to-end disaster relief batch pipeline.

---

## 1. Assignment Integration Mapping Overview

```
+-----------------------------------------------------------------------------------+
| ASSIGNMENT #1: PS File Processing with DFSORT                                     |
| Maps to: PREP-APP (Job: PREPAPP.jcl, Control: sort/SRTAPP01.srt)                  |
| Role: Intake flat-file cleanup, primary key sorting, duplicate removal            |
+-----------------------------------------------------------------------------------+
                                          │
                                          ▼
+-----------------------------------------------------------------------------------+
| ASSIGNMENT #4: JCL File Validation, Record Counts & Conditional Flow Control      |
| Maps to: VALIDATE-COUNT (Job: VALCNT.jcl)                                         |
| Role: Quality gate ensuring file integrity, count validation, and safe branching  |
+-----------------------------------------------------------------------------------+
                                          │
                                          ▼
+-----------------------------------------------------------------------------------+
| ASSIGNMENT #2: Two-File Sequential Matching in COBOL                              |
| Maps to: AT04REC Payment Reconciliation (Program: cobol/reconciliation/AT04REC)   |
| Role: Matches approved relief grants against external banking transaction logs    |
+-----------------------------------------------------------------------------------+
                                          │
                                          ▼
+-----------------------------------------------------------------------------------+
| ASSIGNMENT #3: REXX Data Manipulation & Operational Utility                       |
| Maps to: RDEDUP (Script: rexx/RDEDUP.rex)                                         |
| Role: Standalone administrative deduplication and dataset sanitation tool         |
+-----------------------------------------------------------------------------------+
```

---

## 2. Detailed Subsystem Mappings

### 2.1 Assignment #1: PS File Processing with DFSORT
- **Academic Assignment Concept:** Ingesting a Physical Sequential (PS) file, sorting records by defined key fields, and eliminating duplicate entries using sorting control cards.
- **RELIEF360 Operational Mapping:** **`PREP-APP` (Preparation Phase)**
- **Components:**
  - JCL: `jcl/preparation/PREPAPP.jcl`
  - Sort Control Card: `sort/SRTAPP01.srt`
- **Functional Responsibility:**
  Raw application feeds arrive from multiple intake channels in unsorted order with accidental duplicate submissions. `PREP-APP` executes DFSORT with `SORT FIELDS=(1,10,CH,A)` (National ID / Household Key) and `SUM FIELDS=NONE` to output a sorted, deduplicated baseline dataset ready for mainframe processing.

---

### 2.2 Assignment #2: Two-File Sequential Matching in COBOL
- **Academic Assignment Concept:** Reading two pre-sorted sequential input files simultaneously and performing high-speed sequential matching logic (key comparison: $Key_A = Key_B$, $Key_A < Key_B$, $Key_A > Key_B$).
- **RELIEF360 Operational Mapping:** **`AT04REC` (Payment Reconciliation Engine)**
- **Components:**
  - COBOL Program: `cobol/reconciliation/AT04REC.cbl`
  - Copybooks: `copybook/APPREC.cpy`, `copybook/PAYREC.cpy`
  - JCL: `jcl/reconciliation/RECON.jcl`
- **Functional Responsibility:**
  Approved relief payments must be reconciled against the clearing transaction file provided by the banking authority. `AT04REC` sequentially compares approved relief records with bank records:
  - **Match:** Approved ID matches Bank ID with equal disbursement amount.
  - **Mismatch:** Record matches on ID, but disbursed amount deviates from approved grant.
  - **Missing:** Approved grant exists on system records with zero corresponding bank disbursement.
  - **Unmatched Bank Item:** Bank transaction lacks an approved relief application in the system.

---

### 2.3 Assignment #3: REXX Data Manipulation & Deduplication
- **Academic Assignment Concept:** Writing a REXX program to parse, sort, and deduplicate records programmatically using compound variables (`STEM` variables) and REXX string parsing.
- **RELIEF360 Operational Mapping:** **`RDEDUP` (Operational Deduplication Utility)**
- **Components:**
  - REXX Program: `rexx/RDEDUP.rex`
- **Functional Responsibility:**
  Provides mainframe system operators with a lightweight, interactive command utility to sanitize and inspect small test datasets or perform emergency on-demand deduplication directly in TSO/ISPF without having to draft and submit a full batch JCL job.

---

### 2.4 Assignment #4: JCL Quality Gates, Count Validation & Conditional Flow
- **Academic Assignment Concept:** Authoring JCL that copies datasets, performs record count validation against header/trailer records, and uses `COND` or `IF/THEN/ELSE` return code branching to govern downstream execution.
- **RELIEF360 Operational Mapping:** **`VALIDATE-COUNT` (Quality Gate Phase)**
- **Components:**
  - JCL: `jcl/validation/VALCNT.jcl`
- **Functional Responsibility:**
  Serves as the indispensable quality firewall between raw ingestion and the COBOL calculation engines. If the input file is truncated, missing its trailer record, or has a mismatched record count, `VALCNT` sets `RC=0008`. Downstream calculation steps (`ELIG`, `RECON`, `REPORT`) evaluate this condition code and bypass execution, protecting the database from corrupted batch updates.

---

## 3. Implementation Status
All four assignment mappings are architecturally documented and assigned to the respective team leads. Programmatic implementation will begin in Phase 1.
