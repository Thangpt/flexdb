CREATE OR REPLACE PROCEDURE td0012 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD       IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2,
   PV_TDACCTNO      IN       VARCHAR2

   )
IS

   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_FRDATE         DATE;
   V_TODATE         DATE;
   V_STRCUSTODYCD    VARCHAR2 (10);
   V_STRAFACCTNO    VARCHAR2 (10);
   V_STRTDSRC    VARCHAR2 (1);
   V_STRTDACCTNO VARCHAR2 (20);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN

   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

    -- GET REPORT'S PARAMETERS


   IF(upper(PV_CUSTODYCD) <> 'ALL') THEN
        V_STRCUSTODYCD := trim(upper(PV_CUSTODYCD));
   ELSE
        V_STRCUSTODYCD := '%';
   END IF;

   IF(upper(PV_AFACCTNO) <> 'ALL') THEN
        V_STRAFACCTNO := trim(PV_AFACCTNO);
   ELSE
        V_STRAFACCTNO := '%';
   END IF;

   IF(upper(PV_TDACCTNO) <> 'ALL') THEN
        V_STRTDACCTNO := trim(PV_TDACCTNO);
   ELSE
        V_STRTDACCTNO := '%';
   END IF;



   V_FRDATE := to_date(F_DATE,'dd/mm/RRRR');
   V_TODATE := to_date(T_DATE,'dd/mm/RRRR');


   -- GET REPORT'S DATA

OPEN PV_REFCURSOR
       FOR
        SELECT  TONG_RUT, TONG_GUI, TONG_LAI, CF.FULLNAME, CI.*, CASE WHEN TL.TLTXCD = '1670' THEN TL.MSGAMT ELSE TLFLD.NVALUE END ORGAMT, A1.cdcontent, TDP.ACTYPE, TD.description
        FROM (SELECT * FROM vw_citran_gen WHERE txdate between V_FRDATE AND V_TODATE
                AND TLTXCD IN ('1600','1610','1670')
             ) CI LEFT JOIN
             (
                SELECT SUM(CASE WHEN TLTXCD = '1670' AND TXCD = '0028' THEN NAMT ELSE 0 END) TONG_GUI,
                   SUM(CASE WHEN TLTXCD IN ('1600','1610') AND TXCD = '0029' THEN NAMT ELSE 0 END) TONG_RUT,
                   SUM(CASE WHEN TLTXCD IN ('1600','1610') AND TXCD = '0012' THEN NAMT ELSE 0 END) TONG_LAI
                FROM vw_citran_gen
                WHERE txdate between to_date('01/01/2012','DD/MM/RRRR') AND to_date('31/12/2012','DD/MM/RRRR')
                AND TLTXCD IN ('1600','1610','1670')  AND TXCD IN('0029','0028','0012')
            ) A ON 1=1,
            CFMAST CF, TDMAST TD, TDTYPE TDP,ALLCODE A1,
            (SELECT * FROM vw_tllog_all WHERE txdate between V_FRDATE AND V_TODATE
                AND TLTXCD IN ('1600','1610','1670')
            ) TL LEFT JOIN
            (SELECT * FROM vw_tllogfld_all WHERE FLDCD = '09' and
                txdate between V_FRDATE AND V_TODATE
            ) TLFLD ON TL.TXDATE = TLFLD.TXDATE AND TL.TXNUM = TLFLD.TXNUM
        WHERE CI.TXDATE=TL.TXDATE AND CI.TXNUM=TL.TXNUM
        AND CI.CUSTID = CF.CUSTID
        AND ci.ref= TD.ACCTNO AND TD.ACTYPE = TDP.ACTYPE
        AND A1.CDNAME= 'TDSRC'  AND A1.CDVAL=TDP.TDSRC
        AND CI.TLTXCD IN ('1600','1610','1670')
        AND cf.custodycd LIKE V_STRCUSTODYCD
        AND td.afacctno LIKE V_STRAFACCTNO
        AND TD.ACCTNO LIKE V_STRTDACCTNO
        AND CI.TXDATE between V_FRDATE AND V_TODATE
        order by CI.CUSTODYCD, CI.ACCTNO,ci.ref, CI.TXDATE, ci.txnum

        ;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

