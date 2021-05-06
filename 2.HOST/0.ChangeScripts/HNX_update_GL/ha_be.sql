
create table HA_BE
(
  UserRequestID        VARCHAR2(100),
  UserRequestType      NUMBER(4) default 3,
  Username             VARCHAR2(100),
  Password             VARCHAR2(100),
  NewPassword          VARCHAR2(100), 
  date_time            TIMESTAMP(6) default systimestamp,
  msgtype              VARCHAR2(2) default 'BE',
  sendnum              NUMBER(4) default 1,
  status               VARCHAR2(1) default 'N'
);
alter table HA_BE
  add constraint HA_BE_PK unique (UserRequestID);
  
create sequence SEQ_BE_REQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 100;  