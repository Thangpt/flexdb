CREATE OR REPLACE PROCEDURE pr_lockaccount(p_txmsg in tx.msg_rectype, p_err_code in out varchar2)
is
    l_listacctno varchar2 (1000);
begin
    l_listacctno:='|';
    for rec in (
        select  distinct map.acfld, map.apptype
        from appmap map, apptx tx, tltx
        where map.apptxcd= tx.txcd and map.apptype = tx.apptype
        and fldtype ='N' and  map.tltxcd =p_txmsg.tltxcd
        and map.tltxcd = tltx.tltxcd and nvl(chksingle,'N') ='Y'

    )
    loop

        if instr(l_listacctno,'|' || p_txmsg.txfields(rec.acfld).value || rec.apptype || '|') =0 then
            insert into accupdate (acctno,updatetype,createdate)
            values (p_txmsg.txfields(rec.acfld).value, rec.apptype, SYSTIMESTAMP);
        end if;
        l_listacctno:= l_listacctno  ||  p_txmsg.txfields(rec.acfld).value || rec.apptype || '|';
        p_err_code:=0;
    end loop;
exception when others then
    p_err_code:='-100201';
end;
/

