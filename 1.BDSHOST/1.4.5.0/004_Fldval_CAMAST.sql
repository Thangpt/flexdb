delete from fldval where objname='CA.CAMAST' and fldname like '028%';
insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('028DEVIDENTRATE', 'CA.CAMAST', 64, 'V', '>=', '@0', null, 'Tỷ lệ chia lợi tức (%)  phải lớn hơn 0', 'DevidentRate format is invalid!', 'CATYPE', '@028', 0);

insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('028DEVIDENTVALUE', 'CA.CAMAST', 65, 'V', '>=', '@0', null, 'Số tiền chi trả phải lớn hơn 0', 'DevidentValue format is invalid!', 'CATYPE', '@028', 0);

insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('028EXPRICE', 'CA.CAMAST', 66, 'V', '>=', '@0', null, 'Giá thanh toán phải lớn hơn 0', 'Exprice format is invalid!', 'CATYPE', '@028', 0);

insert into fldval (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
values ('028DESCRIPTION', 'CA.CAMAST', 67, 'E', 'FX', 'FN_GEN_DESC_CAMAST_028', 'CODEID##REPORTDATE##028TYPERATE##028DEVIDENTRATE##028DEVIDENTVALUE', null, null, null, null, 0);

commit;


