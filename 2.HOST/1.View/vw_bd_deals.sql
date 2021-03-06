CREATE OR REPLACE FORCE VIEW VW_BD_DEALS AS
SELECT TO_CHAR(MST.TXDATE,'DD/MM/RRRR') || '.' || MST.TXNUM REFID, MST.TXDATE, MST.TXNUM,
REFMST.AFACCTNO, MST.ORGORDERID ORDERID, MST.SYMBOL, MST.MATCHPRICE PRICE, MST.MATCHQTTY QTTY, MST.CONFIRM_NO,
A0.CDCONTENT BORS_DESC, MST.BORS
FROM IOD MST, ALLCODE A0, ODMAST REFMST
WHERE A0.CDTYPE='OD' AND A0.CDNAME='BORS' AND MST.BORS=A0.CDVAL
AND MST.ORGORDERID=REFMST.ORDERID;

