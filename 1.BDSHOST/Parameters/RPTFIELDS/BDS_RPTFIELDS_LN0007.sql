﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'LN0007';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','P_PAIDSTATUS','LN0007','P_PAIDSTATUS','Trạng thái tất toán','Paid status',8,'M','ccc','_',3,'SELECT CDVAL VALUE,CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION
FROM (
SELECT ''ALL'' CDVAL, ''ALL'' CDCONTENT, -1 LSTODR FROM DUAL
UNION
SELECT ''001'' CDVAL, ''Tất toán'' CDCONTENT, 0 LSTODR FROM DUAL
UNION
SELECT ''002'' CDVAL, ''Chưa tất toán'' CDCONTENT, 1 LSTODR FROM DUAL)
 ORDER BY LSTODR',null,'002','Y','N','Y',null,null,'Y','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y',null);
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','CUSTBANK','LN0007','CUSTBANK','Nguồn giải ngân','Exec type',7,'M','cccc','_',5,null,null,'ALL','Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'RSCTYPE','SA',null,null,null,null,'Y',null);
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','PV_ISVSD','LN0007','PV_ISVSD','Loại cầm cố','Status',6,'M','ccc','_',3,'SELECT CDVAL VALUE, CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION FROM
        (SELECT ''ALL'' CDVAL, ''Tất cả'' CDCONTENT, -1 LSTODR FROM DUAL
        UNION SELECT ''DF'' CDVAL, ''CTy'' CDCONTENT, 0 LSTODR FROM DUAL
        UNION SELECT ''VSD'' CDVAL, ''VSD'' CDCONTENT, 1 LSTODR FROM DUAL
        ) ORDER BY LSTODR',null,'ALL','Y','N','Y',null,null,'Y','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y',null);
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','SERVICETYPE','LN0007','SERVICETYPE','Loại vay','Service name',5,'M',null,null,20,'SELECT CDVAL VALUE, CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION FROM
        (SELECT ''ALL'' CDVAL, ''Tất cả'' CDCONTENT, -1 LSTODR FROM DUAL
        UNION SELECT ''GR'' CDVAL, ''Bảo lãnh tiền mua'' CDCONTENT, 0 LSTODR FROM DUAL
        UNION SELECT ''MR'' CDVAL, ''Margin'' CDCONTENT, 1 LSTODR FROM DUAL
        UNION SELECT ''DF'' CDVAL, ''Cầm cố'' CDCONTENT, 2 LSTODR FROM DUAL
        ) ORDER BY LSTODR',null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','pv_NUM','LN0007','pv_NUM','Số khế ước','Số khế ước',4,'M','cccccccccccccccc','_',20,null,null,'ALL','Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'LNNUM_S','LN',null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','PV_AFACCTNO','LN0007','PV_AFACCTNO','Số tiểu khoản','Sub account',3,'T',null,'_',30,'SELECT ''ALL'' VALUE, ''ALL'' VALUECD, ''ALL'' DISPLAY, ''ALL'' EN_DISPLAY, ''ALL'' DESCRIPTION FROM DUAL ',null,'ALL','Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'AFMAST','CF',null,'pv_CUSTODYCD','SELECT FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, DESCRIPTION FROM VW_CUSTODYCD_SUBACCOUNT WHERE FILTERCD= UPPER(''<$TAGFIELD>'')',null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','pv_CUSTODYCD','LN0007','pv_CUSTODYCD','Số TK lưu ký','Custody code',2,'M','cccc.cccccc','_',10,null,null,'ALL','Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'CUSTODYCD_CF','CF',null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','T_DATE','LN0007','T_DATE','Ðến ngày','To date',1,'M','99/99/9999','dd/MM/yyyy',10,null,null,'<$BUSDATE>','Y','N','Y',null,null,'N','D',null,null,null,null,null,null,null,null,null,null,null,null,'Y',null);
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','F_DATE','LN0007','F_DATE','Từ ngày','From date',0,'M','99/99/9999','dd/MM/yyyy',10,null,null,'<$BUSDATE>','Y','N','Y',null,null,'N','D',null,null,null,null,null,null,null,null,null,null,null,null,'Y',null);
COMMIT;
/
