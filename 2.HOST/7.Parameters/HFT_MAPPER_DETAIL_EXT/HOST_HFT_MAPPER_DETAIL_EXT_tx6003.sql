﻿--
--
/
DELETE HFT_MAPPER_DETAIL WHERE FO_KEY = 'tx6003';
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (102,'tx6003','ORDERID','VARCHAR',null,'AFACCTNO|p_afacctno',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (101,'tx6003','ACCTNO','VARCHAR',null,'AFACCTNO|p_afacctno',null,null,null);
COMMIT;
/
