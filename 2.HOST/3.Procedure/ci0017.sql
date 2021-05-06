CREATE OR REPLACE PROCEDURE ci0017(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   I_BRID         IN       VARCHAR2,
   I_ADTYPE       IN       VARCHAR2,
   I_VIA          IN       VARCHAR2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- Ban ke hoan ung
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DUNGNH   21-MAY-10  CREATED
--  TheNN   19-Mar-2012 Modified    Them tham so nguon ung truoc
-- ---------   ------  -------------------------------------------
   V_STROPT     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID       VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID         VARCHAR2 (5);

   V_STRAFACCTNO   VARCHAR2 (20);
   V_STRCUSTODYCD  VARCHAR2 (20);

   V_STRISBRID      VARCHAR2 (5);
   V_FROMDATE       DATE;
   V_TODATE         DATE;
   V_ADTYPE     VARCHAR2(4);
   V_STRVIA     VARCHAR2(6);

BEGIN
   /* V_STROPTION := OPT;

    IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
    THEN
      V_STRBRID := BRID;
    ELSE
      V_STRBRID := '%%';
    END IF; */

    V_STROPT := upper(OPT);
    V_INBRID := BRID;
    if(V_STROPT = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPT = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

    -- GET REPORT'S PARAMETERS

    IF (I_BRID = 'ALL' or I_BRID is null)
    THEN
      V_STRISBRID := '%%';
    ELSE
      V_STRISBRID := I_BRID;
    END IF;

    IF I_ADTYPE = 'ALL' OR I_ADTYPE IS NULL THEN
        V_ADTYPE := '%%';
    ELSE
        V_ADTYPE := I_ADTYPE;
    END IF;

    IF upper(I_VIA) = 'ALL' OR I_VIA IS NULL THEN
        V_STRVIA := '%';
    ELSE
        V_STRVIA := I_VIA;
    END IF;

    V_FROMDATE := to_date(F_DATE,'DD/MM/YYYY');
    V_TODATE   := to_date(T_DATE,'DD/MM/YYYY');

   -- END OF GETTING REPORT'S PARAMETERS


   -- GET REPORT'S DATA

    OPEN  PV_REFCURSOR FOR

        SELECT BR.BRNAME,AD.TXNUM,cf.custodycd,af.acctno,cf.fullname,
            ad.txdate,ad.paidamt,ad.oddate,ad.paiddate, ad.custbank,
            decode(V_ADTYPE,'%%','ALL',nvl(adt.typename,'')) advbank, AD.ADTYPE,
            DECODE(V_STRISBRID,'%%','ALL',NVL(br.brname,'')) BRANCH,
            nvl(cf2.shortname,'MSBS') bankname,
            (CASE WHEN trim(tl.tltxcd) = '8842' THEN '42' when SUBSTR(ad.txnum,1,2) = '68' then '68'
                when SUBSTR(ad.txnum,1,2) = '99' then '99' else '00' end) kenh,
                CASE WHEN SUBSTR(AF.ACCTNO,1,2)= SUBSTR(AD.TXNUM,1,2) OR substr(AD.TXNUM,1,2) IN ('99','68')   THEN '1'  ELSE '2' END TYPEBRID
        FROM
            (
           SELECT ad.AUTOID,ad.ISMORTAGE,ad.STATUS,ad.DELTD,ad.ACCTNO,ad.TXDATE,ad.TXNUM,ad.REFADNO,ad.CLEARDT,ad.AMT,
                   ad.FEEAMT,ad.VATAMT,ad.BANKFEE,ad.PAIDAMT,ad.RRTYPE,adso.CUSTBANK,ad.CIACCTNO,ad.ODDATE,ad.PAIDDATE, NVL(adso.adtype,'----') ADTYPE
            FROM adschd  ad ,adsource adso where ad.autoid = adso.autoid and ad.paiddate >= V_FROMDATE
                and ad.paiddate <= V_TODATE

            ) AD, vw_tllog_all tl2,
            (select fld.nvalue, tl.*
                    From vw_tllog_all tl, vw_tllogfld_all fld
                    where tl.tltxcd in ('8851','8842')
                        and fld.fldcd = '09'
                        and tl.txnum = fld.txnum
                        and tl.txdate = fld.txdate
                        and tl.txdate >= V_FROMDATE
                        and tl.txdate <= V_TODATE
            ) TL,
            brgrp BR, afmast af, cfmast cf,
            (select * from cfmast where isbanking = 'Y') cf2,
            (SELECT ADT.ACTYPE, ADT.TYPENAME FROM ADTYPE ADT UNION ALL SELECT '----' ACTYPE, '----' TYPENAME FROM DUAL) ADT
        WHERE AD.TXDATE=TL2.TXDATE
            AND AD.TXNUM=TL2.TXNUM
            and ad.autoid = tl.nvalue
            and ad.acctno=af.acctno
            and af.custid=cf.custid
            AND TL2.BRID=BR.BRID
            AND ad.status ='C'
            and (tl2.brid like V_STRBRID or INSTR(V_STRBRID,tl2.brid) <> 0)
            AND ad.adtype = adt.actype (+)
            AND ad.adtype LIKE V_ADTYPE
            and ad.custbank = cf2.custid(+)
            and ((case when SUBSTR(ad.txnum,1,2) = '68' then 'O' ELSE 'FA' END) like V_STRVIA
            or (case when SUBSTR(ad.txnum,1,2) = '68' then 'O'
                when SUBSTR(ad.txnum,1,2) = '99' then 'A' else 'F' end) like V_STRVIA)  ---HOANGND
        ORDER BY AD.TXDATE, AD.ACCTNO, AD.TXNUM
     ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

