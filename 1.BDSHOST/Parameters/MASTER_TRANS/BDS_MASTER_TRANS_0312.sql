--
--
/
DELETE FLDMASTER WHERE OBJNAME = '0312';
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('RE','30','0312','T_DESC','Diễn giải','Description',30,'C',' ',' ',250,' ',' ',null,'Y','N','N',' ',' ','N','C',null,null,null,null,'##########',null,null,null,null,'T','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('RE','10','0312','AMT','Giá trị điều chỉnh','Adjust amount',3,'N','#,##0','#,##0',19,' ',' ',' ','Y','N','Y',' ',' ','N','N',null,null,null,null,'##########',null,null,null,null,'T','N','MAIN',null,null,null,'N','P_AMT','Y','0','N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('RE','05','0312','DIRECTFEEACR','Doanh thu trực tiếp','Directfee acr',2,'N','#,##0','#,##0',19,' ',' ',' ','Y','Y','N',' ',' ','N','N',null,null,null,null,'##########','03DIRECTFEEACR',null,null,null,'T','N','MAIN',null,null,null,'N','P_AMT','Y','0','N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('RE','03','0312','REACCTNO','Tài khoản đại lý/môi giới','Remiser account',1,'C','9999.999999.9999','9999.999999.9999',14,null,null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'REMAST_FULL','RE',null,'M','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
COMMIT;
/
--
--
/
DELETE FLDVAL WHERE OBJNAME = '0312';
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('05','0312',0,'V','>=','05--05--10',null,'Không được điều chỉnh doanh thu nhỏ hơn 0',null,null,null,'0');
COMMIT;
/
--
--
/
DELETE TLTX WHERE TLTXCD = '0312';
INSERT INTO TLTX (TLTXCD,TXDESC,EN_TXDESC,LIMIT,OFFLINEALLOW,IBT,OVRRQD,LATE,OVRLEV,PRN,LOCAL,CHAIN,DIRECT,HOSTACNO,BACKUP,TXTYPE,NOSUBMIT,DELALLOW,FEEAPP,MSQRQR,VOUCHER,MNEM,MSG_AMT,MSG_ACCT,WITHACCT,ACCTENTRY,BGCOLOR,DISPLAY,BKDATE,ADJALLOW,GLGP,VOUCHERID,CCYCD,RUNMOD,RESTRICTALLOW,REFOBJ,REFKEYFLD,MSGTYPE,CHKBKDATE,CFCUSTODYCD,CFFULLNAME,VISIBLE,CHKSINGLE)
VALUES ('0312','Điều chỉnh doanh thu cộng dồn cho môi giới','Adjust net revenue for broker/remiser',0,'Y','Y','Y','0',2,'Y','N','Y','Y',' ','Y','M','2','N','N','N','TD01','TDOPEN','10','03',' ',null,0,'Y','N','Y','N',null,'##','NET','N',null,null,null,'N','##','##','Y','N');
COMMIT;
/
--
--
/
DELETE APPCHK WHERE TLTXCD = '0312';
INSERT INTO APPCHK (TLTXCD,APPTYPE,ACFLD,RULECD,AMTEXP,FLDKEY,DELTDCHK,ISRUN,CHKLEV)
VALUES ('0312','RE','03','01','@A','ACCTNO','N','@1','0');
COMMIT;
/
--
--
/
DELETE APPMAP WHERE TLTXCD = '0312';
INSERT INTO APPMAP (TLTXCD,APPTYPE,APPTXCD,ACFLD,AMTEXP,COND,ACFLDREF,APPTYPEREF,FLDKEY,ISRUN,TRDESC,ODRNUM)
VALUES ('0312','RE','0028','03','10',null,null,null,'ACCTNO','@1',null,0);
COMMIT;
/
