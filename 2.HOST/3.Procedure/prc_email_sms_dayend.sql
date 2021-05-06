CREATE OR REPLACE PROCEDURE prc_email_sms_dayend

   IS
-- ---------   ------  -------------------------------------------
    l_datasourcesms NVARCHAR2 (1000);
    v_strBeginTime  NVARCHAR2(50);
    v_strEndTime   NVARCHAR2(50);



BEGIN

select to_Char(cmpltime,'DD/MM/YYYY hh24:MI:ss') into v_strBeginTime  from sbbatchsts
where bchdate=(select TO_DATE(VARVALUE,'DD/MM/YYYY')  from sysvar where varname='PREVDATE')
and bchmdl in('SABFB');

select to_Char(SYSDATE,'DD/MM/YYYY hh24:MI:ss') into v_strEndTime  from sbbatchsts
where bchdate=(select TO_DATE(VARVALUE,'DD/MM/YYYY')  from sysvar where varname='PREVDATE')
and bchmdl in('SAAFB');



for rec in
(
Select cdval Email from allcode where CDTYPE ='SY' and CDNAME ='EMAIL'
)
loop



 l_datasourcesms:='select ''' ||'END OF DAY'|| ''' TASK, '''  ||v_strBeginTime||''' BEGINTIME, '''|| v_strEndTime ||''' ENDTIME  from dual';

 nmpks_ems.InsertEmailLog(rec.Email, '0208', l_datasourcesms, '');


end loop;


for rec in
(
Select cdval Mobile from allcode where CDTYPE ='SY' and CDNAME ='MOBILE'
)
loop

 l_datasourcesms:='Select ''' || 'Thoi gian bat dau chay Batch : '||v_strBeginTime|| 'Thoi gian ket thuc chay batch :  '|| v_strEndTime ||'''  detail from dual';

 nmpks_ems.InsertEmailLog(rec.MOBILE, '0334', l_datasourcesms, '');

end loop;


EXCEPTION
    WHEN OTHERS THEN
       null;
END; -- Procedure
/

