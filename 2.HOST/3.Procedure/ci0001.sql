CREATE OR REPLACE PROCEDURE ci0001 (
   PV_REFCURSOR             IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                      IN       VARCHAR2,
   BRID                     IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PV_CUSTTYPE    in       varchar2,
   PV_CUSTOMTYPE    in       VARCHAR2 --1.5.1.3 MSBS-1810
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
    v_custtype varchar2(4);
    v_customtype varchar2(4); --1.5.1.3 MSBS-1810

BEGIN
    -- GET REPORT'S PARAMETERS
   V_STROPTION := OPT;
      v_brid := brid;

 IF  V_STROPTION = 'A' and v_brid = '0001' then
    V_STRBRID := '%';
    elsif V_STROPTION = 'B' then
        select br.mapid into V_STRBRID from brgrp br where br.brid = v_brid;
    else V_STRBRID := v_brid;

END IF;

    v_FromDate := TO_DATE(F_DATE, 'DD/MM/YYYY');
    v_ToDate := TO_DATE(T_DATE, 'DD/MM/YYYY');

    IF (PV_CUSTODYCD <> 'ALL' OR PV_CUSTODYCD <> '' OR PV_CUSTODYCD <> NULL) THEN
       v_CustodyCD := PV_CUSTODYCD;
    ELSE
       v_CustodyCD := '%';
    END IF;

    IF (PV_CUSTTYPE <> 'ALL' OR PV_CUSTTYPE <> '' OR PV_CUSTTYPE <> NULL) THEN
       v_custtype := PV_CUSTTYPE;
    ELSE
       v_custtype := '%';
    END IF;

    V_CUSTOMTYPE := PV_CUSTOMTYPE; --1.5.1.3 MSBS-1810

    IF (PV_AFACCTNO <> 'ALL' OR PV_AFACCTNO <> '' OR PV_AFACCTNO <> NULL) THEN
       v_AFAcctno := PV_AFACCTNO;
    ELSE
       v_AFAcctno  := '%';
    END IF;

OPEN PV_REFCURSOR
FOR
    select cf.custid,  nvl(af.description, cf.custodycd ) custodycd , af.acctno afacctno, cf.fullname,
        (nvl(ci_debit,0)) ci_debit, (nvl(ci_credit,0)) ci_credit,
        (nvl(ci.balance,0) + nvl(ci.bamt,0) + nvl(ci.mblock,0) + nvl(ci.emkamt,0)) - (nvl(ci_move_from_cur,0)) + NVL(DF.BE_DFAMT,0) ci_begin_bal,
        a.cdcontent custtype, nvl(od.sumfeeacr,0) sumfeeacr,
        (CASE WHEN cf.country IN ('234') THEN 'TN' ELSE 'NN' END) CUSTOMTYPE --1.5.1.3 MSBS-1810
    from cfmast cf, afmast af, cimast ci,
        ( SELECT sum(o.execamt) sumfeeacr, o.afacctno
        FROM vw_odmast_all o,afmast af, cfmast cf WHERE cf.custodycd not like '091P%' and o.exectype = 'NB'
        and o.afacctno =  af.acctno and af.custid =  cf.custid
        and cf.custatcom = 'Y' and  o.execamt > 0 AND AF.COREBANK='N'
        AND (o.txdate = v_ToDate or o.txdate = fn_get_nextdate(v_ToDate , -1))
        GROUP BY o.afacctno) od,
       (
        select tr.custid, tr.custodycd, tr.acctno AFAcctno,
            sum (case when tr.txtype = 'D' then - tr.namt else tr.namt end) ci_move_from_cur
        from vw_citran_gen tr
        where txtype in ('D','C')
            and field in ('BAMT','BALANCE','MBLOCK','EMKAMT')
            and tr.busdate >= v_FromDate
            and tr.custodycd like v_CustodyCD
            and tr.acctno like v_AFAcctno
            and substr(tr.custid,1,4) like '%'
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
                and substr(tr.custid,1,4) like '%'
                and tr.custodycd not like '091P%'
            group by tr.custid, tr.custodycd, tr.acctno
            UNION ALL
            -- GD VAY DF
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
    , allcode a
    where cf.custid = af.custid and af.acctno = ci.acctno
        and a.cdtype = 'CF' and a.cdname = 'CUSTTYPE' and cf.custtype = a.cdval
        and ci.acctno = tr_from_cur.afacctno (+)
        and ci.acctno = tr_from_Todate.afacctno (+)
        AND ci.acctno = df.afacctno (+)
        and cf.custodycd like v_CustodyCD
        and af.acctno like v_AFAcctno
        and cf.custtype like v_custtype
        AND ((cf.country = '234' AND V_CUSTOMTYPE = 'C') OR (cf.country <> '234' AND V_CUSTOMTYPE = 'F') OR (cf.country LIKE '%' AND V_CUSTOMTYPE = 'ALL')) --1.5.1.3 MSBS-1810
        and cf.custodycd not like '091P%'
          AND (cf.brid LIKE V_STRBRID or instr(V_STRBRID,cf.brid) <> 0)
          and cf.custatcom='Y'
          AND AF.COREBANK='N'
          AND ci.afacctno = od.afacctno(+)
          and
        (
        abs(round(nvl(ci_debit,0),0))
        + abs(round(nvl(ci_credit,0),0) )
        + abs((balance + bamt + mblock + emkamt) - round(nvl(ci_move_from_cur,0),0) + NVL(DF.BE_DFAMT,0)) + nvl(od.sumfeeacr,0)
        ) >=1
    order by cf.custodycd
;

EXCEPTION
   WHEN OTHERS
   THEN
   plog.error(SQLERRM || dbms_utility.format_error_backtrace);
      RETURN;
END;
