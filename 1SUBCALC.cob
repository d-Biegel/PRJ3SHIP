      **************************************************************
      *
      *  PROGRAM ID SUBCALC
      *  DATE CREATED:  07MAR2026
      *
      * SUBPROGRAM THAT CALCULATES THE VALUES USED IN ORDERSYS.
      * NEEDS TO BE COMPILED ON ITS OWN BEFOREHAND
      *
      *  CHANGE LOG
      *  USER ID     DATE     CHANGE DESCRIPTION
      * ---------   ------    -------------------------------------
      *  DAN BIEG   07MAR2026 CODE PROG
      **************************************************************
       IDENTIFICATION DIVISION.                               
      **************************************************************
       PROGRAM-ID SUBCALC.     

      **************************************************************
       ENVIRONMENT DIVISION.     
      **************************************************************

      **************************************************************
       DATA DIVISION.   
      **************************************************************

       LINKAGE SECTION.               
        01  LS-ORDER-NO        PIC X(6).
        01  LS-CUST-NAME       PIC X(10).
        01  LS-ITEM-CODE       PIC X(3).
        01  LS-QUANTITY        PIC 9(5).
        01  LS-UNIT-PRICE      PIC 9(5)V99.
        01  LS-TRANS-TYPE      PIC X(1).

        01  LS-EXTENDED-AMT    PIC 9(9)V99 VALUE ZEROES.
        01  LS-TOTAL-SALES     PIC 9(5) VALUE ZEROES. 
        01  LS-TOTAL-ITEMS     PIC 9(9) VALUE ZEROES.
        01  LS-TOTAL-SALES-AMT PIC 9(9)V99 VALUE ZEROES.
        01  LS-TOTAL-RETURNS   PIC 9(5) VALUE ZEROES.
        01  LS-TOTAL-CANCELS   PIC 9(5) VALUE ZEROES.

      **************************************************************
       PROCEDURE DIVISION USING LS-ORDER-NO, LS-CUST-NAME,
                 LS-ITEM-CODE, LS-QUANTITY, LS-UNIT-PRICE,
                 LS-TRANS-TYPE, LS-EXTENDED-AMT, LS-TOTAL-SALES
                 LS-TOTAL-ITEMS, LS-TOTAL-SALES-AMT, 
                 LS-TOTAL-RETURNS, LS-TOTAL-CANCELS.    
      **************************************************************

           DISPLAY ' >> '.
           DISPLAY '  WE ARE IN A CALLED PROGRAM'.   
           DISPLAY ' >> '.
      
           COMPUTE LS-EXTENDED-AMT =
                    LS-QUANTITY * LS-UNIT-PRICE.

              IF LS-TRANS-TYPE = 'S'
                 ADD 1 TO LS-TOTAL-SALES
                 ADD LS-QUANTITY TO LS-TOTAL-ITEMS
                 ADD LS-EXTENDED-AMT TO LS-TOTAL-SALES-AMT
              .

              IF LS-TRANS-TYPE = 'R'
                 ADD 1 TO LS-TOTAL-RETURNS
              .

              IF LS-TRANS-TYPE = 'C'
                 ADD 1 TO LS-TOTAL-CANCELS
              .

           GOBACK. 