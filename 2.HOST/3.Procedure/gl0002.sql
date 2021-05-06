CREATE OR REPLACE PROCEDURE gl0002 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2
)
IS
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BANG CAN DOI KE TOAN
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- THANH.TRAN   3-1-07 CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION   VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID     VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   V_DATE         DATE; --NGAY HIEN TAI
   V_MINDATE      DATE; --NGAY NHO NHAT CO DU LIEU KE TOAN
   V_FNDATE       DATE; --NGAY GAN  F_DATE NHAT CO DU LIEU
   V_TNDATE       DATE; --NGAY GAN  T_DATE NHAT CO DU LIEU
   V_BEDATE       DATE; --NGAY DAU KY
   V_ENDATE       DATE; --NGAY CUOI KY

   A             PKG_REPORT.REF_CURSOR;
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;

 IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
END IF;
-- GET DATE BEGIN  AND DATE END
OPEN A
FOR
SELECT V_DATE.V_DATE, MIN_DATE.TXDATE,FNDATE.TXDATE,TNDATE.TXDATE
FROM  (SELECT TO_DATE (VARVALUE, 'DD/MM/YYYY') V_DATE
       FROM SYSVAR
       WHERE VARNAME = 'CURRDATE') V_DATE ,
      (SELECT MIN(TXDATE) TXDATE FROM GLHIST)MIN_DATE,
      (SELECT MAX (TXDATE) TXDATE FROM GLHIST WHERE TXDATE <= TO_DATE (f_DATE, 'DD/MM/YYYY'))FNDATE,
      (SELECT MAX (TXDATE) TXDATE FROM GLHIST WHERE TXDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY'))TNDATE

/*SELECT V_DATE.V_DATE, MIN_DATE.TXDATE,FNDATE.TXDATE,TNDATE.TXDATE
FROM  (SELECT TO_DATE (VARVALUE, 'DD/MM/YYYY') V_DATE
       FROM SYSVAR
       WHERE VARNAME = 'CURRDATE') V_DATE ,
      (SELECT MIN(TXDATE) TXDATE FROM GLHIST)MIN_DATE,
      (SELECT max(sbdate) txdate FROM sbcldr
        WHERE holiday <> 'Y'
        AND sbdate <= to_date(F_DATE,'DD/MM/YYYY'))FNDATE,
      (SELECT max(sbdate) txdate FROM sbcldr
        WHERE holiday <> 'Y'
        AND sbdate <= to_date(T_DATE,'DD/MM/YYYY')
      )TNDATE
*/
;

LOOP
  FETCH A
   INTO V_DATE,V_MINDATE,V_FNDATE,V_TNDATE;

  EXIT WHEN A%NOTFOUND;
END LOOP;

CLOSE A;
--XAC DINH NGAY DAU KY VA CUOI KY

IF TO_DATE (F_DATE, 'DD/MM/YYYY') < V_MINDATE THEN
V_BEDATE := '01-jan-2005';
ELSE
V_BEDATE:=V_FNDATE;
END IF;

IF TO_DATE (T_DATE, 'DD/MM/YYYY') >= V_DATE THEN
V_ENDATE := V_DATE;
ELSE
V_ENDATE:=V_TNDATE;
END IF;

   OPEN PV_REFCURSOR
       FOR

SELECT  B.GLBANK, B.C3, B.BE_BALANCE, B.EN_BALANCE, B.glname   FROM
(
--111
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '111'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='111'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='111'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='111'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--112
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '112'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='112'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='112'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='112'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--113
--111
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '113'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='113'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='113'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='113'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--114
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '114'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='114'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='114'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='114'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--117
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '117'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='117'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='117'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='117'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--118
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '118'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='118'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='118'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='118'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--121
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '121'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='121'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='121'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='121'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--123
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '123'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='123'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='123'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='123'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--128
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '128'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('12810','12820')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('12810','12820')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('12810','12820')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--12810
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '12810'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('12810')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('12810')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('12810')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--12820
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '12820'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('12820')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('12820')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('12820')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--129
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        -(ROUND(ABS(BE_BALANCE.BE_CBAL)) - ROUND(BE_BALANCE.BE_DBAL)) BE_BALANCE,
        -(ROUND(ABS(EN_BALANCE.EN_CBAL)) - ROUND(EN_BALANCE.EN_DBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '129'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='129'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='129'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='129'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--13110
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '13110'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13110')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13110')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13110')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--13120
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '13120'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13120','13100')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13120','13100')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13120','13100')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--13130
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '13130'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13130')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13130')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13130')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--13140
--12810
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '13140'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13140')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13140')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13140')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--135
--123
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '133'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('1331','1332','1330')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('1331','1332','1330')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('1331','1332','1330')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--136
/*SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '136'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('136')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('136')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('136')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE*/
--136 sua lai co so sanh voi TK336, neu 136>336 then 136-336
SELECT MIN(GLBANK) GLBANK, MIN(C3) C3, sum(BE_BALANCE) BE_BALANCE, sum(EN_BALANCE) EN_BALANCE, MIN(GLNAME) GLNAME
FROM
(
    SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
            (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,--
            (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
    FROM
    (SELECT * FROM ALLCODE
        WHERE CDNAME = 'CODEGL'
        AND CDVAL = '136'
        ORDER by CDVAL
     )GL,
    (
        SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
        (
            	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
                   		NVL((CASE WHEN balance >= 0 THEN Balance end),0) CBAl
                FROM GLHIST GH
                WHERE GH.txdate = V_BEDATE
                AND GH.period = 'EOD'
                AND  SUBSTR(GH.ACCTNO,7,3)IN('136')
                UNION ALL
                SELECT 0 DBAL, 0 CBAL FROM dual
        ) A
    )BE_BALANCE,
    (
        SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
        (
            	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
                   		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
                FROM GLHIST GH
                WHERE GH.txdate = V_ENDATE
                AND GH.period = 'EOD'
                AND  SUBSTR(GH.ACCTNO,7,3)IN('136')
                UNION ALL
                SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
                   		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
                FROM GLMAST GH
                WHERE V_DATE  = V_ENDATE
                AND  SUBSTR(GH.ACCTNO,7,3)IN('136')
                UNION ALL
                SELECT 0 DBAL, 0 CBAL FROM dual

        ) A
    )EN_BALANCE

    UNION ALL

    --336
    SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
            -(ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,--ANCE,
            -(ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
    FROM
    (SELECT * FROM ALLCODE
        WHERE CDNAME = 'CODEGL'
        AND CDVAL = '336'
        ORDER by CDVAL
     )GL,
    (
        SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
        (
            	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
                   		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
                FROM GLHIST GH
                WHERE GH.txdate = V_BEDATE
                AND GH.period = 'EOD'
                AND  SUBSTR(GH.ACCTNO,7,3)IN('336')
                UNION ALL
                SELECT 0 DBAL, 0 CBAL FROM dual
        ) A
    )BE_BALANCE,
    (
        SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
        (
            	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
                   		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
                FROM GLHIST GH
                WHERE GH.txdate = V_ENDATE
                AND GH.period = 'EOD'
                AND  SUBSTR(GH.ACCTNO,7,3)IN('336')
                UNION ALL
                SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
                   		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
                FROM GLMAST GH
                WHERE V_DATE  = V_ENDATE
                AND  SUBSTR(GH.ACCTNO,7,3)IN('336')
                UNION ALL
                SELECT 0 DBAL, 0 CBAL FROM dual

        ) A
    )EN_BALANCE
)
having (sum(BE_BALANCE) >=0 AND sum(EN_BALANCE) >=0)

UNION ALL

--138
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '138'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)in('1388')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)in('1388')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)in('1388')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--139
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        -(ROUND(ABS(BE_BALANCE.BE_CBAL)) - ROUND(BE_BALANCE.BE_DBAL)) BE_BALANCE,
        -(ROUND(ABS(EN_BALANCE.EN_CBAL)) - ROUND(EN_BALANCE.EN_DBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '139'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='139'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='139'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='139'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--IV: Vat lieu cong cu ton kho
--151
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '151'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='151'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='151'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='151'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--152
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '152'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='152'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='152'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='152'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--153
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '153'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='153'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='153'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='153'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--A.V: Tai san luu dong khac
--141
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '141'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='141'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='141'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='141'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--142
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '142'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='142'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='142'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='142'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--13810
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '13810'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13811','13812','13813')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13811','13812','13813')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13811','13812','13813')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--13811
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '13811'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13811')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13811')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13811')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--13813
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '13813'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13812','13813')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13812','13813')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('13812','13813')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--144
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '144'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='144'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='144'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='144'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--B.I: Tai san co dinh
--211
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(ABS(BE_BALANCE.BE_CBAL))) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(ABS(EN_BALANCE.EN_CBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '211'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='211'
            UNION ALL
           	SELECT 	-NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		-NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)='2141'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='211'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='211'
            UNION ALL
            SELECT 	-NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		-NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)='2141'
            UNION ALL
            SELECT 	-NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		-NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)='2141'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)EN_BALANCE

