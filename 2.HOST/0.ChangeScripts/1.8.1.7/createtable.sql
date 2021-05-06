--
--
/
create table draft_order
(
autoid            number,
order_group       number,
userid			  varchar2(20),
acctno            varchar2(20),
custodycd         varchar2(20),
txdate            date,
exectype          varchar2(10),
symbol            varchar2(50),
qtty              number,
pricetype         varchar2(20),
price             number,
amt               number,
bo_orderid        varchar2(50),
fo_orderid        varchar2(50),
fo_acctno		  varchar2(50),
status            varchar2(10) default 'P',
errcode           varchar2(20),
errmsg            varchar2(1000),
PRIMARY KEY(autoid)      
);
/
create sequence SEQ_DRAFT_ORDER
minvalue 0
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;
/
create table draft_order_group
(
id                number, -- mã nhóm
group_name        varchar2(500), -- tên nhóm
userid            varchar2(20), -- userid
note			  varchar2(500), -- ghi chú
deltd             varchar2(10) default 'N',
primary key (id, userid)
);
/
create sequence SEQ_DRAFT_ORDER_GROUP
minvalue 0
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;
/
create table DRAFT_ORDERMAP
(
  draft_id	   NUMBER,
  txdate       DATE,
  foorderid    VARCHAR2(30),
  boorderid    VARCHAR2(30),
  foacctno     VARCHAR2(30),
  PRIMARY KEY (draft_id, txdate)
);
/
alter table draft_order add lastordertime varchar2(20);
/
CREATE INDEX draft_order_group_userid
ON draft_order(order_group,userid);
/
CREATE INDEX draft_order_userid
ON draft_order(userid);
/
CREATE INDEX draft_order_groupid
ON draft_order(order_group);
/



