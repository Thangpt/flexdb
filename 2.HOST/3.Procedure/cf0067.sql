CREATE OR REPLACE PROCEDURE cf0067(
   pv_refcursor   IN OUT   pkg_report.ref_cursor,
   opt            IN       VARCHAR2,
   brid           IN       VARCHAR2,
   f_date         IN       VARCHAR2,
   t_date         in       varchar2,
   pv_custodycd   IN       varchar2,
   pv_status      IN       VARCHAR2
)
IS
   v_stroption   VARCHAR2 (5);            -- A: All; B: Branch; S: Sub-branch
   v_strbrid     VARCHAR2 (4);                   -- Used when v_numOption > 0
   frdate        DATE;
   todate        DATE;
   v_custodycd   VARCHAR2(10);
   v_status      VARCHAR2(10);
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
   
   IF (pv_status <> 'ALL')
   THEN
      v_status := pv_status;
   ELSE
      v_status := '%%';
   END IF;

   frdate := to_date(f_date,'dd/mm/rrrr');
   todate := to_date(t_date,'dd/mm/rrrr');

   OPEN pv_refcursor FOR
        SELECT lm.*, cf.custodycd, cf.fullname, tl.tlname, tl.aprname
        FROM cftrflimit lm, cfmast cf,
              (SELECT tl.TXNUM, tl.TXDATE, tlp1.tlname, tlp2.tlname aprname
              FROM vw_tllog_all tl, tlprofiles tlp1, tlprofiles tlp2
              WHERE tl.TLID = tlp1.tlid AND tl.OFFID = tlp2.tlid(+)
              ) tl
        WHERE lm.custid = cf.custid AND lm.txdate = tl.TXDATE AND lm.txnum = tl.TXNUM
        AND cf.custodycd LIKE v_custodycd AND lm.txdate BETWEEN frdate AND todate
        AND lm.status LIKE v_status
        order by lm.TXDATE
        ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
