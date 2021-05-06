CREATE OR REPLACE PROCEDURE gl1008 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2
)
IS
--
-- PURPOSE: BAO CAO T?NG H?P DOANH S? NHOM KHACH HANG (VIP TEAM)
--
-- MODIFICATION HISTORY
-- PERSON               DATE                COMMENTS
-- ---------------      -----------         ---------------------
-- TRUONGLD                 14/06/2010          Tao moi

-- ---------   ------  -------------------------------------------

  v_FromDate date;
  v_ToDate date;
  v_UnitAmt number(20);
  v_UnitName varchar2(200);

BEGIN

v_FromDate:= to_date(F_DATE,'DD/MM/RRRR');
v_ToDate := to_date(T_DATE,'DD/MM/RRRR');
v_UnitAmt:=1000000;
v_UnitName := 'Tri?u d?ng';

-- I    Ca nhan
-- B    T? ch?c

-- Main report
OPEN PV_REFCURSOR FOR

/*SELECT '20/07/2010' TXDATE,  0 B_F_AMT, 0 I_F_AMT, 0 B_C_AMT, 0 I_C_AMT, 0 VIP_TEAM_TOTAL, 0 FEEACR, 0 TOTAL
FROM DUAL;*/


SELECT OD.TXDATE,
       ROUND(NVL(OD.B_F_AMT,0)/v_UnitAmt,3) B_F_AMT,
       ROUND(NVL(OD.I_F_AMT,0)/v_UnitAmt,3) I_F_AMT,
       ROUND((NVL(OD.B_C_AMT1,0) + NVL(OD.B_C_AMT2,0))/v_UnitAmt,3) B_C_AMT,
       ROUND(NVL(OD.I_C_AMT,0)/v_UnitAmt,3) I_C_AMT,
       ROUND((NVL(OD.B_F_AMT,0) + NVL(OD.I_F_AMT,0) + NVL(OD.B_C_AMT1,0) + NVL(OD.B_C_AMT2,0) + NVL(OD.I_C_AMT,0))/v_UnitAmt,3) VIP_TEAM_TOTAL,
       ROUND(NVL(OD.FEEACR,0)/v_UnitAmt,3) FEEACR,
       ROUND(NVL(TT.TOTAL,0)/v_UnitAmt,3) TOTAL,
       v_UnitAmt UnitAmt, v_UnitName UnitName
FROM
  (
       SELECT OD.TXDATE, SUM(OD.EXECAMT) TOTAL
       FROM VW_ODMAST_ALL OD, sbsecurities sb
       WHERE OD.DELTD <> 'Y'
             AND od.CODEID=sb.codeid
             AND OD.EXECQTTY > 0
             AND sb.tradeplace  <> '005'
             AND sb.sectype = '001'
             AND OD.TXDATE BETWEEN v_FromDate AND v_ToDate
       GROUP BY OD.TXDATE
  )TT
INNER JOIN
 (
       SELECT OD.TXDATE,
              SUM(CASE WHEN CF.CUSTTYPE = 'B' AND CF.CUSTODYCD NOT LIKE '017C%' AND CF.CUSTODYCD NOT IN ('HSBB018888', 'BIDB000016','VCHB608888') THEN OD.EXECAMT ELSE 0 END) B_F_AMT,
              SUM(CASE WHEN CF.CUSTTYPE = 'I' AND CF.CUSTODYCD NOT LIKE '017C%' AND CF.CUSTODYCD NOT IN ('HSBB018888', 'BIDB000016','VCHB608888') THEN OD.EXECAMT ELSE 0 END) I_F_AMT,
              SUM(CASE WHEN CF.CUSTTYPE = 'B' AND CF.CUSTODYCD LIKE '017C%' AND CF.CUSTODYCD NOT IN ('HSBB018888', 'BIDB000016','VCHB608888') THEN OD.EXECAMT ELSE 0 END) B_C_AMT1,
              SUM(CASE WHEN CF.CUSTTYPE = 'B' AND CF.CUSTODYCD IN ('HSBB018888', 'BIDB000016','VCHB608888') THEN OD.EXECAMT ELSE 0 END) B_C_AMT2,
              SUM(CASE WHEN CF.CUSTTYPE = 'I' AND CF.CUSTODYCD LIKE '017C%' AND CF.CUSTODYCD NOT IN ('HSBB018888', 'BIDB000016','VCHB608888') THEN OD.EXECAMT ELSE 0 END) I_C_AMT,
              SUM(OD.FEEACR) FEEACR
       FROM VW_ODMAST_ALL OD, CFMAST CF, AFMAST AF
       WHERE CF.CUSTID=AF.CUSTID
             AND AF.ACCTNO=OD.AFACCTNO
             AND OD.DELTD <>'Y'
             AND OD.EXECQTTY > 0
             AND AF.CAREBY IN ('0070','0071','0065','0027')
             AND OD.TXDATE BETWEEN v_FromDate AND v_ToDate
       GROUP BY OD.TXDATE

 )OD ON TT.TXDATE=OD.TXDATE
 ORDER BY OD.TXDATE;

EXCEPTION
   WHEN OTHERS THEN
      RETURN;
END;



-- End of DDL Script for Procedure HOST.GL1008
/

