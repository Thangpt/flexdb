create or replace force view vw_stschd_tradeplace_all as
select fn_symbol_tradeplace(chd.codeid,TO_CHAR(chd.TXDATE ,'DD/MM/YYYY')) tradeplace, chd."AUTOID",chd."DUETYPE",chd."ACCTNO",chd."REFORDERID",chd."TXDATE",chd."CLEARDAY",chd."CLEARCD",chd."AMT",chd."AAMT",chd."QTTY",chd."AQTTY",chd."FAMT",chd."AFACCTNO",chd."STATUS",chd."DELTD",chd."TXNUM",chd."ORGORDERID",chd."CODEID",chd."PAIDAMT",chd."PAIDFEEAMT",chd."COSTPRICE",chd."CLEARDATE",chd."RIGHTQTTY",chd."ARIGHT",chd."TRFBUYDT",chd."TRFBUYSTS",chd."TRFEXEAMT",chd."TRFBUYRATE",chd."TRFBUYEXT",chd."DFAMT",chd."TRFT0AMT"
from vw_stschd_all chd;

