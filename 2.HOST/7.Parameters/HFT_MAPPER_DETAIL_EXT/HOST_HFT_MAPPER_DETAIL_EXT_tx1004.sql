--
--
/
DELETE HFT_MAPPER_EXT WHERE FO_KEY = 'tx1004';
INSERT INTO HFT_MAPPER_EXT (AUTOID,BPS_KEY_FIELD,BPS_KEY_VALUE,FO_FIELD,FO_KEY)
VALUES (24,'p_functionname|CLASSCD','PLACE_ADVANCED_ORDER|PCO','MSGTYPE','tx1004');
COMMIT;
/
--
--
/
DELETE HFT_MAPPER_DETAIL WHERE FO_KEY = 'tx1004';
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (213,'tx1004','VIA','VARCHAR',null,'VIA',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (209,'tx1004','USERID','VARCHAR',null,'USERID',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (214,'tx1004','TYPECD','VARCHAR',null,'TYPECD',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (211,'tx1004','SYMBOL','VARCHAR',null,'SYMBOL',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (215,'tx1004','SUBTYPECD','VARCHAR',null,'SUBTYPECD',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (212,'tx1004','SIDE','VARCHAR',null,'SIDE',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (208,'tx1004','REQUESTID','VARCHAR','0','p_afacctno','SEQ','0',null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (216,'tx1004','QTTY','NUMBER',null,'QTTY',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (219,'tx1004','EXPIREDDT','VARCHAR',null,'EXPIREDDT',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (218,'tx1004','CREATEDDT','VARCHAR',null,'CREATEDDT',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (217,'tx1004','CLASSCD','VARCHAR',null,'CLASSCD',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (220,'tx1004','BROKER','VARCHAR',null,'BROKER',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (210,'tx1004','ACCTNO','VARCHAR',null,'ACCTNO',null,null,null);
COMMIT;
/
