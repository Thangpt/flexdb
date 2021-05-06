CREATE OR REPLACE PROCEDURE ca0013 (
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
-- PURPOSE: Bao cao giao dich chung khoan lo le
-- PERSON      DATE        COMMENTS
-- Quyet.kieu  09-03-2011  CREATE

-- ---------   ------  -------------------------------------------

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPTION        VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (4);
    V_STRCUSTODYCD     VARCHAR2 (20);
    V_STRAFACCTNO      VARCHAR2 (20);
BEGIN
   V_STROPTION := OPT;

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
          Select TL.txdate,TL.AFACCTNO ,CF.custodycd SO_TKLK ,sb.symbol Symbol, TL.CODEID,TL.KL KLTH,
           to_number(CI.ref) Gia_tham_chieu ,to_number(CI.namt /TL.KL) GIa_thuc_hien,tl.TAX  from
        (
            SELECT al.txnum,al.txdate,max(substr(al.msgacct,0,10)) AFACCTNO ,
                max(substr(msgacct,11,06)) CODEID ,max(msgamt) KL,
                max(decode(fld.fldcd,'14',nvalue,null)) TAX
            FROM vw_tllog_all al,vw_tllogfld_all fld
            WHERE
                al.txnum=fld.txnum
                and al.txdate=fld.txdate
                and al.tltxcd='8815'
                and al.deltd<>'Y'
            group by al.txnum,al.txdate
        ) TL ,
        (
        Select txnum,txdate,namt,ref from citran where txcd='0028' and deltd <> 'Y' and tltxcd='8815'
        union all
        Select txnum,txdate,namt,ref from citrana  where txcd='0028' and deltd <> 'Y' and tltxcd='8815'
        )CI , AFmast af , CFMAST cf , sbsecurities sb
        where TL.txnum=CI.txnum
        and TL.txdate = CI.txdate
        and af.Acctno= TL.afacctno
        and af.custid = cf.custID
        and TL.codeid=sb.codeid
        and CF.custodycd like V_STRCUSTODYCD
        and TL.afacctno  like V_STRAFACCTNO
        and TL.TXDATE  >= to_date (F_DATE,'dd/mm/yyyy')
        and TL.TXDATE  <= to_date (T_DATE ,'dd/mm/yyyy');

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

