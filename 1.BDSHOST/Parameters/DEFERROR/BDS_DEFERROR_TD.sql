--
--
/
DELETE DEFERROR WHERE MODCODE = 'TD';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-570001,'Trùng biểu lãi suất của loại hình','Interest table is duplicated','TD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-570002,'Không tìm thông tin tham số sản phẩm','Product information not found','TD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-570003,'Số tiền nhỏ hơn mức số dư tối thiểu','The amount  is less than minimum balance','TD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-570004,'Trạng thái món tiền tiết kiệm không hợp lệ','The status of term deposit account is invalid','TD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-570005,'Vượt số dư gốc','Exceed origin balance!','TD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-570006,'Trạng thái bảo đảm sức mua không hợp lệ','Invalid purchase power status','TD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-570007,'Số dư bảo đảm không đủ','Mortgage amount not enough','TD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-570008,'Số dư được rút tối đa không đủ','Available withdraw amount not enough','TD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-570009,'Tai khoan khong duoc dung lam bao lanh tien mua','Account not allow to use underwrite!','TD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-570010,'So ghep bao lanh vuot qua so kha dung','Exceed available balance!','TD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-570011,'Khong duoc rut truoc han','Min break term less than current term ','TD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-570012,'[-570012]: Chưa hết kỳ hạn tối thiểu để chuyển sang tự động rút để mua','[-570012] :Minimum period not yet over to change to auto withdraw','TD',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-570013,'[-570013]: Loại hình không cho rút trước hạn không thể chọn tự động rút để mua bằng có!','[-570013] :This type not allow to pre_withdraw, can not choose auto withdraw to buy = Yes !','TD',null);
COMMIT;
/
