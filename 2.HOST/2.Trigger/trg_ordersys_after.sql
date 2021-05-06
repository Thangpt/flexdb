CREATE OR REPLACE TRIGGER TRG_ORDERSYS_AFTER
 AFTER 
 INSERT OR UPDATE OF SYSDESC
 ON ORDERSYS
 REFERENCING OLD AS OLDVAL NEW AS NEWVAL
 FOR EACH ROW 
declare
    v_strBeginTime varchar2(20);
    l_datasourcesms varchar2(1000);
    l_datasourcesms2 varchar2(1000);
begin
Select to_char(sysdate ,'DD/MM/YYYY hh24:Mi:ss') into v_strBeginTime from dual ;
    if fopks_api.fn_is_ho_active then
   
     
           -- truong hop cap lai mat khau giao dich qua dien thoai cua khach hang
     if trim(:oldval.sysdesc) <> trim(:newval.sysdesc) then

            if :newval.sysdesc ='CONNECTION_ESTABLISHED' then
 
                l_datasourcesms:= ' Select ''' || 'START HOSE GATEWAY' || ''' TASK , ''' || v_strBeginTime|| ''' Begintime FROM dual' ;
                l_datasourcesms2:= ' Select ''' || ' TASK : START HOSE GATEWAY - TIME : ' || v_strBeginTime|| ''' detail FROM dual' ;
                for rec in
                (
                    Select cdval Email from allcode where CDTYPE ='SY' and CDNAME ='EMAIL'
                )
                loop
                    nmpks_ems.InsertEmailLog(rec.Email, '0208', l_datasourcesms, null);
                end loop;

                for rec in
                (
                    Select cdval MOBILE from allcode where CDTYPE ='SY' and CDNAME ='MOBILE'
                )
                loop
                    nmpks_ems.InsertEmailLog(rec.MOBILE, '0808', l_datasourcesms2, null);
                end loop;

            else if :newval.sysdesc ='CONNECTION_TERMINATION' and  :oldval.sysdesc <> 'CONNECTTING'  then


                l_datasourcesms:= ' Select ''' || 'STOP HOSE GATEWAY' || ''' TASK , ''' || v_strBeginTime|| ''' Begintime FROM dual' ;
                l_datasourcesms2:= ' Select ''' || ' TASK : STOP HOSE GATEWAY - TIME : ' || v_strBeginTime|| ''' detail FROM dual' ;
                for rec in
                (
                    Select cdval Email from allcode where CDTYPE ='SY' and CDNAME ='EMAIL'
                )
                loop
                    nmpks_ems.InsertEmailLog(rec.Email, '0208', l_datasourcesms, null);
                end loop;

                for rec in
                (
                    Select cdval MOBILE from allcode where CDTYPE ='SY' and CDNAME ='MOBILE'
                )
                loop
                    nmpks_ems.InsertEmailLog(rec.MOBILE, '0808', l_datasourcesms2, null);
                end loop;

            end if ;
            end if;
     end if ;
    end if;
   
end;
/

