-- Create table
create table LOGPLACEORDER
(
  autoid 	 number not null,	
  requestid      VARCHAR2(50) not null,
  orderid        VARCHAR2(50),
  via            VARCHAR2(1),
  ipaddress      VARCHAR2(30),
  validationtype VARCHAR2(2),
  devicetype     VARCHAR2(10),
  device         VARCHAR2(200)
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table LOGPLACEORDER   add primary key (autoid);
create index LOGPLACEORDER_IDX2 on LOGPLACEORDER (requestid);
create sequence SEQ_LOGPLACEORDER
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;
