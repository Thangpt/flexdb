CREATE OR REPLACE PROCEDURE SP_FSS_QT_PROCESS_DEFAULT (qname varchar2, objqueue fss_txlog_queue_payload_type) AS
BEGIN
  --Ghi log x? lý
  INSERT INTO APPMSGLOG (ORGLOGID, ORGLOGDATE, QUEUENAME, OBJNAME, REFMSG, LOGTIME)
  VALUES (objqueue.logid, objqueue.logdate, qname, objqueue.tltxcd, to_char(objqueue.txdate,'DD/MM/YYYY') || '.' || objqueue.txnum, SYSTIMESTAMP);
  RETURN;
EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END;
/

