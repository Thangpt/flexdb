CREATE OR REPLACE PROCEDURE ci0002 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTODYCD      IN       VARCHAR2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO TIEN LAI CUA NGUOI DAU TU
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   20-DEC-06  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION     VARCHAR2  (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID       VARCHAR2  (4);                   -- USED WHEN V_NUMOPTION > 0
   V_STRCUSTODYCD   VARCHAR2 (20);

BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS
  IF (CUSTODYCD <> 'ALL' or CUSTODYCD <> '')
   THEN
      V_STRCUSTODYCD :=  CUSTODYCD;
   ELSE
      V_STRCUSTODYCD := '%%';
   END IF;

   -- END OF GETTING REPORT'S PARAMETERS


   -- GET REPORT'S DATA
   IF (V_STROPTION <> 'A') AND (V_STRBRID <> 'ALL')
   THEN
   OPEN PV_REFCURSOR
       FOR
            SELECT TMP.custodycd, TMP.acctno,TMP.FULLNAME, (ROUND(NVL(CRINTAMT.NAMT,0)) + tmp.crintacr) INTAMT
            from
            (SELECT CF.fullname , cf.custodycd ,AF.acctno, cim.crintacr
                FROM AFMAST AF, CFMAST CF, CIMAST CIM
                WHERE AF.CUSTID =CF.custid
                AND af.acctno = cim.acctno
                AND  cf.custodycd like V_STRCUSTODYCD
                and  substr(AF.acctno,1,4)= V_STRBRID
            ) TMP
            LEFT JOIN
            (
                SELECT SUM(AMT.NAMT) NAMT, AMT.AFACCTNO  FROM
                (
                    SELECT CI.NAMT,CI.ACCTNO AFACCTNO
                    FROM
                            (SELECT * FROM TLLOG
                             WHERE BUSDATE >= TO_DATE(F_DATE ,'DD/MM/YYYY')
                             AND  BUSDATE <= TO_DATE(T_DATE ,'DD/MM/YYYY')
                             AND TLTXCD LIKE '1162'
                             AND DELTD<>'Y') TL, CITRAN CI , APPTX APP
                     WHERE  TL.TXDATE=CI.TXDATE
                             AND TL.TXNUM =CI.TXNUM
                             AND CI.TXCD = APP.TXCD
                             AND APP.APPTYPE ='CI'
                             AND APP.FIELD='BALANCE'
                     UNION ALL
                     SELECT CI.NAMT,CI.ACCTNO AFACCTNO
                     FROM
                            (SELECT * FROM TLLOGALL
                             WHERE BUSDATE >= TO_DATE(F_DATE ,'DD/MM/YYYY')
                             AND  BUSDATE <= TO_DATE(T_DATE ,'DD/MM/YYYY')
                             AND TLTXCD LIKE '1162'
                             AND DELTD<>'Y')TL,CITRANA  CI ,APPTX APP
                     WHERE  TL.TXDATE=CI.TXDATE
                             AND TL.TXNUM =CI.TXNUM
                             AND CI.TXCD = APP.TXCD
                             AND APP.APPTYPE ='CI'
                             AND APP.FIELD='BALANCE'
                )AMT
                GROUP BY AMT.AFACCTNO
                having SUM(AMT.NAMT) > 0
                )CRINTAMT
             ON TMP.ACCTNO = CRINTAMT.AFACCTNO
             --where ROUND(NVL(CRINTAMT.NAMT,0)) > 0
             ORDER BY TMP.CUSTODYCD,TMP.ACCTNO;
   ELSE
      OPEN PV_REFCURSOR
       FOR
       SELECT cf.custodycd, CF.acctno,CF.FULLNAME, (ROUND(NVL(CRINTAMT.NAMT,0)) + cf.crintacr) INTAMT
       from
        (SELECT cf.custodycd, CF.fullname ,AF.acctno, cim.crintacr
            FROM AFMAST AF, CFMAST CF, cimast cim
            WHERE AF.CUSTID =CF.custid
            AND af.acctno = cim.acctno
            AND  cf.custodycd like V_STRCUSTODYCD
        ) CF
        LEFT JOIN
            (SELECT SUM(AMT.NAMT) NAMT, AMT.AFACCTNO
             FROM
                (SELECT CI.NAMT,CI.ACCTNO AFACCTNO
                  FROM
                    (SELECT * FROM TLLOG
                     WHERE BUSDATE >= TO_DATE(F_DATE ,'DD/MM/YYYY')
                             AND  BUSDATE <= TO_DATE(T_DATE ,'DD/MM/YYYY')
                             AND TLTXCD LIKE '1162'
                             AND DELTD<>'Y')TL,CITRAN CI ,APPTX APP
                 WHERE  TL.TXDATE=CI.TXDATE
                     AND TL.TXNUM =CI.TXNUM
                     AND CI.TXCD = APP.TXCD
                     AND APP.APPTYPE ='CI'
                     AND APP.FIELD='BALANCE'
                 UNION ALL
                 SELECT CI.NAMT,CI.ACCTNO AFACCTNO
                 FROM
                    (SELECT * FROM TLLOGALL
                     WHERE BUSDATE >= TO_DATE(F_DATE ,'DD/MM/YYYY')
                             AND  BUSDATE <= TO_DATE(T_DATE ,'DD/MM/YYYY')
                             AND TLTXCD LIKE '1162'
                             AND DELTD<>'Y'
                     )TL,CITRANA  CI ,APPTX APP
                 WHERE  TL.TXDATE=CI.TXDATE
                     AND TL.TXNUM =CI.TXNUM
                     AND CI.TXCD = APP.TXCD
                     AND APP.APPTYPE ='CI'
                     AND APP.FIELD='BALANCE'
                ) AMT

             GROUP BY AMT.AFACCTNO
             having SUM(AMT.NAMT) > 0
             ) CRINTAMT
          ON CF.ACCTNO = CRINTAMT.afACCTNO
          --where ROUND(NVL(CRINTAMT.NAMT,0)) > 0
          ORDER BY cf.custodycd, CF.ACCTNO;

 END IF;                                                          -- PROCEDURE
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

