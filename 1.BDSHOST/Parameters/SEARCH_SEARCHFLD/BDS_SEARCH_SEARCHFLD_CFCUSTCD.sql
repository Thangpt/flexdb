--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'CFCUSTCD';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('CFCUSTCD','Quản lý số tài khoản lưu ký','Custody code management','SELECT MST.AUTOID, MST.CUSTODYCD, A0.CDCONTENT DESC_CUSTTYPE, MST.CUSTID, NVL(CF.FULLNAME,''...'') CFFULLNAME,
A1.CDCONTENT DESC_EXCHANGECD, A2.CDCONTENT DESC_TYPESUBCD, A3.CDCONTENT DESC_STATUS
FROM CFCUSTODYCD MST, CFMAST CF, ALLCODE A0, ALLCODE A1, ALLCODE A2, ALLCODE A3
WHERE MST.CUSTID=CF.CUSTID (+)
AND A0.CDTYPE=''SA'' AND A0.CDNAME=''CUSTTYPE'' AND A0.CDVAL=MST.CUSTTYPE
AND A1.CDTYPE=''SA'' AND A1.CDNAME=''EXCHANGECD'' AND A1.CDVAL=MST.EXCHANGECD
AND A2.CDTYPE=''SA'' AND A2.CDNAME=''TYPESUBCD'' AND A2.CDVAL=MST.TYPESUBCD
AND A3.CDTYPE=''SA'' AND A3.CDNAME=''STATUS'' AND A3.CDVAL=MST.STATUS ','CFCUSTODYCD','frmCFCUSTODYCD',null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'CFCUSTCD';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'DESC_STATUS','Trạng thái','C','CFCUSTCD',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Status','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'DESC_EXCHANGECD','Nơi giao dịch','C','CFCUSTCD',100,null,'LIKE,=',null,'Y','Y','N',120,null,'Exchange','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (4,'CFFULLNAME','Tên KH','C','CFCUSTCD',100,null,'LIKE,=',null,'Y','Y','N',200,null,'Customer name','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'DESC_TYPESUBCD','Loại tài khoản','C','CFCUSTCD',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Account type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'DESC_CUSTTYPE','Loại khách hàng','C','CFCUSTCD',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Custody type','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CUSTODYCD','Số lưu ký','C','CFCUSTCD',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Custody code','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (0,'AUTOID','Mã quản lý','C','CFCUSTCD',100,null,'LIKE,=','_','N','N','Y',80,null,'AutoID','N',null,null,'N',null,null,null,'N');
COMMIT;
/
