CREATE OR REPLACE FUNCTION fn_getAVLQTTY(p_AFACCTNO in varchar2, p_CODEID IN VARCHAR2)
RETURN NUMBER
IS
    l_avlqtty NUMBER(20,0);
BEGIN

select (se.trade - nvl(sts.execsellqtty,0) + nvl(od.buyqtty,0) + nvl(sts.execbuyqtty,0)) - nvl(pr.prinused,0)
        into l_avlqtty
    from (select * from semast where afacctno = p_AFACCTNO and codeid = p_CODEID) se,
         (select * from afmast where acctno = p_AFACCTNO) af,
         aftype aft, mrtype mrt, securities_info sb, afmrserisk rsk,
        (select sts.afacctno, sts.codeid,
            sum(case when duetype = 'SS' then qtty - decode(status,'C',qtty,aqtty) - nvl(dfexecqtty,0) else 0 end) execsellqtty,
            sum(case when duetype = 'RS' then qtty - decode(status,'C',qtty,aqtty) else 0 end) execbuyqtty
            from stschd sts, odmast od,
                (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
            where duetype in ('SS','RS') and sts.afacctno = p_AFACCTNO and sts.codeid = p_CODEID and sts.deltd <> 'Y'
            and sts.orgorderid = dfex.orderid(+)
            and sts.orgorderid = od.orderid
            and not (od.grporder='Y' and od.matchtype='P')
            group by sts.afacctno, sts.codeid) sts,
        (select afacctno, codeid,
            sum(case when exectype = 'NB' then remainqtty else 0 end) buyqtty
            from odmast od
            where exectype = 'NB' and afacctno = p_AFACCTNO and codeid = p_CODEID and deltd <> 'Y' --and txdate = l_currdate
            and not (od.grporder='Y' and od.matchtype='P')
            group by afacctno, codeid) od,
        (select afacctno, codeid, sum(prinused) prinused
                       from vw_afpralloc_all
                       where afacctno = p_AFACCTNO and codeid = p_CODEID and restype = 'M'
                       group by afacctno,codeid
            ) pr
    where se.afacctno = p_AFACCTNO and se.codeid = p_CODEID
    and se.afacctno = af.acctno and af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
    and se.afacctno = sts.afacctno(+) and se.codeid = sts.codeid(+)
    and se.afacctno = od.afacctno(+) and se.codeid = od.codeid(+)
    and se.afacctno = pr.afacctno(+) and se.codeid = pr.codeid(+)
    and af.actype = rsk.actype and se.codeid = rsk.codeid and sb.codeid = se.codeid;

    RETURN l_avlqtty;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/

