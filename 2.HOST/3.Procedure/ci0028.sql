CREATE OR REPLACE PROCEDURE ci0028(
   pv_refcursor   IN OUT   pkg_report.ref_cursor,
   opt            IN       VARCHAR2,
   brid           IN       VARCHAR2,
   f_date         IN       VARCHAR2,
   t_date         in       varchar2,
   pv_custodycd   IN       varchar2
)
IS
   v_stroption   VARCHAR2 (5);            -- A: All; B: Branch; S: Sub-branch
   v_strbrid     VARCHAR2 (4);                   -- Used when v_numOption > 0
   frdate        DATE;
   todate        DATE;
   v_custodycd   VARCHAR2(10);

BEGIN
   v_stroption := opt;

   IF (v_stroption <> 'A') AND (brid <> 'ALL')
   THEN
      v_strbrid := brid;
   ELSE
      v_strbrid := '%%';
   END IF;

   IF (pv_custodycd <> 'ALL')
   THEN
      v_custodycd := pv_custodycd;
   ELSE
      v_custodycd := '%%';
   END IF;

   frdate := to_date(f_date,'dd/mm/rrrr');
   todate := to_date(t_date,'dd/mm/rrrr');

   OPEN pv_refcursor FOR
        SELECT e.txdate, cf.custodycd, cf.fullname, e.afacctno, e.amount, e.cashamt, e.advamt, tl.tlname
        FROM extranferreq e, afmast af, cfmast cf, tlprofiles tl
        WHERE e.afacctno = af.acctno AND af.custid = cf.custid
        AND e.status = 'A' AND e.aprvid = tl.tlid
        AND e.txdate BETWEEN frdate AND todate
        AND cf.custodycd LIKE v_custodycd
		order by e.txdate
        ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
