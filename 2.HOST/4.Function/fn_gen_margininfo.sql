CREATE OR REPLACE FUNCTION fn_gen_margininfo
  RETURN  NUMBER IS
--
-- To modify this template, edit file FUNC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the function
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  -------------------------------------------

   -- Declare program variables as shown above
BEGIN
    --CHAY LENH NAY NGAY SAU KHI CHAY BATCH XONG

    delete from afmargininfo;
    insert into afmargininfo (AFACCTNO, SEAMT, SEASS, SEMRAMT, SEMRASS, SEREALAMT, SEREALASS)
    select AFACCTNO, SEAMT, SEASS, SEMRAMT, SEMRASS, SEREALAMT, SEREALASS from V_GETSECMARGININFO_BOD;
    COMMIT;


    delete semargininfo;
    insert into semargininfo (codeid, trade, receiving, sytrade, syreceiving)
    select mr_sy.codeid, mr_sy.trade, mr_sy.receiving, nvl(mr.trade,0), nvl(mr.receiving,0)
    from v_semargininfo_bod mr, v_semargininfo_sy_bod mr_sy
    where mr_sy.codeid = mr.codeid(+);
    commit;

    RETURN 0;
EXCEPTION
   WHEN others THEN
   dbms_output.put_line('DBMS_UTILITY.FORMAT_ERROR_BACKTRACE:'||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
   dbms_output.put_line('SQL:'||SQLERRM);
   return -1;
END;
/

