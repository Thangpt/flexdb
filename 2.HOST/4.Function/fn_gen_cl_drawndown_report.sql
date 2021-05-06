CREATE OR REPLACE FUNCTION fn_gen_cl_drawndown_report(p_type varchar2)
return boolean
IS

-- RP NAME : Giai Ngan Tien Vay
-- PERSON : LinhLNB
-- DATE : 04/04/2012
-- COMMENTS : Create New
-- ---------   ------  -------------------------------------------
l_CurrDate date;
l_RefType   varchar2(10);
BEGIN

l_CurrDate:= to_date(cspks_system.fn_get_sysvar('SYSTEM','CURRDATE'),'DD/MM/RRRR');

if p_type = 'T0' then
    l_RefType:= 'GP';
else
    l_RefType:= 'P';
end if;

insert into rlsrptlog_eod
(
custodycd,custid, afacctno, mrcrlimitmax, mrcrlimitremain,
       rlsamt, totalprinamt, totalodamt, seass, rate, cfrate,
       marginrate, rlsdate, overduedate, lnschdid, rrtype, custbank, marginratio
)

select mst.custodycd,  --custodycd
    mst.custid,
    mst.afacctno, -- afacctno
case when mst.ftype = 'AF' and mst.reftype = 'GP' then mst.t0loanlimit
    when mst.rrtype = 'B' then nvl(lmamt,0)
    else mst.mrloanlimit end
        mrcrlimitmax, -- mrcrlimitmax
greatest(
case when mst.ftype = 'AF' and mst.reftype = 'GP' then mst.t0loanlimit - nvl(trf.trft0amt,0) - nvl(mst.t0amt,0)
    when mst.rrtype = 'B' then nvl(lmamt,0) -nvl(lnmb_dfamt,0)-nvl(lnmb_mramt,0)
    else mst.mrloanlimit -nvl(mst.dfamt,0)-nvl(mst.mramt,0) end
        ,0)
        mrcrlimitremain, -- mrcrlimitremain
    rlsamt, -- rlsamt
greatest(
case when mst.ftype = 'AF' and mst.reftype = 'GP' then nvl(lnorgc.t0amt,0)
    when mst.rrtype = 'B' and mst.reftype = 'P' then nvl(lnorgb.dfamt,0) + nvl(lnorgb.mramt,0)
    when mst.rrtype <> 'B' and mst.reftype = 'P' and nvl(mst.chksysctrl,'N') = 'N' then nvl(lnorgc.dfcmpamt,0) + nvl(lnorgc.mrcmpamt,0)
    when mst.rrtype <> 'B' and mst.reftype = 'P' and nvl(mst.chksysctrl,'N') = 'Y' then nvl(mr74cmpprin,0)
    else 0 end
        ,0)
        totalprinamt, -- totalprinamt
    case when ftype = 'AF' and nvl(mst.chksysctrl,'N') = 'Y' and reftype = 'P' then nvl(mr74cmpamt,0)
        else nvl(lnorgall.curr_mramt,0) + nvl(trfsecuredamt,0) end totalodamt,
    case when ftype = 'AF' and nvl(mst.chksysctrl,'N') = 'Y' and reftype = 'P' then nvl(mr74ass,0)
        else nvl(NAVACCOUNTT2,0) end seass,
    rate,
    cfrate,

    round((case when ftype = 'DF' then 1
     when ftype = 'AF' and reftype = 'P' then
        case when (nvl(lnorgall.curr_mramt,0) + nvl(trfsecuredamt,0)) = 0 then 1
        when nvl(mst.chksysctrl,'N') = 'Y' then case when nvl(mr74cmpamt,0) = 0  then 1 else nvl(mr74ass,0) / nvl(mr74cmpamt,0) end
            else nvl(NAVACCOUNTT2,0) / (nvl(lnorgall.curr_mramt,0) + nvl(trfsecuredamt,0)) end
    else round(nvl(rlsmarginrate,0)/100,6) end)*100,4) marginrate,
    mst.rlsdate,
    mst.overduedate,
    mst.lnschdid,
    mst.rrtype,
    mst.custbank,
    mst.marginratio

