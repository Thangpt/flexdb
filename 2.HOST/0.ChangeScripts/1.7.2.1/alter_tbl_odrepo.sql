--
--
/
alter table tbl_odrepo
add(
  grporder      VARCHAR2(2) default 'N',
  afacctno      VARCHAR2(10),
  clearday      NUMBER default 0,
  remainqtty    NUMBER default 0,
  execqtty      NUMBER default 0,
  execamt       NUMBER default 0,
  txdate2       DATE,
  clearday2     NUMBER default 0,
  quoteprice2   NUMBER default 0,
  orderqtty2    NUMBER default 0,
  remainqtty2   NUMBER default 0,
  execqtty2     NUMBER default 0,
  execamt2      NUMBER default 0);
/
