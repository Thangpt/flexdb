CREATE OR REPLACE FUNCTION fn_get_nav_no
(
    p_custodycd     IN      VARCHAR2,
    p_accno         IN      VARCHAR2
)
RETURN NUMBER
IS
    l_netasset          NUMBER(20,4);
    l_no                NUMBER(20,4);
    l_nav_no            NUMBER(20,4);

BEGIN
    l_netasset := fn_get_netasset(p_custodycd,p_accno);
    l_no := fn_get_no(p_accno);

    IF l_no <= 0 AND l_netasset > 0 THEN
        l_nav_no := 10000;
    ELSIF l_no = 0 AND l_netasset = 0 THEN
        l_nav_no := 0;
    ELSE
        l_nav_no := round((l_netasset/l_no)*100,2);
    END IF;

    RETURN l_nav_no;

EXCEPTION
  WHEN OTHERS THEN
    RETURN 0;
END;
/

