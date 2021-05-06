CREATE OR REPLACE FUNCTION fn_markedafpralloc (p_afacctno varchar2,
                                p_codeid varchar2,
                                p_mark_flag varchar2,
                                p_alloctyp varchar2,
                                p_refid varchar2,
                                p_ismaxass varchar2,
                                p_ignorealert varchar2,
                                p_txdate varchar2,
                                p_txnum varchar2,
                                p_err_code in out VARCHAR2,
                                p_ist2  VARCHAR2 DEFAULT 'N')
return number
is
/*
-- Tham so in/ out function:
--  p_afacctno      So Tieu Khoan
--  p_codeid        Ma Chung khoan
--  p_mark_flag     Co Cap Nhap: M: mark; U: unmark; A: all
--  p_alloctyp      Phan bo: T: tam thoi; M: danh dau luon
--  p_refid         Tham chieu cho viec danh dau/ go danh dau
--  p_txdate        Ngay giao dich
--  p_txnum         So Chung Tu Giao Dich
--  p_err_code      Ma loi tra ve
*/
pkgctx   plog.log_ctx;
logrow   tlogdebug%ROWTYPE;

l_currdate date;
l_marked_outstanding number(20,0);
l_unmarked_outstanding number(20,0);
l_marked_sys_outstanding number(20,0);
l_unmarked_sys_outstanding number(20,0);
l_remain_outstanding number(20,0);
l_exec_outstanding number(20,0);
l_securedqtty number(20,0);
l_avlqtty number(20,0);
l_markedqtty number(20,0);
l_marginPrice number(20,0);
l_mrratioratio number(20,4);
l_afratioratio number(20,4);
l_actype varchar2(4);
l_type varchar2(10);
l_count number(10);
l_avllimit number(20,0);
l_hoststatus varchar2(1);
l_markroom74inday varchar2(1);
l_default_margin varchar2(1);
l_isMarginAccount varchar2(1);
l_maxdebcf number(20,0);
l_fomode    VARCHAR2(10);
l_afmode    VARCHAR2(10);
l_batchmode VARCHAR2(10);
l_isstopadv       varchar2(10);

CURSOR markedRecords IS
select pr.codeid, nvl(se.avlmarginqtty,0) Si, pr.prinused Qi, pr.prlimit Ri, nvl(pravllimit,0) pravllimit
        from
            (select sb.codeid, (semr.trade + semr.receiving + semr.odqtty) avlmarginqtty
                from semargininfo semr,
                (select distinct codeid from afmrserisk) sb
                where sb.codeid = semr.codeid(+)) se,
            (select pr.codeid, (pr.roomlimit - nvl(afpr.prinused,0)) pravllimit,
                    pr.roomlimit prlimit,
                    nvl(afpr.prinused,0) prinused
                                    from vw_marginroomsystem pr,
                                        (select codeid, sum(decode(restype,'M',prinused,0)) prinused
                                            from vw_afpralloc_all group by codeid) afpr
                                    where pr.CODEID = afpr.CODEID(+)
            ) pr
        where se.codeid = pr.codeid
            and exists (select 1 from semast se, afmast af1, afmrserisk rsk1
                            where se.afacctno = p_afacctno and se.codeid = pr.codeid
                            and se.afacctno = af1.acctno and se.codeid = rsk1.codeid and af1.actype = rsk1.actype and rsk1.mrratioloan * rsk1.mrpriceloan > 0 and rsk1.ismarginallow = 'Y')
        order by decode(pr.codeid,p_codeid,0,1),
                 case when nvl(se.avlmarginqtty,0)/decode(nvl(pr.prlimit,0),0,1,pr.prlimit) < 1 then
                        nvl(se.avlmarginqtty,0)/decode(nvl(pr.prlimit,0),0,1,pr.prlimit) else 1 end,
                 nvl(pr.prinused,0) / decode(nvl(pr.prlimit,0),0,1,pr.prlimit);

marked_rec markedRecords%ROWTYPE;


CURSOR sy_markedRecords IS
select pr.codeid, nvl(se.avlmarginqtty,0) Si, pr.sy_prinused sy_Qi, pr.sy_prlimit sy_Ri, nvl(sy_pravllimit,0) sy_pravllimit
        from
            (select sb.codeid, (semr.sytrade + semr.syreceiving + semr.syodqtty) avlmarginqtty
                from semargininfo semr,
                (select distinct codeid from afserisk) sb
                where sb.codeid = semr.codeid(+)) se,
            (select pr.codeid, (pr.syroomlimit - pr.syroomused - nvl(afpr.sy_prinused,0)) sy_pravllimit,
                    pr.syroomlimit sy_prlimit,
                    nvl(afpr.sy_prinused,0) sy_prinused
                                    from vw_marginroomsystem pr,
                                        (select codeid, sum(decode(restype,'S',prinused,0)) sy_prinused
                                            from vw_afpralloc_all group by codeid) afpr
                                    where pr.CODEID = afpr.CODEID(+)
            ) pr
        where se.codeid = pr.codeid
            and exists (select 1 from semast se, afmast af1, afserisk rsk1
                            where se.afacctno = p_afacctno and se.codeid = pr.codeid
                            and se.afacctno = af1.acctno and se.codeid = rsk1.codeid and af1.actype = rsk1.actype and rsk1.mrratioloan * rsk1.mrpriceloan > 0)
        order by decode(pr.codeid,p_codeid,0,1),
                 case when nvl(se.avlmarginqtty,0)/decode(nvl(pr.sy_prlimit,0),0,1,pr.sy_prlimit) < 1 then
                        nvl(se.avlmarginqtty,0)/decode(nvl(pr.sy_prlimit,0),0,1,pr.sy_prlimit) else 1 end,
                    nvl(pr.sy_prinused,0) / decode(nvl(pr.sy_prlimit,0),0,1,pr.sy_prlimit);

sy_marked_rec sy_markedRecords%ROWTYPE;


