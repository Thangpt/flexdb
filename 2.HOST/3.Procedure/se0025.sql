CREATE OR REPLACE PROCEDURE se0025(
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   F_DATE           IN       VARCHAR2,
   T_DATE           IN       VARCHAR2,
   CUSTODYCD        IN       VARCHAR2,
   SYMBOL           IN       VARCHAR2,
   TRADEPLACE       IN       VARCHAR2

        )
   IS
--
-- TO MODIFY THIS TEMPLATE, EDIT FILE PROC.TXT IN TEMPLATE
-- DIRECTORY OF SQL NAVIGATOR
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- DANH SACH KHACH HANG CO GIAO DICH CHUNG KHOAN
-- MODIFICATION HISTORY
-- PERSON: THANH.TRAN
-- DATE  : 24/10/2007
-- COMMENTS
-- ---------   ------  -------------------------------------------

    V_STROPTION         VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID           VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
    V_STRTLTXCD         VARCHAR (100);
    V_STRSYMBOL         VARCHAR (20);
    V_STRTRADEPLACE     VARCHAR2 (3);
    V_STRAFACCTNO       VARCHAR (20);
     V_CUSTODYCD       VARCHAR (20);

   -- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
    -- GET REPORT'S PARAMETERS
   V_STROPTION := OPT;
    V_CUSTODYCD := CUSTODYCD;
   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   IF (TRADEPLACE <> 'ALL')
   THEN
      V_STRTRADEPLACE := TRADEPLACE;
   ELSE
      V_STRTRADEPLACE := '%%';
   END IF;



   IF  (SYMBOL <> 'ALL')
   THEN
      V_STRSYMBOL := replace(SYMBOL,' ','_');
   ELSE
      V_STRSYMBOL := '%%';
   END IF;

   --V_STRTLTXCD := TLTXCD;


   --END OF GET REPORT'S PARAMETERS

   --IF V_STRTLTXCD <> 'ALL' THEN

 OPEN PV_REFCURSOR
    FOR
SELECT  TL.BUSDATE TXDATE,A4.CDCONTENT TRADEPLACE ,SEMAST.ACTYPE,
SEMAST.ACCTNO SEACCCTNO
, SYM.SYMBOL, SYM.PARVALUE, SEMAST.CODEID,  AFACCTNO, CFMAST.CUSTODYCD,
A1.CDCONTENT STATUS, SEMAST.PSTATUS, A2.CDCONTENT IRTIED, A3.CDCONTENT ICCFTIED, IRCD,
COSTPRICE,SEDEPOSIT.DEPOSITQTTY DEPOSIT,SEDEPOSIT.DEPOSITPRICE DEPOSITPRICE,SEDEPOSIT.AUTOID AUTOID,
SEDEPOSIT.DESCRIPTION DESCRIPTION,TL.BUSDATE PDATE,SEMAST.CUSTID CUSTID,
COSTDT,CFMAST.FULLNAME CUSTNAME,CFMAST.ADDRESS  ADDRESS, A5.CDCONTENT IDTYPE, CFMAST.IDDATE IDDATE,
SEMAST.TRADE TRADE,cfmast.idcode,issuers.fullname ISSNAME,cfmast.idcode,SEMAST.deposit DEPO
FROM SEMAST,CFMAST,SBSECURITIES SYM,issuers ,
(SELECT * FROM SEDEPOSIT WHERE STATUS='D' AND DELTD <> 'Y') SEDEPOSIT,
 ALLCODE A1, ALLCODE A2, ALLCODE A3,ALLCODE A4,ALLCODE A5,
(SELECT * FROM TLLOG  WHERE TXSTATUS = '1' AND DELTD = 'N' AND TLTXCD = '2240' UNION ALL SELECT * FROM TLLOGALL WHERE TXSTATUS = '1' AND DELTD = 'N' AND TLTXCD = '2240') tl
WHERE SEMAST.DEPOSIT > 0 AND A1.CDTYPE = 'SE'
      AND A1.CDNAME = 'STATUS' AND A1.CDVAL = SEMAST.STATUS
      AND A2.CDTYPE = 'SY' AND A2.CDNAME = 'YESNO'
      AND A2.CDVAL = IRTIED
      AND SYM.CODEID = SEMAST.CODEID
      AND A3.CDTYPE = 'SY' AND A3.CDNAME = 'YESNO'
      AND A3.CDVAL = SEMAST.ICCFTIED
      AND A4.CDTYPE = 'SE' AND A4.CDNAME = 'TRADEPLACE'
      AND A5.CDTYPE = 'CF' AND A5.CDNAME = 'IDTYPE'
      AND CFMAST.CUSTODYCD LIKE V_CUSTODYCD
      AND A4.CDVAL = SYM.TRADEPLACE
      AND A5.CDVAL = CFMAST.IDTYPE
      AND CFMAST.CUSTID = SEMAST.CUSTID
      AND SEDEPOSIT.ACCTNO=SEMAST.ACCTNO
      AND SEDEPOSIT.TXNUM = TL.TXNUM
      AND SEDEPOSIT.TXDATE = TL.TXDATE
      AND issuers.issuerid = sym.issuerid
      and SYM.SYMBOL like V_STRSYMBOL
      and SYM.TRADEPLACE like  V_STRTRADEPLACE
      and TL.TXDATE >= to_date( F_DATE,'MM/DD/RRRR')
      and TL.TXDATE <= to_date( T_DATE,'MM/DD/RRRR')
      ;

EXCEPTION
    WHEN OTHERS
   THEN
      RETURN;
END; -- PROCEDURE
/

