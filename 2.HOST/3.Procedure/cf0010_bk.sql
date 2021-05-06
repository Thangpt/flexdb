CREATE OR REPLACE PROCEDURE CF0010_BK (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2
  )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO TAI KHOAN TIEN TONG HOP CUA NGUOI DAU TU
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   20-DEC-06  CREATED
-- ---------   ------  -------------------------------------------

   CUR             PKG_REPORT.REF_CURSOR;
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   V_STRAFACCTNO  VARCHAR2 (20);
   V_STRSDDK      NUMBER (20, 2);
   V_STRCTT       NUMBER (20, 2);
   V_STRKQ        NUMBER (20, 2);
   V_STRPT        NUMBER (20, 2);
   V_STRFULLNAME  VARCHAR2 (100);
   V_STRADDRESS    VARCHAR2 (500);
   V_DATE         DATE;
   V_D_CUR        DATE;

BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS


   IF (AFACCTNO <> 'ALL')
   THEN
      V_STRAFACCTNO :=  AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;
   -- END OF GETTING REPORT'S PARAMETERS
--Tinh ngay nhan thanh toan bu tru

OPEN    CUR
FOR
SELECT CF.FULLNAME,CF.ADDRESS
 FROM AFMAST AF,CFMAST CF
WHERE AF.custid =CF.custid
AND AF.ACCTNO  LIKE  V_STRAFACCTNO

;

LOOP
  FETCH    CUR
  INTO V_STRFULLNAME, V_STRADDRESS ;
  EXIT WHEN    CUR%NOTFOUND;
END LOOP;
CLOSE    CUR;

---XAC DINH NGAY HIEN TAI CO LA NGAY T_DATE KHONG
OPEN    CUR
FOR
SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR  WHERE VARNAME='CURRDATE';

LOOP
  FETCH    CUR
  INTO V_D_CUR ;
  EXIT WHEN    CUR%NOTFOUND;
END LOOP;
CLOSE    CUR;

--NGAY TINH TIEN CHO NHAN VE

IF  TO_DATE(T_DATE,'DD/MM/YYYY') < V_D_CUR  THEN

OPEN    CUR
FOR
SELECT A.SBDATE
FROM(SELECT ROWNUM DAY,SBDATE
FROM(SELECT  SBDATE FROM SBCLDR
WHERE CLDRTYPE='001' AND HOLIDAY='N' AND
SBDATE < to_date(T_DATE  ,'dd/mm/yyyy')   order by SBDATE  desc )SBCLDR )A
WHERE A.DAY = 3;
--WHERE A.DAY = 4;

ELSE

OPEN    CUR
FOR
SELECT A.SBDATE
FROM(SELECT ROWNUM DAY,SBDATE
FROM(SELECT  SBDATE FROM SBCLDR
WHERE CLDRTYPE='001' AND HOLIDAY='N' AND
SBDATE < to_date(T_DATE  ,'dd/mm/yyyy')   order by SBDATE  desc )SBCLDR )A
--WHERE A.DAY = 3;
WHERE A.DAY = 4;

END IF;




LOOP
  FETCH    CUR
  INTO V_DATE ;
  EXIT WHEN    CUR%NOTFOUND;
END LOOP;
CLOSE    CUR;


OPEN    CUR
    FOR
  SELECT NVL(SUM(STS.AMT),0) STS FROM
(
SELECT ACCTNO,AMT FROM STSCHD
WHERE DUETYPE ='RM' and  TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY')
and TXDATE >V_DATE
and acctno LIKE V_STRAFACCTNO
and deltd<> 'Y'
UNION ALL
SELECT ACCTNO,AMT FROM STSCHDHIST
WHERE DUETYPE ='RM'  and TXDATE <= TO_DATE (T_DATE  ,'DD/MM/YYYY')
and TXDATE >  V_DATE
and acctno LIKE V_STRAFACCTNO
and acctno = V_STRAFACCTNO
and deltd<> 'Y'
)STS
GROUP BY  STS.ACCTNO
;


LOOP
    FETCH    CUR
     INTO V_STRCTT;
      EXIT WHEN    CUR%NOTFOUND;
   END LOOP;
   CLOSE    CUR;



-- TINH SO TIEN KY QUY
OPEN    CUR
    FOR
     SELECT  CI.BAMT  -  NVL(DTL.B,0)
      FROM (SELECT * FROM  CIMAST WHERE AFACCTNO  LIKE V_STRAFACCTNO)  CI
