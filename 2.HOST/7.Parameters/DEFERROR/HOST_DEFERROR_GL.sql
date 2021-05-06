﻿--
--
/
DELETE DEFERROR WHERE MODCODE = 'GL';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500001,'[-500001]: Mã số tài sản đã được sử dụng!','[-500001]: Fixed asset code is duplicated!','GL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500002,'[-500002]: Không thể xoá tài khoản này vì còn dữ liệu liên quan!','[-500002]: Cannot delete the Account number which contains related data!','GL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500003,'[-500003]: Mã tài khoản kế toán đã được sử dụng!','[-500003]: GL account is duplicated!','GL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500004,'[-500004]: Mã số tài khoản không tồn tại!','[-500004]: GL code is not exists!','GL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500005,'[-500005]: gc_ERRCODE_GL_ACCTENTRY_DOESNOTBALANCE','[-500005]: gc_ERRCODE_GL_ACCTENTRY_DOESNOTBALANCE','GL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500006,'[-500006]: gc_ERRCODE_GL_ACCTENTRY_OFFBALANCESHEET','[-500006]: gc_ERRCODE_GL_ACCTENTRY_OFFBALANCESHEET','GL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500007,'[-500007]: gc_ERRCODE_GL_ACCTENTRY_NOTSAMECCYCD','[-500007]: gc_ERRCODE_GL_ACCTENTRY_NOTSAMECCYCD','GL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500008,'[-500008]: Không thể xoá tài khoản kế toán này do vẫn còn dữ liệ liên quan!','[-500008]: Cannot delete the GL account which contains related data!','GL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500009,'[-500009] Số dư tài khoản kế toán không đủ.','[-500009] Not enough GL account balance','GL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500010,'[-500010] ERRCODE_GL_DRGLEXP_ACCTNO_DOESNOTEXIST','[-500010] ERRCODE_GL_DRGLEXP_ACCTNO_DOESNOTEXIST','GL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500011,'[-500011] ERRCODE_GL_CRGLDEPR_ACCTNO_DOESNOTEXIST','[-500011] ERRCODE_GL_CRGLDEPR_ACCTNO_DOESNOTEXIST','GL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500012,'[-500012]:ERR_GL_BKDATE_IN_HOLIDAY','[-500012]:ERR_GL_BKDATE_IN_HOLIDAY','GL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500013,'[-500013] Không cùng chi nhánh trong bút toán đang thực hiện','[-500013] Not the same branch in current entry!','GL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500014,'[-500014]: Mã TK cấp trên bao gồm 7 ký tự','[-500014]: Superior account number includes 7 character','GL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500015,'[-500015]: Mã TK chi tiết 2 bao gồm 3 ký tự','[-500015]: Details account level 2 includes 3 character','GL',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-500016,'[-500016]: Mã TK GL này đã được tạo','[-500016]: GL code duplicated','GL',null);
COMMIT;
/