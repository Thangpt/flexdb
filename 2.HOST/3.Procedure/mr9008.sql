CREATE OR REPLACE PROCEDURE mr9008 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   SYMBOL         IN       VARCHAR2,
   BASKETID       IN       VARCHAR2,
   MAKER          IN       VARCHAR2,
   CHECKER        IN       VARCHAR2,
   ACTION         IN       VARCHAR2,
   PV_IMP         IN       VARCHAR2
   )
IS

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_FROMDATE     DATE;
   V_TODATE       DATE;
   V_SYMBOL       VARCHAR2(20);
   V_BASKETID     VARCHAR2(50);
   V_MAKER        VARCHAR2(20);
   V_CHECKER      VARCHAR2(20);
   V_ACTION       VARCHAR2(20);
   V_IMP          VARCHAR2(20);

BEGIN
   V_STROPTION := OPT;

   IF V_STROPTION = 'A' THEN     -- TOAN HE THONG
      V_STRBRID := '%';
   ELSIF V_STROPTION = 'B' THEN
      V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
   ELSE
      V_STRBRID := BRID;
   END IF;

   IF(SYMBOL <> 'ALL') THEN
      V_SYMBOL := REPLACE(SYMBOL,' ','_');
   ELSE
      V_SYMBOL := '%';
   END IF;

   IF(BASKETID <> 'ALL') THEN
      V_BASKETID := BASKETID;
   ELSE
      V_BASKETID := '%';
   END IF;

   IF(MAKER <> 'ALL') THEN
      V_MAKER := MAKER;
   ELSE
      V_MAKER := '%';
   END IF;

   IF(CHECKER <> 'ALL') THEN
      V_CHECKER := CHECKER;
   ELSE
      V_CHECKER := '%';
   END IF;

   IF(ACTION <> 'ALL') THEN
      V_ACTION := ACTION;
   ELSE
      V_ACTION := '%';
   END IF;

   IF(PV_IMP <> 'ALL') THEN
      V_IMP := PV_IMP;
   ELSE
      V_IMP := '%';
   END IF;

   V_FROMDATE  :=    TO_DATE(F_DATE,'DD/MM/YYYY');
   V_TODATE    :=    TO_DATE(T_DATE,'DD/MM/YYYY');

OPEN PV_REFCURSOR
FOR
    SELECT txdate, txtime, basketid, symbol, mrratiorate, mrratioloan, mrpricerate, mrpriceloan,
        mrratiorate_old, mrratioloan_old, mrpricerate_old, mrpriceloan_old,
        t1.tlname makerid, t2.tlname checkerid, action
    FROM secbasket_log l, tlprofiles t1, tlprofiles t2
    WHERE l.makerid = t1.tlid AND l.checkerid = t2.tlid AND l.symbol LIKE V_SYMBOL
        AND REPLACE(l.basketid,'_',' ') LIKE V_BASKETID
        AND l.makerid LIKE V_MAKER
        AND l.checkerid LIKE V_CHECKER
        AND l.action LIKE '%'||V_ACTION
        AND l.action LIKE V_IMP||'%'
        AND l.txdate BETWEEN V_FROMDATE AND V_TODATE
    ORDER BY symbol, basketid, txdate, txtime
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

