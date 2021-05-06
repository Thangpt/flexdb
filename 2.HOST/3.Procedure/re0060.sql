CREATE OR REPLACE PROCEDURE re0060 (
   PV_REFCURSOR             IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                      IN       VARCHAR2,
   BRID                     IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PV_RECUSTID    IN        VARCHAR2,
   PV_REGRPID      IN        VARCHAR2
       )
IS
--
-- BAO CAO: TONG HOP TIEU KHOAN TIEN GUI CUA KHACH HANG
-- MODIFICATION HISTORY
-- PERSON           DATE                    COMMENTS
-- -----------      -----------------       ---------------------------
-- TUNH             15-05-2010              CREATED
-- THENN            14-06-2012              MODIFIED    THAY DOI CACH TINH SDDK
-----------------------------------------------------------------------

    V_STROPTION         VARCHAR2  (5);
    V_STRBRID           VARCHAR2  (16);
    v_brid              VARCHAR2(4);

    v_FromDate     date;
    v_ToDate       date;

    v_CustodyCD    varchar2(100);
    v_AFAcctno     varchar2(100);

    V_GROUPID VARCHAR2(10);
    V_RECUSTID VARCHAR2(10);

BEGIN
    -- GET REPORT'S PARAMETERS
   V_STROPTION := OPT;
      v_brid := brid;


 IF  V_STROPTION = 'A' and v_brid = '0001' then
    V_STRBRID := '%';
    elsif V_STROPTION = 'B' then
        select br.mapid into V_STRBRID from brgrp br where br.brid = v_brid;
    else V_STROPTION := v_brid;

END IF;

    v_FromDate := TO_DATE(F_DATE, 'DD/MM/YYYY');
    v_ToDate := v_FromDate;

    IF (PV_CUSTODYCD <> 'ALL' OR PV_CUSTODYCD <> '' OR PV_CUSTODYCD <> NULL) THEN
       v_CustodyCD := PV_CUSTODYCD;
    ELSE
       v_CustodyCD := '%';
    END IF;

    IF (PV_AFACCTNO <> 'ALL' OR PV_AFACCTNO <> '' OR PV_AFACCTNO <> NULL) THEN
       v_AFAcctno := PV_AFACCTNO;
    ELSE
       v_AFAcctno  := '%';
    END IF;

     IF PV_REGRPID <> 'ALL' THEN
        V_GROUPID := PV_REGRPID;
    ELSE V_GROUPID := '%';
    END IF;

     IF PV_RECUSTID <> 'ALL' THEN
        V_RECUSTID := PV_RECUSTID;
    ELSE V_RECUSTID := '%';
    END IF;

