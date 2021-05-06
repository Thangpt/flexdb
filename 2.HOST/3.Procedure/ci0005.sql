CREATE OR REPLACE PROCEDURE ci0005(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   CUSTID         IN       VARCHAR2,
   pv_CUSTODYCD      IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO TINH PHI THAU CHI CUA KHACH HANG
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   20-DEC-06  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID       VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   V_CUSTID        VARCHAR2 (20);
   V_AFACCTNO        VARCHAR2 (20);
   V_CUSTODYCD        VARCHAR2 (20);
BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

     IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

     IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS

 IF (CUSTID <> 'ALL' OR CUSTID <> '' OR CUSTID <> NULL) THEN
       v_CUSTID := CUSTID;
    ELSE
       v_CUSTID := '%';
    END IF;

     IF (PV_CUSTODYCD <> 'ALL' ) THEN
       V_CUSTODYCD := PV_CUSTODYCD;
    ELSE
       V_CUSTODYCD := '%';
    END IF;

     IF (PV_AFACCTNO <> 'ALL' ) THEN
       V_AFACCTNO := PV_AFACCTNO;
    ELSE
       V_AFACCTNO := '%';
    END IF;
   -- END OF GETTING REPORT'S PARAMETERS


   -- GET REPORT'S DATA

OPEN  PV_REFCURSOR FOR

    select ads.autoid,ads.txdate,ads.txnum,af.acctno,cf.custodycd, cf.fullname , ADS.amt ,ADS.rrtype, NVL( cfb.shortname,'KBSV') custbank
    ,NVL( cfb.fullname ,'KBSV') bank_fullname , NVL(lm.lmamtmax,0) lmamtmax
    from adsource ads,afmast af, cfmast cf, cfmast cfb, cflimit LM
    where ads.acctno = af.acctno
        and af.custid = cf.custid
        and ads.custbank = cfb.custid(+)
        and ads.status ='N'
        AND ads.deltd ='N'
        and ads.custbank = lm.bankid(+)
        and nvl( lm.lmsubtype,'ADV') ='ADV'
        AND NVL( LM.status,'A') ='A'
        AND NVL( cfb.custid,'KBSV') like V_CUSTID
        and af.acctno like v_afacctno
        and cf.custodycd like V_CUSTODYCD
        ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

