﻿--
--
/
DELETE HFT_MAPPER WHERE BPS_FUNCTION = 'PLACEORDER';
INSERT INTO HFT_MAPPER (BPS_FUNCTION,BPS_KEY_FIELD,FO_FIELD,FO_FIELD_TYPE,RETURN_ID,FO_URL,REQUEST_TYPE,FO_IDX_TABLE,BPS_ACCOUNT_TYPE,BPS_ACCOUNT)
VALUES ('PLACEORDER','p_functionname|p_exectype|p_timetype',null,null,null,null,null,null,'CUSTID','p_username|p_tlid');
COMMIT;
/