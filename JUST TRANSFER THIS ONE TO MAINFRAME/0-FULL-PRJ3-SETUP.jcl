//FULLP3 JOB  (SETUP),                                               
//             'FULL PRJ3 STUP',                                      
//             CLASS=A,                                               
//             MSGCLASS=X,                                            
//             MSGLEVEL=(0,0),                                        
//             NOTIFY=&SYSUID                                         
//********************************************************************
//*   -----------------    FULL PRJ3 FILE SETUP    ----------------- 
//********************************************************************
//* DELETE PRIOR VERSIONS OF SOURCE AND OBJECT DATASETS               *
//*********************************************************************
//*                                                          
//IDCAMS  EXEC PGM=IDCAMS,REGION=1024K                       
//SYSPRINT DD  SYSOUT=*                                      
//SYSIN    DD  *                                             
    DELETE PRJ3.DEV.BCOB NONVSAM SCRATCH PURGE               
    DELETE PRJ3.DEV.COPYBOOK NONVSAM SCRATCH PURGE           
    DELETE PRJ3.DEV.JCL NONVSAM SCRATCH PURGE                
    DELETE PRJ3.DEV.LOADLIB NONVSAM SCRATCH PURGE 
    DELETE PRJ3.DEV.INPUT.SHIPIN NONVSAM                                 
    SET MAXCC=0
