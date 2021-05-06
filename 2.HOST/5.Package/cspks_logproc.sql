CREATE OR REPLACE PACKAGE cspks_logproc
IS
    /*----------------------------------------------------------------------------------------------------
     ** Module   : COMMODITY SYSTEM
     ** and is copyrighted by FSS.
     **
     **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
     **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
     **    graphic, optic recording or otherwise, translated in any language or computer language,
     **    without the prior written permission of Financial Software Solutions. JSC.
     **
     **  MODIFICATION HISTORY
     **  Person      Date           Comments
     **  FSS      20-mar-2010    Created
     ** (c) 2008 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/
    PROCEDURE pr_log_mr0002(pv_Action varchar2);
    procedure pr_log_mr3008(pv_Action varchar2);
    procedure pr_log_mr3009(pv_Action varchar2);
    procedure pr_log_mr5005(pv_Action varchar2);
    procedure pr_Drawndown_Margin(pv_Action varchar2);
    procedure pr_calculate_feeadvamt;
    procedure pr_log_sa0015;
    procedure pr_log_ci1018;
    PROCEDURE pr_log_pr0001;
    PROCEDURE pr_log_pr0002;
    PROCEDURE pr_log_pr0003;
    PROCEDURE pr_log_MR3003;
    PROCEDURE pr_log_re0088_1;
    PROCEDURE pr_log_od0019;
    PROCEDURE pr_log_pr0004;
END;
/
CREATE OR REPLACE PACKAGE BODY cspks_logproc
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

PROCEDURE pr_log_pr0004
IS
    v_curdate       VARCHAR2 (20);
    l_mramt         NUMBER (30,4);
    l_mramttopup    NUMBER (30,4);
    l_tsqdmr        NUMBER (30,4);
    l_qttymr        NUMBER;
    l_count          NUMBER;
    l_tsqdtopup     NUMBER (30,4);
    l_qttytopup     NUMBER;
BEGIN
    plog.setbeginsection(pkgctx, 'pr_log_pr0004');
    v_curdate:=cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');
  delete log_pr0004 where txdate = to_date(v_curdate,'dd/mm/rrrr');

    FOR rec IN
    (
        SELECT afacctno, custodycd, l.mramt + round(l.mrint) - l.t0amt - round(l.t0int) mramt, l.mramttopup + round(l.mrinttopup) mramttopup
        FROM log_sa0015 l WHERE txdate = to_date(v_curdate,'dd/mm/rrrr') AND l.mramt + l.mramttopup > 0 --AND afacctno = '0001000468'

    )

    LOOP
        l_mramt := rec.mramt;
        l_mramttopup := rec.mramttopup;

        IF l_mramt > 0 THEN
            FOR rec1 IN
            (
                SELECT afacctno, custodycd, mramt, trade+totalreceiving+totalbuyqtty trade, symbol, codeid, usedsysroom, used74room, ratecl, pricecl, rate74, price74
                FROM tbl_mr3007_log
                WHERE txdate = to_date(v_curdate,'dd/mm/rrrr') AND mramt > 0 AND trade > 0 AND rate74 <> 0 and price74<>0 -- hotfix 20200421
                AND afacctno = rec.afacctno
                ORDER BY afacctno, round((trade+totalreceiving+totalbuyqtty)*(rate74/100)*price74) desc

            )
            LOOP

                FOR rec2 IN
                (
                    SELECT * FROM
                    (
                        select * from
                        (
                            select af.acctno, lnt.actype lntype, odrnum, 'Y' IsSubResource
                                from afmast af, aftype aft, afidtype afid, lntype lnt, cfmast cf
                                where aft.actype = afid.aftype
                                    and afid.actype = lnt.actype
                                    and af.actype = aft.actype
                                    and lnt.custbank = cf.custid(+)
                                    and af.acctno = rec.afacctno AND lnt.chksysctrl = 'Y'
                                    and objname = 'LN.LNTYPE' and lnt.status <> 'N'  AND lnt.lnpurpose = 'D'
                            union all
                            select af.acctno, lnt.actype lntype, 999 odrnum, 'N' IsSubResource
                                from afmast af, aftype aft, lntype lnt, cfmast cf
                                where af.actype = aft.actype
                                    and lnt.custbank = cf.custid(+)
                                    and af.acctno = rec.afacctno AND lnt.chksysctrl = 'Y'
                                    and aft.lntype = lnt.actype and lnt.status <> 'N' AND lnt.lnpurpose = 'D'

                        )
                        order by acctno, case WHEN IsSubResource = 'Y' then 0 else 1 end, odrnum
                    ) ln,
                    (
                        SELECT ACTYPE, basketid, MAX(AUTOID) AUTOID
                                FROM (  SELECT * FROM LNSEBASKET
                                        WHERE EFFDATE <= to_date(v_curdate,'dd/mm/rrrr')
                                        ORDER BY AUTOID DESC
                                        ) GROUP BY ACTYPE, basketid
                    ) lnb
                    WHERE ln.lntype = lnb.actype
                )
                LOOP
                    IF l_mramt > 0 THEN
                        l_tsqdmr :=  round(rec1.trade*(rec1.rate74/100)*rec1.price74);
                        IF l_tsqdmr >= l_mramt THEN
                            l_qttymr := CEIL(l_mramt/(rec1.rate74/100)/rec1.price74);

                            INSERT INTO log_pr0004 (autoid, txdate, custodycd, afacctno, mramt, mramttopup, basket,
                                symbol, codeid, trade, rate, price, tsqd, qttymr, tsqdmr, qttytopup, tsqdtopup)
                            VALUES (seq_log_pr0004.NEXTVAL, to_date(v_curdate,'dd/mm/rrrr'), rec1.custodycd, rec1.afacctno, rec.mramt, rec.mramttopup, rec2.basketid,
                                rec1.symbol, rec1.codeid, rec1.trade, rec1.rate74, rec1.price74, l_tsqdmr, l_qttymr, l_mramt,0,0);

                            l_mramt := 0;
                        ELSE
                            l_qttymr := CEIL(l_tsqdmr/(rec1.rate74/100)/rec1.price74);

                            INSERT INTO log_pr0004 (autoid, txdate, custodycd, afacctno, mramt, mramttopup, basket,
                                symbol, codeid, trade, rate, price, tsqd, qttymr, tsqdmr, qttytopup, tsqdtopup)
                            VALUES (seq_log_pr0004.NEXTVAL, to_date(v_curdate,'dd/mm/rrrr'), rec1.custodycd, rec1.afacctno, rec.mramt, rec.mramttopup, rec2.basketid,
                                rec1.symbol, rec1.codeid, rec1.trade, rec1.rate74, rec1.price74, l_tsqdmr, l_qttymr, l_tsqdmr,0,0);

                            l_mramt := l_mramt - l_tsqdmr;
                        END IF;
                    END IF;
                END LOOP;
            END LOOP;
        END IF;

        IF l_mramttopup > 0 THEN
            FOR rec1 IN
            (
                SELECT * FROM
                (
                    SELECT '1' stt, round((mr.trade+mr.totalreceiving+totalbuyqtty-nvl(l.qttymr,0))*(mr.ratecl/100)*mr.pricecl) tsqd, nvl(l.qttymr,0) b,mr.afacctno,
                        mr.custodycd, mr.mramt, mr.trade+mr.totalreceiving-nvl(l.qttymr,0) trade, mr.symbol, mr.codeid, mr.usedsysroom, mr.used74room, mr.ratecl, mr.pricecl, mr.rate74, mr.price74
                    FROM (SELECT * FROM tbl_mr3007_log WHERE txdate = to_date(v_curdate,'dd/mm/rrrr') AND mramt > 0 AND trade > 0 AND ratecl <> 0) mr,
                    (SELECT * FROM log_pr0004 WHERE txdate = to_date(v_curdate,'dd/mm/rrrr')) l
                    WHERE mr.afacctno = l.afacctno(+) AND mr.codeid = l.codeid(+)
                    AND mr.afacctno = rec.afacctno
                    AND NOT EXISTS (SELECT 1 FROM secbasket sec,
                                            (
                                                SELECT aft.lntype, lnt.typename, lns.basketid FROM afmast af, aftype aft, lntype lnt, lnsebasket lns
                                                WHERE af.acctno = rec.afacctno  AND af.actype = aft.actype AND aft.lntype = lnt.actype AND lnt.chksysctrl = 'Y'
                                                AND lns.actype = lnt.actype AND lnt.custbank IS NULL AND lnt.status <> 'N'  AND lnt.lnpurpose = 'D'
                                                UNION ALL
                                                SELECT ad.actype, lnt.typename, lns.basketid FROM afmast af, aftype aft, afidtype ad, lntype lnt, lnsebasket lns
                                                WHERE af.acctno = rec.afacctno  AND af.actype = aft.actype AND af.actype = ad.aftype AND ad.actype = lnt.actype
                                                AND lns.actype = lnt.actype AND lnt.custbank IS NULL AND lnt.chksysctrl = 'Y'
                                                AND objname = 'LN.LNTYPE' AND lnt.status <> 'N'  AND lnt.lnpurpose = 'D'
                                            ) ln
                                            WHERE ln.basketid = sec.basketid AND mr.symbol = sec.symbol)
                UNION ALL
                    SELECT '2' stt,round((mr.trade+mr.totalreceiving+totalbuyqtty-nvl(l.qttymr,0))*(mr.ratecl/100)*mr.pricecl) tsqd, nvl(l.qttymr,0) b,mr.afacctno,
                        mr.custodycd, mr.mramt, mr.trade+mr.totalreceiving-nvl(l.qttymr,0) trade, mr.symbol, mr.codeid, mr.usedsysroom, mr.used74room, mr.ratecl, mr.pricecl, mr.rate74, mr.price74
                    FROM (SELECT * FROM tbl_mr3007_log WHERE txdate = to_date(v_curdate,'dd/mm/rrrr')) mr, (SELECT * FROM log_pr0004 WHERE txdate = to_date(v_curdate,'dd/mm/rrrr')) l
                    WHERE mr.afacctno = l.afacctno(+) AND mr.codeid = l.codeid(+)
                    AND mr.mramt > 0 AND mr.trade > 0 AND mr.ratecl <> 0
                    AND mr.afacctno = rec.afacctno
                    AND EXISTS (SELECT 1 FROM secbasket sec,
                                          (
                                              SELECT aft.lntype, lnt.typename, lns.basketid FROM afmast af, aftype aft, lntype lnt, lnsebasket lns
                                              WHERE af.acctno = rec.afacctno  AND af.actype = aft.actype AND aft.lntype = lnt.actype AND lnt.chksysctrl = 'Y'
                                              AND lns.actype = lnt.actype AND lnt.custbank IS NULL AND lnt.status <> 'N'  AND lnt.lnpurpose = 'D'
                                              UNION ALL
                                              SELECT ad.actype, lnt.typename, lns.basketid FROM afmast af, aftype aft, afidtype ad, lntype lnt, lnsebasket lns
                                              WHERE af.acctno = rec.afacctno  AND af.actype = aft.actype AND af.actype = ad.aftype AND ad.actype = lnt.actype
                                              AND lns.actype = lnt.actype AND lnt.custbank IS NULL AND lnt.chksysctrl = 'Y'
                                              AND objname = 'LN.LNTYPE' AND lnt.status <> 'N'  AND lnt.lnpurpose = 'D'
                                          ) ln
                                          WHERE ln.basketid = sec.basketid AND mr.symbol = sec.symbol)
                )
                ORDER BY afacctno, stt, tsqd desc

            )
            LOOP
                FOR rec2 IN
                (
                    SELECT * FROM
                    (
                        select * from
                        (
                            select af.acctno, lnt.actype lntype, odrnum, 'Y' IsSubResource
                                from afmast af, aftype aft, afidtype afid, lntype lnt, cfmast cf
                                where aft.actype = afid.aftype
                                    and afid.actype = lnt.actype
                                    and af.actype = aft.actype
                                    and lnt.custbank = cf.custid(+)
                                    and af.acctno = rec.afacctno AND lnt.chksysctrl <> 'Y'
                                    and objname = 'LN.LNTYPE' and lnt.status <> 'N'  AND lnt.lnpurpose = 'D'
                            union all
                            select af.acctno, lnt.actype lntype, 999 odrnum, 'N' IsSubResource
                                from afmast af, aftype aft, lntype lnt, cfmast cf
                                where af.actype = aft.actype
                                    and lnt.custbank = cf.custid(+)
                                    and af.acctno = rec.afacctno AND lnt.chksysctrl <> 'Y'
                                    and aft.lntype = lnt.actype and lnt.status <> 'N' AND lnt.lnpurpose = 'D'
                        )
                        order by acctno, case WHEN IsSubResource = 'Y' then 0 else 1 end, odrnum
                    ) ln,
                    (
                        SELECT ACTYPE, basketid, MAX(AUTOID) AUTOID
                                FROM (  SELECT * FROM LNSEBASKET
                                        WHERE EFFDATE <= to_date(v_curdate,'dd/mm/rrrr')
                                        ORDER BY AUTOID DESC
                                        ) GROUP BY ACTYPE, basketid
                    ) lnb
                    WHERE ln.lntype = lnb.actype
                )
                LOOP
                    SELECT COUNT(*) INTO l_count FROM log_pr0004 WHERE afacctno = rec1.afacctno AND codeid = rec1.codeid AND txdate = to_date(v_curdate,'dd/mm/rrrr');
                    IF l_mramttopup > 0 THEN
                        l_tsqdtopup :=  round(rec1.trade*(rec1.ratecl/100)*rec1.pricecl);
                        IF l_tsqdtopup >= l_mramttopup THEN
                            l_qttytopup := CEIL(l_mramttopup/(rec1.ratecl/100)/rec1.pricecl);
                            IF l_count = 0 THEN
                                INSERT INTO log_pr0004 (autoid, txdate, custodycd, afacctno, mramt, mramttopup, basket,
                                    symbol, codeid, trade, rate, price, tsqd, qttymr, tsqdmr, qttytopup, tsqdtopup)
                                VALUES (seq_log_pr0004.NEXTVAL, to_date(v_curdate,'dd/mm/rrrr'), rec1.custodycd, rec1.afacctno, rec.mramt, rec.mramttopup, rec2.basketid,
                                    rec1.symbol, rec1.codeid, rec1.trade, rec1.ratecl, rec1.pricecl, l_tsqdtopup, 0, 0,l_qttytopup,l_mramttopup);
                            ELSE
                                UPDATE log_pr0004 SET qttytopup = l_qttytopup, tsqdtopup = l_mramttopup WHERE afacctno = rec1.afacctno AND codeid = rec1.codeid AND txdate = to_date(v_curdate,'dd/mm/rrrr');
                            END IF;
                            l_mramttopup := 0;
                        ELSE
                            l_qttytopup := CEIL(l_tsqdtopup/(rec1.ratecl/100)/rec1.pricecl);
                            IF l_count = 0 THEN
                                INSERT INTO log_pr0004 (autoid, txdate, custodycd, afacctno, mramt, mramttopup, basket,
                                    symbol, codeid, trade, rate, price, tsqd, qttymr, tsqdmr, qttytopup, tsqdtopup)
                                VALUES (seq_log_pr0004.NEXTVAL, to_date(v_curdate,'dd/mm/rrrr'), rec1.custodycd, rec1.afacctno, rec.mramt, rec.mramttopup, rec2.basketid,
                                    rec1.symbol, rec1.codeid, rec1.trade, rec1.ratecl, rec1.pricecl, l_tsqdtopup, 0, 0,l_qttytopup,l_tsqdtopup);
                            ELSE
                                UPDATE log_pr0004 SET qttytopup = l_qttytopup, tsqdtopup = l_tsqdtopup WHERE afacctno = rec1.afacctno AND codeid = rec1.codeid AND txdate = to_date(v_curdate,'dd/mm/rrrr');
                            END IF;
                            l_mramttopup := l_mramttopup - l_tsqdtopup;
                        END IF;
                    END IF;
                END LOOP;
            END LOOP;
        END IF;
    END LOOP;



    plog.setendsection(pkgctx, 'pr_log_pr0004');
EXCEPTION
WHEN OTHERS
THEN
    plog.debug (pkgctx,'got error on pr_log_pr0004');
    ROLLBACK;
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'pr_log_pr0004');
    RAISE errnums.E_SYSTEM_ERROR;
END;

PROCEDURE pr_log_od0019
IS
    v_curdate varchar2(20);
BEGIN
    plog.setbeginsection(pkgctx, 'pr_log_od0019');
    v_curdate:=cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');

    INSERT INTO odmastdtl (ORDERID,CODEID,TRADEPLACE,EXECTYPE,PRICETYPE,VIA,ORDERQTTY,QUOTEPRICE,REFORDERID,SYMBOL,AFACCTNO,CUSTODYCD,FULLNAME,TXDATE,TXTIME,RECUSTID,REFULLNAME,DFS,TLID,ISDISPOSAL)

    SELECT mst.*
    FROM
        (
            SELECT OD.ORDERID,OD.CODEID, SE.TRADEPLACE,OD.EXECTYPE,
                OD.PRICETYPE, OD.VIA, OD.ORDERQTTY,OD.QUOTEPRICE, OD.REFORDERID,se.symbol,
                od.afacctno, cf.custodycd, cf.fullname,
                od.txdate, od.txtime, re.recustid, re.refullname, re1.DFS, tl.tlname tlid, NVL(od_org.isdisposal, od.isdisposal)
            FROM SBSECURITIES SE, afmast af, cfmast cf, tlprofiles tl,
                (
                    SELECT * FROM odmast od
                    WHERE od.txdate = to_date(v_curdate,'dd/mm/rrrr')
                    AND od.exectype not in ('AB','AS')
                    and ((od.exectype in ('NB','NS','MS') AND od.via in (SELECT CDVAL FROM allcode WHERE cdname='VIA' AND CDTYPE='SA' AND CDVAL<>'L')) or (od.exectype  not in ('NB','NS','MS'))) -- 1.7.1.6: hotfix via
                ) OD,
                (
                    select re.afacctno, (cf.fullname) refullname,(cf.custid) recustid, (retype.rerole) rerole, re.frdate, nvl(re.clstxdate-1,re.todate) todate
                    from reaflnk re, cfmast cf,retype
                    where substr(re.reacctno,0,10) = cf.custid
                    and re.deltd <> 'Y'
                    AND substr(re.reacctno,11) = RETYPE.ACTYPE
                    AND rerole IN ( 'RM','BM')
                ) re,
                (
                    select re.afacctno, (cf.fullname) dfs,(cf.custid) recustid, (retype.rerole) rerole, re.frdate, nvl(re.clstxdate-1,re.todate) todate
                    from reaflnk re, cfmast cf,retype
                    WHERE substr(re.reacctno,0,10) = cf.custid
                        AND re.deltd <> 'Y'
                        AND substr(re.reacctno,11) = RETYPE.ACTYPE
                        AND rerole IN ('RD')
                ) re1,
                odmast od_org
            WHERE OD.CODEID=SE.CODEID
                and od.afacctno=af.acctno and af.custid=cf.custid
                AND od.afacctno = re.afacctno (+) AND od.txdate >= re.frdate(+) AND od.txdate <= re.todate(+)
                AND od.afacctno = re1.afacctno (+) AND od.txdate >= re1.frdate(+) AND od.txdate <= re1.todate(+)
                And substr(cf.custodycd,4,1) <> 'P'
                AND (CASE WHEN (nvl(od.reforderid,'a') = 'a' OR od.exectype IN ('CB','CS'))  THEN od.tlid
                    ELSE (SELECT max(tlid) tlid FROM (SELECT * FROM odmast od
                                                    WHERE od.txdate = to_date(v_curdate,'dd/mm/rrrr')
                                                    ) od2
                        WHERE od2.orderid <> od.orderid AND od.reforderid= od2.reforderid )
                    END) = tl.tlid
                AND od.reforderid = od_org.orderid(+)
          ----
        ) mst
    ORDER BY TXDATE,CUSTODYCD, AFACCTNO, TXTIME
;

    plog.setendsection(pkgctx, 'pr_log_od0019');
EXCEPTION
WHEN OTHERS
THEN
    plog.debug (pkgctx,'got error on pr_log_od0019');
    ROLLBACK;
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'pr_log_od0019');
    RAISE errnums.E_SYSTEM_ERROR;
END;

PROCEDURE pr_log_re0088_1
IS
    v_curdate varchar2(20);
BEGIN
    plog.setbeginsection(pkgctx, 'pr_log_re0088_1');
    v_curdate:=cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');

    INSERT INTO tbl_re0088_1_log(TXDATE,SO_TK_KH,SO_TK_MG,REROLE,CUSTID_MG,RETYPE,ACTYPE,RDTYPE,RDCUSTID,REFRECFLNKID,EXTCUSTID,EXTROLE,TEN_KH,CUST_KH,TEN_MG,PA_ROLE,TEN_NHOM,TEN_TRUONG_NHOM,TEN_MG_LQ,EXECAMT,FEEACR,PHI_GIAM_TRU_DS,PHI_GIAM_TRU_DT,PHI_DSF)
    select
        to_date(v_curdate,'dd/mm/rrrr'), so_tk_kh, so_tk_mg, rerole, custid_mg, retype, r.actype, rdtype, rdcustid, r.refrecflnkid, nvl(extcustid,'0000000000') extcustid, nvl(extrole,'XX') extrole,
        c1.fullname ten_kh, c1.custodycd cust_kh, c2.fullname ten_mg, retype ||'-' || a.cdcontent pa_role
        , ten_nhom, ten_truong_nhom
        , ten_mg_lq
        , sum(nvl(execamt,0)) execamt, sum(nvl(feeacr,0)) feeacr
        , sum(nvl(execamt,0) * DECODE(rf.CALTYPE,'0001',Rf.RERFRATE,0)/100) phi_giam_tru_ds
        , sum(nvl(feeacr,0) * DECODE(rf.CALTYPE,'0002',rf.RERFRATE,0)/100) phi_giam_tru_dt
        , nvl(case when rerole <> 'RD' and ispaydsf = 'Y' then
                   (case when   ruletype = 'T'--decode(ruletype,'T',0,( sum(feeacr) -    sum(execamt) * DECODE(Rf.CALTYPE,'0001',rf.RERFRATE,0)/100) * icrate / 100) = 0
                                --neu loai tinh phi la bac thang
                                then   ( sum(nvl(feeacr,0)) -  sum(nvl(execamt,0) * DECODE(rf.CALTYPE,'0001',Rf.RERFRATE,0)/100)) * fn_idelta_rd(rdcustid, trunc(to_date(v_curdate,'dd/mm/rrrr'),'MM'), LAST_DAY(to_date(v_curdate,'dd/mm/rrrr'))) / 100

                            else --truong hop loai tinh hoa hong la co dinh
                                 --phi DSF = (phi giao dich - phi giam tru) * ty le phi /100 = hoa hong dsf
                                 decode(ruletype,'T',0,( sum(nvl(feeacr,0)) -    sum(nvl(execamt,0)) * DECODE(Rf.CALTYPE,'0001',rf.RERFRATE,0)/100) * icrate / 100)
                       end
                       )
              else 0
              end,0)  phi_DSF
    from
    (
    SELECT   substr(rd.reacctno,11,4) rdtype, substr(rd.reacctno,1,10) rdcustid , rd.icrate
            , rd.ruletype, rd.rerole rdrerole, od.*, ext.fullname ten_mg_lq, ext.custid extcustid, ext.rerole extrole
        FROM
            (select kh.afacctno so_tk_kh, mg.custid, kh.reacctno so_tk_MG, retype.rerole,  mg.custid custid_mg, kh.refrecflnkid,
                    retype.typename retype, od.execamt, od.feeacr, sb.sectype, retype.actype, ispaydsf, od.txdate, od.afacctno
            from
                (SELECT afacctno, txdate, execamt EXECAMT, feeacr, codeid FROM odmast WHERE deltd <> 'Y' and execamt <> 0
                    UNION ALL SELECT afacctno, txdate, execamt EXECAMT, feeacr, codeid FROM odmasthist WHERE deltd <> 'Y' and execamt <> 0
                ) OD, sbsecurities sb
                ,reaflnk kh,recflnk mg,recfdef,retype--, reuserlnk reu
            where od.codeid = sb.codeid and OD.afacctno = kh.afacctno
            and od.txdate between trunc(to_date(v_curdate,'dd/mm/rrrr'),'MM') AND LAST_DAY(to_date(v_curdate,'dd/mm/rrrr'))
            and od.txdate between kh.frdate and nvl(kh.clstxdate - 1, kh.todate)
            and od.txdate between recfdef.effdate and nvl(recfdef.closedate - 1, recfdef.expdate)
            and kh.reacctno = mg.custid || recfdef.reactype
            and recfdef.refrecflnkid= mg.autoid
            AND substr(kh.reacctno, 11,4) = retype.actype
            --and instr(v_strtlid,SUBSTR(l_format || to_char(kh.refrecflnkid), length(l_format || to_char(kh.refrecflnkid))-l_length+1,l_length)) <> 0
            --AND retype.rerole LIKE V_REROLE
            ) OD
            left join
            (select r.*, icc.icrate, icc.ruletype, e.rerole, rd.opendate rdtypeopendate, nvl(rd.closedate - 1, rd.expdate) rdtypeclosedate
                from reaflnk r, retype e , iccftypedef icc, recflnk rl, recfdef rd
                where substr(r.reacctno,11,4) = e.actype and e.rerole = 'RD' and e.actype = icc.actype and icc.modcode = 'RE'
                and r.reacctno = rl.custid||rd.reactype and rl.autoid = rd.refrecflnkid
            ) rd
            on od.afacctno = rd.afacctno and od.txdate between rd.frdate and nvl(rd.clstxdate -1 , rd.todate)
                                         and od.txdate between rd.rdtypeopendate and rd.rdtypeclosedate
            left join
            (
                select r.reacctno, r.afacctno, r.frdate, r.clstxdate, r.todate, cf.fullname, rt.rerole, cf.custid
                    from reaflnk r, cfmast cf, retype rt
                    where substr(r.reacctno,1,10) = cf.custid and substr(r.reacctno,11,4) = rt.actype
            ) ext
            on od.afacctno = ext.afacctno and od.txdate between ext.frdate and nvl(ext.clstxdate -1 , ext.todate)
                and od.rerole <> ext.rerole
    ) r
    ,rerfee rf  --moi loai CK co ty le khac nhau
    , --truong nhom
    (SELECT cfmast.fullname ten_truong_nhom, tn.fullname ten_nhom, nhom.reacctno FROM regrplnk nhom, regrp tn, cfmast
        WHERE tn.autoid = nhom.refrecflnkid AND nhom.status = 'A'
        AND tn.custid = cfmast.custid) b
    ,cfmast c1, afmast af1, cfmast c2, allcode a/*, cfmast c3*/
    where  r.actype = rf.refobjid (+) and r.sectype = rf.symtype (+)
    and r.so_tk_mg = b.reacctno (+)
    and r.so_tk_kh = af1.acctno and af1.custid = c1.custid and r.custid_mg = c2.custid
    and a.cdtype = 'RE' and a.cdname = 'REROLE' and a.cdval = r.rerole
    --and nvl(extcustid,'0000000000') like V_RDCUSTID
    --and nvl(extrole,'XX') like V_RDREROLE
    group by
        so_tk_kh, so_tk_mg, rerole, custid_mg, retype, r.actype, rdtype, rdcustid,
        c1.fullname , c2.fullname , retype ||'-' || a.cdcontent, ten_nhom, ten_truong_nhom,ispaydsf,
        ruletype,Rf.CALTYPE,rf.RERFRATE, icrate,  c1.custodycd, ten_mg_lq/*, c3.fullname*/,r.refrecflnkid, nvl(extcustid,'0000000000'), nvl(extrole,'XX')
    order by retype,so_tk_kh

