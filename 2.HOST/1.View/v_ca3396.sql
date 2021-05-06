CREATE OR REPLACE FORCE VIEW V_CA3396 AS
(SELECT CA.AUTOID,CA.ISCI,CA.ISCISE,(case when CF.STATUS IN ('P','A') Then 'Ho?t d?ng' else '��ng' end ) CFSTATUS,CA.BALANCE, SUBSTR(CA.CAMASTID,1,4) || '.' || SUBSTR(CA.CAMASTID,5,6) || '.' || SUBSTR(CA.CAMASTID,11,6) CAMASTID,
       CA.AFACCTNO,A0.CDCONTENT CATYPE, CA.CODEID, CA.EXCODEID,CA.QTTY, CA.AMT, CA.AQTTY,
       CA.AAMT, (CASE WHEN CAMAST.ISWFT='Y' THEN (SELECT SYMBOL FROM SBSECURITIES WHERE REFCODEID =SYM.CODEID ) ELSE SYM.SYMBOL END) SYMBOL, A1.CDCONTENT STATUS, CA.STATUS
       STATUSCD,CA.AFACCTNO ||(CASE WHEN CAMAST.ISWFT='Y' THEN (SELECT CODEID FROM SBSECURITIES WHERE REFCODEID =SYM.CODEID ) ELSE CA.CODEID END)  SEACCTNO,
       CA.AFACCTNO || (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END) EXSEACCTNO,
       SYM.PARVALUE PARVALUE, EXSYM.PARVALUE EXPARVALUE,CAMAST.REPORTDATE REPORTDATE, CAMAST.ACTIONDATE  ,
       to_char('�?i phuong th?c thu thu?, '||CAMAST.description) DESCRIPTION,cf.custodycd,cf.fullname,cf.idcode, a2.cdcontent CAVAT, CA.PITRATEMETHOD VAT,a3.cdcontent CAVAT2,
       (CASE WHEN AFT.VAT='Y' THEN CAMAST.pitrate*CA.AMT/100 ELSE 0 END) DUTYAMT
FROM CASCHD CA, SBSECURITIES SYM, SBSECURITIES EXSYM,
      ALLCODE A0, ALLCODE A1,ALLCODE A2,ALLCODE A3,ALLCODE A4,CAMAST ,AFMAST AF , CFMAST CF, AFTYPE AFT
WHERE A0.CDTYPE = 'CA' AND A0.CDNAME = 'CATYPE' AND A0.CDVAL = CAMAST.CATYPE
      AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS' AND A1.CDVAL = CA.STATUS
      AND A2.CDTYPE = 'CA' AND A2.CDNAME = 'PITRATEMETHOD' AND A2.CDVAL = CA.PITRATEMETHOD
      AND A3.CDTYPE = 'CA' AND A3.CDNAME = 'PITRATEMETHOD' AND A3.CDVAL = CAMAST.PITRATEMETHOD
      AND A4.CDTYPE='CF' AND A4.CDNAME = 'STATUS' AND A4.CDVAL=CF.STATUS
      AND CA.AFACCTNO = AF.ACCTNO AND AF.ACTYPE = AFT.ACTYPE --AND AFT.AFTYPE ='002'
      AND AFT.VAT='Y'
      AND AF.CUSTID =CF.CUSTID --AND SUBSTR(CF.CUSTODYCD,4,1)='C'
      AND CA.CAMASTID = CAMAST.CAMASTID AND CAMAST.CODEID =SYM.CODEID
      AND CA.DELTD ='N' AND CA.STATUS IN ('A','S','I')
      And CAMAST.CATYPE in ('010','011','021','015','016','009','017','020','023','027')
      And CAMAST.PITRATE>0
      AND CAMAST.STATUS <> 'C'
      AND CAMAST.STATUS='I'
      and cf.custatcom='Y'
      AND EXSYM.CODEID = (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END)
      AND CA.BALANCE > 0
      AND CA.AMT + CA.AAMT>0
      AND NVL(CA.ISCI,' ') !='Y'
      --AND NVL(CA.Iscise,' ')!='Y'
)
;
