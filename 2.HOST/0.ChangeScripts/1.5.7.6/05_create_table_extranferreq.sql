-- Create sequence 
DROP SEQUENCE SEQ_EXTRANFERREQ;
create sequence SEQ_EXTRANFERREQ
minvalue 1
maxvalue 999999999999999
start with 1
increment by 1
cache 100;
-- Create table
DROP TABLE EXTRANFERREQ;
create table EXTRANFERREQ
(
   autoid            NUMBER,
   txdate            DATE,
   afacctno          VARCHAR2(10),
   bankid            VARCHAR2(20),
   benefbank         VARCHAR2(100),
   benefacct         VARCHAR2(20),
   benefcustname     VARCHAR2(100),
   beneflicense      VARCHAR2(20),
   amount            NUMBER(20),
   feeamt            NUMBER(20),
   vatamt            NUMBER(20),
   txdesc            VARCHAR2(200),
   ipaddress         VARCHAR2(50),
   via               VARCHAR2(1),
   validationtype    VARCHAR2(2),
   devicetype        VARCHAR2(10),
   device            VARCHAR2(200),
   status            VARCHAR2(1),
   curcashamt        NUMBER(20),
   curadvamt         NUMBER(20),
   cashamt           NUMBER(20),
   advamt            NUMBER(20),
   aprvid            VARCHAR2(10)
);
-- Create/Recreate indexes 
create index IDX_EXTRANFERREQ_TXDATE on EXTRANFERREQ(TXDATE);
create index IDX_EXTRANFERREQ_AFACCTNO on EXTRANFERREQ(AFACCTNO);
