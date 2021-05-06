-- Create table
create table CFTRFLIMIT
(
   txdate            DATE,
   txnum             VARCHAR2(20),
   custid            VARCHAR2(20),
   maxtotaltrfamt    NUMBER(20),
   remaxtrfamt       NUMBER(20),
   maxtrfamt	       NUMBER(20),
   maxtrfcnt         NUMBER(20),
   status            VARCHAR(1)
);
-- Create/Recreate indexes 
create index IDX_CFTRFLIMIT_TXDATE on CFTRFLIMIT(TXDATE);
create index IDX_CFTRFLIMIT_TXNUM on CFTRFLIMIT(TXNUM);
create index IDX_CFTRFLIMIT_CUSTID on CFTRFLIMIT(CUSTID);
