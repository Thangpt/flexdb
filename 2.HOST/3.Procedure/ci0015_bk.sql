CREATE OR REPLACE PROCEDURE ci0015_bk(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   I_BRID         IN       VARCHAR2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- Bang ke uong truoc tien ban
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DUNGNH   21-MAY-10  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID       VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   V_STRAFACCTNO   VARCHAR2 (20);
   V_STRCUSTODYCD  VARCHAR2 (20);

   V_STRISBRID      VARCHAR2 (5);
   V_FROMDATE       DATE;
   V_TODATE         DATE;
   v_AdvFeeRate number(20,6);
   
    -- added by Truong for logging
   V_TRADELOG CHAR(2);
   V_AUTOID NUMBER;
   V_INSTANCE VARCHAR2 (10);

BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS

   IF (I_BRID = 'ALL' or I_BRID is null)
   THEN
      V_STRISBRID := '%';
   ELSE
      V_STRISBRID := I_BRID;
   END IF;


   V_FROMDATE := to_date(F_DATE,'DD/MM/YYYY');
   V_TODATE   := to_date(T_DATE,'DD/MM/YYYY');
    select to_number(varvalue)/360 into v_AdvFeeRate from sysvar where varname = 'AINTRATE' and grname = 'SYSTEM';
   -- END OF GETTING REPORT'S PARAMETERS

-- BEGIN LOG added by truong

   -- GET REPORT'S DATA

OPEN  PV_REFCURSOR FOR
select br.brname brname, ad.txdate txdate, to_char(ad.txnum) txnum , cf.custodycd custodycd, af.acctno acctno, cf.fullname fullname,
    ad.cleardt cleardt, (ad.amt+ad.feeamt) namt,
    v_AdvFeeRate fee,
--            round((ad.feeamt*100/(ad.amt+ad.feeamt))/to_number(ad.cleardt-ad.txdate),4) fee,
    ad.feeamt feeamt, ad.amt amt
from (select * From
                    (
                        select acctno, txdate, txnum, cleardt, amt, feeamt, paidamt, deltd from adschd
                        union all
                        select acctno, txdate, txnum, cleardt, amt, feeamt, paidamt, deltd from adschdhist
                    )
     ) ad, afmast af, cfmast cf, brgrp br , vw_tllog_all tl
where ad.deltd <> 'Y'
    and af.acctno = ad.acctno
    and af.custid = cf.custid
    and ad.txnum = tl.txnum
    and ad.txdate = tl.txdate
    and cf.custodycd like '017%'
    and tl.brid = br.brid
    and ad.txdate >= V_FROMDATE
    and ad.txdate <= V_TODATE
    and tl.brid like V_STRISBRID

union all

select br.brname brname, ci.txdate txdate, to_char(ci.txnum) txnum , cf.custodycd custodycd,  af.acctno acctno, cf.fullname fullname,
    sts.cleardate cleardt, ci.namt namt,
    v_AdvFeeRate fee,
    ci.feeamt feeamt, (ci.namt-ci.feeamt) amt
from cfmast cf, afmast af, vw_stschd_all sts, brgrp br, vw_tllog_all tl,
    (
        select acctno, txdate, txnum, sum(namt ) namt,sum(feeamt) feeamt, max(orgorderid)orgorderid
        from
        (   -- Goc ung truoc
            select ci.acctno, ci.txdate, ci.txnum, ci.namt ,0 feeamt, ci.ref orgorderid
            from vw_citran_gen ci 
            where ci.field = 'AAMT' and ci.txtype = 'C'
                and ci.tltxcd <> '1153'
                and ci.busdate >= V_FROMDATE
                and ci.busdate <= V_TODATE
                and ci.namt <> 0

            union all       -- Phi ung truoc
            select ci.acctno, ci.txdate, ci.txnum, 0 namt, ci.namt feeamt,
                '0000' orgorderid
            from vw_citran_gen ci 
            where ci.field = 'BALANCE'
                and ci.tltxcd <> '1153'
                and ci.txcd = '0011'
                and ci.namt <> 0
                and ci.txdate >= V_FROMDATE
                and ci.txdate <= V_TODATE                    
        ) c
        group by acctno, txdate, txnum
    ) ci
    where cf.custid = af.custid and af.acctno = ci.acctno
        and sts.acctno = af.acctno
        and ci.txnum = tl.txnum
        and ci.txdate = tl.txdate
        and nvl(tl.brid,SUBSTR(msgacct,1,4)) = br.brid
        and cf.custodycd like '017%'
        and sts.duetype = 'RM'
        and ci.orgorderid = sts.orgorderid
        and nvl(tl.brid,SUBSTR(msgacct,1,4)) like V_STRISBRID
order by txdate, txnum

;
-- END LOG added by Truong

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