UNION ALL

--211: Nguyen gia
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '291'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='211'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='211'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='211'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--2141: Hao mon tai san co dinh
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        -(ROUND(ABS(BE_BALANCE.BE_CBAL)) - ROUND(BE_BALANCE.BE_DBAL)) BE_BALANCE,
        -(ROUND(ABS(EN_BALANCE.EN_CBAL)) - ROUND(EN_BALANCE.EN_DBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '21410'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2141')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2141')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2141')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--212: Tai san co dinh thue tai chinh
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(ABS(BE_BALANCE.BE_CBAL))) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(ABS(EN_BALANCE.EN_CBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '212'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='212'
            UNION ALL
            SELECT 	-NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		-NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)='2142'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='212'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='212'
            UNION ALL
            SELECT 	-NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		-NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)='2142'
            UNION ALL
            SELECT 	-NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		-NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)='2142'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--212: Nguyen gia
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '292'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='212'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='212'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='212'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--2142: gia tri hao mon luy ke
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        -(ROUND(ABS(BE_BALANCE.BE_CBAL)) - ROUND(BE_BALANCE.BE_DBAL)) BE_BALANCE,
        -(ROUND(ABS(EN_BALANCE.EN_CBAL)) - ROUND(EN_BALANCE.EN_DBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '21420'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2142')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2142')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2142')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--213: Tai san co dinh vo hinh
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(ABS(BE_BALANCE.BE_CBAL))) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(ABS(EN_BALANCE.EN_CBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '213'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='213'
            UNION ALL
            SELECT 	-NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		-NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)='2143'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='213'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='213'
            UNION ALL
        	SELECT 	-NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		-NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)='2143'
            UNION ALL
            SELECT 	-NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		-NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)='2143'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--213: Nguyen gia
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '293'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='213'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='213'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='213'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--2143: gia tri hao mon luy ke
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
       - (ROUND(ABS(BE_BALANCE.BE_CBAL)) - ROUND(BE_BALANCE.BE_DBAL)) BE_BALANCE,
       - (ROUND(ABS(EN_BALANCE.EN_CBAL)) - ROUND(EN_BALANCE.EN_DBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '21430'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2143')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2143')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2143')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--B.II: Cac khoan dau tu ck dai han
--221
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '221'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='221'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='221'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='221'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--222
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '222'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='222'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='222'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='222'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--223
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '223'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='223'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='223'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='223'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--228
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '228'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('22810','22820')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2281','2282')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2281','2282')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--22810
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '22810'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2281')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2281')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2281')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--22820
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '22820'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2282')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2282')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('2282')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--229
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        -(ROUND(ABS(BE_BALANCE.BE_CBAL)) - ROUND(BE_BALANCE.BE_DBAL)) BE_BALANCE,
        -(ROUND(ABS(EN_BALANCE.EN_CBAL)) - ROUND(EN_BALANCE.EN_DBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '229'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='229'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='229'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='229'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--III.
--241
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '241'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='241'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='241'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='241'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--244
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '244'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='244'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='244'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='244'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--245
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '245'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='245'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='245'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='245'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--246
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '246'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='246'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)='246'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)='246'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--::::::::::::::NGUON VON::::::::::::::::::::::::
--311
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '311'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3111','3112')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3111','3112')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3111','3112')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--3111
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '31110'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3111')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3111')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3111')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--3112
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '31120'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3112')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3112')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3112')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--315
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '315'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('315')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('315')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('315')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--33110
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '33110'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33110')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33110')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33110')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--33120
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '33120'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3312')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3312')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3312')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--33130
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '33130'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3313')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3313')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3313')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--33140
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '33140'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3314','3310')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3314','3310')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3314','3310')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--33150
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '33150'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3315')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3315')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3315')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--332
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '332'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33210','33220')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33210','33220')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33210','33220')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--33210
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '33210'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33210')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33210')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33210')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--33220
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '33220'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33220')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33220')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33220')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--333
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '333'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('333')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('333')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('333')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--334
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '334'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('334')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('334')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('334')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--335
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '335'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('335')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('335')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('335')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--336
/*SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '336'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('336')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('336')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('336')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE
*/

