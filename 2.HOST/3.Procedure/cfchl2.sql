CREATE OR REPLACE PROCEDURE cfchl2 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   IN_DATE         IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   ACTYPE       in       varchar2,
   CAREBY       IN       VARCHAR2,
   I_BRID       IN       VARCHAR2,
   TLID IN VARCHAR2

   )
is
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
--V_CRRDATE date;
   V_STRI_BRID      VARCHAR2 (5);
   V_IDATE      date;
   v_custodycd varchar2(20);
   v_actype     varchar2 (4);
    v_careby varchar2(4);
   v_brid varchar2(4);
   v_TLID varchar2(4);



BEGIN
 V_STROPTION := OPT;

 IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

    IF PV_CUSTODYCD ='ALL' THEN
        v_custodycd :='%%';
    ELSE
        v_custodycd := PV_CUSTODYCD;
    END IF;

    IF CAREBY='ALL' THEN
        v_careby :='%%';
    ELSE
        v_careby := CAREBY;
    END IF;

    IF I_BRID='ALL' THEN
        v_brid :='%%';
    ELSE
        v_brid := I_BRID;
    END IF;

 V_IDATE := to_date (IN_DATE,'DD/MM/RRRR');
 v_actype :=actype;
 v_TLID := TLID;

OPEN PV_REFCURSOR FOR

select V_IDATE ngay,af.actype,cf.OPNDATE OPNCUST, af.OPNDATE OPNCUST_sub, cf.CUSTODYCD Cust, af.acctno cust_sub, cf.FULLNAME ten_KH,  re.reid BR_code, re.REFULLNAME BR_name,
cf.brid,sum(nvl(nav_1,0))nav_1, sum(nvl(nav,0)) nav,sum(nvl(trade,0)) trade,sum(nvl(Debt,0)) debt,sum(nvl(trade_fee,0)) trade_fee,sum(nvl(intfee,0)) intfee
,sum(nvl(right_16,0)) right_16,sum(nvl(Depo_amt,0)) depo_amt,sum(nvl(tranf_symbol,0))tranf_symbol,sum(nvl(withd_amt,0))withd_amt, sum(nvl(PT_amt,0)) PT_amt,brg.brname br_name
from  --, afmast af,LOG_SA0015 lo_1
cfmast cf,BRGRP brg, afmast af
left join
    (
 select lo.afacctno acctno, lo.txdate,sum(nvl(lo_1.navamt_ed,0)) nav_1,sum(nvl(lo.navamt_ed,0)) nav,sum(nvl(lo.ODEXECAMT,0)) trade,sum(nvl(lo.MRAMT,0)) Debt,sum(nvl(lo.ODFEEAMT,0)) trade_fee,sum(nvl(lo.MRINT_BEDAY,0))  intfee
  ,0 Depo_amt,0 withd_amt, 0 tranf_symbol,0 right_16, 0 PT_amt
    from LOG_SA0015 lo left join LOG_SA0015 lo_1 on lo.AFACCTNO =lo_1.AFACCTNO and lo_1.txdate = FN_GET_NEXTDATE(lo.txdate,-1)
    where lo.txdate =V_IDATE
    group by lo.afacctno, lo.txdate
union all
--n?p ti?n
    select acctno, txdate,0 nav_1,0 nav,0 trade,0 Debt,0 trade_fee,0 intfee ,sum(nvl(vw_ci.namt,0)+ nvl(vw_ci.camt,0)) Depo_amt,0 withd_amt, 0 tranf_symbol,0 right_16,0 PT_amt  --, nvl((case when vw_ci.tltxcd in ('1131','1141','1198') and vw_ci.field='BALANCE' and vw_ci.txtype='C' then nvl(vw_ci.namt,0)+ nvl(vw_ci.camt,0)end),0) Depo_amt
  from vw_citran_gen vw_ci where txdate =V_IDATE
  and vw_ci.tltxcd in ('1131','1141','1198','1120') and vw_ci.field='BALANCE' and vw_ci.txtype='C'
  group by acctno, txdate
union all
--rút ti?n
    select acctno, txdate,0 nav_1,0 nav,0 trade,0 Debt,0 trade_fee,0 intfee ,0 Depo_amt, sum (nvl(vw_ci1.namt,0)+ nvl(vw_ci1.camt,0))  withd_amt, 0 tranf_symbol,0 right_16,0 PT_amt
  from vw_citran_gen vw_ci1
  where txdate =V_IDATE and vw_ci1.tltxcd in ('1101','1111','1118','1120','1129','1132','1133','1184','1185','1188','1199','1130')
   and vw_ci1.field='BALANCE' and vw_ci1.txtype='D'
   group by acctno,txdate
  union all
  -- GD tang gi?m ck
  select afacctno acctno,txdate,0 nav_1,0 nav,0 trade,0 Debt,0 trade_fee,0 intfee ,0 Depo_amt,0 withd_amt, sum(nvl(vw_se.namt,0)+ nvl(vw_se.camt,0)) tranf_symbol,0 right_16,0 PT_amt
 from vw_setran_gen VW_SE where txdate =V_IDATE and vw_se.tltxcd in ('2242', '2200'  , '2246', '2245'  ) and vw_se.field ='TRADE'
 group by   afacctno,txdate
  union all
 --Quy?n
 select acctno, txdate,0 nav_1,0 nav,0 trade,0 Debt,0 trade_fee,0 intfee ,0 Depo_amt,0 withd_amt, 0 tranf_symbol,sum(nvl(vw_ci12.namt,0)) right_16,0 PT_amt
  from vw_citran_gen vw_ci12 where txdate =V_IDATE and vw_ci12.tltxcd in ('3350','3354') and vw_ci12.field='BALANCE' and vw_ci12.txtype='C'
  group by acctno, txdate
  union all
  select afacctno, txdate,0 nav_1,0 nav,0 trade,0 Debt,0 trade_fee,0 intfee ,0 Depo_amt,0 withd_amt, 0 tranf_symbol,0 right_16,sum(EXECAMT) PT_amt
  from  VW_ODMAST_ALL od
  where matchtype ='P' and txdate =V_IDATE
group by afacctno,txdate

  ) a on af.acctno =a.acctno
  left join
(
 select re.afacctno, MAX(cf.fullname) refullname, MAX (substr(re.reacctno,1,10)) reid
    from reaflnk re, sysvar sys, cfmast cf, retype
    where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
        and substr(re.reacctno,0,10) = cf.custid
        and varname = 'CURRDATE' and grname = 'SYSTEM'
        and re.status <> 'C' and re.deltd <> 'Y'
        AND substr(re.reacctno,11) = retype.actype
        AND rerole IN ( 'RM','BM')
    GROUP BY afacctno) re on af.acctno =re.afacctno
    --left join BRGRP brg on  af.brid =brg.brid
where af.custid =cf.custid and af.actype =v_actype
and cf.brid=brg.brid
and cf.brid like v_brid
and cf.custodycd like v_custodycd
and af.careby like v_careby
and  exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = v_TLID )
 group by  cf.OPNDATE , af.OPNDATE , cf.CUSTODYCD , af.acctno , cf.FULLNAME ,  re.reid , re.REFULLNAME ,cf.brid ,af.actype,brg.brname;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/
