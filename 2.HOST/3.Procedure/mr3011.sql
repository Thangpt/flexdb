CREATE OR REPLACE PROCEDURE MR3011 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   p_OPT                    IN       VARCHAR2,
   p_BRID                   IN       VARCHAR2,
   p_TO_DATE                 IN       VARCHAR2
  )
IS

--
-- BAO CAO DANH MUC CHUNG KHOAN THUC HIEN GIAO DICH KI QUY
-- MODIFICATION HISTORY
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- QUOCTA      17-02-2012           CREATED
--


   l_OPT varchar2(10);
   l_BRID varchar2(1000);
   l_BRID_FILTER varchar2(1000);
   l_ToDate                 DATE;
   l_CurrDate               DATE;

   l_COUNTMRACC_BG          NUMBER(20,0);
   l_COUNTMRACC_END         NUMBER(20,0);
   l_MAXDEBT_BG                NUMBER(20,0);
   l_MAXDEBT_END                NUMBER(20,0);

   l_ODAMT_BG               NUMBER(20,0);
   l_ODAMT_END              NUMBER(20,0);

   l_SEREALASS_BG              NUMBER(20,0);
   l_SEREALASS_END              NUMBER(20,0);

   l_INTAMT_BG              NUMBER(20,0);
   l_INTAMT_END             NUMBER(20,0);

   l_FEEAMT_BG              NUMBER(20,0);
   l_FEEAMT_END             NUMBER(20,0);

   l_TOP5SYMBOL_BG             varchar2(30);
   l_TOP5SYMBOL_END             varchar2(30);


