CREATE OR REPLACE FORCE VIEW V_GETSECMARGININFO_BOD AS
SELECT AF.ACCTNO AFACCTNO,
    SUM((se.trade + nvl(sts.receiving,0)) * NVL(RSK1.MRRATIORATE,0)/100 * LEAST(SB.MARGINPRICE,NVL(RSK1.MRPRICERATE,0))) SEASS,
    SUM((se.trade + nvl(sts.receiving,0)) * NVL(RSK1.MRRATIOLOAN,0)/100 * LEAST(SB.MARGINPRICE,NVL(RSK1.MRPRICELOAN,0))) SEAMT,
    sum((se.trade + nvl(sts.receiving,0)) * least(nvl(RSK2.mrratioloan,0),100-af.mriratio)/100 * least(sb.MARGINREFPRICE,nvl(RSK2.mrpriceloan,0))) SEMRAMT,
    sum((se.trade + nvl(sts.receiving,0)) * least(nvl(RSK2.MRRATIORATE,0),100-af.mriratio)/100 * least(sb.MARGINREFPRICE,nvl(RSK2.mrpricerate,0))) SEMRASS,
    sum((se.trade + nvl(sts.receiving,0)) * least(sb.MARGINREFPRICE,nvl(RSK2.mrpriceloan,0))) SEREALAMT,
    sum((se.trade + nvl(sts.receiving,0)) * least(sb.MARGINREFPRICE,nvl(RSK2.mrpricerate,0))) SEREALASS

FROM AFMAST AF, (SELECT SEMAST.AFACCTNO, SEMAST.CODEID, SEMAST.TRADE, AFMAST.ACTYPE FROM AFMAST, SEMAST WHERE AFMAST.ACCTNO=SEMAST.AFACCTNO) SE,
    AFSERISK RSK1,AFMRSERISK RSK2, SECURITIES_INFO SB, SBSECURITIES SEC,
    (SELECT STS.CODEID,STS.AFACCTNO,
            SUM(CASE WHEN DUETYPE ='RS' and nvl(sts_trf.islatetransfer,0) = 0 AND STS.TXDATE <> (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME='SYSTEM' AND VARNAME='CURRDATE') THEN QTTY-AQTTY ELSE 0 END) RECEIVING
        FROM STSCHD STS, ODMAST OD, ODTYPE TYP, (select orgorderid, trfbuyext * trfbuyrate islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf
        WHERE STS.DUETYPE = 'RS' AND STS.STATUS ='N'
            AND STS.DELTD <>'Y' AND STS.ORGORDERID=OD.ORDERID AND OD.ACTYPE =TYP.ACTYPE
            and od.orderid = sts_trf.orgorderid(+)
            GROUP BY STS.AFACCTNO,STS.CODEID
     ) sts
WHERE SE.AFACCTNO =AF.ACCTNO AND SE.CODEID=SB.CODEID
                AND SB.CODEID = SEC.CODEID AND NOT EXISTS (SELECT ISSUERID FROM ISSUER_MEMBER ISS WHERE ISS.ISSUERID =SEC.ISSUERID AND ISS.CUSTID = AF.CUSTID)
                AND SE.CODEID = RSK1.CODEID (+) AND SE.ACTYPE =RSK1.ACTYPE (+)
                AND SE.CODEID = RSK2.CODEID (+) AND SE.ACTYPE =RSK2.ACTYPE (+)
                and se.codeid = sts.codeid (+) and se.afacctno = sts.afacctno (+)
GROUP BY AF.ACCTNO;

