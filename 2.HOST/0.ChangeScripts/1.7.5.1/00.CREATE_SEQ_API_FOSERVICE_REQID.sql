--
--
create sequence SEQ_API_FOSERVICE_REQID
minvalue 0
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;
/
create table LOG_AUTOFS
(
  autoid          NUMBER not null,     
  custodycd      VARCHAR2(20),
  actype         VARCHAR2(4) not null,
  acctno         VARCHAR2(20) not null,
  fullname       VARCHAR2(1000),
  marginrate     NUMBER,
  rlsmarginrate  NUMBER,
  rtnremainamt   NUMBER,
  rtnremainamt5  NUMBER,
  rtnamt         NUMBER,
  rtnamt2        NUMBER,
  rtnamtt2       NUMBER,
  t0ovdamount    NUMBER,
  ovdamount      NUMBER,
  cidepofeeacr   NUMBER(20,4),
  totalvnd       NUMBER,
  addvnd         NUMBER,
  realsellamt    NUMBER,
  asssellamt     NUMBER,
  mrirate        NUMBER(20,4),
  mrmrate        NUMBER(20,4),
  mrlrate        NUMBER(20,4),
  calldate       VARCHAR2(20),
  calltime       VARCHAR2(20),
  phone1         VARCHAR2(50),
  email          VARCHAR2(100),
  mr0003type     VARCHAR2(6),
  rtnamountref   NUMBER,
  ovdamountref   NUMBER,
  selllostassref NUMBER,
  sellamountref  NUMBER,
  novdamt        NUMBER,
  trfbuyext      NUMBER(20),
  addvndt2       NUMBER,
  ofs            VARCHAR2(100),
  totalodamt     NUMBER,
  outstandingt2  NUMBER,
  mrcrlimitmax   NUMBER(20,4),
  setotalcallass NUMBER,
  semaxcallass   NUMBER,
  rtnamt3        NUMBER,
  rtnamt5        NUMBER,
  nyovdamt       NUMBER,
  mpovdamt       NUMBER,
  navaccount     NUMBER(20,4),
  secoutstanding NUMBER,
  brid           VARCHAR2(4),
  fullnamere     VARCHAR2(1000),
  mobilesms      VARCHAR2(400),
  careby         VARCHAR2(200),
  txdate          DATE,
  logtime         TIMESTAMP(6) default SYSTIMESTAMP,
  process         VARCHAR2(1)
)
/
-- Create table
create table ORDER_AUTOFS
(
  Autoid     NUMBER not null Primary key,
  sellorder  NUMBER,
  codeid     VARCHAR2(6),
  afacctno   VARCHAR2(20),
  symbol     VARCHAR2(80),
  quoteprice NUMBER,
  orderqtty  NUMBER,
  custid     VARCHAR2(20) not null,
  via        CHAR(1),
  pricetype  CHAR(2),
  exectype   CHAR(2),
  tradelot   NUMBER, 
  PROCESS    VARCHAR2(1),
  logtime    TIMESTAMP(6) default SYSTIMESTAMP
)
/
create table FSORDER
(
  afacctno   VARCHAR2(20),
  odtype     VARCHAR2(50),
  txdate     DATE,
  codeid     VARCHAR2(10),
  quoteqtty  NUMBER,
  quoteprice NUMBER,
  symbol     VARCHAR2(100),
  ordertime  TIMESTAMP(6) default SYSTIMESTAMP,
  STATUS 	VARCHAR2(1)
)
/
-- Create sequence 
create sequence SEQ_LOG_AUTOFS
minvalue 1
maxvalue 9999999999999999999999999999
start with 29426
increment by 1
cache 100
order;
/
-- Create sequence 
create sequence SEQ_ORDER_AUTOFS
minvalue 1
maxvalue 9999999999999999999999999999
start with 54811
increment by 1
cache 100
order;
/
create table LOG_AUTOFS_HIST
(
  autoid          NUMBER not null,     
  custodycd      VARCHAR2(20),
  actype         VARCHAR2(4) not null,
  acctno         VARCHAR2(20) not null,
  fullname       VARCHAR2(1000),
  marginrate     NUMBER,
  rlsmarginrate  NUMBER,
  rtnremainamt   NUMBER,
  rtnremainamt5  NUMBER,
  rtnamt         NUMBER,
  rtnamt2        NUMBER,
  rtnamtt2       NUMBER,
  t0ovdamount    NUMBER,
  ovdamount      NUMBER,
  cidepofeeacr   NUMBER(20,4),
  totalvnd       NUMBER,
  addvnd         NUMBER,
  realsellamt    NUMBER,
  asssellamt     NUMBER,
  mrirate        NUMBER(20,4),
  mrmrate        NUMBER(20,4),
  mrlrate        NUMBER(20,4),
  calldate       VARCHAR2(20),
  calltime       VARCHAR2(20),
  phone1         VARCHAR2(50),
  email          VARCHAR2(100),
  mr0003type     VARCHAR2(6),
  rtnamountref   NUMBER,
  ovdamountref   NUMBER,
  selllostassref NUMBER,
  sellamountref  NUMBER,
  novdamt        NUMBER,
  trfbuyext      NUMBER(20),
  addvndt2       NUMBER,
  ofs            VARCHAR2(100),
  totalodamt     NUMBER,
  outstandingt2  NUMBER,
  mrcrlimitmax   NUMBER(20,4),
  setotalcallass NUMBER,
  semaxcallass   NUMBER,
  rtnamt3        NUMBER,
  rtnamt5        NUMBER,
  nyovdamt       NUMBER,
  mpovdamt       NUMBER,
  navaccount     NUMBER(20,4),
  secoutstanding NUMBER,
  brid           VARCHAR2(4),
  fullnamere     VARCHAR2(1000),
  mobilesms      VARCHAR2(400),
  careby         VARCHAR2(200),
  txdate          DATE,
  logtime         TIMESTAMP(6) default SYSTIMESTAMP,
  process         VARCHAR2(1)
)
/
create table ORDER_AUTOFS_HIST
(
  Autoid     NUMBER not null Primary key,
  sellorder  NUMBER,
  codeid     VARCHAR2(6),
  afacctno   VARCHAR2(20),
  symbol     VARCHAR2(80),
  quoteprice NUMBER,
  orderqtty  NUMBER,
  custid     VARCHAR2(20) not null,
  via        CHAR(1),
  pricetype  CHAR(2),
  exectype   CHAR(2),
  tradelot   NUMBER, 
  PROCESS    VARCHAR2(1),
  logtime    TIMESTAMP(6) default SYSTIMESTAMP
)
/
create table FSORDER_HIST
(
  afacctno   VARCHAR2(20),
  odtype     VARCHAR2(50),
  txdate     DATE,
  codeid     VARCHAR2(10),
  quoteqtty  NUMBER,
  quoteprice NUMBER,
  symbol     VARCHAR2(100),
  ordertime  TIMESTAMP(6) default SYSTIMESTAMP,
  STATUS 	VARCHAR2(1)
)
/
DELETE FROM tblbackup WHERE FRTABLE = 'LOG_AUTOFS';
insert into tblbackup (FRTABLE, TOTABLE, TYPBK)
values ('LOG_AUTOFS', 'LOG_AUTOFS_HIST', 'N');
/
DELETE FROM tblbackup WHERE FRTABLE = 'ORDER_AUTOFS';
insert into tblbackup (FRTABLE, TOTABLE, TYPBK)
values ('ORDER_AUTOFS', 'ORDER_AUTOFS_HIST', 'N');
/
DELETE FROM tblbackup WHERE FRTABLE = 'FSORDER';
insert into tblbackup (FRTABLE, TOTABLE, TYPBK)
values ('FSORDER', 'FSORDER_HIST', 'N');
/
COMMIT;
/

