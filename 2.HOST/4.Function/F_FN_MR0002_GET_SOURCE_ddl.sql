CREATE OR REPLACE FUNCTION fn_mr0002_get_source( pv_acctno IN VARCHAR2)
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
L_intdue:=0;

for rec in (
 select  cf.custodycd,cf.fullname,lns.rlsdate,lns.overduedate,lns.intdue,lns.nml
 from lnmast ln, lnschd lns, cfmast cf, afmast af
 where lns.acctno = ln.acctno and ln.trfacctno = pv_acctno
 and ln.trfacctno = af.acctno and af.custid = cf.custid
 and reftype ='P'
 and lns.overduedate = (select to_date(varvalue,'DD/MM/RRRR') from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM')
)
loop
l_custody_code:= rec.custodycd;
l_fullname := rec.fullname;
l_rlsdate := TO_CHAR( rec.rlsdate,'DD/MM/YYYY');
l_overduedate:= TO_CHAR( rec.overduedate,'DD/MM/YYYY');
l_intdue:= rec.intdue;
l_nml:= rec.nml;

end loop ;



if L_intdue >0 then

    v_Result := 'select ''' || l_custody_code || ''' custodycode, ''' ||pv_acctno || ''' account, '''
                ||l_rlsdate || ''' rlsdate, ''' || l_overduedate || ''' overduedate, '''
                || to_char(ROUND(l_intdue),'99G999G999G999G999MI')||' VND' || ''' intdue, ''' ||to_char(ROUND(l_nml),'99G999G999G999G999MI')||' VND'   || ''' nml, ''' ||l_sex || ''' sex, ''' ||
                 l_fullname || ''' fullname , ''T0219'' TEMPLATECODE from dual';

ELSE


 SELECT custodycd,fullname,to_char(round(marginrate,2),'9,990.99')||' %' marginrate,to_char(ROUND(mrmrate))||' %' mrmrate, to_char (ROUND( CLAMT),'99G999G999G999G999MI')||' VND'CLAMT --thuyct edit to_char(round(marginrate)) 20191225
 ,to_char(ROUND(ODAMT),'99G999G999G999G999MI')||' VND'ODAMT,to_char(ROUND(ADDVND),'99G999G999G999G999MI')||' VND' ADDVND
 into l_custody_code, l_fullname,l_marginrate,l_mrmrate, l_CLAMT,l_ODAMT,l_ADDVND
 FROM VW_MR0002 WHERE acctno = pv_acctno  ;


 if l_marginrate < l_mrmrate then

    v_Result := 'select ''' || l_custody_code || ''' custodycode, ''' ||pv_acctno || ''' account, '''
                ||l_marginrate || ''' marginrate, ''' || l_mrmrate || ''' mrmrate, '''
                ||l_CLAMT || ''' CLAMT, ''' || l_ODAMT || ''' ODAMT, ''' || l_ADDVND || ''' ADDVND, ''' ||l_sex || ''' sex, ''' ||
                 l_fullname || ''' fullname, ''T0218'' TEMPLATECODE from dual';
end if;

 end if;

RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;

-- End of DDL Script for Function HOST.FN_2225_GET_AMT
/