CURSOR unmarkedRecords IS
select pr.codeid, nvl(se.avlmarginqtty,0) Si, pr.prinused Qi, pr.prlimit Ri, nvl(pravllimit,0) pravllimit
        from
            (select sb.codeid, (semr.trade + semr.receiving + semr.odqtty) avlmarginqtty
                from semargininfo semr,
                (select distinct codeid from afmrserisk) sb
                where sb.codeid = semr.codeid(+)) se,
            (select pr.codeid, (pr.roomlimit - nvl(afpr.prinused,0)) pravllimit,
                    pr.roomlimit prlimit,
                    nvl(afpr.prinused,0) prinused
                                    from vw_marginroomsystem pr,
                                        (select codeid, sum(decode(restype,'M',prinused,0)) prinused
                                            from vw_afpralloc_all group by codeid) afpr
                                    where pr.CODEID = afpr.CODEID(+)
                ) pr
        where se.codeid = pr.codeid
            and exists (select 1 from semast se, afmast af1, afmrserisk rsk1
                            where se.afacctno = p_afacctno and se.codeid = pr.codeid
                            and se.afacctno = af1.acctno and se.codeid = rsk1.codeid and af1.actype = rsk1.actype and rsk1.mrratioloan * rsk1.mrpriceloan > 0 and rsk1.ismarginallow = 'Y')
        order by decode(pr.codeid,p_codeid,0,1),
                 case when nvl(se.avlmarginqtty,0)/decode(nvl(pr.prlimit,0),0,1,pr.prlimit) < 1 then
                        nvl(se.avlmarginqtty,0)/decode(nvl(pr.prlimit,0),0,1,pr.prlimit) else 1 end DESC,
                nvl(pr.prinused,0) / decode(nvl(pr.prlimit,0),0,1,pr.prlimit) DESC;

unmarked_rec unmarkedRecords%ROWTYPE;


CURSOR sy_unmarkedRecords IS
select pr.codeid, nvl(se.avlmarginqtty,0) Si, pr.sy_prinused sy_Qi, pr.sy_prlimit sy_Ri, nvl(sy_pravllimit,0) sy_pravllimit
        from
            (select sb.codeid, (semr.sytrade + semr.syreceiving + semr.syodqtty) avlmarginqtty
                from semargininfo semr,
                (select distinct codeid from afserisk) sb
                where sb.codeid = semr.codeid (+)) se,
            (select pr.codeid, (pr.syroomlimit - pr.syroomused - nvl(afpr.sy_prinused,0)) sy_pravllimit,
                    pr.syroomlimit sy_prlimit,
                    nvl(afpr.sy_prinused,0) sy_prinused
                                    from vw_marginroomsystem pr,
                                        (select codeid, sum(decode(restype,'S',prinused,0)) sy_prinused
                                            from vw_afpralloc_all group by codeid) afpr
                                    where pr.CODEID = afpr.CODEID(+)
                ) pr
        where se.codeid = pr.codeid
            and exists (select 1 from semast se, afmast af1, afserisk rsk1
                            where se.afacctno = p_afacctno and se.codeid = pr.codeid
                            and se.afacctno = af1.acctno and se.codeid = rsk1.codeid and af1.actype = rsk1.actype and rsk1.mrratioloan * rsk1.mrpriceloan > 0)
        order by decode(pr.codeid,p_codeid,0,1),
                 case when nvl(se.avlmarginqtty,0)/decode(nvl(pr.sy_prlimit,0),0,1,pr.sy_prlimit) < 1 then
                        nvl(se.avlmarginqtty,0)/decode(nvl(pr.sy_prlimit,0),0,1,pr.sy_prlimit) else 1 end DESC,
                nvl(pr.sy_prinused,0) / decode(nvl(pr.sy_prlimit,0),0,1,pr.sy_prlimit) DESC;

sy_unmarked_rec sy_unmarkedRecords%ROWTYPE;



BEGIN
--check co hach toan check room duoi BO ko?
SELECT nvl(varvalue,'OFF') INTO l_fomode FROM sysvar WHERE varname = 'FOMODE';
SELECT nvl(af.isfo,'N') INTO l_afmode FROM afmast af WHERE acctno = p_afacctno;
l_isstopadv := cspks_system.fn_get_sysvar('MARGIN','ISSTOPADV');
BEGIN
    SELECT nvl(bchsts,'N') INTO l_batchmode FROM sbbatchsts bs WHERE bs.bchmdl = 'SABFB' AND bchdate = to_date(p_txdate,'DD/MM/RRRR');
EXCEPTION WHEN OTHERS THEN
    l_batchmode := 'N';
END;
IF (l_fomode = 'OFF' OR l_afmode = 'N' OR l_batchmode = 'Y') THEN
    IF fn_markedafpralloc_2(p_afacctno,
                    p_codeid,
                    p_mark_flag,
                    p_alloctyp,
                    p_refid,
                    p_ismaxass,
                    p_ignorealert,
                    p_txdate,
                    p_txnum,
                    p_err_code) <> systemnums.C_SUCCESS THEN
        plog.setendsection(pkgctx, 'fn_markedafpralloc');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
ELSE
    RETURN systemnums.C_SUCCESS;
