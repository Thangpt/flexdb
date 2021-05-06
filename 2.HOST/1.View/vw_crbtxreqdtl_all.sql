CREATE OR REPLACE FORCE VIEW VW_CRBTXREQDTL_ALL AS
(
SELECT autoid, reqid, fldname, cval, nval  FROM crbtxreqdtl
UNION ALL
SELECT autoid, reqid, fldname, cval, nval  FROM crbtxreqdtlHIST);

