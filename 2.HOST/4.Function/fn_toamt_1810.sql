CREATE OR REPLACE FUNCTION fn_TOAMT_1810( pv_acctno varchar2, PV_T0AMTUSED number ,PV_PP NUMBER,PV_ADVANCELINE  NUMBER)
    RETURN number IS
    V_RESULT number;
    v_amt number;
    v_sumToAmt NUMBER;
    v_count NUMBER;
BEGIN
  V_RESULT:=0;
  IF PV_PP >= 0 THEN
    V_RESULT := PV_T0AMTUSED;
  ELSE
  --  SELECT nvl(COUNT(*),0) INTO v_count FROM olndetail WHERE acctno =pv_acctno AND status in ('A','E') AND duedate =getcurrdate;
    IF PV_PP+PV_ADVANCELINE <0 THEN
       -- IF v_count>0 THEN
      --  V_RESULT := PV_PP+PV_ADVANCELINE+PV_T0AMTUSED;
      --  ELSE
        V_RESULT := -1*PV_PP-PV_ADVANCELINE+PV_T0AMTUSED;
      --  END  IF;
    ELSE
        V_RESULT := PV_T0AMTUSED;
    END IF;
  END IF;
RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/