from
(select cf.custodycd,cf.custid, af.acctno afacctno,
(ls.nml+ls.ovd+ls.paid) rlsamt,
case when ln.ftype = 'AF' and ls.reftype = 'GP' then ln.oprinnml+ln.oprinovd else ln.prinnml+ln.prinovd end lnprin,
case when ln.ftype = 'AF' and ls.reftype = 'GP' then ln.orate2 else ln.rate2 end rate,
case when ln.ftype = 'AF' and ls.reftype = 'GP' then 0 else ln.cfrate2 end cfrate,
ls.rlsdate, ls.overduedate,
ln.rrtype || case when ln.rrtype = 'B' then cfb.shortname when ln.rrtype = 'C' then 'BVSC' else null end rsctype,
ls.autoid lnschdid, ln.rrtype, ln.custbank, ln.ftype, ls.reftype, cf.t0loanlimit, cf.mrloanlimit,
nvl(lnm.t0amt,0) t0amt,  nvl(lnm.dfamt,0) dfamt , nvl(lnm.mramt,0) mramt, cfb.shortname bankname,
nvl(NAVACCOUNTT2,0) + greatest(nvl(sec.avladvance,0) + ci.balance,0) NAVACCOUNTT2, nvl(rlsmarginrate,0) rlsmarginrate, lnt.chksysctrl,
nvl(marginratio,0) marginratio
from cfmast cf, afmast af,cimast ci, vw_lnmast_all ln, lntype lnt, vw_lnschd_all ls, cfmast cfb,
    v_getsecmarginratio sec,
    (select af.custid, sum(decode(ln.ftype,'DF',1,0)*(ls.nml+ls.ovd)) dfamt,
        round(sum(decode(ln.ftype,'AF',1,0)*decode(ls.reftype,'P',1,0)*
            (ls.nml+ls.ovd+ls.intnmlacr+ls.intdue+ls.intovd+ls.intovdprin+ls.feeintnmlacr+ls.feeintdue+ls.feeintovdacr+ls.feeintnmlovd)),0) mramt,
        round(sum(decode(ln.ftype,'AF',1,0)*decode(ls.reftype,'GP',1,0)*(ls.nml+ls.ovd+ls.intnmlacr+ls.intdue+ls.intovd+ls.intovdprin)),0) t0amt
    from afmast af, lnmast ln, lnschd ls
    where ln.acctno = ls.acctno and ln.trfacctno = af.acctno and ls.reftype in ('P','GP')
    and ls.rlsdate < l_CurrDate
    group by af.custid) lnm
where cf.custid = af.custid and af.acctno = ci.acctno
    and af.acctno = ln.trfacctno
    and cf.custid = lnm.custid(+)
    and ln.acctno = ls.acctno
    and ln.actype = lnt.actype
    and af.acctno = sec.afacctno
    and ln.custbank = cfb.custid(+)
    and ls.reftype = l_RefType
    and ls.rlsdate = l_CurrDate
) mst,
(select cfl.bankid,cfe.custid, nvl(cfe.lmamt,cfl.lmamt) lmamt from cflimit cfl,
        (select cf.custid, cfe.bankid, cfe.lmsubtype, cfe.lmchktyp, cfe.lmtyp, cfe.lmamt
        from cfmast cf, cflimitext cfe
        where cf.custid = cfe.custid(+)) cfe
        where cfl.bankid = nvl(cfe.bankid,cfl.bankid)
        and cfl.lmsubtype = nvl(cfe.lmsubtype,cfl.lmsubtype)
        and cfl.lmchktyp = nvl(cfe.lmchktyp,cfl.lmchktyp)
        and cfl.lmtyp = nvl(cfe.lmtyp,cfl.lmtyp)
        AND cfl.LMSUBTYPE = 'DFMR') cfl,
/*(select af.custid,ln.custbank, sum(decode(ln.ftype,'DF',1,0)*(ls.nml+ls.ovd)) dfamt,
        round(sum(decode(ln.ftype,'AF',1,0)*decode(ls.reftype,'P',1,0)*decode(ln.rrtype,'B',0,1)*
            (ls.nml+ls.ovd)),0) mramt
    from afmast af, lnmast ln, lnschd ls
    where ln.acctno = ls.acctno and ln.trfacctno = af.acctno and ls.reftype in ('P','GP')
    and ln.rrtype = 'B'
    and ls.rlsdate < l_CurrDate
    group by af.custid, ln.custbank) lnmb,*/
(select af.custid,ln.custbank,
        round(sum(decode(ln.ftype,'DF',1,0)*decode(ln.rrtype,'B',1,0)*(ls.nml+ls.ovd)),0) dfamt,
        round(sum(decode(ln.ftype,'AF',1,0)*decode(ln.rrtype,'B',1,0)*decode(ls.reftype,'P',1,0)*(ls.nml+ls.ovd)),0) mramt,
        sum(CASE WHEN ls.rlsdate < l_CurrDate THEN decode(ln.ftype,'DF',1,0)*(ls.nml+ls.ovd) ELSE 0 END) lnmb_dfamt,
        round(sum(CASE WHEN ls.rlsdate < l_CurrDate THEN decode(ln.ftype,'AF',1,0)*decode(ls.reftype,'P',1,0)*decode(ln.rrtype,'B',0,1)*
            (ls.nml+ls.ovd) ELSE 0 END),0) lnmb_mramt
    from afmast af, lnmast ln, lnschd ls
    where ln.acctno = ls.acctno and ln.trfacctno = af.acctno and ls.reftype in ('P','GP')
    and ln.rrtype = 'B'
    and ls.rlsdate <= l_CurrDate
    group by af.custid, ln.custbank) lnorgb,
