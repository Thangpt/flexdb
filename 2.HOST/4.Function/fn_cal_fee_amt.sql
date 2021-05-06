CREATE OR REPLACE FUNCTION fn_cal_fee_amt(pv_amt IN number, pv_feetype IN varchar2)
RETURN number IS
v_dblResult number(20,4);
v_dblAmt number(20,4);
v_strFeetype varchar2(20);
v_forp varchar2(1);
v_feerate number(20,4);
v_minval number(20,4);
v_maxval number(20,4);
BEGIN
    v_dblAmt := pv_amt;
    v_strFeetype := pv_feetype;
    SELECT f.forp, nvl(f.feeamt,0),nvl(f.feerate,0), nvl(f.minval,0), nvl(f.maxval,0)
        INTO v_forp, v_dblResult, v_feerate, v_minval, v_maxval
      FROM feemaster f WHERE f.feecd= v_strFeetype;
    IF v_forp = 'F' THEN
        RETURN v_dblResult;
    ELSIF v_forp = 'P' THEN
        v_dblResult := LEAST(v_maxval,GREATEST(v_minval, v_dblAmt * (v_feerate/100)));
    ELSE
        RETURN 0;
    END IF;
    RETURN v_dblResult;
EXCEPTION WHEN OTHERS THEN
    RETURN 0;
END;
/

