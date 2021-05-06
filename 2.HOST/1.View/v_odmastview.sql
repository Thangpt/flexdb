CREATE OR REPLACE FORCE VIEW V_ODMASTVIEW AS
(
SELECT OD.AFACCTNO ACCTNO,TO_CHAR(OD.ORDERID) ORDERID, TO_CHAR(OD.REFORDERID) REFORDERID,TO_CHAR(A0.CDCONTENT) TRADEPLACE,TO_CHAR(SUBSTR (OD.AFACCTNO, 1, 4) || '.'|| SUBSTR (OD.AFACCTNO, 5, 6)) AFACCTNO,
TO_CHAR(SUBSTR (CF.CUSTODYCD, 1, 3) || '.'|| SUBSTR (CF.CUSTODYCD, 4, 1)|| '.' || SUBSTR (CF.CUSTODYCD, 5, 6)) CUSTODYCD,
TO_CHAR(SE.SYMBOL) SYMBOL, TO_CHAR(A1.CDCONTENT) ORSTATUS,TO_CHAR(A10.CDCONTENT) EDSTATUS, OT.TYPENAME ACTYPE,TO_CHAR(A2.CDCONTENT) VIA,
TO_CHAR(OD.TXTIME) MAKETIME,TO_CHAR(NVL(OD.SENDTIME,'____')) SENDTIME,TO_CHAR(A3.CDCONTENT) TIMETYPE, OD.TXNUM, OD.TXDATE, OD.EXPDATE,
OD.BRATIO, TO_CHAR(A4.CDCONTENT) EXECTYPE, OD.NORK, TO_CHAR(A5.CDCONTENT) MATCHTYPE,OD.CLEARDAY, TO_CHAR(A6.CDCONTENT) CLEARCD, TO_CHAR(A7.CDCONTENT) PRICETYPE,OD.QUOTEPRICE, OD.STOPPRICE, OD.LIMITPRICE, OD.ORDERQTTY,
OD.REMAINQTTY, OD.EXECQTTY, OD.STANDQTTY, OD.CANCELQTTY, OD.ADJUSTQTTY,OD.REJECTQTTY, TO_CHAR(A8.CDCONTENT) REJECTCD, OD.EXPRICE, OD.EXQTTY,
TO_CHAR(A9.CDCONTENT) DELTD ,OD.FOACCTNO
FROM AFMAST AF,CFMAST CF,SBSECURITIES SE,ODTYPE OT,ALLCODE A0,ALLCODE A1,ALLCODE A2,
ALLCODE A3,ALLCODE A4,ALLCODE A5,ALLCODE A6,ALLCODE A7,ALLCODE A8,ALLCODE A9,ALLCODE A10,
(SELECT OD.*, OOD.TXTIME SENDTIME FROM
(SELECT OD.* FROM ODMAST OD WHERE OD.TXDATE =TO_DATE ((SELECT VARVALUE FROM SYSVAR WHERE VARNAME = 'CURRDATE' AND GRNAME = 'SYSTEM'),'DD/MM/YYYY')) OD,(
SELECT TXTIME ,ORGORDERID FROM OOD) OOD WHERE OD.ORDERID=OOD.ORGORDERID(+)) OD
WHERE OD.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID AND OD.CODEID = SE.CODEID AND OD.ACTYPE = OT.ACTYPE
AND A10.CDTYPE = 'OD' AND A10.CDNAME = 'EDSTATUS' AND A10.CDVAL = OD.EDSTATUS
AND A0.CDTYPE = 'OD' AND A0.CDNAME = 'TRADEPLACE' AND A0.CDVAL = SE.TRADEPLACE AND A2.CDTYPE = 'OD' AND A2.CDNAME = 'VIA'
AND A2.CDVAL = OD.VIA AND A3.CDTYPE = 'OD' AND A3.CDNAME = 'TIMETYPE' AND A3.CDVAL = OD.TIMETYPE AND A4.CDTYPE = 'OD'
AND A4.CDNAME = 'EXECTYPE' AND A4.CDVAL = OD.EXECTYPE AND A5.CDTYPE = 'OD' AND A5.CDNAME = 'MATCHTYPE' AND A5.CDVAL = OD.MATCHTYPE
AND A6.CDTYPE = 'OD' AND A6.CDNAME = 'CLEARCD' AND A6.CDVAL = OD.CLEARCD AND A7.CDTYPE = 'OD' AND A7.CDNAME = 'PRICETYPE'
AND A7.CDVAL = OD.PRICETYPE AND A8.CDTYPE = 'OD' AND A8.CDNAME = 'REJECTCD' AND A8.CDVAL = OD.REJECTCD AND A9.CDTYPE = 'SY'
AND A9.CDNAME = 'YESNO' AND A9.CDVAL = OD.DELTD
AND A1.CDNAME = 'ORSTATUS'
AND OD.ORSTATUS = A1.CDVAL
);