;
    plog.setendsection(pkgctx, 'pr_log_re0088_1');
EXCEPTION
WHEN OTHERS
THEN
    plog.debug (pkgctx,'got error on pr_log_re0088_1');
    ROLLBACK;
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'pr_log_re0088_1');
    RAISE errnums.E_SYSTEM_ERROR;
END;

PROCEDURE pr_log_pr0001
IS
    v_curdate varchar2(20);
BEGIN
    plog.setbeginsection(pkgctx, 'pr_log_pr0001');
    v_curdate:=cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');
  delete tbl_pr0001_log where txdate =  to_date(v_curdate,'DD/MM/RRRR');

    INSERT INTO tbl_pr0001_log(txdate, fullname, custodycd, afacctno, actype, codeid, symbol, grp_code,
    grpname, selimit, grp_pravlremain, grp_prinused, ts_grp, ratecl, pricecl, note, refullname, autoid, pcc, brid)

    SELECT to_date(v_curdate,'DD/MM/RRRR') txdate, cf.fullname, prgrp.*, amr.refullname, amr.autoid, amr.rg_grfullname pcc, amr.brid
        FROM cfmast cf, afmast af, v_getsecprgrpinfo prgrp,
        (
            SELECT amr.*, crm.rg_grfullname, crm.autoid
            FROM
            (
                SELECT cf.fullname refullname, re.reacctno, re.afacctno, rcf.brid
                FROM reaflnk re, retype, recflnk rcf, cfmast cf
                WHERE to_date(v_curdate,'DD/MM/RRRR') BETWEEN re.frdate AND nvl(re.clstxdate-1,re.todate)
                    AND rcf.custid = substr(re.reacctno,1,10)
                    AND substr(re.reacctno, 0, 10) = cf.custid
                    AND re.deltd <> 'Y' AND rcf.custid = cf.custid
                    AND substr(re.reacctno, 11) = retype.actype
                    AND rerole IN ('RM', 'BM')
            ) amr,
            (
                SELECT rg.autoid, reg.reacctno, rg.fullname rg_grfullname
                FROM regrplnk reg , regrp rg
                WHERE reg.refrecflnkid = rg.autoid
                    AND reg.frdate <= to_date(v_curdate,'dd/mm/rrrr')
                    AND nvl(reg.clstxdate-1,reg.todate) >= to_date(v_curdate,'DD/MM/RRRR')
            ) crm
            WHERE amr.reacctno = crm.reacctno(+)
        ) amr
        WHERE cf.custid = af.custid AND af.acctno = prgrp.afacctno
            AND prgrp.grp_prinused <> 0 AND af.acctno = amr.afacctno(+)
    ;
    plog.setendsection(pkgctx, 'pr_log_pr0001');
    EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_log_pr0001');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_log_pr0001');
      RAISE errnums.E_SYSTEM_ERROR;
END;

PROCEDURE pr_log_pr0002
IS
    v_curdate varchar2(20);
BEGIN
    plog.setbeginsection(pkgctx, 'pr_log_pr0002');
    v_curdate:=cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');
  delete tbl_pr0002_log where txdate = to_date(v_curdate,'DD/MM/RRRR');

    INSERT INTO tbl_pr0002_log(txdate, selimit, codeid, symbol, grp_code, grp_pravlremain, grp_prinused, note)

    SELECT to_date(v_curdate,'DD/MM/RRRR') txdate, sel.selimit, sb.codeid, sb.symbol, sel.autoid grpname, nvl(prgrp.grp_pravlremain,0) grp_pravlremain,
        sum(nvl(prgrp.grp_prinused,0)) grp_prinused, sel.note
    FROM selimitgrp sel, v_getsecprgrpinfo prgrp, sbsecurities sb
    WHERE sel.autoid = prgrp.grp_code(+) AND sel.codeid = sb.codeid
    GROUP BY sel.autoid, sel.selimit, sb.codeid, sb.symbol, prgrp.grp_pravlremain, sel.note
    ORDER BY sb.symbol
    ;
    plog.setendsection(pkgctx, 'pr_log_pr0002');
    EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_log_pr0002');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_log_pr0002');
      RAISE errnums.E_SYSTEM_ERROR;
END;

PROCEDURE pr_log_pr0003
IS
    v_curdate varchar2(20);
BEGIN
    plog.setbeginsection(pkgctx, 'pr_log_pr0003');
    v_curdate:=cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');
  delete tbl_pr0003_log where txdate = to_date(v_curdate,'DD/MM/RRRR');

    INSERT INTO tbl_pr0003_log(txdate, codeid, symbol, listingqtty, syroomlimit, syprinused, sy_pravlremain, syscallmargin,
        roomlimit, prinused, pravlremain, princallmargin, selimit, grp_prinused, grp_pravlremain, grpcallmargin)

    SELECT to_date(v_curdate,'DD/MM/RRRR') txdate, sb.codeid, sb.symbol, sb.listingqtty,
        nvl(a.syroomlimit,0) syroomlimit, nvl(a.syprinused,0) syprinused, nvl(sy_pravlremain,0) sy_pravlremain, nvl(a.syscallmargin,0) syscallmargin,
        nvl(a.roomlimit,0) roomlimit, nvl(a.prinused,0) prinused, nvl(a.pravlremain,0) pravlremain, nvl(princallmargin,0) princallmargin,
        nvl(b.selimit,0) selimit, nvl(b.grp_prinused,0) grp_prinused, nvl(grp_pravlremain,0) grp_pravlremain, nvl(grpcallmargin,0) grpcallmargin
    FROM securities_info sb, sbsecurities sbs,
    (
        SELECT a.codeid, a.roomlimit, a.syroomlimit,
            sum(syprinused * nvl(afs.mrratioloan,0)/100 * LEAST(a.marginprice,afs.mrpriceloan)) syscallmargin,
            sum(prinused * nvl(afm.mrratioloan,0) /100 * LEAST(a.marginrefprice,afm.mrpriceloan)) princallmargin,
            sum(syprinused) syprinused, sum(prinused) prinused,
            a.roomlimit - sum(prinused) pravlremain, a.syroomlimit - sum(syprinused) sy_pravlremain
        FROM
        (
            SELECT af.actype, pr.codeid, sb.marginprice, sb.marginrefprice,
                max(pr.roomlimit) roomlimit, max(pr.syroomlimit) syroomlimit,
                nvl(sum(case when restype = 'M' then nvl(afpr.prinused,0) else 0 end),0) prinused,
                nvl(sum(case when restype = 'S' then nvl(afpr.prinused,0) else 0 end),0) syprinused
            FROM vw_marginroomsystem pr, vw_afpralloc_all afpr, afmast af, securities_info sb
            WHERE pr.codeid = afpr.codeid(+) AND pr.codeid = sb.codeid
                AND afpr.afacctno = af.acctno(+)
            GROUP BY af.actype, afpr.afacctno, pr.codeid, sb.marginprice, sb.marginrefprice
        ) a, afserisk afs, afmrserisk afm
        WHERE a.actype = afs.actype(+) AND a.codeid = afs.codeid(+)
            AND a.actype = afm.actype(+) AND a.codeid = afm.codeid(+)
        GROUP BY a.codeid, a.roomlimit, a.syroomlimit
    ) a,
    (
        SELECT a.codeid, max(b.selimit) selimit, max(b.selimit) - sum(grp_prinused) grp_pravlremain,
            sum(grp_prinused) grp_prinused, sum(grpcallmargin) grpcallmargin
        FROM
        (
            SELECT grp.codeid, sum(grp_prinused) grp_prinused,
                sum(grp.grp_prinused * nvl(afs.mrratioloan,0) /100 * LEAST(sb.marginprice,afs.mrpriceloan)) grpcallmargin
            FROM v_getsecprgrpinfo grp, afserisk afs, securities_info sb
            WHERE grp.codeid = sb.codeid
                AND grp.actype = afs.actype(+) AND grp.codeid = afs.codeid(+)
            GROUP BY grp.grp_code, grp.codeid
        ) a,
        (
            SELECT codeid, sum(selimit) selimit FROM selimitgrp GROUP BY codeid
        ) b
        WHERE a.codeid = b.codeid
        GROUP BY a.codeid
    ) b
    WHERE sb.codeid = a.codeid(+) AND sb.codeid = b.codeid(+)
        AND sb.codeid = sbs.codeid AND sbs.tradeplace NOT IN ('006','003')
    ORDER BY sb.symbol;

    plog.setendsection(pkgctx, 'pr_log_pr0003');
    EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_log_pr0003');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_log_pr0003');
      RAISE errnums.E_SYSTEM_ERROR;
END;

procedure pr_log_ci1018
is
    v_curdate varchar2(20);
