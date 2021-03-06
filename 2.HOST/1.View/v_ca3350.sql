CREATE OR REPLACE FORCE VIEW V_CA3350 AS
(SELECT CA.AUTOID, CA.BALANCE, SUBSTR(CA.CAMASTID,1,4) || '.' || SUBSTR(CA.CAMASTID,5,6) || '.' || SUBSTR(CA.CAMASTID,11,6) CAMASTID, CA.AFACCTNO,A0.CDCONTENT CATYPE, CA.CODEID, CA.EXCODEID, CA.QTTY, ROUND(CA.AMT) AMT, ROUND(CA.AQTTY)  AQTTY,
       ROUND(CA.AAMT) AAMT,ROUND(CA.INTAMT) INTAMT, round(CA.DFAMT) DFAMT, SYM.SYMBOL, A1.CDCONTENT STATUS,CA.AFACCTNO || CA.CODEID  SEACCTNO,CA.AFACCTNO || (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END) EXSEACCTNO,
       SYM.PARVALUE PARVALUE, EXSYM.PARVALUE EXPARVALUE, CAMAST.REPORTDATE REPORTDATE, CAMAST.ACTIONDATE ,CAMAST.ACTIONDATE  POSTINGDATE,
      camast.description, camast.taskcd,
      (CASE WHEN AF.ISFCT='Y' THEN ( CASE WHEN CAMAST.CATYPE IN ('016','023') THEN CAMAST.pitrate*CA.INTAMT/100 ELSE CAMAST.pitrate*CA.AMT/100 END) ELSE 0 END) DUTYAMT,
      CF.FULLNAME, CF.IDCODE, CF.CUSTODYCD,(CASE WHEN CAMAST.catype IN ('016','023') THEN 1 ELSE 0 END) ISDEBITSE,
      CASE WHEN CI.COREBANK='Y' THEN 0 ELSE 1 END ISCOREBANK,CASE WHEN CI.COREBANK='Y' THEN 'Yes' ELSE 'No' END ISCOREBANKTEXT,
        NVL(se.trade,0) trade
FROM CASCHD CA, SBSECURITIES SYM, SBSECURITIES EXSYM, ALLCODE A0, ALLCODE A1, CAMAST, AFMAST AF , CFMAST CF , CIMAST CI , AFTYPE TYP, SYSVAR SYS, semast se
WHERE A0.CDTYPE = 'CA' AND A0.CDNAME = 'CATYPE' AND A0.CDVAL = CAMAST.CATYPE
AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS' AND A1.CDVAL = CA.STATUS
AND CA.CAMASTID = CAMAST.CAMASTID AND CAMAST.CODEID = SYM.CODEID
AND CA.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID AND AF.ACCTNO=CI.AFACCTNO
AND CA.DELTD ='N' AND CA.STATUS IN ('S','G','H','J','W') AND CA.ISCI ='N' and CAMAST.STATUS IN ('I','G','H','J')
AND se.acctno(+)=ca.afacctno||ca.codeid
AND CA.AMT > 0
AND CA.ISEXEC='Y'
AND (case when ca.pitratemethod='##' then CAMAST.PITRATEMETHOD else ca.pitratemethod end) in ('NO','SC')
AND AF.ACTYPE = TYP.ACTYPE AND SYS.GRNAME='SYSTEM' AND SYS.VARNAME='CADUTY'
AND EXSYM.CODEID = (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END));

