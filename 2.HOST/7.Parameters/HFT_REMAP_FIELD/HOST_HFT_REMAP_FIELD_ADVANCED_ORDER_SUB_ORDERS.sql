﻿--
--
/
DELETE HFT_REMAP_FIELD WHERE BPS_FUNCTION = 'ADVANCED_ORDER_SUB_ORDERS';
INSERT INTO HFT_REMAP_FIELD (BPS_MODULE,BPS_FUNCTION,ACTION,FO_FIELD,BPS_FIELD,BPS_FIELD_TYPE,BPS_DEFAULT_VALUE)
VALUES (null,'ADVANCED_ORDER_SUB_ORDERS','CONVERT','REMAINQTTY',null,'NUMBER',null);
INSERT INTO HFT_REMAP_FIELD (BPS_MODULE,BPS_FUNCTION,ACTION,FO_FIELD,BPS_FIELD,BPS_FIELD_TYPE,BPS_DEFAULT_VALUE)
VALUES (null,'ADVANCED_ORDER_SUB_ORDERS','CONVERT','CANCELQTTY',null,'NUMBER',null);
INSERT INTO HFT_REMAP_FIELD (BPS_MODULE,BPS_FUNCTION,ACTION,FO_FIELD,BPS_FIELD,BPS_FIELD_TYPE,BPS_DEFAULT_VALUE)
VALUES (null,'ADVANCED_ORDER_SUB_ORDERS','COPY','ORSTATUSVALUE','EN_ORSTATUS',null,null);
INSERT INTO HFT_REMAP_FIELD (BPS_MODULE,BPS_FUNCTION,ACTION,FO_FIELD,BPS_FIELD,BPS_FIELD_TYPE,BPS_DEFAULT_VALUE)
VALUES (null,'ADVANCED_ORDER_SUB_ORDERS','CONVERT','AVGEXECPRICE',null,'NUMBER',null);
INSERT INTO HFT_REMAP_FIELD (BPS_MODULE,BPS_FUNCTION,ACTION,FO_FIELD,BPS_FIELD,BPS_FIELD_TYPE,BPS_DEFAULT_VALUE)
VALUES (null,'ADVANCED_ORDER_SUB_ORDERS','CONVERT','EXECQTTY',null,'NUMBER',null);
INSERT INTO HFT_REMAP_FIELD (BPS_MODULE,BPS_FUNCTION,ACTION,FO_FIELD,BPS_FIELD,BPS_FIELD_TYPE,BPS_DEFAULT_VALUE)
VALUES (null,'ADVANCED_ORDER_SUB_ORDERS','CONVERT','ORDERQTTY',null,'NUMBER',null);
INSERT INTO HFT_REMAP_FIELD (BPS_MODULE,BPS_FUNCTION,ACTION,FO_FIELD,BPS_FIELD,BPS_FIELD_TYPE,BPS_DEFAULT_VALUE)
VALUES (null,'ADVANCED_ORDER_SUB_ORDERS','COPY','ORSTATUSVALUE','ORSTATUS',null,null);
INSERT INTO HFT_REMAP_FIELD (BPS_MODULE,BPS_FUNCTION,ACTION,FO_FIELD,BPS_FIELD,BPS_FIELD_TYPE,BPS_DEFAULT_VALUE)
VALUES (null,'ADVANCED_ORDER_SUB_ORDERS','CONVERT','QUOTEPRICE',null,'NUMBER',null);
COMMIT;
/
