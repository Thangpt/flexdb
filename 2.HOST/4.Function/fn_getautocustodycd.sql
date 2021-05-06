CREATE OR REPLACE FUNCTION fn_getautocustodycd (p_custodycd VARCHAR2)
RETURN VARCHAR2
IS
    l_custodycd            VARCHAR2(10);
    l_count                NUMBER(10);
    l_max                  VARCHAR2(10);
    l_prefix_custodycd     varchar2(10);
    l_length               number;
BEGIN
    l_max := to_number(substr('999999',length(p_custodycd)+1));
    select varvalue||'C' into l_prefix_custodycd from sysvar where varname = 'FIRM' and grname = 'SYSTEM';
    l_length := 6 - length(p_custodycd);
    
    FOR i IN 1 ..l_max
    LOOP
        SELECT COUNT (*) INTO l_count 
        FROM (SELECT CUSTODYCD FROM CFMAST 
              UNION ALL
              SELECT CUSTODYCD FROM registeronline)
        where custodycd = l_prefix_custodycd||p_custodycd||lpad(i,l_length,'0');

        IF l_count = 0 THEN
            l_custodycd := substr('000000'||i,length('000000'||i)-(5-length(p_custodycd)));
            EXIT;
        END IF;

    END LOOP;
    RETURN l_custodycd;
END;
/