--
--
/
DELETE VSDTRFCODE WHERE TLTXCD = '2245';
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('544.NEWM.LINK//598.SETR//TWAC..OK','Nhận chuyển khoản toàn bộ CK không tất toán tài khoản','544','Y','INF','2245',null,null,'2245','N');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('544.NEWM.LINK//598.SETR//TBAC..OK','Nhận chuyển khoản CK tất toán tài khoản','544','Y','INF','2245',null,null,'2245','N');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('544.NEWM.LINK//542.SETR//TRAD.STCO//DLWM.OK','Nhận chuyển khoản CK lô lẻ đến','544','Y','INF','2245',null,null,'2245','N');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('544.NEWM.LINK//542.SETR//OWNI.STCO//DLWM.OK','Nhận chuyển khoản CK cùng công ty','544','Y','INF','2245',null,null,'2245','N');
INSERT INTO VSDTRFCODE (TRFCODE,DESCRIPTION,VSDMT,STATUS,TYPE,TLTXCD,SEARCHCODE,FILTERNAME,REQTLTXCD,AUTOCONF)
VALUES ('544.NEWM.LINK//542.SETR//OWNE.STCO//DLWM.OK','Nhận chuyển khoản CK từ CTCK khác','544','Y','INF','2245',null,null,'2245','N');
COMMIT;
/
