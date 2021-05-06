CREATE OR REPLACE PROCEDURE CI0061
   (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   PV_REF         IN       VARCHAR2

   )
   IS

   v_BANKCODE VARCHAR2(500);
   v_CUSTODYCD VARCHAR2(20);
   v_CUSTBANK VARCHAR2(20);

BEGIN



  /*  IF PV_BANKCODE='ALL' THEN
        v_BANKCODE:='%%';
     ELSE
        SELECT DECODE(RRTYPE,'B', CUSTBANK, NULL) INTO v_CUSTBANK FROM ADTYPE WHERE ACTYPE= PV_BANKCODE  ;
        SELECT SHORTNAME INTO v_BANKCODE FROM CFMAST WHERE CUSTID=v_CUSTBANK;
    END IF;*/


    OPEN PV_REFCURSOR
    FOR

SELECT * FROM
(
    SELECT PV_REF BCODE_IN, LGDTL.VERSION,  MST.OBJNAME, TO_DATE(LOG.CVALUE,'DD/MM/YYYY') DUEDATE, MST.TXDATE, MST.OBJKEY, MST.NOTES,FN_CRB_GETVOUCHERNO(LG.TRFCODE, LG.TXDATE, LG.VERSION) VOUCHERNO,
        MST.AFACCTNO, MST.BANKCODE, MST.BANKACCT, MST.STATUS, MST.TXAMT, CF.CUSTODYCD, CF.FULLNAME, CF.ADDRESS, CF.IDCODE LICENSE, CF.IDDATE, CF.IDPLACE, LGDTL.AMT, RF.*
        FROM CFMAST CF, AFMAST AF, CRBTXREQ MST, CRBTRFLOG LG, CRBTRFLOGDTL LGDTL, AFTYPE TYP, ADTYPE AD,
         (SELECT * FROM
            (SELECT * FROM tllogfld
            UNION ALL
            SELECT * FROM tllogfldall)
           ) LOG,
        (SELECT *
        FROM   (SELECT DTL.REQID, DTL.FLDNAME, NVL(DTL.CVAL,DTL.NVAL) REFVAL
                FROM   CRBTXREQ MST, CRBTXREQDTL DTL WHERE MST.REQID=DTL.REQID )
        PIVOT  (MAX(REFVAL) AS R FOR (FLDNAME) IN  ('ORDATE' as ORDATE, 'DAYS' as DAYS, 'ADVAMT' as ADVAMT, 'BNKFEEAMT' as BNKFEEAMT, 'BNKRATE' as BNKRATE, 'CFEEAMT' as CFEEAMT, 'FEEAMT' as FEEAMT))
        ORDER BY REQID) RF
        WHERE CF.CUSTID=AF.CUSTID
        AND AF.ACCTNO=MST.AFACCTNO
        AND AF.ACTYPE = TYP.ACTYPE
        AND TYP.ADTYPE = AD.ACTYPE
        AND MST.REQID=RF.REQID
        AND LG.VERSION = LGDTL.VERSION
        AND LG.TXDATE = LGDTL.TXDATE
        AND LG.TRFCODE = LGDTL.TRFCODE
        AND LGDTL.REFREQID = MST.REQID
        AND LG.TRFCODE = 'TRFADVFRBANK'
        AND LOG.TXNUM = MST.OBJKEY
        AND LOG.TXDATE = MST.TXDATE
        AND LOG.FLDCD = '08'

    UNION ALL

      SELECT  PV_REF BCODE_IN, LGDTL.VERSION, MST.OBJNAME,
            SCHD.CLEARDT DUEDATE,
             MST.TXDATE, MST.OBJKEY, MST.NOTES,FN_CRB_GETVOUCHERNO(LG.TRFCODE, LG.TXDATE, LG.VERSION) VOUCHERNO,
            MST.AFACCTNO, MST.BANKCODE, MST.BANKACCT, MST.STATUS, MST.TXAMT, CF.CUSTODYCD, CF.FULLNAME, CF.ADDRESS, CF.IDCODE LICENSE, CF.IDDATE, CF.IDPLACE, LGDTL.AMT, RF.*

          FROM CFMAST CF, AFMAST AF, CRBTXREQ MST, CRBTRFLOG LG, CRBTRFLOGDTL LGDTL, ADTYPE ADT,
                (
                   select * from adschd
                   union all
                   select * from adschdhist
                ) SCHD,  vw_tllogfld_all LOG,
                (SELECT *
                FROM   (SELECT DTL.REQID, DTL.FLDNAME, NVL(DTL.CVAL,DTL.NVAL) REFVAL
                        FROM   CRBTXREQ MST, CRBTXREQDTL DTL WHERE MST.REQID=DTL.REQID )
                PIVOT  (MAX(REFVAL) AS R FOR (FLDNAME) IN  ('ORDATE' as ORDATE, 'DAYS' as DAYS, 'ADVAMT' as ADVAMT, 'BNKFEEAMT' as BNKFEEAMT, 'BNKRATE' as BNKRATE, 'CFEEAMT' as CFEEAMT,'FEEAMT' as FEEAMT))
                ORDER BY REQID) RF

                WHERE CF.CUSTID=AF.CUSTID
                AND AF.ACCTNO=MST.AFACCTNO
                AND MST.REQID=RF.REQID
                AND LG.VERSION = LGDTL.VERSION
                AND LG.TXDATE = LGDTL.TXDATE
                AND LG.TRFCODE = LGDTL.TRFCODE
                AND LGDTL.REFREQID = MST.REQID
                AND LG.TRFCODE = 'TRFADVFRBANK'
                AND LOG.TXNUM = MST.OBJKEY
                AND LOG.TXDATE = MST.TXDATE
                AND LOG.FLDCD = '01'
                AND LOG.CVALUE = TO_CHAR(SCHD.AUTOID)
                AND MST.OBJNAME = '1178'
                AND SCHD.ADTYPE = ADT.ACTYPE
)AD

WHERE lpad(AD.VERSION, 3,'0') = SUBSTR(PV_REF,15,3)
AND AD.TXDATE = TO_DATE((SUBSTR(PV_REF,9,2) || '/' || SUBSTR(PV_REF,11,2)  || '/' || '20' || SUBSTR(PV_REF,13,2)),'DD/MM/YYYY')

;



EXCEPTION
    WHEN OTHERS THEN
        RETURN ;
END; -- Procedure
/

