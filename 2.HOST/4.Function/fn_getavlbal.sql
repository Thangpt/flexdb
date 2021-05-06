CREATE OR REPLACE FUNCTION fn_getavlbal (pv_afacctno varchar2, pv_lnschdid number) return number
is
    v_dblAVLBAL number;
    l_reftype varchar2(10);
begin
    select reftype into l_reftype from lnschd where autoid = pv_lnschdid;

    if l_reftype = 'GP' then
        select least(greatest(least(nvl(set0amt,0)/*+af.mrcrlimit*/,af.mrcrlimitmax-ci.dfodamt) - nvl(ln.odamt,0),0)
            + ci.balance + nvl(adv.avladvance,0)
                 - nvl(b.trfsecuredamt,0),
                 ci.balance + nvl(adv.avladvance,0))
            into v_dblAVLBAL
        from afmast af, cimast ci,
            (select sum(depoamt) avladvance,afacctno
                from v_getAccountAvlAdvance where afacctno = pv_afacctno group by afacctno
            ) adv,
            (select * from v_getsecmargininfo where afacctno = pv_afacctno) sec,
            (select trfacctno, sum(prinnml+prinovd+intdue+intnmlacr+intnmlovd+intovdacr+feeintdue+feeintnmlacr+feeintnmlovd+feeintovdacr) odamt
            from lnmast
            where ftype <> 'DF' and trfacctno = pv_afacctno group by trfacctno) ln,
            (select sts.afacctno,
                    sum(greatest(amt-aamt+feeacr-feeamt-trft0amt -trfexeamt,0)) trfsecuredamt
                from stschd sts, odmast od, sysvar sy_CURRDATE
                where sts.orgorderid = od.orderid and duetype = 'SM' and sts.deltd <> 'Y' and trfbuyrate * trfbuyext * (amt-trfexeamt) > 0 and trfbuysts <> 'Y'
                    and sy_CURRDATE.grname='SYSTEM' and sy_CURRDATE.varname='CURRDATE'
                    and sts.status = 'C' and sts.afacctno = pv_afacctno
                    and to_date(sy_CURRDATE.varvalue,'DD/MM/RRRR') < nvl(sts.trfbuydt,to_date(sy_CURRDATE.varvalue,'DD/MM/RRRR'))
                group by sts.afacctno) b
        where af.acctno = ci.acctno
            and ci.acctno = adv.afacctno(+)
            and ci.acctno = sec.afacctno(+)
            and ci.acctno = ln.trfacctno(+)
            and ci.acctno = b.afacctno(+)
            and ci.acctno =pv_afacctno;
    else
        select least(greatest(least(nvl(set0amt,0)/*+af.mrcrlimit*/,af.mrcrlimitmax-ci.dfodamt) - nvl(ln.odamt,0),0)
            + ci.balance + nvl(adv.avladvance,0)
                 - least(nvl(b.trfsecuredamt,0),nvl(ln.t0odamt,0)),
                 ci.balance + nvl(adv.avladvance,0))
            into v_dblAVLBAL
        from afmast af, cimast ci,
            (select sum(depoamt) avladvance,afacctno
                from v_getAccountAvlAdvance where afacctno = pv_afacctno group by afacctno
            ) adv,
            (select * from v_getsecmargininfo where afacctno = pv_afacctno) sec,
            (select trfacctno,
                sum(prinnml+prinovd+intdue+intnmlacr+intnmlovd+intovdacr+feeintdue+feeintnmlacr+feeintnmlovd+feeintovdacr) odamt,
                sum(oprinnml+oprinovd+ointdue+ointnmlacr+ointnmlovd+ointovdacr) t0odamt
            from lnmast
            where ftype <> 'DF' and trfacctno = pv_afacctno group by trfacctno) ln,
            (select sts.afacctno,
                    sum(greatest(amt-aamt+feeacr-feeamt-trft0amt -trfexeamt,0)) trfsecuredamt
                from stschd sts, odmast od, sysvar sy_CURRDATE
                where sts.orgorderid = od.orderid and duetype = 'SM' and sts.deltd <> 'Y' and trfbuyrate * trfbuyext * (amt-trfexeamt) > 0 and trfbuysts <> 'Y'
                    and sy_CURRDATE.grname='SYSTEM' and sy_CURRDATE.varname='CURRDATE'
                    and sts.status = 'C' and sts.afacctno = pv_afacctno
                    and to_date(sy_CURRDATE.varvalue,'DD/MM/RRRR') < nvl(sts.trfbuydt,to_date(sy_CURRDATE.varvalue,'DD/MM/RRRR'))
                group by sts.afacctno) b
        where af.acctno = ci.acctno
            and ci.acctno = adv.afacctno(+)
            and ci.acctno = sec.afacctno(+)
            and ci.acctno = ln.trfacctno(+)
            and ci.acctno = b.afacctno(+)
            and ci.acctno =pv_afacctno;
    end if;
    return v_dblAVLBAL;

exception when others then
    return 0;
end;
/

