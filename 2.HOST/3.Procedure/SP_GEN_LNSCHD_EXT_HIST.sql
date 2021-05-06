CREATE OR REPLACE Procedure SP_GEN_LNSCHD_EXT_HIST Is
       V_CURRDATE DATE;
Begin
  V_CURRDATE:= getcurrdate;
  insert into lnschdexthist
  select * from lnschdext where TDATE =  V_CURRDATE;
  delete from lnschdext where TDATE =  V_CURRDATE;
  COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
End SP_GEN_LNSCHD_EXT_HIST;
/
