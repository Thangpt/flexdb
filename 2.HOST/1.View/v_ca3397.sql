-- Start of DDL Script for View HOSTMSTRADE.V_CA3397
-- Generated 16/01/2018 5:21:12 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE VIEW v_ca3397 (
   isci,
   iscise,
   autoid,
   balance,
   camastid,
   afacctno,
   catype,
   codeid,
   excodeid,
   qtty,
   amt,
   aqtty,
   aamt,
   symbol,
   status,
   statuscd,
   seacctno,
   exseacctno,
   parvalue,
   exparvalue,
   reportdate,
   actiondate,
   description,
   custodycd,
   fullname,
   idcode,
   caisexec,
   isexec,
   cfstatusnhap,
   cfstatus,
   dutyamt )
AS
(
SELECT CA.ISCI,CA.ISCISE,CA.AUTOID, CA.BALANCE, SUBSTR(CA.CAMASTID,1,4) || '.' || SUBSTR(CA.CAMASTID,5,6) || '.' || SUBSTR(CA.CAMASTID,11,6) CAMASTID,
       CA.AFACCTNO,A0.CDCONTENT CATYPE, CA.CODEID, CA.EXCODEID,CA.QTTY, CA.AMT, CA.AQTTY,
       CA.AAMT, (CASE WHEN CAMAST.ISWFT='Y' THEN (SELECT SYMBOL FROM SBSECURITIES WHERE REFCODEID =SYM.CODEID ) ELSE SYM.SYMBOL END) SYMBOL, A1.CDCONTENT STATUS, CA.STATUS
       STATUSCD,CA.AFACCTNO ||(CASE WHEN CAMAST.ISWFT='Y' THEN (SELECT CODEID FROM SBSECURITIES WHERE REFCODEID =SYM.CODEID ) ELSE CA.CODEID END)  SEACCTNO,
       CA.AFACCTNO || (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END) EXSEACCTNO,
       SYM.PARVALUE PARVALUE, EXSYM.PARVALUE EXPARVALUE,CAMAST.REPORTDATE REPORTDATE, CAMAST.ACTIONDATE  ,
       to_char('Không phân bổ tiền, '||CAMAST.description) DESCRIPTION,cf.custodycd,cf.fullname,cf.idcode, a2.cdcontent CAISEXEC, CA.ISEXEC ISEXEC,CF.STATUS,
       (case when CF.STATUS IN ('P','A') Then 'Hoạt động' else 'Ðóng' end ) CFSTATUS,
       (CASE WHEN TYP.VAT='Y' THEN CAMAST.pitrate*CA.AMT/100 ELSE 0 END) DUTYAMT
FROM CASCHD CA, SBSECURITIES SYM, SBSECURITIES EXSYM,
      ALLCODE A0, ALLCODE A1,ALLCODE A2,ALLCODE A4, CAMAST ,AFMAST AF , CFMAST CF,AFTYPE TYP
WHERE A0.CDTYPE = 'CA' AND A0.CDNAME = 'CATYPE' AND A0.CDVAL = CAMAST.CATYPE
      AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS' AND A1.CDVAL = CA.STATUS
      AND A2.CDTYPE = 'SY' AND A2.CDNAME = 'YESNO' AND A2.CDVAL = CA.ISEXEC
      AND A4.CDTYPE='CF' AND A4.CDNAME = 'STATUS' AND A4.CDVAL=CF.STATUS
      AND CA.AFACCTNO = AF.ACCTNO AND AF.ACTYPE=TYP.ACTYPE
      AND AF.CUSTID =CF.CUSTID
      AND CA.CAMASTID = CAMAST.CAMASTID AND CAMAST.CODEID =SYM.CODEID
      AND CA.DELTD ='N' AND CA.STATUS IN ('S','I')
      And CAMAST.CATYPE in ('010','009','011','021','017','020','015','016','023','027','028') and cf.custatcom='Y'
      AND EXSYM.CODEID = (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END)
      AND CA.BALANCE > 0 AND CA.AMT + CA.AAMT>0
      AND NVL(CA.ISCI,' ') !='Y'
      --AND NVL(CA.Iscise,' ')!='Y'
      AND CAMAST.STATUS <>'C'
)
/


-- End of DDL Script for View HOSTMSTRADE.V_CA3397

