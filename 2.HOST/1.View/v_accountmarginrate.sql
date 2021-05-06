CREATE OR REPLACE FORCE VIEW V_ACCOUNTMARGINRATE
(custodycd, groupleader, fullname, actype, acctno, custid, afacctno, ccycd, lastdate, email, mobile, phone1, address, cipamt, balance, cramt, dramt, avrbal, mdebit, mcredit, crintacr, odintacr, adintacr, minbal, aamt, ramt, bamt, emkamt, odlimit, mmarginbal, marginbal, odamt, receiving, mblock, desc_status, apmt, advlimit, mrcrlimitmax, mrcrlimit, mrclamt, mrirate, mrmrate, mrlrate, mriratio, mrmratio, mrlratio, ovamt, dueamt, pp, avllimit, navaccount, outstanding, marginrate, rlsmarginrate, avlwithdraw, baldefovd, baldeftrfamt, gocth, laith, gocqh, laiqh, not0, lait0, not0qh, lait0qh, marginratio, mraddvnd, addvnd, serealass, triggerdate, chksysctrl, seass, totalvnd, advanceline, trft0amt, trfsecuredamt, status, buyfeeacr, buyamt, secureamt, trfbuyrate, typename)
AS
(
SELECT custodycd,GROUPLEADER,FULLNAME,ACTYPE,ACCTNO,CUSTID,AFACCTNO,CCYCD,LASTDATE,EMAIL,MOBILE,PHONE1,ADDRESS,CIPAMT,
BALANCE,CRAMT,DRAMT,AVRBAL,MDEBIT,MCREDIT,CRINTACR,ODINTACR,ADINTACR,MINBAL,AAMT,RAMT,
BAMT,EMKAMT,ODLIMIT,MMARGINBAL,MARGINBAL,ODAMT,RECEIVING,MBLOCK,DESC_STATUS,APMT,
ADVLIMIT,case when ismarginacc = 'Y' then least(to_number(sy_MaxCf.varvalue),MRCRLIMITMAX) else MRCRLIMITMAX end MRCRLIMITMAX,MRCRLIMIT,MRCLAMT,MRIRATE,MRMRATE,MRLRATE,MRIRATIO,MRMRATIO,MRLRATIO,OVAMT,DUEAMT,PP,
AVLLIMIT,NAVACCOUNT,OUTSTANDING,MARGINRATE,RLSMARGINRATE,
TRUNC(GREATEST((CASE WHEN MRIRATE>0 THEN least(NAVACCOUNT*100/MRIRATE + OUTSTANDING,AVLLIMIT-ADVLIMIT) ELSE NAVACCOUNT + OUTSTANDING END),0),0) AVLWITHDRAW,
greatest(TRUNC(
        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNT + (OUTSTANDING-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
        - DEALPAIDAMT
    ,0),0) BALDEFOVD,
greatest(TRUNC(
        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNT + (OUTSTANDINGT2-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFTRFAMT,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFTRFAMT END)
        - DEALPAIDAMT
    ,0),0) BALDEFTRFAMT,
NVL(GOCTH,0) GOCTH, NVL(LAITH,0) LAITH, NVL(GOCQH,0) GOCQH, NVL(LAIQH,0) LAIQH, NVL(NOT0,0) NOT0, NVL(LAIT0,0) LAIT0,NVL(NOT0QH,0) NOT0QH, NVL(LAIT0QH,0) LAIT0QH,
MARGINRATIO,MRADDVND,ADDVND,SEREALASS, triggerdate, ismarginacc CHKSYSCTRL, SEASS,TOTALVND, ADVANCELINE, TRFT0AMT, trfsecuredamt, afstatus,
buyfeeacr, buyamt,secureamt, trfbuyrate, typename
FROM
(SELECT mst.groupleader,mst.fullname, mst.custodycd, aftype actype, mst.acctno,mst.custid, mst.afacctno, mst.ccycd, mst.lastdate,
            mst.email,mst.mobile,mst.phone1,mst.address,
           (mst.ramt - mst.aamt) cipamt,  TRUNC (mst.balance)-nvl(se.secureamt,0) balance,
           mst.cramt, mst.dramt, mst.avrbal, mst.mdebit, mst.mcredit,
           mst.crintacr, mst.odintacr, mst.adintacr, mst.minbal, mst.aamt,
           mst.ramt, nvl(se.secureamt,0) bamt, mst.emkamt, mst.odlimit, mst.mmarginbal,
           mst.marginbal, mst.odamt, nvl(se.avladvance,0) receiving, mst.mblock,
           mst.desc_status, NVL (se.avladvance, 0) apmt,
           mst.advanceline advlimit,
           nvl(mst.mrcrlimitmax,0) mrcrlimitmax,mst.MRCRLIMIT,mst.MRCLAMT,
           mst.mrirate,mst.mrmrate,mst.mrlrate,mst.mriratio,mst.mrmratio,mst.mrlratio,mst.ovamt,mst.dueamt,
           mst.balance - nvl(se.secureamt,0) - mst.odamt - NVL (se.advamt, 0) avlwithdraw ,
           nvl(mst.balance + nvl(se.avladvance,0) - nvl(se.overamt,0) + nvl(se.secureamt,0) - mst.odamt - mst.dfdebtamt - mst.dfintdebtamt,0) baldefodamt,
           greatest(
                    nvl(se.avladvance,0) + balance + nvl(se.trfbuyamt_over,0) - mst.ovamt - mst.dueamt - mst.dfdebtamt - mst.dfintdebtamt - ramt - nvl(se.dealpaidamt,0) - mst.depofeeamt
                        - greatest(nvl(se.overamt,0) + nvl(se.secureamt,0) + nvl(se.trfbuyamt_in,0) + least(nvl(OVDAF.NMLMARGINAMT,0) - least(nvl(se.mrcrlimitmax,0) - dfodamt, least(mrcrlimit, nvl(se.secureamt,0)+nvl(se.trfbuyamt_in,0)) + nvl(se.seamt,0)),0),0)
                ,0) baldefovd,
            greatest(
                nvl(se.avladvance,0) + balance - ovamt - dueamt - mst.dfdebtamt - mst.dfintdebtamt - ramt-nvl(se.dealpaidamt,0) - mst.depofeeamt
                - greatest(0, nvl(se.buyamt,0) + nvl(se.buyfeeacr,0) - least(mst.trfbuyrate/100* nvl(se.buyamt,0) + nvl(se.execbuyamtfee,0), mst.advanceline - nvl(se.trft0amt,0) )
                            + mst.trfbuyamt - nvl(se.trft0amt,0)
                            + nvl(se.trft0addamt,0)
                            + nvl(ovdaf.nmlmarginamt,0)
                            - least(nvl(se.mrcrlimitmax,0) - dfodamt, /*mrcrlimit +*/ nvl(se.seamt,0)) )
                ,0) baldeftrfamt,
           case when isdefaultMargin = 'Y' then
                 least(
                 round(mst.balance - (nvl(se.buyamt,0) * (100-mst.trfbuyrate)/100  + (case when mst.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                     - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + nvl(se.avladvance,0) + least(nvl(se.mrcrlimitmax,0)+ nvl(mst.mrcrlimit,0)  - dfodamt,nvl(mst.mrcrlimit,0) + nvl(se.semramt,0)) - nvl(mst.odamt,0) - mst.dfdebtamt - mst.dfintdebtamt - ramt - mst.depofeeamt,0),
                 round(mst.balance - (nvl(se.buyamt,0) * (100-mst.trfbuyrate)/100  + (case when mst.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                     - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + nvl(se.avladvance,0) + least(nvl(se.mrcrlimitmax,0)+nvl(mst.mrcrlimit,0)  - dfodamt,nvl(mst.mrcrlimit,0)  + nvl(se.seamt,0)) - nvl(mst.odamt,0) - mst.dfdebtamt - mst.dfintdebtamt - ramt  - mst.depofeeamt,0)
                 )
           else
                 round(mst.balance - (nvl(se.buyamt,0) * (100-mst.trfbuyrate)/100  + (case when mst.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                     - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + nvl(se.avladvance,0) + least(nvl(se.mrcrlimitmax,0) +nvl(mst.mrcrlimit,0)- dfodamt,nvl(mst.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(mst.odamt,0) - mst.dfdebtamt - mst.dfintdebtamt - ramt  - mst.depofeeamt,0)
           end pp,
           nvl(se.avladvance,0) + nvl(mst.advanceline,0) - nvl(trft0amt,0) + nvl(mst.mrcrlimitmax,0)+nvl(mst.mrcrlimit,0)- dfodamt + balance- odamt - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - nvl(secureamt,0) - ramt - nvl(depofeeamt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) avllimit,
           /*nvl(mst.MRCRLIMIT,0) +*/ nvl(se.SECALLASS,0)  NAVACCOUNT,
           nvl(mst.advanceline,0) + mst.balance+least(nvl(mst.mrcrlimit,0),nvl(se.secureamt,0)) - trfbuyamt + nvl(se.avladvance,0)- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt - mst.depofeeamt - NVL (se.advamt, 0)-nvl(se.secureamt,0) - mst.ramt OUTSTANDING,
           nvl(mst.advanceline,0) + mst.balance +least(nvl(mst.mrcrlimit,0), greatest(nvl(se.buyamt,0) + nvl(se.buyfeeacr,0) - least(mst.trfbuyrate/100* nvl(se.buyamt,0) + nvl(se.buyfeeacr,0), mst.advanceline - nvl(se.trft0amt,0) ),0) )
              - trfbuyamt + nvl(se.avladvance,0)- mst.odamt - mst.dfdebtamt - mst.dfintdebtamt - mst.depofeeamt - mst.ramt
                                - greatest(nvl(se.buyamt,0) + nvl(se.buyfeeacr,0) - least(mst.trfbuyrate/100* nvl(se.buyamt,0) + nvl(se.buyfeeacr,0), mst.advanceline - nvl(se.trft0amt,0) ),0) OUTSTANDINGT2,
           nvl(se.MARGINRATE,0) MARGINRATE,
           nvl(se.RLSMARGINRATE,0) RLSMARGINRATE,
           nvl(se.MARGINRATIO,0) MARGINRATIO,
           greatest((mst.MRMRATIO/100 - SE.MARGINRATIO/100) * (SE.serealass + greatest(SE.OUTSTANDING,0)),0)  MRADDVND,
           greatest(round((case when nvl(se.MARGINRATE,0) * MRMRATE =0 then OUTSTANDING else
                     greatest( 0,- OUTSTANDING - NAVACCOUNT *100/MRMRATE) end),0),0) ADDVND,
           NVL(OVDAF.GOCTH,0) GOCTH, OVDAF.LAITH, OVDAF.GOCQH, OVDAF.LAIQH, OVDAF.NOT0, OVDAF.LAIT0, OVDAF.NOT0QH, OVDAF.LAIT0QH, se.SEREALASS, mst.debitifdebt, mst.triggerdate,
           nvl(DEALPAIDAMT,0) DEALPAIDAMT, nvl(trft0amt,0) trft0amt, ADVANCELINE, nvl(ismarginacc,'N') ismarginacc, nvl(se.SEASS,0) SEASS,
           mst.balance + nvl(se.avladvance,0) TOTALVND, nvl(trfsecuredamt,0) trfsecuredamt, mst.afstatus,
           nvl(buyfeeacr,0) buyfeeacr, nvl(buyamt,0) buyamt,nvl(secureamt,0) secureamt, mst.trfbuyrate, typename
      FROM
      (select mst.*,aft.typename, cf.custodycd,cd1.cdcontent desc_status,af.advanceline,af.mrirate,af.mrmrate,af.mrlrate,af.mriratio,af.mrmratio,af.mrlratio,cf.fullname,
            af.MRCRLIMIT,af.MRCLAMT,af.MRCRLIMITMAX,af.actype aftype,
            CF.email,CF.mobile,cf.phone phone1,CF.address,af.groupleader, aft.debitifdebt, af.triggerdate, nvl(lnt.chksysctrl,'N') isdefaultMargin,
            af.trfbuyrate, af.status afstatus
        from cimast mst,afmast af,cfmast cf, aftype aft, mrtype mrt,allcode cd1, lntype lnt
      where af.actype=aft.actype and aft.mrtype =mrt.actype and mrt.mrtype IN ('S','T') and af.acctno = mst.afacctno  and af.custid=cf.custid
      and aft.lntype = lnt.actype(+)
      and cd1.cdtype = 'CI' AND cd1.cdname = 'STATUS' and mst.status = cd1.cdval) mst
      left join v_getsecmarginratio se
            on mst.acctno = se.afacctno
      LEFT JOIN
             (select TRFACCTNO, nvl(sum(ln.PRINOVD + ln.INTOVDACR + ln.INTNMLOVD + ln.OPRINOVD + ln.OPRINNML + ln.OINTNMLOVD + ln.OINTOVDACR+ln.OINTDUE+ln.OINTNMLACR + nvl(lns.nml,0) + nvl(lns.intdue,0)),0) OVDAMT,
                                       nvl(sum(ln.PRINNML - nvl(lns.nml,0) + ln.INTNMLACR),0) NMLMARGINAMT,
                        ROUND(SUM(ln.PRINNML),0) GOCTH, ROUND(SUM(ln.PRINOVD),0) GOCQH, ROUND(SUM(ln.INTOVDACR + ln.INTNMLOVD),0) LAIQH, ROUND(SUM(ln.INTNMLACR + ln.INTDUE),0) LAITH,
                        ROUND(SUM(OPRINOVD + OPRINNML),0) NOT0, ROUND(SUM(OINTNMLOVD + OINTOVDACR+OINTDUE+OINTNMLACR),0) LAIT0, ROUND(SUM(OPRINOVD),0) NOT0QH, ROUND(SUM(OINTNMLOVD + OINTOVDACR+OINTDUE),0) LAIT0QH
                    from lnmast ln, (select acctno, sum(nml) nml, sum(intdue) intdue  from lnschd, sysvar sy_Date
                                        where sy_date.varname = 'CURRDATE' and sy_date.grname = 'SYSTEM' and reftype = 'P' and overduedate = to_date(sy_date.varvalue,'DD/MM/RRRR') group by acctno) lns
                    where ln.acctno = lns.acctno(+) and ln.ftype = 'AF'
                    group by ln.trfacctno) OVDAF
           ON OVDAF.TRFACCTNO = MST.ACCTNO
      left join
            (select acctno, 'Y' ismarginacc from afmast af
                where exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y'
                                union all
                                select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y')
                group by acctno) ismr
           ON ismr.ACCTNO = MST.ACCTNO
      ), sysvar sy_MaxCf where varname = 'MAXDEBTCF' and grname = 'MARGIN'
);

