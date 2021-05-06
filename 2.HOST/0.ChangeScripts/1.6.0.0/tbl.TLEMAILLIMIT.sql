create table TLEMAILLIMIT
(
  tlid             VARCHAR2(4),
  tlname           VARCHAR2(50),
  tltitle          VARCHAR2(100),
  email            VARCHAR2(100),
  t_advancelimit   NUMBER(20) default 0,
  f_advancelimit   NUMBER(20) default 0,
  t_totaltranlimit NUMBER(20) default 0,
  f_totaltranlimit NUMBER(20) default 0,
  brid             VARCHAR2(4),
  readvancelimit   NUMBER(20),
  retotaltranlimit NUMBER(20)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );