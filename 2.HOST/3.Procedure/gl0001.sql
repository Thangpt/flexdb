CREATE OR REPLACE PROCEDURE GL0001 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   TYPEBA         IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   21-NOV-06  CREATED
-- ---------   ------  -------------------------------------------
  V_STROPTION            VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
  V_STRBRID              VARCHAR2 (4);
  V_DATEENBALANCE        DATE;
  V_EOY                  VARCHAR2 (1);
  V_EOM                  VARCHAR2 (1);
  V_DMIN                 DATE;
  V_DMAX                 DATE;
  v_PERIOD               VARCHAR2 (4);
  V_PCUR                PKG_REPORT.REF_CURSOR;
  V_STRTYPEBA            VARCHAR2 (20);
  -- USED WHEN V_NUMOPTION > 0
  -- V_STRLEVELG        VARCHAR2 (10);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;
   
   IF (TYPEBA = '001') THEN
        V_STRTYPEBA := '0';
   ELSE
        V_STRTYPEBA := '123456789';
   END IF;



-- NGAY GAN NGAY F_DATE NHAT CO DU LIEU
OPEN V_PCUR
FOR
SELECT TO_DATE(MAX(TXDATE),'DD/MM/YYYY')
FROM GLHIST
WHERE TXDATE<  TO_DATE ( F_DATE ,'DD/MM/YYYY')
AND INSTR(V_STRTYPEBA,SUBSTR(acctno,7,1)) >0;

LOOP
FETCH V_PCUR
INTO V_DMAX ;
EXIT WHEN V_PCUR%NOTFOUND;
END LOOP;
CLOSE V_PCUR;


--XAC DINH LOAI NGAY

 v_PERIOD :='EOD';

OPEN PV_REFCURSOR
       FOR
       
 SELECT BE_BALANCE.GLBANK,BE_BALANCE.GLNAME, ROUND(NVL(BE_BALANCE.BALANCE,0)) BE_BALANCE,
    ROUND(NVL(BALANCE.AMTD,0)) AMTD ,ROUND(NVL(BALANCE.AMTC,0)) AMTC,ROUND(NVL(LK.AMTD,0)) LKAMTD,
    ROUND(NVL(LK.AMTC,0)) LKAMTC,(ROUND(NVL(BE_BALANCE.BALANCE,0))-ROUND(NVL(BALANCE.AMTD,0))+ROUND(NVL(BALANCE.AMTC,0))) EN_BALANCE
     FROM  ( SELECT GLBANK, GLNAME,SUM(BALANCE) BALANCE 
               FROM( SELECT GB.GLBANK GLBANK,  GB.GLNAME GLNAME, nvl(GH.BALANCE,0) BALANCE
               FROM GLBANK GB
               left join (select *from GLHIST GH where INSTR(V_STRTYPEBA,SUBSTR(GH.acctno,7,1)) >0
               and SUBSTR(GH.acctno,1,4) LIKE V_STRBRID  and GH.TXDATE=  ( SELECT MAX(TXDATE)
                    FROM GLHIST
                    WHERE TXDATE<  TO_DATE ( F_DATE  ,'DD/MM/YYYY') )
                     )GH
               on GB.GLBANK = SUBSTR(GH.ACCTNO, 7, 5)
       )  GROUP BY GLBANK, GLNAME) BE_BALANCE
   LEFT JOIN

 ( SELECT SUBSTR(A.ACCTNO, 7,5) GLBANK,SUM (A.AMTD) AMTD,SUM(A.AMTC) AMTC
                               FROM
                                (SELECT  ACCTNO , (CASE WHEN DORC = 'D' THEN  AMT ELSE 0 END) AMTD,
                                       (CASE WHEN DORC ='C' THEN  AMT ELSE 0 END)AMTC
                                FROM GLTRAN GT ,TLLOG TL
                                WHERE TL.txnum =GT.txnum
                                      AND TL.deltd <>'Y'
                                      AND TL.busdate >= TO_DATE (F_DATE, 'DD/MM/YYYY')
                                      AND TL.busdate <= TO_DATE (T_DATE, 'DD/MM/YYYY')
                                      AND INSTR(V_STRTYPEBA,SUBSTR(GT.acctno,7,1)) >0
                                      AND SUBSTR(GT.acctno,1,4) LIKE V_STRBRID
                                 UNION ALL
                                SELECT  ACCTNO , (CASE WHEN DORC = 'D' THEN  AMT ELSE 0 END) AMTD,
                                       (CASE WHEN DORC ='C' THEN  AMT ELSE 0 END)AMTC
                                FROM GLTRANA GT ,TLLOGALL TL
                                WHERE TL.txnum =GT.txnum
                                     AND GT.txdate =TL.txdate
                                     AND TL.deltd <>'Y'
                                     AND TL.busdate >= TO_DATE (F_DATE, 'DD/MM/YYYY')
                                     AND TL.busdate <= TO_DATE (T_DATE, 'DD/MM/YYYY')
                                     AND SUBSTR(GT.acctno,1,4) LIKE V_STRBRID
                                     AND INSTR(V_STRTYPEBA,SUBSTR(GT.acctno,7,1)) >0
                            ) A
                            GROUP BY SUBSTR(A.ACCTNO, 7,5)
                            ) BALANCE
                    ON   BALANCE.GLBANK= BE_BALANCE.GLBANK
                      LEFT JOIN

                        (SELECT SUBSTR(A.ACCTNO, 7,5) GLBANK,SUM (A.AMTD) AMTD,SUM(A.AMTC) AMTC
                               FROM
                                (SELECT  ACCTNO , (CASE WHEN DORC = 'D' THEN  AMT ELSE 0 END) AMTD,
                                       (CASE WHEN DORC ='C' THEN  AMT ELSE 0 END)AMTC
                                FROM GLTRAN GT ,TLLOG TL
                                WHERE TL.txnum =GT.txnum
                                      AND TL.deltd <>'Y'
                                      AND TO_CHAR(TL.busdate,'YYYY')  = TO_CHAR(TO_DATE(F_DATE ,'DD/MM/YYYY'),'YYYY' )
                                      AND INSTR(V_STRTYPEBA,SUBSTR(GT.acctno,7,1)) >0
                                      AND SUBSTR(GT.acctno,1,4) LIKE V_STRBRID
                                 UNION ALL
                                SELECT  ACCTNO , (CASE WHEN DORC = 'D' THEN  AMT ELSE 0 END) AMTD,
                                       (CASE WHEN DORC ='C' THEN  AMT ELSE 0 END)AMTC
                                FROM GLTRANA GT ,TLLOGALL TL
                                WHERE TL.txnum =GT.txnum
                                     AND GT.txdate =TL.txdate
                                     AND TL.deltd <>'Y'
                                     AND TO_CHAR(TL.busdate,'YYYY')  = TO_CHAR(TO_DATE(F_DATE ,'DD/MM/YYYY'),'YYYY' )
                                     AND SUBSTR(GT.acctno,1,4) LIKE V_STRBRID
                                     AND INSTR(V_STRTYPEBA,SUBSTR(GT.acctno,7,1)) >0
                            ) A
                            GROUP BY SUBSTR(A.ACCTNO, 7,5)
                                                )LK
                    ON  BE_BALANCE.GLBANK=LK.GLBANK
                    
                           WHERE (BE_BALANCE.BALANCE <>0 OR BALANCE.AMTD<>0 OR BALANCE.AMTC<>0)
                   ORDER BY BE_BALANCE.GLBANK;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

