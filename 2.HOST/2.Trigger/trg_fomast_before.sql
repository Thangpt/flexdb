CREATE OR REPLACE TRIGGER "TRG_FOMAST_BEFORE"
 BEFORE
  INSERT OR UPDATE
 ON fomast
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
begin
:NEWVAL.last_change:= SYSTIMESTAMP;
END;
/
