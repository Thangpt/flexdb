--
--
/
DELETE DEFERROR WHERE MODCODE = 'DF';
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260001,'[-260001] Loại hình DF không tồn tại','[-260001] DF type not exist','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260002,'[-260002] Không thể giải ngân cho deal','[-260002] Can not drawdown for deal!','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260003,'[-260003] Không thể mở hợp đồng tín dung','[-260003] Can not create credit contract','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260004,'[-260004] Không thể phong toả chứng khoán nhận về','[-260004] Can not block receivable stocks','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260005,'[-260005] Trả quá số tiền phải thanh toán cho deal','[-260005] Exceed payable amount!','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260006,'[-260006] Số lượng chứng khoán chờ về không đủ để làm deal','[-260006] Not enough QTTY','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260007,'[-260007] Số lượng quyền chờ về không đủ để làm deal','[-260007] Not enough CA QTTY','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260008,'[-260008] Số lượng chứng khoán phong toả không đủ để làm deal','[-260008] Not enough block QTTY ','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260009,'[-260009] Lịch thanh toán của chứng khoán chờ về không tồn tại','[-260009] Payment schedule not exist','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260010,'[-260010] Lịch quyền chứng khoán chờ về không tồn tại','[-260010] Schedule CA receivable stock not existed','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260011,'[-260011] Danh sách chi tiết chứng khoán phong toả không tồn tại','[-260011] Detail list of blocked stocks not existed','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260012,'[-260012]: Số dư khả dụng không đủ !','[-260012]: Not enough usable amount!','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260013,'[-260013]: Hạn mức bảo lãnh không đủ !','[-260013]: Not enough T0 limit','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260014,'[-260014]: Số lượng chứng khoán giải tỏa không đủ !','[-260014]: Not enough released QTTY','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260015,'[-260015]: Giao dịch giải ngân phải được xóa trước khi xóa HĐ vay !','[-260015]: Drawdown transaction is deleted before deleting Credit contract!','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260016,'[-260016]: Không tìm thấy giao dịch giải ngân !','[-260016]: Drawdown transaction not exist!','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260017,'[-260017]: Không tìm thấy hợp đồng vay !','[-260017]: Credit contract not exist!','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260018,'[-260018]: Nợ gốc <= Tiền nộp < Tổng nợ nên không được trả nợ !','[-260018]: Principal <= amount < total outstanding : can not settle !','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260020,'[-260020] Số tiền rút không đủ','[-260020] Not enough withdrawal amount','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260021,'[-260021]: Nơi cho vay không đúng!','[-260021]: ERR_DF_DFTYPE_L_NOT_ALLOW_RRTYPE_O!','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260022,'[-260022] Phải xác nhận giải tỏa cầm cố VSD trước khi bổ sung chứng khoán','[-260022] VSD release confirmation required before adding securities','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260023,'[-260023] Loại hình vay phải có nguồn giải ngân từ ngân hàng','[-260023] LN type must have bank source','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260025,'[-260025]: DEALTYPE không dúng!','[-260025]: ERR_DF_DEALTYPE_NOT_FOUND!','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260026,'[-260026] Số tiền nộp không đủ để đưa khoản vay về trạng thái an toàn','[-260026] Amount not enough to reach Safe ratio','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260028,'[-260018]: Tiền nộp > Tổng nợ nên không được trả !','[-260018]: Amount > Total outstanding: can not settle !','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260035,'[-260035]: Tài sản quy đổi, tổng nợ đã bị thay đổi !','[-260035]: Asset collateral and total outsating are changed!','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260036,'[-260036]: Chưa xác nhận cầm cố VSD','[-260036]: ERR_DF_NOT_CONFIRM_VSD!','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260040,'[-260040]: Giao dịch chưa được giải ngân!','[-260040]: Transaction not yet drawdown!','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260041,'[-260041]: Số lượng chứng khoán không đủ!','[-260041]: QTTY not enough!','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260042,'[-260042]: Chỉ được phép thực hiện từng loại chứng khoán (hạn chế/tự do) mỗi lần!!','[-260042]: Chỉ được phép thực hiện từng loại chứng khoán (hạn chế/tự do) mỗi lần!!','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-260050,'[-260050]: Không thể giải tỏa chứng khoán cầm cố VSD','[-260050]: ERR_DF_CAN_NOT_RELEASE_VSD!','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-268003,'[-268003] Vượt quá số lượng chứng khoán được bán của deal.','[-268003] Exceed available securities amount in Deal','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-269003,'[-269003] Vượt quá số lượng chứng khoán được bán.','[-269003] Exceed available securities amount ','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-269007,'[-269007]Không được giải tỏa quá số chứng khoán được phép','[-269007] Exceed permitted amount!','DF',null);
INSERT INTO DEFERROR (ERRNUM,ERRDESC,EN_ERRDESC,MODCODE,CONFLVL)
VALUES (-269008,'[-269008] Số tiền nộp vượt quá nợ','[-269008] Exceed outstanding amount!','DF',null);
COMMIT;
/
