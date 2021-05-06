create table TBLINTCHANGEHIST
(
  autoid       NUMBER default 0,
  txdate       DATE,
  tlid         VARCHAR2(10),
  fileid       VARCHAR2(20),
  custodycd    VARCHAR2(20),
  afacctno     VARCHAR2(20),
  lntype       VARCHAR2(10),
  rate1a       NUMBER(10,4),
  rate2a       NUMBER(10,4),
  rate3a       NUMBER(10,4),
  cfrate1a     NUMBER(10,4),
  cfrate2a     NUMBER(10,4),
  cfrate3a     NUMBER(10,4),
  autoapplynew CHAR(1),
  alllnschd    CHAR(1),
  fdate        DATE,
  tdate        DATE,
  status       CHAR(1) default 'A',
  deltd        VARCHAR2(1) default 'N',
  errmsg       VARCHAR2(200)
)
