--
--
/
DELETE SYSVAR WHERE VARNAME = 'FEEVSDUC_CP';
INSERT INTO SYSVAR (GRNAME,VARNAME,VARVALUE,VARDESC,EN_VARDESC,EDITALLOW)
VALUES ('DEFINED','FEEVSDUC_CP','0.02','TI LE PHI TRA VSD CHO CP UPCOM','VSD SHARES PAID FEE RATE (UPCOM)','N');
COMMIT;
/