begin
    plog.setbeginsection(pkgctx, 'pr_log_ci1018');
    v_curdate:=cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');
    --delete from ci1018_log where txdate = to_date(v_curdate,'dd/mm/rrrr');
    insert into ci1018_log(TLTXCD_FILTER,TLTXCD,TXDESC,TXNUM,BUSDATE,TXDATE,CUSTODYCD,ACCTNO,CUSTODYCDC,ACCTNOC,AMT,MK,CK,BRID,TLBRID,TLID,OFFID,BANKID,COREBANK,BANKNAME,TRDESC,TXTYPE,CREDIT,DEBIT)
    select A.*,
          case when txtype <> 'D' then amt else 0 end Credit,
          case when txtype <> 'C' then amt else 0 end Debit from (
        select ci.tltxcd tltxcd_filter,ci.tltxcd,tltx.txdesc ,ci.txnum,ci.busdate ,ci.txdate,cf.custodycd,af.acctno,
        cfc.custodycd custodycdc,afc.acctno acctnoc,ci.namt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,
        nvl(AF.brid,'') brid,nvl(ci.brid,'') tlbrid,nvl(ci.tlid,'') tlid,nvl(ci.OFFID,'') OFFID,
        ''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,
        nvl(ci.trdesc,ci.txdesc) trdesc,
        ci.txtype
        from --tllog TL ,citran ci,
        vw_citran_gen_inday ci,
        afmast af,cfmast cf, afmast afc,cfmast cfc ,tltx  , tlprofiles mk,tlprofiles ck
        where ci.acctno= af.acctno and cf.custid =af.custid
        and ci.ref =afc.acctno and afc.custid =cfc.custid
        and tltx.tltxcd = ci.tltxcd
        and  ci.tlid = mk.tlid(+)
        and  ci.OFFID =ck.tlid(+)
        and ci.tltxcd in ('1120','1130','1134','1188') and ci.field ='BALANCE'
        and ci.txcd in ('0011','0012')

        union ALL
        SELECT case when  ci.tltxcd in ('3350','3354') then '3342' else  ci.tltxcd end tltxcd_filter,
            case when  ci.tltxcd in ('3350','3354') then '3342'
                    when ci.tltxcd in ( '1201'/*,'1101'*/, '1120','1130','1111','1185','1188')  and ci.txcd = '0028' then ' '
                    else  ci.tltxcd end  tltxcd ,
                case when ci.tltxcd in ('1201'/*,'1101'*/,'1120','1130','1111','1185','1188') and ci.txcd = '0028' then  utf8nums.c_const_RPT_CI1018_Phi_DESC
                    else  tltx.txdesc end txdesc ,ci.txnum,ci.busdate ,ci.txdate,
        cf.custodycd,af.acctno, '' custodycdc,'' acctnoc
        , case when ci.tltxcd = '8894' and af.corebank = 'Y' then ci.msgamt
               else  ci.namt end /*ci.msgamt*/ amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,
        nvl(AF.brid,'') brid,nvl(ci.brid,'') tlbrid,nvl(ci.tlid,'') tlid,nvl(ci.OFFID,'') OFFID,
        ''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname ,
        case when ci.tltxcd in ('1201'/*,'1101'*/,'1120','1130','1111','1185','1188') and ci.txcd = '0028' then tltx.txdesc || ' - ' || ci.tltxcd
             when ci.tltxcd in ('2200','8894','3382','3383','0088','1113') and ci.txcd = '0011' then ci.trdesc else ci.txdesc end trdesc, ci.txtype
        FROM afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck, vw_citran_gen_inday ci
        where/* substr(ci.msgacct,0,10)*/ ci.acctno =af.acctno and af.custid = cf.custid
        and tltx.tltxcd = ci.tltxcd
        and  ci.tlid = mk.tlid(+)
        and  ci.OFFID =ck.tlid(+)
        and ci.tltxcd in ('1140','1100','1107',/*'1101',*/'1133'
        ,'1104','1108','1111','1114','1104','1112','1145','1144'
        ,'1123','1124','1126','1127','1162','1180','1182','1184','1185','1189','6613','1105','1198','1199','8866'
        ,'8856','0066','8889','8894','8851','5541','3386'
        ,'1113', '2200','3382','3383','0088','1201',
        /*'1101',*/'1120','1130','1111','1185','1188','5569') --Chaunh bo 3384, 1188
        and  ci.field in ('BAMT','BALANCE','MBLOCK','EMKAMT')
        and case when ci.tltxcd in ('1113', '2200','3382','3383'/*,'0088'*/) and ci.txcd <> '0011' then 0
            when ci.TLTXCD = '0088' and ci.txcd not in ('0011','0012') then 0
             when ci.tltxcd in (/*'1101',*/'1120','1130',/*'1111',*/'1185','1188') and ci.txcd <> '0028' then 0 --14/10 bo 1101, 1111
            else 1 end = 1

        and ci.msgamt + ci.namt >0
        
        union ALL
        SELECT ci.tltxcd tltxcd_filter,
            case when ci.txcd = '0028' then ' '
                    else  ci.tltxcd end  tltxcd ,
                case when ci.txcd = '0028' then  utf8nums.c_const_RPT_CI1018_Phi_DESC
                    else  tltx.txdesc end txdesc ,ci.txnum,ci.busdate ,ci.txdate,
        cf.custodycd,af.acctno, '' custodycdc,'' acctnoc
        , ci.namt  amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,
        nvl(AF.brid,'') brid,nvl(ci.brid,'') tlbrid,nvl(ci.tlid,'') tlid,nvl(ci.OFFID,'') OFFID,
        fld.cvalue bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname ,
        case when ci.txcd = '0028' then tltx.txdesc || ' - ' || ci.tltxcd else ci.txdesc end trdesc, ci.txtype
        FROM afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck, vw_citran_gen_inday ci, tllogfld fld
        where/* substr(ci.msgacct,0,10)*/ ci.acctno =af.acctno and af.custid = cf.custid
        and tltx.tltxcd = ci.tltxcd
        and  ci.tlid = mk.tlid(+)
        and  ci.OFFID =ck.tlid(+)
        and ci.tltxcd in ('1101')
        and  ci.field in ('BAMT','BALANCE','MBLOCK','EMKAMT')
        and ci.txnum = fld.txnum and ci.txdate = fld.txdate
        and fld.fldcd = '80'
        and ci.msgamt + ci.namt >0

        union ALL
        SELECT   ci.tltxcd||'T'|| sts.trfbuyext tltxcd_filter,
        ci.tltxcd||'T'|| sts.trfbuyext  tltxcd ,tltx.txdesc ,ci.txnum,ci.busdate ,ci.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,ci.msgamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(ci.brid,'') tlbrid,nvl(ci.tlid,'') tlid,nvl(ci.OFFID,'') OFFID,
        ''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,nvl(ci.trdesc,ci.txdesc) trdesc, ci.txtype
        FROM afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,vw_citran_gen_inday CI, stschd sts
        where ci.msgacct=af.acctno and af.custid = cf.custid
        and tltx.tltxcd = ci.tltxcd
        and  ci.tlid = mk.tlid(+)
        and  ci.OFFID =ck.tlid(+)
        AND CI.field ='BALANCE'
        and ci.tltxcd ='8855'
        and ci.ref = sts.orgorderid
        and sts.duetype ='SM'

        union ALL
        SELECT case when  ci.tltxcd in ('3350','3354') then '3342' else  ci.tltxcd end tltxcd_filter,
            case when  ci.tltxcd in ('3350','3354') and  CI.TXCD ='0012'  then '3342'
                    when  ci.tltxcd in ('3350','3354') and  CI.TXCD ='0011'  then '3343'
                    else  ci.tltxcd end  tltxcd  ,
                     CASE WHEN ci.TLTXCD = '3350' and ci.txcd = '0011' THEN nvl(ci.TRDESC,tltx.txdesc)  ELSE tltx.txdesc END txdesc,
                      ci.txnum,ci.busdate ,ci.txdate
                    ,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,ci.namt amt,nvl(mk.tlname,'') mk
                    ,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(ci.brid,'') tlbrid,nvl(ci.tlid,'') tlid,nvl(ci.OFFID,'') OFFID,
        ''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,ci.trdesc, ci.txtype
        FROM afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,vw_citran_gen_inday CI
        where ci.msgacct=af.acctno and af.custid = cf.custid
        and tltx.tltxcd = ci.tltxcd
        and  ci.tlid = mk.tlid(+)
        and  ci.OFFID =ck.tlid(+)
        AND CI.TXCD in('0012','0011')
        and ci.tltxcd IN('3350','3354')

        UNION ALL
        SELECT  ci.tltxcd tltxcd_filter,
        ci.tltxcd ,tltx.txdesc ,ci.txnum,ci.busdate ,ci.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,CI.NAMT amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(ci.brid,'') tlbrid,nvl(ci.tlid,'') tlid,nvl(ci.OFFID,'') OFFID,
        ''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,nvl(ci.trdesc,ci.txdesc) trdesc, ci.txtype
        FROM afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,vw_citran_gen_inday CI
        where ci.msgacct=af.acctno and af.custid = cf.custid
        and tltx.tltxcd = ci.tltxcd
        and  ci.tlid = mk.tlid(+)
        and  ci.OFFID =ck.tlid(+)
        AND CI.field ='BALANCE'
        and ci.tltxcd in('1153','8865','1139')

        union ALL
        SELECT tl.tltxcd tltxcd_filter,
        tl.tltxcd,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,ads.amt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.brid,'') tlbrid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
        '' bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc, ' ' txtype
        FROM tllog TL,adschd ads ,afmast af,cfmast cf,tltx, tlprofiles mk,tlprofiles ck
        where tl.msgamt =ads.autoid
        and TL.msgacct = af.acctno and af.custid = cf.custid
        and tltx.tltxcd = tl.tltxcd
        and  tl.tlid = mk.tlid(+)
        and  tl.OFFID =ck.tlid(+)
        and tl.tltxcd in ('1178')

        union ALL

        SELECT   tl.tltxcd tltxcd_filter,
        tl.tltxcd ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,tl.msgamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.brid,'') tlbrid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
        ,nvl(bank.fullname,' ') bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc,
        case when tl.tltxcd in ('1132','1136') then 'D' else 'C' end txtype
        FROM tllog TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,tllogfld tlfld,banknostro bank
        where tl.msgacct=af.acctno and af.custid = cf.custid and tl.deltd <> 'Y'
        and tltx.tltxcd = tl.tltxcd
        and  tl.tlid = mk.tlid(+)
        and  tl.OFFID =ck.tlid(+)
        and tlfld.txdate = tl.txdate
        and tlfld.txnum = tl.txnum
        and tlfld.fldcd='02'
        and tlfld.cvalue=bank.shortname(+)
        and tl.tltxcd in ('1131','1132','1136','1141')

        union ALL
        SELECT ci.tltxcd tltxcd_filter,
        ci.tltxcd,tltx.txdesc ,ci.txnum,ci.busdate ,ci.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,CI.NAMT amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(ci.brid,'') tlbrid,nvl(ci.tlid,'') tlid,nvl(ci.OFFID,'') OFFID,
        nvl(CFB.shortname,'') bankid ,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, CI.trdesc trdesc, ci.txtype
        FROM dfgroup dfg ,afmast af,cfmast cf,tltx, tlprofiles mk,tlprofiles ck,
         lnmast ln,lntype , CFMAST CFB,vw_citran_gen_inday CI
        where ci.msgacct= dfg.groupid and dfg.afacctno = af.acctno and af.custid = cf.custid
        and tltx.tltxcd = ci.tltxcd
        and dfg.lnacctno =ln.acctno
        and ln.actype =lntype.actype
        AND LN.actype= LNTYPE.actype
        AND LN.custbank = CFB.custid(+)
        and ci.tlid = mk.tlid(+)
        and ci.OFFID =ck.tlid(+)
        AND CI.ref =LN.acctno
        and ci.tltxcd in ('2646','2648','2665','2636')
        AND CI.field ='BALANCE'

        union ALL
        SELECT   ci.tltxcd tltxcd_filter,
        ci.tltxcd ,tltx.txdesc ,ci.txnum,ci.busdate ,ci.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,ci.NAMT amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(ci.brid,'') tlbrid,nvl(ci.tlid,'') tlid,nvl(ci.OFFID,'') OFFID,
        nvl(CFB.shortname,'') bankid ,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,ci.trdesc, ci.txtype
        FROM afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,
         vw_citran_gen_inday ci,
         lnmast ln,lntype , CFMAST CFB
        where ci.msgacct=af.acctno and af.custid = cf.custid
        and tltx.tltxcd = ci.tltxcd
        and  ci.tlid = mk.tlid(+)
        and  ci.OFFID =ck.tlid(+)
        and ci.ref = ln.acctno and ci.field ='BALANCE'
        AND LN.actype= LNTYPE.actype
        AND LN.custbank = CFB.custid(+)
        and ci.tltxcd in ('5540','5566','5567')

        union ALL
        SELECT   tl.tltxcd tltxcd_filter,
        tl.tltxcd ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,tl.msgamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.brid,'') tlbrid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
        nvl(CFB.shortname,'') bankid ,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc, 'C' txtype
        FROM tllog TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,  tllogfld tlfld, lnmast ln,lntype , CFMAST CFB
        where tl.msgacct=af.acctno and af.custid = cf.custid
        and tltx.tltxcd = tl.tltxcd
        and  tl.tlid = mk.tlid(+)
        and  tl.OFFID =ck.tlid(+)
        and tl.txnum= tlfld.txnum
        and tl.txdate = tlfld.txdate
        and tlfld.fldcd ='21'
        and tlfld.cvalue = ln.acctno(+)
        AND LN.actype= LNTYPE.actype
        AND LN.custbank = CFB.custid(+)
        AND LN.actype= LNTYPE.actype
        AND LN.custbank = CFB.custid(+)
        and tl.tltxcd ='2674'
        union ALL
        SELECT  tl.tltxcd tltxcd_filter,
        tl.tltxcd   tltxcd ,tltx.txdesc ,tl.txnum,tl.busdate ,tl.txdate,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc,ci.namt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.brid,'') tlbrid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID,
        ''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,CI.trdesc, ci.txtype
        FROM tllog TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,
         vw_citran_gen_inday   ci
        where ci.acctno=af.acctno and af.custid = cf.custid
        and tltx.tltxcd = tl.tltxcd
        and  tl.tlid = mk.tlid(+)
        and  tl.OFFID =ck.tlid(+)
        and tl.txdate = ci.txdate
        and tl.txnum = ci.txnum
        and tl.tltxcd  IN (/*'0088',*/'1670','1610','1600','1620','1137','1138','3384','3394') --chaunh add 3384, 3394
        and ci.field ='BALANCE'

        union all
        --begin chaunh -- voi giao dich corebank
        ----- 8894
        select  tl.tltxcd tltxcd_filter,
            tl.tltxcd, tl.txdesc, tl.txnum, tl.busdate, tl.txdate, cf.custodycd, af.acctno
            ,' ' custodycdc,'' acctnoc
            , tl.msgamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.brid,'') tlbrid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
            ,' ' bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc
            ,  'C' txtype --tong tien ban
        from tllog tl, cfmast cf, semast se, afmast af, tlprofiles mk, tlprofiles ck
        where  tl.tltxcd = '8894' and af.corebank = 'Y'
            and cf.custid = af.custid and tl.msgacct = se.acctno and se.afacctno = af.acctno
            and tl.tlid = mk.tlid(+) and tl.chkid = ck.tlid(+)

        union all
        select tl.tltxcd tltxcd_filter,
            tl.tltxcd,case when  crb.trfcode = 'TRFODSRTL' then 'Phi ' || crb.notes else crb.notes end txdesc, tl.txnum, tl.busdate, tl.txdate, cf.custodycd, af.acctno
            ,' ' custodycdc,'' acctnoc
            ,case when crb.trfcode = 'TRFODSRTL' then  tl.msgamt - crb.txamt --phi ban
                  when crb.trfcode = 'TRFODSRTDF' then crb.txamt end  amt --thue ban
            ,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.brid,'') tlbrid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
            ,' ' bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc
            ,  'D'  txtype  --thue ban
        from tllog tl, CRBTXREQ crb, cfmast cf, semast se, afmast af, tlprofiles mk, tlprofiles ck
        where tl.txnum = crb.refcode and tl.txdate = crb.txdate and tltxcd = '8894'
            and cf.custid = af.custid and tl.msgacct = se.acctno and se.afacctno = af.acctno
            and tl.tlid = mk.tlid(+) and tl.chkid = ck.tlid(+)

        union all
        --3386
        select tl.tltxcd tltxcd_filter,
            tl.tltxcd, crb.notes txdesc, tl.txnum, tl.busdate, tl.txdate, cf.custodycd, af.acctno
            ,' ' custodycdc,'' acctnoc,crb.txamt amt,nvl(mk.tlname,'') mk,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.brid,'') tlbrid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
            ,' ' bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname, tl.txdesc trdesc
            , case when crb.trfcode='TRFCAUNREG' then 'D' end txtype
        from tllog tl, CRBTXREQ crb, cfmast cf, afmast af, tlprofiles mk, tlprofiles ck
        where tl.txnum = crb.refcode and tl.txdate = crb.txdate and tl.tltxcd = '3386'
            and cf.custid = af.custid and tl.msgacct = af.acctno
            and tl.tlid = mk.tlid(+) and tl.chkid = ck.tlid(+)

        union all
        --3350,3354
        SELECT case when  ci.tltxcd in ('3350','3354') then '3342' else  ci.tltxcd end tltxcd_filter,
                case when  ci.tltxcd in ('3350','3354') and  ci.field in ( 'CRAMT','RECEIVING')  then '3342' --cong
                    when  ci.tltxcd in ('3350','3354') and  CI.field = 'DRAMT'  then '3343' --tru
                    else  ci.tltxcd end  tltxcd  ,tltx.txdesc ,ci.txnum,ci.busdate ,ci.txdate
                    ,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc
                    ,case when ci.tltxcd = '3354' then  ci.msgamt else ci.namt end amt
                    ,nvl(mk.tlname,'') mk
                    ,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(ci.brid,'') tlbrid,nvl(ci.tlid,'') tlid,nvl(ci.OFFID,'') OFFID
                    ,''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,ci.trdesc
                    , case when ci.field = 'CRAMT' and ci.tltxcd = '3350' then 'C'
                           when ci.field = 'RECEIVING' and ci.tltxcd = '3354' then 'C'
                           when ci.field = 'DRAMT' and ci.tltxcd = '3350' then 'D'
                           end txtype
        FROM afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck,vw_citran_gen_inday CI
        where ci.msgacct=af.acctno and af.custid = cf.custid
        and tltx.tltxcd = ci.tltxcd and af.corebank = 'Y'
        and  ci.tlid = mk.tlid(+)
        and  ci.OFFID =ck.tlid(+)
        AND case when ci.tltxcd = '3350' and CI.field in('CRAMT','DRAMT') then 1
                 when ci.tltxcd = '3354' and ci.field = 'RECEIVING' then 1
                 else 0 end = 1
        and ci.tltxcd IN('3350','3354')

        union all
        --8866,8856,0066
        SELECT tl.tltxcd tltxcd_filter,
            tl.tltxcd  ,tl.txdesc ,tl.txnum,tl.busdate ,tl.txdate
                    ,cf.custodycd,af.acctno, '' custodycdc,'' acctnoc
                    , tl.msgamt amt
                    ,nvl(mk.tlname,'') mk
                    ,nvl(ck.tlname,'')  ck,nvl(AF.brid,'') brid,nvl(tl.brid,'') tlbrid,nvl(tl.tlid,'') tlid,nvl(tl.OFFID,'') OFFID
                    ,''bankid,af.corebank,decode(af.bankname,'---',utf8nums.c_const_COMPANY_NAME,af.bankname) bankname,tl.txdesc
                    , case when tl.tltxcd = '8866' then 'C'
                           when  tl.tltxcd in ('8856','0066') then 'D'
                           end txtype
        FROM tllog TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck
        where tl.msgacct=af.acctno and af.custid = cf.custid
        and tltx.tltxcd = tl.tltxcd and af.corebank = 'Y'
        and  tl.tlid = mk.tlid(+)
        and  tl.OFFID =ck.tlid(+)
        and tl.tltxcd IN('8866','8856','0066')

        UNION ALL
        --1170, 1179
        SELECT tl.tltxcd tltxcd_filter,
            tl.tltxcd  ,tl.txdesc ,tl.txnum,tl.busdate ,tl.txdate
            , cf.custodycd,af.acctno, '' custodycdc,'' acctnoc
            , tl.msgamt amt
            , NVL(mk.tlname,'AUTO') mk
            , NVL(ck.tlname,'AUTO') ck,NVL(AF.brid,'') brid,NVL(tl.brid,'') tlbrid,NVL(tl.tlid,'') tlid,NVL(tl.OFFID,'') OFFID
            , '' bankid,af.corebank,'' bankname, tltx.txdesc
            , CASE WHEN tl.tltxcd = '1170' THEN 'D'
                   WHEN  tl.tltxcd IN ('1179') THEN 'C'
              END txtype
        FROM tllog TL,afmast af,cfmast cf ,tltx, tlprofiles mk,tlprofiles ck
        WHERE tl.msgacct=af.acctno AND af.custid = cf.custid
        AND tltx.tltxcd = tl.tltxcd
        AND  tl.tlid = mk.tlid(+)
        AND  tl.OFFID =ck.tlid(+)
        AND tl.tltxcd IN('1170','1179')
        --end chaunh
        )A
        where substr(a.custodycd,4,1) <> 'P'
        ORDER BY A.TLTXCD ,a.busdate,A.TXNUM;

    plog.setendsection(pkgctx, 'pr_log_ci1018');
    EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_log_ci1018');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_log_ci1018');
      RAISE errnums.E_SYSTEM_ERROR;
end;

procedure pr_log_MR3003
is
    v_CURRDATE  DATE;
    v_EOMDATE  DATE;
    v_NEXTDATE  DATE;
    v_enddate   date;
    V_DATE DATE;

    v_mprinused number;
    v_syprinused number;
begin
    plog.setbeginsection(pkgctx, 'pr_log_MR3003');
  SELECT TO_DATE (varvalue, systemnums.c_date_format) INTO v_CURRDATE
  FROM sysvar WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
  SELECT TO_DATE (varvalue, systemnums.c_date_format) INTO v_NEXTDATE
  FROM sysvar WHERE grname = 'SYSTEM' AND varname = 'NEXTDATE';

  --CHECK EOM PROCESSING
  --SELECT DECODE(extract(MONTH FROM v_NEXTDATE)-extract(MONTH FROM v_CURRDATE),0,'N','Y') into v_EOM FROM DUAL;
  SELECT ADD_MONTHS(TRUNC(v_CURRDATE, 'MM'), 1)  INTO v_EOMDATE FROM DUAL;
  SELECT LAST_DAY(v_CURRDATE) INTO v_enddate FROM DUAL;
  select MIN(SBDATE) INTO V_DATE from  sbcldr where holiday='N' and  sbdate >=v_EOMDATE ;

  IF V_DATE =v_NEXTDATE THEN

    begin
    select sum(prinused * least(sec0.marginrefprice,rsk.mrpriceloan)) mprinused,
           sum(SYPRINUSED * least(sec0.marginprice,rsk.mrpriceloan)) syprinused
           into v_mprinused,v_syprinused
                      from afmast af,
                      (
                            SELECT afacctno, codeid,
                                SUM(case when AFPR.restype = 'M' then PRINUSED else 0 end) PRINUSED,
                                SUM(case when AFPR.restype = 'S' then PRINUSED else 0 end) SYPRINUSED
                            FROM vw_afpralloc_all AFPR
                            GROUP BY afacctno, codeid
                      ) pr,
                      securities_info sec0,
                      afmrserisk rsk
                  where pr.codeid =  sec0.codeid(+)
                      and pr.afacctno = af.acctno
                      and af.actype = rsk.actype(+)
                      and rsk.codeid = sec0.codeid;
     EXCEPTION  WHEN OTHERS THEN
             v_mprinused:=0;
             v_syprinused:=0;
     end;

    insert into MR3003_LOG(AUTOID,TXDATE,PREVDATE,NEXTDATE,TOPSYMBOL,PRINUSED, MPRINUSED,SYPRINUSED)

      select TO_CHAR(v_enddate,'DDMMYYYY') AUTOID, v_CURRDATE TXDATE,v_enddate PREVDATE,v_EOMDATE NEXTDATE,
          max(decode(rn,1,symbol))
                || '-' || max(decode(rn,2,symbol))
                || '-' || max(decode(rn,3,symbol))
                || '-' || max(decode(rn,4,symbol))
                || '-' || max(decode(rn,5,symbol))
                     TOPSYMBOL,
           max(decode(rn,1,prinused))
                || '-' || max(decode(rn,2,prinused))
                || '-' || max(decode(rn,3,prinused))
                || '-' || max(decode(rn,4,prinused))
                || '-' || max(decode(rn,5,prinused))
                     PRINUSED, v_mprinused MPRINUSED, v_syprinused SYPRINUSED

          from
          (
              select rownum rn, codeid,symbol, prinused from (
                select codeid, symbol, prinused
                from (
                  select pr.codeid,sec0.symbol, sum(prinused * rsk.mrratioloan * least(sec0.marginrefprice,rsk.mrpriceloan) / 100)   prinused
                      from afmast af,
                      (
                            SELECT afacctno, codeid,
                                SUM(case when AFPR.restype = 'M' then PRINUSED else 0 end) PRINUSED,
                                SUM(case when AFPR.restype = 'S' then PRINUSED else 0 end) SYPRINUSED
                            FROM vw_afpralloc_all AFPR
                            GROUP BY afacctno, codeid
                      ) pr,
                      securities_info sec0,
                      afmrserisk rsk
                  where pr.codeid =  sec0.codeid(+)
                      and pr.afacctno = af.acctno
                      and af.actype = rsk.actype(+)
                      and rsk.codeid = sec0.codeid
                  group by pr.codeid,sec0.symbol)
                  order by prinused  desc
              ) where rownum <= 5
          ) mst;


  END IF;


    plog.setendsection(pkgctx, 'pr_log_MR3003');
    EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_log_MR3003');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_log_MR3003');
      RAISE errnums.E_SYSTEM_ERROR;
end;

procedure pr_log_mr0002(pv_Action varchar2)
is
    v_curdate varchar2(20);
begin
    plog.setbeginsection(pkgctx, 'pr_log_mr0002');
    v_curdate:=cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');
    insert into mr0002_log
    (actype, typename, co_financing, ismarginacc, custodycd,
       acctno, trfbuyext, fullname, phone1, email,
       rlsmarginrate, marginrate, rtnamt, addvnd, rtnamtt2,
       addvndt2, mrirate, mrmrate, mrlrate, totalvnd,
       advanceline, setotalcallass, mrcrlimit, mrcrlimitmax,
       dfodamt, mrcrlimitremain, status, dueamount, ovdamount,
       calldate, calltime, txdate, log_date, log_action)
    select actype, typename, co_financing, ismarginacc, custodycd,
       acctno, trfbuyext, fullname, phone1, email,
       rlsmarginrate, marginrate, rtnamt, addvnd, rtnamtt2,
       addvndt2, mrirate, mrmrate, mrlrate, totalvnd,
       advanceline, setotalcallass, mrcrlimit, mrcrlimitmax,
       dfodamt, mrcrlimitremain, status, dueamount, ovdamount,
       calldate, calltime, to_date(v_curdate,'DD/MM/RRRR'),SYSTIMESTAMP log_date, pv_Action log_action from vw_mr0002;
    plog.setendsection(pkgctx, 'pr_log_mr0002');
    EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_log_mr0002');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_log_mr0002');
      RAISE errnums.E_SYSTEM_ERROR;
