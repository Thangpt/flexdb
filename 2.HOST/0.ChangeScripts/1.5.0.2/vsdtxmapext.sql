delete from vsdtxmapext where OBJNAME = '0043' and TRFCODE = '598.NEWM/AOPN' and FLDNAME = 'PHONE';

insert into vsdtxmapext (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, ODRNUM)
values ('T', '0043', '598.NEWM/AOPN', 'PHONE', 'C', '$01', 'SELECT MOBILE FROM CFMAST WHERE CUSTID=''<$FILTERID>''', 'Số điện thoại', null);

commit;