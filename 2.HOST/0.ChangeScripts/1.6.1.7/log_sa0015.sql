begin
 update log_sa0015
 SET mrint_beday=0,
    mrinttopup_beday=0,
	t0int_beday=0,
	t0inttopup_beday=0
 WHERE txdate >= to_date('25/11/2019','DD/MM/RRRR') and txdate < getcurrdate;
 
 for rec in (
      select * from
          (select ln.trfacctno, lni.frdate,SUM(CASE WHEN ln.custbank is null THEN lni.intamt ELSE 0 END) intamt_mr,
                                SUM(CASE WHEN ln.custbank is not null THEN lni.intamt ELSE 0 END) intamt_topup,
                                SUM(CASE WHEN ln.custbank is null and lns.reftype='GP' THEN lni.intamt ELSE 0 END) t0_intamt_mr,
                                SUM(CASE WHEN ln.custbank is not null and lns.reftype='GP' THEN lni.intamt ELSE 0 END) t0_intamt_topup
          from lninttran lni, lnmast ln, (select distinct(acctno),reftype from lnschd) lns
          where lni.acctno=ln.acctno
          and lns.acctno = ln.acctno
          and lns.reftype  in ('P','GP')
		  and lni.frdate >= to_date('25/11/2019','DD/MM/RRRR') and lni.frdate < getcurrdate
          group by ln.trfacctno,lni.frdate) a
      where a.intamt_mr+a.intamt_topup >0
      order by a.frdate
      )
loop
   UPDATE log_sa0015 lg
      SET mrint_beday=rec.intamt_mr,
          mrinttopup_beday=rec.intamt_topup,
		  t0int_beday=rec.t0_intamt_mr,
          t0inttopup_beday=rec.t0_intamt_topup
    WHERE txdate=rec.frdate and afacctno=rec.trfacctno;
  end loop;

COMMIT;
end;




