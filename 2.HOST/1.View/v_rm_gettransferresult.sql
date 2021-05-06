create or replace force view v_rm_gettransferresult as
(/*select "REQID","OBJTYPE","OBJNAME","TRFCODE","REFCODE","OBJKEY","TXDATE","BANKCODE","BANKACCT","AFACCTNO","TXAMT","NOTES","STATUS","REFTXNUM","REFTXDATE","REFVAL","AFFECTDATE","ERRORCODE","CREATEDATE","GRPREQID","VIA","DIRBANKCODE","DIRBANKNAME","DIRBANKCITY","DIRACCNAME","TRNREF" from crbtxreq
where status in ('S','E') and via ='DIR' and trnref is not null and errorcode <>'-670051'*/

select mst.REQID, '' OBJTYPE,
    mst.OBJNAME, mst.TRFCODE,
    TO_CHAR(mst.TXDATE,'DD/MM/RRRR') || mst.TXNUM REFCODE,
    mst.TXNUM OBJKEY ,
    TO_CHAR(mst.TXDATE,'DD/MM/RRRR') TXDATE,
    bm.BankCode BANKCODE, mst.Account BANKACCT,
    mst.acctno AFACCTNO, mst.Amount TXAMT,
    mst.NOTES, mst.STATUS,
    '' REFTXNUM,'' REFTXDATE,'' REFVAL,
    TO_CHAR(mst.TXDATE,'DD/MM/RRRR') AFFECTDATE,
    mst.ERRORCODE,
    TO_CHAR(mst.TXDATE,'DD/MM/RRRR') CREATEDATE,
    '' GRPREQID, 'DIR' VIA,
    bm.BankCode DIRBANKCODE,
    bl.BankName DIRBANKNAME,
    bl.regional DIRBANKCITY,
    cf.fullname DIRACCNAME,
    mst.TRNREF, bm.BankId
From TCDTBankRequest mst
    INNER JOIN CRBBANKMAP bm ON substr(mst.Account,1,3) = bm.BankId
    INNER JOIN CRBBANKLIST bl ON bm.BankCode = bl.BankCode
    INNER JOIN afmast af ON mst.acctno = af.acctno
    INNER JOIN cfmast cf ON af.custid = cf.custid
where mst.status in ('S','E') And trnref is not null and mst.ERRORCODE <>'-670051'
--    And mst.BankCode = '202'
)
;

