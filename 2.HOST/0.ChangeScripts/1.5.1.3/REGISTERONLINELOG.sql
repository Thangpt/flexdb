DROP TABLE REGISTERONLINELOG;
-- Create table
create table REGISTERONLINELOG
(
  autoid                  NUMBER(10) not NULL PRIMARY KEY,
  customertype            VARCHAR2(3),
  customername            VARCHAR2(100),
  customerbirth           DATE,
  idtype                  VARCHAR2(3),
  idcode                  VARCHAR2(120),
  iddate                  DATE,
  idplace                 VARCHAR2(200),
  expiredate              DATE,
  mobile                  VARCHAR2(20),
  email                   VARCHAR2(120),
  country                 VARCHAR2(100),
  customercity            VARCHAR2(100),
  sex                     VARCHAR2(3),
  contactaddress          VARCHAR2(1000),
  custodycd               VARCHAR2(10),
  brid                    VARCHAR2(5),
  txdate                  DATE,
  deletedate              DATE
);
-- Create sequence 
create sequence SEQ_REGISTERONLINELOG
minvalue 1
maxvalue 9999999999999999999999999999
start with 21
increment by 1
cache 20;