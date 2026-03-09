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