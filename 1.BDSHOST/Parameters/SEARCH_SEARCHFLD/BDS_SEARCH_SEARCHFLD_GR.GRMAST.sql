﻿--
--
/
DELETE SEARCH WHERE SEARCHCODE = 'GR.GRMAST';
INSERT INTO SEARCH (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE)
VALUES ('GR.GRMAST','Hop dong bao lanh','Guarranty contract','SELECT * FROM GRMAST MST WHERE 0=0 ','GR.GRMAST','frmGRMAST',null,null,null,50,'N',30,null,'Y','T');
COMMIT;
/