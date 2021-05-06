CREATE OR REPLACE FUNCTION fn_cimastcheck_for_report (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN txpks_check.cimastcheck_arrtype
   IS
      l_margintype            CHAR (1);
      l_actype                VARCHAR2 (4);
      l_groupleader           VARCHAR2 (10);
      l_baldefovd             NUMBER (20, 0);
      l_baldefovd_Released    NUMBER (20, 0);

      l_pp                    NUMBER (20, 0);
      l_avllimit              NUMBER (20, 0);
      l_deallimit             NUMBER (20, 0);
      l_navaccount            NUMBER (20, 0);
      l_outstanding           NUMBER (20, 0);
      l_mrirate               NUMBER (20, 4);

      l_baldefovd_Released_depofee    NUMBER (20, 0);

      l_cimastcheck_rectype   txpks_check.cimastcheck_rectype;
      l_cimastcheck_arrtype   txpks_check.cimastcheck_arrtype;
      l_i                     NUMBER (10);
      pv_refcursor            pkg_report.ref_cursor;
      l_count number;
      l_isChkSysCtrlDefault varchar2(1);
      l_isMarginAcc varchar2(1);

      l_avladvance  NUMBER; -- TheNN added
      l_advanceamount NUMBER; -- TheNN added
      l_paidamt       NUMBER; -- TheNN added
      l_EXECBUYAMT       NUMBER; -- TheNN added
      l_TRFBUYRATE       NUMBER;
      l_isstopadv       varchar2(10);
   BEGIN
         -- Proc
     l_isstopadv := cspks_system.fn_get_sysvar('MARGIN','ISSTOPADV');
        --l_TRFBUYRATE:= (100 - to_number(cspks_system.fn_get_sysvar('SYSTEM', 'TRFBUYRATE')))/100;
     SELECT (100 - to_number(varvalue))/100 into l_TRFBUYRATE from sysvar where grname ='SYSTEM' and varname ='TRFBUYRATE';
     SELECT mr.mrtype, af.actype, mst.groupleader
       INTO l_margintype, l_actype, l_groupleader
       FROM afmast mst, aftype af, mrtype mr
      WHERE mst.actype = af.actype
        AND af.mrtype = mr.actype
        AND mst.acctno = pv_condvalue;
    plog.error('fn_cimastcheck_for_report: l_margintype ' || l_margintype || 'begin fn');

      IF l_margintype = 'N' or l_margintype = 'L'
      THEN
         --Tai khoan binh thuong khong Margin
         OPEN pv_refcursor FOR
            SELECT ci.actype, ci.acctno, ci.ccycd,
                   ci.afacctno, ci.custid, ci.opndate,
                   ci.clsdate, ci.lastdate, ci.dormdate,
                   ci.status, ci.pstatus,
                   af.advanceline - nvl(trft0amt,0) advanceline,
                   ci.balance - NVL (secureamt, 0) balance,
                   ci.balance + decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)) avlbal,
                   ci.cramt,
                   ci.dramt, ci.crintacr,ci.CIDEPOFEEACR, ci.crintdt,
                   ci.odintacr, ci.odintdt, ci.avrbal,
                   ci.mdebit, ci.mcredit, ci.aamt, ci.ramt,
                   NVL (secureamt, 0) bamt, ci.emkamt, ci.mmarginbal,
                   ci.marginbal, ci.iccfcd, ci.iccftied,
                   ci.odlimit, ci.adintacr, ci.adintdt,
                   ci.facrtrade, ci.facrdepository, ci.facrmisc,
                   ci.minbal, ci.odamt, ci.dueamt, ci.ovamt, ci.namt, ci.floatamt,
                   ci.holdbalance, ci.pendinghold,
                   ci.pendingunhold, ci.corebank, ci.receiving,
                   ci.netting, ci.mblock, l_margintype mrtype,
                   round(
                    decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)) + nvl(balance,0) - nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - NVL (advamt, 0)- nvl(secureamt,0) + advanceline - nvl(trft0amt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) - nvl(ramt,0) - ci.depofeeamt + least(af.mrcrlimitmax +af.mrcrlimit - ci.dfodamt,af.mrcrlimit)
                    ,0) pp,
                   round(
                    decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)) + nvl(balance,0) - nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - NVL (advamt, 0)- nvl(secureamt,0) + advanceline - nvl(trft0amt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) - nvl(ramt,0) - ci.depofeeamt + least(af.mrcrlimitmax + af.mrcrlimit- ci.dfodamt,af.mrcrlimit)
                    ,0) ppref,
                    decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0))
                   + AF.mrcrlimitmax + af.mrcrlimit - dfodamt
                   + af.advanceline - nvl(trft0amt,0)
                   + balance
                   - odamt
                   - dfdebtamt
                   - dfintdebtamt
                   - NVL (overamt, 0)
                   - NVL (secureamt, 0) - nvl(trfsecuredamt,0) - nvl(trft0addamt,0)
                   - ramt
                   - ci.depofeeamt avllimit,
                    decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0))
                   + AF.mrcrlimitmax  + af.mrcrlimit - dfodamt
                   + af.advanceline - nvl(trft0amt,0)
                   + balance
                   - odamt
                   - dfdebtamt
                   - dfintdebtamt
                   - NVL (overamt, 0)
                   - NVL (secureamt, 0) - nvl(trfsecuredamt,0) - nvl(trft0addamt,0)
                   - ramt
                   - ci.depofeeamt avllimitt2,
                   decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)) +
                   AF.mrcrlimitmax + least(af.mrcrlimit,NVL (secureamt, 0)+ nvl(trfsecuredamt,0)+ nvl(trft0addamt,0)) - dfodamt
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
                   0 navaccount, 0 outstanding,
                   0 NAVACCOUNTT2, 0 OUTSTANDINGT2, af.mrirate,
                   GREATEST ( decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)) + balance - trfbuyamt
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
                   --greatest(
                        decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)) + balance - trfbuyamt - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - NVL (overamt, 0) - nvl(secureamt,0) - ramt-nvl(pd.dealpaidamt,0) - ci.depofeeamt
                   --     ,0)
                   BALDEFOVD,
                   --greatest(
                        decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)) + balance - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - ramt-nvl(pd.dealpaidamt,0) - ci.depofeeamt
                                    - greatest(
                                            nvl(trfi.secureamt_inday,0)
                                            + (nvl(trfi.trfbuyamtnofee_inday,0) + nvl(trfbuyamtnofee,0)) * l_TRFBUYRATE
                                            ,
                                            nvl(b.buyamt,0) + nvl(b.buyfeeacr,0) - least(af.trfbuyrate/100* nvl(b.buyamt,0) + case when af.trfbuyrate > 0 then nvl(b.buyfeeacr,0) else 0 end, af.advanceline - nvl(b.trft0amt,0) )
                                            + nvl(b.trfsecuredamt,0)
                                            + nvl(b.trft0amt_over,0))
                   --     ,0)
                        BALDEFTRFAMT,
                   greatest(
                        decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)) + balance - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - ramt-nvl(pd.dealpaidamt,0) - ci.depofeeamt
                                    - greatest(0
                                            ,
                                            nvl(b.buyamt,0) + nvl(b.buyfeeacr,0) - least(af.trfbuyrate/100* nvl(b.buyamt,0) + case when af.trfbuyrate > 0 then nvl(b.buyfeeacr,0) else 0 end, af.advanceline - nvl(b.trft0amt,0) )
                                            + nvl(b.trfsecuredamt,0)
                                            + nvl(b.trft0amt_over,0))
                        ,0) BALDEFTRFAMTEX,

                   GREATEST (  round(least(decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)) + balance - trfbuyamt ,
                                    nvl(adv.avladvance,0) + balance - trfbuyamt  +
                                    af.advanceline -NVL (advamt, 0)-
                                    nvl(secureamt,0)-ramt
                            ),0
                   ) ,0) baldefovd_released,
                   dfdebtamt,
                   dfintdebtamt,
                   GREATEST ( decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)) + balance - trfbuyamt
                             - odamt
                             - dfdebtamt
                             - dfintdebtamt
                             - NVL (advamt, 0)
                             - NVL (secureamt, 0)
                             - ramt
                             - nvl(pd.dealpaidamt,0),
                             0
                            ) baldefovd_released_depofee,  -- Su dung de check khi thu phi luu ky
                   decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)) avladvance, nvl(adv.advanceamount,0) advanceamount, nvl(adv.paidamt,0) paidamt,
                   nvl(b.EXECBUYAMT,0) EXECBUYAMT, nvl(pd.dealpaidamt,0) dealpaidamt, 0 SEASS,0 MARGINRATE,
                   ci.trfbuyamt,
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
              FROM cimast ci INNER JOIN afmast af ON ci.acctno = af.acctno
                   LEFT JOIN (SELECT *
                                FROM v_getbuyorderinfo
                               WHERE afacctno = pv_condvalue) b
                               ON ci.acctno = b.afacctno
                   LEFT JOIN (SELECT *
                                FROM vw_trfbuyinfo_inday
                               WHERE afacctno = pv_condvalue) trfi
                               ON ci.acctno = trfi.afacctno
                   left join
                            (select sum(depoamt) avladvance,afacctno, sum(advamt) advanceamount, sum(paidamt) paidamt
                                from v_getAccountAvlAdvance
                                where afacctno = pv_condvalue group by afacctno) adv
                                on adv.afacctno=ci.acctno
                   LEFT JOIN
                            (select *
                                from v_getdealpaidbyaccount p
                                where p.afacctno = pv_CONDVALUE) pd
                            on pd.afacctno=ci.acctno
                   LEFT JOIN
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
                            )lns
                            on ci.acctno=lns.trfacctno
             WHERE ci.acctno = pv_condvalue;
      ELSIF     l_margintype in  ('S','T')
            AND (LENGTH (l_groupleader) = 0 OR l_groupleader IS NULL)
      THEN
             plog.error('fn_cimastcheck_for_report: l_groupleader ' || l_groupleader || 'begin fn');
            select count(1)
                into l_count
            from afmast af
            where af.acctno = pv_condvalue
            and (exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y')
                or exists (select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y'));

            if l_count > 0 then
                l_isMarginAcc:='Y';
            else
                l_isMarginAcc:='N';
            end if;


            -- Day la tieu khoan gan loai hinh mac dinh la tuan thu.
            select count(1)
                into l_count
            from afmast af
            where af.acctno = pv_condvalue
            and exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y');

            if l_count > 0 then
                l_isChkSysCtrlDefault:='Y';
            else
                l_isChkSysCtrlDefault:='N';
            end if;
         --Tai khoan margin khong tham gia group
         plog.error('begin open cursor');
         OPEN pv_refcursor FOR
                SELECT
                ACTYPE,ACCTNO,CCYCD,AFACCTNO,CUSTID,OPNDATE,CLSDATE,LASTDATE,
                DORMDATE,STATUS,PSTATUS,(ADVANCELINE-trft0amt) ADVANCELINE, BALANCE,AVLBAL,CRAMT,DRAMT,CRINTACR, cidepofeeacr, CRINTDT,ODINTACR,ODINTDT,
                AVRBAL,MDEBIT,MCREDIT,AAMT,RAMT,BAMT,EMKAMT,MMARGINBAL,MARGINBAL,ICCFCD,ICCFTIED,
                ODLIMIT,ADINTACR,ADINTDT,FACRTRADE,FACRDEPOSITORY,FACRMISC,MINBAL,ODAMT,dueamt, ovamt,NAMT,FLOATAMT,
                HOLDBALANCE,PENDINGHOLD,PENDINGUNHOLD,COREBANK,RECEIVING,NETTING,MBLOCK,l_margintype mrtype,PP,PPREF,AVLLIMIT,AVLLIMITT2,AVLMRLIMIT,DEALLIMIT,
                NAVACCOUNT,OUTSTANDING,NAVACCOUNTT2, OUTSTANDINGT2,MRIRATE,
                TRUNC(
                    GREATEST(
                        (CASE WHEN MRIRATE>0 THEN least(NAVACCOUNT*100/MRIRATE + (OUTSTANDING-(ADVANCELINE-trft0amt)),AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE NAVACCOUNT + OUTSTANDING END)
                    ,0) - DEALPAIDAMT
                ,0) AVLWITHDRAW,
                --Neu co bao lanh T0 thi khong duoc rut
                --greatest(
                    case when l_isChkSysCtrlDefault = 'Y' then
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
                    end
                --,0)
                BALDEFOVD,
                --greatest(
                    case when l_isChkSysCtrlDefault = 'Y' then
                        least(
                            (MARGINRATIO/100 - MRIRATIO/100) * (serealass) + greatest(0,balance+nvl(bamt,0)+nvl(avladvance,0)-ovamt-dueamt-depofeeamt)
                            ,
                           TRUNC(
                            (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNTT2 + (OUTSTANDINGT2-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFTRFAMT,AVLLIMITT2-(ADVANCELINE-trft0amt)) ELSE BALDEFTRFAMT END)
                            - DEALPAIDAMT
                        ,0))
                    else
                        TRUNC(
                            (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNTT2 + (OUTSTANDINGT2-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFTRFAMT,AVLLIMITT2-(ADVANCELINE-trft0amt)) ELSE BALDEFTRFAMT END)
                            - DEALPAIDAMT
                        ,0)
                    end
                --,0)
                BALDEFTRFAMT,
                greatest(case when l_isChkSysCtrlDefault = 'Y' then
                    least(
                        (MARGINRATIO/100 - MRIRATIO/100) * (serealass) + greatest(0,balance+nvl(bamt,0)+nvl(avladvance,0)-ovamt-dueamt-depofeeamt)
                        ,
                       TRUNC(
                        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNTT2 + (OUTSTANDINGT2EX-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFTRFAMT,AVLLIMITT2-(ADVANCELINE-trft0amt)) ELSE BALDEFTRFAMT END)
                        - DEALPAIDAMT
                    ,0))
                else
                    TRUNC(
                        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNTT2 + (OUTSTANDINGT2EX-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFTRFAMT,AVLLIMITT2-(ADVANCELINE-trft0amt)) ELSE BALDEFTRFAMT END)
                        - DEALPAIDAMT
                    ,0)
                end,0) BALDEFTRFAMTEX,
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
                avladvance, advanceamount, paidamt, EXECBUYAMT, dealpaidamt, SEASS,0 MARGINRATE,
                trfbuyamt,
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
                        ci.balance-nvl(secureamt,0) balance,
                        ci.balance + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) avlbal,
                        ci.DFDEBTAMT,
                        ci.cramt,ci.dramt,ci.crintacr,ci.crintdt,ci.odintacr,ci.odintdt,ci.avrbal,ci.mdebit,ci.mcredit,ci.aamt,ci.ramt,
                        nvl(secureamt,0) bamt,
                        ci.emkamt,ci.mmarginbal,ci.marginbal,ci.iccfcd,ci.iccftied,ci.odlimit,ci.adintacr,ci.adintdt,
                        ci.facrtrade,ci.facrdepository,ci.facrmisc,ci.minbal,ci.odamt,ci.namt,ci.floatamt,ci.holdbalance,
                        ci.pendinghold,ci.pendingunhold,ci.corebank,ci.receiving,ci.netting,ci.mblock, ci.dfintdebtamt,
                        --greatest(
                             decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance /*- trfbuyamt*/ - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt /*- NVL (overamt, 0) - nvl(secureamt,0)*/ - ramt-nvl(se.dealpaidamt,0) - ci.depofeeamt
                        --     ,0)
                        BALDEFOVD,
                        --greatest(
                             decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - ramt-nvl(se.dealpaidamt,0) - ci.depofeeamt
                                         /*- greatest(0, nvl(se.buyamt,0) + nvl(se.buyfeeacr,0) - least(af.trfbuyrate/100* nvl(se.buyamt,0) + case when af.trfbuyrate > 0 then nvl(se.buyfeeacr,0) else 0 end, af.advanceline - nvl(se.trft0amt,0) )
                                                 + nvl(trfsecuredamt,0)
                                                 + nvl(se.trft0addamt,0))*/
                        --     ,0)
                        baldeftrfamt,
                        greatest(ci.balance - trfbuyamt - nvl(se.secureamt,0) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - af.advanceline,0) BALDEFOVD_RLSODAMT ,
                        greatest(round(least(decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance - trfbuyamt, decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance - trfbuyamt  + af.advanceline -NVL (advamt, 0)-nvl(secureamt,0)-ramt),0) ,0) baldefovd_released,
                        case when l_isChkSysCtrlDefault = 'Y' then
                             least(
                             round(ci.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                                 - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0) +nvl(af.mrcrlimit,0)- dfodamt,nvl(af.mrcrlimit,0) + nvl(se.semramt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt - ci.depofeeamt,0),
                             round(ci.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                                 - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                             )
                        else
                             round(ci.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                                 - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0) +nvl(af.mrcrlimit,0)- dfodamt,nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                        end PP,
                        case when l_isChkSysCtrlDefault = 'Y' then
                             least(
                             round(ci.balance - nvl(se.secureamt,0) - nvl(se.overamt,0)
                                 - ci.trfbuyamt + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0) +nvl(af.mrcrlimit,0)- dfodamt,nvl(af.mrcrlimit,0) + nvl(se.setotalmramt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt - ci.depofeeamt,0),
                             round(ci.balance - nvl(se.secureamt,0) - nvl(se.overamt,0)
                                 - ci.trfbuyamt + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+ nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.setotalamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                             )
                        else
                             round(ci.balance - nvl(se.secureamt,0) - nvl(se.overamt,0)
                                 - ci.trfbuyamt + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.setotalamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                        end PPREF,
                        round(
                            decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + nvl(af.advanceline,0) - nvl(trft0amt,0) - nvl(trfsecuredamt,0) + nvl(se.mrcrlimitmax,0) +nvl(af.mrcrlimit,0)- dfodamt + balance - odamt - ci.dfdebtamt - ci.dfintdebtamt - nvl(secureamt,0) - ramt - ci.depofeeamt
                        ,0) AVLLIMIT,
                        round(
                            decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + nvl(af.advanceline,0) - nvl(trfsecuredamt,0) + nvl(se.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)- dfodamt + balance - odamt - ci.dfdebtamt - ci.dfintdebtamt -nvl(trf.trfsecuredamt_inday,0)-nvl(trf.secureamt_inday,0) - ramt - ci.depofeeamt
                        ,0) AVLLIMITT2,
                        decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + nvl(se.mrcrlimitmax,0)+least(nvl(af.mrcrlimit,0), nvl(secureamt,0))
                        - dfodamt + balance - trfbuyamt - odamt - ci.dfdebtamt - ci.dfintdebtamt  - nvl(secureamt,0) - ramt - ci.depofeeamt  avlmrlimit,
                        greatest(least(nvl(se.mrcrlimitmax,0) - dfodamt,
                                nvl(se.mrcrlimitmax,0) - dfodamt + nvl(af.advanceline,0) -odamt),0) deallimit,
                        least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SETOTALCALLASS,0),nvl(SE.mrcrlimitmax,0) - dfodamt) NAVACCOUNT,
                        least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SEMAXTOTALCALLASS,0),nvl(SE.mrcrlimitmax,0) - dfodamt) NAVACCOUNTT2,
                        -- KHONG TINH MIN VOI ROOM
                        least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SEMAXTOTALCALLASS,0),nvl(SE.mrcrlimitmax,0) - dfodamt) NAVACCOUNTT3,
                        nvl(af.advanceline,0) - nvl(trft0amt,0) + ci.balance +least(nvl(af.mrcrlimit,0),nvl(se.secureamt,0)) - trfbuyamt + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - NVL (se.advamt, 0)-nvl(se.secureamt,0) - ci.ramt OUTSTANDING, --kHI DAT LENH THI THEM PHAN T0
                        least(nvl(af.advanceline,0)  - nvl(trft0amt,0) + ci.balance + least(nvl(af.mrcrlimit,0),nvl(trf.trfsecuredamt_inday,0)+ nvl(se.trfsecuredamt,0) +nvl(trf.secureamt_inday,0)+nvl(se.trft0amt_over,0))
                                  + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - ci.ramt - nvl(se.trft0amt_over,0)
                                    -nvl(trf.trfsecuredamt_inday,0) - nvl(se.trfsecuredamt,0) -nvl(trf.secureamt_inday,0),
                                nvl(af.advanceline,0)  - nvl(trft0amt,0) + ci.balance
                                + least(nvl(af.mrcrlimit,0), nvl(trf.secureamt_inday,0)+(nvl(trf.trfbuyamtnofee_inday,0)+nvl(trfbuyamtnofee,0)) * l_TRFBUYRATE)
                                + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - ci.ramt
                                    -(nvl(trf.trfbuyamtnofee_inday,0)+nvl(trfbuyamtnofee,0)) * l_TRFBUYRATE - nvl(trf.secureamt_inday,0)
                                ) OUTSTANDINGT2,
                        nvl(af.advanceline,0)  - nvl(trft0amt,0) + ci.balance
                        + least(nvl(af.mrcrlimit,0),nvl(trf.trfsecuredamt_inday,0)+ nvl(se.trfsecuredamt,0) +nvl(trf.secureamt_inday,0)+nvl(se.trft0amt_over,0))
                        + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - ci.ramt - nvl(se.trft0amt_over,0)
                                    -nvl(trf.trfsecuredamt_inday,0) - nvl(se.trfsecuredamt,0) -nvl(trf.secureamt_inday,0) OUTSTANDINGT2EX,
                        af.mrirate,nvl(se.dealpaidamt,0) dealpaidamt,
                        se.chksysctrl, nvl(se.trft0amt,0) trft0amt,
                        decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) avladvance, nvl(se.advanceamount,0) advanceamount, nvl(se.paidamt,0) paidamt,
                        nvl(se.EXECBUYAMT,0) EXECBUYAMT, nvl(se.SEASS,0) SEASS, nvl(margin74amt,0) margin74amt, nvl(serealass,0) serealass,
                        af.MRIRATIO, nvl(MARGINRATIO,0) MARGINRATIO, depofeeamt, dueamt, ovamt, ci.trfbuyamt,
                         --PhuongHT edit ngay 29.02.2016
                        nvl(se.trfbuyamt_over,0) trfbuyamt_over, nvl(se.set0amt,0) set0amt,nvl(se.rlsmarginrate_ex,0) rlsmarginrate_ex,
                        nvl(se.NYOVDAMT,0) NYOVDAMT,nvl(se.marginrate_ex,0) marginrate_Ex,
                        nvl(se.semaxtotalcallass,0) semaxtotalcallass,nvl(secallass,0) secallass,
                        nvl(se.navaccount,0) CLAMT,nvl(se.navaccountt2,0) navaccountt2_EX,
                        nvl(se.outstanding,0)+nvl(se.NYOVDAMT,0) outstanding_EX,
                        nvl(se.navaccount,0) navaccount_ex,nvl(se.MARGINRATE5,0) MARGINRATE5,
                        nvl(se.outstanding,0)outstanding5,
                        abs(ci.balance +LEAST(nvl(af.MRCRLIMIT,0), nvl(secureamt,0)+ trfbuyamt) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - trfbuyamt - ci.odamt - nvl(secureamt,0) - ci.ramt) odAMT_EX,
                        nvl(se.outstandingt2,0)+nvl(se.NYOVDAMT,0) outstandingT2_EX,
                        nvl(se.semaxcallass,0) semaxcallass,
                        nvl(trf.secureamt_inday,0) secureamt_inday,
                        nvl(trf.trfsecuredamt_inday,0)trfsecuredamt_inday
                        -- end of PhuongHT edit ngay 29.02.2016
                   from cimast ci inner join afmast af on ci.acctno=af.acctno
                        left join (select * from v_getsecmarginratio where afacctno = pv_CONDVALUE) se on se.afacctno=ci.acctno
                        left join (select * from vw_trfbuyinfo_inday where afacctno = pv_CONDVALUE) trf on trf.afacctno=ci.acctno
                        left join (select TRFACCTNO, nvl(sum(ln.PRINOVD + ln.INTOVDACR + ln.INTNMLOVD + ln.OPRINOVD + ln.OPRINNML + ln.OINTNMLOVD + ln.OINTOVDACR+ln.OINTDUE+ln.OINTNMLACR + nvl(lns.nml,0) + nvl(lns.intdue,0)),0) OVDAMT,
                                                       nvl(sum(ln.PRINNML - nvl(nml,0)+ ln.INTNMLACR),0) NMLMARGINAMT,
                                            nvl(sum(decode(lnt.chksysctrl,'Y',1,0)*(ln.prinnml+ln.prinovd+ln.intnmlacr+ln.intdue+ln.intovdacr+ln.intnmlovd+ln.feeintnmlacr+ln.feeintdue+ln.feeintovdacr+ln.feeintnmlovd)),0) margin74amt
                                        from lnmast ln, lntype lnt, (select acctno, sum(nml) nml, sum(intdue) intdue  from lnschd
                                                            where reftype = 'P' and  overduedate = to_date(fn_get_sysvar_for_report('SYSTEM','CURRDATE'),'DD/MM/RRRR') group by acctno) lns
                                        where ln.actype = lnt.actype and ln.acctno = lns.acctno(+) and ln.ftype = 'AF'
                                        and ln.trfacctno = pv_CONDVALUE
                                        group by ln.trfacctno) OVDAF on OVDAF.TRFACCTNO = ci.acctno
                        left join (select afacctno, sum(amt) receivingamt from stschd where afacctno = pv_CONDVALUE and duetype = 'RM' and status <> 'C' and deltd <> 'Y' group by afacctno) sts_rcv
                                on ci.acctno = sts_rcv.afacctno
                   WHERE ci.acctno = pv_CONDVALUE);
         plog.error('End of open currsor');

      ELSE
         --Tai khoan margin join theo group
         SELECT LEAST(SUM((NVL(AF.MRCRLIMIT,0) + NVL(SE.SEAMT,0)+
                                    NVL(adv.avladvance,0)))
                            ,sum(nvl(adv.avladvance,0)+ greatest(NVL(AF.MRCRLIMITMAX,0)+NVL(AF.MRCRLIMIT,0)- dfodamt,0)))
                       + sum(BALANCE - ODAMT- dfdebtamt- dfintdebtamt - NVL (ADVAMT, 0)-NVL(SECUREAMT,0) -nvl(trfsecuredamt,0)-nvl(TRFT0ADDAMT,0) - RAMT - ci.depofeeamt) PP,
                GREATEST (SUM ( NVL (AF.mrcrlimitmax, 0)+NVL(AF.MRCRLIMIT,0) - dfodamt
                               + balance
                               - odamt
                               - dfdebtamt
                               - dfintdebtamt
                               - NVL (secureamt, 0)
                               - ramt
                               - ci.depofeeamt
                              ),
                          0
                         ) avllimit,
                greatest(least(sum(nvl(AF.mrcrlimitmax,0) - dfodamt),
                        sum(nvl(AF.mrcrlimitmax,0) - dfodamt + nvl(af.advanceline,0) -odamt)),0) deallimit,
                --GREATEST (
                    SUM (nvl(adv.avladvance,0) + balance - trfbuyamt - dfdebtamt
                             - dfintdebtamt- ovamt - dueamt - ramt- ci.depofeeamt)
                --, 0)
                baldefovd,
                greatest(round(least(sum(nvl(adv.avladvance,0) + balance- trfbuyamt ),
                                    sum(nvl(adv.avladvance,0) + balance- trfbuyamt  +
                                    af.advanceline -NVL (advamt, 0)-
                                    nvl(secureamt,0)-ramt)
                            ),0
                   ),0) baldefovd_released,
                SUM (  /*NVL (af.mrcrlimit, 0)
                     +*/ NVL (se.seass, 0)
                    ) navaccount,
                SUM (  ci.balance- trfbuyamt
                     + NVL (adv.avladvance, 0)
                     - ci.odamt
                     - ci.dfdebtamt
                     - ci.dfintdebtamt
                     - NVL (b.secureamt, 0)
                     - ci.ramt
                     + least(nvl(af.mrcrlimit,0),NVL (b.secureamt, 0))
                    ) outstanding,
                SUM (CASE
                        WHEN af.acctno <> pv_condvalue
                           THEN 0
                        ELSE af.mrirate
                     END) mrirate,
                GREATEST (SUM (nvl(adv.avladvance,0) + balance - trfbuyamt - dfdebtamt
                             - dfintdebtamt- ovamt - dueamt - ramt), 0) baldefovd_released_depofee, -- Su dung de check khi thu phi luu ky,
                nvl(adv.avladvance,0) avladvance, nvl(adv.advanceamount,0) advanceamount, nvl(adv.paidamt,0) paidamt,
                nvl(b.EXECBUYAMT,0) EXECBUYAMT
           INTO l_pp,
                l_avllimit,
                l_deallimit,
                l_baldefovd,
                l_baldefovd_Released,
                l_navaccount,
                l_outstanding,
                l_mrirate,
                l_baldefovd_Released_depofee,
                l_avladvance,
                l_advanceamount,
                l_paidamt,
                l_EXECBUYAMT
           FROM cimast ci INNER JOIN afmast af ON ci.acctno = af.acctno
                                          AND af.groupleader = l_groupleader
                LEFT JOIN (SELECT b.*
                             FROM v_getbuyorderinfo b, afmast af
                            WHERE b.afacctno = af.acctno
                              AND af.groupleader = l_groupleader) b ON ci.acctno =
                                                                         b.afacctno
                LEFT JOIN (SELECT b.*
                             FROM v_getsecmargininfo b, afmast af
                            WHERE b.afacctno = af.acctno
                              AND af.groupleader = l_groupleader) se ON se.afacctno =
                                                                          ci.acctno
                left join
                        (select sum(depoamt) avladvance,afacctno, sum(advamt) advanceamount, sum(paidamt) paidamt
                            from v_getAccountAvlAdvance b , afmast af where b.afacctno =af.acctno and af.groupleader=l_groupleader group by afacctno) adv
                        on adv.afacctno=ci.acctno
                ;

         OPEN pv_refcursor FOR
            SELECT ci.actype, ci.acctno, ci.ccycd,
                   ci.afacctno, ci.custid, ci.opndate,
                   ci.clsdate, ci.lastdate, ci.dormdate,
                   ci.status, ci.pstatus,
                   af.advanceline - nvl(trft0amt,0) advanceline,
                   ci.balance  - NVL (secureamt, 0) balance,
                   ci.balance + l_avladvance avlbal,
                   ci.cramt,
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
                   ci.netting, ci.mblock,l_margintype mrtype,
                   greatest(NVL (af.advanceline, 0) + l_pp,0) pp,
                   NVL (af.advanceline, 0) - nvl(trft0amt,0) + l_avllimit avllimit,
                   l_avllimit avlmrlimit,l_deallimit deallimit,
                   l_navaccount navaccount, l_outstanding outstanding,
                   l_mrirate mrirate,
                   TRUNC
                      (GREATEST ((CASE
                                     WHEN l_mrirate > 0
                                        THEN   least(l_navaccount * 100 / l_mrirate
                                             + l_outstanding,l_avllimit)
                                     ELSE l_navaccount + l_outstanding
                                  END
                                 )- nvl(pd.dealpaidamt,0),
                                 0
                                ),
                       0
                      ) avlwithdraw,
                   TRUNC
                      ((CASE
                           WHEN l_mrirate > 0
                              THEN LEAST (GREATEST (  (  100 * l_navaccount
                                                       +   l_outstanding
                                                         * l_mrirate
                                                      )
                                                    / l_mrirate,
                                                    0
                                                   ),
                                          --l_baldefovd,
                                          greatest(balance- trfbuyamt - dfdebtamt-dfintdebtamt - ovamt-dueamt - ramt-af.advanceline,0),
                                          l_avllimit
                                         )
                           ELSE GREATEST (  balance- trfbuyamt
                                          - odamt
                                          - dfdebtamt-dfintdebtamt
                                          - NVL (advamt, 0)
                                          - NVL (secureamt, 0)
                                          - ramt,
                                          0
                                         )
                        END
                       ) - nvl(pd.dealpaidamt,0) - ci.depofeeamt,
                       0
                      ) baldefovd,
                      l_baldefovd_Released baldefovd_Released,
                      dfdebtamt, dfintdebtamt,
                      TRUNC
                      ((CASE
                           WHEN l_mrirate > 0
                              THEN LEAST (GREATEST (  (  100 * l_navaccount
                                                       +   l_outstanding
                                                         * l_mrirate
                                                      )
                                                    / l_mrirate,
                                                    0
                                                   ),
                                          --l_baldefovd,
                                          greatest(balance- trfbuyamt - dfdebtamt-dfintdebtamt - ovamt-dueamt - ramt-af.advanceline,0),
                                          l_avllimit
                                         )
                           ELSE GREATEST (  balance- trfbuyamt
                                          - odamt
                                          - dfdebtamt-dfintdebtamt
                                          - NVL (advamt, 0)
                                          - NVL (secureamt, 0)
                                          - ramt,
                                          0
                                         )
                        END
                       ) - nvl(pd.dealpaidamt,0),
                       0
                      ) baldefovd_Released_depofee, -- Su dung check khi thu phi luu ky
                      l_avladvance avladvance,
                        l_advanceamount advanceamount,
                        l_paidamt paidamt, l_EXECBUYAMT EXECBUYAMT, nvl(pd.dealpaidamt,0) dealpaidamt, nvl(se.SEASS,0) SEASS,0 MARGINRATE,
                         --PhuongHT edit ngay 29.02.2016
                        0 trfbuyamt_over, 0 set0amt,0 rlsmarginrate_ex,
                        0 NYOVDAMT,0 marginrate_Ex,
                        0 semaxtotalcallass,0 secallass,
                        0 CLAMT,0 navaccountt2_EX,
                        0 outstanding_EX,
                        0 navaccount_ex,0 MARGINRATE5,
                        0 outstanding5,0 ODAMT_EX,
                        0  outstandingT2_EX,
                        0 semaxcallass,
                        0 secureamt_inday,
                        0 trfsecuredamt_inday
                        -- end of PhuongHT edit ngay 29.02.2016
              FROM cimast ci INNER JOIN afmast af ON ci.acctno = af.acctno
                   LEFT JOIN (SELECT *
                                FROM v_getbuyorderinfo
                               WHERE afacctno = pv_condvalue) b ON ci.acctno =
                                                                     b.afacctno
                   LEFT JOIN (SELECT *
                                FROM v_getsecmargininfo se
                               WHERE se.afacctno = pv_condvalue) se ON se.afacctno =
                                                                         ci.acctno
                   LEFT JOIN
                              (select *
                                  from v_getdealpaidbyaccount p where p.afacctno = pv_condvalue) pd
                              on pd.afacctno=ci.acctno
             WHERE ci.acctno = pv_condvalue;
      END IF;

      l_i := 0;
      LOOP
         FETCH pv_refcursor
          INTO l_cimastcheck_rectype;

         l_cimastcheck_arrtype (l_i) := l_cimastcheck_rectype;
         EXIT WHEN pv_refcursor%NOTFOUND;
         l_i := l_i + 1;
      END LOOP;
      --close pv_refcursor;
      /*FETCH pv_refcursor
          bulk collect INTO l_cimastcheck_arrtype;
      close pv_refcursor;*/
        plog.error('End of funtion');
      RETURN l_cimastcheck_arrtype;

   EXCEPTION
      WHEN OTHERS
      THEN
        plog.error('get error at End of funtion');
         if pv_refcursor%ISOPEN THEN
            CLOSE pv_refcursor;
         END IF;
         RETURN l_cimastcheck_arrtype;
   END fn_cimastcheck_for_report;
/

