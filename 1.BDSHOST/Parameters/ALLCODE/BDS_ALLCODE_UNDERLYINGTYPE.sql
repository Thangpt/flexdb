--
--
/
DELETE ALLCODE WHERE CDNAME = 'UNDERLYINGTYPE';
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','UNDERLYINGTYPE','E','Chứng chỉ quỹ',2,'Y','Exchange Traded Fund (ETF)');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','UNDERLYINGTYPE','I','Chỉ số',1,'Y','Index');
INSERT INTO ALLCODE (CDTYPE,CDNAME,CDVAL,CDCONTENT,LSTODR,CDUSER,EN_CDCONTENT)
VALUES ('SA','UNDERLYINGTYPE','S','Cổ phiếu',0,'Y','Securities');
COMMIT;
/
