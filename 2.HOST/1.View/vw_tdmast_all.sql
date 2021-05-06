CREATE OR REPLACE FORCE VIEW VW_TDMAST_ALL AS
SELECT a.txdate, a.txnum, a.acctno, a.afacctno, a.actype, a.status,
       a.pstatus, a.deltd, a.ciacctno, a.custbank, a.tdsrc, a.tdtype,
       a.orgamt, a.balance, a.mortgage, a.printpaid, a.autopaid,
       a.intnmlacr, a.intpaid, a.taxrate, a.bonusrate, a.tpr,
       a.schdtype, a.intrate, a.termcd, a.tdterm, a.breakcd,
       a.minbrterm, a.inttypbrcd, a.flintrate, a.rndno, a.ddramt,
       a.intmethod, a.opndate, a.frdate, a.todate, a.autornd,
       a.intduecd, a.intfrq, a.buyingpower, a.refclacctno,
       a.description, a.tlid, a.offid, a.last_change
  FROM tdmast a;

