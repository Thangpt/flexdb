CREATE OR REPLACE FUNCTION fn_gettcdtdesbankacc_c(pv_brid varchar2, pv_bankid varchar2 default '202') return varchar2
is
v_return varchar2(100);
begin

    begin
	 if (pv_bankid is null or pv_bankid <> '309') then
        if pv_brid ='0101' then
            --Chi nhanh HCM
            select bankacctno into v_return from BANKNOSTRO b, sysvar s where b.shortname = s.varvalue AND s.varname='TCDTBIDVHCM' AND s.grname='SYSTEM';
        else
            --Hoi so
            select bankacctno into v_return from BANKNOSTRO b, sysvar s where b.shortname = s.varvalue AND s.varname='TCDTBIDVHN' AND s.grname='SYSTEM';
        end if;
	 else
	   select bankacctno into v_return from BANKNOSTRO b, sysvar s where b.shortname = s.varvalue AND s.varname='TCDTVPBHN' AND s.grname='SYSTEM';
   end if;
   	return v_return;
    end;

exception when others then
    select bankacctno into v_return from BANKNOSTRO b, sysvar s where b.shortname = s.varvalue AND s.varname='TCDTBIDVHN' AND s.grname='SYSTEM';
    return v_return;
end;
/