LEFT JOIN
      (
         SELECT SUM(A.AMT) B,A.ACCTNO  ACCTNO
         FROM (SELECT   SUM ((CASE WHEN APP.TXTYPE = 'D'THEN -TR.NAMT
                                   WHEN APP.TXTYPE = 'C' THEN TR.NAMT
                                   ELSE 0   END )) AMT,TR.ACCTNO ACCTNO
               FROM APPTX APP, CITRAN TR ,TLLOG TL
               WHERE TR.TXCD = APP.TXCD
                    AND TL.TXNUM =TR.TXNUM
                    AND TL.deltd <>'Y'
                    AND TR.NAMT<>0
                    AND APP.APPTYPE = 'CI'
                    AND APP.TXTYPE IN ('C', 'D')
                    AND TRIM (APP.FIELD) IN ('BAMT')
                    AND  TL.BUSDATE  > TO_DATE (T_DATE ,'DD/MM/YYYY')
               GROUP BY TR.ACCTNO
           UNION ALL
              SELECT   SUM ((CASE WHEN APP.TXTYPE = 'D'THEN -TR.NAMT
                                 WHEN  APP.TXTYPE = 'C'THEN TR.NAMT
                                 ELSE 0 END )) AMT,TR.ACCTNO ACCTNO
              FROM APPTX APP, CITRANA TR,TLLOGALL TL
              WHERE TR.TXCD = APP.TXCD
                    AND TL.TXNUM =TR.TXNUM
                    AND TL.deltd <>'Y'
                    AND TR.NAMT<>0
                    AND TL.TXDATE =TR.TXDATE
                    AND APP.APPTYPE = 'CI'
                    AND APP.TXTYPE IN ('C', 'D')
                    AND TRIM (APP.FIELD) IN ('BAMT')
                    AND  TL.BUSDATE  > TO_DATE (T_DATE ,'DD/MM/YYYY')
              GROUP BY TR.ACCTNO
                ) A
                  GROUP BY A.ACCTNO)DTL
       on DTL.ACCTNO = CI.AFACCTNO
       ;

   LOOP
      FETCH    CUR
       INTO  V_STRKQ  ;
      EXIT WHEN    CUR%NOTFOUND;
   END LOOP;
   CLOSE    CUR;

-- SO TIEN PHONG TOA
OPEN    CUR
    FOR
     SELECT  CI.EMKAMT  - NVL(DTL.B,0)
      FROM (SELECT * FROM  CIMAST WHERE AFACCTNO  LIKE V_STRAFACCTNO)  CI
    LEFT JOIN
      (
         SELECT SUM(A.AMT) B,A.ACCTNO  ACCTNO
         FROM (SELECT   SUM ((CASE WHEN APP.TXTYPE = 'D'THEN -TR.NAMT
                                   WHEN APP.TXTYPE = 'C' THEN TR.NAMT
                                   ELSE 0   END )) AMT,TR.ACCTNO ACCTNO
               FROM APPTX APP, CITRAN TR ,TLLOG TL
               WHERE TR.TXCD = APP.TXCD
                    AND TL.TXNUM =TR.TXNUM
                    AND TL.deltd <>'Y'
                    AND TR.NAMT<>0
                    AND APP.APPTYPE = 'CI'
                    AND APP.TXTYPE IN ('C', 'D')
                    AND TRIM (APP.FIELD) IN ('EMKAMT')
                    AND  TL.BUSDATE  > TO_DATE (T_DATE ,'DD/MM/YYYY')
               GROUP BY TR.ACCTNO
           UNION ALL
              SELECT   SUM ((CASE WHEN APP.TXTYPE = 'D'THEN -TR.NAMT
                                 WHEN  APP.TXTYPE = 'C'THEN TR.NAMT
                                 ELSE 0 END )) AMT,TR.ACCTNO ACCTNO
              FROM APPTX APP, CITRANA TR,TLLOGALL TL
              WHERE TR.TXCD = APP.TXCD
                    AND TL.TXNUM =TR.TXNUM
                    AND TL.deltd <>'Y'
                    AND TR.NAMT<>0
                    AND TL.TXDATE =TR.TXDATE
                    AND APP.APPTYPE = 'CI'
                    AND APP.TXTYPE IN ('C', 'D')
                    AND TRIM (APP.FIELD) IN ('EMKAMT')
                    AND  TL.BUSDATE  >  TO_DATE (T_DATE ,'DD/MM/YYYY')
              GROUP BY TR.ACCTNO
                ) A
                  GROUP BY A.ACCTNO)DTL
 ON DTL.ACCTNO = CI.AFACCTNO
;

   LOOP
      FETCH    CUR
       INTO  V_STRPT  ;
      EXIT WHEN    CUR%NOTFOUND;
   END LOOP;
   CLOSE    CUR;


