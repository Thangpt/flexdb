﻿--
--
/
DELETE VSDTXMAP WHERE OBJNAME = '2241';
INSERT INTO VSDTXMAP (OBJTYPE,OBJNAME,TRFCODE,FLDREFCODE,FLDNOTES,AMTEXP,AFFECTDATE,FLDACCTNO)
VALUES ('T','2241','540.NEWM.CLAS//PEND/2','$05','$30','$04','<$TXDATE>','$02');
INSERT INTO VSDTXMAP (OBJTYPE,OBJNAME,TRFCODE,FLDREFCODE,FLDNOTES,AMTEXP,AFFECTDATE,FLDACCTNO)
VALUES ('T','2241','540.NEWM.CLAS//PEND/1','$05','$30','$06','<$TXDATE>','$02');
INSERT INTO VSDTXMAP (OBJTYPE,OBJNAME,TRFCODE,FLDREFCODE,FLDNOTES,AMTEXP,AFFECTDATE,FLDACCTNO)
VALUES ('T','2241','540.NEWM.CLAS//NORM/2','$05','$30','$04','<$TXDATE>','$02');
INSERT INTO VSDTXMAP (OBJTYPE,OBJNAME,TRFCODE,FLDREFCODE,FLDNOTES,AMTEXP,AFFECTDATE,FLDACCTNO)
VALUES ('T','2241','540.NEWM.CLAS//NORM/1','$05','$30','$06','<$TXDATE>','$02');
COMMIT;
/
