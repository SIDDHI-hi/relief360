# RELIEF360 — COBOL Source Modules

This directory contains the Enterprise COBOL programs for **RELIEF360**, organized by functional domain.

**Primary Owner:** Ritik (COBOL & Business Logic Lead)  
**Integration Lead:** Siddhi  

---

## Directory Organization & Program Directory

| Directory | Program ID | Name / Description |
| :--- | :--- | :--- |
| `validation/` | **`AT01VAL.cbl`** | Ingests preprocessed records; validates field formats, National ID checksums, bank routing codes, and identity verification flags. |
| `validation/` | **`AT03DUP.cbl`** | Detects and resolves cross-household duplicate submissions and multi-claim patterns. |
| `eligibility/` | **`AT02ELIG.cbl`** | Calculates weighted 3-factor priority scores ($0.50 \times \text{Damage} + 0.30 \times \text{Vulnerability} + 0.20 \times \text{Urgency}$) and enforces statutory aid caps. |
| `reconciliation/`| **`AT04REC.cbl`** | Two-file sequential matching engine reconciling approved relief amounts against external bank disbursement feeds (Assignment #2). |
| `audit/` | **`AT05OPS.cbl`** | Centralized audit logger and operational status checkpoint manager interfacing with Db2 `AUDIT_LOG` and `BATCH_RUN`. |
| `reports/` | **`AT06RPT.cbl`** | Generates formatted executive summary listings, reconciliation balance sheets, and exception manifests. |

---

## Coding Standards & Conventions

1. **Format:** Standard 80-column fixed layout:
   - Columns 1-6: Sequence numbers (optional / spaces).
   - Column 7: Indicator area (space, `*` for comment, `-` for continuation).
   - Columns 8-11: Area A (Division, Section, Paragraph names, 01/77 levels).
   - Columns 12-72: Area B (Statements, clauses, subordinate data levels).
   - Columns 73-80: Identification area (program name / blank).
2. **Copybooks:** Include shared structures from `copybook/` using `COPY <MEMBER>.` statements.
3. **Status Codes:** Always check `FILE STATUS` after file I/O and `SQLCODE` after `EXEC SQL` calls.
