CREATE OR REPLACE FUNCTION fn_getpin(PV_CUSTODYCD IN VARCHAR2) RETURN VARCHAR
IS
V_RESULT VARCHAR2(20);
V_PIN VARCHAR2(20);
i NUMBER;
BEGIN

V_PIN := ' ';
i:=0;

SELECT nvl(pin,' ') INTO V_PIN FROM cfmast WHERE custodycd = PV_CUSTODYCD;

IF V_PIN <> ' ' THEN
  SELECT lpad('*',length(V_PIN), '*') INTO V_RESULT FROM dual;
ELSE
     V_RESULT:= ' ';
END IF;

RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN ' ';
END;
/

