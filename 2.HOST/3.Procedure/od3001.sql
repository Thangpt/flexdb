CREATE OR REPLACE PROCEDURE od3001 (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   F_DATE           IN       VARCHAR2,
   T_DATE           IN       VARCHAR2,
   PV_REGTYPE          IN      VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
       )
IS
    --
    -- PURPOSE: BAO CAO DANG KY/HUY DANG KY BLOOMBERG
    --
    -- MODIFICATION HISTORY
    -- PERSON      DATE    COMMENTS
    -- TheNN       22-Jun-2013  Created
    -- ---------   ------  -------------------------------------------
    V_BRID          VARCHAR2(4);
    V_STROPTION     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID       VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
    V_INBRID        VARCHAR2 (5);
    V_REGTYPE       VARCHAR2(10);
    V_CUSTODYCD     varchar2(10);
    V_AFACCTNO      varchar2(10);
    V_CAREBY        varchar2(10);

BEGIN

    V_STROPTION := upper(OPT);
    V_INBRID := BRID;

    IF PV_REGTYPE = 'ALL' THEN
        V_REGTYPE := '%%';
    ELSE
        V_REGTYPE := PV_REGTYPE;
    END IF;

    IF PV_CUSTODYCD = 'ALL' THEN
        V_CUSTODYCD := '%%';
    ELSE
        V_CUSTODYCD := PV_CUSTODYCD;
    END IF;

    IF PV_AFACCTNO = 'ALL' THEN
        V_AFACCTNO := '%%';
    ELSE
        V_AFACCTNO := PV_AFACCTNO;
    END IF;

OPEN PV_REFCURSOR FOR
    SELECT TO_CHAR(TXDATE,'DD/MM/YYYY') TXDATE, CUSTODYCD, AFACCTNO, FULLNAME, CAREBYNAME, CAREBYID, REGTYPE
    FROM
    (
        SELECT blr.regdate TXDATE, cf.CUSTODYCD, blr.AFACCTNO, cf.FULLNAME, blr.blacctno CAREBYNAME, tlg.grpid CAREBYID, 'R' REGTYPE
        FROM bl_register blr, cfmast cf, tlgroups tlg,afmast af
        WHERE blr.afacctno = af.acctno AND af.custid = cf.custid
            AND cf.careby = tlg.grpid
            --AND af.acctno = re.afacctno (+)
            AND blr.regdate >= to_date(F_DATE, 'dd/mm/yyyy')
            AND blr.regdate <= to_date(T_DATE, 'dd/mm/yyyy')
            AND cf.custodycd LIKE V_CUSTODYCD
            AND blr.afacctno LIKE V_AFACCTNO
            --AND tlg.grpid LIKE V_CAREBY
        UNION ALL
        SELECT blr.clsdate TXDATE, cf.CUSTODYCD, blr.AFACCTNO, cf.FULLNAME, blr.blacctno CAREBYNAME, tlg.grpid CAREBYID, 'C' REGTYPE
        FROM bl_register blr, cfmast cf, tlgroups tlg, afmast af
        WHERE blr.afacctno = af.acctno AND af.custid = cf.custid
            AND cf.careby = tlg.grpid AND blr.clsdate IS NOT NULL
            --AND af.acctno = re.afacctno (+)
            AND blr.clsdate >= to_date(F_DATE, 'dd/mm/yyyy')
            AND blr.clsdate <= to_date(T_DATE, 'dd/mm/yyyy')
            AND cf.custodycd LIKE V_CUSTODYCD
            AND blr.afacctno LIKE V_AFACCTNO
            --AND tlg.grpid LIKE V_CAREBY
    ) BL
    WHERE BL.regtype LIKE V_REGTYPE
    ORDER BY bl.regtype DESC, bl.txdate DESC, bl.custodycd;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