SELECT  Max(GLBANK) GLBANK, Max(C3) C3, sum(BE_BALANCE) BE_BALANCE, sum(EN_BALANCE) EN_BALANCE,  Max(GLNAME) GLNAME
FROM
(
    --336
    SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
            (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,--ANCE,
            (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
    FROM
    (SELECT * FROM ALLCODE
        WHERE CDNAME = 'CODEGL'
        AND CDVAL = '336'
        ORDER by CDVAL
     )GL,
    (
        SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
        (
            	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
                   		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
                FROM GLHIST GH
                WHERE GH.txdate = V_BEDATE
                AND GH.period = 'EOD'
                AND  SUBSTR(GH.ACCTNO,7,3)IN('336')
                UNION ALL
                SELECT 0 DBAL, 0 CBAL FROM dual
        ) A
    )BE_BALANCE,
    (
        SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
        (
            	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
                   		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
                FROM GLHIST GH
                WHERE GH.txdate = V_ENDATE
                AND GH.period = 'EOD'
                AND  SUBSTR(GH.ACCTNO,7,3)IN('336')
                UNION ALL
                SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
                   		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
                FROM GLMAST GH
                WHERE V_DATE  = V_ENDATE
                AND  SUBSTR(GH.ACCTNO,7,3)IN('336')
                UNION ALL
                SELECT 0 DBAL, 0 CBAL FROM dual

        ) A
    )EN_BALANCE

    UNION ALL

    SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
            -(ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,--
            -(ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
    FROM
    (SELECT * FROM ALLCODE
        WHERE CDNAME = 'CODEGL'
        AND CDVAL = '136'
        ORDER by CDVAL
     )GL,
    (
        SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
        (
            	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
                   		NVL((CASE WHEN balance >= 0 THEN Balance end),0) CBAl
                FROM GLHIST GH
                WHERE GH.txdate = V_BEDATE
                AND GH.period = 'EOD'
                AND  SUBSTR(GH.ACCTNO,7,3)IN('136')
                UNION ALL
                SELECT 0 DBAL, 0 CBAL FROM dual
        ) A
    )BE_BALANCE,
    (
        SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
        (
            	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
                   		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
                FROM GLHIST GH
                WHERE GH.txdate = V_ENDATE
                AND GH.period = 'EOD'
                AND  SUBSTR(GH.ACCTNO,7,3)IN('136')
                UNION ALL
                SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
                   		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
                FROM GLMAST GH
                WHERE V_DATE  = V_ENDATE
                AND  SUBSTR(GH.ACCTNO,7,3)IN('136')
                UNION ALL
                SELECT 0 DBAL, 0 CBAL FROM dual

        ) A
    )EN_BALANCE

)
having (sum(BE_BALANCE) <=0 AND sum(EN_BALANCE) <=0)

UNION ALL
--337
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '337'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('337')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('337')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('337')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--338
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '338'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3382','3383','3384','3385','3386','3387','3388')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3382','3383','3384','3385','3386','3387','3388')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3382','3383','3384','3385','3386','3387','3388')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--33810
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '33810'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33811','33812','33813')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33811','33812','33813')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33811','33812','33813')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--33811
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '33811'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33811')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33811')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33811')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--33818

SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '33818'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33812','33813')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33812','33813')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('33812','33813')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--353
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '353'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('353')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('353')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('353')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--341
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '341'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('341')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('341')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('341')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--342
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '342'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('342')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('342')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('342')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--34220
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '34220'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3422')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3422')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('3422')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--344
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '344'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('344')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('344')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('344')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '346'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('346')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('346')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('346')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--B: Nguon von chu so huu
--925
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '925'
    ORDER by CDVAL
 )GL,
