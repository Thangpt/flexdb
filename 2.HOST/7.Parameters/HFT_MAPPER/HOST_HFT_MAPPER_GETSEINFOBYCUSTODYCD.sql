﻿--
--
/
DELETE HFT_MAPPER WHERE BPS_FUNCTION = 'GETSEINFOBYCUSTODYCD';
INSERT INTO HFT_MAPPER (BPS_FUNCTION,BPS_KEY_FIELD,FO_FIELD,FO_FIELD_TYPE,RETURN_ID,FO_URL,REQUEST_TYPE,FO_IDX_TABLE,BPS_ACCOUNT_TYPE,BPS_ACCOUNT)
VALUES ('GETSEINFOBYCUSTODYCD',null,'MSGTYPE','VARCHAR','tx6004',null,null,0,'AFACCTNO','p_afacctno');
COMMIT;
/
