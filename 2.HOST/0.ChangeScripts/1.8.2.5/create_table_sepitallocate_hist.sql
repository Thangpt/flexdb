-- Create table
create table SEPITALLOCATE_HIST
(
  camastid    VARCHAR2(20) not null,
  afacctno    VARCHAR2(20),
  codeid      VARCHAR2(10),
  pitrate     NUMBER default 0,
  qtty        NUMBER(20,4),
  price       NUMBER(20,4),
  aright      NUMBER(20,4),
  orgorderid  VARCHAR2(20),
  txnum       VARCHAR2(10) not null,
  txdate      DATE not null,
  carate      NUMBER default 1,
  sepitlog_id NUMBER default 0,
  catype      VARCHAR2(3)
);
