# RELIEF360 — Environment Configuration Guide

This directory houses non-sensitive environment configuration templates, symbolic parameter definition decks, and deployment profiles for the **RELIEF360** mainframe batch system.

---

## 1. Security & Credential Isolation Policy

> [!CAUTION]
> **STRICT SECURITY REQUIREMENT:**  
> NEVER commit actual passwords, API tokens, SSH private keys, personal credentials, or Zowe authentication secrets to this repository.

### Strictly Forbidden in Version Control:
- Real mainframe passwords or RACF/ACF2 passphrases
- Zowe credentials, JWT tokens, or base64 authentication hashes
- Host IP addresses or internal institutional DNS names with credentials
- Personal `.zowe` profile configurations containing secret keys

---

## 2. Using Symbolic Configuration Placeholders

All configuration decks, JCL procedures, and REXX parameters committed here must use standardized symbolic placeholders:

| Placeholder Parameter | Meaning / Description | Example Concrete Value (Applied Locally) |
| :--- | :--- | :--- |
| `<HLQ>` | User or Project High-Level Qualifier | `KC03A01`, `STUDENT1`, `RELIEF` |
| `<DB2_SSID>` | Db2 Subsystem Identifier | `DSN1`, `DB2A`, `DBCG` |
| `<DB2_LOCATION>` | Db2 Network Location Name | `LOC_ZOS_01` |
| `<COBOL_COMP_PROC>` | Site COBOL Compiler JCL Procedure | `IGYWCLG`, `ELAXFCOC` |
| `<LKED_PROC>` | Site Link-Edit JCL Procedure | `IEWL` |
| `<CEE_LIB>` | IBM Language Environment Runtime Library | `CEE.SCEERUN` |
| `<DB2_LOAD_LIB>` | Db2 SDSNLOAD System Library | `DSN.SDSNLOAD` |
| `<SORT_LIB>` | DFSORT / SyncSort System Library | `SYS1.SICELIB` |

---

## 3. Local Configuration Setup

When setting up your local environment or Zowe Explorer profile:
1. Copy template files locally (e.g., `zowe.config.template.json` to your local machine outside Git tracking).
2. Store your active authentication in `.zowe/` in your local user home directory, which is excluded by [.gitignore](../.gitignore).
3. Do not modify committed files with your personal college credentials.
