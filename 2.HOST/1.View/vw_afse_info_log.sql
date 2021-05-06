CREATE OR REPLACE FORCE VIEW VW_AFSE_INFO_LOG AS
select symbol , se.codeid,
trade TRADEQTTY,receiving RCVQTTY,execqtty SELLMATCHQTTY,buyqtty BUYQTTY,
nvl(sy_pravlremain,0) + nvl(sy_prinused,0) AVLSYSROOM, nvl(sy_pravlremain,0) REMAINSYSROOM,nvl(sy_prinused,0) USEDSYSROOM,
nvl(pravlremain,0) + nvl(prinused,0) AVL74ROOM, nvl(pravlremain,0) REMAIN74ROOM,nvl(prinused,0) USED74ROOM,
nvl(rsk1.mrratioloan,0) RATECL, least(sb.MARGINPRICE,nvl(rsk1.mrpriceloan,0)) PRICECL, least(sb.MARGINCALLPRICE,nvl(rsk1.mrpricerate,0)) CALLPRICECL,
least(nvl(rsk2.mrratioloan,0),100-mriratio) RATE74, least(sb.MARGINREFPRICE,nvl(rsk2.mrpriceloan,0)) PRICE74, least(sb.MARGINREFCALLPRICE,nvl(rsk2.mrpriceloan,0)) CALLPRICE74,
(least(trade + receiving - execqtty + buyqtty,nvl(sy_pravlremain,0) + nvl(sy_prinused,0)) * nvl(rsk1.mrratioloan,0)/100 * least(sb.MARGINPRICE,nvl(rsk1.mrpriceloan,0)))
    SEAMT,
(least(trade + receiving - execqtty + buyqtty, nvl(pravlremain,0) + nvl(prinused,0) ) * least(nvl(rsk2.mrratioloan,0),100-mriratio)/100 * least(sb.MARGINREFPRICE,nvl(rsk2.mrpriceloan,0)))
    SE74AMT,
se.afacctno,
custodycd
from
(select cf.custodycd, se.codeid, af.actype, af.mriratio,af.trfbuyrate, af.trfbuyext, se.afacctno,se.acctno, se.trade , nvl(sts.receiving,0) receiving,nvl(sts.t0receiving,0) t0receiving,nvl(sts.totalreceiving,0) totalreceiving,nvl(BUYQTTY,0) BUYQTTY,nvl(TOTALBUYQTTY,0) TOTALBUYQTTY,nvl(od.EXECQTTY,0) EXECQTTY, nvl(STS.MAMT,0) mamt, nvl(afpr.prinused,0) prinused, nvl(afpr.sy_prinused,0) sy_prinused
  from semast se
  inner join afmast af on se.afacctno =af.acctno
  inner join cfmast cf on af.custid =cf.custid
  left join
  (select sum(BUYQTTY) BUYQTTY,sum(TOTALBUYQTTY) TOTALBUYQTTY, sum(EXECQTTY) EXECQTTY , AFACCTNO, CODEID
          from (
              SELECT (case when od.exectype IN ('NB','BC')
                          then (case when (af.trfbuyext * af.trfbuyrate) > 0 then 0 else REMAINQTTY end)
                                  + (case when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY - DFQTTY end)
                          else 0 end) BUYQTTY,
                          (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end) TOTALBUYQTTY,
                      (case when od.exectype IN ('NS','MS') and od.stsstatus <> 'C' then EXECQTTY - nvl(dfexecqtty,0) else 0 end) EXECQTTY, AFACCTNO, CODEID
              FROM odmast od, afmast af,
                  (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                  (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                 where od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
                 and od.txdate =(select to_date(VARVALUE,'DD/MM/RRRR') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                 AND od.deltd <> 'Y'
                 and not(od.grporder='Y' and od.matchtype='P') --Lenh thoa thuan tong khong tinh vao
                 AND od.exectype IN ('NS', 'MS','NB','BC')
              )
   group by  AFACCTNO, CODEID
   ) OD
  on OD.afacctno =se.afacctno and OD.codeid =se.codeid
  left join
  (SELECT STS.CODEID,STS.AFACCTNO,
          SUM(CASE WHEN DUETYPE ='RM' THEN AMT-AAMT-FAMT+PAIDAMT+PAIDFEEAMT-AMT*TYP.DEFFEERATE/100 ELSE 0 END) MAMT,
          SUM(CASE WHEN DUETYPE ='RS' and nvl(sts_trf.islatetransfer,0) = 0 AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR') THEN QTTY-AQTTY ELSE 0 END) RECEIVING,
          SUM(CASE WHEN DUETYPE ='RS' AND (nvl(sts_trf.islatetransfer,0) = 0 or sts_trf.trfbuydt = TO_DATE(sy.VARVALUE,'DD/MM/RRRR')) AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR') THEN QTTY-AQTTY ELSE 0 END) T0RECEIVING,
          SUM(CASE WHEN DUETYPE ='RS' AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR') THEN QTTY-AQTTY ELSE 0 END) TOTALRECEIVING
      FROM STSCHD STS, ODMAST OD, ODTYPE TYP,
      (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer, trfbuydt from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
      sysvar sy
      WHERE STS.DUETYPE IN ('RM','RS') AND STS.STATUS ='N'
          and sy.grname = 'SYSTEM' and sy.varname = 'CURRDATE'
          AND STS.DELTD <>'Y' AND STS.ORGORDERID=OD.ORDERID AND OD.ACTYPE =TYP.ACTYPE
          and od.orderid = sts_trf.orgorderid(+)
          GROUP BY STS.AFACCTNO,STS.CODEID
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
afserisk rsk1,
afmrserisk rsk2,
securities_info sb,
(
  select pr.codeid,
      greatest(max(pr.roomlimit) - nvl(sum(case when restype = 'M' then nvl(afpr.prinused,0) else 0 end),0),0) pravlremain,
      greatest(max(pr.syroomlimit) - max(pr.syroomused) - nvl(sum(case when restype = 'S' then nvl(afpr.prinused,0) else 0 end),0),0) sy_pravlremain
  from vw_marginroomsystem pr, vw_afpralloc_all afpr
  where pr.codeid = afpr.codeid(+)
  group by pr.codeid
) pr
where se.codeid=sb.codeid
and se.codeid=rsk1.codeid and se.actype =rsk1.actype
and se.codeid=rsk2.codeid and se.actype =rsk2.actype
and se.codeid = pr.codeid
;

