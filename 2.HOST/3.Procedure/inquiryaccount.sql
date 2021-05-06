CREATE OR REPLACE PROCEDURE inquiryaccount (
        PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
        f_TABLENAME IN VARCHAR2,
        f_ACCTNO IN VARCHAR2,
        f_INDATE in varchar2,
        f_TYPE in varchar2)
  IS
  V_ACCTNO VARCHAR2(50);
  V_TABLENAME VARCHAR2(30);
  v_INDATE date;
  v_type char(1);
  v_margintype char(1);
  v_actype varchar2(4);
  v_groupleader varchar2(10);
  l_count number;
  l_isChkSysCtrlDefault varchar2(1);
  l_isMarginAcc varchar2(1);
  l_TRFBUYRATE number;
  v_ISFO varchar2(1);
  v_FOwithdraw NUMBER;
  v_FOwithdrawPP NUMBER;

  l_deal      VARCHAR2(2);
  l_t0loanrate   NUMBER;
  l_isstopadv   varchar2(10);
BEGIN
    l_isstopadv := cspks_system.fn_get_sysvar('MARGIN','ISSTOPADV');
    V_ACCTNO:=F_ACCTNO;
    V_TABLENAME:=F_TABLENAME;
    v_type:=f_TYPE;
    IF LENGTH(v_INDATE) > 0 THEN
       v_INDATE:=to_date(f_INDATE,'DD/MM/YYYY');
    END IF;

    begin
        SELECT NVL(ISFO,'N') INTO v_ISFO FROM afmast WHERE acctno = F_ACCTNO AND ISFO = 'Y' AND EXISTS (SELECT varname FROM sysvar WHERE varname = 'FOMODE' AND varvalue = 'ON');
    EXCEPTION WHEN OTHERS THEN
        v_ISFO:='N';
    END;

    IF v_ISFO = 'Y' THEN
        v_FOwithdraw :=CSPKS_FO_ACCOUNT.fn_get_withdraw@DBL_FO(F_ACCTNO);
        v_FOwithdrawPP :=CSPKS_FO_ACCOUNT.fn_get_withdraw_PP@DBL_FO(F_ACCTNO);
    ELSE
        v_FOwithdraw := NULL;
        v_FOwithdrawPP := 0;
    END IF;

