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
                                         