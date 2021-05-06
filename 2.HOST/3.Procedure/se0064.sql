CREATE OR REPLACE PROCEDURE se0064 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         in        varchar2,
   --F_DATE         IN       VARCHAR2,
   --T_DATE         IN       VARCHAR2,
   --PV_CUSTODYCD   IN       VARCHAR2,
   --PV_AFACCTNO    IN       VARCHAR2,
   --PV_SYMBOL      IN       VARCHAR2,
   PV_SEND        in       varchar2,
   PV_TRADEPLACE    in      varchar2

)
IS
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);

   V_STRAFACCTNO  VARCHAR2 (15);
   V_CUSTODYCD VARCHAR2 (15);
   V_STRSYMBOL VARCHAR2 (10);
   V_FROMDATE       date;
   V_TODATE         date;
   V_INMONTH   VARCHAR2(2);
    V_INYEAR    VARCHAR2(4);
    V_PLSENT      varchar2(100);
    V_TRADEPLACE  varchar(10);


BEGIN
-- GET REPORT'S PARAMETERS
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

    IF TO_NUMBER(SUBSTR(I_DATE,1,2)) <= 12 THEN
        V_FROMDATE := TO_DATE('01/' || SUBSTR(I_DATE,1,2) || '/' || SUBSTR(I_DATE,3,4),'DD/MM/YYYY');
    ELSE
        V_FROMDATE := TO_DATE('31/12/9999','DD/MM/YYYY');
    END IF;
    V_TODATE := LAST_DAY(V_FROMDATE);
    select cdcontent into V_PLSENT from allcode where cdname = 'BRANCH' and cdval = PV_SEND;
    V_INMONTH := SUBSTR(I_DATE,1,2);
    V_INYEAR :=  SUBSTR(I_DATE,3,4);

    if PV_TRADEPLACE = 'ALL' then
        V_TRADEPLACE := '%';
    else V_TRADEPLACE := PV_TRADEPLACE;
    end if;

/*
   IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;


   IF  (PV_AFACCTNO <> 'ALL')
   THEN
         V_STRAFACCTNO := PV_AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%';
   END IF;

   IF  (UPPER(PV_SYMBOL) <> 'ALL' AND PV_SYMBOL IS NOT NULL)
   THEN
         V_STRSYMBOL := PV_SYMBOL;
   ELSE
      V_STRSYMBOL := '%';
   END IF;*/

-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
select to_date(V_TODATE,'DD/MM/RRRR') txdate, ' ' fullname, '' acctno, '' custodycd, '' symbol,
        '' securitiesname, 0 qtty, 0 price, 0 basicprice,
        '' descustodycd,
        V_INBRID brid, V_PLSENT sendto, V_INMONTH imonth, V_INYEAR iyear from dual
union all
SELECT se.txdate, cf.fullname, af.acctno, cf.custodycd, sb.symbol,
        iss.fullname securitiesname, msgamt qtty, se.price, si.basicprice,
       cf2.custodycd descustodycd,
        V_INBRID brid, V_PLSENT sendto, V_INMONTH imonth, V_INYEAR iyear
FROM seretail se, vw_tllog_all tl,
cfmast cf, afmast af, sbsecurities sb, issuers iss, securities_info si, afmast af2, cfmast cf2
WHERE substr(se.acctno,1,10) = af.acctno AND af.custid = cf.custid
AND substr(se.acctno,11,6) = sb.codeid AND sb.issuerid = iss.issuerid
and sb.codeid = si.codeid
AND se.status <> 'R'
AND tl.txdate = se.txdate AND tl.txnum = se.txnum
and cf2.custid = af2.custid and af2.acctno = substr(desacctno,1,10)
AND se.sdate <= to_date(V_TODATE,'DD/MM/RRRR')
AND se.sdate >= to_date(V_FROMDATE,'DD/MM/RRRR')
--AND sb.symbol LIKE V_STRSYMBOL
--AND cf.custodycd LIKE V_CUSTODYCD
--AND af.acctno LIKE V_STRAFACCTNO
AND (substr(cf.custid,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(cf.custid,1,4))<> 0)
AND    (case when V_TRADEPLACE = '999' and sb.TRADEPLACE IN ('001','002') then '999'
             WHEN V_TRADEPLACE = '888' AND sb.tradeplace in ('002','005') THEN '888'
            else sb.TRADEPLACE end ) LIKE V_TRADEPLACE
ORDER BY custodycd
;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

