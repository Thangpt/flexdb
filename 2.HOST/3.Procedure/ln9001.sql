CREATE OR REPLACE PROCEDURE ln9001 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   CUSTODYCD       IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2
  )
IS

   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);

   v_IDate date;
   v_CustodyCD varchar2(20);
   v_AFAcctno varchar2(20);
   v_T1Date date;
   v_T2Date date;

BEGIN
    V_STROPTION := upper(OPT);
    V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

v_IDATE:= to_date(I_DATE,'DD/MM/RRRR');
select to_date(min(sbdate),'DD/MM/RRRR') into v_T1Date from sbcldr where cldrtype = '000' and sbdate > v_IDATE;
select to_date(min(sbdate),'DD/MM/RRRR') into v_T2Date from sbcldr where sbdate > (select min(sbdate) from sbcldr where cldrtype = '000' and sbdate > v_IDATE) and cldrtype = '000';

if v_CustodyCD = 'ALL' or v_CustodyCD is null then
    v_CustodyCD := '%';
else
    v_CustodyCD := v_CustodyCD;
end if;

if v_AFAcctno = 'ALL' or v_AFAcctno is null then
    v_AFAcctno := '%';
else
    v_AFAcctno := v_AFAcctno;
end if;


OPEN PV_REFCURSOR FOR

select main.*,re.*,nvl(hmdc.amt,0) hmdc, 'T0' lbl
      , nvl(ln.rlsamt,0) pvMR --phat vay Margin trong ngay
      , nvl(Tln.DnBLlk,0) /*-  nvl(ln.CLrlsamt,0)*/ dnCL --du no bao lanh luy ke
      , nvl(ln.CLrlsamt,0) pvCL --phat vay bao lanh trong ngay
      , v_IDATE rpt_date
      , ln.rlsdate npv,  ln.overduedate ntt
      --neu len bao cao trong qua khu, ngay T0 co du no bao lanh luy ke > 0 thi gia tri T1 = tien ban + tien mat trong ngay T1
      , case when getcurrdate > v_IDATE and nvl(Tln.DnBLlk,0) /*-  nvl(ln.CLrlsamt,0)*/ >0 then nvl(T1.tm_tctu,0)
            else 0 end T1tm
      , case when getcurrdate > v_IDATE and  nvl(T1Tln.DnBLlk,0)/*-  nvl(T1ln.CLrlsamt,0)*/ >0 then nvl(T2.tm_tctu,0)
            else 0 end T2tm

