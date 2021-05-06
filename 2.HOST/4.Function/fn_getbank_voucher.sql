CREATE OR REPLACE FUNCTION fn_GetBank_Voucher(PV_BANKID IN VARCHAR2)
    RETURN String IS
-- PURPOSE: PHI CHUYEN KHOAN CHUNG KHOAN
-- MODIFICATION HISTORY
-- PERSON      DATE         COMMENTS
-- ---------   ------       -------------------------------------------
-- THANHNM   20/03/2012     CREATED
    V_RESULT varchar2(100);
BEGIN
V_RESULT :=' ';

if instr('06/02/03/04/40/41/42', PV_BANKID)>0 then
V_RESULT:='PVOUCHER_2';
elsif instr('01/99', PV_BANKID)>0 then
      V_RESULT:='PVOUCHER_1';
elsif instr('05/88', PV_BANKID)>0 then
       V_RESULT:='WDRLC';
else
       V_RESULT:='';

end if;

RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/

