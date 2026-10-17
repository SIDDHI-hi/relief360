# RELIEF360 — Test Scenarios & Edge Cases

This directory documents test data permutations mapping directly to the 12 master test cases defined in [TEST_STRATEGY.md](../../docs/testing/TEST_STRATEGY.md):

- **Scenario 01:** Standard Verified Application (Happy Path)
- **Scenario 02:** Unverified Application Routing (`NOT_VERIFIED`)
- **Scenario 03:** Primary & Secondary Duplicate Suppression (`DUPLICATE`)
- **Scenario 04:** Malformed Bank Account Number / Routing (`BANK_INVALID`)
- **Scenario 05:** Requested Aid Exceeding Cap (`OVER_CAP`)
- **Scenario 06:** Perfect Reconciliation Match (`MATCHED`)
- **Scenario 07:** Approved Allocation Missing in Bank Ledger (`PAYMENT_MISSING`)
- **Scenario 08:** Disbursed Amount Differs from Approved (`PAYMENT_MISMATCH`)
- **Scenario 09:** Active Citizen Dispute Hold (`COMPLAINT_PENDING`)
- **Scenario 10:** Catastrophic Disaster Triage (Priority Band `CRITICAL`)
- **Scenario 11:** Record Count Mismatch Quality Gate Trip (`VALCNT`)
- **Scenario 12:** Mid-Stream Step Abend & Checkpoint Recovery (`RRESTART`)
