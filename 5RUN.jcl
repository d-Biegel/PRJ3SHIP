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