      *****************************************************************
      * COPYBOOK:    PAYREC
      * SYSTEM:      RELIEF360 - EMERGENCY RELIEF ALLOCATION
      * DESCRIPTION: BANK PAYMENT TRANSACTION RECORD STRUCTURE
      * AUTHOR:      RITIK (COBOL LEAD)
      * INTEGRATION: SIDDHI
      *
      * NOTE:        THIS IS A PHASE 0 IMPLEMENTATION PLACEHOLDER.
      *              DETAILED FIELD OFFSETS & PICTURE CLAUSES WILL BE
      *              FINALIZED IN PHASE 1.
      *****************************************************************
       01  PAYMENT-RECORD.
           05  PAY-REF-ID                  PIC X(12).
           05  PAY-APP-ID                  PIC X(10).
           05  PAY-ROUTING-CODE            PIC X(09).
           05  PAY-ACCOUNT-NO              PIC X(16).
           05  PAY-AMOUNT                  PIC 9(07)V99.
           05  PAY-DATE                    PIC X(08).
           05  PAY-RECON-STATUS            PIC X(10).
           05  FILLER                      PIC X(28).
