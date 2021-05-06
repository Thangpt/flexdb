CREATE OR REPLACE FORCE VIEW VW_CFRELATION_SUBACCOUNT AS
SELECT CF.CUSTODYCD FILTERCD, C.CUSTID VALUE, C.CUSTID VALUECD, C.CUSTID || ' : ' || A.CDCONTENT DISPLAY,
C.CUSTID || ' : ' || A.CDCONTENT EN_DISPLAY, C.FULLNAME DESCRIPTION
FROM cfrelation R, CFMAST C, ALLCODE A, CFMAST CF
WHERE TRIM(R.CUSTID) = CF.CUSTID AND TRIM(R.RECUSTID) = C.CUSTID AND A.CDVAL = R.RETYPE AND A.CDNAME = 'RETYPE' AND A.CDTYPE = 'CF';