(
    SELECT 0 BE_DBAl, 0 BE_CBAl FROM
    dual
)BE_BALANCE,
(
    SELECT 0 EN_DBAl, 0 EN_CBAl FROM
    dual
)EN_BALANCE

UNION ALL
--41110
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '41110'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4111')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4111')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4111')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--926
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL)))/10000 BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL)))/10000 EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '926'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4111')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4111')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4111')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--927
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '927'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        SELECT 0 DBAL, 10000 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        SELECT 0 DBAL, 10000 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--II. Von bo sung
--41121
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '41121'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('41121','41120')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('41121','41120')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('41121','41120')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--41122
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '41122'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('41122')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('41122')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('41122')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--41128
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '41128'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('41128')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('41128')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('41128')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--III: cac quy loi nhuan chua phan phoi
--414
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '414'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('414')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('414')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('414')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--415
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '415'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4151','4152','4153','4158')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4151','4152','4153','4158')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4151','4152','4153','4158')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--4151
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '41510'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4151')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4151')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4151')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--4152
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '41520'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4152')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4152')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4152')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--4153
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '41530'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4153')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4153')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4153')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--4158
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '41580'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4158')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4158')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('4158')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--416
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '416'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('416')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('416')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('416')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--421
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '421'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('421')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('421')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('421')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--431
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '431'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('431')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('431')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('431')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--412
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '412'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('41200')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('41200')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('41200')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--413
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '41320'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('413')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('413')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('413')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

