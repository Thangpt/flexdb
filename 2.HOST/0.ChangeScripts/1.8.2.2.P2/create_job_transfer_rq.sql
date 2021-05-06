BEGIN
      DBMS_SCHEDULER.DROP_JOB (
         job_name         =>  'GET_TRANSFER_RQ',
         force => true);
    exception when others then
    null;
END;
/
BEGIN
      DBMS_SCHEDULER.CREATE_JOB (
         job_name         =>  'GET_TRANSFER_RQ',
         job_type           =>  'PLSQL_BLOCK',
         job_action       =>  'BEGIN PCK_BANKGW.pr_insertTransferRequest(); END;',
         start_date       =>  sysdate,
         repeat_interval  =>  'freq=SECONDLY;interval=2',
         enabled           => FALSE,
         comments         => 'Job GET_TRANSFER_RQ',
         job_class =>'FSS_DEFAULT_JOB_CLASS');      
END;
/
