create table SE2247_LOG
(
  autoid      NUMBER not null,
  txnum       VARCHAR2(10),
  txdate      DATE,
  acctno      VARCHAR2(20),
  custodycd   VARCHAR2(10),
  codeid      VARCHAR2(6),
  qtty        NUMBER(20) default 0,
  caqtty      NUMBER default 0,
  recustodycd VARCHAR2(10),
  price       NUMBER(20),
  deltd       VARCHAR2(1),
  createdt    TIMESTAMP(6) default SYSTIMESTAMP
);
