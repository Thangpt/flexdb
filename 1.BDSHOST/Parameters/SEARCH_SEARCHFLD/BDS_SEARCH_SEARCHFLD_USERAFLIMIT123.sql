﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'USERAFLIMIT123';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('USERAFLIMIT123','Hạn mức bảo lãnh','Limit T0','SELECT MST.*, nvl(rlimit,0)RLIMIT, nvl(LIMITMAX,0)LIMITMAX, nvl(USERHAVE,0)USERHAVE FROM (
SELECT CF.SHORTNAME, AF.ACTYPE,AFT.TYPENAME ACNAME, SUBSTR(AF.CUSTID,1,4) || ''.'' || SUBSTR(AF.CUSTID,5,6) CUSTID,
CF.FULLNAME FULLNAME,CF.FULLNAME || ''(''||CF.custodycd ||'')'' CUSTNAME,CF.CUSTODYCD CUSTODYCD,
SUBSTR(AF.ACCTNO,1,4) || ''.'' || SUBSTR(AF.ACCTNO,5,6) ACCTNO, AF.AFTYPE
,AF.PIN,AF.TRADEPHONE,AF.PHONE1,CF.IDCODE,CF.IDDATE, CF.IDPLACE,
AF.BANKACCTNO,AF.SWIFTCODE,AF.EMAIL,AF.ADDRESS,AF.FAX,
SUBSTR(AF.CIACCTNO,1,4) || ''.'' || SUBSTR(AF.CIACCTNO,5,6) CIACCTNO,AF.IFRULECD,AF.LASTDATE,
AF.MARGINLINE,AF.TRADELINE,AF.ADVANCELINE,AF.REPOLINE,AF.DEPOSITLINE,AF.BRATIO,AF.DESCRIPTION,
AF.TELELIMIT,AF.ONLINELIMIT,AF.CFTELELIMIT,AF.CFONLINELIMIT,AF.TRADERATE,AF.DEPORATE,AF.MISCRATE, GRP.GRPNAME CAREBY,
GRP.grpid CAREBYID, CF.REFNAME, AF.corebank,AF.bankname,
AF.MRIRATE,AF.MRMRATE,AF.MRLRATE,AF.MRDUEDAY,AF.MREXTDAY,AF.MRCLAMT,AF.MRCRLIMIT,AF.MRCRLIMITMAX,NVL(USF.ACCLIMIT,0) ACCLIMIT,CFLM.CUSTAVLLIMIT

FROM AFMAST AF,CFMAST CF,AFTYPE AFT, TLGROUPS GRP,MRTYPE MRT,
(SELECT * FROM USERAFLIMIT WHERE  TLIDUSER=''<$TELLERID>'' AND  TYPERECEIVE=''T0'') USF,
(select afc.acctno, MRLOANLIMIT-af.MRCRLIMITMAX CUSTAVLLIMIT from cfmast cf,
    (select  custid,  sum(MRCRLIMITMAX + advanceline) MRCRLIMITMAX
                         from afmast
                         group by custid) af, afmast afc
                  where cf.custid = af.custid and afc.custid = cf.custid) cflm
WHERE AF.CUSTID=CF.CUSTID AND AF.ACTYPE=AFT.ACTYPE AND AFT.MRTYPE=MRT.ACTYPE
AND CF.CUSTODYCD LIKE ''001%''
AND AF.ACCTNO =USF.ACCTNO (+)
AND AF.ACCTNO=cflm.ACCTNO
AND CF.CAREBY = GRP.GRPID AND GRP.GRPTYPE = ''2''
AND AFT.ACTYPE = AF.ACTYPE
AND (SUBSTR(CF.CUSTID,1,4) = DECODE(''<$BRID>'', ''<$HO_BRID>'', SUBSTR(CF.CUSTID,1,4), ''<$BRID>'')
    OR CF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>''))) mST
LEFT JOIN
(SELECT us.t0 t0,  nvl(SUM(usf.acclimit),0) usedlimit, (us.t0 - nvl(SUM(usf.acclimit),0)) rlimit
  FROM userlimit us, (select * from  Useraflimit where typereceive = ''T0'') usf
  WHERE us.tliduser = usf.Tliduser (+)
   AND us.tliduser = ''<$TELLERID>''
  GROUP BY us.t0) us
on 0=0
LEFT JOIN
(Select NVL(US.ACCTLIMIT,0) LIMITMAX,NVL(US.ALLOCATELIMMIT-US.USEDLIMMIT,0) USERHAVE
  from userlimit US where US.tliduser=''<$TELLERID>'') ul
on 0=0','USERAFLIMIT',null,null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
