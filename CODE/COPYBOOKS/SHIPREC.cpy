      ****************************************************************
      * INVENTORY INPUT FILE RECORD LAYOUT                           *
      * FILE: SHIPIN                                                 *
      * RECORD LENGTH: 80 BYTES                                      *
      ****************************************************************
       01  CPY-SHIP-INPUT-REC.
           05  SI-ORDER-NO        PIC X(6).
           05  SI-CUST-NAME       PIC X(10).
           05  SI-ITEM-CODE       PIC X(3).
           05  SI-QUANTITY        PIC 9(5).
           05  SI-UNIT-PRICE      PIC 9(5)V99.
           05  SI-TRANS-TYPE      PIC X(1).
           05  SI-FILLER          PIC X(48).
