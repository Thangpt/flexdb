--
--
/
DELETE HFT_REMAP_VALUE WHERE BPS_MODULE = 'BOData';
INSERT INTO HFT_REMAP_VALUE (AUTOID,BPS_MODULE,BPS_FUNCTION,BPS_FIELD,REMAP_ALLCODE_VALUE,REMAP_ALLCODE_IDX)
VALUES (1,'BOData','BD_GET_ORDERS_BY_USER','STATUS','OD.ORSTATUS',null);
INSERT INTO HFT_REMAP_VALUE (AUTOID,BPS_MODULE,BPS_FUNCTION,BPS_FIELD,REMAP_ALLCODE_VALUE,REMAP_ALLCODE_IDX)
VALUES (3,'BOData','BD_GET_ORDERS_BY_USER','DESC_EXECTYPE','OD.EXECTYPE',null);
INSERT INTO HFT_REMAP_VALUE (AUTOID,BPS_MODULE,BPS_FUNCTION,BPS_FIELD,REMAP_ALLCODE_VALUE,REMAP_ALLCODE_IDX)
VALUES (2,'BOData','BD_SP_GET_ORDERS_BY_USER','STATUS','OD.ORSTATUS',null);
INSERT INTO HFT_REMAP_VALUE (AUTOID,BPS_MODULE,BPS_FUNCTION,BPS_FIELD,REMAP_ALLCODE_VALUE,REMAP_ALLCODE_IDX)
VALUES (4,'BOData','BD_SP_GET_ORDERS_BY_USER','DESC_EXECTYPE','OD.EXECTYPE',null);
COMMIT;
/
