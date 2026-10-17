# RELIEF360 — COBOL Copybooks

This directory contains standardized COBOL data record definitions (`.cpy`) shared across batch programs and interface datasets.

**Primary Owner:** Ritik (COBOL Lead)  
**Integration Lead:** Siddhi  

---

## Planned Copybook Definitions

| Copybook | Record Name | Description |
| :--- | :--- | :--- |
| **`APPREC.cpy`** | `APPLICATION-RECORD` | Intake and validated disaster relief application record layout (Applicant ID, Damage, Vulnerability, Urgency, Requested/Approved Aid). |
| **`PAYREC.cpy`** | `PAYMENT-RECORD` | Financial institution bank transaction record layout (Payment Ref, Account No, Routing Code, Disbursed Amount). |
| **`BENREC.cpy`** | `BENEFICIARY-RECORD` | Demographic master profile (National ID, Household Key, Full Name, Contact Info). |
| **`EXCREC.cpy`** | `EXCEPTION-RECORD` | Error and discrepancy output record layout (Exception Code, Entity ID, Reason Message, Timestamp). |
| **`AUDREC.cpy`** | `AUDIT-RECORD` | Append-only audit record layout (Audit ID, Job Name, Program ID, Action, Before/After Images). |

---

## Usage Guidelines
- Reference copybooks in COBOL programs using standard syntax:
  ```cobol
         COPY APPREC.
  ```
- Any modification to copybook layouts alters byte offsets across sequential files, DFSORT control cards, and Db2 host variables. All revisions require integration review by Siddhi and Ananya.
