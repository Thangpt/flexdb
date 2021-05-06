-- Create table LNTYPEXT
create table LNTYPEXT
(
  lnid      VARCHAR2(20) not null,
  lnname    VARCHAR2(100),
  status    CHAR(1) default 'P',
  pstatus   VARCHAR2(50),
  apprv_sts CHAR(1) default 'P'
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table LNTYPEXT
  add constraint PK_LNID primary key (LNID)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
/
-- Create table LNINTSTEP
create table LNINTSTEP
(
  autoid  NUMBER(20),
  lnid    VARCHAR2(20),
  fval    NUMBER,
  tval    NUMBER,
  rate1   NUMBER(10,4),
  rate2   NUMBER(10,4),
  rate3   NUMBER(10,4),
  lnlevel NUMBER(20)
);
/