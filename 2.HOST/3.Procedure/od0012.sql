CREATE OR REPLACE PROCEDURE od0012 (
   pv_refcursor   IN OUT   pkg_report.ref_cursor,
   opt            IN       VARCHAR2,
   brid           IN       VARCHAR2,
   f_date         IN       VARCHAR2,
   t_date         IN       VARCHAR2,
   afacctno       IN       VARCHAR2,
   symbol         in       varchar2
)
IS
--
-- Purpose: Briefly explain the functionality of the procedure
--BAO CAO THONG KE VA THEO DOI LENH CHO TUNG KHACH HANG
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- Namnt   21-Nov-06  Created
-- ---------   ------  -------------------------------------------
   v_stroption     VARCHAR2 (5);          -- A: All; B: Branch; S: Sub-branch
   v_strbrid       VARCHAR2 (4);                 -- Used when v_numOption > 0
   v_strafacctno   VARCHAR2 (10);
   v_strsymbol    VARCHAR2 (10);
-- Declare program variables as shown above
BEGIN
   v_stroption := opt;

   IF (v_stroption <> 'A') AND (brid <> 'ALL')
   THEN
      v_strbrid := brid;
   ELSE
      v_strbrid := '%%';
   END IF;

   -- Get report's parameters

   IF (afacctno <> 'ALL')
   THEN
      v_strafacctno := afacctno;
   ELSE
      v_strafacctno := '%%';
   END IF;


   IF (symbol <> 'ALL')
   THEN
      v_strsymbol := symbol;
   ELSE
      v_strsymbol := '%%';
   END IF;

   -- Get report's data
   IF (v_stroption <> 'A') AND (brid <> 'ALL')
   THEN
      OPEN pv_refcursor
       FOR

           SELECT afacctno  afacctno, T.*,NVL(IO.MATCHQTTY,0) MATCHQTTY,NVL(IO.MATCHPRICE,0) MATCHPRICE FROM
                 (SELECT OD.ORDERID,OD.TXDATE,OD.EXECTYPE,SB.SYMBOL,OD.ORDERQTTY,OD.QUOTEPRICE,OD.CIACCTNO,CF.FULLNAME,OD.FEEACR,
                         OD.expdate,AL.cdcontent orstatus,OD.TXTIME
                  FROM (SELECT* FROM ODMAST
                        UNION ALL
                        SELECT * FROM ODMASTHIST )OD, SBSECURITIES SB,AFMAST AF ,CFMAST CF,ALLCODE AL
                  WHERE  OD.CODEID=SB.CODEID
                       AND OD.CIACCTNO=AF.ACCTNO
                       AND AF.CUSTID=CF.CUSTID
                       AND AL.cdtype = 'OD'
                       AND AL.cdname = 'ORSTATUS'
                       AND AL.cdval = od.orstatus
                       AND OD.TXDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY')
                       AND OD.TXDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')
                       and sb.SYMBOL like v_strsymbol
                       AND OD.CIACCTNO LIKE v_strafacctno
                       AND SUBSTR (OD.AFACCTNO, 1, 4) LIKE V_STRBRID
                       )T
                  LEFT JOIN
                  ( SELECT * FROM IOD
                   WHERE DELTD<>'Y'
                  UNION ALL
                   SELECT * FROM IODHIST
                     WHERE DELTD<>'Y'
                  ) IO
                  ON IO.ORGORDERID=T.ORDERID
                  ORDER BY T.TXDATE ,t.SYMBOL
          ;

   ELSE
      OPEN pv_refcursor
       FOR
          SELECT afacctno afacctno, T.*,NVL(IO.MATCHQTTY,0) MATCHQTTY,NVL(IO.MATCHPRICE,0) MATCHPRICE FROM
                 (SELECT OD.ORDERID,OD.TXDATE,OD.EXECTYPE,SB.SYMBOL,OD.ORDERQTTY,OD.QUOTEPRICE,OD.CIACCTNO,CF.FULLNAME,OD.FEEACR,
                        OD.expdate,AL.cdcontent orstatus,OD.TXTIME
                  FROM (SELECT* FROM ODMAST
                        UNION ALL
                        SELECT * FROM ODMASTHIST )OD, SBSECURITIES SB,AFMAST AF ,CFMAST CF,ALLCODE AL
                  WHERE  OD.CODEID=SB.CODEID
                       AND OD.CIACCTNO=AF.ACCTNO
                       AND AF.CUSTID=CF.CUSTID
                       AND AL.cdtype = 'OD'
                       AND AL.cdname = 'ORSTATUS'
                       AND AL.cdval = od.orstatus
                       AND OD.TXDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY')
                       AND OD.TXDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')
                       and sb.SYMBOL like v_strsymbol
                       AND OD.CIACCTNO LIKE v_strafacctno
                                            )T
                  LEFT JOIN
                  ( SELECT * FROM IOD
                      WHERE DELTD<>'Y'
                  UNION ALL
                   SELECT * FROM IODHIST
                      WHERE DELTD<>'Y'
                  ) IO
                  ON IO.ORGORDERID=T.ORDERID
                ORDER BY T.TXDATE ,t.SYMBOL
          ;
 END IF;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- Procedure
/

