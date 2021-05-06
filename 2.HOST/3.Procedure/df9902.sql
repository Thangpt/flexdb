CREATE OR REPLACE PROCEDURE DF9902 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CIACCTNO       IN       VARCHAR2, --CUSTODYCD
   I_BRID         IN       VARCHAR2,
   ACTYPE         IN       VARCHAR2,
   RRTYPE         IN       VARCHAR2,
   CAREBY         IN       VARCHAR2
   )
IS
--

-- ---------   ------  -------------------------------------------

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_STRCIACCTNO  VARCHAR2 (20);

   V_STRI_BRID               VARCHAR2(5);
   V_STRACTYPE               VARCHAR2(5);
   V_STRRRTYPE               VARCHAR2(5);
   V_STRCAREBY               VARCHAR2(5);
   v_FromDate                DATE;
   V_TODATE                  DATE;


BEGIN
   V_STROPTION := OPT;

   v_FromDate := to_date(F_DATE,'DD/MM/RRRR');
   v_ToDate   := to_date(T_DATE,'DD/MM/RRRR');

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%';
   END IF;

   IF(CIACCTNO = 'ALL' or CIACCTNO is null )
   THEN
        V_STRCIACCTNO := '%%';
   ELSE
        V_STRCIACCTNO := CIACCTNO;
   END IF;

   IF(I_BRID = 'ALL' OR I_BRID IS NULL)
    THEN
       V_STRI_BRID := '%';
   ELSE
       V_STRI_BRID := I_BRID;
   END IF;

   IF(ACTYPE = 'ALL' OR ACTYPE IS NULL)
    THEN
       V_STRACTYPE := '%';
   ELSE
       V_STRACTYPE := ACTYPE;
   END IF;

   IF(RRTYPE = 'ALL' OR RRTYPE IS NULL)
    THEN
       V_STRRRTYPE := '%';
   ELSE
       V_STRRRTYPE := RRTYPE;
   END IF;


   IF(CAREBY = 'ALL' OR CAREBY IS NULL)
    THEN
       V_STRCAREBY := '%';
   ELSE
       V_STRCAREBY := CAREBY;
   END IF;


OPEN PV_REFCURSOR
FOR
--Giai ngan
select (A1.cdcontent ||' '|| df.ciacctno || ' ' || df.custbank) NGUON,
      dftype.typename, brgrp.brname,
    df.acctno, df.txnum , null txnum,
    cf.custodycd, df.afacctno, cf.fullname, sb.symbol, (df.dfqtty + df.rcvqtty + df.blockqtty + df.carcvqtty+df.rlsqtty) qtty,
    --(case when df.dftype = 'L' then df.refprice else null end ) refprice,
	    df.refprice refprice,
    (case when df.dftype = 'L' then (df.dfqtty + df.rcvqtty + df.blockqtty + df.carcvqtty+df.rlsqtty) * df.refprice
            Else Null End ) Tongkhoplenh,
    df.dfprice, df.triggerprice,ln.rate1,ln.rate2,ln.rate3,ln.printfrq1,ln.printfrq2,ln.printfrq3, round(df.dfprice*100/df.refprice,2) TLGopVon, lnd.rlsdate txdate, df.amt,
    TO_NUMBER(lnd.overduedate-lnd.opndate) ThoiHanHD, (lnd.overduedate)NgayDenHanHD, null txdate_2, null namt,
    null msgamt, round(df.amt-df.rlsamt+df.namt) conlai,
    (case when (df.amt-df.rlsamt) > 2 then TO_NUMBER(v_ToDate-lnd.opndate) else
                    TO_NUMBER(lnd.paiddate-lnd.opndate)end )EXPDATE,
  (case when (df.amt-df.rlsamt) < 2
        then(case when lnd.paiddate > lnd.overduedate
                then TO_NUMBER(lnd.paiddate-lnd.overduedate) else 0 end )
            else (case when lnd.overduedate is null then 0
                else (case when v_ToDate > lnd.overduedate
                then TO_NUMBER(v_ToDate-lnd.overduedate) else 0 end ) end
                    ) end
    ) Overduedate,
     Null Laitheohd, Null Laiquahan, Null Tonglaikh , (-1) Status,
     Df.Description, Dftype.Actype, (Df.Dfqtty + Df.Rcvqtty + Df.Blockqtty + Df.Carcvqtty + Df.Qtty) Sl_Conlai, Tlgroups.Grpname Careby,Tl.Tlname Nguoiquanly,
     tl1.tlname NguoiThucHien,tl2.tlname NguoiDuyet
