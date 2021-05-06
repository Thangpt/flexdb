create or replace force view vw_dfmast_all as
(
select ACCTNO,AFACCTNO,LNACCTNO,TXDATE,TXNUM,TXTIME,ACTYPE,RRTYPE,DFTYPE,CUSTBANK,LNTYPE,FEE,FEEMIN,TAX,AMTMIN,CODEID,REFPRICE,DFPRICE,TRIGGERPRICE,DFRATE,IRATE,MRATE,LRATE,CALLTYPE,DFQTTY,RCVQTTY,BLOCKQTTY,CARCVQTTY,BQTTY,RLSQTTY,DFAMT,RLSAMT,AMT,INTAMTACR,FEEAMT,RLSFEEAMT,STATUS,DFREF,DESCRIPTION,PSTATUS,CIACCTNO,LAST_CHANGE,LIMITCHK,FLAGTRIGGER,ORGAMT,AUTOPAID,TRIGGERDATE,TLID,CISVRFEE,GROUPID,DEALTYPE,GRPORDAMT,CACASHQTTY,CAQTTY,SENDVSDQTTY, RELEVSDQTTY, DFSTANDING
from dfmast
union all
select ACCTNO,AFACCTNO,LNACCTNO,TXDATE,TXNUM,TXTIME,ACTYPE,RRTYPE,DFTYPE,CUSTBANK,LNTYPE,FEE,FEEMIN,TAX,AMTMIN,CODEID,REFPRICE,DFPRICE,TRIGGERPRICE,DFRATE,IRATE,MRATE,LRATE,CALLTYPE,DFQTTY,RCVQTTY,BLOCKQTTY,CARCVQTTY,BQTTY,RLSQTTY,DFAMT,RLSAMT,AMT,INTAMTACR,FEEAMT,RLSFEEAMT,STATUS,DFREF,DESCRIPTION,PSTATUS,CIACCTNO,LAST_CHANGE,LIMITCHK,FLAGTRIGGER,ORGAMT,AUTOPAID,TRIGGERDATE,TLID,CISVRFEE,GROUPID,DEALTYPE,GRPORDAMT,CACASHQTTY,CAQTTY,SENDVSDQTTY, RELEVSDQTTY, DFSTANDING
from dfmasthist
);