OPEN PV_REFCURSOR
FOR
SELECT RE.*,CI.* FROM
(
    select cf.custid,   cf.custodycd   , af.acctno afacctno, cf.fullname, br.description,
        (nvl(ci_debit,0)) ci_debit, (nvl(ci_credit,0)) ci_credit,
        (balance + bamt + mblock + emkamt) - (nvl(ci_move_from_cur,0)) + NVL(DF.BE_DFAMT,0) ci_begin_bal
    from cfmast cf, afmast af, cimast ci, brgrp br,

    (
        select tr.custid, tr.custodycd, tr.acctno AFAcctno,
            sum (case when tr.txtype = 'D' then - tr.namt else tr.namt end) ci_move_from_cur
        from vw_citran_gen tr
        where txtype in ('D','C')
            and field in ('BAMT','BALANCE','MBLOCK','EMKAMT')
            and tr.busdate >= v_FromDate
            and tr.custodycd like v_CustodyCD
            and tr.acctno like v_AFAcctno
        group by tr.custid, tr.custodycd, tr.acctno
        having sum (case when tr.txtype = 'D' then - tr.namt else tr.namt end) <> 0
    )  tr_from_cur,
    (
         SELECT DF.AFACCTNO, SUM(DF.DFBLOCKAMT + DF.DFAMT - NVL(TR.DFAMT,0)) BE_DFAMT
         FROM
             (SELECT * FROM dfgroup UNION ALL SELECT * FROM dfgrouphist) df
             LEFT JOIN
             (
                 select tr.acctno,
                         sum (case when atx.txtype = 'D' then - tr.namt else tr.namt end) dfamt
                     from vw_dftran_all tr, apptx atx
                     where tr.txcd = atx.txcd AND atx.apptype = 'DF'
                         AND atx.txtype in ('D','C')
                         and atx.field IN ('DFBLOCKAMT','DFAMT')
                         and tr.TXDATE >= v_FromDate
                     group by tr.acctno
             ) TR
             ON TR.ACCTNO = DF.GROUPID
         GROUP BY DF.AFACCTNO
         HAVING SUM(DF.DFBLOCKAMT + DF.DFAMT - NVL(TR.DFAMT,0)) <>0
     ) DF,

    (
        SELECT tr.custid, tr.custodycd, tr.afacctno, sum(ci_debit) ci_debit, sum(ci_credit) ci_credit
        FROM
        (
            select tr.custid, tr.custodycd, tr.acctno AFAcctno,
                sum (case when tr.txtype = 'D' then tr.namt else 0 end) ci_debit,
                sum (case when tr.txtype = 'C' then tr.namt else 0 end) ci_credit
            from vw_citran_gen tr
            where tr.txtype in ('D','C')
                and tr.field in ('BAMT','BALANCE','MBLOCK','EMKAMT')
                and tr.tltxcd not in ('6600','6690','2635','2651','2653','2656','2646','2648','2636','2665',
                                        '1144','1145')
                and tr.busdate between v_FromDate and v_ToDate
                and tr.custodycd like v_CustodyCD
                and tr.acctno like v_AFAcctno
                and tr.custodycd not like '091P%'
            group by tr.custid, tr.custodycd, tr.acctno
            UNION ALL
            SELECT cf.custid, cf.custodycd, ci.acctno AFAcctno,
                sum(CASE WHEN ci.txtype = 'D' THEN ci.namt ELSE 0 end) ci_debit,
                sum(CASE WHEN ci.txtype = 'C' THEN ci.namt ELSE 0 end) ci_credit
             FROM
                 (
                 SELECT LN.trfacctno ACCTNO, LNT.TLTXCD, LNT.TXDATE, LNT.TXNUM, LNT.TXCD,
                     LNT.NAMT, APT.field FIELD, 'D' TXTYPE, LN.custbank
                 FROM (SELECT * FROM vw_lntran_all WHERE TXDATE >= v_FromDate AND txdate <= v_ToDate) lnt,
                    vw_lnmast_all LN, APPTX APT
                 WHERE LNT.TLTXCD IN ('2646','2648','2636','2665') AND lnt.TXCD IN ('0014','0024','0090') AND lnt.namt > 0
                     AND LN.prinnml+LN.prinovd+LN.prinpaid > 0 AND LN.FTYPE = 'DF'
                     AND LNT.txcd = APT.txcd AND APT.apptype = 'LN'
                     AND LNT.acctno = LN.acctno
                 ) CI, CFMAST CF, afmast af
             WHERE cf.custid = af.custid AND af.acctno = ci.acctno
             GROUP BY cf.custid, cf.custodycd, ci.acctno
        ) tr
        GROUP BY tr.custid, tr.custodycd, tr.afacctno
    )  tr_from_Todate

    where cf.custid = af.custid and af.acctno = ci.acctno
        and ci.acctno = tr_from_cur.afacctno (+)
        and ci.acctno = tr_from_Todate.afacctno (+)
        AND ci.acctno = df.afacctno (+)
        and substr(cf.custid, 1,4) = br.brid
        and cf.custodycd like v_CustodyCD
        and af.acctno like v_AFAcctno
        and cf.custodycd not like '091P%'
          AND (af.brid LIKE V_STRBRID or instr(V_STRBRID,af.brid) <> 0)
          and cf.custatcom='Y'
          AND AF.COREBANK='N'
    order by cf.custodycd
) CI
LEFT JOIN
(
select c.custid STK_MG, cf.fullname, a.reacctno ma_mg , a.afacctno , g.fullname ten_nhom, g.custid truong_nhom, g.autoid ma_nhom
from reaflnk a, recflnk c, recfdef d, retype t, cfmast cf,
    (
    select g.fullname, g.custid, g.autoid, l.reacctno  from regrp g, regrplnk l where g.autoid = l.refrecflnkid
     and  v_FromDate between l.frdate and nvl(l.clstxdate -1, l.todate)
     and  v_FromDate between g.effdate and g.expdate
    ) g
where substr(a.reacctno,1,10) = c.custid and c.autoid = d.refrecflnkid and t.actype = d.reactype
and t.rerole in ('BM','RM') and cf.custid = c.custid
and a.reacctno = g.reacctno (+)
and v_FromDate between a.frdate and nvl(a.clstxdate -1, a.todate)
and v_FromDate between c.effdate and c.expdate
and v_FromDate between d.effdate and nvl(d.closedate -1 , d.expdate)
) RE
on CI.afacctno = re.afacctno
where nvl(SP_FORMAT_REGRP_MAPCODE(re.ma_nhom),' ') LIKE (CASE WHEN V_GROUPID = '%' THEN '%' ELSE SP_FORMAT_REGRP_MAPCODE(V_GROUPID)||'%' END)
and re.STK_MG like V_RECUSTID

;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

