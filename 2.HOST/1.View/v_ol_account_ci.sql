CREATE OR REPLACE FORCE VIEW V_OL_ACCOUNT_CI AS
SELECT cimast.ACCTNO AFACCTNO,
                greatest(nvl(adv.avladvance,0) + nvl(af.advanceline,0) + nvl(balance,0)+NVL(af.mrcrlimit,0)- nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - NVL (advamt, 0)-nvl(secureamt,0) - nvl(ramt,0),0) PURCHASINGPOWER,
                nvl(adv.avladvance,0) + nvl(AF.mrcrlimitmax,0)+NVL(af.mrcrlimit,0) - nvl(dfodamt,0) +
                nvl(af.advanceline,0) + nvl(balance,0)- nvl(odamt,0) - nvl (overamt, 0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) -nvl(secureamt,0) - nvl(ramt,0) AVLLIMIT,
                greatest(nvl(balance,0)-nvl(b.secureamt,0)-nvl(b.ADVAMT,0),0) CASH_ON_HAND,
                nvl(b.secureamt,0) + nvl(b.ADVAMT,0) ORDERAMT,
                greatest(nvl(b.overamt,0) - nvl(b.ADVAMT,0),0)  OUTSTANDING,
                --greatest(- cimast.balance- nvl(adv.avladvance,0) +  cimast.odamt + NVL (b.advamt, 0)+ nvl(b.secureamt,0) + cimast.ramt,0)+ nvl(b.overamt,0)  OUTSTANDING,
                af.advanceline ADVANCEDLINE,
                --nvl(adv.avladvance,0) AVLADVANCED,
                nvl(adv.advanceamount,0) AVLADVANCED,
                nvl(adv.paidamt,0) paidamt,
                AF.mrcrlimitmax MRCRLIMITMAX,
                nvl(CASH_RECEIVING_T0,0) CASH_RECEIVING_T0,
                nvl(CASH_RECEIVING_T1,0) CASH_RECEIVING_T1,
                nvl(CASH_RECEIVING_T2,0) CASH_RECEIVING_T2,
                nvl(CASH_RECEIVING_T3,0) CASH_RECEIVING_T3,
                nvl(CASH_RECEIVING_TN,0) CASH_RECEIVING_TN,
                nvl(CASH_SENDING_T0,0) CASH_SENDING_T0,
                nvl(CASH_SENDING_T1,0) CASH_SENDING_T1,
                nvl(CASH_SENDING_T2,0) CASH_SENDING_T2,
                nvl(CASH_SENDING_T3,0) CASH_SENDING_T3,
                nvl(CASH_SENDING_TN,0) CASH_SENDING_TN,
                -- ducnv them tong no, so tien da ung truoc, so tien co the rut
                nvl(cimast.odamt,0) - nvl(cimast.dfdebtamt,0) - nvl(cimast.dfintdebtamt,0) totaldeb,
                nvl(adv.aamt,0) ADVANCED_BALANCE,
                greatest(nvl(adv.avladvance,0) + balance- odamt- dfdebtamt - dfintdebtamt - NVL (advamt, 0)-nvl(secureamt,0) - ramt-nvl(pd.dealpaidamt,0),0) baldefovd,
                 nvl(pd.dealpaidamt,0) dealpaidamt
                from cimast
                --tk thuong ko margin
                inner join (select mst.* from afmast mst,aftype af, mrtype mr
                            where mst.actype=af.actype and af.mrtype=mr.actype
                                  and mr.MRTYPE in ('N','L')) af
                 on cimast.acctno=af.acctno
                left join
                (select * from v_getbuyorderinfo ) b
                on  cimast.acctno = b.afacctno
                LEFT JOIN
               (select * from v_getsecmargininfo) SE
               on se.afacctno = cimast.acctno
                LEFT JOIN
                (select sum(depoamt) avladvance, sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno, sum(aamt) aamt from v_getAccountAvlAdvance
               group by afacctno) adv
                on adv.afacctno=cimast.acctno
                LEFT JOIN
                (select * from v_getdealpaidbyaccount p ) pd
                on pd.afacctno=cimast.acctno
                LEFT JOIN
                (SELECT AFACCTNO,
                        SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=0 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_RECEIVING_T0,
                        SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=1 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_RECEIVING_T1,
                        SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=2 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_RECEIVING_T2,
                        SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_RECEIVING_T3,
                        SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY>3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_RECEIVING_TN,
                        SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=0 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_SENDING_T0,
                        SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=1 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_SENDING_T1,
                        SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=2 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_SENDING_T2,
                        SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_SENDING_T3,
                        SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY>3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_SENDING_TN
                FROM
                    VW_BD_PENDING_SETTLEMENT ST WHERE DUETYPE='RM' OR DUETYPE='SM'
                GROUP BY AFACCTNO) ST
                on ST.AFACCTNO=cimast.acctno
