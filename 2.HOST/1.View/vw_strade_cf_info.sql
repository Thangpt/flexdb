CREATE OR REPLACE FORCE VIEW VW_STRADE_CF_INFO AS
SELECT cf.custodycd,af.acctno , aft.typename, cf.fullname, cf.address, cf.idcode, cf.idplace, cf.idtype, cf.iddate, af.status afstatus, ci.status cistatus,
fn_getDefaultAcctno(af.custid, af.acctno) IsDefault
FROM cfmast cf, afmast af, cimast ci, aftype aft
WHERE cf.custid = af.custid
AND af.acctno = ci.afacctno
AND af.actype = aft.actype;

