create table DBNAVGRP
(
  actype  VARCHAR2(4) not null,
  grpname VARCHAR2(200),
  descrt  VARCHAR2(200),
  status  CHAR(1),
  pstatus VARCHAR2(100)
);
alter table DBNAVGRP add primary key (ACTYPE);