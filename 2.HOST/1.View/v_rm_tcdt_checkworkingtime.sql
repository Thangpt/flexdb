create or replace force view v_rm_tcdt_checkworkingtime as
select case when (to_char(sysdate,'hh24:mi:ss') >= st.varvalue and to_char(sysdate,'hh24:mi:ss') <= ot.varvalue) then 0 else 1 end result from sysvar st, sysvar ot
where st.grname ='SYSTEM' and st.varname ='TCDTSTARTTIME'
and ot.grname ='SYSTEM' and ot.varname ='TCDTOFFTIME';

