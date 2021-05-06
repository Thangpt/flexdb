﻿--
--
/
DELETE HFT_MAPPER_DETAIL WHERE FO_KEY = 'tx6000';
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (70,'tx6000','SYMBOL','VARCHAR',null,'p_symbol',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (69,'tx6000','PRICE','NUMBER',null,'p_quoteprice','**','1',null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (68,'tx6000','ACCTNO','VARCHAR',null,'p_afacctno',null,null,null);
COMMIT;
/
