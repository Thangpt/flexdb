CREATE OR REPLACE FUNCTION fn_get_netasset(l_CUSTDYCD IN VARCHAR2,
                                           l_AFACCTNO IN VARCHAR2)
  return number is

  l_STROPTION       VARCHAR2(5); -- A: ALL; B: BRANCH; S: SUB-BRANCH
  l_STRBRID         VARCHAR2(4);
  l_MRAMT           number(20, 0);
  l_T0AMT           number(20, 0);
  l_DFAMT           number(20, 0);
  l_BALANCE         number(20, 0);
  l_REALASS         number(20, 0);
  l_DEPOFEEAMT      number(20, 0);
  l_DFODAMT         number(20, 0);
  l_AVLADVANCE      number(20, 0);
  l_MRCRLIMITMAX    number(20, 0);
  l_trfbuyamt_in    number(20, 0);
  l_trfbuyamt_over  number(20, 0);
  l_trfbuyamt_inday number(20, 0);
  l_secureamt_inday number(20, 0);
  v_IDATE           DATE; --ngay lam viec gan ngay idate nhat
  v_CurrDate        DATE;
  V_TLID            VARCHAR2(4);
  l_NYOVDAMT        number(20, 0);
  l_intnmlpbl       number(20, 0);
  l_isstopadv       varchar2(10);
BEGIN
  l_isstopadv := cspks_system.fn_get_sysvar('MARGIN','ISSTOPADV');
  -- lay ngay he thong
  select to_date(varvalue, 'DD/MM/RRRR')
    into v_CurrDate
    from sysvar
   where varname = 'CURRDATE'
     and grname = 'SYSTEM';
  select sum(t.REALASS)
    into l_REALASS
    from vw_mr9004 t
   where t.afacctno = l_AFACCTNO;
  select nvl(sum(t0amt), 0), nvl(sum(marginamt), 0)
    into l_T0AMT, l_MRAMT
    from vw_lngroup_all
   where trfacctno = l_AFACCTNO;

  select nvl(sum(intnmlpbl), 0)
    into l_intnmlpbl
    from lnmast
   where trfacctno = l_AFACCTNO
     and ftype <> 'DF';

  select nvl(sum(prinnml + prinovd + intnmlacr + intnmlovd + intovdacr +
                 intdue + feeintnmlacr + feeintnmlovd + feeintovdacr +
                 feeintdue),
             0),
         nvl(sum(prinnml + prinovd), 0)
    into l_DFAMT, l_DFODAMT
    from lnmast
   where trfacctno = l_AFACCTNO
     and ftype = 'DF';

  select nvl(sum(trfbuyamt_in), 0), nvl(sum(trfbuyamt_over), 0)
    into l_trfbuyamt_in, l_trfbuyamt_over
    from v_getbuyorderinfo
   where afacctno = l_AFACCTNO;

  select nvl(sum(trfsecuredamt_inday + trft0amt_inday), 0),
         nvl(sum(secureamt_inday), 0)
    into l_trfbuyamt_inday, l_secureamt_inday
    from vw_trfbuyinfo_inday
   where afacctno = l_AFACCTNO;

  select mrcrlimitmax
    into l_MRCRLIMITMAX
    from afmast af
   where af.acctno = l_AFACCTNO;

  select balance, depofeeamt
    into l_BALANCE, l_DEPOFEEAMT --, l_DFODAMT  , dfodamt
    from cimast
   where acctno = l_AFACCTNO;

  select nvl(sum(decode(l_isstopadv,'Y',0,depoamt)), 0)
    into l_AVLADVANCE
    from v_getaccountavladvance
   where afacctno = l_AFACCTNO;
  return nvl(l_REALASS,0) + nvl(l_BALANCE,0) + nvl(l_AVLADVANCE,0) - nvl(l_DEPOFEEAMT,0) - nvl(l_T0AMT,0) - nvl(l_MRAMT,0) - nvl(l_DFAMT,0) - nvl(l_trfbuyamt_in,0) - nvl(l_trfbuyamt_over,0) - nvl(l_trfbuyamt_inday,0) - nvl(l_secureamt_inday,0);
end FN_GET_NETASSET;
/

