CREATE OR REPLACE PROCEDURE cf1112 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   PV_PLSENT    IN VARCHAR2,
   PV_CUSTODYCD         IN       VARCHAR2,
   PV_AFACCTNO        IN       VARCHAR2

 )
IS

    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    C_EMAIL varchar(1);
     C_SMS varchar(1);
      C_SK varchar(1);


BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;
    begin
    select 'Y' into C_EMAIL from (select t.* from aftemplates s, templates t  where s.afacctno = PV_AFACCTNO and s.template_code = t.code and t.name = 'T0215'
                                 union
                                 select t.* from templates t where t.REQUIRE_REGISTER = 'N' and t.name = 'T0215');
    exception
    when others
    then C_EMAIL := 'N';
   end;

   begin
    select 'Y' into C_SMS from (select t.* from aftemplates s, templates t  where s.afacctno = PV_AFACCTNO and s.template_code = t.code and t.name = 'T0323'
                                 union
                                 select t.* from templates t where t.REQUIRE_REGISTER = 'N' and t.name = 'T0323');
    exception
    when others
    then C_SMS := 'N';
   end;


   begin
    select 'Y' into C_SK from (select t.* from aftemplates s, templates t  where s.afacctno = PV_AFACCTNO and s.template_code = t.code and t.name = 'T0214'
                                 union
                                 select t.* from templates t where t.REQUIRE_REGISTER = 'N' and t.name = 'T0214');
    exception
    when others
    then C_SK := 'N';
   end;

OPEN PV_REFCURSOR FOR
select kh.*,
C_EMAIL chkEMAIL, C_SMS chkCMS, C_SK chkSK,
s1.varvalue ten_ddMSBS, s1.vardesc cv_ddMSBS, s2.varvalue so_uqMSBS, s2.vardesc nguoi_uqMSBS, s2.en_vardesc ngay_uqMSBS,
V_INBRID chi_nhanh
from
    (
    select c.custid, c.fullname name, gioi_tinh.cdcontent gioi_tinh, c.custodycd , a.acctno, c.dateofbirth,
    c.idtype, c.idcode, c.iddate, c.idplace, c.idexpired, c.address, c.phone, c.mobile, c.opndate,
    c.fax, c.email, a.corebank, c.bankacctno, a3.cdcontent bankname, c.taxcode, a4.cdcontent businesstype, a.termofuse
    from cfmast c, afmast a, allcode gioi_tinh, allcode a1, allcode a2, allcode a3, allcode a4
    where c.custid = a.custid
    and gioi_tinh.cdval = c.sex  and gioi_tinh.cdname = 'SEX'
    and a1.cdval = c.businesstype and a1.cdname = 'BUSINESSTYPE' and a1.cdtype = 'CF'
    and a2.cdval = c.idtype and a2.cdname = 'IDTYPE'
    and a3.cdval = c.bankcode and a3.cdname = 'BANKCODE' and a3.cdtype = 'CF'
    and a4.cdval = c.sector and a4.cdname = 'SECTOR'
    and c.custtype = 'I' and a.acctno = PV_AFACCTNO
    ) kh,
    sysvar s1, sysvar s2
where  s1.grname = 'REPRESENT' and s2.grname = 'REPRESENT'
and s1.varname = PV_PLSENT
and CASE WHEN PV_PLSENT ='MSBSREP01' THEN 'MSBSREPAUTH01'
        WHEN PV_PLSENT ='MSBSREP02' THEN 'MSBSREPAUTH02'
        WHEN PV_PLSENT ='MSBSREP03' THEN 'MSBSREPAUTH03' END = s2.varname
/*select kh.*,
PV_PLSENT dd_MSBS, C_EMAIL chkEMAIL, C_SMS chkCMS, C_SK chkSK
from
    (
    select c.custid, c.fullname name, gioi_tinh.cdcontent gioi_tinh,c.dateofbirth, c.custodycd ,
    a2.cdcontent idtype, c.idcode, c.iddate, c.idplace, c.idexpired, c.address, c.phone, c.mobile,
    c.fax, c.email
    from cfmast c, allcode gioi_tinh, allcode a2
    where
    gioi_tinh.cdval = c.sex  and gioi_tinh.cdname = 'SEX'
    and a2.cdval = c.idtype and a2.cdname = 'IDTYPE'
    and c.custtype = 'I' and c.custodycd = PV_CUSTODYCD
    ) kh*/
;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

