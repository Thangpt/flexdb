CREATE OR REPLACE FUNCTION fnc_getlnactype(V_LNACTYPE varchar2) RETURN VARCHAR2
AS
v_checksysctl varchar2(100);

BEGIN
SELECT  chksysctrl INTO v_checksysctl FROM lntype WHERE actype  =V_LNACTYPE;
IF v_checksysctl ='Y' THEN
  RETURN 'U0';
ELSE
  RETURN 'M0';
END IF;
EXCEPTION WHEN OTHERS THEN
  RETURN 'M';
END;
/

