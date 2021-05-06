--TBCFPREFERENTIALHIST
create table TBCFPREFERENTIALHIST
(
  autoid    NUMBER default 0,
  txdate    DATE,
  tlid      VARCHAR2(10),
  custodycd VARCHAR2(20),
  afacctno  VARCHAR2(20),
  lntype    VARCHAR2(10),
  lnid      VARCHAR2(20),
  status    CHAR(1),
  deltd     VARCHAR2(1),
  errmsg    VARCHAR2(200),
  fdate     DATE,
  tdate     DATE,
  fileid    VARCHAR2(10)
);

-- TBCFPREFERENTIAL
create table TBCFPREFERENTIAL
(
  autoid    NUMBER default 0,
  txdate    DATE,
  tlid      VARCHAR2(10),
  custodycd VARCHAR2(20),
  afacctno  VARCHAR2(20),
  lntype    VARCHAR2(10),
  lnid      VARCHAR2(20),
  status    CHAR(1) default 'P',
  deltd     VARCHAR2(1) default 'N',
  errmsg    VARCHAR2(200),
  fdate     DATE,
  tdate     DATE,
  fileid    VARCHAR2(10)
);

-- Create table
create table CFPREFERENTIAL
(
  autoid    NUMBER default 0,
  custodycd VARCHAR2(20),
  afacctno  VARCHAR2(20),
  lntype    VARCHAR2(10),
  lnid      VARCHAR2(20),
  fdate     DATE,
  tdate     DATE
);
----- Create sequence 
create sequence TBCFPREFERENTIAL_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1029
increment by 1
nocache;
