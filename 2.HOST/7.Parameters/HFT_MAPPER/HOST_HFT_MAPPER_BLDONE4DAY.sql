﻿--
--
/
DELETE hft_mapper WHERE BPS_FUNCTION = 'BLDONE4DAY';
INSERT INTO HFT_MAPPER (BPS_FUNCTION,BPS_KEY_FIELD,FO_FIELD,FO_FIELD_TYPE,RETURN_ID,FO_URL,REQUEST_TYPE,FO_IDX_TABLE,BPS_ACCOUNT_TYPE,BPS_ACCOUNT)
VALUES ('BLDONE4DAY',null,'MSGTYPE','VARCHAR','fe7006',null,null,null,'','');
COMMIT;
/