CREATE OR REPLACE FORCE VIEW VW_STSCHD_TDAY AS
SELECT STS."AUTOID",STS."DUETYPE",STS."ACCTNO",STS."REFORDERID",STS."TXDATE",STS."CLEARDAY",STS."CLEARCD",STS."AMT",STS."AAMT",STS."QTTY",STS."AQTTY",STS."FAMT",STS."AFACCTNO",STS."STATUS",STS."DELTD",STS."TXNUM",STS."ORGORDERID",STS."CODEID",STS."PAIDAMT",STS."PAIDFEEAMT",STS."COSTPRICE",STS."CLEARDATE", STS.CLEARDAY-SP_BD_GETCLEARDAY(STS.CLEARCD, SB.TRADEPLACE, STS.TXDATE, TO_DATE(SYS.VARVALUE,'DD/MM/RRRR')) TDAY 
FROM STSCHD STS, SBSECURITIES SB, SYSVAR SYS
WHERE STS.CODEID = SB.CODEID AND SYS.VARNAME ='CURRDATE';

