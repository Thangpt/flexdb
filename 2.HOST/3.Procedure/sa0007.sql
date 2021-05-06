CREATE OR REPLACE PROCEDURE sa0007 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   INMONTH        IN       VARCHAR2

   )
IS
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    V_F_DATE    DATE;
    V_T_DATE    DATE;
    V_PLSENT    VARCHAR2(2000);
    V_INMONTH   VARCHAR2(2);
    V_INYEAR    VARCHAR2(4);


BEGIN

    V_STROPTION := upper(OPT);
    V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;
    -- GET REPORT'S PARAMETERS
    IF TO_NUMBER(SUBSTR(INMONTH,1,2)) <= 12 THEN
        V_F_DATE := TO_DATE('01/' || SUBSTR(INMONTH,1,2) || '/' || SUBSTR(INMONTH,3,4),'DD/MM/YYYY');
    ELSE
        V_F_DATE := TO_DATE('31/12/9999','DD/MM/YYYY');
    END IF;
    V_T_DATE := LAST_DAY(V_F_DATE);
    V_INMONTH := SUBSTR(INMONTH,1,2);
    V_INYEAR :=  SUBSTR(INMONTH,3,4);



    -- GET REPORT'S DATA
    OPEN PV_REFCURSOR
    FOR
   select s.*, main.*,od.*, V_INMONTH mon, V_INYEAR yea, market.*, clsamt
           --thi phan MSBS
    ,case when market.HNX_value is null or market.HNX_value = 0 then 0 else round(MSBS_HNX/market.HNX_value * 100, 2) end  thiphan_hnx
    ,case when market.HOSE_value is null or market.HOSE_value = 0 then 0 else round(MSBS_HOSE/market.HOSE_value * 100, 2) end thiphan_HOSE
    ,case when market.HNX_value is null or market.HOSE_value is null or market.HNX_value + market.HOSE_value = 0 then 0 else round((MSBS_HNX + MSBS_HOSE)/(market.HNX_value + market.HOSE_value)  * 100, 2) end thiphan_TT
    --ti le dat lenh qua cac kenh
    ,case when sllenh_TT = 0 then 0 else round(sllenh_ol/sllenh_TT * 100,2) end tyle_lenh_ol
    ,case when sllenh_TT = 0 then 0 else round(sllenh_mobile/sllenh_TT * 100,2) end tyle_lenh_Mobile
    ,case when sllenh_TT = 0 then 0 else round(sllenh_home/sllenh_TT * 100,2) end tyle_lenh_Home
    ,case when sllenh_TT = 0 then 0 else round(sllenh_Tl/sllenh_TT * 100,2) end tyle_lenh_CALL
    ,case when sllenh_TT = 0 then 0 else round(sllenh_san/sllenh_TT * 100,2) end tyle_lenh_san
    --gia tri giao dich san lam tron 1 ty
    ,round(market.HNX_value /1000000000,9) GTGD_HNX
    ,round(market.HOSE_value /1000000000,9) GTGD_HOSE
