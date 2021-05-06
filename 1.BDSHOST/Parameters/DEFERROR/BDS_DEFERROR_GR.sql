--
--
/
DELETE DEFERROR WHERE MODCODE = 'GR';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-580001,'Invalid status','Invalid status','GR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-580002,'Not enought balance','Not enough the collaterall value','GR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-580003,'Not enought secured balance','Not enough the collaterall value','GR',null);
COMMIT;
/
