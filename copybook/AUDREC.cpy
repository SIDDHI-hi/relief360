      *****************************************************************
      * COPYBOOK:    AUDREC
      * SYSTEM:      RELIEF360 - EMERGENCY RELIEF ALLOCATION
      * DESCRIPTION: AUDIT TRAIL LOG RECORD STRUCTURE
      * AUTHOR:      RITIK (COBOL LEAD)
      * INTEGRATION: SIDDHI
      *
      * NOTE:        THIS IS A PHASE 0 IMPLEMENTATION PLACEHOLDER.
      *              DETAILED FIELD OFFSETS & PICTURE CLAUSES WILL BE
      *              FINALIZED IN PHASE 1.
      *****************************************************************
       01  AUDIT-RECORD.
           05  AUD-ID                      PIC X(12).
           05  AUD-BATCH-RUN-ID            PIC X(10).
           05  AUD-PGM-ID                  PIC X(08).
           05  AUD-ACTION-CODE             PIC X(10).
           05  AUD-ENTITY-REF              PIC X(12).
           05  AUD-BEFORE-IMAGE            PIC X(50).
           05  AUD-AFTER-IMAGE             PIC X(50).
           05  AUD-TIMESTAMP               PIC X(26).
           05  AUD-OPERATOR-ID             PIC X(08).
           05  FILLER                      PIC X(04).
