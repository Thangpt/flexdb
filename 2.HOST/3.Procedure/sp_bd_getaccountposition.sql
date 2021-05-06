CREATE OR REPLACE PROCEDURE sp_bd_getaccountposition (PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,AFACCTNO IN VARCHAR2)
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
  l_isChkSysCtrlDefault varchar2(1);
  l_isMarginAcc varchar2(1);
  l_count number;
BEGIN
---------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
    V_AFACCTNO:=AFACCTNO;
    SELECT MR.MRTYPE,af.actype,mst.groupleader,MR.isppused into v_margintype,v_actype,v_groupleader,v_isPPUsed from afmast mst,aftype af, mrtype mr where mst.actype=af.actype and af.mrtype=mr.actype and mst.acctno=V_AFACCTNO;
    SELECT CDCONTENT INTO v_margindesc FROM ALLCODE  WHERE  CDTYPE='SA' AND  CDNAME='MARGINTYPE' AND CDVAL=v_margintype;

    if v_margintype='N' or v_margintype='L' then
            --Tai khoan binh thuong khong Margin
            OPEN PV_REFCURSOR FOR
                SELECT --V_AFACCTNO AFACCTNO,
                round(
                    nvl(adv.avladvance,0) + nvl(balance,0) - nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - NVL (advamt, 0)- nvl(secureamt,0) + advanceline - nvl(trft0amt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) - nvl(ramt,0) - ci.depofeeamt + least(af.mrcrlimitmax +af.mrcrlimit- ci.dfodamt,af.mrcrlimit)
                    ,0) PURCHASINGPOWER,
                round(
                    nvl(adv.avladvance,0) + nvl(balance,0)- nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0)  - nvl (overamt,0) -nvl(secureamt,0) + nvl(af.advanceline,0) - nvl(trft0amt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) - nvl(ramt,0) - nvl(depofeeamt,0) + AF.mrcrlimitmax+af.mrcrlimit - dfodamt
                    ,0) AVLLIMIT,
                greatest(nvl(balance,0)-nvl(b.secureamt,0)-nvl(b.ADVAMT,0),0) CASH_ON_HAND,
                nvl(b.secureamt,0) + nvl(b.ADVAMT,0) ORDERAMT,
                greatest(nvl(b.overamt,0) - nvl(b.ADVAMT,0)-least(af.mrcrlimit,nvl(secureamt,0)),0)  OUTSTANDING,
                af.advanceline ADVANCEDLINE,
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
                nvl(ci.odamt,0) - nvl(ci.dfdebtamt,0) - nvl(ci.dfintdebtamt,0) totaldeb,
                nvl(adv.aamt,0) ADVANCED_BALANCE,
                getbaldefovd(ci.acctno) baldefovd,
                nvl(pd.dealpaidamt,0) dealpaidamt
                from cimast ci inner join afmast af on ci.acctno=af.acctno
                left join
                (select * from v_getbuyorderinfo where afacctno = V_AFACCTNO) b
                on  ci.acctno = b.afacctno
                LEFT JOIN
                (select sum(depoamt) avladvance, sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno, sum(aamt) aamt from v_getAccountAvlAdvance where afacctno = V_AFACCTNO group by afacctno) adv
                on adv.afacctno=ci.acctno
                LEFT JOIN
                (select * from v_getdealpaidbyaccount p where p.afacctno = V_AFACCTNO) pd
                on pd.afacctno=ci.acctno
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
                on ST.AFACCTNO=ci.acctno
                WHERE ci.acctno = V_AFACCTNO;
        elsif v_margintype in ('S','T') and (length(v_groupleader)=0 or  v_groupleader is null) then
            select count(1)
                into l_count
            from afmast af
            where af.acctno = V_AFACCTNO
            and (exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y')
                or exists (select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y'));

            if l_count > 0 then
                l_isMarginAcc:='Y';
            else
                l_isMarginAcc:='N';
            end if;

            select count(1)
                into l_count
            from afmast af
            where af.acctno = V_AFACCTNO
            and exists (select 1 from aftype aft, lntype lnt where to_char(aft.actype) = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y');

            if l_count > 0 then
                l_isChkSysCtrlDefault:='Y';
            else
                l_isChkSysCtrlDefault:='N';
            end if;
            --Tai khoan margin khong tham gia group
            OPEN PV_REFCURSOR FOR

            SELECT
                case when l_isChkSysCtrlDefault = 'Y' then
                    least(
                    round(cimast.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                        - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + nvl(se.avladvance,0) + least(nvl(se.mrcrlimitmax,0)+ nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.semramt,0)) - nvl(cimast.odamt,0) - cimast.dfdebtamt - cimast.dfintdebtamt - ramt - cimast.depofeeamt,0),
                    round(cimast.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                        - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + nvl(se.avladvance,0) + least(nvl(se.mrcrlimitmax,0)+ nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(cimast.odamt,0) - cimast.dfdebtamt - cimast.dfintdebtamt - ramt  - cimast.depofeeamt,0)
                    )
                else
                    round(cimast.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                        - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + nvl(se.avladvance,0) + least(nvl(se.mrcrlimitmax,0)+ nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(cimast.odamt,0) - cimast.dfdebtamt - cimast.dfintdebtamt - ramt  - cimast.depofeeamt,0)
                end PURCHASINGPOWER,
                round(
                    nvl(se.avladvance,0) + nvl(af.advanceline,0) - nvl(trft0amt,0) + nvl(AF.mrcrlimitmax,0)+ nvl(af.mrcrlimit,0)- dfodamt + balance- odamt - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - nvl(secureamt,0) - ramt - nvl(depofeeamt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0)
                    ,0) AVLLIMIT,
                balance-nvl(se.secureamt,0) CASH_ON_HAND,
                nvl(se.secureamt,0) ORDERAMT,
                greatest(-(greatest(cimast.balance + nvl(se.avladvance,0) - cimast.odamt - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - NVL (se.advamt, 0) - cimast.ramt,0) -nvl(se.secureamt,0) ),0) OUTSTANDING,
                nvl(af.advanceline,0) ADVANCEDLINE,
                nvl(se.advanceamount,0) AVLADVANCED,
                nvl(se.paidamt,0) paidamt,
                nvl(se.mrcrlimitmax,0) MRCRLIMITMAX,
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
                getbaldefovd(cimast.acctno) baldefovd,
                nvl(se.dealpaidamt,0) dealpaidamt
                from cimast inner join afmast af on cimast.acctno=af.acctno
                INNER JOIN aftype aft ON aft.actype = af.actype
                INNER JOIN mrtype mrt ON aft.mrtype = mrt.actype and mrt.mrtype IN ('S','T')
                LEFT JOIN (select * from v_getsecmarginratio where afacctno = V_AFACCTNO) se on se.afacctno=cimast.acctno
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
                    GROUP BY AFACCTNO) ST on ST.AFACCTNO=cimast.acctno
                   left join (select TRFACCTNO, nvl(sum(ln.PRINOVD + ln.INTOVDACR + ln.INTNMLOVD + ln.OPRINOVD + ln.OPRINNML + ln.OINTNMLOVD + ln.OINTOVDACR+ln.OINTDUE+ln.OINTNMLACR + nvl(lns.nml,0) + nvl(lns.intdue,0)),0) OVDAMT,
                                       nvl(sum(ln.PRINNML - nvl(nml,0) + ln.INTNMLACR),0) NMLMARGINAMT,
                                       nvl(sum(decode(lnt.chksysctrl,'Y',1,0)*(ln.prinnml+ln.prinovd+ln.intnmlacr+ln.intdue+ln.intovdacr+ln.intnmlovd+ln.feeintnmlacr+ln.feeintdue+ln.feeintovdacr+ln.feeintnmlovd)),0) margin74amt
                                    from lnmast ln, lntype lnt, (select acctno, sum(nml) nml, sum(intdue) intdue  from lnschd
                                                        where reftype = 'P' and  overduedate = to_date(cspks_system.fn_get_sysvar('SYSTEM','CURRDATE'),'DD/MM/RRRR') group by acctno) lns
                                    where ln.actype = lnt.actype and ln.acctno = lns.acctno(+) and ln.ftype = 'AF'
                                    group by ln.trfacctno) OVDAF on OVDAF.TRFACCTNO = cimast.acctno
                    WHERE cimast.acctno = V_AFACCTNO;
        else
            --Tai khoan margin join theo group
            -- Ducnv sua lai theo inquiryaccount
            OPEN PV_REFCURSOR FOR
             select round(AF.ADVANCELINE+ MST.PP,0) PURCHASINGPOWER,
                AF.ADVANCELINE - nvl(trft0amt,0) + MST.AVLLIMIT AVLLIMIT,
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
                                            nvl(adv.avladvance,0) +ci.balance- ci.ovamt-ci.dueamt - ci.ramt-af.advanceline,
                                            AVLLIMIT),0)
                                 ELSE BALDEFOVD END),0) BALDEFOVD,
                nvl(dp.dealpaidamt,0) dealpaidamt
                from
                (SELECT V_AFACCTNO afacctno,sum((mst.ramt - mst.aamt)) cipamt, sum(af.tradeline) tradeline ,
                sum(case when mst.acctno=V_AFACCTNO
                 then TRUNC (mst.balance)-nvl(al.secureamt,0)
                 else 0 end)
                 balance,
                                    sum(mst.balance) intbalance,sum(mst.DFDEBTAMT)  DFDEBTAMT,
                                    sum(mst.cramt) cramt, sum(mst.dramt) dramt, sum(mst.avrbal) avrbal, sum(mst.mdebit) mdebit, sum(mst.mcredit) mcredit,
                                   sum(mst.crintacr) crintacr, sum(mst.odintacr) odintacr, sum(mst.adintacr) adintacr, sum(mst.minbal) minbal, sum(nvl(adv.aamt,0)) aamt,
                                   sum(mst.ramt) ramt, sum(nvl(al.secureamt,0)) bamt, sum(mst.emkamt) emkamt, sum(mst.odlimit) odlimit, sum(mst.mmarginbal) mmarginbal,
                                   sum(mst.marginbal) marginbal, sum(mst.odamt) odamt, sum(nvl(adv.avladvance,0)) receiving, sum(mst.mblock) mblock,
                                   sum(nvl(adv.advanceamount,0)) apmt,sum(nvl(adv.paidamt,0)) paidamt,
                                   sum(NVL (af.mrcrlimitmax, 0)) ADVLIMIT,
                                   sum(nvl(adv.avladvance,0) + mst.balance - nvl(al.secureamt,0) - mst.odamt- mst.dfdebtamt - mst.dfintdebtamt - NVL (al.advamt, 0)) avlwithdraw ,
                                   greatest(SUM(nvl(adv.avladvance,0) + balance- ovamt-dueamt - mst.dfdebtamt - mst.dfintdebtamt- ramt - mst.depofeeamt),0) baldefovd,
                                   least(sum((nvl(af.mrcrlimit,0) + nvl(se.seass,0)+
                                                nvl(adv.avladvance,0)))
                                        ,sum(nvl(adv.avladvance,0) + greatest(nvl(af.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)-mst.dfodamt,0)))
                                   + sum(mst.balance- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- nvl (al.advamt, 0)-nvl(al.secureamt,0)  - nvl(trft0addamt,0) -nvl(trfsecuredamt,0)  - mst.ramt - mst.depofeeamt) pp,
                                   sum(nvl(adv.avladvance,0) + nvl(af.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)-mst.dfodamt + mst.balance- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- nvl (al.overamt, 0)-nvl(al.secureamt,0) - mst.ramt - mst.depofeeamt) avllimit,
                                   sum(/*nvl(af.MRCRLIMIT,0) + */ nvl(se.SEASS,0))  NAVACCOUNT,
                                   sum(mst.balance+ nvl(adv.avladvance,0)+least(nvl(af.mrcrlimit,0),nvl(al.secureamt,0))- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt- NVL (al.advamt, 0)-nvl(al.secureamt,0) - mst.ramt) OUTSTANDING,
                                   sum(case when af.acctno <> v_groupleader then 0 else af.mrirate end) mstmrirate,
                                   sum(mst.depofeeamt) cidepofeeacr,
                                   nvl(al.trft0amt,0) trft0amt
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
                (select * from v_getdealpaidbyaccount p where p.afacctno = V_AFACCTNO) dp,
                (select depoamt avladvance,afacctno from v_getAccountAvlAdvance where afacctno = V_AFACCTNO ) adv
                where mst.afacctno =af.acctno
                and mst.afacctno=ci.afacctno
                and mst.afacctno=st.afacctno(+)
                and mst.afacctno=dp.afacctno(+)
                and mst.afacctno=adv.afacctno(+)
                ;

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

