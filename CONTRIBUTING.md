# RELIEF360 — Team Contribution Guidelines

Welcome to the **RELIEF360** project! To ensure smooth collaboration across all four team members and prevent conflicting mainframe code or dataset definitions, we adhere to a disciplined Git branching and review workflow.

---

## 1. Team Roles & Ownership

Each member owns a distinct functional area of the system:

| Member | Primary Role | Branch Name | Core Directory Ownership |
| :--- | :--- | :--- | :--- |
| **Siddhi** | **Project Lead & Integration Owner** | `siddhi-integration` | `docs/architecture/`, `sql/`, overall repository coordination, integration review |
| **Ritik** | **COBOL & Business Logic Lead** | `ritik-cobol` | `cobol/`, `copybook/` |
| **Ananya** | **JCL & Batch Orchestration Lead** | `ananya-jcl` | `jcl/`, `sort/`, job flow coordination |
| **Rishikesh** | **Test Data & Documentation Lead** | `rishikesh-testdocs` | `testdata/`, `docs/testing/`, `docs/runbook/` |

---

## 2. Standard Branching Strategy

- **`main`**: The stable, production-ready branch. **Direct pushes to `main` are strictly prohibited.**
- **Feature / Member Branches**: Each team member maintains and develops features inside their assigned branch:
  - `siddhi-integration`
  - `ritik-cobol`
  - `ananya-jcl`
  - `rishikesh-testdocs`

---

## 3. Step-by-Step Developer Workflow

Follow this procedure for all additions, fixes, and documentation updates:

### Step 1: Clone the Repository (Initial Setup Only)
```bash
git clone <REPOSITORY_URL>
cd relief360
```
*(Replace `<REPOSITORY_URL>` with your approved repository clone URL).*

### Step 2: Switch to Your Feature Branch & Pull Latest `main`
Always ensure your branch starts from the latest synchronized state:
```bash
git checkout main
git pull origin main
git checkout -b ritik-cobol
# or if branch already exists:
# git checkout ritik-cobol
# git merge main
```

### Step 3: Work Exclusively Within Your Assigned Domain
- Focus changes strictly on your owned directories.
- If your change requires modifying shared artifacts (e.g., modifying a copybook in `copybook/` or changing an interface DD name in `jcl/`), coordinate with the component owner and Siddhi before proceeding.

### Step 4: Verify Local Standards
- **COBOL:** Standard column formatting (Indicator col 7, Area A cols 8-11, Area B cols 12-72).
- **JCL:** Uppercase syntax, standard job card conventions, clean continuation lines.
- **Documentation:** Markdown formatting without broken links or unescaped tags.
- **Security Check:** Ensure **no** mainframe credentials, passwords, or personal connection profiles are staged.

### Step 5: Stage and Commit Changes with Meaningful Messages
```bash
git add .
git commit -m "feat(cobol): Add application field validation routine in AT01VAL"
```

### Step 6: Push to Your Remote Branch
```bash
git push origin ritik-cobol
```

### Step 7: Open a Pull Request (PR) on GitHub
- Target branch: `main`
- Source branch: `ritik-cobol` (or your respective branch)
- Title: Clear description of the change (e.g., `feat(jcl): Implement PREP-APP DFSORT deduplication job`)
- Description: Outline what was changed, what copybooks/datasets are referenced, and testing status.

### Step 8: Peer Review & Integration Sign-Off
- **Siddhi** reviews all pull requests, particularly those affecting Db2 schemas, shared copybooks, dataset naming conventions, or cross-module integration.
- Address any review feedback promptly.

### Step 9: Merge & Re-sync
- Once approved, the PR is merged into `main`.
- All team members pull the updated `main` into their local branches before starting their next task:
```bash
git checkout main
git pull origin main
```

---

## 4. Coding & Collaboration Golden Rules

1. **Never Commit Secrets:** Do not commit passwords, user IDs, host IP addresses, private keys, or personal Zowe configuration profiles.
2. **Use Placeholders:** Use `<HLQ>` for high-level qualifiers and `<DB2_SSID>` for subsystem IDs until college mainframe parameters are officially confirmed.
3. **No Unilateral Interface Changes:** Changing a record layout in `copybook/` impacts COBOL, JCL, DFSORT, and Db2. Discuss any layout change with the entire team first.
4. **Keep Commits Atomic:** Group related changes into small, verifiable commits rather than massive monolithic updates.
