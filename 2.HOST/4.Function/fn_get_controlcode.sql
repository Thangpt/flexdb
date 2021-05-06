-- Start of DDL Script for Function HOSTMSTRADE.FN_GET_CONTROLCODE
-- Generated 26-Sep-2018 10:50:50 from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE 
FUNCTION fn_get_controlcode
  ( p_symbol IN varchar2)
  RETURN  VARCHAR2 IS
   v_tradeplace varchar2(10);
   v_controlcode varchar2(10);
BEGIN
    v_controlcode:='-1';
    Select Tradeplace into v_tradeplace
    From sbsecurities
    Where symbol=p_symbol;
    If v_tradeplace = '001' then
        Select sysvalue into v_controlcode
        From ordersys
        Where sysname='CONTROLCODE';
    /*Else
        Select tradingsessionid into v_controlcode
        From hasecurity_req
        Where symbol=p_symbol;*/
    ELSE
      --Begin HNX_update|MSBS-1774
         SELECT hb.tradingsessionid into v_controlcode
         From hasecurity_req hr,  HA_BRD hb
         Where
           hb.BRD_CODE = hr.tradingsessionsubid
           AND hr.symbol=p_symbol;
      --End HNX_update|MSBS-1774

    End if;
    RETURN v_controlcode ;
EXCEPTION
   WHEN others THEN
    RETURN v_controlcode ;
END;
/



-- End of DDL Script for Function HOSTMSTRADE.FN_GET_CONTROLCODE
