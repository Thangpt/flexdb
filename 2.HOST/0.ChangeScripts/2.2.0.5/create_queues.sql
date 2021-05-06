/*=======================================================================
    QUEUES SECTION
=======================================================================*/
-- Grant
--grant execute on dbms_aqadm to HOST64;
--grant execute on dbms_aq to HOST64;
--grant execute on dbms_aqin to HOST64;
--grant execute on dbms_aqjms to HOST64;
--GRANT Aq_administrator_role, aq_user_role TO HOST64;
--exec dbms_aqadm.grant_system_privilege('ENQUEUE_ANY','HOST64');
--exec dbms_aqadm.grant_system_privilege('DEQUEUE_ANY','HOST64');
--create queue table
BEGIN
    DBMS_AQADM.stop_queue(queue_name=>'PUSH2FO');
    DBMS_AQADM.drop_queue(queue_name=>'PUSH2FO',auto_commit=>TRUE);
EXCEPTION WHEN OTHERS THEN
NULL;
END;
/
BEGIN    
    DBMS_AQADM.DROP_QUEUE_TABLE('PUSH2FO_queue_table', FORCE=>TRUE, AUTO_COMMIT=>TRUE);
EXCEPTION WHEN OTHERS THEN
NULL;
END;
/
BEGIN
    DBMS_AQADM.CREATE_QUEUE_TABLE (queue_table => 'PUSH2FO_queue_table',multiple_consumers => FALSE,queue_payload_type => 'SYS.AQ$_JMS_TEXT_MESSAGE');
end;
/

--create queue instance
begin
    DBMS_AQADM.CREATE_QUEUE (queue_name => 'PUSH2FO',queue_table => 'PUSH2FO_queue_table');
end;
/

--start queues
begin
    DBMS_AQADM.START_QUEUE (queue_name => 'PUSH2FO');
end;
/
/*
--Drop queue table with force parameter 
exec dbms_aqadm.drop_queue_table(QUEUE_TABLE=>'FSS_QT_BASED_TABLE', FORCE=>TRUE, AUTO_COMMIT=>TRUE);
exec dbms_aqadm.drop_queue_table(QUEUE_TABLE=>'FSS_QT_PROCESS_TABLE', FORCE=>TRUE, AUTO_COMMIT=>TRUE);
exec dbms_aqadm.drop_queue_table(QUEUE_TABLE=>'FSS_QO_BASED_TABLE', FORCE=>TRUE, AUTO_COMMIT=>TRUE);
exec dbms_aqadm.drop_queue_table(QUEUE_TABLE=>'FSS_QO_PROCESS_TABLE', FORCE=>TRUE, AUTO_COMMIT=>TRUE);
*/
--create agents

/*
DECLARE
   SUBSCRIBER   SYS.AQ$_AGENT;
BEGIN
   SUBSCRIBER := SYS.AQ$_AGENT ('TXNOUTAGENT', null, NULL);
   BEGIN
       DBMS_AQADM.remove_subscriber(QUEUE_NAME => 'txaqs_FLEX2FO', SUBSCRIBER => SUBSCRIBER);
   EXCEPTION WHEN OTHERS THEN
        NULL;
   END; 
   DBMS_AQADM.ADD_SUBSCRIBER(QUEUE_NAME => 'txaqs_FLEX2FO', SUBSCRIBER => SUBSCRIBER);
END;
/
DECLARE
   SUBSCRIBER   SYS.AQ$_AGENT;
BEGIN
   SUBSCRIBER := SYS.AQ$_AGENT ('TXNINAGENT', null, NULL);
   BEGIN
       DBMS_AQADM.remove_subscriber(QUEUE_NAME => 'txaqs_fo2bo', SUBSCRIBER => SUBSCRIBER);
   EXCEPTION WHEN OTHERS THEN
        NULL;
   END; 
   DBMS_AQADM.ADD_SUBSCRIBER(QUEUE_NAME => 'txaqs_fo2bo', SUBSCRIBER => SUBSCRIBER);
END;
/
*/