end;

procedure pr_log_mr3008(pv_Action varchar2)
is
    v_curdate varchar2(20);
begin
    plog.setbeginsection(pkgctx, 'pr_log_mr3008');
    v_curdate:=cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');
    insert into mr3008_log
    (ftype, custodycd, afacctno, dfgroupid, fullname,
       marginrate, mrmrate, odamt, navaccount, addvnd,
       refullname, txdate, log_date, log_action)
    select a.*, to_date(v_curdate,'DD/MM/RRRR') txdate, SYSTIMESTAMP log_date, pv_Action log_action
        from (
        select --l_OPT OPT,l_BRID BRID, l_NEXTDATE RPTDATE,
        'AF' FTYPE,cf.custodycd, af.acctno afacctno, '' dfgroupid, cf.fullname,
        sec.rlsmarginrate marginrate, af.mrmrate,
            ci.odamt, sec.NAVACCOUNT,
            greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrirate =0 then - outstandingt2 else
                             greatest( 0,- (outstandingt2+depofeeamt) - navaccountt2 *100/af.mrmrate) end),0)) addvnd,
        re.refullname

        from cfmast cf, afmast af, cimast ci, aftype aft, mrtype mrt, v_getsecmarginratio_all sec,
        (select re.afacctno, MAX(cf.fullname) refullname
            from reaflnk re, sysvar sys, cfmast cf,RETYPE
            where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
            and substr(re.reacctno,0,10) = cf.custid
            and varname = 'CURRDATE' and grname = 'SYSTEM'
            and re.status <> 'C' and re.deltd <> 'Y'
            AND   substr(re.reacctno,11) = RETYPE.ACTYPE
            AND  rerole IN ( 'RM','BM')
            GROUP BY AFACCTNO
        ) re
        where cf.custid = af.custid

        and af.acctno = sec.afacctno
        and af.actype = aft.actype
        and af.acctno = ci.acctno
        and aft.mrtype = mrt.actype
        and mrt.mrtype = 'T'
        and af.acctno = re.afacctno(+)
        and ((af.mrlrate < sec.rlsmarginrate AND sec.rlsmarginrate < af.mrmrate)

            )
                  -- HaiLT them dieu kien de lay len 3 ngay lien tiep ti le thuc te < ti le canh bao
        and  not EXISTS
        (
                        SELECT AFACCTNO FROM
                        (
                            SELECT DISTINCT A.AFACCTNO,COUNT(*) NUM FROM
                                (select distinct txdate , afacctno/*, marginrate*/ from  mr3008_log where log_action = 'BF-EOD' --group by txdate, afacctno, marginrate
                                union
                                select distinct txdate, afacctno/*,  marginrate*/ from mr3009_logall where log_action = 'BF-EOD'-- group by txdate, afacctno, marginrate
                                ) a, afmast b
                            where a.afacctno = b.acctno --AND LOG_ACTION = 'BF-EOD'
                            --and a.marginrate < b.mrmrate
                            AND A.TXDATE>=
                                           ( select sbdate from sbcurrdate where numday=-3 and sbtype='B')
                            GROUP BY a.AFACCTNO
                        )
                        WHERE NUM>=3 and af.acctno=afacctno
                    )
        --and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
        --Chaunh: neu dang doi xu ly thi khong call
        --and af.acctno not in (select distinct afacctno from mr3009_logall a where log_action = 'AF-END'
        --                    and a.txdate = getcurrdate/*(
        --                                    select max(sbdate) from SBCLDR where CLDRTYPE='000' and  HOLIDAY <> 'Y'
       --                                      and sbdate < getcurrdate
       --                                  )*/
        --             )
       -- --and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
        union all

        SELECT --l_OPT OPT,l_BRID BRID, l_NEXTDATE RPTDATE,
        'DF' FTYPE,custodycd,afacctno, groupid dfgroupid,fullname, rtt, mrate, DDF, tadf, ODSELLDF,
        refullname
        FROM ( select al1.cdcontent DEALFLAGTRIGGER,DF.GROUPID,CF.CUSTODYCD,CF.FULLNAME,AF.ACCTNO AFACCTNO,CF.ADDRESS,CF.IDCODE,nvl(DF.CONTRACTCHK,'N') CONTRACTCHK,DECODE(DF.LIMITCHK,'N',0,1) LIMITCHECK ,
        DF.ORGAMT -DF.RLSAMT AMT, DF.LNACCTNO , DF.STATUS DEALSTATUS ,DF.ACTYPE ,DF.RRTYPE, DF.DFTYPE, DF.CUSTBANK, DF.CIACCTNO,DF.FEEMIN,
        DF.TAX,DF.AMTMIN,DF.IRATE,DF.MRATE,DF.LRATE,DF.RLSAMT,DF.DESCRIPTION, lns.rlsdate, lns.overduedate,
        to_date (lns.overduedate,'DD/MM/RRRR') - to_date ((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') duenum,
        (case when df.ciacctno is not null then df.ciacctno when df.custbank is not null then   df.custbank else '' end )
        RRID , decode (df.RRTYPE,'O',1,0) CIDRAWNDOWN,decode (df.RRTYPE,'B',1,0) BANKDRAWNDOWN,
        decode (df.RRTYPE,'C',1,0) CMPDRAWNDOWN,dftype.AUTODRAWNDOWN,df.calltype,LN.RLSAMT AMTRLS,
        LN.RATE1,LN.RATE2,LN.RATE3,LN.CFRATE1,LN.CFRATE2,LN.CFRATE3,
        A1.CDCONTENT PREPAIDDIS,A2.CDCONTENT INTPAIDMETHODDIS,A3.CDCONTENT AUTOAPPLYDIS,TADF,DDF, RTTDF RTT, ODCALLDF, ODCALLSELLRCB,ODCALLSELLMRATE, ODCALLSELLMRATE - NVL(od.sellamount,0) ODSELLDF, ODCALLSELLRXL, ODCALLRTTDF, ODCALLRTTDF ODCALLRTTF,
        CURAMT, CURINT, CURFEE, LNS.PAID, DF.DFBLOCKAMT, vndselldf, vndwithdrawdf, tadf - ddf*(v.irate/100) vwithdrawdf,
        LEAST(ln.MInterm, TO_NUMBER( TO_DATE(lns.OVERDUEDATE,'DD/MM/RRRR') - TO_DATE(lns.RLSDATE,'DD/MM/RRRR')) )  MInterm, ln.intpaidmethod, lnt.WARNINGDAYS,
        A4.CDCONTENT RRTYPENAME, AF.FAX1, CF.EMAIL, ODDF, re.refullname,
        nvl(ln.prinovd+ln.intovdacr+ln.intnmlovd+ln.feeintovdacr+ln.feeintnmlovd,0)  df_ovdamt
        from dfgroup df, dftype, lnmast ln, lntype lnt ,lnschd lns, afmast af , cfmast cf, allcode al1,
           ALLCODE A1, ALLCODE A2, ALLCODE A3, v_getgrpdealformular v , allcode A4, v_getdealsellamt od,
        (select re.afacctno, MAX(cf.fullname) refullname
            from reaflnk re, sysvar sys, cfmast cf,RETYPE
            where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
            and substr(re.reacctno,0,10) = cf.custid
            and varname = 'CURRDATE' and grname = 'SYSTEM'
            and re.status <> 'C' and re.deltd <> 'Y'
            AND   substr(re.reacctno,11) = RETYPE.ACTYPE
            AND  rerole IN ( 'RM','BM')
            GROUP BY AFACCTNO
        ) re
        where df.lnacctno= ln.acctno and ln.acctno=lns.acctno and ln.actype=lnt.actype and lns.reftype='P' and df.afacctno= af.acctno and af.custid= cf.custid and df.actype=dftype.actype
        and A1.cdname = 'YESNO' and A1.cdtype ='SY' AND A1.CDVAL = LN.PREPAID
        and A2.cdname = 'INTPAIDMETHOD' and A2.cdtype ='LN' AND A2.CDVAL = LN.INTPAIDMETHOD
        and A3.cdname = 'AUTOAPPLY' and a3.cdtype ='LN' AND A3.CDVAL = LN.AUTOAPPLY
        and A4.cdname = 'RRTYPE' and A4.cdtype ='DF' AND A4.CDVAL = DF.RRTYPE
        and df.flagtrigger=al1.cdval and al1.cdname='FLAGTRIGGER' and df.groupid=v.groupid(+)
        and df.groupid=od.groupid(+) and df.afacctno=od.afacctno(+)
        and df.afacctno = re.afacctno(+)
        --and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
        ) WHERE ODDF>0 AND ( RTT <= MRATE AND RTT> LRATE) and df_ovdamt <=0
        ) a  order by custodycd, dfgroupid;
    plog.setendsection(pkgctx, 'pr_log_mr3008');
    EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_log_mr3008');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_log_mr3008');
      RAISE errnums.E_SYSTEM_ERROR;
end;

procedure pr_log_mr3009(pv_Action varchar2)
is
    v_curdate varchar2(20);
begin
    plog.setbeginsection(pkgctx, 'pr_log_mr3009');
    v_curdate:=cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');
    insert into mr3009_logall
    (ftype, custodycd, afacctno, dfgroupid, fullname,
       marginrate, mrlrate, odamt, navaccount, rtnamtcl,
       rtnamtdf, ovd, marginovd, refullname,rtnamt2, txdate,
       log_date, log_action)
    select a.*, to_date(v_curdate,'DD/MM/RRRR') txdate, SYSTIMESTAMP log_date, pv_Action log_action
        from (
        select --l_OPT OPT,l_BRID BRID, l_NEXTDATE RPTDATE,
        'AF' FTYPE,cf.custodycd, af.acctno afacctno, '' dfgroupid, cf.fullname,
            sec.rlsmarginrate marginrate, af.mrlrate,
            greatest(-outstandingt2,0) odamt, sec.navaccountt2 NAVACCOUNT,
            round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrirate =0 then - outstandingt2 else
                             greatest( 0,- (outstandingt2+depofeeamt) - sec.navaccountt2*100/af.mrirate) end),0),greatest(ovamt - balance -nvl(sec.NYOVDAMT,0) - nvl(avladvance,0),0)),0) rtnamtCL,
            0 rtnamtDF,
            nvl(lnt0.ovd,0) ovd,
            nvl(cl_ovdamt,0) MARGINOVD,
            re.refullname,
            round(greatest(round((case when nvl(sec.marginrate,0) * af.mrirate =0 then - sec.outstanding else
                     greatest( 0,- (sec.outstanding+depofeeamt) - sec.navaccount *100/af.mrirate) end),0),0),0) rtnamt2 --- So tien nop them de ve R an toan
        from cfmast cf, afmast af, cimast ci, aftype aft, mrtype mrt, v_getsecmarginratio_all sec,
        (
            /*select trfacctno,
                sum(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd) ovd,
                sum(prinovd+intovdacr+intnmlovd+feeintovdacr+feeintnmlovd) cl_ovdamt
            from lnmast
            where ftype = 'AF' group by trfacctno
            */
            select ln.trfacctno, max(case when  fn_getworkday(nvl(lns.overduedate,to_date('01/01/2000','DD/MM/RRRR'))) <> 0 and
                       lnt.LIQOVDDAY <= fn_getworkday(nvl(lns.overduedate,to_date('01/01/2000','DD/MM/RRRR'))) then 1 else 0 end) liqday,
                sum(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd) ovd,
                sum(prinovd+intovdacr+intnmlovd+feeintovdacr+feeintnmlovd) cl_ovdamt
            from
                ( select acctno, min(overduedate) overduedate from lnschd where reftype in ('P','GP') group by acctno) lns, --no bao lanh thi khong check ngay
                        lnmast ln, lntype lnt
            where ln.acctno=lns.acctno(+) and ln.actype=lnt.actype  AND ftype = 'AF'
            group by ln.trfacctno

        ) lnt0,
        (select re.afacctno, MAX(cf.fullname) refullname
            from reaflnk re, sysvar sys, cfmast cf,RETYPE
            where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
            and substr(re.reacctno,0,10) = cf.custid
            and varname = 'CURRDATE' and grname = 'SYSTEM'
            and re.status <> 'C' and re.deltd <> 'Y'
            AND   substr(re.reacctno,11) = RETYPE.ACTYPE
            AND  rerole IN ( 'RM','BM')
            GROUP BY AFACCTNO
        ) re
        where cf.custid = af.custid and af.acctno = sec.afacctno
        and af.actype = aft.actype and af.acctno = ci.acctno
        and cf.custatcom = 'Y'
        and aft.mrtype = mrt.actype --and mrt.mrtype = 'T'
        and af.acctno = lnt0.trfacctno(+)
        and af.acctno = re.afacctno(+)
        and ((sec.rlsmarginrate<af.mrlrate and af.mrlrate <> 0)
              or (ci.ovamt-nvl(sec.NYOVDAMT,0)>1 AND liqday>0)
              /*or (EXISTS (select 1 from mr3008_log where afacctno= af.acctno
                            and txdate = (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname ='PREVDATE' and grname ='SYSTEM')
                            and log_action ='AF-END' and FTYPE ='AF'
                         )
                    and sec.rlsmarginrate > af.mrlrate and sec.rlsmarginrate<af.mrmrate
                    --and l_ISCALLED='Y'
                    and af.mrlrate <>0 and af.mrmrate <> 0
                 )*/
             or (EXISTS  (
                        SELECT AFACCTNO FROM (
                            SELECT DISTINCT A.AFACCTNO,COUNT(*) NUM FROM
                                (select txdate , afacctno/*, marginrate */from  mr3008_log where log_action = 'BF-EOD' group by txdate, afacctno
                                union
                                select txdate, afacctno/*, -1 marginrate*/ from mr3009_logall where log_action = 'BF-EOD' group by txdate, afacctno
                                ) a, afmast b
                            where a.afacctno = b.acctno --AND LOG_ACTION = 'BF-EOD'
                            --and a.marginrate < b.mrmrate
                            AND A.TXDATE>= (select sbdate from sbcurrdate where numday=-3 and sbtype='B'
                                           )
                            GROUP BY a.AFACCTNO
                        )  WHERE NUM>=3 AND AFACCTNO=af.acctno
                    )
                AND sec.rlsmarginrate < AF.mrmrate
                 )
            --chaunh
           --or ( sec.rlsmarginrate < AF.mrmrate
          --      and (af.acctno in (
           --             select distinct afacctno from mr3009_logall a where log_action = 'AF-END'
           --                 and a.txdate = getcurrdate
                                        /*(
                                            select max(sbdate) from SBCLDR where CLDRTYPE='000' and  HOLIDAY <> 'Y'
                                             and sbdate < getcurrdate
                                         )*/
          --                     )
         --           )
         --        )
            )
        /*and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
        and case when p_ISASSREMAIN = 'ALL' then 1
                 when sec.navaccountt2 > 0 and p_ISASSREMAIN = 'Y' then 1
                 when sec.navaccountt2 <= 0 and p_ISASSREMAIN = 'N' then 1
            else 0 end <> 0*/

        union all

        SELECT --l_OPT OPT,l_BRID BRID, l_NEXTDATE RPTDATE,
        'DF' FTYPE, custodycd,afacctno,groupid,
        fullname,rtt,lrate,DDF, TADF,0, ODSELLDF, ovd, nvl(df_ovdamt,0) MARGINOVD, refullname, 0 rtnamt2
        FROM ( select al1.cdcontent DEALFLAGTRIGGER,DF.GROUPID,CF.CUSTODYCD,CF.FULLNAME,AF.ACCTNO AFACCTNO,CF.ADDRESS,CF.IDCODE,nvl(DF.CONTRACTCHK,'N') CONTRACTCHK,DECODE(DF.LIMITCHK,'N',0,1) LIMITCHECK ,
        DF.ORGAMT -DF.RLSAMT AMT, DF.LNACCTNO , DF.STATUS DEALSTATUS ,DF.ACTYPE ,DF.RRTYPE, DF.DFTYPE, DF.CUSTBANK, DF.CIACCTNO,DF.FEEMIN,
        DF.TAX,DF.AMTMIN,DF.IRATE,DF.MRATE,DF.LRATE,DF.RLSAMT,DF.DESCRIPTION, lns.rlsdate, lns.overduedate,
        to_date (lns.overduedate,'DD/MM/RRRR') - to_date ((SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') duenum,
        (case when df.ciacctno is not null then df.ciacctno when df.custbank is not null then   df.custbank else '' end )
        RRID , decode (df.RRTYPE,'O',1,0) CIDRAWNDOWN,decode (df.RRTYPE,'B',1,0) BANKDRAWNDOWN,
        decode (df.RRTYPE,'C',1,0) CMPDRAWNDOWN,dftype.AUTODRAWNDOWN,df.calltype,LN.RLSAMT AMTRLS,
        LN.RATE1,LN.RATE2,LN.RATE3,LN.CFRATE1,LN.CFRATE2,LN.CFRATE3,
        A1.CDCONTENT PREPAIDDIS,A2.CDCONTENT INTPAIDMETHODDIS,A3.CDCONTENT AUTOAPPLYDIS,TADF,DDF, RTTDF RTT, ODCALLDF, ODCALLSELLMRATE - NVL(od.sellamount,0) ODSELLDF, ODCALLRTTDF, ODCALLMRATE ODCALLRTTF,
        ODCALLSELLRCB, ODCALLSELLMRATE, ODCALLSELLMRATE - NVL(od.sellamount,0) ODCALLSELLMR, ODCALLSELLRXL,
        CURAMT, CURINT, CURFEE, LNS.PAID, DF.DFBLOCKAMT, vndselldf, vndwithdrawdf, tadf - ddf*(v.irate/100) vwithdrawdf,
        LEAST(ln.MInterm, TO_NUMBER( TO_DATE(lns.OVERDUEDATE,'DD/MM/RRRR') - TO_DATE(lns.RLSDATE,'DD/MM/RRRR')) )  MInterm, ln.intpaidmethod, lnt.WARNINGDAYS,
        A4.CDCONTENT RRTYPENAME, AF.FAX1, CF.EMAIL, ODDF, nvl(avladvance,0) avladvance, balance, ovamt, depofeeamt,nvl(lnt0.ovd,0) ovd, odoverduedf, re.refullname,
        nvl(ln.prinovd+ln.intovdacr+ln.intnmlovd+ln.feeintovdacr+ln.feeintnmlovd,0) df_ovdamt
        from dfgroup df, dftype, lnmast ln, lntype lnt ,lnschd lns, afmast af, cimast ci , cfmast cf, allcode al1,
           ALLCODE A1, ALLCODE A2, ALLCODE A3, v_getgrpdealformular v , allcode A4, v_getdealsellamt od,
           (select sum(aamt) aamt,sum(depoamt) avladvance,sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno from v_getAccountAvlAdvance_all group by afacctno) adv,
        (select trfacctno,
                sum(decode(ftype,'AF',1,0)*(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd)) ovd
            from lnmast
            group by trfacctno) lnt0,
        (select re.afacctno, MAX(cf.fullname) refullname
            from reaflnk re, sysvar sys, cfmast cf,RETYPE
            where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
            and substr(re.reacctno,0,10) = cf.custid
            and varname = 'CURRDATE' and grname = 'SYSTEM'
            and re.status <> 'C' and re.deltd <> 'Y'
            AND   substr(re.reacctno,11) = RETYPE.ACTYPE
            AND  rerole IN ( 'RM','BM')
            GROUP BY AFACCTNO
        ) re
        where df.lnacctno= ln.acctno and ln.acctno=lns.acctno and ln.actype=lnt.actype and lns.reftype='P' and df.afacctno= af.acctno and af.custid= cf.custid and df.actype=dftype.actype
        and A1.cdname = 'YESNO' and A1.cdtype ='SY' AND A1.CDVAL = LN.PREPAID
        and A2.cdname = 'INTPAIDMETHOD' and A2.cdtype ='LN' AND A2.CDVAL = LN.INTPAIDMETHOD
        and A3.cdname = 'AUTOAPPLY' and a3.cdtype ='LN' AND A3.CDVAL = LN.AUTOAPPLY
        and A4.cdname = 'RRTYPE' and A4.cdtype ='DF' AND A4.CDVAL = DF.RRTYPE
        and df.flagtrigger=al1.cdval and al1.cdname='FLAGTRIGGER' and df.groupid=v.groupid(+)
        and df.groupid=od.groupid(+) and df.afacctno=od.afacctno(+)
        and af.acctno = ci.acctno and af.acctno = adv.afacctno(+)
        and af.acctno = lnt0.trfacctno(+)
        and af.acctno = re.afacctno(+)
        /*and case when l_OPT = 'A' then 1 else instr(l_BRID_FILTER,substr(af.acctno,1,4)) end  <> 0
        and case when p_ISASSREMAIN = 'ALL' then 1
                 when TADF > 0 and p_ISASSREMAIN = 'Y' then 1
                 when TADF <= 0 and p_ISASSREMAIN = 'N' then 1
            else 0 end <> 0*/
        ) MST WHERE ((ODDF>0 AND (RTT <= LRATE or odoverduedf>0))
                or df_ovdamt > 0
                or (EXISTS (select 1 from mr3008_log where afacctno= MST.afacctno and txdate = (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname ='PREVDATE' and grname ='SYSTEM') and log_action ='AF-END' and FTYPE ='DF')
                and RTT > LRATE and RTT < MRATE /*and l_ISCALLED='Y'*/ and LRATE <>0 and MRATE <> 0
                )
            )
        ) a order by custodycd, dfgroupid;
    plog.setendsection(pkgctx, 'pr_log_mr3009');
    EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_log_mr3009');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_log_mr3009');
      RAISE errnums.E_SYSTEM_ERROR;
