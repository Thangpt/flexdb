﻿--
--
/
DELETE HFT_MAPPER WHERE BPS_FUNCTION = 'GET_NORMAL_ORDER_LIST';
INSERT INTO HFT_MAPPER (BPS_FUNCTION,BPS_KEY_FIELD,FO_FIELD,FO_FIELD_TYPE,RETURN_ID,FO_URL,REQUEST_TYPE,FO_IDX_TABLE,BPS_ACCOUNT_TYPE,BPS_ACCOUNT)
VALUES ('GET_NORMAL_ORDER_LIST',null,'MSGTYPE','VARCHAR','tx6005',null,null,null,'CUSTID','PLACECUSTID');
COMMIT;
/