﻿--
--
/
DELETE HFT_MAPPER_EXT WHERE FO_KEY = 'tx0100';
INSERT INTO HFT_MAPPER_EXT (AUTOID,BPS_KEY_FIELD,BPS_KEY_VALUE,FO_FIELD,FO_KEY)
VALUES (5,'p_functionname|p_exectype|p_timetype','CANCELORDER|NS|T','MSGTYPE','tx0100');
INSERT INTO HFT_MAPPER_EXT (AUTOID,BPS_KEY_FIELD,BPS_KEY_VALUE,FO_FIELD,FO_KEY)
VALUES (4,'p_functionname|p_exectype|p_timetype','CANCELORDER|NB|T','MSGTYPE','tx0100');
INSERT INTO HFT_MAPPER_EXT (AUTOID,BPS_KEY_FIELD,BPS_KEY_VALUE,FO_FIELD,FO_KEY)
VALUES (3,'p_functionname|p_exectype|p_timetype','CANCELORDER||','MSGTYPE','tx0100');
COMMIT;
/
--
--
/
DELETE HFT_MAPPER_DETAIL WHERE FO_KEY = 'tx0100';
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (58,'tx0100','VIA','VARCHAR',null,'p_via',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (57,'tx0100','USERID','VARCHAR',null,'p_username|p_tlid',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (54,'tx0100','REQUESTID','VARCHAR','0','p_afacctno','SEQ','0',null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (56,'tx0100','ORDERID','VARCHAR',null,'p_acctno',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (55,'tx0100','ACCTNO','VARCHAR',null,'p_afacctno',null,null,null);
COMMIT;
/
