--
--
/
DELETE FLDMASTER WHERE OBJNAME = '2842';
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('FN','30','2842','DESC','Mô tả','Description',20,'C',null,null,250,' ',' ',' ','Y','N','N',' ',' ','N','C',null,null,null,null,'##########',null,null,'FN',null,'T','N','MAIN',null,null,null,'N','P_DESC','Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('FN','13','2842','TRFAMT','Tổng','Total',19,'N','#,##0','#,##0',19,' ',' ','0','Y','Y','Y',' ',' ','N','N',null,null,null,null,'##########',null,null,null,null,'T','N','MAIN',null,null,null,'N','P_TRFAMT','Y','0','N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('FN','12','2842','VATAMT','Thuế VAT','VAT amount',18,'N','#,##0','#,##0',18,' ',' ','0','Y','Y','Y',' ',' ','N','N',null,null,null,null,'##########',null,null,null,null,'T','N','MAIN',null,null,null,'N','P_VATAMT','Y','0','N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('FN','11','2842','FEEAMT','Số phí','Fee amount',17,'N','#,##0','#,##0',17,' ',' ','0','Y','Y','Y',' ',' ','N','N',null,null,null,null,'##########',null,null,null,null,'T','N','MAIN',null,null,null,'N','P_FEEAMT','Y','0','N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('FN','66','2842','$FEECD','Biểu phí','Fee code',15,'C',null,null,5,'SELECT FEECD VALUECD, FEECD VALUE, FEENAME DISPLAY, FEENAME EN_DISPLAY, FEENAME DESCRIPTION FROM FEEMASTER WHERE FEECD IN (SELECT DISTINCT FEECD FROM FEEMAP WHERE TLTXCD=''<$TLTXCD>'')',' ',' ','Y','N','N',' ',' ','Y','C',null,null,null,'ACNAME','##########',null,null,null,null,'T','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('FN','09','2842','IORO','Kiểu phí','Fee type',14,'C','999999','999999',17,'SELECT  A.CDVAL VALUECD, A.CDVAL VALUE, A.CDCONTENT DISPLAY, A.CDCONTENT EN_DISPLAY, A.CDCONTENT DESCRIPTION FROM ALLCODE A WHERE A.CDTYPE=''SA'' AND A.CDNAME=''IOROFEE'' ORDER BY A.LSTODR',' ','1','Y','Y','Y',' ',' ','Y','C',null,null,null,'CODEID','##########',null,null,null,null,'C','N','MAIN',null,null,null,'N','P_IORO','Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('FN','10','2842','AMT','Số lượng','Quantity',6,'N','#,##0','#,##0',19,' ',' ','0','Y','N','Y',' ',' ','N','N',null,null,null,null,'##########',null,null,'FN',null,'T','N','MAIN',null,null,null,'N','P_AMT','Y','0','N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('FN','08','2842','PRICE','Giá chuyển nhượng','Price',5,'N','#,##0','#,##0',19,' ',' ','0','Y','N','Y',' ',' ','N','N',null,null,null,'PRICE','##########','01PRICE',null,null,null,'T','N','MAIN',null,null,null,'N','P_PRICE','Y','0','N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('FN','03','2842','REFAFACCTNO','Tiểu khoản thanh toán bên nhận','Settlement sub-account',4,'C','9999.999999','9999.999999',10,null,' ',' ','Y','N','Y',' ',' ','Y','C',null,null,null,'AFACCTNO','##########','06REFAFACCTNO','AFMAST','CF',null,'M','N','MAIN',null,null,null,'N','P_AFACCTNO','Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('FN','07','2842','REFCODEID','Tham chiếu chứng chỉ quỹ','Ref fund certificate',3,'C','9999.999999','9999.999999',10,null,' ',' ','Y','N','N',' ',' ','Y','C',null,null,null,'AFACCTNO','##########','06CODEID',null,null,null,'M','N','MAIN',null,null,null,'N','P_AFACCTNO','Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('FN','06','2842','TOFNACCTNO','Tài khoản quỹ bên nhận','To Fund account',2,'C','9999.999999.999999','9999.999999.999999',20,' ',' ',' ','Y','N','Y',' ',' ','N','C',null,null,null,'FNACCTNO','##########',null,'FNMAST','FN',null,'M','N','MAIN',null,null,null,'N','P_ACCTNO','Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('SE','01','2842','CODEID','Chứng chỉ quỹ','Fund certificatge',1,'C','999999','999999',6,'SELECT  SEC.CODEID VALUECD, SEC.CODEID VALUE, ISS.fullname FULLNAME, SEC.SYMBOL DISPLAY, SEC.SYMBOL EN_DISPLAY, SEC.SYMBOL DESCRIPTION, SEC.PARVALUE, SEINFO.BASICPRICE PRICE, SEC.AFACCTNO FROM SBSECURITIES SEC, SECURITIES_INFO SEINFO, ISSUERS ISS  WHERE SEC.CODEID=SEINFO.CODEID  AND SEC.issuerid= ISS.issuerid AND SEC.SECTYPE=''008'' ORDER BY SEC.SYMBOL',' ','---','Y','Y','Y',' ',' ','Y','C',null,null,null,'CODEID','##########','05CODEID',null,null,null,'C','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null);
INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM)
VALUES ('FN','05','2842','FRFNACCTNO','Tài khoản quỹ bên chuyển','From Fund account',0,'C','9999.999999.999999','9999.999999.999999',20,' ',' ',' ','Y','N','Y',' ',' ','N','C',null,null,null,'FNACCTNO','##########',null,'FNMAST','FN',null,'M','N','MAIN',null,null,null,'N','P_ACCTNO','Y',null,'N',null,null,null);
COMMIT;
/
--
--
/
DELETE FLDVAL WHERE OBJNAME = '2842';
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('13','2842',6,'E','EX','10**08++FF**09++VV**09',null,null,null,null,null,'0');
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('12','2842',5,'E','EX','VV**09',null,null,null,null,null,'0');
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('11','2842',4,'E','EX','FF**09',null,null,null,null,null,'0');
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('07','2842',3,'V','==','01',null,'Chứng chỉ quỹ không hợp lệ','Fund certificate is invalid',null,null,'0');
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('08','2842',2,'V','>>','@0',null,'Giá phải lớn hơn 0','Price should be greater than zero',null,null,'0');
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('10','2842',1,'V','>>','@0',null,'Số lượng phải lớn hơn 0','Quantity should be greater than zero',null,null,'0');
COMMIT;
/
--
--
/
DELETE TLTX WHERE TLTXCD = '2842';
INSERT INTO TLTX (TLTXCD,TXDESC,EN_TXDESC,LIMIT,OFFLINEALLOW,IBT,OVRRQD,LATE,OVRLEV,PRN,LOCAL,CHAIN,DIRECT,HOSTACNO,BACKUP,TXTYPE,NOSUBMIT,DELALLOW,FEEAPP,MSQRQR,VOUCHER,MNEM,MSG_AMT,MSG_ACCT,WITHACCT,ACCTENTRY,BGCOLOR,DISPLAY,BKDATE,ADJALLOW,GLGP,VOUCHERID,CCYCD,RUNMOD,RESTRICTALLOW,REFOBJ,REFKEYFLD,MSGTYPE,CHKBKDATE,CFCUSTODYCD,CFFULLNAME,VISIBLE,CHKSINGLE)
VALUES ('2842','Chuyển nhượng chứng chỉ quỹ','Transfer fund certificate between customers',0,'Y','Y','Y','0',2,'Y','N','Y','Y',' ','Y','T','2','Y','Y','N','SE01','SEDEPO','10','03',' ',null,0,'Y','Y','Y','N','CA005LK','##','NET','N',null,null,null,'N','##','##','N','N');
COMMIT;
/
--
--
/
DELETE APPCHK WHERE TLTXCD = '2842';
INSERT INTO APPCHK (TLTXCD,APPTYPE,ACFLD,RULECD,AMTEXP,FLDKEY,DELTDCHK,ISRUN,CHKLEV)
VALUES ('2842','FN','05','04','10','ACCTNO','N','@1','0');
INSERT INTO APPCHK (TLTXCD,APPTYPE,ACFLD,RULECD,AMTEXP,FLDKEY,DELTDCHK,ISRUN,CHKLEV)
VALUES ('2842','FN','06','02','@A','ACCTNO','N','@1','0');
INSERT INTO APPCHK (TLTXCD,APPTYPE,ACFLD,RULECD,AMTEXP,FLDKEY,DELTDCHK,ISRUN,CHKLEV)
VALUES ('2842','FN','05','02','@A','ACCTNO','N','@1','0');
INSERT INTO APPCHK (TLTXCD,APPTYPE,ACFLD,RULECD,AMTEXP,FLDKEY,DELTDCHK,ISRUN,CHKLEV)
VALUES ('2842','CI','03','11','13','ACCTNO','N','@1','0');
COMMIT;
/
--
--
/
DELETE APPMAP WHERE TLTXCD = '2842';
INSERT INTO APPMAP (TLTXCD,APPTYPE,APPTXCD,ACFLD,AMTEXP,COND,ACFLDREF,APPTYPEREF,FLDKEY,ISRUN,TRDESC,ODRNUM)
VALUES ('2842','FN','0001','06','10',null,null,null,'ACCTNO','@1',null,0);
INSERT INTO APPMAP (TLTXCD,APPTYPE,APPTXCD,ACFLD,AMTEXP,COND,ACFLDREF,APPTYPEREF,FLDKEY,ISRUN,TRDESC,ODRNUM)
VALUES ('2842','CI','0011','03','13',null,null,null,'ACCTNO','@1',null,0);
INSERT INTO APPMAP (TLTXCD,APPTYPE,APPTXCD,ACFLD,AMTEXP,COND,ACFLDREF,APPTYPEREF,FLDKEY,ISRUN,TRDESC,ODRNUM)
VALUES ('2842','FN','0003','06','08**10',null,null,null,'ACCTNO','@1',null,0);
INSERT INTO APPMAP (TLTXCD,APPTYPE,APPTXCD,ACFLD,AMTEXP,COND,ACFLDREF,APPTYPEREF,FLDKEY,ISRUN,TRDESC,ODRNUM)
VALUES ('2842','FN','0002','05','10',null,null,null,'ACCTNO','@1',null,0);
INSERT INTO APPMAP (TLTXCD,APPTYPE,APPTXCD,ACFLD,AMTEXP,COND,ACFLDREF,APPTYPEREF,FLDKEY,ISRUN,TRDESC,ODRNUM)
VALUES ('2842','FN','0005','05','08**10',null,null,null,'ACCTNO','@1',null,0);
COMMIT;
/
