﻿--
--
/
DELETE VSDTXMAP WHERE OBJNAME = '8815';
INSERT INTO VSDTXMAP (OBJTYPE,OBJNAME,TRFCODE,FLDREFCODE,FLDNOTES,AMTEXP,AFFECTDATE,FLDACCTNO)
VALUES ('T','8815','542.NEWM.CLAS//PEND/1.SETR//TRAD.STCO//DLWM','$05','$30','$10','<$TXDATE>','$02');
INSERT INTO VSDTXMAP (OBJTYPE,OBJNAME,TRFCODE,FLDREFCODE,FLDNOTES,AMTEXP,AFFECTDATE,FLDACCTNO)
VALUES ('T','8815','542.NEWM.CLAS//NORM/1.SETR//TRAD.STCO//DLWM','$05','$30','$10','<$TXDATE>','$02');
COMMIT;
/
