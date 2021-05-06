--
--
/
DELETE DEFERROR WHERE MODCODE = 'PR';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100521,'[-100521]: Nguồn đã được sử dụng không được phép xóa!','[-100521]: CAN NOT BE DELETED!','PR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100529,'[-100529]: Không thể xoá dữ liệu khi nguồn đang được sử dụng!','[-100529]: CAN NOT BE DELETED! INUSED!','PR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100533,'[-100533]: Hạn mức giảm quá hạn mức còn lại!','[-100533]: Decreased limit exceed remain limit!','PR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100534,'[-100534]: Mã nguồn không tồn tại!','[-100534]: PRCODE NOT EXIST!','PR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100542,'[-100542]: Không phải TK Margin !','[-100542]: Not a Margin Sub Account !','PR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100543,'[-100543]: Chứng khoán chuyển không hợp lệ !','[-100543]: Transfer securities code not valid !','PR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100544,'[-100544]: Số lượng CK chuyển vượt quá SL chuyển tối đa !','[-100544]: Transfer QTTY exceed max QTTY !','PR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100545,'[-100545]: Chứng khoán nhận không hợp lệ !','[-100545]: Receivable securities invalid !','PR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100546,'[-100546]: Vượt quá hạn mức còn lại của Room hoặc số dư TK CK nhận không đủ !','[-100546]: Exceed room remain or not enough QTTY !','PR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100547,'[-100547]: Hệ thống chỉ tồn tại duy nhất một nguồn cho mỗi mã CK margin!','[-100547]: 1 source remain only in system for each symbol of MR !','PR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100548,'[-100548]: Giá trị nguồn tăng thêm không được vượt quá phần nguồn đã sử dụng !','[-100548]: Increased value not exceed sorce used !','PR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100549,'[-100549]: Giá trị nguồn tăng thêm phải dương !','[-100549]: Increased value must be greater than 0 !','PR',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-100550,'[-100550]: Hạn mức nguồn muốn đảo vượt quá giá trị đảo nguồn tối đa có thể của hệ thống !','[-100550]: Limit of rollover source exceed max limit of system','PR',null);
COMMIT;
/
