--
--
/
DELETE VSDTXMAP WHERE OBJNAME = '0059';
INSERT INTO VSDTXMAP (OBJTYPE,OBJNAME,TRFCODE,FLDREFCODE,FLDNOTES,AMTEXP,AFFECTDATE,FLDACCTNO)
VALUES ('T','0059','598.NEWM/ACLS',null,'$30','@0','<$TXDATE>',null);
COMMIT;
/
