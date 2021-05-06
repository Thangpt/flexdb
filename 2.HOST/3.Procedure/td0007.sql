CREATE OR REPLACE PROCEDURE td0007 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD       IN       VARCHAR2,
   CAREBY         IN       VARCHAR2,
   ACCTNO         IN       VARCHAR2--,
   --GROUPTYPE      IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- Bao cao tat toan hop dong
-- PERSON           DATE        COMMENTS
-- DUNGNH       24-MAR-2011     CREATED
-- ---------       ------   -------------------------------------------
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_FROMDATE       DATE;
   V_TODATE         DATE;
   V_CUSTODYCD    VARCHAR2 (10);
   V_STRACCTNO      VARCHAR2 (20);
   V_STRCAREBY      VARCHAR2 (10);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%';
   END IF;

    -- GET REPORT'S PARAMETERS

   if(upper(PV_CUSTODYCD) <> 'ALL') then
        V_CUSTODYCD :=  PV_CUSTODYCD;
   else
        V_CUSTODYCD := '%';
   end if;

   if(upper(ACCTNO) <> 'ALL') then
        V_STRACCTNO := ACCTNO;
   else
        V_STRACCTNO := '%';
   end if;

   if(upper(CAREBY) <> 'ALL') then
        V_STRCAREBY :=  CAREBY;
   else
        V_STRCAREBY := '%';
   end if;

   V_FROMDATE := to_date(F_DATE,'dd/mm/rrrr');
   V_TODATE := to_date(T_DATE,'dd/mm/rrrr');

   -- GET REPORT'S DATA
OPEN PV_REFCURSOR
       FOR
SELECT a.*, b.msgamt FROM
(select td.aftype, td.tdtype, td.careby, td.acctno, td.afacctno,td.custodycd, td.fullname, td.orgamt,
    td.frdate, td.todate, td.cdcontent, td.txdate, td.namt,
     (case when td.schdtype = 'F' then td.intrate else nvl(SCHM.intrate,td.intrate) end) intrate,td.intpaid-- ,
    --GROUPTYPE strGROUPTYPE
from
(
    select mst.aftype, mst.tdtype, mst.careby, mst.acctno, mst.afacctno,mst.custodycd, mst.fullname,
        mst.frdate, mst.todate, mst.cdcontent,mst.schdtype, mst.intrate,mst.tdterm,
        --(case when sum(tr.namt) = max(mst.orgamt) then max(tr.txdate) else null end) txdate,
        tr.txdate,  mst.orgamt orgamt,
        sum(tr.namt) namt,
        sum(tr.intpaid) intpaid--,
        --GROUPTYPE strGROUPTYPE
    from
    (
        select td.actype tdtype, tl.grpname careby, td.acctno, af.acctno afacctno, cf.fullname, cf.custodycd,
            td.orgamt, td.frdate, td.schdtype,td.intrate,td.tdterm, td.balance,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                AND SBDATE >= td.TODATE AND HOLIDAY = 'N') todate,
            (td.tdterm || ' ' || al.cdcontent) cdcontent, cf.careby carebyid, af.actype aftype
        from (select * from tdmast union select * from tdmasthist) td, afmast af, cfmast cf,
            allcode al, tlgroups tl
        where td.afacctno = af.acctno and af.custid = cf.custid
            and al.cdtype = 'TD' and al.cdname = 'TERMCD'
            and td.termcd = al.cdval
            and cf.careby = tl.grpid
            and td.deltd <> 'Y'
    ) mst
    left join
    (
        SELECT TR.ACCTNO, tr.txdate,  tr.tltxcd, --tr.txnum,
            sum(case when APP.FIELD = 'BALANCE' then (CASE WHEN APP.TXTYPE = 'D' THEN TR.NAMT ELSE -TR.NAMT END)
                else 0 end) NAMT,
            sum(case when APP.FIELD = 'INTPAID' then (CASE WHEN APP.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END)
                else 0 end) INTPAID
        FROM (SELECT * FROM TDTRAN UNION ALL SELECT * FROM TDTRANA) TR,
            (select * from tllog union all select * from tllogall) tl,
            --ngay giao dich cuoi cung
            (SELECT acctno, max(txdate) txdate FROM  (SELECT * FROM TDTRAN UNION ALL SELECT * FROM TDTRANA) TR WHERE tr.namt > 0 AND tr.deltd <> 'Y' GROUP BY acctno ) a,
            V_APPMAP_BY_TLTXCD APP
        WHERE TR.NAMT > 0 AND tr.DELTD <> 'Y'
            AND TR.TXNUM = TL.TXNUM
            AND TR.TXDATE = TL.TXDATE
            AND APP.tltxcd = TL.TLTXCD
            AND TR.TXCD = APP.APPTXCD
            AND APP.FIELD in ('BALANCE','INTPAID')
            AND APP.APPTYPE = 'TD'
            --lay ngay giao dich cuoi cung
            AND a.acctno = tr.acctno AND a.txdate = tr.txdate
            AND tr.txdate BETWEEN V_FROMDATE and V_TODATE
        group by TR.ACCTNO, tr.TXDATE,  tr.tltxcd --tr.txnum,
    ) TR
    on mst.acctno = tr.acctno
        and tr.txdate <= mst.todate
        --and tr.txdate > mst.frdate
        and case WHEN tr.tltxcd in ('1600','1620') and mst.frdate  <= tr.txdate THEN 1
                             WHEN tr.tltxcd NOT IN  ('1600','1620') AND  mst.frdate <  txdate THEN 1
                             ELSE 0 END = 1
    where mst.balance = 0 AND tr.txdate is NOT null
        AND mst.custodycd like V_CUSTODYCD
        and mst.acctno like V_STRACCTNO
        and mst.carebyid like V_STRCAREBY
    GROUP BY mst.aftype, mst.tdtype, mst.careby, mst.acctno, mst.afacctno,mst.custodycd, mst.fullname,
        mst.frdate, mst.todate, mst.cdcontent,mst.schdtype, mst.intrate,mst.tdterm,
        --(case when sum(tr.namt) = max(mst.orgamt) then max(tr.txdate) else null end) txdate,
        tr.txdate,  mst.orgamt

) td

