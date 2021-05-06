CREATE OR REPLACE PROCEDURE df0041 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD       IN       VARCHAR2, --CUSTODYCD
   PV_AFACCTNO         IN       VARCHAR2,
   PV_RRTYPE         IN       VARCHAR2,
   PV_GROUPID         IN       VARCHAR2
   )
IS
--Bang chi tiet lai vay
--created by CHaunh at 03/02/2012

-- ---------   ------  -------------------------------------------

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_STRCUSTODYCD  VARCHAR2 (20);
   V_STRAFACCTNO               VARCHAR2(20);
   V_GROUPID               VARCHAR2(20);
   V_STRRRTYPE               VARCHAR2(5);
   v_FrDate                DATE;
   V_ToDate                 DATE;
   v_currdate     date;


BEGIN
   V_STROPTION := OPT;

   v_FrDate := to_date(F_DATE,'DD/MM/RRRR');
   v_ToDate   := to_date(T_DATE,'DD/MM/RRRR');

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%';
   END IF;

   IF(PV_CUSTODYCD = 'ALL' or PV_CUSTODYCD is null )
   THEN
        V_STRCUSTODYCD := '%%';
   ELSE
        V_STRCUSTODYCD := PV_CUSTODYCD;
   END IF;

   IF(PV_AFACCTNO = 'ALL' OR PV_AFACCTNO IS NULL)
    THEN
       V_STRAFACCTNO := '%';
   ELSE
       V_STRAFACCTNO := PV_AFACCTNO;
   END IF;

   IF(PV_RRTYPE = 'ALL' OR PV_RRTYPE IS NULL)
    THEN
       V_STRRRTYPE := '%';
   ELSE
       V_STRRRTYPE := PV_RRTYPE;
   END IF;


   IF(PV_GROUPID = 'ALL' OR PV_GROUPID IS NULL)
    THEN
       V_GROUPID := '%';
   ELSE
       V_GROUPID := PV_GROUPID;
   END IF;


OPEN PV_REFCURSOR
FOR
    select a.cdcontent, cf.custodycd, dg.afacctno, cf.fullname, dg.groupid, ln.rlsdate, ln.expdate, ln.rlsdate + ln.intday,
        min(tran.frdate) frdate, max(tran.todate) todate,  tran.intbal so_du_tinh_lai_phi,
        case when tran.inttype = 'O' then tran.cfirrate else tran.irrate end ty_le_lai_phi,
        case when inttype = 'I' then sum(intamt) + sum(feeintamt) else 0 end lai_phi_tronghan,
        case when inttype <> 'I' then sum(intamt) + sum(feeintamt) else 0 end lai_phi_quahan
    from (SELECT * FROM dfgroup UNION ALL SELECT * FROM dfgrouphist) dg, cfmast cf, afmast af, vw_lnmast_all ln,
         (SELECT * FROM lninttrana UNION ALL SELECT * FROM lninttran ) tran, allcode a
    where dg.afacctno = af.acctno and cf.custid = af.custid
    and ln.acctno = dg.lnacctno and tran.acctno = dg.lnacctno
    and a.cdtype = 'DF' and a.cdname = 'RRTYPE' and a.cdval = dg.rrtype
    and dg.groupid like V_GROUPID
    --and dg.txdate >= v_FrDate
    and dg.txdate <= V_ToDate
    and dg.rrtype like V_STRRRTYPE
    and dg.afacctno like V_STRAFACCTNO and cf.custodycd like V_STRCUSTODYCD
    group by a.cdcontent, cf.custodycd, dg.afacctno, cf.fullname, dg.groupid, ln.rlsdate, ln.expdate, ln.rlsdate, ln.intday,
        intbal, inttype, irrate, cfirrate
    order by a.cdcontent, dg.groupid, min(tran.frdate), max(tran.todate)
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

