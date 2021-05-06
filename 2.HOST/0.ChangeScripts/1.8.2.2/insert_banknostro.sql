--
--
/
delete from banknostro where glaccount = 'VPBANK';
insert into banknostro (SHORTNAME, FULLNAME, OWNERNAME, BANKACCTNO, GLACCOUNT, BRANCHID)
values ('109', 'Ngân hàng TMCP Việt Nam Thịnh Vượng', 'Công ty Cổ phần Chứng khoán Maritime Bank', '202989713', 'VPBANK', null);
commit;
/

