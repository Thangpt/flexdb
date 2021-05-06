create or replace procedure pr_GotPhiLuuKy(v_custodycd varchar2)
is
v_mmyyyy    varchar2(100);
begin
    --v_custodycd:='091C600250';
    for rec in (
        select distinct fee.afacctno from cfmast cf, afmast af,cifeeschd fee  where cf.custid = af.custid and af.acctno = fee.afacctno 
                and af.status in ('C','N') and custodycd in v_custodycd --v_custodycd
    )
    loop
        for rec1 in (
            select * from tllogall where tltxcd in ('1182','1183') and msgacct =rec.afacctno
        ) loop
            select cvalue into v_mmyyyy from tllogfldall where txnum =rec1.txnum and txdate =rec1.txdate and fldcd='07'; --03/2014
            --
            --select * from cifeeschd where to_Char(todate,'MM/RRRR')='03/2014' and afacctno ='0101003884'
            update cifeeschd set paidtxnum= rec1.txnum , paidtxdate = rec1.txdate where to_Char(todate,'MM/RRRR')=v_mmyyyy and afacctno =rec.afacctno;
            dbms_output.put_line('v_mmyyyy:' || v_mmyyyy);
            dbms_output.put_line('afacctno:' || rec.afacctno);
        end loop;
    end loop;
end;
/

