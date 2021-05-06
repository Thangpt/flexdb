CREATE OR REPLACE FUNCTION fn_gen_desc_1816 (p_description varchar2,p_afacctno varchar2,p_AMT number) return string
is
v_desc varchar2(500);
v_afacctno varchar2(500);
v_amt number;
begin
       v_desc:=nvl(p_description,'') ;
       v_amt:=nvl(p_AMT,0);
       v_afacctno:= nvl(p_afacctno,'');
       if length(replace(p_afacctno,'.',''))=10 then
            v_desc:= to_char(v_amt) || substr(v_desc,instr(v_desc,'/'));
       end if;
       return v_desc;
exception when others then
       return 'Cap han muc bao lanh cho tieu khoan (1816)';
end;
/

