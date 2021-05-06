CREATE OR REPLACE FUNCTION fn_mr0008_get_source( pv_acctno IN VARCHAR2)
    RETURN VARCHAR IS
  v_Result  varchar2(1000);
  l_custody_code  varchar2(1000);
  l_fullname      varchar2(1000);
  l_marginrate    varchar2(200);
  l_mrmrate       varchar2(200);
  l_CLAMT         varchar2(200);
  l_ODAMT         varchar2(200);
  L_rlsdate       varchar2(200);
  l_overduedate   varchar2(200);
  L_intdue        number;
  L_nml     number;
  l_ADDVND         varchar2(200);
  l_sex          varchar2(200);
  l_mrlrate varchar2(200);
  l_NAVACCOUNT varchar2(200);
  l_SECOUTSTANDING varchar2(200);
BEGIN
l_marginrate:=0;
l_mrmrate:=0;
l_CLAMT:=0;
l_ODAMT:=0;
L_intdue:=0;
L_nml:=0;
l_rlsdate :='01-jan-2000';
l_overduedate :='01-jan-2000';
-- hotfix email
select decode( cf.sex,'001','Ông','002','Bà','Quý khách'),CF.CUSTODYCD,CF.FULLNAME
  into l_sex  ,l_custody_code,l_fullname
from afmast af, cfmast cf
where af.custid = cf.custid and  af.acctno = pv_acctno ;

v_Result:='';
For vc in (
 SELECT custodycd,fullname,to_char(round(MARGINRATE_LN),'9,990.99')||' %' marginrate,to_char(ROUND(mrmrate))||' %' mrmrate, --thuyct edit 20191225
 to_char (ROUND( NAVACCOUNT),'99G999G999G999G999MI')||' VND' NAVACCOUNT
 ,to_char(ROUND(SECOUTSTANDING),'99G999G999G999G999MI')||' VND' SECOUTSTANDING
  ,to_char(ROUND(ADDVND_LOAN),'99G999G999G999G999MI')||' VND' ADDVND_LOAN
  FROM VW_MR0008 WHERE acctno = pv_acctno  and MARGINRATE_LN < mrmrate )
Loop

  l_marginrate:=vc.marginrate;
  l_mrmrate:=vc.mrmrate;
   l_NAVACCOUNT:=vc.NAVACCOUNT;
   l_SECOUTSTANDING:=vc.SECOUTSTANDING;
   l_ADDVND:=VC.ADDVND_LOAN;

    v_Result := 'select ''' || l_custody_code || ''' custodycode, ''' ||pv_acctno || ''' account, '''
                ||l_marginrate || ''' marginrate, ''' || l_mrmrate || ''' mrmrate, '''
                ||l_NAVACCOUNT || ''' NAVACCOUNT, ''' || l_SECOUTSTANDING || ''' SECOUTSTANDING, '''
                || l_ADDVND || ''' ADDVND_LOAN, '''
                ||l_sex || ''' sex, ''' || l_fullname || ''' fullname, ''T4004'' TEMPLATECODE from dual';
end loop;
RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/
