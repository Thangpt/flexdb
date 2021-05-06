CREATE OR REPLACE PACKAGE htspks_api is

  -- Author  : THONG_000
  -- Created : 23/09/2013 10:15:49 AM
  -- Purpose : Home API

  -- Public type declarations
  -- type <TypeName> is <Datatype>;

  -- Public constant declarations
  -- <ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  -- <VariableName> <Datatype>;

  -- Public function and procedure declarations
  procedure sp_login(p_login_id in out varchar2, p_username varchar2,
                     p_password varchar2, p_loginsrcip varchar2,
                     p_logindstip varchar2, p_custid in out varchar2,
                     p_role in out varchar2, p_isreset in out varchar2,
                     p_custodycd in out varchar2,
                     p_token in out varchar2,--1.5.1.0: them p_token
                     p_authtype in out varchar2, --1.5.3.0: them authentype
                     p_err_code in out varchar2,
                     p_err_message in out varchar2);
 procedure sp_loginToken(p_login_id in out varchar2, p_username varchar2,
                     p_password varchar2, p_loginsrcip varchar2,
                     p_logindstip varchar2, p_custid in out varchar2,
                     p_role in out varchar2, p_isreset in out varchar2,
                     p_custodycd in out varchar2,
                     p_token in out varchar2,--1.5.1.0: them p_token
                     p_authtype in out varchar2, --1.5.3.0: them authentype
                     p_err_code in out varchar2,
                     p_err_message in out varchar2);
  procedure sp_audit_authenticate(p_loginid varchar2, p_userid char,
                                  p_loginsrcip varchar2,
                                  p_logindstip varchar2, p_type char);

  procedure sp_get_account_infor(p_refcursor in out pkg_report.ref_cursor,
                                 p_username varchar2, p_password varchar2,
                                 p_role varchar2);

  procedure sp_get_sub_account(p_refcursor in out pkg_report.ref_cursor,
                               p_custodycode varchar2, p_tlid varchar2,
                               p_custid varchar2, p_role varchar2);

  procedure sp_refesh_orders_by_user(p_refcursor in out pkg_report.ref_cursor,
                                     p_tlname in varchar2, p_scn in varchar2,
                                     p_role in varchar2 default 'B');

  procedure sp_get_orders_by_user(p_refcursor in out pkg_report.ref_cursor,
                                  p_tlname in varchar2,
                                  p_rowperpage in number, p_page in number,
                                  p_role in varchar2 default 'B');


  function fn_validation_type(p_module varchar2, p_custid varchar2,
                              p_afacctno varchar2) return varchar2;

  procedure sp_get_ot_rights(p_refcursor in out pkg_report.ref_cursor,
                             p_custid in varchar2);

  procedure sp_get_careby_by_name(p_refcursor in out pkg_report.ref_cursor,
                                  p_username in varchar2,
                                  p_afacctno in varchar2);
  -- bugfix: 1.5.1.0
 PROCEDURE pr_AllocateGuaranteeT0(
                                P_USERID        VARCHAR2,
                                P_USERTYPE        VARCHAR2,
                                P_ACCTNO        VARCHAR2,
                                P_TOAMT        VARCHAR2,
                                P_ACCLIMIT        VARCHAR2,
                                P_RLIMIT        VARCHAR2,
                                P_ACCUSED        VARCHAR2,
                                P_DEAL              VARCHAR2,
                                P_CUSTAVLLIMIT        VARCHAR2,
                                P_MARGINRATE        VARCHAR2,
                                P_SETOTAL        VARCHAR2,
                                P_TOTALLOAN        VARCHAR2,
                                P_PP        VARCHAR2,
                                P_PERIOD        VARCHAR2,
                                P_T0AMTUSED        VARCHAR2,
                                P_T0AMTPENDING        VARCHAR2,
                                P_SYMBOLAMT        VARCHAR2,
                                P_SOURCE        VARCHAR2,
                                PTLID        VARCHAR2,
                                P_DESC        VARCHAR2,
                                P_T0CAL        VARCHAR2,
                                P_ADVANCELINE        VARCHAR2,
                                P_T0OVRQ        VARCHAR2,
                                P_T0DEB        VARCHAR2,
                                P_CONTRACTCHK        VARCHAR2,
                                P_CUSTODYCD        VARCHAR2,
                                P_MARGINRATE_T0        VARCHAR2,
                                P_FULLNAME        VARCHAR2,
                                P_TLFULLNAME        VARCHAR2,
                                P_TLIDNAME        VARCHAR2,
                                P_TLGROUP           VARCHAR2,
                                p_err_code  OUT varchar2,
                                 p_err_message out varchar2);
