CREATE OR REPLACE PROCEDURE se0006 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   SYMBOL         IN       VARCHAR2,
   CIACCTNO       IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   21-NOV-06  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
   V_STRAFACCTNO      VARCHAR (20);
   V_STRSYMBOL        VARCHAR (20);
   V_D_CUR            DATE;
   V_STRLG            VARCHAR (20);
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS

      V_STRAFACCTNO := CIACCTNO;

  IF  (SYMBOL  <> 'ALL')
   THEN
      V_STRSYMBOL := replace(SYMBOL,' ','_');
   ELSE
      V_STRSYMBOL := '%%';
   END IF;


-- END OF GETTING REPORT'S PARAMETERS
-- GET language
SELECT ( CASE WHEN  SUBSTR(CF.custodycd,4,1) IS NULL OR SUBSTR(CF.custodycd,4,1)in('P','C') THEN 'C' ELSE 'F' end)
INTO  V_STRLG FROM CFMAST CF ,AFMAST AF
WHERE CF.custid = AF.custid
AND AF.acctno  LIKE V_STRAFACCTNO ;

-- GET REPORT'S DATA
OPEN PV_REFCURSOR
    FOR
sELECT V_STRLG LG,se.AFACCTNO AFACCTNO,I_DATE I_DATE,se.ACCTNO,
       sb.symbol ,  cf.address address,
         cf.fullname fullname,
 (se.trade - NVL (num.trade, 0) - NVL(od.secureamt,0)  ) trade,
 (nvl(b.qtty,0)- NVL (num.blocked, 0) )blocked,
 (se.mortage - NVL (num.mortage, 0) -NVL(od.securemtg,0)) mortage,
 (se.senddeposit + se.deposit - NVL (num.deposit, 0)) senddeposit,
  (se.receiving - NVL (num.receiving, 0) + NVL(od.receiving,0)) sts,
  (NVL(od.secureamt,0) + NVL(od.securemtg,0) - NVL (num.secured, 0)) secured,
  (se.dtoclose + se.withdraw - NVL (num.dtoclose, 0)) dtoclose,
 (se.netting - NVL (num.netting, 0)) netting,
 nvl(odsts.sereceiving,0) allowtrans
