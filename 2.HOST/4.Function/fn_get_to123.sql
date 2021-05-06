CREATE OR REPLACE FUNCTION fn_get_to123(p_brid   varchar2,
                                        p_period varchar2,
                                        I_DATE   varchar2) return number is
  v_dc number(20, 3) := 0;
begin

  select nvl(sum(yy.TOAMT),0) AMT
    into v_dc
    from (select t1.allocatedlimit - t1.retrievedlimit TOAMT,
                 t1.acctno,
                 nvl(t2.period, 0) period,
                 re. brid

            from (select *
                    from t0limitschd
                  union
                  select *
                    from t0limitschdhist) t1,
                 olndetail t2,
                 (select distinct re.afacctno, rcf.brid, rcf.custid
                    from reaflnk re,
                         sysvar  sys,
                         cfmast  cf,
                         RETYPE,
                         recflnk rcf
                   where to_date(varvalue, 'DD/MM/RRRR') between re.frdate and
                         nvl(re.clstxdate - 1, re.todate)
                     and substr(re.reacctno, 0, 10) = cf.custid
                     and varname = 'CURRDATE'
                     and substr(re.reacctno, 0, 10) = rcf.custid
                     and grname = 'SYSTEM'
                     and re.status <> 'C' --and re.afacctno = '0001000036'
                     and re.deltd <> 'Y'
                     AND substr(re.reacctno, 11) = RETYPE.ACTYPE
                     AND rerole IN ('RM', 'BM')) re
           where t1.refautoid = t2.autoid(+)
             and t1.acctno = re.afacctno(+)
             and nvl(t2.period,0) like p_period
             and t1.allocateddate = to_date(I_DATE, 'dd/MM/yyyy')) yy
   where yy.brid = p_brid;
  return v_dc;
exception
  when others then
    return 0;
end;
/