/*                                                           
//*   
//*********************************************************************
//* CREATE A PDS WITH PROGRAM SOURCE                                  *
//*********************************************************************
//*                                                                    
//STEP01 EXEC PGM=IEBUPDTE,REGION=1024K,PARM=NEW                      
//SYSPRINT DD  SYSOUT=*                                                 
//*                                                                     
//SYSUT2   DD  DSN=PRJ3.DEV.BCOB,DISP=(,CATLG,DELETE),             
//             UNIT=TSO,SPACE=(TRK,(15,,2)),                            
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=800)                      
//SYSPRINT DD  SYSOUT=*                                                 
//SYSIN    DD  DATA,DLM='><'                                            
./ ADD NAME=SUBCALC,LIST=ALL
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
./ ADD NAME=ORDERSYS,LIST=ALL 
      **************************************************************
      *
      *  PROGRAM ID ORDERSYS
      *  DATE CREATED:  03MAR2026
      *
      * TAKE INPUT DATA FROM A FILE, FORMAT IT FOR 
      * OUTPUT AND CALCULATE NUMBER OF ITEMS SOLD AND 
      * TALLY THE TOTAL KINDS OF EACH TRANSACTION
      *
      *  CHANGE LOG
      *  USER ID     DATE     CHANGE DESCRIPTION
      * ---------   ------    -------------------------------------
      *  DAN BIEG   03MAR2026 CODE PROG
      **************************************************************
       IDENTIFICATION DIVISION.                               
      **************************************************************
       PROGRAM-ID. ORDERSYS.  

      **************************************************************
       ENVIRONMENT DIVISION.
      **************************************************************

       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-370.
       OBJECT-COMPUTER. IBM-370. 

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.
           SELECT FILE-SHIPIN ASSIGN TO UT-S-SHIPIN.
           SELECT FILE-SHIPOUT ASSIGN TO UT-S-SHIPOUT.

      **************************************************************
       DATA DIVISION.
      **************************************************************

       FILE SECTION.

      * IF THERE IS A PROBLEM, MOST LIKELY ITS HOW I'M
      * READING IN THE FILE

      *READ IN
       FD  FILE-SHIPIN
              LABEL RECORDS ARE OMITTED       
              BLOCK CONTAINS 0 RECORDS            
              DATA RECORD IS FIL-SHIPIN. 

       01  FIL-SHIPIN         PIC X(80). 

      * ---

      *WRITE OUT
       FD  FILE-SHIPOUT
              LABEL RECORDS ARE OMITTED   
              BLOCK CONTAINS 0 RECORDS       
              DATA RECORD IS FIL-SHIPOUT. 

       01  FIL-SHIPOUT       PIC X(80).

      **************************************************************
       WORKING-STORAGE SECTION.
      **************************************************************

      * USE THE COPYBOOKS

      *    USE TO READ IN DATA
       01  SHIP-INPUT-REC COPY SHIPREC.

      *    TOTAL VARS + USE TO WRITE TO OUTPUT
       01  SHIP-OUTPUT-REC COPY OUTREC.

      * SEPERATORS AND MESSAGES
       01  WS-BREAKPT     PIC X(25) VALUE '-=-=-=-=-=-=-=-=-=-=-=-=-'.
       01  WS-MESSAGE     PIC X(25) VALUE 'ORDER SUMMARY REPORT GEN!'.
       01  WS-LINE-SPACE  PIC X(25) VALUE SPACES.

      * FLAGS
       01  WS-VAL.
           02  WS-EOF-SHIPIN     PIC X VALUE 'N'.

      **************************************************************
       PROCEDURE DIVISION.
      **************************************************************

           DISPLAY WS-BREAKPT.
           DISPLAY WS-MESSAGE.
           DISPLAY WS-BREAKPT.

      *    OPEN FILES AND READ FIRST RECORD
           PERFORM R1000-OPEN-DATASETS.

      *    ADD DATA HEADER

      *    START MAIN LOOP 
           PERFORM R2000-PROCESS-RECORD
              UNTIL WS-EOF-SHIPIN = 'Y'.

           PERFORM R3000-CRAFT-SUMMARY.

      *    CLOSE OUT FILES
           PERFORM R4000-CLOSE-DATASETS.

           STOP RUN.

      *  ------
        R1000-OPEN-DATASETS.
      *  ------
           DISPLAY '  R1000 OPEN DATASETS'.
           OPEN INPUT  FILE-SHIPIN.
           OPEN OUTPUT FILE-SHIPOUT.


      *  ------
        R1100-READ-LIC-ENTRY.
      *  ------
           DISPLAY '  R1100 READ ENTRY'.
           READ FILE-SHIPIN INTO SHIP-INPUT-REC 
                 AT END MOVE 'Y' TO WS-EOF-SHIPIN.

      *  ------
        R2000-PROCESS-RECORD.
      *  ------
           DISPLAY '  R2000 PROCESS REC'.
           PERFORM R1100-READ-LIC-ENTRY.

      *    IN CASE OF ABEND, MOST LIKELY DUE TO MISALIGNED DATA
           DISPLAY ' -- START DEBUG COPYBOOK DATA --'.  
           DISPLAY '    SI-ORDER-NO: ' SI-ORDER-NO.     
           DISPLAY '   SI-CUST-NAME: ' SI-CUST-NAME.    
           DISPLAY '   SI-ITEM-CODE: ' SI-ITEM-CODE.    
           DISPLAY '    SI-QUANTITY: ' SI-QUANTITY.     
           DISPLAY '  SI-UNIT-PRICE: ' SI-UNIT-PRICE.   
           DISPLAY '  SI-TRANS-TYPE: ' SI-TRANS-TYPE.   
           DISPLAY ' -- END DEBUG COPYBOOK DATA --'.    
           

      **    LV1 IF 
           IF WS-EOF-SHIPIN = 'N'
      *    USING SUBPROGRAM TO CALC OUT THE VALUES
              CALL 'SUBCALC' USING SI-ORDER-NO, SI-CUST-NAME,
                 SI-ITEM-CODE, SI-QUANTITY, SI-UNIT-PRICE,
                 SI-TRANS-TYPE, WS-EXTENDED-AMT, WS-TOTAL-SALES
                 WS-TOTAL-ITEMS, WS-TOTAL-SALES-AMT, 
                 WS-TOTAL-RETURNS, WS-TOTAL-CANCELS.  

      
      *       COMPUTE WS-EXTENDED-AMT =
      *             SI-QUANTITY * SI-UNIT-PRICE.


      **    LV2 IF - IF S
      *       IF SI-TRANS-TYPE = 'S'
      *          ADD 1 TO WS-TOTAL-SALES
      *          ADD SI-QUANTITY TO WS-TOTAL-ITEMS
      *          ADD WS-EXTENDED-AMT TO WS-TOTAL-SALES-AMT
      **CHECK IF ABOVE VALID IN COBOL 68
      *       .


      **    LV2 IF - IF R
      *       IF SI-TRANS-TYPE = 'R'
      *          ADD 1 TO WS-TOTAL-RETURNS
      *       .


      **    LV2 IF - IF C
      *       IF SI-TRANS-TYPE = 'C'
      *          ADD 1 TO WS-TOTAL-CANCELS
      *       .

              DISPLAY 'PROCESSED ORDER: ' SI-ORDER-NO.
              DISPLAY WS-BREAKPT.
              DISPLAY WS-LINE-SPACE.

      *    LV1 IF END
           .


      *  ------
        R3000-CRAFT-SUMMARY.
      *  ------
           DISPLAY '  R3000 CRAFT SUMMARY'. 
           MOVE SPACES TO FIL-SHIPOUT.

      *    USE COPYBOOK TO WRITE TO OUTPUT LINE BY LINE
           MOVE OUT-PT0 TO FIL-SHIPOUT.
           WRITE FIL-SHIPOUT.
           MOVE SPACES TO FIL-SHIPOUT.

           MOVE OUT-PT1 TO FIL-SHIPOUT.
           WRITE FIL-SHIPOUT.
           MOVE SPACES TO FIL-SHIPOUT.

           MOVE OUT-PT2 TO FIL-SHIPOUT.
           WRITE FIL-SHIPOUT.
           MOVE SPACES TO FIL-SHIPOUT.

           MOVE OUT-PT3 TO FIL-SHIPOUT.
           WRITE FIL-SHIPOUT.
           MOVE SPACES TO FIL-SHIPOUT.


      * ------------------
        R4000-CLOSE-DATASETS.
      * ------------------
           DISPLAY '  R4000 CLOSE DATA'.
           CLOSE FILE-SHIPIN.
           CLOSE FILE-SHIPOUT.
./ ENDUP 
><       
/*  
//*********************************************************************
//* CREATE A PDS WITH COPYBOOKS                                       *
//*********************************************************************
//*                                                                    
//STEP02 EXEC PGM=IEBUPDTE,REGION=1024K,PARM=NEW                     
//SYSPRINT DD  SYSOUT=*                                                
//*                                                                    
//SYSUT2   DD  DSN=PRJ3.DEV.COPYBOOK,DISP=(,CATLG,DELETE),            
//             UNIT=TSO,SPACE=(TRK,(15,,2)),                           
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=800)                     
//SYSPRINT DD  SYSOUT=*                                                
//SYSIN    DD  DATA,DLM='><'                                           
./ ADD NAME=OUTREC,LIST=ALL  
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
./ ADD NAME=SHIPREC,LIST=ALL 
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
./ ENDUP 
><       
/*  
//*********************************************************************
//* CREATE A PDS WITH JCL                                             *
//*********************************************************************
//*                                                                    
//STEP03 EXEC PGM=IEBUPDTE,REGION=1024K,PARM=NEW                     
//SYSPRINT DD  SYSOUT=*                                                
//*                                                                    
//SYSUT2   DD  DSN=PRJ3.DEV.JCL,DISP=(,CATLG,DELETE),            
//             UNIT=TSO,SPACE=(TRK,(15,,2)),                           
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=800)                     
//SYSPRINT DD  SYSOUT=*                                                
//SYSIN    DD  DATA,DLM='><'                                           
./ ADD NAME=CMP1SUBP,LIST=ALL  
//CMPSUBPA JOB (SETUP),                                      
//             'COMPILE SUBPROGRAM',                         
//             CLASS=A,                                      
//             MSGCLASS=H,                                   
//             MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID                                    
//********************************************************************
//* STEP 1: COMPILE THE COBOL SUBPROGRAM
//********************************************************************
//COMPILE1 EXEC COBUCL                                       
//COB.SYSLIB DD DSNAME=PRJ3.DEV.COPYBOOK,DISP=SHR           
//COB.SYSIN DD DSNAME=PRJ3.DEV.BCOB(SUBCALC),DISP=SHR       
//COB.SYSLIN DD DSNAME=PRJ3.DEV.LOADLIB,DISP=SHR    
//********************************************************************
//* STEP 2: LINK-EDIT THE OBJECT CODE                                 
//********************************************************************
//LKED.SYSLMOD DD DSNAME=PRJ3.DEV.LOADLIB(SUBCALC),DISP=SHR 
//LKED.SYSLIN  DD DSNAME=PRJ3.DEV.LOADLIB,DISP=SHR          
//LKED.SYSLIB DD DSNAME=SYS1.COBLIB,DISP=SHR                 
//            DD DSNAME=SYS1.LINKLIB,DISP=SHR                
//SYSPRINT DD SYSOUT=*                                       
//                     
./ ADD NAME=CMP2ORDR,LIST=ALL
//CMPPRJ3A JOB (001),'COMPILE ORDERSYS',                            
//             CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1),                     
//             NOTIFY=&SYSUID                                   
//********************************************************************
//* STEP 1: COMPILE THE COBOL PROGRAM                                 
//********************************************************************
//COBSTEP EXEC PGM=IKFCBL00,REGION=4096K,                             
//             PARM='LIB,LOAD,LIST,NOSEQ,SIZE=2048K,BUF=1024K'        
//STEPLIB  DD DSN=SYS1.COBLIB,DISP=SHR                                
//SYSLIB   DD DSN=PRJ3.DEV.COPYBOOK,DISP=SHR                         
//SYSIN    DD DSN=PRJ3.DEV.BCOB(ORDERSYS),DISP=SHR                 
//SYSPRINT DD SYSOUT=*                                                
//SYSPUNCH DD SYSOUT=B                                                
//SYSLIN   DD DSN=&&LOADSET,UNIT=SYSDA,DISP=(MOD,PASS),               
//            SPACE=(80,(500,100))                                    
//SYSUT1   DD UNIT=SYSDA,SPACE=(460,(700,100))                        
//SYSUT2   DD UNIT=SYSDA,SPACE=(460,(700,100))                        
//SYSUT3   DD UNIT=SYSDA,SPACE=(460,(700,100))                        
//SYSUT4   DD UNIT=SYSDA,SPACE=(460,(700,100))                        
//********************************************************************
//* STEP 2: LINK-EDIT THE OBJECT CODE                                 
//********************************************************************
//LKED    EXEC PGM=IEWL,REGION=256K,PARM='LIST,XREF,LET',             
//             COND=(5,LT,COBSTEP)                                    
//SYSLIN   DD DSN=&&LOADSET,DISP=(OLD,DELETE)                         
//         DD DDNAME=SYSIN                                            
//SYSLMOD  DD DSN=PRJ3.DEV.LOADLIB(ORDERSYS),DISP=SHR       
//SYSUT1 DD UNIT=(SYSDA,SEP=(SYSLIN,SYSLMOD)),SPACE=(1024,(50,20)) 
//SYSLIB DD DSNAME=SYS1.COBLIB,DISP=SHR                            
//       DD DSNAME=SYS1.LINKLIB,DISP=SHR                           
//       DD DSNAME=PRJ3.DEV.LOADLIB,DISP=SHR                      
//SYSPRINT DD SYSOUT=*             
./ ADD NAME=RUN3,LIST=ALL  
//RUNPRJ3A JOB  'RUN ORDERSYS',          
//        CLASS=A,
//        MSGCLASS=X,
//        MSGLEVEL=(1,1),                            
//        NOTIFY=&SYSUID               
//********************************************************************
//* DELETE OLD OUTPUT IF EXISTS (DO THIS FIRST)
//********************************************************************
//BR14A    EXEC PGM=IEFBR14 
//SHIPOUT   DD DSN=PRJ3.DEV.OUTPUT.SHIPOUT,DISP=(MOD,DELETE,DELETE),
//         SPACE=(TRK,(0,0)),UNIT=SYSDA
//********************************************************************
//* STEP 2: RUN ORDERSYS BINARY
//* INPUT FROM PRJ3.DEV.INPUT   
//* OUTPUT RESULTS TO SHIPOUT                         
//********************************************************************
//STEP1    EXEC PGM=ORDERSYS             
//STEPLIB  DD DSN=PRJ3.DEV.LOADLIB,DISP=SHR 
//         DD DSN=SYS1.COBLIB,DISP=SHR
//SHIPIN  DD DSN=PRJ3.DEV.INPUT.SHIPIN,DISP=SHR   
//SHIPOUT   DD DSN=PRJ3.DEV.OUTPUT.SHIPOUT,DISP=(NEW,CATLG,DELETE),
//         SPACE=(TRK,(1,1)),UNIT=SYSDA,
//         DCB=(RECFM=FB,LRECL=80,BLKSIZE=800)   
//SYSOUT   DD SYSOUT=*      
//SYSUDUMP DD SYSOUT=*
//
./ ENDUP 
><       
/*  
//*                                                                  
//********************************************************************
//* SETUP YOUR LOADLIB NOTE RECFM=U                                   
//********************************************************************
//STEP04  EXEC PGM=IEFBR14                                            
//ALLOC4   DD  DSN=PRJ3.DEV.LOADLIB,                               
//             DISP=(NEW,CATLG,DELETE),                               
//             UNIT=TSO,                                              
//             SPACE=(CYL,(5,5,15),RLSE),                             
//             DCB=(LRECL=0,RECFM=U,BLKSIZE=6144,DSORG=PO)            
//SYSPRINT DD  SYSOUT=*                                               
//SYSOUT   DD  SYSOUT=*                                               
//*                                                                  
//********************************************************************
//* CREATE INPUT FILES (SEQUENTIAL, 80 BYTE RECORDS)                         
//********************************************************************
//* SHIPIN
//STEP05 EXEC PGM=IEBGENER,REGION=128K                      
//SYSIN    DD  DUMMY                                           
//SYSPRINT DD  SYSOUT=*                                        
//*                                                            
//SYSUT2   DD  DSN=PRJ3.DEV.INPUT.SHIPIN,DISP=(,CATLG,DELETE),  
//             UNIT=TSO,SPACE=(CYL,(1,1),RLSE),          
//             DCB=(LRECL=80,RECFM=FB,BLKSIZE=27920,DSORG=PS)     
//SYSUT1   DD  *                                                  
000001JOHN SMITHA10001000025000S                                                
000002MIKE JONESA20000500010000S                                                
000003SARA BROWNB10000200005000R                                                
000004LISA WHITEA10000300025000S                                                
000005TOM GREEN C30000100075000C                                                
000006JANE DOE  A10000200025000S                                                
000007BOB MARLEYA20000400010000R                                                
000008MARY LEE  B10000100005000S                                                
000009TIM COOK  C30000200075000S                                                
000010ANNA KENT A10000100025000C                                                
000011DAVID CARKA20000300010000S                                                
000012PAUL KING B10000200005000S                                                
000013LUCY HALL C30000100075000R                                                
000014ERIC YOUNGA10000500025000S                                                
000015NANCY ADAMSA2000010001000S                                                
000016FRANK WILONB1000040000500S                                                
000017KAREN SCOTTC3000020007500C                                                
000018DAN BLAKE  A1000030002500S                                                
000019OLIVIA REEDA2000020001000S                                                
000020PETER PAKERB1000010000500S                                                
/*                                                       
//SYSOUT   DD  SYSOUT=*                            