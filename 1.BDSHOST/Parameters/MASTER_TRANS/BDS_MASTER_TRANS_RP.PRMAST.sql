﻿--
--
/
DELETE FLDVAL WHERE OBJNAME = 'RP.PRMAST';
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('SPOTRATE','RP.PRMAST',1,'V','<=','@100',null,'Lãi suất Spot lớn hơn 0','Spot Irrating should be greater than zero!',null,null,'0');
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('SPOTRATE','RP.PRMAST',0,'V','>=','@0',null,'Lãi suất Spot lớn hơn 0','Spot Irrating should be greater than zero!',null,null,'0');
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('SPOTRATE','RP.PRMAST',0,'V','>>','@0',null,'Lãi suất Spot lớn hơn 0','Spot Irrating should be greater than zero!',null,null,'0');
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('SPOTRATE','RP.PRMAST',0,'V','>=','@0',null,'Lãi suất Spot lớn hơn 0','Spot Irrating should be greater than zero!',null,null,'0');
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('SPOTRATE','RP.PRMAST',0,'V','>>','@0',null,'Lãi suất Spot lớn hơn 0','Spot Irrating should be greater than zero!',null,null,'0');
INSERT INTO FLDVAL (FLDNAME,OBJNAME,ODRNUM,VALTYPE,OPERATOR,VALEXP,VALEXP2,ERRMSG,EN_ERRMSG,TAGFIELD,TAGVALUE,CHKLEV)
VALUES ('SPOTRATE','RP.PRMAST',0,'V','>>','@0',null,'Lãi suất Spot lớn hơn 0','Spot Irrating should be greater than zero!',null,null,'0');
COMMIT;
/
