CREATE OR REPLACE PROCEDURE td0001 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   I_TDTYPE       IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- Bao cao tinh trang no qua han
-- PERSON           DATE        COMMENTS
-- DUNGNH       24-MAR-2011     CREATED
-- ---------       ------   -------------------------------------------
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_INDATE         date;
   V_STRTDTYPE      VARCHAR2 (10);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

    -- GET REPORT'S PARAMETERS


   IF(upper(I_TDTYPE) <> 'ALL') THEN
        V_STRTDTYPE := I_TDTYPE;
   ELSE
        V_STRTDTYPE := '%';
   END IF;

   V_INDATE := to_date(I_DATE,'dd/mm/yyyy');


   -- GET REPORT'S DATA

OPEN PV_REFCURSOR
       FOR
select mst.actype, tdtype.typename, sum(mst.NAMT) namt,
    sum(MST.INTAVLAMT) INTAVLAMT
from tdtype,
(
    select mst.acctno, mst.actype, (mst.balance-nvl(tr.namt,0)) NAMT,
        (FN_TDMASTINTRATIO(mst.ACCTNO, 
        (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' 
                                AND SBDATE >= MST.TODATE AND HOLIDAY = 'N')
            ,(mst.balance-nvl(tr.namt,0))))INTAVLAMT
    from tdmast mst,
        (
            select tr.acctno,
                sum(case when app.txtype = 'D' then -Tr.namt else TR.namt end) namt
            from (select * from tdtran union all select * from tdtrana) tr,
                v_appmap_by_tltxcd app
            where tr.namt > 0 and deltd <> 'Y'
                and TR.txcd = app.apptxcd
                and app.field = 'BALANCE'
                and app.apptype = 'TD'
                and nvl(tr.bkdate,tr.txdate) >= V_INDATE
            group by tr.acctno
        ) TR
    where mst.acctno=TR.acctno(+)
        and mst.opndate <= V_INDATE
) MST
where mst.actype = tdtype.actype
    and mst.namt > 0
    and tdtype.actype like V_STRTDTYPE
group by mst.actype, tdtype.typename;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

