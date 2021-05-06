CREATE OR REPLACE PROCEDURE PR_GETORDERINFO(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                                            F_CUSTODYCD  IN VARCHAR2,
                                            F_AFACCTNO   IN VARCHAR2,
                                            F_FROMDATE   IN VARCHAR2,
                                            F_TODATE     IN VARCHAR2,
                                            F_SYMBOL     IN VARCHAR2,
                                            F_EXECTYPE   IN VARCHAR2,
                                            F_BUSDATE    IN VARCHAR2) IS
  V_CUSTODYCD VARCHAR2(50);
  V_AFACCTNO  VARCHAR2(30);
  V_FROMDATE  DATE;
  V_TODATE    DATE;
  V_SYMBOL    VARCHAR2(20);
  V_EXECTYPE  VARCHAR2(10);
  V_CURRDATE  DATE;
  V_BUSDATE   DATE;
BEGIN
  V_CUSTODYCD := F_CUSTODYCD;
  IF F_AFACCTNO <> 'ALL' THEN
    V_AFACCTNO := F_AFACCTNO;
  ELSE
    V_AFACCTNO := '%';
  END IF;

  IF F_SYMBOL <> 'ALL' THEN
    V_SYMBOL := F_SYMBOL;
  ELSE
    V_SYMBOL := '%';
  END IF;

  IF F_EXECTYPE <> 'ALL' THEN
    V_EXECTYPE := F_EXECTYPE;
  ELSE
    V_EXECTYPE := '%';
  END IF;

  IF LENGTH(F_BUSDATE) > 0 THEN
    V_BUSDATE := TO_DATE(F_BUSDATE, 'DD/MM/YYYY');
  END IF;

  IF LENGTH(F_FROMDATE) > 0 THEN
    V_FROMDATE := TO_DATE(F_FROMDATE, 'DD/MM/YYYY');
  END IF;

  IF LENGTH(F_TODATE) > 0 THEN
    V_TODATE := TO_DATE(F_TODATE, 'DD/MM/YYYY');
  END IF;

  --select to_date(varvalue,'dd/MM/RRRR') into v_CURRDATE  from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';

  OPEN PV_REFCURSOR FOR

    SELECT OD.ORDERID ORDERID,
           OD.AFACCTNO || ' - ' || AFT.TYPENAME AFACCTNO,
           OD.TXDATE,
           CASE
             WHEN IOD.BORS = 'S' THEN
              'Bán'
             ELSE
              'Mua'
           END EXECTYPE,
           SB.SYMBOL,
           SUM(IOD.MATCHQTTY) EXECQTTY,
           SUM(IOD.MATCHPRICE * IOD.MATCHQTTY) EXECMATCH,
          round( SUM(IOD.MATCHPRICE * IOD.MATCHQTTY) / SUM(IOD.MATCHQTTY)) EXECAVGPRICE,
           --phi giao dich
           SUM(CASE
                 WHEN IOD.MATCHPRICE * IOD.MATCHQTTY > 0 AND OD.FEEACR = 0 THEN
                  ROUND(IOD.MATCHQTTY * IOD.MATCHPRICE * ODT.DEFFEERATE / 100, 2)
                 ELSE
                  (CASE
                    WHEN (IOD.MATCHPRICE * IOD.MATCHQTTY * OD.FEEACR) = 0 THEN
                     0
                    ELSE
                     (CASE
                       WHEN IOD.TXDATE = V_BUSDATE THEN
                        ROUND(OD.FEEACR * IOD.MATCHQTTY * IOD.MATCHPRICE / OD.EXECAMT,
                              2)
                       ELSE
                        ROUND(IOD.MATCHQTTY * IOD.MATCHPRICE / OD.EXECAMT * OD.FEEACR,
                              2)
                     END)
                  END)
               END) FEEORDER,
           --- THUE TNCN
           SUM(CASE
                 WHEN OD.EXECTYPE IN ('NS', 'SS', 'MS') AND AFT.VAT = 'Y' THEN
                  (SELECT TO_NUMBER(VARVALUE)
                     FROM SYSVAR
                    WHERE VARNAME = 'ADVSELLDUTY'
                      AND GRNAME = 'SYSTEM') * NVL(IOD.MATCHQTTY, 0) *
                  NVL(IOD.MATCHPRICE, 0) / 100
                 ELSE
                  0
               END) VATORDER

      FROM VW_IOD_ALL    IOD,
           ODTYPE        ODT,
           VW_ODMAST_ALL OD,
           AFMAST        AF,
           AFTYPE        AFT,
           CFMAST        CF,
           SBSECURITIES  SB
     WHERE IOD.ORGORDERID = OD.ORDERID
       AND OD.ACTYPE = ODT.ACTYPE
       AND CF.CUSTID = AF.CUSTID
       AND SB.CODEID = OD.CODEID
       AND AF.ACCTNO = OD.AFACCTNO
       AND AFT.ACTYPE = AF.ACTYPE
       AND IOD.MATCHQTTY > 0
       AND OD.TXDATE BETWEEN V_FROMDATE AND V_TODATE
       AND OD.DELTD <> 'Y'
       AND IOD.DELTD <> 'Y'
       AND OD.AFACCTNO LIKE V_AFACCTNO
       AND CF.CUSTODYCD = V_CUSTODYCD
       AND SB.SYMBOL LIKE V_SYMBOL
       AND IOD.BORS LIKE V_EXECTYPE
     GROUP BY OD.ORDERID,
              OD.TXDATE,
              IOD.BORS,
              SB.SYMBOL,
              OD.AFACCTNO,
              AFT.TYPENAME
    HAVING SUM(IOD.MATCHPRICE * IOD.MATCHQTTY) > 0
     ORDER BY OD.TXDATE, SB.SYMBOL;

EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END;
/

