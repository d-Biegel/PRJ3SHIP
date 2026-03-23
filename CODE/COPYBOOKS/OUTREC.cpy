      ****************************************************************
      * OUTPUT PROCESSED RECORD LAYOUT - WRITING OUT TRANSACTIONS    *
      * FILE: SHIPOUT                                                *
      * RECORD LENGTH: 80 BYTES                                      *
      ****************************************************************
       01 CPY-SHIP-OUTPUT-REC.
           02 OUT-PT0.
              03  FILLER             PIC X(20) VALUE ALL '+'. 
              03  FILLER             PIC X(33) 
                    VALUE 'START OF OUTPUT PROCESSED RECORD'.
              03  FILLER             PIC X(27) VALUE ALL '+'.
           02 OUT-PT1.
              03  LBL-TOTAL-SALES    PIC X(14) 
                    VALUE 'TOTAL SALES: '.
              03  WS-TOTAL-SALES     PIC 9(5) VALUE ZEROES.
              03  FILLER             PIC X(3) VALUE ' | '.
              03  LBL-TOTAL-RETURNS  PIC X(11) VALUE ' RETURNS: '.
              03  WS-TOTAL-RETURNS   PIC 9(5) VALUE ZEROES.
              03  FILLER             PIC X(3) VALUE ' | '.
              03  LBL-TOTAL-CANCELS  PIC X(11) VALUE ' CANCELS: '.
              03  WS-TOTAL-CANCELS   PIC 9(5) VALUE ZEROES.
              03  FILLER             PIC X(23).
           02 OUT-PT2.
              03  LBL-TOTAL-ITEMS    PIC X(19) 
                    VALUE 'TOTAL ITEMS SOLD: '.
              03  WS-TOTAL-ITEMS     PIC 9(9) VALUE ZEROES.
              03  FILLER             PIC X(3) VALUE ' | '.
              03  LBL-TOT-SALES-AMT  PIC X(22)
                    VALUE ' TOTAL SALES AMOUNT: '.
              03  WS-TOTAL-SALES-AMT PIC 9(9)V99 VALUE ZEROES.
              03  FILLER             PIC X(16) VALUE SPACES.
           02 OUT-PT3.
              03  FILLER             PIC X(78) VALUE ALL '+'. 
              03  FILLER             PIC X(2) VALUE SPACES.
           02 OUT-PT4.
              03  WS-EXTENDED-AMT    PIC 9(9)V99 VALUE ZEROES.
              03  FILLER             PIC X(69) VALUE SPACES.
