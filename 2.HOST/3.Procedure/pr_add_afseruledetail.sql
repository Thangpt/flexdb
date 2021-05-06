CREATE OR REPLACE PROCEDURE pr_add_afseruledetail
    (
        pv_err_code IN OUT VARCHAR2,
        p_refid IN VARCHAR2,
        p_tlid IN VARCHAR2,
        p_codeid IN VARCHAR2
    )
IS
    v_symbol  VARCHAR2(20);
BEGIN
    SELECT symbol INTO v_symbol FROM sbsecurities WHERE codeid = p_codeid;

    INSERT INTO afseruledetail (REFID,SYMBOL,AFSERULETYPE,MAKER,APPROVE,ACTION,TXDATE,TXTIME)
    VALUES(p_refid,v_symbol,'BL',p_tlid,p_tlid,'ADD',getcurrdate,to_char(SYSTIMESTAMP,'hh24:mi:ss'));
    COMMIT;
    pv_err_code := 0;
EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END;
/

