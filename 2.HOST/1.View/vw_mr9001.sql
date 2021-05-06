create or replace force view vw_mr9001 as
select cf.custodycd, cf.fullname, af.acctno afacctno,
    case when af.trfbuyrate = 100 then
            least(cf.t0loanlimit - nvl(cflim.acclimit,0),
                nvl(ulim.t0max,0) - nvl(aflim.acclimit,0),
                nvl(ulim.t0,0) - nvl(ulim.acclimit,0) )
        else
            least(cf.t0loanlimit - nvl(cflim.acclimit,0),
                nvl(ulim.t0max,0) - nvl(aflim.acclimit,0),
                nvl(ulim.t0,0) - nvl(ulim.acclimit,0),
                round(greatest(greatest(balance+nvl(avladvance,0)- ci.ovamt - ci.dueamt - depofeeamt,0)
                                + greatest(least(af.mrcrlimitmax +LEAST( af.mrcrlimit, nvl(sts.trfsecuredamt_in,0))- dfodamt,
                                                nvl(sec.set0amt,0)+LEAST( af.mrcrlimit, nvl(sts.trfsecuredamt_in,0)))
                                            - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                            - nvl(sts.trfsecuredamt_in,0) ,0)
                                - nvl(b.trfbuyamt_over,0)
                                ,0)
                    ,0) * af.trfbuyrate / (100-af.trfbuyrate)
                    - (af.advanceline - nvl(b.trft0amt,0))
                )
        end ADDADVANCELINE,
    least(nvl(ulim.t0max,0) - nvl(aflim.acclimit,0),
                nvl(ulim.t0,0) - nvl(ulim.acclimit,0) ) URT0LIMITREMAIN,
    nvl(aflim.acclimit,0) AFT0USED,
    nvl(cflim.acclimit,0) CUSTT0USED,
    (af.advanceline - nvl(b.trft0amt,0)) ADVANCELINE,
    cf.t0loanlimit,
    nvl(ulim.t0max,0) - nvl(aflim.acclimit,0) USERT0REMAIN,
    nvl(ulim.t0,0) - nvl(ulim.acclimit,0)  USERT0AFREMAIN,
        cf.t0loanlimit - nvl(cflim.acclimit,0) CUSTT0REMAIN,
        CF.CONTRACTCHK,
        CF.IDCODE,
        'Cap bao lanh toi da cho tieu khoan tra cham' DESCRIPTION

from cimast ci, afmast af, cfmast cf, v_getbuyorderinfo b,
    v_getsecmargininfo sec,
    (select sum(depoamt) avladvance,afacctno
            from v_getAccountAvlAdvance group by afacctno) adv,
    v_getdealpaidbyaccount pd,
    (select acctno, sum(acclimit) acclimit from useraflimit where tliduser = '<$TELLERID>' and typereceive = 'T0' group by acctno) aflim,
    (select custid, sum(acclimit) acclimit from useraflimit, afmast af where af.acctno = useraflimit.acctno /*and tliduser = '<$TELLERID>'*/ and typereceive = 'T0' group by custid) cflim,
    (select u.tliduser, u.t0, u.t0max, nvl(uused.acclimit,0) acclimit
        from userlimit u,
             (select tliduser, sum(acclimit) acclimit
                 from useraflimit
                 where tliduser = '<$TELLERID>' and typeallocate = 'Flex' and typereceive = 'T0' group by tliduser) uused
        where u.tliduser = '<$TELLERID>' and u.usertype = 'Flex'
        and u.tliduser = uused.tliduser(+)) ulim, TLGROUPS GRP, tlprofiles tlp,
    (select sts.afacctno,
        sum(sts.amt + od.feeacr - od.feeamt -sts.trfexeamt - sts.trft0amt) trfsecuredamt_in
    from stschd sts, odmast od, (select * from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') sy
    where sts.duetype = 'SM' and sts.trfbuyrate*sts.trfbuyext > 0 and sts.trfbuysts <> 'Y'
    and sts.orgorderid = od.orderid
    and sts.txdate <> to_date(sy.varvalue,'DD/MM/RRRR')
    and sts.trfbuydt <> to_date(sy.varvalue,'DD/MM/RRRR')
    group by sts.afacctno) sts,
    (select trfacctno, sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd) marginamt,
                 sum(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd) t0amt,
                 sum(prinovd+intovdacr+intnmlovd+feeintovdacr+feeintnmlovd + nvl(ls.dueamt,0) + feeintdue) marginovdamt
        from lnmast ln, lntype lnt,
                (select acctno, sum(nml+intdue) dueamt
                        from lnschd, (select * from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') sy
                        where reftype = 'P' and overduedate = to_date(varvalue,'DD/MM/RRRR')
                        group by acctno) ls
        where ftype = 'AF'
                and ln.actype = lnt.actype
                and ln.acctno = ls.acctno(+)
        group by ln.trfacctno) ln
WHERE ci.acctno=af.acctno
and cf.custid = af.custid
and af.trfbuyrate > 0 and af.trfbuyext > 0
and af.acctno = b.afacctno(+)
and af.acctno = adv.afacctno(+)
and af.acctno = pd.afacctno(+)
and af.acctno = aflim.acctno(+)
and cf.custid = cflim.custid(+)
and af.acctno = sec.afacctno(+)
and af.acctno = ln.trfacctno(+)
and af.acctno = sts.afacctno(+)
and tlp.tlid = ulim.tliduser(+)
AND AF.CAREBY = GRP.GRPID AND GRP.GRPTYPE = '2';

