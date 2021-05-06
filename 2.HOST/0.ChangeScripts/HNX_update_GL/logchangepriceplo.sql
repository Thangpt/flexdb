create table logchangepriceplo
(
  autoid      NUMBER default 0 not NULL PRIMARY KEY,
  orderid     VARCHAR2(20) not null,
  sysdates     DATE,
  oldprice     number,
  newprice     number
);
-- Create sequence 
create sequence SEQ_LOGCHANGEPRICEPLO
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

CREATE INDEX logchangepriceplo_orderid_idx ON logchangepriceplo
  (
    "ORDERID" DESC
  ) 
/
