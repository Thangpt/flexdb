CREATE OR REPLACE PROCEDURE pr0004 (
    PV_REFCURSOR    IN OUT   PKG_REPORT.REF_CURSOR,
    OPT             IN       VARCHAR2,
    BRID            IN       VARCHAR2,
    F_DATE          IN       VARCHAR2,
    T_DATE          IN       VARCHAR2,
    PV_CUSTODYCD    IN       VARCHAR2,
    PV_AFACCTNO     IN       VARCHAR2
)
IS
    --Bao cao tong hop cac co phieu co room theo nhom
    -- ---------   ------  -------------------------------------------
    V_STROPTION         VARCHAR2 (5);         -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID           VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
    V_INBRID            VARCHAR2 (4);
    V_CUSTODYCD         VARCHAR2 (50);
    V_AFACCTNO          VARCHAR2 (50);
    V_CURRDATE          DATE;
    V_FULLNAME          VARCHAR2 (500);
    V_IDCODE            VARCHAR2 (50);
    V_IDDATE            DATE;
    V_IDPLACE           VARCHAR2 (500);
    V_ADDRESS           VARCHAR2 (500);

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

    IF PV_CUSTODYCD <> 'ALL' THEN
        V_CUSTODYCD := REPLACE(PV_CUSTODYCD,'.','');
        SELECT fullname, idcode, iddate, idplace, address INTO V_FULLNAME, V_IDCODE, V_IDDATE, V_IDPLACE, V_ADDRESS
        FROM cfmast WHERE custodycd = V_CUSTODYCD;
    ELSE
        V_CUSTODYCD := '%';
    END IF;

    IF PV_AFACCTNO <> 'ALL' THEN
        V_AFACCTNO := PV_AFACCTNO;
    ELSE
        V_AFACCTNO := '%';
    END IF;

    SELECT to_date(varvalue,'DD/MM/RRRR') INTO v_CurrDate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';

OPEN PV_REFCURSOR
  FOR
    SELECT V_CUSTODYCD V_CUSTODYCD, V_AFACCTNO V_AFACCTNO, V_FULLNAME V_FULLNAME, V_IDCODE V_IDCODE, V_IDDATE V_IDDATE,
        V_IDPLACE V_IDPLACE, V_ADDRESS V_ADDRESS, F_DATE F_DATE, T_DATE T_DATE, prgrp.*
    FROM log_pr0004 prgrp
    WHERE prgrp.txdate BETWEEN to_date(F_DATE,'dd/mm/rrrr') AND to_date(T_DATE,'dd/mm/rrrr')
        AND prgrp.custodycd = V_CUSTODYCD AND prgrp.afacctno = V_AFACCTNO

;

EXCEPTION
   WHEN OTHERS THEN
   RETURN;
END;
/

