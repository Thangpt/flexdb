create or replace force view v_busiodstatus as
(
select iod.orgorderid orderid, iod.symbol,iod.MATCHPRICE,iod.MATCHQTTY,af.custid ,iod.txnum,iod.txdate,iod.txtime
from iod,odmast od,afmast af where iod.orgorderid=od.orderid
and od.afacctno=af.acctno);

