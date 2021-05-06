CREATE OR REPLACE FUNCTION fn_getppavlroom(p_CodeID IN VARCHAR2, p_AfAcctno in varchar2)
RETURN NUMBER
IS
    l_avlsyroomqtty NUMBER(20,0);
    l_avlroomqtty NUMBER(20,0);
    l_avlsyqtty NUMBER(20,0);
    l_avlqtty NUMBER(20,0);
    l_PP0_add number(20,0);
    l_advanceline number(20,0);
    l_mrratiorate number(20,4);
    l_mrpriceloan number(20,4);
    l_chksysctrl varchar2(1);
    l_margintype varchar2(1);
    l_marginprice number(20,0);
    l_marginrefprice number(20,0);
BEGIN
     SELECT mr.mrtype
         INTO l_margintype
     FROM afmast mst, aftype af, mrtype mr
     WHERE mst.actype = af.actype
         AND af.mrtype = mr.actype
         AND mst.acctno = p_AfAcctno;
     if l_margintype not in  ('T','S') then
        return 0;
     else

         select nvl(rsk.mrratioloan,0),nvl(rsk.mrpriceloan,0), nvl(lnt.chksysctrl,'N')
             into l_mrratiorate,l_mrpriceloan, l_chksysctrl
         from afmast af, aftype aft, lntype lnt,
             (select * from afserisk where codeid = p_CodeID) rsk
         where af.actype = aft.actype and aft.lntype = lnt.actype(+) and af.actype = rsk.actype(+) and af.acctno = p_AfAcctno;

         select marginprice, marginrefprice into l_marginprice, l_marginrefprice
         from securities_info where codeid = p_CodeID;

        -- Room:
        begin
            select greatest(r1.syroomlimit - r1.syroomused - nvl(u1.sy_prinused,0),0) avlsyroom,
                   greatest(r1.roomlimit - nvl(u1.prinused,0),0) avlroom
                   into l_avlsyroomqtty, l_avlroomqtty
            from vw_marginroomsystem r1,
            (select codeid, sum(case when restype = 'M' then prinused else 0 end) prinused,
                       sum(case when restype = 'S' then prinused else 0 end) sy_prinused
               from vw_afpralloc_all
               where codeid = p_CODEID
               group by codeid) u1
            where r1.codeid = u1.codeid(+)
            and r1.codeid = p_CODEID;
        exception when others then
            l_avlroomqtty:=0;
            l_avlsyroomqtty:=0;
        end;

        --AvlQtty
        begin
            select greatest(nvl(l_avlsyroomqtty + nvl(sy_prinused,0),0) - nvl(least(trade + receiving - EXECQTTY + BUYQTTY,l_avlsyroomqtty + nvl(sy_prinused,0)),0),0) avlsyqtty,
                   greatest(nvl(l_avlroomqtty + nvl(prinused,0),0) - nvl(least(trade + receiving - EXECQTTY + BUYQTTY,l_avlroomqtty + nvl(prinused,0)),0),0) avlqtty
                 into l_avlsyqtty, l_avlqtty
            from
                (select se.codeid, af.actype,se.afacctno,se.acctno, se.trade + se.grpordamt trade, nvl(sts.receiving,0) receiving,nvl(BUYQTTY,0) BUYQTTY,nvl(od.EXECQTTY,0) EXECQTTY,  nvl(afpr.prinused,0) prinused, nvl(afpr.sy_prinused,0) sy_prinused
                    from (select * from semast where afacctno = p_AfAcctno and codeid = p_CodeID) se
                    inner join (select * from afmast where acctno = p_AfAcctno) af on se.afacctno =af.acctno
                        left join
                        (select sum(BUYQTTY) BUYQTTY, sum(EXECQTTY) EXECQTTY , SEACCTNO
                                from (
                                    SELECT (case when od.exectype IN ('NB','BC')
                                                then (case when (af.trfbuyext * af.trfbuyrate) > 0 then 0 else REMAINQTTY end)
                                                        + (case when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY - DFQTTY end)
                                                else 0 end) BUYQTTY,
                                                (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end) TOTALBUYQTTY,
                                            (case when od.exectype IN ('NS','MS') then EXECQTTY - nvl(dfexecqtty,0) else 0 end) EXECQTTY,SEACCTNO
                                    FROM odmast od, afmast af, (select orgorderid, (trfbuyext * trfbuyrate) * (amt-trfexeamt) islatetransfer from stschd where duetype = 'SM') sts_trf,
                                    (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                                       where od.afacctno = p_AfAcctno and od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
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
                            FROM STSCHD STS, ODMAST OD, ODTYPE TYP, (select orgorderid, (trfbuyext * trfbuyrate) * (amt-trfexeamt) islatetransfer from stschd where duetype = 'SM') sts_trf
                            WHERE STS.DUETYPE IN ('RM','RS') AND STS.STATUS ='N'
                                AND STS.DELTD <>'Y' AND STS.ORGORDERID=OD.ORDERID AND OD.ACTYPE =TYP.ACTYPE
                                and od.orderid = sts_trf.orgorderid(+) and sts.afacctno = p_AfAcctno
                                GROUP BY STS.AFACCTNO,STS.CODEID
                         ) sts
                        on sts.afacctno =se.afacctno and sts.codeid=se.codeid
                        left join
                        (
                            select afacctno, codeid,
                                nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                                nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                            from vw_afpralloc_all
                            where codeid = p_CodeID and afacctno = p_AfAcctno
                            group by afacctno, codeid
                        ) afpr  on afpr.afacctno =se.afacctno and afpr.codeid=se.codeid
                    ) se
            where se.afacctno = p_AfAcctno and se.codeid = p_CodeID;
        EXCEPTION when others then
            l_avlsyqtty:=l_avlsyroomqtty;
            l_avlqtty:=l_avlroomqtty;
        end;
        plog.debug('fn_getppavlroom:l_avlsyroomqtty:'||l_avlsyroomqtty);
        plog.debug('fn_getppavlroom:l_avlsyqtty:'||l_avlsyqtty);
        plog.debug('fn_getppavlroom:l_avlroomqtty:'||l_avlroomqtty);
        plog.debug('fn_getppavlroom:l_avlqtty:'||l_avlqtty);

        plog.debug('fn_getppavlroom:l_marginprice:'||l_marginprice);
        plog.debug('fn_getppavlroom:l_mrpriceloan:'||l_mrpriceloan);
        plog.debug('fn_getppavlroom:l_mrratiorate:'||l_mrratiorate);
        plog.debug('fn_getppavlroom:l_chksysctrl:'||l_chksysctrl);

        if l_chksysctrl = 'Y' then
            l_PP0_add:= least(least(l_marginrefprice, l_mrpriceloan) * l_mrratiorate /100 * l_avlqtty,
                             least(l_marginprice, l_mrpriceloan) * l_mrratiorate/100 * l_avlsyqtty);
        else
            l_PP0_add:= least(l_marginprice, l_mrpriceloan) * l_mrratiorate/100 * l_avlsyqtty;
        end if;
    end if;
    return l_PP0_add;
EXCEPTION
   WHEN OTHERS THEN
    plog.error('fn_getppavlroom:WHEN OTHERS THEN:'||SQLERRM);
    RETURN 0;
END fn_getppavlroom;
/

