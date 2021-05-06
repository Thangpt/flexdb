CREATE OR REPLACE PROCEDURE CI0020 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2
)
IS

--
-- PURPOSE:
-- BAO CAO SO DU TIEN MAT - TAI KHOAN KHONG LUU KY ( <> 017% )
-- MODIFICATION HISTORY
-- PERSON               DATE                COMMENTS
-- ---------------      -----------         ---------------------
-- HUYNH.ND             20/09/2010          Chinh sua tu CI0018 dong 97
-- ---------   ------  -------------------------------------------

  V_STROPTION            VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
  V_STRBRID              VARCHAR2 (4);

  V_IN_DATE              DATE;
  V_CURR_DATE            DATE;


BEGIN

    V_STROPTION := OPT;

     IF V_STROPTION = 'A' THEN     -- TOAN HE THONG
      V_STRBRID := '%';
   ELSIF V_STROPTION = 'B' THEN
      V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
   ELSE
      V_STRBRID := BRID;
   END IF;

   SELECT  to_date(VARVALUE,'DD/MM/RRRR') INTO V_CURR_DATE FROM SYSVAR WHERE VARNAME = 'CURRDATE' AND GRNAME = 'SYSTEM';
   V_IN_DATE := TO_DATE(I_DATE,'DD/MM/RRRR');


-- Main report
OPEN PV_REFCURSOR FOR

SELECT MAX(V_IN_DATE) IN_DATE, CF.CUSTODYCD, CF.FULLNAME,
    ROUND(SUM(CI_CURR.BALANCE - NVL(CI_TR.TR_BALANCE,0))) BALANCE,
    ROUND(sum( NVL(sM.AMT,0))) NETTING,
    ROUND(sum( NVL(RM.AMT,0)))  RECEIVING,
    ROUND(SUM(CI_CURR.EMKAMT - NVL(CI_TR.TR_EMKAMT,0))) EMKAMT
FROM CIMAST CI_CURR, AFMAST AF, CFMAST CF,
    ( SELECT TR.ACCTNO,
            ROUND(SUM(CASE WHEN TX.FIELD = 'BALANCE' THEN (CASE WHEN TX.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END)
                        ELSE 0 END)) TR_BALANCE,

            ROUND(SUM(CASE WHEN TX.FIELD = 'EMKAMT' THEN (CASE WHEN TX.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END)
                        ELSE 0 END)) TR_EMKAMT

        FROM VW_CITRAN_ALL TR, APPTX TX
        WHERE TR.TXCD = TX.TXCD
            AND TX.APPTYPE = 'CI'
            AND TX.TXTYPE IN ('C','D')
            AND TX.FIELD IN ('BALANCE','NETTING','RECEIVING','EMKAMT')
            AND NVL(TR.BKDATE,TR.TXDATE) >  to_date( V_IN_DATE,'DD/MM/YYYY')
        GROUP BY TR.ACCTNO
    ) CI_TR,
    (
    select afacctno ,sum(amt)amt from vw_stschd_all
    where txdate >= get_t_date( to_date( V_IN_DATE,'DD/MM/YYYY'),3)
    AND TXDATE <= TO_DATE(V_IN_DATE,'DD/MM/YYYY')
    AND DUETYPE='RM'
    group by afacctno
    ) RM,
   (
    SELECT afacctno ,sum(amt)amt FROM VW_STSCHD_ALL
    WHERE TXDATE >= GET_T_DATE(to_date( V_IN_DATE,'DD/MM/YYYY'),3)
    AND TXDATE <= TO_DATE(V_IN_DATE,'DD/MM/YYYY')
    AND DUETYPE='RS'
    group by afacctno
    )SM,
    (   SELECT AFACCTNO, sum(EXECAMT) EXECAMT
        FROM ODMAST
        WHERE TXDATE = V_CURR_DATE and exectype = 'NB'
        group by AFACCTNO
    ) OD_TR

WHERE AF.ACCTNO = CI_CURR.ACCTNO
    AND AF.CUSTID = CF.CUSTID
    AND CI_CURR.ACCTNO = CI_TR.ACCTNO(+)
    AND CI_CURR.ACCTNO = OD_TR.AFACCTNO(+)
    AND CI_CURR.ACCTNO = RM.AFACCTNO(+)
    AND CI_CURR.ACCTNO = SM.AFACCTNO(+)
    AND(
          ROUND(CI_CURR.BALANCE - NVL(CI_TR.TR_BALANCE,0)) <> 0 OR
          ROUND(CI_CURR.EMKAMT - NVL(CI_TR.TR_EMKAMT,0)) <> 0 OR
          ROUND( NVL(RM.AMT,0)) <> 0 OR
          ROUND( NVL(SM.AMT,0)) <> 0
       )
      and cf.custatcom='N'
GROUP BY CF.CUSTODYCD, CF.FULLNAME
order by  CF.CUSTODYCD
;
EXCEPTION
   WHEN OTHERS THEN
      RETURN;
END;
/

