﻿--
--
/
DELETE ALLCODE WHERE CDNAME = 'FILENAME';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GW','FILENAME','v_CheckDSSum','prc_CheckDSDetail',4,'Y','File check doi soat chi tiet');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GW','FILENAME','Bank_To_CTCK','V_Bank_To_CTCK',4,'Y','File check doi soat chi tiet');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('GW','FILENAME','CTCK_To_Bank','V_CTCK_To_Bank',4,'Y','File check doi soat chi tiet');
COMMIT;
/
