      *****************************************************************
      * PROGRAM NAME: R360TEST                                        *
      * SYSTEM:       RELIEF360 - EMERGENCY RELIEF ALLOCATION         *
      * PURPOSE:      STANDALONE SMOKE TEST AND VERIFICATION PROGRAM  *
      * AUTHOR:       RITIK (COBOL LEAD) - RELIEF360 TEAM             *
      * DESCRIPTION:  VERIFIES Z/OS COBOL COMPILATION AND EXECUTES    *
      *               THE RELIEF360 PRIORITY SCORING ALGORITHM        *
      *               AND STATUTORY AID CAP BUSINESS RULES.           *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.    R360TEST.
       AUTHOR.        RITIK.
      *
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-ZOS.
       OBJECT-COMPUTER. IBM-ZOS.
      *
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *---------------------------------------------------------------*
      * PROGRAM CONSTANTS & HEADERS                                   *
      *---------------------------------------------------------------*
       01  WS-CONSTANTS.
           05  WS-PGM-NAME             PIC X(08) VALUE 'R360TEST'.
           05  WS-VERSION              PIC X(05) VALUE '1.0.0'.
           05  WS-STATUTORY-CAP        PIC 9(07)V99 VALUE 50000.00.
      *
      *---------------------------------------------------------------*
      * TEST RECORD DATA                                              *
      *---------------------------------------------------------------*
       01  WS-TEST-APPLICATIONS.
           05  WS-APP-1.
               10  WS-APP1-ID          PIC X(10) VALUE 'APP-202601'.
               10  WS-APP1-BEN-NAME    PIC X(20) VALUE 'SHARMA, RAJESH     '.
               10  WS-APP1-DAMAGE      PIC 9(03) VALUE 090.
               10  WS-APP1-VULN        PIC 9(03) VALUE 085.
               10  WS-APP1-URGENCY     PIC 9(03) VALUE 080.
               10  WS-APP1-REQUESTED   PIC 9(07)V99 VALUE 0065000.00.
           05  WS-APP-2.
               10  WS-APP2-ID          PIC X(10) VALUE 'APP-202602'.
               10  WS-APP2-BEN-NAME    PIC X(20) VALUE 'VERMA, SUNITA      '.
               10  WS-APP2-DAMAGE      PIC 9(03) VALUE 060.
               10  WS-APP2-VULN        PIC 9(03) VALUE 070.
               10  WS-APP2-URGENCY     PIC 9(03) VALUE 050.
               10  WS-APP2-REQUESTED   PIC 9(07)V99 VALUE 0035000.00.
           05  WS-APP-3.
               10  WS-APP3-ID          PIC X(10) VALUE 'APP-202603'.
               10  WS-APP3-BEN-NAME    PIC X(20) VALUE 'PATEL, AMIT        '.
               10  WS-APP3-DAMAGE      PIC 9(03) VALUE 030.
               10  WS-APP3-VULN        PIC 9(03) VALUE 025.
               10  WS-APP3-URGENCY     PIC 9(03) VALUE 040.
               10  WS-APP3-REQUESTED   PIC 9(07)V99 VALUE 0020000.00.
      *
      *---------------------------------------------------------------*
      * CALCULATION WORK FIELDS                                       *
      *---------------------------------------------------------------*
       01  WS-CALC-FIELDS.
           05  WS-CURR-APP-ID          PIC X(10).
           05  WS-CURR-BEN-NAME        PIC X(20).
           05  WS-CURR-DAMAGE          PIC 9(03).
           05  WS-CURR-VULN            PIC 9(03).
           05  WS-CURR-URGENCY         PIC 9(03).
           05  WS-CURR-REQUESTED       PIC 9(07)V99.
           05  WS-CURR-APPROVED        PIC 9(07)V99.
           05  WS-WEIGHTED-DAMAGE      PIC 9(03)V9999.
           05  WS-WEIGHTED-VULN        PIC 9(03)V9999.
           05  WS-WEIGHTED-URG         PIC 9(03)V9999.
           05  WS-PRIORITY-SCORE       PIC 9(03)V99.
           05  WS-PRIORITY-BAND        PIC X(08).
           05  WS-CAP-FLAG             PIC X(08).
      *
      *---------------------------------------------------------------*
      * FORMATTED DISPLAY EDIT FIELDS                                 *
      *---------------------------------------------------------------*
       01  WS-FORMAT-FIELDS.
           05  WS-DISP-SCORE           PIC ZZ9.99.
           05  WS-DISP-REQ             PIC $$,$$$,$$9.99.
           05  WS-DISP-APP             PIC $$,$$$,$$9.99.
           05  WS-DISP-DAMAGE          PIC ZZ9.
           05  WS-DISP-VULN            PIC ZZ9.
           05  WS-DISP-URG             PIC ZZ9.
      *
       PROCEDURE DIVISION.
       0000-MAIN-CONTROL.
           PERFORM 1000-DISPLAY-HEADER.
      *
      *    PROCESS TEST SCENARIO 1 (HIGH PRIORITY / OVER CAP)
           MOVE WS-APP1-ID        TO WS-CURR-APP-ID.
           MOVE WS-APP1-BEN-NAME  TO WS-CURR-BEN-NAME.
           MOVE WS-APP1-DAMAGE    TO WS-CURR-DAMAGE.
           MOVE WS-APP1-VULN      TO WS-CURR-VULN.
           MOVE WS-APP1-URGENCY   TO WS-CURR-URGENCY.
           MOVE WS-APP1-REQUESTED TO WS-CURR-REQUESTED.
           PERFORM 2000-PROCESS-APPLICATION.
      *
      *    PROCESS TEST SCENARIO 2 (HIGH/NORMAL / WITHIN CAP)
           MOVE WS-APP2-ID        TO WS-CURR-APP-ID.
           MOVE WS-APP2-BEN-NAME  TO WS-CURR-BEN-NAME.
           MOVE WS-APP2-DAMAGE    TO WS-CURR-DAMAGE.
           MOVE WS-APP2-VULN      TO WS-CURR-VULN.
           MOVE WS-APP2-URGENCY   TO WS-CURR-URGENCY.
           MOVE WS-APP2-REQUESTED TO WS-CURR-REQUESTED.
           PERFORM 2000-PROCESS-APPLICATION.
      *
      *    PROCESS TEST SCENARIO 3 (LOW PRIORITY / WITHIN CAP)
           MOVE WS-APP3-ID        TO WS-CURR-APP-ID.
           MOVE WS-APP3-BEN-NAME  TO WS-CURR-BEN-NAME.
           MOVE WS-APP3-DAMAGE    TO WS-CURR-DAMAGE.
           MOVE WS-APP3-VULN      TO WS-CURR-VULN.
           MOVE WS-APP3-URGENCY   TO WS-CURR-URGENCY.
           MOVE WS-APP3-REQUESTED TO WS-CURR-REQUESTED.
           PERFORM 2000-PROCESS-APPLICATION.
      *
           PERFORM 3000-DISPLAY-FOOTER.
           MOVE 0 TO RETURN-CODE.
           GOBACK.
      *
       1000-DISPLAY-HEADER.
           DISPLAY '=================================================='.
           DISPLAY ' RELIEF360: SMOKE TEST & VERIFICATION HARNESS     '.
           DISPLAY ' PROGRAM:   ' WS-PGM-NAME '  VERSION: ' WS-VERSION.
           DISPLAY ' FORMULA:   SCORE = (0.50*DMG) + (0.30*VUL) + (0.20*URG)'.
           DISPLAY ' AID CAP:   $50,000.00 STATUTORY MAXIMUM      '.
           DISPLAY '=================================================='.
           DISPLAY ' '.
           EXIT.
      *
       2000-PROCESS-APPLICATION.
      *    1. COMPUTE 3-FACTOR WEIGHTED PRIORITY SCORE
           COMPUTE WS-WEIGHTED-DAMAGE = WS-CURR-DAMAGE * 0.50.
           COMPUTE WS-WEIGHTED-VULN   = WS-CURR-VULN   * 0.30.
           COMPUTE WS-WEIGHTED-URG    = WS-CURR-URGENCY * 0.20.
           COMPUTE WS-PRIORITY-SCORE  ROUNDED =
               WS-WEIGHTED-DAMAGE + WS-WEIGHTED-VULN + WS-WEIGHTED-URG.
      *
      *    2. DETERMINE PRIORITY BAND
           EVALUATE TRUE
               WHEN WS-PRIORITY-SCORE >= 80.00
                   MOVE 'CRITICAL' TO WS-PRIORITY-BAND
               WHEN WS-PRIORITY-SCORE >= 60.00
                   MOVE 'HIGH    ' TO WS-PRIORITY-BAND
               WHEN WS-PRIORITY-SCORE >= 40.00
                   MOVE 'NORMAL  ' TO WS-PRIORITY-BAND
               WHEN OTHER
                   MOVE 'LOW     ' TO WS-PRIORITY-BAND
           END-EVALUATE.
      *
      *    3. APPLY STATUTORY AID CAP RULE
           IF WS-CURR-REQUESTED > WS-STATUTORY-CAP
               MOVE WS-STATUTORY-CAP  TO WS-CURR-APPROVED
               MOVE 'OVER_CAP'        TO WS-CAP-FLAG
           ELSE
               MOVE WS-CURR-REQUESTED TO WS-CURR-APPROVED
               MOVE 'APPROVED'        TO WS-CAP-FLAG
           END-IF.
      *
      *    4. FORMAT AND DISPLAY TEST CASE RESULTS
           MOVE WS-CURR-DAMAGE    TO WS-DISP-DAMAGE.
           MOVE WS-CURR-VULN      TO WS-DISP-VULN.
           MOVE WS-CURR-URGENCY   TO WS-DISP-URG.
           MOVE WS-PRIORITY-SCORE TO WS-DISP-SCORE.
           MOVE WS-CURR-REQUESTED TO WS-DISP-REQ.
           MOVE WS-CURR-APPROVED  TO WS-DISP-APP.
      *
           DISPLAY '--- [APPLICATION: ' WS-CURR-APP-ID ' - '
                   WS-CURR-BEN-NAME '] ---'.
           DISPLAY '  DAMAGE: ' WS-DISP-DAMAGE
                   '  VULNERABILITY: ' WS-DISP-VULN
                   '  URGENCY: ' WS-DISP-URG.
           DISPLAY '  CALCULATED SCORE: ' WS-DISP-SCORE
                   ' ---> BAND: [' WS-PRIORITY-BAND ']'.
           DISPLAY '  REQUESTED: ' WS-DISP-REQ
                   '  APPROVED: ' WS-DISP-APP
                   ' [' WS-CAP-FLAG ']'.
           DISPLAY ' '.
           EXIT.
      *
       3000-DISPLAY-FOOTER.
           DISPLAY '=================================================='.
           DISPLAY ' RELIEF360 TEST EXECUTION COMPLETED SUCCESSFULLY. '.
           DISPLAY ' RETURN CODE: 0000                                '.
           DISPLAY '=================================================='.
           EXIT.
