-- backup lai bang hien tai
create table  log_sa0015_20200408 as
select *   from log_sa0015 where  txdate >= '31/DEC/2019';
-- tinh toan lai gia ri dung theo dung ngay frdate
-- sau chay tung ngay se lay frdate = current
create table log_sa0015_temp as
select * from
          (select ln.trfacctno, lni.frdate,SUM(CASE WHEN ln.custbank is null THEN lni.intamt ELSE 0 END) intamt_mr,
                                SUM(CASE WHEN ln.custbank is not null THEN lni.intamt ELSE 0 END) intamt_topup,
                                SUM(CASE WHEN ln.custbank is null and l.loantype='T0' THEN lni.intamt ELSE 0 END) t0_intamt_mr,
                                SUM(CASE WHEN ln.custbank is not null and l.loantype='T0' THEN lni.intamt ELSE 0 END) t0_intamt_topup
          from lninttran lni, VW_LNMAST_ALL ln, lntype l
          where lni.acctno=ln.acctno
          and ln.ACTYPE = l.actype
          and l.loantype in ('T0', 'CL')
          and lni.frdate >= '31/DEC/2019'
          group by ln.trfacctno, lni.frdate) a
        where a.intamt_mr+a.intamt_topup >0 ;
-- cap nhat du lieu
  begin 
      FOR rec IN (select * from log_sa0015_temp)
      LOOP
        UPDATE log_sa0015 lg
        SET mrint_beday=rec.intamt_mr,
            mrinttopup_beday=rec.intamt_topup,
            t0int_beday=rec.t0_intamt_mr,
            t0inttopup_beday=rec.t0_intamt_topup
        WHERE txdate=rec.frdate and afacctno=rec.trfacctno;
        commit;
      END LOOP;
   end;
   
   
   
