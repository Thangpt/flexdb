CREATE OR REPLACE PROCEDURE td0018 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
  /* F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,*/
   TX_DATE         IN       VARCHAR2,
   PV_CUSTODYCD       IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2,
   PV_TDACCTNO      IN       VARCHAR2
   )
IS

   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0


   V_TODATE         DATE;
   V_CURRDATE         DATE;
   V_STRCUSTODYCD    VARCHAR2 (10);
   V_STRAFACCTNO    VARCHAR2 (10);
   V_STRTDSRC    VARCHAR2 (1);
   V_STRTDACCTNO VARCHAR2 (20);
   V_TXDATE         DATE;

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
/*
   V_FRDATE := to_date(F_DATE,'dd/mm/RRRR');
   V_TODATE := to_date(T_DATE,'dd/mm/RRRR');*/
   V_TXDATE := to_date(TX_DATE,'dd/mm/RRRR');
   V_CURRDATE:= GETCURRDATE();


   -- GET REPORT'S DATA

OPEN PV_REFCURSOR FOR

SELECT V_TXDATE TXDATE, cf.CUSTODYCD, cf.CUSTID, TDM.AFACCTNO AFACCTNO,cf.fullname, cf.ADDRESS,
TDM.ACCTNO TDACCTNO,
nvl(tdr_cur.TONG_RUT,0) TONG_RUT ,NVL(tdr_cur.TONG_LAI,0) TONG_LAI,
TDM.orgamt  - NVL(tdr_to.TONG_GUI,0) DAU_KY,
TDM.balance + NVL(tdr_to.TONG_RUT,0) - NVL(tdr_to.TONG_GUI,0) CUOI_KY,
TDM.description TRDESC ,TDM.actype ACTYPE

FROM  tdmast TDM ,
( -- Tong phat sinh tu TXDATE den ngay hien tai
    SELECT max(CF.CUSTODYCD) CUSTODYCD , max(CF.CUSTID) CUSTID, td.ACCTNO,max(af.acctno) afacctno,
        max(CF.fullname) fullname ,max(CF.ADDRESS) ADDRESS,
        SUM(CASE WHEN TLTXCD in ('1610') AND td.TXCD = '0022' THEN NAMT ELSE 0 END) TONG_GUI,
        SUM(CASE WHEN TLTXCD IN ('1600','1610','1620') AND td.TXCD IN('0023') THEN NAMT ELSE 0 END) TONG_RUT,
        SUM(CASE WHEN TLTXCD IN ('1600','1610') AND td.TXCD = '0026' THEN NAMT ELSE 0 END) TONG_LAI
    FROM vw_tdtran_all td, apptx app,tdmast TDM, AFMAST AF, CFMAST CF
    WHERE td.txcd = app.txcd and app.apptype = 'TD'
        AND TD.ACCTNO = TDM.ACCTNO AND TDM.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID
        and TD.txdate > V_TXDATE
        AND td.TLTXCD IN ('1600','1610','1670','1620')
        AND td.TXCD IN('0022','0023','0026')
        AND tdm.deltd <> 'Y'
        GROUP BY td.acctno
)  tdr_to,
( -- Tong phat sinh tu TXDATE den ngay hien tai
    SELECT max(CF.CUSTODYCD) CUSTODYCD , max(CF.CUSTID) CUSTID, td.ACCTNO,max(af.acctno) afacctno,
        max(CF.fullname) fullname ,max(CF.ADDRESS) ADDRESS,
        SUM(CASE WHEN TLTXCD in ('1610') AND td.TXCD = '0022' THEN NAMT ELSE 0 END) TONG_GUI,
        SUM(CASE WHEN TLTXCD IN ('1600','1610','1620') AND td.TXCD IN('0023') THEN NAMT ELSE 0 END) TONG_RUT,
        SUM(CASE WHEN TLTXCD IN ('1600','1610') AND td.TXCD = '0026' THEN NAMT ELSE 0 END) TONG_LAI
    FROM vw_tdtran_all td, apptx app,tdmast TDM, AFMAST AF, CFMAST CF
    WHERE td.txcd = app.txcd and app.apptype = 'TD'
        AND TD.ACCTNO = TDM.ACCTNO AND TDM.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID
        and TD.txdate <= V_TXDATE
        AND td.TLTXCD IN ('1600','1610','1670','1620')
        AND td.TXCD IN('0022','0023','0026')
        AND tdm.deltd <> 'Y'
        GROUP BY td.acctno
)  tdr_cur, afmast af, cfmast cf


WHERE
    tdm.afacctno=af.acctno
    AND af.custid=cf.custid
    AND TDM.acctno = tdr_cur.acctno (+)
    AND TDM.acctno = tdr_cur.acctno (+)
    AND cf.custodycd LIKE V_STRCUSTODYCD
    AND af.acctno LIKE V_STRAFACCTNO
    AND tdm.acctno LIKE V_STRTDACCTNO
    AND tdr_cur.acctno=tdr_to.acctno(+)
    AND tdm.deltd <> 'Y'
ORDER BY cf.CUSTODYCD, af.acctno,tdm.ACCTNO
;



EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

