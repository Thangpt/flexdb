CREATE OR REPLACE FUNCTION fn_getavlmarkedtransferqtty (
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
  l_newtempqtty    number;
  l_tempamt     number;


TYPE afpralloc_rectype IS RECORD (
    afacctno varchar2(10),
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
            (select sb.codeid, (semr.trade + semr.receiving + semr.odqtty) avlmarginqtty
                from semargininfo semr,
                (select distinct codeid, ismarginallow from afmrserisk where ismarginallow = 'Y') sb
                where sb.codeid = semr.codeid (+) ) se,
            (select pr.codeid, (pr.roomlimit - nvl(afpr.prinused,0)) pravllimit, pr.roomlimit prlimit,nvl(afpr.prinused,0) prinused
                                    from vw_marginroomsystem pr, (select codeid, sum(prinused) prinused from vw_afpralloc_all where restype = 'M' group by codeid) afpr
                                    where pr.CODEID = afpr.CODEID(+)
                ) pr
        where se.codeid = pr.codeid and pr.codeid <> p_codeid
        and decode(pr.prlimit, 0, 100, round((100*nvl(pr.prinused,0))/pr.prlimit)) < (select to_number(varvalue)
                                                                                                from sysvar
                                                                                                where grname = 'MARGIN' and varname = 'ROLLLIMIT')
        order by case when nvl(se.avlmarginqtty,0)/decode(nvl(pr.prlimit,0),0,1,pr.prlimit) < 1 then
                    nvl(se.avlmarginqtty,0)/decode(nvl(pr.prlimit,0),0,1,pr.prlimit) else 1 end,
                    pr.prinused / decode(nvl(pr.prlimit,0),0,1,pr.prlimit);

incre_rec IncreRecords%ROWTYPE;

CURSOR AfIncreRecords IS
       -- So du cac ma CK cua khach hang
       select seb.afacctno, seb.codeid, seb.trade + seb.receiving + nvl(sed.od_qtty,0) avlQtty from
       (select se.afacctno, se.codeid, sum(se.trade) trade, sum(nvl(sts.receiving,0)) receiving
         from semast se, afmast af, aftype aft, mrtype mrt,
         (select codeid,afacctno, (qtty - aqtty) receiving from stschd where txdate <> (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') and duetype = 'RS' and status <> 'C') sts
         where se.afacctno = af.acctno
         and af.actype = aft.actype
         and aft.mrtype = mrt.actype
         and se.afacctno = sts.afacctno (+) and se.codeid = sts.codeid (+)
         and mrt.mrtype = 'T'
         group by se.afacctno, se.codeid) seb,
       (select od.afacctno, od.codeid, sum(case when od.exectype = 'NB' then od.remainqtty else 0 end) - sum(execsellqtty) + sum(execbuyqtty) od_qtty
         from odmast od, afmast af, aftype aft, mrtype mrt,
         (select sts.codeid,sts.afacctno,
                 sum(case when sts.duetype = 'SS' then sts.qtty - decode(sts.status,'C',sts.qtty,sts.aqtty)  - nvl(dfexecqtty,0) else 0 end) execsellqtty,
                 sum(case when sts.duetype = 'RS' then sts.qtty - decode(sts.status,'C',sts.qtty,sts.aqtty) else 0 end) execbuyqtty
             from stschd sts, odmast od,
                            (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
             where sts.txdate = (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
             and sts.orgorderid = dfex.orderid(+)
             and sts.orgorderid = od.orderid
             and not (od.grporder='Y' and od.matchtype='P')
             and duetype in ('RS','SS') and status <> 'C'
             group by sts.codeid, sts.afacctno) sts
         where od.afacctno = af.acctno
         and af.actype = aft.actype
         and aft.mrtype = mrt.actype
         and od.afacctno = sts.afacctno (+) and od.codeid = sts.codeid (+)
         and mrt.mrtype = 'T'
         group by od.afacctno, od.codeid) sed
       where seb.afacctno = sed.afacctno(+) and seb.codeid = sed.codeid(+) and seb.codeid = incre_rec.codeid
       and seb.codeid <> p_codeid
       and seb.trade + seb.receiving + nvl(sed.od_qtty,0) > 0
       order by seb.trade + seb.receiving + nvl(sed.od_qtty,0) desc;

afincre_rec AfIncreRecords%ROWTYPE;

afpralloc_arr afpralloc_arrtype;
sealloc_arr sealloc_arrtype;
seafpralloc_arr seafpralloc_arrtype;

BEGIN
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
    where grname = 'MARGIN' and varname = 'ROLLLIMIT';

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
                        select round((least(nvl(rsk.mrratioloan,0),100-af.mriratio)/100)*least(sei.marginrefprice, rsk.mrpriceloan)) into l_oldprice
                        from afmast af, afmrserisk rsk, securities_info sei
                        where af.acctno = afincre_rec.afacctno
                                   and af.actype = rsk.actype
                                   and rsk.codeid = sei.codeid
                                   and rsk.codeid = p_codeid;
                    exception when others then
                        l_oldprice:=0;
                    end;
                    begin
                        select round((least(nvl(rsk.mrratioloan,0),100-af.mriratio)/100)*least(sei.marginrefprice, rsk.mrpriceloan)) into l_newprice
                         from afmast af, afmrserisk rsk, securities_info sei
                         where af.acctno = afincre_rec.afacctno
                               and af.actype = rsk.actype
                               and rsk.codeid = sei.codeid
                               and rsk.codeid = afincre_rec.codeid;
                    exception when others then
                        l_newprice:=0;
                    end;
                    if l_oldprice * l_newprice > 0 then
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
                            select sum(afp.prinused)*l_oldprice into l_tempamt
                            from vw_afpralloc_all afp
                            where afp.afacctno = afincre_rec.afacctno
                                  and afp.codeid = p_codeid and restype = 'M'
                            group by afp.afacctno, afp.codeid;
                        exception when others then
                            l_tempamt:=0;
                        end;

                        select least(floor(((pr.roomlimit*l_rolllimit)/100)-nvl(pru.usedqtty, 0))*l_newprice,l_tempamt, greatest(afincre_rec.avlqtty-nvl(pra.usedqtty, 0),0)*l_newprice) into l_oldamt
                        from vw_marginroomsystem pr,
                             (select codeid, sum(prinused) + nvl(max(sealloc_arr(afincre_rec.codeid).qtty),0) usedqtty from vw_afpralloc_all where restype = 'M' group by codeid) pru,
                             (select codeid, sum(prinused) + nvl(max(seafpralloc_arr(to_char(afincre_rec.afacctno||afincre_rec.codeid)).qtty),0) usedqtty from vw_afpralloc_all where afacctno = afincre_rec.afacctno and restype = 'M' group by codeid) pra
                        where pr.codeid = afincre_rec.codeid
                              and pr.codeid = pru.codeid(+)
                              and pr.codeid = pra.codeid(+);

                        l_tempqtty := floor(l_oldamt/l_oldprice);
                        l_newtempqtty := floor(l_oldamt/l_newprice);

                        if l_tempqtty > 0 then
                            --insert into afpralloc_temp (AUTOID, AFACCTNO, PRINUSED, CODEID, ALLOCTYP, ORGORDERID, TXDATE, TXNUM,RESTYPE)
                            --values (seq_afpralloc_temp.nextval, afincre_rec.afacctno, l_tempqtty, p_codeid, 'T', '', null, null,'S');
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

