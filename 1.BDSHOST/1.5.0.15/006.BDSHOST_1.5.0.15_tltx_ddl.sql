DELETE FROM tltx WHERE tltxcd = '0050';

insert into tltx (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHKSINGLE)
values ('0050', 'Đăng ký giao dịch qua Bloomberg', 'Bloomberg trading register', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'Y', 'Y', ' ', 'Y', 'T', '2', 'N', 'N', 'N', 'CF01', 'CFCHG', null, '03', ' ', null, 0, 'Y', 'N', 'Y', 'N', null, '##', 'DB', 'N', null, null, null, 'N', '88', '##', 'Y', 'N');

COMMIT;

DELETE FROM tltx WHERE tltxcd = '0051';

insert into tltx (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHKSINGLE)
values ('0051', 'Hủy đăng ký giao dịch qua Bloomberg', 'Cancel Bloomberg trading register', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'Y', 'N', ' ', 'Y', 'T', '2', 'N', 'N', 'N', 'CF01', 'CFCHG', null, '03', ' ', null, 0, 'Y', 'N', 'Y', 'N', null, '##', 'DB', 'N', null, null, null, 'N', '88', '##', 'Y', 'N');

COMMIT;

DELETE FROM tltx WHERE tltxcd = '0052';

insert into tltx (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHKSINGLE)
values ('0052', 'Gán TraderID cho tiểu khoản GD Bloomberg', 'Traderid to Bloomberg sub account assignment', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'Y', 'N', ' ', 'Y', 'T', '2', 'N', 'N', 'N', 'CF01', 'CFCHG', null, '03', ' ', null, 0, 'Y', 'N', 'Y', 'N', null, '##', 'DB', 'N', null, null, null, 'N', '88', '##', 'Y', 'N');

COMMIT;

DELETE FROM tltx WHERE tltxcd = '0053';

insert into tltx (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHKSINGLE)
values ('0053', 'Hủy gán TraderID cho tiểu khoản GD Bloomberg', 'Cancel Traderid to Bloomberg sub account assignment', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'Y', 'N', ' ', 'Y', 'T', '2', 'N', 'N', 'N', 'CF01', 'CFCHG', null, '05', ' ', null, 0, 'Y', 'N', 'Y', 'N', null, '##', 'DB', 'N', null, null, null, 'N', '88', '##', 'Y', 'N');

COMMIT;

