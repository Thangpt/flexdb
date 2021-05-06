CREATE OR REPLACE PACKAGE txpks_#8848ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8848EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      27/08/2012     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_PlaceOrder
    (
        p_txmsg in tx.msg_rectype,
        p_afacctno  IN VARCHAR2,
        p_orderqtty IN  NUMBER,
        p_err_code out VARCHAR2,
        p_newOrderID OUT varchar2
    )
RETURN NUMBER;
FUNCTION fn_Match_Order
    (
        p_orderid        IN   VARCHAR2,
        p_orgorderid     IN   VARCHAR2,
        p_matchqtty      IN   number,
        p_matchprice     IN   number,
        p_err_code       out VARCHAR2
    )
RETURN NUMBER;
END;
/
CREATE OR REPLACE PACKAGE BODY txpks_#8848ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_orderid          CONSTANT CHAR(2) := '01';
   c_custodycd        CONSTANT CHAR(2) := '02';
   c_afacctno         CONSTANT CHAR(2) := '03';
   c_tdcustodycd      CONSTANT CHAR(2) := '04';
   c_tdafacctno       CONSTANT CHAR(2) := '05';
   c_txdate           CONSTANT CHAR(2) := '08';
   c_cleardate        CONSTANT CHAR(2) := '09';
   c_codeid           CONSTANT CHAR(2) := '07';
   c_exectype         CONSTANT CHAR(2) := '22';
   c_tdorderqtty      CONSTANT CHAR(2) := '10';
   c_orderqtty        CONSTANT CHAR(2) := '15';
   c_quoteprice       CONSTANT CHAR(2) := '11';
   c_matchqtty        CONSTANT CHAR(2) := '12';
   c_matchamt         CONSTANT CHAR(2) := '14';
   c_fixerrtype       CONSTANT CHAR(2) := '20';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_exectype      varchar2(2);
    l_seacctno      varchar2(20);
    l_afacctno      varchar2(10);
    l_semastcheck_arr txpks_check.semastcheck_arrtype;
    l_cimastcheck_arr txpks_check.cimastcheck_arrtype;
    l_PP number(20,4);
    l_PPse number(20,4);
    l_AVLLIMIT number(20,4);
    l_STATUS    varchar2(2);
    l_SETRADE   NUMBER;
    l_bratio    NUMBER;
    l_odactype  VARCHAR2(4);
    l_margintype            CHAR (1);
    l_actype                VARCHAR2 (4);

    l_advanceline number(20,4);
    l_mrratiorate number(20,4);
    l_marginprice number(20,4);
    l_marginrefprice number(20,4);
    l_mrpriceloan number(20,4);
    l_orderprice number(20,4);
    l_deffeerate number(10,6);
    l_chksysctrl varchar2(1);
    l_ismarginallow varchar2(1);
    l_total_trft0amt number(20,0);

    l_avlroomqtty number;
    l_avlsyroomqtty number;
    l_avlqtty number;
    l_avlsyqtty number;
    l_PP0_add number;
    l_IsLateTransfer number;
    l_T0SecureAmt number;
    l_orderqtty NUMBER;
    l_quoteprice    NUMBER;
    l_batchrun      NUMBER;
    l_corebank      varchar2(1);
    
    l_deal      VARCHAR2(2);
    l_advanceline1 number(20,4);
    l_t0loanrate   NUMBER;
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txPreAppCheck');
   plog.debug(pkgctx,'BEGIN OF fn_txPreAppCheck');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/

    -- Kiem tra xem da chay batch chua, neu chay batch roi thi ko cho sinh lenh
    SELECT fn_check_after_batch INTO l_batchrun FROM dual;
    IF l_batchrun > 0 THEN
        p_err_code := errnums.C_SA_RUN_BEFORE_BATCH;
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    l_exectype := p_txmsg.txfields(c_exectype).value;
    -- Kiem tra tai khoan corebank da thanh toan tien mua ko cho phep sua SL CK dat mua moi
    SELECT corebank INTO l_corebank FROM cimast WHERE acctno = p_txmsg.txfields(c_afacctno).value;
    IF l_corebank = 'Y' AND l_exectype IN ('NB') AND (to_number(p_txmsg.txfields(c_orderqtty).value) > 0 OR
            to_number(p_txmsg.txfields(c_tdorderqtty).value) <> to_number(p_txmsg.txfields(c_matchqtty).value))
        AND to_date(p_txmsg.txfields(c_txdate).value,'DD/MM/YYYY') <> getcurrdate THEN
        p_err_code := errnums.C_OD_COREBANK_ACC_TRF;
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    -- Kiem tra so du tien va so du CK co du de dat lenh hay ko?
    IF l_exectype IN ('NS','MS','SS') THEN
        IF to_number(p_txmsg.txfields(c_tdorderqtty).value) > 0 THEN
            l_seacctno := p_txmsg.txfields(c_tdafacctno).value || p_txmsg.txfields(c_codeid).value;
            l_SEMASTcheck_arr := txpks_check.fn_SEMASTcheck(l_seacctno,'SEMAST','ACCTNO');

            l_SETRADE := l_SEMASTcheck_arr(0).TRADE;

            IF NOT (greatest(to_number(l_SETRADE),0) >= to_number(p_txmsg.txfields(c_tdorderqtty).value)) THEN
                p_err_code := '-900017';
                plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        END IF;
        IF to_number(p_txmsg.txfields(c_orderqtty).value) > 0 THEN
            l_seacctno := p_txmsg.txfields(c_afacctno).value || p_txmsg.txfields(c_codeid).value;
            l_SEMASTcheck_arr := txpks_check.fn_SEMASTcheck(l_seacctno,'SEMAST','ACCTNO');

            l_SETRADE := l_SEMASTcheck_arr(0).TRADE;

            IF NOT (greatest(to_number(l_SETRADE),0) >= to_number(p_txmsg.txfields(c_orderqtty).value)) THEN
                p_err_code := '-900017';
                plog.setendsection (pkgctx, 'fn_txAftAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        END IF;
    END IF;
    IF l_exectype IN ('NB') THEN
        -- Lay thong tin ky quy lenh goc
        SELECT od.bratio, od.actype
        INTO l_bratio, l_odactype
        FROM odmast od
        WHERE od.orderid = p_txmsg.txfields(c_orderid).value;

        -- Kiem tra TK tu doanh
        IF to_number(p_txmsg.txfields(c_tdorderqtty).value) > 0 THEN
            l_afacctno := p_txmsg.txfields(c_tdafacctno).value;
            l_orderqtty := to_number(p_txmsg.txfields(c_tdorderqtty).value);
            l_quoteprice := to_number(p_txmsg.txfields(c_quoteprice).value);

            SELECT mr.mrtype, af.actype, mst.deal, cf.t0loanrate
            INTO l_margintype, l_actype, l_deal, l_t0loanrate
            FROM afmast mst, aftype af, mrtype mr, cfmast cf
            WHERE mst.actype = af.actype
                AND af.mrtype = mr.actype
                AND mst.custid = cf.custid
                AND mst.acctno = l_afacctno;

            select af.advanceline, nvl(rsk.mrratioloan,0),nvl(rsk.mrpriceloan,0), nvl(lnt.chksysctrl,'N'), nvl(rsk.ismarginallow,'N'), af.trfbuyrate * af.trfbuyext,
                    (nvl(b.buyamt,0) * af.trfbuyrate/100)  + (case when af.trfbuyrate > 0 then nvl(b.buyfeeacr,0) else 0 end)
            into l_advanceline, l_mrratiorate,l_mrpriceloan, l_chksysctrl, l_ismarginallow, l_IsLateTransfer, l_T0SecureAmt
            from afmast af, aftype aft, lntype lnt,
                (select * from afserisk where codeid = p_txmsg.txfields(c_codeid).value) rsk,
                (select * from v_getbuyorderinfo where afacctno = l_afacctno) b
            where af.actype = aft.actype
            and aft.lntype = lnt.actype(+)
            and af.actype = rsk.actype(+)
            and af.acctno = b.afacctno(+)
            and af.acctno = l_afacctno;
            
     ----
     --1.5.8.9 MSBS-2055
              IF l_deal = 'N' THEN
                  SELECT ROUND(least(nvl((ci.balance-NVL(b.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt - 
                          NVL(ci.ovamt,0),0) * l_t0loanrate /100,nvl(v_getsec.SELIQAMT2,0)))
                  INTO l_advanceline1
                  from cimast ci inner join afmast af on ci.acctno=af.acctno
                  left join
                  (select * from v_getbuyorderinfo where afacctno = p_txmsg.txfields('03').value) b
                  on  ci.acctno = b.afacctno
                  LEFT JOIN
                  (select sum(depoamt) avladvance, sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno, sum(aamt) aamt from v_getAccountAvlAdvance where afacctno = p_txmsg.txfields('03').value group by afacctno) adv
                  on adv.afacctno=ci.acctno
                  LEFT JOIN
                  (SELECT * FROM v_getsecmargininfo_ALL) v_getsec
                  ON ci.acctno = v_getsec.afacctno
                  where ci.acctno = p_txmsg.txfields('03').value;
              ELSE
                  l_advanceline1 := l_advanceline;
              END IF;

            -- Bao lanh danh cho lenh trong qua khu:
            select nvl(sum(sts.trft0amt),0)
                into l_total_trft0amt
            from stschd sts
            where sts.afacctno = l_afacctno and sts.duetype = 'SM'  and deltd <> 'Y' and trfbuysts <> 'Y' and trfbuyrate * trfbuyext > 0;
            -- Bao lanh cap trong ngay:
            l_advanceline:=greatest(greatest(least(l_advanceline,l_advanceline1),0)-l_total_trft0amt, 0); --1.5.8.9 MSBS-2055

            l_CIMASTcheck_arr := txpks_check.fn_CIMASTcheck(l_afacctno,'CIMAST','ACCTNO');
            l_PP := l_CIMASTcheck_arr(0).PP;
            l_AVLLIMIT := l_CIMASTcheck_arr(0).AVLLIMIT;
            l_STATUS := l_CIMASTcheck_arr(0).STATUS;

            IF NOT ( INSTR('AT',l_STATUS) > 0) THEN
                p_err_code := '-400100';
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
            if l_margintype not in ('S','T') then
                IF NOT (ceil(to_number(l_PP)) >= l_orderqtty * l_quoteprice * l_bratio/100) THEN
                    p_err_code := '-400116';
                    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
            else

                select marginrefprice, marginprice
                into l_marginrefprice, l_marginprice
                from securities_info
                where codeid = p_txmsg.txfields(c_codeid).value;

                select deffeerate/100
                into l_deffeerate
                from odtype
                where actype =l_odactype;

                if (l_chksysctrl = 'Y' and l_ismarginallow = 'N') or l_IsLateTransfer > 0 then
                    l_PPse:=l_PP + l_advanceline - l_T0SecureAmt;
                else
                    if l_chksysctrl = 'Y' then
                        if l_PP > 0 then
                            l_PPse:= l_PP / (1 + l_deffeerate - l_mrratiorate/100 * least(l_marginrefprice, l_mrpriceloan) /(l_quoteprice)) + l_advanceline - l_T0SecureAmt;
                        else
                            l_PPse:=l_PP + l_advanceline - l_T0SecureAmt;
                        end if;
                    else
                        if l_PP > 0 then
                            l_PPse:= l_PP / (1 + l_deffeerate - l_mrratiorate/100 * least(l_marginprice, l_mrpriceloan) /(l_quoteprice)) + l_advanceline - l_T0SecureAmt;
                        else
                            l_PPse:=l_PP + l_advanceline - l_T0SecureAmt;
                        end if;
                    end if;

                    -- Room
                    begin
                    select greatest(r1.syroomlimit - r1.syroomused - nvl(u1.sy_prinused,0),0) avlsyroom,
                            greatest(r1.roomlimit - nvl(u1.prinused,0),0) avlroom
                            into l_avlsyroomqtty, l_avlroomqtty
                    from vw_marginroomsystem r1,
                    (select codeid, sum(case when restype = 'M' then prinused else 0 end) prinused,
                                sum(case when restype = 'S' then prinused else 0 end) sy_prinused
                        from vw_afpralloc_all
                        where codeid = p_txmsg.txfields(c_codeid).value
                        group by codeid) u1
                    where r1.codeid = u1.codeid(+)
                    and r1.codeid = p_txmsg.txfields(c_codeid).value;
                    exception when others then
                        l_avlsyroomqtty:=0;
                        l_avlroomqtty:=0;
                    end;

                    --AvlQtty
                    begin
                        select greatest(nvl(l_avlsyroomqtty + nvl(sy_prinused,0),0) - nvl(least(trade + receiving - EXECQTTY + BUYQTTY,l_avlsyroomqtty + nvl(sy_prinused,0)),0),0) avlsyqtty,
                           greatest(nvl(l_avlroomqtty + nvl(prinused,0),0) - nvl(least(trade + receiving - EXECQTTY + BUYQTTY,l_avlroomqtty + nvl(prinused,0)),0),0) avlqtty
                           into l_avlsyqtty, l_avlqtty
                        from
                            (select se.codeid, af.actype,se.afacctno,se.acctno, se.trade + se.grpordamt trade, nvl(sts.receiving,0) receiving,nvl(BUYQTTY,0) BUYQTTY,nvl(od.EXECQTTY,0) EXECQTTY,  nvl(afpr.prinused,0) prinused, nvl(afpr.sy_prinused,0) sy_prinused
                            from semast se inner join afmast af on se.afacctno =af.acctno
                            left join
                            (select sum(BUYQTTY) BUYQTTY, sum(EXECQTTY) EXECQTTY , SEACCTNO
                                  from (
                                      SELECT (case when od.exectype IN ('NB','BC')
                                                  then (case when (af.trfbuyext * af.trfbuyrate) > 0 then 0 else REMAINQTTY end)
                                                          + (case when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY - DFQTTY end)
                                                  else 0 end) BUYQTTY,
                                                  (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end) TOTALBUYQTTY,
                                              (case when od.exectype IN ('NS','MS') then EXECQTTY - nvl(dfexecqtty,0) else 0 end) EXECQTTY,SEACCTNO
                                      FROM odmast od, afmast af, (select orgorderid, (trfbuyext * trfbuyrate) * (amt - trfexeamt) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                                            (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                                         where od.afacctno = l_afacctno and od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
                                         and od.txdate =(select to_date(VARVALUE,'DD/MM/RRRR') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                                         AND od.deltd <> 'Y'
                                         and not(od.grporder='Y' and od.matchtype='P') --Lenh thoa thuan tong khong tinh vao
                                         AND od.exectype IN ('NS', 'MS','NB','BC')
                                      )
                           group by seacctno
                           ) OD
                          on OD.seacctno =se.acctno
                          left join
                          (SELECT STS.CODEID,STS.AFACCTNO,
                                  SUM(CASE WHEN DUETYPE ='RS' and nvl(sts_trf.islatetransfer,0) = 0 AND STS.TXDATE <> (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME='SYSTEM' AND VARNAME='CURRDATE') THEN QTTY-AQTTY ELSE 0 END) RECEIVING
                              FROM STSCHD STS, ODMAST OD, ODTYPE TYP, (select orgorderid, (trfbuyext * trfbuyrate) * (amt - trfexeamt) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf
                              WHERE STS.DUETYPE IN ('RM','RS') AND STS.STATUS ='N'
                                  AND STS.DELTD <>'Y' AND STS.ORGORDERID=OD.ORDERID AND OD.ACTYPE =TYP.ACTYPE
                                  and od.orderid = sts_trf.orgorderid(+) and sts.afacctno = p_txmsg.txfields('03').value
                                  GROUP BY STS.AFACCTNO,STS.CODEID
                           ) sts
                          on sts.afacctno =se.afacctno and sts.codeid=se.codeid
                          left join
                          (
                              select afacctno, codeid,
                                  nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                                  nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                              from vw_afpralloc_all
                              where codeid = p_txmsg.txfields(c_codeid).value and afacctno = l_afacctno
                              group by afacctno, codeid
                          ) afpr  on afpr.afacctno =se.afacctno and afpr.codeid=se.codeid
                      ) se,
                      afmast af, afserisk rsk,securities_info sb
                      where se.afacctno =af.acctno and se.codeid=sb.codeid
                      and se.codeid=rsk.codeid (+) and se.actype =rsk.actype (+)
                      and se.afacctno = l_afacctno and se.codeid = p_txmsg.txfields(c_codeid).value;
                    EXCEPTION when others then
                        l_avlsyqtty:=l_avlsyroomqtty;
                        l_avlqtty:=l_avlroomqtty;
                    end;

                    if l_chksysctrl = 'Y' then
                        l_PP0_add:= least(least(l_marginrefprice, l_mrpriceloan) * l_mrratiorate /100 * l_avlqtty,
                                            least(l_marginprice, l_mrpriceloan) * l_mrratiorate/100 * l_avlsyqtty);
                    else
                        l_PP0_add:= least(l_marginprice, l_mrpriceloan) * l_mrratiorate/100 * l_avlsyqtty;
                    end if;
                    l_PPse:=least(l_PPse,l_PP + l_advanceline - l_T0SecureAmt + l_PP0_add);
                end if;

                IF NOT ceil(l_PPse) >= l_orderqtty * l_quoteprice THEN
                    p_err_code := '-400116';
                    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
            end if;

        END IF;

        -- Kiem tra TK thuong
        IF to_number(p_txmsg.txfields(c_orderqtty).value) > 0 THEN
            l_afacctno := p_txmsg.txfields(c_afacctno).value;
            l_orderqtty := to_number(p_txmsg.txfields(c_orderqtty).value);
            l_quoteprice := to_number(p_txmsg.txfields(c_quoteprice).value);

            SELECT mr.mrtype, af.actype, mst.deal, cf.t0loanrate
            INTO l_margintype, l_actype, l_deal, l_t0loanrate
            FROM afmast mst, aftype af, mrtype mr, cfmast cf
            WHERE mst.actype = af.actype
                AND af.mrtype = mr.actype
                AND mst.custid = cf.custid
                AND mst.acctno = l_afacctno;

            select af.advanceline, nvl(rsk.mrratioloan,0),nvl(rsk.mrpriceloan,0), nvl(lnt.chksysctrl,'N'), nvl(rsk.ismarginallow,'N'), af.trfbuyrate * af.trfbuyext,
                    (nvl(b.buyamt,0) * af.trfbuyrate/100)  + (case when af.trfbuyrate > 0 then nvl(b.buyfeeacr,0) else 0 end)
            into l_advanceline, l_mrratiorate,l_mrpriceloan, l_chksysctrl, l_ismarginallow, l_IsLateTransfer, l_T0SecureAmt
            from afmast af, aftype aft, lntype lnt,
                (select * from afserisk where codeid = p_txmsg.txfields(c_codeid).value) rsk,
                (select * from v_getbuyorderinfo where afacctno = l_afacctno) b
            where af.actype = aft.actype
            and aft.lntype = lnt.actype(+)
            and af.actype = rsk.actype(+)
            and af.acctno = b.afacctno(+)
            and af.acctno = l_afacctno;

----
         --1.5.8.9 MSBS-2055
              IF l_deal = 'N' THEN
                  SELECT ROUND(least(nvl((ci.balance-NVL(b.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt - 
                          NVL(ci.ovamt,0),0) * l_t0loanrate /100,nvl(v_getsec.SELIQAMT2,0)))
                  INTO l_advanceline1
                  from cimast ci inner join afmast af on ci.acctno=af.acctno
                  left join
                  (select * from v_getbuyorderinfo where afacctno = p_txmsg.txfields('03').value) b
                  on  ci.acctno = b.afacctno
                  LEFT JOIN
                  (select sum(depoamt) avladvance, sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno, sum(aamt) aamt from v_getAccountAvlAdvance where afacctno = p_txmsg.txfields('03').value group by afacctno) adv
                  on adv.afacctno=ci.acctno
                  LEFT JOIN
                  (SELECT * FROM v_getsecmargininfo_ALL) v_getsec
                  ON ci.acctno = v_getsec.afacctno
                  where ci.acctno = p_txmsg.txfields('03').value;
              END IF;
              
            -- Bao lanh danh cho lenh trong qua khu:
            select nvl(sum(sts.trft0amt),0)
                into l_total_trft0amt
            from stschd sts
            where sts.afacctno = l_afacctno and sts.duetype = 'SM'  and deltd <> 'Y' and trfbuysts <> 'Y' and trfbuyrate * trfbuyext > 0;
            -- Bao lanh cap trong ngay:
            l_advanceline:=greatest(least(l_advanceline,l_advanceline1)-l_total_trft0amt, 0);

            l_CIMASTcheck_arr := txpks_check.fn_CIMASTcheck(l_afacctno,'CIMAST','ACCTNO');
            l_PP := l_CIMASTcheck_arr(0).PP;
            l_AVLLIMIT := l_CIMASTcheck_arr(0).AVLLIMIT;
            l_STATUS := l_CIMASTcheck_arr(0).STATUS;

            IF NOT ( INSTR('AT',l_STATUS) > 0) THEN
                p_err_code := '-400100';
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
            if l_margintype not in ('S','T') then
                IF NOT (ceil(to_number(l_PP)) >= l_orderqtty * l_quoteprice * l_bratio/100) THEN
                    p_err_code := '-400116';
                    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
            else

                select marginrefprice, marginprice
                into l_marginrefprice, l_marginprice
                from securities_info
                where codeid = p_txmsg.txfields(c_codeid).value;

                select deffeerate/100
                into l_deffeerate
                from odtype
                where actype =l_odactype;

                if (l_chksysctrl = 'Y' and l_ismarginallow = 'N') or l_IsLateTransfer > 0 then
                    l_PPse:=l_PP + l_advanceline - l_T0SecureAmt;
                else
                    if l_chksysctrl = 'Y' then
                        if l_PP > 0 then
                            l_PPse:= l_PP / (1 + l_deffeerate - l_mrratiorate/100 * least(l_marginrefprice, l_mrpriceloan) /(l_quoteprice)) + l_advanceline - l_T0SecureAmt;
                        else
                            l_PPse:=l_PP + l_advanceline - l_T0SecureAmt;
                        end if;
                    else
                        if l_PP > 0 then
                            l_PPse:= l_PP / (1 + l_deffeerate - l_mrratiorate/100 * least(l_marginprice, l_mrpriceloan) /(l_quoteprice)) + l_advanceline - l_T0SecureAmt;
                        else
                            l_PPse:=l_PP + l_advanceline - l_T0SecureAmt;
                        end if;
                    end if;

                    -- Room
                    begin
                    select greatest(r1.syroomlimit - r1.syroomused - nvl(u1.sy_prinused,0),0) avlsyroom,
                            greatest(r1.roomlimit - nvl(u1.prinused,0),0) avlroom
                            into l_avlsyroomqtty, l_avlroomqtty
                    from vw_marginroomsystem r1,
                    (select codeid, sum(case when restype = 'M' then prinused else 0 end) prinused,
                                sum(case when restype = 'S' then prinused else 0 end) sy_prinused
                        from vw_afpralloc_all
                        where codeid = p_txmsg.txfields(c_codeid).value
                        group by codeid) u1
                    where r1.codeid = u1.codeid(+)
                    and r1.codeid = p_txmsg.txfields(c_codeid).value;
                    exception when others then
                        l_avlsyroomqtty:=0;
                        l_avlroomqtty:=0;
                    end;

                    --AvlQtty
                    begin
                        select greatest(nvl(l_avlsyroomqtty + nvl(sy_prinused,0),0) - nvl(least(trade + receiving - EXECQTTY + BUYQTTY,l_avlsyroomqtty + nvl(sy_prinused,0)),0),0) avlsyqtty,
                           greatest(nvl(l_avlroomqtty + nvl(prinused,0),0) - nvl(least(trade + receiving - EXECQTTY + BUYQTTY,l_avlroomqtty + nvl(prinused,0)),0),0) avlqtty
                           into l_avlsyqtty, l_avlqtty
                        from
                            (select se.codeid, af.actype,se.afacctno,se.acctno, se.trade + se.grpordamt trade, nvl(sts.receiving,0) receiving,nvl(BUYQTTY,0) BUYQTTY,nvl(od.EXECQTTY,0) EXECQTTY,  nvl(afpr.prinused,0) prinused, nvl(afpr.sy_prinused,0) sy_prinused
                            from semast se inner join afmast af on se.afacctno =af.acctno
                            left join
                            (select sum(BUYQTTY) BUYQTTY, sum(EXECQTTY) EXECQTTY , SEACCTNO
                                  from (
                                      SELECT (case when od.exectype IN ('NB','BC')
                                                  then (case when (af.trfbuyext * af.trfbuyrate) > 0 then 0 else REMAINQTTY end)
                                                          + (case when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY - DFQTTY end)
                                                  else 0 end) BUYQTTY,
                                                  (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end) TOTALBUYQTTY,
                                              (case when od.exectype IN ('NS','MS') then EXECQTTY - nvl(dfexecqtty,0) else 0 end) EXECQTTY,SEACCTNO
                                      FROM odmast od, afmast af, (select orgorderid, (trfbuyext * trfbuyrate) * (amt - trfexeamt) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                                            (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                                         where od.afacctno = l_afacctno and od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
                                         and od.txdate =(select to_date(VARVALUE,'DD/MM/RRRR') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                                         AND od.deltd <> 'Y'
                                         and not(od.grporder='Y' and od.matchtype='P') --Lenh thoa thuan tong khong tinh vao
                                         AND od.exectype IN ('NS', 'MS','NB','BC')
                                      )
                           group by seacctno
                           ) OD
                          on OD.seacctno =se.acctno
                          left join
                          (SELECT STS.CODEID,STS.AFACCTNO,
                                  SUM(CASE WHEN DUETYPE ='RS' and nvl(sts_trf.islatetransfer,0) = 0 AND STS.TXDATE <> (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME='SYSTEM' AND VARNAME='CURRDATE') THEN QTTY-AQTTY ELSE 0 END) RECEIVING
                              FROM STSCHD STS, ODMAST OD, ODTYPE TYP, (select orgorderid, (trfbuyext * trfbuyrate) * (amt - trfexeamt) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf
                              WHERE STS.DUETYPE IN ('RM','RS') AND STS.STATUS ='N'
                                  AND STS.DELTD <>'Y' AND STS.ORGORDERID=OD.ORDERID AND OD.ACTYPE =TYP.ACTYPE
                                  and od.orderid = sts_trf.orgorderid(+) and sts.afacctno = p_txmsg.txfields('03').value
                                  GROUP BY STS.AFACCTNO,STS.CODEID
                           ) sts
                          on sts.afacctno =se.afacctno and sts.codeid=se.codeid
                          left join
                          (
                              select afacctno, codeid,
                                  nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                                  nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                              from vw_afpralloc_all
                              where codeid = p_txmsg.txfields(c_codeid).value and afacctno = l_afacctno
                              group by afacctno, codeid
                          ) afpr  on afpr.afacctno =se.afacctno and afpr.codeid=se.codeid
                      ) se,
                      afmast af, afserisk rsk,securities_info sb
                      where se.afacctno =af.acctno and se.codeid=sb.codeid
                      and se.codeid=rsk.codeid (+) and se.actype =rsk.actype (+)
                      and se.afacctno = l_afacctno and se.codeid = p_txmsg.txfields(c_codeid).value;
                    EXCEPTION when others then
                        l_avlsyqtty:=l_avlsyroomqtty;
                        l_avlqtty:=l_avlroomqtty;
                    end;

                    if l_chksysctrl = 'Y' then
                        l_PP0_add:= least(least(l_marginrefprice, l_mrpriceloan) * l_mrratiorate /100 * l_avlqtty,
                                            least(l_marginprice, l_mrpriceloan) * l_mrratiorate/100 * l_avlsyqtty);
                    else
                        l_PP0_add:= least(l_marginprice, l_mrpriceloan) * l_mrratiorate/100 * l_avlsyqtty;
                    end if;
                    l_PPse:=least(l_PPse,l_PP + l_advanceline - l_T0SecureAmt + l_PP0_add);
                end if;

                IF NOT ceil(l_PPse) >= l_orderqtty * l_quoteprice THEN
                    p_err_code := '-400116';
                    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
            end if;
        END IF;
    END IF;

    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppCheck;

FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_TradeLotChk   NUMBER;
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAftAppCheck');
   plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppCheck>>');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/

    -- Kiem tra SL dat phai dung lo GD
    IF to_number(p_txmsg.txfields(c_tdorderqtty).value) > 0 THEN
        SELECT mod(to_number(p_txmsg.txfields(c_tdorderqtty).value), seif.tradelot)
        INTO l_TradeLotChk
        FROM securities_info seif
        WHERE seif.codeid = p_txmsg.txfields(c_codeid).value;
        IF l_TradeLotChk > 0  THEN
            p_err_code := errnums.C_OD_QTTY_TRADELOT_INCORRECT; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
    END IF;
    IF to_number(p_txmsg.txfields(c_orderqtty).value) > 0 THEN
        SELECT mod(to_number(p_txmsg.txfields(c_orderqtty).value), seif.tradelot)
        INTO l_TradeLotChk
        FROM securities_info seif
        WHERE seif.codeid = p_txmsg.txfields(c_codeid).value;
        IF l_TradeLotChk > 0  THEN
            p_err_code := errnums.C_OD_QTTY_TRADELOT_INCORRECT; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
    END IF;

   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck>>');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txAftAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppCheck;

FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppUpdate');
    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_newOrderID    varchar2(20);
    l_currdate      DATE;
    l_remainqtty    NUMBER;
    l_errreason     varchar2(2);
    l_trfbuydt      DATE;
    l_trfamt        NUMBER;
    l_trfqtty       NUMBER;
    l_txnum         varchar2(10);
    l_txdate        DATE;
    l_TRFBUYAMT     NUMBER;
    l_clearday      NUMBER;
    l_seacctno      varchar2(20);
    l_trfbuyfeeamt  NUMBER;
    l_buyfeeamt     NUMBER;
    l_corebank      char(1);
    l_custatcom      varchar2(10);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    SELECT getcurrdate INTO l_currdate FROM dual;

    SELECT od.remainqtty, od.errreason, nvl(sts.trfbuydt,l_currdate), sts.amt, sts.qtty
    INTO l_remainqtty, l_errreason, l_trfbuydt, l_trfamt, l_trfqtty
    FROM odmast od, stschd sts
    WHERE od.orderid = sts.orgorderid
        AND sts.duetype IN ('SM','SS') AND  od.orderid = p_txmsg.txfields(c_orderid).value;

    -- CAP NHAT LENH LOI DA HET HIEU LUC
    UPDATE ODMAST SET
        ORSTATUS = '3',
        CANCELQTTY = CANCELQTTY + REMAINQTTY,
        REMAINQTTY = 0
    WHERE ORDERID = p_txmsg.txfields(c_orderid).value;

    -- Xoa lenh trong OOD
    UPDATE OOD SET
        DELTD = 'Y'
    WHERE ORGORDERID = p_txmsg.txfields(c_orderid).value;

    select corebank into l_corebank from cimast where acctno =p_txmsg.txfields(c_afacctno).value;
    SELECT custatcom INTO l_custatcom FROM cfmast WHERE custodycd = p_txmsg.txfields(c_custodycd).value;
    -- Neu lenh tu ngay truoc thi revert lai tien/CK
    l_seacctno := p_txmsg.txfields(c_afacctno).value || p_txmsg.txfields(c_codeid).value;
    IF l_currdate <> to_date(p_txmsg.txfields(c_txdate).value,'DD/MM/YYYY') AND l_custatcom = 'Y' THEN
        IF p_txmsg.txfields(c_exectype).value IN ('NS','MS','SS') THEN
            IF p_txmsg.txfields(c_exectype).value = 'MS' THEN
                UPDATE SEMAST SET
                    NETTING = NETTING - l_remainqtty,
                    PREVQTTY = PREVQTTY + l_remainqtty,
                    MORTAGE = MORTAGE + l_remainqtty
                WHERE ACCTNO = l_seacctno;
                -- MORTAGE
                INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_seacctno,'0065',l_remainqtty,NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
            ELSE
                UPDATE SEMAST SET
                    TRADE = TRADE + l_remainqtty,
                    NETTING = NETTING - l_remainqtty,
                    PREVQTTY = PREVQTTY + l_remainqtty
                WHERE ACCTNO = l_seacctno;
                -- Insert to SETRAN
                -- TRADE
                INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_seacctno,'0012',l_remainqtty,NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
            END IF;

            -- NETTING
            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_seacctno,'0020',l_remainqtty,NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
            -- PREVQTTY
            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_seacctno,'0063',l_remainqtty,NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            UPDATE cimast SET
                RECEIVING = RECEIVING - l_trfamt
            WHERE acctno = p_txmsg.txfields(c_afacctno).value;
            -- INSERT TO CITRAN
            -- RECEIVING
            INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields (c_afacctno).value,'0045',l_trfamt,NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            -- Cap nhat them de tinh gia von
            -- TheNN, 25-Mar-2014
            UPDATE semast SET
                DDROUTQTTY = DDROUTQTTY - (l_trfqtty),
                DDROUTAMT = DDROUTAMT - (l_trfamt - l_buyfeeamt)
            WHERE ACCTNO = l_seacctno;
            -- Insert to SETRAN
            -- DCRQTTY
            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_seacctno,'0068',-(l_trfqtty),NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,to_date(p_txmsg.txfields(c_txdate).value,'DD/MM/YYYY'),'' || '' || '');
            -- DCRAMT
            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_seacctno,'0067',-(l_trfamt - l_buyfeeamt),NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,to_date(p_txmsg.txfields(c_txdate).value,'DD/MM/YYYY'),'' || '' || '');
            -- Ket thuc: Cap nhat them de tinh gia von

           /*
            -- Lay thong tin GD chuyen CK de xoa GD
            SELECT max(se.txnum), max(se.txdate)
            INTO l_txnum, l_txdate
            FROM setran_gen se
            WHERE se.field = 'TRFBUYAMT' AND se.acctno = p_txmsg.txfields(c_afacctno).value || p_txmsg.txfields(c_codeid).value
                AND se.acctref = p_txmsg.txfields(c_orderid).value AND se.tltxcd IN ('8867','8823');
            -- Xoa GD chuyen CK
            UPDATE tllogall SET
                deltd = 'Y'
            WHERE txdate = l_txdate AND txnum = l_txnum;
            UPDATE citrana SET
                deltd = 'Y'
            WHERE txdate = l_txdate AND txnum = l_txnum;
            UPDATE citran_gen SET
                deltd = 'Y'
            WHERE txdate = l_txdate AND txnum = l_txnum;
            UPDATE setrana SET
                deltd = 'Y'
            WHERE txdate = l_txdate AND txnum = l_txnum;
            UPDATE setran_gen SET
                deltd = 'Y'
            WHERE txdate = l_txdate AND txnum = l_txnum;
            */
        END IF;

        IF p_txmsg.txfields(c_exectype).value IN ('NB') THEN
            UPDATE SEMAST SET
                RECEIVING = RECEIVING - l_trfqtty
            WHERE AFACCTNO = p_txmsg.txfields(c_afacctno).value AND CODEID = p_txmsg.txfields(c_codeid).value;
            -- Insert to SETRAN
            -- TRADE
            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_seacctno,'0015',l_trfqtty,NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            -- Lay thong tin GD chuyen tien de xoa GD
            SELECT max(cit.txnum), max(cit.txdate), NVL(max(cit.namt),0)
            INTO l_txnum, l_txdate, l_TRFBUYAMT
            FROM citran_gen cit
            WHERE cit.field = 'TRFBUYAMT' AND cit.acctno = p_txmsg.txfields(c_afacctno).value
                AND cit.acctref = p_txmsg.txfields(c_orderid).value AND cit.tltxcd IN ('8865','8821');

            -- Lay thong tin GD thu phi GD mua
            SELECT nvl(ci.buyfee,0), nvl(ci.trfbuyfee,0)
            INTO l_buyfeeamt, l_trfbuyfeeamt
            FROM (SELECT sum(decode(cit.field,'BALANCE',nvl(cit.namt,0),0)) buyfee,
                        sum(decode(cit.field,'TRFBUYAMT',nvl(cit.namt,0),0)) trfbuyfee
                    FROM citran_gen cit
                    WHERE cit.tltxcd = '8855' AND cit.acctno = p_txmsg.txfields(c_afacctno).value
                        AND cit.acctref = p_txmsg.txfields(c_orderid).value) ci;

            UPDATE cimast SET
                NETTING = NETTING - l_trfamt,
                --TRFAMT = TRFAMT - l_trfamt,
                TRFBUYAMT = TRFBUYAMT - l_TRFBUYAMT - l_trfbuyfeeamt,
                FACRTRADE = FACRTRADE - l_buyfeeamt,
                BALANCE = BALANCE + l_buyfeeamt * (case when l_corebank='Y' then 0 else 1 end)
            WHERE acctno = p_txmsg.txfields(c_afacctno).value;
            -- INSERT TO CITRAN
            -- NETTING
            INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields (c_afacctno).value,'0047',l_trfamt,NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
            -- TRFAMT
            --INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            --VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields (c_afacctno).value,'0069',l_trfamt,NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
            -- TRFBUYAMT
            INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields (c_afacctno).value,'0082',l_TRFBUYAMT+l_trfbuyfeeamt,NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
            -- FACRTRADE
            INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields (c_afacctno).value,'0036',l_buyfeeamt,NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
            -- BALANCE
            IF l_buyfeeamt > 0 THEN
                INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields (c_afacctno).value,'0012',l_buyfeeamt,NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
                --Doan xu ly ghi vao corebank nay neu sua thi bao lai de xem xet phan chinh sua day bang ke sang ngan hang
                if l_corebank='Y' then --Neu tai khoan corebank thi Cat tien di ngay
                    INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields (c_afacctno).value,'0011',l_buyfeeamt,NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
                end if;
            END IF;

            -- TK tra cham chua thanh toan thi ko update balance
            --IF l_trfbuydt = to_date(p_txmsg.txfields(c_txdate).value,'DD/MM/YYYY') THEN
            IF l_trfbuydt < l_currdate THEN
                UPDATE cimast SET
                    BALANCE = BALANCE + l_trfamt * (case when l_corebank='Y' then 0 else 1 end)
                WHERE acctno = p_txmsg.txfields(c_afacctno).value;
                -- INSERT TO CITRAN
                -- BALANCE
                INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields (c_afacctno).value,'0012',l_trfamt,NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
                --Doan xu ly ghi vao corebank nay neu sua thi bao lai de xem xet phan chinh sua day bang ke sang ngan hang
                if l_corebank='Y' then --Neu tai khoan corebank thi Cat tien di ngay
                    INSERT INTO CITRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields (c_afacctno).value,'0011',l_trfamt,NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
                end if;
            END IF;

            -- Cap nhat them de tinh gia von
            -- TheNN, 25-Mar-2014
            UPDATE semast SET
                DCRQTTY = DCRQTTY + (-l_trfqtty),
                DCRAMT = DCRAMT + (-l_trfamt - l_buyfeeamt)
            WHERE ACCTNO = l_seacctno;
            -- Insert to SETRAN
            -- DCRQTTY
            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_seacctno,'0052',(-l_trfqtty),NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,to_date(p_txmsg.txfields(c_txdate).value,'DD/MM/YYYY'),'' || '' || '');
            -- DCRAMT
            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_seacctno,'0051',(-l_trfamt - l_buyfeeamt),NULL,p_txmsg.txfields (c_afacctno).value,p_txmsg.deltd,p_txmsg.txfields (c_afacctno).value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,to_date(p_txmsg.txfields(c_txdate).value,'DD/MM/YYYY'),'' || '' || '');
            -- Ket thuc: Cap nhat them de tinh gia von


            /*
            -- Xoa GD 8865
            UPDATE tllogall SET
                deltd = 'Y'
            WHERE txdate = l_txdate AND txnum = l_txnum;
            UPDATE citrana SET
                deltd = 'Y'
            WHERE txdate = l_txdate AND txnum = l_txnum;
            UPDATE citran_gen SET
                deltd = 'Y'
            WHERE txdate = l_txdate AND txnum = l_txnum;
            UPDATE setrana SET
                deltd = 'Y'
            WHERE txdate = l_txdate AND txnum = l_txnum;
            UPDATE setran_gen SET
                deltd = 'Y'
            WHERE txdate = l_txdate AND txnum = l_txnum;*/
        END IF;
    END IF;

    -- Xac dinh lich thanh toan cho lenh moi
    SELECT fn_get_date_diff(l_currdate, to_date(p_txmsg.txfields(c_cleardate).value,'DD/MM/YYYY'), 'B') - 1
    INTO l_clearday
    FROM dual;

    -- Dat lenh moi vao TK tu doanh
    IF to_number(p_txmsg.txfields(c_tdorderqtty).value) > 0 THEN
        IF fn_PlaceOrder (p_txmsg,
                          p_txmsg.txfields(c_tdafacctno).value,
                          to_number(p_txmsg.txfields(c_tdorderqtty).value),
                          p_err_code,
                          l_newOrderID
                          ) <> systemnums.c_success
        THEN
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
        -- Cap nhat trang thai lenh moi sinh la da gui len san
        -- ODMAST
        UPDATE ODMAST SET
            ORSTATUS = '2',
            REFORDERID = p_txmsg.txfields(c_orderid).value,
            FERROD = 'Y',
            ERRSTS = 'N',
            ERRREASON = l_errreason,
            FIXERRTYPE = p_txmsg.txfields(c_fixerrtype).value
            --,
            --CLEARDAY = l_clearday
        WHERE ORDERID = l_newOrderID;
        -- OOD
        UPDATE OOD SET
            OODSTATUS = 'S'
        WHERE ORGORDERID = l_newOrderID;

        -- Goi ham khop lenh moi vua tao ra
        IF fn_Match_Order (l_newOrderID,
                          p_txmsg.txfields(c_orderid).value,
                          to_number(p_txmsg.txfields(c_tdorderqtty).value),
                          to_number(p_txmsg.txfields(c_quoteprice).value),
                          p_err_code
                          ) <> systemnums.c_success
        THEN
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
    END IF;

    -- Dat lenh moi vao TK thong thuong
    IF to_number(p_txmsg.txfields(c_orderqtty).value) > 0 THEN
        IF fn_PlaceOrder (p_txmsg,
                          p_txmsg.txfields(c_afacctno).value,
                          to_number(p_txmsg.txfields(c_orderqtty).value),
                          p_err_code,
                          l_newOrderID
                          ) <> systemnums.c_success
        THEN
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
        -- Cap nhat trang thai lenh moi sinh la da gui len san
        -- ODMAST
        UPDATE ODMAST SET
            ORSTATUS = '2',
            REFORDERID = p_txmsg.txfields(c_orderid).value,
            FERROD = 'Y',
            ERRSTS = 'N',
            ERRREASON = l_errreason,
            FIXERRTYPE = p_txmsg.txfields(c_fixerrtype).value
            --,
            --CLEARDAY = l_clearday
        WHERE ORDERID = l_newOrderID;
        -- OOD
        UPDATE OOD SET
            OODSTATUS = 'S'
        WHERE ORGORDERID = l_newOrderID;

        -- Goi ham khop lenh moi vua tao ra
        IF fn_Match_Order (l_newOrderID,
                          p_txmsg.txfields(c_orderid).value,
                          to_number(p_txmsg.txfields(c_orderqtty).value),
                          to_number(p_txmsg.txfields(c_quoteprice).value),
                          p_err_code
                          ) <> systemnums.c_success
        THEN
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
    END IF;

    -- Goi ham danh dau lai
    if fn_markedafpralloc(p_txmsg.txfields(c_afacctno).value,
                            null,
                            'A',
                            'T',
                            null,
                            'N',
                            'N',
                            l_currdate,
                            null,
                            p_err_code) <> systemnums.C_SUCCESS then
                null;
    end if;

    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppUpdate;

-- HAM THUC HIEN DAT LENH MOI
FUNCTION fn_PlaceOrder
    (
        p_txmsg in tx.msg_rectype,
        p_afacctno  IN VARCHAR2,
        p_orderqtty IN  NUMBER,
        p_err_code out VARCHAR2,
        p_newOrderID OUT varchar2
    )
RETURN NUMBER
IS
    l_txmsg               tx.msg_rectype;
    l_err_param           deferror.errdesc%TYPE;
    l_orderqtty     NUMBER;
    l_quoteprice    NUMBER;
    l_codeid        varchar2(10);
    l_symbol        varchar2(20);
    l_actype        varchar2(4);
    l_clearday      NUMBER;
    l_typebratio    NUMBER;
    l_feeamountmin  NUMBER;
    l_feerate       NUMBER;
    l_securedratio  NUMBER;
    l_afbratio  NUMBER;
    l_securedratiomin NUMBER;
    l_securedratiomax   NUMBER;
    l_feesecureratiomin NUMBER;
    l_tradeunit     NUMBER;

    l_timetype      varchar2(10);
    l_pricetype      varchar2(10);
    l_matchtype      varchar2(10);
    l_tradeplace      varchar2(10);
    l_sectype      varchar2(10);
    l_nork      varchar2(10);
    l_afactype      varchar2(10);
    l_MarginType varchar2(10);
    l_afacctno  varchar2(10);
    l_fullname  varchar2(100);
    l_exectype  varchar2(2);
    l_isdiposal varchar2(1);
    l_parvalue  NUMBER;
    l_newOrderID    varchar2(20);
    l_orgtxdate    DATE;
    l_ptdeal varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_PlaceOrder');
    plog.debug (pkgctx, '<<BEGIN OF fn_PlaceOrder');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    -- Goi GD 8876, 8877 de sinh ra lenh moi
    -- Lay  thong tin lenh goc
    SELECT od.timetype, od.pricetype, od.matchtype, sb.tradeplace, sb.sectype, od.nork, --af.actype,
        seif.securedratiomin, seif.securedratiomax, sb.symbol, seif.tradeunit, od.isdisposal, sb.parvalue, od.txdate, od.ptdeal
        , od.clearday   --T2_HoangND add
    INTO l_timetype, l_pricetype, l_matchtype, l_tradeplace, l_sectype, l_nork, --l_afactype,
        l_securedratiomin, l_securedratiomax, l_symbol, l_tradeunit, l_isdiposal, l_parvalue,l_orgtxdate, l_ptdeal
        , l_clearday    --T2_HoangND add
    FROM odmast od, sbsecurities sb, afmast af, securities_info seif
    WHERE od.codeid = sb.codeid AND af.acctno = od.afacctno AND sb.codeid = seif.codeid
        AND od.orderid = p_txmsg.txfields(c_orderid).value;

    l_orderqtty := p_orderqtty;
    l_quoteprice := to_number(p_txmsg.txfields(c_quoteprice).value);
    l_codeid := p_txmsg.txfields(c_codeid).value;
    l_afacctno := p_afacctno;
    l_exectype := p_txmsg.txfields(c_exectype).value;
    -- NEU LENH GOC BAN CAM CO THI LENH SUA LOI KO CAN LA BAN CAM CO
    IF l_exectype = 'MS' THEN
        l_exectype := 'NS';
    END IF;
    -- Lay thong tin tieu khoan
    SELECT mrt.mrtype, af.bratio, af.actype
    INTO l_MarginType, l_afbratio, l_afactype
    FROM afmast af, mrtype mrt, aftype aft
    WHERE af.actype = aft.actype AND aft.mrtype = mrt.actype
        AND af.acctno = l_afacctno;

    -- Tinh ty le ky quy
    BEGIN
        SELECT actype, /*clearday, T2_HoangND rao*/bratio, minfeeamt, deffeerate
        --to_char(sysdate,systemnums.C_TIME_FORMAT) TXTIME
        INTO l_actype,                 --ACTYPE
           --l_clearday,               --CLEARDAY           --T2_HoangND rao
           l_typebratio,                          --BRATIO (fld13)
           l_feeamountmin,
           l_feerate
        FROM (SELECT a.actype, a.clearday, a.bratio, a.minfeeamt, a.deffeerate, b.ODRNUM
        FROM odtype a, afidtype b
        WHERE     a.status = 'Y'
            AND (a.via = 'F' OR a.via = 'A') --VIA
            AND a.clearcd = 'B'       --CLEARCD
            AND (a.exectype = l_exectype
                 OR a.exectype = 'AA')                    --EXECTYPE
            AND (a.timetype = l_timetype
                 OR a.timetype = 'A')                     --TIMETYPE
            AND (a.pricetype = l_pricetype
                 OR a.pricetype = 'AA')                  --PRICETYPE
            AND (a.matchtype = l_matchtype
                 OR a.matchtype = 'A')                   --MATCHTYPE
            AND (a.tradeplace = l_tradeplace
                 OR a.tradeplace = '000')
            AND (instr(case when l_sectype in ('001','002','011') then l_sectype || ',' || '111,333'
                           when l_sectype in ('003','006') then l_sectype || ',' || '222,333,444'
                           when l_sectype in ('008') then l_sectype || ',' || '111,444'
                           else l_sectype end, a.sectype)>0 OR a.sectype = '000')
            AND (a.nork = l_nork OR a.nork = 'A') --NORK
            AND (CASE WHEN A.CODEID IS NULL THEN l_codeid ELSE A.CODEID END)= l_codeid
            AND a.actype = b.actype and b.aftype = l_afactype and b.objname='OD.ODTYPE'
            order BY A.deffeerate , B.ACTYPE DESC -- Lay ti le phi nho nhat
        ) where rownum<=1;
    EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
    RAISE errnums.e_od_odtype_notfound;
    END;
    if l_MarginType='S' or l_MarginType='T' or l_MarginType='N' then
       --Tai khoan margin va tai khoan binh thuong ky quy 100%
        l_securedratio:=100;
    elsif l_MarginType='L' then --Cho tai khoan margin loan
        begin
            select (case when nvl(dfprice,0)>0 then least(nvl(dfrate,0),round(nvl(dfprice,0)/ l_quoteprice/l_tradeunit * 100,4)) else nvl(dfrate,0) end ) dfrate
            into l_securedratio
            from (select * from dfbasket where symbol = l_symbol) bk,
                aftype aft, dftype dft,afmast af
            where af.actype = aft.actype and aft.dftype = dft.actype and dft.basketid = bk.basketid (+)
            and af.acctno = l_afacctno;
            l_securedratio:=greatest (100-l_securedratio,0);
        exception
        when others then
             l_securedratio:=100;
        end;
    else
        l_securedratio                    :=
        GREATEST (LEAST (l_typebratio + l_afbratio, 100),
                l_securedratiomin
        );
        l_securedratio                    :=
          CASE
             WHEN l_securedratio > l_securedratiomax
             THEN
                l_securedratiomax
             ELSE
                l_securedratio
          END;
    end if;

    --FeeSecureRatioMin = mv_dblFeeAmountMin * 100 / (CDbl(v_strQUANTITY) * CDbl(v_strQUOTEPRICE) * CDbl(v_strTRADEUNIT))
    l_feesecureratiomin               :=
      l_feeamountmin * 100
      / (  TO_NUMBER (l_orderqtty)         --quantity
         * TO_NUMBER (l_quoteprice)       --quoteprice
         * TO_NUMBER (l_tradeunit));      --tradeunit

    IF l_feesecureratiomin > l_feerate
    THEN
      l_securedratio   := l_securedratio + l_feesecureratiomin;
    ELSE
      l_securedratio   := l_securedratio + l_feerate;
    END IF;

    -- Set gia tri cho cac truong GD
    -- 1. Set common values
    l_txmsg.brid        := p_txmsg.brid; -- systemnums.c_ho_brid;
    l_txmsg.tlid        :=  systemnums.c_system_userid;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'AUTO';

    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
        SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.txtime := TO_CHAR (SYSDATE, systemnums.c_time_format);
    l_txmsg.chktime                   := l_txmsg.txtime;
    l_txmsg.offtime                   := l_txmsg.txtime;
    l_txmsg.tlid   := p_txmsg.tlid;

    --2.3 Set txdate
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
    INTO l_txmsg.txdate
    FROM sysvar
    WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    l_txmsg.txdate                    := l_orgtxdate;
    l_txmsg.brdate                    := l_orgtxdate;-- l_txmsg.txdate;
    l_txmsg.busdate                   := l_orgtxdate; --l_txmsg.txdate;

    --2.4 Set fld value
    l_txmsg.txfields ('01').defname   := 'CODEID';
    l_txmsg.txfields ('01').TYPE      := 'C';
    l_txmsg.txfields ('01').VALUE     := l_codeid; --set vale for CODEID

    l_txmsg.txfields ('07').defname   := 'SYMBOL';
    l_txmsg.txfields ('07').TYPE      := 'C';
    l_txmsg.txfields ('07').VALUE     := l_symbol; --set vale for Symbol

    l_txmsg.txfields ('60').defname   := 'ISMORTAGE';
    l_txmsg.txfields ('60').TYPE      := 'N';
    l_txmsg.txfields ('60').VALUE     := CASE WHEN l_exectype='MS' THEN '1' ELSE '0' end; --set vale for Is mortage sell

    l_txmsg.txfields ('02').defname   := 'ACTYPE';
    l_txmsg.txfields ('02').TYPE      := 'C';
    l_txmsg.txfields ('02').VALUE     := l_actype; --set vale for Product code

    l_txmsg.txfields ('03').defname   := 'AFACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := l_afacctno; --set vale for Contract number

    l_txmsg.txfields ('06').defname   := 'SEACCTNO';
    l_txmsg.txfields ('06').TYPE      := 'C';
    l_txmsg.txfields ('06').VALUE     := l_afacctno || l_codeid; --set vale for SE account number

    l_txmsg.txfields ('50').defname   := 'CUSTNAME';
    l_txmsg.txfields ('50').TYPE      := 'C';
    l_txmsg.txfields ('50').VALUE     := l_fullname; --set vale for Customer name

    l_txmsg.txfields ('20').defname   := 'TIMETYPE';
    l_txmsg.txfields ('20').TYPE      := 'C';
    l_txmsg.txfields ('20').VALUE     := l_timetype; --set vale for Duration

    l_txmsg.txfields ('21').defname   := 'EXPDATE';
    l_txmsg.txfields ('21').TYPE      := 'D';
    l_txmsg.txfields ('21').VALUE     := l_orgtxdate; --l_txmsg.txdate; --set vale for Expired date

    l_txmsg.txfields ('19').defname   := 'EFFDATE';
    l_txmsg.txfields ('19').TYPE      := 'D';
    l_txmsg.txfields ('19').VALUE     := l_orgtxdate; --l_txmsg.txdate; --set vale for Expired date

    l_txmsg.txfields ('22').defname   := 'EXECTYPE';
    l_txmsg.txfields ('22').TYPE      := 'C';
    l_txmsg.txfields ('22').VALUE     := l_exectype; --set vale for Execution type

    l_txmsg.txfields ('23').defname   := 'NORK';
    l_txmsg.txfields ('23').TYPE      := 'C';
    l_txmsg.txfields ('23').VALUE     := l_nork; --set vale for All or none?

    l_txmsg.txfields ('34').defname   := 'OUTPRICEALLOW';
    l_txmsg.txfields ('34').TYPE      := 'C';
    l_txmsg.txfields ('34').VALUE     := 'N'; --set vale for Accept out amplitute price

    l_txmsg.txfields ('24').defname   := 'MATCHTYPE';
    l_txmsg.txfields ('24').TYPE      := 'C';
    l_txmsg.txfields ('24').VALUE     := l_matchtype; --set vale for Matching type

    l_txmsg.txfields ('25').defname   := 'VIA';
    l_txmsg.txfields ('25').TYPE      := 'C';
    l_txmsg.txfields ('25').VALUE     := 'F'; --set vale for Via

    l_txmsg.txfields ('10').defname   := 'CLEARDAY';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := l_clearday; --set vale for Clearing day

    l_txmsg.txfields ('26').defname   := 'CLEARCD';
    l_txmsg.txfields ('26').TYPE      := 'C';
    l_txmsg.txfields ('26').VALUE     := 'B'; --set vale for Calendar

    l_txmsg.txfields ('72').defname   := 'PUTTYPE';
    l_txmsg.txfields ('72').TYPE      := 'C';
    l_txmsg.txfields ('72').VALUE     := 'O'; --set vale for Puthought type

    l_txmsg.txfields ('27').defname   := 'PRICETYPE';
    l_txmsg.txfields ('27').TYPE      := 'C';
    l_txmsg.txfields ('27').VALUE     := l_pricetype; --set vale for Price type

    l_txmsg.txfields ('11').defname   := 'QUOTEPRICE';
    l_txmsg.txfields ('11').TYPE      := 'N';
    l_txmsg.txfields ('11').VALUE     := l_quoteprice/l_tradeunit; --set vale for Limit price

    l_txmsg.txfields ('12').defname   := 'ORDERQTTY';
    l_txmsg.txfields ('12').TYPE      := 'N';
    l_txmsg.txfields ('12').VALUE     := l_orderqtty; --set vale for Quantity

    l_txmsg.txfields ('13').defname   := 'BRATIO';
    l_txmsg.txfields ('13').TYPE      := 'N';
    l_txmsg.txfields ('13').VALUE     := l_securedratio; --set vale for Block ration

    l_txmsg.txfields ('14').defname   := 'LIMITPRICE';
    l_txmsg.txfields ('14').TYPE      := 'N';
    l_txmsg.txfields ('14').VALUE     := l_quoteprice; --set vale for Stop price

    IF l_exectype IN ('NS', 'MS', 'SS') THEN --gc_OD_PLACENORMALSELLORDER_ADVANCED
        --HaiLT them cho GRPORDER
        l_txmsg.txfields ('55').defname   := 'GRPORDER';
        l_txmsg.txfields ('55').TYPE      := 'C';
        l_txmsg.txfields ('55').VALUE     := 'N';
    END IF;

    l_txmsg.txfields ('40').defname   := 'FEEAMT';
    l_txmsg.txfields ('40').TYPE      := 'N';
    --l_txmsg.txfields ('40').VALUE     := l_build_msg.fld40; --set vale for Fee amount

    l_txmsg.txfields ('28').defname   := 'VOUCHER';
    l_txmsg.txfields ('28').TYPE      := 'C';
    l_txmsg.txfields ('28').VALUE     := ''; --l_build_msg.fld28; --set vale for Voucher status

    l_txmsg.txfields ('29').defname   := 'CONSULTANT';
    l_txmsg.txfields ('29').TYPE      := 'C';
    l_txmsg.txfields ('29').VALUE     := ''; --l_build_msg.fld29; --set vale for Consultant status

    l_txmsg.txfields ('04').defname   := 'ORDERID';
    l_txmsg.txfields ('04').TYPE      := 'C';
    --l_txmsg.txfields ('04').VALUE     := l_build_msg.fld04; --set vale for Order ID
    --this is set below
    l_txmsg.txfields ('15').defname   := 'PARVALUE';
    l_txmsg.txfields ('15').TYPE      := 'N';
    l_txmsg.txfields ('15').VALUE     := l_parvalue; --set vale for Parvalue

    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    --l_txmsg.txfields ('30').VALUE     := l_build_msg.fld30; --set vale for Description

    l_txmsg.txfields ('95').defname   := 'DFACCTNO';
    l_txmsg.txfields ('95').TYPE      := 'C';
    l_txmsg.txfields ('95').VALUE     := ''; --set vale for deal id

    l_txmsg.txfields ('94').defname   := 'SSAFACCTNO';
    l_txmsg.txfields ('94').TYPE      := 'C';
    l_txmsg.txfields ('94').VALUE     := ''; --set vale for short sale account

    l_txmsg.txfields ('99').defname   := 'HUNDRED';
    l_txmsg.txfields ('99').TYPE      := 'N';
    l_txmsg.txfields ('99').VALUE     := 100;
    /*If l_MarginType = 'N' Then
        l_txmsg.txfields ('99').VALUE     := 100;
    Else
        If l_dblIsPPUsed = 1 Then
            l_txmsg.txfields ('99').VALUE     := to_char(100 / (1 - l_dblMarginRatioRate / 100 * l_dblSecMarginPrice / l_build_msg.fld11 / l_build_msg.fld98));
        Else
            l_txmsg.txfields ('99').VALUE     := l_build_msg.fld99;
        End If;
    End If;*/

    l_txmsg.txfields ('98').defname   := 'TRADEUNIT';
    l_txmsg.txfields ('98').TYPE      := 'N';
    l_txmsg.txfields ('98').VALUE     := l_tradeunit; --set vale for Trade unit

    l_txmsg.txfields ('96').defname   := 'TRADEUNIT';
    l_txmsg.txfields ('96').TYPE      := 'N';
    l_txmsg.txfields ('96').VALUE     := 1; --l_build_msg.fld96; --set vale for GTC

    l_txmsg.txfields ('97').defname   := 'MODE';
    l_txmsg.txfields ('97').TYPE      := 'C';
    l_txmsg.txfields ('97').VALUE     := ''; --set vale for MODE DAT LENH

    l_txmsg.txfields ('33').defname   := 'CLIENTID';
    l_txmsg.txfields ('33').TYPE      := 'C';
    l_txmsg.txfields ('33').VALUE     := ''; --set vale for ClientID

    l_txmsg.txfields ('73').defname   := 'CONTRAFIRM';
    l_txmsg.txfields ('73').TYPE      := 'C';
    l_txmsg.txfields ('73').VALUE     := ''; --set vale for Contrafirm

    l_txmsg.txfields ('32').defname   := 'TRADERID';
    l_txmsg.txfields ('32').TYPE      := 'C';
    l_txmsg.txfields ('32').VALUE     := ''; --set vale for TraderID

    l_txmsg.txfields ('71').defname   := 'CONTRACUS';
    l_txmsg.txfields ('71').TYPE      := 'C';
    l_txmsg.txfields ('71').VALUE     := ''; --l_build_msg.fld71; --set vale for Contra custody

    l_txmsg.txfields ('74').defname   := 'ISDISPOSAL';
    l_txmsg.txfields ('74').TYPE      := 'C';
    l_txmsg.txfields ('74').VALUE     := l_isdiposal;

    l_txmsg.txfields ('31').defname   := 'CONTRAFIRM';
    l_txmsg.txfields ('31').TYPE      := 'C';
    l_txmsg.txfields ('31').VALUE     := ''; --set vale for Contrafirm
    -- DUcnv sua hnx
    l_txmsg.txfields ('80').defname   := 'QUOTEQTTY';
    l_txmsg.txfields ('80').TYPE      := 'N';
    l_txmsg.txfields ('80').VALUE     := 0;

    l_txmsg.txfields ('81').defname   := 'PTDEAL';
    l_txmsg.txfields ('81').TYPE      := 'C';
    l_txmsg.txfields ('81').VALUE     := l_ptdeal;

    --SAVEPOINT sp#2;
    -- SET FEE AMOUNT
    l_txmsg.txfields ('40').VALUE     :=
        greatest(l_feerate/100 * TO_NUMBER (l_orderqtty)
        * TO_NUMBER (l_quoteprice),l_feeamountmin);

    --2.1 Set txnum
    SELECT systemnums.c_fo_prefixed
         || LPAD (seq_fotxnum.NEXTVAL, 8, '0')
    INTO l_txmsg.txnum
    FROM DUAL;
    -- Order ID
    SELECT    systemnums.c_fo_prefixed
         || '00'
         || TO_CHAR(TO_DATE (VARVALUE, 'DD\MM\RR'),'DDMMRR')
         || LPAD (seq_odmast.NEXTVAL, 6, '0')
    INTO l_newOrderID
    FROM SYSVAR WHERE VARNAME ='CURRDATE' AND GRNAME='SYSTEM';
    l_txmsg.txfields ('04').VALUE := l_newOrderID;

    SELECT REGEXP_REPLACE (l_txmsg.txfields ('04').VALUE,
                         '(^[[:digit:]]{4})([[:digit:]]{2})([[:digit:]]{10}$)',
                         '\1.\2.\3.'
         )
         || l_fullname
         || '.'
         || l_txmsg.txfields ('24').VALUE          --MATCHTYPE
         || l_txmsg.txfields ('22').VALUE       ---ORGEXECTYPE
         || '.'
         || l_txmsg.txfields ('07').VALUE             --SYMBOL
         || '.'
         || l_txmsg.txfields ('12').VALUE
         || '.'
         || l_txmsg.txfields ('11').VALUE         --QUOTEPRICE
    INTO l_txmsg.txfields ('30').VALUE
    FROM DUAL;

    /*INSERT INTO rootordermap
    (
     foacctno,
     orderid,
     status,
     MESSAGE,
     id
    )
    VALUES (
            l_build_msg.acctno,
            l_txmsg.txfields ('04').VALUE,
            'A',
            '[' || systemnums.c_success || '] OK,',
            l_order_count
         );*/

    -- Get tltxcd from EXECTYPE
    IF l_exectype = 'NB' THEN
        BEGIN
            l_txmsg.tltxcd   := '8876'; -- gc_OD_PLACENORMALBUYORDER_ADVANCED
            -- 2: Process
            IF txpks_#8876.fn_autotxprocess (l_txmsg,
                                             p_err_code,
                                             l_err_param
               ) <> systemnums.c_success
            THEN
               plog.debug (pkgctx,
                           'got error 8876: ' || p_err_code
               );
               --ONLY ROLLBACK FOR THIS MESSAGE
               --ROLLBACK TO SAVEPOINT sp#2;
               --EXIT; -- UNCOMMENT THIS IF YOU WANT TO EXIT LOOP WHEN GOT AN ERROR
               --RAISE errnums.e_biz_rule_invalid;

               RETURN errnums.C_SYSTEM_ERROR;
            END IF;
        END;                                               --8876
    ELSIF l_exectype IN ('NS', 'MS', 'SS') THEN
        BEGIN
            l_txmsg.tltxcd   := '8877'; --gc_OD_PLACENORMALSELLORDER_ADVANCED

            -- 2: Process
            IF txpks_#8877.fn_autotxprocess (l_txmsg,
                                             p_err_code,
                                             l_err_param
               ) <> systemnums.c_success
            THEN
               plog.error (pkgctx,
                              '8877: '
                           || p_err_code
                           || ':'
                           || l_err_param
               );
               --ONLY ROLLBACK FOR THIS MESSAGE
               --ROLLBACK TO SAVEPOINT sp#2;
               --EXIT; -- UNCOMMENT THIS IF YOU WANT TO EXIT LOOP WHEN GOT AN ERROR
               --RAISE errnums.e_biz_rule_invalid;

               RETURN errnums.C_SYSTEM_ERROR;
            END IF;
         END;                                             -- 8887
    END IF;

    p_newOrderID := l_newOrderID;

    plog.debug (pkgctx, '<<END OF fn_PlaceOrder');
    plog.setendsection (pkgctx, 'fn_PlaceOrder');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_PlaceOrder');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_PlaceOrder;

FUNCTION fn_Match_Order (
   p_orderid        IN   VARCHAR2,
   p_orgorderid     IN   VARCHAR2,
   p_matchqtty      IN   number,
   p_matchprice     IN   number,
   p_err_code       out  VARCHAR2
)
RETURN number
IS
   v_tltxcd             VARCHAR2 (30);
   v_txnum              VARCHAR2 (30);
   v_txdate             VARCHAR2 (30);
   v_tlid               VARCHAR2 (30);
   v_brid               VARCHAR2 (30);
   v_ipaddress          VARCHAR2 (30);
   v_wsname             VARCHAR2 (30);
   v_txtime             VARCHAR2 (30);
   mv_strorgorderid     VARCHAR2 (30);
   mv_strcodeid         VARCHAR2 (30);
   mv_strsymbol         VARCHAR2 (30);
   mv_strcustodycd      VARCHAR2 (30);
   mv_strbors           VARCHAR2 (30);
   mv_strnorp           VARCHAR2 (30);
   mv_straorn           VARCHAR2 (30);
   mv_strafacctno       VARCHAR2 (30);
   mv_strciacctno       VARCHAR2 (30);
   mv_strseacctno       VARCHAR2 (30);
   mv_reforderid        VARCHAR2 (30);
   mv_refcustcd         VARCHAR2 (30);
   mv_strclearcd        VARCHAR2 (30);
   mv_strexprice        NUMBER (10);
   mv_strexqtty         NUMBER (10);
   mv_strprice          NUMBER (10);
   mv_strqtty           NUMBER (10);
   mv_strremainqtty     NUMBER (10);
   mv_strclearday       NUMBER (10);
   mv_strsecuredratio   NUMBER (10,2);
   mv_strconfirm_no     VARCHAR2 (30);
   mv_strmatch_date     VARCHAR2 (30);
   mv_desc              VARCHAR2 (30);
   v_strduetype         VARCHAR (2);
   v_matched            NUMBER (10,2);
   v_ex                 EXCEPTION;
   v_err                VARCHAR2 (100);
   v_temp               NUMBER(10);
   v_refconfirmno       VARCHAR2 (30);
   v_order_number       VARCHAR2(30);
   mv_mtrfday                NUMBER(10);

   mv_strtradeplace      VARCHAR2(3);
   mv_dbltrfbuyext      number(20,0);
   mv_dbltrfbuyrate      number(20,4);
   mv_strtrfstatus      VARCHAR2(1);
   v_orderdate          DATE;

   /*Cursor c_Odmast(v_OrgOrderID Varchar2) Is
   SELECT FOACCTNO,REMAINQTTY,EXECQTTY,EXECAMT,CANCELQTTY,ADJUSTQTTY
   FROM ODMAST WHERE TIMETYPE ='G' AND ORDERID=v_OrgOrderID;
   vc_Odmast c_Odmast%Rowtype;*/


BEGIN
    -- LENH GOC CU KHOP GIA NAO THI LENH MOI SINH RA KHOP GIA VA KL TUONG UNG
    FOR REC IN
    (
        SELECT IOD.MATCHPRICE, SUM(IOD.matchqtty) MATCHQTTY
        FROM vw_iod_all IOD
        WHERE IOD.orgorderid = p_orgorderid
        GROUP BY IOD.orgorderid, IOD.matchprice
    )
    LOOP
        --0 lay cac tham so
        v_brid := '0000';
        v_tlid := '0000';
        v_ipaddress := 'HOST';
        v_wsname := 'HOST';
        v_tltxcd := '8804';

        mv_dbltrfbuyext:=0;
        mv_dbltrfbuyrate:=0;
        mv_strtrfstatus:='Y';

        SELECT    '8080' || SUBSTR ('000000' || seq_batchtxnum.NEXTVAL, LENGTH ('000000' || seq_batchtxnum.NEXTVAL) - 5, 6)
        INTO v_txnum
        FROM DUAL;

        SELECT TO_CHAR (SYSDATE, 'HH24:MI:SS') INTO v_txtime FROM DUAL;

        BEGIN
            SELECT varvalue
            INTO v_txdate
            FROM sysvar
            WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
        EXCEPTION
            WHEN OTHERS THEN
                v_err := SUBSTR ('sysvar ' || SQLERRM, 1, 100);
            RAISE v_ex;
        END;

        --Kiem tra doi da thuc hien khop voi confirm number hay chua, neu da khop exit

        /*BEGIN
            SELECT COUNT(ORGORDERID)
            INTO V_TEMP
            FROM IOD
            WHERE ORGORDERID = p_orderid
                --AND   CONFIRM_NO = TRIM(CONFIRM_NUMBER)
                AND IOD.deltd <>'Y';

            IF V_TEMP > 0 THEN
                RETURN errnums.C_OD_ERROR_ORDER_MATCHED;
            END IF;
        EXCEPTION
        WHEN OTHERS THEN
            p_err_code := errnums.C_SYSTEM_ERROR;
            plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
            plog.setendsection (pkgctx, 'fn_Match_Order');
            RAISE errnums.E_SYSTEM_ERROR;
        END;*/

        --TungNT modified - for T2 late send money
        BEGIN
            SELECT od.remainqtty, sb.codeid, sb.symbol, ood.custodycd,
                 ood.bors, ood.norp, ood.aorn, od.afacctno,
                 od.ciacctno, od.seacctno, '', '',
                 od.clearcd, ood.price, ood.qtty, REC.matchprice, --p_matchprice,
                 REC.matchqtty, /*p_matchqtty,*/ od.clearday, od.bratio,
                 v_txdate, '', typ.mtrfday,
                 ss.tradeplace,af.trfbuyext, af.trfbuyrate, od.txdate
            INTO mv_strremainqtty, mv_strcodeid, mv_strsymbol, mv_strcustodycd,
                 mv_strbors, mv_strnorp, mv_straorn, mv_strafacctno,
                 mv_strciacctno, mv_strseacctno, mv_reforderid, mv_refcustcd,
                 mv_strclearcd, mv_strexprice, mv_strexqtty, mv_strprice,
                 mv_strqtty, mv_strclearday, mv_strsecuredratio,
                 mv_strmatch_date, mv_desc,mv_mtrfday,
                 mv_strtradeplace,mv_dbltrfbuyext, mv_dbltrfbuyrate, v_orderdate
            FROM odmast od, ood, securities_info sb,odtype typ,afmast af,sbsecurities ss
            WHERE od.orderid = ood.orgorderid and od.actype = typ.actype
                AND od.afacctno=af.acctno and od.codeid=ss.codeid
                AND od.codeid = sb.codeid
                AND orderid = p_orderid;
        EXCEPTION
            WHEN OTHERS THEN
                p_err_code := errnums.C_SYSTEM_ERROR;
                plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                plog.setendsection (pkgctx, 'fn_Match_Order');
                RAISE errnums.E_SYSTEM_ERROR;
        END;

        IF mv_dbltrfbuyext>0 THEN
            mv_strtrfstatus:='N';
        END IF;
        --End

        mv_desc := 'Matching order';

        IF mv_strremainqtty >= mv_strqtty THEN
            --thuc hien khop voi ket qua tra ve
            --1 them vao trong tllog
            INSERT INTO tllog
                      (autoid, txnum,
                       txdate, txtime, brid,
                       tlid, offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2,
                       tlid2, ccyusage, txstatus, msgacct, msgamt, chktime,
                       offtime, off_line, deltd, brdate,
                       busdate, msgsts, ovrsts, ipaddress,
                       wsname, batchname, txdesc
                      )
               VALUES (seq_tllog.NEXTVAL, v_txnum,
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), v_txtime, v_brid,
                       v_tlid, '', 'N', '', '', v_tltxcd, 'Y', '',
                       '', '', '1', p_orderid, mv_strqtty, '',
                       '', 'N', 'N', TO_DATE (v_txdate, 'DD/MM/YYYY'),
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), '', '', v_ipaddress,
                       v_wsname, 'DAY', mv_desc
                      );

            --tHEM VAO TRONG TLLOGFLD
            INSERT INTO tllogfld
                      (autoid, txnum,
                       txdate, fldcd, nvalue,
                       cvalue, txdesc
                      )
               VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), '03', 0,
                       p_orderid, NULL
                      );

            INSERT INTO tllogfld
                      (autoid, txnum,
                       txdate, fldcd, nvalue, cvalue,
                       txdesc
                      )
               VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), '80', 0, mv_strcodeid,
                       NULL
                      );

            INSERT INTO tllogfld
                      (autoid, txnum,
                       txdate, fldcd, nvalue, cvalue,
                       txdesc
                      )
               VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), '81', 0, mv_strsymbol,
                       NULL
                      );

            INSERT INTO tllogfld
                      (autoid, txnum,
                       txdate, fldcd, nvalue,
                       cvalue, txdesc
                      )
               VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), '82', 0,
                       mv_strcustodycd, NULL
                      );

            INSERT INTO tllogfld
                      (autoid, txnum,
                       txdate, fldcd, nvalue, cvalue,
                       txdesc
                      )
               VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), '04', 0, mv_strafacctno,
                       NULL
                      );

            INSERT INTO tllogfld
                      (autoid, txnum,
                       txdate, fldcd, nvalue, cvalue,
                       txdesc
                      )
               VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), '11', mv_strqtty, NULL,
                       NULL
                      );

            INSERT INTO tllogfld
                      (autoid, txnum,
                       txdate, fldcd, nvalue, cvalue,
                       txdesc
                      )
               VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), '10', mv_strprice, NULL,
                       NULL
                      );

            INSERT INTO tllogfld
                      (autoid, txnum,
                       txdate, fldcd, nvalue, cvalue, txdesc
                      )
               VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), '30', 0, mv_desc, NULL
                      );
            INSERT INTO tllogfld
                      (autoid, txnum,
                       txdate, fldcd, nvalue, cvalue, txdesc
                      )
               VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), '05', 0, mv_strafacctno, NULL
                      );

            IF mv_strbors = 'B' THEN
                INSERT INTO tllogfld
                      (autoid, txnum,
                       txdate, fldcd, nvalue, cvalue, txdesc
                      )
                VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), '86', mv_strprice*mv_strqtty, NULL, NULL
                      );

                INSERT INTO tllogfld
                      (autoid, txnum,
                       txdate, fldcd, nvalue, cvalue, txdesc
                      )
                VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), '87', mv_strqtty, NULL, NULL
                      );
            ELSE
                INSERT INTO tllogfld
                      (autoid, txnum,
                       txdate, fldcd, nvalue, cvalue, txdesc
                      )
                VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), '86', 0, NULL, NULL
                      );

                INSERT INTO tllogfld
                      (autoid, txnum,
                       txdate, fldcd, nvalue, cvalue, txdesc
                      )
                VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), '87', 0, NULL, NULL
                      );
            END IF;

            --3 THEM VAO TRONG IOD
            INSERT INTO iod
                      (orgorderid, codeid, symbol,
                       custodycd, bors, norp,
                       txdate, txnum, aorn,
                       price, qtty, exorderid, refcustcd,
                       matchprice, matchqtty, confirm_no,txtime
                      )
               VALUES (p_orderid, mv_strcodeid, mv_strsymbol,
                       mv_strcustodycd, mv_strbors, mv_strnorp,
                       TO_DATE (v_txdate, 'DD/MM/YYYY'), v_txnum, mv_straorn,
                       mv_strexprice, mv_strexqtty, mv_reforderid, mv_refcustcd,
                       mv_strprice, mv_strqtty, '',to_char(sysdate,'hh24:mi:ss')
                      );

                -- if instr('/NS/MS/SS/', :newval.exectype) > 0 then
            if mv_strbors = 'S' then
                -- quyet.kieu : Them cho LINHLNB 21/02/2012
                -- Begin Danh sau tai san LINHLNB
                INSERT INTO odchanging_trigger_log (AFACCTNO,CODEID,AMT,TXNUM,TXDATE,ERRCODE,LAST_CHANGE,ORDERID,ACTIONFLAG,QTTY)
                VALUES( mv_strafacctno,mv_strcodeid ,mv_strprice * mv_strqtty ,v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),NULL,systimestamp,p_orderid,'M',mv_strqtty);
                -- End Danh dau tai san LINHLNB
            end if;

            --4 CAP NHAT STSCHD
            SELECT COUNT (*)
            INTO v_matched
            FROM stschd
            WHERE orgorderid = p_orderid AND deltd <> 'Y';

            BEGIN
                IF mv_strbors = 'B' THEN                                                          --Lenh mua
                    --Tao lich thanh toan chung khoan
                    v_strduetype := 'RS';

                    IF v_matched > 0 THEN
                        UPDATE stschd SET
                            qtty = qtty + mv_strqtty,
                            amt = amt + mv_strprice * mv_strqtty
                        WHERE orgorderid = p_orderid AND duetype = v_strduetype;
                    ELSE
                        INSERT INTO stschd
                                (autoid, orgorderid, codeid,
                                 duetype, afacctno, acctno,
                                 reforderid, txnum,
                                 txdate, clearday,
                                 clearcd, amt, aamt,
                                 qtty, aqtty, famt, status, deltd, costprice, cleardate
                                )
                         VALUES (seq_stschd.NEXTVAL, p_orderid, mv_strcodeid,
                                 v_strduetype, mv_strafacctno, mv_strseacctno,
                                 mv_reforderid, v_txnum,
                                 v_orderdate, mv_strclearday,
                                 mv_strclearcd, mv_strprice * mv_strqtty, 0,
                                 mv_strqtty, 0, 0, 'N', 'N', 0, getduedate(v_orderdate,mv_strclearcd,'000',mv_strclearday)
                                );
                    END IF;
                    --Tao lich thanh toan tien
                    v_strduetype := 'SM';

                    IF v_matched > 0 THEN
                        UPDATE stschd SET
                            qtty = qtty + mv_strqtty,
                            amt = amt + mv_strprice * mv_strqtty
                        WHERE orgorderid = p_orderid AND duetype = v_strduetype;
                    ELSE
                        INSERT INTO stschd
                                (autoid, orgorderid, codeid,
                                 duetype, afacctno, acctno,
                                 reforderid, txnum,
                                 txdate, clearday,
                                 clearcd, amt, aamt,
                                 qtty, aqtty, famt, status, deltd, costprice, cleardate,trfbuydt,trfbuysts, trfbuyrate, trfbuyext
                                )
                         VALUES (seq_stschd.NEXTVAL, p_orderid, mv_strcodeid,
                                 v_strduetype, mv_strafacctno, mv_strafacctno,
                                 mv_reforderid, v_txnum,
                                 v_orderdate, 0,
                                 mv_strclearcd, mv_strprice * mv_strqtty, 0,
                                 mv_strqtty, 0, 0, 'N', 'N', 0, getduedate(v_orderdate,mv_strclearcd,'000',greatest(mv_mtrfday,mv_dbltrfbuyext)),
                                 least(getduedate(v_orderdate,mv_strclearcd,'000',mv_dbltrfbuyext),getduedate(v_orderdate,mv_strclearcd,'000',mv_strclearday)),mv_strtrfstatus, mv_dbltrfbuyrate, mv_dbltrfbuyext
                                );
                    END IF;
                ELSE                                                          --Lenh ban
                    --Tao lich thanh toan chung khoan
                    v_strduetype := 'SS';
                    IF v_matched > 0 THEN
                        UPDATE stschd SET
                            qtty = qtty + mv_strqtty,
                            amt = amt + mv_strprice * mv_strqtty
                        WHERE orgorderid = p_orderid AND duetype = v_strduetype;
                    ELSE
                        INSERT INTO stschd
                                (autoid, orgorderid, codeid,
                                 duetype, afacctno, acctno,
                                 reforderid, txnum,
                                 txdate, clearday,
                                 clearcd, amt, aamt,
                                 qtty, aqtty, famt, status, deltd, costprice, cleardate
                                )
                         VALUES (seq_stschd.NEXTVAL, p_orderid, mv_strcodeid,
                                 v_strduetype, mv_strafacctno, mv_strseacctno,
                                 mv_reforderid, v_txnum,
                                 v_orderdate, 0,
                                 mv_strclearcd, mv_strprice * mv_strqtty, 0,
                                 mv_strqtty, 0, 0, 'N', 'N', 0, getduedate(v_orderdate,mv_strclearcd,'000',0)
                                );
                    END IF;

                    --Tao lich thanh toan tien
                    v_strduetype := 'RM';
                    IF v_matched > 0 THEN
                        UPDATE stschd
                            SET qtty = qtty + mv_strqtty,
                            amt = amt + mv_strprice * mv_strqtty
                        WHERE orgorderid = p_orderid AND duetype = v_strduetype;
                    ELSE
                        INSERT INTO stschd
                                (autoid, orgorderid, codeid,
                                 duetype, afacctno, acctno,
                                 reforderid, txnum,
                                 txdate, clearday,
                                 clearcd, amt, aamt,
                                 qtty, aqtty, famt, status, deltd, costprice, cleardate
                                )
                         VALUES (seq_stschd.NEXTVAL, p_orderid, mv_strcodeid,
                                 v_strduetype, mv_strafacctno, mv_strafacctno,
                                 mv_reforderid, v_txnum,
                                 v_orderdate, mv_strclearday,
                                 mv_strclearcd, mv_strprice * mv_strqtty, 0,
                                 mv_strqtty, 0, 0, 'N', 'N', 0, getduedate(v_orderdate,mv_strclearcd,'000',mv_strclearday)
                                );
                    END IF;
                END IF;
            EXCEPTION
                WHEN OTHERS THEN
                    v_err :=
                    SUBSTR (   'Loi insert vao stschd '
                            || p_orderid || ' DueType '||v_strduetype
                            || SQLERRM,
                            1,
                            100
                           );
                    RAISE v_ex;
            END;

            --CAP NHAT TRAN VA MAST
            --BUY
            UPDATE OOD SET
                OODSTATUS = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
            WHERE ORGORDERID = p_orderid AND OODSTATUS <> 'S';

            UPDATE odmast SET
                orstatus = '4',
                PORSTATUS = PORSTATUS||'4',
                execqtty = execqtty + mv_strqtty ,
                remainqtty = remainqtty - mv_strqtty,
                execamt = execamt + mv_strqtty * mv_strprice,
                matchamt = matchamt + mv_strqtty * mv_strprice
            WHERE orderid = p_orderid;

            --Neu khop het va co lenh huy cua lenh da khop thi cap nhat thanh refuse
            IF mv_strremainqtty = mv_strqtty THEN
                UPDATE odmast
                    SET ORSTATUS = '0'
                WHERE REFORDERID = p_orderid;
            END IF;

            --Cap nhat tinh gia von

            IF mv_strbors = 'B' THEN
                UPDATE semast SET
                    dcramt = dcramt + mv_strqtty*mv_strprice,
                    dcrqtty = dcrqtty+mv_strqtty
                WHERE acctno = mv_strseacctno;
            END IF;

            INSERT INTO odtran
                  (txnum, txdate,
                   acctno, txcd, namt, camt, acctref, deltd,
                   REF, autoid
                  )
            VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   p_orderid, '0013', mv_strqtty, NULL, NULL, 'N',
                   NULL, seq_odtran.NEXTVAL
                  );

            INSERT INTO odtran
                  (txnum, txdate,
                   acctno, txcd, namt, camt, acctref, deltd,
                   REF, autoid
                  )
            VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   p_orderid, '0011', mv_strqtty, NULL, NULL, 'N',
                   NULL, seq_odtran.NEXTVAL
                  );

            INSERT INTO odtran
                  (txnum, txdate,
                   acctno, txcd, namt, camt,
                   acctref, deltd, REF, autoid
                  )
            VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   p_orderid, '0028', mv_strqtty * mv_strprice, NULL,
                   NULL, 'N', NULL, seq_odtran.NEXTVAL
                  );

            INSERT INTO odtran
                  (txnum, txdate,
                   acctno, txcd, namt, camt,
                   acctref, deltd, REF, autoid
                  )
            VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   p_orderid, '0034', mv_strqtty * mv_strprice, NULL,
                   NULL, 'N', NULL, seq_odtran.NEXTVAL
                  );
        END IF;
    END LOOP;

    plog.debug (pkgctx, '<<END OF fn_Match_Order');
    plog.setendsection (pkgctx, 'fn_Match_Order');
    RETURN systemnums.C_SUCCESS;

EXCEPTION
    when others then
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'fn_Match_Order');
        RAISE errnums.E_SYSTEM_ERROR;
END fn_Match_Order;


BEGIN
      FOR i IN (SELECT *
                FROM tlogdebug)
      LOOP
         logrow.loglevel    := i.loglevel;
         logrow.log4table   := i.log4table;
         logrow.log4alert   := i.log4alert;
         logrow.log4trace   := i.log4trace;
      END LOOP;
      pkgctx    :=
         plog.init ('TXPKS_#8848EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8848EX;
/
