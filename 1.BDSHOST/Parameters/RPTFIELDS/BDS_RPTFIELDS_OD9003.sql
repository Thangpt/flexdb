﻿--
--
/
DELETE RPTFIELDS WHERE OBJNAME = 'OD9003';
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('OD','PV_CUSTID','OD9003','PV_CUSTID','Mã kh ủy quyền','Mã kh ủy quyền',5,'M','9999.999999','9999.999999',30,null,null,null,'Y','N','Y',null,null,'N','C',null,null,null,'AFACCTNO','##########',null,'CFAUTH','CF',null,'PV_AFACCTNO','SELECT CUSTID FILTERCD, CUSTID VALUE, CUSTID VALUECD, fullname DISPLAY,
fullname EN_DISPLAY, fullname DESCRIPTION FROM CFAUTH WHERE ACCTNO =''<$TAGFIELD>''  union all select ''Không chọn'' FILTERCD  , ''000'' value  , ''000'' valuecd , ''Không chọn'' DISPLAY , ''Không chọn'' EN_DISPLAY , ''Không chọn'' DESCRIPTION from dual  ORDER BY VALUE ',null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('OD','VIATYPE','OD9003','VIATYPE',' Loại kênh ','VIA type',3,'M','ccccccccccc','_',10,'SELECT VALUE VALUE, VALUE VALUECD, fullname DISPLAY, SYMBOL EN_DISPLAY, SYMBOL DESCRIPTION
 FROM (SELECT ''F'' VALUE ,''Truc tiep'' SYMBOL ,''Truc tiep'' fullname ,0 LSTODR FROM DUAL
    UNION ALL
SELECT ''O'' VALUE , ''Online'' SYMBOL ,''Online'' fullname ,1 LSTODR FROM DUAL)ORDER BY LSTODR',null,'Truc tiep','Y','N','Y',null,null,'N','C',null,null,null,null,null,null,null,null,null,null,null,null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('OD','PV_AFACCTNO','OD9003','PV_AFACCTNO','Số tiểu khoản','Sub account',2,'M','9999.999999','9999.999999',30,null,null,null,'Y','N','Y',null,null,'N','C',null,null,null,'AFACCTNO','##########',null,'CIMAST_ALL','CF',null,'PV_CUSTODYCD','SELECT FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, DESCRIPTION FROM VW_CUSTODYCD_SUBACCOUNT WHERE FILTERCD=upper(''<$TAGFIELD>'')
 union all select ''ALL'' FILTERCD  , ''ALL'' value  , ''ALL'' valuecd , ''ALL'' DISPLAY , ''ALL'' EN_DISPLAY , ''ALL'' DESCRIPTION from dual  ORDER BY VALUE DESC

',null,'Y','C');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('OD','PV_CUSTODYCD','OD9003','PV_CUSTODYCD',' Số TK lưu ký ','Custody code',1,'M','cccc.cccccc','_',10,null,null,null,'Y','N','Y',null,null,'N','C',null,null,null,null,null,null,'CUSTODYCD_TX','CF',null,null,null,null,'Y','T');
INSERT INTO RPTFIELDS (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,TAGFIELD,TAGLIST,TAGVALUE,ISPARAM,CTLTYPE)
VALUES ('OD','I_DATE','OD9003','I_DATE',' Ngày giao dịch ','In date',0,'M','99/99/9999','dd/MM/yyyy',10,null,null,'<$BUSDATE>','Y','N','Y',null,null,'N','D',null,null,null,null,null,null,null,null,null,null,null,null,'Y','T');
COMMIT;
/
