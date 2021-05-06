CREATE table IPLOG
(
  autoid      NUMBER default 0 not NULL PRIMARY KEY,
  txnum       VARCHAR2(20) not NULL,
  txdate      DATE not NULL,
  ipaddress   VARCHAR2(20),
  via         VARCHAR2(1) default '',
  otauthtype  VARCHAR2(2) default '',
  devicetype  VARCHAR2(10),
  device      VARCHAR2(200),
  errorcode   VARCHAR2(10),
  sysdates     DATE
);
-- Create sequence 
create sequence SEQ_IPLOG
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;
-- Create/Recreate indexes 
create index iplog_txnum_ind on IPLOG (txnum);
create index iplog_txdate_ind on IPLOG (txdate);
