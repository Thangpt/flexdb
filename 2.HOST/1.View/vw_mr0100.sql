CREATE OR REPLACE FORCE VIEW VW_MR0100 AS
select cf.custodycd, af.acctno,cf.fullname
    ,cf.t0loanlimit --hm bao lanh kh
    ,nvl(T0af.AFT0USED,0) AFT0USED --hm bao lanh tieu khoan
    ,cf.mrloanlimit --hm mr khach hang
    ,af.mrcrlimitmax -- hm mr tieu khoan
    ,/*case when mt.mrtype not in ('S','T') then
                round((case when ci.balance+ least(nvl(af.mrcrlimit,0),nvl(b.secureamt,0)+ci.trfbuyamt)
                        - ci.trfbuyamt+nvl(adv.avladvance,0)- ci.odamt- ci.dfdebtamt - ci.dfintdebtamt - nvl (b.advamt, 0)-nvl(b.secureamt,0) - ci.ramt>=0
                        then 100000
                        else (nvl(af.mrclamt,0) + nvl(se.seass,0) + nvl(adv.avladvance,0))
                             / abs(ci.balance+least(nvl(af.mrcrlimit,0)
                                                    ,nvl(b.secureamt,0)+ci.trfbuyamt) - ci.trfbuyamt+nvl(adv.avladvance,0)
                                                        - ci.odamt- ci.dfdebtamt - ci.dfintdebtamt - nvl (b.advamt, 0)-nvl(b.secureamt,0) - ci.ramt
                                                    )
                        end)
                        ,4) * 100
        else nvl(mr.MARGINRATE,0) end*/ BUF.MARGINRATE  --rtt
    , od.symbol, od.S_orderqtty, od.B_orderqtty, S_execqtty,B_execqtty,S_orderamt,B_orderamt,S_execamt,B_execamt
    , S_ALL_execqtty, S_ALL_execamt, B_ALL_execqtty, B_ALL_execamt, S_ALL_orderamt
    , re.bm_name, re.bm_phone
from afmast af, cfmast cf, cimast ci, aftype aft, mrtype mt
    ,v_getbuyorderinfo  b
    ,buf_ci_account BUF
    --,v_getsecmarginratio MR
    --,v_getsecmargininfo  SE
    ,(select sum(acclimit) AFT0USED, acctno from useraflimit us where us.typereceive = 'T0' group by acctno) T0af
    --,(select aamt,depoamt avladvance, advamt advanceamount,afacctno, paidamt from v_getAccountAvlAdvance  ) adv
    ,(select sb.symbol, od.afacctno
            ,sum(case when instr(od.exectype,'S') <> 0 then od.execqtty + od.remainqtty else 0 end) S_orderqtty
            ,sum(case when instr(od.exectype,'B') <> 0 then od.execqtty + od.remainqtty else 0 end) B_orderqtty
            ,sum(case when instr(od.exectype,'S') <> 0 then od.execqtty else 0 end) S_execqtty
            ,sum(case when instr(od.exectype,'B') <> 0 then od.execqtty else 0 end) B_execqtty
            ,sum(case when instr(od.exectype,'S') <> 0 then (od.execamt + od.remainqtty * od.quoteprice) * (2 - OD.BRATIO/100 -  (SELECT VARVALUE FROM SYSVAR WHERE VARNAME LIKE 'ADVSELLDUTY' AND  GRNAME = 'SYSTEM' )/100) else 0 end) S_orderamt --TRU PHI, THUE
            ,sum(case when instr(od.exectype,'B') <> 0 then (od.execamt + od.remainqtty * od.quoteprice) * OD.BRATIO/100 else 0 end) B_orderamt --CONG PHI
            ,sum(case when instr(od.exectype,'S') <> 0 then od.execamt * (2 - OD.BRATIO/100 -  (SELECT VARVALUE FROM SYSVAR WHERE VARNAME LIKE 'ADVSELLDUTY' AND  GRNAME = 'SYSTEM' )/100) else 0 end) S_execamt
            ,sum(case when instr(od.exectype,'B') <> 0 then od.execamt  * OD.BRATIO/100 else 0 end) B_execamt
        from odmast od, blacklistsymbol bl, sbsecurities sb
        where od.exectype not in ('AS','AB','CB','CS') and od.deltd <> 'Y' and sb.codeid = od.codeid and bl.symbol = sb.symbol and od.txdate = (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
        group by sb.symbol, od.afacctno) od
    , (select od.afacctno
            ,sum(case when instr(od.exectype,'S') <> 0 then (od.execamt + od.remainqtty*od.quoteprice) * (2 - OD.BRATIO/100 -  (SELECT VARVALUE FROM SYSVAR WHERE VARNAME LIKE 'ADVSELLDUTY' AND  GRNAME = 'SYSTEM' )/100) else 0 end) S_ALL_orderamt
            ,sum(case when instr(od.exectype,'S') <> 0 then od.execqtty  else 0 end) S_ALL_execqtty
            ,sum(case when instr(od.exectype,'S') <> 0 then od.execamt * (2 - OD.BRATIO/100 -   (SELECT VARVALUE FROM SYSVAR WHERE VARNAME LIKE 'ADVSELLDUTY' AND  GRNAME = 'SYSTEM' )/100) else 0 end) S_ALL_execamt
            ,sum(case when instr(od.exectype,'B') <> 0 then od.execqtty  else 0 end) B_ALL_execqtty
            ,sum(case when instr(od.exectype,'B') <> 0 then od.execamt  * OD.BRATIO/100 else 0 end) B_ALL_execamt
        from odmast od where  od.deltd <> 'Y' and od.execqtty + od.execamt <> 0 and od.txdate = (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
        group by od.afacctno
        ) od_all
    ,(select cf.custid, cf.fullname bm_name, r.afacctno, nvl(cf.mobile, cf.phone) bm_phone from reaflnk r, recfdef rd, recflnk rf, retype rt, cfmast cf
        where rf.autoid = rd.refrecflnkid and rf.custid = cf.custid
            and r.reacctno = rf.custid || rd.reactype
            and rd.reactype = rt.actype and rt.rerole in ('BM','RM')
            and (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') between r.frdate and nvl(r.clstxdate -1, r.todate)
            and (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') between rd.effdate and nvl(rd.closedate -1, rd.expdate)
        ) re
where af.custid=cf.custid
    and ci.acctno = od.afacctno
    and af.acctno = ci.acctno
    and ci.acctno = od_all.afacctno (+)
    and af.actype = aft.actype and aft.mrtype = mt.actype
    and nvl(T0af.AFT0USED,0) > 0
    --and ci.acctno = MR.afacctno (+)
    and ci.acctno = T0af.acctno(+)
    and ci.acctno = re.afacctno (+)
    and af.acctno = b.afacctno(+)
    --and ci.acctno = se.afacctno (+)
    --and ci.acctno = adv.afacctno (+)
    AND CI.ACCTNO = BUF.AFACCTNO(+)
;

