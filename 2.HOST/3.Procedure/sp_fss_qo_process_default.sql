create or replace procedure SP_FSS_QO_PROCESS_DEFAULT(qname    varchar2,
                                                      objqueue fss_objlog_queue_payload_type) as
begin
  --G?i d?n th? t?c x? lý tuong ?ng
  --**************************************************************************************************
  if instr(qname, 'FSS_QO_SENDFO2OD') > 0 then
    --Queue d?y l?nh t? FOMAST và ODMAST
    MSGPKS_PROCESSING.SP_FSS_QO_SENDFO2OD(qname, objqueue);
  elsif instr(qname, 'FSS_QO_CRBTXREQ') > 0 then
    --Queue x? lý request k?t n?i ngân hàng
    MSGPKS_PROCESSING.SP_FSS_QO_CRBTXREQ(qname, objqueue);
  elsif instr(qname, 'FSS_QO_GETCIFULL') > 0 then
    --Queue tính l?i s?c mua
    MSGPKS_PROCESSING.SP_FSS_QO_GETCIFULL(qname, objqueue);
  elsif instr(qname, 'FSS_QO_GETSEMAST') > 0 then
    --Queue tính l?i s? du ch?ng khoán
    MSGPKS_PROCESSING.SP_FSS_QO_GETSEMAST(qname, objqueue);
  elsif instr(qname, 'FSS_QO_ORDERBOOK') > 0 then
    --Queue c?p nh?t l?i thông tin s? l?nh
    MSGPKS_PROCESSING.SP_FSS_QO_ORDERBOOK(qname, objqueue);
  elsif instr(qname, 'FSS_QO_MONEY_TRF') > 0 then
    --Queue c?p nh?t l?i thông tin s? l?nh
    MSGPKS_PROCESSING.SP_FSS_QO_MoneyTransfer(qname, objqueue);
  elsif instr(qname, 'FSS_QO_PUSH2EXT') > 0 then
    --Queue notify message ra ngoài theo chu?n JMS
    MSGPKS_PROCESSING.SP_FSS_QO_PUSH2EXT(qname, objqueue);
  end if;

  --Ghi log x? lý
  insert into APPMSGLOG
    (ORGLOGID, ORGLOGDATE, QUEUENAME, OBJNAME, REFMSG, LOGTIME)
  values
    (objqueue.logid,
     objqueue.logdate,
     qname,
     objqueue.objname,
     objqueue.rcdkey,
     SYSTIMESTAMP);
  return;
exception
  when others then
    return;
end;
/