/*UNION ALL
--122: Gia thuan chung khoan ngan quy
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '923'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('122','129','229')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('122','129','229')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('122','129','229')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE
*/
UNION ALL
--122
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '122'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('122')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('122')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('122')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

/* thanh.tran rao chi tieu nay vao vi tren BCD chua can lay chi tieu nay, sau nay bo sung sau.
Date: 30/03/2008
UNION ALL
--924
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGL'
    AND CDVAL = '924'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('129','229')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('129','229')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('129','229')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE
*/
UNION ALL
--------------------------------------------------------------------------------
--Cac chi tieu ngoai bang can doi ke toan
--001
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '001'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('001')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('001')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('001')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)EN_BALANCE

UNION ALL

--002
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '002'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('002')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('002')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('002')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)EN_BALANCE

UNION ALL
--004
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '004'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('004')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('004')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('004')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)EN_BALANCE

UNION ALL
--007
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '007'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('007')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('007')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('007')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)EN_BALANCE

UNION ALL
--009
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '009'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('009')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('009')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('009')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)EN_BALANCE

UNION ALL
--012
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '012'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('012')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('012')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('012')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)EN_BALANCE

UNION ALL

/*--0121
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(BE_BALANCE.BE_CBAL) - ROUND(ABS(BE_BALANCE.BE_DBAL))) BE_BALANCE,
        (ROUND(EN_BALANCE.EN_CBAL) - ROUND(ABS(EN_BALANCE.EN_DBAL))) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '12810'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('12810')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('12810')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('12810')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE
UNION ALL*/
--0121
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '031'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01211','01212','01213')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01211','01212','01213')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01211','01212','01213')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--1211
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01211'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01211')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01211')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01211')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--1212
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01212'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01212')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01212')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01212')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01213'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01213')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01213')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01213')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--0122
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '032'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01221','01222','01223')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01221','01222','01223')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01221','01222','01223')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--1221
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01221'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01221')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01221')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01221')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01222'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01222')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01222')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01222')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--1223
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01223'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01223')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01223')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01223')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--01230
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '033'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01231','01232','01233')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01231','01232','01233')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01231','01232','01233')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL


--231
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '24200'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('24200','24240')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('24200','24240')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('24200','24240')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

