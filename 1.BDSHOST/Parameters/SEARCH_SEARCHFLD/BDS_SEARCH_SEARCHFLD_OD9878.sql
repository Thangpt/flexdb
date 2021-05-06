﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'OD9878';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('OD9878','HA Putthourgh Cancelled list','HA Putthourgh Cancelled list','Select SECURITYSYMBOL,CONFIRMNUMBER,VOLUME,PRICE,BUYFIRM,SELLFIRM,BORS,ORGORDERID,confirm_no,Text
From
(
--Huy lenh thoa thuan da thuc hien (ca mua va ban):
Select c.SECURITYSYMBOL,c.CONFIRMNUMBER,c.VOLUME, c.PRICE, o.FIRM BUYFIRM,
o.SELLERCONTRAFIRM  SELLFIRM, i.bors  BORS,i.ORGORDERID, i.confirm_no, ''Huy da thuc hien'' Text
from Haptcancelled c, orderptack o, iod i
where c.CONFIRMNUMBER =o.confirmnumber(+) and c.CONFIRMNUMBER =i.confirm_no
--and o.status  =''A''
union all
--Xoa lenh thoa thuan chua xac nhan (ban)
select o.SECURITYSYMBOL,c.CONFIRMNUMBER,c.VOLUME, od.PRICE, o.FIRM BUYFIRM,
o.SELLERCONTRAFIRM  SELLFIRM, o.side BORS,od.ORGORDERID, '''' confirm_no , ''Huy ban chua xac nhan hoac tu choi lenh mua'' Text
from Haptcancelled c, orderptack o, ordermap_ha om,ood od
where c.CONFIRMNUMBER =o.confirmnumber
and o.confirmnumber =om.order_number
and om.orgorderid =od.orgorderid
and o.confirmnumber not in (select NVL(confirm_no,''1'') from iod)
and od.oodstatus =''B''
) Where 1=1','ODMAST',null,null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'OD9878';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (14,'TEXT','Text','C','OD9878',100,null,'=,LIKE','_','Y','Y','N',180,null,'Text','N','  ',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (13,'CONFIRM_NO','Confirm No','C','OD9878',150,null,'=,LIKE',null,'Y','Y','N',100,null,'confirm_no','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (10,'PRICE','Khoi luong','N','OD9878',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',80,null,'PRICE','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (9,'VOLUME','Khoi luong','N','OD9878',100,null,'<,<=,=,>=,>,<>','#,##0','Y','Y','N',80,null,'VOLUME','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (8,'SECURITYSYMBOL','Chung khoan','C','OD9878',80,null,'=,LIKE','_','Y','Y','N',40,null,'SECURITYSYMBOL','N','  ',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (7,'SELLFIRM','SELLFIRM','C','OD9878',80,null,'=,LIKE',null,'Y','Y','N',40,null,'SELLFIRM','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (6,'BUYFIRM','BUYFIRM','C','OD9878',80,null,'=,LIKE',null,'Y','Y','N',40,null,'BUYFIRM','N',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (5,'BORS','MUA/BAN','C','OD9878',80,null,'=','_','Y','Y','N',20,'SELECT CDVAL VALUE, CDCONTENT DISPLAY FROM ALLCODE WHERE CDTYPE = ''OD'' AND CDNAME = ''BORS'' ORDER BY LSTODR','Buy/Sell','N','30',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'ORGORDERID','ORGORDERID','C','OD9878',150,null,'=,LIKE','_','Y','Y','N',120,null,'ORGORDERID','N','  ',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'CONFIRMNUMBER','Order number','C','OD9878',150,null,'=,LIKE','_','Y','Y','N',120,null,'CONFIRMNUMBER','N','  ',null,'N',null,null,null,'N');
COMMIT;
/