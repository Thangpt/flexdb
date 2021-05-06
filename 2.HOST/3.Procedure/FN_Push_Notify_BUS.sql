create or replace function FN_Push_Notify_BUS(pv_type in varchar2)
return TIMESTAMP
is
 pv_ref pkg_report.ref_cursor;
 enq_msgid RAW(16);
 l_content VARCHAR2(4000);
begin
  IF pv_type = 'PUSH2FO' THEN
     OPEN pv_ref for
     SELECT 'C' MSGTYPE, 'HB' EVENTTYPE, TO_CHAR(SYSTIMESTAMP, 'RRRR-MM-DD HH24:MI:SS.FF') TIME
     FROM dual;

     txpks_NOTIFY.PR_NOTIFYEVENT2FO(pv_ref, 'PUSH2FO');
  END IF;
  return SYSTIMESTAMP;
EXCEPTION
  WHEN OTHERS THEN
    return NULL;
end FN_Push_Notify_BUS;
/