from
(
    select nvl(a.txdate, b.opndate) thisdate, a.*, b.*
    from
        (
           select
               od.txdate,
               round(sum(case when sb.tradeplace = '002' and substr(cf.custodycd, 4,1) <> 'P' then nvl(od.execamt,0) else 0 end) / 1000000000,9) HNX,
               round(sum(case when sb.tradeplace = '001' and substr(cf.custodycd, 4,1) <> 'P' then nvl(od.execamt,0) else 0 end)/ 1000000000,9) HOSE,
               round(sum(case when sb.tradeplace = '002' and substr(cf.custodycd, 4,1) = 'P' then nvl(od.execamt,0) else 0 end)/ 1000000000,9) P_HNX,
               round(sum(case when sb.tradeplace = '001' and substr(cf.custodycd, 4,1) = 'P' then nvl(od.execamt,0) else 0 end)/ 1000000000,9) P_HOSE,
               sum(case when sb.tradeplace = '002'  then nvl(od.execamt,0.000000001) else 0.000000001 end) MSBS_HNX,
               sum(case when sb.tradeplace = '001'  then nvl(od.execamt,0.000000001) else 0.000000001 end) MSBS_HOSE,
               round(sum(nvl(od.feeacr,0)) / 1000000,6) phi,
               sum(case when od.via = 'O' and od.exectype not in ('CB','CS','AB','AS') then 1 else 0 end ) sllenh_ol,
               sum(case when od.via = 'H' and od.exectype not in ('CB','CS','AB','AS') then 1 else 0 end ) sllenh_home,
               sum(case when od.via = 'M' and od.exectype not in ('CB','CS','AB','AS') then 1 else 0 end ) sllenh_mobile,
               sum(case when od.via = 'T' and od.exectype not in ('CB','CS','AB','AS') then 1 else 0 end ) sllenh_Tl,
               sum(case when od.via not in ('O','H','M','T') and od.exectype not in ('CB','CS','AB','AS')  then 1 else 0 end ) sllenh_san,
               sum(case when od.exectype not in ('CB','CS','AB','AS')  then 1 else 0 end ) sllenh_TT,
               sum(case when od.via = 'O' then od.execamt else 0 end ) GT_Ol,
               sum(case when od.via = 'H' then od.execamt else 0 end ) GT_home,
               sum(case when od.via = 'M' then od.execamt else 0 end ) GT_mobile,
               sum(case when od.via = 'T' then od.execamt else 0 end ) GT_Tl,
               sum(case when od.via not in ('O','H','M','T') then od.execamt else 0 end ) GT_Fl
           from
           (select * from odmast union all select * from odmasthist) od
           , sbsecurities sb, cfmast cf, afmast af
           where sb.codeid = od.codeid
           and cf.custid = af.custid and af.acctno = od.afacctno --and substr(cf.custodycd, 4,1) <> 'P'
           AND (substr(cf.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(cf.custid,1,4))<> 0)
           and od.deltd <> 'Y' --and od.execamt <> 0
           group by od.txdate
       )a
       full join
       (
            select sum(case when mr = 'Y' then 1 else 0 end) tk_MR
            , count(custid) tk_thuong
            , opndate
            FROM
            (
            select
            max( case when mr.mrtype = 'T' then 'Y' else ' ' end  ) mr
            , cf.opndate
            , cf.custid
            from afmast a, aftype af, mrtype mr, cfmast cf
            where a.actype = af.actype and af.mrtype = mr.actype and cf.custid = a.custid
            AND (substr(cf.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(cf.custid,1,4))<> 0)
            group by cf.opndate, cf.custid
            )
            group by opndate
       ) b
       on b.opndate = a.txdate
) main
,
(select * from sbcldr s where cldrtype = '000' and s.holiday = 'N' and sbdate between V_F_DATE and V_T_DATE
) s
,(
    select nvl(count(distinct afacctno),0) sl_tk_hd , txdate from
        (select distinct afacctno, txdate from odmast where deltd <> 'Y' AND (substr(afacctno,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(afacctno,1,4))<> 0)
        union all
        select distinct afacctno, txdate from odmasthist where deltd <> 'Y' AND (substr(afacctno,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(afacctno,1,4))<> 0)
       ) i
    group by txdate

) od
,(
select tradingdate,
    sum(case when marketcode = 'HNX' then to_number(nvl(totaltrade,0)) else 0 end) HNX_trade,
    sum(case when marketcode = 'HNX' then to_number(nvl(totalvolume,0)) else 0 end) HNX_volume,
    sum(case when marketcode = 'HNX' then to_number(nvL(totalvalue,0)) else 0 end) HNX_value,
    sum(case when marketcode = 'HOSE' then to_number(nvl(totaltrade,0)) else 0 end) HOSE_trade,
    sum(case when marketcode = 'HOSE' then to_number(nvl(totalvolume,0)) else 0 end) HOSE_volume,
    sum(case when marketcode = 'HOSE' then to_number(nvl(totalvalue,0)) else 0 end) HOSE_value,
    sum(case when marketcode = 'UPCOM' then to_number(nvl(totaltrade,0)) else 0 end) UPCOM_trade,
    sum(case when marketcode = 'UPCOM' then to_number(nvl(totalvolume,0)) else 0 end) UPCOM_volume,
    sum(case when marketcode = 'UPCOM' then to_number(nvl(totalvalue,0)) else 0 end) UPCOM_value
from marketinforlog where  tradingdate between V_F_DATE and V_T_DATE
group by tradingdate
) market
,(
 select ngay_dong,count(*) clsamt from
    (
        select cf.fullname,cf.custodycd,  max(tl.txdate) ngay_dong  from vw_tllog_all tl, cfmast cf
        where tltxcd = '0059' and cf.custid = tl.msgacct and tl.deltd <> 'Y'
        and tl.txdate between V_F_DATE and V_T_DATE
        group by cf.fullname, cf.custodycd
    ) CF
    left join
    (
        select cf.fullname,cf.custodycd,  tl.txdate  from vw_tllog_all tl, cfmast cf
        where tltxcd = '0067' and cf.custid = tl.msgacct and tl.deltd <> 'Y'
        and tl.txdate between V_F_DATE and V_T_DATE
    ) LOG
    on CF.custodycd = LOG.custodycd and CF.ngay_dong < LOG.txdate
    where LOG.custodycd is null
    group by ngay_dong
) CLSED
where s.sbdate = thisdate(+)
and s.sbdate = od.txdate (+)
and  s.sbdate = market.tradingdate (+)
and s.sbdate = CLSED.ngay_dong (+)
order by s.sbdate

;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

