create table BRANCH
(
  autoid    NUMBER not null,
  branchid   VARCHAR2(4) not null,
  email   VARCHAR2(400),
  areaid  VARCHAR2(4),
  CONSTRAINT branch_pk PRIMARY KEY (autoid)
);
