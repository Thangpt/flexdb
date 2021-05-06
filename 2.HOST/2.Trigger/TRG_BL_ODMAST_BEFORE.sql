create or replace trigger TRG_BL_ODMAST_BEFORE
  before insert or update
  on bl_odmast 
  for each row
declare
  -- local variables here
BEGIN
  IF :new.Last_Change = :old.Last_Change OR :old.last_change IS NULL THEN
    :NEW.Last_Change := systimestamp;
  END IF;
end TRG_BL_ODMAST_BF;
/
