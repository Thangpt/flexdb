CREATE OR REPLACE FUNCTION fn_get_acctno_updatecost(pv_strACCTNO IN varchar2, pv_strCODEID IN varchar2)
  RETURN  varchar2
  IS
 v_result varchar2(30);
 l_codeid varchar2(10);
 v_afacctno       varchar2(10);
BEGIN
    v_afacctno:=pv_strACCTNO;
    select nvl(refcodeid,codeid) into l_codeid
    from sbsecurities where codeid=pv_strCODEID;
    v_result:=v_afacctno||l_codeid;

    RETURN v_result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN pv_strACCTNO||pv_strCODEID;
END;
/

