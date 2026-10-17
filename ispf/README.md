# RELIEF360 — Interactive System Productivity Facility (ISPF / 3270)

This directory is reserved for future ISPF dialog manager components, including 3270 display panels, message members, file tailoring skeletons, and command tables.

**Integration Lead:** Siddhi  

---

## Planned 3270 / ISPF Components

- **`panels/` (`PANELS`):** 3270 screen definitions formatted with ISPF panel control characters (`ATTR`, `BODY`, `INIT`, `PROC` sections):
  - `R360MNU`: Primary relief management menu.
  - `R360APP`: Citizen application query and status review screen.
  - `R360REC`: Payment reconciliation status and mismatch inspector.
  - `R360EXC`: Exception review and supervisor override screen.
  - `R360OPS`: Batch execution trigger and REXX monitor display.
- **`messages/` (`MSGS`):** System message members defining informational, warning, and error text displayed on 3270 terminals.
- **`skeletons/` (`SKELS`):** JCL file-tailoring templates dynamically populated with dataset names and submitted via ISPF dialog functions (`FTOPEN`, `FTINCL`, `FTCLOSE`).

*(Note: Implementation of interactive 3270 panels will take place in later project phases following batch core stability).*
