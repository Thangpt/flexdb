-- Create table
create table BRANCH_TOTAL_INFO
(
  bankcode           VARCHAR2(20),
  bank_no            VARCHAR2(20),
  bank_name          VARCHAR2(200),
  is_napas           VARCHAR2(5),
  bank_smlid         VARCHAR2(100),
  branch_no          VARCHAR2(30),
  branch_name        VARCHAR2(300),
  branch_address     VARCHAR2(20),
  sys_bank_name      VARCHAR2(200),
  sys_branch_name    VARCHAR2(300),
  sys_branch_address VARCHAR2(20),
  status             VARCHAR2(5) default 'Y' -- trang thai
)