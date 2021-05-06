﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'SE2285';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('SE2285','Danh sách ch?ng khoán c?a Flex (Giao d?ch 2285)','List Securities (wait for 2285)','
SELECT * FROM (
SELECT symbol, a1.cdcontent tradeplace, i.fullname issname
FROM sbsecurities s, issuers i, allcode a1
WHERE s.issuerid = i.issuerid AND a1.cdval = s.tradeplace AND a1.cdname = ''TRADEPLACE'' AND a1.cdtype = ''SA''
    AND sectype NOT IN (''004'') AND tradeplace IN (''005'',''002'',''001'')
ORDER BY symbol) WHERE 0 = 0   ','SEMAST','frmSEMAST',null,'2285',null,50,'N',30,'NYNNYYYNNN','Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'SE2285';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (3,'ISSNAME','Tên TCPH','C','SE2285',300,null,'LIKE,=',null,'Y','Y','N',300,null,'Issname','N','03',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'TRADEPLACE','Sàn giao d?ch','C','SE2285',100,null,'LIKE,=','_','Y','Y','N',100,null,'TradePlace','N','02',null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'SYMBOL','Mã ch?ng khoán','C','SE2285',100,null,'LIKE,=',null,'Y','Y','N',100,null,'Symbol','N','01',null,'N',null,null,null,'N');
COMMIT;
/
