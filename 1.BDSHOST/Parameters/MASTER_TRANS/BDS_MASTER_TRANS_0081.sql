﻿--
--
/
DELETE FLDMASTER WHERE OBJNAME = '0081';
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CF','30','0081','DESC','Diễn giải','Description',5,'C',' ',' ',250,' ',' ',' ','Y','N','N',' ',' ','N','C',null,null,null,null,'##########',null,null,null,null,'T','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CF','11','0081','FOCUSTYPE','Focus type','Focus type ',3,'C','999','999',4,'SELECT  A.CDVAL VALUECD, A.CDVAL VALUE, A.CDCONTENT DISPLAY, A.CDCONTENT EN_DISPLAY, A.CDCONTENT DESCRIPTION FROM ALLCODE A WHERE A.CDTYPE=''CF'' AND A.CDNAME=''FOCUSTYPE'' ORDER BY A.LSTODR',null,null,'Y','N','N',null,null,'Y','C',null,null,null,'CODEID','##########','03FOCUSTYPE1',null,null,null,'M','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CF','10','0081','STAFF','Staff','Staff',2,'C','999','999',4,'SELECT  A.CDVAL VALUECD, A.CDVAL VALUE, A.CDCONTENT DISPLAY, A.CDCONTENT EN_DISPLAY, A.CDCONTENT DESCRIPTION FROM ALLCODE A WHERE A.CDTYPE=''CF'' AND A.CDNAME=''STAFF'' ORDER BY A.LSTODR',null,null,'Y','N','N',null,null,'Y','C',null,null,null,'CODEID','##########','03STAFF1',null,null,null,'M','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CF','09','0081','CLASS','Class','Class',1,'C','999','999',4,'SELECT  A.CDVAL VALUECD, A.CDVAL VALUE, A.CDCONTENT DISPLAY, A.CDCONTENT EN_DISPLAY, A.CDCONTENT DESCRIPTION FROM ALLCODE A WHERE A.CDTYPE=''CF'' AND A.CDNAME=''CLASS'' ORDER BY A.LSTODR',' ',' ','Y','N','N',' ',' ','Y','C',null,null,null,'CODEID','##########','03CLASS1',null,null,null,'M','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('CF','03','0081','CUSTID','Số Tiểu khoản','Customer ID',0,'C','9999.999999','9999.999999',10,' ',' ',' ','Y','N','N',' ',' ','N','C',null,null,null,'CUSTID','##########',null,'CFMAST_TX','CF',null,'M','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
COMMIT;
/
--
--
/
DELETE TLTX WHERE TLTXCD = '0081';
INSERT INTO TLTX (TLTXCD,TXDESC,EN_TXDESC,LIMIT,OFFLINEALLOW,IBT,OVRRQD,LATE,OVRLEV,PRN,LOCAL,CHAIN,DIRECT,HOSTACNO,BACKUP,TXTYPE,NOSUBMIT,DELALLOW,FEEAPP,MSQRQR,VOUCHER,MNEM,MSG_AMT,MSG_ACCT,WITHACCT,ACCTENTRY,BGCOLOR,DISPLAY,BKDATE,ADJALLOW,GLGP,VOUCHERID,CCYCD,RUNMOD,RESTRICTALLOW,REFOBJ,REFKEYFLD,MSGTYPE,CHKBKDATE,CFCUSTODYCD,CFFULLNAME,VISIBLE,CHKSINGLE)
VALUES ('0081','Thay đổi thông tin khách hàng - Phân loại','Change customer profile - classification',0,'Y','Y','Y','0',2,'Y','N','N','N',' ','Y','M','2','N','N','N','CF01','CFCHG','10','03',' ',null,0,'Y','N','Y','N',null,'##','NET','N',null,null,null,'N','##','##','N','N');
COMMIT;
/
--
--
/
DELETE APPCHK WHERE TLTXCD = '0081';
INSERT INTO APPCHK (TLTXCD,APPTYPE,ACFLD,RULECD,AMTEXP,FLDKEY,DELTDCHK,ISRUN,CHKLEV)
VALUES ('0081','CF','03','03','@A','CUSTID','N','@1','0');
COMMIT;
/
--
--
/
DELETE APPMAP WHERE TLTXCD = '0081';
INSERT INTO APPMAP (TLTXCD,APPTYPE,APPTXCD,ACFLD,AMTEXP,COND,ACFLDREF,APPTYPEREF,FLDKEY,ISRUN,TRDESC,ODRNUM)
VALUES ('0081','CF','0036','03','10',null,'03','CF','CUSTID','@1',null,0);
INSERT INTO APPMAP (TLTXCD,APPTYPE,APPTXCD,ACFLD,AMTEXP,COND,ACFLDREF,APPTYPEREF,FLDKEY,ISRUN,TRDESC,ODRNUM)
VALUES ('0081','CF','0035','03','09',null,'03','CF','CUSTID','@1',null,0);
INSERT INTO APPMAP (TLTXCD,APPTYPE,APPTXCD,ACFLD,AMTEXP,COND,ACFLDREF,APPTYPEREF,FLDKEY,ISRUN,TRDESC,ODRNUM)
VALUES ('0081','CF','0037','03','11',null,'03','CF','CUSTID','@1',null,0);
COMMIT;
/
