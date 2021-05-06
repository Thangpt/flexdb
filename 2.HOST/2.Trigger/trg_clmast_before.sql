CREATE OR REPLACE TRIGGER "TRG_CLMAST_BEFORE"
 BEFORE
  INSERT OR UPDATE
 ON clmast
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
begin
:NEWVAL.last_change:= SYSTIMESTAMP;
END;
/