end;

procedure pr_log_mr5005(pv_Action varchar2)
is
    v_curdate varchar2(20);
begin
    plog.setbeginsection(pkgctx, 'pr_log_mr0002');
    v_curdate:=cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');


    /*insert into MR5005_LOG
        select to_date(v_curdate,'DD/MM/RRRR'),pv_Action,custodycd,actype,acctno,
            marginrate, GREATEST(rtnamt2 - asssellamt, T0OVDAMOUNT + OVDAMOUNT + CIDEPOFEEACR - TOTALVND - realsellamt) rtnremainamt, rtnamt2 AMT2IRATE, rtnamt AMT2MRATE,
            T0OVDAMOUNT, OVDAMOUNT,CIDEPOFEEACR,TOTALVND, GREATEST(T0OVDAMOUNT + OVDAMOUNT + CIDEPOFEEACR - TOTALVND,rtnamt2) addvnd,
            realsellamt, asssellamt, mrirate, MRMRATE, MRLRATE ,RTNAMOUNTREF , OVDAMOUNTREF,
            SELLLOSTASSREF, SELLAMOUNTREF,novdamt,trfbuyext,ADDVNDT2,setotalcallass, mrt0prinamt, mrt0intamt,prin_move, INT_MOVE, PRIN_DRAWNDOWN
        FROM
        (

            select af.groupleader, af.actype, DECODE(ismarginacc,'Y','YES','NO') ismarginacc,
            custodycd,af.acctno, af.trfbuyext,
            nvl(sec.rlsmarginrate,0) rlsmarginrate, nvl(sec.marginrate,0) marginrate,ci.CIDEPOFEEACR,
            round(greatest(round((case when nvl(sec.marginrate,0) * af.mrmrate =0 then - sec.outstanding else
                                 greatest( 0,- sec.outstanding - sec.navaccount *100/af.mrmrate) end),0),0),0) rtnamt,
            round(greatest(round((case when nvl(sec.marginrate,0) * af.mrirate =0 then - sec.outstanding else
                                 greatest( 0,- sec.outstanding - sec.navaccount *100/af.mrirate) end),0),0),0) rtnamt2, --- So tien nop them de ve R an toan
            round(greatest(round((case when nvl(sec.marginrate,0) * af.mrmrate =0 then - sec.outstanding else
                                 greatest( 0,- (sec.outstanding +depofeeamt) - sec.navaccount *100/af.mrmrate) end),0),greatest(ovamt - balance - nvl(avladvance,0),0)),0) addvnd,
            round(greatest(round((case when nvl(sec.marginrate,0) * af.mrirate =0 then - sec.outstanding else
                                 greatest( 0,- (sec.outstanding +depofeeamt) - sec.navaccount *100/af.mrirate) end),0),greatest(ovamt - balance - nvl(avladvance,0),0)),0) addvnd2, -- So tien nop them ve Ran toan va tra het no qua han
            greatest(ovamt+depofeeamt - balance - nvl(avladvance,0),0) novdamt, -- So tien can nop them de tra het no qua han
            round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrmrate =0 then - outstandingt2 else
                                 greatest( 0,- outstandingt2 - sec.navaccountt2*100/af.mrmrate) end),0),0),0) rtnamtt2,
            round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrmrate =0 then - outstandingt2 else
                                 greatest( 0,- (outstandingt2+round(depofeeamt)) - sec.navaccountt2*100/af.mrmrate) end),0),greatest(ovamt - balance - round(nvl(avladvance,0)),0)),0) addvndt2,
            round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrmrate =0 then - sec.outstandingt2 else
                                 greatest( 0,- (sec.outstandingt2+round(depofeeamt)) - sec.navaccountt2 *100/af.mrmrate) end),0),greatest(round(ovamt) - balance - nvl(avladvance,0) - nvl(lostass,0),0))  - nvl(od.sellamount,0),0) rtnremainamt,
            round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrirate =0 then - sec.outstandingt2 else
                                 greatest( 0,- (sec.outstandingt2+round(depofeeamt)) - sec.navaccountt2 *100/af.mrirate) end),0),greatest(round(ovamt) - balance - nvl(avladvance,0) - nvl(lostass,0),0))  - nvl(od.sellamount,0),0) rtnremainamt2, -- So tien con phai xu ly ve Rantoan va tra het no qua han

            af.mrirate, af.mrmrate, af.mrlrate, ci.balance + nvl(avladvance,0) totalvnd, nvl(t0.advanceline,0) advanceline, nvl(sec.semaxtotalcallass,0) setotalcallass,nvl(sec.semaxcallass,0) semaxcallass, af.mrcrlimit,
            af.mrcrlimitmax, ci.dfodamt,af.mrcrlimitmax - ci.dfodamt mrcrlimitremain, af.status, nvl(ln.marginovdamt,0) ovdamount,round(nvl(ln.t0amt,0)) t0ovdamount,
            round(ci.odamt) + round(nvl(trfbuyamt_over,0)) totalodamt, round(ci.trfbuyamt) trfbuyamt, round(nvl(od.sellamount,0),0) RMAMT,
           nvl(sec.outstanding,0) outstanding, nvl(sec.outstandingt2,0) outstandingt2,

            round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrmrate =0 then - sec.outstandingt2 else
                                 greatest( 0,- sec.outstandingt2 - sec.navaccountt2 *100/af.mrmrate) end),0),0),0) RTNAMOUNTREF,
            round(greatest(ovamt+depofeeamt - balance - nvl(avladvance,0),0),0) OVDAMOUNTREF,
            round(nvl(lostass,0),0) SELLLOSTASSREF,
            round(nvl(od.sellamount,0),0) SELLAMOUNTREF,
            round(nvl(realsellamt,0),0) realsellamt,
            round(nvl(realsellamt,0),0) - round(nvl(lostass,0),0) asssellamt,
            nvl(ln.mrt0prinamt,0) mrt0prinamt, nvl(ln.mrt0intamt,0) mrt0intamt, PRIN_DRAWNDOWN,
            prin_move, INT_MOVE + PRFEE_MOVE INT_MOVE

            from cfmast cf, afmast af, cimast ci, aftype aft, v_getsecmarginratio_all sec,
                (select acctno, 'Y' ismarginacc from afmast af
                      where exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y'
                                      union all
                                      select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y')
                      group by acctno) ismr,
                (select aftype, 'Y' co_financing from afidtype where objname = 'LN.LNTYPE' group by aftype) cof,
                (

                    SELECT A.*, NVL(B.PRIN_DRAWNDOWN,0) PRIN_DRAWNDOWN, NVL(B.prin_move,0) prin_move,
                        NVL(B.INT_MOVE,0) INT_MOVE, NVL(B.PRFEE_MOVE,0) PRFEE_MOVE   FROM (
                    select LN.trfacctno, trunc(sum(round(prinnml)+round(prinovd)+round(intnmlacr)+round(intdue)+round(intovdacr)+round(intnmlovd)+round(feeintnmlacr)+round(feeintdue)+round(feeintovdacr)+round(feeintnmlovd)),0) marginamt,
                            trunc(sum(round(prinnml)+round(prinovd) + round(oprinnml)+round(oprinovd)),0)  mrt0prinamt,
                            trunc(sum(round(intnmlacr)+round(intdue)+round(intovdacr)+round(intnmlovd)+round(feeintnmlacr)+round(feeintdue)+round(feeintovdacr)+round(feeintnmlovd) + round(ointnmlacr)+round(ointdue)+round(ointovdacr)+round(ointnmlovd)),0) mrt0intamt,
                            trunc(sum(round(oprinnml)+round(oprinovd)+round(ointnmlacr)+round(ointdue)+round(ointovdacr)+round(ointnmlovd)),0) t0amt,
                            trunc(sum(round(prinovd)+round(intovdacr)+round(intnmlovd)+round(feeintovdacr)+round(feeintnmlovd)),0) marginovdamt,
                            trunc(sum(round(oprinovd)+round(ointovdacr)+round(ointnmlovd)),0) t0ovdamt
                    from lnmast ln
                    where ftype = 'AF'
                    group by ln.trfacctno ) A LEFT JOIN

                    (
                    SELECT TRFACCTNO, ABS(trunc(sum(nvl(PRIN_DRAWNDOWN,0)),0)) PRIN_DRAWNDOWN,
                        ABS(trunc(sum(nvl(prin_move,0)),0)) prin_move,
                        ABS(trunc(sum(nvl(INT_MOVE,0)),0)) INT_MOVE,
                        ABS(trunc(sum(nvl(PRFEE_MOVE,0)),0)) PRFEE_MOVE FROM LNMAST LN,
                       (SELECT acctno, autoid FROM LNSCHD UNION SELECT acctno, autoid FROM LNSCHDHIST) ls,
                         (    SELECT AUTOID,SUM(CASE WHEN NML < 0 THEN 0 ELSE NML END ) PRIN_DRAWNDOWN,
                             SUM(case when reftype in ('P','GP') then (CASE WHEN NML > 0 THEN 0 ELSE NML END  +OVD) else 0 end) PRIN_MOVE,
                             --SUM(PAID)  PRIN_MOVE,
                            --SUM((CASE WHEN NML > 0 THEN 0 ELSE NML END )  +OVD) PRIN_MOVE,
                             --SUM(INTNMLACR +INTDUE+INTOVD+INTOVDPRIN) INT_MOVE,
                             SUM(INTPAID) INT_MOVE,
                             --SUM(FEEINTNMLACR+ FEEINTDUE+FEEINTOVD+FEEINTOVDPRIN) PRFEE_MOVE
                             SUM(FEEPAID) PRFEE_MOVE
                             FROM ( select a.*, b.reftype from vw_lnschdlog_all a, vw_lnschd_all b
                                          where a.autoid = b.autoid (+)
                                    ) LNSLOG
                             WHERE NVL(DELTD,'N') <>'Y' and TXDATE = getcurrdate
                             GROUP BY AUTOID
                         ) LNTR
                           where ftype = 'AF'
                               and ln.acctno = ls.acctno
                               AND LS.AUTOID = LNTR.AUTOID(+)
                       GROUP BY TRFACCTNO
                    ) B ON A.TRFACCTNO = B.TRFACCTNO






                ) ln,
            (select acctno, sum(acclimit) advanceline from useraflimit where typereceive = 'T0' group by acctno) t0,
            (select od.afacctno,
                 round(sum(od.remainqtty*od.quoteprice*(1-odt.deffeerate/100-to_number(sy.varvalue)/100)*(1-nvl(rsk.advrate,adt.advrate/100)*3/360)),0) realsellamt, --- so tien ban tru phi, thue, UTTB
                round(sum(od.remainqtty*od.quoteprice),0) asssellamt, --- so tien ban chua tru phi, thue, UTTB
                round(greatest(sum(od.remainqtty*od.quoteprice*(1-odt.deffeerate/100-to_number(sy.varvalue)/100)*(1-nvl(rsk.advrate,adt.advrate/100)*3/360) - od.remainqtty*least(nvl(rsk.mrpriceloan,0),marginprice)*nvl(rsk.mrratiorate,0)/(case when nvl(rsk.mrmrate,100) = 0 then 100 else nvl(rsk.mrmrate,100) end) ),0)) sellamount,
                round(greatest(sum(od.remainqtty*least(nvl(rsk.mrpricerate,0),margincallprice)*nvl(rsk.mrratiorate,0)/(case when nvl(rsk.mrirate,100) = 0 then 100 else nvl(rsk.mrirate,100) end) ),0)) lostass
                from odmast od, odtype odt,afmast af, aftype aft, adtype adt,
                    (select af.acctno, af.mrmrate,af.mrirate, nvl(adt.advrate,0)/100 advrate, rsk.*
                        from afmast af, afserisk rsk, aftype aft, adtype adt
                        where af.actype = rsk.actype(+)
                        and af.actype = aft.actype and aft.adtype = adt.actype
                        ) rsk,
                    securities_info sec,
                    sysvar sy
                where od.exectype in ('NS','MS') and isdisposal = 'Y'
                and od.afacctno = af.acctno and af.actype = aft.actype and aft.adtype = adt.actype
                and od.afacctno = rsk.acctno(+) and od.codeid = rsk.codeid(+)
                and od.codeid = sec.codeid
                and od.actype = odt.actype
                and sy.varname = 'ADVSELLDUTY'
                and od.remainqtty > 0
                group by afacctno) od
            where cf.custid = af.custid
            and cf.custatcom = 'Y'
            and af.actype = aft.actype
            and af.acctno = ci.acctno
            and af.acctno = sec.afacctno
            and af.acctno = ln.trfacctno(+)
            and af.acctno = ismr.acctno(+)
            and af.actype = cof.aftype(+)
            and af.acctno = t0.acctno(+)
            and af.acctno = od.afacctno(+)
        )
   -- where  mrt0prinamt + mrt0intamt >0
   ;
*/

   insert into MR5005_LOG ( txdate, log_action, custodycd, actype, afacctno,rrtype, custbank ,
       marginrate, rtnremainamt, amt2irate, amt2mrate, t0ovdamount, ovdamount, cidepofeeacr, totalvnd, addvnd,
       realsellamt, asssellamt, mrirate, mrmrate, mrlrate,
       rtnamountref, ovdamountref, selllostassref,
       sellamountref, novdamt, trfbuyext, addvndt2,
       setotalcallass, mrprinamt, t0prinamt, mrintamt,
       t0intamt, prin_move_margin, prin_move_t0,
       int_move_margin, int_move_t0, prin_drawndown_margin,
       prin_drawndown_t0, marginrate_mr)

  select to_date(v_curdate,'DD/MM/RRRR'),pv_Action,custodycd,actype,acctno,
     rrtype, custbank ,
    marginrate, GREATEST(rtnamt2 - asssellamt, T0OVDAMOUNT + OVDAMOUNT + CIDEPOFEEACR - TOTALVND - realsellamt) rtnremainamt, rtnamt2 AMT2IRATE, rtnamt AMT2MRATE,
   T0OVDAMOUNT, OVDAMOUNT,CIDEPOFEEACR,TOTALVND, GREATEST(T0OVDAMOUNT + OVDAMOUNT + CIDEPOFEEACR - TOTALVND,rtnamt2) addvnd,
   realsellamt, asssellamt, mrirate, MRMRATE, MRLRATE ,RTNAMOUNTREF , OVDAMOUNTREF,
   SELLLOSTASSREF, SELLAMOUNTREF,novdamt,trfbuyext,ADDVNDT2,setotalcallass,
   --mrt0prinamt, mrt0intamt,prin_move, INT_MOVE, PRIN_DRAWNDOWN
   mrprinamt, t0prinamt, mrintamt, t0intamt,
   prin_move_MARGIN,prin_move_T0, INT_MOVE_MARGIN,INT_MOVE_T0, PRIN_DRAWNDOWN_MARGIN,PRIN_DRAWNDOWN_T0,
   marginrate_mr

   FROM
   (

       select af.groupleader, af.actype, DECODE(ismarginacc,'Y','YES','NO') ismarginacc,
       custodycd,af.acctno, af.trfbuyext,
       nvl(sec.rlsmarginrate,0) rlsmarginrate, nvl(sec.marginrate,0) marginrate,ci.CIDEPOFEEACR,
       round(greatest(round((case when nvl(sec.marginrate,0) * af.mrmrate =0 then - sec.outstanding else
                            greatest( 0,- sec.outstanding - sec.navaccount *100/af.mrmrate) end),0),0),0) rtnamt,
       round(greatest(round((case when nvl(sec.marginrate,0) * af.mrirate =0 then - sec.outstanding else
                            greatest( 0,- sec.outstanding - sec.navaccount *100/af.mrirate) end),0),0),0) rtnamt2, --- So tien nop them de ve R an toan
       round(greatest(round((case when nvl(sec.marginrate,0) * af.mrmrate =0 then - sec.outstanding else
                            greatest( 0,- (sec.outstanding +depofeeamt) - sec.navaccount *100/af.mrmrate) end),0),greatest(ovamt - balance - nvl(avladvance,0),0)),0) addvnd,
       round(greatest(round((case when nvl(sec.marginrate,0) * af.mrirate =0 then - sec.outstanding else
                            greatest( 0,- (sec.outstanding +depofeeamt) - sec.navaccount *100/af.mrirate) end),0),greatest(ovamt - balance - nvl(avladvance,0),0)),0) addvnd2, -- So tien nop them ve Ran toan va tra het no qua han
       greatest(ovamt+depofeeamt - balance - nvl(avladvance,0),0) novdamt, -- So tien can nop them de tra het no qua han
       round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrmrate =0 then - outstandingt2 else
                            greatest( 0,- outstandingt2 - sec.navaccountt2*100/af.mrmrate) end),0),0),0) rtnamtt2,
       round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrmrate =0 then - outstandingt2 else
                            greatest( 0,- (outstandingt2+round(depofeeamt)) - sec.navaccountt2*100/af.mrmrate) end),0),greatest(ovamt - balance - round(nvl(avladvance,0)),0)),0) addvndt2,
       round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrmrate =0 then - sec.outstandingt2 else
                            greatest( 0,- (sec.outstandingt2+round(depofeeamt)) - sec.navaccountt2 *100/af.mrmrate) end),0),greatest(round(ovamt) - balance - nvl(avladvance,0) - nvl(lostass,0),0))  - nvl(od.sellamount,0),0) rtnremainamt,
       round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrirate =0 then - sec.outstandingt2 else
                            greatest( 0,- (sec.outstandingt2+round(depofeeamt)) - sec.navaccountt2 *100/af.mrirate) end),0),greatest(round(ovamt) - balance - nvl(avladvance,0) - nvl(lostass,0),0))  - nvl(od.sellamount,0),0) rtnremainamt2, -- So tien con phai xu ly ve Rantoan va tra het no qua han

       af.mrirate, af.mrmrate, af.mrlrate, ci.balance + nvl(avladvance,0) totalvnd, nvl(t0.advanceline,0) advanceline, nvl(sec.semaxtotalcallass,0) setotalcallass,nvl(sec.semaxcallass,0) semaxcallass, af.mrcrlimit,
       af.mrcrlimitmax, ci.dfodamt,af.mrcrlimitmax - ci.dfodamt mrcrlimitremain, af.status, nvl(ln.marginovdamt,0) ovdamount,round(nvl(ln.t0amt,0)) t0ovdamount,
       round(ci.odamt) + round(nvl(trfbuyamt_over,0)) totalodamt, round(ci.trfbuyamt) trfbuyamt, round(nvl(od.sellamount,0),0) RMAMT,
      nvl(sec.outstanding,0) outstanding, nvl(sec.outstandingt2,0) outstandingt2,

       round(greatest(round((case when nvl(sec.rlsmarginrate,0) * af.mrmrate =0 then - sec.outstandingt2 else
                            greatest( 0,- sec.outstandingt2 - sec.navaccountt2 *100/af.mrmrate) end),0),0),0) RTNAMOUNTREF,
       round(greatest(ovamt+depofeeamt - balance - nvl(avladvance,0),0),0) OVDAMOUNTREF,
       round(nvl(lostass,0),0) SELLLOSTASSREF,
       round(nvl(od.sellamount,0),0) SELLAMOUNTREF,
       round(nvl(realsellamt,0),0) realsellamt,
       round(nvl(realsellamt,0),0) - round(nvl(lostass,0),0) asssellamt,
       nvl(ln.mrprinamt,0) mrprinamt,  nvl(ln.t0prinamt,0) t0prinamt, nvl(ln.mrintamt,0) mrintamt, nvl(ln.t0intamt,0) t0intamt,
       nvl(PRIN_DRAWNDOWN_MARGIN,0) PRIN_DRAWNDOWN_MARGIN, nvl(PRIN_DRAWNDOWN_T0,0) PRIN_DRAWNDOWN_T0,
       nvl(PRIN_MOVE_MARGIN,0) PRIN_MOVE_MARGIN, nvl(PRIN_MOVE_T0,0) PRIN_MOVE_T0,
       nvl(INT_MOVE_MARGIN + PRFEE_MOVE_MARGIN,0) INT_MOVE_MARGIN,
       nvl(INT_MOVE_T0 + PRFEE_MOVE_T0,0) INT_MOVE_T0, ln.rrtype, ln.custbank,
       nvl(sec.marginrate_mr,0) marginrate_mr

       from cfmast cf, afmast af, cimast ci, aftype aft, v_getsecmarginratio_all sec,
           (select acctno, 'Y' ismarginacc from afmast af
                 where exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y'
                                 union all
                                 select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y')
                 group by acctno) ismr,
           (select aftype, 'Y' co_financing from afidtype where objname = 'LN.LNTYPE' group by aftype) cof,
           (

              select TRFACCTNO, rrtype, nvl(custbank,'') custbank,
                    SUM (mrprinamt) mrprinamt, SUM (t0prinamt) t0prinamt, SUM (mrintamt) mrintamt, SUM (t0intamt) t0intamt, SUM (marginamt) marginamt,
                    SUM (marginovdamt) marginovdamt, SUM (t0amt) t0amt, SUM (t0ovdamt) t0ovdamt,
                    SUM (prin_drawndown_margin) prin_drawndown_margin, SUM (prin_drawndown_t0) prin_drawndown_t0, SUM (prin_move_margin) prin_move_margin,
                    SUM (prin_move_t0) prin_move_t0, SUM (int_move_margin) int_move_margin,
                    SUM (int_move_t0) int_move_t0, SUM (prfee_move_t0) prfee_move_t0, SUM (prfee_move_margin) prfee_move_margin

                FROM (
                         SELECT TRFACCTNO, lnt.rrtype, nvl(lnt.custbank,'') custbank,
                                 trunc((round(prinnml)+round(prinovd)),0)  mrprinamt,
                                 trunc((round(oprinnml)+round(oprinovd)),0)  t0prinamt,

                                 trunc((round(intnmlacr)+round(intdue)+round(intovdacr)+round(intnmlovd)+round(feeintnmlacr)+round(feeintdue)+round(feeintovdacr)+round(feeintnmlovd)),0) mrintamt,
                                 trunc((round(ointnmlacr)+round(ointdue)+round(ointovdacr)+round(ointnmlovd)),0) t0intamt,

                                 trunc((round(prinnml)+round(prinovd)+round(intnmlacr)+round(intdue)+round(intovdacr)+round(intnmlovd)+round(feeintnmlacr)+round(feeintdue)+round(feeintovdacr)+round(feeintnmlovd)),0) marginamt,
                                 trunc((round(prinovd)+round(intovdacr)+round(intnmlovd)+round(feeintovdacr)+round(feeintnmlovd)),0) marginovdamt,

                                 trunc((round(oprinnml)+round(oprinovd)+round(ointnmlacr)+round(ointdue)+round(ointovdacr)+round(ointnmlovd)),0) t0amt,
                                 trunc((round(oprinovd)+round(ointovdacr)+round(ointnmlovd)),0) t0ovdamt,

                                 ABS(trunc(sum(nvl(PRIN_DRAWNDOWN_MARGIN,0)),0)) PRIN_DRAWNDOWN_MARGIN,
                                 ABS(trunc(sum(nvl(PRIN_DRAWNDOWN_T0,0)),0)) PRIN_DRAWNDOWN_T0,
                                 ABS(trunc(sum(nvl(prin_move_margin,0)),0)) PRIN_MOVE_MARGIN,
                                 ABS(trunc(sum(nvl(prin_move_t0,0)),0)) prin_move_t0,
                                 ABS(trunc(sum(nvl(INT_MOVE_MARGIN,0)),0)) INT_MOVE_MARGIN,
                                 ABS(trunc(sum(nvl(INT_MOVE_t0,0)),0)) INT_MOVE_T0,
                                 ABS(trunc(sum(nvl(PRFEE_MOVE_T0,0)),0)) PRFEE_MOVE_T0,
                                 ABS(trunc(sum(nvl(PRFEE_MOVE_MARGIN,0)),0)) PRFEE_MOVE_MARGIN

                          FROM vw_lnmast_all LN,
                          (SELECT acctno, autoid, REFTYPE FROM vw_lnschd_all) ls,
                          (
                               SELECT AUTOID,SUM(CASE WHEN NML < 0 THEN 0 ELSE
                                       case when reftype in ('P') then NML else 0 end
                                       END ) PRIN_DRAWNDOWN_MARGIN,
                                   SUM(CASE WHEN NML < 0 THEN 0 ELSE
                                       case when reftype in ('GP') then NML else 0 end
                                       END ) PRIN_DRAWNDOWN_T0,
                                   SUM(case when reftype in ('P') then (CASE WHEN NML > 0 THEN 0 ELSE NML END  +OVD) else 0 end) PRIN_MOVE_MARGIN,
                                   SUM(case when reftype in ('GP') then (CASE WHEN NML > 0 THEN 0 ELSE NML END  +OVD) else 0 end) PRIN_MOVE_T0,
                                   SUM(case when reftype in ('P') then INTPAID else 0 end) INT_MOVE_MARGIN,
                                   SUM(case when reftype in ('GP') then INTPAID else 0 end) INT_MOVE_T0,
                                   SUM(case when reftype in ('P') then FEEPAID else 0 end) PRFEE_MOVE_MARGIN,
                                   SUM(case when reftype in ('GP') then FEEPAID else 0 end) PRFEE_MOVE_T0
                                   FROM ( select a.*, b.reftype from vw_lnschdlog_all a, vw_lnschd_all b
                                                where a.autoid = b.autoid (+)
                                          ) LNSLOG
                                   WHERE NVL(DELTD,'N') <>'Y' and TXDATE =  to_date(v_curdate,'DD/MM/RRRR')
                                   GROUP BY AUTOID
                              ) LNTR, lntype lnt
                                 where ftype = 'AF'
                                     and ln.actype = lnt.actype
                                     and ls.acctno = ln.acctno (+)
                                     AND LS.AUTOID = LNTR.AUTOID(+)
                             GROUP BY TRFACCTNO, lnt.rrtype, lnt.custbank,trunc((round(prinnml)+round(prinovd)),0)  ,
                             trunc((round(oprinnml)+round(oprinovd)),0)  ,

                             trunc((round(intnmlacr)+round(intdue)+round(intovdacr)+round(intnmlovd)+round(feeintnmlacr)+round(feeintdue)+round(feeintovdacr)+round(feeintnmlovd)),0) ,
                             trunc((round(ointnmlacr)+round(ointdue)+round(ointovdacr)+round(ointnmlovd)),0) ,

                             trunc((round(prinnml)+round(prinovd)+round(intnmlacr)+round(intdue)+round(intovdacr)+round(intnmlovd)+round(feeintnmlacr)+round(feeintdue)+round(feeintovdacr)+round(feeintnmlovd)),0) ,
                             trunc((round(prinovd)+round(intovdacr)+round(intnmlovd)+round(feeintovdacr)+round(feeintnmlovd)),0) ,

                             trunc((round(oprinnml)+round(oprinovd)+round(ointnmlacr)+round(ointdue)+round(ointovdacr)+round(ointnmlovd)),0) ,
                             trunc((round(oprinovd)+round(ointovdacr)+round(ointnmlovd)),0)

                ) A GROUP BY TRFACCTNO, rrtype, custbank

           ) ln,
       (select acctno, sum(acclimit) advanceline from useraflimit where typereceive = 'T0' group by acctno) t0,
       (select od.afacctno,
            round(sum(od.remainqtty*od.quoteprice*(1-odt.deffeerate/100-to_number(sy.varvalue)/100)*(1-nvl(rsk.advrate,adt.advrate/100)*3/360)),0) realsellamt, --- so tien ban tru phi, thue, UTTB
           round(sum(od.remainqtty*od.quoteprice),0) asssellamt, --- so tien ban chua tru phi, thue, UTTB
           round(greatest(sum(od.remainqtty*od.quoteprice*(1-odt.deffeerate/100-to_number(sy.varvalue)/100)*(1-nvl(rsk.advrate,adt.advrate/100)*3/360) - od.remainqtty*least(nvl(rsk.mrpriceloan,0),marginprice)*nvl(rsk.mrratiorate,0)/(case when nvl(rsk.mrmrate,100) = 0 then 100 else nvl(rsk.mrmrate,100) end) ),0)) sellamount,
           round(greatest(sum(od.remainqtty*least(nvl(rsk.mrpricerate,0),margincallprice)*nvl(rsk.mrratiorate,0)/(case when nvl(rsk.mrirate,100) = 0 then 100 else nvl(rsk.mrirate,100) end) ),0)) lostass
           from odmast od, odtype odt,afmast af, aftype aft, adtype adt,
               (select af.acctno, af.mrmrate,af.mrirate, nvl(adt.advrate,0)/100 advrate, rsk.*
                   from afmast af, afserisk rsk, aftype aft, adtype adt
                   where af.actype = rsk.actype(+)
                   and af.actype = aft.actype and aft.adtype = adt.actype
                   ) rsk,
               securities_info sec,
               sysvar sy
           where od.exectype in ('NS','MS') and isdisposal = 'Y'
           and od.afacctno = af.acctno and af.actype = aft.actype and aft.adtype = adt.actype
           and od.afacctno = rsk.acctno(+) and od.codeid = rsk.codeid(+)
           and od.codeid = sec.codeid
           and od.actype = odt.actype
           and sy.varname = 'ADVSELLDUTY'
           and od.remainqtty > 0
           group by afacctno) od
       where cf.custid = af.custid
       and cf.custatcom = 'Y'
       and af.actype = aft.actype
       and af.acctno = ci.acctno
       and af.acctno = sec.afacctno
       and af.acctno = ln.trfacctno
       and af.acctno = ismr.acctno(+)
       and af.actype = cof.aftype(+)
       and af.acctno = t0.acctno(+)
       and af.acctno = od.afacctno(+)
       ORDER BY CF.CUSTODYCD, AF.ACCTNO,  ln.rrtype, ln.custbank
   )
   ;





    plog.setendsection(pkgctx, 'pr_log_mr0002');
    EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_log_mr0002');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_log_mr0002');
      RAISE errnums.E_SYSTEM_ERROR;
