﻿--
--
/
DELETE PRCHK WHERE TLTXCD = '2646';
INSERT INTO PRCHK (TLTXCD,CHKTYPE,TYPE,TYPEID,BRIDTYPE,PRTYPE,ACCFLDCD,TYPEFLDCD,DORC,AMTEXP,ODRNUM,UDPTYPE,DELTD,LNACCFLDCD,LNTYPEFLDCD)
VALUES ('2646','L','AFTYPE','03','0','P','03',null,'C','34','0','I','N',null,null);
COMMIT;
/