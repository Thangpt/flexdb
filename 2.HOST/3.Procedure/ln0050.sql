CREATE OR REPLACE PROCEDURE ln0050(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                                   OPT          IN VARCHAR2,
                                   BRID         IN VARCHAR2,
                                   I_DATE       IN VARCHAR2,
                                   P_GUARANTYPE IN VARCHAR2) IS
  V_STROPTION VARCHAR2(5); -- A: ALL; B: BRANCH; S: SUB-BRANCH
  V_STRBRID   VARCHAR2(40); -- USED WHEN V_NUMOPTION > 0
  V_INBRID    VARCHAR2(5);

  V_GUARANTYPE VARCHAR2(20);
  V_FROMDATE   DATE;

BEGIN
  V_STROPTION := upper(OPT);
  V_INBRID    := BRID;

  if (V_STROPTION = 'A') then
    V_STRBRID := '%';
  else
    if (V_STROPTION = 'B') then
      select br.mapid
        into V_STRBRID
        from brgrp br
       where br.brid = V_INBRID;
    else
      V_STRBRID := BRID;
    end if;
  end if;

  IF (P_GUARANTYPE <> 'ALL') THEN
    V_GUARANTYPE := P_GUARANTYPE;
  ELSE
    V_GUARANTYPE := '%';
  END IF;

  V_FROMDATE := TO_DATE(I_DATE, 'DD/MM/RRRR');

  OPEN PV_REFCURSOR FOR
    select sum(a.NOBALANH) NOBALANH,
           sum(AMT) AMT,
           BRANCH,
           GUARANTYPE,
           P_GUARANTYPE F_GUARANTYPE,
           I_DATE F_I_DATE
      from (select sum(t2.AMT) NOBALANH,
                   b.brname BRANCH,
                   t2.branchid,
                   'T' || t2.minterm GUARANTYPE,
                   fn_get_to123(t2.branchid, t2.minterm, I_DATE) AMT
              from (select sum(round(ls.nml + ls.ovd - nvl(lg.nml, 0) -
                                     nvl(lg.ovd, 0),
                                     0)

                               + round(ls.intnmlacr + ls.intdue + ls.intovd +
                                       ls.intovdprin - nvl(lg.intnmlacr, 0) -
                                       nvl(lg.intdue, 0) - nvl(lg.intovd, 0) -
                                       nvl(lg.intovdprin, 0),
                                       0)

                               + round(ls.feeintnmlacr + ls.feeintdue +
                                       ls.feeintnmlovd + ls.feeintovdacr +
                                       ls.feeovd - nvl(lg.feeintnmlacr, 0) -
                                       nvl(lg.feeintdue, 0) -
                                       nvl(lg.feeintnmlovd, 0) -
                                       nvl(lg.feeintovdacr, 0) -
                                       nvl(lg.feeovd, 0),
                                       0)) + (CASE
                                                WHEN V_FROMDATE = getcurrdate THEN
                                                 max(ln.intnmlpbl)
                                                ELSE
                                                 0
                                              END) AMT,
                           ls.minterm,
                           re.brid branchid
                      from vw_lnmast_all ln,
                           (SELECT (SELECT COUNT(sbdate) - 1 minterm
                                      FROM sbcldr
                                     WHERE sbdate BETWEEN rlsdate AND
                                           mintermdate
                                       AND cldrtype = '000'
                                       AND holiday = 'N') minterm,
                                   ls.*
                              FROM (SELECT *
                                      FROM lnschd
                                    UNION ALL
                                    SELECT *
                                      FROM lnschdhist) ls) ls,
                           (select autoid,
                                   sum(nml) nml,
                                   sum(ovd) ovd,
                                   sum(paid) paid,
                                   sum(intnmlacr) intnmlacr,
                                   sum(intdue) intdue,
                                   sum(intovd) intovd,
                                   sum(intovdprin) intovdprin,
                                   sum(feeintnmlacr) feeintnmlacr,
                                   sum(feeintdue) feeintdue,
                                   sum(feeintovd) feeintnmlovd,
                                   sum(feeintovdprin) feeintovdacr,
                                   sum(feeovd) feeovd
                              from (select *
                                      from lnschdlog
                                    union all
                                    select *
                                      from lnschdloghist) lg
                             where lg.txdate > V_FROMDATE
                             group by autoid) lg,
                           (select distinct re.afacctno, rcf.brid, rcf.custid
                              from reaflnk re,
                                   sysvar  sys,
                                   cfmast  cf,
                                   RETYPE,
                                   recflnk rcf
                             where to_date(varvalue, 'DD/MM/RRRR') between
                                   re.frdate and
                                   nvl(re.clstxdate - 1, re.todate)
                               and substr(re.reacctno, 0, 10) = cf.custid
                               and varname = 'CURRDATE'
                               and substr(re.reacctno, 0, 10) = rcf.custid
                               and grname = 'SYSTEM'
                               and re.status <> 'C' --and re.afacctno = '0001000036'
                               and re.deltd <> 'Y'
                               AND substr(re.reacctno, 11) = RETYPE.ACTYPE
                               AND rerole IN ('RM', 'BM')) re
                     where ln.acctno = ls.acctno
                       and ls.autoid = lg.autoid(+)
                       and ln.trfacctno = re.afacctno(+)
                       and ln.ftype = 'AF'
                       and ls.reftype = 'GP'
                       and nvl(re.brid, 0) != 0
                     group by ln.acctno, ls.minterm, re.brid) t2,
                   brgrp b
             where t2.branchid = b.brid
               and t2.minterm like V_GUARANTYPE
             GROUP BY t2.minterm, t2.branchid, b.brname) a
     group by branchid, BRANCH, GUARANTYPE
     order by branchid, BRANCH, GUARANTYPE;

EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END;

  -- End of DDL Script for Procedure HOSTMSBST.LN0050
/

