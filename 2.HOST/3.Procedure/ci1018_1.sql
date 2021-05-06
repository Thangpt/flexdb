CREATE OR REPLACE PROCEDURE ci1018_1(
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   OPT              IN       VARCHAR2,
   BRID             IN       VARCHAR2,
   TYPEDATE         IN       VARCHAR2,
   F_DATE           IN       VARCHAR2,
   T_DATE           IN       VARCHAR2,
   TLTXCD           IN       VARCHAR2,
   MAKER            IN       VARCHAR2,
   CHECKER          IN       VARCHAR2,
   corebank         IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2,
   TYPEBRID         IN       VARCHAR2
        )
   IS
--
-- To modify this template, edit file PROC.TXT in TEMPLATE
-- directory of SQL Navigator
-- BAO CAO DANH SACH GIAO DICH LUU KY
-- Purpose: Briefly explain the functionality of the procedure
-- DANH SACH GIAO DICH LUU KY
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- NAMNT   11-APR-2012  MODIFIED
-- ---------   ------  -------------------------------------------

    V_STROPTION         VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRTLTXCD         VARCHAR (900);
    V_STRSYMBOL         VARCHAR (20);
    V_STRTYPEDATE       VARCHAR(5);
    V_STRCHECKER        VARCHAR(20);
    V_STRMAKER          VARCHAR(20);
    V_STRCOREBANK       VARCHAR(20);
    V_STROPT            VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID           VARCHAR2 (100);                   -- USED WHEN V_NUMOPTION > 0
    V_INBRID            VARCHAR2 (5);
    v_strIBRID          VARCHAR2 (4);
    vn_BRID             varchar2(50);
    V_STRPV_CUSTODYCD   varchar2(50);
    V_STRPV_AFACCTNO    varchar2(50);
   -- Declare program variables as shown above
BEGIN
    -- GET REPORT'S PARAMETERS


 V_STROPT := upper(OPT);
    V_INBRID := BRID;
    if(V_STROPT = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPT = 'B') then
            --select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
            V_STRBRID := substr(BRID,1,2) || '__' ;
        else
            V_STRBRID := BRID;
        end if;
    end if;

  V_STRTYPEDATE := TYPEDATE;

   IF(TLTXCD <> 'ALL')
   THEN
        V_STRTLTXCD := TLTXCD||'%';
      ELSE
        V_STRTLTXCD := '%%';
   END IF;

   IF(CHECKER <> 'ALL')
   THEN
        V_STRCHECKER := CHECKER;
   ELSE
        V_STRCHECKER := '%%';
   END IF;

   IF(MAKER <> 'ALL')
   THEN
        V_STRMAKER  := MAKER;
   ELSE
        V_STRMAKER  := '%%';
   END IF;

   IF(COREBANK <> 'ALL')
   THEN
        V_STRCOREBANK  := COREBANK;
   ELSE
        V_STRCOREBANK  := '%%';
   END IF;

    IF(PV_CUSTODYCD <> 'ALL')
   THEN
        V_STRPV_CUSTODYCD  := PV_CUSTODYCD;
   ELSE
        V_STRPV_CUSTODYCD  := '%%';
   END IF;

    IF(PV_AFACCTNO <> 'ALL')
   THEN
        V_STRPV_AFACCTNO  := PV_AFACCTNO;
   ELSE
        V_STRPV_AFACCTNO := '%%';
   END IF;

IF   TYPEBRID ='002' THEN

 OPEN PV_REFCURSOR
  FOR
  select TLTXCD,TXDESC,TXNUM,BUSDATE,TXDATE,CUSTODYCD,ACCTNO,
    CUSTODYCDC,ACCTNOC,AMT,MK,CK,BRID,TLID,OFFID,BANKID,
    COREBANK,BANKNAME,TRDESC,TXTYPE,CREDIT,DEBIT
  from ci1018_log lg
  where lg.busdate>=to_date(F_DATE,'DD/MM/YYYY')
    AND lg.busdate<=to_date(T_DATE,'DD/MM/YYYY')
    AND lg.TLTXCD_FILTER LIKE V_STRTLTXCD
    and  nvl(lg.brid,V_STRBRID) like V_STRBRID
    AND NVL( lg.TLID,'-') LIKE V_STRMAKER
    AND NVL( lg.OFFID,'-') LIKE V_STRCHECKER
    AND lg.COREBANK LIKE V_STRCOREBANK
    AND lg.custodycd LIKE V_STRPV_CUSTODYCD
    AND lg.acctno LIKE V_STRPV_AFACCTNO;

ELSE
  OPEN PV_REFCURSOR
  FOR
    select TLTXCD,TXDESC,TXNUM,BUSDATE,TXDATE,CUSTODYCD,ACCTNO,
    CUSTODYCDC,ACCTNOC,AMT,MK,CK,TLBRID BRID,TLID,OFFID,BANKID,
    COREBANK,BANKNAME,TRDESC,TXTYPE,CREDIT,DEBIT
    from ci1018_log lg
    where lg.busdate>=to_date(F_DATE,'DD/MM/YYYY')
    AND lg.busdate<=to_date(T_DATE,'DD/MM/YYYY')
    AND lg.TLTXCD_FILTER LIKE V_STRTLTXCD
    and  nvl(lg.tlbrid,V_STRBRID) like V_STRBRID
    AND NVL( lg.TLID,'-') LIKE V_STRMAKER
    AND NVL( lg.OFFID,'-') LIKE V_STRCHECKER
    AND lg.COREBANK LIKE V_STRCOREBANK
    AND lg.custodycd LIKE V_STRPV_CUSTODYCD
    AND lg.acctno LIKE V_STRPV_AFACCTNO;

end if;


END; -- Procedure
/

