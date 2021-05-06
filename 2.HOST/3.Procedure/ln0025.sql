CREATE OR REPLACE PROCEDURE ln0025 (
    PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
    OPT            IN       VARCHAR2,
    BRID           IN       VARCHAR2,
    I_DATE         IN       VARCHAR2,
    PV_CUSTODYCD   IN       VARCHAR2,
    PV_AFACCTNO    IN       VARCHAR2,
    GRCAREBY       IN       VARCHAR2,
    REID           IN       VARCHAR2,
    SYMBOL         IN       VARCHAR2
)
IS
    V_STROPTION      VARCHAR2 (5);             -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID        VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
    V_INBRID         VARCHAR2 (5);

    V_DATE           DATE;
    V_CUSTODYCD     VARCHAR2 (10);
    V_AFACCTNO      VARCHAR2 (10);
    V_GRCAREBY      VARCHAR2 (10);
    V_REID          VARCHAR2 (10);
    V_SYMBOL        VARCHAR2 (10);

BEGIN
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

    IF (V_STROPTION = 'A') THEN
        V_STRBRID := '%';
    ELSE
        IF (V_STROPTION = 'B') THEN
            SELECT br.mapid INTO V_STRBRID FROM brgrp br WHERE br.brid = V_INBRID;
        ELSE
            V_STRBRID := BRID;
        END IF;
    END IF;

    IF(PV_CUSTODYCD <> 'ALL') THEN
        V_CUSTODYCD := PV_CUSTODYCD;
    ELSE
        V_CUSTODYCD := '%';
    END IF;

    IF(PV_AFACCTNO <> 'ALL') THEN
        V_AFACCTNO := PV_AFACCTNO;
    ELSE
        V_AFACCTNO := '%';
    END IF;

    IF(GRCAREBY <> 'ALL') THEN
        V_GRCAREBY := GRCAREBY;
    ELSE
        V_GRCAREBY := '%';
    END IF;

    IF(REID <> 'ALL') THEN
        V_REID := REID;
    ELSE
        V_REID := '%';
    END IF;

    IF(SYMBOL <> 'NULL') THEN
        V_SYMBOL := SYMBOL;
    ELSE
        V_SYMBOL := ' ';
    END IF;

    V_DATE := TO_DATE(I_DATE,'DD/MM/RRRR');

IF V_DATE = getcurrdate THEN
    OPEN PV_REFCURSOR
    FOR

    SELECT cf.custodycd, af.acctno, cf.fullname, aft.actype, nvl(ln.t0amt,0) t0amt, nvl(ci.balance,0) balance, nvl(adv.avladvance,0) avladvance,
        GREATEST((nvl(ln.t0amt,0) - nvl(ci.balance,0) - nvl(adv.avladvance,0)),0) realt0amt,
        V_SYMBOL symbol, nvl(se.qtty,0) qtty, re.refullname, V_DATE V_DATE
    FROM afmast af, cfmast cf, aftype aft,
        (SELECT trfacctno, nvl(sum(t0amt),0) t0amt, nvl(sum(marginamt),0) marginamt
        FROM vw_lngroup_all
        WHERE trfacctno LIKE V_AFACCTNO GROUP BY trfacctno) ln,
        (SELECT afacctno, balance, depofeeamt depofeeamt FROM cimast WHERE acctno LIKE V_AFACCTNO) ci,
        (SELECT afacctno, nvl(sum(depoamt),0) avladvance FROM v_getaccountavladvance WHERE afacctno LIKE V_AFACCTNO GROUP BY afacctno) adv,
        (SELECT raf.afacctno, rcf.custid, cf.fullname refullname FROM recflnk rcf, reaflnk raf, retype ret, cfmast cf
        WHERE rcf.autoid = raf.refrecflnkid AND raf.status = 'A'
            AND rcf.custid = cf.custid AND raf.afacctno LIKE V_AFACCTNO
            AND substr(raf.reacctno,11,4) = ret.actype AND ret.rerole IN ('BM','RM')
            AND getcurrdate BETWEEN raf.frdate AND nvl(raf.clstxdate-1,raf.todate)) re,
        (SELECT afacctno, symbol, (trade + mortage + totalreceiving - sellmatchqtty + totalbuyqtty) qtty
        FROM vw_mr9004 WHERE symbol = V_SYMBOL AND (trade + mortage + totalreceiving - sellmatchqtty + totalbuyqtty) > 0
            AND custodycd LIKE V_CUSTODYCD AND afacctno LIKE V_AFACCTNO
        ) se
    WHERE cf.custid = af.custid AND af.acctno = ln.trfacctno(+)
        AND af.acctno = se.afacctno(+) AND nvl(ln.t0amt,0) > 0
        AND af.actype = aft.actype AND af.acctno = adv.afacctno(+)
        AND af.acctno = ci.afacctno AND af.acctno = re.afacctno(+)
        AND cf.custodycd LIKE V_CUSTODYCD AND af.acctno LIKE V_AFACCTNO
        AND af.careby LIKE V_GRCAREBY AND nvl(re.custid,' ') LIKE V_REID
	ORDER BY cf.custodycd, af.acctno
    ;
ELSE
    OPEN PV_REFCURSOR
    FOR

    SELECT cf.custodycd, af.acctno, cf.fullname, aft.actype, nvl(log.t0amt,0) t0amt, nvl(log.balance,0) balance, nvl(log.avladvance,0) avladvance,
        GREATEST((nvl(log.t0amt,0) - nvl(log.balance,0) - nvl(log.avladvance,0)),0) realt0amt,
        V_SYMBOL symbol, nvl(se.qtty,0) qtty, re.refullname, V_DATE V_DATE
    FROM afmast af, cfmast cf, aftype aft,
        (SELECT afacctno, max(t0amt) t0amt, max(balance) balance, max(avladvance) avladvance
        FROM tbl_mr3007_log WHERE txdate = V_DATE GROUP BY afacctno) log,
        (SELECT raf.afacctno, rcf.custid, cf.fullname refullname FROM recflnk rcf, reaflnk raf, retype ret, cfmast cf
        WHERE rcf.autoid = raf.refrecflnkid AND raf.status = 'A'
            AND rcf.custid = cf.custid
            AND substr(raf.reacctno,11,4) = ret.actype AND ret.rerole IN ('BM','RM')
            AND getcurrdate BETWEEN raf.frdate AND nvl(raf.clstxdate-1,raf.todate)) re,
        (SELECT afacctno, symbol, (trade + mortage + totalreceiving - sellmatchqtty + totalbuyqtty) qtty
        FROM tbl_mr3007_log WHERE txdate = V_DATE AND (trade + mortage + totalreceiving - sellmatchqtty + totalbuyqtty) > 0
            AND symbol = V_SYMBOL AND custodycd LIKE V_CUSTODYCD AND afacctno LIKE V_AFACCTNO) se
    WHERE cf.custid = af.custid AND af.actype = aft.actype AND af.acctno = log.afacctno(+)
        AND af.acctno = re.afacctno(+) AND af.acctno = se.afacctno(+) AND nvl(log.t0amt,0) > 0
        AND cf.custodycd LIKE V_CUSTODYCD AND af.acctno LIKE V_AFACCTNO
        AND af.careby LIKE V_GRCAREBY AND nvl(re.custid,' ') LIKE V_REID
	ORDER BY cf.custodycd, af.acctno
    ;
END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