from (select df.*, nvl(dfa2.namt,0) namt, nvl(dfa2.qtty,0) qtty
            From (select * from (select * from dfmast where status <> 'N' and txdate <= v_ToDate
                            union all
                            select * from dfmasthist where status <> 'N' and txdate <= v_ToDate
            ))df,
    (select *
        from (
                select dfa.acctno,
                    sum(case when tx.field = 'RLSAMT' then (case when tx.txtype = 'D' then -dfa.namt else dfa.namt end)
                                else 0 end) namt,
                    sum(case when tx.field = 'RLSQTTY' then (case when tx.txtype = 'D' then -dfa.namt else dfa.namt end)
                                else 0 end) qtty
                from vw_dftran_all dfa, apptx tx
                where dfa.txcd = tx.txcd
                    and tx.txtype in ('C','D')
                    and tx.field in ('RLSAMT','RLSQTTY')
                    and tx.apptype = 'DF'
                    and dfa.namt > 0
                    and dfa.txdate >= v_FromDate
                group by dfa.acctno
            )
    )dfa1,
   (select *
        from (
                select dfa.acctno,
                    sum(case when tx.field = 'RLSAMT' then (case when tx.txtype = 'D' then -dfa.namt else dfa.namt end)
                                else 0 end) namt,
                    sum(case when tx.field = 'RLSQTTY' then (case when tx.txtype = 'D' then -dfa.namt else dfa.namt end)
                                else 0 end) qtty
                from vw_dftran_all dfa, apptx tx
                where dfa.txcd = tx.txcd
                    and tx.txtype in ('C','D')
                    and tx.field in ('RLSAMT','RLSQTTY')
                    and tx.apptype = 'DF'
                    and dfa.namt > 0
                    and dfa.txdate > v_ToDate
                group by dfa.acctno
            )
    )dfa2
where df.acctno = dfa1.acctno(+)
    and df.acctno = dfa2.acctno(+)
    and ((df.amt-df.rlsamt+nvl(dfa1.namt,0)) > 2 )
    ) df,
    allcode A1, afmast af, cfmast cf, sbsecurities sb, lntype ln,dftype, brgrp,
    (select  ln.acctno, max(ln.rlsdate) rlsdate, max(ln.opndate) opndate, max(lnsc.overduedate) overduedate, max(lnsc.paiddate) paiddate
        from vw_lnmast_all ln ,
            (select * from lnschd union all select * from lnschdhist)lnsc
        where ln.acctno = lnsc.acctno
                    and lnsc.reftype in ('P','GP')
        Group By Ln.Acctno
    )lnd,tlgroups,tlprofiles tl,vw_tllog_all la,tlprofiles tl1,tlprofiles tl2
    where df.rrtype = A1.cdval
        and A1.cdname = 'RRTYPE'
        AND df.rrtype LIKE V_STRRRTYPE
        and df.afacctno = af.acctno
        and af.custid = cf.custid
        and df.codeid = sb.codeid
        and df.lntype = ln.actype
        and df.lnacctno = lnd.acctno
        and cf.custodycd like V_STRCIACCTNO
        AND DF.ACTYPE LIKE V_STRACTYPE
        AND substr(df.acctno,1,4) LIKE V_STRI_BRID
        and df.actype = dftype.actype(+)
        And Substr(Df.Acctno,1,4) = Brgrp.Brid(+)
        And Cf.Careby = Tlgroups.Grpid(+)
        And Cf.Tlid = Tl.Tlid(+)
        And Df.Txnum = La.Txnum(+)
        And Df.Txdate = La.Txdate(+)
        And La.Tlid = Tl1.Tlid(+)
        and la.offid = tl2.tlid(+)
        And Cf.Careby Like V_Strcareby

