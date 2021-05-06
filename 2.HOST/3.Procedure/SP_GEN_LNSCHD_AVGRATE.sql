CREATE OR REPLACE Procedure SP_GEN_LNSCHD_AVGRATE  Is

Begin

  FOR REC IN (select b.autoid , ((nvl(a.avgrate, 0)* nvl(a.days,0)) +(b.IRtemp ))/( b.todate - b.rlsdate )avgrate
              from AVGRATELNSCHD_TEMP  a,
              (select sum(DAYS * IRtemp_T/IRtemp_M) IRtemp , sum(days) days, autoid, rlsdate, max(todate) todate
               from (select sum((lt.todate - lt.frdate) * irrate * lt.intbal) IRtemp_T, sum ( (lt.todate - lt.frdate)  * lt.intbal) IRtemp_M,
                   lt.todate, lt.frdate, ln.autoid, ln.rlsdate, lt.todate - lt.frdate days
                   from lnschd ln, lninttran lt
                   where ln.autoid= lt.lnschdid and lt.lnschdid is not null
                   and lt.intamt + lt.feeintamt > 0 and ln.reftype in ('P', 'GP')
                   group by ln.autoid, ln.rlsdate, lt.todate, lt.frdate, lt.todate- lt.frdate)
               group by autoid, rlsdate )b
               where b.autoid = a.autoid (+) )  LOOP
    UPDATE LNSCHD L SET L.AVGRATE = round(rec.avgrate , 4) where l.autoid = rec.autoid and l.nml + l.ovd > 0;
    commit;
  END LOOP;
EXCEPTION
   WHEN OTHERS    THEN
      RETURN;
End SP_GEN_LNSCHD_AVGRATE;
/
