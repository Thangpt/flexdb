create or replace force view vw_mr0001 as
select af.actype, aft.typename, DECODE(co_financing,'Y','YES','NO') co_financing, DECODE(ismarginacc,'Y','YES','NO') ismarginacc,
custodycd,af.acctno, aft.disadvfeedays trfbuyext, cf.fullname, ROUND(nvl(ln.marginamt,0)) marginamt, ROUND(nvl(ln.t0amt,0)) t0amt,

ROUND(greatest(least(
    greatest(round(nvl(sec.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0) - greatest(balance + round(nvl(avladvance,0)) - round(ovamt) - round(dueamt) - round(depofeeamt),0)
    ,
    greatest(least(af.mrcrlimitmax+ LEAST(af.mrcrlimit,(round(nvl(sec.trfsecuredamt_inday,0))+ round(nvl(sts.trfsecuredamt_in,0)))) - round(dfodamt)
                                    , round(nvl(sec.set0amt,0)) + LEAST(af.mrcrlimit,(round(nvl(sec.trfsecuredamt_inday,0))+ round(nvl(sts.trfsecuredamt_in,0)))) )
                    - (round(nvl(marginamt,0))-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                    - round(nvl(sec.trfsecuredamt_inday,0)) - round(nvl(sts.trfsecuredamt_in,0)) ,0)
                )
        ,0)) exmarginamt, -- du tinh margin

ROUND(greatest(
        least(
            greatest(round(nvl(sts.trfsecuredamt_in,0))
                            - greatest (greatest(
                                            least(af.mrcrlimitmax - round(dfodamt), round(nvl(sec.set0amt,0)) /*+ af.mrcrlimit*/)
                                                - (round(nvl(marginamt,0))-least(greatest(balance+round(nvl(avladvance,0))- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                                                --- nvl(sec.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0)
                                                + greatest(balance + round(nvl(avladvance,0)) - round(ovamt) - round(dueamt) - round(depofeeamt),0)
                                                ,0)
                                        --- greatest(nvl(sec.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                        - greatest( greatest(round(nvl(sec.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0)
                                                    - greatest(
                                                            greatest(round(nvl(sec.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0) - greatest(balance+round(nvl(avladvance,0))- round(ci.ovamt) - round(ci.dueamt) - round(depofeeamt),0)
                                                            -
                                                            greatest(least(af.mrcrlimitmax +least(af.mrcrlimit, round(nvl(sec.trfsecuredamt_inday,0))+ round(nvl(sts.trfsecuredamt_in,0)))
                                                                          - round(dfodamt), round(nvl(sec.set0amt,0))
                                                                          + least(af.mrcrlimit, round(nvl(sec.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0))))
                                                                            - (round(nvl(marginamt,0))-least(greatest(balance+round(nvl(avladvance,0))- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                                                                            - round(nvl(sec.trfsecuredamt_inday,0)) - round(nvl(sts.trfsecuredamt_in,0)) ,0)
                                                            ,0)
                                                ,0)
                                        ,0)
                    ,0),
            greatest(round(nvl(sec.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0)
            )
            ,
    greatest(
            greatest(round(nvl(sec.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0) - greatest(balance+round(nvl(avladvance,0))- round(ci.ovamt) - round(ci.dueamt) - round(depofeeamt),0)
            -
            greatest(least(af.mrcrlimitmax +LEAST( af.mrcrlimit, round(nvl(sec.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)))
                                            - round(dfodamt), round(nvl(sec.set0amt,0))
                           +LEAST( af.mrcrlimit, round(nvl(sec.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0))))
                            - (round(nvl(marginamt,0))-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                            - round(nvl(sec.trfsecuredamt_inday,0)) - round(nvl(sts.trfsecuredamt_in,0)) ,0)
            ,0)
        )
+ greatest( nvl(sec.trfsecuredamt_inday,0)
                            - greatest (greatest(
                                            least(af.mrcrlimitmax - round(dfodamt), round(nvl(sec.set0amt,0))/* + af.mrcrlimit*/)
                                                - (round(nvl(marginamt,0))-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),round(nvl(marginovdamt,0))))
                                                --- nvl(sec.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0)
                                                + greatest(balance + round(nvl(avladvance,0)) - round(ovamt) - round(dueamt) - round(depofeeamt),0)
                                                ,0)
                                        --- greatest(nvl(sec.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                        - greatest( greatest(round(nvl(sec.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0)
                                                    - greatest(
                                                            greatest(round(nvl(sec.secureamt_inday,0)) + round(nvl(sec.trfbuyamt_over,0)),0) - greatest(balance+round(nvl(avladvance,0))- round(ci.ovamt) - round(ci.dueamt) - round(depofeeamt),0)
                                                            -
                                                            greatest(least(af.mrcrlimitmax +LEAST( af.mrcrlimit,(round(nvl(sec.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0))))
                                                                                           - round(dfodamt), round(nvl(sec.set0amt,0))
                                                                            +LEAST( af.mrcrlimit,(round(nvl(sec.trfsecuredamt_inday,0)) + round(nvl(sts.trfsecuredamt_in,0)))))
                                                                            - (round(nvl(marginamt,0))-least(greatest(balance+nvl(avladvance,0)- round(nvl(ln.t0amt,0))- round(depofeeamt),0),nvl(marginovdamt,0)))
                                                                            - round(nvl(sec.trfsecuredamt_inday,0)) - round(nvl(sts.trfsecuredamt_in,0)) ,0)
                                                            ,0)
                                                ,0)
                                        - round(nvl(sts.trfsecuredamt_in,0))
                                        ,0)
            ,0))
ext0amt,

ROUND(ROUND(nvl(ln.marginamt,0))
    + greatest(least(
            greatest(nvl(sec.secureamt_inday,0) + ROUND(nvl(sec.trfbuyamt_over,0),0)) - greatest(balance + ROUND(nvl(avladvance,0)) - ROUND(ovamt) - ROUND(dueamt) - ROUND(depofeeamt),0)
            ,
            greatest(least(af.mrcrlimitmax + least(af.mrcrlimit,(ROUND(nvl(sec.trfsecuredamt_inday,0))+ ROUND(nvl(sts.trfsecuredamt_in,0))))
                           - ROUND(dfodamt), ROUND(nvl(sec.set0amt,0))
                            + least(af.mrcrlimit,(ROUND(nvl(sec.trfsecuredamt_inday,0))+ ROUND(nvl(sts.trfsecuredamt_in,0)))))
                            - (ROUND(nvl(marginamt,0))-least(greatest(balance+ROUND(nvl(avladvance,0))- ROUND(nvl(ln.t0amt,0))- ROUND(depofeeamt),0),ROUND(nvl(marginovdamt,0))))
                            - ROUND(nvl(sec.trfsecuredamt_inday,0)) - ROUND(nvl(sts.trfsecuredamt_in,0)) ,0)
                        )
                ,0)) totalmarginamt,

ROUND(nvl(ln.t0amt,0)
    +
greatest(
        least(
            greatest(ROUND(nvl(sts.trfsecuredamt_in,0))
                            - greatest (greatest(
                                            least(af.mrcrlimitmax - ROUND(dfodamt), ROUND(nvl(sec.set0amt,0)) /*+ af.mrcrlimit*/)
                                                - (ROUND(nvl(marginamt,0))-least(greatest(balance+ROUND(nvl(avladvance,0))- ROUND(nvl(ln.t0amt,0))- ROUND(depofeeamt),0),ROUND(nvl(marginovdamt,0))))
                                                --- nvl(sec.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0)
                                                + greatest(balance + ROUND(nvl(avladvance,0)) - ROUND(ovamt) - ROUND(dueamt) - ROUND(depofeeamt),0)
                                                ,0)
                                        --- greatest(nvl(sec.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                        - greatest( greatest(ROUND(nvl(sec.secureamt_inday,0)) + ROUND(nvl(sec.trfbuyamt_over,0)),0)
                                                    - greatest(
                                                            greatest(ROUND(nvl(sec.secureamt_inday,0)) + ROUND(nvl(sec.trfbuyamt_over,0)),0) - greatest(balance+ROUND(nvl(avladvance,0))- ROUND(ci.ovamt) - ROUND(ci.dueamt) - ROUND(depofeeamt),0)
                                                            -
                                                            greatest(least(af.mrcrlimitmax + least(af.mrcrlimit,(ROUND(nvl(sec.trfsecuredamt_inday,0))+ ROUND(nvl(sts.trfsecuredamt_in,0))))
                                                                           - ROUND(dfodamt), ROUND(nvl(sec.set0amt,0))
                                                                             + least(af.mrcrlimit,(ROUND(nvl(sec.trfsecuredamt_inday,0))+ ROUND(nvl(sts.trfsecuredamt_in,0)))))
                                                                            - (ROUND(nvl(marginamt,0))-least(greatest(balance+ROUND(nvl(avladvance,0))- ROUND(nvl(ln.t0amt,0))- ROUND(depofeeamt),0),ROUND(nvl(marginovdamt,0))))
                                                                            - nvl(sec.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0) ,0)
                                                            ,0)
                                                ,0)
                                        ,0)
                    ,0),
            greatest(ROUND(nvl(sec.secureamt_inday,0)) + ROUND(nvl(sec.trfbuyamt_over,0)),0)
            )
            ,
    greatest(
            greatest(ROUND(nvl(sec.secureamt_inday,0)) + ROUND(nvl(sec.trfbuyamt_over,0)),0) - greatest(balance+ROUND(nvl(avladvance,0))- ROUND(ci.ovamt) - ROUND(ci.dueamt) - ROUND(depofeeamt),0)
            -
            greatest(least(af.mrcrlimitmax + least(af.mrcrlimit,(ROUND(nvl(sec.trfsecuredamt_inday,0))+ ROUND(nvl(sts.trfsecuredamt_in,0))))
                                           - ROUND(dfodamt), ROUND(nvl(sec.set0amt,0))
                            + least(af.mrcrlimit,(ROUND(nvl(sec.trfsecuredamt_inday,0))+ ROUND(nvl(sts.trfsecuredamt_in,0)))))
                            - (ROUND(nvl(marginamt,0))-least(greatest(balance+ROUND(nvl(avladvance,0))- ROUND(nvl(ln.t0amt,0))- ROUND(depofeeamt),0),ROUND(nvl(marginovdamt,0))))
                            - ROUND(nvl(sec.trfsecuredamt_inday,0)) - ROUND(nvl(sts.trfsecuredamt_in,0)) ,0)
            ,0)
        )
+ greatest( ROUND(nvl(sec.trfsecuredamt_inday,0))
                            - greatest (greatest(
                                            least(af.mrcrlimitmax - ROUND(dfodamt), ROUND(nvl(sec.set0amt,0))/* + af.mrcrlimit*/)
                                                - (ROUND(nvl(marginamt,0))-least(greatest(balance+ROUND(nvl(avladvance,0))- ROUND(nvl(ln.t0amt,0))- ROUND(depofeeamt),0),ROUND(nvl(marginovdamt,0))))
                                                --- nvl(sec.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0)
                                                + greatest(balance + ROUND(nvl(avladvance,0)) - ROUND(ovamt) - ROUND(dueamt) - ROUND(depofeeamt),0)
                                                ,0)
                                        --- greatest(nvl(sec.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                        - greatest( greatest(ROUND(nvl(sec.secureamt_inday,0)) + ROUND(nvl(sec.trfbuyamt_over,0)),0)
                                                    - greatest(
                                                            greatest(ROUND(nvl(sec.secureamt_inday,0)) + ROUND(nvl(sec.trfbuyamt_over,0)),0) - greatest(balance+ROUND(nvl(avladvance,0))- ROUND(ci.ovamt) - ROUND(ci.dueamt) - ROUND(depofeeamt),0)
                                                            -
                                                            greatest(least(af.mrcrlimitmax + least(af.mrcrlimit,(ROUND(nvl(sec.trfsecuredamt_inday,0))+ ROUND(nvl(sts.trfsecuredamt_in,0))))
                                                                               - ROUND(dfodamt), ROUND(nvl(sec.set0amt,0))
                                                                            + least(af.mrcrlimit,(ROUND(nvl(sec.trfsecuredamt_inday,0))+ ROUND(nvl(sts.trfsecuredamt_in,0)))))
                                                                            - (ROUND(nvl(marginamt,0))-least(greatest(balance+ROUND(nvl(avladvance,0))- ROUND(nvl(ln.t0amt,0))- ROUND(depofeeamt),0),ROUND(nvl(marginovdamt,0))))
                                                                            - nvl(sec.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0) ,0)
                                                            ,0)
                                                ,0)
                                        - ROUND(nvl(sts.trfsecuredamt_in,0))
                                        ,0)
            ,0))
totalt0amt,

ROUND(nvl(ln.marginovdamt,0)) marginovdamt, ROUND(nvl(ln.t0ovdamt,0)) t0ovdamt,
nvl(sec.rlsmarginrate,0) rlsmarginrate, nvl(sec.marginrate,0) marginrate,
ROUND(greatest(round((case when nvl(sec.marginrate,0) * mrirate =0 then - outstanding else
                     greatest( 0,- outstanding - navaccount *100/mrirate) end),0),greatest(dueamt+ovamt+depofeeamt -sec.NYOVDAMT- balance - nvl(avladvance,0),0))) addvnd,
ROUND(greatest(round((case when nvl(sec.marginrate,0) * mrirate =0 then - outstandingt2 else
                     greatest( 0,- outstandingt2 - navaccountt2 *100/mrirate) end),0),greatest(dueamt+ovamt+depofeeamt - balance - nvl(avladvance,0),0))) addvndt2,
af.mrirate, af.mrmrate, af.mrlrate, ROUND(balance + nvl(avladvance,0)) totalvnd, nvl(t0.advanceline,0) advanceline, nvl(sec.semaxtotalcallass,0) setotalcallass, af.mrcrlimit,
af.mrcrlimitmax, ci.dfodamt, af.mrcrlimitmax - ci.dfodamt mrcrlimitremain, af.status, af.careby, nvl(sec.set0amt,0) set0amt,nvl(sec.secallass,0) secallass

from cfmast cf, afmast af, cimast ci, aftype aft,
--PhuongHT edit ngay 01.03.2016
-- v_getsecmarginratio_all sec, vw_trfbuyinfo_inday trfi,
(select  afacctno,avladvance_EX avladvance,trfbuyamt_over,set0amt, rlsmarginrate_ex rlsmarginrate,NYOVDAMT, marginrate_Ex marginrate,
         semaxtotalcallass, secallass,CLAMT,navaccountt2_EX navaccountt2,outstanding_ex outstanding,
         navaccount_ex navaccount, MARGINRATE5,
         outstanding5,ODAMT_EX ODAMT ,outstandingT2_EX outstandingT2,semaxcallass,secureamt_inday,trfsecuredamt_inday
 from buf_ci_account) sec,
--end of PhuongHT edit ngay 01.03.2016

    (select aftype, 'Y' co_financing from afidtype where objname = 'LN.LNTYPE' group by aftype) cof,
    (select acctno, 'Y' ismarginacc from afmast af
          where exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y'
                          union all
                          select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y')
          group by acctno) ismr,
    (select trfacctno, trunc(sum(round(prinnml)+round(prinovd)+round(intnmlacr)+round(intdue)+round(intovdacr)+round(intnmlovd)+round(feeintnmlacr)
                                +round(feeintdue)+round(feeintovdacr)+round(feeintnmlovd)),0) marginamt,
                 trunc(sum(round(oprinnml)+round(oprinovd)+round(ointnmlacr)+round(ointdue)+round(ointovdacr)+round(ointnmlovd)),0) t0amt,
                 trunc(sum(round(prinovd)+round(intovdacr)+round(intnmlovd)+round(feeintovdacr)+round(feeintnmlovd) + round(nvl(ls.dueamt,0)) + round(feeintdue)),0) marginovdamt,
                 trunc(sum(round(oprinovd)+round(ointovdacr)+round(ointnmlovd)),0) t0ovdamt
        from lnmast ln, lntype lnt,
                (select acctno, sum(nml+intdue) dueamt
                        from lnschd, (select * from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') sy
                        where reftype = 'P' and overduedate = to_date(varvalue,'DD/MM/RRRR')
                        group by acctno) ls
        where ftype = 'AF'
                and ln.actype = lnt.actype
                and ln.acctno = ls.acctno(+)
        group by ln.trfacctno) ln,
(select acctno, sum(acclimit) advanceline from useraflimit where typereceive = 'T0' group by acctno) t0,
(select sts.afacctno,
        sum(sts.amt + od.feeacr - od.feeamt -sts.trfexeamt - sts.trft0amt) trfsecuredamt_in
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
and af.actype = cof.aftype(+)
and af.acctno = t0.acctno(+)
and af.acctno = sts.afacctno(+)
and af.acctno = ismr.acctno(+)
--and af.acctno = trfi.afacctno(+)
--and nvl(ln.marginamt,0) + nvl(ln.t0amt,0) + nvl(secureamt,0) > 0
;

