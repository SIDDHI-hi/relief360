//R360TEST JOB (ACCOUNT),'RELIEF360 TEST',
//             CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID
//*********************************************************************
//* JOB NAME:    TESTCOB                                              *
//* SYSTEM:      RELIEF360 - EMERGENCY RELIEF ALLOCATION              *
//* PURPOSE:     COMPILE, LINK, AND RUN R360TEST SMOKE TEST           *
//* TARGET:      IBM Z XPLORE / ENTERPRISE COBOL FOR Z/OS             *
//*********************************************************************
//COBTEST  EXEC IGYWCLG,
//             PARM.COBOL='OPT(0),MAP,SOURCE,LIST',
//             PARM.LKED='LIST,MAP'
//COBOL.SYSIN DD DSN=&SYSUID..RLF360.CBL(R360TEST),DISP=SHR
//* OR ALTERNATIVELY USE YOUR EXISTING CBL PDS:
//* //COBOL.SYSIN DD DSN=&SYSUID..CBL(R360TEST),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..RLF360.LOAD(R360TEST),DISP=SHR
//GO.SYSOUT   DD SYSOUT=*
//GO.SYSUDUMP DD SYSOUT=*
//
