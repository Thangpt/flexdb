
--drop table bl_mapOrder;
--drop table bl_odmast_processing;

CREATE TABLE bl_mapOrder (
   mapId           VARCHAR2(30),
   blOrderId       VARCHAR2(20),
   qtty            NUMBER(20) DEFAULT 0,
   price           NUMBER(20,2) DEFAULT 0,
   priceType       VARCHAR2(10),
   execType        VARCHAR2(10),
   exQtty          NUMBER(23),
   exExecType      VARCHAR2(10),
   execQtty        NUMBER(23) DEFAULT 0,
   execAmt         NUMBER(23) DEFAULT 0,
   remainQtty      NUMBER(23) DEFAULT 0,
   cancelQtty      NUMBER(23) DEFAULT 0,
   txTime          VARCHAR2(20) DEFAULT TO_CHAR(sysdate, 'HH24:MI:SS'),
   refMapId        VARCHAR2(30),
   hftOrderId      VARCHAR2(20),
   hftRefOrderId   VARCHAR2(20),
   tlid            VARCHAR2(10),
   status          VARCHAR2(1) DEFAULT 'P',
   pStatus         VARCHAR2(1000),
   errMsg          VARCHAR2(1000),
   last_change     TIMESTAMP(6) DEFAULT SYSTIMESTAMP;
);
alter table bl_mapOrder add constraint BL_MAPORDER_PK primary key (mapId);
create index IDX_bl_mapOrder_BLORDERID on bl_mapOrder (blorderid);
create index IDX_bl_mapOrder_hftOrderId on bl_mapOrder (hftOrderId);


CREATE TABLE bl_odmast_processing (
  blorderid   VARCHAR2(30),
  eventName   VARCHAR2(100),
  createTime  TIMESTAMP(6) DEFAULT systimestamp
);
alter table BL_ODMAST_PROCESSING add constraint BL_ODMAST_PROCESSING_PK primary key (BLORDERID);