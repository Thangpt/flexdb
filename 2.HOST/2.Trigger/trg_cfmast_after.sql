CREATE OR REPLACE TRIGGER TRG_CFMAST_AFTER
 AFTER
 INSERT OR UPDATE OF CUSTID, CUSTODYCD, PIN
 ON CFMAST
 REFERENCING OLD AS OLDVAL NEW AS NEWVAL
 FOR EACH ROW
declare
    v_afacctno varchar2(20);
    v_mobile varchar2(20);
    v_Email varchar2(200);
    v_Acctno varchar2(200);
    l_datasourcesms varchar2(1000);
    v_strSex  varchar2(20);
begin

    if fopks_api.fn_is_ho_active then
        v_mobile:='';

       IF (nvl(:newval.pin,'zzz')<>nvl(:oldval.pin,'zzz') and length(:newval.pin)>0 and length(:newval.custodycd)>0)
          -- or ( length(:newval.pin)>0 and length(:newval.custodycd)>0 and length(:newval.custodycd)= 0 )
            then
              For vc in (select fax1
                         from afmast where custid = :newval.custid and length(fax1)>1 ) loop
                         v_mobile:=vc.fax1;
              End loop;
              If length(v_mobile)>1 then
                l_datasourcesms:='select ''KBSV thong bao: Mat khau GD qua dien thoai cua so tai khoan '||:newval.custodycd||' la: '||:newval.pin||''' detail from dual';
                nmpks_ems.InsertEmailLog(v_mobile, '0330', l_datasourcesms, '');
              End if;

           -- truong hop cap lai mat khau giao dich qua dien thoai cua khach hang
           if length(trim(:oldval.pin)) > 0 then

               if :oldval.sex='001'  then
                    v_strSex := 'Ông : ' ;
               else
                    v_strSex := 'Bà : ';
               end if ;

                Select  max(email), max(acctno) into v_Email,v_Acctno from afmast where status in ('A','P') and  custid = :newval.custid ;
                l_datasourcesms:= ' Select ''' || :newval.custodycd || ''' custodycd , '''
                                              || v_strSex || ''' Sex,'''
                                              || :newval.fullname || ''' fullname,'''
                                              || :newval.pin || ''' loginpwd,  '''
                                              || to_char(sysdate,'DD/MM/YYYY hh24:MI:SS') || ''' TimeSend '
                                              || 'FROM dual' ;
                nmpks_ems.InsertEmailLog(v_Email, '0209', l_datasourcesms, v_Acctno);
           end if ;


        End if;
    end if;

end;
/

