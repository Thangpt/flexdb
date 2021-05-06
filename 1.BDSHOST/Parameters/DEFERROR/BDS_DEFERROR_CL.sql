--
--
/
DELETE DEFERROR WHERE MODCODE = 'CL';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100605,'[-100605]: Không thể thu hồi vượt khoản mức đã cấp','[-100605]:ERR_SA_RETRIEVE_EXCEED_ALLOCATED','CL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-530001,'Invalid account status','Invalid account status','CL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-530002,'Invalid book type','Invalid book type','CL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-530003,'Not enought secured amount','Not enough the collaterall value','CL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-530004,'The secured amount must be zero','The secured amount must be zero','CL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-530005,'Not enought the collaterall using amount','Not enough the collaterall value','CL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-530006,'Not enought the collaterall book value','Not enough the collaterall value','CL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-530007,'Not enought the collaterall value','Not enough the collaterall value','CL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-530008,'The secured amount must be less than collaterall using amount','The secured amount must be less than collaterall using amount','CL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-530009,'Unmortaged amount is over mortaged amount','Unmortaged amount is over mortaged amount','CL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-530010,'Less than using amount','Less than using amount','CL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-700046,'[-700046]: Vượt quá hạn mức giao dịch','Exceed trading limit','CL',null);
COMMIT;
/