end;

PROCEDURE pr_Drawndown_Margin (pv_Action varchar2)
  IS
      v_CURRDATE date;
      l_LOGDATE varchar2(10);
      v_strDesc varchar2(1000);
      v_strEN_Desc varchar2(1000);
      v_dblMRODAMT  number(20,0);
      l_err_param varchar2(300);
      l_CUSTODYCD_PREFIX varchar2(3);
      l_LNACCTNO varchar2(30);
      l_remain_MRamount number(20,4);
      l_exec_MRamount number(20,4);
      l_rrtype varchar2(1);
      l_custbank varchar2(30);
      l_ciacctno varchar2(30);
      l_avlamt number(24,4);
      l_mrcrlimitmax number(24,4);
      l_afavlamt number(24,4);
      l_afusedamt number(24,4);
      l_chksysctrl varchar2(1);
      l_mriratio number(10,4);
      l_maxdebt number(20,0);
      l_count number;
      l_T0ODAMT number(20,0);
      l_MarginType varchar2(1);
      l_MR_Master_Amount number(20,4);
      l_sub_MRamount number(20,4);
      l_main_MRamount number(20,4);
      l_checkbanklimit number(20,4);
  BEGIN
     SELECT TO_DATE (varvalue, systemnums.c_date_format), varvalue
               INTO v_CURRDATE, l_LOGDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    for rec in
    (   --- xet tren tat ca tai khoan
        SELECT A.*,  nvl(LN.chksysctrl,'N')  chksysctrl FROM (
            SELECT CI.ACCTNO CIACCTNO, CI.BALANCE, CI.T0ODAMT, aft.lntype, aft.t0lntype, 1 FINANCETYPE, CF.MARGINALLOW
            FROM CIMAST CI, CFMAST CF, AFMAST AF, AFTYPE AFT, mrtype mrt
            WHERE cf.custid = af.custid and af.actype = aft.actype and af.acctno = ci.afacctno and CI.STATUS='A' and aft.mrtype = mrt.actype
            and cf.custatcom='Y'  and mrt.mrtype in ('S','T') --and ci.acctno = '0001002063'
            ORDER BY case when af.trfbuyrate * af.trfbuyext = 0 then 0 else 1 end, ci.acctno
        )A left join LNTYPE LN on NVL(A.lntype,0) = LN.ACTYPE and ln.lnpurpose <> 'R'
        ORDER BY nvl(LN.chksysctrl,'N') DESC
    )
    loop -- rec
        v_dblMRODAMT:= 999999999999;--greatest(-rec.BALANCE,0);
        -- Margin Drawndown
        l_LNACCTNO:='';
        l_exec_MRamount:= 0;

        If round(v_dblMRODAMT,0) >= 0 Then
            l_remain_MRamount:= round(v_dblMRODAMT,0);
            -- Tong gia tri giai ngan theo nguon chinh. >> xac dinh so tien giai ngan toi da theo nguon chinh.
            for rec_mast in
            (
                    select lnt.*, AFT.ACTYPE AFTYPE
                        from afmast af, aftype aft, lntype lnt
                        where af.actype = aft.actype
                            and af.acctno = rec.ciacctno
                            and aft.lntype = lnt.actype and lnt.status <> 'N'
            )
            loop
                select 100 - mriratio into l_mriratio from afmast where acctno = rec.ciacctno;

                begin
                    select greatest(least(af.mrcrlimitmax - mst.dfodamt,nvl(afavlamt,0)) - greatest(decode(rec_mast.chksysctrl,'Y',nvl(ln.margin74amt,0),nvl(ln.marginamt,0)),0)
                                - nvl(sts.trfsecuredamt,0),0)
                        into l_MR_Master_Amount
                    from cimast mst, afmast af,
                        (select  se.afacctno, nvl(sum(case when rec_mast.chksysctrl = 'Y' then
                                        (least(se.trade + nvl(sts.receiving,0) - nvl(used.prinused_af,0),
                                                    greatest(nvl(room.roomlimit,0) - nvl(prinused,0),0))
                                            + nvl(used.prinused_af,0))
                                             * nvl(rsk.MRRATE,0)/100 * nvl(rsk.MRPRICE,0)
                                        else
                                        (least(se.trade + nvl(sts.receiving,0) - nvl(used.sys_prinused_af,0),
                                                    greatest(nvl(room.syroomlimit,0) - nvl(room.syroomused,0) - nvl(used.sys_prinused,0),0))
                                            + nvl(used.sys_prinused_af,0))
                                             * nvl(rsk.MRRATE,0)/100 * nvl(rsk.MRPRICE,0)
                                        end)
                                ,0) afavlamt
                        from semast se,
                            (select s1.acctno, sum(s1.qtty-s1.aqtty) receiving
                                from
                                    (select * from stschd where duetype = 'RS' and deltd <> 'Y') s1,
                                    (select * from stschd where duetype = 'SM' and deltd <> 'Y') s2
                                where s1.orgorderid = s2.orgorderid
                                    and s2.trfbuyrate * s2.trfbuyext * (s2.amt-s2.trfexeamt) = 0
                                    and s1.status <> 'C'
                                group by s1.acctno) sts,
                               (SELECT SB.CODEID,rec_mast.actype ACTYPE,
                                  LEAST(SEC.MRRATIOLOAN, decode(rec_mast.chksysctrl,'Y',l_mriratio,100))*(case when RSK.ismarginallow = 'N' and rec_mast.chksysctrl = 'Y' then 0 else 1 end) MRRATE,
                                  LEAST(SEC.MRPRICELOAN,RSK.MRPRICELOAN, decode(rec_mast.chksysctrl,'Y',SB.MARGINREFPRICE,SB.MARGINPRICE)) MRPRICE
                                FROM AFSERISK SEC, SECURITIES_INFO SB,
                                    SECURITIES_RISK RSK
                                WHERE SB.CODEID=SEC.CODEID AND SEC.CODEID = RSK.CODEID
                                    AND SEC.ACTYPE =  rec_mast.AFTYPE ) rsk, --ACTYPE CUA AFTYPE

                            vw_marginroomsystem room,
                            (select codeid, sum(case when restype = 'M' then prinused else 0 end) prinused,
                                sum(case when restype = 'S' then prinused else 0 end) sys_prinused,
                                sum(case when restype = 'M' and afacctno = rec.ciacctno then prinused else 0 end) prinused_af,
                                sum(case when restype = 'S' and afacctno = rec.ciacctno then prinused else 0 end) sys_prinused_af
                            from vw_afpralloc_all group by codeid) used
                        where se.acctno = sts.acctno(+)
                        and se.codeid = rsk.codeid(+)
                        and se.codeid = room.codeid(+)
                        and se.codeid = used.codeid(+)
                        and se.afacctno = rec.ciacctno
                        group by se.afacctno
                    ) se,
                    (select sts.afacctno, sum(amt+feeacr-feeamt-trft0amt) trfsecuredamt
                         from odmast od, stschd sts
                         where od.orderid = sts.orgorderid and sts.duetype = 'SM' and sts.deltd <> 'Y'
                         and trfbuyrate * trfbuyext * (amt-trfexeamt) > 0
                         and od.afacctno = rec.ciacctno
                         and trfbuydt > v_CURRDATE
                         group by sts.afacctno) sts,
                    (select trfacctno,
                                sum(decode(lnt.chksysctrl,'Y',1,0)*(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) margin74amt,
                                sum((prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) marginamt
                        from lnmast ln, lntype lnt
                        where trfacctno = rec.ciacctno
                        and ln.ftype = 'AF' --and ln.actype = rec_mast.actype
                        and ln.actype = lnt.actype
                        group by trfacctno) ln
                    where mst.acctno = se.afacctno(+)
                    and mst.acctno = sts.afacctno(+)
                    and mst.acctno = ln.trfacctno(+)
                    and mst.acctno = af.acctno
                    and mst.acctno = rec.ciacctno;
                exception when others then
                    l_MR_Master_Amount:=0;
                end;
            end loop;

            l_remain_MRamount:=greatest(least(to_number(l_MR_Master_Amount),l_remain_MRamount),0);

            for rec_ln in
            (
                select * from (
                    select lnt.*, nvl(cf.mnemonic,cf.shortname) cfmnemonic,af.custid cfcustid, odrnum, 'Y' IsSubResource
                        from afmast af, aftype aft, afidtype afid, lntype lnt, cfmast cf
                        where aft.actype = afid.aftype
                            and afid.actype = lnt.actype
                            and af.actype = aft.actype
                            and lnt.custbank = cf.custid(+)
                            and af.acctno = rec.ciacctno
                            and objname = 'LN.LNTYPE' and lnt.status <> 'N'  AND lnt.lnpurpose = 'D'
                    union all
                    select lnt.*, nvl(cf.mnemonic,cf.shortname) cfmnemonic,af.custid cfcustid, 999 odrnum, 'N' IsSubResource
                        from afmast af, aftype aft, lntype lnt, cfmast cf
                        where af.actype = aft.actype
                            and lnt.custbank = cf.custid(+)
                            and af.acctno = rec.ciacctno
                            and aft.lntype = lnt.actype and lnt.status <> 'N' AND lnt.lnpurpose = 'D'
                            )
                order by case when IsSubResource = 'Y' then 0 else 1 end, odrnum
            )
            loop -- rec_ln

                --select ln.acctno, ln.rrtype, ln.custbank, ln.ciacctno into l_LNACCTNO, l_rrtype, l_custbank,  l_ciacctno
                --from lnmast ln where ln.actype = rec_ln.actype and ln.trfacctno = rec.ciacctno and ln.STATUS NOT IN ('P','R','C') AND ln.FTYPE='AF';
                select  rec_ln.rrtype, rec_ln.custbank, rec.ciacctno into l_rrtype, l_custbank,  l_ciacctno from dual;
                if rec_ln.IsSubResource = 'Y' then
                    -- Neu la nguon PHU, xet nguon cho vay tuong ung.
                    -- Dat gia tri nguon phu = max
                    l_sub_MRamount:= 999999999999;


                    if l_rrtype = 'B' then -- Neu nguon cho vay la nguon Ngan Hang: Xet min gioi han cua Toan He Thong va cua tung Khach Hang
                        begin
                            l_avlamt:= cspks_cfproc.fn_getavlcflimit(l_custbank, rec_ln.cfcustid, 'DFMR');
                        exception when others then
                            l_avlamt:= 0;
                        end;

                        select nvl(greatest(af.mrcrlimitmax - ci.dfodamt - greatest(nvl(usedprin,0),0),0),0)
                            into l_mrcrlimitmax
                        from afmast af, cimast ci,
                        (select trfacctno, sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd) usedprin
                                from lnmast ln
                                where ftype = 'AF' and trfacctno = rec.ciacctno
                                group by ln.trfacctno) lcf
                        where af.acctno = rec.ciacctno and af.acctno = ci.acctno
                            and af.acctno = lcf.trfacctno(+);

                        l_sub_MRamount:= least(l_avlamt, l_sub_MRamount, l_mrcrlimitmax);

                        /*insert into temp_log_chaunh
                        values('Giai ngan nguon phu, nguon BANK  ','l_sub_MRamount',l_sub_MRamount);*/

                    elsif l_rrtype = 'O' then -- Neu nguon cho vay la nguon CI: Tam thoi khong check han muc
                        select nvl(greatest( mrcrlimitmax - ci.dfodamt - greatest(nvl(usedprin,0),0),0),0)
                            into l_mrcrlimitmax
                        from afmast af, cimast ci,
                        (select trfacctno, sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd) usedprin
                                from lnmast ln
                                where ftype = 'AF'
                                group by ln.trfacctno) lcf
                        where af.acctno = rec.ciacctno and af.acctno = ci.acctno
                        and af.acctno = lcf.trfacctno(+);

                        l_sub_MRamount:= least(l_sub_MRamount, l_mrcrlimitmax);

                        /*insert into temp_log_chaunh
                        values('Giai ngan nguon phu, nguon O  ','l_sub_MRamount',l_sub_MRamount);*/

                    elsif l_rrtype = 'C' then -- Neu nguon cho vay la nguon Cong Ty: Kiem tra tren han muc vay cua khach hang MRCRLIMITMAX

                        select nvl(greatest(mrcrlimitmax - ci.dfodamt - greatest(nvl(usedprin,0),0),0),0)
                                into l_mrcrlimitmax
                            from afmast af, cimast ci,
                            (select trfacctno, sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd) usedprin
                                    from lnmast ln
                                    where ftype = 'AF'
                                    group by ln.trfacctno) lcf
                            where af.acctno = rec.ciacctno and af.acctno = ci.acctno
                            and af.acctno = lcf.trfacctno(+);

                        l_sub_MRamount:=least(l_mrcrlimitmax,l_sub_MRamount);
                        -- Neu tuan thu. lay min voi maxdebt
                        if rec_ln.chksysctrl = 'Y' then
                           select nvl(greatest(least(mrcrlimitmax,to_number(cspks_system.fn_get_sysvar('MARGIN','MAXDEBTCF'))) - ci.dfodamt - greatest(nvl(usedprin,0),0),0),0)
                                into l_mrcrlimitmax
                            from afmast af, cimast ci,
                            (select trfacctno, sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd) usedprin
                                    from lnmast ln, lntype lnt
                                    where ln.actype = lnt.actype and ln.rrtype = 'C' and lnt.chksysctrl = 'Y'
                                    group by ln.trfacctno) lcf
                            where af.acctno = rec.ciacctno and af.acctno = ci.acctno
                            and af.acctno = lcf.trfacctno(+);
                            l_sub_MRamount:=least(l_mrcrlimitmax,l_sub_MRamount);

                            -- Neu khach hang ko duoc phep Margin. --> Han muc = 0.
                            if rec.MARGINALLOW <> 'Y' then
                                l_sub_MRamount:= 0;
                            end if;
                            select greatest(nvl(sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd),0),0) into l_maxdebt
                            from lnmast ln, lntype lnt where ln.actype = lnt.actype and ftype = 'AF' and lnt.rrtype = 'C' and chksysctrl = 'Y';

                            select greatest(to_number(varvalue) - l_maxdebt,0) into l_mrcrlimitmax from sysvar where varname = 'MAXDEBT';

                            select greatest(least(l_mrcrlimitmax, prlimit - prinused),0) into l_mrcrlimitmax from prmaster where prcode = '9999' and prtyp = 'P';

                            l_sub_MRamount:= least(l_mrcrlimitmax, l_sub_MRamount);
                        end if;

                        l_sub_MRamount:= least(l_mrcrlimitmax, l_sub_MRamount);

                        /*insert into temp_log_chaunh
                        values('Giai ngan nguon phu, nguon CTY  ','l_sub_MRamount',l_sub_MRamount);*/

                    end if;
                    select 100 - mriratio into l_mriratio from afmast where acctno = rec.ciacctno;
                    -- Lay min voi Room: Neu Tuan Thu --> check tren min (ROOM MARGIN, ROOM SYSTEM); Neu Khong Tuan Thu --> check tren ROOM SYSTEM.
                    -- Xet nguon tren ro vay toi da.
                    begin
                        select greatest(least(af.mrcrlimitmax - mst.dfodamt,nvl(afavlamt,0)) - greatest(decode(rec_ln.chksysctrl,'Y',nvl(ln.margin74amt,0),nvl(ln.marginamt,0)),0)
                                    - nvl(sts.trfsecuredamt,0),0)
                            into l_afavlamt
                        from cimast mst, afmast af,
                            (select  se.afacctno, nvl(sum(case when rec_ln.chksysctrl = 'Y' then
                                            (least(se.trade + nvl(sts.receiving,0) - nvl(used.prinused_af,0),
                                                        greatest(nvl(room.roomlimit,0) - nvl(prinused,0),0))
                                                + nvl(used.prinused_af,0))
                                                 * nvl(rsk.MRRATE,0)/100 * nvl(rsk.MRPRICE,0)
                                            else
                                            (least(se.trade + nvl(sts.receiving,0) - nvl(used.sys_prinused_af,0),
                                                        greatest(nvl(room.syroomlimit,0) - nvl(room.syroomused,0) - nvl(used.sys_prinused,0),0))
                                                + nvl(used.sys_prinused_af,0))
                                                 * nvl(rsk.MRRATE,0)/100 * nvl(rsk.MRPRICE,0)
                                            end)
                                    ,0) afavlamt
                            from semast se,
                                (select s1.acctno, sum(s1.qtty-s1.aqtty) receiving
                                    from
                                        (select * from stschd where duetype = 'RS' and deltd <> 'Y') s1,
                                        (select * from stschd where duetype = 'SM' and deltd <> 'Y') s2
                                    where s1.orgorderid = s2.orgorderid
                                        and s2.trfbuyrate * s2.trfbuyext * (s2.amt-s2.trfexeamt) = 0
                                        and s1.status <> 'C'
                                    group by s1.acctno) sts,
                                (SELECT SB.CODEID,LNB.ACTYPE,
                                      LEAST(SEC.MRRATIOLOAN,RATE.MRRATIOLOAN, decode(rec_ln.chksysctrl,'Y',l_mriratio,100))*(case when ismarginallow = 'N' and rec_ln.chksysctrl = 'Y' then 0 else 1 end) MRRATE,
                                      LEAST(SEC.MRPRICELOAN,RSK.MRPRICELOAN, decode(rec_ln.chksysctrl,'Y',SB.MARGINREFPRICE,SB.MARGINPRICE)) MRPRICE
                                    FROM (select * from lnsebasket
                                              where effdate = (select max(effdate)
                                                              from LNSEBASKET
                                                              where effdate <= (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE')
                                                                    and actype = rec_ln.actype
                                                              group by actype)
                                              and actype = rec_ln.actype) LNB,
                                        SECBASKET SEC, SECURITIES_INFO SB,
                                        SECURITIES_RISK RSK, SECURITIES_RATE RATE
                                    WHERE RSK.CODEID=RATE.CODEID AND RATE.FROMPRICE<=SB.FLOORPRICE AND RATE.TOPRICE>SB.FLOORPRICE
                                          AND LNB.BASKETID=SEC.BASKETID AND TRIM(SEC.SYMBOL)=TRIM(SB.SYMBOL)
                                          AND SB.CODEID=RSK.CODEID) rsk,
                                vw_marginroomsystem room,
                                (select codeid, sum(case when restype = 'M' then prinused else 0 end) prinused,
                                    sum(case when restype = 'S' then prinused else 0 end) sys_prinused,
                                    sum(case when restype = 'M' and afacctno = rec.ciacctno then prinused else 0 end) prinused_af,
                                    sum(case when restype = 'S' and afacctno = rec.ciacctno then prinused else 0 end) sys_prinused_af
                                from vw_afpralloc_all group by codeid) used
                            where se.acctno = sts.acctno(+)
                            and se.codeid = rsk.codeid(+)
                            and se.codeid = room.codeid(+)
                            and se.codeid = used.codeid(+)
                            and se.afacctno = rec.ciacctno
                            group by se.afacctno
                        ) se,
                        (select sts.afacctno, sum(amt+feeacr-feeamt-trft0amt) trfsecuredamt
                             from odmast od, stschd sts
                             where od.orderid = sts.orgorderid and sts.duetype = 'SM' and sts.deltd <> 'Y'
                             and trfbuyrate * trfbuyext * (amt-trfexeamt) > 0
                             and od.afacctno = rec.ciacctno
                             and trfbuydt > v_CURRDATE
                             group by sts.afacctno) sts,
                        (select trfacctno,
                                    sum(decode(lnt.chksysctrl,'Y',1,0)*(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) margin74amt,
                                    sum((prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) marginamt
                            from lnmast ln, lntype lnt
                            where trfacctno = rec.ciacctno
                            and ln.ftype = 'AF' and ln.actype = rec_ln.actype
                            and ln.actype = lnt.actype
                            group by trfacctno) ln
                        where mst.acctno = se.afacctno(+)
                        and mst.acctno = sts.afacctno(+)
                        and mst.acctno = ln.trfacctno(+)
                        and mst.acctno = af.acctno
                        and mst.acctno = rec.ciacctno;
                    exception when others then
                        l_afavlamt:=0;
                    end;
                    -- Lay min voi Room: Neu Tuan Thu --> check tren min (ROOM MARGIN, ROOM SYSTEM); Neu Khong Tuan Thu --> check tren ROOM SYSTEM.
                    l_sub_MRamount:= least(greatest(l_afavlamt,0), l_sub_MRamount);

                    /*insert into temp_log_chaunh
                        values('Giai ngan nguon phu, nguon kk  ','l_sub_MRamount',l_sub_MRamount);*/

                else
                    l_main_MRamount:= 999999999999;


                    if l_rrtype = 'B' then -- Neu nguon cho vay la nguon Ngan Hang: Xet min gioi han cua Toan He Thong va cua tung Khach Hang
                        begin
                            l_avlamt:= cspks_cfproc.fn_getavlcflimit(l_custbank, rec_ln.cfcustid, 'DFMR');
                            l_checkbanklimit:=cspks_cfproc.fn_getavlbanklimit(l_custbank,'DFMR');
                        exception when others then
                            l_avlamt:= 0;
                            l_checkbanklimit:= 0;
                        end;

                        select nvl(greatest(af.mrcrlimitmax - ci.dfodamt - greatest(nvl(usedprin,0),0),0),0)
                            into l_mrcrlimitmax
                        from afmast af, cimast ci,
                        (select trfacctno, sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd) usedprin
                                from lnmast ln
                                where ftype = 'AF' and trfacctno = rec.ciacctno
                                group by ln.trfacctno) lcf
                        where af.acctno = rec.ciacctno and af.acctno = ci.acctno
                            and af.acctno = lcf.trfacctno(+);

                        l_main_MRamount:= least(greatest(l_avlamt,0), l_main_MRamount, greatest(l_mrcrlimitmax,0));

                        /*insert into temp_log_chaunh
                        values('Giai ngan nguon chinh, nguon BANK  ','l_main_MRamount',l_main_MRamount);*/

                    elsif l_rrtype = 'O' then -- Neu nguon cho vay la nguon CI: Tam thoi khong check han muc
                        select nvl(greatest( mrcrlimitmax - ci.dfodamt - greatest(nvl(usedprin,0),0),0),0)
                            into l_mrcrlimitmax
                        from afmast af, cimast ci,
                        (select trfacctno, sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd) usedprin
                                from lnmast ln
                                where ftype = 'AF'
                                group by ln.trfacctno) lcf
                        where af.acctno = rec.ciacctno and af.acctno = ci.acctno
                        and af.acctno = lcf.trfacctno(+);

                        l_main_MRamount:= least(l_main_MRamount, greatest(l_mrcrlimitmax,0));

                        /*insert into temp_log_chaunh
                        values('Giai ngan nguon chinh, nguon O  ','l_main_MRamount',l_main_MRamount);*/
                    elsif l_rrtype = 'C' then -- Neu nguon cho vay la nguon Cong Ty: Kiem tra tren han muc vay cua khach hang MRCRLIMITMAX

                        select nvl(greatest(mrcrlimitmax - ci.dfodamt - greatest(nvl(usedprin,0),0),0),0)
                                into l_mrcrlimitmax
                            from afmast af, cimast ci,
                            (select trfacctno, sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd) usedprin
                                    from lnmast ln
                                    where ftype = 'AF'
                                    group by ln.trfacctno) lcf
                            where af.acctno = rec.ciacctno and af.acctno = ci.acctno
                            and af.acctno = lcf.trfacctno(+);

                        l_main_MRamount:=least(greatest(l_mrcrlimitmax,0),l_main_MRamount);

                        /*insert into temp_log_chaunh
                        values('Giai ngan nguon chinh, nguon C  ','l_main_MRamount',l_main_MRamount);*/
                        -- Neu tuan thu. lay min voi maxdebt
                        if rec_ln.chksysctrl = 'Y' then
                           select nvl(greatest(least(mrcrlimitmax,to_number(cspks_system.fn_get_sysvar('MARGIN','MAXDEBTCF'))) - ci.dfodamt - greatest(nvl(usedprin,0),0),0),0)
                                into l_mrcrlimitmax
                            from afmast af, cimast ci,
                            (select trfacctno, sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd) usedprin
                                    from lnmast ln, lntype lnt
                                    where ln.actype = lnt.actype and ln.rrtype = 'C' and lnt.chksysctrl = 'Y'
                                    group by ln.trfacctno) lcf
                            where af.acctno = rec.ciacctno and af.acctno = ci.acctno
                            and af.acctno = lcf.trfacctno(+);
                            l_main_MRamount:=least(greatest(l_mrcrlimitmax,0),l_main_MRamount);

                            -- Neu khach hang ko duoc phep Margin. --> Han muc = 0.
                            if rec.MARGINALLOW <> 'Y' then
                                l_main_MRamount:= 0;
                            end if;
                            select greatest(nvl(sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd),0),0) into l_maxdebt
                            from lnmast ln, lntype lnt where ln.actype = lnt.actype and ftype = 'AF' and lnt.rrtype = 'C' and chksysctrl = 'Y';

                            select greatest(to_number(varvalue) - l_maxdebt,0) into l_mrcrlimitmax from sysvar where varname = 'MAXDEBT';

                            select greatest(least(l_mrcrlimitmax, prlimit - prinused),0) into l_mrcrlimitmax from prmaster where prcode = '9999' and prtyp = 'P';

                            l_main_MRamount:= least(greatest(l_mrcrlimitmax,0), l_main_MRamount);
                        end if;

                        l_main_MRamount:= least(greatest(l_mrcrlimitmax,0), l_main_MRamount);

                    end if;
                    select 100 - mriratio into l_mriratio from afmast where acctno = rec.ciacctno;
                    -- Lay min voi Room: Neu Tuan Thu --> check tren min (ROOM MARGIN, ROOM SYSTEM); Neu Khong Tuan Thu --> check tren ROOM SYSTEM.
                    -- Xet nguon tren ro vay toi da.
                    begin
                        select greatest(least(af.mrcrlimitmax - mst.dfodamt,nvl(afavlamt,0)) - greatest(decode(rec_ln.chksysctrl,'Y',nvl(ln.margin74amt,0),nvl(ln.marginamt,0)),0)
                                    - nvl(sts.trfsecuredamt,0),0)
                            into l_afavlamt
                        from cimast mst, afmast af,
                            (select  se.afacctno, nvl(sum(case when rec_ln.chksysctrl = 'Y' then
                                            (least(se.trade + nvl(sts.receiving,0) - nvl(used.prinused_af,0),
                                                        greatest(nvl(room.roomlimit,0) - nvl(prinused,0),0))
                                                + nvl(used.prinused_af,0))
                                                 * nvl(rsk.MRRATE,0)/100 * nvl(rsk.MRPRICE,0)
                                            else
                                            (least(se.trade + nvl(sts.receiving,0) - nvl(used.sys_prinused_af,0),
                                                        greatest(nvl(room.syroomlimit,0) - nvl(room.syroomused,0) - nvl(used.sys_prinused,0),0))
                                                + nvl(used.sys_prinused_af,0))
                                                 * nvl(rsk.MRRATE,0)/100 * nvl(rsk.MRPRICE,0)
                                            end)
                                    ,0) afavlamt
                            from semast se,
                                (select s1.acctno, sum(s1.qtty-s1.aqtty) receiving
                                    from
                                        (select * from stschd where duetype = 'RS' and deltd <> 'Y') s1,
                                        (select * from stschd where duetype = 'SM' and deltd <> 'Y') s2
                                    where s1.orgorderid = s2.orgorderid
                                        and s2.trfbuyrate * s2.trfbuyext * (s2.amt-s2.trfexeamt) = 0
                                        and s1.status <> 'C'
                                    group by s1.acctno) sts,
                                (SELECT SB.CODEID,LNB.ACTYPE,
                                      LEAST(SEC.MRRATIOLOAN,RATE.MRRATIOLOAN, decode(rec_ln.chksysctrl,'Y',l_mriratio,100))*(case when ismarginallow = 'N' and rec_ln.chksysctrl = 'Y' then 0 else 1 end) MRRATE,
                                      LEAST(SEC.MRPRICELOAN,RSK.MRPRICELOAN, decode(rec_ln.chksysctrl,'Y',SB.MARGINREFPRICE,SB.MARGINPRICE)) MRPRICE
                                    FROM (select * from lnsebasket
                                              where effdate = (select max(effdate)
                                                              from LNSEBASKET
                                                              where effdate <= (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE')
                                                                    and actype = rec_ln.actype
                                                              group by actype)
                                              and actype = rec_ln.actype) LNB,
                                        SECBASKET SEC, SECURITIES_INFO SB,
                                        SECURITIES_RISK RSK, SECURITIES_RATE RATE
                                    WHERE RSK.CODEID=RATE.CODEID AND RATE.FROMPRICE<=SB.FLOORPRICE AND RATE.TOPRICE>SB.FLOORPRICE
                                          AND LNB.BASKETID=SEC.BASKETID AND TRIM(SEC.SYMBOL)=TRIM(SB.SYMBOL)
                                          AND SB.CODEID=RSK.CODEID) rsk,
                                vw_marginroomsystem room,
                                (select codeid, sum(case when restype = 'M' then prinused else 0 end) prinused,
                                    sum(case when restype = 'S' then prinused else 0 end) sys_prinused,
                                    sum(case when restype = 'M' and afacctno = rec.ciacctno then prinused else 0 end) prinused_af,
                                    sum(case when restype = 'S' and afacctno = rec.ciacctno then prinused else 0 end) sys_prinused_af
                                from vw_afpralloc_all group by codeid) used
                            where se.acctno = sts.acctno(+)
                            and se.codeid = rsk.codeid(+)
                            and se.codeid = room.codeid(+)
                            and se.codeid = used.codeid(+)
                            and se.afacctno = rec.ciacctno
                            group by se.afacctno
                        ) se,
                        (select sts.afacctno, sum(amt+feeacr-feeamt-trft0amt) trfsecuredamt
                             from odmast od, stschd sts
                             where od.orderid = sts.orgorderid and sts.duetype = 'SM' and sts.deltd <> 'Y'
                             and trfbuyrate * trfbuyext * (amt-trfexeamt) > 0
                             and od.afacctno = rec.ciacctno
                             and trfbuydt > v_CURRDATE
                             group by sts.afacctno) sts,
                        (select trfacctno,
                                    sum(decode(lnt.chksysctrl,'Y',1,0)*(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) margin74amt,
                                    sum((prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) marginamt
                            from lnmast ln, lntype lnt
                            where trfacctno = rec.ciacctno
                            and ln.ftype = 'AF' and ln.actype = rec_ln.actype
                            and ln.actype = lnt.actype
                            group by trfacctno) ln
                        where mst.acctno = se.afacctno(+)
                        and mst.acctno = sts.afacctno(+)
                        and mst.acctno = ln.trfacctno(+)
                        and mst.acctno = af.acctno
                        and mst.acctno = rec.ciacctno;
                    exception when others then
                        l_afavlamt:=0;
                    end;
                    -- Lay min voi Room: Neu Tuan Thu --> check tren min (ROOM MARGIN, ROOM SYSTEM); Neu Khong Tuan Thu --> check tren ROOM SYSTEM.
                    l_main_MRamount:= least(greatest(l_afavlamt,0), l_main_MRamount);

                    /*insert into temp_log_chaunh
                        values('Giai ngan nguon chinh, nguon KK  ','l_main_MRamount',l_main_MRamount);*/
                end if;

                if l_sub_MRamount is null or l_main_MRamount is null then
                    l_exec_MRamount:= greatest(nvl(l_sub_MRamount,0),  nvl(l_main_MRamount,0));
                else
                    l_exec_MRamount:= l_sub_MRamount + l_main_MRamount;
                end if;

                /*insert into temp_log_chaunh
                        values('Giai ngan  ','l_exec_MRamount',l_exec_MRamount);*/
            end loop; -- rec_ln

        end if;
        l_exec_MRamount:= least(l_exec_MRamount,l_remain_MRamount);

        /*insert into temp_log_chaunh
                        values('Giai ngan tong  ','l_exec_MRamount',l_exec_MRamount);*/
        --update log_mr4000
        if l_exec_MRamount is not null then
            update log_mr4000 set totaldrawndownamt = l_exec_MRamount where afacctno = rec.ciacctno and txdate = v_CURRDATE;
        end if;
    end loop; -- rec
    --xoa nhung khach hang khong co no trong log_mr4000
    --delete from log_mr4000 where totaldrawndownamt is null;
  EXCEPTION
  WHEN OTHERS
   THEN

      plog.error (pkgctx, 'rows:' || dbms_utility.format_error_backtrace);
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_CHAUNH_Drawndown_Margin');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_Drawndown_Margin;

procedure pr_log_sa0015
is
    v_curdate   date ;
    v_datecount number;
    v_edate     date;

begin

    plog.setbeginsection(pkgctx, 'pr_LOG_SA0015');
    v_curdate:= to_date(cspks_system.fn_get_sysvar('SYSTEM','CURRDATE') ,'DD/MM/YYYY');

    -- log ngay
    SELECT min(to_date(sbdate,'DD/MM/RRRR')) - to_date(v_curdate,'DD/MM/RRRR') into v_datecount FROM sbcldr WHERE to_date(sbdate,'DD/MM/RRRR') > to_date(v_curdate,'DD/MM/RRRR')  AND holiday='N' AND cldrtype='000';
    --
    SELECT max(to_date(sbdate,'DD/MM/RRRR'))  into v_edate FROM sbcldr WHERE to_date(sbdate,'DD/MM/RRRR') < v_curdate AND holiday='N' AND cldrtype='000';
    --
  Delete log_sa0015 where txdate = v_curdate;
  --
    insert into log_sa0015( TXDATE,CUSTODYCD,AFACCTNO,BALANCE,BALANCEN,MRAMT,MRAMTTOPUP,ADAMT,adfee,mrint,mrinttopup,payint,payinttopup,mrfee,mrfeetopup,t0amt,t0int
    ,careby,reid,refullname,aftype,odexecamt,odfeeamt,afgrpid,navamt,t0amt_bank,t0int_bank,date_count,grpid,grpname,NAVAMT_ED) --1.6.1.8   MSBS-2194

    select v_curdate txdate, cf.custodycd, ci.acctno afacctno, ci.balance, ci.balance+ ci.netting banlancen, nvl(mr.mramt,0) mramt
    ,nvl(mr.MRAMTTOPUP,0) MRAMTTOPUP, nvl(ad.amt,0) adamt , nvl(ad.feeamt,0) adfee,nvl(mr.mrint,0) mrint, nvl(mr.mrinttopup,0) mrinttopup,
   nvl( payin.payint,0) payint,    nvl( payin.payinttopup,0) payinttopup, nvl(mr.mrfee,0) mrfee, nvl(mr.mrfeetopup,0) mrfeetopup, nvl(mr.t0amt,0) t0amt, nvl(t0int,0) t0int
   --1.6.1.8   MSBS-2194
   , cf.careby, re.reid, re.refullname, af.actype aftype, od.execamt odexecamt, od.feeacr odfeeamt, afgrp.actype afgrpid
   --End 1.6.1.8   MSBS-2194
   --1.6.1.8 - 2210
   , NAVED.AVGNAV navamt
   , nvl(mr.t0amt_bank,0) t0amt_bank, nvl(t0int_bank,0) t0int_bank
   , v_datecount
   , re.grpid, re.grpname
   --END 1.6.1.8 - 2210
   --1.7.1.9
   ,NAVED.AVGNAVED
    from cimast ci,cfmast cf, afmast af,    --1.6.1.8   MSBS-2194
      (select sum( case when  ln.custbank is   null then  (lns.nml + lns.ovd ) else 0  end )MRAMT ,
              sum( case when  ln.custbank is not  null then  (lns.nml + lns.ovd ) else 0  end )MRAMTTOPUP,
              sum( case when  ln.custbank is   null and lns.reftype  in ('GP') then  (lns.nml + lns.ovd ) else 0  end ) T0AMT ,
              sum( case when  ln.custbank is  not  null and lns.reftype  in ('GP') then  (lns.nml + lns.ovd ) else 0  end ) T0AMT_BANK ,
              sum( case when  ln.custbank is   null then  (lns.intnmlacr + lns.intdue + lns.intovd+ lns.intovdprin ) else 0  end ) mrint,
              sum( case when  ln.custbank is   null and lns.reftype  in ('GP') then  (lns.intnmlacr + lns.intdue + lns.intovd+ lns.intovdprin ) else 0  end ) t0int,
              sum( case when  ln.custbank is not null and lns.reftype  in ('GP') then  (lns.intnmlacr + lns.intdue + lns.intovd+ lns.intovdprin ) else 0  end ) t0int_bank,
              sum( case when  ln.custbank is not  null then  (lns.intnmlacr + lns.intdue + lns.intovd + lns.intovdprin ) else 0  end )mrinttopup,
              sum( case when  ln.custbank is   null then  (lns.feeintnmlacr + lns.feeintdue + lns.feeintnmlovd + lns.feeintovdacr + lns.feeovd) else 0  end) mrfee,
              sum( case when  ln.custbank is not  null then  (lns.feeintnmlacr + lns.feeintdue + lns.feeintnmlovd + lns.feeintovdacr + lns.feeovd) else 0  end) mrfeetopup,
               ln.trfacctno afacctno
       from lnschd lns, lnmast ln
       where lns.acctno = ln.acctno
        and lns.reftype  in ('P','GP')
       group by trfacctno
       ) mr,( select sum(amt) amt,sum(case when txdate = v_curdate then  feeamt else 0 end ) feeamt, acctno  from adschd
                where deltd <>'Y' AND STATUS ='N'
                group by acctno )ad,
          ( select
            sum(case when  ln.custbank is   null then  (lnlog.intpaid) else 0  end) payint,
            sum(case when  ln.custbank is not  null then  (lnlog.intpaid) else 0  end) payinttopup,
             trfacctno  acctno
            from vw_lnschdlog_all lnlog, vw_lnschd_all lns, lnmast ln
             where lnlog.txdate = v_curdate
             and lns.autoid = lnlog.autoid and lns.acctno = ln.acctno
             group by trfacctno) payin,
    --1.6.1.8   MSBS-2194
    (select re.afacctno, MAX(cf.fullname) refullname, MAX (substr(re.reacctno,1,10)) reid,max(reg.grpid) grpid, max(reg.grpname) grpname
    from reaflnk re, cfmast cf, retype,
    (select r.reacctno,rg.autoid grpid,rg.fullname grpname from regrplnk r,regrp rg WHERE rg.autoid=r.refrecflnkid and  r.status='A' AND v_curdate between r.frdate and r.todate) reg
    where v_curdate between re.frdate and re.todate
        and substr(re.reacctno,0,10) = cf.custid
        and re.status <> 'C' and re.deltd <> 'Y'
        AND substr(re.reacctno,11) = retype.actype
        AND rerole IN ( 'RM','BM')
        AND re.reacctno=reg.reacctno(+)
    GROUP BY afacctno
    ) re,
    (SELECT afacctno, SUM (execamt) execamt, SUM (feeacr) feeacr FROM odmast WHERE txdate = v_curdate AND execamt > 0
    GROUP BY  afacctno
    ) od,
    (SELECT db.actype, afdb.afacctno FROM dbnavgrp db, afdbnavgrp afdb WHERE db.actype = afdb.refactype AND db.status = 'A'
    ) afgrp,
    --End 1.6.1.8   MSBS-2194
    --1.6.1.8 - 2210
    /*(SELECT custodycd,afacctno,MAX(custid) custid ,round(sum((realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT)),4) AVGNAV
            FROM(select cf.custodycd,v.afacctno , MAX(cf.custid) custid, sum(v.realass) realass,
                       max(T0AMT)T0AMT, max(MRAMT) MRAMT, max(v.balance + v.avladvance) BALANCE,
                       max(v.depofeeamt) DEPOFEEAMT
                from (SELECT * FROM tbl_mr3007_log WHERE txdate=v_curdate) v,cfmast cf
                where cf.custodycd = v.custodycd
                group by cf.custodycd,v.afacctno )
            WHERE (realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT) > 0
            GROUP BY custodycd,afacctno) NAV,*/
    -- END 1.6.1.8 - 2210
    -- 1.7.1.9: NAV theo gia cuoi ngay
    (SELECT custodycd,afacctno,MAX(custid) custid ,round(sum((realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT)),4) AVGNAVED,
            round(sum((NAV_realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT)),4) AVGNAV
            FROM(select cf.custodycd,v.afacctno , MAX(cf.custid) custid, NVL(sum((v.trade + v.mortage + v.TOTALRECEIVING - v.SELLMATCHQTTY + v.TOTALBUYQTTY)*se.avgprice),0) realass,
                       max(T0AMT)T0AMT, max(MRAMT) MRAMT, max(v.balance + v.avladvance) BALANCE,
                       max(v.depofeeamt) DEPOFEEAMT,
                       sum(v.realass) NAV_realass
                from (SELECT * FROM tbl_mr3007_log
                WHERE txdate=v_curdate
                ) v, securities_info se, cfmast cf
                where cf.custodycd = v.custodycd
                and v.codeid=se.codeid(+)
                group by cf.custodycd,v.afacctno )
            WHERE (realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT) > 0
            GROUP BY custodycd,afacctno
            ) NAVED
    -- END 1.7.1.9
    where ci.custid= cf.custid
    and ci.acctno = mr.afacctno (+)
    and ci.acctno = ad.acctno (+)
    and ci.acctno = payin.acctno (+)
    --1.6.1.8   MSBS-2194
    AND ci.acctno= af.acctno
    and ci.acctno = re.afacctno (+)
    and ci.acctno = od.afacctno (+)
    and ci.acctno = afgrp.afacctno (+)
    --End 1.6.1.8   MSBS-2194
    --1.6.1.8 - 2210
    --and ci.acctno = NAV.afacctno (+)
    -- END 1.6.1.8 - 2210
    --1.7.1.9 - NAV gia cuoi ngay
    and ci.acctno = NAVED.afacctno (+)
    --END 1.7.1.9
    and ci.balance + ci.netting +nvl(mr.mramt,0)+nvl(mr.MRAMTTOPUP,0)+ nvl(ad.amt,0) + nvl( payin.payint,0)+ nvl( payin.payinttopup,0) + NVL(od.execamt,0)>0; --1.7.2.4: có phi giao dich cung log
--

   /* FOR rec In (
      SELECT CUSTODYCD,AFACCTNO,sum(CASE WHEN txdate=v_curdate THEN mrint ELSE 0 END) mrint,
                                sum(CASE WHEN txdate=v_curdate THEN mrinttopup ELSE 0 END) mrinttopup,
                                sum(CASE WHEN txdate=v_edate THEN mrint ELSE 0 END) mrint_re,
                                sum(CASE WHEN txdate=v_edate THEN mrinttopup ELSE 0 END) mrinttopup_re
          FROM log_sa0015 where txdate between v_edate and v_curdate
      GROUP BY CUSTODYCD,AFACCTNO
     )
     LOOP
      --1.6.1.7: tru lai da tra
       SELECT NVL(sum(CASE WHEN lm.custbank is null THEN ci.namt else 0 end),0) namt_mr,
              NVL(sum(CASE WHEN lm.custbank is not null THEN ci.namt else 0 end),0) namt_topup
        INTO v_namt_mr, v_namt_topup
        FROM vw_citran_gen ci , lnmast lm
        WHERE ci.tltxcd in ('5567','5540','5566') AND ci.field='BALANCE' AND lower(ci.trdesc) like '%lãi%'
          AND lm.trfacctno=ci.acctno AND lm.acctno=ci.acctref
          AND ci.txdate = v_curdate AND ci.acctno=rec.afacctno;

       UPDATE log_sa0015 lg
       SET lg.mrint_beday=rec.mrint-(rec.mrint_re-v_namt_mr),
           lg.mrinttopup_beday=rec.mrinttopup-(rec.mrinttopup_re-v_namt_topup)
       WHERE lg.txdate=v_curdate and lg.custodycd=rec.CUSTODYCD and lg.afacctno=rec.AFACCTNO;
       END LOOP;*/

    -- 1.6.1.7: log lai xuat
  --1.7.3.0: sua lai
    FOR rec IN
      (
       select * from
          (select ln.trfacctno, SUM(CASE WHEN ln.custbank is null THEN lni.intamt ELSE 0 END) intamt_mr,
                                SUM(CASE WHEN ln.custbank is not null THEN lni.intamt ELSE 0 END) intamt_topup,
                                SUM(CASE WHEN ln.custbank is null and l.loantype='T0' THEN lni.intamt ELSE 0 END) t0_intamt_mr,
                                SUM(CASE WHEN ln.custbank is not null and l.loantype='T0' THEN lni.intamt ELSE 0 END) t0_intamt_topup
          from lninttran lni, lnmast ln, lntype l
          where lni.acctno=ln.acctno
           and ln.ACTYPE = l.actype
          and l.loantype in ('T0', 'CL')
          and v_curdate = lni.frdate
          group by ln.trfacctno) a
        where a.intamt_mr+a.intamt_topup >0
      )
      LOOP
        UPDATE log_sa0015 lg
        SET mrint_beday=rec.intamt_mr,
            mrinttopup_beday=rec.intamt_topup,
            --1.6.1.7: lay them lai cua bao lanh
            t0int_beday=rec.t0_intamt_mr,
            t0inttopup_beday=rec.t0_intamt_topup
            --end
        WHERE txdate=v_curdate and afacctno=rec.trfacctno;
        END LOOP;
     ---

    plog.setendsection(pkgctx, 'pr_log_mr5005');
    EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_log_mr5005');
      ROLLBACK;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_log_mr5005');
      RAISE errnums.E_SYSTEM_ERROR;
end;
  procedure pr_calculate_feeadvamt
is
    v_noquahan number;
    v_notronghan number;
    v_tienUT number;
    v_gtphi number;
    v_temp number;
    v_rowtemp number;
    v_rtemp number;
    v_tongtemp number;
    v_tienmua number;
    v_maxdaonotronghan number;
    v_maxnotronghan number;
    v_currdate      DATE;
BEGIN
    v_currdate:= to_date(cspks_system.fn_get_sysvar('SYSTEM','CURRDATE') ,'DD/MM/RRRR');
    for rec in
    (select * from log_mr4000 where txdate = v_currdate)
    loop
        v_tienUT:=0;
        v_gtphi:= 0;
        v_temp:=0;
        v_noquahan:=0;
        v_notronghan:=0;
        v_rowtemp:=0;
        v_rtemp:= 0;
        v_tienmua:= rec.bamt;
        v_maxdaonotronghan:= rec.daonotronghan;
        v_maxnotronghan:= rec.notronghan;
        v_noquahan:= rec.noquahan;
        for r in --lay so tien da ung trong tung ngay
        (
        select a.afacctno, a.days, a.cleardate, a.custodycd,a.feecmp, a.depoamt + nvl(d.amt,0) advamt
        from v_dayadvanceschedule_all a
            left join
            (select cleardt, acctno, sum(amt) amt from adschd group by  cleardt, acctno) d
            on a.cleardate = d.cleardt and a.afacctno = d.acctno
        where a.afacctno = rec.afacctno
        order by a.days
        )
        loop
        -- phan bo:  no qua han truoc
            v_noquahan:= v_noquahan - r.advamt;
            --so tien co the phan bo trong ngay
            v_tongtemp:= r.advamt - v_noquahan ;
            --phan bo het no qua han, se phan bo sang no trong han va tien mua trong ngay
            if least(v_noquahan,0) <= 0 then
                v_noquahan:=0; --da tra het no quahan
                v_tienUT:= v_tienUT + v_tongtemp;
                --neu cho dao no, tra no truoc
                --uu tien tra nhung khoan no cu truoc
               begin --tra khoan no dao nguon
               for rc in
               (
                select rownum i, ln.* from (
                select ln.trfacctno, ls.rlsdate,v_currdate - ls.rlsdate days,
                    sum(log.PAID + log.INTPAID + log.FEEPAID + log.FEEINTPAID) notronghan
                from lnschdlog log, lnschd ls, lnmast ln where log.autoid = ls.autoid and ln.acctno = ls.acctno
                and ls.overduedate > v_currdate and ln.advpay = 'Y' and ln.trfacctno = rec.afacctno
                group by ln.trfacctno, ls.rlsdate, ls.overduedate
                order by v_currdate - ls.overduedate) ln  --tra nhung khoan no gan ht truoc
               )
               loop

                 if v_rowtemp < rc.i and v_maxdaonotronghan > 0 then --check den khoan no can giai ngan, chi giai ngan khi nguon giai ngan con

                     if rc.notronghan <= v_tienUT then
                         v_temp:=least(v_tienUT, rc.notronghan, v_maxdaonotronghan) * least(greatest(2 - rc.days,0),r.days) * r.feecmp / 100 /360
                                /(1- least(greatest(2 - rc.days,0),r.days) * r.feecmp / 100 /360);
                         v_tienUT:= v_tienUT - rc.notronghan;

                     else  --rc.notronghan > v_tienUT
                         v_rowtemp:= rc.i;
                         v_notronghan:= rc.notronghan - v_tienUT;
                         v_temp:= least(v_tienUT, rc.notronghan, v_maxdaonotronghan) * least(greatest(2 - rc.days,0),r.days) * r.feecmp / 100 /360
                                /(1-least(greatest(2 - rc.days,0),r.days) * r.feecmp / 100 /360);
                        --da ung het tien
                         v_tienUT:= 0;
                     end if;
                     --giam ngujon max
                     v_maxdaonotronghan:= v_maxdaonotronghan - least(v_tienUT, rc.notronghan, v_maxdaonotronghan);
                     v_gtphi:= v_gtphi + v_temp;
                 elsif v_rowtemp = rc.i and v_notronghan >0 and v_maxdaonotronghan >0 then
                    v_temp:= least(v_tienUT, v_notronghan, v_maxdaonotronghan) * least(greatest(2 - rc.days,0),r.days) * r.feecmp / 100 /360
                            /(1-least(greatest(2 - rc.days,0),r.days) * r.feecmp / 100 /360);
                    if v_tienUT - v_notronghan < 0 then
                       v_notronghan:= v_notronghan - v_tienUT;
                       v_tienUT:= 0;
                    elsif v_tienUT - v_notronghan >=0 then
                        v_notronghan:= 0;
                        v_rowtemp:= 0;
                        v_tienUT:= v_tienUT - v_notronghan;
                    end if;
                    v_maxdaonotronghan:=v_maxdaonotronghan - least(v_tienUT, v_notronghan, v_maxdaonotronghan);
                    v_gtphi:= v_gtphi + v_temp;
                 end if;
               end loop;
               exception when others then
                    v_notronghan:= 0;
               end;

               begin --UT tien mua
                v_temp:= least(v_tienUT, v_tienmua)* least(2,r.days)*r.feecmp/100/360 / (1 - least(2,r.days)*r.feecmp/100/360);
                v_gtphi:= v_gtphi + v_temp;
                v_tienUT:= greatest(v_tienUT - v_tienmua,0);
                v_tienmua:= greatest(v_tienmua - v_tienUT,0);
                if v_tienmua = 0 then  --tra het tien mua
                    --bat dau tra tien notronghan khong dao no
                    begin --tra khoan no dao nguon

                       for rc in
                       (select rownum i, ln.* from (
                        select  ln.trfacctno, ls.rlsdate,v_currdate - ls.rlsdate days, sum(log.PAID + log.INTPAID + log.FEEPAID + log.FEEINTPAID) notronghan
                        from lnschdlog log, lnschd ls, lnmast ln where log.autoid = ls.autoid and ln.acctno = ls.acctno
                        and ls.overduedate > v_currdate and ln.advpay = 'N' and ln.trfacctno = rec.afacctno
                        group by ln.trfacctno, ls.rlsdate, ls.overduedate
                        order by v_currdate - ls.overduedate) ln  --tra nhung khoan no gan ht truoc
                       )
                       loop

                         if v_rtemp < rc.i and v_maxnotronghan > 0 then --check den khoan no can giai ngan

                             if rc.notronghan <= v_tienUT then
                                 v_temp:= least(v_tienUT, rc.notronghan, v_maxnotronghan) * least(greatest(2 - rc.days,0),r.days) * r.feecmp / 100 /360
                                            /(1-least(greatest(2 - rc.days,0),r.days) * r.feecmp / 100 /360);
                                 v_tienUT:= v_tienUT - rc.notronghan;
                             else  --rc.notronghan > v_tienUT
                                 v_rtemp:= rc.i;
                                 v_notronghan:= rc.notronghan - v_tienUT ;
                                 v_temp:= least(v_tienUT, rc.notronghan, v_maxnotronghan) * least(greatest(2 - rc.days,0),r.days) * r.feecmp / 100 /360
                                                /(1-least(greatest(2 - rc.days,0),r.days) * r.feecmp / 100 /360);
                                 v_tienUT:= 0;

                             end if;

                             --giam ngujon max
                             v_maxdaonotronghan:= v_maxdaonotronghan - least(v_tienUT, rc.notronghan, v_maxnotronghan);
                             v_gtphi:= v_gtphi + v_temp;
                         elsif v_rtemp = rc.i and v_notronghan >0 and v_maxnotronghan > 0 then
                            v_temp:= least(v_tienUT, v_notronghan,v_maxnotronghan ) * least(greatest(2 - rc.days,0),r.days) * r.feecmp / 100 /360
                                    /(1-least(greatest(2 - rc.days,0),r.days) * r.feecmp / 100 /360);
                            if v_tienUT - v_notronghan < 0 then
                               v_notronghan:= v_notronghan - v_tienUT;
                               v_tienUT:= 0;
                            elsif v_tienUT - v_notronghan >0 then
                                v_notronghan:= 0;
                                v_rtemp:= 0;
                                v_tienUT:=v_tienUT - v_notronghan;
                            end if;
                            v_maxdaonotronghan:= v_maxdaonotronghan - least(v_tienUT, rc.notronghan, v_maxnotronghan);
                            v_gtphi:= v_gtphi + v_temp;
                         end if;
                       end loop;
                       exception when others then
                            select 0 into v_notronghan from dual;
                       end;
                    ---end tra no

                end if;
               end;


            end if;

        end loop;
        update log_mr4000
        set fee = v_gtphi where txdate = v_currdate and afacctno = rec.afacctno;

    end loop;

 EXCEPTION
  WHEN OTHERS
   THEN

      plog.error (pkgctx, 'rows:' || dbms_utility.format_error_backtrace);
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_calculate_feeadvamt');
      RAISE errnums.E_SYSTEM_ERROR;
end pr_calculate_feeadvamt;

BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_logproc',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
