--
--
/
DELETE VSDTXMAP WHERE OBJNAME = '0043';
INSERT INTO VSDTXMAP (OBJTYPE,OBJNAME,TRFCODE,FLDREFCODE,FLDNOTES,AMTEXP,AFFECTDATE,FLDACCTNO)
VALUES ('T','0043','598.NEWM/AOPN',null,'$30','@0','<$TXDATE>',null);
COMMIT;
/
