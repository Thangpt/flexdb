--
--
/
ALTER TABLE draft_order add ACTCOUNT number default 0;
/
update draft_order set actcount= 0 where actcount is null;
commit;
/
create table DRAFT_ORDER_LOG
(
  autoid          NUMBER not null,
  order_group_old NUMBER,
  order_group     NUMBER,
  userid_old      VARCHAR2(20),
  userid          VARCHAR2(20),
  acctno_old      VARCHAR2(20),
  acctno          VARCHAR2(20),
  custodycd_old   VARCHAR2(20),
  custodycd       VARCHAR2(20),
  exectype_old    VARCHAR2(10),
  exectype        VARCHAR2(10),
  symbol_old      VARCHAR2(50),
  symbol          VARCHAR2(50),
  qtty_old        NUMBER,
  qtty            NUMBER,
  pricetype_old   VARCHAR2(20),
  pricetype       VARCHAR2(20),
  price_old       NUMBER,
  price           NUMBER,
  amt_old         NUMBER,
  amt             NUMBER,
  logtime         TIMESTAMP(6) default systimestamp
);
/
create sequence seq_draft_order_log;

