CREATE OR REPLACE PROCEDURE pr_del_afseruledetail
    (
        pv_err_code IN OUT VARCHAR2,
        p_autoid IN VARCHAR2,
        p_tlid IN VARCHAR2,
        p_codeid IN VARCHAR2
    )
IS
    v_symbol  VARCHAR2(20);

BEGIN
    --SELECT symbol INTO v_symbol FROM sbsecurities WHERE codeid = p_codeid;

    FOR rec IN (SELECT b.symbol, a.* FROM afserule a, sbsecurities b WHERE autoid = p_autoid AND a.codeid = b.codeid)
    LOOP
            INSERT INTO afseruledetail (REFID,SYMBOL,AFSERULETYPE,MAKER,APPROVE,ACTION,TXDATE,TXTIME)
            VALUES(rec.refid,rec.symbol,'BL',p_tlid,p_tlid,'DEL',getcurrdate,to_char(SYSTIMESTAMP,'hh24:mi:ss'));
    END LOOP;

    COMMIT;
    pv_err_code :=  0;
EXCEPTION
  WHEN OTHERS THEN
        pv_err_code := 'Inseat afseruledetail fail autoid = '||p_autoid;
        RETURN;
END;
/

