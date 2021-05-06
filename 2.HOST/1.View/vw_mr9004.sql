CREATE OR REPLACE FORCE VIEW VW_MR9004 AS
select roomchk, symbol , se.codeid,
trade , mortage,receiving ,t0receiving receivingt2,TOTALRECEIVING ,execqtty SELLMATCHQTTY,buyqtty BUYQTTY,TOTALBUYQTTY,TOTALBUYAMT,
nvl(sy_pravlremain,0) + nvl(sy_prinused,0) AVLSYSROOM, nvl(sy_prinused,0) USEDSYSROOM,
nvl(pravlremain,0) + nvl(prinused,0) AVL74ROOM, nvl(prinused,0) USED74ROOM,
nvl(prgrp.grp_pravlremain,0) + nvl(grp_prinused,0) AVLGRPROOM, nvl(grp_prinused,0) USEDGRPROOM,
nvl(rsk1.mrratioloan,0) RATECL, least(sb.MARGINPRICE,nvl(rsk1.mrpriceloan,0)) PRICECL, least(sb.MARGINCALLPRICE,nvl(rsk1.mrpricerate,0)) CALLPRICECL,
least(nvl(rsk2.mrratioloan,0),100-mriratio) RATE74, least(sb.MARGINREFPRICE,nvl(rsk2.mrpriceloan,0)) PRICE74, least(sb.MARGINREFCALLPRICE,nvl(rsk2.mrpriceloan,0)) CALLPRICE74,
(least(trade + receiving - execqtty + buyqtty,nvl(sy_pravlremain,0) + nvl(sy_prinused,0)) * nvl(rsk1.mrratioloan,0)/100 * least(sb.MARGINPRICE,nvl(rsk1.mrpriceloan,0)))
    TS_SUCMUA,
(least(trade + TOTALRECEIVING - EXECQTTY + TOTALBUYQTTY,nvl(sy_pravlremain,0) + nvl(sy_prinused,0)) * nvl(rsk1.mrratioloan,0)/100 * least(sb.MARGINPRICE,nvl(rsk1.mrpriceloan,0)))
    TS_DANHDAU,
(least(trade + t0receiving - execqtty + buyqtty,nvl(sy_pravlremain,0) + nvl(sy_prinused,0)) * nvl(rsk1.mrratioloan,0)/100 * least(sb.MARGINPRICE,nvl(rsk1.mrpriceloan,0)))
    TS_T2,
(least(trade + t0receiving - execqtty + buyqtty,nvl(sy_pravlremain,0) + nvl(sy_prinused,0)) * nvl(rsk1.mrratioloan,0)/100 * least(sb.MARGINCALLPRICE,nvl(rsk1.mrpriceloan,0)))
    TS_CALLT2,

(least(trade + TOTALRECEIVING - execqtty + TOTALBUYQTTY,nvl(sy_pravlremain,0) + nvl(sy_prinused,0)) * nvl(rsk1.mrratiorate,0)/100 * least(sb.MARGINCALLPRICE,nvl(rsk1.mrpricerate,0)))
TS_WITHD
,
((trade + TOTALRECEIVING - execqtty + TOTALBUYQTTY) * nvl(rsk1.mrratiorate,0)/100 * least(sb.MARGINCALLPRICE,nvl(rsk1.mrpricerate,0)))
 TS_CALL,

((trade + mortage + TOTALRECEIVING - execqtty + TOTALBUYQTTY) * sb.BASICPRICE)
    REALASS,
se.afacctno,
custodycd,
se.acctno, NVL( rsk1.mrratiorate,0) mrratiorate
from
(select prgrp.autoid, se.roomchk, cf.custodycd, se.codeid, af.actype, af.mriratio,af.trfbuyrate, af.trfbuyext, se.afacctno,se.acctno, se.trade, se.mortage , nvl(sts.receiving,0) receiving,
    nvl(sts.t0receiving,0) t0receiving,nvl(sts.totalreceiving,0) totalreceiving,nvl(BUYQTTY,0) BUYQTTY,nvl(TOTALBUYQTTY,0) TOTALBUYQTTY, nvl(OD.TOTALBUYAMT,0) TOTALBUYAMT,
    nvl(od.EXECQTTY,0) EXECQTTY, nvl(STS.MAMT,0) mamt,
    CASE WHEN se.roomchk = 'Y' THEN nvl(afpr.prinused,0) ELSE 1000000000000 END prinused,
    CASE WHEN se.roomchk = 'Y' THEN nvl(afpr.sy_prinused,0) ELSE 1000000000000 END sy_prinused,
    CASE WHEN se.roomchk <> 'Y' THEN (se.trade + se.mortage + nvl(sts.totalreceiving,0) - nvl(od.execqtty,0) + nvl(totalbuyqtty,0)) ELSE 0 END grp_prinused
  from semast se
  inner join afmast af on se.afacctno =af.acctno
  inner join cfmast cf on af.custid =cf.custid
  inner JOIN sbsecurities sb ON se.codeid = sb.codeid AND sb.sectype <> '004' AND SB.tradeplace <> '006'
  LEFT JOIN (SELECT af.afacctno, sel.* FROM selimitgrp sel, afselimitgrp af WHERE sel.autoid = af.refautoid) prgrp ON se.afacctno = prgrp.afacctno AND se.codeid = prgrp.codeid
  left join
  (select sum(BUYQTTY) BUYQTTY,sum(TOTALBUYAMT) TOTALBUYAMT, sum(TOTALBUYQTTY) TOTALBUYQTTY, sum(EXECQTTY) EXECQTTY , AFACCTNO, CODEID
          from (
              SELECT (case when od.exectype IN ('NB','BC')
                          then (case when (af.trfbuyext * af.trfbuyrate) > 0 then 0 else REMAINQTTY end)
                                  + (case when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY - DFQTTY end)
                          else 0 end) BUYQTTY,
                          (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end) TOTALBUYQTTY,
                          (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end)*od.quoteprice TOTALBUYAMT,
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
) pr,
(
    SELECT se.autoid, selimit - fn_getUsedSeLimitByGroup(se.autoid) grp_pravlremain
    FROM selimitgrp se
) prgrp
where se.codeid=sb.codeid
and se.codeid=rsk1.codeid (+) and se.actype =rsk1.actype (+)
and se.codeid=rsk2.codeid (+) and se.actype =rsk2.actype (+)
and se.codeid = pr.codeid (+) AND se.autoid = prgrp.autoid (+)
;

