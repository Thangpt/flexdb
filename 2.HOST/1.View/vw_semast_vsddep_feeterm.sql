-- Start of DDL Script for View HOSTMSTRADE.VW_SEMAST_VSDDEP_FEETERM
-- Generated 11/04/2017 3:48:02 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE VIEW vw_semast_vsddep_feeterm (
   afacctno,
   acctno,
   tbaldt,
   autoid,
   forp,
   feeamt,
   lotday,
   lotval,
   roundtyp,
   sebal,
   odrnum )
AS
SELECT SE.AFACCTNO, SE.ACCTNO, SE.TBALDT, RF.AUTOID, RF.FORP, RF.FEEAMT, RF.LOTDAY, RF.LOTVAL, RF.ROUNDTYP,
(se.trade + se.margin + se.mortage + se.blocked + se.secured + se.repo + se.netting + se.dtoclose + se.withdraw) SEBAL, 0 ODRNUM
FROM SEMAST SE, CIMAST MST, CITYPE TYP, CIFEEDEF RF,AFMAST AF, CFMAST CF
WHERE TYP.ACTYPE=MST.ACTYPE AND TYP.ACTYPE=RF.ACTYPE AND RF.FEETYPE='VSDDEP' AND RF.STATUS='A'
AND (se.trade + se.margin + se.mortage + se.blocked + se.secured + se.repo + se.netting + se.dtoclose + se.withdraw)>0
AND MST.AFACCTNO=SE.AFACCTNO AND RF.CODEID=SE.CODEID
AND SE.AFACCTNO=AF.ACCTNO AND AF.STATUS IN ('A','P')
AND CF.CUSTID=AF.CUSTID AND CF.CUSTATCOM='Y'
UNION ALL
--THEO TRADEPLACE
SELECT SE.AFACCTNO, SE.ACCTNO, SE.TBALDT, RF.AUTOID, RF.FORP, RF.FEEAMT, RF.LOTDAY, RF.LOTVAL, RF.ROUNDTYP,
(se.trade + se.margin + se.mortage + se.blocked + se.secured + se.repo + se.netting + se.dtoclose + se.withdraw) SEBAL, 1 ODRNUM
FROM SBSECURITIES SB, SEMAST SE, CIMAST MST, CITYPE TYP, CIFEEDEF RF,AFMAST AF,CFMAST CF
WHERE TYP.ACTYPE=MST.ACTYPE AND TYP.ACTYPE=RF.ACTYPE AND RF.FEETYPE='VSDDEP' AND RF.STATUS='A'
AND (se.trade + se.margin + se.mortage + se.blocked + se.secured + se.repo + se.netting + se.dtoclose + se.withdraw)>0
AND MST.AFACCTNO=SE.AFACCTNO AND SB.CODEID=SE.CODEID AND SB.TRADEPLACE=RF.TRADEPLACE AND RF.CODEID IS NULL
AND (SB.SECTYPE=RF.SECTYPE OR DECODE(SB.SECTYPE,'001','111','002','111','011','111','007','111','008','111','003','222','006','222','')=RF.SECTYPE)
AND SE.AFACCTNO=AF.ACCTNO AND AF.STATUS IN ('A','P')
AND CF.CUSTID=AF.CUSTID AND CF.CUSTATCOM='Y'
UNION ALL
--DEFAULT THEO SECTYPE
SELECT SE.AFACCTNO, SE.ACCTNO, SE.TBALDT, RF.AUTOID, RF.FORP, RF.FEEAMT, RF.LOTDAY, RF.LOTVAL, RF.ROUNDTYP,
(se.trade + se.margin + se.mortage + se.blocked + se.secured + se.repo + se.netting + se.dtoclose + se.withdraw) SEBAL, 2 ODRNUM
FROM SBSECURITIES SB, SEMAST SE, CIMAST MST, CITYPE TYP, CIFEEDEF RF,AFMAST AF,CFMAST CF
WHERE TYP.ACTYPE=MST.ACTYPE AND TYP.ACTYPE=RF.ACTYPE AND RF.FEETYPE='VSDDEP' AND RF.STATUS='A'
AND (se.trade + se.margin + se.mortage + se.blocked + se.secured + se.repo + se.netting + se.dtoclose + se.withdraw)>0
AND MST.AFACCTNO=SE.AFACCTNO AND SB.CODEID=SE.CODEID AND RF.TRADEPLACE IN('000','999' ) AND RF.CODEID IS NULL
AND (SB.SECTYPE=RF.SECTYPE OR DECODE(SB.SECTYPE,'001','111','002','111','011','111','007','111','008','111','003','222','006','222','')=RF.SECTYPE)
AND SE.AFACCTNO=AF.ACCTNO AND AF.STATUS IN ('A','P')
AND CF.CUSTID=AF.CUSTID AND CF.CUSTATCOM='Y'
/


-- End of DDL Script for View HOSTMSTRADE.VW_SEMAST_VSDDEP_FEETERM

