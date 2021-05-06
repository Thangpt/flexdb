

-- Create table
--DROP table GWINFOR
create table GWINFOR
(
  UserRequestID        NUMBER,    
  Username             VARCHAR2(100),
  Password             VARCHAR2(100),
  NewPassword          VARCHAR2(100), 
  date_time            TIMESTAMP(6) default SYSTIMESTAMP,
  txdate               DATE, 
  txnum                VARCHAR2(100),
  status               VARCHAR2(1)DEFAULT 'N',
  asetstatus           NUMBER DEFAULT '0',
  UserStatusText       VARCHAR2(1000)
  );
  
alter table GWINFOR
  add constraint GWINFOR_PK unique (UserRequestID);
  