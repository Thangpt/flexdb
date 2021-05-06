﻿--
--
/
DELETE FLDMASTER WHERE OBJNAME = '5571';
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CL','04','5571','NEXTTX','Giao dịch tiếp','Next transaction',1,'C','9999','9999',4,'SELECT  DISTINCT A.TLTXCD VALUECD, A.TLTXCD VALUE, A.TXDESC DISPLAY, A.EN_TXDESC EN_DISPLAY,A.TXDESC DESCRIPTION FROM TLTX A, FLDMASTER B WHERE A.CHAIN=''Y'' AND A.DIRECT=''N'' AND A.TLTXCD = B.OBJNAME AND B.MODCODE=''CL'' ORDER BY TLTXCD',' ',' ','Y','N','N',' ',' ','Y','C',null,null,null,null,'##########',null,null,null,null,'M','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CL','03','5571','ACCTNO','Số tài khoản vay','Loan account number',0,'C','9999.99.9999.999999','9999.99.9999.999999',16,' ',' ',' ','Y','N','Y',' ',' ','N','C',null,null,null,'ACCTNO','##########',null,'LNMAST_ALL','LN',null,'M','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
COMMIT;
/
--
--
/
DELETE TLTX WHERE TLTXCD = '5571';
INSERT INTO TLTX (TLTXCD,TXDESC,EN_TXDESC,LIMIT,OFFLINEALLOW,IBT,OVRRQD,LATE,OVRLEV,PRN,LOCAL,CHAIN,DIRECT,HOSTACNO,BACKUP,TXTYPE,NOSUBMIT,DELALLOW,FEEAPP,MSQRQR,VOUCHER,MNEM,MSG_AMT,MSG_ACCT,WITHACCT,ACCTENTRY,BGCOLOR,DISPLAY,BKDATE,ADJALLOW,GLGP,VOUCHERID,CCYCD,RUNMOD,RESTRICTALLOW,REFOBJ,REFKEYFLD,MSGTYPE,CHKBKDATE,CFCUSTODYCD,CFFULLNAME,VISIBLE,CHKSINGLE)
VALUES ('5571','Tra cứu thông tin tài khoản vay','Loan account inquiry',0,'Y','Y','Y','0',2,'Y','N','N','Y',' ','Y','I','1','N','N','N',null,'LNINQ',' ','03',' ',null,0,'Y','N','Y','N',null,'##','NET','N',null,null,null,'N','##','##','Y','N');
COMMIT;
/