left join

    (
            select tdmstschm.refautoid,  tdmstschm.acctno,  tdmstschm.intrate,  framt ,toamt,  frterm,toterm  ,tdmast.frdate ,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                        AND SBDATE >= tdmast.todate AND HOLIDAY = 'N') todate
            from tdmstschm , tdmast, cfmast cf, afmast af
            where tdmstschm.acctno = tdmast.acctno AND cf.custid = af.custid
            and tdmast.acctno like V_STRACCTNO  and tdmast.afacctno = af.acctno AND cf.custodycd  like V_CUSTODYCD
            union all
            select    tdmstschmhist.refautoid,  tdmstschmhist.acctno,  tdmstschmhist.intrate,  framt ,toamt,  frterm,toterm  ,tdmstschmhist.frdate ,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                        AND SBDATE >= tdmstschmhist.todate AND HOLIDAY = 'N') todate
            from tdmstschmhist
            where tdmstschmhist.acctno like V_STRACCTNO
    )
      SCHM

        on td.acctno = SCHM.acctno(+)
        and td.orgamt >= SCHM.framt(+)
        and td.orgamt < SCHM.toamt(+)
        and td.tdterm >= SCHM.FRTERM(+)
        and td.tdterm < SCHM.toterm(+)
        and td.txdate > SCHM.frdate(+)
        and td.txdate <= SCHM.todate(+)
        where (td.namt > 0 or td.intpaid > 0 )
        --and td.orgamt = td.namt
) a,
(
SELECT td.txdate, td.txnum, td.afacctno, td.acctno, tl.msgamt FROM
    ( SELECT txdate, txnum, afacctno, acctno, min(opndate) opndate FROM (
    SELECT * FROM tdmast UNION ALL SELECT * FROM tdmasthist ) GROUP BY txdate, txnum, afacctno, acctno
    ) td, vw_tllog_all tl
WHERE tl.tltxcd = '1670' AND td.txdate = tl.txdate AND td.txnum = tl.txnum
) b
WHERE a.acctno = b.acctno(+)
ORDER BY a.txdate, a.custodycd, a.afacctno, a.acctno

/*
TDMSTSCHM
on td.acctno = TDMSTSCHM.acctno(+)
and td.orgamt >= TDMSTSCHM.framt(+)
and td.orgamt < TDMSTSCHM.toamt(+)
and td.tdterm >= TDMSTSCHM.FRTERM(+)
and td.tdterm < TDMSTSCHM.toterm(+)
where (td.namt > 0 or td.intpaid > 0)   */
--and td.orgamt = td.namt

    ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

