﻿--
--
/
DELETE hft_mapper WHERE BPS_FUNCTION = 'PLACE_MAP_BL_ORDER';
INSERT INTO HFT_MAPPER (BPS_FUNCTION,BPS_KEY_FIELD,FO_FIELD,FO_FIELD_TYPE,RETURN_ID,FO_URL,REQUEST_TYPE,FO_IDX_TABLE,BPS_ACCOUNT_TYPE,BPS_ACCOUNT)
VALUES ('PLACE_MAP_BL_ORDER',null,'MSGTYPE','VARCHAR','fe7002',null,null,null,'','');
COMMIT;
/
