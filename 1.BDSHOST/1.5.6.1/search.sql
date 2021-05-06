UPDATE search SET SEARCHCMDSQL = 'SELECT FN_GET_LOCATION(CF.BRID) LOCATION, CF.CUSTODYCD, B.DESACCTNO AFDDI , C.CODEID, C.SYMBOL, C.PARVALUE, A.AFACCTNO,seinf.CURRPRICE,seinf.FLOORPRICE , B.* , CF.IDCODE ,A4.CDCONTENT TRADEPLACE,ROUND(decode(afTY.VAT,''Y'',1,0)* B.QTTY*seinf.FLOORPRICE*(SELECT to_number(varvalue) FROM SYSVAR WHERE VARNAME =''TAXRETAIL'')/100) TAX,
CF.FULLNAME, cf_mg.fullname REFULLNAME, cf.brid || '' - '' || brgrp.brname BRNAME, cf.careby || '' - '' || tlgroups.grpname CAREBY
FROM SEMAST A, SERETAIL B, SBSECURITIES C ,AFMAST AF , CFMAST CF ,ALLCODE A4,securities_info seiNF,aftype afty,
cfmast cf_mg, reaflnk, retype, brgrp, tlgroups
WHERE A.ACCTNO = B.ACCTNO AND A.CODEID = C.CODEID and  c.codeid = seinf.codeid AND B.QTTY > 0 AND B.STATUS=''N'' AND AF.ACCTNO =A.AFACCTNO AND AF.CUSTID =CF.CUSTID and af.actype=afty.actype
AND A4.CDTYPE = ''SE'' AND A4.CDNAME = ''TRADEPLACE''  AND A4.CDVAL = C.TRADEPLACE
AND retype.actype = substr(reaflnk.reacctno,11,4) AND retype.rerole IN (''BM'',''RM'')
AND reaflnk.status = ''A'' AND cf_mg.custid = substr(reaflnk.reacctno,1,10)
AND af.acctno = reaflnk.afacctno
AND cf.brid = brgrp.brid AND cf.careby = tlgroups.grpid'
WHERE searchcode = 'SE8815';
COMMIT;
