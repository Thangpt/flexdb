﻿--
--
/
DELETE HFT_REMAP_FIELD WHERE BPS_FUNCTION = 'BD_GET_PP_SE';
INSERT INTO HFT_REMAP_FIELD (BPS_MODULE,BPS_FUNCTION,ACTION,FO_FIELD,BPS_FIELD,BPS_FIELD_TYPE,BPS_DEFAULT_VALUE)
VALUES (null,'BD_GET_PP_SE','ADD',null,'MRRATIOLOAN','NUMBER','0');
COMMIT;
/