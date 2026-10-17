      *****************************************************************
      * COPYBOOK:    BENREC
      * SYSTEM:      RELIEF360 - EMERGENCY RELIEF ALLOCATION
      * DESCRIPTION: BENEFICIARY DEMOGRAPHIC RECORD STRUCTURE
      * AUTHOR:      RITIK (COBOL LEAD)
      * INTEGRATION: SIDDHI
      *
      * NOTE:        THIS IS A PHASE 0 IMPLEMENTATION PLACEHOLDER.
      *              DETAILED FIELD OFFSETS & PICTURE CLAUSES WILL BE
      *              FINALIZED IN PHASE 1.
      *****************************************************************
       01  BENEFICIARY-RECORD.
           05  BEN-ID                      PIC X(10).
           05  BEN-NATIONAL-ID             PIC X(12).
           05  BEN-HOUSEHOLD-ID            PIC X(10).
           05  BEN-FULL-NAME               PIC X(40).
           05  BEN-REGION                  PIC X(15).
           05  BEN-CONTACT-PHONE           PIC X(12).
           05  FILLER                      PIC X(31).