union all

--1231
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01231'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01231')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01231')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01231')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--01232
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01232'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01232')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01232')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01232')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--01233
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01233'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01233')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01233')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01233')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--01240
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '034'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01241','01242','01243')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01241','01242','01243')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01241','01242','01243')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--1241
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01241'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01241')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01241')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01241')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--01242
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01242'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01242')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01242')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01242')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--1243
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01243'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01243')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01243')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01243')
            AND SUBSTR(GH.ACCTNO,15,1)NOT IN('4','6')
            AND substr(GH.ACCTNO,12,1)<> '3'
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--013
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '013'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('013')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('013')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('013')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)EN_BALANCE

UNION ALL
--0131

SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '041'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01311','01312','01313')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01311','01312','01313')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01311','01312','01313')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--01311
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01311'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01311')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01311')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01311')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--01312
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01312'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01312')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01312')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01312')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--01313
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01313'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01313')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01313')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01313')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--01320

SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '042'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01321','01322','01323')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01321','01322','01323')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01321','01322','01323')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--01321
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01321'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01321')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01321')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01321')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--01322
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01322'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01322')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01322')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01322')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--01323
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '051'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01323')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01323')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01323')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--01330

SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '043'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01331','01332','01333')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01331','01332','01333')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01331','01332','01333')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--01331
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01331'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01331')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01331')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01331')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--01332
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01332'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01332')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01332')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01332')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--01333
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01333'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01333')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01333')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01333')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--01340

SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '044'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01341','01342','01343')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01341','01342','01343')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01341','01342','01343')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--01341
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01341'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01341')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01341')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01341')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--01342
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01342'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01342')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01342')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01342')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--01343
SELECT  GL.GLBANK GLBANK , SUBSTR (GLBANK,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.glname GLNAME
FROM
(SELECT * FROM GLBANK
    WHERE GLBANK = '01343'
    ORDER by GLBANK
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01343')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01343')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01343')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--014
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '014'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('014')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('014')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('014')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)EN_BALANCE

UNION ALL
--0141
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '052'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('0141')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,4)IN('0141')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,4)IN('0141')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--0142
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '053'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01421','01422')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01421','01422')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01421','01422')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL
--0143
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '054'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01431','01432')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01431','01432')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,5)IN('01431','01432')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual

    ) A
)EN_BALANCE

UNION ALL

--015
SELECT  GL.CDVAL GLBANK , SUBSTR (CDVAL,1,3) C3,
        (ROUND(ABS(BE_BALANCE.BE_DBAL)) - ROUND(BE_BALANCE.BE_CBAL)) BE_BALANCE,
        (ROUND(ABS(EN_BALANCE.EN_DBAL)) - ROUND(EN_BALANCE.EN_CBAL)) EN_BALANCE, GL.cdcontent GLNAME
FROM
(SELECT * FROM ALLCODE
    WHERE CDNAME = 'CODEGLNB'
    AND CDVAL = '015'
    ORDER by CDVAL
 )GL,
(
    SELECT SUM(A.DBAL) BE_DBAl, SUM(A.CBAl) BE_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_BEDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('015')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)BE_BALANCE,
(
    SELECT SUM(A.DBAL) EN_DBAl, SUM(A.CBAl) EN_CBAl FROM
    (
        	SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLHIST GH
            WHERE GH.txdate = V_ENDATE
            AND GH.period = 'EOD'
            AND  SUBSTR(GH.ACCTNO,7,3)IN('015')
            UNION ALL
            SELECT 	NVL((CASE WHEN GH.balance < 0 THEN Balance end),0) DBAL,
               		NVL((CASE WHEN GH.balance >= 0 THEN Balance end),0) CBAl
            FROM GLMAST GH
            WHERE V_DATE  = V_ENDATE
            AND  SUBSTR(GH.ACCTNO,7,3)IN('015')
            UNION ALL
            SELECT 0 DBAL, 0 CBAL FROM dual
    ) A
)EN_BALANCE
)
B
-------------------------------------------------------------------------------------------------
    ;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE




-- End of DDL Script for Procedure HOST1.GL0002
/

