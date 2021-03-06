--
--
/
DELETE HFT_MAPPER_EXT WHERE FO_KEY = 'tx1008';
INSERT INTO HFT_MAPPER_EXT (AUTOID,BPS_KEY_FIELD,BPS_KEY_VALUE,FO_FIELD,FO_KEY)
VALUES (28,'p_functionname|CLASSCD','PLACE_ADVANCED_ORDER|OCO','MSGTYPE','tx1008');
COMMIT;
/
--
--
/
DELETE HFT_MAPPER_DETAIL WHERE FO_KEY = 'tx1008';
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (267,'tx1008','VIA','VARCHAR',null,'VIA',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (265,'tx1008','USERID','VARCHAR',null,'USERID',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (268,'tx1008','TYPECD','VARCHAR',null,'TYPECD',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (274,'tx1008','SYMBOL2','VARCHAR',null,'SYMBOL2',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (270,'tx1008','SYMBOL','VARCHAR',null,'SYMBOL',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (269,'tx1008','SUBTYPECD','VARCHAR',null,'SUBTYPECD',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (275,'tx1008','SIDE2','VARCHAR',null,'SIDE2',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (271,'tx1008','SIDE','VARCHAR',null,'SIDE',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (264,'tx1008','REQUESTID','VARCHAR','0','p_afacctno','SEQ','0',null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (276,'tx1008','QTTY2','NUMBER',null,'QTTY2',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (272,'tx1008','QTTY','NUMBER',null,'QTTY',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (277,'tx1008','PRICE2','NUMBER',null,'PRICE2','**','1000',null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (273,'tx1008','PRICE','NUMBER',null,'PRICE','**','1000',null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (280,'tx1008','EXPIREDDT','VARCHAR',null,'EXPIREDDT',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (279,'tx1008','CREATEDDT','VARCHAR',null,'CREATEDDT',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (278,'tx1008','CLASSCD','VARCHAR',null,'CLASSCD',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (281,'tx1008','BROKER','VARCHAR',null,'BROKER',null,null,null);
INSERT INTO HFT_MAPPER_DETAIL (AUTOID,FO_KEY,FO_FIELD,FO_FIELD_TYPE,FO_FIELD_VALUE,BPS_FIELD,OPERATOR,VALEXP,ALTERNATIVE_VALUE)
VALUES (266,'tx1008','ACCTNO','VARCHAR',null,'ACCTNO',null,null,null);
COMMIT;
/
