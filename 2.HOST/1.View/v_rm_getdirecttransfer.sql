create or replace force view v_rm_getdirecttransfer as
(
Select mst.REQID, mst.TRFCODE,
    TO_CHAR(mst.TXDATE,'DD/MM/RRRR') ||  mst.txnum REFCODE,
    mst.txnum OBJKEY,
    TO_CHAR(mst.TXDATE,'DD/MM/RRRR') TXDATE,
    mst.BankCode BANKCODE, bl.BankCode DIRBANKCODE,
    mst.Account BANKACCT, mst.benefcustname accname,
    mst.acctno AFACCTNO, mst.Amount TXAMT,
    mst.NOTES, cf.custodycd,
    bl.BankName  BANKNAME, bl.regional BANKCITY,
    fn_gettcdtdesbankacc(substr(mst.acctno,1,4)) DESACCTNO,
    fn_gettcdtdesbankname(substr(mst.acctno,1,4)) DESACCTNAME
from TCDTBankRequest mst
    INNER JOIN CRBBANKMAP bm ON substr(mst.Account,1,3) = bm.BankId
    INNER JOIN CRBBANKLIST bl ON bm.BankCode = bl.BankCode
    INNER JOIN afmast af ON mst.acctno = af.acctno
    INNER JOIN cfmast cf ON af.custid = cf.custid
WHERE mst.status = 'P'
);