if V_TABLENAME = 'CIMAST' THEN

    l_TRFBUYRATE:= (100 - to_number(cspks_system.fn_get_sysvar('SYSTEM', 'TRFBUYRATE')))/100;
    SELECT MR.MRTYPE,af.actype,mst.groupleader
    into v_margintype,v_actype,v_groupleader
    from afmast mst,aftype af, mrtype mr
    where mst.actype=af.actype and af.mrtype=mr.actype and mst.acctno=V_ACCTNO;

    BEGIN
      SELECT cf.t0loanrate, nvl(af.deal,'Y') INTO l_t0loanrate,l_deal FROM cfmast cf, afmast af 
      WHERE cf.custid = af.custid AND af.acctno = V_ACCTNO;
    exception when others then
        l_t0loanrate:=0;
        l_deal:='Y';
    END;
        if v_margintype in ('N','L') then
            --Tai khoan binh thuong khong Margin
            OPEN PV_REFCURSOR FOR
              SELECT dt.*, least(dt.baldefovd, nvl(v_FOwithdraw, dt.baldefovd + 1)) WITHDRAWAMT FROM ( -- 1.5.9.0
                SELECT cf.CUSTODYCD, ci.ACTYPE, ci.ACCTNO, ci.AFACCTNO, ci.CCYCD, ci.LASTDATE,
                       (ci.ramt - ci.aamt) CIPAMT, af.TRADELINE, trunc (ci.balance)-nvl(b.secureamt,0)-nvl (b.advamt, 0) BALANCE,
                       greatest(trunc (ci.balance)-nvl(b.secureamt,0),0) + CI.emkamt INTBALANCE, ci.DFDEBTAMT,
                       ci.CRAMT, ci.DRAMT, ci.AVRBAL, ci.MDEBIT, ci.MCREDIT,
                       CI.CRINTACR, CI.ODINTACR, CI.ADINTACR, CI.MINBAL, NVL(ADV.AAMT,0) AAMT,
                       CI.RAMT, NVL(B.secureamt,0) + NVL (B.advamt, 0) BAMT, CI.EMKAMT, CI.ODLIMIT, CI.MMARGINBAL,
                       CI.MARGINBAL, CI.ODAMT, NVL(ADV.avladvance,0) RECEIVING, CI.MBLOCK, CCY.SHORTCD,
                       CD1.cdcontent DESC_STATUS, NVL(ADV.advanceamount,0) APMT,ROUND(NVL(ADV.paidamt,0),0) PAIDAMT,
                       AF.ADVANCELINE,NVL(AF.mrcrlimitmax,0) ADVLIMIT, AF.MRIRATE,AF.MRMRATE,AF.MRLRATE,
                       nvl(pd.dealpaidamt,0) DEALPAIDAMT,
                       round(greatest(decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + ci.balance - nvl(b.secureamt,0) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - nvl (b.advamt, 0)-nvl(pd.dealpaidamt,0)-ci.depofeeamt,0),0) AVLWITHDRAW ,
                       greatest(
                            decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - NVL (overamt, 0) - nvl(secureamt,0) - ramt-nvl(pd.dealpaidamt,0) - ci.depofeeamt
                            ,0) BALDEFOVD,
                       greatest(
                            decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - ramt-nvl(pd.dealpaidamt,0) - ci.depofeeamt
                                    - greatest(
                                            nvl(trfi.secureamt_inday,0)
                                            + (nvl(trfi.trfbuyamtnofee_inday,0) + nvl(trfbuyamtnofee,0)) * l_TRFBUYRATE
                                            ,
                                            nvl(b.buyamt,0) + nvl(b.buyfeeacr,0) - least(af.trfbuyrate/100* nvl(b.buyamt,0) + case when af.trfbuyrate > 0 then nvl(b.buyfeeacr,0) else 0 end, af.advanceline - nvl(b.trft0amt,0) )
                                            + nvl(b.trfsecuredamt,0)
                                            + nvl(b.trft0amt_over,0))
                            ,0) BALDEFTRFAMT,
                       (decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - ci.trfbuyamt - odamt- ci.dfdebtamt - ci.dfintdebtamt - nvl (advamt, 0)-nvl(secureamt,0) - ramt) realbalwithdrawn,
                       round(
                            decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + nvl(balance,0) - nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - nvl (advamt, 0)- nvl(secureamt,0) +
                            /*advanceline*/
                            --1.5.8.9
                            CASE WHEN l_deal = 'N' THEN greatest(least(ROUND(least(nvl((ci.balance-NVL(b.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt -
                                nvl(ci.ovamt,0),0) * l_t0loanrate /100,nvl(v_getsec.SELIQAMT2,0))),af.advanceline),0) ELSE af.advanceline END
                            - nvl(trft0amt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) - nvl(ramt,0) - ci.depofeeamt + least(af.mrcrlimitmax +af.mrcrlimit- ci.dfodamt,af.mrcrlimit)
                        ,0) PP,
                       greatest( round(
                            decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + nvl(balance,0) - nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - nvl (advamt, 0)- nvl(secureamt,0) + advanceline - nvl(trft0amt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) - nvl(ramt,0) - ci.depofeeamt + least(af.mrcrlimitmax +af.mrcrlimit- ci.dfodamt,af.mrcrlimit) - NVL(af.mrcrlimit,0)
                        ,0),0) PP_TDAMT, -- = PP - af.mrcrlimit
                       decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + af.mrcrlimitmax+af.mrcrlimit-ci.dfodamt + af.advanceline - nvl(trft0amt,0) + ci.balance - ci.odamt- ci.dfdebtamt - ci.dfintdebtamt - nvl (b.overamt, 0)-nvl(b.secureamt,0) - ci.ramt - ci.depofeeamt -nvl(b.trfsecuredamt,0)-nvl(b.trft0addamt,0) AVLLIMIT,
                       nvl(af.mrclamt,0) +  nvl(se.seass,0)  NAVACCOUNT,
                       ci.balance+ least(mrcrlimit,nvl(b.secureamt,0)+ci.trfbuyamt) - ci.trfbuyamt+ decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0))- ci.odamt - ci.dfdebtamt - ci.dfintdebtamt- nvl (b.advamt, 0)-nvl(b.secureamt,0) - ci.ramt OUTSTANDING,
                       round(
                            (case when ci.balance+ least(nvl(af.mrcrlimit,0),nvl(b.secureamt,0)+ci.trfbuyamt) - ci.trfbuyamt+decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0))- ci.odamt- ci.dfdebtamt - ci.dfintdebtamt - nvl (b.advamt, 0)-nvl(b.secureamt,0) - ci.ramt>=0 then 100000
                            else (nvl(af.mrclamt,0) + nvl(se.seass,0) + decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)))/ abs(ci.balance+least(nvl(af.mrcrlimit,0),nvl(b.secureamt,0)+ci.trfbuyamt) - ci.trfbuyamt+decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0))- ci.odamt- ci.dfdebtamt - ci.dfintdebtamt - nvl (b.advamt, 0)-nvl(b.secureamt,0) - ci.ramt) end)
                            ,4) * 100 MARGINRATE,
                        round(
                            (case when ci.balance+ least(nvl(af.mrcrlimit,0),nvl(b.secureamt,0)+ci.trfbuyamt) - ci.trfbuyamt+decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0))+ NVL(SE2.NYOVDAMT,0)- ci.odamt- ci.dfdebtamt - ci.dfintdebtamt - nvl (b.advamt, 0)-nvl(b.secureamt,0) - ci.ramt>=0 then 100000
                            else (nvl(af.mrclamt,0) + nvl(se.seass,0) + decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)))/ abs(ci.balance+least(nvl(af.mrcrlimit,0),nvl(b.secureamt,0)+ci.trfbuyamt) - ci.trfbuyamt+decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0))- ci.odamt- ci.dfdebtamt - ci.dfintdebtamt - nvl (b.advamt, 0)-nvl(b.secureamt,0) - ci.ramt) end)
                            ,4) * 100 MARGINRATE2,
                       ci.DEPOFEEAMT, ci.CIDEPOFEEACR, ci.TRFBUYAMT, ci.netting SENDING,
                       NVL(af.mrcrlimit,0) mrcrlimit, nvl(v_FOwithdraw,0) FOWITHDRAW, v_FOwithdrawPP FOWITHDRAWPP
                  FROM cimast ci
                       inner join afmast af on af.acctno = ci.afacctno AND ci.acctno = V_ACCTNO
                       inner join sbcurrency ccy on ccy.ccycd = ci.ccycd
                       INNER JOIN cfmast cf ON cf.custid = af.custid
                       inner join (select * from allcode cd1  where cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS') cd1 on ci.status = cd1.cdval
                       left join
                       (select * from v_getbuyorderinfo where afacctno = V_ACCTNO) b
                        on ci.acctno = b.afacctno
                        LEFT JOIN
                          (select TRFACCTNO AFACCTNO,
                            sum(case when LNS.mintermdate >= getcurrdate then   (LNS.nml + LNS.ovd + LNS.intdue + LNS.intovd + LNS.feedue + LNS.feeovd + LNS.intovdprin+lns.intnmlacr
                            + LNS.feeintnmlacr + LNS.feeintovdacr + LNS.feeintnmlovd + LNS.feeintdue
                             + LNS.nmlfeeint + LNS.ovdfeeint + LNS.feeintnml + LNS.feeintovd ) else 0 end)  NYOVDAMT
                             ,  sum(case when LNS.mintermdate < getcurrdate then   (LNS.nml + LNS.ovd + LNS.intdue + LNS.intovd + LNS.feedue + LNS.feeovd + LNS.intovdprin+lns.intnmlacr
                            + LNS.feeintnmlacr + LNS.feeintovdacr + LNS.feeintnmlovd + LNS.feeintdue
                             + LNS.nmlfeeint + LNS.ovdfeeint + LNS.feeintnml + LNS.feeintovd ) else 0 end) MPOVDAMT
                            from lnschd LNS,LNMAST LN  WHERE LNS.ACCTNO = LN.ACCTNO AND  reftype = 'GP'
                            group by TRFACCTNO)SE2
                       ON CI.ACCTNO = SE2.AFACCTNO
                       LEFT JOIN (SELECT *
                                FROM vw_trfbuyinfo_inday
                               WHERE afacctno = V_ACCTNO) trfi
                               ON ci.acctno = trfi.afacctno
                       LEFT JOIN
                       (select * from v_getsecmargininfo where afacctno = V_ACCTNO) SE
                       on se.afacctno = ci.acctno
                       LEFT JOIN
                       (select aamt,depoamt avladvance, advamt advanceamount,afacctno, paidamt from v_getAccountAvlAdvance where afacctno = V_ACCTNO) adv
                       on adv.afacctno=ci.acctno
                       LEFT JOIN
                       (select * from v_getdealpaidbyaccount p where p.afacctno = V_ACCTNO) pd
                       on pd.afacctno=ci.acctno
                       --1.5.8.9 MSBS-2055
                      LEFT JOIN
                      (SELECT * FROM v_getsecmargininfo_ALL) v_getsec
                      ON ci.acctno = v_getsec.afacctno) dt;
        elsif v_margintype in ('S','T') and (length(v_groupleader)=0 or v_groupleader is null) then

            select count(1)
                into l_count
            from afmast af
            where af.acctno = V_ACCTNO
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
            where af.acctno = V_ACCTNO
            and exists (select 1 from aftype aft, lntype lnt where to_char(aft.actype) = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y');

            if l_count > 0 then
                l_isChkSysCtrlDefault:='Y';
            else
                l_isChkSysCtrlDefault:='N';
            end if;

            --Tai khoan margin khong tham gia group
            OPEN PV_REFCURSOR FOR
           SELECT dt.*, least(dt.baldefovd, nvl(v_FOwithdraw, dt.baldefovd + 1)) WITHDRAWAMT FROM ( -- 1.5.9.0
           SELECT CUSTODYCD,ACTYPE,ACCTNO,AFACCTNO,CCYCD,LASTDATE,CIPAMT,TRADELINE,BALANCE,INTBALANCE,CRAMT,DRAMT,AVRBAL,MDEBIT,MCREDIT,
                CRINTACR,ODINTACR,ADINTACR,MINBAL,AAMT,RAMT,BAMT,EMKAMT,ODLIMIT,MMARGINBAL,MARGINBAL,ODAMT,RECEIVING,
                MBLOCK,SHORTCD,DESC_STATUS,APMT,ADVANCELINE,ADVLIMIT,MRIRATE,MRMRATE,MRLRATE,PP,greatest( PP - MRCRLIMIT,0) PP_TDAMT,AVLLIMIT,NAVACCOUNT,OUTSTANDING,
                MARGINRATE,MARGINRATE2, DFDEBTAMT,DEALPAIDAMT,
                TRUNC(
                    GREATEST(
                        (CASE WHEN MRIRATE>0 THEN least(NAVACCOUNT*100/MRIRATE + (OUTSTANDING-(ADVANCELINE-trft0amt)),AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE NAVACCOUNT + OUTSTANDING END)
                    ,0) - DEALPAIDAMT
                ,0) AVLWITHDRAW,
                round(greatest(case when l_isChkSysCtrlDefault = 'Y' then
                    least(
                        (MARGINRATIO/100 - MRIRATIO/100) * (serealass) + greatest(0,balance+bamt+nvl(avladvance,0)-ovamt-dueamt-depofeeamt)
                        ,
                       TRUNC(
                        --(CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNT + (OUTSTANDING-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
                        -- HaiLT sua ct rut tien thuong theo y/c MR001
                        (CASE WHEN MRIRATE>0  THEN LEAST(PP,BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
                        - DEALPAIDAMT
                    ,0))
                else
                    TRUNC(
                        --(CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNT + (OUTSTANDING-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
                        -- HaiLT sua ct rut tien thuong theo y/c MR001
                        (CASE WHEN MRIRATE>0  THEN LEAST(PP,BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
                        - DEALPAIDAMT
                    ,0)
                end,0) ,0) BALDEFOVD,
                round(greatest(case when l_isChkSysCtrlDefault = 'Y' then
                    least(
                        (MARGINRATIO/100 - MRIRATIO/100) * (serealass) + greatest(0,balance+bamt+nvl(avladvance,0)-ovamt-dueamt-depofeeamt)
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
                end,0),0) BALDEFTRFAMT,
                MARGINRATIO, DEPOFEEAMT, PAIDAMT, TRFBUYAMT, CIDEPOFEEACR, SENDING,MRCRLIMIT,
                nvl(v_FOwithdraw,0) FOWITHDRAW, v_FOwithdrawPP FOWITHDRAWPP
            FROM (
            SELECT cf.CUSTODYCD,AF.advanceline,ci.actype, ci.acctno, ci.afacctno, ci.ccycd, ci.lastdate,
                   (ci.ramt - ci.aamt) cipamt, af.tradeline, TRUNC (ci.balance)-nvl(se.secureamt,0) balance,
                  greatest(trunc (ci.balance)-nvl(se.secureamt,0),0) + CI.emkamt intbalance, ci.DFDEBTAMT,
                   ci.cramt, ci.dramt, ci.avrbal, ci.mdebit, ci.mcredit,
                   ci.crintacr, ci.odintacr, ci.adintacr, ci.minbal, nvl(se.aamt,0) aamt,
                   ci.ramt, nvl(se.secureamt,0) bamt, ci.emkamt, ci.odlimit, ci.mmarginbal,
                   ci.marginbal, ci.odamt, nvl(se.avladvance,0) receiving, ci.mblock, ccy.shortcd,
                   cd1.cdcontent desc_status, nvl(se.advanceamount,0) apmt,round(nvl(se.paidamt,0),0) paidamt,
                   nvl(af.mrcrlimitmax,0) advlimit, af.mrirate,af.mrmrate,af.mrlrate,
                   nvl(se.dealpaidamt,0) dealpaidamt,
                   decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + ci.balance - nvl(se.secureamt,0) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt- ci.dfdebtamt - ci.dfintdebtamt - NVL (se.advamt, 0)-nvl(se.dealpaidamt,0) - nvl(depofeeamt,0) avlwithdraw ,
                   greatest(
                       decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance /*- trfbuyamt*/ - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt /*- NVL (overamt, 0) - nvl(secureamt,0)*/ - ramt-nvl(se.dealpaidamt,0) - ci.depofeeamt
                       ,0) BALDEFOVD,
                   greatest(
                       decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - ramt-nvl(se.dealpaidamt,0) - ci.depofeeamt
                                   /*- greatest(0, nvl(se.buyamt,0) + nvl(se.buyfeeacr,0) - least(af.trfbuyrate/100* nvl(se.buyamt,0) + case when af.trfbuyrate > 0 then nvl(se.buyfeeacr,0) else 0 end, af.advanceline - nvl(se.trft0amt,0) )
                                           + nvl(trfsecuredamt,0)
                                           + nvl(se.trft0addamt,0))*/
                       ,0) baldeftrfamt,
/*                   greatest(
                               nvl(se.avladvance,0) + ci.balance - ci.ovamt - ci.dueamt - ci.dfdebtamt - ci.dfintdebtamt - ramt - nvl(se.dealpaidamt,0) - ci.depofeeamt
                           ,0) baldefovd,
                   greatest(
                               nvl(sts_rcv.receivingamt,0)
                           ,0) baldeftrfamt,*/
                   case when l_isChkSysCtrlDefault = 'Y' then
                       least(
                       round(ci.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                           - nvl(se.trft0addamt,0) -nvl(se.trfsecuredamt,0) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+ nvl(af.mrcrlimit,0)- dfodamt,nvl(af.mrcrlimit,0) + nvl(se.semramt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt - ci.depofeeamt,0),
                       round(ci.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                           - nvl(se.trft0addamt,0) -nvl(se.trfsecuredamt,0) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                       )
                   else
                       round(ci.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                           - nvl(se.trft0addamt,0) -nvl(se.trfsecuredamt,0) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                   end PP,
                   round(
                        decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + nvl(af.advanceline,0) - nvl(se.trft0amt,0) + nvl(AF.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)- dfodamt + balance- ci.odamt - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - nvl(se.secureamt,0) - ramt - nvl(depofeeamt,0) - nvl(se.trft0addamt,0) -nvl(se.trfsecuredamt,0)
                        ,0) AVLLIMIT,
                   round(
                        decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + nvl(af.advanceline,0) + nvl(AF.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)- dfodamt + balance- ci.odamt - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - ramt - nvl(depofeeamt,0) - nvl(se.trft0addamt,0) -nvl(se.trfsecuredamt,0)
                            -nvl(trf.trfsecuredamt_inday,0)-nvl(trf.secureamt_inday,0)
                        ,0) AVLLIMITT2,
                   least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SETOTALCALLASS,0),nvl(af.mrcrlimitmax,0) - dfodamt) NAVACCOUNT,
                   least(/*nvl(af.MRCRLIMIT,0)*/ + nvl(se.SET0CALLASS,0),nvl(af.mrcrlimitmax,0) - dfodamt) NAVACCOUNTT2,
                   nvl(af.advanceline,0) - nvl(se.trft0amt,0) + ci.balance
                   +least(nvl(af.MRCRLIMIT,0),nvl(se.secureamt,0)+trfbuyamt)
                   - trfbuyamt + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - NVL (se.advamt, 0)-nvl(se.secureamt,0) - ci.ramt OUTSTANDING,
                   least(nvl(af.advanceline,0)  - nvl(se.trft0amt,0) + ci.balance
                                 +least(nvl(af.MRCRLIMIT,0),nvl(trf.trfsecuredamt_inday,0) + nvl(se.trfsecuredamt,0)+nvl(trf.secureamt_inday,0) +nvl(se.trft0amt_over,0))
                                +decode(l_isstopadv,'Y',0,nvl(se.avladvance,0))- ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - ci.ramt - nvl(se.trft0amt_over,0)
                                -nvl(trf.trfsecuredamt_inday,0) - nvl(se.trfsecuredamt,0) -nvl(trf.secureamt_inday,0),
                                nvl(af.advanceline,0)  - nvl(se.trft0amt,0) + ci.balance
                                +least(nvl(af.MRCRLIMIT,0),(nvl(trf.trfbuyamtnofee_inday,0)+nvl(se.trfbuyamtnofee,0)) * l_TRFBUYRATE + nvl(trf.secureamt_inday,0))+ decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - ci.ramt
                                -(nvl(trf.trfbuyamtnofee_inday,0)+nvl(se.trfbuyamtnofee,0)) * l_TRFBUYRATE - nvl(trf.secureamt_inday,0)
                                ) OUTSTANDINGT2,
                   nvl(se.MARGINRATE,0) MARGINRATE,
                   nvl(se2.MARGINRATE,0) MARGINRATE2,
                   nvl(se.chksysctrl,'N') CHKSYSCTRL, nvl(se.MARGINRATIO,0) MARGINRATIO, ci.DEPOFEEAMT, ci.TRFBUYAMT, nvl(se.trft0amt,0) TRFT0AMT, ci.CIDEPOFEEACR,
                   nvl(margin74amt,0) margin74amt, decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) avladvance, nvl(se.serealass,0) serealass, nvl(af.MRIRATIO,0) MRIRATIO, dueamt, ovamt,
                   ci.netting SENDING,NVL(af.mrcrlimit,0) mrcrlimit
              FROM cimast ci inner join afmast af on af.acctno = ci.afacctno AND ci.acctno = V_ACCTNO
                    INNER JOIN aftype aft ON aft.actype = af.actype
                    INNER JOIN mrtype mrt ON aft.mrtype = mrt.actype and mrt.mrtype IN ('S','T')
                    inner join sbcurrency ccy on ccy.ccycd = ci.ccycd
                    INNER JOIN cfmast cf ON cf.custid = af.custid
                    inner join (select * from allcode cd1  where cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS') cd1 on ci.status = cd1.cdval
                    left join (select * from v_getsecmarginratio where afacctno = V_ACCTNO) se on se.afacctno = ci.acctno
                    left join (select * from v_getsecmarginratio_ALL  where afacctno = V_ACCTNO) se2 on se2.afacctno = ci.acctno
                    left join (select * from vw_trfbuyinfo_inday where afacctno = V_ACCTNO) trf on trf.afacctno = ci.acctno
                    left join (select TRFACCTNO, nvl(sum(ln.PRINOVD + ln.INTOVDACR + ln.INTNMLOVD + ln.OPRINOVD + ln.OPRINNML + ln.OINTNMLOVD + ln.OINTOVDACR+ln.OINTDUE+ln.OINTNMLACR + nvl(lns.nml,0) + nvl(lns.intdue,0)),0) OVDAMT,
                                       nvl(sum(ln.PRINNML + ln.PRINOVD + ln.INTOVDACR + ln.INTNMLOVD + ln.INTNMLACR + ln.INTDUE),0) MARGINAMT,
                                                       nvl(sum(ln.PRINNML - nvl(nml,0) + ln.INTNMLACR),0) NMLMARGINAMT,
                                       nvl(sum(decode(lnt.chksysctrl,'Y',1,0)*(ln.prinnml+ln.prinovd+ln.intnmlacr+ln.intdue+ln.intovdacr+ln.intnmlovd+ln.feeintnmlacr+ln.feeintdue+ln.feeintovdacr+ln.feeintnmlovd)),0) margin74amt
                                    from lnmast ln, lntype lnt, (select acctno, sum(nml) nml, sum(intdue) intdue  from lnschd
                                                        where reftype = 'P' and  overduedate = to_date(cspks_system.fn_get_sysvar('SYSTEM','CURRDATE'),'DD/MM/RRRR') group by acctno) lns
                                    where ln.actype = lnt.actype and ln.acctno = lns.acctno(+) and ln.ftype = 'AF'
                                    and ln.trfacctno = V_ACCTNO
                                    group by ln.trfacctno) OVDAF on OVDAF.TRFACCTNO = ci.acctno
                    left join (select afacctno, sum(amt) receivingamt from stschd where afacctno = V_ACCTNO and duetype = 'RM' and status <> 'C' and deltd <> 'Y' group by afacctno) sts_rcv
                                on ci.acctno = sts_rcv.afacctno
                   )) dt
                   ;
        else
            --Tai khoan margin join theo group
            if v_type='U' then
               OPEN PV_REFCURSOR FOR
               SELECT dt.*, least(dt.baldefovd, nvl(v_FOwithdraw, dt.baldefovd + 1)) WITHDRAWAMT FROM ( -- 1.5.9.0
                SELECT CUSTODYCD,ACTYPE,ACCTNO,AFACCTNO,CCYCD,LASTDATE,CIPAMT,TRADELINE,BALANCE,INTBALANCE,CRAMT,DRAMT,AVRBAL,MDEBIT,MCREDIT,
                    CRINTACR,ODINTACR,ADINTACR,MINBAL,AAMT,RAMT,BAMT,EMKAMT,ODLIMIT,MMARGINBAL,MARGINBAL,ODAMT,RECEIVING,
                    MBLOCK,SHORTCD,DESC_STATUS,APMT,ADVLIMIT,MRIRATE,MRMRATE,MRLRATE,PP, greatest( PP - MRCRLIMIT,0) PP_TDAMT,AVLLIMIT,NAVACCOUNT,OUTSTANDING,
                    MARGINRATE, DFDEBTAMT,
                    TRUNC(
                        GREATEST(
                            (CASE WHEN MRIRATE>0 THEN greatest(least(NAVACCOUNT*100/MRIRATE + (OUTSTANDING),AVLLIMIT-advanceline),0) ELSE NAVACCOUNT + OUTSTANDING END)
                        ,0) - DEALPAIDAMT
                    ,0) AVLWITHDRAW,
                    TRUNC(
                        --(CASE WHEN MRIRATE>0  THEN GREATEST(LEAST((100* NAVACCOUNT + OUTSTANDING * MRIRATE)/MRIRATE,BALDEFOVD,AVLLIMIT-advanceline),0) ELSE BALDEFOVD END)
                        -- HaiLT sua ct rut tien thuong theo y/c MR001
                        (CASE WHEN MRIRATE>0  THEN GREATEST(LEAST(PP,BALDEFOVD,AVLLIMIT-advanceline),0) ELSE BALDEFOVD END)
                        - DEALPAIDAMT
                    ,0) BALDEFOVD, depofeeamt, paidamt, trfbuyamt, cidepofeeacr, SENDING,MRCRLIMIT,
                    nvl(v_FOwithdraw,0) FOWITHDRAW, v_FOwithdrawPP FOWITHDRAWPP
                FROM (
                SELECT cf.CUSTODYCD,AF.advanceline,ci.actype, ci.acctno, ci.afacctno, ci.ccycd, ci.lastdate,
                       (ci.ramt - ci.aamt) cipamt, af.tradeline, TRUNC (ci.balance)-nvl(b.secureamt,0) balance,
                       greatest(trunc (ci.balance)-nvl(b.secureamt,0),0) + CI.emkamt intbalance, ci.DFDEBTAMT,
                       ci.cramt, ci.dramt, ci.avrbal, ci.mdebit, ci.mcredit,
                       ci.crintacr, ci.odintacr, ci.adintacr, ci.minbal, nvl(adv.aamt,0) aamt,
                       ci.ramt, nvl(b.secureamt,0) bamt, ci.emkamt, ci.odlimit, ci.mmarginbal,
                       ci.marginbal, ci.odamt, nvl(adv.avladvance,0) receiving, ci.mblock, ccy.shortcd,
                       cd1.cdcontent desc_status, nvl(adv.advanceamount,0) apmt,nvl(adv.paidamt,0) paidamt,
                       nvl(af.mrcrlimitmax,0) advlimit, af.mrirate,af.mrmrate,af.mrlrate,
                       -nvl(pd.dealpaidamt,0) dealpaidamt,
                       nvl(adv.avladvance,0) + ci.balance - ci.trfbuyamt - nvl(b.secureamt,0) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt- NVL (b.advamt, 0) -nvl(pd.dealpaidamt,0) avlwithdraw ,
                       greatest(nvl(adv.avladvance,0) + balance - ci.trfbuyamt- ovamt-dueamt - ci.dfdebtamt - ci.dfintdebtamt- ramt-af.advanceline-nvl(pd.dealpaidamt,0)- depofeeamt,0) baldefovd,
                       greatest(least(nvl(af.mrcrlimit,0) + nvl(se.seamt,0)
                            ,greatest(nvl(af.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)-ci.dfodamt,0))
                       + ci.balance + nvl(adv.avladvance,0) - nvl(trfsecuredamt,0) - nvl(trft0addamt,0) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt- nvl(b.secureamt,0) - ci.ramt - ci.depofeeamt,0) pp,
                       nvl(adv.avladvance,0) + af.advanceline - nvl(trft0amt,0) + nvl(af.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)-ci.dfodamt + ci.balance - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt- nvl (b.overamt, 0)-nvl(b.secureamt,0) - ci.ramt - ci.depofeeamt avllimit,
                       /*nvl(af.MRCRLIMIT,0) +*/  nvl(se.SEASS,0)  NAVACCOUNT,
                       ci.balance +least(nvl(af.mrcrlimit,0),nvl(b.secureamt,0)+ci.trfbuyamt)- ci.trfbuyamt+ nvl(adv.avladvance,0)- ci.odamt - ci.dfdebtamt - ci.dfintdebtamt- NVL (b.advamt, 0)-nvl(b.secureamt,0) - ci.ramt OUTSTANDING,
                       round((case when ci.balance+least(nvl(af.mrcrlimit,0),nvl(b.secureamt,0)+ci.trfbuyamt) - ci.trfbuyamt + nvl(adv.avladvance,0) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt- NVL (b.advamt, 0)-nvl(b.secureamt,0) - ci.ramt>=0 then 100000
                       else (/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SEASS,0))/ abs(ci.balance+least(nvl(af.mrcrlimit,0),nvl(b.secureamt,0)+ci.trfbuyamt) - ci.trfbuyamt+ nvl(adv.avladvance,0)- ci.odamt - ci.dfdebtamt - ci.dfintdebtamt- NVL (b.advamt, 0)-nvl(b.secureamt,0) - ci.ramt) end),4) * 100 MARGINRATE,
                       ci.depofeeamt, ci.trfbuyamt, ci.cidepofeeacr,ci.netting SENDING,
                       NVL(af.mrcrlimit,0) mrcrlimit
                  FROM cimast ci inner join afmast af on af.acctno = ci.afacctno AND ci.acctno = V_ACCTNO
                       inner join sbcurrency ccy on ccy.ccycd = ci.ccycd
                       INNER JOIN cfmast cf ON cf.custid = af.custid
                       inner join (select * from allcode cd1  where cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS') cd1 on ci.status = cd1.cdval
                       left join
                       (select * from v_getbuyorderinfo where afacctno = V_ACCTNO) b
                        on ci.acctno = b.afacctno
                        LEFT JOIN
                       (select * from v_getsecmargininfo where afacctno = V_ACCTNO) SE
                       on se.afacctno=ci.acctno
                       LEFT JOIN
                       (select aamt,depoamt avladvance, advamt advanceamount,afacctno, paidamt from v_getAccountAvlAdvance where afacctno = V_ACCTNO ) adv
                       on adv.afacctno=ci.acctno
                       LEFT JOIN
                       (select * from v_getdealpaidbyaccount p where p.afacctno = V_ACCTNO) pd
                       on pd.afacctno=ci.acctno
                       )) dt;
            else
                OPEN PV_REFCURSOR FOR
                SELECT dt.*, least(dt.baldefovd, nvl(v_FOwithdraw, dt.baldefovd + 1)) WITHDRAWAMT FROM ( -- 1.5.9.0
                select cf.CUSTODYCD,ci.actype, ci.acctno,ci.ccycd, ci.lastdate, af.mrirate,af.mrmrate,af.mrlrate,
                        ccy.shortcd,cd1.cdcontent desc_status,
                        MST.AFACCTNO,MST.CIPAMT,MST.TRADELINE,MST.BALANCE,MST.INTBALANCE,MST.CRAMT,MST.DRAMT,MST.AVRBAL,
                        MST.MDEBIT,MST.MCREDIT,MST.CRINTACR,MST.ODINTACR,MST.ADINTACR,MST.MINBAL,MST.AAMT,
                        MST.RAMT,MST.BAMT,MST.EMKAMT,MST.ODLIMIT,MST.MMARGINBAL,MST.MARGINBAL,MST.ODAMT,
                        MST.RECEIVING,MST.MBLOCK,MST.APMT,PAIDAMT,
                        AF.ADVANCELINE,MST.ADVLIMIT,greatest(AF.ADVANCELINE+ MST.PP,0) PP, greatest(AF.ADVANCELINE+ MST.PP - AF.MRCRLIMIT,0) PP_TDAMT ,AF.ADVANCELINE+ MST.AVLLIMIT AVLLIMIT,
                        MST.NAVACCOUNT,AF.ADVANCELINE+ MST.OUTSTANDING OUTSTANDING,
                        TRUNC(GREATEST((CASE WHEN mst.mstmrirate>0 THEN greatest(least(NAVACCOUNT*100/mst.mstmrirate + (OUTSTANDING),AVLLIMIT),0) ELSE NAVACCOUNT + OUTSTANDING END),0),0) AVLWITHDRAW,
                        round((case when MST.OUTSTANDING>=0 then 100000
                               else MST.NAVACCOUNT/ abs(MST.OUTSTANDING) end),4) * 100 MARGINRATE,
                        TRUNC((CASE WHEN mst.mstmrirate>0
                                --THEN GREATEST(LEAST((100* NAVACCOUNT + OUTSTANDING * mst.mstmrirate)/mst.mstmrirate,
                                -- HaiLT sua ct rut tien thuong theo y/c MR001
                                THEN GREATEST(LEAST(PP,
                                            nvl(adv.avladvance,0) +ci.balance - ci.trfbuyamt- ci.ovamt-ci.dueamt - ci.ramt-af.advanceline,
                                            AVLLIMIT),0)
                                 ELSE BALDEFOVD END),0) BALDEFOVD,  mst.DFDEBTAMT, mst.cidepofeeacr, mst.depofeeamt,ci.netting SENDING,
                        NVL(af.mrcrlimit,0) mrcrlimit, nvl(v_FOwithdraw,0) FOWITHDRAW, v_FOwithdrawPP FOWITHDRAWPP
                from
                (SELECT V_ACCTNO afacctno,sum((ci.ramt - ci.aamt)) cipamt, sum(af.tradeline) tradeline , sum(TRUNC (ci.balance)-nvl(b.secureamt,0)) balance,
                                    sum(greatest(trunc (ci.balance)-nvl(b.secureamt,0),0) + CI.emkamt) intbalance,sum(ci.DFDEBTAMT)  DFDEBTAMT,
                                    sum(ci.cramt) cramt, sum(ci.dramt) dramt, sum(ci.avrbal) avrbal, sum(ci.mdebit) mdebit, sum(ci.mcredit) mcredit,
                                   sum(ci.crintacr) crintacr, sum(ci.odintacr) odintacr, sum(ci.adintacr) adintacr, sum(ci.minbal) minbal, sum(nvl(adv.aamt,0)) aamt,
                                   sum(ci.ramt) ramt, sum(nvl(b.secureamt,0)) bamt, sum(ci.emkamt) emkamt, sum(ci.odlimit) odlimit, sum(ci.mmarginbal) mmarginbal,
                                   sum(ci.marginbal) marginbal, sum(ci.odamt) odamt, sum(nvl(adv.avladvance,0)) receiving, sum(ci.mblock) mblock,
                                   sum(nvl(adv.advanceamount,0)) apmt,sum(nvl(adv.paidamt,0)) paidamt,
                                   sum(NVL (af.mrcrlimitmax, 0)) ADVLIMIT,
                                   sum(nvl(adv.avladvance,0) + ci.balance - ci.trfbuyamt - nvl(b.secureamt,0) - ci.odamt- ci.dfdebtamt - ci.dfintdebtamt - NVL (b.advamt, 0)) avlwithdraw ,
                                   greatest(SUM(nvl(adv.avladvance,0) + balance - ci.trfbuyamt- ovamt-dueamt - ci.dfdebtamt - ci.dfintdebtamt- ramt - ci.depofeeamt),0) baldefovd,
                                   least(sum(nvl(af.mrcrlimit,0) + nvl(se.seamt,0))
                                        ,sum(greatest(nvl(af.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)-ci.dfodamt,0)))
                                   + sum(ci.balance + nvl(adv.avladvance,0) - nvl(trfsecuredamt,0) - nvl(trft0addamt,0) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt- nvl (b.advamt, 0)-nvl(b.secureamt,0) - ci.ramt-ci.depofeeamt) pp,
                                   sum(nvl(adv.avladvance,0) + nvl(af.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)-ci.dfodamt + ci.balance + af.advanceline - nvl(trft0amt,0) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt- nvl (b.overamt, 0)-nvl(b.secureamt,0) - ci.ramt - ci.depofeeamt) avllimit,
                                   sum(/*nvl(af.MRCRLIMIT,0) +*/  nvl(se.SEASS,0))  NAVACCOUNT,
                                   sum(ci.balance+least(nvl(af.mrcrlimit,0),nvl(b.secureamt,0) +ci.trfbuyamt) - ci.trfbuyamt+ nvl(adv.avladvance,0)- ci.odamt - ci.dfdebtamt - ci.dfintdebtamt- NVL (b.advamt, 0)-nvl(b.secureamt,0) - ci.ramt) OUTSTANDING,
                                   sum(case when af.acctno <> v_groupleader then 0 else af.mrirate end) mstmrirate,
                                   sum(ci.cidepofeeacr) cidepofeeacr, sum(ci.depofeeamt) depofeeamt
                               FROM cimast ci inner join afmast af on af.acctno = ci.afacctno AND af.groupleader=v_groupleader
                                   left join
                                   (select b.* from v_getbuyorderinfo  b, afmast af where b.afacctno =af.acctno and af.groupleader=v_groupleader) b
                                    on ci.acctno = b.afacctno
                                   LEFT JOIN
                                   (select b.* from v_getsecmargininfo b, afmast af where b.afacctno =af.acctno and af.groupleader=v_groupleader) se
                                   on se.afacctno=ci.acctno
                                   LEFT JOIN
                                   (select sum(aamt) aamt,sum(depoamt) avladvance, sum(advamt) advanceamount ,afacctno, sum(paidamt) paidamt from v_getAccountAvlAdvance b, afmast af where b.afacctno =af.acctno and af.groupleader = v_groupleader group by b.afacctno) adv
                                   on adv.afacctno=ci.acctno
                ) MST, afmast af, cfmast cf,cimast ci,
                                   sbcurrency ccy ,
                                    allcode cd1,
                  (select * from v_getdealpaidbyaccount p where p.afacctno = V_ACCTNO) pd,
                  (select depoamt avladvance,afacctno from v_getAccountAvlAdvance where afacctno = V_ACCTNO ) adv


                where mst.afacctno =af.acctno and af.custid=cf.custid
                and mst.afacctno=pd.afacctno(+)
                and mst.afacctno=ci.afacctno and ccy.ccycd = ci.ccycd
                and cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS'
                and ci.status = cd1.cdval
                and adv.afacctno(+)=MST.afacctno) dt;
            end if;

        end if;
elsif V_TABLENAME = 'SEMAST' then
    --Tai khoan binh thuong khong Margin
    -- DUcnv them SENDDEPOSIT : chung khoan gui luu ky
    OPEN PV_REFCURSOR FOR
      SELECT MST.ACTYPE, CF.CUSTODYCD, MST.ACCTNO, MST.AFACCTNO, MST.LASTDATE, MST.CODEID, MST.IRCD, MST.STATUS, MST.COSTPRICE, MST.TRADE-NVL(B.SECUREAMT,0) TRADE,
             MST.WTRADE, MST.MORTAGE-NVL(B.SECUREMTG,0) MORTAGE , MST.MARGIN, MST.NETTING, MST.STANDING,NVL(B.SECUREAMT,0)+NVL(B.SECUREMTG,0) SECURED,
             MST.WITHDRAW, MST.BLOCKED, MST.DEPOSIT, MST.LOAN,MST.PREVQTTY,MST.DTOCLOSE,MST.SDTOCLOSE,MST.DCRQTTY,MST.DCRAMT,MST.DEPOFEEACR,
             MST.RECEIVING, CCY.SYMBOL, CCY.PARVALUE,SE_INF.PREVCLOSEPRICE PRICE, CD1.CDCONTENT DESC_STATUS, B.sereceiving AVLRECEIVING,
             GREATEST(MST.TRADE-NVL(B.SECUREAMT,0)+NVL(B.sereceiving,0),0) AVLTRADING,
             (MST.MORTAGE - NVL(B.SECUREMTG,0) + MST.STANDING) MORADDSTAND, ABS(STANDING) ABSTANDING,
             MST.SENDDEPOSIT
          FROM AFMAST AF, SEMAST MST, CFMAST CF, SBSECURITIES CCY, SECURITIES_INFO SE_INF, ALLCODE CD1, v_getsellorderinfo B
          WHERE AF.ACCTNO = MST.AFACCTNO AND AF.CUSTID= CF.CUSTID AND MST.ACCTNO=B.SEACCTNO(+)
           AND CCY.CODEID=MST.CODEID AND MST.ACCTNO = V_ACCTNO
               AND TRIM(CD1.CDTYPE) = 'SE' AND SE_INF.CODEID=CCY.CODEID
           AND TRIM(CD1.CDNAME)='STATUS' AND TRIM(MST.STATUS) = TRIM(CD1.CDVAL);
ELSIF V_TABLENAME = 'CFMAST' THEN
  OPEN PV_REFCURSOR FOR
      SELECT MST.ACTYPE, MST.ACCTNO, MST.AFTYPE, MST.PIN, MST.CIACCTNO,MST.TRADEPHONE, MST.IFRULECD,MST.CFTELELIMIT,
             MST.CFONLINELIMIT,NVL(MST.FEEBASE,0) FEEBASE, MST.MARGINLINE, MST.TRADELINE, MST.ADVANCELINE, MST.REPOLINE,
             MST.DEPOSITLINE, MST.BRATIO,MST.TRADERATE,MST.DEPORATE,MST.MISCRATE, MST.TERMOFUSE,MST.CONSULTANT,MST.PHONE1,
             MST.TRADEFLOOR,MST.TRADEONLINE, MST.LANGUAGE,CF.IDCODE, MST.STATUS, MST.LASTDATE, ROUND((ROUND(CRINTACR,0) + ROUND(BALANCE,0) -ROUND(ODINTACR,0)-ROUND(ODAMT,0)),0) CIWITHDRAWAL,
             MST.DESCRIPTION,ROUND(CI.CRINTACR,0) CRINTACR,ROUND(CI.BALANCE,0) BALANCE,ROUND(CI.ODINTACR,0) ODINTACR,ROUND(CI.ODAMT,0) ODAMT,
             CF.FULLNAME, CF.ADDRESS,CF.EMAIL, CF.IDCODE LICENSE, CD1.CDCONTENT DESC_TERMOFUSE, CD2.CDCONTENT DESC_LANGUAGE, CD3.CDCONTENT DESC_STATUS,
             CD4.CDCONTENT DESC_AFTYPE
      FROM CFMAST CF, AFMAST MST,CIMAST CI, ALLCODE CD1, ALLCODE CD2, ALLCODE CD3, ALLCODE CD4
      WHERE CF.CUSTID = MST.CUSTID AND MST.ACCTNO = V_ACCTNO
      AND CD1.CDTYPE = 'CF' AND CD1.CDNAME='TERMOFUSE' AND MST.TERMOFUSE = CD1.CDVAL
      AND CD2.CDTYPE(+) = 'CF' AND CD2.CDNAME(+)='LANGUAGE' AND MST.LANGUAGE = CD2.CDVAL(+)
      AND CD3.CDTYPE = 'CF' AND CD3.CDNAME='STATUS' AND MST.STATUS = CD3.CDVAL
      AND CD4.CDTYPE = 'CF' AND CD4.CDNAME='AFTYPE' AND MST.AFTYPE = CD4.CDVAL AND CI.ACCTNO=MST.ACCTNO;
ELSIF V_TABLENAME = 'GLMAST' THEN
  OPEN PV_REFCURSOR FOR
      SELECT MST.GLBANK, MST.ACCTNO, MST.CCYCD, MST.SUBCD, MST.ACNAME, MST.BALANCE, MST.AVGBAL, MST.YEARBAL, MST.INTRATE,
             MST.DDR, MST.DCR,  MST.MDR, MST.MCR, MST.YDR, MST.YCR, MST.DTXCOUNT, MST.YTXCOUNT, CCY.SHORTCD, MST.LSTDATE,
             case when MST.BALANCE >=0 then MST.BALANCE else 0 end CREDIT_BAL,
             case when MST.BALANCE < 0 then abs(MST.BALANCE) else 0 end DEBIT_BAL
      FROM GLMAST MST, SBCURRENCY CCY
      WHERE CCY.CCYCD=MST.CCYCD AND MST.ACCTNO = V_ACCTNO;
ELSIF V_TABLENAME = 'LNMAST' THEN
  OPEN PV_REFCURSOR FOR
    SELECT MST.ACTYPE, MST.ACCTNO, A.CDCONTENT LNTYPE, MST.TRFACCTNO, CF.FULLNAME,
            NVL(SCHD.NML,0) PRINNML, MST.PRINNML-NVL(SCHD.NML,0) PRINDUE, MST.PRINOVD, PRINPAID,
            NVL(SCHD_T0.NML,0) T0PRINNML, MST.OPRINNML-NVL(SCHD_T0.NML,0) T0PRINDUE, MST.OPRINOVD T0PRINOVD, OPRINPAID T0PRINPAID,
            INTNMLACR + OINTNMLACR INTNMLACR, INTDUE+OINTDUE INTDUE, INTNMLOVD+OINTNMLOVD INTNMLOVD, INTOVDACR+OINTOVDACR INTOVDACR, INTPAID+OINTPAID INTPAID,
            FEE + FEEDUE + FEEOVD + FEEPAID FEEAMT, FEE, FEEDUE, FEEOVD, FEEPAID
            FROM LNMAST MST, CIMAST CI, CFMAST CF, ALLCODE A,
            (SELECT ACCTNO, SUM(NML) NML FROM LNSCHD WHERE REFTYPE = 'P' AND OVERDUEDATE = v_INDATE AND NML > 0
            GROUP BY ACCTNO) SCHD,
            (SELECT ACCTNO, SUM(NML) NML FROM LNSCHD WHERE REFTYPE = 'GP' AND OVERDUEDATE = v_INDATE AND NML > 0
            GROUP BY ACCTNO) SCHD_T0
            WHERE CI.acctno = MST.trfacctno AND CI.custid = CF.CUSTID AND MST.ACCTNO = SCHD.ACCTNO(+) AND MST.ACCTNO = SCHD_T0.ACCTNO(+)
            AND A.CDNAME = 'LNTYPE' AND A.CDVAL = MST.LNTYPE AND MST.ACCTNO = V_ACCTNO;
end if;
   EXCEPTION
    WHEN others THEN
        return;
END;
/