(select af.acctno,
        round(sum(decode(ln.ftype,'AF',1,0)*decode(ls.reftype,'P',1,0)
                *(ls.nml + ls.ovd + ls.intnmlacr + ls.intdue + ls.intovd + ls.intovdprin
                                        + ls.feeintnmlacr + ls.feeintdue + ls.feeintnmlovd + ls.feeintovdacr)),0) curr_mramt,
        round(sum(decode(ln.ftype,'AF',1,0)*decode(ls.reftype,'P',1,0)*decode(ln.rrtype,'B',0,1)*decode(lnt.chksysctrl,'Y',1,0)
                *(ls.nml + ls.ovd + ls.intnmlacr + ls.intdue + ls.intovd + ls.intovdprin
                                        + ls.feeintnmlacr + ls.feeintdue + ls.feeintnmlovd + ls.feeintovdacr)),0) mr74cmpamt,
        round(sum(decode(ln.ftype,'AF',1,0)*decode(ls.reftype,'P',1,0)*decode(ln.rrtype,'B',0,1)*decode(lnt.chksysctrl,'Y',1,0)
                *(ls.nml + ls.ovd)),0) mr74cmpprin
    from afmast af, lnmast ln, lnschd ls, lntype lnt
    where ln.acctno = ls.acctno and ln.trfacctno = af.acctno and ls.reftype = 'P' and ln.actype = lnt.actype
    and ls.rlsdate <= l_CurrDate
    group by af.acctno) lnorgall,
(select af.custid,
        round(sum(decode(ln.ftype,'AF',1,0)*decode(ls.reftype,'GP',1,0)
                *(ls.nml + ls.ovd + ls.intnmlacr + ls.intdue + ls.intovd + ls.intovdprin
                                        + ls.feeintnmlacr + ls.feeintdue + ls.feeintnmlovd + ls.feeintovdacr)),0) t0amt,
        round(sum(decode(ln.ftype,'DF',1,0)
                *(case when ls.rlsdate = l_CurrDate then ls.nml+ls.ovd + ls.paid else ls.nml+ls.ovd end)),0) dfcmpamt,
        round(sum(decode(ln.ftype,'AF',1,0)*decode(ls.reftype,'P',1,0)
                *(ls.nml + ls.ovd + ls.intnmlacr + ls.intdue + ls.intovd + ls.intovdprin
                                        + ls.feeintnmlacr + ls.feeintdue + ls.feeintnmlovd + ls.feeintovdacr)),0) mrcmpamt
    from afmast af, lnmast ln, lnschd ls
    where ln.acctno = ls.acctno and ln.trfacctno = af.acctno and ls.reftype in ('P','GP')
    and ls.rlsdate <= l_CurrDate
    group by af.custid) lnorgc,
(select af.custid, sum(trft0amt) trft0amt
    from stschd sts, afmast af
    where sts.afacctno = af.acctno and sts.deltd <> 'Y' and sts.duetype = 'SM'
        and sts.trfbuyext * sts.trfbuyrate * (amt - trfexeamt) > 0
    group by af.custid) trf,
(select sts.afacctno, sum(amt+feeacr-feeamt-trft0amt) trfsecuredamt
    from stschd sts, odmast od
    where od.orderid = sts.orgorderid and sts.deltd <> 'Y' and sts.duetype = 'SM'
        and sts.trfbuyext * sts.trfbuyrate * (amt - trfexeamt) > 0
    group by sts.afacctno) trf_secure,
(select apr.afacctno, sum(prinused*least(rsk.mrratiorate,100-mriratio)/100*least(rsk.mrpricerate,sec.marginrefcallprice)) mr74ass
    from vw_afpralloc_all apr, afmast af, afmrserisk rsk, securities_info sec
    where restype = 'M' and apr.codeid = sec.codeid and apr.afacctno = af.acctno and af.actype = rsk.actype and apr.codeid = rsk.codeid
    group by apr.afacctno) ass
where mst.custbank = cfl.bankid(+)
and mst.custid = cfl.custid(+)
/*and mst.custbank = lnmb.custbank(+)
and mst.custid = lnmb.custid(+)*/
and mst.custbank = lnorgb.custbank(+)
and mst.custid = lnorgb.custid(+)
and mst.custid = trf.custid(+)
and mst.afacctno = lnorgall.acctno(+)
and mst.afacctno = trf_secure.afacctno(+)
and mst.custid = lnorgc.custid(+)
and mst.afacctno = ass.afacctno(+)
and mst.reftype = l_RefType
and not exists (select 1 from rlsrptlog_eod r where r.rlsdate = mst.rlsdate and r.lnschdid = mst.lnschdid)
order by mst.custodycd, mst.afacctno;

return true;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN false;
END;
 
/
