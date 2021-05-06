CREATE OR REPLACE FORCE VIEW V_GETSECMARGININFO_OD AS
SELECT AF.ACCTNO AFACCTNO,
    SUM(EXECQTTY * NVL(RSK1.MRRATIOLOAN,0)/100 * LEAST(SB.MARGINPRICE,NVL(RSK1.MRPRICELOAN,0))) EXECQTTY_AMT,
    SUM(EXECQTTY * NVL(RSK1.MRRATIORATE,0)/100 * LEAST(SB.MARGINPRICE,NVL(RSK1.MRPRICERATE,0))) EXECQTTY_ASS,
    SUM(BUYQTTY* NVL(RSK1.MRRATIOLOAN,0)/100 * LEAST(SB.MARGINPRICE,NVL(RSK1.MRPRICELOAN,0))) BUYQTTY_AMT,
    SUM(BUYQTTY* NVL(RSK1.MRRATIORATE,0)/100 * LEAST(SB.MARGINPRICE,NVL(RSK1.MRPRICERATE,0))) BUYQTTY_ASS,

    sum (EXECQTTY * least(nvl(RSK2.mrratioloan,0),100-af.mriratio)/100 * least(sb.MARGINREFPRICE,nvl(RSK2.mrpriceloan,0))) EXECQTTY_MRAMT,
    sum (EXECQTTY * least(nvl(RSK2.MRRATIORATE,0),100-af.mriratio)/100 * least(sb.MARGINREFPRICE,nvl(RSK2.mrpricerate,0))) EXECQTTY_MRASS,
    sum (BUYQTTY * least(nvl(RSK2.mrratioloan,0),100-af.mriratio)/100 * least(sb.MARGINREFPRICE,nvl(RSK2.mrpriceloan,0))) BUYQTTY_MRAMT,
    sum (BUYQTTY * least(nvl(RSK2.MRRATIORATE,0),100-af.mriratio)/100 * least(sb.MARGINREFPRICE,nvl(RSK2.mrpricerate,0))) BUYQTTY_MRASS,

    sum (EXECQTTY * least(sb.MARGINREFPRICE,nvl(RSK2.mrpriceloan,0))) EXECQTTY_REALAMT,
    sum (EXECQTTY * least(sb.MARGINREFPRICE,nvl(RSK2.mrpricerate,0))) EXECQTTY_REALASS,
    sum (BUYQTTY * least(sb.MARGINREFPRICE,nvl(RSK2.mrpriceloan,0))) BUYQTTY_REALAMT,
    sum (BUYQTTY * least(sb.MARGINREFPRICE,nvl(RSK2.mrpricerate,0))) BUYQTTY_REALASS

FROM AFMAST AF, AFSERISK RSK1, AFMRSERISK RSK2, SECURITIES_INFO SB, SBSECURITIES SEC,
    (SELECT OD.ORDERID, (CASE WHEN OD.EXECTYPE IN ('NB','BC') THEN
                (case  when (af.trfbuyrate* af.trfbuyext) > 0 then 0 else REMAINQTTY end)
                + (case  when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY-DFQTTY end) ELSE 0 END) BUYQTTY,
            (CASE WHEN OD.EXECTYPE IN ('NS','MS') THEN EXECQTTY - nvl(dfexecqtty,0) ELSE 0 END) EXECQTTY, od.AFACCTNO, od.CODEID, AF.ACTYPE
        FROM ODMAST OD, afmast af, (select orgorderid, trfbuyext * trfbuyrate islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                                    (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
        WHERE od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
            and OD.TXDATE =(SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME='SYSTEM' AND VARNAME='CURRDATE')
            AND OD.AFACCTNO=AF.ACCTNO AND OD.DELTD <> 'Y' AND OD.EXECTYPE IN ('NS', 'MS','NB','BC')
            AND NOT(OD.EXECTYPE IN('MS','NS') AND OD.STSSTATUS='C')) SE
WHERE SE.AFACCTNO =AF.ACCTNO AND SE.CODEID=SB.CODEID
                AND SB.CODEID = SEC.CODEID AND NOT EXISTS (SELECT ISSUERID FROM ISSUER_MEMBER ISS WHERE ISS.ISSUERID =SEC.ISSUERID AND ISS.CUSTID = AF.CUSTID)
                AND SE.CODEID = RSK1.CODEID (+) AND SE.ACTYPE =RSK1.ACTYPE (+)
                AND SE.CODEID = RSK2.CODEID (+) AND SE.ACTYPE =RSK2.ACTYPE (+)
GROUP BY AF.ACCTNO;

