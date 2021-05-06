CREATE OR REPLACE PROCEDURE df0006 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   F_BRID         IN       VARCHAR2,
   ACTYPE         IN       VARCHAR2
   )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO TAI KHOAN TIEN TONG HOP CUA NGUOI DAU TU
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DUNGNH   17-MAY-10  CREATED
-- ---------   ------  -------------------------------------------

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_STRCIACCTNO  VARCHAR2 (20);

   V_STRI_BRID      VARCHAR2 (5);
   V_STRI_TYPE      VARCHAR2 (5);
   V_STRACTYPE      VARCHAR2 (5);

   V_FROMDATE       DATE;
   V_TODATE         DATE;

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

   IF(ACTYPE = 'ALL' or ACTYPE is null)
   THEN
      V_STRACTYPE := '%';
   ELSE
      V_STRACTYPE := ACTYPE;
   END IF;

   V_FROMDATE := to_date(F_DATE,'DD/MM/YYYY');
   V_TODATE := to_date(T_DATE,'DD/MM/YYYY');


OPEN PV_REFCURSOR
FOR

select df.rrtype, max(df.DVGN)DVGN, df.MSP, max(df.TSP) TSP, max(df.PGD)PGD, df.brid,
sum(df.amt+nvl(TN2.amt,0)-nvl(GN2.amt,0)) SDCK,
     sum(nvl(GN.amt,0)) GiaiNgan, sum(nvl(TN.amt,0)) ThuNo,
     sum(df.amt+nvl(TN2.amt,0)-nvl(GN2.amt,0)-nvl(GN.amt,0)+nvl(TN.amt,0)) SDDK
from (select  DVGN,   MSP, TSP, PGD,  brid, afacctno, acctno, lnacctno, amt, rrtype
    from (select (A1.cdcontent ||''|| df.ciacctno ||'' || df.custbank) DVGN,  df.actype MSP, dftype.typename TSP,
        br.brname PGD, br.brid, df.afacctno, df.acctno, df.lnacctno, (df.amt-df.rlsamt) amt, df.rrtype  rrtype
    from (select * from ( select * from dfmast where status <> 'N'
                        union all
                    select * from dfmasthist where status <> 'N')
         )df, brgrp br, dftype , allcode A1
    where SUBSTR(df.afacctno,1,4) = br.brid
        and df.actype = dftype.actype
        and df.rrtype = A1.cdval
        and A1.cdname = 'RRTYPE'
        and df.status <> 'C' 
        and br.brid like V_STRI_BRID
        and df.rrtype like V_STRACTYPE)
    )df,
--thu no trong ky
    (select tr.acctno lnacctno,
        sum(case when tx.txtype = 'D'  then -tr.namt else tr.namt end ) amt
        from vw_lntran_all tr, apptx tx
        where tr.txcd = tx.txcd
            and tx.apptype = 'LN'
            and tx.field in ('PRINPAID')
            and tx.txtype in ('C','D')
            and tr.deltd <> 'Y'
            and tr.txdate between V_FROMDATE and V_TODATE
            and tr.namt <> 0
        group by tr.acctno
    )TN,
--thu no ngoai ky
    (select tr.acctno lnacctno,
        sum(case when tx.txtype = 'D'  then -tr.namt else tr.namt end ) amt
        from vw_lntran_all tr, apptx tx
        where tr.txcd = tx.txcd
            and tx.apptype = 'LN'
            and tx.field in ('PRINPAID')
            and tx.txtype in ('C','D')
            and tr.deltd <> 'Y'
            and tr.txdate > V_TODATE
            and tr.namt <> 0
        group by tr.acctno
    )TN2,
--Giai ngan trong ky
    (select dfacctno, sum(amt ) amt
        From ((select dfacctno, sum(namt) amt from
                 (select ci.ref dfacctno, ci.namt
                     from (SELECT * from citrana union all select * from citran) ci, apptx tx
                         where ci.tltxcd = '2670'
                             and ci.txcd = tx.txcd
                             and tx.field = 'BALANCE'
                             and tx.apptype = 'CI'
                             and tx.txtype = 'C'
                             and ci.deltd <> 'Y'
                             and ci.txdate >= V_FROMDATE
                             and ci.txdate <= V_TODATE
                 )
            group by dfacctno
            )
        union all
        --gia tri giai ngan qua giao dich 2678
        (select acctno dfacctno, sum(namt) amt
            from (select df.acctno, df.namt
                    from (select * from dftrana union all select * from dftran) df, apptx
                    where apptx.field = 'AMT'
                        and df.txcd = apptx.txcd
                        and apptx.apptype = 'DF'
                        and df.deltd <> 'Y'
                        and df.namt <> 0
                        and apptx.txtype = 'C'
                        and df.deltd <> 'Y'
                        and df.txdate >= V_FROMDATE
                        and df.txdate <= V_TODATE
                  )
            group by acctno)
        )
        group by dfacctno)GN,
--Giai ngan ngoai ky
        (select dfacctno, sum(amt ) amt
        From ((select dfacctno, sum(namt) amt from
                 (select ci.ref dfacctno, ci.namt
                     from (SELECT * from citrana union all select * from citran) ci, apptx tx
                         where ci.tltxcd = '2670'
                             and ci.txcd = tx.txcd
                             and tx.field = 'BALANCE'
                             and tx.apptype = 'CI' 
                             and tx.txtype = 'C'
                             and ci.txdate > V_TODATE
                             and ci.deltd <> 'Y'
                 )
            group by dfacctno)
        union all
        --gia tri giai ngan qua giao dich 2678
        (select acctno dfacctno, sum(namt) amt
            from (select df.acctno, df.namt
                    from (select * from dftrana union all select * from dftran) df, apptx
                    where apptx.field = 'AMT'
                        and df.txcd = apptx.txcd
                        and apptx.apptype = 'DF'
                        and df.deltd <> 'Y'
                        and df.namt <> 0
                        and apptx.txtype = 'C'
                        and df.txdate > V_TODATE
                        and df.deltd <> 'Y'
                  )
            group by acctno)
        )
        group by dfacctno)GN2
    where df.lnacctno = TN.lnacctno(+)
        and df.lnacctno = TN2.lnacctno(+)
        and df.acctno = GN.dfacctno(+)
        and df.acctno = GN2.dfacctno(+)
        and ((df.amt+nvl(TN2.amt,0)-nvl(GN2.amt,0)) <> 0 or (nvl(GN.amt,0)) <> 0 or (nvl(TN.amt,0)) <> 0)
    group by df.rrtype,  df.MSP, df.brid
;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

