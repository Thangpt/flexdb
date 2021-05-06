CREATE OR REPLACE FUNCTION fn_gettcdtdesbankacc(pv_brid varchar2) return varchar2
is
v_return varchar2(100);
begin

    begin
        if pv_brid ='0101' then
            --Chi nhanh HCM
            select refacctno into v_return from crbdefacct where  refbank = 'BIDVHCM' and trfcode = 'TCDT';
        else
            --Hoi so
            select refacctno into v_return from crbdefacct where  refbank = 'BIDVHN' and trfcode = 'TCDT';
        end if;
        return v_return;
    end;
exception when others then
    select refacctno into v_return from crbdefacct where  refbank = 'BIDVHN' and trfcode = 'TCDT';
    return v_return;
end;
/