union all
---- Margin ko theo group
 SELECT
         cimast.ACCTNO AFACCTNO,
          --greatest(cimast.balance - nvl(secureamt,0) + nvl(adv.avladvance,0) + af.advanceline + least(nvl(af.mrcrlimitmax,0),nvl(af.mrcrlimit,0) + nvl(se.seamt,0)+nvl(se.trfamt,0)) - nvl(cimast.odamt,0) - cimast.dfdebtamt - cimast.dfintdebtamt - ramt,0) PURCHASINGPOWER,
          case when chksysctrl = 'Y' then
                greatest(cimast.balance - nvl(secureamt,0) + nvl(se.avladvance,0) + af.advanceline + least(nvl(se.mrcrlimitmax,0)+nvl(af.mrcrlimit,0),nvl(af.mrcrlimit,0) + nvl(se.semramt,0)) - nvl(cimast.odamt,0) - cimast.dfdebtamt - cimast.dfintdebtamt - ramt - cimast.cidepofeeacr,0)
          else
                greatest(cimast.balance - nvl(secureamt,0) + nvl(se.avladvance,0) + af.advanceline + least(nvl(se.mrcrlimitmax,0)+nvl(af.mrcrlimit,0),nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(cimast.odamt,0) - cimast.dfdebtamt - cimast.dfintdebtamt - ramt  - cimast.cidepofeeacr,0)
          end PURCHASINGPOWER,
                nvl(se.avladvance,0) + nvl(af.advanceline,0) + nvl(AF.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)- dfodamt + balance- odamt - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - nvl(secureamt,0) - ramt AVLLIMIT,
                   balance-nvl(se.secureamt,0) CASH_ON_HAND,
                   nvl(se.secureamt,0) ORDERAMT,
                greatest(-(cimast.balance +LEAST(nvl(af.mrcrlimit,0),nvl(se.secureamt,0))-nvl(se.secureamt,0) + nvl(se.avladvance,0) - cimast.odamt - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - NVL (se.advamt, 0) - cimast.ramt),0) OUTSTANDING,
                nvl(af.advanceline,0) ADVANCEDLINE,
                nvl(se.advanceamount,0) AVLADVANCED,
                nvl(se.paidamt,0) paidamt,
                nvl(AF.mrcrlimitmax,0) MRCRLIMITMAX,
                nvl(CASH_RECEIVING_T0,0) CASH_RECEIVING_T0,
                nvl(CASH_RECEIVING_T1,0) CASH_RECEIVING_T1,
                nvl(CASH_RECEIVING_T2,0) CASH_RECEIVING_T2,
                nvl(CASH_RECEIVING_T3,0) CASH_RECEIVING_T3,
                nvl(CASH_RECEIVING_TN,0) CASH_RECEIVING_TN,
                nvl(CASH_SENDING_T0,0) CASH_SENDING_T0,
                nvl(CASH_SENDING_T1,0) CASH_SENDING_T1,
                nvl(CASH_SENDING_T2,0) CASH_SENDING_T2,
                nvl(CASH_SENDING_T3,0) CASH_SENDING_T3,
                nvl(CASH_SENDING_TN,0) CASH_SENDING_TN,
                -- ducnv them tong no, so tien da ung truoc, SO TIEN DC RUT
                nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) totaldeb,
                nvl(se.aamt,0) ADVANCED_BALANCE,
                /*
                TRUNC(
                  (CASE WHEN af.MRIRATE>0
                  THEN LEAST((100* (nvl(af.MRCRLIMIT,0) +  nvl(se.SEASS,0) + nvl(se.trfass,0))
                  + (cimast.balance+ nvl(adv.avladvance,0)- cimast.odamt- cimast.dfdebtamt - cimast.dfintdebtamt - NVL (B.advamt, 0)-nvl(B.secureamt,0) - cimast.ramt) * af.MRIRATE)/af.MRIRATE,
                  (nvl(adv.avladvance,0) + balance- ovamt-dueamt - cimast.dfdebtamt - cimast.dfintdebtamt - ramt-af.advanceline-nvl(DP.dealpaidamt,0)),
                  nvl(adv.avladvance,0)  + nvl(af.mrcrlimitmax,0)-cimast.dfodamt + cimast.balance- cimast.odamt- cimast.dfdebtamt - cimast.dfintdebtamt - nvl (B.overamt, 0)-nvl(B.secureamt,0) - cimast.ramt)
                  ELSE
                  nvl(adv.avladvance,0) + balance- ovamt-dueamt - cimast.dfdebtamt - cimast.dfintdebtamt - ramt-af.advanceline-nvl(DP.dealpaidamt,0)-advanceline
                   END)
                    - NVL(DP.DEALPAIDAMT,0)
                ,0) BALDEFOVD,
                */
                greatest(case when chksysctrl = 'Y' then
                            least(  trunc(greatest(least(
                                         nvl(nvl(se.avladvance,0) + balance - cimast.ovamt - cimast.dueamt - ramt - dfdebtamt - dfintdebtamt - nvl(se.dealpaidamt,0),0)
                                                - greatest(nvl(se.overamt,0) + nvl(se.secureamt,0) + nvl(OVDAF.MARGINAMT,0) - se.semrass,0),
                                            case when odamt > 0 then (se.MARGINRATIO - se.MRIRATIO/100) * (se.serealass) + greatest(0,se.outstanding)
                                            else nvl(nvl(se.avladvance,0) + balance - cimast.ovamt - cimast.dueamt - ramt - dfdebtamt - dfintdebtamt - nvl(se.dealpaidamt,0),0)
                                                        - greatest(nvl(se.overamt,0) + nvl(se.secureamt,0) + nvl(OVDAF.MARGINAMT,0) - se.semrass,0)
                                        end,
                                        se.avlmrlimit - af.advanceline
                                       ),0),0) ,
                                    TRUNC((CASE WHEN af.MRIRATE>0  THEN LEAST((100* NAVACCOUNT + OUTSTANDING * af.MRIRATE)/af.MRIRATE,
                                    nvl(cimast.balance + nvl(se.avladvance,0) - cimast.ovamt - cimast.dueamt - cimast.dfdebtamt - cimast.dfintdebtamt
                                        - greatest(nvl(se.overamt,0) + nvl(se.secureamt,0) + nvl(OVDAF.MARGINAMT,0) - se.seass,0),0)
                                    ,se.avlmrlimit-advanceline) ELSE
                                        nvl(cimast.balance + nvl(se.avladvance,0) - cimast.ovamt - cimast.dueamt - cimast.dfdebtamt - cimast.dfintdebtamt
                                            - greatest(nvl(se.overamt,0) + nvl(se.secureamt,0) + nvl(OVDAF.MARGINAMT,0) - se.seass,0),0)-advanceline END)
                                        -DEALPAIDAMT
                                    ,0))
                        else
                           TRUNC((CASE WHEN af.MRIRATE>0  THEN LEAST((100* NAVACCOUNT + OUTSTANDING * af.MRIRATE)/af.MRIRATE,
                                    nvl(cimast.balance + nvl(se.avladvance,0) - cimast.ovamt - cimast.dueamt - cimast.dfdebtamt - cimast.dfintdebtamt
                                        - greatest(nvl(se.overamt,0) + nvl(se.secureamt,0) + nvl(OVDAF.MARGINAMT,0) - se.seass,0),0)
                                    ,se.avlmrlimit-advanceline) ELSE
                                        nvl(cimast.balance + nvl(se.avladvance,0) - cimast.ovamt - cimast.dueamt - cimast.dfdebtamt - cimast.dfintdebtamt
                                            - greatest(nvl(se.overamt,0) + nvl(se.secureamt,0) + nvl(OVDAF.MARGINAMT,0) - se.seass,0),0)-advanceline END)
                                        -DEALPAIDAMT
                                    ,0)
                        end,0) baldefovd,
                 nvl(se.dealpaidamt,0) dealpaidamt
                from cimast inner join afmast af on cimast.acctno=af.acctno
                    INNER JOIN aftype aft ON aft.actype = af.actype
                    INNER JOIN mrtype mrt ON aft.mrtype = mrt.actype and mrt.mrtype IN ('S','T')
                    LEFT JOIN (select * from v_getsecmarginratio) se on se.afacctno=cimast.acctno
                    LEFT JOIN
                    (SELECT AFACCTNO,
                            SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=0 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_RECEIVING_T0,
                            SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=1 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_RECEIVING_T1,
                            SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=2 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_RECEIVING_T2,
                            SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_RECEIVING_T3,
                            SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY>3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_RECEIVING_TN,
                            SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=0 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_SENDING_T0,
                            SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=1 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_SENDING_T1,
                            SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=2 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_SENDING_T2,
                            SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_SENDING_T3,
                            SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY>3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_SENDING_TN
                    FROM
                        VW_BD_PENDING_SETTLEMENT ST WHERE DUETYPE='RM' OR DUETYPE='SM'
                    GROUP BY AFACCTNO) ST      on ST.AFACCTNO=cimast.acctno
                    LEFT JOIN (select TRFACCTNO, nvl(sum(ln.PRINOVD + ln.INTOVDACR + ln.INTNMLOVD + ln.OPRINOVD + ln.OPRINNML + ln.OINTNMLOVD + ln.OINTOVDACR+ln.OINTDUE+ln.OINTNMLACR + nvl(lns.nml,0) + nvl(lns.intdue,0)),0) OVDAMT,
                                       nvl(sum(ln.PRINNML + ln.PRINOVD + ln.INTOVDACR + ln.INTNMLOVD + ln.INTNMLACR + ln.INTDUE),0) MARGINAMT
                                    from lnmast ln, (select acctno, sum(nml) nml, sum(intdue) intdue  from lnschd
                                                        where reftype = 'P' and  overduedate = to_date(cspks_system.fn_get_sysvar('SYSTEM','CURRDATE'),'DD/MM/RRRR') group by acctno) lns
                                    where ln.acctno = lns.acctno(+) and ln.ftype = 'AF'
                                    group by ln.trfacctno) OVDAF on OVDAF.TRFACCTNO = cimast.acctno

