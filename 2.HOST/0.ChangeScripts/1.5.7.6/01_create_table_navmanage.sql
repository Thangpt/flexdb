-- Create table
create table NAVMANAGE
(
  navid          VARCHAR2(16),
  frdate         DATE,
  todate         DATE,
  avlnav         NUMBER(20,4),
  DESCRIPTION    VARCHAR2(1000),
  status         VARCHAR2(4),
  pstatus        VARCHAR2(1000)
);
-- Create/Recreate indexes 
create index IDX_CFNAVLOG_AUTOID on NAVMANAGE(NAVID);
