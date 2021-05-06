create or replace function 
fn_getusedselimit (p_acctno IN VARCHAR2, p_codeid in varchar2)
RETURN NUMBER
  IS
l_amt number;
BEGIN
    select trade + receiving - EXECQTTY + BUYQTTY  into l_amt
    from (
      select se.codeid, af.actype,se.afacctno,se.acctno, se.trade + se.grpordamt trade, nvl(sts.receiving,0) receiving,nvl(BUYQTTY,0) BUYQTTY,nvl(od.EXECQTTY,0) EXECQTTY
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
                      where od.afacctno = p_acctno and od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
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
               and od.orderid = sts_trf.orgorderid(+) and sts.afacctno = p_acctno
               GROUP BY STS.AFACCTNO,STS.CODEID
        ) sts
       on sts.afacctno =se.afacctno and sts.codeid=se.codeid
       where se.afacctno = p_acctno and se.codeid = p_codeid
    );


    return l_amt;
EXCEPTION
    WHEN others THEN
        return 0;
END;
/

