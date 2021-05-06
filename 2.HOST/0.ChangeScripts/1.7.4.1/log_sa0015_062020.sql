
create table log_sa0015_062020 as
select * from log_sa0015 where 0=0;

DECLARE  v_prevdate   DATE;

BEGIN
  select to_date(varvalue,'DD/MM/RRRR') into v_prevdate from sysvar where varname = 'PREVDATE' and grname='SYSTEM';
  
  insert into log_sa0015( TXDATE,CUSTODYCD,AFACCTNO,
    careby,reid,refullname,aftype,odexecamt,odfeeamt,afgrpid,navamt,date_count,grpid,grpname,NAVAMT_ED)

  select * from
   ( select od.txdate txdate, cf.custodycd, ci.acctno afacctno
   , cf.careby, re.reid, re.refullname, af.actype aftype, od.execamt odexecamt, od.feeacr odfeeamt
   , afgrp.actype afgrpid
   , NVL(NAV.AVGNAV,0) navamt
   , 0 date_count
   , re.grpid
   , re.grpname
   ,NVL(NAVED.AVGNAVED,0) AVGNAVED 
    from cimast ci,cfmast cf, afmast af,
    (select re.afacctno, MAX(cf.fullname) refullname, MAX (substr(re.reacctno,1,10)) reid,max(reg.grpid) grpid, max(reg.grpname) grpname
    from reaflnk re, sysvar sys, cfmast cf, retype,
    (select r.reacctno,rg.autoid grpid,rg.fullname grpname from regrplnk r,regrp rg WHERE rg.autoid=r.refrecflnkid and  r.status='A' AND to_date(getcurrdate,'DD/MM/RRRR') between r.frdate and r.todate) reg
    where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
        and substr(re.reacctno,0,10) = cf.custid
        and varname = 'CURRDATE' and grname = 'SYSTEM'
        and re.status <> 'C' and re.deltd <> 'Y'
        AND substr(re.reacctno,11) = retype.actype
        AND rerole IN ('RM','BM')
        AND re.reacctno=reg.reacctno(+)
    GROUP BY afacctno
    ) re,
    (SELECT afacctno,txdate, SUM (execamt) execamt, SUM (feeacr) feeacr 
    FROM vw_odmast_all 
    WHERE txdate between to_date('01/01/2020','DD/MM/RRRR') and v_prevdate
    AND execamt > 0
    GROUP BY  afacctno, txdate
    ) od,
    (SELECT db.actype, afdb.afacctno FROM dbnavgrp db, afdbnavgrp afdb WHERE db.actype = afdb.refactype AND db.status = 'A'
    ) afgrp,
    (SELECT custodycd,afacctno,txdate,MAX(custid) custid ,round(sum((realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT)),4) AVGNAV
            FROM(select cf.custodycd,v.afacctno ,v.txdate, MAX(cf.custid) custid, sum(v.realass) realass,
                       max(T0AMT)T0AMT, max(MRAMT) MRAMT, max(v.balance + v.avladvance) BALANCE,
                       max(v.depofeeamt) DEPOFEEAMT
                from (SELECT * FROM tbl_mr3007_log WHERE txdate between to_date('01/01/2020','DD/MM/RRRR') and v_prevdate ) v,cfmast cf
                where cf.custodycd = v.custodycd
                group by cf.custodycd,v.afacctno,v.txdate )
            WHERE (realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT) > 0
            GROUP BY custodycd,afacctno,txdate) NAV,
    (SELECT custodycd,afacctno,txdate,MAX(custid) custid ,round(sum((realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT)),4) AVGNAVED
            FROM(select cf.custodycd,v.afacctno,v.txdate, MAX(cf.custid) custid, NVL(sum((v.trade + v.mortage + v.TOTALRECEIVING - v.SELLMATCHQTTY + v.TOTALBUYQTTY)*se.avgprice),0) realass,
                       max(T0AMT)T0AMT, max(MRAMT) MRAMT, max(v.balance + v.avladvance) BALANCE,
                       max(v.depofeeamt) DEPOFEEAMT
                from (SELECT * FROM tbl_mr3007_log
                WHERE txdate between to_date('01/01/2020','DD/MM/RRRR') and v_prevdate
                ) v, securities_info se, cfmast cf
                where cf.custodycd = v.custodycd
                and v.codeid=se.codeid(+)
                group by cf.custodycd,v.afacctno,v.txdate )
            WHERE (realass + BALANCE) - (DEPOFEEAMT + T0AMT + MRAMT) > 0
            GROUP BY custodycd,afacctno,txdate
            ) NAVED
    where ci.custid= cf.custid
    AND ci.acctno= af.acctno
    and ci.acctno = re.afacctno (+)
    and ci.acctno = od.afacctno
    and ci.acctno = afgrp.afacctno (+)
    and od.afacctno = NAV.afacctno (+)
    and od.afacctno = NAVED.afacctno (+)
    and od.txdate = NAV.txdate (+)
    and od.txdate = NAVED.txdate (+)
    ) a
    where not exists (select * from log_sa0015 lg where lg.afacctno=a.afacctno and lg.txdate=a.txdate)
    ;
     ---
   COMMIT;
END;
