CREATE OR REPLACE PROCEDURE mr0015 (
    PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
    OPT            IN       VARCHAR2,
    BRID           IN       VARCHAR2,
    I_DATE         IN       VARCHAR2
)
IS
    --Bao cao tong hop du no
    -- ---------   ------  -------------------------------------------
    V_STROPTION        VARCHAR2 (5);         -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
    V_INBRID           VARCHAR2 (4);
    V_IDATE            DATE;
    V_CURRDATE         DATE;

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

    SELECT max(sbdate) INTO V_IDATE FROM sbcurrdate WHERE sbtype ='B' AND sbdate <= to_date(I_DATE,'DD/MM/RRRR');
    SELECT to_date(varvalue,'DD/MM/RRRR') INTO v_CurrDate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';

IF v_idate = v_CurrDate THEN
-- GET REPORT'S DATA
    OPEN PV_REFCURSOR
        FOR
    SELECT v.symbol, sum(v.usedsysroom) usedsysroom, sum(v.usedsysroom_amt) usedsysroom_amt
    FROM
    (
        SELECT v.symbol, decode(nvl(v.roomchk,'Y'),'Y',v.usedsysroom,nvl(v.usedgrproom,0)) usedsysroom,
            decode(nvl(v.roomchk,'Y'),'Y',v.usedsysroom,nvl(v.usedgrproom,0))*v.pricecl*v.ratecl/100 usedsysroom_amt
        FROM vw_mr9004 v, cfmast cf, afmast af
        WHERE cf.custodycd = v.custodycd AND v.afacctno = af.acctno
            AND v.usedsysroom > 0
    ) v
    GROUP BY v.symbol
    ORDER BY v.symbol;

ELSE
  -- GET REPORT'S DATA
    OPEN PV_REFCURSOR
        FOR
    SELECT v.symbol, sum(v.usedsysroom) usedsysroom, sum(v.usedsysroom_amt) usedsysroom_amt
    FROM
    (
        SELECT v.symbol, decode(nvl(v.roomchk,'Y'),'Y',v.usedsysroom,nvl(v.usedgrproom,0)) usedsysroom,
            decode(nvl(v.roomchk,'Y'),'Y',v.usedsysroom,nvl(v.usedgrproom,0))*v.pricecl*v.ratecl/100 usedsysroom_amt
        FROM tbl_mr3007_log  v, cfmast cf, afmast af
        WHERE txdate = V_IDATE AND cf.custodycd = v.custodycd AND af.acctno = v.afacctno
            AND v.usedsysroom > 0
    ) v
    GROUP BY v.symbol
    ORDER BY v.symbol;

END IF;

EXCEPTION
   WHEN OTHERS
   THEN RETURN;
END;
/

