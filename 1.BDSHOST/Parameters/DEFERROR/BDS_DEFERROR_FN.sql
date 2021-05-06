--
--
/
DELETE DEFERROR WHERE MODCODE = 'FN';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-280100,'[-280100]: Không đủ số dư đầu tư!','[-280100]: Not enought balance!','FN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-280101,'[-280101]: Trạng thái tài khoản không hợp lệ!','[-280101]: FN account status invalid!','FN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-280102,'[-280102]: Vượt quá số dư có thể rút!','[-280102]: Available balance not enought!','FN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-280103,'[-280103]: Chứng chỉ quỹ không đủ!','[-280103]: Fund unit not enought!','FN',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-280104,'[-280104]: Loại hình đầu tư không hợp lệ!','[-280104]: Invalid investment type!','FN',null);
COMMIT;
/
