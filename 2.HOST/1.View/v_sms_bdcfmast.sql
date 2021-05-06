create or replace force view v_sms_bdcfmast as
select CUSTODYCD,LASTDATE, ACTIVEDATE ,afstatus  status from cfmast;

