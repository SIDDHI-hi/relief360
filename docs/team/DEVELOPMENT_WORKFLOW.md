# RELIEF360 — Beginner-Friendly Development Workflow

Welcome to mainframe engineering with **RELIEF360**! If you are new to the relationship between modern code editors, Git/GitHub, and IBM z/OS mainframes, this guide explains every step simply and clearly.

---

## 1. The Big Picture: How Everything Connects

You will develop source code on your local computer using the **Antigravity IDE**, manage versions through **Git & GitHub**, transfer files to the mainframe using **Zowe Explorer**, and run your jobs on **IBM z/OS**.

```
+-----------------------------------------------------------------------------------+
| 1. Antigravity IDE (Your Local Editor)                                            |
|    You write COBOL, JCL, Copybooks, or REXX scripts on your machine.              |
+-----------------------------------------┬-----------------------------------------+
                                          │
                                          ▼
+-----------------------------------------------------------------------------------+
| 2. Local Project Directory (relief-360)                                           |
|    Your files are organized cleanly in folders like cobol/, jcl/, copybook/.       |
+-----------------------------------------┬-----------------------------------------+
                                          │
                                          ▼
+-----------------------------------------------------------------------------------+
| 3. Git (Version Control on Your PC)                                               |
|    You snapshot your work on your personal branch (e.g., ritik-cobol).            |
+-----------------------------------------┬-----------------------------------------+
                                          │
                                          ▼
+-----------------------------------------------------------------------------------+
| 4. GitHub (Shared Team Cloud Repository)                                          |
|    You push your code so teammates and Siddhi can review it in a Pull Request.    |
+-----------------------------------------┬-----------------------------------------+
                                          │
                                          ▼
+-----------------------------------------------------------------------------------+
| 5. Zowe Explorer (The Mainframe Bridge)                                           |
|    Uploads your code from your PC into partitioned datasets (PDS) on z/OS.        |
+-----------------------------------------┬-----------------------------------------+
                                          │
                                          ▼
+-----------------------------------------------------------------------------------+
| 6. IBM z/OS (The Mainframe Operating System)                                      |
|    Where the code actually lives as datasets (<HLQ>.RELIEF360.COBOL, etc.).       |
+-----------------------------------------┬-----------------------------------------+
                                          │
                                          ▼
+-----------------------------------------------------------------------------------+
| 7. Compile / Run (Batch Execution)                                                |
|    You submit a compile job or run JCL. The mainframe executes your code.         |
+-----------------------------------------┬-----------------------------------------+
                                          │
                                          ▼
+-----------------------------------------------------------------------------------+
| 8. Results / Error Inspection (JES / SDSF)                                        |
|    You check the output spool: Did it finish with RC=0000, or did it fail/abend? |
+-----------------------------------------┬-----------------------------------------+
                                          │
                   ┌──────────────────────┴──────────────────────┐
                   │                                             │
      If errors occur (RC > 4 or Abend):            If successful (RC=0000):
                   ▼                                             ▼
+-------------------------------------+       +-------------------------------------+
| 9. Fix (Back to Antigravity IDE)    |       | 10. Push Working Code to GitHub     |
|    Correct the bug locally, upload  |       |     Merge PR to main, share victory |
|    via Zowe, and re-test.           |       |     with the entire team!           |
+-------------------------------------+       +-------------------------------------+
```

---

## 2. Detailed Step-by-Step Walkthrough

### Step 1: Write or Edit Code in Antigravity IDE
Open your local `relief-360` folder. Edit your assigned files:
- Ritik: edit files in `cobol/` or `copybook/`.
- Ananya: edit files in `jcl/` or `sort/`.
- Rishikesh: edit files in `testdata/` or `docs/`.
- Siddhi: edit files in `sql/` or `docs/architecture/`.

### Step 2: Track Your Changes with Git
Open your local terminal in the project root:
```bash
# Check what files you changed
git status

# Add your changes to the staging area
git add .

# Save your snapshot with a clear message
git commit -m "feat(cobol): Add bank validation checks to AT01VAL"
```

### Step 3: Push Your Branch to GitHub
```bash
git push origin <your-branch-name>
# Example: git push origin ritik-cobol
```
*GitHub stores your latest code safely in the cloud.*

### Step 4: Transfer Code to z/OS Using Zowe Explorer
1. Open the **Zowe Explorer** pane in your editor.
2. Connect to your college z/OS profile.
3. Locate your assigned Partitioned Dataset (PDS), for example:
   `<HLQ>.RELIEF360.COBOL` or `<HLQ>.RELIEF360.JCL`
4. Copy or upload your local file as a member into the corresponding PDS.

### Step 5: Compile and Submit on z/OS
1. In Zowe Explorer, navigate to your compile JCL or run JCL.
2. Right-click the JCL member and choose **Submit Job** (or use the command line `zowe jobs submit ds "<HLQ>.RELIEF360.JCL(COMPILE)"`).
3. Take note of the generated **Job ID** (e.g., `JOB01234`).

### Step 6: Inspect Results in JES Spool / SDSF
1. Look at the return code:
   - `RC=0000`: Perfect success.
   - `RC=0004`: Warning (review compiler messages, but execution succeeded).
   - `RC=0008`: Error (compilation or step failed, must be corrected).
   - `ABEND S0C7`: Data exception (usually non-numeric data in a numeric field).
   - `ABEND S0C4`: Storage protection violation / subscript out of bounds.
2. Read the `SYSPRINT` and `SYSOUT` listings in the spool to identify the exact line or issue.

### Step 7: Fix, Repeat, and Celebrate
1. Modify your local file in Antigravity IDE.
2. Re-upload to z/OS and re-submit the job until it yields `RC=0000`.
3. Commit and push the working code to GitHub!
4. Create a Pull Request so Siddhi can review and merge your clean work into `main`.

---

## 3. Important Reminders for Beginners

- **GitHub does NOT run your mainframe code:** GitHub only stores the code. The mainframe runs the code.
- **Always keep backups:** Before making risky experimental changes on the mainframe directly, ensure your code is safely committed in Git.
- **Respect COBOL formatting:** Keep COBOL Area A (columns 8-11) and Area B (columns 12-72) properly aligned.
- **Respect JCL syntax:** JCL statements must begin with `//` in columns 1-2.
