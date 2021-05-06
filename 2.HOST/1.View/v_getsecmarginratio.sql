CREATE OR REPLACE FORCE VIEW V_GETSECMARGINRATIO AS
select

ci.acctno afacctno, round(ln.marginamt,0) marginamt,nvl(al.secureamt,0) secureamt, nvl(al.execbuyamt,0) execbuyamt,
       nvl(al.trft0amt,0) trft0amt,nvl(al.trfexeamt,0) trfexeamt,nvl(al.trfsecuredamt,0) trfsecuredamt,nvl(al.trft0addamt,0) trft0addamt,nvl(al.trft0amt_over,0) trft0amt_over, nvl(al.trfbuyamt_in,0) trfbuyamt_in, nvl(al.trfbuyamt_over,0) trfbuyamt_over,
       nvl(al.trfbuyamtnofee_in,0) trfbuyamtnofee_in, nvl(al.trfbuyamtnofee,0) trfbuyamtnofee,nvl(al.advamt,0) advamt, nvl(al.overamt,0) overamt,
       nvl(al.buyamt,0) buyamt, nvl(al.buyfeeacr,0) buyfeeacr, nvl(al.execbuyamtfee,0) execbuyamtfee,
       nvl(se.seamt,0) seamt,nvl(se.set0amt,0) set0amt,nvl(se.setotalamt,0) setotalamt,nvl(se.semaxtotalamt,0) semaxtotalamt, nvl(se.seass,0) seass,nvl(se.secallass,0) secallass,nvl(se.set0callass,0) set0callass,nvl(se.setotalcallass,0) setotalcallass,nvl(se.semaxcallass,0) semaxcallass,nvl(se.semaxtotalcallass,0) semaxtotalcallass,nvl(se.semramt,0) semramt,nvl(se.setotalmramt,0) setotalmramt, nvl(se.semrass,0) semrass,
       nvl(se.serealamt,0) serealamt, nvl(se.serealass,0) serealass, nvl(se.secallrealass,0) secallrealass,nvl(se.semaxcallrealass,0) semaxcallrealass, nvl(se.receivingamt,0) receivingamt,
       nvl(adv.avladvance,0) avladvance, nvl(adv.paidamt,0) paidamt,nvl(adv.advanceamount,0) advanceamount, nvl(adv.aamt,0) aamt,0 dealpaidamt,
       least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SEMAXTOTALCALLASS,0), af.mrcrlimitmax - dfodamt) NAVACCOUNT,
       least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SEMAXCALLASS,0), af.mrcrlimitmax - dfodamt) NAVACCOUNTT2,
       (ci.balance - nvl(al.secureamt,0) + nvl(adv.avladvance,0) - ci.odamt - ci.ramt - ci.dfdebtamt - ci.dfintdebtamt - depofeeamt + nvl(se.serealass,0)) NAVMRACCOUNT,
       (/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.seass,0) + GREATEST(ci.balance - nvl(al.secureamt,0) + nvl(adv.avladvance,0) - ci.odamt - ci.ramt - ci.dfdebtamt - ci.dfintdebtamt - depofeeamt,0)) TAVACCOUNT,
       (nvl(af.MRCRLIMIT,0) + nvl(se.serealass,0) + GREATEST(ci.balance - nvl(al.secureamt,0) + nvl(adv.avladvance,0) - ci.odamt - ci.ramt - ci.dfdebtamt - ci.dfintdebtamt - depofeeamt,0)) TAVMRACCOUNT,
       nvl(se.SEMAXCALLREALASS,0)  + GREATEST(ci.balance + nvl(adv.avladvance,0) - nvl(ln.marginamt,0),0) TA_UB,
       round(case when (nvl(se.SEMAXCALLREALASS,0)  + GREATEST(ci.balance + nvl(adv.avladvance,0) - nvl(ln.marginamt,0),0)) > 0 then
                  (ci.balance + nvl(adv.avladvance,0) - nvl(ln.marginamt,0) + nvl(se.SEMAXCALLREALASS,0) ) /
                  (nvl(se.SEMAXCALLREALASS,0) + GREATEST(ci.balance + nvl(adv.avladvance,0) - nvl(ln.marginamt,0),0))
              else case when (nvl(se.SEMAXCALLREALASS,0)  + GREATEST(ci.balance + nvl(adv.avladvance,0) - nvl(ln.marginamt,0),0)) = 0 then -100000 else 0 end end,10) * 100 MARGINRATIO,
       round((case when ci.balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(al.secureamt,0)+trfbuyamt)+ nvl(adv.avladvance,0) - trfbuyamt - ci.odamt - nvl(al.secureamt,0) - ci.ramt>=0 then 100000
                   else    nvl(se.SEMAXTOTALCALLASS,0) --least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SEMAXTOTALCALLASS,0), af.mrcrlimitmax - dfodamt)
                 / abs(ci.balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(al.secureamt,0)+trfbuyamt)+ nvl(adv.avladvance,0) - trfbuyamt - ci.odamt - nvl(al.secureamt,0) - ci.ramt) end),4) * 100 MARGINRATE,
       --PhuongHT add them _EX: khong tinh no bao lanh
        round((case when ci.balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(al.secureamt,0)+trfbuyamt)+ nvl(adv.avladvance,0) - trfbuyamt +nvl(LN.NYOVDAMT,0)- ci.odamt - nvl(al.secureamt,0) - ci.ramt>=0 then 100000
                   else    nvl(se.SEMAXTOTALCALLASS,0) --least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SEMAXTOTALCALLASS,0), af.mrcrlimitmax - dfodamt)
                 / abs(ci.balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(al.secureamt,0)+trfbuyamt)+ nvl(adv.avladvance,0) - trfbuyamt +nvl(LN.NYOVDAMT,0)- ci.odamt - nvl(al.secureamt,0) - ci.ramt) end),4) * 100 MARGINRATE_EX,

        round((case when ci.balance +LEAST(nvl(af.MRCRLIMIT,0), nvl(al.secureamt,0)+ trfbuyamt)+ nvl(adv.avladvance,0) - trfbuyamt - ci.odamt  - nvl(al.secureamt,0) - ci.ramt>=0 then 100000
        else least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SEMAXTOTALCALLASS,0), af.mrcrlimitmax - dfodamt)
        / abs(ci.balance +LEAST(nvl(af.MRCRLIMIT,0), nvl(al.secureamt,0)+ trfbuyamt) +nvl(adv.avladvance,0) - trfbuyamt - ci.odamt  - nvl(al.secureamt,0) - ci.ramt) end),4) * 100 MARGINRATE5,
       --phuongnt add
       CASE WHEN mr.mrtype ='N' OR mr.mrtype ='L' THEN
         round(af.advanceline +
                     ci.balance
                    - nvl(al.secureamt,0)
                    + nvl(adv.avladvance,0)
                    + least(nvl(AF.mrcrlimitmax,0) + nvl(af.mrcrlimit,0) - dfodamt ,
                            nvl(af.mrcrlimit,0) )
                    - nvl(ci.odamt,0)
                    - ci.ramt
                    - ci.depofeeamt,0)
         ELSE
                   case when chksysctrl='Y' then
                   least(round(
                                ci.balance
                               - nvl(al.secureamt,0)
                               + nvl(adv.avladvance,0)
                               + least(nvl(AF.mrcrlimitmax,0) + nvl(af.mrcrlimit,0) - ci.dfodamt ,
                                       nvl(af.mrcrlimit,0) + nvl(se.semramt,0))
                               - nvl(ci.odamt,0)
                               -nvl(ci.dfdebtamt,0)
                               - nvl(ci.dfintdebtamt,0)
                               - ci.ramt
                               - ci.depofeeamt,
                               0)
                          ,
                           round(
                           ci.balance
                           - nvl(al.secureamt,0)
                           + nvl(adv.avladvance,0)
                           + least(nvl(AF.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - ci.dfodamt,
                                   nvl(af.mrcrlimit,0) + nvl(se.seamt,0))
                           -nvl(ci.dfdebtamt,0)
                           - nvl(ci.dfintdebtamt,0)
                           - nvl(ci.odamt,0)
                           - ci.ramt
                           - ci.depofeeamt,0)
                    )
                   else
                     round(
                           ci.balance
                           - nvl(al.secureamt,0)
                           + nvl(adv.avladvance,0)
                           + least(nvl(AF.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,
                                   nvl(af.mrcrlimit,0) + nvl(se.seamt,0))
                           -nvl(dfdebtamt,0)
                           - nvl(dfintdebtamt,0)
                           - nvl(ci.odamt,0)
                           - ramt
                           - ci.depofeeamt,0)
                   END
           END
                   PP,
        --
        --Rtt khong bao gom bao lanh trong han
       round((case when ci.balance +LEAST(nvl(af.MRCRLIMIT,0), nvl(al.secureamt,0)+ trfbuyamt)+ nvl(adv.avladvance,0) - trfbuyamt - ci.odamt + NVL(ln.NYOVDAMT,0) - nvl(al.secureamt,0) - ci.ramt>=0 then 100000
                    else least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SEMAXTOTALCALLASS,0), af.mrcrlimitmax - dfodamt)
            / abs(ci.balance +LEAST(nvl(af.MRCRLIMIT,0), nvl(al.secureamt,0)+ trfbuyamt) +nvl(adv.avladvance,0) - trfbuyamt - ci.odamt + NVL(ln.NYOVDAMT,0) - nvl(al.secureamt,0) - ci.ramt) end),4) * 100 MARGINRATE_T0,

       round((case when ci.balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(trfi.trfsecuredamt_inday,0) + nvl(trfi.secureamt_inday,0)+nvl(trfsecuredamt,0))
                     + nvl(adv.avladvance,0) - nvl(trfsecuredamt,0)
                     - nvl(trfi.trfsecuredamt_inday,0) - nvl(trfi.secureamt_inday,0) - ci.odamt - ci.ramt >=0 then 100000
                else least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SEMAXCALLASS,0), af.mrcrlimitmax - dfodamt)
                      / abs(ci.balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(trfi.trfsecuredamt_inday,0) + nvl(trfi.secureamt_inday,0)+nvl(trfsecuredamt,0))
                     + nvl(adv.avladvance,0) - nvl(trfsecuredamt,0)
                     - nvl(trfi.trfsecuredamt_inday,0) - nvl(trfi.secureamt_inday,0) - ci.odamt - ci.ramt) end),4) * 100 RLSMARGINRATE,
      round((case when ci.balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(trfi.trfsecuredamt_inday,0) + nvl(trfi.secureamt_inday,0)+nvl(trfsecuredamt,0))
                     + nvl(adv.avladvance,0) - nvl(trfsecuredamt,0)
                     - nvl(trfi.trfsecuredamt_inday,0) - nvl(trfi.secureamt_inday,0)+nvl(ln.NYOVDAMT,0) - ci.odamt - ci.ramt >=0 then 100000
                else least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SEMAXCALLASS,0), af.mrcrlimitmax - dfodamt)
                      / abs(ci.balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(trfi.trfsecuredamt_inday,0) + nvl(trfi.secureamt_inday,0)+nvl(trfsecuredamt,0))
                     + nvl(adv.avladvance,0) - nvl(trfsecuredamt,0)
                     - nvl(trfi.trfsecuredamt_inday,0) - nvl(trfi.secureamt_inday,0) +nvl(ln.NYOVDAMT,0)- ci.odamt - ci.ramt) end),4) * 100 RLSMARGINRATE_EX,

     (nvl(adv.avladvance,0) +nvl(af.MRCRLIMIT,0)+ balance - trfbuyamt - nvl(al.secureamt,0) - nvl (al.overamt, 0) - ci.odamt - ci.ramt - ci.dfdebtamt - ci.dfintdebtamt + af.advanceline - nvl(trft0amt,0)
                            + af.mrcrlimitmax - ci.dfodamt)  avlmrlimit,
     nvl(adv.avladvance,0) + balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(al.secureamt,0)+trfbuyamt)- trfbuyamt - nvl(al.secureamt,0) - nvl (al.overamt, 0)- ci.odamt - ci.ramt - ci.dfdebtamt - ci.dfintdebtamt outstanding,
     nvl(adv.avladvance,0) + balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(al.secureamt,0)+trfbuyamt)- trfbuyamt - nvl(al.secureamt,0) - nvl (al.overamt, 0)- nvl(LN.marginamt,0) - ci.ramt - ci.dfdebtamt - ci.dfintdebtamt outstanding_UB,
     nvl(adv.avladvance,0) + balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(al.secureamt,0)+trfbuyamt)- trfbuyamt - nvl(al.secureamt,0) - nvl (al.overamt, 0)- ci.odamt - ci.ramt - ci.dfdebtamt - ci.dfintdebtamt outstanding_SY,
     nvl(adv.avladvance,0) + balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(trfi.trfsecuredamt_inday,0) + nvl(trfi.secureamt_inday,0)+ (trfbuyamt - nvl(al.trft0amt,0)))
                           - (trfbuyamt - nvl(al.trft0amt,0))    - nvl(trfi.trfsecuredamt_inday,0) - nvl(trfi.secureamt_inday,0)
        - ci.odamt - ci.ramt - ci.dfdebtamt - ci.dfintdebtamt outstandingT2,
     chksysctrl, af.MRIRATIO,af.MRMRATIO,af.MRLRATIO,af.mrcrlimitmax,
     nvl(ln.NYOVDAMT,0) NYOVDAMT

