CREATE OR REPLACE FUNCTION fn_gen_report_log(p_RPTID varchar2)
  RETURN  BOOLEAN IS
--
-- To modify this template, edit file FUNC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the function
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  -------------------------------------------
-- variable_name                 datatype;
   -- Declare program variables as shown above
BEGIN
    -- TXDATE: Log theo ngay CurrDate
    if p_RPTID = 'MR3012' or p_RPTID = 'MR3013' or p_RPTID = 'ALL' then
        delete report_rskmngt_log
        where txdate = (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM');

/*        insert into report_rskmngt_log
        select mst.*, recustid, to_date(varvalue,'DD/MM/RRRR') TXDATE
        from
        (select af.acctno afacctno, af.mrirate, af.mrmrate,af.mrlrate,
        round((case when nvl(adv.avladvance,0) + balance - nvl(marginamt,0) >=0 then 10000
                else least(nvl(af.MRCRLIMIT,0) + nvl(se.semaxcallmrass,0), af.mrcrlimitmax - dfodamt)
                    / abs(nvl(adv.avladvance,0) + balance - nvl(marginamt,0)) end),4) * 100 MARGINRATE,
        nvl(se.semaxcallmrass,0) navaccount,
        round(greatest(-(nvl(adv.avladvance,0) + balance - nvl(marginamt,0)),0),0) outstanding
        from cimast ci, afmast af, aftype aft, mrtype mrt,
        v_getsecmargininfo se,
        (select trfacctno, sum(prinnml+prinovd+intnmlacr+intnmlovd+intdue+intovdacr+fee+feeovd+feedue+feeintnmlacr+feeintnmlovd+feeintdue+feeintovdacr) marginamt
            from lnmast ln, lntype lnt
            where ln.actype = lnt.actype
            and ln.ftype = 'AF'
            and lnt.chksysctrl = 'Y'
            group by ln.trfacctno) ln,
        (select afacctno,sum(depoamt) avladvance
            from v_getAccountAvlAdvance group by afacctno) adv
        where ci.acctno = af.acctno and af.actype = aft.actype
                and se.afacctno(+)=ci.acctno and adv.afacctno(+)=ci.acctno
                and ln.trfacctno(+) = ci.acctno and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
        ) mst,
        (select re.afacctno, cf.custid recustid
            from reaflnk re, sysvar sys, cfmast cf
            where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
            and substr(re.reacctno,0,10) = cf.custid
            and varname = 'CURRDATE' and grname = 'SYSTEM'
            and re.status <> 'C' and re.deltd <> 'Y') re,
        sysvar sydt
        where mst.afacctno = re.afacctno(+)
        and sydt.varname = 'CURRDATE' and sydt.grname = 'SYSTEM'
        and MARGINRATE <= mrmrate
        order by mst.afacctno;*/
        insert into report_rskmngt_log
            (afacctno, mrirate, mrmrate,mrlrate, MARGINRATE, navaccount, outstanding, recustid, txdate)
        select af.acctno afacctno, af.mriratio mrirate, af.mrmratio mrmrate, af.mrlratio mrlrate, sec.marginratio marginrate,
            nvl(semaxcallrealass,0) navaccount,
            greatest(nvl(ln.marginamt,0) - nvl(sec.avladvance,0) - balance,0) outstanding,
            recustid, to_date(varvalue,'DD/MM/RRRR') TXDATE

        from v_getsecmarginratio sec, afmast af, cimast ci,
            (select trfacctno, sum(prinnml+prinovd+intnmlacr+intnmlovd+intdue+intovdacr+fee+feeovd+feedue+feeintnmlacr+feeintnmlovd+feeintdue+feeintovdacr) marginamt
                    from lnmast ln, lntype lnt
                    where ln.actype = lnt.actype
                    and ln.ftype = 'AF'
                    and lnt.chksysctrl = 'Y'
                    group by ln.trfacctno) ln,
            (select re.afacctno, cf.custid recustid
                    from reaflnk re, sysvar sys, cfmast cf
                    where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
                    and substr(re.reacctno,0,10) = cf.custid
                    and varname = 'CURRDATE' and grname = 'SYSTEM'
                    and re.status <> 'C' and re.deltd <> 'Y') re,
            sysvar sydt
        where af.acctno = sec.afacctno
            and af.acctno = ln.trfacctno(+)
            and af.acctno = ci.acctno and af.acctno = re.afacctno(+)
            and sydt.varname = 'CURRDATE' and sydt.grname = 'SYSTEM'
            and sec.marginratio <= af.mrmratio
        order by af.acctno;
    end if;

    RETURN true;
EXCEPTION
   WHEN others THEN
       return false;
END;
/