BEGIN



    l_OPT:=p_OPT;

    IF (l_OPT = 'A') THEN
      l_BRID_FILTER := '%';
    ELSE if (l_OPT = 'B') then
            select brgrp.mapid into l_BRID_FILTER from brgrp where brgrp.brid = p_BRID;
        else
            l_BRID_FILTER := p_BRID;
        end if;
    END IF;
    l_ToDate:= to_date(p_TO_DATE,SYSTEMNUMS.C_DATE_FORMAT);


  --- LAY NGAY HE THONG
  SELECT TO_DATE(VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
  INTO   l_CurrDate
  FROM   SYSVAR
  WHERE  grname = 'SYSTEM' AND varname = 'CURRDATE';


OPEN PV_REFCURSOR FOR
select * from (
    select custodycd, max('AF') ftype, sum(prinamt) prinamt, sum(paidamt) paidamt, sum(REREALASS) REREALASS from
    (
    SELECT cf.custodycd, af.acctno,
        nvl(sum(ln.prinnml + ln.prinovd + ln.prinpaid),0) - nvl(max(nvl(PRIN_TO_CR,0)),0) - nvl(max(nvl(PAID_TO_CR,0)),0) prinamt,
        nvl(sum(ln.prinpaid),0) - nvl(max(nvl(PAID_TO_CR,0)),0) paidamt,
        nvl(max(ts.prinused),0) + nvl(max(nvl(ci.BALANCE,0)),0) + nvl(max(nvl(adv.AVLADVANCE,0)),0) REREALASS

    FROM vw_lnmast_all LN, lntype lnt, afmast af, cfmast cf,
      (SELECT ln.trfacctno, NVL(SUM(CASE WHEN APP.TXTYPE = 'D' THEN -LNTR.NAMT ELSE LNTR.NAMT END), 0) PRIN_TO_CR
      FROM  VW_LNTRAN_ALL LNTR, APPTX APP, VW_LNMAST_ALL LN, AFMAST AF, AFTYPE AFT, MRTYPE MRT, LNTYPE LNT
      WHERE   LNTR.TXCD = APP.TXCD
          AND APP.APPTYPE = 'LN'
          AND APP.FIELD IN ('PRINNML','PRINOVD')
          AND APP.TXTYPE IN ('C','D')
          AND LNTR.ACCTNO = LN.ACCTNO
          AND LN.FTYPE = 'AF'
          AND LN.TRFACCTNO = AF.ACCTNO
          AND AF.ACTYPE    = AFT.ACTYPE
          AND AFT.MRTYPE   = MRT.ACTYPE
          AND MRT.MRTYPE   = 'T'
          AND LN.ACTYPE   = LNT.ACTYPE
          AND LNTR.NAMT <> 0
          AND LNTR.DELTD <> 'Y'
          AND LNTR.BKDATE > l_ToDate
      group by ln.trfacctno) prinmov,
      (SELECT ln.trfacctno, NVL(SUM(CASE WHEN APP.TXTYPE = 'D' THEN -LNTR.NAMT ELSE LNTR.NAMT END), 0) PAID_TO_CR
      FROM  VW_LNTRAN_ALL LNTR, APPTX APP, VW_LNMAST_ALL LN, AFMAST AF, AFTYPE AFT, MRTYPE MRT, LNTYPE LNT
      WHERE   LNTR.TXCD = APP.TXCD
          AND APP.APPTYPE = 'LN'
          AND APP.FIELD IN ('PRINPAID')
          AND APP.TXTYPE IN ('C','D')
          AND LNTR.ACCTNO = LN.ACCTNO
          AND LN.FTYPE = 'AF'
          AND LN.TRFACCTNO = AF.ACCTNO
          AND AF.ACTYPE    = AFT.ACTYPE
          AND AFT.MRTYPE   = MRT.ACTYPE
          AND MRT.MRTYPE   = 'T'
          AND LN.ACTYPE   = LNT.ACTYPE
          AND LNTR.NAMT <> 0
          AND LNTR.DELTD <> 'Y'
          AND LNTR.BKDATE > l_ToDate
      group by ln.trfacctno) paidmov,
      (select af.acctno, nvl(sum(prinused * least(sec0.marginprice,rsk.mrpriceloan)),0)   prinused
               from afmast af,
               (
                   select codeid,afacctno, sum(prinused) prinused
                   from (
                       select * from afpralloc where txdate <= l_ToDate and restype = 'S'
                       union all
                       select * from afprallochist where txdate <= l_ToDate and restype = 'S'
                   ) group by codeid, afacctno
               ) pr,
               (select * from securities_info_hist where histdate = (select max(histdate) from securities_info_hist where histdate <= l_ToDate)) sec0,
               (select * from afseriskhist
                            where to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR') = (select max(to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR')) from afseriskhist where to_date(substr(BACKUPDT,1,10),'DD/MM/RRRR') <= l_ToDate)) rsk
           where pr.codeid =  sec0.codeid
               and pr.afacctno = af.acctno
               and af.actype = rsk.actype
               and rsk.codeid = sec0.codeid
        group by af.acctno) ts,
        (select ci.acctno, ci.balance - nvl(tr.balance,0) balance
            from cimast ci,
            (select tr.acctno, sum(decode(tx.txtype, 'D', -namt, namt)) balance
                from vw_citran_all tr, apptx tx
                where tr.txcd = tx.txcd and tr.deltd <> 'Y'
                and tx.apptype = 'CI' and tx.field = 'BALANCE'
                and tr.txdate > l_ToDate
                group by tr.acctno) tr
            where ci.acctno = tr.acctno(+)) ci,
        (select acctno afacctno, round(nvl(sum(avladvance),0),0) avladvance
            from (
                select avl.acctno, avl.txdate, avl.cleardate, (nvl(avlamt,0) - nvl(advamt,0)) avladvance
                from
                    (select sts.acctno, sts.txdate, sts.cleardate, sum((sts.amt - od.feeacr) * (1 - (sts.cleardate - sts.txdate) * to_number(varvalue) / 100 / 360)) avlamt, sum(od.feeacr) feeamt from vw_stschd_all sts, vw_odmast_all od, sysvar syadv
                        where duetype = 'RM' and sts.deltd <> 'Y' and sts.txdate <= l_ToDate and sts.cleardate > l_ToDate
                            and sts.orgorderid = od.orderid and syadv.grname = 'SYSTEM' and syadv.varname = 'ADVSELLDUTY'
                        group by sts.acctno, sts.txdate, sts.cleardate) avl,
                    (select acctno, txdate, cleardt, sum(amt) advamt from vw_adschd_all
                        where txdate <= l_ToDate and cleardt > l_ToDate and deltd <> 'Y'
                        group by acctno, txdate, cleardt) adv
                where avl.acctno = adv.acctno and avl.txdate = adv.txdate and avl.cleardate = adv.cleardt
                )
            group by acctno) adv
    where ln.trfacctno = af.acctno and af.custid = cf.custid
    and ln.ftype = 'AF' and lnt.actype = ln.actype
    and af.acctno = prinmov.trfacctno(+)
    and af.acctno = paidmov.trfacctno(+)
    and af.acctno = ci.acctno(+)
    and af.acctno = adv.afacctno(+)
    and ln.trfacctno = ts.acctno(+)
    and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
    group by cf.custodycd, af.acctno
    having nvl(sum(ln.prinnml + ln.prinovd),0) - nvl(max(nvl(PRIN_TO_CR,0)),0) + nvl(max(ts.prinused),0) > 0
    )
    group by custodycd
