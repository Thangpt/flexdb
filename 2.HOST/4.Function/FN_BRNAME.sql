CREATE OR REPLACE FUNCTION FN_BRNAME(pv_BRID In VARCHAR2)
    RETURN VARCHAR2 IS
    v_Result  VARCHAR2(400);
BEGIN
  BEGIN
    SELECT brname INTO v_Result FROM brgrp WHERE brid = pv_BRID;
  EXCEPTION WHEN OTHERS THEN
    v_Result := NULL;
  END;
    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN NULL;
END;
/
