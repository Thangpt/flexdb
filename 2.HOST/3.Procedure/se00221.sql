CREATE OR REPLACE PROCEDURE se00221 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_RECUSTODYCD   in       varchar2,
   PV_RENAME        IN       varchar2,
   PV_RECOMPANY     IN       varchar2
       )
IS

    V_BRID              VARCHAR2(4);
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);
    V_IDATE DATE;
    V_CUSTODYCD varchar2(10);
    v_COUNT  number;

BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;
   v_COUNT :=0;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

   V_CUSTODYCD := upper(PV_CUSTODYCD);

OPEN PV_REFCURSOR FOR
SELECT        custodycd,
             CAMASTID,
             CA_GROUP,
             CATYPENAME,
             TRADEPLACE,
             SYMBOL,
             DEVIDENTSHARES,
             DEVIDENTRATE,
             RIGHTOFFRATE,
             EXPRICE,
             INTERESTRATE,
             EXRATE,
             REPORTDATE,
             CATYPE,
             SUM(TRADE) TRADE,
             SUM(AMT) AMT,
             SUM(QTTY) QTTY,
             SUM(RQTTY) RQTTY,
             SUM(PBALANCE) PBALANCE,
             SUM(BALANCE) BALANCE
        FROM (SELECT CF.CUSTODYCD,
                    CAS.CAMASTID,
                     CAS.BALANCE,
                     CAS.PBALANCE,
                     CAS.RQTTY,
                     CAS.QTTY,
                     CAS.AMT,
                     CAS.TRADE,
                     CA.CATYPE,
                     CA.REPORTDATE,
                     CA.EXRATE,
                     case when ca.catype = '027' then decode(CA.TYPERATE,'R',CA.DEVIDENTRATE ||' %',CA.DEVIDENTVALUE)
                          else CA.INTERESTRATE end INTERESTRATE,
                     CA.EXPRICE,
                     CA.RIGHTOFFRATE,
                     CASE
                       WHEN CA.CATYPE = '010' AND CA.DEVIDENTRATE = 0 THEN
                        TO_CHAR(CA.DEVIDENTVALUE)
                       ELSE
                        CA.DEVIDENTRATE
                     END DEVIDENTRATE,
                     CA.DEVIDENTSHARES,
                     SB.SYMBOL,
                     A1.CDCONTENT TRADEPLACE,
                     CASE
                       WHEN CA.CATYPE = '011' THEN  UTF8NUMS.C_CONST_CA_RIGHTNAME_A--'A. QUY?N NH?N C? T?C B?NG C? PHI?U'
                       WHEN CA.CATYPE = '010' THEN UTF8NUMS.C_CONST_CA_RIGHTNAME_C --'C. QUY?N NH?N C? T?C B?NG TI?N'
                       WHEN CA.CATYPE = '021' THEN UTF8NUMS.C_CONST_CA_RIGHTNAME_B --'B. QUY?N C? PHI?U THU?NG'
                       WHEN CA.CATYPE = '014' THEN UTF8NUMS.C_CONST_CA_RIGHTNAME_D --'D. QUY?N MUA'
                       WHEN CA.CATYPE = '020' THEN UTF8NUMS.C_CONST_CA_RIGHTNAME_E --'E. QUY?N HO?N ?I C? PHI?U'
                       WHEN CA.CATYPE IN ('017', '023') THEN UTF8NUMS.C_CONST_CA_RIGHTNAME_F --'F. QUY?N CHUY?N ?I TR?I PHI?U'
                       WHEN CA.CATYPE IN ('022', '005', '006') THEN UTF8NUMS.C_CONST_CA_RIGHTNAME_G--'G. QUY?N BI?U QUY?T'
                       ELSE UTF8NUMS.C_CONST_CA_RIGHTNAME_H --'H. QUY?N KH?C'

                     END CATYPENAME,
                     CASE
                       WHEN CA.CATYPE IN ('011', '021') THEN
                        1
                       WHEN CA.CATYPE IN ('010') THEN
                        2
                       WHEN CA.CATYPE IN ('014') THEN
                        3
                       WHEN CA.CATYPE IN ('020') THEN
                        4
                       WHEN CA.CATYPE IN ('017', '023') THEN
                        5
                       WHEN CA.CATYPE IN ('022', '005', '006') THEN
                        6
                       ELSE
                        7
                     END CA_GROUP
                FROM CASCHD       CAS,
                     CAMAST       CA,
                     SBSECURITIES SB,
                     ALLCODE      A1,
                     ALLCODE      A2,
                     AFMAST       AF,
                     CFMAST       CF
               WHERE CAS.CAMASTID = CA.CAMASTID
                 AND CAS.CODEID = SB.CODEID
                 AND CAS.AFACCTNO = AF.ACCTNO
                 AND AF.CUSTID = CF.CUSTID
                 AND A1.CDNAME = 'TRADEPLACE'
                 AND A1.CDTYPE = 'SE'
                 AND A1.CDVAL = SB.TRADEPLACE
                 AND A2.CDNAME = 'CATYPE'
                 AND A2.CDTYPE = 'CA'
                 AND CA.CATYPE = A2.CDVAL
                 AND CF.CUSTODYCD = V_CUSTODYCD
                 AND CA.CATYPE not IN ('022', '005', '006') -- khong lay quyen bieu quyet
                 --AND AF.STATUS = 'N'
                 AND CAS.DELTD <> 'Y'
                 AND (CASE
                       WHEN CAS.STATUS IN ('C', 'J','W') THEN --15/10 them trang thai W
                        0
                       ELSE
                        1
                     END) > 0) A
       GROUP BY custodycd,
                CATYPE,
                REPORTDATE,
                EXRATE,
                INTERESTRATE,
                EXPRICE,
                RIGHTOFFRATE,
                DEVIDENTRATE,
                DEVIDENTSHARES,
                SYMBOL,
                TRADEPLACE,
                CATYPENAME,
                CA_GROUP,
                CAMASTID
       ORDER BY A.CATYPENAME
       ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

