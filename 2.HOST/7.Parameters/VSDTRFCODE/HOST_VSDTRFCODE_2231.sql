--
--
/
DELETE VSDTRFCODE WHERE TLTXCD = '2231';
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('548.INST.LINK//540.SETR//TRAD.STCO//PHYS','Từ chối lưu ký chứng khoán','548','Y','CFN','2231','SE2231','CUSTODYCD','2241','Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('540.NEWM.CLAS//PEND/2.SETR//TRAD.STCO//PHYS.NAK','Điện lưu ký chứng khoán WFT bị NAK','548','Y','CFN','2231','SE2231','CUSTODYCD','2241','Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('540.NEWM.CLAS//PEND/1.SETR//TRAD.STCO//PHYS.NAK','Điện lưu ký chứng khoán WFT bị NAK','548','Y','CFN','2231','SE2231','CUSTODYCD','2241','Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('540.NEWM.CLAS//NORM/2.SETR//TRAD.STCO//PHYS.NAK','Điện lưu ký chứng khoán bị NAK','548','Y','CFN','2231','SE2231','CUSTODYCD','2241','Y');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('540.NEWM.CLAS//NORM/1.SETR//TRAD.STCO//PHYS.NAK','Điện lưu ký chứng khoán bị NAK','548','Y','CFN','2231','SE2231','CUSTODYCD','2241','Y');
COMMIT;
/
