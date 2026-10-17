# RELIEF360 — DFSORT / IBM SORT Control Cards

This directory contains DFSORT and ICETOOL control card statements (`.srt`) used in JCL batch preprocessing and data scrubbing.

**Primary Owner:** Ananya (JCL & Batch Lead)  
**Integration Lead:** Siddhi  

---

## Planned Control Decks

- **`SRTAPP01.srt`:** Sorts raw application records by primary key (National ID / Household Key) and performs automated duplicate elimination via `SUM FIELDS=NONE` (Academic Assignment #1 integration).