end htspks_api;
/
CREATE OR REPLACE PACKAGE BODY "HTSPKS_API" is

  -- Private type declarations

  -- Private constant declarations
  c_fo_login  constant char := 'I';
  c_fo_logout constant char := 'O';

  c_auth_by_pass_index  constant int := 5;
  c_auth_by_token_index constant int := 6;
  c_auth_by_sign_index constant int := 7;

  --c_fo_log    constant char := 'L';

  c_fo_user_does_not_existed constant number := -107;
  --c_fo_no_contract_in_list     constant number := -108;
  c_fo_customer_status_invalid constant number := -109;

  -- Private variable declarations
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;
procedure sp_loginToken(p_login_id in out varchar2, p_username in varchar2,
                     p_password varchar2, p_loginsrcip varchar2,
                     p_logindstip varchar2, p_custid in out varchar2,
                     p_role in out varchar2, p_isreset in out varchar2,
                     p_custodycd in out varchar2,
                     p_token in out varchar2,--1.5.1.0: them p_token
                     p_authtype in out varchar2, --1.5.3.0: them authentype
                     p_err_code in out varchar2,
                     p_err_message in out varchar2) as
    l_userid       varchar2(10);
    l_username     varchar2(50);
    l_fullname     varchar2(500);
    l_brid         char(4);
    l_customer_id  char(10);
    l_tokenid      varchar2(25);
    l_current_date varchar2(25);
    l_login_time   varchar2(25);
    l_roles        char(1);
    l_status       char(1);
    l_isreset      char(1);
    l_custody_code varchar2(10);
    l_authtype varchar2(2); --1.5.3.0
  begin

    plog.setbeginsection(pkgctx, 'sp_login');

    p_err_code    := systemnums.c_success;
    p_err_message := '-';

    if not fopks_api.fn_is_ho_active then

      p_err_code    := errnums.c_sa_host_operation_isinactive;
      p_err_message := cspks_system.fn_get_errmsg(p_err_code);
      return;

    end if;

    begin

      select tlid, tlname, tlfullname, brid, tokenid, currdate, logintime,
             role, custid, status, isreset, custodycd, authtype
        into l_userid, l_username, l_fullname, l_brid, l_tokenid,
             l_current_date, l_login_time, l_roles, l_customer_id, l_status,
             l_isreset, l_custody_code, l_authtype
        from (select tlid, tlname, tlfullname, brid, '' tokenid,
                      to_char(getcurrdate, 'DD/MM/RRRR') currdate,
                      to_char(sysdate, 'DD/MM/RRRR HH24:MI:SS') logintime,
                      'B' role, tlid custid, active status, 'N' isreset,
                      '' custodycd, '' authtype
                 from tlprofiles tl
                where tl.tlname = p_username
                  --and tl.pin = p_password
               union all
               select u.username tlid, c.username tlname,
                      c.fullname tlfullname, brid, u.tokenid,
                      to_char(getcurrdate, 'DD/MM/RRRR') currdate,
                      to_char(sysdate, 'DD/MM/RRRR HH24:MI:SS') logintime,
                      'C' role, c.custid, u.status, u.isreset, c.custodycd, o.authtype
                 from userlogin u, cfmast c,
                 (select o.authcustid, max(o.authtype) authtype
                  from otright o where o.cfcustid = o.authcustid and o.deltd='N' and o.via in ('A','K')
                  group by  o.authcustid ) o
                where u.username = c.username and c.custid = o.authcustid
                  and u.username = p_username
                  --and u.loginpwd = p_password
                  );

      if nvl(l_roles, 'X') = 'B' then
        if nvl(l_status, 'X') <> 'Y' then
          p_err_code := c_fo_customer_status_invalid;
          raise errnums.e_biz_rule_invalid;
        end if;
      else
        if nvl(l_status, 'X') <> 'A' then
          p_err_code := c_fo_customer_status_invalid;
          raise errnums.e_biz_rule_invalid;
        end if;
      end if;

    exception
      when no_data_found then
        p_err_code := c_fo_user_does_not_existed;
        raise errnums.e_biz_rule_invalid;
    end;

    p_login_id  := sys_guid();
    p_role      := l_roles;
    p_custid    := trim(l_customer_id);--1.5.1.0: gan tlid khi MG login
    p_isreset   := l_isreset;
    p_custodycd := l_custody_code;
    p_token     := l_tokenid;--1.5.1.0: them p_token
    p_authtype  := l_authtype; --1.5.3.0

    sp_audit_authenticate(p_login_id,
                          p_username,
                          p_loginsrcip,
                          p_logindstip,
                          c_fo_login);

    /*    open p_refcursor for
    select l_userid, l_username, l_fullname, l_brid, l_tokenid,
           l_current_date, l_login_time, l_roles, l_status
      from dual;*/

    plog.setendsection(pkgctx, 'sp_login');
  exception
    when errnums.e_biz_rule_invalid then
      for i in (select errdesc, en_errdesc
                  from deferror
                 where errnum = p_err_code) loop
        p_err_message := i.errdesc;

      --sp_audit_authenticate(p_username, c_fo_log, '', p_err_param);
      end loop;
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'sp_login');
    when others then
      p_err_code := errnums.c_system_error;
      for i in (select errdesc, en_errdesc
                  from deferror
                 where errnum = p_err_code) loop
        p_err_message := i.errdesc;
      end loop;
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'sp_login');
  end;
  -- Function and procedure implementations
  procedure sp_login(p_login_id in out varchar2, p_username in varchar2,
                     p_password varchar2, p_loginsrcip varchar2,
                     p_logindstip varchar2, p_custid in out varchar2,
                     p_role in out varchar2, p_isreset in out varchar2,
                     p_custodycd in out varchar2,
                     p_token in out varchar2,--1.5.1.0: them p_token
                     p_authtype in out varchar2, --1.5.3.0: them authentype
                     p_err_code in out varchar2,
                     p_err_message in out varchar2) as
    l_userid       varchar2(50);
    l_username     varchar2(50);
    l_fullname     varchar2(500);
    l_brid         char(4);
    l_customer_id  char(10);
    l_tokenid      varchar2(25);
    l_current_date varchar2(25);
    l_login_time   varchar2(25);
    l_roles        char(1);
    l_status       char(1);
    l_isreset      char(1);
    l_custody_code varchar2(10);
    l_authtype varchar2(2); --1.5.3.0
  begin

    plog.setbeginsection(pkgctx, 'sp_login');

    p_err_code    := systemnums.c_success;
    p_err_message := '-';

    if not fopks_api.fn_is_ho_active then

      p_err_code    := errnums.c_sa_host_operation_isinactive;
      p_err_message := cspks_system.fn_get_errmsg(p_err_code);
      return;

    end if;

    begin

      select tlid, tlname, tlfullname, brid, tokenid, currdate, logintime,
             role, custid, status, isreset, custodycd , authtype
        into l_userid, l_username, l_fullname, l_brid, l_tokenid,
             l_current_date, l_login_time, l_roles, l_customer_id, l_status,
             l_isreset, l_custody_code , l_authtype
        from (select tlid, tlname, tlfullname, brid, '' tokenid,
                      to_char(getcurrdate, 'DD/MM/RRRR') currdate,
                      to_char(sysdate, 'DD/MM/RRRR HH24:MI:SS') logintime,
                      'B' role, tlid custid, active status, 'N' isreset,
                      '' custodycd, '' authtype
                 from tlprofiles tl
                where tl.tlname = p_username
                  and tl.pin = p_password
               union all
               select u.username tlid, c.username tlname,
                      c.fullname tlfullname, brid, u.tokenid,
                      to_char(getcurrdate, 'DD/MM/RRRR') currdate,
                      to_char(sysdate, 'DD/MM/RRRR HH24:MI:SS') logintime,
                      'C' role, c.custid, u.status
                      , CASE WHEN u.expdate <= getcurrdate THEN 'Y' ELSE u.isreset END isreset
                      ,c.custodycd, o.authtype
                 from userlogin u, cfmast c,
                 (select o.authcustid, max(o.authtype) authtype
                  from otright o where o.cfcustid = o.authcustid and o.deltd='N' and o.via in ('A','K')
                  group by  o.authcustid ) o
                where u.username = c.username and c.custid = o.authcustid
                  and u.username = p_username
                  and u.loginpwd = p_password);

      if nvl(l_roles, 'X') = 'B' then
        if nvl(l_status, 'X') <> 'Y' then
          p_err_code := c_fo_customer_status_invalid;
          raise errnums.e_biz_rule_invalid;
        end if;
      else
        if nvl(l_status, 'X') <> 'A' then
          p_err_code := c_fo_customer_status_invalid;
          raise errnums.e_biz_rule_invalid;
        end if;
      end if;

    exception
      when no_data_found then
        p_err_code := c_fo_user_does_not_existed;
        raise errnums.e_biz_rule_invalid;
    end;

    p_login_id  := sys_guid();
    p_role      := l_roles;
    p_custid    := trim(l_customer_id);--1.5.1.0: gan tlid khi MG login
    p_isreset   := l_isreset;
    p_custodycd := l_custody_code;
    p_token     := l_tokenid;--1.5.1.0: them p_token
    p_authtype  := l_authtype; --1.5.3.0

    sp_audit_authenticate(p_login_id,
                          p_username,
                          p_loginsrcip,
                          p_logindstip,
                          c_fo_login);

    /*    open p_refcursor for
    select l_userid, l_username, l_fullname, l_brid, l_tokenid,
           l_current_date, l_login_time, l_roles, l_status
      from dual;*/

    plog.setendsection(pkgctx, 'sp_login');
  exception
    when errnums.e_biz_rule_invalid then
      for i in (select errdesc, en_errdesc
                  from deferror
                 where errnum = p_err_code) loop
        p_err_message := i.errdesc;

      --sp_audit_authenticate(p_username, c_fo_log, '', p_err_param);
      end loop;
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'sp_login');
    when others then
      p_err_code := errnums.c_system_error;
      for i in (select errdesc, en_errdesc
                  from deferror
                 where errnum = p_err_code) loop
        p_err_message := i.errdesc;
      end loop;
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'sp_login');
  end;

  -- Get account information
  procedure sp_get_account_infor(p_refcursor in out pkg_report.ref_cursor,
                                 p_username varchar2, p_password varchar2,
                                 p_role varchar2) as
    l_roles char(1);
  begin

    plog.setbeginsection(pkgctx, 'sp_get_account_infor');

    l_roles := p_role;

    if nvl(l_roles, 'X') = 'B' then
      open p_refcursor for
        select tlid, tlname, tlfullname, brid, '' tokenid,
               to_char(getcurrdate, 'DD/MM/RRRR') currdate,
               to_char(sysdate, 'DD/MM/RRRR HH24:MI:SS') logintime,
               '' custid, tlid subaccounts
          from tlprofiles tl
         where tl.active = 'Y'
           and tl.tlname = p_username
           --and tl.pin = p_password
           ;
    elsif nvl(l_roles, 'X') = 'C' then
      open p_refcursor for
        select '%%' tlid, c.username tlname, c.fullname tlfullname, brid,
               u.tokenid, to_char(getcurrdate, 'DD/MM/RRRR') currdate,
               to_char(sysdate, 'DD/MM/RRRR HH24:MI:SS') logintime, c.custid,
               u.isreset, a.subaccounts
          from userlogin u, cfmast c,
               (select custid,
                       listagg(acctno, ',') WITHIN GROUP(ORDER BY custid) as subaccounts
                  from afmast
                 where status in ('A', 'P')
                 group by custid) a
         where u.username = c.username
         and c.custid = a.custid
           and u.status = 'A'
           and upper(u.username) = upper(p_username) -- 1.5.3.0
           --and u.loginpwd = p_password
           ;
    end if;

    plog.setendsection(pkgctx, 'sp_get_account_infor');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'sp_get_account_infor');
  end;

  procedure sp_get_sub_account(p_refcursor in out pkg_report.ref_cursor,
                               p_custodycode varchar2, p_tlid varchar2,
                               p_custid varchar2, p_role varchar2) as
    l_roles char(1);
  begin

    plog.setbeginsection(pkgctx, 'sp_get_sub_account');

    l_roles := p_role;

    if nvl(l_roles, 'X') = 'B' then
      open p_refcursor for
        select mst.*, rownum lstodr
          from (select a.acctno cdval,
                        c.custodycd || '.' || t.typename cdcontent,
                        a.tradetelephone, c.fullname
                   from afmast a, cfmast c, aftype t, mrtype m
                  where a.custid = c.custid
                    and a.actype = t.actype
                    and custodycd = upper(p_custodycode)
                    and a.status in ('A', 'P')
                    and t.mrtype = m.actype
                    and a.careby in
                        (select grpid from tlgrpusers where tlid = p_tlid)
                  order by decode(m.mrtype, 'T', 0, 1)) mst;
    elsif nvl(l_roles, 'X') = 'C' then
      open p_refcursor for
        select a.cdval, a.cdcontent, a.tradetelephone, a.custodycd, a.status,
               rownum lstodr, a.cdcontent || '.' || a.fullname fullname
          from (select af.acctno cdval,
                        cf.custodycd || '.' || aft.typename cdcontent,
                        af.tradetelephone, cf.custodycd, af.status,
                        decode(m.mrtype, 'T', 0, 1) stt, cf.fullname
                   from (select authcustid, cfcustid,max(via) via
                        from otright
                        where deltd <> 'Y' and VALDATE <= getcurrdate  AND getcurrdate <= EXPDATE
                              AND via IN ('A', 'K')
                         group by authcustid, cfcustid) r, afmast af, aftype aft, cfmast cf, mrtype m
                  where af.actype = aft.actype
                    and r.Cfcustid= af.Custid
                    and cf.custid = af.custid
                    and aft.mrtype = m.actype
                    and r.authcustid = p_custid
                    order by stt) a;
    end if;

    plog.setendsection(pkgctx, 'sp_get_sub_account');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'sp_get_sub_account');
  end;

  -- Logout function
  procedure fn_logout(p_login_id varchar2, p_err_code in out varchar2,
                      p_err_param out varchar2) as
    l_err_desc varchar2(1000);
  begin
    plog.setbeginsection(pkgctx, 'fn_logout');
    -- TO DO
    p_err_code := systemnums.c_success;
    sp_audit_authenticate(p_login_id, '', '', '', c_fo_logout);

    begin
      select errdesc
        into l_err_desc
        from deferror
       where errnum = p_err_code;
      p_err_param := l_err_desc;
    exception
      when no_data_found then
        p_err_param := 'Ma loi chua duoc dinh nghia.';
    end;

  exception
    when others then
      p_err_code := errnums.c_system_error;
      select errdesc
        into l_err_desc
        from deferror
       where errnum = p_err_code;
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'fn_logout');
  end;

  -- Audit login/ logout
  procedure sp_audit_authenticate(p_loginid varchar2, p_userid char,
                                  p_loginsrcip varchar2,
                                  p_logindstip varchar2, p_type char) as
    --l_text varchar2(200);
  begin
    plog.setbeginsection(pkgctx, 'sp_audit_authenticate');

    --Ghi log xu ly
    if nvl(p_type, 'X') = c_fo_login then
      --Login
      insert into loginhist
        (loginid, userid, logintime, loginsrcip, logindstip)
      values
        (p_loginid, p_userid, sysdate, p_loginsrcip, p_logindstip);
    elsif nvl(p_type, 'X') = c_fo_logout then
      --Logout
      update loginhist
         set logouttime = sysdate
       where loginhist.loginid = p_loginid;
    end if;

    plog.setendsection(pkgctx, 'sp_audit_authenticate');
    commit;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'sp_audit_authenticate');
  end;

  -- Get orders all list
  procedure sp_get_orders_by_user(p_refcursor in out pkg_report.ref_cursor,
                                  p_tlname in varchar2,
                                  p_rowperpage in number, p_page in number,
                                  p_role in varchar2 default 'B') is
    l_page number;
    l_custodycd VARCHAR2(10);
  begin

    l_page := p_page + 1;

    if nvl(p_role, 'X') = 'B' then

      open p_refcursor for
        select *
          from (select a.*, rownum r
                   from (select exectype, pricetype, custodycd, afacctno,
                                 symbol, orderqtty, quoteprice * 1000 quoteprice,
                                 execqtty,
                                 case
                                   when execqtty > 0 and cancelqtty = 0 and
                                        adjustqtty = 0 then
                                    ORSTATUSVALUE || ' ' || execqtty || '/' ||
                                    orderqtty
                                   when cancelqtty > 0 and adjustqtty = 0 then
                                    ORSTATUSVALUE || ' ' || cancelqtty || '/' ||
                                    orderqtty
                                   when adjustqtty > 0 then
                                    ORSTATUSVALUE || ' ' || adjustqtty || '/' ||
                                    orderqtty
                                   else
                                    ORSTATUSVALUE
                                 end status, orderid,
                                 decode(hosesession,
                                         'O',
                                         'Liên tục',
                                         'A',
                                         'Định kỳ',
                                         'P',
                                         'Định kỳ') hosesession,
                                 sdtime lastchange, remainqtty, desc_exectype,
                                 cancelqtty, adjustqtty, tradeplace, iscancel,
                                 isadmend, isdisposal, foacctno,
                                 nvl(limitprice * 1000, 0) limitprice, execamt,
                                 nvl(quoteqtty, 0) quoteqtty,
                                 to_char(odtimestamp,
                                          'RRRR/MM/DD hh24:mi:ss.ff9') odtimestamp,
                                 orstatusvalue, confirmed, txtime
                            from buf_od_account
                           where tlid = p_tlname
                             and txdate = getcurrdate
                             and orstatusvalue not in ( 'P', 'R')
                           order by txtime desc) a
                  where rownum <= p_rowperpage * l_page)
         where r > p_rowperpage * (l_page - 1);
    ELSE
      SELECT custodycd INTO l_custodycd
      FROM cfmast
      WHERE custid = p_tlname;

      open p_refcursor for
        select *
          from (select a.*, rownum r
                   from (select exectype, pricetype, custodycd, afacctno,
                                 symbol, orderqtty, quoteprice * 1000 quoteprice,
                                 execqtty,
                                 case
                                   when execqtty > 0 and cancelqtty = 0 and
                                        adjustqtty = 0 then
                                    ORSTATUSVALUE || ' ' || execqtty || '/' ||
                                    orderqtty
                                   when cancelqtty > 0 and adjustqtty = 0 then
                                    ORSTATUSVALUE || ' ' || cancelqtty || '/' ||
                                    orderqtty
                                   when adjustqtty > 0 then
                                    ORSTATUSVALUE || ' ' || adjustqtty || '/' ||
                                    orderqtty
                                   else
                                    ORSTATUSVALUE
                                 end status, orderid,
                                 decode(hosesession,
                                         'O',
                                         'Liên tục',
                                         'A',
                                         'Định kỳ',
                                         'P',
                                         'Định kỳ') hosesession,
                                 sdtime lastchange, remainqtty, desc_exectype,
                                 cancelqtty, adjustqtty, tradeplace, iscancel,
                                 isadmend, isdisposal, foacctno,
                                 nvl(limitprice * 1000, 0) limitprice, execamt,
                                 nvl(quoteqtty, 0) quoteqtty,
                                 to_char(odtimestamp,
                                          'RRRR/MM/DD hh24:mi:ss.ff9') odtimestamp,
                                 orstatusvalue, confirmed, txtime
                            from buf_od_account
                           where custodycd = l_custodycd
                             and txdate = getcurrdate
                             and orstatusvalue not in ( 'P', 'R')
                           order by txtime desc) a
                  where rownum <= p_rowperpage * l_page)
         where r > p_rowperpage * (l_page - 1);
    end if;
  end sp_get_orders_by_user;

  -- Refesh orders
  procedure sp_refesh_orders_by_user(p_refcursor in out pkg_report.ref_cursor,
                                     p_tlname in varchar2, p_scn in varchar2,
                                     p_role in varchar2 default 'B') is
  l_custodycd VARCHAR2(10);
  begin

    if nvl(p_role, 'X') = 'B' then

      open p_refcursor for
        select exectype, pricetype, custodycd, afacctno, symbol, orderqtty,
               quoteprice * 1000 quoteprice,
               case
                 when execqtty > 0 and cancelqtty = 0 and adjustqtty = 0 then
                  ORSTATUSVALUE || ' ' || execqtty || '/' || orderqtty
                 when cancelqtty > 0 and adjustqtty = 0 then
                  ORSTATUSVALUE || ' ' || cancelqtty || '/' || orderqtty
                 when adjustqtty > 0 then
                  ORSTATUSVALUE || ' ' || adjustqtty || '/' || orderqtty
                 else
                  ORSTATUSVALUE
               end status, orderid,
               decode(hosesession,
                       'O',
                        'Liên tục',
                        'A',
                        'Định kỳ',
                        'P',
                        'Định kỳ') hosesession, sdtime lastchange, remainqtty,
               cancelqtty, adjustqtty, tradeplace, desc_exectype, iscancel,
               isadmend, isdisposal, foacctno,
               to_char(odtimestamp, 'RRRR/MM/DD hh24:mi:ss.ff9') odtimestamp,
               orstatusvalue, nvl(limitprice * 1000, 0) limitprice,
               nvl(quoteqtty, 0) quoteqtty, confirmed, execqtty, execamt,
               txtime
          from buf_od_account
         where tlid = p_tlname
           and txdate = getcurrdate
           and orstatusvalue not in ( 'P', 'R')
           and odtimestamp >
               to_timestamp(p_scn, 'RRRR/MM/DD hh24:mi:ss.ff9');
    else
      SELECT custodycd INTO l_custodycd
      FROM cfmast
      WHERE custid = p_tlname;

      open p_refcursor for
        select exectype, pricetype, custodycd, afacctno, symbol, orderqtty,
               quoteprice * 1000 quoteprice,
               case
                 when execqtty > 0 and cancelqtty = 0 and adjustqtty = 0 then
                  ORSTATUSVALUE || ' ' || execqtty || '/' || orderqtty
                 when cancelqtty > 0 and adjustqtty = 0 then
                  ORSTATUSVALUE || ' ' || cancelqtty || '/' || orderqtty
                 when adjustqtty > 0 then
                  ORSTATUSVALUE || ' ' || adjustqtty || '/' || orderqtty
                 else
                  ORSTATUSVALUE
               end status, orderid,
               decode(hosesession,
                       'O',
                       'Liên tục',
                       'A',
                       'Định kỳ',
                       'P',
                       'Định kỳ') hosesession, sdtime lastchange, remainqtty,
               cancelqtty, adjustqtty, tradeplace, desc_exectype, iscancel,
               isadmend, isdisposal, foacctno,
               to_char(odtimestamp, 'RRRR/MM/DD hh24:mi:ss.ff9') odtimestamp,
               orstatusvalue, nvl(limitprice * 1000, 0) limitprice,
               nvl(quoteqtty, 0) quoteqtty, confirmed, execqtty, execamt,
               txtime
          from buf_od_account
          where custodycd = l_custodycd
           and txdate = getcurrdate
           and orstatusvalue not in ( 'P', 'R')
           and odtimestamp >
               to_timestamp(p_scn, 'RRRR/MM/DD hh24:mi:ss.ff9');
    end if;
  end sp_refesh_orders_by_user;

  -- Audit login/ logout

  -- Audit login/ logout
  function fn_validation_type(p_module varchar2, p_custid varchar2,
                              p_afacctno varchar2) return varchar2 as
    l_auth_cust_id varchar2(10);
    --l_otmn_code    varchar2(20);
    l_ot_right    varchar2(10);
    l_pass_value  varchar2(1);
    l_token_value varchar2(1);
     l_sign_value varchar2(1);
     l_custid     varchar2(10);
  begin
    plog.setbeginsection(pkgctx, 'fn_is_module_permission');

    begin
      select af.custid into l_custid
       from afmast af where af.acctno =  p_afacctno;
      select d.authcustid, d.otright
        into l_auth_cust_id, l_ot_right
        from ( select authcustid, cfcustid,max(via) via
              from otright
              where deltd <> 'Y'
              AND getcurrdate <= EXPDATE AND via IN ('A', 'K')
               group by authcustid, cfcustid) o , otrightdtl d, allcode a
       where o.authcustid = d.authcustid
         and o.cfcustid = d.cfcustid
         and o.via= d.via
         and d.deltd = 'N'
         and o.cfcustid = l_custid
         and o.authcustid = p_custid
         and d.otmncode = p_module
         and a.cdval = d.otmncode
         and a.cdname = 'OTFUNC';

    exception
      when no_data_found then
        return 'NONE';
    end;
