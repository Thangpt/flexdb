CREATE OR REPLACE PROCEDURE pr0003 (
    PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
    OPT            IN       VARCHAR2,
    BRID           IN       VARCHAR2,
    I_DATE         IN       VARCHAR2,
    SYMBOL         IN       VARCHAR2,
    PV_TLID        IN       VARCHAR2
)
IS
    --Bao cao tong hop cac co phieu co room theo nhom
    -- ---------   ------  -------------------------------------------
    V_STROPTION        VARCHAR2 (5);         -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
    V_INBRID           VARCHAR2 (4);
    V_SYMBOL           VARCHAR2 (20);
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

    IF SYMBOL <> 'ALL' THEN
        V_SYMBOL := REPLACE(SYMBOL,' ','_');
    ELSE
        V_SYMBOL := '%';
    END IF;

    SELECT max(sbdate) INTO v_date  FROM sbcurrdate WHERE sbtype ='B' AND sbdate <= to_date(I_DATE,'DD/MM/RRRR');
    SELECT to_date(varvalue,'DD/MM/RRRR') INTO v_CurrDate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';

IF v_date = v_CurrDate THEN
OPEN PV_REFCURSOR
  FOR
    SELECT v_CurrDate txdate, sb.codeid, sb.symbol, sb.listingqtty, nvl(a.syroomlimit,0) syroomlimit, nvl(a.roomlimit,0) roomlimit, nvl(b.selimit,0) selimit,
        nvl(a.prinused,0) prinused, nvl(a.syprinused,0) syprinused, nvl(b.grp_prinused,0) grp_prinused,
        nvl(a.pravlremain,0) pravlremain, nvl(sy_pravlremain,0) sy_pravlremain, nvl(grp_pravlremain,0) grp_pravlremain,
        nvl(a.syscallmargin,0) syscallmargin, nvl(princallmargin,0) princallmargin, nvl(grpcallmargin,0) grpcallmargin
    FROM securities_info sb, sbsecurities sbs,
    (
        SELECT a.codeid, a.roomlimit, a.syroomlimit,
            sum(syprinused * nvl(afs.mrratioloan,0)/100 * LEAST(a.marginprice,afs.mrpriceloan)) syscallmargin,
            sum(prinused * nvl(afm.mrratioloan,0) /100 * LEAST(a.marginrefprice,afm.mrpriceloan)) princallmargin,
            sum(syprinused) syprinused, sum(prinused) prinused,
            a.roomlimit - sum(prinused) pravlremain, a.syroomlimit - sum(syprinused) sy_pravlremain
        FROM
        (
            SELECT af.actype, pr.codeid, sb.marginprice, sb.marginrefprice,
                max(pr.roomlimit) roomlimit, max(pr.syroomlimit) syroomlimit,
                nvl(sum(case when restype = 'M' then nvl(afpr.prinused,0) else 0 end),0) prinused,
                nvl(sum(case when restype = 'S' then nvl(afpr.prinused,0) else 0 end),0) syprinused
            FROM vw_marginroomsystem pr, vw_afpralloc_all afpr, afmast af, securities_info sb
            WHERE pr.codeid = afpr.codeid(+) AND pr.codeid = sb.codeid
                AND afpr.afacctno = af.acctno(+)
            GROUP BY af.actype, afpr.afacctno, pr.codeid, sb.marginprice, sb.marginrefprice
        ) a, afserisk afs, afmrserisk afm
        WHERE a.actype = afs.actype(+) AND a.codeid = afs.codeid(+)
            AND a.actype = afm.actype(+) AND a.codeid = afm.codeid(+)
        GROUP BY a.codeid, a.roomlimit, a.syroomlimit
    ) a,
    (
        SELECT a.codeid, max(b.selimit) selimit, max(b.selimit) - sum(grp_prinused) grp_pravlremain,
            sum(grp_prinused) grp_prinused, sum(grpcallmargin) grpcallmargin
        FROM
        (
            SELECT grp.codeid, sum(grp_prinused) grp_prinused,
                sum(grp.grp_prinused * nvl(afs.mrratioloan,0) /100 * LEAST(sb.marginprice,afs.mrpriceloan)) grpcallmargin
            FROM v_getsecprgrpinfo grp, afserisk afs, securities_info sb
            WHERE grp.codeid = sb.codeid
                AND grp.actype = afs.actype(+) AND grp.codeid = afs.codeid(+)
            GROUP BY grp.grp_code, grp.codeid
        ) a,
        (
            SELECT codeid, sum(selimit) selimit FROM selimitgrp GROUP BY codeid
        ) b
        WHERE a.codeid = b.codeid
        GROUP BY a.codeid
    ) b
    WHERE sb.codeid = a.codeid(+) AND sb.codeid = b.codeid(+)
        AND sb.codeid = sbs.codeid AND sbs.tradeplace NOT IN ('006','003') AND sb.symbol LIKE V_SYMBOL
        AND nvl(a.syroomlimit,0) + nvl(b.selimit,0) <> 0
    ORDER BY sb.symbol

;
ELSE
OPEN PV_REFCURSOR
  FOR
    SELECT v_date v_date, prgrp.*
    FROM tbl_pr0003_log prgrp
    WHERE prgrp.symbol LIKE V_SYMBOL
        AND nvl(prgrp.syroomlimit,0) + nvl(prgrp.selimit,0) <> 0
        AND prgrp.txdate = v_date


;
END IF;

EXCEPTION
   WHEN OTHERS THEN
   RETURN;
END;
/

