CREATE OR REPLACE PROCEDURE DF9903 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTODYCD      IN       VARCHAR2,
   I_BRID         IN       VARCHAR2,
   ACTYPE         IN       VARCHAR2,
   RRTYPE         IN       VARCHAR2,
   CAREBY         IN       VARCHAR2
   )
Is
--BANG KE GIAI NGAN
-- ---------   ------  -------------------------------------------

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_STRCIACCTNO  VARCHAR2 (20);

   V_STRI_BRID               VARCHAR2(5);
   V_STRACTYPE               VARCHAR2(5);
   V_STRRRTYPE               VARCHAR2(5);
   V_STRCAREBY               VARCHAR2(5);
BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%';
   END IF;

  IF(CUSTODYCD = 'ALL' or CUSTODYCD is null )
   THEN
        V_STRCIACCTNO := '%%';
   ELSE
        V_STRCIACCTNO := CUSTODYCD;
   END IF;

   IF (I_BRID = 'ALL' or I_BRID is null)
   THEN
      V_STRI_BRID := '%';
   ELSE
      V_STRI_BRID := I_BRID;
   END IF;

   IF (RRTYPE = 'ALL' or RRTYPE is null)
   THEN
      V_STRRRTYPE := '%';
   ELSE
      V_STRRRTYPE := RRTYPE;
   END IF;

   IF(ACTYPE = 'ALL' OR ACTYPE IS NULL)
    THEN
       V_STRACTYPE := '%';
   ELSE
       V_STRACTYPE := ACTYPE;
   END IF;

IF(CAREBY = 'ALL' OR CAREBY IS NULL)
    THEN
       V_STRCAREBY := '%';
   ELSE
       V_STRCAREBY := CAREBY;
   END IF;

OPEN PV_REFCURSOR
FOR
    select lnd.opndate, (A1.cdcontent ||''|| df.ciacctno ||'' || df.custbank) brname,
        dftype.typename, brgrp.brname, df.acctno, df.txnum ,
        cf.custodycd, df.afacctno,  cf.fullname, sb.symbol ,
        (Df.Dfqtty + Df.Rcvqtty + Df.Blockqtty + Df.Carcvqtty+Df.Rlsqtty) Qtty,
        --(case when df.dftype = 'L' then df.refprice else null end ) refprice,
        Df.Refprice,Df.Triggerprice,
        --(case when df.dftype = 'L' then (df.dfqtty + df.rcvqtty + df.blockqtty + df.carcvqtty+df.rlsqtty) * df.refprice else null end ) TongKhopLenh,
        (df.dfqtty + df.rcvqtty + df.blockqtty + df.carcvqtty+df.rlsqtty) * df.refprice TongKhopLenh,
        df.dfprice,ln.rate1,ln.rate2,ln.rate3,ln.printfrq1,ln.printfrq2,ln.printfrq3, round(df.dfprice*100/df.refprice,2) TLGopVon, lnd.rlsdate NgayGiaiNgan, df.amt,
        To_Number(Lnd.Overduedate-Lnd.Opndate) Thoihanhd, Lnd.Overduedate Ngaydenhanhd,
        df.description, dftype.actype,Tlgroups.Grpname Careby,Tl.Tlname Nguoiquanly,
     tl1.tlname NguoiThucHien,tl2.tlname NguoiDuyet
    from
        (
        select *
        from (
                select * from dfmast where status <> 'N'
                union all
                select * from dfmasthist where status <> 'N'
            )
        ) df,
    allcode A1, afmast af, cfmast cf, sbsecurities sb, lntype ln, dftype, brgrp,
    (
        select  ln.acctno, max(ln.rlsdate) rlsdate, max(ln.opndate) opndate, max(lnsc.overduedate) overduedate, max(lnsc.paiddate) paiddate
        from vw_lnmast_all ln ,
            (select * from lnschd union all select * from lnschdhist)lnsc
        where ln.acctno = lnsc.acctno
                    and lnsc.reftype in ('P','GP')
        Group By Ln.Acctno
    )lnd,tlgroups,tlprofiles tl,tllogall la,tlprofiles tl1,tlprofiles tl2
    where df.rrtype = A1.cdval
        and A1.cdname = 'RRTYPE'
        and df.afacctno = af.acctno
        and af.custid = cf.custid
        and df.codeid = sb.codeid
        and df.lntype = ln.actype
        and df.lnacctno = lnd.acctno
        and df.actype = dftype.actype(+)
        and substr(df.acctno,1,4) = brgrp.brid(+)
        and lnd.rlsdate >= to_date(F_DATE,'DD/MM/YYYY')
        and lnd.rlsdate <= to_date(T_DATE,'DD/MM/YYYY')
        AND df.rrtype LIKE V_STRRRTYPE
        and cf.custodycd like V_STRCIACCTNO
        AND DF.ACTYPE LIKE V_STRACTYPE
        AND substr(df.acctno,1,4) LIKE V_STRI_BRID
        And Cf.Careby Like V_Strcareby
        And Cf.Careby = Tlgroups.Grpid(+)
        And Cf.Tlid = Tl.Tlid(+)
        And Df.Txnum = La.Txnum(+) 
        And Df.Txdate = La.Txdate(+)
        And La.Tlid = Tl1.Tlid(+)
        and la.offid = tl2.tlid(+)
    order by acctno
;
EXCEPTION
   WHEN OTHERS
   THEN
      Return;
END;
/

