DELETE DEFERROR where errnum = -200501;
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-200501,'[-200501]: Không được sửa thông tin Email!','[-200501]: Do not edit Email information!','CF',null);
commit;