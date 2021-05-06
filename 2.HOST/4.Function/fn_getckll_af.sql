CREATE OR REPLACE FUNCTION fn_getckll_af (pv_afacctno IN VARCHAR2, pv_codeid IN VARCHAR2)
RETURN NUMBER
iS
    v_result NUMBER(20);
BEGIN
    SELECT  NVL(SUM(mod(se.trade - nvl(vw.execqtty,0),sec.tradelot)),0)
                INTO v_result
        FROM semast se, afmast af, securities_info sec, v_getsellorderinfo vw
            WHERE se.afacctno = af.acctno  AND se.codeid = sec.codeid and se.acctno = vw.seacctno(+)
                    AND af.acctno = pv_afacctno  AND se.codeid = pv_codeid;
    RETURN v_result;
EXCEPTION WHEN OTHERS THEN
    RETURN 0;
END;
/

