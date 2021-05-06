CREATE OR REPLACE PROCEDURE cf0029 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2,
   SYMBOL         IN       VARCHAR2
)
IS
-- Bao cao sao ke tai khoan chung khoan
-- Quyet.kieu   Date 04_08_2010
-- ---------   ------  -------------------------------------------
   V_STROPTION     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID       VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   V_STRAFACCTNO   VARCHAR2 (20);
   V_STRSYMBOL     VARCHAR2 (20);
   V_STRFULLNAME  VARCHAR2 (100);
   V_STRADDRESS    VARCHAR2 (500);
      V_STRLG            VARCHAR (20);
   CUR             PKG_REPORT.REF_CURSOR;
   V_A5 Varchar2(20);
   V_A6 Varchar2(20);

Cursor A is
Select Max (SYMBOL_2)
From
(     ----------GIAO DICH KHAC LENH
SELECT  SETR.ACCTNO ACCTNO, TO_CHAR(SB.SYMBOL) SYMBOL_2,TL.BUSDATE BUSDATE,
 TL.TXDATE TXDATE, TL.TXNUM TXNUM, TO_CHAR(TL.TXDESC) DESCRIPTION,
(CASE WHEN APP.TXTYPE ='C' THEN SETR.NAMT ELSE 0 END)CAMT ,
(CASE WHEN APP.TXTYPE ='D' THEN SETR.NAMT ELSE 0 END)DAMT, '' orderid
 FROM
 (
    SELECT * FROM TLLOG
    WHERE BUSDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY') --F_DATE
    AND BUSDATE   <= TO_DATE (T_DATE, 'DD/MM/YYYY') --TDATE
    AND TLTXCD IN
   ( SELECT  TLTXCD FROM TLTX  WHERE  SUBSTR(TLTXCD,1,2) <> '88'and tltxcd not in ('2297','2298','2250','2252') or  TLTXCD  IN('8878' ,'8879','2248'))

 ) TL, APPTX APP,SETRAN SETR, SBSECURITIES SB
WHERE
     TL.TXNUM = SETR.TXNUM
     AND TL.TXDATE =SETR.TXDATE
     AND SETR.TXCD = APP.TXCD
     AND SB.CODEID=SUBSTR (SETR.ACCTNO, 11, 6)
     AND APP.APPTYPE = 'SE'
     AND APP.TXTYPE IN ('C', 'D')
     AND TRIM (APP.FIELD) IN('TRADE','SECURED','MORTAGE')
     AND  SUBSTR(SETR.ACCTNO,1,10) LIKE V_STRAFACCTNO
     AND  SETR.NAMT<>0
     AND TL.DELTD<>'Y'
UNION ALL

 SELECT  SETR.ACCTNO ACCTNO, TO_CHAR(SB.SYMBOL) SYMBOL,TL.BUSDATE BUSDATE,
 TL.TXDATE TXDATE, TL.TXNUM TXNUM, TO_CHAR(TL.TXDESC) DESCRIPTION,
(CASE WHEN APP.TXTYPE ='C' THEN SETR.NAMT ELSE 0 END)CAMT ,
(CASE WHEN APP.TXTYPE ='D' THEN SETR.NAMT ELSE 0 END)DAMT, '' ORDERID

 FROM
 (
    SELECT * FROM TLLOGALL
    WHERE BUSDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY') --F_DATE
    AND BUSDATE   <= TO_DATE   (T_DATE, 'DD/MM/YYYY') --T_DATE
    AND TLTXCD IN
       ( SELECT  TLTXCD FROM TLTX  WHERE  SUBSTR(TLTXCD,1,2) <> '88'and tltxcd not in ('2297','2298','2250','2252') or  TLTXCD  IN('8878' ,'8879','2248'))
 ) TL, APPTX APP,SETRANA SETR, SBSECURITIES SB
 WHERE   TL.TXNUM = SETR.TXNUM
         AND TL.TXDATE =SETR.TXDATE
         AND SETR.TXCD = APP.TXCD
         AND SB.CODEID=SUBSTR (SETR.ACCTNO, 11, 6)
         AND APP.APPTYPE = 'SE'
         AND APP.TXTYPE IN ('C', 'D')
         AND TRIM (APP.FIELD) IN('TRADE','SECURED','MORTAGE')
         AND  SUBSTR(SETR.ACCTNO,1,10) LIKE V_STRAFACCTNO
         AND  SETR.NAMT<>0
         AND TL.DELTD<>'Y'

  UNION ALL

-------NHUNG GIAO DICH LENH
  SELECT  MAX(SETR.ACCTNO) ACCTNO,TO_CHAR( MAX(SB.SYMBOL)) SYMBOL,  MAX(TL.BUSDATE) BUSDATE
  , MAX(TL.TXDATE) TXDATE, MAX(TL.TXNUM) TXNUM, TO_CHAR(MAX(TL.TXDESC)) DESCRIPTION,
 sum(CASE WHEN APP.TXTYPE ='C' THEN SETR.NAMT ELSE 0 END)CAMT ,
 sum(CASE WHEN APP.TXTYPE ='D' THEN SETR.NAMT ELSE 0 END)DAMT, SETR.ref ORDERID

 FROM
 ( SELECT * FROM TLLOG
    WHERE BUSDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY')--F_DATE
    AND BUSDATE <= TO_DATE   (T_DATE, 'DD/MM/YYYY') --TDATE
    AND TLTXCD  IN( '8824' ,'8823', '8868', '8867','2248')
 ) TL, APPTX APP,SETRAN SETR, SBSECURITIES SB
 WHERE   TL.TXNUM = SETR.TXNUM
     AND TL.TXDATE =SETR.TXDATE
     AND SETR.TXCD = APP.TXCD
     AND SB.CODEID=SUBSTR (SETR.ACCTNO, 11, 6)
     AND APP.APPTYPE = 'SE'
     AND APP.TXTYPE IN ('C', 'D')
     AND TRIM (APP.FIELD) IN('TRADE','SECURED','MORTAGE')
     AND  SUBSTR(SETR.ACCTNO,1,10) LIKE V_STRAFACCTNO
     AND  SETR.NAMT<>0
     AND TL.DELTD<>'Y'
  GROUP BY SETR.ref,APP.TXTYPE

UNION ALL

SELECT  MAX(SETR.ACCTNO) ACCTNO,TO_CHAR( MAX(SB.SYMBOL)) SYMBOL,  MAX(TL.BUSDATE) BUSDATE
  , MAX(TL.TXDATE) TXDATE, MAX(TL.TXNUM) TXNUM, TO_CHAR(MAX(TL.TXDESC)) DESCRIPTION,
  sum(CASE WHEN APP.TXTYPE ='C' THEN SETR.NAMT ELSE 0 END)CAMT ,
  sum(CASE WHEN APP.TXTYPE ='D' THEN SETR.NAMT ELSE 0 END)DAMT, SETR.ref ORDERID

FROM
(
    SELECT * FROM TLLOGALL
    WHERE BUSDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY') --FDATE
    AND BUSDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY') --TDATE
    AND TLTXCD  IN( '8824' ,'8823', '8868', '8867','2248')
) TL, APPTX APP,SETRANA SETR,SBSECURITIES SB
  WHERE   TL.TXNUM = SETR.TXNUM
     AND TL.TXDATE =SETR.TXDATE
     AND SETR.TXCD = APP.TXCD
     AND SB.CODEID=SUBSTR (SETR.ACCTNO, 11, 6)

     AND APP.APPTYPE = 'SE'
     AND APP.TXTYPE IN ('C', 'D')
     AND TRIM (APP.FIELD) IN('TRADE','SECURED','MORTAGE')
     AND  SUBSTR(SETR.ACCTNO,1,10) LIKE V_STRAFACCTNO
     AND  SETR.NAMT<>0
     AND TL.DELTD<>'Y'
      GROUP BY SETR.ref,APP.TXTYPE )BALANCE;


 --------------------------
 Cursor B is
