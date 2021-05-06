--create table
create table NEWBANKGW_LOG
(
  autoid        number,
  transactionid VARCHAR2(100),
  batchid       VARCHAR2(100),
  messageid     VARCHAR2(100),
  txdate        DATE,
  txnum         VARCHAR2(20),
  trftype       VARCHAR2(1),
  acctnosum     VARCHAR2(50),
  account       VARCHAR2(50),
  benefcustname VARCHAR2(200),
  amount        NUMBER,
  ccycd         VARCHAR2(20),
  remark        VARCHAR2(500),
  bankname      VARCHAR2(100),
  bankcode      VARCHAR2(50),
  bankid        varchar2(100),
  banktime      varchar2(100),
  status        VARCHAR2(5) default 'P',
  errcode       VARCHAR2(20),
  errmsg        VARCHAR2(200),
  sendnum       number default 0,
  CONSTRAINT gw_key PRIMARY KEY (autoid)
);
/
-- Create sequence 
create sequence SEQ_NEWBANKGW_LOG
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 100;
