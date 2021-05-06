CREATE OR REPLACE FUNCTION fn_getavlsymarkedtransferqtty (
        p_codeid IN VARCHAR2,
        p_amount IN NUMBER)
RETURN NUMBER
  IS
  l_amount      number;
  l_result      number;
  l_rolllimit   number;
  l_oldamt      number;
  l_oldprice    number;
  l_newprice    number;
  l_tempqtty    number;
  l_newtempqtty number;
  l_tempamt     number;
  l_markedqtty  number;


TYPE afpralloc_rectype IS RECORD (
    qtty  number(20,0)
);

TYPE afpralloc_arrtype IS TABLE OF afpralloc_rectype INDEX BY varchar2(10);


TYPE sealloc_rectype IS RECORD (
    qtty  number(20,0)
);

TYPE sealloc_arrtype IS TABLE OF sealloc_rectype INDEX BY varchar2(10);


TYPE seafpralloc_rectype IS RECORD (
    qtty  number(20,0)
);

TYPE seafpralloc_arrtype IS TABLE OF seafpralloc_rectype INDEX BY varchar2(20);



CURSOR IncreRecords IS
select se.codeid, nvl(se.avlmarginqtty,0) Si, nvl(pravllimit,0) pravllimit,
                pr.prinused / decode(nvl(pr.prlimit,0),0,1,pr.prlimit) rollratio
        from
            (select semr.codeid, (semr.trade + semr.receiving + semr.odqtty) avlmarginqtty
                from semargininfo semr) se,
            (select pr.codeid, (pr.syroomlimit - pr.syroomused - nvl(afpr.prinused,0)) pravllimit, pr.syroomlimit prlimit,nvl(afpr.prinused,0) prinused
                                    from vw_marginroomsystem pr, (select codeid, sum(prinused) prinused from vw_afpralloc_all where restype = 'S' group by codeid) afpr
                                    where pr.CODEID = afpr.CODEID(+)
                ) pr
        where se.codeid = pr.codeid and pr.codeid <> p_codeid
        and decode(pr.prlimit, 0, 100, round((100*nvl(pr.prinused,0))/pr.prlimit)) < (select to_number(varvalue)
                                                                                                from sysvar
                                                                                                where grname = 'MARGIN' and varname = 'SYROLLLIMIT')
        order by case when nvl(se.avlmarginqtty,0)/decode(nvl(pr.prlimit,0),0,1,pr.prlimit) < 1 then
                    nvl(se.avlmarginqtty,0)/decode(nvl(pr.prlimit,0),0,1,pr.prlimit) else 1 end,
                    pr.prinused / decode(nvl(pr.prlimit,0),0,1,pr.prlimit);

incre_rec IncreRecords%ROWTYPE;

