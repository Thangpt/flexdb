CREATE OR REPLACE FUNCTION fn_get_no(P_ACCNO IN VARCHAR2) RETURN NUMBER IS
  l_BALANCE         number(20, 0);
  l_AVLADVANCE      number(20, 0);
  l_T0AMT           number(20, 0);
  l_MRAMT           number(20, 0);
  l_trfbuyamt_in    number(20, 0);
  l_trfbuyamt_over  number(20, 0);
  l_trfbuyamt_inday number(20, 0);
  l_secureamt_inday number(20, 0);
  l_isstopadv       varchar2(10);
BEGIN
  l_isstopadv := cspks_system.fn_get_sysvar('MARGIN','ISSTOPADV');
  select nvl(sum(t0amt), 0), nvl(sum(marginamt), 0)
    into l_T0AMT, l_MRAMT
    from vw_lngroup_all
   where trfacctno = P_ACCNO;
  select balance
    into l_BALANCE --, l_DFODAMT  , dfodamt
    from cimast
   where acctno = P_ACCNO;
  select nvl(sum(decode(l_isstopadv,'Y',0,depoamt)), 0)
    into l_AVLADVANCE
    from v_getaccountavladvance
   where afacctno = P_ACCNO;

  select nvl(sum(trfbuyamt_in), 0), nvl(sum(trfbuyamt_over), 0)
    into l_trfbuyamt_in, l_trfbuyamt_over
    from v_getbuyorderinfo
   where afacctno = P_ACCNO;

  select nvl(sum(trfsecuredamt_inday + trft0amt_inday), 0),
         nvl(sum(secureamt_inday), 0)
    into l_trfbuyamt_inday, l_secureamt_inday
    from vw_trfbuyinfo_inday
   where afacctno = P_ACCNO;

  RETURN nvl(l_T0AMT,0) + nvl(l_MRAMT,0) - (nvl(l_BALANCE,0) + nvl(l_AVLADVANCE,0) - nvl(l_trfbuyamt_in,0) - nvl(l_trfbuyamt_over,0) - nvl(l_trfbuyamt_inday,0) - nvl(l_secureamt_inday,0));

EXCEPTION
  WHEN OTHERS THEN
    RETURN 0;
END;
/

