# RELIEF360 — Job Control Language (JCL) Batch Streams

This directory houses the JCL job streams, cataloged procedures, and step execution controls for the **RELIEF360** mainframe batch system.

**Primary Owner:** Ananya (JCL & Batch Orchestration Lead)  
**Integration Lead:** Siddhi  

---

## Directory Organization & Job Inventory

| Subdirectory | Member Name | Pipeline Phase | Description |
| :--- | :--- | :--- | :--- |
| `setup/` | **`SETUP.jcl`** | SETUP | Allocates project datasets, initializes GDG bases, and formats transient work areas. |
| `preparation/`| **`PREPAPP.jcl`** | PREP-APP | Executes DFSORT to cleanse, sort, and deduplicate raw application feeds (Assignment #1). |
| `validation/` | **`VALCNT.jcl`** | VALIDATE-COUNT | Quality gate comparing input counts against control trailer cards (Assignment #4). |
| `validation/` | **`VALID.jcl`** | VALID | Executes COBOL program `AT01VAL` for schema, ID, and bank validation. |
| `processing/` | **`ELIG.jcl`** | ELIG | Executes COBOL program `AT02ELIG` for priority calculation and statutory aid capping. |
| `reconciliation/`|**`RECON.jcl`** | RECON | Executes COBOL program `AT04REC` for two-file payment reconciliation (Assignment #2). |
| `reporting/` | **`REPORT.jcl`** | REPORT | Executes COBOL program `AT06RPT` to print disbursement summaries and exception logs. |
| `master/` | **`RELIEF360.jcl`** | MASTER PIPELINE | End-to-end master job orchestrating all sequential phases with conditional flow control. |
| `master/` | **`AUDIT.jcl`** | AUDIT | Executes `AT05OPS` to finalize audit trails and commit run checkpoint states. |
| `master/` | **`MONITOR.jcl`** | MONITOR | Triggers automated REXX health checks and return-code verification scripts. |

---

## JCL Design Standards
- All JCL statements strictly begin with `//` in columns 1-2.
- Dataset names use standardized `<HLQ>` symbolic parameters (e.g., `&HLQ..RELIEF360.COBOL`).
- Conditional execution uses standard `COND` parameters or `IF/THEN/ELSE/ENDIF` blocks to halt on `RC > 4`.
- Temporary datasets use system-managed disposition `DISP=(NEW,DELETE)`.
