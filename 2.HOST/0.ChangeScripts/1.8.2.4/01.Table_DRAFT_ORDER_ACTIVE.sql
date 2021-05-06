
create table DRAFT_ORDER_ACTIVE
(
  autoid         NUMBER not null,
  draft_id   NUMBER,
  txdate     DATE,
  foorderid  VARCHAR2(30),
  boorderid  VARCHAR2(30),
  foacctno   VARCHAR2(30),
  activetime DATE 
);
/
create sequence SEQ_DRAFT_ORDER_ACTIVE
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;
/
insert into DRAFT_ORDER_ACTIVE(AUTOID,DRAFT_ID,TXDATE,FOORDERID,BOORDERID,FOACCTNO,ACTIVETIME)
select SEQ_DRAFT_ORDER_ACTIVE.nextval, d.draft_id, d.txdate, d.foorderid, d.boorderid, d.foacctno, d.txdate from draft_ordermap d;
commit;
/
alter table DRAFT_ORDER_ACTIVE modify activetime default sysdate;





