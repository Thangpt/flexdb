CREATE OR REPLACE FUNCTION fn_mr1003_get_source( pv_acctno IN VARCHAR2)
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
  l_rtnremainamt  varchar2(200);
  l_T0OVDAMOUNT varchar2(200);
  l_OVDAMOUNT varchar2(200);
  l_MPOVDAMT  varchar2(200);
  l_MR1003TYPE varchar2(200);
  l_Nameibr varchar2(200);
  l_cidepofeeacr varchar2(200);
  l_phone1 varchar2(200);
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
 SELECT custodycd,fullname,to_char(round(marginrate,2),'9,999,990.99') marginrate,to_char(ROUND(mrlrate))  mrlrate, --thuyct round(marginrate,2) 20191203
 to_char (ROUND( NAVACCOUNT),'99G999G999G999G999MI') NAVACCOUNT
 ,to_char(ROUND(SECOUTSTANDING),'99G999G999G999G999MI') SECOUTSTANDING
 ,to_char(ROUND(rtnremainamt),'99G999G999G999G999MI') rtnremainamt
 ,to_char(ROUND(T0OVDAMOUNT),'99G999G999G999G999MI') T0OVDAMOUNT
  ,to_char(ROUND(OVDAMOUNT),'99G999G999G999G999MI') OVDAMOUNT
  ,to_char(ROUND(MPOVDAMT),'99G999G999G999G999MI') MPOVDAMT
  ,MR1003TYPE
  ,fullnamere
  ,to_char(round(cidepofeeacr),'99G999G999G999G999MI') cidepofeeacr
  ,nvl(phone1,'x') phone1
  FROM VW_MR1003 WHERE acctno = pv_acctno   )
Loop

  l_marginrate:=vc.marginrate; -- ty le thuc te
  l_mrlrate:=vc.mrlrate;
  l_NAVACCOUNT:=vc.NAVACCOUNT;
  l_SECOUTSTANDING:=vc.SECOUTSTANDING;

   -- lay them
   l_rtnremainamt:= vc.rtnremainamt;--tong tien con phai xu ly
   l_T0OVDAMOUNT    :=vc.T0OVDAMOUNT ; -- no bao lanh
   l_OVDAMOUNT    :=vc.OVDAMOUNT;   -- no mr qua han
   l_MPOVDAMT     :=vc.MPOVDAMT;  --- tong no bao lanh phai tra
   l_MR1003TYPE   := vc.MR1003TYPE;  --- Phan loai
   l_Nameibr      := vc.fullnamere;
   l_cidepofeeacr :=vc.cidepofeeacr;
   l_phone1       :=vc.phone1;
    v_Result := 'select ''' || l_custody_code || ''' custodycode, ''' ||pv_acctno || ''' account, '''
                ||l_marginrate || ''' marginrate, ''' || l_mrlrate || ''' mrlrate, '''
                ||l_NAVACCOUNT || ''' NAVACCOUNT, ''' || l_SECOUTSTANDING || ''' SECOUTSTANDING, '''
                ||l_sex || ''' sex, ''' || l_fullname || ''' fullname, ''T4033'' TEMPLATECODE,
                '''|| l_rtnremainamt || ''' rtnremainamt,
                '''|| l_T0OVDAMOUNT || ''' toovdamount,
                '''|| l_OVDAMOUNT || ''' OVDAMOUNT,
                '''|| l_MPOVDAMT || ''' MPOVDAMT,
                '''|| To_char(getcurrdate,'dd/MM/yyyy') || ''' currdate,
                '''|| l_Nameibr || ''' Nameibr,
                '''|| l_cidepofeeacr || ''' cidepofeeacr,
                '''|| l_phone1 || ''' phone1,
                '''|| l_MR1003TYPE || ''' MR1003TYPE from dual';
end loop;
RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/
