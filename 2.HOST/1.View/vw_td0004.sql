CREATE OR REPLACE FORCE VIEW VW_TD0004 AS
(
SELECT td.txdate, td.tltxcd, td.acctno, td.afacctno, td.fullname,
    td.actype, td.msgamt, td.frdate, td.todate,
    td.intrate, td.NAMT, td.INTAVLAMT, TD.intamt, /*TD.grpname,*/ td.cdcontent,td.buyingpower,
    td.custodycd
 FROM
(
      select td.txdate, td.tltxcd, td.acctno, td.afacctno, td.fullname,
          td.actype, td.msgamt, td.frdate, td.todate,
          (case when td.schdtype = 'F' then td.intrate else nvl(TDMSTSCHM.intrate,td.intrate) end) intrate,
          0 NAMT, td.INTAVLAMT, 0 intamt, /*td.grpname,*/ td.cdcontent,td.buyingpower,
          td.custodycd
      from
      (
          select tl.txdate, tl.tltxcd, TD.acctno, td.afacctno, cf.fullname,
              td.actype, tl.msgamt, td.frdate, td.todate, td.intrate,
              fn_tdmastintratio(td.acctno,td.todate,td.balance) INTAVLAMT, td.tdterm,
              td.orgamt, td.schdtype, tl.txdesc, /*nvl(tl.grpname,'')  grpname,*/ td.tdterm || '' || al.cdcontent cdcontent,
              a3.cdcontent buyingpower,cf.custodycd
          from
              (
              SELECT * FROM TLLOG WHERE TLTXCD = '1670'
              UNION ALL
              SELECT * FROM TLLOGALL WHERE TLTXCD = '1670'
              ) TL,
             (
             /* select txdate, txnum, acctno, afacctno, actype, orgamt, balance, opndate,
                  frdate, todate, intrate, tdterm, schdtype, termcd,buyingpower
              from tdmasthist
              union all*/
              select txdate, txnum, acctno, afacctno, actype, orgamt, balance, opndate,
                  frdate, todate, intrate, tdterm, schdtype, termcd,buyingpower
              from tdmast
          ) TD, afmast af, cfmast cf, allcode al,allcode a3
          where tl.txnum = td.txnum
              and tl.txdate = td.txdate
              and td.afacctno = af.acctno
              and af.custid = cf.custid
             /* and cf.CAREBY = tl.grpid(+)*/
              and al.cdtype = 'TD' and al.cdname = 'TERMCD'
              and td.termcd = al.cdval
             /* AND CF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = '<$TELLERID>')*/
              AND A3.CDTYPE='SY' AND A3.CDNAME='YESNO' AND TD.BUYINGPOWER=A3.CDVAL
              order BY td.txdate,td.txnum

      ) td
      left join
      TDMSTSCHM
      on td.acctno = TDMSTSCHM.acctno(+)
          and td.orgamt >= TDMSTSCHM.framt(+)
          and td.orgamt < TDMSTSCHM.toamt(+)
          and td.tdterm >= TDMSTSCHM.FRTERM(+)
          and td.tdterm < TDMSTSCHM.toterm(+)
UNION ALL
    select td.txdate, td.tltxcd, td.acctno, td.afacctno, td.fullname,
        td.actype, td.orgamt msgamt, td.frdate, td.todate,
        (case when td.schdtype = 'F' then td.intrate else nvl(TDMSTSCHM.intrate,td.intrate) end) intrate,
        TD.namt NAMT, 0 INTAVLAMT, TD.intpaid intamt, /*td.grpname,*/ td.cdcontent,td.buyingpower,
        td.custodycd
    FROM
    (
    select tr.txdate, tl.tltxcd, tr.acctno, td.afacctno, cf.fullname,
        td.actype, td.orgamt, td.frdate, td.todate,
        max(case when tr.txcd = '0026' then tr.namt else 0 end) intpaid,
        max(case when tr.txcd = '0023' then tr.namt else 0 end) namt,
        tr.txnum, TD.intrate, TD.schdtype, TD.tdterm,
       /* max(nvl(tl.grpname,' '))  grpname,*/ max(td.tdterm || ' ' || al.cdcontent) cdcontent,
        max(a3.cdcontent) buyingpower,max(cf.custodycd) custodycd
    from afmast af, cfmast cf, /*tlgroups tl, */ allcode al,
    (
      /*  select txdate, txnum, acctno, afacctno, actype, orgamt, balance, opndate,
            frdate, todate, intrate, tdterm, schdtype, termcd,buyingpower
        from tdmasthist
        union all*/
        select txdate, txnum, acctno, afacctno, actype, orgamt, balance, opndate,
            frdate, todate, intrate, tdterm, schdtype, termcd,buyingpower
        from tdmast
    ) TD,
    ( select * from tdtran union all select * from tdtrana ) TR,
    ( select * from tllog union all select * from tllogall ) tl,
    allcode a3
    where tr.txcd in ('0023','0026')
        and tr.txnum = tl.txnum
        and tr.txdate = tl.txdate
        and tr.acctno = td.acctno
        and td.afacctno = af.acctno
        and af.custid = cf.custid
    /*    and cf.CAREBY = tl.grpid(+)*/
        and al.cdtype = 'TD' and al.cdname = 'TERMCD'
        and td.termcd = al.cdval
       /* AND CF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = '<$TELLERID>')*/

         AND A3.CDTYPE='SY' AND A3.CDNAME='YESNO' AND TD.BUYINGPOWER=A3.CDVAL

    group by tr.txnum, tr.txdate, tr.txdate, tl.tltxcd, tr.acctno, td.afacctno, cf.fullname,
        td.actype, td.orgamt, td.frdate, td.todate, TD.intrate, TD.tdterm, TD.schdtype
     order BY max(td.txdate),max(td.txnum)
    ) TD
    left join
    TDMSTSCHM
    on td.acctno = TDMSTSCHM.acctno(+)
        and td.namt >= TDMSTSCHM.framt(+)
        and td.namt < TDMSTSCHM.toamt(+)
        and td.tdterm >= TDMSTSCHM.FRTERM(+)
        and td.tdterm < TDMSTSCHM.toterm(+)
    ) td where 0 = 0
);

