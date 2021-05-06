DELETE appmapbravo WHERE tltxcd in ('1179','1170','2259');
insert into appmapbravo (APPTYPE, TLTXCD, SUBTX, DORC, FLDTYPE, ACFLD, ACSEFLD, ACNAME, PRICE, SYMBOL, CODEID, BANKID, QTTYEXP, AMTEXP, ISRUN, DESCRIPTION, REFTRAN)
values ('CI', '1179', '01', 'C', 'E', '03', null, 'BALANCE', null, null, null, '02', null, '10', '@1', 'So tien', null);
insert into appmapbravo (APPTYPE, TLTXCD, SUBTX, DORC, FLDTYPE, ACFLD, ACSEFLD, ACNAME, PRICE, SYMBOL, CODEID, BANKID, QTTYEXP, AMTEXP, ISRUN, DESCRIPTION, REFTRAN)
values ('CI', '1170', '01', 'D', 'E', '03', null, 'BALANCE', null, null, null, '02', null, '10', '@1', 'So tien', null);
insert into appmapbravo (APPTYPE, TLTXCD, SUBTX, DORC, FLDTYPE, ACFLD, ACSEFLD, ACNAME, PRICE, SYMBOL, CODEID, BANKID, QTTYEXP, AMTEXP, ISRUN, DESCRIPTION, REFTRAN)
values ('SE', '2259', '02', 'D', 'E', '02', '03', 'TRADE', null, null, null, null, '10', null, '@1', null, null);
insert into appmapbravo (APPTYPE, TLTXCD, SUBTX, DORC, FLDTYPE, ACFLD, ACSEFLD, ACNAME, PRICE, SYMBOL, CODEID, BANKID, QTTYEXP, AMTEXP, ISRUN, DESCRIPTION, REFTRAN)
values ('SE', '2259', '03', 'D', 'E', '02', '03', 'BLOCKED', null, null, null, null, '06', null, '@1', null, null);
COMMIT;