create or replace force view vw_odmast_all as
select ACTYPE,ORDERID,CODEID,AFACCTNO,SEACCTNO,CIACCTNO,TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PRICETYPE,QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,CUSTID,EXPRICE,EXQTTY,ICCFCD,ICCFTIED,EXECAMT,EXAMT,FEEAMT,CONSULTANT,VOUCHER,ODTYPE,FEEACR,PORSTATUS,RLSSECURED,SECUREDAMT,MATCHAMT,DELTD,REFORDERID,BANKTRFAMT,BANKTRFFEE,EDSTATUS,CORRECTIONNUMBER,CONTRAFIRM,TRADERID,CLIENTID,CONFIRM_NO,FOACCTNO,HOSESESSION,CONTRAORDERID,PUTTYPE,CONTRAFRM,DFACCTNO,LAST_CHANGE,DFQTTY,STSSTATUS,FEEBRATIO,TLID,SSAFACCTNO,ADVIDREF,NOE,GRPORDER,GRPAMT,EXCFEEAMT,EXCFEEREFID,ISDISPOSAL,
TAXRATE,TAXSELLAMT,ERROD,ERRSTS,ERRREASON,FERROD,QUOTEQTTY, CONFIRMED, orderTime,REPOTYPE, PTDEAL
from odmast
union all
select ACTYPE,ORDERID,CODEID,AFACCTNO,SEACCTNO,CIACCTNO,TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PRICETYPE,QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,CUSTID,EXPRICE,EXQTTY,ICCFCD,ICCFTIED,EXECAMT,EXAMT,FEEAMT,CONSULTANT,VOUCHER,ODTYPE,FEEACR,PORSTATUS,RLSSECURED,SECUREDAMT,MATCHAMT,DELTD,REFORDERID,BANKTRFAMT,BANKTRFFEE,EDSTATUS,CORRECTIONNUMBER,CONTRAFIRM,TRADERID,CLIENTID,CONFIRM_NO,FOACCTNO,HOSESESSION,CONTRAORDERID,PUTTYPE,CONTRAFRM,DFACCTNO,LAST_CHANGE,DFQTTY,STSSTATUS,FEEBRATIO,TLID,SSAFACCTNO,ADVIDREF,NOE,GRPORDER,GRPAMT,EXCFEEAMT,EXCFEEREFID,ISDISPOSAL,
TAXRATE,TAXSELLAMT,ERROD,ERRSTS,ERRREASON,FERROD,QUOTEQTTY,CONFIRMED, orderTime,REPOTYPE, PTDEAL
from odmasthist;
