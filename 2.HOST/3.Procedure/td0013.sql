CREATE OR REPLACE PROCEDURE td0013 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD       IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2
   )
IS

   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_FRDATE         DATE;
   V_TODATE         DATE;
   V_CURRDATE         DATE;
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



   V_FRDATE := to_date(F_DATE,'dd/mm/RRRR');
   V_TODATE := to_date(T_DATE,'dd/mm/RRRR');

SELECT TO_DATE(VARVALUE,'dd/mm/RRRR') INTO V_CURRDATE FROM SYSVAR WHERE VARNAME = 'CURRDATE';


   -- GET REPORT'S DATA

OPEN PV_REFCURSOR FOR

SELECT tdr_to.CUSTODYCD, tdr_to.CUSTID, tdr_to.ACCTNO AFACCTNO, tdr_to.fullname, tdr_to.ADDRESS,
TD.TLTXCD ,TD.TXDATE, TD.TXNUM,TD.ACCTNO,
case when txtype = 'D' then namt else 0 end TD_DEBIT, case when txtype = 'C' then namt else 0 end TD_CREDIT ,
TD.TXCD,
tdr_to.TONG_GUI, tdr_to.TONG_RUT, tdr_to.TONG_LAI,
TDB.balance + NVL(tdr_cur.TONG_RUT,0) - NVL(tdr_cur.TONG_GUI,0) DAU_KY,
TDB.balance + NVL(tdr_cur.TONG_RUT,0) - NVL(tdr_cur.TONG_GUI,0) - tdr_to.TONG_RUT + tdr_to.TONG_GUI CUOI_KY,
TRDESC
FROM vw_tdtran_all TD, APPTX APP, vw_tdmast_all TDM , (SELECT AFACCTNO,SUM(BALANCE) BALANCE FROM TDMAST GROUP BY AFACCTNO) TDB ,

( -- Tong phat sinh trong FRDATE den TODATE
    SELECT CF.CUSTODYCD, CF.CUSTID, AF.ACCTNO,CF.fullname, CF.ADDRESS, SUM(CASE WHEN TLTXCD in ('1670','1610') AND td.TXCD = '0022' THEN NAMT ELSE 0 END) TONG_GUI,
        SUM(CASE WHEN TLTXCD IN ('1600','1610','1620') AND td.TXCD IN('0023') THEN NAMT ELSE 0 END) TONG_RUT,
        SUM(CASE WHEN TLTXCD IN ('1600','1610') AND td.TXCD = '0026' THEN NAMT ELSE 0 END) TONG_LAI
    FROM vw_tdtran_all td, apptx app,vw_tdmast_all TDM, AFMAST AF, CFMAST CF
    WHERE td.txcd = app.txcd and app.apptype = 'TD'
        AND TD.ACCTNO = TDM.ACCTNO AND TDM.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID
        and TD.txdate >= V_FRDATE AND TD.txdate <= V_TODATE
        AND td.TLTXCD IN ('1600','1610','1670','1620')
        AND td.TXCD IN('0022','0023','0026')
    GROUP BY CF.CUSTODYCD, CF.CUSTID, AF.ACCTNO,CF.fullname, CF.ADDRESS
)  tdr_to
,( -- Tong phat sinh tu FRDATE den ngay hien tai
    SELECT CF.CUSTODYCD, CF.CUSTID, AF.ACCTNO,CF.fullname, CF.ADDRESS, SUM(CASE WHEN TLTXCD in ('1670','1610') AND td.TXCD = '0022' THEN NAMT ELSE 0 END) TONG_GUI,
        SUM(CASE WHEN TLTXCD IN ('1600','1610','1620') AND td.TXCD IN('0023') THEN NAMT ELSE 0 END) TONG_RUT,
        SUM(CASE WHEN TLTXCD IN ('1600','1610') AND td.TXCD = '0026' THEN NAMT ELSE 0 END) TONG_LAI
    FROM vw_tdtran_all td, apptx app,vw_tdmast_all TDM, AFMAST AF, CFMAST CF
    WHERE td.txcd = app.txcd and app.apptype = 'TD'
        AND TD.ACCTNO = TDM.ACCTNO AND TDM.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID
        and TD.txdate >= V_FRDATE AND TD.txdate <= V_CURRDATE
        AND td.TLTXCD IN ('1600','1610','1670','1620')
        AND td.TXCD IN('0022','0023','0026')
    GROUP BY CF.CUSTODYCD, CF.CUSTID, AF.ACCTNO,CF.fullname, CF.ADDRESS

)  tdr_cur


WHERE TD.ACCTNO = TDM.ACCTNO AND TDM.AFACCTNO = TDB.AFACCTNO
    and tdb.afacctno = tdr_to.acctno (+)
    and tdr_to.ACCTNO = tdr_cur.ACCTNO (+)
    AND td.txcd = app.txcd and app.apptype = 'TD'
    and TD.txdate >= V_FRDATE AND TD.txdate <= V_TODATE
    AND tdr_to.custodycd LIKE V_STRCUSTODYCD
    AND tdr_to.acctno LIKE V_STRAFACCTNO
    AND td.TLTXCD IN ('1600','1610','1670','1620')
    AND td.TXCD IN('0022','0023','0026')
AND TD.DELTD <> 'Y' AND namt > 0
ORDER BY tdr_to.CUSTODYCD, tdr_to.ACCTNO, TD.ACCTNO,TD.TXDATE, TD.TXNUM
;



EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

