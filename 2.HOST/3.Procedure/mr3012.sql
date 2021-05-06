CREATE OR REPLACE PROCEDURE mr3012 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   p_OPT                    IN       VARCHAR2,
   p_BRID                   IN       VARCHAR2,
   p_DATE                       IN       VARCHAR2
  )
IS

--
-- BAO CAO DANH MUC CHUNG KHOAN THUC HIEN GIAO DICH KI QUY
-- MODIFICATION HISTORY
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
--

   l_OPT varchar2(10);
   l_BRID varchar2(1000);
   l_BRID_FILTER varchar2(1000);
   l_CurrDate date;

BEGIN



    l_OPT:=p_OPT;

    IF (l_OPT = 'A') THEN
      l_BRID_FILTER := '%';
    ELSE if (l_OPT = 'B') then
            select brgrp.mapid into l_BRID_FILTER from brgrp where brgrp.brid = p_BRID;
        else
            l_BRID_FILTER := p_BRID;
        end if;
    END IF;

    select to_date(varvalue,'DD/MM/RRRR') into l_CurrDate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';

if l_CurrDate = to_date(p_DATE,'DD/MM/RRRR') then

    OPEN PV_REFCURSOR FOR
    /*select mst.*,
        greatest(round((case when nvl(mst.marginrate,0) * mst.mrmrate =0 then nvl(mst.outstanding,0) else
                         greatest( 0, nvl(mst.outstanding,0) - nvl(mst.navaccount,0) *100/mst.mrmrate) end),0),0) addvnd,
        nvl(refullname,'') refullname
    from
        (select cf.custodycd, af.acctno afacctno, cf.fullname, af.mrmrate,af.mrlrate,
        round((case when nvl(adv.avladvance,0) + balance - nvl(marginamt,0) >=0 then 10000
                else least(nvl(af.MRCRLIMIT,0) + nvl(se.semaxcallmrass,0), af.mrcrlimitmax - dfodamt)
                    / abs(nvl(adv.avladvance,0) + balance - nvl(marginamt,0)) end),4) * 100 MARGINRATE,
        nvl(se.semaxcallmrass,0) navaccount,
        greatest(-(nvl(adv.avladvance,0) + balance - nvl(marginamt,0)),0) outstanding
        from cfmast cf, cimast ci, afmast af, aftype aft, mrtype mrt,
        v_getsecmargininfo se,
        (select trfacctno, sum(prinnml+prinovd+intnmlacr+intnmlovd+intdue+intovdacr+fee+feeovd+feedue+feeintnmlacr+feeintnmlovd+feeintdue+feeintovdacr) marginamt
            from lnmast ln, lntype lnt
            where ln.actype = lnt.actype
            and ln.ftype = 'AF'
            and lnt.chksysctrl = 'Y'
            group by ln.trfacctno) ln,
        (select afacctno,sum(depoamt) avladvance
            from v_getAccountAvlAdvance group by afacctno) adv
    where cf.custid = af.custid and ci.acctno = af.acctno and af.actype = aft.actype
            and se.afacctno(+)=ci.acctno and adv.afacctno(+)=ci.acctno
            and ln.trfacctno(+) = ci.acctno and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
    ) mst,
    (select re.afacctno, cf.fullname refullname
        from reaflnk re, sysvar sys, cfmast cf
        where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
        and substr(re.reacctno,0,10) = cf.custid
        and varname = 'CURRDATE' and grname = 'SYSTEM'
        and re.status <> 'C' and re.deltd <> 'Y') re
    where mst.afacctno = re.afacctno(+)
    and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(mst.afacctno,1,4)) end  <> 0
    and MARGINRATE <= mrmrate and MARGINRATE > mrlrate
    order by custodycd;*/
    select cf.custodycd, sec.afacctno, cf.fullname, af.mriratio mrirate, af.mrmratio mrmrate, af.mrlratio mrlrate, sec.marginratio marginrate,
        nvl(semaxcallrealass,0) navaccount,
        greatest(nvl(SEC.marginamt,0) - nvl(sec.avladvance,0) - balance,0) outstanding,
        round(greatest((af.mrmratio/100 - sec.marginratio/100) * (sec.semaxcallrealass + GREATEST(balance + nvl(avladvance,0) - nvl(ln.marginamt,0),0)),0),0) addvnd,
        nvl(refullname,'') refullname
    from v_getsecmarginratio sec, afmast af, cfmast cf, cimast ci,
        (select trfacctno, sum(prinnml+prinovd+intnmlacr+intnmlovd+intdue+intovdacr+fee+feeovd+feedue+feeintnmlacr+feeintnmlovd+feeintdue+feeintovdacr) marginamt
                from lnmast ln, lntype lnt
                where ln.actype = lnt.actype
                and ln.ftype = 'AF'
                and lnt.chksysctrl = 'Y'
                group by ln.trfacctno) ln,
        (select re.afacctno, cf.fullname refullname
            from reaflnk re, sysvar sys, cfmast cf
            where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
            and substr(re.reacctno,0,10) = cf.custid
            and varname = 'CURRDATE' and grname = 'SYSTEM'
            and re.status <> 'C' and re.deltd <> 'Y') re
    where cf.custid = af.custid and af.acctno = sec.afacctno
        and af.acctno = ln.trfacctno(+)
        and af.acctno = ci.acctno and af.acctno = re.afacctno(+)
        and sec.marginratio <= af.mrmratio and sec.marginratio > af.mrlratio
        AND (substr(af.acctno,1,4) LIKE l_BRID_FILTER OR instr(l_BRID_FILTER,substr(af.acctno,1,4))<> 0)
    order by cf.custodycd;

else

    OPEN PV_REFCURSOR FOR
/*    select log.*, cf.custodycd, cf.fullname, cfb.fullname refullname,
        greatest(round((case when nvl(log.marginrate,0) * log.mrmrate =0 then nvl(log.outstanding,0) else
                             greatest( 0, nvl(log.outstanding,0) - nvl(log.navaccount,0) *100/log.mrmrate) end),0),0) addvnd
    from report_rskmngt_log log, cfmast cf, afmast af, cfmast cfb
    where cf.custid = af.custid and af.acctno = log.afacctno
        and log.recustid = cfb.custid(+)
        and log.txdate = (select max(txdate) from report_rskmngt_log where txdate <= to_date(p_DATE,'DD/MM/RRRR'))
        and log.MARGINRATE <= log.mrmrate and log.MARGINRATE > log.mrlrate
        and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
    order by cf.custodycd;*/
    select log.*, cf.custodycd, cf.fullname, cfb.fullname refullname,
        round(greatest((log.mrmrate/100 - log.marginrate/100) * (nvl(log.navaccount,0) + GREATEST(-nvl(log.outstanding,0),0)),0),0) addvnd
    from report_rskmngt_log log, cfmast cf, afmast af, cfmast cfb
    where cf.custid = af.custid and af.acctno = log.afacctno
        and log.recustid = cfb.custid(+)
        and log.txdate = (select max(txdate) from report_rskmngt_log where txdate <= to_date(p_DATE,'DD/MM/RRRR'))
        and log.MARGINRATE <= log.mrmrate and log.MARGINRATE > log.mrlrate
        --and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
        AND (substr(af.acctno,1,4) LIKE l_BRID_FILTER OR instr(l_BRID_FILTER,substr(af.acctno,1,4))<> 0)
    order by cf.custodycd;

end if;



EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
/

