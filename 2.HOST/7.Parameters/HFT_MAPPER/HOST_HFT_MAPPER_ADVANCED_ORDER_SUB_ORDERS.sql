﻿--
--
/
DELETE HFT_MAPPER WHERE BPS_FUNCTION = 'ADVANCED_ORDER_SUB_ORDERS';
INSERT INTO HFT_MAPPER (BPS_FUNCTION,BPS_KEY_FIELD,FO_FIELD,FO_FIELD_TYPE,RETURN_ID,FO_URL,REQUEST_TYPE,FO_IDX_TABLE,BPS_ACCOUNT_TYPE,BPS_ACCOUNT)
VALUES ('ADVANCED_ORDER_SUB_ORDERS',null,'MSGTYPE','VARCHAR','tx6106',null,null,null,'CUSTID','USERID');
COMMIT;
/
