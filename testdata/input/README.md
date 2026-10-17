# RELIEF360 — Test Input Feeds

This directory will contain synthetic, fixed-width Physical Sequential (PS) files representing intake data:

1. **`APPS_RAW.dat`:** Raw unsorted intake application records containing intentional duplicates, invalid bank entries, and unverified records.
2. **`PAY_TRANS.dat`:** Synthetic bank transaction file simulating disbursements from financial institutions.
3. **`TRAILER_CTL.dat`:** Header/trailer control records used by the JCL count quality gate (`VALCNT`).

*(Files will be populated with synthetic test rows by Rishikesh in Phase 1).*
