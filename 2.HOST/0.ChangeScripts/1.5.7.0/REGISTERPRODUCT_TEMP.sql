
create table REGISTERPRODUCT_TEMP
(
  autoid      NUMBER default 0,
  custodycd   VARCHAR2(20),
  afacctno    VARCHAR2(100),
  producttype VARCHAR2(100),
  status      VARCHAR2(1) default 'P',
  deltd       VARCHAR2(1) default 'N',
  description VARCHAR2(500),
  errmsg      VARCHAR2(500)
);

-- Create sequence 
create sequence SEQ_REGISTERPRODUCT_TEMP
minvalue 1
maxvalue 999999999999
start with 1
increment by 1
cache 100;







