CREATE OR REPLACE PROCEDURE pr_deleteexternalafmast(pv_err_code in out varchar2, p_acctno in varchar2)
is
 v_str varchar2 (20);
 v_count number (20) :=0;
begin
    --delete from otright where afacctno = p_acctno;
    --delete from otrightdtl where afacctno = p_acctno;
    delete from aftemplates where afacctno = p_acctno;
    delete from cfauth where acctno = p_acctno;
    delete from cfotheracc where afacctno = p_acctno;
    delete from reaflnk where afacctno = p_acctno;
    delete from aftxmap where afacctno = p_acctno;
    delete from   AFSERULE  where   refid = p_acctno;
    --BINHVT iss 414 xy ly khi khach hang co 1 tieu khoang thi xoa het ca so luu ky
    select t.custid into v_str from afmast t where t.acctno = p_acctno;
    select count(1) into v_count  from  afmast  u where u.custid = v_str;
    if v_count = 1 then
      update cfmast c set c.custodycd = ''  where c.custid = v_str;
      -- xoa thong tin OTRIGHT
	    delete from otright o where  o.cfcustid = o.cfcustid and o.authcustid = v_str;
      delete from otrightdtl o where  o.cfcustid = o.cfcustid and o.authcustid = v_str;
      delete from otright o where  o.cfcustid <> o.cfcustid and o.authcustid = v_str and o.via <>'A';
      delete from otrightdtl o where  o.cfcustid <> o.cfcustid and o.authcustid = v_str and o.via <>'A';
      end if;
    --
    pv_err_code:= 0;
end;
/
