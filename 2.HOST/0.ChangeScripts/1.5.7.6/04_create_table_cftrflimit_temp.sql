-- Create sequence 
create sequence SEQ_CFTRFLIMIT_TEMP
minvalue 1
maxvalue 999999999999999
start with 1
increment by 1
cache 100;
-- Create table
create table CFTRFLIMIT_TEMP
(
   autoid            NUMBER,
   custodycd         VARCHAR2(20),
   maxtotaltrfamt    NUMBER(20,4),
   remaxtrfamt       NUMBER(20,4),
   maxtrfamt         NUMBER(20,4),
   maxtrfcnt         NUMBER(20,4),
   status            VARCHAR2(1) DEFAULT 'P',
   errmsg            VARCHAR2(500)
);
