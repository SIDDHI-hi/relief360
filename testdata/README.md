# RELIEF360 — Test Datasets & Test Scenarios

This directory contains synthetic test datasets, expected reconciliation results, and edge-case test scenario specifications for **RELIEF360**.

**Primary Owner:** Rishikesh (Test Data & QA Lead)  
**Integration Lead:** Siddhi  

---

## Directory Organization

- **[`input/`](input/):** Raw fixed-width input sequential test files (applications, bank transaction files, control trailer records).
- **[`expected/`](expected/):** Golden baseline expected output files, exception logs, and formatted reports used for automated diff checks.
- **[`scenarios/`](scenarios/):** Detailed documentation and input combinations covering the 12 master test cases defined in [TEST_STRATEGY.md](../docs/testing/TEST_STRATEGY.md).

---

## Data Privacy & Integrity Notice
All test datasets in this directory are 100% synthetic and generated exclusively for academic and verification testing. They contain no real citizen names, actual national identity numbers, or genuine banking credentials.
