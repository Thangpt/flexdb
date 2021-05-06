CREATE OR REPLACE PROCEDURE gettcdtreceiverequest_info  (PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR, v_TABLE IN VARCHAR2)
   IS
   v_transdate Date;
BEGIN

SELECT TO_DATE(varvalue, 'DD/MM/YYYY') into v_transdate  from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';

    OPEN PV_REFCURSOR FOR
SELECT CRB.autoid, CRB.txdate, CRB.transactionnumber, A1.CDCONTENT status, CRB.trnref,  CRB.trn_dt, CRB.desbankaccount, CRB.accname,
    CRB.accnum, CRB.bankcode,   CRB.branch, CRB.location, CRB.amount, CRB.keyacct1, CRB.keyacct2,  CRB.transactiondescription,
    CRB.isconfirmed, CRB.ismanual, CRB.usercreated, CRB.createdt, CRB.errordesc
FROM tcdtreceiverequest CRB, ALLCODE A1
where CRB.STATUS =A1.CDVAL AND A1.CDTYPE = 'RM' AND A1.CDNAME = 'CRBRQDSTS' 
    AND CRB.status <> 'F' AND CRB.TXDATE = v_transdate
order by autoid;

EXCEPTION
    WHEN others THEN
        return;
END; -- Procedure
/

