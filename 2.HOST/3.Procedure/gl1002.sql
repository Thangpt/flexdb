CREATE OR REPLACE PROCEDURE GL1002 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   TLID           IN       VARCHAR2,
   PV_TLID        IN       VARCHAR2
)
IS
--
-- PURPOSE: Bao cao Doanh so giao dich theo USER
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
  v_tlid     varchar2(100);
  v_strtLID  varchar2(100);
  v_BRID     varchar2(100);

BEGIN

v_FromDate:= to_date(F_DATE,'DD/MM/RRRR');
v_ToDate := to_date(T_DATE,'DD/MM/RRRR');
v_UnitAmt:=1000000;
v_UnitName := 'Tri?u d?ng';

v_strtLID := PV_TLID;

SELECT NVL(BRID,'') INTO v_BRID FROM TLPROFILES WHERE TLID=v_strtLID;

IF v_BRID='0001' THEN
   v_BRID:='%';
ELSE
   v_BRID:=v_BRID;
END IF;

IF TLID <> 'ALL' THEN
   v_tlid := TLID;
ELSE
   v_tlid := '%';
END IF;

-- Main report
OPEN PV_REFCURSOR FOR
     select sub.careby careby_id, sub.tlid, sub.grpname group_name, sub.PRGRPNAME PRGRPNAME, sub.fullname,
            round(sub.HOSE_ONL_AMT/v_UnitAmt,3) HOSE_ONL_AMT,
            round(sub.HNX_ONL_AMT/v_UnitAmt,3) HNX_ONL_AMT,
            round(sub.UPCOM_ONL_AMT/v_UnitAmt,3) UPCOM_ONL_AMT,
            round(sub.HOSE_OFFL_AMT/v_UnitAmt,3) HOSE_OFFL_AMT,
            round(sub.HNX_OFFL_AMT/v_UnitAmt,3) HNX_OFFL_AMT,
            round(sub.UPCOM_OFFL_AMT/v_UnitAmt,3) UPCOM_OFFL_AMT,
            round(SUB_TOTAL/v_UnitAmt,3) SUB_TOTAL,
            round(TT.TOTAL/v_UnitAmt,3) TOTAL,
            v_UnitAmt UnitAmt, v_UnitName UnitName
     FROM
      (   -- total
        select sum (od.execamt) total
        from vw_odmast_all od
        where od.execamt <> 0 and nvl(deltd,'N') <> 'Y'
            and od.exectype not in ('AB','AS','CB','CS')
            and od.txdate between v_FromDate and v_ToDate
            and deltd<>'Y'
      ) tt,
      (   -- subtotal_careby
          select od.careby, od.tlid, g.grpname, A2.CDCONTENT PRGRPNAME, nvl(tl.tlfullname, tl.tlname) Fullname,
              sum(HOSE_ONL_AMT) HOSE_ONL_AMT, sum(HNX_ONL_AMT) HNX_ONL_AMT, sum(UPCOM_ONL_AMT) UPCOM_ONL_AMT,
              sum(HOSE_OFFL_AMT) HOSE_OFFL_AMT, sum(HNX_OFFL_AMT) HNX_OFFL_AMT, sum(UPCOM_OFFL_AMT) UPCOM_OFFL_AMT,
              sum(HOSE_ONL_AMT + HNX_ONL_AMT + UPCOM_ONL_AMT + HOSE_OFFL_AMT + HNX_OFFL_AMT + UPCOM_OFFL_AMT) SUB_TOTAL
              --SUM(OD.EXECAMT) SUB_TOTAL
          from
          (
              select af.careby, af.tlid,
                  (case when od.via = 'O' AND sb.tradeplace ='001' then od.execamt else 0 end) HOSE_ONL_AMT,
                  (case when od.via = 'O' AND sb.tradeplace ='002' then od.execamt else 0 end) HNX_ONL_AMT,
                  (case when od.via = 'O' AND sb.tradeplace ='005' then od.execamt else 0 end) UPCOM_ONL_AMT,
                  (case when od.via <> 'O' AND sb.tradeplace ='001' then od.execamt else 0 end) HOSE_OFFL_AMT,
                  (case when od.via <> 'O' AND sb.tradeplace ='002' then od.execamt else 0 end) HNX_OFFL_AMT,
                  (case when od.via <> 'O' AND sb.tradeplace ='005' then od.execamt else 0 end) UPCOM_OFFL_AMT,
                  OD.EXECAMT
              from vw_odmast_all od, cfmast cf, afmast af, sbsecurities sb, allcode a1
              where od.afacctno = af.acctno
                  and cf.custid = af.custid
                  and od.execamt <> 0
                  and od.exectype not in ('AB','AS','CB','CS')
                  AND od.CODEID = sb.codeid
                  AND sb.tradeplace = a1.cdval
                  AND a1.cdtype = 'OD'
                  AND a1.cdname = 'TRADEPLACE'
                  AND af.careby NOT IN ('0065')
                  AND af.tlid LIKE v_tlid
                  and od.txdate between v_FromDate and v_ToDate

              UNION ALL

              select '0027' careby, af.tlid, -- cf.careby, Xu ly rieng cho TH : 0065 Care by Thang.NH dua nhom nay ve 53    0027    CARED BY VIPTEAM
                  (case when od.via = 'O' AND sb.tradeplace ='001' then od.execamt else 0 end) HOSE_ONL_AMT,
                  (case when od.via = 'O' AND sb.tradeplace ='002' then od.execamt else 0 end) HNX_ONL_AMT,
                  (case when od.via = 'O' AND sb.tradeplace ='005' then od.execamt else 0 end) UPCOM_ONL_AMT,
                  (case when od.via <> 'O' AND sb.tradeplace ='001' then od.execamt else 0 end) HOSE_OFFL_AMT,
                  (case when od.via <> 'O' AND sb.tradeplace ='002' then od.execamt else 0 end) HNX_OFFL_AMT,
                  (case when od.via <> 'O' AND sb.tradeplace ='005' then od.execamt else 0 end) UPCOM_OFFL_AMT,
                  OD.EXECAMT
              from vw_odmast_all od, cfmast cf, afmast af, sbsecurities sb, allcode a1
              where od.afacctno = af.acctno
                  and cf.custid = af.custid
                  and od.execamt <> 0
                  and od.exectype not in ('AB','AS','CB','CS')
                  AND od.CODEID = sb.codeid
                  AND sb.tradeplace = a1.cdval
                  AND a1.cdtype = 'OD'
                  AND a1.cdname = 'TRADEPLACE'
                  AND af.careby IN ('0065')
                  AND af.tlid LIKE v_tlid
                  and od.txdate between v_FromDate and v_ToDate
          ) od, tlgroups g, allcode a2, tlprofiles tl
          where od.careby = g.grpid AND od.tlid = tl.tlid
                AND g.prgrpid = a2.cdval
                AND A2.CDTYPE = 'SA'
                AND a2.cdname = 'PRGRPID'
                AND TL.BRID LIKE v_BRID
          group by od.careby, od.tlid, g.grpname, A2.CDCONTENT, nvl(tl.tlfullname, tl.tlname)
      ) sub
order by sub_total desc;

EXCEPTION
   WHEN OTHERS THEN
      RETURN;
END;
/

