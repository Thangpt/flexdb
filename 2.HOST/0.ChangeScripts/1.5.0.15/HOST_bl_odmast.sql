create table BL_ODMAST
(
  autoid        VARCHAR2(30) not null,
  blorderid     VARCHAR2(20),
  blacctno      VARCHAR2(50),
  afacctno      VARCHAR2(10),
  custodycd     VARCHAR2(10),
  traderid      VARCHAR2(50),
  forefid       VARCHAR2(50),
  status        VARCHAR2(1),
  pstatus       VARCHAR2(100),
  blodtype      VARCHAR2(1), -- handlinst
  exectype      VARCHAR2(3),
  pricetype     VARCHAR2(3),
  timetype      VARCHAR2(3),
  codeid        VARCHAR2(6),
  symbol        VARCHAR2(20),
  quantity      NUMBER(20) default 0,
  price         NUMBER(20,2) default 0,
  execqtty      NUMBER(20,2) default 0,
  execamt       NUMBER(20,2) default 0,
  remainqtty    NUMBER(20,2) default 0,
  cancelqtty    NUMBER(20,2) default 0,
  amendqtty     NUMBER(20,2) default 0,
  ptbookqtty    NUMBER(20,2) default 0, --not use
  sentqtty      NUMBER(20,2) default 0, --not use
  refblorderid  VARCHAR2(20),
  feedbackmsg   VARCHAR2(1000),
  activatedt    VARCHAR2(20),
  createddt     VARCHAR2(20),
  txdate        DATE,
  txnum         VARCHAR2(10),
  effdate       DATE,
  expdate       DATE,
  via           VARCHAR2(1),
  deltd         VARCHAR2(1) default 'N',
  username      VARCHAR2(300), --not use
  direct        VARCHAR2(1) default 'N',
  last_change   TIMESTAMP(6) default SYSTIMESTAMP,
  tlid          VARCHAR2(4),
  retlid        VARCHAR2(20), --not use
  pretlid       VARCHAR2(500), --not use
  ordertime     TIMESTAMP(6) default SYSTIMESTAMP,
  assigntime    TIMESTAMP(6) default SYSTIMESTAMP, --not use
  exectime      TIMESTAMP(6) default SYSTIMESTAMP,
  remngcomment  VARCHAR2(500), --not use
  reexecomment  VARCHAR2(500), --not use
  blinstruction VARCHAR2(500),
  ptsentqtty    NUMBER(20,2) default 0, --not use
  isreasd       VARCHAR2(1) default 'N', --not use
  asdtlid       VARCHAR2(10), --not use
  pasdtlid      VARCHAR2(100), --not use
  refforefid    VARCHAR2(50),
  orgquantity   NUMBER default 0,
  orgprice      NUMBER default 0,
  edstatus      VARCHAR2(1) default 'N',
  edexectype    VARCHAR2(2),
  rootorderid   VARCHAR2(20),
  app_status    VARCHAR2(1) default 'P', --not use
  execinst      VARCHAR2(100), --not use
  FIXSide        VARCHAR2(10),
  FIXOrdType     VARCHAR2(10),
  FIXTimeInForc	VARCHAR2(10),
  FIXSenderCompId	VARCHAR2(100),
  FIXCompId        VARCHAR2(100),
  beginString	VARCHAR2(10),
  hftOrderId	VARCHAR2(20),
  hftRefOrderId	VARCHAR2(20),
  origExecQtty	NUMBER DEFAULT 0,
  origExecAmt	NUMBER DEFAULT 0
);
-- Create/Recreate indexes 
create index BL_ODMAST_BLORDERID_IDX on BL_ODMAST (blorderid);
create index BL_ODMAST_FOREFID_IDX on BL_ODMAST (forefid);
-- Create/Recreate primary, unique and foreign key constraints 
alter table BL_ODMAST add constraint BL_ODMAST_PK primary key (AUTOID);

create sequence seq_bl_odmast
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 2;