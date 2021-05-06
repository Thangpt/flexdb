-- Start of DDL Script for View HOSTMSTRADE.VW_SEMAST_CUSTODYCD
-- Generated 11/04/2017 10:04:20 AM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE VIEW vw_semast_custodycd (
   custodycd,
   symbol,
   tradeplace,
   actype,
   acctno,
   codeid,
   afacctno,
   opndate,
   clsdate,
   lastdate,
   status,
   pstatus,
   irtied,
   ircd,
   costprice,
   trade,
   mortage,
   margin,
   netting,
   standing,
   withdraw,
   deposit,
   loan,
   blocked,
   receiving,
   transfer,
   prevqtty,
   dcrqtty,
   dcramt,
   depofeeacr,
   repo,
   pending,
   tbaldepo,
   custid,
   costdt,
   secured,
   iccfcd,
   iccftied,
   tbaldt,
   senddeposit,
   sendpending,
   ddroutqtty,
   ddroutamt,
   dtoclose,
   sdtoclose,
   qtty_transfer,
   last_change,
   dealintpaid,
   wtrade,
   grpordamt )
AS
select cf.custodycd, sb.symbol, sb.tradeplace, se."ACTYPE",se."ACCTNO",se."CODEID",se."AFACCTNO",se."OPNDATE",se."CLSDATE",se."LASTDATE",se."STATUS",se."PSTATUS",se."IRTIED",se."IRCD",se."COSTPRICE",se."TRADE",se."MORTAGE",se."MARGIN",se."NETTING",se."STANDING",se."WITHDRAW",se."DEPOSIT",se."LOAN",se."BLOCKED",se."RECEIVING",se."TRANSFER",se."PREVQTTY",se."DCRQTTY",se."DCRAMT",se."DEPOFEEACR",se."REPO",se."PENDING",se."TBALDEPO",se."CUSTID",se."COSTDT",se."SECURED",se."ICCFCD",se."ICCFTIED",se."TBALDT",se."SENDDEPOSIT",se."SENDPENDING",se."DDROUTQTTY",se."DDROUTAMT",se."DTOCLOSE",se."SDTOCLOSE",se."QTTY_TRANSFER",se."LAST_CHANGE",se."DEALINTPAID",se."WTRADE",se."GRPORDAMT"
from cfmast cf, afmast af, semast se, sbsecurities sb 
where cf.custid = af.custid and af.acctno = se.afacctno and se.codeid = sb.codeid
/


-- End of DDL Script for View HOSTMSTRADE.VW_SEMAST_CUSTODYCD