--margin   theo group
union all

            select af.acctno AFACCTNO,greatest(AF.ADVANCELINE+ MST.PP,0) PURCHASINGPOWER,
                AF.ADVANCELINE+ MST.AVLLIMIT AVLLIMIT,
                MST.BALANCE CASH_ON_HAND,
                MST.BAMT ORDERAMT,
                greatest(-(AF.ADVANCELINE+ MST.OUTSTANDING),0) OUTSTANDING,-- check lai No trong ngay
                AF.ADVANCELINE ADVANCEDLINE,
                MST.APMT AVLADVANCED,
                MST.PAIDAMT PAIDAMT,
                MST.ADVLIMIT MRCRLIMITMAX,
                nvl(CASH_RECEIVING_T0,0) CASH_RECEIVING_T0,
                nvl(CASH_RECEIVING_T1,0) CASH_RECEIVING_T1,
                nvl(CASH_RECEIVING_T2,0) CASH_RECEIVING_T2,
                nvl(CASH_RECEIVING_T3,0) CASH_RECEIVING_T3,
                nvl(CASH_RECEIVING_TN,0) CASH_RECEIVING_TN,
                nvl(CASH_SENDING_T0,0) CASH_SENDING_T0,
                nvl(CASH_SENDING_T1,0) CASH_SENDING_T1,
                nvl(CASH_SENDING_T2,0)  CASH_SENDING_T2,
                nvl(CASH_SENDING_T3,0) CASH_SENDING_T3,
                nvl(CASH_SENDING_TN,0) CASH_SENDING_TN,
                nvl(ci.odamt,0) - nvl(ci.dfdebtamt,0) - nvl(ci.dfintdebtamt,0) totaldeb,
                MST.AAMT ADVANCED_BALANCE,
                TRUNC((CASE WHEN mst.mstmrirate>0
                                THEN GREATEST(LEAST((100* NAVACCOUNT + OUTSTANDING * mst.mstmrirate)/mst.mstmrirate,
                                            --BALDEFOVD,
                                            ci.balance- ci.ovamt-ci.dueamt - ci.ramt-af.advanceline,
                                            AVLLIMIT),0)
                                 ELSE BALDEFOVD END),0) BALDEFOVD,
                nvl(dp.dealpaidamt,0) dealpaidamt
        From
          (SELECT gl.acctno afacctno,
               sum(case when mst.acctno=gl.acctno--'0001000193'
                 then TRUNC (mst.balance)-nvl(al.secureamt,0)
                 else 0 end)   balance,
          sum(nvl(adv.aamt,0)) aamt,
          sum(nvl(al.secureamt,0)) bamt,
          sum(nvl(adv.advanceamount,0)) apmt,        sum(nvl(adv.paidamt,0)) paidamt,
          sum(NVL (af.mrcrlimitmax, 0)) ADVLIMIT,
          sum(nvl(adv.avladvance,0) + mst.balance - nvl(al.secureamt,0) - mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (al.advamt, 0)) avlwithdraw ,
          greatest(SUM(nvl(adv.avladvance,0) + balance- ovamt-dueamt - mst.dfdebtamt - mst.dfintdebtamt- ramt),0) baldefovd,
          least(sum((nvl(af.mrcrlimit,0) + nvl(se.seamt,0)+
                       nvl(adv.avladvance,0)))
               ,sum(nvl(adv.avladvance,0) + greatest(nvl(af.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)-mst.dfodamt,0)))
          + sum(mst.balance- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- nvl (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt) pp,
          sum(nvl(adv.avladvance,0) + nvl(af.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)-mst.dfodamt + mst.balance- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- nvl (al.overamt, 0)-nvl(al.secureamt,0) - mst.ramt) avllimit,
          -- sum(nvl(af.MRCRLIMIT,0) +  nvl(se.SEASS,0)  + nvl(se.trfass,0))  NAVACCOUNT,
          sum(/*nvl(af.MRCRLIMIT,0) +*/  nvl(se.SEASS,0))  NAVACCOUNT,
          sum(mst.balance+LEAST(nvl(af.mrcrlimit,0),nvl(al.secureamt,0))+ nvl(adv.avladvance,0)- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- NVL (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt) OUTSTANDING,
          sum(case when af.acctno <> gl.groupleader--'0001000192'
          then 0 else af.mrirate end) mstmrirate,
          sum(mst.cidepofeeacr) cidepofeeacr
      FROM cimast mst , afmast af,
          v_getbuyorderinfo  al ,
          v_getsecmargininfo se ,
          (select sum(aamt) aamt,sum(depoamt) avladvance,
          sum(advamt) advanceamount ,afacctno, sum(paidamt) paidamt
          from v_getAccountAvlAdvance b
          group by b.afacctno) adv,
          (select acctno,groupleader from afmast where length(groupleader)=10 )GL
      where Gl.acctno=af.acctno
            and af.acctno = mst.afacctno
            AND af.groupleader=gl.groupleader--'0001000192'
            and  mst.acctno = al.afacctno(+)
            and MST.acctno =se.afacctno(+)
            and  MST.acctno = adv.afacctno (+)
      group by gl.acctno
          ) MST,
          afmast af,   cimast ci,
         (SELECT AFACCTNO,
                        SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=0 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_RECEIVING_T0,
                        SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=1 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_RECEIVING_T1,
                        SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=2 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_RECEIVING_T2,
                        SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY=3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_RECEIVING_T3,
                        SUM(NVL(CASE WHEN ST.DUETYPE='RM' AND ST.TDAY>3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_RECEIVING_TN,
                        SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=0 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_SENDING_T0,
                        SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=1 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_SENDING_T1,
                        SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=2 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_SENDING_T2,
                        SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY=3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_SENDING_T3,
                        SUM(NVL(CASE WHEN ST.DUETYPE='SM' AND ST.TDAY>3 THEN ST.ST_AMT-ST.ST_AAMT-ST.ST_FAMT ELSE 0 END,0)) CASH_SENDING_TN
                FROM
                    VW_BD_PENDING_SETTLEMENT ST WHERE( DUETYPE='RM' OR DUETYPE='SM')
           GROUP BY AFACCTNO) ST,
          (select * from v_getdealpaidbyaccount p ) dp
          where length(af.groupleader)=10 and af.groupleader is not null
          and  mst.afacctno =af.acctno
          and mst.afacctno=ci.afacctno
          and mst.afacctno=st.afacctno(+)
          and mst.afacctno=dp.afacctno(+)
;

