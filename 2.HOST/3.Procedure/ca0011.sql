CREATE OR REPLACE PROCEDURE ca0011 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CACODE         IN       VARCHAR2,
   PLSENT         in       varchar2 -- MA SU KIEM
   )
IS
--
-- RePort NAME: GIAY DANG KY MUA CK
-- Date : 24/05/2011
-- Hien.vu
-----------------------------------------------

V_STRCACODE   VARCHAR2 (20);

BEGIN
V_STRCACODE :=  CACODE;
-- GET REPORT'S PARAMETERS
OPEN PV_REFCURSOR
   FOR
   /*
SELECT   cf.custid, PLSENT sendto, cf.fullname, af.acctno, ca.camastid, sec.*,
         ca.reportdate, SUBSTR (cf.custodycd, 4, 1) custodycd,
         caschd.pqtty pqtty , caschd.qtty, caschd.aamt, ca.exprice
  FROM   cfmast cf, afmast af, caschd, camast ca,
         (SELECT   sb.codeid,
                   iss.issuerid,
                   iss.shortname seccode,
                   iss.fullname secname,
                   sb.parvalue
            FROM   issuers iss, sbsecurities sb
           WHERE   iss.issuerid = sb.issuerid) sec
 WHERE       cf.custid = af.custid
         AND af.acctno = caschd.afacctno
         AND caschd.camastid = ca.camastid
         AND caschd.codeid = sec.codeid
         AND caschd.deltd <> 'Y'
         AND caschd.status <> 'C'
         AND ca.deltd <> 'Y'
         AND ca.status <> 'C'
         AND ca.catype = '014'
         AND ca.camastid = v_strcacode;
         */
SELECT PLSENT sendto, sec.secname, sec.seccode, sec.parvalue, ca.exprice, ca.reportdate, MAX(CA.VNCODE) VNCODE,
----    SUBSTR (cf.custodycd, 4, 1) custodycd,
    sum(case when SUBSTR (cf.custodycd,4,1) = 'C' then caschd.qtty + caschd.sendqtty + caschd.cutqtty else 0 end) c_qtty,
    sum(case when SUBSTR (cf.custodycd,4,1) = 'F' then caschd.qtty + caschd.sendqtty + caschd.cutqtty else 0 end) f_qtty,
    sum(case when SUBSTR (cf.custodycd,4,1) = 'P' then caschd.qtty + caschd.sendqtty + caschd.cutqtty else 0 end) p_qtty,
    -- caschd.pbalance+caschd.roretailbal
/*
    sum(case when SUBSTR (cf.custodycd,4,1) = 'C' then caschd.retailbal+caschd.roretailbal+caschd.inbalance else 0 end) c_pqtty,
    sum(case when SUBSTR (cf.custodycd,4,1) = 'F' then caschd.retailbal+caschd.roretailbal+caschd.inbalance else 0 end) f_pqtty,
    sum(case when SUBSTR (cf.custodycd,4,1) = 'P' then caschd.retailbal+caschd.roretailbal+caschd.inbalance else 0 end) p_pqtty,
*/

    sum(case when SUBSTR (cf.custodycd,4,1) = 'C' then caschd.pbalance+caschd.balance else 0 end) c_pqtty,
    sum(case when SUBSTR (cf.custodycd,4,1) = 'F' then caschd.pbalance+caschd.balance else 0 end) f_pqtty,
    sum(case when SUBSTR (cf.custodycd,4,1) = 'P' then caschd.pbalance+caschd.balance else 0 end) p_pqtty,

    sum(case when SUBSTR (cf.custodycd,4,1) = 'C' then caschd.aamt else 0 end) c_aamt,
    sum(case when SUBSTR (cf.custodycd,4,1) = 'F' then caschd.aamt else 0 end) f_aamt,
    sum(case when SUBSTR (cf.custodycd,4,1) = 'P' then caschd.aamt else 0 end) p_aamt
FROM cfmast cf, afmast af, caschd, camast ca,
    (
        SELECT sb.codeid, iss.issuerid, iss.shortname seccode, iss.fullname secname, sb.parvalue
        FROM issuers iss, sbsecurities sb
        WHERE iss.issuerid = sb.issuerid
    ) sec
WHERE cf.custid = af.custid
    AND af.acctno = caschd.afacctno
    AND caschd.camastid = ca.camastid
    --AND caschd.codeid = sec.codeid --chaunh 02/10/2012 moved
    AND nvl(ca.tocodeid,ca.codeid) = sec.codeid --chaunh 02/10/2012 added
    AND caschd.deltd <> 'Y'
    AND caschd.status <> 'C'
    AND ca.deltd <> 'Y'
    AND ca.status <> 'C'
    AND ca.catype = '014'
    AND ca.camastid = v_strcacode
group by sec.secname, sec.seccode, sec.parvalue, ca.exprice, ca.reportdate
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

