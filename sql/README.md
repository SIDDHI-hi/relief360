# RELIEF360 — Relational Database Architecture (Db2 for z/OS)

This directory contains Db2 for z/OS artifacts for **RELIEF360**, including Data Definition Language (DDL) schemas, Data Manipulation Language (DML) reference data, operational queries, and embedded SQL bind packages.

**Primary Owner:** Siddhi (Project Lead & Db2 Architecture Owner)  

---

## Directory Organization

- **[`ddl/`](ddl/):** Table definitions, primary/foreign keys, indexes, and storage space specifications.
- **[`dml/`](dml/):** Initial seed data, configuration lookups, and test reference rows.
- **[`queries/`](queries/):** Operational verification queries, reconciliation checks, and audit reports.
- **[`db2/`](db2/):** Embedded SQL plan bind scripts (`DSN` commands) and coprocessor definitions.

---

## Planned Db2 Entities Overview

1. **`BENEFICIARY`:** Master demographic record of citizen/applicant (National ID, Full Name, Household ID, Region, Contact Details).
2. **`APPLICATION`:** Intake application record (Application ID, Beneficiary ID, Damage Assessment, Vulnerability, Urgency, Calculated Priority, Aid Requested, Aid Approved, Status).
3. **`PAYMENT`:** Bank transaction record (Payment Ref, Application ID, Account Number, Routing Code, Disbursed Amount, Timestamp, Status).
4. **`COMPLAINT`:** Grievance or dispute record holding disbursement until resolved (Complaint ID, Application ID, Category, Description, Status).
5. **`EXCEPTION_LOG`:** Segregated log of anomalies (Exception ID, Batch Run ID, Entity Ref, Reason Code, Description, Timestamp).
6. **`AUDIT_LOG`:** Append-only compliance log capturing all transactional state changes (Audit ID, Batch Run ID, Program ID, Action, Before/After Images, Timestamp).
7. **`BATCH_RUN`:** Execution checkpoint ledger tracking batch run status (Run ID, Job Name, Start Time, End Time, Counts, Return Code, Checkpoint Step).

*(Note: Concrete SQL scripts will be developed in Phase 1 following the configuration of the college Db2 subsystem name, bufferpools, and storage groups).*
