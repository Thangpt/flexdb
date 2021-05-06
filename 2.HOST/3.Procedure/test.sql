CREATE OR REPLACE PROCEDURE TEST (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR

  )
IS
--

--


BEGIN

    OPEN PV_REFCURSOR FOR
        select utf8nums.c_const_RPT_CF1000_1143 A
        from DUAL;



END;
/

