CREATE OR REPLACE VIEW V_GETSECMARGININFO_ALL AS
(
select se.afacctno , --SE.CODEID, SB.SYMBOL ,
                     SUM(LEAST(trade + receiving - execqtty + buyqtty, SB.AVRTRADEQTT) * sb.basicprice) SELIQAMT /* Gia tri thanh khoan cua tai san*/
                ,SUM(LEAST(RECEIVING_T0 * (1 - sy.pricelimit/100) + trade - execqtty, SB.AVRTRADEQTT) * sb.floorprice * (1 - sy1.feerate/100) -
                     LEAST(trade - execqtty, SB.AVRTRADEQTT) * nvl(risk.mrratioloan,0)/100 * LEAST(sb.marginprice, nvl(risk.mrpriceloan,0))) SELIQAMT2 /* Gia tri thanh khoan cua tai san 1.5.8.9*/
                ,SUM((trade + receiving - execqtty + buyqtty) * least(sb.basicprice, sb.navprice)) SENAVAMT /* Tai san tinh tai san rong */
                ,SUM((trade + mortage + TOTALRECEIVING - execqtty + TOTALBUYQTTY) * sb.BASICPRICE) SETOTAL -- tai san rong
                from
                (select se.codeid, af.actype, af.mriratio, af.acctno afacctno,se.acctno, se.trade ,se.mortage, nvl(sts.receiving,0) receiving,nvl(sts.t0receiving,0) t0receiving,nvl(sts.totalreceiving,0) totalreceiving,nvl(BUYQTTY,0) BUYQTTY,nvl(TOTALBUYQTTY,0) TOTALBUYQTTY,nvl(od.EXECQTTY,0) EXECQTTY, nvl(STS.MAMT,0) mamt, nvl(afpr.prinused,0) prinused, nvl(afpr.sy_prinused,0) sy_prinused, nvl(sts.RECEIVING_T0,0) RECEIVING_T0
                    from semast se inner join afmast af on se.afacctno =af.acctno
					inner JOIN sbsecurities sb ON se.codeid = sb.codeid AND sb.sectype <> '004' AND SB.tradeplace <> '006'
                    left join
                    (select sum(BUYQTTY) BUYQTTY,sum(TOTALBUYQTTY) TOTALBUYQTTY, sum(EXECQTTY) EXECQTTY , AFACCTNO, CODEID
                            from (
                                SELECT (case when od.exectype IN ('NB','BC')
                                            then (case when (af.trfbuyext * af.trfbuyrate) > 0 then 0 else REMAINQTTY end)
                                                    + (case when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY - DFQTTY end)
                                            else 0 end) BUYQTTY,
                                            (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end) TOTALBUYQTTY,
                                        (case when od.exectype IN ('NS','MS') and od.stsstatus <> 'C' then EXECQTTY - nvl(dfexecqtty,0) else 0 end) EXECQTTY,AFACCTNO, CODEID
                                FROM odmast od, afmast af,
                                    (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                                    (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                                   where od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
                                   and od.txdate =(select to_date(VARVALUE,'DD/MM/RRRR') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                                   AND od.deltd <> 'Y'
                                   --AND od.errod = 'N'
                                   and not(od.grporder='Y' and od.matchtype='P') --Lenh thoa thuan tong khong tinh vao
                                   AND od.exectype IN ('NS', 'MS','NB','BC')
                                )
                     group by AFACCTNO, CODEID
                     ) OD
                    on OD.afacctno =se.afacctno and OD.codeid =se.codeid
                    left join
                    (SELECT od.CODEID,od.AFACCTNO,
                            SUM(CASE WHEN DUETYPE ='RM' THEN AMT-AAMT-FAMT+PAIDAMT+PAIDFEEAMT-AMT*TYP.DEFFEERATE/100 ELSE 0 END) MAMT,
                            SUM(CASE WHEN DUETYPE ='RS' and nvl(sts_trf.islatetransfer,0) = 0 AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR') THEN QTTY-AQTTY ELSE 0 END) RECEIVING,
                            SUM(CASE WHEN DUETYPE ='RS' AND (nvl(sts_trf.islatetransfer,0) = 0 or sts_trf.trfbuydt = TO_DATE(sy.VARVALUE,'DD/MM/RRRR')) AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR') THEN QTTY-AQTTY ELSE 0 END) T0RECEIVING,
                            SUM(CASE WHEN DUETYPE ='RS' AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR') THEN QTTY-AQTTY ELSE 0 END) TOTALRECEIVING,
                            SUM(CASE WHEN DUETYPE ='RS' AND STS.CLEARDAY = SP_BD_GETCLEARDAY(STS.CLEARCD, SB.TRADEPLACE, STS.TXDATE, TO_DATE(sy.VARVALUE,'DD/MM/RRRR')) THEN QTTY ELSE 0 END) RECEIVING_T0
                        FROM STSCHD STS, ODMAST OD, ODTYPE TYP, sbsecurities sb,
                        (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer, trfbuydt from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                        sysvar sy
                        WHERE STS.DUETYPE IN ('RM','RS') AND STS.STATUS ='N'
                            and sy.grname = 'SYSTEM' and sy.varname = 'CURRDATE'
                            AND STS.DELTD <>'Y' AND STS.ORGORDERID=OD.ORDERID AND OD.ACTYPE =TYP.ACTYPE
                            --AND od.errod = 'N'
                            and od.orderid = sts_trf.orgorderid(+)
                            AND od.codeid = sb.codeid
                            GROUP BY od.AFACCTNO,od.CODEID
                     ) sts
                    on sts.afacctno =se.afacctno and sts.codeid=se.codeid
                    left join
                    (
                        select afacctno, codeid,
                            nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                            nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                        from vw_afpralloc_all
                        group by afacctno, codeid
                    ) afpr  on afpr.afacctno =se.afacctno and afpr.codeid=se.codeid
                ) se,

                securities_info sb, afserisk risk,
                (SELECT to_number(varvalue) pricelimit FROM sysvar WHERE grname = 'SYSTEM' AND varname = 'PRICELIMIT') sy,
                (SELECT to_number(varvalue) feerate FROM sysvar WHERE grname = 'SYSTEM' AND varname = 'FEE_RATE') sy1
                WHERE se.codeid=sb.codeid
                AND se.actype = risk.actype(+) AND se.codeid = risk.codeid(+)
                group by se.afacctno
)
;
