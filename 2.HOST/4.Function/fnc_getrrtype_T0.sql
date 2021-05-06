CREATE OR REPLACE FUNCTION fnc_getrrtype_T0(T0LNTYPE IN VARCHAR2) return VARCHAR2
  IS

  v_count NUMBER;
BEGIN
    select count(1) INTO v_count from lntype where actype = T0LNTYPE and chksysctrl = 'N' and rrtype = 'B';
    IF v_count > 0 THEN
      Return 'FALSE';
    ELSE
      Return 'TRUE';
    END IF;

EXCEPTION
    WHEN others THEN
        RETURN 'FALSE';
END;
/
