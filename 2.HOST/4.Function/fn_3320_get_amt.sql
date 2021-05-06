-- Start of DDL Script for Function HOSTBVST.FN_3320_GET_AMT
-- Generated 19/01/2018 4:21:51 PM from HOSTBVST@FLEX32

CREATE OR REPLACE 
FUNCTION fn_3320_get_amt( pv_codeid varchar2)
    RETURN NUMBER IS
    v_Result  NUMBER;
    v_wftcodeid   varchar2(6);

BEGIN
    begin
    select refcodeid into v_wftcodeid from sbsecurities where nvl(refcodeid,'a')=pv_codeid;
    exception
    when others then
    v_wftcodeid:=pv_codeid;
    end;
   select sum( trade+margin+wtrade+mortage+BLOCKED+secured+repo+netting+dtoclose+withdraw)
   into v_Result from semast where codeid=pv_codeid or codeid=v_wftcodeid;
   RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/



-- End of DDL Script for Function HOSTBVST.FN_3320_GET_AMT

