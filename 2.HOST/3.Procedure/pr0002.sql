CREATE OR REPLACE PROCEDURE pr0002 (
    PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
    OPT            IN       VARCHAR2,
    BRID           IN       VARCHAR2,
    I_DATE         IN       VARCHAR2,
    PRGRP          IN       VARCHAR2,
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
    V_PRGRP            VARCHAR2 (20);
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

    IF PRGRP <> 'ALL' THEN
        V_PRGRP := trim(PRGRP);
    ELSE
        V_PRGRP := '%';
    END IF;

    SELECT max(sbdate) INTO v_date  FROM sbcurrdate WHERE sbtype ='B' AND sbdate <= to_date(I_DATE,'DD/MM/RRRR');
    SELECT to_date(varvalue,'DD/MM/RRRR') INTO v_CurrDate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';

IF v_date = v_CurrDate THEN
OPEN PV_REFCURSOR
  FOR
    SELECT v_date v_date, sel.selimit, sb.symbol, sel.grpname grpname, nvl(prgrp.grp_pravlremain,0) grp_pravlremain,
        sum(nvl(prgrp.grp_prinused,0)) grp_prinused, sel.note
    FROM selimitgrp sel, v_getsecprgrpinfo prgrp, sbsecurities sb
    WHERE sel.autoid = prgrp.grp_code(+) AND sel.codeid = sb.codeid
        AND sb.symbol LIKE V_SYMBOL
        AND sel.autoid LIKE trim(V_PRGRP)
    GROUP BY sel.grpname, sel.selimit, sb.symbol, prgrp.grp_pravlremain, sel.note
    ORDER BY sb.symbol
;

ELSE
OPEN PV_REFCURSOR
  FOR
    SELECT txdate v_date, prgrp.selimit, prgrp.symbol, se.grpname grpname, prgrp.grp_pravlremain, sum(prgrp.grp_prinused) grp_prinused, prgrp.note
    FROM tbl_pr0002_log prgrp, selimitgrp se
    WHERE prgrp.grp_code = se.autoid AND prgrp.symbol LIKE V_SYMBOL
        AND prgrp.grp_code LIKE trim(V_PRGRP)
        AND prgrp.txdate = v_date
    GROUP BY prgrp.selimit, prgrp.symbol, se.grpname, prgrp.grp_pravlremain, prgrp.note
    ORDER BY prgrp.symbol

;
END IF;

EXCEPTION
   WHEN OTHERS THEN
   RETURN;
END;
/

