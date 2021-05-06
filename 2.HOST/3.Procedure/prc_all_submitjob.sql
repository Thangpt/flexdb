CREATE OR REPLACE PROCEDURE prc_all_submitjob is
 v_job integer;

begin
dbms_job.submit(v_job,' pr_smsbeginday;',sysdate,'sysdate + 1/48');
dbms_job.submit(v_job,' pck_gwtransfer.pr_putbatchprocessb2c;',sysdate,'sysdate + 3/86400');
dbms_job.submit(v_job,' pck_gwtransfer.pr_PutbatchProcessC2B;',sysdate,'sysdate + 3/86400 ');
dbms_job.submit(v_job,' pck_gwtransfer.pr_Complete_PutbatchC2B;',sysdate,' SYSDATE + 3/86400');
dbms_job.submit(v_job,' pck_gwtransfer.pr_PutbatchProcessC2B_BIDV;',sysdate,'sysdate + 3/86400 ');
commit;

end;
/

