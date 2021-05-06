CREATE OR REPLACE PROCEDURE se0019 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2,
   symbol         in       VARCHAR2
  )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO TAI KHOAN TIEN TONG HOP CUA NGUOI DAU TU
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   20-DEC-06  CREATED
-- ---------   ------  -------------------------------------------

   CUR             PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   V_STRAFACCTNO  VARCHAR2 (20);
   V_STRSYMBOL  VARCHAR2 (20);

BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   IF (V_STRSYMBOL <> 'ALL')
   THEN
      V_STRSYMBOL := SYMBOL;
   ELSE
      V_STRSYMBOL := '%%';
   END IF;
   -- GET REPORT'S PARAMETERS


   IF (AFACCTNO <> 'ALL')
   THEN
      V_STRAFACCTNO :=  AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;
   -- END OF GETTING REPORT'S PARAMETERS
--TINH NGAY NHAN THANH TOAN BU TRU

OPEN  PV_REFCURSOR FOR
SELECT  TL.busdate,GETDUEDATE(TL.busdate,'B','001',3) t3,SB.symbol ,CF.custodycd ,CF.fullname ,
nvl(sum(case when  TLTXCD='2252' then TL.msgamt end ),0) RM,nvl(sum(case when  TLTXCD='2250' then TL.msgamt end ),0) SM
FROM TLLOG TL,SBSECURITIES SB, AFMAST AF, CFMAST CF
WHERE SUBSTR(TL.msgacct,11,6)=SB.codeid
AND SUBSTR(TL.msgacct,1,10) =AF.acctno
AND AF.custid =CF.custid AND TLTXCD in('2252','2250')
and AF.acctno like V_STRAFACCTNO
and sb.symbol  like V_STRSYMBOL
and tl.busdate <=to_date (T_DATE,'DD/MM/YYYY' )
and tl.busdate >=to_date (F_DATE,'DD/MM/YYYY' )
and tl.deltd <>'Y'
GROUP BY TL.busdate,GETDUEDATE(TL.busdate,'B','001',3) ,SB.symbol ,CF.custodycd ,CF.fullname
union all
SELECT  TL.busdate,GETDUEDATE(TL.busdate,'B','001',3) t3,SB.symbol ,CF.custodycd ,CF.fullname ,
nvl(sum(case when  TLTXCD='2252' then TL.msgamt end ),0) RM,nvl(sum(case when  TLTXCD='2250' then TL.msgamt end ),0) SM
FROM TLLOGall TL,SBSECURITIES SB, AFMAST AF, CFMAST CF
WHERE SUBSTR(TL.msgacct,11,6)=SB.codeid
AND SUBSTR(TL.msgacct,1,10) =AF.acctno
AND AF.custid =CF.custid AND TLTXCD in('2252','2250')
and AF.acctno like V_STRAFACCTNO
and sb.symbol  like V_STRSYMBOL
and tl.busdate <=to_date (T_DATE,'DD/MM/YYYY' )
and tl.busdate >=to_date (F_DATE,'DD/MM/YYYY' )
and tl.deltd <>'Y'
GROUP BY TL.busdate,GETDUEDATE(TL.busdate,'B','001',3) ,SB.symbol ,CF.custodycd ,CF.fullname

;




EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

