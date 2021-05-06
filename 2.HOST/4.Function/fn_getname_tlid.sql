CREATE OR REPLACE FUNCTION fn_getName_TLID( pv_tlid VARCHAR2)
    RETURN STRING IS
  v_result varchar2(500);
  v_count NUMBER;
BEGIN
  V_RESULT:='';
 SELECT NVL(COUNT(*),0) INTO v_count FROM tlprofiles WHERE tlid =pv_tlid;
 IF v_count >0 THEN
  SELECT tlfullname INTO V_RESULT FROM tlprofiles WHERE tlid =pv_tlid;
  END IF;
RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 'Loi!khong lay duoc thong tin';
END;
/

