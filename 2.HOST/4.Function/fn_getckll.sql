CREATE OR REPLACE FUNCTION fn_getckll (pv_custodycd IN VARCHAR2, pv_codeid IN VARCHAR2)
RETURN NUMBER
iS
    v_result NUMBER(20);
BEGIN
       SELECT NVL(mod(sum(se.trade-nvl(vw.SECUREAMT,0)),max(tradelot)),0)
                INTO v_result
        FROM semast se, afmast af, cfmast cf, securities_info sec, v_getsellorderinfo vw
            WHERE se.afacctno = af.acctno AND af.custid = cf.custid
                AND se.codeid = sec.codeid AND cf.custodycd = pv_custodycd
                AND se.codeid = pv_codeid
                AND se.acctno = vw.seacctno(+);
    RETURN v_result;
EXCEPTION WHEN OTHERS THEN
    RETURN 0;
END;
/

