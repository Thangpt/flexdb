create table CONFIGSYSTEM
(
  groupname VARCHAR2(20),
  varname   VARCHAR2(255),
  varvalue  VARCHAR2(20),
  vardesc   VARCHAR2(255)
);

create table FOCMDCODE
(
  cmdcode VARCHAR2(50) not null,
  cmdtext VARCHAR2(1000),
  cmduse  VARCHAR2(1),
  cmdtype VARCHAR2(10),
  cmddesc VARCHAR2(500)
);

create table DURATION
(
  id            VARCHAR2(20),
  title         VARCHAR2(255),
  hasdatepicker VARCHAR2(255),
  hastimepicker VARCHAR2(255)
);

create table ACCOUNTMANAGERTABLE
(
  id      VARCHAR2(20),
  title   VARCHAR2(255),
  cmdtext VARCHAR2(255)
);

create table ACCOUNTMANAGERCOLUMN
(
  id         VARCHAR2(20),
  tableid    VARCHAR2(20),
  title      VARCHAR2(255),
  tooltip    VARCHAR2(255),
  fixedwidth VARCHAR2(10),
  sorttable  VARCHAR2(10)
);