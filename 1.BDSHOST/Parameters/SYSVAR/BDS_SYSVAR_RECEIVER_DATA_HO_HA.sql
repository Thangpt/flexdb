--
--
/
DELETE SYSVAR WHERE VARNAME = 'RECEIVER_DATA_HO_HA';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('SYSTEM','RECEIVER_DATA_HO_HA','HA','ALL:HO:HA','ALL: ca 2 san, HO chi HoStc, Ha chi HaStc','N');
COMMIT;
/
