CREATE OR REPLACE VIEW VW_STRADE_SUBACCOUNT_INFO AS
SELECT DTL.ACCTNO AFACCTNO, MST.CUSTID, MST.CUSTODYCD, MST.SHORTNAME, MST.FULLNAME,
CD1.EN_CDCONTENT EN_IDTYPE_DESC, CD1.CDCONTENT IDTYPE_DESC, MST.IDCODE, MST.IDDATE, MST.IDPLACE, MST.IDEXPIRED,
MST.ADDRESS, MST.PHONE, MST.MOBILE, MST.FAX, MST.EMAIL, MST.CUSTODYCD||'.'||af.Typename CUSTODYCDTYPE
FROM AFMAST DTL, CFMAST MST, ALLCODE CD1, aftype af
WHERE DTL.CUSTID=MST.CUSTID
AND CD1.CDTYPE='CF' AND CD1.CDNAME='IDTYPE' AND MST.IDTYPE=CD1.CDVAL
AND dtl.actype = af.actype;
