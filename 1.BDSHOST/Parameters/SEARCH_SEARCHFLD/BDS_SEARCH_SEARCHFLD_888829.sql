﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = '888829';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('888829','Tra cứu giao dịch điều chỉnh trả chậm','Adjust transfer buy amoutn','
SELECT CF.CUSTODYCD, CF.FULLNAME, AF.ACCTNO AFACCTNO, STS.AUTOID, STS.ORGORDERID, STS.CODEID, STS.amt - STS.aamt AMT, STS.QTTY - STS.aqtty qtty,SB.SYMBOL,
(STS.amt - STS.aamt) / (STS.QTTY - STS.aqtty) MATCHPRICE, STS.TRFBUYEXT, STS.TRFBUYRATE
FROM STSCHD STS, AFMAST AF, CFMAST CF, SBSECURITIES SB
WHERE STS.AFACCTNO = AF.ACCTNO AND STS.DUETYPE = ''SM'' AND AF.CUSTID = CF.CUSTID AND STS.TRFBUYEXT > 0
AND STS.CODEID = SB.CODEID
AND STS.TXDATE = (SELECT TO_DATE(VARVALUE,''DD/MM/RRRR'') FROM SYSVAR WHERE VARNAME = ''CURRDATE'')
','SEMAST',null,null,'8829',null,50,'N',30,null,'Y','T');
COMMIT;
/
