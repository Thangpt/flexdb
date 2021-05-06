CREATE TABLE fix_message_temp(
  autoid           NUMBER,
  msgtype          VARCHAR2(10),
  ClOrdID          VARCHAR2(100),
  OrigClordid      VARCHAR2(100),
  Account          VARCHAR2(100),
  Side             VARCHAR2(10),
  Symbol           VARCHAR2(100),
  OrderQty         NUMBER,
  Price            NUMBER,
  OrdType          VARCHAR2(10),
  TimeInForc       VARCHAR2(10),
  HandlInst        VARCHAR2(10),
  TransactionTime  VARCHAR2(100),
  SenderSubID      VARCHAR2(100),
  TargetCompID     VARCHAR2(100),
  SenderCompID     VARCHAR2(100),
  TargetSubID      VARCHAR2(100),
  BeginString      VARCHAR2(10),
  status           VARCHAR2(10) DEFAULT 'P',
  errCode          VARCHAR2(100) DEFAULT '0',
  errmsg           VARCHAR2(2000),
  createDate       Timestamp(6) DEFAULT Systimestamp,
  refAccount       VARCHAR2(1000),
  refside          VARCHAR2(10),
  refPriceType     VARCHAR2(10),
  SecurityExchange VARCHAR2(100)
)
/
alter table FIX_MESSAGE_TEMP
  add constraint FIX_MESSAGE_TEMP_PK primary key (AUTOID);
/
-- Create sequence 
create sequence seq_fix_message_temp
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 10;
