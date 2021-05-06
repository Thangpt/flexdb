ALTER TABLE otright ADD SERIALNUMSIG VARCHAR2(200);
ALTER TABLE otright ADD VIA VARCHAR2(2);
ALTER TABLE otright ADD CFCUSTID VARCHAR2(10);
/

UPDATE otright SET via = 'A' where via is null;
commit;

/

UPDATE OTRIGHT O SET O.CFCUSTID  = ( SELECT af.custid  FROM afmast af WHERE o.afacctno = af.acctno);
commit;

/

create table OTRIGHT_BACKUP as
select * from OTRIGHT o where 0=0;
drop sequence SEQ_OTRIGHT;
create sequence SEQ_OTRIGHT
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;
drop table OTRIGHT;
-- Create table
create table OTRIGHT
(
  autoid       NUMBER not null,
  cfcustid     VARCHAR2(10),
  authcustid   VARCHAR2(10),
  authtype     VARCHAR2(1) default '0',
  valdate      DATE,
  expdate      DATE,
  deltd        VARCHAR2(1) default 'N',
  lastdate     DATE,
  lastchange   DATE default SYSDATE,
  serialnumsig VARCHAR2(100),
  via          VARCHAR2(2) default 'A'
);
-- Create/Recreate indexes 
create index OTR_NEW_IDX2 on OTRIGHT (CFCUSTID, AUTHCUSTID);
create index OTR_NEW_IDX on OTRIGHT (AUTOID);
-- Create/Recreate primary, unique and foreign key constraints 
--alter table OTRIGHT_NEW
--  add constraint OTRIGHT_PK primary key (AUTOID);
-- Grant/Revoke object privileges 
--grant select on OTRIGHT_NEW to READHOST;


