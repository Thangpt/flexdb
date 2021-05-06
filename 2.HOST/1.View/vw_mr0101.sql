create or replace force view vw_mr0101 as
select af.actype, aft.typename, DECODE(co_financing,'Y','YES','NO') co_financing, DECODE(ismarginacc,'Y','YES','NO') ismarginacc,
custodycd,af.acctno, af.trfbuyext, cf.fullname, ROUND(nvl(ln.margin74amt,0)) marginamt, ROUND(nvl(ln.t0amt,0)) t0amt,

ROUND(greatest(least(
    greatest(round(nvl(trfi.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0) - greatest(balance + nvl(avladvance,0) - round(ovamt) - round(dueamt) - round(depofeeamt),0)
    ,
    greatest(least(af.mrcrlimitmax +least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) )
                                   - round(dfodamt), round(nvl(sec.set0amt,0))
                    + least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) ))
                    - (round(nvl(marginamt,0))-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                    - round(nvl(trfi.trfsecuredamt_inday,0)) - round(nvl(sts.trfsecuredamt_in,0)) ,0)
                )
        ,0)) exmarginamt, -- du tinh margin

ROUND(greatest(
        least(
            greatest(round(nvl(sts.trfsecuredamt_in,0))
                            - greatest (greatest(
                                            least(af.mrcrlimitmax - round(dfodamt), round(nvl(sec.set0amt,0))/* + af.mrcrlimit*/)
                                                - (round(nvl(marginamt,0))-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                                                --- nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0)
                                                + greatest(balance + nvl(avladvance,0) - round(ovamt) - round(dueamt) - round(depofeeamt),0)
                                                ,0)
                                        --- greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                        - greatest( greatest(round(nvl(trfi.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0)
                                                    - greatest(
                                                            greatest(round(nvl(trfi.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0) - greatest(balance+nvl(avladvance,0)- round(ci.ovamt) - round(ci.dueamt) - round(depofeeamt),0)
                                                            -
                                                            greatest(least(af.mrcrlimitmax+ least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) )
                                                                                             - round(dfodamt), round(nvl(sec.set0amt,0))
                                                                         + least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) ))
                                                                            - (round(nvl(marginamt,0))-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                                                                            - round(nvl(trfi.trfsecuredamt_inday,0)) - round(nvl(sts.trfsecuredamt_in,0)) ,0)
                                                            ,0)
                                                ,0)
                                        ,0)
                    ,0),
            greatest(round(nvl(trfi.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0)
            )
            ,
    greatest(
            greatest(round(nvl(trfi.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0) - greatest(balance+nvl(avladvance,0)- round(ci.ovamt) - round(ci.dueamt) - round(depofeeamt),0)
            -
            greatest(least(af.mrcrlimitmax + least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) )
                                           - round(dfodamt), round(nvl(sec.set0amt,0))
                            + least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) ))
                            - (round(nvl(marginamt,0))-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                            - round(nvl(trfi.trfsecuredamt_inday,0)) - round(nvl(sts.trfsecuredamt_in,0)) ,0)
            ,0)
        )
+ greatest( round(nvl(trfi.trfsecuredamt_inday,0))
                            - greatest (greatest(
                                            least(af.mrcrlimitmax - round(dfodamt), round(nvl(sec.set0amt,0)) /*+ af.mrcrlimit*/)
                                                - (round(nvl(marginamt,0))-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                                                --- nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0)
                                                + greatest(balance + nvl(avladvance,0) - round(ovamt) - round(dueamt) - round(depofeeamt),0)
                                                ,0)
                                        --- greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                        - greatest( greatest(round(nvl(trfi.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0)
                                                    - greatest(
                                                            greatest(round(nvl(trfi.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0) - greatest(balance+nvl(avladvance,0)- round(ci.ovamt) - round(ci.dueamt) - round(depofeeamt),0)
                                                            -
                                                            greatest(least(af.mrcrlimitmax + least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) )
                                                                                                        - round(dfodamt), round(nvl(sec.set0amt,0))
                                                                            + least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) ))
                                                                            - (round(nvl(marginamt,0))-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                                                                            - round(nvl(trfi.trfsecuredamt_inday,0)) - round(nvl(sts.trfsecuredamt_in,0)) ,0)
                                                            ,0)
                                                ,0)
                                        - round(nvl(sts.trfsecuredamt_in,0))
                                        ,0)
            ,0))
ext0amt,

ROUND(nvl(ln.marginamt,0)
    + greatest(least(
        greatest(round(nvl(trfi.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0) - greatest(balance + nvl(avladvance,0) - round(ovamt) - round(dueamt) - round(depofeeamt),0)
        ,
        greatest(least(af.mrcrlimitmax + least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) )
                       - round(dfodamt), round(nvl(sec.set0amt,0))
                       + least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) ))
                        - (round(nvl(marginamt,0))-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                        - round(nvl(trfi.trfsecuredamt_inday,0)) - round(nvl(sts.trfsecuredamt_in,0)) ,0)
                    )
            ,0)) totalmarginamt,

ROUND(round(nvl(ln.t0amt,0))
    +
greatest(
        least(
            greatest(round(nvl(sts.trfsecuredamt_in,0))
                            - greatest (greatest(
                                            least(af.mrcrlimitmax - round(dfodamt), round(nvl(sec.set0amt,0))/* + af.mrcrlimit*/)
                                                - (round(nvl(marginamt,0))-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                                                --- nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0)
                                                + greatest(balance + nvl(avladvance,0) - round(ovamt) - round(dueamt) - round(depofeeamt),0)
                                                ,0)
                                        --- greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                        - greatest( greatest(round(nvl(trfi.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0)
                                                    - greatest(
                                                            greatest(round(nvl(trfi.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0) - greatest(balance+nvl(avladvance,0)- round(ci.ovamt) - round(ci.dueamt) - round(depofeeamt),0)
                                                            -
                                                            greatest(least(af.mrcrlimitmax  + least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) )
                                                                                                        - round(dfodamt), round(nvl(sec.set0amt,0))
                                                                          + least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) ))
                                                                            - (round(nvl(marginamt,0))-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                                                                            - round(nvl(trfi.trfsecuredamt_inday,0)) - round(nvl(sts.trfsecuredamt_in,0)) ,0)
                                                            ,0)
                                                ,0)
                                        ,0)
                    ,0),
            greatest(round(nvl(trfi.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0)
            )
            ,
    greatest(
            greatest(round(nvl(trfi.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0) - greatest(balance+nvl(avladvance,0)- round(ci.ovamt) - round(ci.dueamt) - round(depofeeamt),0)
            -
            greatest(least(af.mrcrlimitmax  + least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) )
                                                        - round(dfodamt), round(nvl(sec.set0amt,0))
                             + least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) ))
                            - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                            - round(nvl(trfi.trfsecuredamt_inday,0)) - round(nvl(sts.trfsecuredamt_in,0)) ,0)
            ,0)
        )
+ greatest( round(nvl(trfi.trfsecuredamt_inday,0))
                            - greatest (greatest(
                                            least(af.mrcrlimitmax - round(dfodamt), round(nvl(sec.set0amt,0))/* + af.mrcrlimit*/)
                                                - (round(nvl(marginamt,0))-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                                                --- nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0)
                                                + greatest(balance + nvl(avladvance,0) - round(ovamt) - round(dueamt) - round(depofeeamt),0)
                                                ,0)
                                        --- greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                        - greatest( greatest(round(nvl(trfi.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0)
                                                    - greatest(
                                                            greatest(round(nvl(trfi.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0) - greatest(balance+nvl(avladvance,0)- round(ci.ovamt) - round(ci.dueamt) - round(depofeeamt),0)
                                                            -
                                                            greatest(least(af.mrcrlimitmax  + least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) )
                                                                                                        - round(dfodamt), round(nvl(sec.set0amt,0))
                                                                            + least(af.mrcrlimit,round(nvl(trfi.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)) ))
                                                                            - (round(nvl(marginamt,0))-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                                                                            - round(nvl(trfi.trfsecuredamt_inday,0)) - round(nvl(sts.trfsecuredamt_in,0)) ,0)
                                                            ,0)
                                                ,0)
                                        - (nvl(sts.trfsecuredamt_in,0))
                                        ,0)
            ,0))
totalt0amt,

ROUND(nvl(ln.margin74ovdamt,0)) MARGINOVDAMT, ROUND(nvl(ln.t0ovdamt,0)) t0ovdamt, ROUND(nvl(sec.marginratio,0)) marginratio,
ROUND(greatest((af.mriratio/100 - sec.marginratio/100) * (sec.semaxcallrealass + GREATEST(balance + ROUND(nvl(avladvance,0)) - ROUND(nvl(ln.margin74amt,0)),0)),greatest(ROUND(nvl(ln.margin74ovdamt,0)) - balance - ROUND(avladvance),0))) addvnd,
af.mriratio, af.mrmratio, af.mrlratio, ROUND(balance + avladvance) totalvnd, nvl(t0.advanceline,0) advanceline, sec.secallrealass,sec.semaxcallrealass, af.mrcrlimit,
af.mrcrlimitmax, ci.dfodamt,af.mrcrlimitmax - ci.dfodamt mrcrlimitremain, af.status, af.careby

from cfmast cf, afmast af, cimast ci, aftype aft, v_getsecmarginratio_all sec,
    vw_trfbuyinfo_inday trfi,
    (select acctno, 'Y' ismarginacc from afmast af
          where exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y'
                          union all
                          select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y')
          group by acctno) ismr,
    (select aftype, 'Y' co_financing from afidtype where objname = 'LN.LNTYPE' group by aftype) cof,
    (select trfacctno, trunc(sum(round(prinnml)+round(prinovd)+round(intnmlacr)+round(intdue)+round(intovdacr)+round(intnmlovd)+round(feeintnmlacr)+round(feeintdue)+round(feeintovdacr)+round(feeintnmlovd)),0) marginamt,
                 trunc(sum(decode(lnt.chksysctrl,'Y',1,0)*(round(prinnml)+round(prinovd)+round(intnmlacr)+round(intdue)+round(intovdacr)+round(intnmlovd)+round(feeintnmlacr)+round(feeintdue)+round(feeintovdacr)+round(feeintnmlovd))),0) margin74amt,
                 trunc(sum(round(oprinnml)+round(oprinovd)+round(ointnmlacr)+round(ointdue)+round(ointovdacr)+round(ointnmlovd)),0) t0amt,
                 trunc(sum((round(prinovd)+round(intovdacr)+round(intnmlovd)+round(feeintovdacr)+round(feeintnmlovd) + round(nvl(ls.dueamt,0)) + round(feeintdue))),0) marginovdamt,
                 trunc(sum(decode(lnt.chksysctrl,'Y',1,0)*(round(prinovd)+round(intovdacr)+round(intnmlovd)+round(feeintovdacr)+round(feeintnmlovd) + round(nvl(ls.dueamt,0)) + round(feeintdue))),0) margin74ovdamt,
                 trunc(sum(round(oprinovd)+round(ointovdacr)+round(ointnmlovd)),0) t0ovdamt
        from lnmast ln, lntype lnt,
                (select acctno, sum(nml+intdue) dueamt  from lnschd
                        where reftype = 'P' and overduedate = (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
                        group by acctno) ls
        where ftype = 'AF' and ln.actype = lnt.actype
                and ln.acctno = ls.acctno(+)
        group by ln.trfacctno) ln,
(select acctno, sum(acclimit) advanceline from useraflimit where typereceive = 'T0' group by acctno) t0,
(select sts.afacctno, sum(sts.amt + od.feeacr - od.feeamt -sts.trfexeamt - sts.trft0amt) trfsecuredamt_in
    from stschd sts, odmast od, (select * from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') sy
    where sts.duetype = 'SM' and sts.deltd <> 'Y' and sts.trfbuyrate*sts.trfbuyext > 0 and sts.trfbuysts <> 'Y'
    and sts.orgorderid = od.orderid
    and sts.txdate <> to_date(sy.varvalue,'DD/MM/RRRR')
    and sts.trfbuydt <> to_date(sy.varvalue,'DD/MM/RRRR')
    group by sts.afacctno) sts
where cf.custid = af.custid
and cf.custatcom = 'Y'
and af.actype = aft.actype
and af.acctno = ci.acctno
and af.acctno = sec.afacctno
and af.acctno = ln.trfacctno(+)
and af.acctno = ismr.acctno(+)
and af.actype = cof.aftype(+)
and af.acctno = t0.acctno(+)
and af.acctno = sts.afacctno(+)
and af.acctno = trfi.afacctno(+)
--and nvl(ln.nvl(marginamt,0),0) + nvl(ln.t0amt,0) + nvl(secureamt,0) > 0
and nvl(ismarginacc,'N') = 'Y'
;