from
(
select cf.custid, cf.custodycd, af.acctno, cf.fullname
    ,case when getcurrdate = v_IDATE then nvl(b.buyamt,0)
        else nvl(mr.bamt,0)  end buyamt
    ,case when getcurrdate = v_IDATE then  trunc (ci.balance)/*-nvl(b.secureamt,0)*/-nvl (b.advamt, 0) + nvl(adv.advamt,0)
        else nvl(mr.balance,0) + nvl(mr.receiving,0) end  tm_tctu
from cfmast cf, afmast af,  cimast ci, v_getbuyorderinfo b, v_getAccountAvlAdvance adv, (select * from log_mr4000 where txdate = v_IDATE) mr
where cf.custid = af.custid  and af.acctno like v_AFAcctno and cf.custodycd like v_CustodyCD
and ci.acctno = b.afacctno (+) and ci.acctno = af.acctno
and ci.acctno = adv.afacctno  (+) and ci.acctno = mr.afacctno (+)
) main
left join
(
select  r.afacctno, r.reacctno, cf.fullname BMname
from reaflnk r, recfdef rc, recflnk rl, retype rt, cfmast cf
where  v_IDATE between r.frdate and nvl(r.clstxdate -1, r.todate)
and r.reacctno = rl.custid||rc.reactype and rl.autoid = rc.refrecflnkid and rc.reactype = rt.actype
and rt.rerole in ('BM','RM') and cf.custid = rl.custid
and v_IDATE between rc.effdate and nvl(rc.closedate - 1, rc.expdate)
) re
on main. acctno = re.afacctno
left join
(select acctno, sum(case when txcd = '0022' then -namt else namt end) amt from vw_aftran_all where tltxcd in ('1810','1811') and txcd in ('0062','0022')
    and txdate = v_IDate
    group by acctno
) hmdc
on main.acctno = hmdc.acctno
left join
(select l.afacctno
    , case when ln.reftype = 'GP' then l.rlsdate else null end rlsdate
    , case when ln.reftype = 'GP' then l.overduedate else null end overduedate
    , sum(case when ln.reftype = 'P' then l.rlsamt else 0 end) rlsamt
    , sum(case when ln.reftype = 'GP' then l.rlsamt else 0 end) CLrlsamt
    --, sum(case when ln.reftype = 'GP' then l.totalprinamt else 0 end) prinamt
    from rlsrptlog_eod l, vw_lnschd_all ln where l.rlsdate = v_IDATE and l.lnschdid = ln.autoid and ln.reftype in ('P','GP')
    group by l.afacctno, l.rlsdate, l.overduedate, ln.reftype
) ln on main.acctno = ln.afacctno
left join
(
select l.trfacctno acctno, sum(x.be_amt) DnBLlk  from
(SELECT A.AUTOID,a.acctno, A.AMT - NVL(MOV_PAID,0)  BE_AMT FROM
     (SELECT SUM(NML + OVD + PAID + INTDUE + INTOVD + INTPAID + FEEDUE + FEEOVD + FEEPAID + intnmlacr + intovdprin ) AMT, AUTOID, acctno  FROM VW_LNSCHD_ALL
     WHERE NML + OVD + PAID <>0 AND RLSDATE < v_IDATE  and reftype = 'GP' GROUP BY AUTOID, acctno
     ) A
     LEFT JOIN
     (SELECT  AUTOID, SUM(PAID + INTPAID + FEEPAID + FEEINTPAID) MOV_PAID FROM VW_LNSCHDLOG_ALL
     WHERE NVL(DELTD,'N') <>'Y' AND TXDATE < v_IDATE GROUP BY AUTOID
     ) B  ON A.AUTOID = B.AUTOID
 )x, lnmast l
 where l.acctno = x.acctno
 group by l.trfacctno
) Tln on main.acctno = Tln.acctno
left join
(
select  ci.acctno
    ,case when getcurrdate = v_T1Date then nvl(b.buyamt,0)
        else nvl(mr.bamt,0)  end bamt
    ,case when getcurrdate = v_T1Date then  trunc (ci.balance)/*-nvl(b.secureamt,0)*/-nvl (b.advamt, 0) + nvl(adv.advamt,0)
        else nvl(mr.balance,0) + nvl(mr.receiving,0) end  tm_tctu
from   cimast ci, v_getbuyorderinfo b, v_getAccountAvlAdvance adv, (select * from log_mr4000 where txdate = v_T1Date) mr
where  ci.acctno = b.afacctno (+)
and ci.acctno = adv.afacctno  (+) and ci.acctno = mr.afacctno (+)

--select   afacctno, bamt, balance, receiving from log_mr4000 where txdate = (select min(sbdate) from sbcldr where cldrtype = '000' and sbdate > v_IDATE)
) T1 on main.acctno = T1.acctno
left join
(
select  ci.acctno
    ,case when getcurrdate = v_T2Date then nvl(b.buyamt,0)
        else nvl(mr.bamt,0)  end bamt
    ,case when getcurrdate = v_T2Date then  trunc (ci.balance)/*-nvl(b.secureamt,0)*/-nvl (b.advamt, 0) + nvl(adv.advamt,0)
        else nvl(mr.balance,0) + nvl(mr.receiving,0) end  tm_tctu
from cimast ci, v_getbuyorderinfo b, v_getAccountAvlAdvance adv, (select * from log_mr4000 where txdate = v_T2Date ) mr
where  ci.acctno = b.afacctno (+)
and ci.acctno = adv.afacctno  (+) and ci.acctno = mr.afacctno (+)
--select   afacctno, bamt, balance, receiving from log_mr4000 where txdate = (select min(sbdate) from sbcldr where sbdate > (select min(sbdate) from sbcldr where cldrtype = '000' and sbdate > v_IDATE) and cldrtype = '000')
) T2 on main.acctno = T2.acctno
left join
(select l.afacctno, l.rlsdate, l.overduedate
    , sum(case when ln.reftype = 'P' then l.rlsamt else 0 end) rlsamt
    , sum(case when ln.reftype = 'GP' then l.rlsamt else 0 end) CLrlsamt
    --, sum(case when ln.reftype = 'GP' then l.totalprinamt else 0 end) prinamt
    from rlsrptlog_eod l, vw_lnschd_all ln where l.rlsdate = v_T1Date and l.lnschdid = ln.autoid and ln.reftype in ('P','GP') group by l.afacctno, l.rlsdate, l.overduedate
) T1ln on main.acctno = T1ln.afacctno
left join
(
select l.trfacctno acctno, sum(x.be_amt) DnBLlk from
(SELECT A.AUTOID,a.acctno, A.AMT - NVL(MOV_PAID,0)  BE_AMT FROM
     (SELECT SUM(NML + OVD + PAID + INTDUE + INTOVD + INTPAID + FEEDUE + FEEOVD + FEEPAID) AMT, AUTOID, acctno  FROM VW_LNSCHD_ALL
     WHERE NML + OVD + PAID <>0  and reftype = 'GP' AND RLSDATE < v_T1Date  GROUP BY AUTOID, acctno
     ) A
     LEFT JOIN
     (SELECT  AUTOID, SUM(PAID + INTPAID + FEEPAID + FEEINTPAID) MOV_PAID FROM VW_LNSCHDLOG_ALL
     WHERE NVL(DELTD,'N') <>'Y' AND TXDATE < v_T1Date GROUP BY AUTOID
     ) B  ON A.AUTOID = B.AUTOID
 )x, lnmast l
 where l.acctno = x.acctno
 group by l.trfacctno
)T1Tln on main.acctno = T1Tln.acctno
where    nvl(hmdc.amt,0) +  nvl(Tln.DnBLlk,0)  +  nvl(ln.CLrlsamt,0) > 1
;

EXCEPTION
  WHEN OTHERS
   THEN
      Return;
End;
/

