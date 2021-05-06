


delete from filemap where filecode = 'I0018' and filerowname = 'SBTYPE';
insert into filemap (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT)
values ('I0018', 'SBTYPE', 'SBTYPE', 'C', null, 20, 'N', 'N', 'Y', 'Y', 5, 'Loại lịch', 'N');
commit;
