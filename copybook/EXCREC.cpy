      *****************************************************************
      * COPYBOOK:    EXCREC
      * SYSTEM:      RELIEF360 - EMERGENCY RELIEF ALLOCATION
      * DESCRIPTION: EXCEPTION AND ANOMALY RECORD STRUCTURE
      * AUTHOR:      RITIK (COBOL LEAD)
      * INTEGRATION: SIDDHI
      *
      * NOTE:        THIS IS A PHASE 0 IMPLEMENTATION PLACEHOLDER.
      *              DETAILED FIELD OFFSETS & PICTURE CLAUSES WILL BE
      *              FINALIZED IN PHASE 1.
      *****************************************************************
       01  EXCEPTION-RECORD.
           05  EXC-ID                      PIC X(12).
           05  EXC-BATCH-RUN-ID            PIC X(10).
           05  EXC-ENTITY-TYPE             PIC X(08).
           05  EXC-ENTITY-REF-ID           PIC X(12).
           05  EXC-CODE                    PIC X(16).
           05  EXC-REASON-TEXT             PIC X(60).
           05  EXC-TIMESTAMP               PIC X(26).
           05  FILLER                      PIC X(16).
