# PRJ3SHIP - Shipping Order System
Emulates an industrial Shipping/Order system. Take input data from a file, format it for output and calculate number of items sold and tally the total kinds of each transaction. 
Incorporates a subroutine to handle the main program's calculations.

COMPILES ON MVS 3.8 TK5 - FITS COBOL 68 STANDARD

You will need to have the following folders/files created:
- PRJ3.DEV.BCOB - for source files
- PRJ3.DEV.JCL  - for jcl files
- PRJ3.DEV.COPYBOOk - for copybooks
- PRJ3.DEV.LOADLIB - for output binaries
- PRJ3.DEV.INPUT.SHIPIN - for input dataset
(NOTE: if you use the 0-FULL-PRJ3-SETUP.jcl, you wont have to create all these manually)

## How to setup:
### SHORT WAY:
- copy 0-FULL-PRJ3-SETUP.jcl to your mainframe and run, it will create all the files you need
- submit the CMP1SUBP.jcl in your PRJ1.DEV.JCL to compile your subroutine
- submit the CMP2ORDR.jcl in your PRJ1.DEV.JCL to compile your main Shipping program
- submit the RUN3.jcl in your PRJ1.DEV.JCL to run
- Voila! You can view the JES2 Output by going to 3.8 and finding your job name. There should also be a new output file created called PRJ3.
DEV.OUTPUT.SHIPOUT in your PRJ3 directories

### LONG WAY: 
- create and run 0DEMOSTUP.jcl on MVS to create all the folders/input files you will need for this project
- copy OUTREC.cpy and SHIPREC.cpy to your copybooks storage
- copy SHIPIN to the PRJ3.DEV.INPUT.SHIPIN file
- copy 1SUBCALC.cob to your cobol storage and name it SUBCALC
- copy 2CMPSUBP.jcl to your jcl storage, name it CMPSUBP and submit it to compile your subroutine
- copy 3ORDERSYS.cob to your cobol storage and name it ORDERSYS
- copy 4CMPORDR.jcl to your jcl storage, name it CMPORDR and submit it to compile your full Shipping Order System Program
- copy 5RUN.jcl to your jcl storage and submit it to run your Shipping Order System Program
- Voila! You can view the JES2 Output by going to 3.8 and finding your job name. There should also be a new output file created called PRJ3.DEV.OUTPUT.SHIPOUT in your PRJ3 directories

## Code:
- If you want to just view the code that went into this in a more seemless manner, you can dig into the CODE folder to each component part

## Sources:
- Module 8.2: COBOL Subprogram Practical | COBOL Programming Full Course https://youtu.be/zSVew6CQkO0