END IF;
--End check co hach toan check room duoi BO ko?
    begin
        FOR i IN (SELECT *
                FROM tlogdebug)
        LOOP
            logrow.loglevel    := i.loglevel;
            logrow.log4table   := i.log4table;
            logrow.log4alert   := i.log4alert;
            logrow.log4trace   := i.log4trace;
        END LOOP;
    exception when others then
        null;
    end;
    pkgctx    :=
         plog.init ('fn_markedafpralloc',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
    plog.debug (pkgctx, '<<BEGIN OF fn_markedafpralloc');
    --plog.debug (pkgctx, 'fn_markedafpralloc on AFACCTNO:'||p_afacctno);

    pr_error ('fn_markedafpralloc','Begin function ');
    select varvalue into l_hoststatus
    from sysvar
    where varname = 'HOSTATUS' and grname = 'SYSTEM';

    select varvalue into l_markroom74inday
    from sysvar
    where varname = 'MARKROOM74INDAY' and grname = 'SYSTEM';


    --Chi danh dau voi tai khoan CreditLine
    select count(1) into l_count
    from afmast af, aftype aft, mrtype mrt
    where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
        and af.acctno = p_afacctno;
    if l_count = 0 then
        return systemnums.C_SUCCESS;
    end if;

    --Chi danh dau voi tai khoan Margin, co tuan thu muc he thong.
    select count(1) into l_count
    from afmast af, aftype aft, mrtype mrt, lntype lnt
    where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
        and aft.lntype = lnt.actype(+)
        and (lnt.chksysctrl = 'Y'
            or exists (select 1 from afidtype afid, lntype lnt
                    where afid.actype = lnt.actype and afid.aftype = aft.actype and afid.objname = 'LN.LNTYPE' and lnt.chksysctrl = 'Y'))
        and af.acctno = p_afacctno;

    --Neu Tieu khoan khong danh dau bat buoc tuan thu he thong hoac ko phai lai tieu khoan margin -> Khong can hach toan nguon.
    if l_count > 0 then
        l_isMarginAccount:='Y';
    else
        l_isMarginAccount:='N';
    end if;

    --Xem co phai loai hinh LNTYPE default la tuan thu hay khong?. Neu la loai hinh tuan thu, du tinh trong ngay. Hay nguoc lai
    select count(1)
        into l_count
    from afmast af, aftype aft, mrtype mrt, lntype lnt
    where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
        and aft.lntype = lnt.actype(+)
        and lnt.chksysctrl = 'Y'
        and af.acctno = p_afacctno;
    if l_count <> 0 then
        l_default_margin:='Y';
    else
        l_default_margin:='N';
    end if;

    select to_date(varvalue,systemnums.C_DATE_FORMAT) into l_currdate from sysvar where varname = 'CURRDATE';
    select to_number(varvalue) into l_maxdebcf from sysvar where varname = 'MAXDEBTCF';
    select 100 - mriratio into l_afratioratio from afmast where acctno = p_afacctno;

    pr_error ('fn_markedafpralloc',' l_isMarginAccount: '||l_isMarginAccount||' - '||' l_default_margin: '||l_default_margin||' - '||' l_afratioratio: '||l_afratioratio);
    -- << Unmarked when miss asset
    if p_mark_flag in ('U','A') then
        if l_isMarginAccount = 'Y' and  l_markroom74inday = 'Y' then -- l_hoststatus = '0' then
            for rec in
            (
                select se.codeid, sum(greatest( case when se.roomchk ='Y' then se.trade - nvl(sts.execsellqtty,0) + nvl(od.buyqtty,0) + nvl(sts.execbuyqtty,0) else 0 end ,0) - nvl(pr.prinused,0)) avlqtty

                from (select * from semast where afacctno = p_afacctno) se,
                     (select * from afmast where acctno = p_afacctno) af,
                     aftype aft, mrtype mrt, securities_info sb,
                    (select sts.afacctno, sts.codeid,
                        sum(case when duetype = 'SS' then qtty - decode(status,'C',qtty,aqtty) - nvl(dfexecqtty,0) else 0 end) execsellqtty,
                        sum(case when duetype = 'RS' then qtty - decode(status,'C',qtty,aqtty) else 0 end) execbuyqtty
                        from stschd sts, odmast od,
                            (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                        where duetype in ('SS','RS') and sts.afacctno = p_afacctno and sts.deltd <> 'Y'
                        and sts.orgorderid = dfex.orderid(+)
                        and sts.orgorderid = od.orderid
                        and not (od.grporder='Y' and od.matchtype='P')
                        group by sts.afacctno, sts.codeid) sts,
                    (select afacctno, codeid,
                        sum(case when exectype = 'NB' then remainqtty else 0 end) buyqtty
                        from odmast od
                        where exectype = 'NB' and afacctno = p_afacctno and deltd <> 'Y' and txdate = l_currdate
                        and not (od.grporder='Y' and od.matchtype='P')
                        group by afacctno, codeid) od,
                    (select afacctno, codeid, sum(prinused) prinused
                                   from vw_afpralloc_all
                                   where afacctno = p_afacctno and restype = 'M'
                                   group by afacctno,codeid
                        ) pr
                where se.afacctno = p_afacctno
                and se.afacctno = af.acctno and af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
                and se.afacctno = sts.afacctno(+) and se.codeid = sts.codeid(+)
                and se.afacctno = od.afacctno(+) and se.codeid = od.codeid(+)
                and se.afacctno = pr.afacctno(+) and se.codeid = pr.codeid(+)
                and sb.codeid = se.codeid
                group by se.codeid
                having sum(greatest( case when se.roomchk ='Y' then se.trade - nvl(sts.execsellqtty,0) + nvl(od.buyqtty,0) + nvl(sts.execbuyqtty,0) else 0 end ,0) - nvl(pr.prinused,0)) < 0
            )
            loop
                if rec.avlqtty < 0 then
                    INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
                    VALUES(seq_afpralloc.nextval,p_afacctno,rec.avlqtty,rec.codeid,p_alloctyp,p_refid,to_date(p_txdate,systemnums.c_date_format), p_txnum,'M');
                end if;
            end loop;
        end if;

        --if l_isMarginAccount <> 'Y' then
            -- Xac dinh so luong chung khoan co the phan bo vao nguon. = min (SLCK kha dung cua nguon, SLCK co the vay cua TK).
            pr_error ('fn_markedafpralloc','        Begin Xac dinh so luong chung khoan co the phan bo vao nguon. ');
            for rec IN
            (
                select se.codeid, sum(greatest(case when se.roomchk ='Y' then se.trade - nvl(sts.execsellqtty,0) + nvl(od.buyqtty,0) + nvl(sts.execbuyqtty,0) else 0 end,0) - nvl(pr.sy_prinused,0)) avlqtty
                from (select * from semast where afacctno = p_afacctno) se,
                     (select * from afmast where acctno = p_afacctno) af, aftype aft, mrtype mrt, securities_info sb,
                    (select sts.afacctno, sts.codeid,
                        sum(case when duetype = 'SS' then qtty - decode(status,'C',qtty,aqtty) - nvl(dfexecqtty,0) else 0 end) execsellqtty,
                        sum(case when duetype = 'RS' then qtty - decode(status,'C',qtty,aqtty) else 0 end) execbuyqtty
                        from stschd sts, odmast od,
                            (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                        where duetype in ('SS','RS') and sts.afacctno = p_afacctno and sts.deltd <> 'Y'
                        and sts.orgorderid = dfex.orderid(+)
                        and sts.orgorderid = od.orderid
                        and not (od.grporder='Y' and od.matchtype='P')
                        group by sts.afacctno, sts.codeid) sts,
                    (select afacctno, codeid,
                        sum(case when exectype = 'NB' then remainqtty else 0 end) buyqtty
                        from odmast od
                        where exectype = 'NB' and afacctno = p_afacctno and deltd <> 'Y' and txdate = l_currdate
                        and not (od.grporder='Y' and od.matchtype='P')
                        group by afacctno, codeid) od,
                    (select afacctno, codeid, sum(prinused) sy_prinused
                                   from vw_afpralloc_all
                                   where afacctno = p_afacctno and restype = 'S'
                                   group by afacctno,codeid
                        ) pr
                where se.afacctno = p_afacctno
                and se.afacctno = af.acctno and af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
                and se.afacctno = sts.afacctno(+) and se.codeid = sts.codeid(+)
                and se.afacctno = od.afacctno(+) and se.codeid = od.codeid(+)
                and se.afacctno = pr.afacctno(+) and se.codeid = pr.codeid(+)
                and sb.codeid = se.codeid
                group by se.codeid
                having sum(greatest(case when se.roomchk ='Y' then se.trade - nvl(sts.execsellqtty,0) + nvl(od.buyqtty,0) + nvl(sts.execbuyqtty,0) else 0 end,0) - nvl(pr.sy_prinused,0))  < 0

            )
            loop
                if rec.avlqtty < 0 then
                    INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM, RESTYPE)
                    VALUES(seq_afpralloc.nextval,p_afacctno, rec.avlqtty,rec.codeid,p_alloctyp,p_refid,to_date(p_txdate,systemnums.c_date_format), p_txnum, 'S');
                end if;
            end loop;
        --end if;
    end if;
    -- >> End Unmarked when miss asset

    pr_error ('fn_markedafpralloc','    Begin xac dinh du no sau event thuc hien  ');
    --1. xac dinh du no sau event thuc hien.
    begin

        select  greatest(greatest(outstanding, 0) - outstanding_prinused,0),
                greatest(outstanding_prinused - greatest(outstanding,0),0),

                greatest(greatest(sy_outstanding, 0) - sy_outstanding_prinused,0),
                greatest(sy_outstanding_prinused - greatest(sy_outstanding,0),0)

            into l_marked_outstanding,l_unmarked_outstanding,
                l_marked_sys_outstanding,l_unmarked_sys_outstanding
        from
        (
            select
                   least(
                        greatest(    -least(
                                                decode(l_hoststatus,'1',balance+decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)),greatest(balance+decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0)),0))
                                        - nvl(t0.marginamt,0)
                                        - decode(p_ist2,'Y',nvl(trf.trfsecuredamt_inday,0) + nvl(trf.secureamt_inday,0), nvl(b.secureamt,0) + nvl(b.overamt,0))
                                                * decode(l_default_margin,'Y',1,0)
                                                * (case when af.trfbuyrate * af.trfbuyext > 0 AND p_ist2 = 'N' then 0 else 1 end)
                                        +least(af.mrcrlimit,(decode(p_ist2,'Y',nvl(trf.trfsecuredamt_inday,0) + nvl(trf.secureamt_inday,0), nvl(b.secureamt,0) + nvl(b.overamt,0))
                                                * decode(l_default_margin,'Y',1,0)
                                                * (case when af.trfbuyrate * af.trfbuyext > 0 AND p_ist2 = 'N' then 0 else 1 end)))
                                    ,0)
                                ,0),
                        least(least(nvl(af.mrcrlimitmax,0),l_maxdebcf) - mst.dfodamt,/*af.mrcrlimit +*/ decode(p_ismaxass,'Y',nvl(sec.semaxtotalmramt,0),nvl(sec.setotalmramt,0)) )) outstanding,
                   nvl(se.usedmargin,0) + nvl(sec.usedmargin,0) /*+ least(nvl(af.mrcrlimitmax,0),l_maxdebcf, af.mrcrlimit)*/ outstanding_prinused,
                   least(
                        greatest(    -least(
                                          decode(l_hoststatus,'1',
                                                                                        balance+decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0))
                                                                                                - mst.dfdebtamt
                                                                                                - mst.dfintdebtamt
                                                                                                - mst.depofeeamt
                                                                                                - nvl(t0.t0prin,0),
                                                                                        greatest(balance+decode(l_isstopadv,'Y',0,NVL(adv.avladvance,0))
                                                                                                - mst.dfdebtamt
                                                                                                - mst.dfintdebtamt
                                                                                                - mst.depofeeamt
                                                                                                - nvl(t0.t0prin,0),0))

                                        - mst.trfbuyamt
                                        - nvl(t0.nonmarginamt,0)
                                        - nvl(t0.marginamt,0)
                                        - decode(p_ist2,'Y',nvl(trf.trfsecuredamt_inday,0) + nvl(trf.secureamt_inday,0), nvl(b.secureamt,0) + nvl(b.overamt,0))
                                                * (case when af.trfbuyrate * trfbuyext > 0 AND p_ist2 = 'N' then 0 else 1 end)
                                        +least(af.mrcrlimit,(decode(p_ist2,'Y',nvl(trf.trfsecuredamt_inday,0) + nvl(trf.secureamt_inday,0), nvl(b.secureamt,0) + nvl(b.overamt,0))
                                                * (case when af.trfbuyrate * trfbuyext > 0 AND p_ist2 = 'N' then 0 else 1 end)))
                                    ,0)
                                ,0),
                         least(nvl(af.mrcrlimitmax,0) - mst.dfodamt,/*af.mrcrlimit +*/ decode(p_ismaxass,'Y',nvl(sec.semaxtotalamt,0),nvl(sec.setotalamt,0)) )) sy_outstanding,
                   nvl(se.sy_usedmargin,0) + nvl(sec.sy_usedmargin,0) /*+ least(nvl(af.mrcrlimitmax,0),af.mrcrlimit)*/ sy_outstanding_prinused


                from (select * from cimast where acctno = p_afacctno) mst,
                    (select * from afmast where acctno = p_afacctno) af,
                    (select pr.afacctno,
                            sum(nvl(pr.prinused,0) * least(nvl(rsk2.mrpriceloan,0), sb.marginrefprice) * least(nvl(rsk2.mrratioloan,0),l_afratioratio) / 100) usedmargin,
                            sum(nvl(pr.sy_prinused,0) * least(nvl(rsk1.mrpriceloan,0), sb.marginprice) * nvl(rsk1.mrratioloan,0) / 100) sy_usedmargin
                         from aftype aft, mrtype mrt,
                              (select afpr.afacctno, afpr.actype, pr.codeid,
                                    sum(case when restype = 'M' then nvl(afpr.prinused,0) else 0 end) prinused,
                                    sum(case when restype = 'S' then nvl(afpr.prinused,0) else 0 end) sy_prinused
                                    from (select afacctno, af.actype, codeid, restype, sum(prinused) prinused
                                            from afmast af,
                                                 (select * from afpralloc where afacctno = p_afacctno
                                                    union all
                                                  select * from afprallocation where afacctno = p_afacctno) afp
                                            where af.acctno = afp.afacctno
                                            group by afacctno, af.actype, codeid, restype) afpr, vw_marginroomsystem pr
                                    where afpr.codeid = pr.codeid
                                    group by afpr.afacctno, afpr.actype, pr.codeid
                                 ) pr,
                                securities_info sb,
                                afserisk rsk1,
                                afmrserisk rsk2
                             where pr.codeid = sb.codeid
                             and pr.codeid = rsk1.codeid and pr.actype = rsk1.actype
                             and pr.codeid = rsk2.codeid and pr.actype = rsk2.actype
                             and pr.actype = aft.actype and aft.mrtype = mrt.actype
                             and mrt.mrtype = 'T'
                        group by pr.afacctno) se,
                    (select * from v_getbuyorderinfo where afacctno = p_afacctno) b,
                    (select * from v_getsecmargininfo where afacctno = p_afacctno) sec,
                    (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance where afacctno = p_afacctno group by afacctno) adv,
                    (select trfacctno,
                                sum(decode(lnt.chksysctrl,'Y',1,0)*(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) marginamt,
                                sum(decode(lnt.chksysctrl,'Y',0,1)*(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd)) nonmarginamt,
                                sum(oprinnml + oprinovd + ointnmlacr + ointdue + ointovdacr + ointnmlovd) t0prin
                            from lnmast ln, lntype lnt
                            where ln.actype = lnt.actype and ln.ftype = 'AF' and ln.trfacctno = p_afacctno
                            group by trfacctno) t0,
                    (SELECT * FROM vw_trfbuyinfo_inday where afacctno = p_afacctno) trf
                where mst.afacctno = p_afacctno and mst.acctno = af.acctno
                and mst.afacctno = se.afacctno(+)
                and mst.afacctno = b.afacctno(+)
                and mst.afacctno = sec.afacctno(+)
                and mst.afacctno = adv.afacctno(+)
                and mst.afacctno = t0.trfacctno(+)
                AND mst.afacctno = trf.afacctno(+)
        );
    exception when others then
        plog.error (pkgctx, SQLERRM);
        l_marked_outstanding:= 0;
        l_unmarked_outstanding:= 0;
        l_marked_sys_outstanding:= 0;
        l_unmarked_sys_outstanding:= 0;
    end;
    pr_error ('fn_markedafpralloc','    End xac dinh du no sau event thuc hien  ');
    pr_error('fn_markedafpralloc','l_marked_outstanding:'||l_marked_outstanding);
    pr_error('fn_markedafpralloc','l_unmarked_outstanding:'||l_unmarked_outstanding);
    pr_error('fn_markedafpralloc','l_marked_sys_outstanding:'||l_marked_sys_outstanding);
    pr_error('fn_markedafpralloc','l_unmarked_sys_outstanding:'||l_unmarked_sys_outstanding);

    --2. Theo thuat giai phan bo tai san dam bao. Neu Room hoac Pool thieu -> reject event.
    /*
        Chu y:  Chi dung tren cac nguon ma tieu khoan khach hang co ton tai chung khoan de thuc hien ki quy.
                Neu tat ca ck khoan lam tai san dam bao da het nguon. -> reject.
    */
    -->>> MARK Margin
    if l_marked_outstanding > 0 and l_isMarginAccount = 'Y' and p_mark_flag in ('M','A') and l_markroom74inday='Y' then --l_hoststatus = '0' then -- chi danh dau tai san dam bao khi co du no phat sinh them.
        l_remain_outstanding:= l_marked_outstanding;
        --plog.debug ('markedRecords.l_remain_outstanding:'||l_remain_outstanding);
        --select 100 - mriratio into l_afratioratio from afmast where acctno = p_afacctno;
        --Xac dinh ma chung khoan co nguon phu hop nhat.
        --pr_error ('fn_markedafpralloc','    Begin markedRecords  ');
        OPEN markedRecords;
        --pr_error ('fn_markedafpralloc','    End markedRecords  ');
        pr_error ('fn_markedafpralloc','    Begin Loop markedRecords  ');
        loop
            FETCH markedRecords INTO marked_rec;
            EXIT WHEN markedRecords%NOTFOUND;

            --plog.debug(pkgctx,'markedRecords.marked_rec:BEGIN LOOP - codeid:'||marked_rec.codeid);
            -- Xac dinh so luong chung khoan co the phan bo vao nguon. = min (SLCK kha dung cua nguon, SLCK co the vay cua TK).
            pr_error ('fn_markedafpralloc','        Begin Xac dinh so luong chung khoan co the phan bo  '|| 'TK '||p_afacctno||' codeid: '||marked_rec.codeid);
            begin
                select af.actype, (se.trade - nvl(sts.execsellqtty,0) + nvl(od.buyqtty,0) + nvl(sts.execbuyqtty,0)) - nvl(pr.prinused,0), least(rsk.mrpriceloan, sb.marginrefprice) marginprice, least(rsk.mrratioloan,l_afratioratio)
                    into l_actype, l_avlqtty, l_marginPrice, l_mrratioratio
                from (select * from semast where afacctno = p_afacctno and codeid = marked_rec.codeid and roomchk ='Y') se,
                     (select * from afmast where acctno = p_afacctno) af,
                     aftype aft, mrtype mrt, securities_info sb, afmrserisk rsk,
                    (select sts.afacctno, sts.codeid,
                        sum(case when duetype = 'SS' then qtty - decode(status,'C',qtty,aqtty) - nvl(dfexecqtty,0) else 0 end) execsellqtty,
                        sum(case when duetype = 'RS' then qtty - decode(status,'C',qtty,aqtty) else 0 end) execbuyqtty
                        from stschd sts, odmast od,
                            (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                        where duetype in ('SS','RS') and sts.afacctno = p_afacctno and sts.codeid = marked_rec.codeid and sts.deltd <> 'Y'
                        and sts.orgorderid = dfex.orderid(+)
                        and sts.orgorderid = od.orderid
                        and not (od.grporder='Y' and od.matchtype='P')
                        group by sts.afacctno, sts.codeid) sts,
                    (select afacctno, codeid,
                        sum(case when exectype = 'NB' then remainqtty else 0 end) buyqtty
                        from odmast od
                        where exectype = 'NB' and afacctno = p_afacctno and codeid = marked_rec.codeid and deltd <> 'Y' and txdate = l_currdate
                        and not (od.grporder='Y' and od.matchtype='P')
                        group by afacctno, codeid) od,
                    (select afacctno, codeid, sum(prinused) prinused
                                   from vw_afpralloc_all
                                   where afacctno = p_afacctno and codeid = marked_rec.codeid and restype = 'M'
                                   group by afacctno,codeid
                        ) pr
                where se.afacctno = p_afacctno and se.codeid = marked_rec.codeid
                and se.afacctno = af.acctno and af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
                and se.afacctno = sts.afacctno(+) and se.codeid = sts.codeid(+)
                and se.afacctno = od.afacctno(+) and se.codeid = od.codeid(+)
                and se.afacctno = pr.afacctno(+) and se.codeid = pr.codeid(+)
                and af.actype = rsk.actype and se.codeid = rsk.codeid and sb.codeid = se.codeid;

            exception when others then
                --plog.debug(pkgctx,'markedRecords.LOOP IGNORE:codeid:'||marked_rec.codeid);
                CONTINUE;
            end;
            if l_marginPrice * l_mrratioratio = 0 then
                --plog.debug(pkgctx,'markedRecords.LOOP IGNORE:codeid:'||marked_rec.codeid);
                CONTINUE;
            end if;
            pr_error ('fn_markedafpralloc','        End Xac dinh so luong chung khoan co the phan bo  ');
            pr_error('markedRecords.','pravllimit:'||marked_rec.pravllimit);
            pr_error('markedRecords.','l_avlqtty:'||l_avlqtty);
            pr_error('markedRecords.','l_marginPrice:'||l_marginPrice);
            pr_error('markedRecords.','l_mrratioratio:'||l_mrratioratio);
            l_exec_outstanding:= greatest(least(least(l_avlqtty,marked_rec.pravllimit) * l_marginPrice * (l_mrratioratio/100), l_remain_outstanding),0);
            pr_error('markedRecords.','l_exec_outstanding:'||l_exec_outstanding);
            l_securedqtty:= ceil(l_exec_outstanding / (l_marginPrice * (l_mrratioratio/100)));
            pr_error('markedRecords.','l_securedqtty:'||l_securedqtty);
            --Phan bo nguon theo ma CK da xac dinh. (co the phan bo vao nhieu room, neu thoa man dieu kien)
            --xac dinh cac room phai hach toan
            pr_error ('fn_markedafpralloc','        Begin INSERT INTO afpralloc');
            if l_securedqtty > 0 then
               INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID, TXDATE, TXNUM, RESTYPE)
               VALUES(seq_afpralloc.nextval,p_afacctno,l_securedqtty,marked_rec.codeid,p_alloctyp,p_refid,to_date(p_txdate,systemnums.c_date_format), p_txnum, 'M');
            end if;
            pr_error ('fn_markedafpralloc','        End INSERT INTO afpralloc');
            l_remain_outstanding:= l_remain_outstanding - l_exec_outstanding;
            pr_error ('markedRecords.After effected. ','l_remain_outstanding:'||l_remain_outstanding);

            exit when l_remain_outstanding <= 0;
        end loop;
        close markedRecords;
        pr_error ('fn_markedafpralloc','    End Loop markedRecords  ');
        if l_remain_outstanding > 0 then
            --plog.debug(pkgctx,'markedRecords.END LOOP - l_remain_outstanding:'||l_remain_outstanding);
            -- Da het nguon phu hop.
            if cspks_system.fn_get_sysvar('SYSTEM', 'HOSTATUS') = '1' and p_ignorealert = 'N' THEN
                p_err_code:= '-100523';
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
    end if;

    -->>> MARK System
    if l_marked_sys_outstanding > 0 and p_mark_flag in ('M','A') then -- chi danh dau tai san dam bao khi co du no phat sinh them.
        l_remain_outstanding:= l_marked_sys_outstanding;
        --plog.debug ('markedRecords.l_remain_outstanding:'||l_remain_outstanding);
        --Xac dinh ma chung khoan co nguon phu hop nhat.
        pr_error ('fn_markedafpralloc','    Begin OPEN sy_markedRecords');
        OPEN sy_markedRecords;
        pr_error ('fn_markedafpralloc','    End OPEN sy_markedRecords');
        pr_error ('fn_markedafpralloc','    Begin Loop sy_markedRecords');
        loop
            FETCH sy_markedRecords INTO sy_marked_rec;
            EXIT WHEN sy_markedRecords%NOTFOUND;

            --plog.debug(pkgctx,'markedRecords.sy_marked_rec:BEGIN LOOP - codeid:'||sy_marked_rec.codeid);
            -- Xac dinh so luong chung khoan co the phan bo vao nguon. = min (SLCK kha dung cua nguon, SLCK co the vay cua TK).
            pr_error ('fn_markedafpralloc','        Begin Xac dinh so luong chung khoan co the phan bo vao nguon');
            begin
                select af.actype, (se.trade - nvl(sts.execsellqtty,0) + nvl(od.buyqtty,0) + nvl(sts.execbuyqtty,0)) - nvl(pr.sy_prinused,0), least(rsk.mrpriceloan, sb.marginprice) marginprice, rsk.mrratioloan
                    into l_actype, l_avlqtty, l_marginPrice, l_mrratioratio
                from (select * from semast where afacctno = p_afacctno and codeid = sy_marked_rec.codeid and roomchk ='Y') se,
                     (select * from afmast where acctno = p_afacctno) af, aftype aft, mrtype mrt, securities_info sb, afserisk rsk,
                    (select sts.afacctno, sts.codeid,
                        sum(case when duetype = 'SS' then qtty - decode(status,'C',qtty,aqtty) - nvl(dfexecqtty,0) else 0 end) execsellqtty,
                        sum(case when duetype = 'RS' then qtty - decode(status,'C',qtty,aqtty) else 0 end) execbuyqtty
                        from stschd sts, odmast od,
                            (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                        where duetype in ('SS','RS') and sts.afacctno = p_afacctno and sts.codeid = sy_marked_rec.codeid and sts.deltd <> 'Y'
                        and sts.orgorderid = dfex.orderid(+)
                        and sts.orgorderid = od.orderid
                        and not (od.grporder='Y' and od.matchtype='P')
                        group by sts.afacctno, sts.codeid) sts,
                    (select afacctno, codeid,
                        sum(case when exectype = 'NB' then remainqtty else 0 end) buyqtty
                        from odmast od
                        where exectype = 'NB' and afacctno = p_afacctno and codeid = sy_marked_rec.codeid and deltd <> 'Y' and txdate = l_currdate
                        and not (od.grporder='Y' and od.matchtype='P')
                        group by afacctno, codeid) od,
                    (select afacctno, codeid, sum(prinused) sy_prinused
                                   from vw_afpralloc_all
                                   where afacctno = p_afacctno and codeid = sy_marked_rec.codeid and restype = 'S'
                                   group by afacctno,codeid
                        ) pr
                where se.afacctno = p_afacctno and se.codeid = sy_marked_rec.codeid
                and se.afacctno = af.acctno and af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
                and se.afacctno = sts.afacctno(+) and se.codeid = sts.codeid(+)
                and se.afacctno = od.afacctno(+) and se.codeid = od.codeid(+)
                and se.afacctno = pr.afacctno(+) and se.codeid = pr.codeid(+)
                and af.actype = rsk.actype and rsk.codeid = se.codeid and sb.codeid = se.codeid;

            exception when others then
                --plog.debug(pkgctx,'sy_markedRecords.LOOP IGNORE:codeid:'||sy_marked_rec.codeid);
                CONTINUE;
            end;
            if l_marginPrice * l_mrratioratio = 0 then
                --plog.debug(pkgctx,'sy_markedRecords.LOOP IGNORE:codeid:'||sy_marked_rec.codeid);
                CONTINUE;
            end if;
            pr_error ('fn_markedafpralloc','        End Xac dinh so luong chung khoan co the phan bo vao nguon');
            pr_error('sy_markedRecords.','pravllimit:'||sy_marked_rec.sy_pravllimit);
            pr_error('sy_markedRecords.','l_avlqtty:'||l_avlqtty);
            pr_error('sy_markedRecords.','l_marginPrice:'||l_marginPrice);
            pr_error('sy_markedRecords.','l_mrratioratio:'||l_mrratioratio);
            l_exec_outstanding:= greatest(least(least(l_avlqtty,sy_marked_rec.sy_pravllimit) * l_marginPrice * (l_mrratioratio/100), l_remain_outstanding),0);
            pr_error('sy_markedRecords.','l_exec_outstanding:'||l_exec_outstanding);
            l_securedqtty:= ceil(l_exec_outstanding / (l_marginPrice * (l_mrratioratio/100)));
            pr_error('sy_markedRecords.','l_securedqtty:'||l_securedqtty);
            --Phan bo nguon theo ma CK da xac dinh. (co the phan bo vao nhieu room, neu thoa man dieu kien)
            --xac dinh cac room phai hach toan
            if l_securedqtty > 0 then
               INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID, TXDATE, TXNUM, RESTYPE)
               VALUES(seq_afpralloc.nextval,p_afacctno,l_securedqtty,sy_marked_rec.codeid,p_alloctyp,p_refid,to_date(p_txdate,systemnums.c_date_format), p_txnum,'S');
            end if;

            l_remain_outstanding:= l_remain_outstanding - l_exec_outstanding;
            pr_error('sy_markedRecords.After effected. ','l_remain_outstanding:'||l_remain_outstanding);

            exit when l_remain_outstanding <= 0;
        end loop;
        close sy_markedRecords;
        pr_error ('fn_markedafpralloc','    End Loop sy_markedRecords');
        if l_remain_outstanding > 0 then
            --plog.debug(pkgctx,'markedRecords.END LOOP - l_remain_outstanding:'||l_remain_outstanding);
            -- Da het nguon phu hop.
            if cspks_system.fn_get_sysvar('SYSTEM', 'HOSTATUS') = '1' and p_ignorealert = 'N' THEN
                p_err_code:= '-100523';
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
    end if;

    -->>> UNMARK Margin
    if l_unmarked_outstanding > 0 and l_isMarginAccount = 'Y' and p_mark_flag in ('U','A') and l_markroom74inday = 'Y' then -- l_hoststatus = '0' then
        l_remain_outstanding:= l_unmarked_outstanding;
        --Xac dinh ma chung khoan co nguon phu hop nhat.
        --select 100 - mriratio into l_afratioratio from afmast where acctno = p_afacctno;
        pr_error ('fn_markedafpralloc','    Begin unmarkedRecords  ');
        OPEN unmarkedRecords;
        pr_error ('fn_markedafpralloc','    End unmarkedRecords  ');
        pr_error ('fn_markedafpralloc','    Begin Loop unmarkedRecords  ');
        loop
            FETCH unmarkedRecords INTO unmarked_rec;
            EXIT WHEN unmarkedRecords%NOTFOUND;

            -- Xac dinh so luong chung khoan co the phan bo vao nguon. = min (SLCK kha dung cua nguon, SLCK co the vay cua TK).
            pr_error ('fn_markedafpralloc','        Begin Xac dinh so luong chung khoan co the phan bo vao nguon ');
            begin
                select af.actype, nvl(pr.prinused,0), least(rsk.mrpriceloan, sb.marginrefprice) marginprice, least(rsk.mrratioloan,l_afratioratio)
                    into l_actype, l_markedqtty, l_marginPrice, l_mrratioratio
                from semast se, afmast af, aftype aft, mrtype mrt, securities_info sb, afmrserisk rsk,
                    (select afacctno, codeid, sum(prinused)prinused
                                   from vw_afpralloc_all
                                   where afacctno = p_afacctno and codeid = unmarked_rec.codeid and restype = 'M'
                                   group by afacctno,codeid
                        ) pr
                where se.afacctno = p_afacctno and se.codeid = unmarked_rec.codeid
                and se.afacctno = af.acctno and af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
                and se.afacctno = pr.afacctno(+) and se.codeid = pr.codeid(+)
                and af.actype = rsk.actype and rsk.codeid = se.codeid and sb.codeid = se.codeid;

            exception when others then
                --plog.debug(pkgctx,'unmarkedRecords.LOOP IGNORE - codeid:'||unmarked_rec.codeid);
                CONTINUE;
            end;
            if l_marginPrice * l_mrratioratio = 0 then
                --plog.debug(pkgctx,'markedRecords.LOOP IGNORE:codeid:'||unmarked_rec.codeid);
                CONTINUE;
            end if;
            pr_error ('fn_markedafpralloc','        End Xac dinh so luong chung khoan co the phan bo vao nguon ');
            pr_error('unmarkedRecords.','l_markedqtty:'||l_markedqtty);
            pr_error('unmarkedRecords.','l_marginPrice:'||l_marginPrice);
            pr_error('unmarkedRecords.','l_mrratioratio:'||l_mrratioratio);
            l_exec_outstanding:= greatest(least(l_markedqtty * l_marginPrice * (l_mrratioratio/100), l_remain_outstanding),0);
            pr_error('unmarkedRecords.','l_exec_outstanding:'||l_exec_outstanding);
            l_securedqtty:= floor(l_exec_outstanding / (l_marginPrice * (l_mrratioratio/100)));
            pr_error('unmarkedRecords.','l_securedqtty:'||l_securedqtty);
            --Phan bo nguon theo ma CK da xac dinh. (co the phan bo vao nhieu room, neu thoa man dieu kien)
            --xac dinh cac room phai hach toan
            if l_securedqtty > 0 then
                INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM,RESTYPE)
                VALUES(seq_afpralloc.nextval,p_afacctno,-l_securedqtty,unmarked_rec.codeid,p_alloctyp,p_refid,to_date(p_txdate,systemnums.c_date_format), p_txnum,'M');
            end if;

            pr_error('unmarkedRecords.After effected. ','l_remain_outstanding:'||l_remain_outstanding);
            l_remain_outstanding:= l_remain_outstanding - l_exec_outstanding;
            exit when l_remain_outstanding <= 0;
        end loop;
        close unmarkedRecords;
        pr_error ('fn_markedafpralloc','    End Loop unmarkedRecords  ');
    end if;


    -->>> UNMARK System
    if l_unmarked_sys_outstanding > 0 and p_mark_flag in ('U','A') then
        l_remain_outstanding:= l_unmarked_sys_outstanding;
        --Xac dinh ma chung khoan co nguon phu hop nhat.
        pr_error ('fn_markedafpralloc','    Begin sy_unmarkedRecords  ');
        OPEN sy_unmarkedRecords;
        pr_error ('fn_markedafpralloc','    End sy_unmarkedRecords  ');
        pr_error ('fn_markedafpralloc','    Begin Loop sy_unmarkedRecords  ');
        loop
            FETCH sy_unmarkedRecords INTO sy_unmarked_rec;
            EXIT WHEN sy_unmarkedRecords%NOTFOUND;

            -- Xac dinh so luong chung khoan co the phan bo vao nguon. = min (SLCK kha dung cua nguon, SLCK co the vay cua TK).
            pr_error ('fn_markedafpralloc','        Begin Xac dinh so luong chung khoan co the phan bo vao nguon. ');
            begin
                select af.actype, nvl(pr.sy_prinused,0), least(rsk.mrpriceloan, sb.marginprice) marginprice, rsk.mrratioloan
                    into l_actype, l_markedqtty, l_marginPrice, l_mrratioratio
                from semast se, afmast af, aftype aft, mrtype mrt, securities_info sb, afserisk rsk,
                    (select afacctno, codeid, sum(prinused) sy_prinused
                                   from vw_afpralloc_all
                                   where afacctno = p_afacctno and codeid = sy_unmarked_rec.codeid and restype = 'S'
                                   group by afacctno,codeid
                        ) pr
                where se.afacctno = p_afacctno and se.codeid = sy_unmarked_rec.codeid
                and se.afacctno = af.acctno and af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
                and se.afacctno = pr.afacctno(+) and se.codeid = pr.codeid(+)
                and af.actype = rsk.actype and rsk.codeid = se.codeid and sb.codeid = se.codeid;

            exception when others then
                --plog.debug(pkgctx,'unmarkedRecords.LOOP IGNORE - codeid:'||sy_unmarked_rec.codeid);
                CONTINUE;
            end;
            if l_marginPrice * l_mrratioratio = 0 then
                --plog.debug(pkgctx,'markedRecords.LOOP IGNORE:codeid:'||sy_unmarked_rec.codeid);
                CONTINUE;
            end if;
            pr_error ('fn_markedafpra-lloc','        End Xac dinh so luong chung khoan co the phan bo vao nguon. ');
            pr_error('sy_unmarkedRecords.','l_markedqtty:'||l_markedqtty);
            pr_error('sy_unmarkedRecords.','l_marginPrice:'||l_marginPrice);
            pr_error('sy_unmarkedRecords.','l_mrratioratio:'||l_mrratioratio);
            l_exec_outstanding:= greatest(least(l_markedqtty * l_marginPrice * (l_mrratioratio/100), l_remain_outstanding),0);
            pr_error('sy_unmarkedRecords.','l_exec_outstanding:'||l_exec_outstanding);
            l_securedqtty:= floor(l_exec_outstanding / (l_marginPrice * (l_mrratioratio/100)));
            pr_error('sy_unmarkedRecords.','l_securedqtty:'||l_securedqtty);
            --Phan bo nguon theo ma CK da xac dinh. (co the phan bo vao nhieu room, neu thoa man dieu kien)
            --xac dinh cac room phai hach toan
            if l_securedqtty > 0 then
                INSERT INTO afpralloc (AUTOID,AFACCTNO,PRINUSED,CODEID,ALLOCTYP,ORGORDERID,TXDATE,TXNUM, RESTYPE)
                VALUES(seq_afpralloc.nextval,p_afacctno,-l_securedqtty,sy_unmarked_rec.codeid,p_alloctyp,p_refid,to_date(p_txdate,systemnums.c_date_format), p_txnum, 'S');
            end if;
            pr_error('unmarkedRecords.After effected. ','l_remain_outstanding:'||l_remain_outstanding);
            l_remain_outstanding:= l_remain_outstanding - l_exec_outstanding;
            exit when l_remain_outstanding <= 0;
        end loop;
        close sy_unmarkedRecords;
        pr_error ('fn_markedafpralloc','    End Loop sy_unmarkedRecords  ');
    end if;
    pr_error ('fn_markedafpralloc','End function ');
    plog.debug (pkgctx, '<<END OF fn_markedafpralloc');
    return systemnums.C_SUCCESS;
EXCEPTION when others then
    p_err_code:= errnums.C_SYSTEM_ERROR;
    plog.error (pkgctx, SQLERRM);
    plog.error (pkgctx, 'EXCEPTION when others then:'||dbms_utility.format_error_backtrace);
    return errnums.C_SYSTEM_ERROR;
end;
/

