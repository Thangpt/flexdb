--create table
create table putfluctuationlog
(
  autoid            NUMBER,
  bankcode          varchar2(20),
  refnum            varchar2(100),
  time              number,
  amount            number,
  tranid            varchar2(100),
  trandate          date,
  bankacct          varchar2(50),
  description       varchar2(500),
  currency          varchar2(20),
  signature         varchar2(500),
  create_time       timestamp(6) default systimestamp,
  txnum             varchar2(20),
  txdate            date,
  status            varchar2(5) default 'P',
  errcode           varchar2(10),
  errmsg            varchar2(500), 
  CONSTRAINT putfluctuation_pk PRIMARY KEY (tranid)
)
/
-- Create sequence 
create sequence seq_putfluctuationlog
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 100;