CREATE OR REPLACE PROCEDURE sp_bd_getaccountposition_ol(AFACCTNO IN VARCHAR2)
  IS
  V_AFACCTNO VARCHAR2(10);
  v_margintype char(1);
  v_margindesc VARCHAR2(200);
  v_actype varchar2(4);
  v_groupleader varchar2(10);
  v_aamt number(20,0);
  v_pp number(20,0);
  v_balance number(20,0);
  v_avllimit number(20,0);
  v_total   number(20,0);
  v_isPPUsed    number(20,0);
BEGIN
---------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

    V_AFACCTNO:=AFACCTNO;
    SELECT MR.MRTYPE,af.actype,mst.groupleader,MR.isppused into v_margintype,v_actype,v_groupleader,v_isPPUsed from afmast mst,aftype af, mrtype mr where mst.actype=af.actype and af.mrtype=mr.actype and mst.acctno=V_AFACCTNO;
    SELECT CDCONTENT INTO v_margindesc FROM ALLCODE  WHERE  CDTYPE='SA' AND  CDNAME='MARGINTYPE' AND CDVAL=v_margintype;
      delete ol_account_ci where afacctno=V_AFACCTNO;
if v_margintype='N' or v_margintype='L' then
            --Tai khoan binh thuong khong Margin
                insert into ol_account_ci
                SELECT  V_AFACCTNO AFACCTNO,
                greatest(nvl(adv.avladvance,0) + nvl(af.advanceline,0) + nvl(balance,0)+nvl(af.mrcrlimit,0)- nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - NVL (advamt, 0)-nvl(secureamt,0) - nvl(ramt,0) -  nvl(cimast.cidepofeeacr,0),0) PURCHASINGPOWER,
                nvl(adv.avladvance,0) + nvl(AF.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - nvl(dfodamt,0) +
                nvl(af.advanceline,0) + nvl(balance,0)- nvl(odamt,0) - nvl (overamt, 0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) -nvl(secureamt,0) - nvl(ramt,0) AVLLIMIT,
                greatest(nvl(balance,0)-nvl(b.secureamt,0)-nvl(b.ADVAMT,0),0) CASH_ON_HAND,
                nvl(b.secureamt,0) + nvl(b.ADVAMT,0) ORDERAMT,
                greatest(nvl(b.overamt,0) - nvl(b.ADVAMT,0)-least(nvl(af.mrcrlimit,0),nvl(b.secureamt,0)),0)  OUTSTANDING,
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
                greatest(nvl(adv.avladvance,0) + balance- odamt- dfdebtamt - dfintdebtamt - NVL (advamt, 0)-nvl(secureamt,0) - ramt-nvl(pd.dealpaidamt,0) -  nvl(cimast.cidepofeeacr,0),0) baldefovd,
                 nvl(pd.dealpaidamt,0) dealpaidamt
                from cimast inner join afmast af on cimast.acctno=af.acctno
                left join
                (select * from v_getbuyorderinfo where afacctno = V_AFACCTNO) b
                on  cimast.acctno = b.afacctno
                LEFT JOIN
               (select * from v_getsecmargininfo where afacctno = V_AFACCTNO) SE
               on se.afacctno = cimast.acctno
                LEFT JOIN
                (select sum(depoamt) avladvance, sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno, sum(aamt) aamt from v_getAccountAvlAdvance where afacctno = V_AFACCTNO group by afacctno) adv
                on adv.afacctno=cimast.acctno
                LEFT JOIN
                (select * from v_getdealpaidbyaccount p where p.afacctno = V_AFACCTNO) pd
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
                WHERE cimast.acctno = V_AFACCTNO;
        elsif v_margintype in ('S','T') and (length(v_groupleader)=0 or  v_groupleader is null) then
            --Tai khoan margin khong tham gia group
            Insert into ol_account_ci
                  SELECT
                V_AFACCTNO afacctno,
                greatest(cimast.balance - nvl(secureamt,0) + nvl(adv.avladvance,0) + af.advanceline + least(nvl(af.mrcrlimitmax,0)+nvl(af.mrcrlimit,0),nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(cimast.odamt,0) - cimast.dfdebtamt - cimast.dfintdebtamt - ramt -  nvl(cimast.cidepofeeacr,0),0) PURCHASINGPOWER,
                nvl(adv.avladvance,0) + nvl(af.advanceline,0) + nvl(AF.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)- dfodamt + balance- odamt - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - nvl(secureamt,0) - ramt AVLLIMIT,
                   balance-nvl(b.secureamt,0) CASH_ON_HAND,
                   nvl(b.secureamt,0) ORDERAMT,
                greatest(-(cimast.balance+ least(nvl(af.mrcrlimit,0),nvl(b.secureamt,0)) -nvl(b.secureamt,0) + nvl(adv.avladvance,0) - cimast.odamt - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - NVL (b.advamt, 0) - cimast.ramt),0) OUTSTANDING,
                nvl(af.advanceline,0) ADVANCEDLINE,
                nvl(adv.advanceamount,0) AVLADVANCED,
                nvl(adv.paidamt,0) paidamt,
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
                nvl(adv.aamt,0) ADVANCED_BALANCE,
               /*TRUNC(
                  (CASE WHEN MRIRATE>0  THEN LEAST((100* NAVACCOUNT + OUTSTANDING * MRIRATE)/MRIRATE,
                  BALDEFOVD,AVLLIMIT-advanceline)
                  ELSE BALDEFOVD-advanceline END)
                    -DEALPAIDAMT
                ,0) BALDEFOVD
                af.mrirate,
               nvl(af.MRCRLIMIT,0) +  nvl(se.SEASS,0) + nvl(se.trfass,0)  NAVACCOUNT,
               cimast.balance+ nvl(adv.avladvance,0)- cimast.odamt- cimast.dfdebtamt - cimast.dfintdebtamt - NVL (B.advamt, 0)-nvl(B.secureamt,0) - cimast.ramt OOUSTADING,
               nvl(adv.avladvance,0) + balance- ovamt-dueamt - cimast.dfdebtamt - cimast.dfintdebtamt - ramt-af.advanceline-nvl(DP.dealpaidamt,0) baldefovd,
               Nvl(adv.avladvance,0) + af.advanceline + nvl(af.mrcrlimitmax,0)-cimast.dfodamt + cimast.balance- cimast.odamt                - cimast.dfdebtamt - cimast.dfintdebtamt - nvl (B.overamt, 0)-nvl(B.secureamt,0) - cimast.ramt avllimit,
               NVL(DP.DEALPAIDAMT,0) DEALPAIDAMT,advanceline,*/
                TRUNC(
                  (CASE WHEN af.MRIRATE>0
                  THEN LEAST((100* (/*nvl(af.MRCRLIMIT,0) +*/  nvl(se.SEASS,0))
                  + (cimast.balance+ least(nvl(af.MRCRLIMIT,0),nvl(B.secureamt,0))+nvl(adv.avladvance,0)- cimast.odamt- cimast.dfdebtamt - cimast.dfintdebtamt - NVL (B.advamt, 0)-nvl(B.secureamt,0) - cimast.ramt) * af.MRIRATE)/af.MRIRATE,
                  (nvl(adv.avladvance,0) + balance- ovamt-dueamt - cimast.dfdebtamt - cimast.dfintdebtamt - ramt-af.advanceline-nvl(DP.dealpaidamt,0)),
                  nvl(adv.avladvance,0)  + nvl(af.mrcrlimitmax,0)-cimast.dfodamt + cimast.balance- cimast.odamt- cimast.dfdebtamt - cimast.dfintdebtamt - nvl (B.overamt, 0)-nvl(B.secureamt,0) - cimast.ramt)
                  ELSE
                  nvl(adv.avladvance,0) + balance- ovamt-dueamt - cimast.dfdebtamt - cimast.dfintdebtamt - ramt-af.advanceline-nvl(DP.dealpaidamt,0)-advanceline
                   END)
                    - NVL(DP.DEALPAIDAMT,0) - nvl(cimast.cidepofeeacr,0)
                ,0) BALDEFOVD,
                 nvl(dp.dealpaidamt,0) dealpaidamt
                from cimast inner join afmast af on cimast.acctno=af.acctno
                INNER JOIN aftype aft ON aft.actype = af.actype
                INNER JOIN mrtype mrt ON aft.mrtype = mrt.actype and mrt.mrtype IN ('S','T')
                    LEFT JOIN
                    (select * from v_getbuyorderinfo where afacctno = V_AFACCTNO) b
                    on  cimast.acctno = b.afacctno
                    LEFT JOIN
                    (select * from v_getsecmargininfo SE where se.afacctno = V_AFACCTNO) se
                    on se.afacctno=cimast.acctno
                    LEFT JOIN
                    (select sum(depoamt) avladvance, sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno,sum(aamt) aamt from v_getAccountAvlAdvance where afacctno = V_AFACCTNO group by afacctno) adv
                    on adv.afacctno=cimast.acctno
                    LEFT JOIN
                   (select * from v_getdealpaidbyaccount p where p.afacctno = V_AFACCTNO) DP
                   on dP.afacctno=cimast.acctno
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
                    GROUP BY AFACCTNO) ST                on ST.AFACCTNO=cimast.acctno
                    WHERE cimast.acctno = V_AFACCTNO;
        else
            --Tai khoan margin join theo group
            -- Ducnv sua lai theo inquiryaccount
            Insert into ol_account_ci
             select  V_AFACCTNO afacctno,greatest(AF.ADVANCELINE+ MST.PP,0) PURCHASINGPOWER,
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
                from
                (SELECT V_AFACCTNO afacctno,sum((mst.ramt - mst.aamt)) cipamt, sum(af.tradeline) tradeline ,
                sum(case when mst.acctno=V_AFACCTNO
                 then TRUNC (mst.balance)-nvl(al.secureamt,0)
                 else 0 end)
                 balance,
                                    sum(mst.balance + mst.trfamt) intbalance,sum(mst.DFDEBTAMT)  DFDEBTAMT,
                                    sum(mst.cramt) cramt, sum(mst.dramt) dramt, sum(mst.avrbal) avrbal, sum(mst.mdebit) mdebit, sum(mst.mcredit) mcredit,
                                   sum(mst.crintacr) crintacr, sum(mst.odintacr) odintacr, sum(mst.adintacr) adintacr, sum(mst.minbal) minbal, sum(nvl(adv.aamt,0)) aamt,
                                   sum(mst.ramt) ramt, sum(nvl(al.secureamt,0)) bamt, sum(mst.emkamt) emkamt, sum(mst.odlimit) odlimit, sum(mst.mmarginbal) mmarginbal,
                                   sum(mst.marginbal) marginbal, sum(mst.odamt) odamt, sum(nvl(adv.avladvance,0)) receiving, sum(mst.mblock) mblock,
                                   sum(nvl(adv.advanceamount,0)) apmt,sum(nvl(adv.paidamt,0)) paidamt,
                                   sum(NVL (af.mrcrlimitmax, 0)) ADVLIMIT,
                                   sum(nvl(adv.avladvance,0) + mst.balance - nvl(al.secureamt,0) - mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (al.advamt, 0)) avlwithdraw ,
                                   greatest(SUM(nvl(adv.avladvance,0) + balance- ovamt-dueamt - mst.dfdebtamt - mst.dfintdebtamt- ramt - nvl(mst.cidepofeeacr,0)),0) baldefovd,
                                   least(sum((nvl(af.mrcrlimit,0) + nvl(se.seamt,0)+
                                                nvl(adv.avladvance,0)))
                                        ,sum(nvl(adv.avladvance,0) + greatest(nvl(af.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)-mst.dfodamt,0)))
                                   + sum(mst.balance- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- nvl (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt -  nvl(mst.cidepofeeacr,0)) pp,
                                   sum(nvl(adv.avladvance,0) + nvl(af.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)-mst.dfodamt + mst.balance- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- nvl (al.overamt, 0)-nvl(al.secureamt,0) - mst.ramt) avllimit,
                                   sum(/*nvl(af.MRCRLIMIT,0) +*/  nvl(se.SEASS,0))  NAVACCOUNT,
                                   sum(mst.balance+least(nvl(af.mrcrlimit,0),nvl(al.secureamt,0))+ nvl(adv.avladvance,0)- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- NVL (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt) OUTSTANDING,
                                   sum(case when af.acctno <> v_groupleader then 0 else af.mrirate end) mstmrirate,
                                   sum(mst.cidepofeeacr) cidepofeeacr
                               FROM cimast mst inner join afmast af on af.acctno = mst.afacctno AND af.groupleader=v_groupleader
                                   left join
                                   (select b.* from v_getbuyorderinfo  b, afmast af where b.afacctno =af.acctno and af.groupleader=v_groupleader) al
                                    on mst.acctno = al.afacctno
                                   LEFT JOIN
                                   (select b.* from v_getsecmargininfo b, afmast af where b.afacctno =af.acctno and af.groupleader=v_groupleader) se
                                   on se.afacctno=MST.acctno
                                   LEFT JOIN
                                   (select sum(aamt) aamt,sum(depoamt) avladvance, sum(advamt) advanceamount ,afacctno, sum(paidamt) paidamt from v_getAccountAvlAdvance b, afmast af where b.afacctno =af.acctno and af.groupleader = v_groupleader group by b.afacctno) adv
                                   on adv.afacctno=MST.acctno
                ) MST, afmast af,   cimast ci,
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
                    VW_BD_PENDING_SETTLEMENT ST WHERE( DUETYPE='RM' OR DUETYPE='SM') and Afacctno=V_AFACCTNO
                GROUP BY AFACCTNO) ST,
                (select * from v_getdealpaidbyaccount p where p.afacctno = V_AFACCTNO) dp
                where mst.afacctno =af.acctno
                and mst.afacctno=ci.afacctno
                and mst.afacctno=st.afacctno(+)
                and mst.afacctno=dp.afacctno(+);

            /*SELECT
                LEAST(SUM((NVL(AF.MRCRLIMIT,0) + NVL(SE.SEAMT,0)+
                                    NVL(SE.RECEIVINGAMT,0)) + nvl(se.trfamt,0))
                            ,sum(nvl(adv.avladvance,0) +greatest(NVL(AF.MRCRLIMITMAX,0)-dfodamt,0)))
                       + sum(BALANCE- ODAMT - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - NVL (ADVAMT, 0)-NVL(SECUREAMT,0) - RAMT) PURCHASINGPOWER,
                greatest(sum(nvl(adv.avladvance,0) + nvl(AF.mrcrlimitmax,0)- dfodamt + balance- odamt - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - nvl(secureamt,0) - ramt),0) AVLLIMIT,
                   sum(BALANCE-nvl(b.secureamt,0)) CASH_ON_HAND,
                   sum(nvl(b.secureamt,0)) ORDERAMT,
                greatest(-sum(cimast.balance+ nvl(se.receivingamt,0)- cimast.odamt - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - NVL (b.advamt, 0)-nvl(b.secureamt,0) - cimast.ramt),0) OUTSTANDING,
                sum(nvl(af.advanceline,0)) ADVANCEDLINE,
                --sum(nvl(adv.avladvance,0)) AVLADVANCED,
                sum(nvl(adv.advanceamount,0)) AVLADVANCED,
                sum(nvl(adv.paidamt,0)) paidamt,
                sum(nvl(AF.mrcrlimitmax,0)) MRCRLIMITMAX,
                --sum(nvl(af.advanceline,0) + nvl(AF.mrcrlimitmax,0) + balance- odamt - nvl(secureamt,0) - ramt) avllimit,
                sum(nvl(CASH_RECEIVING_T0,0)) CASH_RECEIVING_T0,
                sum(nvl(CASH_RECEIVING_T1,0)) CASH_RECEIVING_T1,
                sum(nvl(CASH_RECEIVING_T2,0)) CASH_RECEIVING_T2,
                sum(nvl(CASH_RECEIVING_T3,0)) CASH_RECEIVING_T3,
                sum(nvl(CASH_RECEIVING_TN,0)) CASH_RECEIVING_TN,
                sum(nvl(CASH_SENDING_T0,0)) CASH_SENDING_T0,
                sum(nvl(CASH_SENDING_T1,0)) CASH_SENDING_T1,
                sum(nvl(CASH_SENDING_T2,0)) CASH_SENDING_T2,
                sum(nvl(CASH_SENDING_T3,0)) CASH_SENDING_T3,
                sum(nvl(CASH_SENDING_TN,0)) CASH_SENDING_TN,
                -- ducnv them tong no, so tien da ung truoc
                sum(nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0)) totaldeb,
                sum(nvl(adv.aamt,0)) ADVANCED_BALANCE,
                sum(greatest(nvl(adv.advanceamount,0) + balance- odamt- dfdebtamt - dfintdebtamt - NVL (advamt, 0)-nvl(secureamt,0) - ramt,0))                baldefovd
               from cimast inner join afmast af on cimast.acctno=af.acctno and af.groupleader=v_groupleader
               left join
                (select b.* from v_getbuyorderinfo  b, afmast af where b.afacctno =af.acctno and af.groupleader=v_groupleader) b
                on  cimast.acctno = b.afacctno
                LEFT JOIN
                (select b.* from v_getsecmargininfo b, afmast af where b.afacctno =af.acctno and af.groupleader=v_groupleader) se
                on se.afacctno=cimast.acctno
                LEFT JOIN
                (select sum(aamt) aamt,sum(depoamt) avladvance, sum(advamt) advanceamount, sum(paidamt) paidamt,afacctno from V_DAYADVANCESCHEDULE b, afmast af where b.afacctno =af.acctno and af.groupleader=v_groupleader group by b.afacctno) adv
                on adv.afacctno=cimast.acctno
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
                on ST.AFACCTNO=cimast.acctno;*/
        end if;
EXCEPTION
    WHEN others THEN
        return;
END;
/

