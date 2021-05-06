CREATE OR REPLACE PROCEDURE ci0014 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   CIACCTNO      IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- PHUONGNN   21-NOV-06 MODIFIED
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

   V_CUSTODYCD        VARCHAR (20);

   V_SDGD             NUMBER ;
   V_PT               NUMBER ;
   V_SDKQ             NUMBER;
   V_STCV             NUMBER ;
   V_Total            NUMBER ;

   v_Fullname         VARCHAR2(50);
   v_Address          varchar2(50);
   V_STRAFACCTNO       varchar2(50);




BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

    IF (CIACCTNO <> 'ALL')
   THEN
      V_STRAFACCTNO :=  CIACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;

   ---V_CUSTODYCD := CUSTODYCD;




   OPEN PV_REFCURSOR
       FOR
        SELECT semast.acctno seACCTNO,af.acctno afacctno, SYM.SYMBOL,
        SEMAST.CODEID, SYM.PARVALUE, SEMAST.LASTDATE SELASTDATE, AF.LASTDATE AFLASTDATE,
        CF.CUSTODYCD, CF.FULLNAME, CF.IDCODE, TYP.TYPENAME, A1.CDCONTENT TRADEPLACE,semast.trade, nvl(seblk.blocked,0) blocked,
        cf.idplace,cf.iddate,cf.address,cf.phone,ci.balance,ci.acctno ciacctno
        FROM SEMAST, SBSECURITIES SYM, AFMAST AF, AFTYPE TYP, CFMAST CF,CIMAST CI, ALLCODE A1,
            (SELECT dtl.acctno acctno, sum(dtl.qtty) BLOCKED
                from semastdtl dtl
                WHERE substr(dtl.acctno,1,10) LIKE V_STRAFACCTNO
                and dtl.qttytype = '002'
                group BY dtl.acctno
            ) SEBLK
            WHERE A1.CDTYPE = 'SA'
             AND A1.CDNAME = 'TRADEPLACE'
             and af.acctno like V_STRAFACCTNO
             AND A1.CDVAL = SYM.TRADEPLACE
             AND CF.CUSTID =AF.CUSTID
             AND SYM.CODEID = SEMAST.CODEID
             AND SEMAST.AFACCTNO= AF.ACCTNO
             and seblk.acctno(+) = semast.acctno
             AND TYP.ACTYPE=AF.ACTYPE
             AND AF.status ='N'
             AND SEMAST.TRADE >0
             and AF.ACCTNO = CI.AFACCTNO

             and CI.BALANCE + CI.ODAMT + CI.CRINTACR + CI.ODINTACR + CI.AAMT +
             CI.RAMT + CI.BAMT + CI.NAMT + CI.EMKAMT + CI.MMARGINBAL
           + CI.MARGINBAL + CI.ADINTACR + CI.holdbalance
            + CI.pendinghold + CI.pendingunhold + ci.dfodamt
            <= (SELECT TO_NUMBER(VARVALUE) FROM SYSVAR WHERE GRNAME ='SYSTEM' AND VARNAME ='ROUND_VALUE');

 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

