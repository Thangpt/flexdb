--
--
/
create or replace package fopks_sa is

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
  /*                               
  Load Cache Map API
  */
  Procedure PRC_FOCMDCODE(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                          p_err_code  in out varchar2,
                          p_err_param in out varchar2);
  /*                               
  Load Cache ALLCODE.
  */
  Procedure pr_get_allcode(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                          p_err_code  in out varchar2,
                          p_err_param in out varchar2);

  /*
  Get all accounts to load cache.
  */
  procedure pr_get_all_account(p_refcursor in out PKG_REPORT.REF_CURSOR,
                               p_err_code  in out varchar2,
                               p_err_param in out varchar2);
  PROCEDURE pr_get_all_account_broker (p_refcursor IN OUT pkg_report.ref_cursor,
                                       p_err_code  IN OUT VARCHAR2,
                                       p_err_param IN OUT VARCHAR2);
end fopks_sa;
/
create or replace package body fopks_sa is

  -- Private type declarations
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;
  
  /*                               
  Load Cache Map API
  */
  procedure PRC_FOCMDCODE(p_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                          p_err_code  in out varchar2,
                          p_err_param in out varchar2) as
  begin

    plog.setBeginSection(pkgctx, 'PRC_FOCMDCODE');

    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';

    Open p_refcursor for
      SELECT A.CMDCODE, A.CMDTEXT, A.CMDUSE, A.CMDTYPE, A.CMDDESC
        FROM FOCMDCODE A
       WHERE A.CMDUSE = 'Y';

    plog.setEndSection(pkgctx, 'PRC_FOCMDCODE');
  exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'PRC_FOCMDCODE');
  end PRC_FOCMDCODE;
  
  /*
  Lấy dữ liệu allcode.
  */
  procedure pr_get_allcode(p_refcursor in out PKG_REPORT.REF_CURSOR,
                               p_err_code  in out varchar2,
                               p_err_param in out varchar2) as
  begin
    plog.setbeginsection(pkgctx, 'pr_get_allcode');
    p_err_code := systemnums.c_success;
    open p_refcursor for
      select a.CDTYPE || a.CDNAME || '_' || a.CDVAL id,
             a.CDTYPE,
             a.CDNAME,
             a.CDVAL,
             a.CDCONTENT,
             a.EN_CDCONTENT
      FROM allcode a;
    plog.setendsection(pkgctx, 'pr_get_allcode');
  exception
    when others then
      p_err_code  := -1;
      p_err_param := cspks_system.fn_get_errmsg(p_err_code);
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_allcode');
  end;
  
  /*
  Get all accounts to load cache.
  */
  procedure pr_get_all_account(p_refcursor in out PKG_REPORT.REF_CURSOR,
                               p_err_code  in out varchar2,
                               p_err_param in out varchar2) as
  begin
    plog.setbeginsection(pkgctx, 'pr_get_all_account');
    p_err_code := systemnums.c_success;
    p_err_param := '';
    open p_refcursor for
      select a.acctno    accountId,
             a.custid    customerId,
             c.custodycd custodyCode,
             c.username,
             a.isfo
        from afmast a, cfmast c
       where c.custid = a.custid
         and a.status <> 'C';
    plog.setendsection(pkgctx, 'pr_get_all_account');
  exception
    when others then
      p_err_code  := -1;
      p_err_param := cspks_system.fn_get_errmsg(p_err_code);
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_all_account');
  end;

PROCEDURE pr_get_all_account_broker (p_refcursor IN OUT pkg_report.ref_cursor,
                                       p_err_code  IN OUT VARCHAR2,
                                       p_err_param IN OUT VARCHAR2)
  AS
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_get_all_account_broker');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    OPEN p_refcursor
    FOR
      SELECT cf.custodycd, cf.custid, af.acctno, tlp.tlid, tlp.tlname
      FROM cfmast cf, afmast af, tlgrpusers tlg, tlprofiles tlp
      WHERE cf.custid = af.custid AND cf.careby = tlg.grpid 
      AND tlg.tlid = tlp.tlid
      AND af.status <> 'C' AND cf.status <> 'C' 
    ;
    plog.setEndSection(pkgctx, 'pr_get_all_account_broker');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code  := -1;
      p_err_param := cspks_system.fn_get_errmsg(p_err_code);
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_all_account_broker');
  END;
begin
  -- Initialization
  for i in (select * from tlogdebug) loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;
  pkgctx := plog.init ('fopks_sa', 
                      plevel => nvl(logrow.loglevel, 30),
                      plogtable => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace => (nvl(logrow.log4trace, 'N') = 'Y'));
end fopks_sa;
/