--YYYYNNY
    l_pass_value  := substr(l_ot_right, c_auth_by_pass_index, 1);
    l_token_value := substr(l_ot_right, c_auth_by_token_index, 1);
    l_sign_value := substr(l_ot_right, c_auth_by_sign_index, 1);


        if (nvl(l_token_value, 'X') = 'Y') then
      return 'TOKEN';
    end if;

    if (nvl(l_pass_value, 'X') = 'Y') then
      return 'PASS';
    end if;

    if (nvl(l_sign_value, 'X') = 'Y') then
      return 'SIGN';
    end if;

    return 'NONE';

    plog.setendsection(pkgctx, 'fn_is_module_permission');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'fn_is_module_permission');
      return 'NONE';
  end fn_validation_type;

  procedure sp_get_ot_rights(p_refcursor in out pkg_report.ref_cursor,
                             p_custid in varchar2) is
    l_current_date date;
  begin

    open p_refcursor for
      select af.acctno AFACCTNO, d.otmncode, d.otright
        from ( select authcustid, cfcustid,max(via) via
              from otright
              where deltd <> 'Y'
              AND getcurrdate <= EXPDATE and valdate<= getcurrdate
              AND via IN ('A', 'K')
               group by authcustid, cfcustid) o, otrightdtl d, afmast af
       where o.authcustid = d.authcustid
         and o.cfcustid = d.cfcustid
         and o.via = d.via
         and d.deltd = 'N'
         and o.cfcustid = af.custid
         and o.authcustid = p_custid;

  end sp_get_ot_rights;

  -- Get careby by username
  procedure sp_get_careby_by_name(p_refcursor in out pkg_report.ref_cursor,
                                  p_username in varchar2,
                                  p_afacctno in varchar2) is
  begin

    open p_refcursor for
      select a.acctno, c.custodycd
        from afmast a, cfmast c
       where a.custid = c.custid
         and a.status in ('A', 'P')
            --and a.isfixaccount = 'N'
         and a.acctno = p_afacctno
         and a.careby in (select grpid
                            from tlgrpusers g, tlprofiles p
                           where g.tlid = p.tlid
                             and p.tlname = p_username)
      union
       select a.acctno, c.custodycd
       from afmast a, cfmast c, otright o
       where a.custid = o.cfcustid
         and a.status in ('A', 'P')
         and o.deltd = 'N'
         and o.valdate <= getcurrdate
         and o.expdate >= getcurrdate
         and o.via ='A'
         and o.authcustid = c.custid
         and a.acctno = p_afacctno
         and c.username = p_username;

  end sp_get_careby_by_name;
  -- bugfix: 1.5.1.0
  PROCEDURE pr_AllocateGuaranteeT0(
                                P_USERID        VARCHAR2,
                                P_USERTYPE        VARCHAR2,
                                P_ACCTNO        VARCHAR2,
                                P_TOAMT        VARCHAR2,
                                P_ACCLIMIT        VARCHAR2,
                                P_RLIMIT        VARCHAR2,
                                P_ACCUSED        VARCHAR2,
                                P_DEAL              VARCHAR2,
                                P_CUSTAVLLIMIT        VARCHAR2,
                                P_MARGINRATE        VARCHAR2,
                                P_SETOTAL        VARCHAR2,
                                P_TOTALLOAN        VARCHAR2,
                                P_PP        VARCHAR2,
                                P_PERIOD        VARCHAR2,
                                P_T0AMTUSED        VARCHAR2,
                                P_T0AMTPENDING        VARCHAR2,
                                P_SYMBOLAMT        VARCHAR2,
                                P_SOURCE        VARCHAR2,
                                PTLID        VARCHAR2,
                                P_DESC        VARCHAR2,
                                P_T0CAL        VARCHAR2,
                                P_ADVANCELINE        VARCHAR2,
                                P_T0OVRQ        VARCHAR2,
                                P_T0DEB        VARCHAR2,
                                P_CONTRACTCHK        VARCHAR2,
                                P_CUSTODYCD        VARCHAR2,
                                P_MARGINRATE_T0        VARCHAR2,
                                P_FULLNAME        VARCHAR2,
                                P_TLFULLNAME        VARCHAR2,
                                P_TLIDNAME        VARCHAR2,
                                P_TLGROUP           VARCHAR2,
                            p_err_code  OUT varchar2,
                            p_err_message out varchar2) is
Begin
 fopks_api.pr_AllocateGuaranteeT0(P_USERID, P_USERTYPE, P_ACCTNO, P_TOAMT, P_ACCLIMIT, P_RLIMIT, P_ACCUSED,P_DEAL, P_CUSTAVLLIMIT, P_MARGINRATE, P_SETOTAL, P_TOTALLOAN, P_PP, P_PERIOD, P_T0AMTUSED, P_T0AMTPENDING, P_SYMBOLAMT, P_SOURCE, PTLID, P_DESC, P_T0CAL, P_ADVANCELINE, P_T0OVRQ, P_T0DEB, P_CONTRACTCHK, P_CUSTODYCD, P_MARGINRATE_T0, P_FULLNAME, P_TLFULLNAME, P_TLIDNAME, P_TLGROUP, p_err_code, p_err_message );
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_AllocateGuaranteeT0');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_AllocateGuaranteeT0');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_AllocateGuaranteeT0;

begin

  -- Initialization
  for i in (select * from tlogdebug) loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('htspks_api',
                      plevel      => nvl(logrow.loglevel, 30),
                      plogtable   => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert      => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace      => (nvl(logrow.log4trace, 'N') = 'Y'));
end htspks_api;
/
