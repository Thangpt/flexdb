﻿--
--
/
DELETE hft_mapper_detail WHERE fo_key = 'fe7007';
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (356,'fe7007','BLORDERID','VARCHAR','','p_blOrderId','','',null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (357,'fe7007','ORDERMAPID','VARCHAR','','p_orderMapId','','',null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (358,'fe7007','TLID','VARCHAR','','p_tellerId','','',null);
COMMIT;
/