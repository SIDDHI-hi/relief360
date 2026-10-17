# RELIEF360 — z/OS Operational Workflow & Dataset Mapping

This guide explains conceptually how the local and GitHub repository structures map to native IBM z/OS datasets, Partitioned Datasets (PDS/PDSE), and Generation Data Groups (GDGs).

---

## 1. High-Level Qualifier (`<HLQ>`) Policy

> [!IMPORTANT]
> **DO NOT ASSUME A FIXED HLQ:**  
> Mainframe environments assign individual High-Level Qualifiers (HLQs) or group prefixes depending on student/developer credentials.  
> Each team member may have their own individual account (e.g., `KC03A01`, `STUDENT1`, `USER24`) or a common project HLQ (e.g., `RELIEF`).  
> **Source code remains universally shared via GitHub**, while each teammate uses their personal `<HLQ>` when allocating datasets and executing test jobs in their z/OS workspace.

---

## 2. Repository to z/OS Dataset Mapping

The table below illustrates the standard conceptual mapping from repository directories to native z/OS Partitioned Datasets (PDS/PDSE) and Sequential Datasets (PS):

| Repository Path | z/OS Dataset Name (Conceptual) | Organization | Record Format (RECFM) | Logical Record Length (LRECL) | Description |
| :--- | :--- | :---: | :---: | :---: | :--- |
| `cobol/**/*.cbl` | `<HLQ>.RELIEF360.COBOL` | PO (PDS/E) | `FB` | 80 | COBOL source programs (`AT01VAL`, `AT02ELIG`, etc.) |
| `copybook/*.cpy` | `<HLQ>.RELIEF360.COPYBOOK` | PO (PDS/E) | `FB` | 80 | Data layout copybooks (`APPREC`, `PAYREC`, etc.) |
| `jcl/**/*.jcl` | `<HLQ>.RELIEF360.JCL` | PO (PDS/E) | `FB` | 80 | JCL job streams and procedures |
| `rexx/*.rex` | `<HLQ>.RELIEF360.REXX` | PO (PDS/E) | `VB` or `FB` | 255 / 80 | REXX automation and monitoring scripts |
| `sql/**/*.sql` | `<HLQ>.RELIEF360.SQL` | PO (PDS/E) | `FB` | 80 | Db2 DDL, DML, and query scripts |
| `sort/*.srt` | `<HLQ>.RELIEF360.SORT` | PO (PDS/E) | `FB` | 80 | DFSORT / ICETOOL control cards |
| `testdata/input/*` | `<HLQ>.RELIEF360.INPUT` | PS / GDG | `FB` | 200 (approx) | Raw application and payment intake feeds |
| Transient Work | `<HLQ>.RELIEF360.WORK` | PS | `FB` | Dynamic | Intermediate sorted/deduplicated files |
| Final Output | `<HLQ>.RELIEF360.OUTPUT` | PS / GDG | `FB` | 200 (approx) | Processed relief allocations |
| Formatted Reports | `<HLQ>.RELIEF360.REPORTS` | PS / SYSOUT | `FBA` | 133 | Printable reports with ANSI carriage control |
| Exceptions | `<HLQ>.RELIEF360.EXCEPTIONS` | PS / GDG | `FB` | 250 (approx) | Segregated error and discrepancy records |
| Compliance Audit | `<HLQ>.RELIEF360.AUDIT` | PS / GDG | `FB` | 250 (approx) | Append-only sequential compliance trail |

---

## 3. Allocation Strategy & Dataset Space Guidelines

When allocating these datasets on z/OS (via JCL `SETUP.jcl` or ISPF 3.2):

1. **Source Code PDS/PDSE Allocation:**
   - Space Units: `TRACKS`
   - Primary: 15, Secondary: 10, Directory Blocks: 20 (for PDS) or `DSNTYPE=LIBRARY` (for PDSE).
   - RECFM: `FB`, LRECL: 80, BLKSIZE: 3120 (or 0 for system-determined).

2. **Sequential Batch Files (PS / GDG):**
   - Ensure input, output, and exception files allocate adequate space based on test batch sizes.
   - For GDG bases, define with IDCAMS:
     ```jcl
     //DEFGDG   EXEC PGM=IDCAMS
     //SYSPRINT DD SYSOUT=*
     //SYSIN    DD *
       DEFINE GDG (NAME(<HLQ>.RELIEF360.INPUT.GDG) LIMIT(5) NOEMPTY SCRATCH)
       DEFINE GDG (NAME(<HLQ>.RELIEF360.OUTPUT.GDG) LIMIT(5) NOEMPTY SCRATCH)
     /*
     ```

---

## 4. Execution & Monitoring Operations

1. **Transfer:** Use Zowe Explorer to upload local code into `<HLQ>.RELIEF360.COBOL`, `<HLQ>.RELIEF360.COPYBOOK`, `<HLQ>.RELIEF360.JCL`, etc.
2. **Compile:** Submit compile JCL referencing `<HLQ>.RELIEF360.COBOL(MEMBER)` and concatenating `<HLQ>.RELIEF360.COPYBOOK` in the `SYSLIB` DD.
3. **Run:** Submit `<HLQ>.RELIEF360.JCL(RELIEF360)`.
4. **Inspect:** Review SDSF / JES Spool output. Confirm all steps return `RC=0000` or intended conditional codes.
5. **Audit:** Verify that output records are cataloged in `<HLQ>.RELIEF360.OUTPUT` and exception records in `<HLQ>.RELIEF360.EXCEPTIONS`.
