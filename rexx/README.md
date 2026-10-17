# RELIEF360 — REXX Operational & Monitoring Scripts

This directory contains REXX scripts (`.rex`) designed to run under TSO/E, ISPF, or batch JCL (`IKJEFT01`) for operational monitoring, status reporting, restart verification, and ad-hoc data processing.

**Integration Lead:** Siddhi  
**Operational Lead:** Ananya & Rishikesh  

---

## Planned REXX Scripts

| Script Name | Purpose & Functionality |
| :--- | :--- |
| **`RMONITOR.rex`** | Inspects active batch job execution status, SDSF job streams, and system health metrics. |
| **`RSTATUS.rex`** | Reads batch status records from Db2 `BATCH_RUN` or dataset checkpoints to report progress and completion percentages. |
| **`RREPORT.rex`** | Parses report outputs and generates an operational digest for system supervisors. |
| **`RRESTART.rex`** | Analyzes abended job states and determines the exact step name and dataset condition for safe JCL restart. |
| **`RDEDUP.rex`** | Standalone REXX deduplication and validation utility (Assignment #3 integration) for interactive dataset cleanup without running full batch JCL. |
