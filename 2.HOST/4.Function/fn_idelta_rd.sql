CREATE OR REPLACE FUNCTION fn_idelta_rd(custid varchar2, f_date date, t_date date)
return number
is
v_delta number;
v_rerole varchar2(10);
v_custid varchar2(10);
--v_count number;
begin

    v_custid := custid;

    /*select count(1) into v_count from idelta_rd where recustid= v_custid and fdate = f_date and tdate = t_date;
    if v_count >0 then
        select max(delta) into v_delta from idelta_rd where recustid= v_custid and fdate = f_date and  tdate = t_date;
        return v_delta;
    else


    end if;*/
    begin
            select a.rerole, i.delta  into v_rerole, v_delta from
            (
                /*select
                 substr(r.reacctno,1,10) custid, substr(r.reacctno,11,4) role, ry.rerole
                 , sum(o.feeacr) feeacr
                from reaflnk r, retype ry, vw_odmast_all o--,  rerfee rf
                , sbsecurities sb
                , iccftypedef icc
                where r.afacctno = o.afacctno and o.deltd <> 'Y'
                and ry.actype = substr(r.reacctno,11,4) and ry.rerole =  'RD' and o.execamt > 0
                and o.txdate between f_date and t_date
                and o.txdate BETWEEN r.frdate and nvl(r.clstxdate -1, r.todate)
                and sb.codeid = o.codeid
                --and ry.actype = rf.refobjid
                --and sb.sectype = rf.symtype
                and ry.actype = icc.actype and icc.modcode = 'RE'
                --and substr(r.reacctno,1,10) = v_custid --custid -- --
                and r.reacctno = v_custid || ry.actype
                group by substr(r.reacctno,1,10), substr(r.reacctno,11,4), ry.rerole*/
                select substr(tran.acctno,1,10) custid, substr(tran.acctno,11,4) role, rt.rerole, sum(tran.intamt) feeacr from
                    (
                    select acctno, intamt , todate from reinttran
                    union all
                    select acctno, intamt , todate from reinttrana
                    ) tran, retype rt
                where SUBSTR(tran.acctno,11,4) = rt.actype
                and rt.rerole = 'RD'
                and tran.todate between f_date and t_date
                and substr(tran.acctno,1,10)= v_custid
                group by tran.acctno,rt.rerole

            ) a
            left join
            (
                select * from iccftier where  modcode = 'RE'
            ) i
            on a.role = i.actype and  a.feeacr >= framt and a.feeacr < toamt;
            if v_rerole <> 'RD' then
            --    insert into idelta_rd (recustid,fdate,tdate,rerole,delta)
            --   values (v_custid, f_date, t_date, v_rerole,v_delta);
                return 0;
            else
           --     insert into idelta_rd (recustid,fdate,tdate,rerole,delta)
           --     values (v_custid, f_date, t_date, v_rerole,v_delta);
                return v_delta;
            end if;
        exception when others then
         --   insert into idelta_rd (recustid,fdate,tdate,rerole,delta)
         --       values (v_custid, f_date, t_date, 'RD',0);
            return 0;
        end;
end;
/

