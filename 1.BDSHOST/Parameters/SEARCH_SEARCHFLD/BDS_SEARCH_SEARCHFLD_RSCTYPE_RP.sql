﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'RSCTYPE_RP';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('RSCTYPE_RP','Nguồn giải ngân','Drawndown Resource','
select * from (
SELECT RESID, RESNAME
FROM (
SELECT ''ALL'' RESID, ''All'' RESNAME, -1 LSTODR FROM DUAL
union all
SELECT ''KBSV'' RESID,''KBSV'' RESNAME, 0 LSTODR FROM dual
union all
SELECT custid RESID, nvl(fullname,shortname) RESNAME, 2 LSTODR FROM cfmast where isbanking = ''Y''
) ORDER BY LSTODR
) where 0=0
','RSCTYPE','frmRSCTYPE',null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/
--
--
/
DELETE SEARCHFLD WHERE SEARCHCODE = 'RSCTYPE_RP';
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (2,'RESNAME','Tên nguồn','C','RSCTYPE_RP',70,null,'LIKE,=','_','Y','Y','N',450,null,'Contract No','Y',null,null,'N',null,null,null,'N');
INSERT INTO SEARCHFLD (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY)
VALUES (1,'RESID','Mã nguồn','C','RSCTYPE_RP',70,null,'LIKE,=',null,'Y','Y','Y',150,null,'CUSTODYCD','N',null,null,'N',null,null,null,'N');
COMMIT;
/
