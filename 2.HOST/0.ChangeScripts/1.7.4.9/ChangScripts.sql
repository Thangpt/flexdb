--
--
/
ALTER TRIGGER trig_after_afselimitgrp DISABLE;
/
UPDATE AFSELIMITGRP SET STATUS = 'A' WHERE STATUS <> 'A';
COMMIT;
/
ALTER TRIGGER trig_after_afselimitgrp ENABLE;
/