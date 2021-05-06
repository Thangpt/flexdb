CREATE OR REPLACE FUNCTION fn_getrefprice(PV_TRADEPLACE IN VARCHAR2, PV_PRICE IN VARCHAR2)
    RETURN NUMBER IS
    V_RESULT NUMBER;
    V_ODD number;
    V_PRICE number;
BEGIN
    V_PRICE:= TO_NUMBER(PV_PRICE);
    if PV_TRADEPLACE in( '002','005') then --san HNX
        V_ODD:= mod(V_PRICE,100);
        select decode(V_ODD,0,V_PRICE,V_PRICE - V_ODD + 100) into V_RESULT from dual;
    else
        if V_PRICE < 50000 then
            V_ODD:= mod(V_PRICE,100);
            select decode(V_ODD,0,V_PRICE,V_PRICE - V_ODD + 100) into V_RESULT from dual;
        ELSIF V_PRICE < 99500 then
            V_ODD := mod(V_PRICE,500);
            select  decode(V_ODD,0,V_PRICE,V_PRICE - V_ODD + 500) into V_RESULT from dual;
        else
            V_ODD := mod(V_PRICE,1000);
            select  decode(V_ODD,0,V_PRICE,V_PRICE - V_ODD + 1000) into V_RESULT from dual;
        end if;
    end if;

RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/

