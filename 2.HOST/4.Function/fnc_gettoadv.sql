CREATE OR REPLACE FUNCTION fnc_gettoadv(v_Acctno IN VARCHAR2) return number
  IS

  V_FRDATE VARCHAR2(10);
  v_afacctno VARCHAR2(20);
  v_TOAMT number(20,4);
  v_TOODAMT number(20,4);
  v_groupleader VARCHAR2(20);
  v_TOTALTOAMT number(20,4);
  v_TOTALTOODAMT number(20,4);
  v_rcvT0 number(20,4);
  v_Result number(20,4);
  v_temp number(20,4);
BEGIN
    --1.Phan bo voi T0 khong thuoc group
    v_Result :=0;
    for rec in(
        select afacctno, T0,greatest(least(T0, T0-PP),0) ADDVND,BUYAMT  from
        (SELECT cimast.afacctno, af.mrirate,nvl(af.advanceline,0) T0,
                   /*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SEASS,0)  NAVACCOUNT,
                   nvl(b.execbuyamtfee,0) BUYAMT,
                   balance+ least(nvl(af.MRCRLIMIT,0),nvl(secureamt,0))+nvl(se.receivingamt,0)- odamt - NVL (advamt, 0) - ramt -nvl(secureamt,0) OUTSTANDING, ---nvl(secureamt,0) khong tinh den vi khi chay batch da cat tien roi
                   greatest(least(nvl(af.MRCRLIMIT,0) + nvl(se.SEAMT,0)+
                                nvl(se.receivingamt,0)  --+ nvl(se.trfamt,0)
                        ,nvL(af.MRCRLIMITMAX,0)+nvl(af.MRCRLIMIT,0)) +
                   nvl(af.advanceline,0) + balance- odamt  - ramt - nvl(secureamt,0),0) PP  ---nvl(secureamt,0) khong tinh den vi khi chay batch da cat tien roi

               FROM cimast inner join afmast af on af.acctno = cimast.afacctno and length(nvl(af.groupleader,'_'))<>10
                           inner join aftype aft on af.actype = aft.actype
                           inner join mrtype mrt on aft.mrtype = mrt.actype  --and mrt.mrtype <>'N'
               left join
                (select * from v_getbuyorderinfo ) b
                on  cimast.acctno = b.afacctno

                LEFT JOIN
                v_getsecmargininfo SE
                on se.afacctno=cimast.acctno)
                WHERE T0>0 and afacctno =v_Acctno
     )
      loop
            v_afacctno:=rec.afacctno;
            v_TOODAMT:=greatest(least(rec.BUYAMT,least(rec.t0,rec.ADDVND)),0);
            v_TOAMT:=rec.t0-v_TOODAMT;
            v_Result:=v_TOODAMT;
      end loop;

    /*--2.Phan bo voi T0 thuoc group
    for rec in(
        select A.afacctno, T0,greatest(least(T0, T0-PP),0) ADDVND,BUYAMT,least(greatest(least(T0, T0-PP),0),BUYAMT) TOTALT0   from
             (SELECT af.groupleader AFACCTNO, sum (nvl(af.advanceline,0)) T0,
                   sum(nvl(af.MRCRLIMIT,0) + nvl(se.SEASS,0)  + nvl(se.trfass,0))  NAVACCOUNT,
                   sum(nvl(b.execbuyamtfee,0)) BUYAMT,
                   sum(balance+ nvl(se.receivingamt,0)- odamt - NVL (advamt, 0) - ramt -nvl(secureamt,0)) OUTSTANDING, ---nvl(secureamt,0) khong tinh den vi khi chay batch da cat tien roi
                   greatest(least(SUM(nvl(se.MRCRLIMIT,0) + nvl(se.SEAMT,0)+
                                nvl(se.receivingamt,0)+ nvl(se.trfamt,0))
                        ,SUM(nvL(se.MRCRLIMITMAX,0))) +
                   SUM(nvl(af.advanceline,0) + balance- odamt  - ramt -nvl(secureamt,0)),0) PP  ---nvl(secureamt,0) khong tinh den vi khi chay batch da cat tien roi
             FROM cimast inner join afmast af on af.acctno = cimast.afacctno and length(nvl(af.groupleader,'_'))=10
                               inner join aftype aft on af.actype = aft.actype
                               inner join mrtype mrt on aft.mrtype = mrt.actype  and mrt.mrtype <>'N'
                               and af.GROUPLEADER in (select nvl(groupleader,'_') from afmast where acctno =v_Acctno)
                   LEFT JOIN
                    (select b.* from v_getbuyorderinfo b) b
                    on  cimast.acctno = b.afacctno

                   LEFT JOIN
                    (select b.* from v_getsecmargininfo b) SE
                    on se.afacctno=cimast.acctno
                    group by af.groupleader) A, AFMAST AF
             where A.AFACCTNO =AF.ACCTNO AND A.T0>0

       )
      LOOP
             v_Result:=rec.TOTALT0;
      end loop;*/

      Return v_Result;
EXCEPTION
    WHEN others THEN
        v_Result:='-1';
        return v_Result;
END;
/

