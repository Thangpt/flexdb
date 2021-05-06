
CREATE OR REPLACE VIEW V_CIMASTCHECK AS
SELECT ci.actype, ci.acctno, ci.ccycd,
                   ci.afacctno, ci.custid, ci.opndate,
                   ci.clsdate, ci.lastdate, ci.dormdate,
                   ci.status, ci.pstatus,
                   af.advanceline - nvl(trft0amt,0) advanceline,
                   ci.balance - NVL (secureamt, 0) balance, ci.cramt,
                   ci.dramt, ci.crintacr,ci.CIDEPOFEEACR, ci.crintdt,
                   ci.odintacr, ci.odintdt, ci.avrbal,
                   ci.mdebit, ci.mcredit, ci.aamt, ci.ramt,
                   NVL (secureamt, 0) bamt, ci.emkamt, ci.mmarginbal,
                   ci.marginbal, ci.iccfcd, ci.iccftied,
                   ci.odlimit, ci.adintacr, ci.adintdt,
                   ci.facrtrade, ci.facrdepository, ci.facrmisc,
                   ci.minbal, ci.odamt, ci.namt, ci.floatamt,
                   ci.holdbalance, ci.pendinghold,
                   ci.pendingunhold, ci.corebank, ci.receiving,
                   ci.netting, ci.mblock, mr.actype mrtype,
                   round(
                    DECODE(sy.isstopadv,'Y',0,nvl(adv.avladvance,0)) + nvl(balance,0) - nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - NVL (advamt, 0)- nvl(secureamt,0) + advanceline - nvl(trft0amt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) - nvl(ramt,0) - ci.depofeeamt + least(af.mrcrlimitmax +af.mrcrlimit- ci.dfodamt,af.mrcrlimit)
                    ,0) pp,
                   round(
                    DECODE(sy.isstopadv,'Y',0,nvl(adv.avladvance,0)) + nvl(balance,0) - nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - NVL (advamt, 0)- nvl(secureamt,0) + advanceline - nvl(trft0amt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) - nvl(ramt,0) - ci.depofeeamt + least(af.mrcrlimitmax+af.mrcrlimit - ci.dfodamt,af.mrcrlimit)
                    ,0) ppref,
                    DECODE(sy.isstopadv,'Y',0,nvl(adv.avladvance,0))
                   + AF.mrcrlimitmax+af.mrcrlimit - dfodamt
                   + af.advanceline - nvl(trft0amt,0)
                   + balance
                   - odamt
                   - dfdebtamt
                   - dfintdebtamt
                   - NVL (overamt, 0)
                   - NVL (secureamt, 0) - nvl(trfsecuredamt,0) - nvl(trft0addamt,0)
                   - ramt
                   - ci.depofeeamt avllimit,
                   DECODE(sy.isstopadv,'Y',0,nvl(adv.avladvance,0)) +
                   AF.mrcrlimitmax +af.mrcrlimit- dfodamt
                   + balance- trfbuyamt
                   - odamt
                   - dfdebtamt
                   - dfintdebtamt
                   - NVL (overamt, 0)
                   - NVL (secureamt, 0) - nvl(trfsecuredamt,0) - nvl(trft0addamt,0)
                   - ramt
                   - ci.depofeeamt avlmrlimit,
                   greatest(least(
                                    AF.mrcrlimitmax - dfodamt,
                                    AF.mrcrlimitmax - dfodamt + af.advanceline -odamt
                                    ),
                                0
                        ) deallimit,
                   0 navaccount, 0 outstanding, af.mrirate,
                   GREATEST ( DECODE(sy.isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt
                             - odamt
                             - dfdebtamt
                             - dfintdebtamt
                             - NVL (advamt, 0)
                             - NVL (secureamt, 0)
                             - ramt
                             - nvl(pd.dealpaidamt,0)
                             - ci.depofeeamt,
                             0
                            ) avlwithdraw,
                   greatest(
                        DECODE(sy.isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - NVL (overamt, 0) - nvl(secureamt,0) - ramt-nvl(pd.dealpaidamt,0) - ci.depofeeamt
                        ,0) BALDEFOVD,
                   greatest(
                        DECODE(sy.isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance
                                         - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - ramt-nvl(pd.dealpaidamt,0) - ci.depofeeamt
                                    - greatest(
                                            nvl(trfi.secureamt_inday,0)
                                            + (nvl(trfi.trfbuyamtnofee_inday,0) + nvl(trfbuyamtnofee,0)) * trfr.TRFBUYRATE
                                            ,
                                            nvl(b.buyamt,0) + nvl(b.buyfeeacr,0) - least(af.trfbuyrate/100* nvl(b.buyamt,0) + case when af.trfbuyrate > 0 then nvl(b.buyfeeacr,0) else 0 end, af.advanceline - nvl(b.trft0amt,0) )
                                            + nvl(b.trfsecuredamt,0)
                                            + nvl(b.trft0amt_over,0))
                        ,0) BALDEFTRFAMT,

                   GREATEST (  round(least(DECODE(sy.isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt ,
                                    DECODE(sy.isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt  +
                                    af.advanceline -NVL (advamt, 0)-
                                    nvl(secureamt,0)-ramt
                            ),0
                   ) ,0) baldefovd_released,
                   dfdebtamt,
                   dfintdebtamt,
                   GREATEST ( DECODE(sy.isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt
                             - odamt
                             - dfdebtamt
                             - dfintdebtamt
                             - NVL (advamt, 0)
                             - NVL (secureamt, 0)
                             - ramt
                             - nvl(pd.dealpaidamt,0),
                             0
                            ) baldefovd_released_depofee,  -- Su dung de check khi thu phi luu ky
                   DECODE(sy.isstopadv,'Y',0,nvl(adv.avladvance,0)) avladvance, nvl(adv.advanceamount,0) advanceamount, nvl(adv.paidamt,0) paidamt,
                   nvl(b.EXECBUYAMT,0) EXECBUYAMT, nvl(pd.dealpaidamt,0) dealpaidamt, 0 SEASS , 0 MARGINRATE,
                    -- tk binh thuong SEASS = 0
                     --PhuongHT edit 29.02.2016
                  nvl(b.trfbuyamt_over,0) trfbuyamt_over, 0 set0amt,
                  (case when ci.balance  + nvl(adv.avladvance,0)  + NVL(lns.NYOVDAMT,0) - ci.odamt - ci.ramt>=0 then 100000
                    else 0 end) rlsmarginrate_ex,
                  0 NYOVDAMT,
                  (case when ci.balance  + nvl(adv.avladvance,0)  + NVL(lns.NYOVDAMT,0) - ci.odamt - ci.ramt>=0 then 100000
                  else 0 end) marginrate_Ex,
                  0 semaxtotalcallass,0 secallass,
                  0 CLAMT,0 navaccountt2_EX,
                  0 outstanding_EX,
                  0 navaccount_ex,100000 MARGINRATE5,
                  0 outstanding5,0 ODAMT_EX,
                  0 outstandingT2_EX,
                  0 semaxcallass,
                  nvl(trfi.secureamt_inday,0) secureamt_inday,
                  nvl(trfi.trfsecuredamt_inday,0)trfsecuredamt_inday
                 -- end of PhuongHT edit ngay 29.02.2016

              FROM cimast ci,
                    afmast af, aftype aft, mrtype mr,
                    (SELECT * FROM v_getbuyorderinfo) b,
                    (select * from vw_trfbuyinfo_inday) trfi,
                    (select sum(depoamt) avladvance,afacctno, sum(advamt) advanceamount, sum(paidamt) paidamt
                                from v_getAccountAvlAdvance
                        group by afacctno) adv,
                (select * from v_getdealpaidbyaccount p) pd,
                (select (100 - to_number(varvalue))/100 trfbuyrate from sysvar where grname = 'SYSTEM' and varname = 'TRFBUYRATE') trfr,
                 (SELECT trfacctno,SUM(NYOVDAMT) NYOVDAMT
                 FROM (SELECT trfacctno,LN.ACCTNO, 
                  sum((case when mintermdate >= getcurrdate 
                    then (lns.nml + lns.ovd + lns.intdue + lns.intovd + lns.feedue + lns.feeovd + lns.intovdprin + lns.intnmlacr
                     + lns.feeintnmlacr + lns.feeintovdacr + lns.feeintnmlovd + lns.feeintdue + lns.nmlfeeint + lns.ovdfeeint + lns.feeintnml + lns.feeintovd ) 
                else 0 end)                          
                 ) + MAX(nvl(LN.intnmlpbl,0)) NYOVDAMT
                FROM lnschd lns, lnmast ln ,lntype lnt
                WHERE lns.acctno = ln.acctno
                AND  ln.actype = lnt.actype
                and  lns.reftype = 'GP'
                group by trfacctno,LN.ACCTNO)
                GROUP BY trfacctno
                )lns,
                (SELECT varvalue isstopadv FROM sysvar WHERE varname = 'ISSTOPADV' AND grname = 'MARGIN') sy
       WHERE ci.acctno = af.acctno
       and af.actype = aft.actype
         AND aft.mrtype = mr.actype
         and mr.mrtype  in('L','N')
        and  ci.acctno =    b.afacctno(+)
        and ci.acctno =adv.afacctno(+)
        and ci.acctno =trfi.afacctno(+)
        and  ci.acctno= pd.afacctno(+)
        and ci.acctno=lns.trfacctno(+)
           --  WHERE ci.acctno = pv_condvalue;
  -- TK MAGIN KO GROUP
  union all
    SELECT
                ACTYPE,ACCTNO,CCYCD,AFACCTNO,CUSTID,OPNDATE,CLSDATE,LASTDATE,
                DORMDATE,STATUS,PSTATUS,ADVANCELINE - nvl(TRFT0AMT,0) ADVANCELINE, BALANCE,CRAMT,DRAMT,CRINTACR, cidepofeeacr, CRINTDT,ODINTACR,ODINTDT,
                AVRBAL,MDEBIT,MCREDIT,AAMT,RAMT,BAMT,EMKAMT,MMARGINBAL,MARGINBAL,ICCFCD,ICCFTIED,
                ODLIMIT,ADINTACR,ADINTDT,FACRTRADE,FACRDEPOSITORY,FACRMISC,MINBAL,ODAMT,NAMT,FLOATAMT,
                HOLDBALANCE,PENDINGHOLD,PENDINGUNHOLD,COREBANK,RECEIVING,NETTING,MBLOCK,mrtype,PP,PPREF,AVLLIMIT,AVLMRLIMIT,DEALLIMIT,
                NAVACCOUNT,OUTSTANDING,MRIRATE,
                TRUNC(
                    GREATEST(
                        (CASE WHEN MRIRATE>0 THEN least(NAVACCOUNT*100/MRIRATE + (OUTSTANDING-(ADVANCELINE-trft0amt)),AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE NAVACCOUNT + OUTSTANDING END)
                    ,0) - DEALPAIDAMT
                ,0) AVLWITHDRAW,
                --Neu co bao lanh T0 thi khong duoc rut
                greatest(case when isChkSysCtrlDefault = 'Y' then
                    least(
                        (MARGINRATIO/100 - MRIRATIO/100) * (serealass) + greatest(0,balance+nvl(bamt,0)+nvl(avladvance,0)-ovamt-dueamt-depofeeamt)
                        ,
                       TRUNC(
                        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNT + (OUTSTANDING-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
                        - DEALPAIDAMT
                    ,0))
                else
                    TRUNC(
                        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNT + (OUTSTANDING-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
                        - DEALPAIDAMT
                    ,0)
                end,0) BALDEFOVD,
                greatest(case when isChkSysCtrlDefault = 'Y' then
                    least(
                        (MARGINRATIO/100 - MRIRATIO/100) * (serealass) + greatest(0,balance+nvl(bamt,0)+nvl(avladvance,0)-ovamt-dueamt-depofeeamt)
                        ,
                       TRUNC(
                        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNTT2 + (OUTSTANDINGT2-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFTRFAMT,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFTRFAMT END)
                        - DEALPAIDAMT
                    ,0))
                else
                    TRUNC(
                        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNTT2 + (OUTSTANDINGT2-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFTRFAMT,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFTRFAMT END)
                        - DEALPAIDAMT
                    ,0)
                end,0) BALDEFTRFAMT,
                baldefovd_Released,
                DFDEBTAMT, dfintdebtamt,
                TRUNC
                ((CASE
                     WHEN mrirate > 0
                        THEN LEAST (GREATEST (  (  100 * navaccount
                                                 +   (  outstanding + depofeeamt
                                                      - (advanceline-nvl(trft0amt,0))
                                                     )
                                                   * mrirate
                                                )
                                              / mrirate,
                                              0
                                             ),
                                    baldefovd + depofeeamt,
                                    avllimit + depofeeamt - (advanceline-nvl(trft0amt,0))
                                   )
                     ELSE baldefovd + depofeeamt
                  END
                 ) - dealpaidamt ,
                 0
                ) Baldefovd_Released_Depofee,  -- Su dung de check khi thu phi luu ky
                avladvance, advanceamount, paidamt, EXECBUYAMT, dealpaidamt, SEASS, MARGINRATE,
                    --PhuongHT edit ngay 29.02.2016
                trfbuyamt_over,set0amt, rlsmarginrate_ex,
                NYOVDAMT, marginrate_Ex,
                semaxtotalcallass, secallass,
                CLAMT,navaccountt2_EX,
                outstanding_EX,
                navaccount_ex, MARGINRATE5,
                outstanding5,ODAMT_EX,
                outstandingT2_EX,
                semaxcallass,
                secureamt_inday,
                trfsecuredamt_inday
                 -- end of PhuongHT edit ngay 29.02.2016
                FROM
                    (SELECT cidepofeeacr, af.advanceline,ci.actype,ci.acctno,ci.ccycd,ci.afacctno,ci.custid,ci.opndate,ci.clsdate,ci.lastdate,ci.dormdate,ci.status,ci.pstatus,
                        ci.balance-nvl(secureamt,0) balance, ci.DFDEBTAMT,
                        ci.cramt,ci.dramt,ci.crintacr,ci.crintdt,ci.odintacr,ci.odintdt,ci.avrbal,ci.mdebit,ci.mcredit,ci.aamt,ci.ramt,
                        nvl(secureamt,0) bamt,
                        ci.emkamt,ci.mmarginbal,ci.marginbal,ci.iccfcd,ci.iccftied,ci.odlimit,ci.adintacr,ci.adintdt,
                        ci.facrtrade,ci.facrdepository,ci.facrmisc,ci.minbal,ci.odamt,ci.namt,ci.floatamt,ci.holdbalance,
                        ci.pendinghold,ci.pendingunhold,ci.corebank,ci.receiving,ci.netting,ci.mblock, ci.dfintdebtamt,
                        greatest(
                             DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) + balance /*- trfbuyamt*/ - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt /*- NVL (overamt, 0) - nvl(secureamt,0)*/ - ramt-nvl(se.dealpaidamt,0) - ci.depofeeamt
                             ,0) BALDEFOVD,
                        greatest(
                             DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) + balance - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - ramt-nvl(se.dealpaidamt,0) - ci.depofeeamt
                                         /*- greatest(0, nvl(se.buyamt,0) + nvl(se.buyfeeacr,0) - least(af.trfbuyrate/100* nvl(se.buyamt,0) + case when af.trfbuyrate > 0 then nvl(se.buyfeeacr,0) else 0 end, af.advanceline - nvl(se.trft0amt,0) )
                                                 + nvl(trfsecuredamt,0)
                                                 + nvl(se.trft0addamt,0))*/
                             ,0) baldeftrfamt,
                        greatest(ci.balance - trfbuyamt - nvl(se.secureamt,0) + DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - af.advanceline,0) BALDEFOVD_RLSODAMT ,
                        greatest(round(least(DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) + balance - trfbuyamt ,DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) + balance - trfbuyamt  + af.advanceline -NVL (advamt, 0)-nvl(secureamt,0)-ramt),0) ,0) baldefovd_released,
                        case when isChkSysCtrlDefault = 'Y' then
                             least(
                             round(ci.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                                 - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0) +nvl(af.mrcrlimit,0)- dfodamt,nvl(af.mrcrlimit,0) + nvl(se.semramt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt - ci.depofeeamt,0),
                             round(ci.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                                 - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0) +nvl(af.mrcrlimit,0)- dfodamt,nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                             )
                        else
                             round(ci.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                                 - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                        end PP,
                        case when isChkSysCtrlDefault = 'Y' then
                             least(
                             round(ci.balance - nvl(se.secureamt,0) - nvl(se.overamt,0)
                                 - ci.trfbuyamt + DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.setotalmramt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt - ci.depofeeamt,0),
                             round(ci.balance - nvl(se.secureamt,0) - nvl(se.overamt,0)
                                 - ci.trfbuyamt + DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0) +nvl(af.mrcrlimit,0)- dfodamt,nvl(af.mrcrlimit,0) + nvl(se.setotalamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                             )
                        else
                             round(ci.balance - nvl(se.secureamt,0) - nvl(se.overamt,0)
                                 - ci.trfbuyamt + DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.setotalamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                        end PPREF,
                        round(
                            DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) + nvl(af.advanceline,0) - nvl(trft0amt,0) - nvl(trfsecuredamt,0) + nvl(se.mrcrlimitmax,0)- dfodamt + balance +nvl(af.mrcrlimit,0)- odamt - ci.dfdebtamt - ci.dfintdebtamt - nvl(secureamt,0) - ramt - ci.depofeeamt
                        ,0) AVLLIMIT,
                        round(
                            DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) + nvl(af.advanceline,0) - nvl(trfsecuredamt,0)   + nvl(se.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)- dfodamt + balance - odamt - ci.dfdebtamt - ci.dfintdebtamt - ramt - ci.depofeeamt
                                -nvl(trf.trfsecuredamt_inday,0)-nvl(trf.secureamt_inday,0)
                        ,0) AVLLIMITT2,
                        DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) + nvl(se.mrcrlimitmax,0)- dfodamt + balance - trfbuyamt - odamt - ci.dfdebtamt - ci.dfintdebtamt  - nvl(secureamt,0) - ramt - ci.depofeeamt  avlmrlimit,
                        greatest(least(nvl(se.mrcrlimitmax,0) - dfodamt,
                                nvl(se.mrcrlimitmax,0) - dfodamt + nvl(af.advanceline,0) -odamt),0) deallimit,
                        least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SETOTALCALLASS,0),nvl(SE.mrcrlimitmax,0) - dfodamt) NAVACCOUNT,
                        least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SET0CALLASS,0),nvl(SE.mrcrlimitmax,0) - dfodamt) NAVACCOUNTT2,
                        nvl(af.advanceline,0) - nvl(trft0amt,0) + ci.balance+LEAST(nvl(af.mrcrlimit,0),nvl(se.secureamt,0)) - trfbuyamt + DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - NVL (se.advamt, 0)-nvl(se.secureamt,0) - ci.ramt OUTSTANDING, --kHI DAT LENH THI THEM PHAN T0
                        least(nvl(af.advanceline,0)  - nvl(trft0amt,0) + ci.balance
                               +LEAST(NVL(af.mrcrlimit,0),nvl(se.trft0amt_over,0)+nvl(trf.trfsecuredamt_inday,0) + nvl(se.trfsecuredamt,0) +nvl(trf.secureamt_inday,0))
                                   + DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0))- ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - ci.ramt - nvl(se.trft0amt_over,0)
                                    -nvl(trf.trfsecuredamt_inday,0) - nvl(se.trfsecuredamt,0) -nvl(trf.secureamt_inday,0),
                                nvl(af.advanceline,0)  - nvl(trft0amt,0) + ci.balance
                                    +LEAST(af.mrcrlimit,+(nvl(trf.trfbuyamtnofee_inday,0)+nvl(trfbuyamtnofee,0)) * trfr.TRFBUYRATE + nvl(trf.secureamt_inday,0))
                                    + DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - ci.ramt
                                    -(nvl(trf.trfbuyamtnofee_inday,0)+nvl(trfbuyamtnofee,0)) * trfr.TRFBUYRATE - nvl(trf.secureamt_inday,0)
                                ) OUTSTANDINGT2,
                        af.mrirate,nvl(se.dealpaidamt,0) dealpaidamt,
                        se.chksysctrl, nvl(se.trft0amt,0) trft0amt,
                        DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) avladvance, nvl(se.advanceamount,0) advanceamount, nvl(se.paidamt,0) paidamt,
                        nvl(se.EXECBUYAMT,0) EXECBUYAMT, nvl(se.SEASS,0) SEASS,NVL(SE.MARGINRATE,0) MARGINRATE , nvl(margin74amt,0) margin74amt, nvl(serealass,0) serealass,
                        af.MRIRATIO, nvl(MARGINRATIO,0) MARGINRATIO, depofeeamt, dueamt, ovamt, af.isMarginAcc, AF.isChkSysCtrlDefault, mr.actype mrtype,
                         --PhuongHT edit ngay 29.02.2016
                        nvl(se.trfbuyamt_over,0) trfbuyamt_over, nvl(se.set0amt,0) set0amt,nvl(se.rlsmarginrate_ex,0) rlsmarginrate_ex,
                        nvl(se.NYOVDAMT,0) NYOVDAMT,nvl(se.marginrate_ex,0) marginrate_Ex,
                        nvl(se.semaxtotalcallass,0) semaxtotalcallass,nvl(secallass,0) secallass,
                        nvl(se.navaccount,0) CLAMT,nvl(se.navaccountt2,0) navaccountt2_EX,
                        nvl(se.outstanding,0)+nvl(se.NYOVDAMT,0) outstanding_EX,
                        nvl(se.navaccount,0) navaccount_ex,nvl(se.MARGINRATE5,0) MARGINRATE5,
                        nvl(se.outstanding,0)outstanding5,
                        abs(ci.balance +LEAST(nvl(af.MRCRLIMIT,0), nvl(secureamt,0)+ trfbuyamt) + DECODE(sy.isstopadv,'Y',0,nvl(se.avladvance,0)) - trfbuyamt - ci.odamt - nvl(secureamt,0) - ci.ramt) odAMT_EX,
                        nvl(se.outstandingt2,0)+nvl(se.NYOVDAMT,0) outstandingT2_EX,
                        nvl(se.semaxcallass,0) semaxcallass,
                        nvl(trf.secureamt_inday,0) secureamt_inday,
                        nvl(trf.trfsecuredamt_inday,0)trfsecuredamt_inday
                        -- end of PhuongHT edit ngay 29.02.2016
                   from cimast ci,
                        ( SELECT af.*,
                            CASE WHEN (exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y')
                                        or exists (select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y'))
                                    THEN 'Y' ELSE 'N' END isMarginAcc,
                            CASE WHEN exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y')
                                    THEN 'Y' ELSE 'N' END isChkSysCtrlDefault
                            from afmast af
                        ) af,
                        aftype aft, mrtype mr,
                        (select * from v_getsecmarginratio) se,
                        (select * from vw_trfbuyinfo_inday) trf,
                        (select TRFACCTNO, nvl(sum(ln.PRINOVD + ln.INTOVDACR + ln.INTNMLOVD + ln.OPRINOVD + ln.OPRINNML + ln.OINTNMLOVD + ln.OINTOVDACR+ln.OINTDUE+ln.OINTNMLACR + nvl(lns.nml,0) + nvl(lns.intdue,0)),0) OVDAMT,
                                                       nvl(sum(ln.PRINNML - nvl(nml,0)+ ln.INTNMLACR),0) NMLMARGINAMT,
                                            nvl(sum(decode(lnt.chksysctrl,'Y',1,0)*(ln.prinnml+ln.prinovd+ln.intnmlacr+ln.intdue+ln.intovdacr+ln.intnmlovd+ln.feeintnmlacr+ln.feeintdue+ln.feeintovdacr+ln.feeintnmlovd)),0) margin74amt
                                        from lnmast ln, lntype lnt, (select acctno, sum(nml) nml, sum(intdue) intdue  from lnschd
                                                            where reftype = 'P' and  overduedate = to_date(cspks_system.fn_get_sysvar('SYSTEM','CURRDATE'),'DD/MM/RRRR') group by acctno) lns
                                        where ln.actype = lnt.actype and ln.acctno = lns.acctno(+) and ln.ftype = 'AF'
                                        group by ln.trfacctno) OVDAF,
                        (select afacctno, sum(amt) receivingamt from stschd
                            where duetype = 'RM' and status <> 'C' and deltd <> 'Y' group by afacctno) sts_rcv,
                        (select (100 - to_number(varvalue))/100 trfbuyrate from sysvar where grname = 'SYSTEM' and varname = 'TRFBUYRATE') trfr,
                        (SELECT varvalue isstopadv FROM sysvar WHERE varname = 'ISSTOPADV' AND grname = 'MARGIN') sy
                   WHERE ci.acctno = af.acctno
                     and   af.actype = aft.actype
                     AND aft.mrtype = mr.actype
                     and mr.mrtype  in   ('S','T')
                     AND (LENGTH (af.groupleader) = 0 OR af.groupleader IS NULL)
                     and ci.acctno= se.afacctno(+)
                     and ci.acctno= trf.afacctno(+)
                     and   ci.acctno= OVDAF.TRFACCTNO (+)
                     AND ci.acctno = sts_rcv.afacctno (+)
                 )
;