SELECT to_Char(sb.symbol)
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
                               and tr.acctno like  V_STRAFACCTNO||'%'
                               AND app.apptype = 'SE'
                               AND app.txtype IN ('C', 'D')
                               AND tl.deltd <> 'Y'
                               AND tl.busdate > TO_DATE (T_DATE, 'DD/MM/YYYY') --IDATE
  group by    tr.acctno
  ) num,
  (SELECT   acctno, SUM (qtty) qtty
                      FROM semastdtl
                     WHERE deltd <> 'Y'
                  GROUP BY acctno) b,
  afmast af,
  cfmast cf,
  (select * from sbsecurities where SYMBOL like V_STRSYMBOL) sb, -- V_STRSYMBOL
  (SELECT    seacctno seacctno,
        SUM (case when od.exectype IN ('NS', 'SS') then remainqtty + execqtty else 0 end)  secureamt,
        SUM (case when od.exectype ='MS' then remainqtty + execqtty else 0 end)  securemtg,
        SUM (case when od.exectype ='NB' then execqtty else 0 end) receiving
        FROM odmast od
        WHERE
        od.seacctno like V_STRAFACCTNO || '%'
        AND od.txdate =to_date(T_DATE, 'DD/MM/YYYY' ) --IDATE
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
            AND ST.status = 'N'
            AND TYP.TRANDAY <= (SELECT (CASE WHEN ST.CLEARCD='B' THEN SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1 ELSE SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 1 ELSE 1 END)-1 END)
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')) --IDATE
            AND ST.CLEARDAY > (SELECT (CASE WHEN ST.CLEARCD='B' THEN SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1 ELSE SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 1 ELSE 1 END)-1 END)
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')) --IDATE
        )
        UNION ALL
        (SELECT ST.ACCTNO, ST.QTTY
        FROM ODMASTHIST OD, STSCHDHIST ST, ODTYPE TYP
        WHERE ST.DELTD <>'Y' AND OD.ORDERID = ST.ORGORDERID AND ST.DUETYPE = 'RS'
            AND ST.acctno LIKE V_STRAFACCTNO||'%'
            And OD.ACTYPE = TYP.ACTYPE
            AND TYP.TRANDAY <= (SELECT (CASE WHEN ST.CLEARCD='B' THEN SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1 ELSE SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 1 ELSE 1 END)-1 END)
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')) --IDATE
            AND ST.CLEARDAY > (SELECT (CASE WHEN ST.CLEARCD='B' THEN SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1 ELSE SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 1 ELSE 1 END)-1 END)
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')) --IDATE
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
     and se.afacctno= V_STRAFACCTNO
     and (
          (se.trade - NVL (num.trade, 0) - NVL(od.secureamt,0)  ) <>0
    or   (b.qtty- NVL (num.blocked, 0) )<>0
    or   (se.mortage - NVL (num.mortage, 0) -NVL(od.securemtg,0))  <>0
    or (se.senddeposit + se.deposit - NVL (num.deposit, 0)) <>0
    or (se.receiving - NVL (num.receiving, 0)) <>0
    or  (NVL(od.secureamt,0)   +  NVL(od.securemtg,0) - NVL (num.secured, 0)) <>0
    or  (se.dtoclose + se.withdraw - NVL (num.dtoclose, 0)) <>0
    or  (se.netting - NVL (num.netting, 0)) <>0)
    and se.acctno = odsts.acctno(+)
    ;
-----------------------------------


BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS
  IF (AFACCTNO <> 'ALL')
   THEN
      V_STRAFACCTNO :=  AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;

 IF (SYMBOL <> 'ALL')
   THEN
      V_STRSYMBOL := replace(SYMBOL,' ','_');
   ELSE
      V_STRSYMBOL := '%%';
   END IF;



   OPEN A;
   FETCH A  INTO V_A6;
   IF A%NOTFOUND or V_A6 is null then
      V_A6:= '.';
   END IF;
   CLOSE A;


   OPEN B;
   FETCH B  INTO V_A5;
   IF B%NOTFOUND or V_A5 is null then
      V_A5:= '.';
   END IF;
   CLOSE B;

   if V_A5='.' and V_A6='.' then
   return;
   end if;

--Lay thong tin loai hinh hop dong
 SELECT ( CASE WHEN  SUBSTR(CF.custodycd,4,1) IS NULL OR SUBSTR(CF.custodycd,4,1)in('P','C') THEN 'C' ELSE 'F' end)
INTO  V_STRLG FROM CFMAST CF ,AFMAST AF
WHERE CF.custid = AF.custid
AND AF.acctno  LIKE V_STRAFACCTNO ;

-- Lay thong tin khach hang
OPEN CUR FOR
SELECT CF.FULLNAME,CF.ADDRESS
 FROM AFMAST AF,CFMAST CF
WHERE AF.custid =CF.custid
AND AF.ACCTNO  LIKE  V_STRAFACCTNO;




LOOP
  FETCH    CUR
  INTO V_STRFULLNAME, V_STRADDRESS ;
  EXIT WHEN    CUR%NOTFOUND;
END LOOP;
CLOSE    CUR;

-- GET REPORT'S DATA`
IF V_A6='.' then

OPEN PV_REFCURSOR
FOR

Select * from
(
(
SELECT '001' A0 ,V_STRFULLNAME A1 ,se.AFACCTNO A2, to_char(T_DATE) A3 ,se.ACCTNO A4 ,to_Char(sb.symbol) A5, '' A6, to_Char(cf.fullname) A7,
      to_char(se.trade - NVL (num.trade, 0) - NVL(od.secureamt,0)) A8, to_char(nvl(b.qtty,0)- NVL (num.blocked, 0) )A9,
      to_char(se.mortage - NVL (num.mortage, 0) -NVL(od.securemtg,0)) A10, (se.senddeposit + se.deposit - NVL (num.deposit, 0)) A11,
      (se.receiving - NVL (num.receiving, 0) + NVL(od.receiving,0)) A12,  to_char(NVL(od.secureamt,0) + NVL(od.securemtg,0) - NVL (num.secured, 0)) A13,
      (se.dtoclose + se.withdraw - NVL (num.dtoclose, 0)) A14, (se.netting - NVL (num.netting, 0)) A15, nvl(odsts.sereceiving,0) A16, V_STRLG A17 , V_A6 A18
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
                               and tr.acctno like  V_STRAFACCTNO||'%'
                               AND app.apptype = 'SE'
                               AND app.txtype IN ('C', 'D')
                               AND tl.deltd <> 'Y'
                               AND tl.busdate > TO_DATE (T_DATE, 'DD/MM/YYYY') --IDATE
  group by    tr.acctno
  ) num,
  (SELECT   acctno, SUM (qtty) qtty
                      FROM semastdtl
                     WHERE deltd <> 'Y'
                  GROUP BY acctno) b,
  afmast af,
  cfmast cf,
  (select * from sbsecurities where SYMBOL like V_STRSYMBOL) sb, -- V_STRSYMBOL
  (SELECT    seacctno seacctno,
        SUM (case when od.exectype IN ('NS', 'SS') then remainqtty + execqtty else 0 end)  secureamt,
        SUM (case when od.exectype ='MS' then remainqtty + execqtty else 0 end)  securemtg,
        SUM (case when od.exectype ='NB' then execqtty else 0 end) receiving
        FROM odmast od
        WHERE
        od.seacctno like V_STRAFACCTNO || '%'
        AND od.txdate =to_date(T_DATE, 'DD/MM/YYYY' ) --IDATE
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
            AND ST.status = 'N'
            AND TYP.TRANDAY <= (SELECT (CASE WHEN ST.CLEARCD='B' THEN SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1 ELSE SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 1 ELSE 1 END)-1 END)
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')) --IDATE
            AND ST.CLEARDAY > (SELECT (CASE WHEN ST.CLEARCD='B' THEN SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1 ELSE SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 1 ELSE 1 END)-1 END)
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')) --IDATE
        )
        UNION ALL
        (SELECT ST.ACCTNO, ST.QTTY
        FROM ODMASTHIST OD, STSCHDHIST ST, ODTYPE TYP
        WHERE ST.DELTD <>'Y' AND OD.ORDERID = ST.ORGORDERID AND ST.DUETYPE = 'RS'
            AND ST.acctno LIKE V_STRAFACCTNO||'%'
            And OD.ACTYPE = TYP.ACTYPE
            AND TYP.TRANDAY <= (SELECT (CASE WHEN ST.CLEARCD='B' THEN SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1 ELSE SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 1 ELSE 1 END)-1 END)
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')) --IDATE
            AND ST.CLEARDAY > (SELECT (CASE WHEN ST.CLEARCD='B' THEN SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1 ELSE SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 1 ELSE 1 END)-1 END)
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')) --IDATE
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
     and se.afacctno= V_STRAFACCTNO
     and (
          (se.trade - NVL (num.trade, 0) - NVL(od.secureamt,0)  ) <>0
    or   (b.qtty- NVL (num.blocked, 0) )<>0
    or   (se.mortage - NVL (num.mortage, 0) -NVL(od.securemtg,0))  <>0
    or (se.senddeposit + se.deposit - NVL (num.deposit, 0)) <>0
    or (se.receiving - NVL (num.receiving, 0)) <>0
    or  (NVL(od.secureamt,0)   +  NVL(od.securemtg,0) - NVL (num.secured, 0)) <>0
    or  (se.dtoclose + se.withdraw - NVL (num.dtoclose, 0)) <>0
    or  (se.netting - NVL (num.netting, 0)) <>0)
    and se.acctno = odsts.acctno(+))

  UNION ALL
 SELECT '002' A0 ,V_STRFULLNAME A1, V_STRADDRESS A2,  to_char('') A3,AFACCTNO A4,
 to_char('') A5, to_char('0') A6,to_char('') A7,to_char('') A8, to_char('') A9 ,
 to_char('No Transaction') A10 , 0 A11 ,0 A12 ,to_char('') A13 , 0 A14 ,0 A15 ,0 A16,V_STRLG A17 , V_A6 A18 From DUal
 );
 -- order by symbol



Else

      OPEN PV_REFCURSOR
       FOR
         Select * from
( SELECT '002' A0 ,V_STRFULLNAME A1,V_STRADDRESS A2,  to_char(BE_BALANCE.BE_BALANCE) A3,BE_BALANCE.AFACCTNO A4,
 to_char(BALANCE.ACCTNO) A5, to_char(BALANCE.SYMBOL) A6,to_char(to_date(BALANCE.BUSDATE,'DD/MM/RRRR')) A7,to_char(BALANCE.TXDATE) A8, to_char(BALANCE.TXNUM) A9 ,
 to_char(BALANCE.DESCRIPTION) A10 , BALANCE.CAMT A11 ,BALANCE.DAMT A12 ,to_char(BALANCE.orderid) A13 , 0 A14 ,0 A15 ,0 A16,V_STRLG A17 , V_A6 A18
          FROM
---------SO DU DAU KY SE
          (  SELECT  NVL((SE.TRADE+SE.secured +SE.mortage  - DTL.B),0)  BE_BALANCE, DTL.ACCTNO,substr( DTL.ACCTNO,1,10) AFACCTNO
          FROM SEMAST SE,SBSECURITIES SB,(
         SELECT SUM(A.AMT) B,A.ACCTNO  ACCTNO
         FROM (SELECT   SUM ((CASE WHEN APP.TXTYPE = 'D'THEN -TR.NAMT
                                   WHEN APP.TXTYPE = 'C' THEN TR.NAMT
                                   ELSE 0   END )) AMT,TR.ACCTNO ACCTNO
               FROM APPTX APP, SETRAN TR ,TLLOG TL
               WHERE TR.TXCD = APP.TXCD
                    AND TL.TXNUM =TR.TXNUM
                    AND TL.DELTD <>'Y'
                    AND APP.APPTYPE = 'SE'
                    AND TR.namt <> 0
                    AND APP.TXTYPE IN ('C', 'D')
                    AND TRIM (APP.FIELD) IN('TRADE','SECURED','MORTAGE')
                    AND  TL.BUSDATE  >= TO_DATE (F_DATE,'DD/MM/YYYY')--F_DATE
               GROUP BY TR.ACCTNO
           UNION ALL
              SELECT   SUM ((CASE WHEN APP.TXTYPE = 'D'THEN -TR.NAMT
                                 WHEN  APP.TXTYPE = 'C'THEN TR.NAMT
                                 ELSE 0 END )) AMT,TR.ACCTNO ACCTNO
              FROM APPTX APP, SETRANA TR,TLLOGALL TL
              WHERE TR.TXCD = APP.TXCD
                    AND TL.TXNUM =TR.TXNUM
                    AND TL.DELTD <>'Y'
                    AND TL.TXDATE =TR.TXDATE
                    AND APP.APPTYPE = 'SE'
                    AND TR.namt <> 0
                    AND APP.TXTYPE IN ('C', 'D')
                    AND TRIM (APP.FIELD) IN('TRADE','SECURED','MORTAGE')
                    AND  TL.BUSDATE  >= TO_DATE ( F_DATE ,'DD/MM/YYYY')--F_DATE
              GROUP BY TR.ACCTNO
                ) A
                  GROUP BY A.ACCTNO)DTL
       WHERE  SE.ACCTNO =DTL.ACCTNO
       AND  SUBSTR(SE.ACCTNO,11,6)=SB.CODEID
       AND  SUBSTR(DTL.ACCTNO,1,10) LIKE V_STRAFACCTNO
       AND  SB.SYMBOL LIKE V_STRSYMBOL
       AND  SUBSTR(SE.ACCTNO,1,4) LIKE V_STRBRID
       and sb.SECTYPE <>'004'
       )BE_BALANCE,-----SO DU SE PHAT SINH

  (     ----------GIAO DICH KHAC LENH
SELECT  SETR.ACCTNO ACCTNO, TO_CHAR(SB.SYMBOL) SYMBOL,TL.BUSDATE BUSDATE,
 TL.TXDATE TXDATE, TL.TXNUM TXNUM, TO_CHAR(TL.TXDESC) DESCRIPTION,
(CASE WHEN APP.TXTYPE ='C' THEN SETR.NAMT ELSE 0 END)CAMT ,
(CASE WHEN APP.TXTYPE ='D' THEN SETR.NAMT ELSE 0 END)DAMT, '' orderid

 FROM
 (
    SELECT * FROM TLLOG
    WHERE BUSDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY') --F_DATE
    AND BUSDATE   <= TO_DATE (T_DATE, 'DD/MM/YYYY') --TDATE
    AND TLTXCD IN
   ( SELECT  TLTXCD FROM TLTX  WHERE  SUBSTR(TLTXCD,1,2) <> '88'and tltxcd not in ('2297','2298','2250','2252') or  TLTXCD  IN('8878' ,'8879','2248'))

 ) TL, APPTX APP,SETRAN SETR, SBSECURITIES SB
WHERE
     TL.TXNUM = SETR.TXNUM
     AND TL.TXDATE =SETR.TXDATE
     AND SETR.TXCD = APP.TXCD
     AND SB.CODEID=SUBSTR (SETR.ACCTNO, 11, 6)
     AND APP.APPTYPE = 'SE'
     AND APP.TXTYPE IN ('C', 'D')
     AND TRIM (APP.FIELD) IN('TRADE','SECURED','MORTAGE')
     AND  SUBSTR(SETR.ACCTNO,1,10) LIKE V_STRAFACCTNO
     AND  SETR.NAMT<>0
     AND TL.DELTD<>'Y'
UNION ALL

 SELECT  SETR.ACCTNO ACCTNO, TO_CHAR(SB.SYMBOL) SYMBOL,TL.BUSDATE BUSDATE,
 TL.TXDATE TXDATE, TL.TXNUM TXNUM, TO_CHAR(TL.TXDESC) DESCRIPTION,
(CASE WHEN APP.TXTYPE ='C' THEN SETR.NAMT ELSE 0 END)CAMT ,
(CASE WHEN APP.TXTYPE ='D' THEN SETR.NAMT ELSE 0 END)DAMT, '' ORDERID

 FROM
 (
    SELECT * FROM TLLOGALL
    WHERE BUSDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY') --F_DATE
    AND BUSDATE   <= TO_DATE   (T_DATE, 'DD/MM/YYYY') --T_DATE
    AND TLTXCD IN
       ( SELECT  TLTXCD FROM TLTX  WHERE  SUBSTR(TLTXCD,1,2) <> '88'and tltxcd not in ('2297','2298','2250','2252') or  TLTXCD  IN('8878' ,'8879','2248'))
 ) TL, APPTX APP,SETRANA SETR, SBSECURITIES SB
 WHERE   TL.TXNUM = SETR.TXNUM
         AND TL.TXDATE =SETR.TXDATE
         AND SETR.TXCD = APP.TXCD
         AND SB.CODEID=SUBSTR (SETR.ACCTNO, 11, 6)
         AND APP.APPTYPE = 'SE'
         AND APP.TXTYPE IN ('C', 'D')
         AND TRIM (APP.FIELD) IN('TRADE','SECURED','MORTAGE')
         AND  SUBSTR(SETR.ACCTNO,1,10) LIKE V_STRAFACCTNO
         AND  SETR.NAMT<>0
         AND TL.DELTD<>'Y'

  UNION ALL

-------NHUNG GIAO DICH LENH
  SELECT  MAX(SETR.ACCTNO) ACCTNO,TO_CHAR( MAX(SB.SYMBOL)) SYMBOL,  MAX(TL.BUSDATE) BUSDATE
  , MAX(TL.TXDATE) TXDATE, MAX(TL.TXNUM) TXNUM, TO_CHAR(MAX(TL.TXDESC)) DESCRIPTION,
 sum(CASE WHEN APP.TXTYPE ='C' THEN SETR.NAMT ELSE 0 END)CAMT ,
 sum(CASE WHEN APP.TXTYPE ='D' THEN SETR.NAMT ELSE 0 END)DAMT, SETR.ref ORDERID

 FROM
 ( SELECT * FROM TLLOG
    WHERE BUSDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY')--F_DATE
    AND BUSDATE <= TO_DATE   (T_DATE, 'DD/MM/YYYY') --TDATE
    AND TLTXCD  IN( '8824' ,'8823', '8868', '8867','2248')
 ) TL, APPTX APP,SETRAN SETR, SBSECURITIES SB
 WHERE   TL.TXNUM = SETR.TXNUM
     AND TL.TXDATE =SETR.TXDATE
     AND SETR.TXCD = APP.TXCD
     AND SB.CODEID=SUBSTR (SETR.ACCTNO, 11, 6)
     AND APP.APPTYPE = 'SE'
     AND APP.TXTYPE IN ('C', 'D')
     AND TRIM (APP.FIELD) IN('TRADE','SECURED','MORTAGE')
     AND  SUBSTR(SETR.ACCTNO,1,10) LIKE V_STRAFACCTNO
     AND  SETR.NAMT<>0
     AND TL.DELTD<>'Y'
  GROUP BY SETR.ref,APP.TXTYPE

UNION ALL

SELECT  MAX(SETR.ACCTNO) ACCTNO,TO_CHAR( MAX(SB.SYMBOL)) SYMBOL,  MAX(TL.BUSDATE) BUSDATE
  , MAX(TL.TXDATE) TXDATE, MAX(TL.TXNUM) TXNUM, TO_CHAR(MAX(TL.TXDESC)) DESCRIPTION,
  sum(CASE WHEN APP.TXTYPE ='C' THEN SETR.NAMT ELSE 0 END)CAMT ,
  sum(CASE WHEN APP.TXTYPE ='D' THEN SETR.NAMT ELSE 0 END)DAMT, SETR.ref ORDERID

FROM
(
    SELECT * FROM TLLOGALL
    WHERE BUSDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY') --FDATE
    AND BUSDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY') --TDATE
    AND TLTXCD  IN( '8824' ,'8823', '8868', '8867','2248')
) TL, APPTX APP,SETRANA SETR,SBSECURITIES SB
  WHERE   TL.TXNUM = SETR.TXNUM
     AND TL.TXDATE =SETR.TXDATE
     AND SETR.TXCD = APP.TXCD
     AND SB.CODEID=SUBSTR (SETR.ACCTNO, 11, 6)

     AND APP.APPTYPE = 'SE'
     AND APP.TXTYPE IN ('C', 'D')
     AND TRIM (APP.FIELD) IN('TRADE','SECURED','MORTAGE')
     AND  SUBSTR(SETR.ACCTNO,1,10) LIKE V_STRAFACCTNO
     AND  SETR.NAMT<>0
     AND TL.DELTD<>'Y'
      GROUP BY SETR.ref,APP.TXTYPE
                         )
              BALANCE
    WHERE BE_BALANCE.ACCTNO = BALANCE.ACCTNO
   ORDER BY BALANCE.BUSDATE,BALANCE.TXDATE, BALANCE.TXNUM
)
union all -------------------------UNION SE0006-------------------
(
SELECT '001' A0 ,V_STRFULLNAME A1 ,se.AFACCTNO A2, to_char(T_DATE) A3 ,se.ACCTNO A4 ,to_Char(sb.symbol) A5,  ' ' A6, to_Char(cf.fullname) A7,
      to_char(se.trade - NVL (num.trade, 0) - NVL(od.secureamt,0)) A8,     to_char(nvl(b.qtty,0)- NVL (num.blocked, 0) )A9,
      to_char(se.mortage - NVL (num.mortage, 0) -NVL(od.securemtg,0)) A10, (se.senddeposit + se.deposit - NVL (num.deposit, 0)) A11,
      (se.receiving - NVL (num.receiving, 0) + NVL(od.receiving,0)) A12,  to_char(NVL(od.secureamt,0) + NVL(od.securemtg,0) - NVL (num.secured, 0)) A13,
      (se.dtoclose + se.withdraw - NVL (num.dtoclose, 0)) A14, (se.netting - NVL (num.netting, 0)) A15, nvl(odsts.sereceiving,0) A16,V_STRLG A17, V_A6 A18
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
                               and tr.acctno like  V_STRAFACCTNO||'%'
                               AND app.apptype = 'SE'
                               AND app.txtype IN ('C', 'D')
                               AND tl.deltd <> 'Y'
                               AND tl.busdate > TO_DATE (T_DATE, 'DD/MM/YYYY') --IDATE
  group by    tr.acctno
  ) num,
  (SELECT   acctno, SUM (qtty) qtty
                      FROM semastdtl
                     WHERE deltd <> 'Y'
                  GROUP BY acctno) b,
  afmast af,
  cfmast cf,
  (select * from sbsecurities where SYMBOL like V_STRSYMBOL) sb, -- V_STRSYMBOL
  (SELECT    seacctno seacctno,
        SUM (case when od.exectype IN ('NS', 'SS') then remainqtty + execqtty else 0 end)  secureamt,
        SUM (case when od.exectype ='MS' then remainqtty + execqtty else 0 end)  securemtg,
        SUM (case when od.exectype ='NB' then execqtty else 0 end) receiving
        FROM odmast od
        WHERE
        od.seacctno like V_STRAFACCTNO||'%'
        AND od.txdate =to_date(T_DATE, 'DD/MM/YYYY' ) --IDATE
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
            AND ST.status = 'N'
            AND TYP.TRANDAY <= (SELECT (CASE WHEN ST.CLEARCD='B' THEN SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1 ELSE SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 1 ELSE 1 END)-1 END)
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')) --IDATE
            AND ST.CLEARDAY > (SELECT (CASE WHEN ST.CLEARCD='B' THEN SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1 ELSE SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 1 ELSE 1 END)-1 END)
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')) --IDATE
        )
        UNION ALL
        (SELECT ST.ACCTNO, ST.QTTY
        FROM ODMASTHIST OD, STSCHDHIST ST, ODTYPE TYP
        WHERE ST.DELTD <>'Y' AND OD.ORDERID = ST.ORGORDERID AND ST.DUETYPE = 'RS'
            AND ST.acctno LIKE V_STRAFACCTNO||'%'
            And OD.ACTYPE = TYP.ACTYPE
            AND TYP.TRANDAY <= (SELECT (CASE WHEN ST.CLEARCD='B' THEN SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1 ELSE SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 1 ELSE 1 END)-1 END)
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')) --IDATE
            AND ST.CLEARDAY > (SELECT (CASE WHEN ST.CLEARCD='B' THEN SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 0 ELSE 1 END)-1 ELSE SUM(CASE WHEN CLDR.HOLIDAY = 'Y' THEN 1 ELSE 1 END)-1 END)
                                FROM SBCLDR CLDR
                                WHERE CLDR.CLDRTYPE = '000'
                                    AND CLDR.SBDATE >= ST.TXDATE
                                    AND CLDR.SBDATE <= TO_DATE(T_DATE,'DD/MM/YYYY')) --IDATE
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
    and se.afacctno= V_STRAFACCTNO
     and (
          (se.trade - NVL (num.trade, 0) - NVL(od.secureamt,0)  ) <>0
    or   (b.qtty- NVL (num.blocked, 0) )<>0
    or   (se.mortage - NVL (num.mortage, 0) -NVL(od.securemtg,0))  <>0
    or (se.senddeposit + se.deposit - NVL (num.deposit, 0)) <>0
    or (se.receiving - NVL (num.receiving, 0)) <>0
    or  (NVL(od.secureamt,0)   +  NVL(od.securemtg,0) - NVL (num.secured, 0)) <>0
    or  (se.dtoclose + se.withdraw - NVL (num.dtoclose, 0)) <>0
    or  (se.netting - NVL (num.netting, 0)) <>0)
    and se.acctno = odsts.acctno(+)
     --order by symbol
);
end if;

EXCEPTION
   WHEN OTHERS   THEN
      RETURN;
END;-- PROCEDURE
/

