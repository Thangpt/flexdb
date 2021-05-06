CREATE OR REPLACE PROCEDURE ln1006_3 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   p_OPT            IN       VARCHAR2,
   p_BRID           IN       VARCHAR2,
   p_I_DATE         IN       VARCHAR2,
   p_BANKNAME       IN       VARCHAR2,
   --p_LOANTYPE       IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2
       )
IS
-- ---------   ------  -------------------------------------------
    l_LOANTYPE          varchar2(100);
    l_BANKNAME          varchar2(100);
    l_OPT               varchar2(10);
    l_BRID              varchar2(1000);
    l_BRID_FILTER       varchar2(1000);
    l_INITRLSDATE       date;
    V_CUSTODYCD         VARCHAR2(10);
    V_AFACCTNO          VARCHAR2(10);
    V_BRID              VARCHAR2(4);

BEGIN
    -- GET REPORT'S PARAMETERS
    l_BANKNAME:=p_BANKNAME;

    --l_LOANTYPE:=p_LOANTYPE;

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

    SELECT ads.TEN_KH fullname, ads.custodycd, b.contractno, ln.DU_NO amtu, ads.tien_gn amt,  nvl(b.lmamtmax,0) limitamt,
        ads.NGAY_UT txdate, ads.NGAY_THU_NO cleardt, b.txdate bankdate, ads.NGAYKHOP oddate, to_date(p_I_DATE,'DD/MM/RRRR') I_DATE
    FROM
    (
        SELECT DISTINCT AF.acctno acctno, nvl(sum(ads.amt + nvl(ads.feeamt,0)),0) tien_gn,
            CF.fullname TEN_KH, CF.custodycd CUSTODYCD, CHD.txdate NGAY_UT,CHD.cleardt NGAY_THU_NO,CHD.oddate NGAYKHOP
        FROM vw_adschd_all CHD, adsource ADS, afmast AF, CFMAST CF
        WHERE CHD.autoid = ADS.autoid
            AND ADS.acctno = AF.acctno
            AND AF.custid = CF.custid
            AND ADS.DELTD <>'Y'
            --AND ADS.STATUS ='N'
            AND (af.brid LIKE l_BRID_FILTER OR instr(l_BRID_FILTER,af.brid) <> 0)
        GROUP BY AF.acctno, CF.fullname, CF.custodycd ,CHD.txdate,CHD.cleardt,CHD.oddate
    ) ads,
    (
        SELECT acctno, SUM(nvl(ads.amt, 0) + nvl(ads.feeamt, 0)- (CASE WHEN to_date(p_I_DATE,'DD/MM/RRRR') >= ads.cleardt THEN ads.amt + ads.feeamt ELSE 0 END)) DU_NO
        FROM adsource ads
        WHERE (ads.amt > 0 OR ads.paiddate = getcurrdate)
            AND ads.txdate < to_date(p_I_DATE,'DD/MM/RRRR')
        GROUP BY acctno
    ) ln,
    (
        SELECT b.*, cf.custid, cf.shortname, cf.fullname, nvl(cfl.lmamtmax,0) lmamtmax
        FROM bankcontractinfo b, cfmast cf, cflimit cfl
        WHERE b.bankcode = cf.shortname AND b.typecont ='ADV'
            AND cf.custid = cfl.bankid(+) AND cfl.lmsubtype(+) = 'ADV'
    ) b
    WHERE ads.acctno = ln.acctno(+)
        AND ads.acctno = b.acctno(+)
        AND ads.NGAY_UT = to_date(p_I_DATE,'DD/MM/RRRR')
        AND ads.acctno LIKE V_AFACCTNO AND ads.custodycd LIKE V_CUSTODYCD
        AND CASE WHEN l_BANKNAME = 'ALL' THEN 1
                WHEN nvl(b.shortname,'MSBS') = l_BANKNAME THEN 1
            ELSE 0
            END = 1
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