union all
--Thanh ly
Select (al.cdcontent ||' '|| df.ciacctno || ' ' || df.custbank) Nguon, dftype.typename,  brgrp.brname, Df.Acctno Acctno,  Tlhd.Txnum Txnum , Tlhd.Txnum Txnum,
    Cf.Custodycd,Df.Afacctno, Cf.Fullname Fullname,Sb.Symbol Symbol, (df.dfqtty + df.rcvqtty + df.blockqtty + df.carcvqtty+df.rlsqtty) Qtty,
    df.refprice, null TongKhopLenh, df.dfprice,  df.triggerprice, ln.rate1,ln.rate2,ln.rate3,ln.printfrq1,ln.printfrq2,ln.printfrq3,
    round(df.dfprice*100/df.refprice,2) TLGopVon, lnd.rlsdate txdate, df.amt, TO_NUMBER(lnd.overduedate-lnd.opndate) ThoiHanHD, lnd.overduedate NgayDenHanHD, tlhd.txdate txdate_2, tlhd.RLSQTTY namt,
    tlhd.rlsamt msgamt, round(df.amt-df.rlsamt+df.namt) conlai,
   (case when (df.amt-df.rlsamt) > 2 then TO_NUMBER(v_ToDate-lnd.opndate) else
                    TO_NUMBER(lnd.paiddate-lnd.opndate)end)EXPDATE,
   (case when (df.amt-df.rlsamt) < 2
        then(case when lnd.paiddate > lnd.overduedate
                then TO_NUMBER(lnd.paiddate-lnd.overduedate) else 0 end )
            else (case when lnd.overduedate is null then 0
                else (case when v_ToDate > lnd.overduedate
                then TO_NUMBER(v_ToDate-lnd.overduedate) else 0 end ) end
                    ) end
    )overduedate,
   (nvl(tlhd.INTPAID,0)-nvl(tlhd.INTOVDACR,0)) LaiTheoHD, nvl(tlhd.INTOVDACR,0) LaiQuaHan,
    nvl(tlhd.INTPAID,0) TongLaiKH,
    (Case When Df.Rlsamt <= 0 Then -2 Else (Df.Amt-Df.Rlsamt) End) Status,
    df.description, Dftype.Actype, (Df.Dfqtty + Df.Rcvqtty + Df.Blockqtty + Df.Carcvqtty + Df.Qtty) SL_CONLAI, tlgroups.grpname CAREBY,Tl.Tlname Nguoiquanly,
     tl1.tlname NguoiThucHien,tl2.tlname NguoiDuyet
 from
    ( select txnum, txdate, dfacctno,
        sum(rlsamt) rlsamt,
        sum(rlsqtty) rlsqtty,
        sum(INTNMLACR) INTNMLACR,
        sum(INTOVDACR) INTOVDACR,
        sum(INTPAID) INTPAID
    From
    (
        --- Tra no goc
        select to_char(tr.txnum) txnum, tr.txdate, tr.acctno dfacctno,
            tr.namt rlsamt,
            0 RLSQTTY,
            0 INTNMLACR,
            0 INTOVDACR,
            0 INTPAID
        from vw_dftran_all tr, apptx tx, vw_dfmast_all df
        where tr.txcd = tx.txcd and tr.acctno = df.acctno
            and tx.field = 'RLSAMT' and tx.apptype = 'DF' and tx.txtype = 'C'
            and tr.namt > 0
            and tr.txdate between v_FromDate and v_ToDate

        --- So luong CK hoan tra
        union all
        select to_char(tr.txnum) txnum, tr.txdate, tr.acctno dfacctno,
            0 rlsamt,
            tr.namt RLSQTTY,
            0 INTNMLACR,
            0 INTOVDACR,
            0 INTPAID
        from vw_dftran_all tr, apptx tx, vw_dfmast_all df
        where tr.txcd = tx.txcd and tr.acctno = df.acctno
            and tx.field = 'RLSQTTY' and tx.apptype = 'DF' and tx.txtype = 'C'
            and tr.namt > 0
            and tr.txdate between v_FromDate and v_ToDate

        --- Tra no lai trong han
        union all
        select to_char(tr.txnum) txnum, tr.txdate, df.acctno dfacctno,
            0 rlsamt,
            0 RLSQTTY,
            sum(tr.namt) INTNMLACR,
            0 INTOVDACR,
            0 INTPAID
        from vw_lntran_all tr, apptx tx, vw_dfmast_all df, vw_lnmast_all ln
        where tr.txcd = tx.txcd and df.lnacctno = ln.acctno
            and tr.acctno = ln.acctno and df.lnacctno = ln.acctno
            and tx.field in ( 'INTNMLACR','INTDUE') and tx.apptype = 'LN' and tx.txtype = 'D'
            and tr.namt > 0
            and tr.txdate between v_FromDate and v_ToDate
        group by to_char(tr.txnum), tr.txdate, df.acctno

        --- Tra no lai tren goc qua han
        union all
        select to_char(tr.txnum) txnum, tr.txdate, df.acctno dfacctno,
            0 rlsamt,
            0 RLSQTTY,
            0 INTNMLACR,
            sum(tr.namt) INTOVDACR,
            0 INTPAID
        from vw_lntran_all tr, apptx tx, vw_dfmast_all df, vw_lnmast_all ln
        where tr.txcd = tx.txcd and df.lnacctno = ln.acctno
            and tr.acctno = ln.acctno and df.lnacctno = ln.acctno
            and tx.field in ('INTOVDACR','INTNMLOVD') and tx.apptype = 'LN' and tx.txtype = 'D'
            and tr.namt > 0
            and tr.txdate between v_FromDate and v_ToDate
        group by to_char(tr.txnum), tr.txdate, df.acctno

        --- Tra no lai tren goc qua han
        union all
        select to_char(tr.txnum) txnum, tr.txdate, df.acctno dfacctno,
            0 rlsamt,
            0 RLSQTTY,
            0 INTNMLACR,
            0 INTOVDACR,
            sum(tr.namt) INTPAID
        from vw_lntran_all tr, apptx tx, vw_dfmast_all df, vw_lnmast_all ln
        where tr.txcd = tx.txcd and df.lnacctno = ln.acctno
            and tr.acctno = ln.acctno and df.lnacctno = ln.acctno
            and tx.field in ('INTPAID') and tx.apptype = 'LN' and tx.txtype = 'C'
            and tr.namt > 0
            and tr.txdate between v_FromDate and v_ToDate
        group by to_char(tr.txnum), tr.txdate, df.acctno
    ) tr
    group by txnum, txdate, dfacctno

    )tlhd,
    (
        select  ln.acctno, max(ln.rlsdate) rlsdate,max(ln.opndate) opndate, max(lnsc.overduedate) overduedate, max(lnsc.paiddate) paiddate
        from vw_lnmast_all ln ,
            (select * from lnschd union all select * from lnschdhist)lnsc
        where ln.acctno = lnsc.acctno
                    and lnsc.reftype in ('P','GP')
        group by ln.acctno
    )lnd,
    (select df.*, nvl(dfa2.namt,0) namt, nvl(dfa2.qtty,0) qtty
      From (select * from (select * from dfmast where status <> 'N' and txdate <= v_ToDate
                             union all
                            select * from dfmasthist where status <> 'N' and txdate <= v_ToDate
            ))df,
    (select *
        from (
                select dfa.acctno,
                    sum(case when tx.field = 'RLSAMT' then (case when tx.txtype = 'D' then -dfa.namt else dfa.namt end)
                                else 0 end) namt,
                    sum(case when tx.field = 'RLSQTTY' then (case when tx.txtype = 'D' then -dfa.namt else dfa.namt end)
                                else 0 end) qtty
                from vw_dftran_all dfa, apptx tx
                where dfa.txcd = tx.txcd
                    and tx.txtype in ('C','D')
                    and tx.field in ('RLSAMT','RLSQTTY')
                    and tx.apptype = 'DF'
                    and dfa.namt > 0
                    and dfa.txdate >= v_FromDate
                group by dfa.acctno
            )
    )dfa1,
   (select *
        from (
                select dfa.acctno,
                    sum(case when tx.field = 'RLSAMT' then (case when tx.txtype = 'D' then -dfa.namt else dfa.namt end)
                                else 0 end) namt,
                    sum(case when tx.field = 'RLSQTTY' then (case when tx.txtype = 'D' then -dfa.namt else dfa.namt end)
                                else 0 end) qtty
                from vw_dftran_all dfa, apptx tx
                where dfa.txcd = tx.txcd
                    and tx.txtype in ('C','D')
                    and tx.field in ('RLSAMT','RLSQTTY')
                    and tx.apptype = 'DF'
                    and dfa.namt > 0
                    and dfa.txdate > v_ToDate
                group by dfa.acctno
            )
    )dfa2
    where df.acctno = dfa1.acctno(+)
          And Df.Acctno = Dfa2.Acctno(+)
          And (Df.Amt-Df.Rlsamt+Nvl(Dfa1.Namt,0)) > 2) Df, ALLCODE al,lntype ln,dftype,brgrp,sbsecurities sb, Afmast Af, Cfmast Cf,Tlgroups ,Tlprofiles Tl,vw_tllog_all La,Tlprofiles Tl1,Tlprofiles Tl2

Where Df.Codeid = Sb.Codeid
      and Df.Rrtype = al.Cdval
      and al.cdname = 'RRTYPE'
      And Df.Actype = Dftype.Actype(+)
      and df.lntype = ln.actype
      and substr(df.acctno,1,4) = brgrp.brid(+)
      and df.acctno = tlhd.dfacctno
      and df.lnacctno = lnd.acctno
      and af.acctno = df.afacctno
      And Af.Custid = Cf.Custid
      and cf.custodycd like V_STRCIACCTNO
      AND DF.ACTYPE LIKE V_STRACTYPE
      AND substr(df.acctno,1,4) LIKE V_STRI_BRID
      And Df.Rrtype Like V_Strrrtype
      And Cf.Careby = Tlgroups.Grpid(+)
       And Cf.Tlid = Tl.Tlid(+)
      And Df.Txnum = La.Txnum(+) 
      And Df.Txdate = La.Txdate(+)
      And La.Tlid = Tl1.Tlid(+)
      And La.Offid = Tl2.Tlid(+)
      And Cf.Careby Like V_Strcareby
order by acctno,txdate,txdate_2;

EXCEPTION
   WHEN OTHERS
   THEN
      Return;
End;                                                              -- PROCEDURE
/

