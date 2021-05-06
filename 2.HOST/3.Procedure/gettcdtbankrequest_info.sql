CREATE OR REPLACE PROCEDURE gettcdtbankrequest_info(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR, v_TABLE IN VARCHAR2)
   IS
   v_transdate Date;
BEGIN
SELECT TO_DATE(varvalue, 'DD/MM/YYYY') into v_transdate  from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';

OPEN PV_REFCURSOR FOR
    Select mst.REQID,
    TO_CHAR(mst.TXDATE,'DD/MM/RRRR') || mst.TXNUM REFCODE,
    TO_CHAR(mst.TXDATE,'DD/MM/RRRR') TXDATE,
    mst.TXNUM OBJKEY, cf.custodycd,
    mst.acctno AFACCTNO, cf.fullname accname,
    mst.Amount TXAMT, bm.BankCode BANKCODE, mst.Account BANKACCT,
    bl.BankName  BANKNAME, bl.regional BANKCITY,
    fn_gettcdtdesbankacc(substr(mst.acctno,1,4)) DESACCTNO,
    fn_gettcdtdesbankname(substr(mst.acctno,1,4)) DESACCTNAME,
    A1.CDCONTENT STATUS, mst.NOTES, mst.ERRORDESC
from TCDTBankRequest mst
    INNER JOIN CRBBANKMAP bm ON substr(mst.Account,1,3) = bm.BankId
    INNER JOIN CRBBANKLIST bl ON bm.BankCode = bl.BankCode
    INNER JOIN afmast af ON mst.acctno = af.acctno
    INNER JOIN cfmast cf ON af.custid = cf.custid
    INNER JOIN ALLCODE A1 ON MST.STATUS = A1.CDVAL
WHERE A1.CDTYPE = 'RM'
    AND A1.CDNAME = 'CRBSTATUS'
    AND mst.BankCode = 'TCDT'
    AND mst.TXDATE = v_transdate;
EXCEPTION
    WHEN others THEN
        return;
END; -- Procedure
/