From
 Semast se,
 (
 SELECT
         sum(decode(app.FIELD,'TRADE',decode( app.txtype,'D',-tr.namt,'C',tr.namt,0),0))  TRADE,
         sum(decode(app.FIELD,'SECURED',decode( app.txtype,'D',-tr.namt,'C',tr.namt,0),0))  SECURED,
         sum(decode(app.FIELD,'MORTAGE',decode( app.txtype,'D',-tr.namt,'C',tr.namt,0),0))  MORTAGE,
         sum(decode(app.FIELD,'BLOCKED',decode( app.txtype,'D',-tr.namt,'C',tr.namt,0),0))  BLOCKED ,
         sum(decode(instr('DEPOSITSENDDEPOSIT',app.FIELD),0,0,decode( app.txtype,'D',-tr.namt,'C',tr.namt,0)))DEPOSIT ,
         sum(decode(instr('DTOCLOSEWITHDRAW',app.FIELD),0,0,decode( app.txtype,'D',-tr.namt,'C',tr.namt,0)))DTOCLOSE ,
         sum(decode(app.FIELD,'RECEIVING',decode( app.txtype,'D',-tr.namt,'C',tr.namt,0),0))  RECEIVING ,
         sum(decode(app.FIELD,'NETTING',decode( app.txtype,'D',-tr.namt,'C',tr.namt,0),0))  NETTING ,
         tr.acctno acctno
  FROM  apptx app,
    (select * from setran
         union all
         select * from setrana)  tr,
        (select * from tllog
         union all
         select * from  tllogall)  tl
  WHERE
                               tr.txcd = app.txcd
                               AND tl.txnum = tr.txnum
                               AND tl.txdate = tr.txdate
                               and tr.acctno like V_STRAFACCTNO||'%'
                               AND app.apptype = 'SE'
                               AND app.txtype IN ('C', 'D')
                               AND tl.deltd <> 'Y'
                               AND tl.busdate > TO_DATE (I_DATE, 'DD/MM/YYYY')
  group by    tr.acctno
  ) num,
  (SELECT   acctno, SUM (qtty) qtty
                      FROM semastdtl
                     WHERE deltd <> 'Y'
                  GROUP BY acctno) b,
  afmast af,
  cfmast cf,
  (select * from sbsecurities where SYMBOL like V_STRSYMBOL) sb,
  (SELECT    seacctno seacctno,
        SUM (case when od.exectype IN ('NS', 'SS') then remainqtty + execqtty else 0 end)  secureamt,
        SUM (case when od.exectype ='MS' then remainqtty + execqtty else 0 end)  securemtg,
        SUM (case when od.exectype ='NB' then execqtty else 0 end) receiving
        FROM odmast od
        WHERE
        od.seacctno like V_STRAFACCTNO||'%'
        AND od.txdate =to_date(I_DATE, 'DD/MM/YYYY' )
        AND od.txdate =(Select TO_DATE (varvalue, 'DD/MM/YYYY') from sysvar
                        where varname = 'CURRDATE')   AND
        deltd <> 'Y' AND od.exectype IN ('NS', 'SS','MS','NB')
   group by   seacctno
  ) od,
    (SELECT ACCTNO, SUM(QTTY) SERECEIVING
    FROM ((SELECT ST.ACCTNO, ST.QTTY
        FROM ODMAST OD, STSCHD ST, ODTYPE TYP
        WHERE ST.DELTD <>'Y' AND OD.ORDERID = ST.ORGORDERID AND ST.DUETYPE = 'RS'
            AND ST.acctno LIKE V_STRAFACCTNO||'%'
            And OD.ACTYPE = TYP.ACTYPE
            AND TYP.TRANDAY <= (SELECT SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(I_DATE,'DD/MM/YYYY'))
            AND ST.CLEARDAY > (SELECT SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(I_DATE,'DD/MM/YYYY'))
        )
        UNION ALL
        (SELECT ST.ACCTNO, ST.QTTY
        FROM ODMASTHIST OD, STSCHDHIST ST, ODTYPE TYP
        WHERE ST.DELTD <>'Y' AND OD.ORDERID = ST.ORGORDERID AND ST.DUETYPE = 'RS'
            AND ST.acctno LIKE V_STRAFACCTNO||'%'
            And OD.ACTYPE = TYP.ACTYPE
            AND TYP.TRANDAY <= (SELECT SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(I_DATE,'DD/MM/YYYY'))
            AND ST.CLEARDAY > (SELECT SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(I_DATE,'DD/MM/YYYY'))
        ) )
    GROUP BY ACCTNO
    ) odsts
where se.acctno = od.seacctno(+)
     and se.acctno = num.acctno(+)
     and se.acctno=b.acctno(+)
     and af.acctno = se.afacctno
     AND cf.custid = af.custid
     AND SUBSTR (af.acctno, 1, 4) LIKE V_STRBRID
     AND sb.codeid = SUBSTR (se.acctno, 11, 6)
     and sb.SECTYPE <>'004'
    and se.afacctno=V_STRAFACCTNO
     and (
          (se.trade - NVL (num.trade, 0) - NVL(od.secureamt,0)  ) <>0
    or (b.qtty- NVL (num.blocked, 0) )<>0
    or   (se.mortage - NVL (num.mortage, 0) -NVL(od.securemtg,0))  <>0
    or (se.senddeposit + se.deposit - NVL (num.deposit, 0)) <>0
    or (se.receiving - NVL (num.receiving, 0)) <>0
    or  (NVL(od.secureamt,0)   +  NVL(od.securemtg,0) - NVL (num.secured, 0)) <>0
    or  (se.dtoclose + se.withdraw - NVL (num.dtoclose, 0)) <>0
    or  (se.netting - NVL (num.netting, 0)) <>0)
    and se.acctno = odsts.acctno(+)
order by symbol
;


 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