CURSOR AfIncreRecords IS
       -- So du cac ma CK cua khach hang
        select se.afacctno , se.codeid,
                    least(trade + TOTALRECEIVING - EXECQTTY + TOTALBUYQTTY, nvl(sy_pravlremain,0) + nvl(sy_prinused,0)) AVLQTTY

                from
                (select se.codeid, af.actype, af.mriratio, se.afacctno,se.acctno, se.trade , nvl(sts.receiving,0) receiving,nvl(sts.t0receiving,0) t0receiving,nvl(sts.totalreceiving,0) totalreceiving,nvl(BUYQTTY,0) BUYQTTY,nvl(TOTALBUYQTTY,0) TOTALBUYQTTY,nvl(od.EXECQTTY,0) EXECQTTY, nvl(STS.MAMT,0) mamt, nvl(afpr.prinused,0) prinused, nvl(afpr.sy_prinused,0) sy_prinused
                    from semast se inner join afmast af on se.afacctno =af.acctno
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
                                    (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer from stschd where duetype = 'SM') sts_trf,
                                    (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                                   where od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
                                   and od.txdate =(select to_date(VARVALUE,'DD/MM/RRRR') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                                   AND od.deltd <> 'Y'
                                   and not(od.grporder='Y' and od.matchtype='P') --Lenh thoa thuan tong khong tinh vao
                                   AND od.exectype IN ('NS', 'MS','NB','BC')
                                )
                     group by AFACCTNO, CODEID
                     ) OD
                    on OD.afacctno =se.afacctno and OD.codeid =se.codeid
                    left join
                    (SELECT STS.CODEID,STS.AFACCTNO,
                            SUM(CASE WHEN DUETYPE ='RM' THEN AMT-AAMT-FAMT+PAIDAMT+PAIDFEEAMT-AMT*TYP.DEFFEERATE/100 ELSE 0 END) MAMT,
                            SUM(CASE WHEN DUETYPE ='RS' and nvl(sts_trf.islatetransfer,0) = 0 AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR') THEN QTTY-AQTTY ELSE 0 END) RECEIVING,
                            SUM(CASE WHEN DUETYPE ='RS' AND (nvl(sts_trf.islatetransfer,0) = 0 or sts_trf.trfbuydt = TO_DATE(sy.VARVALUE,'DD/MM/RRRR')) AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR') THEN QTTY-AQTTY ELSE 0 END) T0RECEIVING,
                            SUM(CASE WHEN DUETYPE ='RS' AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR') THEN QTTY-AQTTY ELSE 0 END) TOTALRECEIVING
                        FROM STSCHD STS, ODMAST OD, ODTYPE TYP,
                        (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer, trfbuydt from stschd where duetype = 'SM') sts_trf,
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
                securities_info sb,
                (
                    select pr.codeid,
                        greatest(max(pr.roomlimit) - nvl(sum(case when restype = 'M' then nvl(afpr.prinused,0) else 0 end),0),0) pravlremain,
                        greatest(max(pr.syroomlimit) - max(pr.syroomused) - nvl(sum(case when restype = 'S' then nvl(afpr.prinused,0) else 0 end),0),0) sy_pravlremain
                    from vw_marginroomsystem pr, vw_afpralloc_all afpr
                    where pr.codeid = afpr.codeid(+)
                    group by pr.codeid
                ) pr
                where se.codeid = pr.codeid
                and se.codeid <> p_codeid
                and se.codeid = incre_rec.codeid
                and (se.actype =rsk1.actype and se.codeid=rsk1.codeid)
                and se.codeid=sb.codeid
                and least(trade + TOTALRECEIVING - EXECQTTY + TOTALBUYQTTY,
            nvl(sy_pravlremain,0) + nvl(sy_prinused,0)) * nvl(rsk1.mrratioloan,0)/100 * least(sb.MARGINPRICE,nvl(rsk1.mrpriceloan,0)) > 0
       order by least(trade + TOTALRECEIVING - EXECQTTY + TOTALBUYQTTY, nvl(sy_pravlremain,0) + nvl(sy_prinused,0))  desc;

afincre_rec AfIncreRecords%ROWTYPE;


afpralloc_arr afpralloc_arrtype;
sealloc_arr sealloc_arrtype;
seafpralloc_arr seafpralloc_arrtype;

BEGIN
    dbms_output.put_line('p_codeid:'||p_codeid);
    l_amount := p_amount;
    l_result := 0;
    l_rolllimit := 0;
    l_oldamt    := 0;
    l_tempqtty  := 0;
    l_oldprice  := 0;
    l_newprice  := 0;
    l_tempamt   := 0;
    select to_number(varvalue) into l_rolllimit
    from sysvar
    where grname = 'MARGIN' and varname = 'SYROLLLIMIT';

    --delete afpralloc_temp;

    OPEN IncreRecords;
    loop
        FETCH IncreRecords INTO incre_rec;
        EXIT WHEN IncreRecords%NOTFOUND;
        begin

            OPEN AfIncreRecords;
            loop
                FETCH AfIncreRecords INTO afincre_rec;
                EXIT WHEN AfIncreRecords%NOTFOUND;
                begin
                    begin
                        select round((nvl(rsk.mrratioloan,0)/100)*least(sei.marginprice, rsk.mrpriceloan)) into l_oldprice
                        from afmast af, afserisk rsk, securities_info sei
                        where af.acctno = afincre_rec.afacctno
                                   and af.actype = rsk.actype
                                   and rsk.codeid = sei.codeid
                                   and rsk.codeid = p_codeid;
                    exception when others then
                        l_oldprice:=0;
                    end;
                    begin
                        select round((nvl(rsk.mrratioloan,0)/100)*least(sei.marginprice, rsk.mrpriceloan)) into l_newprice
                         from afmast af, afserisk rsk, securities_info sei
                         where af.acctno = afincre_rec.afacctno
                               and af.actype = rsk.actype
                               and rsk.codeid = sei.codeid
                               and rsk.codeid = afincre_rec.codeid;
                    exception when others then
                        l_newprice:=0;
                    end;
                    if l_oldprice * l_newprice > 0 then
                        --select nvl(sum(prinused),0) into l_markedqtty
                        --    from afpralloc_temp
                        --    where afacctno = afincre_rec.afacctno
                        --          and codeid = p_codeid;
                        begin
                            afpralloc_arr(afincre_rec.afacctno).qtty:=nvl(afpralloc_arr(afincre_rec.afacctno).qtty,0);
                        exception when no_data_found then
                            afpralloc_arr(afincre_rec.afacctno).qtty:=0;
                        end;
                        begin
                            sealloc_arr(afincre_rec.codeid).qtty:=nvl(sealloc_arr(afincre_rec.codeid).qtty,0);
                        exception when no_data_found then
                            sealloc_arr(afincre_rec.codeid).qtty:=0;
                        end;
                        begin
                            seafpralloc_arr(to_char(afincre_rec.afacctno||afincre_rec.codeid)).qtty:=nvl(seafpralloc_arr(to_char(afincre_rec.afacctno||afincre_rec.codeid)).qtty,0);
                        exception when no_data_found then
                            seafpralloc_arr(to_char(afincre_rec.afacctno||afincre_rec.codeid)).qtty:=0;
                        end;
                        begin
                            select (nvl(sum(afp.prinused),0)-max(nvl(afpralloc_arr(afincre_rec.afacctno).qtty,0)))*l_oldprice
                                into l_tempamt
                            from vw_afpralloc_all afp
                            where afp.afacctno = afincre_rec.afacctno
                                  and afp.codeid = p_codeid and restype = 'S'
                            group by afp.afacctno, afp.codeid;
                        exception when others then
                            l_tempamt:=0;
                        end;

                        select least(floor(((pr.syroomlimit*l_rolllimit)/100)-(nvl(pru.usedqtty,0)+pr.syroomused))*l_newprice,l_tempamt, greatest(afincre_rec.avlqtty-nvl(pra.usedqtty, 0),0)*l_newprice) into l_oldamt
                        from vw_marginroomsystem pr,
                             (select codeid, sum(prinused) + nvl(max(sealloc_arr(afincre_rec.codeid).qtty),0) usedqtty from vw_afpralloc_all where restype = 'S' group by codeid) pru,
                             (select codeid, sum(prinused) + nvl(max(seafpralloc_arr(to_char(afincre_rec.afacctno||afincre_rec.codeid)).qtty),0) usedqtty from vw_afpralloc_all where afacctno = afincre_rec.afacctno and restype = 'S' group by codeid) pra
                        where pr.codeid = afincre_rec.codeid
                              and pr.codeid = pru.codeid(+)
                              and pr.codeid = pra.codeid(+);

                        l_tempqtty := floor(l_oldamt/l_oldprice);
                        l_newtempqtty := floor(l_oldamt/l_newprice);
                        if l_tempqtty > 0 then

--dbms_output.put_line('AF:'||afincre_rec.afacctno||'.S:'||afincre_rec.codeid||'.M:'||l_tempamt||'.AVL:'||afincre_rec.avlqtty||'.Q:'||l_tempqtty||'.OP:'||l_oldprice||'.NP:'||l_newprice);
                            afpralloc_arr(afincre_rec.afacctno).qtty := nvl(afpralloc_arr(afincre_rec.afacctno).qtty,0) + l_tempqtty;
                            seafpralloc_arr(to_char(afincre_rec.afacctno||afincre_rec.codeid)).qtty := nvl(seafpralloc_arr(to_char(afincre_rec.afacctno||afincre_rec.codeid)).qtty,0) + l_newtempqtty;
                            sealloc_arr(afincre_rec.codeid).qtty:= nvl(sealloc_arr(afincre_rec.codeid).qtty,0) + l_newtempqtty;
                            l_result := l_result+l_tempqtty;
                        end if;

                    end if;
                    exit when l_result >= l_amount;
                 end;
                exit when l_result >= l_amount;
            end loop;
            close AfIncreRecords;


            exit when l_result >= l_amount;
        end;
    end loop;
    close IncreRecords;
    l_result := least(l_result, l_amount);
    RETURN l_result;
    EXCEPTION
    WHEN others THEN
        plog.error('error:'||dbms_utility.format_error_backtrace);
        plog.error('error message:'||SQLERRM);
        return 0;
END;
/

