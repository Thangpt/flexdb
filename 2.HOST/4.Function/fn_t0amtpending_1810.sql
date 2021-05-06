CREATE OR REPLACE FUNCTION fn_t0amtpending_1810(pv_accontno IN  VARCHAR2, RLIMIT IN number, PV_T0CAL IN number, pv_ADVANCELINE in number , pv_CUSTAVLLIMIT number, PV_T0AMTUSED number ,PV_PP NUMBER ,PV_T0DEB NUMBER )
    RETURN number IS
    V_RESULT number;
    v_amt number;
    v_sumToAmt NUMBER;
    v_t0CustLimit NUMBER;

BEGIN
/*
PV_T0CAL: Bao lanh ly thuyet
pv_ADVANCELINE: Bao lanh cap trong ngay
pv_ACCLIMIT:Han muc duoc cap cho KH
PV_T0AMTUSED: So tien su dung sau khi cap BL
PV_PP : suc mua
v_t0CustLimit-- Han muc BL tu dong toi da cua 1 tieu khoan 1 ngay
*/
SELECT varvalue INTO v_t0CustLimit FROM sysvar WHERE varname ='T0CUSTLIMIT';
IF LEAST (PV_T0CAL - pv_ADVANCELINE, LEAST(pv_CUSTAVLLIMIT,v_t0CustLimit)-pv_ADVANCELINE)>= PV_T0AMTUSED THEN
    IF PV_PP >= 0 THEN
        V_RESULT := 0;
    ELSE

        SELECT nvl(SUM(TOAMT),0) INTO v_sumToAmt FROM olndetail WHERE duedate =getcurrdate AND status in ('A','E') AND acctno =pv_accontno;
        IF PV_PP+v_sumToAmt <0 THEN
            V_RESULT := GREATEST(-1*PV_PP - PV_T0DEB+pv_ADVANCELINE+PV_T0AMTUSED ,PV_T0AMTUSED);
        ELSE
            V_RESULT := PV_T0AMTUSED+pv_ADVANCELINE;
        END IF;
    END IF;
ELSE
    IF PV_PP >= 0 THEN
        V_RESULT := PV_T0AMTUSED + pv_ADVANCELINE;
    ELSE

        SELECT nvl(SUM(TOAMT),0) INTO v_sumToAmt FROM olndetail WHERE duedate =getcurrdate AND status in ('A','E') AND acctno =pv_accontno;
        IF PV_PP+v_sumToAmt <0 THEN
            V_RESULT := GREATEST(-1*PV_PP - PV_T0DEB+pv_ADVANCELINE+PV_T0AMTUSED ,PV_T0AMTUSED);
        ELSE
            V_RESULT := PV_T0AMTUSED+pv_ADVANCELINE;
        END IF;
    END IF;
END IF;

RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 999999999999;
END;
/

