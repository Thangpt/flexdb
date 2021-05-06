--
--
/
DELETE DEFERROR WHERE MODCODE = 'FO';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-90036,'[-90036]: Tài sản không đủ đảm bảo dư nợ cần đánh dấu','[-90036]: Assets are not sufficient to ensure outstanding mark','FO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-800002,'[-800002]: Lệnh không được hủy do đã khớp hết hoặc đã được yêu cầu hủy sửa rồi!','[-800002]: gc_ERRCODE_FO_INVALID_STATUS','FO',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-800003,'[-800003]: Số hiệu lệnh không đúng!','[-800003]: gc_INVALID_ORDERID','FO',null);
COMMIT;
/
