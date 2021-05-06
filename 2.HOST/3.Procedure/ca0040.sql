CREATE OR REPLACE PROCEDURE CA0040 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   CACODE         IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2
  )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO TAI KHOAN TIEN TONG HOP CUA NGUOI DAU TU
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   20-DEC-06  CREATED
-- ---------   ------  -------------------------------------------

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);
    V_STRCACODE    VARCHAR2 (20);
   V_STRAFACCTNO    VARCHAR2 (20);
BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   IF (CACODE <> 'ALL')
   THEN
      V_STRCACODE := CACODE;
   ELSE
      V_STRCACODE := '%%';
   END IF;

     IF (AFACCTNO <> 'ALL')
   THEN
       V_STRAFACCTNO := AFACCTNO;
   ELSE
       V_STRAFACCTNO := '%%';
   END IF;

OPEN PV_REFCURSOR
   FOR
    SELECT se.symbol,se.codeid, to_date(mst.reportdate,'dd/MM/rrrr') reportdate,cancelshare,
           case when mst.typerate = 'R' then to_char(to_number(mst.devidentrate) || '%') else to_char(to_number(mst.devidentvalue)) end devidentrate,
           cf.custodycd, af.acctno, cf.fullname, cf.idcode, to_date(cf.iddate,'dd/MM/rrrr') iddate, schd.balance, schd.amt, schd.aqtty,
           /*mst.description*/ 'Gi?i th? TCPH' description, iss.fullname symbolname
        FROM
            (select * from (select * from camast union all select * from camasthist)) mst,
            (select * from (select * from caschd union all select * from caschdhist)) schd,
             sbsecurities se, afmast af, cfmast cf, issuers iss
        WHERE schd.codeid = se.codeid and iss.issuerid = se.issuerid
              AND mst.camastid = schd.camastid
              AND schd.afacctno = af.acctno
              AND af.custid = cf.custid
              AND schd.deltd<>'Y'
              AND mst.camastid LIKE V_STRCACODE
              AND schd.afacctno like V_STRAFACCTNO
        ORDER BY cf.custodycd, af.acctno
  ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

