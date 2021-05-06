-- Create table
create table CFNAVLOG
(
  txdate         DATE,
  custid	       VARCHAR2(20),
  balance        NUMBER(20,4) default 0,
  advamt         NUMBER(20,4) default 0,
  etmassetamt    NUMBER(20,4) default 0,
  debtamt        NUMBER(20,4) default 0,
  navamt         NUMBER(20,4) default 0,
  deltd          CHAR(1) default 'N'
);
-- Create/Recreate indexes 
create index IDX_CFNAVLOG_CUSTID on CFNAVLOG(CUSTID);
create index IDX_CFNAVLOG_TXDATE on CFNAVLOG(TXDATE);
