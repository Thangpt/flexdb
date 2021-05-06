-- Create table
create table TCDTRECEIVEREQUESTEXT
(
  autoid    NUMBER,
  txdate    DATE,
  txnum     VARCHAR2(50),
  tranid    VARCHAR2(50) not null,
  trandate  VARCHAR2(50),
  bankcode  VARCHAR2(50),
  bankaccno VARCHAR2(50),
  custodycd VARCHAR2(50),
  afacctno  VARCHAR2(50),
  amount    NUMBER,
  ccycd     VARCHAR2(50),
  trandesc  VARCHAR2(500),
  signature VARCHAR2(500),
  createdt  TIMESTAMP(6) default SYSTIMESTAMP,
  status    CHAR(1) default 'N',
  errorcode VARCHAR2(50),
  errordesc VARCHAR2(500)
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table TCDTRECEIVEREQUESTEXT add primary key (TRANID);

create table TCDTRECEIVEREQUESTEXTHIST
(
  autoid    NUMBER,
  txdate    DATE,
  txnum     VARCHAR2(50),
  tranid    VARCHAR2(50) not null,
  trandate  VARCHAR2(50),
  bankcode  VARCHAR2(50),
  bankaccno VARCHAR2(50),
  custodycd VARCHAR2(50),
  afacctno  VARCHAR2(50),
  amount    NUMBER,
  ccycd     VARCHAR2(50),
  trandesc  VARCHAR2(500),
  signature VARCHAR2(500),
  createdt  TIMESTAMP(6) default SYSTIMESTAMP,
  status    CHAR(1) default 'N',
  errorcode VARCHAR2(50),
  errordesc VARCHAR2(500)
);
