delete from deferror where errnum ='-700110';

insert into deferror (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL)
values (-700110, '[-700110]: TPDN không được đặt loại giá MTL, MOK, MAK, PLO!', '[-700110]:  Corporate Bond do not user pricetype MTL, MOK, MAK, PLO!', 'OD', null);

commit; 
