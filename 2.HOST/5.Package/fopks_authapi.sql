create or replace package fopks_authapi is

  /** ----------------------------------------------------------------------------------------------------
  ** Module: FO - OpenAPI 3
  ** Description: OpenAPI 3
  ** and is copyrighted by FSS.
  **
  **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
  **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
  **    graphic, optic recording or otherwise, translated in any language or computer language,
  **    without the prior written permission of Financial Software Solutions. JSC.
  **
  **  MODIFICATION HISTORY
  **    Person            Date           Comments
  **  duyanh.hoang     05/09/2019         Created
  ** (c) 2018 by Financial Software Solutions. JSC.
  ----------------------------------------------------------------------------------------------------*/
  type ref_cursor is ref cursor;
  procedure sp_login(p_username      varchar2,
                     p_password      varchar2,
                     p_customer_id   in out varchar2,
                     p_customer_info in out varchar2,
                     p_role          IN OUT VARCHAR2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2);
  procedure sp_audit_authenticate(p_key  varchar2,
                                  p_type char,
                                  p_channel varchar2,
                                  p_text varchar2);
    PROCEDURE pr_getAuthType (p_userName    VARCHAR2,
                           p_via          VARCHAR2,
                           pv_authType    OUT VARCHAR2,
                           pv_mobile1     OUT VARCHAR2,
                           pv_mobile2     OUT VARCHAR2,
                           pv_email       OUT VARCHAR2,
                           p_err_code     OUT VARCHAR2,
                           p_err_message  OUT VARCHAR2);
  PROCEDURE pr_getSerialNum (p_custId       VARCHAR2,
                          p_serialNum     OUT VARCHAR2,
                          p_err_code      OUT VARCHAR2,
                          p_err_message   OUT VARCHAR2);
  PROCEDURE pr_checkTradingPass (p_userName   VARCHAR2,
                           p_passWord         VARCHAR2,
                           p_err_code     OUT VARCHAR2,
                           p_err_message  OUT VARCHAR2);
  PROCEDURE pr_checkPassword (p_userName   VARCHAR2,
						   p_passWord         VARCHAR2,
						   p_err_code     OUT VARCHAR2,
						   p_err_message  OUT VARCHAR2);
  PROCEDURE pr_getAuthCustid (pv_refCuror OUT ref_cursor,
                             p_acctno     IN VARCHAR2,
                           p_err_code     OUT VARCHAR2,
                           p_err_message  OUT VARCHAR2);
  PROCEDURE pr_getCfCustid (pv_refCuror   OUT ref_cursor,
                             p_custid      IN VARCHAR2,
                             p_via         IN VARCHAR2,
                             p_err_code     OUT VARCHAR2,
                             p_err_message  OUT VARCHAR2);   
  PROCEDURE pr_getinfCamast (pv_refCuror   OUT ref_cursor,
                             p_err_code     OUT VARCHAR2,
                             p_err_message  OUT VARCHAR2);                                               
