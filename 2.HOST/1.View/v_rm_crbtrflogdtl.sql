CREATE OR REPLACE FORCE VIEW V_RM_CRBTRFLOGDTL AS
SELECT LG.AUTOID,LG.VERSION, REQ.OBJNAME, REQ.TXDATE,REQ.AFFECTDATE, REQ.OBJKEY, REQ.REFCODE,
CASE WHEN NVL(SEC.SYMBOL,'N/A')='N/A' THEN
    CASE WHEN cspks_rmproc.is_number(SUBSTR(REQ.REFCODE,0,1))=1 THEN '' ELSE REQ.REFCODE END
ELSE SEC.SYMBOL END SYMBOL,
REQ.AFACCTNO,CF.CUSTODYCD,CF.FULLNAME,REQ.BANKACCT BANKACCTNO,REQD.DESACCTNO_R DESACCTNO,REQD.DESACCTNAME_R DESACCTNAME, LGD.AMT TXAMT,
LGD.REFNOTES NOTES, A0.CDCONTENT DESC_STATUS,LGD.ERRMSG ERRDESC
FROM CRBTRFLOG LG, CRBTRFLOGDTL LGD, CRBTXREQ REQ, (
    SELECT *
    FROM  (
        SELECT DTL.REQID, DTL.FLDNAME, NVL(DTL.CVAL,DTL.NVAL) REFVAL
        FROM   CRBTXREQ MST, CRBTXREQDTL DTL WHERE MST.STATUS IN ('P','A','E','C','O','D','B') AND MST.REQID=DTL.REQID
    ) PIVOT  (MAX(REFVAL) AS R FOR (FLDNAME) IN ('DESACCTNO' as DESACCTNO,
              'DESACCTNAME' AS DESACCTNAME,'BANKNAME' AS BANKNAME))
    ORDER BY REQID
) REQD
,ALLCODE A0,SECURITIES_INFO SEC,AFMAST AF,CFMAST CF
WHERE LG.VERSION=LGD.VERSION AND LG.TRFCODE=LGD.TRFCODE AND LGD.REFREQID=REQ.REQID
AND REQ.REQID=REQD.REQID AND LG.AFFECTDATE=REQ.AFFECTDATE AND LG.TXDATE=LGD.TXDATE
AND A0.CDTYPE='RM' AND A0.CDNAME='TRFLOGDTLSTS' AND A0.CDVAL=LGD.STATUS
AND REQ.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND REQ.REFCODE = SEC.CODEID(+);

