CREATE OR REPLACE PROCEDURE re0001 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_TRADEPLACE      IN      varchar2,
   PV_BORS          in  varchar2

 )
IS
--
-- created by Chaunh at 06/03/2013
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID           VARCHAR2 (4);


  -- V_CURRDATE               DATE;
   V_TRADEPLACE             varchar2(4);
   V_BORS                   varchar2(3);

BEGIN
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   IF (V_STROPTION = 'A') THEN
      V_STRBRID := '%';
   ELSE if (V_STROPTION = 'B') then
            select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
   END IF;
--
 --  SELECT TO_DATE(SY.VARVALUE, SYSTEMNUMS.C_DATE_FORMAT) INTO V_CURRDATE
   --FROM SYSVAR SY WHERE SY.VARNAME = 'CURRDATE' AND SY.GRNAME = 'SYSTEM';

   IF (PV_BORS <> 'ALL')
   THEN
      V_BORS := PV_BORS;
   ELSE
      V_BORS := '%';
   END IF;

    if PV_TRADEPLACE  <> 'ALL'
    then
        V_TRADEPLACE := PV_TRADEPLACE;
    else
        V_TRADEPLACE := '%';
    end if;

OPEN PV_REFCURSOR
  FOR
select c.fullname, a.*,f.*,
       round(a.kl/decode(f.T_kl,0,0.00001,f.T_kl) *100,2) ty_le_kl,
       round(a.sl/decode(f.T_sl,0,0.00001,f.T_sl) *100,2) ty_le_sl,
       round(a.sl_khop/decode(f.T_sl_khop,0,0.00001,f.T_sl_khop) *100,2) ty_le_sl_khop,
       round(a.kl_khop/decode(f.T_kl_khop,0,0.00001,f.T_kl_khop) *100,2) ty_le_kl_khop,
       round(a.gia_tri/decode(f.T_gia_tri,0,0.00001,f.T_gia_tri) *100,2) ty_le_gia_tri,
       round(a.phi_gd/decode(f.T_phi_gd,0,0.00001,f.T_phi_gd) *100,2) ty_le_phi_gd

from
(
select substr(re.reacctno,1,10) reacctno, count(1) sl,
       sum(od.orderqtty) kl,
       count(case when execamt <> 0 then 1 end) sl_khop,
       sum(case when execamt <> 0 then od.execqtty end) kl_khop,
       sum(od.execamt) gia_tri,
       sum(CASE WHEN od.execamt > 0 AND od.feeacr = 0 THEN ROUND(IOd.matchqtty * iod.matchprice * odtype.deffeerate / 100, 2)
            ELSE (CASE WHEN (od.execamt * od.feeacr) = 0 THEN 0
                       ELSE round(od.feeacr * iod.matchqtty * iod.matchprice / od.execamt,2)
                   END)
            END ) phi_gd
from vw_odmast_all od, reaflnk re , odtype , vw_iod_all iod, sbsecurities s1, sbsecurities s2
where od.afacctno = re.afacctno(+)
and odtype.actype = od.actype and od.deltd <> 'Y' and iod.deltd <> 'Y'
and iod.orgorderid = od.orderid
and iod.txdate <= to_date(T_DATE,'DD/MM/RRRR') and iod.txdate >= to_date(F_DATE,'DD/MM/RRRR')
and iod.txdate <= nvl(nvl(re.clstxdate,re.todate -1),'01-Jan-2020') and iod.txdate >= nvl(re.frdate, '01-Jan-2000')
and od.codeid = s1.codeid
and nvl(s1.refcodeid, s1.codeid) = s2.codeid
AND (substr(re.reacctno,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(re.reacctno,1,4))<> 0)
and s2.tradeplace like V_TRADEPLACE
and iod.bors like V_BORS
group by substr(re.reacctno,1,10)
) a, cfmast c,
(select count(1) T_SL, sum(od.orderqtty) T_KL, count(case when execamt <> 0 then 1 end) T_sl_khop,
        sum(case when execamt <> 0 then od.execqtty end) T_kl_khop,
        sum(od.execamt) T_gia_tri,
        sum(CASE WHEN od.execamt > 0 AND od.feeacr = 0 THEN ROUND(IOd.matchqtty * iod.matchprice * odtype.deffeerate / 100, 2)
            ELSE (CASE WHEN (od.execamt * od.feeacr) = 0 THEN 0
                       ELSE round(od.feeacr * iod.matchqtty * iod.matchprice / od.execamt,2)
                   END)
            END ) T_phi_gd
from vw_odmast_all od, vw_iod_all iod, odtype
where iod.orgorderid = od.orderid and odtype.actype = od.actype and od.deltd <> 'Y' and iod.deltd <> 'Y'
and iod.txdate <= to_date(T_DATE,'DD/MM/RRRR') and iod.txdate >= to_date(F_DATE,'DD/MM/RRRR')
) f
where a.reacctno = c.custid
;



EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/

