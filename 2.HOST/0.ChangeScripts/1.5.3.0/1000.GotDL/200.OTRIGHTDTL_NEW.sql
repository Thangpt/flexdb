ALTER TABLE otrightdtl ADD VIA VARCHAR2(2);
ALTER TABLE OTRIGHTDTL MODIFY OTMNCODE VARCHAR2(40);
ALTER TABLE OTRIGHTDTL ADD CFCUSTID VARCHAR2(10);

UPDATE otrightdtl SET via = 'A' where via is null;
UPDATE otrightdtl SET otright = otright ||'N' WHERE via = 'A' and LENGTH(otright) = 6;
commit;

/

UPDATE OTRIGHTDTL O SET O.CFCUSTID  = ( SELECT af.custid  FROM afmast af WHERE o.afacctno = af.acctno);
commit;

/

create table OTRIGHTDTL_BACKUP as
select * from OTRIGHTDTL o where 0=0;

drop sequence SEQ_OTRIGHTDTL;

create sequence SEQ_OTRIGHTDTL
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

drop table OTRIGHTDTL;

create table OTRIGHTDTL
(
  autoid     NUMBER not null,
  cfcustid   VARCHAR2(10),
  authcustid VARCHAR2(10),
  otmncode   VARCHAR2(20),
  otright    VARCHAR2(10) default '''NNNNNNN''',
  deltd      VARCHAR2(1) default 'N',
  via        VARCHAR2(2) default 'A'
);
-- Create/Recreate indexes 
create index OTRD_IDX2 on OTRIGHTDTL (CFCUSTID, AUTHCUSTID);
create index OTRD_IDX on OTRIGHTDTL (AUTOID);
-- Create/Recreate primary, unique and foreign key constraints 
--alter table OTRIGHTDTL
--  add constraint OTRIGHTDTL_PK primary key (AUTOID);
-- Grant/Revoke object privileges 
--grant select on OTRIGHTDTL to READHOST;

