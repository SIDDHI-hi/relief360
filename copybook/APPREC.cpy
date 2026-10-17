      *****************************************************************
      * COPYBOOK:    APPREC
      * SYSTEM:      RELIEF360 - EMERGENCY RELIEF ALLOCATION
      * DESCRIPTION: APPLICATION RECORD STRUCTURE (INTAKE & PROCESSED)
      * AUTHOR:      RITIK (COBOL LEAD)
      * INTEGRATION: SIDDHI
      *
      * NOTE:        THIS IS A PHASE 0 IMPLEMENTATION PLACEHOLDER.
      *              DETAILED FIELD OFFSETS & PICTURE CLAUSES WILL BE
      *              FINALIZED IN PHASE 1.
      *****************************************************************
       01  APPLICATION-RECORD.
           05  APP-ID                      PIC X(10).
           05  APP-BENEFICIARY-ID          PIC X(10).
           05  APP-HOUSEHOLD-ID            PIC X(10).
           05  APP-STATUS                  PIC X(10).
           05  APP-VERIFIED-FLAG           PIC X(01).
           05  APP-DAMAGE-SCORE            PIC 9(03).
           05  APP-VULN-SCORE              PIC 9(03).
           05  APP-URGENCY-SCORE           PIC 9(03).
           05  APP-PRIORITY-SCORE          PIC 9(03)V99.
           05  APP-PRIORITY-BAND           PIC X(08).
           05  APP-REQUESTED-AID           PIC 9(07)V99.
           05  APP-APPROVED-AID            PIC 9(07)V99.
           05  APP-BANK-ROUTING            PIC X(09).
           05  APP-BANK-ACCOUNT            PIC X(16).
           05  FILLER                      PIC X(30).
