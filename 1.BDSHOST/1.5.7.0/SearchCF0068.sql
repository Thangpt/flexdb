delete from Search where SEARCHCODE='CF0068';

insert into Search (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE)
values ('CF0068', 'DANH SÁCH TÀI KHOẢN ĐĂNG KÝ SỬ DỤNG SẢN PHẨM', 'REGISTER PORODUC', 'Select t.Txdate
      ,t.Txnum
      ,t.Afacctno
      ,t.Produccode
      ,a.Custodycd
      ,(Select Fullname from Cfmast Where Custodycd = a.Custodycd ) Fullname
From   Registerproduc t
      ,Registerlog    a
Where  0 = 0
And    t.Afacctno = a.Afacctno
And    t.Txnum = a.Txnum', 'CFMAST', 'frmSATLID', null, '0019', null, 50, 'N', 30, 'NYNNYYYNNN', 'Y', 'T');


commit;

