CREATE OR REPLACE PROCEDURE df0004 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   F_BRID         IN       VARCHAR2,
   F_DFTYPE       IN       VARCHAR2,
   CUSTODYCD       IN       VARCHAR2
   )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO TAI KHOAN TIEN TONG HOP CUA NGUOI DAU TU
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DUNGNH   10-MAY-10  CREATED
-- ---------   ------  -------------------------------------------

   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_STRI_BRID      VARCHAR2 (5);
   V_STRI_TYPE      VARCHAR2 (5);
   V_STRCUSTODYCD    VARCHAR2 (20);

BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%';
   END IF;

   IF (F_BRID = 'ALL' or F_BRID is null)
   THEN
      V_STRI_BRID := '%';
   ELSE
      V_STRI_BRID := F_BRID;
   END IF;

   IF (F_DFTYPE = 'ALL' or F_DFTYPE is null)
   THEN
      V_STRI_TYPE := '%';
   ELSE
      V_STRI_TYPE := F_DFTYPE;
   END IF;

   IF (CUSTODYCD = 'ALL' or CUSTODYCD is null)
   THEN
      V_STRCUSTODYCD := '%';
   ELSE
      V_STRCUSTODYCD := CUSTODYCD;
   END IF;


OPEN PV_REFCURSOR
FOR
    select (allcode.cdcontent ||''|| df.ciacctno ||'' || df.custbank) cdcontent, cf.custodycd, df.afacctno,
        cf.fullname, A1.CDCONTENT LoaiSanPham, df.acctno, lnd.RLSDATE txdate, lnd.overduedate, (df.amt-df.rlsamt)AMT,
        to_date(T_DATE,'DD/MM/YYYY') IDATE
    From
    (select * from (
            select * from dfmast
                union all
            select * from dfmasthist
            )) df, afmast af, cfmast cf, dftype, allcode , allcode A1,
            (
            SELECT  LN.ACCTNO acctno, MAX(LN.RLSDATE) RLSDATE, MAX(LNSC.OVERDUEDATE) OVERDUEDATE
        FROM VW_LNMAST_ALL LN ,
            (SELECT * FROM LNSCHD UNION ALL SELECT * FROM LNSCHDHIST)LNSC
        WHERE LN.ACCTNO = LNSC.ACCTNO
                    AND LNSC.REFTYPE IN ('P','GP')
        GROUP BY LN.ACCTNO
        )lnd
    where df.dftype like V_STRI_TYPE
        and df.afacctno = af.acctno
        and af.custid = cf.custid
        and df.actype = dftype.actype
        and allcode.cdname = 'RRTYPE'
        and allcode.cdval = dftype.rrtype
        and df.dftype = A1.cdval
        and A1.cdname = 'DFTYPE'
        and (df.amt-df.rlsamt) > 2
        and dftype.rrtype like V_STRI_BRID
        and cf.custodycd like V_STRCUSTODYCD
        and df.lnacctno = lnd.acctno
        and df.txdate <= to_date(T_DATE,'DD/MM/YYYY')
;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

