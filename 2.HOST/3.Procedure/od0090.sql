CREATE OR REPLACE PROCEDURE od0090 (
    PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
    P_OPT            IN       VARCHAR2,
    P_BRID           IN       VARCHAR2,
    P_F_DATE         IN       VARCHAR2,
    P_T_DATE         IN       VARCHAR2,
    PV_CUSTODYCD     IN       VARCHAR2,
    PV_AFACCTNO      IN       VARCHAR2,
    P_BANKNAME       IN       VARCHAR2
       )
IS
-- ---------   ------  -------------------------------------------
    L_LOANTYPE          VARCHAR2(100);
    L_BANKNAME          VARCHAR2(100);
    L_OPT               VARCHAR2(10);
    L_BRID              VARCHAR2(1000);
    L_BRID_FILTER       VARCHAR2(1000);
    L_INITRLSDATE       DATE;
    V_CUSTODYCD         VARCHAR2(10);
    V_AFACCTNO          VARCHAR2(10);
    V_BRID              VARCHAR2(4);

BEGIN
    -- GET REPORT'S PARAMETERS
    l_OPT:=p_OPT;

    IF PV_CUSTODYCD = 'ALL' OR PV_CUSTODYCD IS NULL THEN
       V_CUSTODYCD := '%%';
    ELSE
        V_CUSTODYCD := UPPER( PV_CUSTODYCD);
    END IF;

    IF PV_AFACCTNO = 'ALL' OR PV_AFACCTNO IS NULL THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := UPPER( PV_AFACCTNO);
    END IF;

    IF (l_OPT = 'A') THEN
      l_BRID_FILTER := '%';
    ELSE if (l_OPT = 'B') then
            select brgrp.mapid into l_BRID_FILTER from brgrp where brgrp.brid = p_BRID;
        else
            l_BRID_FILTER := p_BRID;
        end if;
    END IF;

-- GET REPORT'S DATA
OPEN PV_REFCURSOR FOR

    SELECT cf.custodycd, cf.fullname, od.orderid, od.txtime, a1.cdcontent matchtype, sb.symbol,
        sum(iod.matchqtty) matchqtty, iod.matchprice, sum(iod.matchqtty*iod.matchprice) matchamt, iod.txdate
    FROM cfmast cf, afmast af, sbsecurities sb, allcode a1,
        (
            SELECT * FROM vw_odmast_all WHERE txdate >= to_date(P_F_DATE,'DD/MM/RRRR') AND txdate <= to_date(P_T_DATE,'DD/MM/RRRR') AND deltd <> 'Y' AND exectype IN ('NS','MS')
        ) od,
        (
            SELECT * FROM vw_iod_all WHERE txdate >= to_date(P_F_DATE,'DD/MM/RRRR') AND txdate <= to_date(P_T_DATE,'DD/MM/RRRR') AND deltd <> 'Y'
        ) iod,
        (
            SELECT DISTINCT AF.acctno acctno, CHD.oddate
            FROM vw_adschd_all CHD, adsource ADS, afmast AF, CFMAST CF
            WHERE CHD.autoid = ADS.autoid
                AND ADS.acctno = AF.acctno
                AND AF.custid = CF.custid
                AND ADS.DELTD <>'Y'
                AND chd.oddate >= to_date(P_F_DATE,'DD/MM/RRRR') AND chd.oddate <= to_date(P_T_DATE,'DD/MM/RRRR')
        ) ad,
        (
            SELECT b.*, cf.custid, cf.shortname, cf.fullname, nvl(cfl.lmamtmax,0) lmamtmax
            FROM bankcontractinfo b, cfmast cf, cflimit cfl
            WHERE b.bankcode = cf.shortname AND b.typecont ='ADV'
                AND cf.custid = cfl.bankid(+) AND cfl.lmsubtype(+) = 'ADV'
        ) b
    WHERE cf.custid = af.custid AND od.afacctno = af.acctno
        AND od.orderid = iod.orgorderid AND od.codeid = sb.codeid
        AND od.matchtype = a1.cdval AND a1.cdname = 'MATCHTYPE' AND a1.cdtype = 'OD'
        AND od.afacctno = ad.acctno AND od.txdate = ad.oddate
        AND od.afacctno = b.acctno(+)
        AND cf.custodycd LIKE V_CUSTODYCD AND af.acctno LIKE V_AFACCTNO
        AND (af.brid LIKE l_BRID_FILTER OR instr(l_BRID_FILTER,af.brid) <> 0)
        AND CASE WHEN P_BANKNAME = 'ALL' THEN 1
                WHEN nvl(b.shortname,'KBSV') = P_BANKNAME THEN 1
            ELSE 0
            END = 1
    GROUP BY cf.custodycd, cf.fullname, od.orderid, od.txtime, a1.cdcontent, sb.symbol, iod.matchprice, iod.txdate
    ORDER BY cf.custodycd, cf.fullname, iod.txdate, od.txtime

;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

