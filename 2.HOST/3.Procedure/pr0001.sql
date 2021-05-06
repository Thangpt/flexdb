CREATE OR REPLACE PROCEDURE pr0001 (
    PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
    OPT            IN       VARCHAR2,
    BRID           IN       VARCHAR2,
    I_DATE         IN       VARCHAR2,
    SYMBOL         IN       VARCHAR2,
    PRGRP          IN       VARCHAR2,
    PV_TLID        IN       VARCHAR2
)
IS
    --Bao cao tong hop du no
    -- ---------   ------  -------------------------------------------
    V_STROPTION        VARCHAR2 (5);         -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
    V_INBRID           VARCHAR2 (4);
    l_intnmlpbl        NUMBER (20,0);
    v_date             DATE;
    v_currdate         DATE;

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

    SELECT max(sbdate) INTO v_date  FROM sbcurrdate WHERE sbtype ='B' AND sbdate <= to_date(I_DATE,'DD/MM/RRRR');
    SELECT to_date(varvalue,'DD/MM/RRRR') INTO v_CurrDate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';

IF v_date = v_CurrDate THEN
OPEN PV_REFCURSOR
  FOR
    SELECT v_date v_date, cf.fullname, prgrp.custodycd, prgrp.afacctno, aft.typename actype, prgrp.codeid, prgrp.symbol,
        prgrp.grp_code, prgrp.grpname, prgrp.selimit, prgrp.grp_pravlremain, prgrp.grp_prinused,
        prgrp.ts_grp, prgrp.ratecl, prgrp.pricecl, prgrp.note, amr.refullname, nvl(round(ln.t0amt)+round(ln.marginamt),0) odamt,
        nvl(ts.realass,0) ts_thuc,  nvl(ts.ts_dinhgia,0) ts_dinhgia, amr.rg_grfullname pcc, br.brname brid
    FROM cfmast cf, afmast af, v_getsecprgrpinfo prgrp, aftype aft, brgrp br,
    (
        SELECT afacctno, sum(realass) realass, sum(ts_sucmua) ts_dinhgia FROM vw_mr9004 GROUP BY afacctno
    ) ts,
    (
        SELECT trfacctno afacctno, nvl(sum(t0amt),0) t0amt, nvl(sum(marginamt),0) marginamt
        FROM vw_lngroup_all GROUP BY trfacctno
    ) ln,
    (
        SELECT amr.*, crm.rg_grfullname
        FROM
        (
            SELECT cf.fullname refullname, re.reacctno, re.afacctno, rcf.brid
            FROM reaflnk re, retype, recflnk rcf, cfmast cf
            WHERE v_date BETWEEN re.frdate AND nvl(re.clstxdate-1,re.todate)
                AND rcf.custid = substr(re.reacctno,1,10)
                AND substr(re.reacctno, 0, 10) = cf.custid
                AND re.deltd <> 'Y' AND rcf.custid = cf.custid
                AND substr(re.reacctno, 11) = retype.actype
                AND rerole IN ('RM', 'BM')
        ) amr,
        (
            SELECT reg.refrecflnkid, reg.reacctno, rg.fullname rg_grfullname
            FROM regrplnk reg , regrp rg
            WHERE reg.refrecflnkid = rg.autoid
                AND reg.frdate <= v_date
                AND nvl(reg.clstxdate-1,reg.todate) >= v_date
        ) crm
        WHERE amr.reacctno = crm.reacctno(+)
    ) amr
    WHERE cf.custid = af.custid
        AND af.acctno = prgrp.afacctno
        AND prgrp.actype = aft.actype AND amr.brid = br.brid(+)
        AND prgrp.grp_prinused <> 0
        AND prgrp.afacctno = amr.afacctno(+)
        AND prgrp.afacctno = ln.afacctno(+)
        AND prgrp.afacctno = ts.afacctno(+)
        AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = PV_TLID)
        AND prgrp.grp_code = PRGRP
;
ELSE
OPEN PV_REFCURSOR
  FOR
    SELECT v_date v_date, prgrp.txdate, prgrp.fullname, prgrp.custodycd, prgrp.afacctno, aft.typename actype, prgrp.codeid,
        prgrp.symbol, prgrp.grp_code, prgrp.grpname, prgrp.selimit, prgrp.grp_pravlremain, prgrp.grp_prinused, prgrp.ts_grp,
        prgrp.ratecl, prgrp.pricecl, prgrp.note, prgrp.refullname, prgrp.autoid, prgrp.pcc, br.brname brid,
    nvl(ts.odamt,0) odamt, nvl(ts.realass,0) ts_thuc,  nvl(ts.ts_dinhgia,0) ts_dinhgia
    FROM tbl_pr0001_log prgrp, cfmast cf, afmast af, aftype aft, brgrp br,
    (
        SELECT afacctno, max(t0amt) + max(mramt) + max(dfamt) odamt, sum(realass) realass, sum(ts_sucmua) ts_dinhgia FROM tbl_mr3007_log WHERE txdate = v_date GROUP BY afacctno
    ) ts
    WHERE cf.custid = af.custid AND prgrp.afacctno = af.acctno AND prgrp.actype = aft.actype AND prgrp.brid = br.brid
        AND prgrp.grp_prinused <> 0
        AND prgrp.afacctno = ts.afacctno(+)
        AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = PV_TLID)
        AND prgrp.txdate = v_date
        AND prgrp.grp_code = PRGRP
;
END IF;

EXCEPTION
   WHEN OTHERS THEN
   RETURN;
END;
/

