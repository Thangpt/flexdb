CREATE OR REPLACE FORCE VIEW V_RM_GETTRFQUEUEDTL AS
SELECT CRD.AUTOID,CRD.VERSION,CRD.TXDATE,REQ.AFFECTDATE,REQ.OBJNAME,REQ.OBJKEY, REQ.BANKCODE,REQ.TRFCODE,
CF.CUSTODYCD,CRD.AFACCTNO,AF.BANKACCTNO,CF.FULLNAME BANKACCTNAME,NVL(REQD.DESACCTNO_R,'N/A') DESACCTNO,
NVL(REQD.DESACCTNAME_R,'N/A') DESACCTNAME,CRD.AMT,CRD.REFNOTES DESCRIPTIONS,CRD.REFHOLDID
FROM CRBTRFLOGDTL CRD,CRBTXREQ REQ,AFMAST AF,CFMAST CF,(
    SELECT *
    FROM  (
        SELECT DTL.REQID, DTL.FLDNAME, NVL(DTL.CVAL,DTL.NVAL) REFVAL
        FROM   CRBTXREQ MST, CRBTXREQDTL DTL WHERE MST.STATUS IN ('P','A','E','C','O') AND MST.REQID=DTL.REQID
    ) PIVOT  (MAX(REFVAL) AS R FOR (FLDNAME) IN ('DESACCTNO' as DESACCTNO,
              'DESACCTNAME' AS DESACCTNAME,'BANKNAME' AS BANKNAME))
    ORDER BY REQID
) REQD
WHERE CRD.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID
AND REQ.REQID=REQD.REQID(+)
AND CRD.REFREQID = REQ.REQID AND CRD.STATUS='P'
ORDER BY CRD.AUTOID;

