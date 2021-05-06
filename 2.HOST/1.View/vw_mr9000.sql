create or replace force view vw_mr9000 as
select custodycd,
   actype,
   afacctno,
   careby,
   trfbuydt,
   trfbuyext,
   fullname,
   trfamt,
   ovdamt,
   balance,
   avladvance,
   totalvnd,
   exvndamt,
   avlmargin,
   exmarginamt,
   ext0amt,
   greatest(callamt,callamt2) callamt,
   rtnamt,
   acctnokey,
   aftrfbuyext,
   trfsecuredamt_exec_inday,
   trfsecuredamt_noexec_inday,
   addadvanceline_inday,
   refullname,
   callamt2
from (   
    select cf.custodycd, af.actype, af.acctno AFACCTNO, af.careby, st.trfbuydt, af.trfbuyext, cf.fullname, nvl(st.trfamt,0) trfamt,
    nvl(ln.t0amt,0) + ci.depofeeamt ovdamt, ci.balance, nvl(sec.avladvance,0) avladvance, ci.balance + nvl(sec.avladvance,0) totalvnd,
    greatest(ci.balance + nvl(sec.avladvance,0) - ci.ovamt - ci.dueamt - ci.depofeeamt,0) exvndamt,

    greatest(least(af.mrcrlimitmax ++LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0))
                                    - dfodamt, nvl(sec.set0amt,0)
            +LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0)))
            - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
            - nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0)
             ,0) avlmargin,

    greatest(least(
        greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0) - greatest(balance + nvl(avladvance,0) - ovamt - dueamt - depofeeamt,0)
        ,
        greatest(least(af.mrcrlimitmax +LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0))
                                       - dfodamt, nvl(sec.set0amt,0)
                        +LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0)))
                        - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                        - nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0) ,0)
                    )
            ,0) exmarginamt, -- du tinh margin
    greatest(
    greatest(
            least(
                greatest(nvl(sts.trfsecuredamt_in,0)
                                - greatest (greatest(
                                                least(af.mrcrlimitmax - dfodamt, nvl(sec.set0amt,0)/* + af.mrcrlimit*/)
                                                    - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                                    --- nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0)
                                                    + greatest(balance + nvl(avladvance,0) - ovamt - dueamt - depofeeamt,0)
                                                    ,0)
                                            --- greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                            - greatest( greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                                        - greatest(
                                                                greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0) - greatest(balance+nvl(avladvance,0)- ci.ovamt - ci.dueamt - depofeeamt,0)
                                                                -
                                                                greatest(least(af.mrcrlimitmax /*+LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0))*/
                                                                                               - dfodamt, nvl(sec.set0amt,0)
                                                                               /*+LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0))*/)
                                                                                - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                                                                - nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0) ,0)
                                                                ,0)
                                                    ,0)
                                            ,0)
                        ,0),
                greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                )
                ,
        greatest(
                greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0) - greatest(balance+nvl(avladvance,0)- ci.ovamt - ci.dueamt - depofeeamt,0)
                -
                greatest(least(af.mrcrlimitmax /*+LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0))*/
                                               - dfodamt, nvl(sec.set0amt,0)
                                /*+LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0))*/)
                                - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                - nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0) ,0)
                ,0)
            )
    + greatest( nvl(trfi.trfsecuredamt_inday,0)
                                - greatest (greatest(
                                                least(af.mrcrlimitmax - dfodamt, nvl(sec.set0amt,0)/* + af.mrcrlimit*/)
                                                    - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                                    --- nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0)
                                                    + greatest(balance + nvl(avladvance,0) - ovamt - dueamt - depofeeamt,0)
                                                    ,0)
                                            --- greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                            - greatest( greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                                        - greatest(
                                                                greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0) - greatest(balance+nvl(avladvance,0)- ci.ovamt - ci.dueamt - depofeeamt,0)
                                                                -
                                                                greatest(least(af.mrcrlimitmax /*+LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0))*/
                                                                                               - dfodamt, nvl(sec.set0amt,0)
                                                                               /*+LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0))*/)
                                                                                - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                                                                - nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0) ,0)
                                                                ,0)
                                                    ,0)
                                            - nvl(sts.trfsecuredamt_in,0)
                                            ,0)
                ,0)
     - NVL(af.mrcrlimit,0)
             ,0)
    ext0amt,

    greatest(
            least(
                greatest(nvl(sts.trfsecuredamt_in,0)
                                - greatest (greatest(
                                                least(af.mrcrlimitmax - dfodamt, nvl(sec.set0amt,0) /*+ af.mrcrlimit*/)
                                                    - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                                    --- nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0)
                                                    + greatest(balance + nvl(avladvance,0) - ovamt - dueamt - depofeeamt,0)
                                                    ,0)
                                            --- greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                            - greatest( greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                                        - greatest(
                                                                greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0) - greatest(balance+nvl(avladvance,0)- ci.ovamt - ci.dueamt - depofeeamt,0)
                                                                -
                                                                greatest(least(af.mrcrlimitmax +LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0))
                                                                                               - dfodamt, nvl(sec.set0amt,0)
                                                                                +LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0)))
                                                                                - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                                                                - nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0) ,0)
                                                                ,0)
                                                    ,0)
                                            ,0)
                        ,0),
                greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                )
                ,
        greatest(
                greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0) - greatest(balance+nvl(avladvance,0)- ci.ovamt - ci.dueamt - depofeeamt,0)
                -
                greatest(least(af.mrcrlimitmax +LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0))
                                               - dfodamt, nvl(sec.set0amt,0)
                                +LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0)))
                                - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                - nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0) ,0)
                ,0)
            )
    + greatest( nvl(trfi.trfsecuredamt_inday,0)
                                - greatest (greatest(
                                                least(af.mrcrlimitmax - dfodamt, nvl(sec.set0amt,0) /*+ af.mrcrlimit*/)
                                                    - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                                    --- nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0)
                                                    + greatest(balance + nvl(avladvance,0) - ovamt - dueamt - depofeeamt,0)
                                                    ,0)
                                            --- greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                            - greatest( greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                                        - greatest(
                                                                greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0) - greatest(balance+nvl(avladvance,0)- ci.ovamt - ci.dueamt - depofeeamt,0)
                                                                -
                                                                greatest(least(af.mrcrlimitmax +LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0))
                                                                                           - dfodamt, nvl(sec.set0amt,0)
                                                                                +LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0)))
                                                                                - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                                                                - nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0) ,0)
                                                                ,0)
                                                    ,0)
                                            - nvl(sts.trfsecuredamt_in,0)
                                            ,0)
                ,0)
    + greatest(nvl(ln.t0amt,0) + ci.depofeeamt - (ci.balance + nvl(sec.avladvance,0)),0)
     callamt,

    greatest(
            least(
                greatest(nvl(sts.trfsecuredamt_in,0)
                                - greatest (greatest(
                                                least(af.mrcrlimitmax - dfodamt, nvl(sec.set0amt,0) /*+ af.mrcrlimit*/)
                                                    - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                                    --- nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0)
                                                    + greatest(balance + nvl(avladvance,0) - ovamt - dueamt - depofeeamt,0)
                                                    ,0)
                                            --- greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                            - greatest( greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                                        - greatest(
                                                                greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0) - greatest(balance+nvl(avladvance,0)- ci.ovamt - ci.dueamt - depofeeamt,0)
                                                                -
                                                                greatest(least(af.mrcrlimitmax +LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0))
                                                                                               - dfodamt, nvl(sec.set0amt,0)
                                                                                +LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0)))
                                                                                - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                                                                - nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0) ,0)
                                                                ,0)
                                                    ,0)
                                            ,0)
                        ,0),
                greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                )
                ,
        greatest(
                greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0) - greatest(balance+nvl(avladvance,0)- ci.ovamt - ci.dueamt - depofeeamt,0)
                -
                greatest(least(af.mrcrlimitmax+LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0))
                                                       - dfodamt, nvl(sec.set0amt,0)
                                +LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0)))
                                - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                - nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0) ,0)
                ,0)
            )
    + greatest( nvl(trfi.trfsecuredamt_inday,0)
                                - greatest (greatest(
                                                least(af.mrcrlimitmax - dfodamt, nvl(sec.set0amt,0) /*+ af.mrcrlimit*/)
                                                    - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                                    --- nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0)
                                                    + greatest(balance + nvl(avladvance,0) - ovamt - dueamt - depofeeamt,0)
                                                    ,0)
                                            --- greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                            - greatest( greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0)
                                                        - greatest(
                                                                greatest(nvl(trfi.secureamt_inday,0) + nvl(sec.trfbuyamt_over,0),0) - greatest(balance+nvl(avladvance,0)- ci.ovamt - ci.dueamt - depofeeamt,0)
                                                                -
                                                                greatest(least(af.mrcrlimitmax +LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0))
                                                                                               - dfodamt, nvl(sec.set0amt,0)
                                                                                +LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0)))
                                                                                - (nvl(marginamt,0)-least(greatest(balance+nvl(avladvance,0)- nvl(ln.t0amt,0)- depofeeamt,0),nvl(marginovdamt,0)))
                                                                                - nvl(trfi.trfsecuredamt_inday,0) - nvl(sts.trfsecuredamt_in,0) ,0)
                                                                ,0)
                                                    ,0)
                                            - nvl(sts.trfsecuredamt_in,0)
                                            ,0)
                ,0)
    rtnamt,
    af.ACCTNO || nvl(to_char(st.TRFBUYDT,'DD/MM/RRRR'),'') ACCTNOKEY, af.trfbuyext aftrfbuyext,
    nvl(trfi.trfsecuredamt_exec_inday,0) trfsecuredamt_exec_inday,
    nvl(trfi.trfsecuredamt_noexec_inday,0) trfsecuredamt_noexec_inday,
    nvl(trfi.addadvanceline_inday,0) addadvanceline_inday, refullname,

    nvl(sec.trfbuyamt_over,0) + nvl(sts.trfsecuredamt_in,0) + nvl(trfi.trfsecuredamt_exec_inday,0) + nvl(trfi.trfsecuredamt_noexec_inday,0)
    - LEAST( af.mrcrlimit,nvl(trfi.trfsecuredamt_inday,0) + nvl(sts.trfsecuredamt_in,0))
    - (least(af.mrcrlimitmax - dfodamt, nvl(sec.set0amt,0)) - nvl(marginamt,0) - nvl(ln.t0amt,0) +  greatest(balance + nvl(avladvance,0)  - depofeeamt,0))
    callamt2 --So tien phai nop cho du coc va tien phai giao trong ngay

    from cfmast cf, afmast af, cimast ci, aftype aft, v_getsecmarginratio_all sec, vw_trfbuyinfo_inday trfi,
        (select trfacctno, trunc(sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd),0) marginamt,
                     trunc(sum(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd),0) t0amt,
                     trunc(sum(prinovd+intovdacr+intnmlovd+feeintovdacr+feeintnmlovd + nvl(ls.dueamt,0) + intdue + feeintdue),0) marginovdamt,
                     trunc(sum(oprinovd+ointovdacr+ointnmlovd),0) t0ovdamt
            from lnmast ln, lntype lnt,
                    (select acctno, sum(nml) dueamt
                            from lnschd, (select * from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') sy
                            where reftype = 'P' and overduedate = to_date(varvalue,'DD/MM/RRRR')
                            group by acctno) ls
            where ftype = 'AF'
                    and ln.actype = lnt.actype
                    and ln.acctno = ls.acctno(+)
            group by ln.trfacctno) ln,
    (select sts.afacctno,
            sum(sts.amt + od.feeacr - od.feeamt -sts.trfexeamt - sts.trft0amt) trfsecuredamt_in
        from stschd sts, odmast od, (select * from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') sy
        where sts.duetype = 'SM' and sts.deltd <> 'Y' and sts.trfbuyrate*sts.trfbuyext > 0 and sts.trfbuysts <> 'Y'
        and sts.orgorderid = od.orderid
        and sts.txdate <> to_date(sy.varvalue,'DD/MM/RRRR')
        and sts.trfbuydt <> to_date(sy.varvalue,'DD/MM/RRRR')
        group by sts.afacctno) sts,
    (select od.afacctno, nvl(sts.trfbuydt,sts.cleardate) trfbuydt,
            sum(
                case when od.txdate = to_date(sy.varvalue,'DD/MM/RRRR') and feeacr - feeamt = 0 then
                        amt + (amt*odt.deffeerate/100) -sts.trfexeamt
                    else
                        amt + feeacr - feeamt - sts.trfexeamt
                    end
                ) trfamt
        from stschd sts, odmast od, odtype odt, sysvar sy
        where sts.orgorderid = od.orderid and od.actype = odt.actype and duetype = 'SM' and sts.deltd <> 'Y'
            and sy.varname = 'CURRDATE' and sy.grname = 'SYSTEM'
            and (sts.trfbuyrate*sts.trfbuyext>0 or od.txdate = to_date(varvalue,'DD/MM/RRRR'))
            and sts.cleardate >= to_date(varvalue,'DD/MM/RRRR')
        group by od.afacctno, nvl(trfbuydt,cleardate)) st,
    (select re.afacctno, MAX(cf.fullname) refullname
        from reaflnk re, sysvar sys, cfmast cf,RETYPE
        where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
        and substr(re.reacctno,0,10) = cf.custid
        and varname = 'CURRDATE' and grname = 'SYSTEM'
        and re.status <> 'C' and re.deltd <> 'Y'
        AND   substr(re.reacctno,11) = RETYPE.ACTYPE
        AND  rerole IN ( 'RM','BM')
        GROUP BY AFACCTNO) re
    where cf.custid = af.custid
    and cf.custatcom = 'Y'
    and af.actype = aft.actype
    and af.acctno = ci.acctno
    and af.acctno = sec.afacctno
    and af.acctno = ln.trfacctno(+)
    and af.acctno = sts.afacctno(+)
    and af.acctno = trfi.afacctno(+)
    and af.acctno = st.afacctno(+)
    and af.acctno = re.afacctno(+)
)
;