end fopks_authapi;
/
create or replace package body fopks_authapi is
  -- Private variable declarations
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;

  -- Private constant declarations
  C_FO_LOGIN  constant char := 'I';
  C_FO_LOGOUT constant char := 'O';
  C_FO_LOG    constant char := 'L';

  C_FO_USER_DOES_NOT_EXISTED   constant number := -107;
  C_FO_NO_CONTRACT_IN_LIST     constant number := -108;
  C_FO_CUSTOMER_STATUS_INVALID constant number := -109;

  procedure sp_login(p_username      varchar2,
                     p_password      varchar2,
                     p_customer_id   in out varchar2,
                     p_customer_info in out varchar2,
                     p_role          IN OUT VARCHAR2,
                     p_err_code      in out varchar2,
                     p_err_param     in out varchar2) as

    l_username varchar2(50);
    l_status   char(1);
  begin

    plog.setBeginSection(pkgctx, 'sp_login');

    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

    begin
      select username,
             custid,
             fullname,
             status,
             role
        into l_username, p_customer_id, p_customer_info, l_status, p_role
      FROM (SELECT u.username, c.custid, c.fullname, c.status, 'C' role
            from userlogin u, cfmast c
           where u.username = c.username
             and upper(u.username) = upper(p_username)
             and u.loginpwd = genencryptpassword(p_password)
             and u.status = 'A'
          UNION ALL
          SELECT tl.tlname  userName,
                 tl.tlid    custId,
                 tl.tlfullname  fullName,
                 tl.active      status,
                 'B' role
          FROM tlprofiles tl
          WHERE tl.tlname = upper(p_username)
          AND tl.pin = genencryptpassword(p_password)
          );

      IF p_role <> 'B' AND nvl(l_status, 'X') not in ('A','P') then
        p_err_code := C_FO_CUSTOMER_STATUS_INVALID;
        raise errnums.E_BIZ_RULE_INVALID;
      end if;

    exception
      when NO_DATA_FOUND then
        p_err_code := C_FO_USER_DOES_NOT_EXISTED;
        raise errnums.E_BIZ_RULE_INVALID;
    end;

    sp_audit_authenticate(p_username, C_FO_LOGIN, '', 'Login successful');
    plog.setEndSection(pkgctx, 'sp_login');
  exception
    when errnums.E_BIZ_RULE_INVALID then
      for i in (select errdesc, en_errdesc
                  from deferror
                 where errnum = p_err_code)
      loop
        p_err_param := i.errdesc;

        sp_audit_authenticate(p_username, C_FO_LOG, '', p_err_param);
      end loop;
      plog.setEndSection(pkgctx, 'sp_login');
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.setEndSection(pkgctx, 'sp_login');
  end;

  procedure sp_audit_authenticate(p_key  varchar2,
                                  p_type char,
                                  p_channel varchar2,
                                  p_text varchar2) as
    l_text varchar2(200);
  begin
    plog.setbeginsection(pkgctx, 'sp_audit_authenticate');

    plog.debug(pkgctx, l_text);

    l_text := p_key || ' - ' || p_text;
    --Ghi log xu ly
    insert into fo_audit_logs
      (action_date, username, channel, action_type, action_desc)
    values
      (sysdate, p_key, p_channel, p_type, l_text);

    plog.setendsection(pkgctx, 'sp_audit_authenticate');
    commit;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'sp_audit_authenticate');
  end;

  PROCEDURE pr_getAuthType (p_userName    VARCHAR2,
                           p_via          VARCHAR2,
                           pv_authType    OUT VARCHAR2,
                           pv_mobile1     OUT VARCHAR2,
                           pv_mobile2     OUT VARCHAR2,
                           pv_email       OUT VARCHAR2,
                           p_err_code     OUT VARCHAR2,
                           p_err_message  OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_getAuthType');
    p_err_code := '0';
    p_err_message := '';
    BEGIN
      SELECT authtype, mobilesms, mobile, email
      INTO pv_authType, pv_mobile1, pv_mobile2, pv_email
      FROM (
        SELECT o.authtype, cf.mobile, cf.mobilesms, cf.email
        FROM userlogin u, otright o, cfmast cf
        WHERE u.username = p_userName
        AND u.username = cf.username AND cf.custid = o.cfcustid AND o.deltd = 'N'
        AND u.status = 'A' AND o.via IN ('A', p_via)
        ORDER BY via DESC
        )
      WHERE rownum = 1;
    EXCEPTION
      WHEN OTHERS THEN
        pv_authType := '';
        p_err_code := '-100078';
        p_err_message := cspks_system.fn_get_errmsg(p_err_code);
    END;
    plog.setEndSection(pkgctx, 'pr_getAuthType');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := '-1';
      p_err_message := 'System Error';
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_getAuthType');
  END;

  PROCEDURE pr_getSerialNum (p_custId       VARCHAR2,
                            p_serialNum     OUT VARCHAR2,
                            p_err_code      OUT VARCHAR2,
                            p_err_message   OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_getSerialNum');
    p_err_code := '';
    p_err_message := '';
    p_serialNum := '';
    FOR rec IN (
      SELECT t.serialnumsig
      FROM otright t
      WHERE t.cfcustid = p_custId AND t.authcustid = p_custId
      AND t.deltd = 'N' AND t.authtype = '4'
      ORDER BY case WHEN t.via = 'A' THEN 1 ELSE 0 END
    ) LOOP
      p_serialNum := rec.serialnumsig;
      EXIT;
    END LOOP;
    plog.setEndSection(pkgctx, 'pr_getSerialNum');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := '-1';
      p_err_message := 'System Error';
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_getSerialNum');
  END;

  PROCEDURE pr_checkTradingPass (p_userName   VARCHAR2,
                           p_passWord         VARCHAR2,
                           p_err_code     OUT VARCHAR2,
                           p_err_message  OUT VARCHAR2)
  IS
  l_count   NUMBER;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_checkTradingPass');
    p_err_code := '0';
    p_err_message := '';
    SELECT COUNT(1) INTO l_count
    FROM userlogin u
    WHERE userName = p_userName
    AND status = 'A' AND u.tradingpwd = genencryptpassword(p_passWord);
    IF NOT l_count = 1 THEN
      p_err_code := '-670044';
      p_err_message := cspks_system.fn_get_errmsg(p_err_code);
    END IF;
    plog.setEndSection(pkgctx, 'pr_checkTradingPass');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := '-1';
      p_err_message := 'System Error';
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_checkTradingPass');
  END;
PROCEDURE pr_checkPassword (p_userName   VARCHAR2,
                           p_passWord         VARCHAR2,
                           p_err_code     OUT VARCHAR2,
                           p_err_message  OUT VARCHAR2)
  IS
  l_count   NUMBER;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_checkPassword');
    p_err_code := '0';
    p_err_message := '';
    SELECT COUNT(1) INTO l_count
    FROM userlogin u
    WHERE userName = p_userName
    AND status = 'A' AND u.loginpwd = genencryptpassword(p_passWord);
    IF NOT l_count = 1 THEN
      p_err_code := '-670044';
      p_err_message := cspks_system.fn_get_errmsg(p_err_code);
    END IF;
    plog.setEndSection(pkgctx, 'pr_checkPassword');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := '-1';
      p_err_message := 'System Error';
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_checkPassword');
  END;
--Danh sach ALL tai khooan uy quyen
  PROCEDURE pr_getAuthCustid (pv_refCuror   OUT ref_cursor,
                             p_acctno       IN VARCHAR2,
                             p_err_code     OUT VARCHAR2,
                             p_err_message  OUT VARCHAR2)
  IS
  v_custid VARCHAR2(10);
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_getAuthCustid');
    p_err_code := '0';
    p_err_message := '';
    
    if p_acctno = 'ALL' OR p_acctno is NULL then
      v_custid := '%%';
    else
      select custid into v_custid from afmast where acctno = p_acctno;
    end if;

    OPEN pv_refCuror
    FOR
        SELECT distinct CF.CUSTID, CF.CUSTODYCD
        FROM OTRIGHT R, AFMAST AF, CFMAST CF
        WHERE AF.CUSTID=CF.CUSTID
              AND CF.CUSTID = (CASE WHEN R.CFCUSTID = R.AUTHCUSTID THEN R.CFCUSTID ELSE R.AUTHCUSTID END)
              AND (CF.CUSTID = R.CFCUSTID OR CF.CUSTID = R.AUTHCUSTID)
              AND R.DELTD = 'N'
              and R.CFCUSTID like v_custid
              AND getcurrdate BETWEEN r.valdate AND r.expdate;

    plog.setEndSection(pkgctx, 'pr_getAuthCustid');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := '-1';
      p_err_message := 'System Error';
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_getAuthCustid');
  END pr_getAuthCustid;
  
  PROCEDURE pr_getCfCustid (pv_refCuror   OUT ref_cursor,
                             p_custid      IN VARCHAR2,
                             p_via         IN VARCHAR2,
                             p_err_code     OUT VARCHAR2,
                             p_err_message  OUT VARCHAR2)
  IS
  v_custid VARCHAR2(10);
  v_via    VARCHAR2(10);
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_getCfCustid');
    p_err_code := '0';
    p_err_message := '';

    v_via:= CASE WHEN p_via = 'ALL' OR p_via is NULL THEN '%%' ELSE p_via END;
    v_custid:= CASE WHEN p_custid = 'ALL' OR p_custid is NULL THEN '%%' ELSE p_custid END;
    
    OPEN pv_refCuror
    FOR
      SELECT  distinct AF.ACCTNO, OT.* FROM (
         SELECT distinct R.CFCUSTID, R.AUTHCUSTID, DTL.OTMNCODE, AL.CDCONTENT
                FROM OTRIGHT R, CFMAST CF, OTRIGHTDTL DTL, ALLCODE AL
                WHERE  CF.CUSTID = (CASE WHEN R.CFCUSTID = R.AUTHCUSTID THEN R.CFCUSTID ELSE R.AUTHCUSTID END)
                      AND R.CFCUSTID = DTL.CFCUSTID AND R.AUTHCUSTID = DTL.AUTHCUSTID AND DTL.DELTD = 'N'
                      AND AL.CDTYPE ='SA' AND AL.CDNAME ='OTFUNC' AND AL.CDVAL = DTL.OTMNCODE
                      AND (CASE WHEN SUBSTR(DTL.OTRIGHT,2,1) = 'Y' THEN 1 ELSE 0 END) = 1
                      AND R.DELTD = 'N'
                      AND R.AUTHCUSTID LIKE v_custid
                      AND R.VIA LIKE v_via
                      AND getcurrdate BETWEEN r.valdate AND r.expdate
                      ) OT, AFMAST AF 
       WHERE OT.CFCUSTID = AF.CUSTID
       ORDER BY AF.ACCTNO;

    plog.setEndSection(pkgctx, 'pr_getCfCustid');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := '-1';
      p_err_message := 'System Error';
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_getCfCustid');
  END pr_getCfCustid;

  PROCEDURE pr_getinfCamast (pv_refCuror   OUT ref_cursor,
                             p_err_code     OUT VARCHAR2,
                             p_err_message  OUT VARCHAR2)
  IS
  v_frdate date;
  v_currdate date;
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_getinfCamast');
    p_err_code := '0';
    p_err_message := '';
    
   SELECT TO_DATE (varvalue, systemnums.c_date_format)
         INTO v_currdate
         FROM sysvar
         WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
   select to_date(ADD_MONTHS(getcurrdate, -1),'dd/mm/rrrr') into v_frdate from dual;

    OPEN pv_refCuror
    FOR
      select al.CDCONTENT, ca.STATUS, ca.AUTOID, sb.symbol, ca.DESCRIPTION, ca.REPORTDATE, ca.ACTIONDATE, sb.Parvalue,
      ca.INTERESTRATE, ca.SPLITRATE, ca.DEVIDENTSHARES, ca.DEVIDENTRATE, ca.RIGHTOFFRATE, ca.EXRATE
      from camast ca, sbsecurities sb, allcode al where ca.codeid = sb.codeid
      and al.CDTYPE = 'CA' AND al.CDNAME = 'CATYPE' AND al.CDVAL= ca.CATYPE
      and ca.actiondate between v_frdate and v_currdate;
             
    plog.setEndSection(pkgctx, 'pr_getinfCamast');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := '-1';
      p_err_message := 'System Error';
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_getinfCamast');
  END pr_getinfCamast;
  
begin
  -- Initialization
  for i in (select * from tlogdebug)
  loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('fopks_authapi',
                      plevel     => nvl(logrow.loglevel, 30),
                      plogtable  => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert     => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace     => (nvl(logrow.log4trace, 'N') = 'Y'));
end fopks_authapi;
/
