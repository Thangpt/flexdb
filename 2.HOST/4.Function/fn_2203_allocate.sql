create or replace function fn_2203_allocate(pv_acctno varchar2, pv_qttytype varchar2, pv_qtty number,pv_autoid number)
return number
is
v_allqtty number;
v_qtty number;
begin
    begin
        select sum(case when autoid<pv_autoid then qtty else 0 end) ALLQTTY,
               sum(case when autoid=pv_autoid then qtty else 0 end) QTTY
               into v_allqtty,v_qtty
        from semastdtl where acctno = pv_acctno and qttytype = pv_qttytype and deltd <> 'Y'
        and autoid <= pv_autoid;
        if v_allqtty>pv_qtty then
            return 0;
        else
            return least(pv_qtty-v_allqtty, v_qtty);
        end if;
    exception when others then
        return 0;
    end;
end;
/

