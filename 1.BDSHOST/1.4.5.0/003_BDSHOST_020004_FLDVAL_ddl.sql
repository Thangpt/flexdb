--select * from fldval where objname like 'SA.SBSECURITIES';
delete from fldval where objname like 'SA.SBSECURITIES' AND FLDNAME LIKE '011%';

insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('011EXERCISERATIO', 'SA.SBSECURITIES', 23, 'F', 'IN', '@^[^0-]\d*/[^0-]\d*$', null, 'Tỷ lệ thực hiện có dạng a/b và lớn hơn 0!', 'The rate format is invalid!', 'SECTYPE', '@011', 0);

insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('011EXERCISERATIO', 'SA.SBSECURITIES', 24, 'V', '>>', '@0', null, 'Tỷ lệ thực hiện phải lớn hơn 0!', 'Exrate should be greater than 0!', 'SECTYPE', '@011', 0);

insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('011NVALUE', 'SA.SBSECURITIES', 22, 'V', '>>', '@0', null, 'Hệ số nhân phải lớn hớn 0!', 'The Add Value should greater than 0!', 'SECTYPE', '@011', 0);

insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('011EXERCISEPRICE', 'SA.SBSECURITIES', 20, 'V', '>>', '@0', null, 'Giá thực hiện chứng quyền phải lớn hớn 0!', 'The Exercise Price should greater than 0!', 'SECTYPE', '@011', 0);

insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('011LASTTRADINGDATE', 'SA.SBSECURITIES', 34, 'V', '<<', '011MATURITYDATE', null, 'Ngày giao dịch cuối cùng nhỏ hơn ngày đáo hạn!', 'The last trading day is less than the maturity date!', 'SECTYPE', '@011', 0);

insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('011CWTERM', 'SA.SBSECURITIES', 7, 'V', '>>', '@0', null, 'Thời hạn của chứng quyền phải lớn hớn 0!', 'The term cw should greater than 0!', 'SECTYPE', '@011', 0);

insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('011EXERCISERATIO', 'SA.SBSECURITIES', 25, 'E', 'FX', 'fn_check_isnumber', '011EXERCISERATIO', null, null, 'SECTYPE', '@011', 0);

insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('011MATURITYDATE', 'SA.SBSECURITIES', 30, 'V', '==', '<$WORKDATE>', null, 'Ngày đáo hạn phải là ngày làm việc!', 'Maturity date should be working date!', 'SECTYPE', '@011', 0);

insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('011LASTTRADINGDATE', 'SA.SBSECURITIES', 31, 'V', '==', '<$WORKDATE>', null, 'Ngày giao dịch cuối cùng phải là ngày làm việc!', 'The last trading day should be working date!', 'SECTYPE', '@011', 0);

insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('011MATURITYDATE', 'SA.SBSECURITIES', 32, 'V', '>=', '@<$BUSDATE>', null, 'Ngày đáo hạn phải lớn hơn hoặc bằng ngày hiện tại!', 'Maturity date must be greater than current date!', 'SECTYPE', '@011', 0);

insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('011LASTTRADINGDATE', 'SA.SBSECURITIES', 33, 'V', '>=', '@<$BUSDATE>', null, 'Ngày giao dịch cuối cùng phải lớn hơn hoặc bằng ngày hiện tại!', 'The last trading day must be greater than current date!', 'SECTYPE', '@011', 0);

--insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
--values ('011SETTLEMENTPRICE', 'SA.SBSECURITIES', 21, 'V', '>>', '@0', null, 'Giá thanh toán chứng quyền phải lớn hớn 0!', 'The Settlement Price should greater than 0!', 'SECTYPE', '@011', 0);

commit;