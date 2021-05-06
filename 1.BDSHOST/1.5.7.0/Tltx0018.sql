
delete from tltx where tltxcd = '0018';

insert into Tltx (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHKSINGLE)
values ('0018', 'Đăng ký sử dụng sản phẩm ', 'Register Poroduc', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'N', 'Y', ' ', 'Y', 'M', '2', 'N', 'N', 'N', null, null, null, '05', ' ', null, 0, 'Y', 'N', 'N', 'N', null, '##', 'DB', 'N', null, null, null, 'N', '88', '04', 'Y', 'N');



commit;
