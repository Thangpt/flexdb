--
--
/
DELETE GRMASTER WHERE OBJNAME = 'CF.AFTYPETEST';
INSERT INTO GRMASTER (MODCODE,OBJNAME,ODRNUM,GRNAME,GRTYPE,GRBUTTONS,GRCAPTION,EN_GRCAPTION,CAREBYCHK,SEARCHCODE)
VALUES ('CF','CF.AFTYPETEST','1','EXTREFVAL','G','EEEENNNN','TT mở rộng tesst','External','N','BSIDTYPE');
INSERT INTO GRMASTER (MODCODE,OBJNAME,ODRNUM,GRNAME,GRTYPE,GRBUTTONS,GRCAPTION,EN_GRCAPTION,CAREBYCHK,SEARCHCODE)
VALUES ('CF','CF.AFTYPETEST','0','MAIN','N','NNNNNNNN','TT chung test','Common','N',null);
COMMIT;
/
