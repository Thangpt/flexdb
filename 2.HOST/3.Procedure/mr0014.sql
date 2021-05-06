CREATE OR REPLACE PROCEDURE mr0014 (
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

    SELECT nvl(sum(intnmlpbl),0) INTO l_intnmlpbl
       FROM lnmast WHERE ftype <> 'DF';

    SELECT to_date(varvalue,'DD/MM/RRRR') INTO v_CurrDate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';


IF v_date = v_CurrDate THEN
OPEN PV_REFCURSOR
  FOR
    SELECT a.*, I_DATE I_DATE FROM
    (
        --SELECT '1' STT, 'UTTB' custbank, nvl(sum(amt),0) aamt, nvl(sum(feeamt),0) intamt FROM vw_adschd_all WHERE txdate = v_date
        SELECT '1' STT, 'UTTB' custbank, nvl(sum(amt),0) - sum(CASE WHEN paiddate <= v_date THEN nvl(a.paidamt,0) - nvl(feeamt,0) ELSE 0 END)  aamt,
            nvl(sum(feeamt),0) - sum(CASE WHEN paiddate <= v_date THEN nvl(a.paidamt,0) - nvl(amt,0) ELSE 0 END) intamt
        FROM vw_adschd_all a
        WHERE txdate <= v_date
    UNION ALL
        SELECT '2' STT, 'BL' custbank,
            sum(ls.nml + ls.ovd) lnprin,
            sum(ls.intnmlacr + ls.intdue + ls.intovd + ls.intovdprin +
                ls.feeintnmlacr + ls.feeintdue + ls.feeintnmlovd + ls.feeintovdacr + ls.feeovd) + l_intnmlpbl intamt
        FROM lnmast ln, lnschd ls WHERE ln.acctno = ls.acctno
            AND ls.reftype IN ('GP')
    UNION ALL
        SELECT '3' STT, CASE WHEN ln.rrtype = 'B' THEN 'KB-Topup '||cf.shortname ELSE 'KB-Margin' END custbank,
            sum(ls.nml + ls.ovd) lnprin,
            sum(ls.intnmlacr + ls.intdue + ls.intovd + ls.intovdprin +
                ls.feeintnmlacr + ls.feeintdue + ls.feeintnmlovd + ls.feeintovdacr + ls.feeovd) intamt
        FROM lnmast ln, lnschd ls, cfmast cf WHERE ln.acctno = ls.acctno AND ln.custbank = cf.custid(+)
            AND ls.reftype IN ('P')
        GROUP BY CASE WHEN ln.rrtype = 'B' THEN 'KB-Topup '||cf.shortname ELSE 'KB-Margin' END
    ) a
    ORDER BY stt
;
ELSE
OPEN PV_REFCURSOR
  FOR
    SELECT a.*, I_DATE I_DATE FROM
    (
        --SELECT '1' STT, 'UTTB' custbank, nvl(sum(amt),0) aamt, nvl(sum(feeamt),0) intamt FROM vw_adschd_all WHERE txdate = v_date
        SELECT '1' STT, 'UTTB' custbank, nvl(sum(amt),0) - sum(CASE WHEN paiddate <= v_date THEN nvl(a.paidamt,0) - nvl(feeamt,0) ELSE 0 END)  aamt,
            nvl(sum(feeamt),0) - sum(CASE WHEN paiddate <= v_date THEN nvl(a.paidamt,0) - nvl(amt,0) ELSE 0 END) intamt
        FROM vw_adschd_all a
        WHERE txdate <= v_date
    UNION ALL
        SELECT '2' STT, 'BL' custbank, nvl(sum(mr.t0prinamt),0) advalceline, nvl(sum(mr.t0intamt),0) intamt FROM mr5005_log mr WHERE txdate = v_date
    UNION ALL
        SELECT '3' STT, CASE WHEN mr.rrtype = 'B' THEN 'KB-Topup '||cf.shortname ELSE 'KB-Margin' END custbank, sum(mrprinamt) amt, nvl(sum(mr.mrintamt),0) intamt
        FROM mr5005_log mr, cfmast cf
        WHERE txdate = v_date AND mr.custbank = cf.custid (+)
        GROUP BY CASE WHEN mr.rrtype = 'B' THEN 'KB-Topup '||cf.shortname ELSE 'KB-Margin' END
    ) a
    ORDER BY stt
;
END IF;

EXCEPTION
   WHEN OTHERS
   THEN RETURN;
END;
/

