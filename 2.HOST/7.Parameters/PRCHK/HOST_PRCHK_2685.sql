﻿--
--
/
DELETE PRCHK WHERE TLTXCD = '2685';
INSERT INTO PRCHK (TLTXCD,CHKTYPE,TYPE,TYPEID,BRIDTYPE,PRTYPE,ACCFLDCD,TYPEFLDCD,DORC,AMTEXP,ODRNUM,UDPTYPE,DELTD,LNACCFLDCD,LNTYPEFLDCD)
VALUES ('2685','L','AFTYPE','03','0','R','05',null,'C','12++22++13++23--60--61--62--63','0','I','N',null,null);
COMMIT;
/