from cimast ci, afmast af, aftype aft, lntype lnt
        --phuongntn add
        ,mrtype mr,
        --
        v_getbuyorderinfo al,
        v_getsecmargininfo se,
        vw_trfbuyinfo_inday trfi,

        (SELECT trfacctno, sum(CASE WHEN lns.reftype = 'GP'
                                THEN
                                    (case when mintermdate >= getcurrdate then   (lns.nml + lns.ovd + lns.intdue + lns.intovd + lns.feedue + lns.feeovd + lns.intovdprin + lns.intnmlacr
                                   + lns.feeintnmlacr + lns.feeintovdacr + lns.feeintnmlovd + lns.feeintdue + lns.nmlfeeint + lns.ovdfeeint + lns.feeintnml + lns.feeintovd ) else 0 end)
                                   else  0
                             END )  NYOVDAMT,
                         sum( CASE WHEN  ln.ftype = 'AF'
                                      THEN   CASE WHEN lns.reftype = 'P' THEN decode(lnt.chksysctrl, 'N',0, (lns.nml + lns.ovd + lns.intdue + lns.intovd + lns.feedue + lns.feeovd + lns.intovdprin + lns.intnmlacr
                                           + lns.feeintnmlacr + lns.feeintovdacr + lns.feeintnmlovd + lns.feeintdue + lns.nmlfeeint + lns.ovdfeeint + lns.feeintnml + lns.feeintovd ))
                                             ELSE 0 end
                                      ELSE 0
                                      END ) marginamt

         FROM lnschd lns, lnmast ln ,lntype lnt
         WHERE lns.acctno = ln.acctno
                AND   ln.actype = lnt.actype
               group by trfacctno) LN,

         (select sum(aamt) aamt,sum(depoamt) avladvance,sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno from v_getAccountAvlAdvance group by afacctno) adv
where ci.acctno = af.acctno and af.actype = aft.actype and aft.lntype = lnt.actype(+)
        and ci.acctno = al.afacctno(+) and se.afacctno(+)=ci.acctno and adv.afacctno(+)=ci.acctno
        and ln.trfacctno(+) = ci.acctno
        and ci.acctno = trfi.afacctno(+)
        --phuongnt add
        AND aft.mrtype =mr.actype
;

