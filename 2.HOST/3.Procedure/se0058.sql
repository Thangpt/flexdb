CREATE OR REPLACE PROCEDURE SE0058 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
  -- PLSENT         IN       VARCHAR2
)
IS

-- RP NAME : YEU CAU CHUYEN KHOAN CHUNG KHOAN TAT TOAN TAI KHOAN
-- PERSON --------------DATE---------------------COMMENTS
-- VUNV            20/08/2015                 CREATE
-- ---------   ------  -------------------------------------------
   V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_CURRDATE DATE;
   V_STRFULLNAME  VARCHAR2(200);
   V_STR_TVLK_CODE  VARCHAR2(10);
   V_STR_TVLK_NAME  VARCHAR2(200);
   V_STR_CUSTODYCD_NHAN  VARCHAR2(10);
   CUR            PKG_REPORT.REF_CURSOR;

   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);
   V_STROPTION    VARCHAR2(5);

BEGIN
-- GET REPORT'S PARAMETERS
  V_STROPTION := upper(OPT);
  V_INBRID := BRID;
    if(V_STROPTION = 'A') then
        V_STRBRID := '%%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    end if;

    V_CUSTODYCD := UPPER( PV_CUSTODYCD);
    V_STR_TVLK_NAME :=' ';
    V_STR_TVLK_CODE :=' ';
    V_STRFULLNAME :=' ';


    SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURRDATE
     FROM SYSVAR WHERE VARNAME = 'CURRDATE' AND GRNAME = 'SYSTEM';

   IF  (PV_AFACCTNO <> 'ALL')
   THEN
         V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
         V_STRAFACCTNO := '%';
   END IF;

  SELECT FULLNAME INTO V_STRFULLNAME FROM CFMAST WHERE custodycd = V_CUSTODYCD;


 OPEN PV_REFCURSOR
 FOR

        SELECT   DT.CUSTODYCD, V_STRFULLNAME FULLNAME, cf.idcode DKNSH, cf.iddate Ngay_Cap, cf.idplace Noi_Cap,
        cf.address Dia_Chi,cf.phone Dien_Thoai, NVL(DeP.FULLNAME,' ') TEN_TVLK_NHAN, SO_TKLK_NHAN

  FROM
        (
                   SELECT     max(cf.custodycd) custodycd,
                              max(decode(fld.fldcd,'48',cvalue,null)) MA_TVLK_NHAN,
                               max(decode(fld.fldcd,'47',cvalue,null)) SO_TKLK_NHAN
                   FROM   vw_tllog_all tl, vw_tllogfld_all fld, cfmast cf, afmast af
                   WHERE   tl.tltxcd = '0088'  AND tl.DELTD = 'N'
                           and cf.custid = af.custid
                           and tl.msgacct = af.acctno
                           and fld.txnum=tl.txnum and fld.txdate=tl.txdate
                           AND tl.txdate >= TO_DATE (F_DATE,'DD/MM/RRRR')
                           AND tl.txdate <= TO_DATE (T_DATE,'DD/MM/RRRR')
                           and cf.custodycd like v_custodycd
                           group by /*tl.txnum*/ cf.custodycd,tl.txdate
                           ) DT, deposit_member dep, cfmast cf


 WHERE  DT.CUSTODYCD LIKE  v_custodycd
        and dt.MA_TVLK_NHAN = dep.DEPOSITID(+)
                           and cf.custodycd=dt.custodycd

         ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

