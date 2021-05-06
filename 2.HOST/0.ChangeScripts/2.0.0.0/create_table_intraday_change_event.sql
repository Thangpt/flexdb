-- Create table
drop table INTRADAY_CHANGE_EVENT;
create table INTRADAY_CHANGE_EVENT
(
  table_name VARCHAR2(50),
  table_key  VARCHAR2(50),
  key_value  VARCHAR2(50),
  event_time TIMESTAMP(6) default SYSTIMESTAMP,
  txdate     DATE
);
create index INTRADAY_CHANGE_NAME_IDX on INTRADAY_CHANGE_EVENT (table_name,table_key);
create index INTRADAY_CHANGE_VALUE_IDX on INTRADAY_CHANGE_EVENT (key_value);