---So du dau ky
   OPEN    CUR
    FOR
     SELECT  CI.BALANCE+ci.bamt  -  NVL(DTL.B,0)
      FROM (SELECT * FROM  CIMAST WHERE AFACCTNO  LIKE V_STRAFACCTNO)  CI
    LEFT JOIN
      (
         SELECT SUM(A.AMT) B,A.ACCTNO  ACCTNO
         FROM (SELECT   SUM ((CASE WHEN APP.TXTYPE = 'D'THEN -TR.NAMT
                                   WHEN APP.TXTYPE = 'C' THEN TR.NAMT
                                   ELSE 0   END )) AMT,TR.ACCTNO ACCTNO
               FROM APPTX APP, CITRAN TR ,TLLOG TL
               WHERE TR.TXCD = APP.TXCD
                    AND TL.TXNUM =TR.TXNUM
                    AND TL.deltd <>'Y'
                    AND TR.NAMT<>0
                    AND APP.APPTYPE = 'CI'
                    AND APP.TXTYPE IN ('C', 'D')
                    AND TRIM (APP.FIELD) IN ('BALANCE','BAMT')
                    AND  TL.BUSDATE  >= TO_DATE (F_DATE ,'DD/MM/YYYY')
                     --AND  TL.TLTXCD NOT IN('1145' ,'1144')
               GROUP BY TR.ACCTNO
           UNION ALL
              SELECT   SUM ((CASE WHEN APP.TXTYPE = 'D'THEN -TR.NAMT
                                 WHEN  APP.TXTYPE = 'C'THEN TR.NAMT
                                 ELSE 0 END )) AMT,TR.ACCTNO ACCTNO
              FROM APPTX APP, CITRANA TR,TLLOGALL TL
              WHERE TR.TXCD = APP.TXCD
                    AND TL.TXNUM =TR.TXNUM
                    AND TL.deltd <>'Y'
                    AND TR.NAMT<>0
                    AND TL.TXDATE =TR.TXDATE
                    AND APP.APPTYPE = 'CI'
                    AND APP.TXTYPE IN ('C', 'D')
                    AND TRIM (APP.FIELD) IN ('BALANCE','BAMT')
                    AND  TL.BUSDATE  >= TO_DATE (F_DATE ,'DD/MM/YYYY')
                    --AND  TL.TLTXCD NOT IN('1145' ,'1144')
              GROUP BY TR.ACCTNO
                ) A
                  GROUP BY A.ACCTNO)DTL
       ON DTL.ACCTNO = CI.AFACCTNO     ;

   LOOP
      FETCH    CUR
       INTO V_STRSDDK;
      EXIT WHEN    CUR%NOTFOUND;
   END LOOP;
   CLOSE    CUR;



   -- GET REPORT'S DATA

   OPEN PV_REFCURSOR
       FOR
          SELECT AFACCTNO ACCTNO, V_STRFULLNAME FULLNAME, V_STRADDRESS ADDRESS, nvl(V_STRSDDK,0) SDDK , NVL(V_STRCTT,0) SDCTT , NVL(V_STRKQ,0)  SDKQ, NVL(V_STRPT,0) SDPT ,V.TXDATE,V.TXNUM,
          V.CRAMT,V.DRAMT,V.BUSDATE,V.DESCRIPTION,V.ORDERID
          FROM (


        SELECT  TL.TXDATE TXDATE, TL.TXNUM TXNUM, TO_CHAR(TL.TXDESC) DESCRIPTION,
        (CASE WHEN APP.TXTYPE='C' THEN CITR.NAMT ELSE 0 END)CRAMT,
        (CASE WHEN APP.TXTYPE='D' THEN CITR.NAMT ELSE 0 END)DRAMT,TL.BUSDATE, '' ORDERID
         FROM (SELECT * FROM TLLOG WHERE BUSDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY') AND
                                         BUSDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')
                  AND TLTXCD IN ( SELECT  TLTXCD FROM TLTX  WHERE  SUBSTR(TLTXCD,1,2) <> '88'  and tltxcd <> '1196' or TLTXCD  IN('8878' ,'8879'))
                 )  TL,APPTX APP,(SELECT * FROM CITRAN WHERE ACCTNO LIKE V_STRAFACCTNO) CITR
                  WHERE  TL.TXNUM = CITR.TXNUM
                         AND TL.deltd <>'Y'
                         AND CITR.TXCD = APP.TXCD
                         AND APP.APPTYPE = 'CI'
                         AND APP.TXTYPE IN ('C', 'D')
                         AND TRIM (APP.FIELD) IN ('BALANCE','BAMT')
                         AND  CITR.NAMT<>0
                         AND TL.TXDATE =CITR.TXDATE
                         AND SUBSTR(CITR.ACCTNO,1,4)LIKE V_STRBRID

      UNION ALL
                 SELECT MAX(TL.TXDATE) TXDATE, MAX(TL.TXNUM) TXNUM, TO_CHAR(MAX(TL.TXDESC)) DESCRIPTION,
                        SUM(CASE WHEN APP.TXTYPE='C' THEN CITR.NAMT ELSE 0 END)CRAMT,
                        SUM(CASE WHEN APP.TXTYPE='D' THEN CITR.NAMT ELSE 0 END)DRAMT,
                        MAX(TL.BUSDATE) BUSDATE,OD.ORDERID
                FROM (SELECT * FROM TLLOG WHERE BUSDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY') AND
                                                BUSDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')
                             AND tltxcd  IN ( '8821','8865','8866','8822','8861','8855','8856')
                 ) TL,APPTX APP,(SELECT * FROM CITRAN WHERE ACCTNO LIKE V_STRAFACCTNO)  CITR, ( SELECT  TXDATE,TXNUM,MAX(ACCTNO) ORDERID FROM ODTRAN GROUP BY TXDATE,TXNUM) OD
                  WHERE  OD.TXNUM =TL.TXNUM
                         AND OD.TXDATE =TL.TXDATE
                         AND TL.TXNUM = CITR.TXNUM
                         AND TL.TXDATE =CITR.TXDATE
                         AND TL.deltd <>'Y'
                         AND CITR.TXCD = APP.TXCD
                         AND APP.APPTYPE = 'CI'
                         AND APP.TXTYPE IN ('C', 'D')
                         AND TRIM (APP.FIELD) IN  ('BALANCE','BAMT')
                         AND  CITR.NAMT<>0

                         AND SUBSTR(CITR.ACCTNO,1,4)LIKE V_STRBRID
			             GROUP BY OD.ORDERID,APP.TXTYPE,tl.tltxcd

       UNION ALL
         SELECT  TL.TXDATE TXDATE, TL.TXNUM TXNUM, TO_CHAR(TL.TXDESC) DESCRIPTION,
        (CASE WHEN APP.TXTYPE='C' THEN CITR.NAMT ELSE 0 END)CRAMT,
        (CASE WHEN APP.TXTYPE='D' THEN CITR.NAMT ELSE 0 END)DRAMT,TL.BUSDATE, '' ORDERID
          FROM (SELECT * FROM TLLOGALL WHERE BUSDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY') AND
                                              BUSDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')
                   AND TLTXCD IN ( SELECT  TLTXCD FROM TLTX  WHERE  SUBSTR(TLTXCD,1,2) <> '88'  and tltxcd <> '1196' or TLTXCD  IN('8878' ,'8879'))
                 ) TL,APPTX APP,(SELECT * FROM CITRANA WHERE ACCTNO LIKE V_STRAFACCTNO)  CITR
                  WHERE  TL.TXNUM = CITR.TXNUM
                         AND TL.deltd <>'Y'
                         AND CITR.TXCD = APP.TXCD
                         AND APP.APPTYPE = 'CI'
                         AND APP.TXTYPE IN ('C', 'D')
                         AND TRIM (APP.FIELD) IN ('BALANCE','BAMT')
                         AND  CITR.NAMT<>0
                         AND TL.TXDATE =CITR.TXDATE

                         AND SUBSTR(CITR.ACCTNO,1,4)LIKE V_STRBRID
      UNION ALL
          SELECT MAX(TL.TXDATE) TXDATE, MAX(TL.TXNUM) TXNUM, TO_CHAR(MAX(TL.TXDESC)) DESCRIPTION,
                        SUM(CASE WHEN APP.TXTYPE='C' THEN CITR.NAMT ELSE 0 END)CRAMT,
                        SUM(CASE WHEN APP.TXTYPE='D' THEN CITR.NAMT ELSE 0 END)DRAMT,
                        MAX(TL.BUSDATE) BUSDATE,OD.ORDERID
           FROM (SELECT * FROM TLLOGALL WHERE BUSDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY') AND
                                              BUSDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')
                           AND tltxcd  IN ( '8821','8865','8866','8822','8861','8855','8856')
                 ) TL,APPTX APP,(SELECT * FROM CITRANA WHERE ACCTNO LIKE V_STRAFACCTNO)  CITR,
                 ( SELECT  TXDATE,TXNUM,MAX(ACCTNO) ORDERID FROM ODTRANA GROUP BY TXDATE,TXNUM) OD
            WHERE   OD.TXNUM =TL.TXNUM
                 AND OD.TXDATE =TL.TXDATE
                 AND TL.TXNUM = CITR.TXNUM
                 AND TL.deltd <>'Y'
                 AND CITR.TXCD = APP.TXCD
                 AND APP.APPTYPE = 'CI'
                 AND APP.TXTYPE IN ('C', 'D')
                 AND TRIM (APP.FIELD) IN  ('BALANCE','BAMT')
                 AND  CITR.NAMT<>0
                 AND TL.TXDATE =CITR.TXDATE
                 AND SUBSTR(CITR.ACCTNO,1,4)Like V_STRBRID
                 GROUP BY OD.ORDERID,APP.TXTYPE,tl.tltxcd

                         ) V


             --    ORDER BY BUSDATE ,ORDERID,TXNUM
                  ;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

