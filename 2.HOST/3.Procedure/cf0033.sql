CREATE OR REPLACE PROCEDURE cf0033 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   INMONTH        IN       VARCHAR2

    )
IS
--
-- PURPOSE: BANG KE CHI TIET GIA TRI CHUYEN NHUONG VA THUE TNCN
-- PERSON      DATE    COMMENTS
-- THANHNM    05-03-2012  CREATE

-- ---------   ------  -------------------------------------------

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);
    V_INMONTH   VARCHAR2(2);
    V_INYEAR    VARCHAR2(4);
    V_F_DATE    DATE;
    V_T_DATE    DATE;
BEGIN
 -- GET REPORT'S PARAMETERS
   V_STROPTION := OPT;


   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

    IF TO_NUMBER(SUBSTR(INMONTH,1,2)) <= 12 THEN
        V_F_DATE := TO_DATE('01/' || SUBSTR(INMONTH,1,2) || '/' || SUBSTR(INMONTH,3,4),'DD/MM/YYYY');
    ELSE
        V_F_DATE := TO_DATE('31/12/9999','DD/MM/YYYY');
    END IF;
    V_T_DATE := LAST_DAY(V_F_DATE);
    V_INMONTH := SUBSTR(INMONTH,1,2);
    V_INYEAR :=  SUBSTR(INMONTH,3,4);


-- GET DATA
OPEN PV_REFCURSOR
   FOR
      --GET DATA
   SELECT INMONTH IN_M , CF.FULLNAME, CF.IDCODE, CF.IDTYPE,CF.IDDATE, CF.IDPLACE, CF.CUSTODYCD, CF.TAXCODE,CF.ADDRESS,
   'F' CTYPE,SUM(T.MATCHAMT) MATCHAMT, SUM(T.TAXSELLAMT) TAXSELLAMT, T.TXDATE
    FROM
    (       SELECT OD.AFACCTNO,TXDATE,EXECTYPE,SUM(MATCHAMT) MATCHAMT,SUM(TAXSELLAMT) TAXSELLAMT
            FROM
            (SELECT OD.AFACCTNO,OD.TXDATE,ST.CLEARDATE ,OD.EXECTYPE,OD.MATCHAMT,
                 (OD.MATCHAMT * NVL((SELECT TO_NUMBER(VARVALUE)
                 FROM SYSVAR WHERE VARNAME = 'ADVSELLDUTY' AND GRNAME = 'SYSTEM'),0)/100) + ST.ARIGHT TAXSELLAMT, OD.DELTD
                 FROM ODMAST  OD,STSCHD ST WHERE OD.ORDERID = ST.orgorderid AND ST.DELTD='N' AND ST.DUETYPE='RM'
                     UNION ALL
                SELECT OD.AFACCTNO,OD.TXDATE,ST.CLEARDATE,OD.EXECTYPE,OD.MATCHAMT,OD.TAXSELLAMT + ST.ARIGHT  TAXSELLAMT, OD.DELTD
                 FROM ODMASTHIST OD, STSCHDHIST ST WHERE OD.ORDERID = ST.orgorderid AND ST.DELTD='N' AND ST.DUETYPE='RM') OD,CFMAST CF,
                AFMAST AF, AFTYPE AFT
            WHERE OD.AFACCTNO = AF.ACCTNO AND CF.CUSTID = AF.CUSTID
            AND AF.ACTYPE = AFT.ACTYPE AND AFT.VAT ='Y'
            AND CF.CUSTTYPE ='B' AND SUBSTR(CF.CUSTODYCD,4,1) ='F'
            AND OD.DELTD ='N' AND OD.EXECTYPE IN('NS','SS','MS') AND OD.MATCHAMT>0
            AND OD.CLEARDATE<=V_T_DATE AND   OD.CLEARDATE >=V_F_DATE
            GROUP BY OD.AFACCTNO,OD.TXDATE,OD.EXECTYPE
         )  T ,CFMAST CF, AFMAST AF
   WHERE CF.CUSTID = AF.CUSTID AND T.AFACCTNO = AF.ACCTNO
   GROUP BY T.TXDATE,CF.FULLNAME, CF.IDCODE, CF.IDTYPE,CF.IDDATE, CF.IDPLACE, CF.CUSTODYCD, CF.TAXCODE,CF.ADDRESS
    ;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

