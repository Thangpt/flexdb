CREATE OR REPLACE PROCEDURE re0101 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_TLID           IN       varchar2,
   PV_EXECTYPE       IN       varchar2,
   PV_VIA            IN       varchar2

 )
IS
--
-- created by Chaunh at 06/03/2013
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID           VARCHAR2 (4);

   V_TLID            varchar2(4);
   V_EXECTYPE        varchar2(4);
   V_VIA             varchar2(4);
   VF_DATE          date;
   VT_DATE          date;

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

   VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
   VT_DATE := to_date(T_DATE,'DD/MM/RRRR');

   IF (PV_VIA <> 'ALL')
   THEN
      V_VIA := PV_VIA;
   ELSE
      V_VIA := '%';
   END IF;

   IF (PV_TLID <> 'ALL')
   THEN
      V_TLID := PV_TLID;
   ELSE
      V_TLID := '%';
   END IF;

    if PV_EXECTYPE  <> 'ALL'
    then
        V_EXECTYPE := PV_EXECTYPE;
    else
        V_EXECTYPE := '%';
    end if;

OPEN PV_REFCURSOR
  FOR
select tp.tlfullname,od.tlid, a.cdcontent,
            case when instr(od.exectype,'S') <> 0 then 'Sell' else 'Buy' end BorS,
           sum(case when od.exectype in ('AB','AS','CB','CS') then 0 else 1 end ) sllenhdat, --khong tinh lenh huy sua
           sum(case when od.exectype in ('AB','AS','CB','CS') then 0 else od.orderqtty end) kllenhdat, --khong tinh lenh huy
           sum(case when od.execamt <>0 then 1 else 0 end ) sl_khop,
           sum(case when execamt <> 0 then od.execqtty else 0 end) kl_khop,
           sum(od.execamt) gia_tri_khop,
           sum(od.feeacr ) phi_gd
    from vw_odmast_all od,   tlprofiles tp, allcode a
    where  od.deltd <> 'Y'
        and od.txdate between VF_DATE and VT_DATE
        and od.tlid = tp.tlid(+)
        and a.cdname = 'VIA' and a.cdtype = 'FO'
        and  od.via = a.cdval
        and  od.via  like V_VIA
        and od.tlid like V_TLID
        and case when instr(od.exectype,'S') <> 0 then 'S' else 'B' end  like V_EXECTYPE
    group by tp.tlfullname,od.tlid, a.cdcontent, case when instr(od.exectype,'S') <> 0 then 'Sell' else 'Buy' end
    having  sum(case when od.exectype in ('AB','AS','CB','CS') then 0 else 1 end ) +
        sum(case when od.exectype in ('CB','CS') then 0 else od.orderqtty end) +
        sum(case when od.execamt <>0 then 1 else 0 end ) +
        sum(case when execamt <> 0 then od.execqtty else 0 end) > 0
;



EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/

