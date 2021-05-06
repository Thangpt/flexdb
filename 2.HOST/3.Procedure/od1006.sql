CREATE OR REPLACE PROCEDURE od1006 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   custodycd      IN       VARCHAR2,
   pricetype      IN       varchar2,
   TLID            IN       VARCHAR2
)
IS

   V_STROPTION        VARCHAR2 (5);
   V_STRBRID          VARCHAR2 (4);
   v_strcustodycd        VARCHAR2 (20);
   V_P_date           date;
   V_CRRDATE          date;
   V_VAT        number;
   V_PRCTYPE        VARCHAR2 (4);
   V_STRTLID           VARCHAR2(6);
   v_advsellduty        NUMBER;
   v_advvatduty         NUMBER;

BEGIN
    V_P_date := TO_DATE(I_date,'dd/mm/rrrr');
    V_STRTLID:= TLID;
    V_STROPTION := OPT;

    IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
    THEN
        V_STRBRID := BRID;
    ELSE
        V_STRBRID := '%%';
    END IF;

    IF  (custodycd <> 'ALL')
    THEN
        v_strcustodycd := upper(custodycd);
    ELSE
        v_strcustodycd := '%%';
    END IF;
    select to_date(varvalue,'dd/mm/rrrr') into V_CRRDATE  from sysvar where varname = 'CURRDATE';
    SELECT varvalue INTO v_advsellduty FROM sysvar WHERE varname = 'ADVSELLDUTY';
    SELECT varvalue INTO v_advvatduty FROM sysvar WHERE varname = 'ADVVATDUTY';
    V_PRCTYPE := pricetype;
  -- GET REPORT'S DATA
CASE V_PRCTYPE
WHEN '01' THEN
OPEN PV_REFCURSOR FOR
select  V_P_date IN_DATE, cf.fullname, cf.address, cf.custodycd,
    sum(io.matchqtty) exqtty, sum(io.matchqtty*io.matchprice) exprice,
    sum(case when od.execamt > 0 and decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N' AND  od.TXDATE = V_CRRDATE then
--                  round((odt.deffeerate*io.matchqtty * io.matchprice/100),2)
                    round(io.matchqtty * io.matchprice * floor(odt.deffeerate* od.execamt/100) / od.execamt, 2)
             ELSE io.iodfeeacr
        end) feeamt,
    sb.symbol, od.exectype,
    round(sum(CASE WHEN aft.VAT = 'Y' THEN
            (CASE WHEN od.execamt > 0 and decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N' AND  od.TXDATE = V_CRRDATE THEN
                v_advsellduty/100*(IO.matchqtty * io.matchprice) + nvl(sp.aright,0)
            else od.taxrate/100*(IO.matchqtty * io.matchprice) + nvl(sp.aright,0)
            end)
        ELSE 0 END)) selling_tax,
    'T + ' || od.clearday || '('  ||to_char(getduedate(od.txdate,
        od.clearcd, sb.tradeplace, od.CLEARDAY),'dd/mm/rrrr') || ')' txdate, odt.deffeerate
from (select * from odmast where txdate = V_P_date
        union all select * from odmasthist where txdate = V_P_date
    ) od,
    (select * from iod where txdate = V_P_date
        union all select * from iodhist where txdate = V_P_date
    ) io,
    sbsecurities sb, cfmast cf, afmast af, ODTYPE ODT, aftype aft,
    (SELECT orgorderid, txnum, sum(aright) aright FROM sepitallocate GROUP BY orgorderid, txnum) sp,
    (SELECT * FROM sbbatchsts bs WHERE bs.bchmdl = 'ODFEECAL') bs
where od.codeid = sb.codeid AND io.orgorderid = sp.orgorderid(+) AND io.txnum = sp.txnum(+)
    and af.custid = cf.custid
    and af.actype = aft.actype
    and od.orderid = io.orgorderid
    and af.acctno = od.afacctno
    AND oD.ACTYPE = ODT.ACTYPE
    AND OD.DELTD <> 'Y'
    AND od.txdate = bs.bchdate(+)
    and od.exectype IN ('NS','MS','SS')
    and cf.custodycd = v_strcustodycd
    and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = V_STRTLID )
group by sb.symbol, cf.custodycd, cf.fullname, cf.address, od.exectype,
          'T + ' || od.clearday || '('  ||to_char(getduedate(od.txdate, od.clearcd, sb.tradeplace, od.CLEARDAY),'dd/mm/rrrr') || ')',odt.Deffeerate;
ELSE
OPEN PV_REFCURSOR FOR
select  V_P_date IN_DATE, cf.fullname, cf.address, cf.custodycd,
    (io.matchqtty) exqtty, (io.matchqtty*io.matchprice) exprice,
    (case when od.execamt > 0 and decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N' AND  od.TXDATE = V_CRRDATE then
--                  round((odt.deffeerate*io.matchqtty * io.matchprice/100),2)
                    round(io.matchqtty * io.matchprice * floor(odt.deffeerate* od.execamt/100) / od.execamt, 2)
             ELSE io.iodfeeacr
        end) feeamt,
    sb.symbol, od.exectype,
    ((CASE WHEN aft.VAT = 'Y' THEN
            (CASE WHEN od.execamt > 0 and decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N' AND  od.TXDATE = V_CRRDATE THEN
                v_advsellduty/100*(IO.matchqtty * io.matchprice) + nvl(sp.aright,0)
            else od.taxrate/100*(IO.matchqtty * io.matchprice) + nvl(sp.aright,0) end)
        ELSE 0 END)) selling_tax,
    'T + ' || od.clearday || '('  ||to_char(getduedate(od.txdate,
        od.clearcd, sb.tradeplace, od.CLEARDAY),'dd/mm/rrrr') || ')' txdate, odt.deffeerate
from (select * from odmast where txdate = V_P_date
        union all select * from odmasthist where txdate = V_P_date
    ) od,
    (select * from iod where txdate = V_P_date
        union all select * from iodhist where txdate = V_P_date
    ) io,
    sbsecurities sb, cfmast cf, afmast af, ODTYPE ODT, aftype aft,
    (SELECT orgorderid, txnum, sum(aright) aright FROM sepitallocate GROUP BY orgorderid, txnum) sp,
    (SELECT * FROM sbbatchsts bs WHERE bs.bchmdl = 'ODFEECAL') bs
where od.codeid = sb.codeid AND io.orgorderid = sp.orgorderid(+) AND io.txnum = sp.txnum(+)
    and af.custid = cf.custid
    and af.actype = aft.actype
    and od.orderid = io.orgorderid
    and af.acctno = od.afacctno
    AND oD.ACTYPE = ODT.ACTYPE
    AND OD.DELTD <> 'Y'
    AND od.txdate = bs.bchdate(+)
    and od.exectype IN ('NS','MS','SS')
    and cf.custodycd = v_strcustodycd
     and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = V_STRTLID )
--group by sb.symbol, cf.custodycd, cf.fullname, cf.address, od.exectype,
--          'T + ' || od.clearday || '('  ||to_char(getduedate(od.txdate, od.clearcd, sb.tradeplace, od.CLEARDAY),'dd/mm/rrrr') || ')'
          ;
END CASE
;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/