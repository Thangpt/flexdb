CREATE OR REPLACE PROCEDURE mr9006 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   pv_OPT            IN       VARCHAR2,
   pv_BRID           IN       VARCHAR2,
   pv_CUSTDYCD       IN       VARCHAR2,
   pv_AFACCTNO       IN       VARCHAR2
)
IS
-- ---------   ------  -------------------------------------------
   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);

   V_CUSTODYCD VARCHAR2(10);
   V_AFACCTNO VARCHAR2(10);
   V_CURRDATE DATE;


-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := upper(pv_OPT);
   V_INBRID := pv_BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := pv_BRID;
        end if;
    end if;

    SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURRDATE FROM SYSVAR WHERE VARNAME = 'CURRDATE';

    IF pv_CUSTDYCD = 'ALL' THEN
        V_CUSTODYCD := '%%';
    ELSE V_CUSTODYCD := pv_CUSTDYCD;
    END IF;

    IF pv_AFACCTNO = 'ALL' THEN
        V_AFACCTNO := '%%';
    ELSE V_AFACCTNO := pv_AFACCTNO;
    END IF;
  -- GET REPORT'S DATA
    OPEN PV_REFCURSOR FOR
    SELECT ACCTNO, CUSTODYCD, M.FULLNAME, DUNO, TS_CALL
      , case when DUNO < 0 then 10000 else DECODE(DUNO,0,0, ROUND(TS_CALL*100/DUNO)) end RTT
      , GREATEST(0,decode(mrirate,0,0, DUNO - ROUND(TS_CALL*100/MRIRATE))) TORAT
      , GREATEST(0,decode(mrmrate,0,0, DUNO - ROUND(TS_CALL*100/mrmrate))) TORDT
      , TS_CALL_1
      , case when duno < 0 then 10000 else DECODE(DUNO,0,0, ROUND(TS_CALL_1*100/DUNO)) end RTT1
      , TS_CALL_2
      , case when duno < 0 then 10000 else DECODE(DUNO,0,0, ROUND(TS_CALL_2*100/DUNO)) end RTT2
      , TS_CALL_3
      , case when duno < 0 then 10000 else DECODE(DUNO,0,0, ROUND(TS_CALL_3*100/DUNO)) end RTT3
      , A.FULLNAME REFULLNAME
      , G.FULLNAME GRPNAME
      , B.DESCRIPTION
    FROM
    (
    SELECT CI.ACCTNO
        , NVL(LN.T0AMT,0) + NVL(LN.MARGINAMT,0) + CI.DEPOFEEAMT - CI.BALANCE /*- CI.RECEIVING*/ - nvl(avl.avladvance,0) DUNO
        , NVL(V.TS_CALL,0) TS_CALL
        , NVL(V.TS_CALL_1,0) TS_CALL_1
        , NVL(V.TS_CALL_2,0) TS_CALL_2
        , NVL(V.TS_CALL_3,0) TS_CALL_3
        --, AF.MRMRATIO --t/l duy tri cua UBCK
        , mr.mrmrate --t/l canh bao
        , AF.MRIRATE
        , CF.FULLNAME, CF.CUSTODYCD
    FROM CIMAST CI
        , /*(SELECT AFACCTNO
                , SUM(TS_CALL) TS_CALL
                , SUM(CASE WHEN SB.TRADEPLACE = '002' THEN TS_CALL * (1-0.1)
                       ELSE TS_CALL * (1-0.07) END ) TS_CALL_1
                , SUM(CASE WHEN SB.TRADEPLACE = '002' THEN TS_CALL * (1-0.1) * (1-0.1)
                       ELSE TS_CALL *(1-0.07) * (1-0.07) END ) TS_CALL_2
                , SUM(CASE WHEN SB.TRADEPLACE = '002' THEN TS_CALL * (1-0.1) * (1-0.1) * (1-0.1)
                       ELSE TS_CALL * (1-0.07) * (1-0.07) * (1-0.07) END ) TS_CALL_3
          FROM VW_MR9004 M, SBSECURITIES SB WHERE M.CODEID = SB.CODEID  GROUP BY AFACCTNO
          ) V*/
          (select afacctno,
          sum(KL_TS*GIA_TC) TS_CALL,
          sum(case when tradeplace in( '002','005') then KL_TS * fn_getrefprice(tradeplace, GIA_TC * (1-0.1))
                   else KL_TS * fn_getrefprice(TRADEPLACE, GIA_TC * (1-0.07)) END ) TS_CALL_1,
          sum(case when tradeplace in( '002','005') then KL_TS * fn_getrefprice(tradeplace, GIA_TC * (1-0.1) * (1-0.1))
                   else KL_TS * fn_getrefprice(TRADEPLACE, GIA_TC * (1-0.07) * (1-0.07)) END ) TS_CALL_2,
          sum(case when tradeplace in( '002','005') then KL_TS * fn_getrefprice(tradeplace, GIA_TC * (1-0.1)* (1-0.1) * (1-0.1))
                   else KL_TS * fn_getrefprice(TRADEPLACE, GIA_TC * (1-0.07) * (1-0.07) * (1-0.07)) END ) TS_CALL_3
          from
            (
            select
            (trade + TOTALRECEIVING - execqtty + TOTALBUYQTTY) * nvl(rsk1.mrratiorate,0)/100 KL_TS,
            least(sb.MARGINCALLPRICE,nvl(rsk1.mrpricerate,0)) GIA_TC,
            se.tradeplace,
            se.afacctno,
            custodycd,
            se.acctno
            from
            (select cf.custodycd, se.codeid, af.actype, af.mriratio,af.trfbuyrate, af.trfbuyext
                , se.afacctno,se.acctno, se.trade, se.mortage , nvl(sts.receiving,0) receiving,nvl(sts.t0receiving,0) t0receiving
                ,nvl(sts.totalreceiving,0) totalreceiving,nvl(BUYQTTY,0) BUYQTTY,nvl(TOTALBUYQTTY,0) TOTALBUYQTTY,nvl(od.EXECQTTY,0) EXECQTTY
                , nvl(STS.MAMT,0) mamt, nvl(afpr.prinused,0) prinused, nvl(afpr.sy_prinused,0) sy_prinused
                , sb.tradeplace
              from semast se
              inner join afmast af on se.afacctno =af.acctno
              inner join cfmast cf on af.custid =cf.custid
              inner JOIN sbsecurities sb ON se.codeid = sb.codeid AND sb.sectype <> '004' AND SB.tradeplace <> '006'
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
            securities_info sb
            where se.codeid=sb.codeid
            and se.codeid=rsk1.codeid (+) and se.actype =rsk1.actype (+)
            )
          group by afacctno
          ) V
        , (SELECT TRFACCTNO, SUM(T0AMT) T0AMT, SUM(MARGINAMT) MARGINAMT FROM VW_LNGROUP_ALL GROUP BY TRFACCTNO) LN
        ,  (select nvl(sum(depoamt),0) AVLADVANCE, afacctno from v_getaccountavladvance  group by afacctno) avl
        , AFMAST AF, CFMAST CF, mrtype mr, aftype aft
    WHERE CI.ACCTNO = V.AFACCTNO(+)
    AND CI.ACCTNO = LN.TRFACCTNO(+)
    and ci.acctno = avl.afacctno(+)
    AND CI.ACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID and af.actype = aft.actype and aft.mrtype = mr.actype
--    and NVL(LN.T0AMT,0) + NVL(LN.MARGINAMT,0) + CI.DEPOFEEAMT - CI.BALANCE - CI.RECEIVING <> 0
    and NVL(LN.T0AMT,0) + NVL(LN.MARGINAMT,0) + CI.DEPOFEEAMT - CI.BALANCE /*- CI.RECEIVING*/ - nvl(avl.avladvance,0)>0
    and mr.mrtype = 'T' and af.status = 'A'
    AND CI.ACCTNO LIKE V_AFACCTNO
    AND CF.CUSTODYCD LIKE V_CUSTODYCD
    ) M
    LEFT JOIN
        (SELECT CF.FULLNAME, A.REACCTNO, A.AFACCTNO  FROM REAFLNK A, RECFLNK C, RECFDEF D, CFMAST CF , RETYPE R
        WHERE D.REFRECFLNKID = C.AUTOID AND A.REACCTNO = C.CUSTID||D.REACTYPE AND D.STATUS = 'A' AND A.STATUS = 'A'
        AND CF.CUSTID = C.CUSTID AND R.ACTYPE = D.REACTYPE AND R.REROLE IN ('BM','RM')
        ) A
        ON M.ACCTNO = A.AFACCTNO
    LEFT JOIN
        (SELECT G.FULLNAME, G.AUTOID, L.REACCTNO FROM REGRPLNK L, REGRP G WHERE L.refrecflnkid = G.AUTOID AND  G.STATUS = 'A' AND L.STATUS = 'A' ) G
        ON A.REACCTNO = G.REACCTNO
    LEFT JOIN BRGRP B ON SUBSTR(M.ACCTNO,1,4) = B.BRID
    ;



 EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
/

