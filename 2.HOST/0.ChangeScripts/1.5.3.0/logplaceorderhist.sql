-- Create table
create table LOGPLACEORDERHIST
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
alter table LOGPLACEORDERHIST  add primary key (autoid);
