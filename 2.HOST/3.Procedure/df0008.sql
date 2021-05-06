CREATE OR REPLACE PROCEDURE df0008 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2
   )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO TAI KHOAN TIEN TONG HOP CUA NGUOI DAU TU
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DUNGNH   29-MAY-10  CREATED
-- ---------   ------  -------------------------------------------

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_STRCIACCTNO  VARCHAR2 (20);



BEGIN
   V_STROPTION := OPT;

   IF V_STROPTION = 'A' THEN     -- TOAN HE THONG
      V_STRBRID := '%';
   ELSIF V_STROPTION = 'B' THEN
      V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
   ELSE
      V_STRBRID := BRID;
   END IF;




OPEN PV_REFCURSOR
FOR
select df.acctno, nvl(dftype.typename,null)typename, df.txdate,
    ln.overduedate, cf.custodycd, cf.fullname, sb.symbol,
    (tn.qtty) qtty, tn.INTPAID INTPAID,
    (case when df.dftype = 'L' then df.refprice else null end ) refprice,
    (case when df.dftype = 'L' then (df.dfqtty + df.rcvqtty + df.blockqtty + df.carcvqtty+df.rlsqtty) * df.refprice
            else null end ) GROSSAMOUNT,
    df.triggerprice, tn.namt LENDED_BY_SBS, lntype.rate2, df.dfprice,
    brgrp.brname DEPARTMENT, nvl(tl.tlname,null) tlname, df.description, tlgroups.grpname

from dfmast df, dftype,
    (
    select acctno lnacctno, overduedate from lnschd
        where reftype in ('P','GP')
    union all
    select acctno lnacctno, overduedate from lnschdhist
        where reftype in ('P','GP')
    )ln,
    afmast af, cfmast cf, sbsecurities sb, lntype, brgrp, tlgroups,
    (select tllog.txnum, tllog.txdate, tllog.tlid, tlprofiles.tlname tlname
        from tllog , tlprofiles
            where tlprofiles.tlid = tllog.tlid
     union all
     select tllogall.txnum, tllogall.txdate, tllogall.tlid, tlprofiles.tlname tlname
        from tllogall, tlprofiles
            where tlprofiles.tlid = tllogall.tlid
    ) tl,
    (select RLSAMT.acctno, RLSAMT.namt, nvl(RLSQTTY.namt,0) qtty, nvl(INTPAID.namt,0) INTPAID From
    (select nvl(txnum,null) txnum, nvl(txdate,null)txdate, nvl(acctno,null)acctno, nvl(namt,null) namt
       from (select dfa.txnum, dfa.txdate,dfa.acctno, dfa.namt
                from dftran dfa, apptx
            where apptx.field in ('RLSAMT')
                and dfa.txcd = apptx.txcd
                and apptx.apptype = 'DF'
                and dfa.deltd <> 'Y'
                and dfa.namt > 0
                and apptx.txtype in ('C')
        ))RLSAMT,
     (select nvl(txnum,null) txnum, nvl(txdate,null) txdate, nvl(acctno,null) acctno, nvl(namt,null) namt
        from (select dfa.txnum, dfa.txdate, dfa.acctno, dfa.namt
                from dftran dfa, apptx
            where apptx.field in ('RLSQTTY')
                and dfa.txcd = apptx.txcd
                and apptx.apptype = 'DF'
                and dfa.deltd <> 'Y'
                and dfa.namt <> 0
                and apptx.txtype in ('C')
    ))RLSQTTY,
    (select * from
        (select lntrana.txnum, lntrana.txdate,lntrana.acctno, lntrana.namt
        from lntrana, apptx
    where apptx.field in ('INTPAID')
        and lntrana.txcd = apptx.txcd
        and apptx.apptype = 'LN'
        and lntrana.deltd <> 'Y'
        and lntrana.namt <> 0
        and apptx.txtype in ('C')
    union all
    select lntran.txnum, lntran.txdate,lntran.acctno, lntran.namt
        from lntran, apptx
    where apptx.field in ('INTPAID')
        and lntran.txcd = apptx.txcd
        and apptx.apptype = 'LN'
        and lntran.deltd <> 'Y'
        and lntran.namt <> 0
        and apptx.txtype in ('C')
    ))INTPAID
    where RLSAMT.txnum = RLSQTTY.txnum(+)
        and RLSAMT.txdate = RLSQTTY.txdate(+)
        and RLSAMT.txnum = INTPAID.txnum(+)
        and RLSAMT.txdate = INTPAID.txdate(+)
   )TN
    where df.amt - df.rlsamt = 0
        and df.actype = dftype.actype(+)
        and df.lnacctno = ln.lnacctno
        and df.afacctno = af.acctno
        and af.custid = cf.custid
        and df.codeid = sb.codeid
        and df.lntype = lntype.actype(+)
        and SUBSTR(df.acctno,1,4) = brgrp.brid
        and cf.careby = tlgroups.grpid
        and df.acctno = tn.acctno
        and df.txnum = tl.txnum (+)
        and df.txdate = tl.txdate(+)
    order by df.acctno
;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

