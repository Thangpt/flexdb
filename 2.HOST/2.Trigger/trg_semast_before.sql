CREATE OR REPLACE TRIGGER "TRG_SEMAST_BEFORE"
 BEFORE
  INSERT OR UPDATE
 ON semast
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
begin
:NEWVAL.last_change:= SYSTIMESTAMP;
END;
/

