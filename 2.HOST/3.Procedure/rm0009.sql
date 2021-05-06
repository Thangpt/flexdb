CREATE OR REPLACE PROCEDURE RM0009 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD    IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   COREBANK       IN       VARCHAR2
   )
IS
--
-- PURPOSE: Bao cao thue thu nhap ca nhan
-- PERSON      DATE    COMMENTS
-- Quyet.kieu  08-03-2011  CREATE

-- ---------   ------  -------------------------------------------

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);
    V_STRCUSTODYCD     VARCHAR2 (20);
    V_STRAFACCTNO     VARCHAR2 (20);
    V_COREBANK        VARCHAR2(10);
BEGIN
   V_STROPTION := OPT;

   V_COREBANK:=NVL(COREBANK,'Y');
   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

    IF (PV_CUSTODYCD <> 'ALL')
   THEN
      V_STRCUSTODYCD := PV_CUSTODYCD;
   ELSE
      V_STRCUSTODYCD := '%%';
   END IF;


      IF (PV_AFACCTNO <> 'ALL')
   THEN
      V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;



   --GET REPORT'S PARAMETERS

OPEN PV_REFCURSOR
   FOR
   Select cf.fullname , cf.idcode , cf.custodycd , TH.TTNCN , TH.TXDESC from
     (
    -------Thue thu nhap ca nhan theo giao dich 0066
    Select TL.MSGACCT AFACCTNO,  TL.MSGAMT  TTNCN ,to_Char(TL.txdesc)TXDESC  From
         (
         Select MSGACCT  ,MSGAMT , txdesc , TXDATE   from TLLOG where TLTXCD='0066'   AND deltd <> 'Y'
         union all
         Select MSGACCT  ,  MSGAMT , txdesc , TXDATE from TLLOGALL where TLTXCD='0066' AND deltd <> 'Y'
         )TL
          Where  TL.MSGACCT  LIKE V_STRAFACCTNO
          and TL.TXDATE  >= to_date (F_DATE,'dd/mm/yyyy')
           and TL.TXDATE  <= to_date (T_DATE ,'dd/mm/yyyy')

     ) TH ,AFMAST af , CFMAST cf
     where
     af.custid= cf.custid
     and TH.AFACCTNO = AF.ACCTNO
     AND AF.COREBANK=V_COREBANK
     and cf.custodycd Like V_STRCUSTODYCD
     order by cf.custodycd

     ;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

