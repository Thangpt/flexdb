--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'LN1005';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','PV_AFACCTNO','LN1005','PV_AFACCTNO','Số tiểu khoản','Sub account',5,'M','9999.999999','9999.999999',30,'SELECT ''ALL'' VALUE, ''ALL'' VALUECD, ''ALL'' DISPLAY, ''ALL'' EN_DISPLAY, ''ALL'' DESCRIPTION FROM DUAL
                ',null,'ALL','Y','N','N',null,null,'N','C',null,null,null,'AFACCTNO','##########',null,'CIMAST_ALL','CF',null,'PV_CUSTODYCD','SELECT FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, DESCRIPTION FROM VW_CUSTODYCD_SUBACCOUNT WHERE FILTERCD=upper(''<$TAGFIELD>'')
 union all select ''ALL'' FILTERCD  , ''ALL'' value  , ''ALL'' valuecd , ''ALL'' DISPLAY , ''ALL'' EN_DISPLAY , ''ALL'' DESCRIPTION from dual  ORDER BY VALUE DESC

',null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','PV_CUSTODYCD','LN1005','PV_CUSTODYCD',' Số TK lưu ký ','Custody code',4,'M','cccc.cccccc','_',10,null,null,'ALL','Y','N','N',null,null,'N','C',null,null,null,null,null,null,'CUSTODYCD_TX','CF',null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','SIGNTYPE','LN1005','SIGNTYPE','Người ký','Signer',3,'M',null,null,20,'SELECT CDVAL VALUE,CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION
    FROM (
    SELECT ''TGD'' CDVAL,''Tổng Giám Ðốc'' CDCONTENT, 0 LSTODR FROM dual
    union all
    SELECT ''GDCN'' CDVAL,''Giám Ðốc Chi Nhánh'' CDCONTENT, 1 LSTODR FROM dual
    ) ORDER BY LSTODR',null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','SERVICETYPE','LN1005','SERVICETYPE','Loại vay','Service name',2,'M',null,null,20,'SELECT CDVAL VALUE, CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION FROM
        (SELECT ''ALL'' CDVAL, ''Tất cả'' CDCONTENT, -1 LSTODR FROM DUAL
        UNION SELECT ''GR'' CDVAL, ''Bảo lãnh tiền mua'' CDCONTENT, 0 LSTODR FROM DUAL
        UNION SELECT ''MR'' CDVAL, ''Margin'' CDCONTENT, 1 LSTODR FROM DUAL
        UNION SELECT ''DF'' CDVAL, ''Cầm cố'' CDCONTENT, 2 LSTODR FROM DUAL
        ) ORDER BY LSTODR',null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','T_DATE','LN1005','T_DATE','Đến ngày','To date',1,'M','99/99/9999','dd/MM/yyyy',10,null,null,'<$BUSDATE>','Y','N','Y',null,null,'N','D',null,null,null,null,null,null,null,null,null,null,null,null,'Y',null);
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','CUSTBANK','LN1005','CUSTBANK','Nguồn giải ngân','Exec type',1,'M','cccc','_',5,null,null,'ALL','Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'RSCTYPE','SA',null,null,null,null,'Y',null);
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('LN','F_DATE','LN1005','F_DATE','Từ ngày','From date',0,'M','99/99/9999','dd/MM/yyyy',10,null,null,'<$BUSDATE>','Y','N','Y',null,null,'N','D',null,null,null,null,null,null,null,null,null,null,null,null,'Y',null);
COMMIT;
/
