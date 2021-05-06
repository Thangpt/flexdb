CREATE OR REPLACE PROCEDURE ln0020(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                                   OPT          IN VARCHAR2,
                                   BRID         IN VARCHAR2,
                                   F_DATE       IN VARCHAR2,
                                   T_DATE       IN VARCHAR2,
                                   PV_CUSTODYCD IN VARCHAR2,
                                   PV_AFACCTNO  IN VARCHAR2,
                                   TLTITLE      IN VARCHAR2,
                                   MAKER        IN VARCHAR2,
                                   CHECKER      IN VARCHAR2,
                                   CAREBY       IN VARCHAR2,
                                   APPTYPE      IN VARCHAR2,
                                   STATUS       IN VARCHAR2) IS
  V_STROPTION VARCHAR2(5); -- A: ALL; B: BRANCH; S: SUB-BRANCH
  V_STRBRID   VARCHAR2(40); -- USED WHEN V_NUMOPTION > 0
  V_INBRID    VARCHAR2(5);

  V_CUSTODYCD VARCHAR2(20);
  V_AFACCTNO  VARCHAR2(20);
  V_STRBRGID  VARCHAR2(10);
  V_CAREBY    VARCHAR2(20);
  V_TLTITLE   VARCHAR2(20);
  V_MAKER     VARCHAR2(20);
  V_CHECKER   VARCHAR2(20);
  V_APPTYPE   VARCHAR2(20);
  V_STATUS    VARCHAR2(20);
  V_FROMDATE  DATE;
  V_TODATE    DATE;

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

  IF (PV_CUSTODYCD <> 'ALL') THEN
    V_CUSTODYCD := PV_CUSTODYCD;
  ELSE
    V_CUSTODYCD := '%';
  END IF;

  IF (PV_AFACCTNO <> 'ALL') THEN
    V_AFACCTNO := PV_AFACCTNO;
  ELSE
    V_AFACCTNO := '%';
  END IF;

  IF (TLTITLE <> 'ALL') THEN
    V_TLTITLE := TLTITLE;
  ELSE
    V_TLTITLE := '%';
  END IF;

  IF (MAKER <> 'ALL') THEN
    V_MAKER := MAKER;
  ELSE
    V_MAKER := '%';
  END IF;

  IF (CHECKER <> 'ALL') THEN
    V_CHECKER := CHECKER;
  ELSE
    V_CHECKER := '%';
  END IF;

  IF (CAREBY <> 'ALL') THEN
    V_CAREBY := CAREBY;
  ELSE
    V_CAREBY := '%';
  END IF;

  IF (APPTYPE <> 'ALL') THEN
    V_APPTYPE := APPTYPE;
  ELSE
    V_APPTYPE := '%';
  END IF;

  IF (STATUS <> 'ALL') THEN
    V_STATUS := STATUS;
  ELSE
    V_STATUS := '%';
  END IF;

  V_FROMDATE := TO_DATE(F_DATE, 'DD/MM/RRRR');
  V_TODATE   := TO_DATE(T_DATE, 'DD/MM/RRRR');

  OPEN PV_REFCURSOR FOR

    SELECT ol.duedate,
           cf.custodycd,
           ol.acctno,
           cf.fullname,
           ol.t0amtused advanceline,
           ol.t0amtpending toamt,
           ol.toamt autoamt,
           ol.t0amtused,
           CASE
             WHEN ol.status IN ('A','E') THEN
              nvl(ret.retrievedlimit, 0)
             ELSE
              0
           END remainamt,
           ol.period,
           CASE
             WHEN ol.t0amtpending = 0 THEN
              'AUTO'
             ELSE
              'APP'
           END apptype,
           a1.cdcontent tltitle,
           tl1.tlname,
           tl.tlname,
           cr.grpname careby,
           ol.t0cal,
           ol.marginrate,
           ol.setotal,
           ol.totalloan,
           ol.pp,
           a2.cdcontent status,
           TO_CHAR(ol.time1816,'hh24:mi:ss') makertime,
           TO_CHAR(ol.time1818,'hh24:mi:ss') apptime,
           tl2.tlfullname,
           ol.navno,
           a3.cdcontent deal1816, a4.cdcontent deal1818 -- 1.5.8.9|iss:2052
      FROM olndetail ol,
           cfmast cf,
           afmast af,
           tlprofiles tl,
           allcode a1,
           tlprofiles tl1,
           allcode a2,
           tlprofiles tl2,
           (select autoid, txdate, sum(retrievedamt) retrievedlimit
              from RETRIEVEDT0LOG
             group by autoid, txdate) RET,
           (SELECT acctno, allocateddate, autoid, refautoid
              FROM (SELECT *
                      FROM t0limitschd
                    UNION ALL
                    SELECT *
                      FROM t0limitschdhist)) ts,
           tlgroups cr,
           (SELECT * FROM allcode WHERE cdtype = 'SY' AND cdname = 'YESNO') a3,
           (SELECT * FROM allcode WHERE cdtype = 'SY' AND cdname = 'YESNO') a4
     WHERE cf.custid = af.custid
       AND ol.acctno = af.acctno
       AND ol.tlid1818 = tl.tlid(+)
       AND ol.userid = tl1.tlid
       AND ol.autoid = ts.refautoid(+)
       AND ts.autoid = ret.autoid(+)
       AND ts.allocateddate = ret.txdate(+)
       AND af.careby = cr.grpid
       AND ol.tlid = tl2.tlid(+)
       AND ol.acctno LIKE V_AFACCTNO
       AND cf.custodycd LIKE V_CUSTODYCD
       AND nvl(tl2.tltitle, '-') LIKE V_TLTITLE
       AND ol.userid LIKE V_MAKER
       AND nvl(ol.tlid1818, '-') LIKE V_CHECKER
       AND af.careby LIKE V_CAREBY
       AND (CASE
             WHEN ol.t0amtpending = 0 THEN
              'AUTO'
             ELSE
              'APP'
           END) LIKE V_APPTYPE
       AND ol.status LIKE V_STATUS
       AND tl2.tltitle = a1.cdval(+)
       AND a1.cdname(+) = 'TLTITLE'
       AND ol.status = a2.cdval
       AND a2.cdname = 'STATUS'
       AND a2.cdtype = 'BL'
       AND ol.duedate BETWEEN V_FROMDATE AND V_TODATE
       AND nvl(ol.deal1816, ' ') = a3.cdval(+)
       AND nvl(ol.deal1818,' ') = a4.cdval(+)
     ORDER BY cf.custodycd, ol.acctno, ol.time1816, ol.time1818;

EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END;
/
