
--drop table bl_autoOrderPlan;

CREATE TABLE bl_autoOrderPlan (
   autoId                  NUMBER,
   blOrderId               VARCHAR2(20),
   time_interval           DATE,
   prediction_volume       NUMBER(20) DEFAULT 0,
   lowest_volume           NUMBER(20) DEFAULT 0,
   highest_volume          NUMBER(20) DEFAULT 0,
   volume                  NUMBER(20) DEFAULT 0,
   create_time             TIMESTAMP(6) DEFAULT SYSTIMESTAMP,
   tlid                    VARCHAR2(10),
   planInfo                VARCHAR2(1000),
   status                  VARCHAR2(1) DEFAULT 'P',
   active_time             TIMESTAMP(6),
   err_code                VARCHAR2(10),
   err_msg                 VARCHAR2(1000)
);
alter table bl_autoOrderPlan add constraint bl_autoOrderPlan_PK primary key (autoId);


create index IDX_bl_autoOrderPlan_BLORDERID on bl_autoOrderPlan (blorderid);
-- Create sequence 
create sequence SEQ_bl_autoOrderPlan
minvalue 1
maxvalue 999999999999999999999999
start with 1
increment by 1
cache 10
cycle;
