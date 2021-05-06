CREATE OR REPLACE FUNCTION fn_retotaltranlimit(strACCTNO IN varchar2, strTLID IN varchar2)
  RETURN  number
  IS
  v_Result      number(20);
BEGIN
-- 1.6.0.0: lay thong tin han muc tien chuyen con lai
  select tl.retotaltranlimit
  into v_result
  from tlemaillimit tl, afmast af, cfmast cf 
  where tl.brid=cf.brid and af.custid=cf.custid and af.acctno=strACCTNO and tl.tlid=strTLID;

    RETURN v_result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
