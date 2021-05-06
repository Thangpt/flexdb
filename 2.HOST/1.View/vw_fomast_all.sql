CREATE OR REPLACE FORCE VIEW VW_FOMAST_ALL AS
SELECT "ACCTNO","ACTYPE","AFACCTNO","STATUS","EXECTYPE","PRICETYPE","TIMETYPE","MATCHTYPE","NORK","CLEARCD","CLEARDAY","CODEID","SYMBOL","QUANTITY","PRICE","QUOTEPRICE","TRIGGERPRICE","EXECQTTY","EXECAMT","REMAINQTTY","CANCELQTTY","AMENDQTTY","CONFIRMEDVIA","BOOK","ORGACCTNO","REFACCTNO","REFQUANTITY","REFPRICE","REFQUOTEPRICE","FEEDBACKMSG","ACTIVATEDT","CREATEDDT","REFORDERID","REFUSERNAME","TXDATE","TXNUM","EFFDATE","EXPDATE","BRATIO","VIA","DELTD","OUTPRICEALLOW","USERNAME","DFACCTNO","SPLOPT","SPLVAL","DIRECT","LAST_CHANGE" FROM FOMAST UNION ALL SELECT "ACCTNO","ACTYPE","AFACCTNO","STATUS","EXECTYPE","PRICETYPE","TIMETYPE","MATCHTYPE","NORK","CLEARCD","CLEARDAY","CODEID","SYMBOL","QUANTITY","PRICE","QUOTEPRICE","TRIGGERPRICE","EXECQTTY","EXECAMT","REMAINQTTY","CANCELQTTY","AMENDQTTY","CONFIRMEDVIA","BOOK","ORGACCTNO","REFACCTNO","REFQUANTITY","REFPRICE","REFQUOTEPRICE","FEEDBACKMSG","ACTIVATEDT","CREATEDDT","REFORDERID","REFUSERNAME","TXDATE","TXNUM","EFFDATE","EXPDATE","BRATIO","VIA","DELTD","OUTPRICEALLOW","USERNAME","DFACCTNO","SPLOPT","SPLVAL","DIRECT","LAST_CHANGE" FROM FOMASTHIST;
