CREATE OR REPLACE PROCEDURE GL1001 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2
)
IS
--
-- PURPOSE: Bao cao Doanh so giao dich theo care by
--
-- MODIFICATION HISTORY
-- PERSON               DATE                COMMENTS
-- ---------------      -----------         ---------------------
-- TUNH                 14/06/2010          Tao moi

-- ---------   ------  -------------------------------------------

  v_FromDate date;
  v_ToDate date;
  v_UnitAmt number(20);
  v_UnitName varchar2(200);

BEGIN

v_FromDate:= to_date(F_DATE,'DD/MM/RRRR');
v_ToDate := to_date(T_DATE,'DD/MM/RRRR');
v_UnitAmt:=1000000000;
v_UnitName := 'T? d?ng';

-- Main report
OPEN PV_REFCURSOR FOR
select sub.careby careby_id, sub.grpname group_name, sub.PRGRPNAME PRGRPNAME,
       round(sub.HOSE_ONL_AMT/v_UnitAmt,3) HOSE_ONL_AMT,
       round(sub.HNX_ONL_AMT/v_UnitAmt,3) HNX_ONL_AMT,
       round(sub.UPCOM_ONL_AMT/v_UnitAmt,3) UPCOM_ONL_AMT,
       round(sub.HOSE_OFFL_AMT/v_UnitAmt,3) HOSE_OFFL_AMT,
       round(sub.HNX_OFFL_AMT/v_UnitAmt,3) HNX_OFFL_AMT,
       round(sub.UPCOM_OFFL_AMT/v_UnitAmt,3) UPCOM_OFFL_AMT,
       round(SUB_TOTAL/v_UnitAmt,3) SUB_TOTAL,
       ROUND( round(SUB_TOTAL/v_UnitAmt,3) / round(total/v_UnitAmt,3) * 100, 2)  Percent_of_Careby,
       round(total/v_UnitAmt,3) total,
       v_UnitAmt UnitAmt, v_UnitName UnitName
from
(   -- total
    select sum (od.execamt) total
    from vw_odmast_all od
    where od.execamt <> 0 and nvl(deltd,'N') <> 'Y'
        and od.exectype not in ('AB','AS','CB','CS')
        and od.txdate between v_FromDate and v_ToDate
        and deltd<>'Y'

) tt,
(   -- subtotal_careby
    select od.careby, g.grpname, A2.CDCONTENT PRGRPNAME,
        sum(HOSE_ONL_AMT) HOSE_ONL_AMT, sum(HNX_ONL_AMT) HNX_ONL_AMT, sum(UPCOM_ONL_AMT) UPCOM_ONL_AMT,
        sum(HOSE_OFFL_AMT) HOSE_OFFL_AMT, sum(HNX_OFFL_AMT) HNX_OFFL_AMT, sum(UPCOM_OFFL_AMT) UPCOM_OFFL_AMT,
        sum(HOSE_ONL_AMT + HNX_ONL_AMT + UPCOM_ONL_AMT + HOSE_OFFL_AMT + HNX_OFFL_AMT + UPCOM_OFFL_AMT) SUB_TOTAL
    from
    (
        select af.careby, --cf.careby
            (case when od.via = 'O' AND sb.tradeplace ='001' then od.execamt else 0 end) HOSE_ONL_AMT,
            (case when od.via = 'O' AND sb.tradeplace ='002' then od.execamt else 0 end) HNX_ONL_AMT,
            (case when od.via = 'O' AND sb.tradeplace ='005' then od.execamt else 0 end) UPCOM_ONL_AMT,
            (case when od.via <> 'O' AND sb.tradeplace ='001' then od.execamt else 0 end) HOSE_OFFL_AMT,
            (case when od.via <> 'O' AND sb.tradeplace ='002' then od.execamt else 0 end) HNX_OFFL_AMT,
            (case when od.via <> 'O' AND sb.tradeplace ='005' then od.execamt else 0 end) UPCOM_OFFL_AMT
        from vw_odmast_all od, cfmast cf, afmast af, sbsecurities sb, allcode a1
        where od.afacctno = af.acctno
            and cf.custid = af.custid
            and od.execamt <> 0
            and od.exectype not in ('AB','AS','CB','CS')
            AND od.CODEID = sb.codeid
            AND sb.tradeplace = a1.cdval
            AND a1.cdtype = 'OD'
            AND a1.cdname = 'TRADEPLACE'
            AND af.careby NOT IN ('xxxx')
            and od.txdate between v_FromDate and v_ToDate

        UNION ALL

        select 'xxxx' careby, -- cf.careby, Xu ly rieng cho TH : 0065 Care by Thang.NH dua nhom nay ve 53   0027    CARED BY VIPTEAM
            (case when od.via = 'O' AND sb.tradeplace ='001' then od.execamt else 0 end) HOSE_ONL_AMT,
            (case when od.via = 'O' AND sb.tradeplace ='002' then od.execamt else 0 end) HNX_ONL_AMT,
            (case when od.via = 'O' AND sb.tradeplace ='005' then od.execamt else 0 end) UPCOM_ONL_AMT,
            (case when od.via <> 'O' AND sb.tradeplace ='001' then od.execamt else 0 end) HOSE_OFFL_AMT,
            (case when od.via <> 'O' AND sb.tradeplace ='002' then od.execamt else 0 end) HNX_OFFL_AMT,
            (case when od.via <> 'O' AND sb.tradeplace ='005' then od.execamt else 0 end) UPCOM_OFFL_AMT
        from vw_odmast_all od, cfmast cf, afmast af, sbsecurities sb, allcode a1
        where od.afacctno = af.acctno
            and cf.custid = af.custid
            and od.execamt <> 0
            and od.exectype not in ('AB','AS','CB','CS')
            AND od.CODEID = sb.codeid
            AND sb.tradeplace = a1.cdval
            AND a1.cdtype = 'OD'
            AND a1.cdname = 'TRADEPLACE'
            AND af.careby IN ('xxxx')
            and od.txdate between v_FromDate and v_ToDate
    ) od, tlgroups g, allcode a2
    where od.careby = g.grpid
          AND g.prgrpid = a2.cdval
          AND A2.CDTYPE = 'SA'
          AND a2.cdname = 'PRGRPID'
    group by od.careby, g.grpname, A2.CDCONTENT
) sub
order by sub_total desc;


EXCEPTION
   WHEN OTHERS THEN
      RETURN;
END;
/

