create or replace force view vw_iod_tradeplace_all as
select fn_symbol_tradeplace(io.codeid,TO_CHAR(io.TXDATE ,'DD/MM/YYYY')) tradeplace , io."ORGORDERID",io."EXORDERID",io."CODEID",io."SYMBOL",io."CUSTODYCD",io."BORS",io."NORP",io."AORN",io."PRICE",io."QTTY",io."REFCUSTCD",io."MATCHPRICE",io."MATCHQTTY",io."TXNUM",io."TXDATE",io."DELTD",io."CONFIRM_NO",io."TXTIME",io."IODFEEACR",io."IODTAXSELLAMT" from vw_iod_all io;

