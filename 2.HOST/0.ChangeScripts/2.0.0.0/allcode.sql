DELETE allcode WHERE CDTYPE='SE' AND CDNAME='QTTYTYPE' AND CDVAL='008';
INSERT INTO ALLCODE (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
VALUES ('SE', 'QTTYTYPE', '008', 'Phong tỏa ký quỹ phái sinh', 8, 'Y', 'Phong tỏa ký quỹ phái sinh');
COMMIT;

DELETE allcode WHERE CDTYPE='SY' AND CDNAME='TRFCODE' AND CDVAL IN ('FDSWITHDRAW','FDSDEPOSIT');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TRFCODE','FDSWITHDRAW','Bản kê nộp tiền vào tài khoản phái sinh',17,'N','Depository center: Transfer money to derivertive system');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SY','TRFCODE','FDSDEPOSIT','Bản kê rút tiền từ tài khoản phái sinh',17,'N','Depository center: Receive money from derivertive system');
COMMIT;