union all
    select cf.custodycd, max('DF') ftype, sum(prinamt) prinamt, sum(paidamt) paidamt, sum(REREALASS) REREALASS
    from cfmast cf, afmast af,
      (select dg.afacctno,
        sum((ln.prinnml + ln.prinovd + ln.prinpaid) - nvl(PRIN_TO_CR,0) - nvl(PAID_TO_CR,0)) prinamt,
        sum(ln.prinpaid - nvl(PAID_TO_CR,0)) paidamt,
        sum(nvl(DFAMT,0)) REREALASS
        from (select dg.groupid, dg.afacctno, dg.lnacctno,
                sum(((DFQTTY+RCVQTTY+BLOCKQTTY+CARCVQTTY)-nvl(DFQTTY_TO_CR,0)) * sec.dfrefprice) DFAMT
                from dfgroup dg, dfmast df,
                    (SELECT df.acctno, NVL(SUM(CASE WHEN APP.TXTYPE = 'D' THEN -tr.NAMT ELSE tr.NAMT END), 0) DFQTTY_TO_CR
                      FROM  vw_dftran_all tr, APPTX APP, vw_dfmast_all df
                      WHERE   tr.TXCD = APP.TXCD
                          AND APP.APPTYPE = 'DF'
                          AND APP.FIELD IN ('DFQTTY','RCVQTTY','BLOCKQTTY','CARCVQTTY')
                          AND APP.TXTYPE IN ('C','D')
                          AND tr.ACCTNO = df.ACCTNO
                          AND tr.NAMT <> 0
                          AND tr.DELTD <> 'Y'
                          AND tr.BKDATE > l_ToDate
                      group by df.acctno) dfmov,
                    (select * from securities_info_hist
                        where histdate = (select max(histdate)
                                            from securities_info_hist
                                            where histdate <= l_ToDate)) sec
                where dg.groupid = df.groupid
                    and df.acctno = dfmov.acctno(+)
                    and df.codeid = sec.codeid
                group by dg.groupid, dg.afacctno, dg.lnacctno
            ) dg,
            lnmast ln,
            (SELECT ln.acctno, NVL(SUM(CASE WHEN APP.TXTYPE = 'D' THEN -LNTR.NAMT ELSE LNTR.NAMT END), 0) PRIN_TO_CR
              FROM  VW_LNTRAN_ALL LNTR, APPTX APP, VW_LNMAST_ALL LN
              WHERE   LNTR.TXCD = APP.TXCD
                  AND APP.APPTYPE = 'LN'
                  AND APP.FIELD IN ('PRINNML','PRINOVD')
                  AND APP.TXTYPE IN ('C','D')
                  AND LNTR.ACCTNO = LN.ACCTNO
                  AND LN.FTYPE = 'DF'
                  AND LNTR.NAMT <> 0
                  AND LNTR.DELTD <> 'Y'
                  AND LNTR.BKDATE > l_ToDate
              group by ln.acctno) prinmov,
              (SELECT ln.acctno, NVL(SUM(CASE WHEN APP.TXTYPE = 'D' THEN -LNTR.NAMT ELSE LNTR.NAMT END), 0) PAID_TO_CR
                  FROM  VW_LNTRAN_ALL LNTR, APPTX APP, VW_LNMAST_ALL LN
                  WHERE   LNTR.TXCD = APP.TXCD
                      AND APP.APPTYPE = 'LN'
                      AND APP.FIELD IN ('PRINPAID')
                      AND APP.TXTYPE IN ('C','D')
                      AND LNTR.ACCTNO = LN.ACCTNO
                      AND LN.FTYPE = 'DF'
                      AND LNTR.NAMT <> 0
                      AND LNTR.DELTD <> 'Y'
                      AND LNTR.BKDATE > l_ToDate
                  group by ln.acctno) paidmov
        where dg.lnacctno = ln.acctno
            and ln.acctno = prinmov.acctno(+)
            and ln.acctno = paidmov.acctno(+)
        group by dg.afacctno) df
    where cf.custid = af.custid and af.acctno = df.afacctno
    and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
    group by cf.custodycd
)
order by ftype,custodycd;


EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
/

