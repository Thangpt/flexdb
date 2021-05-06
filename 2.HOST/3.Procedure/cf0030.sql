CREATE OR REPLACE PROCEDURE cf0030 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD    IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
   )
IS
--
-- PURPOSE: Bao cao thue thu nhap ca nhan
-- PERSON      DATE    COMMENTS
-- Hien.vu    08-05-2011  CREATE

-- ---------   ------  -------------------------------------------

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (40);
    V_INBRID       VARCHAR2 (4);
    V_STRCUSTODYCD     VARCHAR2 (20);
    V_STRAFACCTNO     VARCHAR2 (20);
BEGIN
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   IF (V_STROPTION = 'A') THEN
      V_STRBRID := '%';
   ELSIF (V_STROPTION = 'B') then
        select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
   else
        V_STRBRID := V_INBRID;
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
    Select TL.MSGACCT AFACCTNO,  TL.MSGAMT  TTNCN ,to_Char(TL.txdesc)TXDESC ,
        tl.txdate
    From
         (
         Select MSGACCT  ,MSGAMT , txdesc , TXDATE, txnum   from TLLOG where TLTXCD='0066'   AND deltd <> 'Y'
         union all
         Select MSGACCT  ,  MSGAMT , txdesc , TXDATE, txnum from TLLOGALL where TLTXCD='0066' AND deltd <> 'Y'
         )TL,
         (
            Select  txnum ,txdate , namt from citran  where txcd ='0011' and deltd <>'Y'
            union all
            Select  txnum ,txdate , namt from citrana where  txcd ='0011'  and deltd <>'Y'
        ) CI
          Where  TL.MSGACCT  LIKE V_STRAFACCTNO
          and TL.TXDATE  >= to_date (F_DATE,'dd/mm/yyyy')
           and TL.TXDATE  <= to_date (T_DATE ,'dd/mm/yyyy')
           and tl.txnum = CI.txnum
            and    TL.txdate = CI.txdate

     UNION all
    -------Thue thu nhap ca nhan theo giao dich 3350
     Select  TL.msgacct AFACCTNO , CI.namt TTNCN,to_Char(TL.txdesc) TXDESC ,
         tl.txdate
     from
        (
        Select  txnum ,txdate ,msgacct, txdesc   from TLLOG where tltxcd='3350'    and DELTD  <>'Y'
        union all
        Select  txnum ,txdate ,msgacct, txdesc  from TLLOGALL where tltxcd='3350'  and DELTD  <>'Y'
        ) TL ,
        (
        Select  txnum ,txdate , namt from citran  where txcd ='0011' and deltd <>'Y'
        union all
        Select  txnum ,txdate , namt from citrana where  txcd ='0011'  and deltd <>'Y'
        ) CI
        where  TL.txnum = CI.txnum
        and    TL.txdate = CI.txdate
          and  TL.MSGACCT  LIKE V_STRAFACCTNO
          and TL.TXDATE  >= to_date (F_DATE,'dd/mm/yyyy')
          and TL.TXDATE  <= to_date (T_DATE ,'dd/mm/yyyy')

          UNION ALL

           Select  TL.msgacct AFACCTNO , CI.namt TTNCN,to_Char(TL.txdesc1) TXDESC  ,
            tl.txdate
           from
        (
        Select  txnum ,txdate , SUBSTR(MSGACCT,0,10) msgacct,
        'Thue giao dich lo le ngay ' || to_char(txdate,'dd/mm/yyyy')  txdesc1   from TLLOG where tltxcd='8815'    and DELTD  <>'Y'
        union all
        Select  txnum ,txdate , SUBSTR(MSGACCT,0,10) msgacct,
        'Thue giao dich lo le ngay ' ||  to_char(txdate,'dd/mm/yyyy') txdesc1   from TLLOGALL where tltxcd='8815'  and DELTD  <>'Y'
        ) TL ,
        (
        Select  txnum ,txdate , namt from citran  where txcd ='0011' and deltd <>'Y' and tltxcd='8815'
        union all
        Select  txnum ,txdate , namt from citrana where  txcd ='0011'  and deltd <>'Y' and tltxcd='8815'
        ) CI
        where  TL.txnum = CI.txnum
        and    TL.txdate = CI.txdate
          and TL.MSGACCT  LIKE V_STRAFACCTNO
          and TL.TXDATE  >= to_date (F_DATE,'dd/mm/yyyy')
          and TL.TXDATE  <= to_date (T_DATE ,'dd/mm/yyyy')

     ) TH , AFMAST af , CFMAST cf
     where af.custid= cf.custid
     and TH.AFACCTNO = AF.ACCTNO
     and (af.brid like V_STRBRID or instr(V_STRBRID,af.brid) <> 0)
     and cf.custodycd Like V_STRCUSTODYCD
     order by cf.custodycd , TH.txdate

     ;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

