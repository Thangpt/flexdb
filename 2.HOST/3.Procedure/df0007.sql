CREATE OR REPLACE PROCEDURE df0007 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   CAREBY         IN       VARCHAR2
   )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO TAI KHOAN TIEN TONG HOP CUA NGUOI DAU TU
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DUNGNH   29-MAY-10  CREATED
-- HUNG.LB  09-SEP-10  UPDATED
-- ---------   ------  -------------------------------------------

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_STRCIACCTNO  VARCHAR2 (20);
   V_STRCAREBY     VARCHAR2(5);

   V_STRI_BRID      VARCHAR2 (5);

   V_InDate     date;


BEGIN
   V_STROPTION := OPT;

   IF V_STROPTION = 'A' THEN     -- TOAN HE THONG
      V_STRBRID := '%';
   ELSIF V_STROPTION = 'B' THEN
      V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
   ELSE
      V_STRBRID := BRID;
   END IF;

    V_InDate :=  to_date(I_DATE, 'DD/MM/YYYY');

    IF(CAREBY = 'ALL' OR CAREBY IS NULL)
     THEN
       V_STRCAREBY := '%';
     ELSE
         V_STRCAREBY := CAREBY;
     END IF;

OPEN PV_REFCURSOR
FOR
select df.acctno, nvl(dftype.typename,null)typename, ln.rlsdate txdate,
    ln.overduedate, cf.custodycd, cf.fullname, sb.symbol,
    (df.dfqtty + df.rcvqtty + df.blockqtty + df.carcvqtty + nvl(RLSQTTY.qtty,0)) qtty,
    (case when df.dftype = 'L' then df.refprice else null end ) refprice,
    (case when df.dftype = 'L' then (df.dfqtty + df.rcvqtty + df.blockqtty + df.carcvqtty + nvl(RLSQTTY.qtty,0)) * df.refprice
            else null end ) GROSSAMOUNT,
    df.triggerprice, (df.amt - df.rlsamt + nvl(TN2.amt,0)) LENDED_BY_SBS,
    lntype.rate2, round(df.dfprice,0) dfprice,
    brgrp.brname DEPARTMENT, nvl(tl.tlname,null) tlname, df.description description, tlgroups.grpname

from vw_dfmast_all df, dftype, afmast af, cfmast cf, sbsecurities sb, lntype, brgrp, tlgroups,
    (
        select  ln.acctno, max(ln.rlsdate) rlsdate, max(lnsc.overduedate) overduedate
        from vw_lnmast_all ln ,
            (select * from lnschd union all select * from lnschdhist)lnsc
        where ln.acctno = lnsc.acctno
                    and lnsc.reftype in ('P','GP')
        group by ln.acctno
   )ln,
    (select tllog.txnum, tllog.txdate, tllog.tlid, tlprofiles.tlname tlname
        from tllog , tlprofiles
            where tlprofiles.tlid = tllog.tlid
     union all
     select tllogall.txnum, tllogall.txdate, tllogall.tlid, tlprofiles.tlname tlname
        from tllogall, tlprofiles
            where tlprofiles.tlid = tllogall.tlid
    ) tl,
--thu no
    (select tr.acctno lnacctno,
        sum(case when tx.txtype = 'D'  then -tr.namt else tr.namt end ) amt
        from vw_lntran_all tr, apptx tx
        where tr.txcd = tx.txcd
            and tx.apptype = 'LN'
            and tx.field in ('PRINPAID')
            and tx.txtype in ('C','D')
            and tr.deltd <> 'Y'
            and tr.txdate >= V_InDate
            and tr.namt <> 0
        group by tr.acctno
    )TN2,
--so luong thanh ly
    (select acctno dfacctno, sum(namt) qtty
            from (select dfa.acctno, dfa.namt
                    from (select * From dftran union all select * From dftrana) dfa, apptx
                where apptx.field = 'RLSQTTY'
                    and dfa.txcd = apptx.txcd
                    and apptx.apptype = 'DF'
                    and dfa.deltd <> 'Y'
                    and dfa.txdate >= V_InDate
                    and dfa.namt <> 0
                    and apptx.txtype = 'C'
        )
        group by acctno
    )RLSQTTY
    where df.lnacctno = TN2.lnacctno(+)
        and ((df.dfqtty + df.rcvqtty + df.blockqtty + df.carcvqtty + nvl(RLSQTTY.qtty,0)) > 0
                or
              (df.amt - df.rlsamt + nvl(TN2.amt,0)) > 10
             )
        and df.acctno = RLSQTTY.dfacctno(+)
        and df.actype = dftype.actype(+)
        and df.lnacctno = ln.acctno
        and df.afacctno = af.acctno
        and af.custid = cf.custid
        and df.codeid = sb.codeid
        and df.lntype = lntype.actype(+)
        and SUBSTR(df.acctno,1,4) = brgrp.brid
        and cf.careby = tlgroups.grpid
        and cf.careby like V_STRCAREBY
        and df.txnum = tl.txnum(+)
        and df.txdate = tl.txdate(+)
        and df.txdate <= V_InDate
;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

