CREATE OR REPLACE FUNCTION FN_GEN_DESC_1188 (p_description varchar2,p_custodycd varchar2, p_fullname varchar2,p_via varchar2) return string
is
v_desc varchar2(500);
v_custodycd varchar2(500);
v_fullname varchar2(500);
v_via varchar2(500);
begin
       v_desc:=nvl(p_description,'') ;
       v_custodycd:=nvl(p_custodycd,'');
       v_fullname:=nvl(p_fullname,'');
       v_via:=nvl(p_via,'');
       if length(replace(v_custodycd,'.',''))=10 then
          v_desc:= replace(v_desc,'<$88CUSTODYCD>',v_custodycd);
       end if;

       if length(replace(v_fullname,'.',''))=10 then
          v_desc:= replace(v_desc,'<$89CUSTODYCD>',v_fullname);
       end if;
        if v_via = 'T' then
            v_desc:=  replace(v_desc,'<$25VIA>','Tele');
        else
            v_desc:=  replace(v_desc,'<$25VIA>','Floor');
       end if;
       return v_desc;
exception when others then
       return 'Chuyen khoan noi bo';
end;
/

