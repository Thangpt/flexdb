--
--
/
create or replace package fopks_openapi IS

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
  **  duyanh.hoang     04/09/2019         Created
  ** (c) 2018 by Financial Software Solutions. JSC.
  ----------------------------------------------------------------------------------------------------*/
  
  -- Public type declarations
  type ref_cursor is ref cursor;
  FUNCTION TIMESTAMP_TO_UNIX (p_timeStamp  TIMESTAMP, in_src_tz in varchar2 default 'Asia/Bangkok') return NUMBER;
  /*
  /config - Get localized configuration pulling interval.
  */
  procedure pr_get_cfg_pulling_interval(p_refcursor in out ref_cursor,
                                        p_group_name in varchar2,
                                        p_err_code in out varchar2,
                                        p_err_param in out varchar2);
  /*
  /config - Get localized configuration durations.
  */
  procedure pr_get_cfg_duration(p_refcursor in out ref_cursor,
                                p_err_code in out varchar2,
                                p_err_param in out VARCHAR2);
  /*
  /config - Get localized configuration account manager table.
  */
  procedure pr_get_cfg_accmanagertable(p_refcursor in out ref_cursor,
                                       p_err_code in out varchar2,
                                       p_err_param in out varchar2);
  /*
  /config - Get localized configuration account manager table.
  */
  procedure pr_get_cfg_accmanagercolumn(p_refcursor in out ref_cursor,
                                        p_table_id in varchar2,
                                        p_err_code in out varchar2,
                                        p_err_param in out varchar2);
  PROCEDURE pr_get_amdata (p_refcursor IN OUT ref_cursor,
                        p_accountId  IN VARCHAR2,
                        p_err_code   IN OUT VARCHAR2,
                        p_err_param  IN OUT VARCHAR2);
  /*
  accounts - Get a list of accounts owned by the user.
  */
  procedure pr_get_accounts(p_refcursor in out ref_cursor,
                            p_customerid in varchar2,
                            p_err_code in out varchar2,
                            p_err_param in out varchar2);
  /*
  accounts - Get flags of account owned by the user.
  */
  procedure pr_get_account_flags(p_refcursor in out ref_cursor,
                                 p_customerid in varchar2,
                                 p_err_code in out varchar2,
                                 p_err_param in out varchar2);
                                 
	procedure pr_get_customer_info(p_refcursor    in out ref_cursor,
                                 p_customerid   in varchar2,
                           	     p_err_code     in out varchar2,
                                 p_err_param    in out varchar2);
  /*
  accounts/state - Get account information.
  */
  procedure pr_get_state(p_refcursor in out ref_cursor,
                         p_accountid in varchar2, p_err_code in out varchar2,
                         p_err_param in out varchar2);
  
  /*
  /accounts/{accountId}/executions - Executions by symbol
  */
  procedure pr_get_executions(p_refcursor in out ref_cursor,
                              p_accountid in varchar2,
                              p_instrument in varchar2, 
                              p_maxcount in number,
                              p_err_code in out varchar2,
                              p_err_param in out varchar2);
  /*
  /accounts/{accountId}/ordersHistory - Get a list of tradeable instruments that are available for trading with the account specified.
  */
  procedure pr_get_instruments(p_refcursor in out ref_cursor,
                               p_accountid in varchar2,
                               p_err_code in out varchar2,
                               p_err_param in out varchar2);
  /*
  check a corebank accounts.
  */
  procedure pr_check_corebank_accounts(p_refcursor in out ref_cursor,
                            p_accountid in varchar2,
                            p_err_code in out varchar2,
                            p_err_param in out varchar2);
                            
  /*
  check host active
  */
  FUNCTION fn_check_system_active RETURN NUMBER;
end fopks_openapi;
/
create or replace package body fopks_openapi is

  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;
  -----------------------------------------Utility----------------------------------------------------------
  FUNCTION TIMESTAMP_TO_UNIX (p_timeStamp  TIMESTAMP, in_src_tz in varchar2 default 'Asia/Bangkok') return number is
   l_unix_ts number;
  begin
    l_unix_ts := round((cast((FROM_TZ(p_timeStamp, in_src_tz) at time zone 'GMT') as date) - TO_DATE('01.01.1970','dd.mm.yyyy'))*(24*60*60));
    return l_unix_ts;
  end;
  ----------------------------------------------------------------------------------------------------------  
  /*
  /config - Get localized configuration pulling interval.
  */
  procedure pr_get_cfg_pulling_interval(p_refcursor in out ref_cursor,
                                        p_group_name in varchar2,
                                        p_err_code in out varchar2,
                                        p_err_param in out varchar2) as
  begin
    plog.setbeginsection(pkgctx, 'pr_get_cfg_pulling_interval');
    open p_refcursor for
      select varname, varvalue
        from configsystem
       where groupname = 'PULLINGINTERVAL';
    plog.setendsection(pkgctx, 'pr_get_cfg_pulling_interval');
  exception
    when others then
      p_err_code  := -1;
      p_err_param := cspks_system.fn_get_errmsg(p_err_code);
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_cfg_pulling_interval');
  end;
  
  /*
  /config - Get localized configuration durations.
  */
  procedure pr_get_cfg_duration(p_refcursor in out ref_cursor,
                                p_err_code in out varchar2,
                                p_err_param in out varchar2) as
  begin
    plog.setbeginsection(pkgctx, 'pr_get_cfg_duration');
    open p_refcursor for
      select id, title, hasdatepicker, hastimepicker from duration;
    p_err_code := '0';
    plog.setendsection(pkgctx, 'pr_get_cfg_duration');
  exception
    when others then
      p_err_code  := -1;
      p_err_param := cspks_system.fn_get_errmsg(p_err_code);
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_cfg_duration');
  end;
  
  /*
  /config - Get localized configuration account manager table.
  */
  procedure pr_get_cfg_accmanagertable(p_refcursor in out ref_cursor,
                                       p_err_code in out varchar2,
                                       p_err_param in out varchar2) as
  begin
    plog.setbeginsection(pkgctx, 'pr_get_cfg_accountmanagertable');
    open p_refcursor for
      select id, title, cmdtext from accountmanagertable;
    p_err_code := 0;
    plog.setendsection(pkgctx, 'pr_get_cfg_accountmanagertable');
  exception
    when others then
      p_err_code  := -1;
      p_err_param := cspks_system.fn_get_errmsg(p_err_code);
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_cfg_accountmanagertable');
  end;
  
  /*
  /config - Get localized configuration account manager table.
  */
  procedure pr_get_cfg_accmanagercolumn(p_refcursor in out ref_cursor,
                                        p_table_id in varchar2,
                                        p_err_code in out varchar2,
                                        p_err_param in out varchar2) as
  begin
    plog.setbeginsection(pkgctx, 'pr_get_cfg_accmanagercolumn');
    open p_refcursor for
      select id, title, tooltip, fixedwidth, sorttable
        from accountmanagercolumn
       where tableid = p_table_id;
    p_err_code := 0;
    plog.setendsection(pkgctx, 'pr_get_cfg_accmanagercolumn');
  exception
    when others then
      p_err_code  := -1;
      p_err_param := cspks_system.fn_get_errmsg(p_err_code);
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_cfg_accmanagercolumn');
  end;
  
  PROCEDURE pr_get_amdata (p_refcursor IN OUT ref_cursor,
                          p_accountId  IN VARCHAR2,
                          p_err_code   IN OUT VARCHAR2,
                          p_err_param  IN OUT VARCHAR2)
  IS
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_get_amdata');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    OPEN p_refcursor
    FOR
      SELECT pp            pp0
      FROM buf_ci_account
      WHERE afacctno = p_accountId
    ;
    plog.setEndSection(pkgctx, 'pr_get_amdata');
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'System Error';
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'pr_get_amdata');
  END;
  
  /*
  accounts - Get a list of accounts owned by the user.
  */
  procedure pr_get_accounts(p_refcursor    in out ref_cursor,
                            p_customerid   in varchar2,
                            p_err_code     in out varchar2,
                            p_err_param    in out varchar2) 
  AS
  l_currDate   DATE := getcurrdate;
  begin
    plog.setbeginsection(pkgctx, 'pr_get_accounts');
    p_err_code := '0';
    p_err_param := '';
    
    open p_refcursor for
      SELECT 1 owner, 
             acctno id,
             c.custodycd || '.' || aft.typename accountDesc,
             aft.typename typename,
             c.custodycd, 
             a.custid customerId, 
             fullname "name", 
             'VND' currency, 
             'đ' currencysign, 
             '' config,
             a.corebank
        from afmast a, cfmast c, aftype aft
       where a.custid = c.custid and aft.actype = a.actype
         and a.status <> 'C'
         and c.custid = p_customerid
      UNION ALL
      SELECT 0 OWNER, 
             AF.ACCTNO id,
             cf.custodycd || '.' || aft.typename accountDesc,
             aft.typename typename,
             CF.CUSTODYCD,
             CF.CUSTID   customerId,
             CF.FULLNAME "name",
             'VND'       currency,
             'đ' currencysign,
             '' config,
             af.corebank
      FROM OTRIGHT R, AFMAST AF, CFMAST CF, CIMAST CI, AFTYPE AFT
      WHERE AF.CUSTID = CF.CUSTID AND AF.ACCTNO = CI.AFACCTNO 
      AND AF.ACTYPE=AFT.ACTYPE
      AND R.CFCUSTID <> R.AUTHCUSTID AND R.CFCUSTID = CF.CUSTID
			AND R.VIA = 'A' AND R.DELTD = 'N'
      AND R.AUTHCUSTID = p_customerid
      AND l_currDate <= R.EXPDATE
      ORDER BY OWNER DESC
    ;

    plog.setendsection(pkgctx, 'pr_get_accounts');
  exception
    when others then
      p_err_code  := -1;
      p_err_param := cspks_system.fn_get_errmsg(p_err_code);
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_accounts');
  end;
  
  procedure pr_get_customer_info(p_refcursor    in out ref_cursor,
                                 p_customerid   in varchar2,
                           	     p_err_code     in out varchar2,
                                 p_err_param    in out varchar2)
  AS
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_get_customer_info');
    p_err_code := '0';
    p_err_param := '';

    OPEN p_refcursor FOR
       SELECT cf.custid customerid, cf.fullname custname, u.isreset isresetpass
       FROM cfmast cf, userlogin u
       WHERE cf.custid = p_customerid
         AND upper(u.username) = upper(cf.custodycd)
         AND u.status = 'A'
         AND cf.status = 'A';
       
    plog.setendsection(pkgctx, 'pr_get_customer_info');
  EXCEPTION WHEN OTHERS THEN
      p_err_code  := -1;
      p_err_param := cspks_system.fn_get_errmsg(p_err_code);
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_customer_info');
  END;
  
  /*
  accounts - Get flags of account owned by the user.
  */
  procedure pr_get_account_flags(p_refcursor in out ref_cursor,
                                 p_customerid in varchar2,
                                 p_err_code in out varchar2,
                                 p_err_param in out varchar2) as
  begin
    plog.setbeginsection(pkgctx, 'pr_get_account_flags');
    p_err_code := '0';
    p_err_param := '';
    
    open p_refcursor for
      select varname, varvalue
        from configsystem
       where groupname = 'ACCOUNTFLAG'
      AND EXISTS (SELECT 1 FROM cfmast WHERE custid = p_customerid);
    plog.setendsection(pkgctx, 'pr_get_account_flags');
  exception
    when others then
      p_err_code  := -1;
      p_err_param := cspks_system.fn_get_errmsg(p_err_code);
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_account_flags');
  end;
  
  /*
  accounts/state - Get account information.
  */
  procedure pr_get_state(p_refcursor in out ref_cursor,
                         p_accountid in varchar2, 
                         p_err_code in out varchar2,
                         p_err_param in out varchar2) is
    l_strCurrDate VARCHAR2(10);
    l_currDate    DATE;
  begin
    plog.setbeginsection(pkgctx, 'pr_get_state');
    p_err_code := '0';
    p_err_param := '';
    
    select VARVALUE INTO l_strCurrDate from sysvar where grname='SYSTEM' and varname='CURRDATE';
    l_currDate := TO_DATE(l_strCurrDate, 'dd/mm/rrrr');
    
    open p_refcursor for
      select c.balance,
             NVL(se.profitandloss, 0) unrealizedpl,
             NVL(se.MARKETAMT, 0) + c.balance - ci.totalodamt equity
        from cimast c,
             (
               SELECT ci.dfodamt + ci.t0odamt + ci.mrodamt
                      + ci.ovdcidepofee + ci.execbuyamt/* + ci.trfbuyamt*//* + ci.rcvadvamt*/    TOTALODAMT,
                      afacctno
               FROM buf_ci_account ci
               WHERE ci.afacctno = p_accountid) ci,
             (select se.afacctno, sum((basicprice - costprice) * (trade /*+ ca_sec*/ + receiving+secured)) profitandloss --lai/lo tam tinh
                     ,sum(basicprice * (trade + receiving + secured /*+ ca_sec*/))  MARKETAMT --GTTT
              from
              (
                 SELECT SDTL.AFACCTNO,
                        SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED TRADE,
                        nvl(sdtl_wft.wft_receiving,0) CA_sec,
                        nvl(od.REMAINQTTY,0) - nvl(B_remainqtty,0) secured,
                        SDTL.receiving + nvl(od.B_execqtty_new,0)/*SDTL.SECURITIES_RECEIVING_T3*/ receiving,
                        CASE WHEN nvl( stif.closeprice,0)>0 THEN stif.closeprice ELSE  SEC.BASICPRICE END BASICPRICE,
                        round((
                            round(nvl(sdtl1.costprice,sdtl.costprice)) -- gia_von_ban_dau ,
                            *(SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.RECEIVING  ) --tong_kl
                            + nvl(od.B_execamt,0) --gia_tri_mua --gia tri khop mua
                            )     /            (SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED
                            + SDTL.RECEIVING + nvl(od.B_EXECQTTY,0) + 0.000001 )
                            ) as COSTPRICE
                 FROM  SBSECURITIES SB, SECURITIES_INFO SEC, BUF_SE_ACCOUNT SDTL
                 LEFT JOIN
                    (
                        SELECT TO_NUMBER( closeprice) closeprice,symbol from stockinfor WHERE tradingdate = l_strCurrDate
                    ) stif ON SDTL.symbol = stif.symbol
                 left join
                    (
                        select seacctno,
                               sum(o.remainqtty) remainqtty, 
                               sum(decode(o.exectype, 'NB', o.remainqtty, 0)) B_remainqtty,
                               sum(decode(o.exectype, 'NB', o.execamt, 0)) B_execamt,
                               sum(decode(o.exectype, 'NB', o.execqtty, 0 )) B_execqtty, 
                               SUM(CASE WHEN o.stsstatus <> 'C' THEN (decode(o.exectype , 'NB', o.execqtty, 0)) ELSE 0 END)  B_execqtty_new
                        from odmast o
                        where deltd <> 'Y' and o.exectype IN ('NS','NB','MS')
                            and o.txdate = l_currDate
                            and o.afacctno = p_accountid
                        group by seacctno
                    ) OD on sdtl.acctno = od.seacctno
                 left join
                    (
                        select afacctno, refcodeid, trade + receiving - SECURITIES_RECEIVING_T1 - SECURITIES_RECEIVING_T2 wft_receiving
                        from buf_se_account sdtl, sbsecurities sb
                        where sdtl.codeid = sb.codeid and sb.refcodeid is not null and sdtl.afacctno like p_accountid
                    ) sdtl_wft on sdtl.codeid = sdtl_wft.refcodeid and sdtl.afacctno = sdtl_wft.afacctno
                 LEFT JOIN
                    (
                        SELECT sb.symbol, se.afacctno||sb.codeid acctno, se.afacctno||nvl(sb.refcodeid,sb.codeid) refacctno,
                               round((
                                      round(BUF.costprice) -- gia_von_ban_dau ,
                                      *(BUF.TRADE + BUF.DFTRADING + BUF.RESTRICTQTTY + BUF.ABSTANDING + BUF.BLOCKED + BUF.RECEIVING  + nvl(sdtl_wft.wft_receiving,0) - nvl(wft_3380,0) + BUF.secured ) --tong_kl
                                      + nvl(od.B_execamt,0) --gia_tri_mua --gia tri khop mua
                                      )            /
                                    (BUF.TRADE + BUF.DFTRADING + BUF.RESTRICTQTTY + BUF.ABSTANDING + BUF.BLOCKED + nvl(sdtl_wft.wft_receiving,0) - nvl(wft_3380,0) + BUF.secured
                                     + BUF.RECEIVING + nvl(od.B_EXECQTTY,0) + 0.000001 )
                                ) AS costprice
                        FROM semast se, sbsecurities sb, buf_se_account buf
                        left join
                        (
                           select seacctno, 
                                  sum(decode(o.exectype, 'NB', o.execamt, 0)) B_execamt,
                                  sum(decode(o.exectype, 'NB', o.execqtty, 0)) B_execqtty, 
                                  SUM(CASE WHEN o.stsstatus <> 'C' THEN (decode(o.exectype, 'NB', o.execqtty , 0)) ELSE 0 END)  B_execqtty_new
                           from odmast o
                           where deltd <>'Y' and o.exectype = 'NS'
                           and o.txdate = l_currDate
                           group by seacctno
                        ) OD on buf.acctno = od.seacctno
                        left join
                        (
                            select afacctno, refcodeid, trade + receiving  wft_receiving , nvl(se.namt,0) wft_3380
                            from  semast sdtl, sbsecurities sb, (select acctno , namt from setran where tltxcd = '3380' and txcd = '0052' and deltd <> 'Y') se
                            where sdtl.codeid = sb.codeid and sb.refcodeid is not null and sdtl.acctno = se.acctno(+)
                        ) sdtl_wft on buf.codeid = sdtl_wft.refcodeid and buf.afacctno = sdtl_wft.afacctno
                    WHERE sb.codeid = se.codeid AND sb.refcodeid IS NOT NULL
                    AND se.afacctno||nvl(sb.refcodeid,sb.codeid) = buf.acctno
                ) sdtl1 ON sdtl.acctno = sdtl1.acctno
                WHERE SB.CODEID = SDTL.CODEID --and sb.refcodeid is null
                  and sdtl.afacctno = p_accountid
                  AND SDTL.CODEID = SEC.CODEID
                  and SDTL.TRADE + SDTL.DFTRADING + SDTL.RESTRICTQTTY + SDTL.ABSTANDING + SDTL.BLOCKED + SDTL.receiving+SDTL.SECURITIES_RECEIVING_T0+SDTL.SECURITIES_RECEIVING_T1+SDTL.SECURITIES_RECEIVING_T2+SDTL.SECURITIES_RECEIVING_T3 + nvl(od.REMAINQTTY,0) >0
            ) se
        group by se.afacctno) se
       where c.acctno = ci.afacctno AND c.acctno = se.afacctno (+)
         and c.acctno = p_accountid;

    plog.setendsection(pkgctx, 'pr_get_state');
  exception
    when others THEN
      p_err_code := '-1';
      p_err_param := 'System Error';
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_state');
  end;
  
  /*
  /accounts/{accountId}/executions - Executions by symbol
  */
  procedure pr_get_executions(p_refcursor in out ref_cursor,
                              p_accountid in varchar2,
                              p_instrument in varchar2, 
                              p_maxcount in number,
                              p_err_code in out varchar2,
                              p_err_param in out varchar2) as
  begin
    plog.setbeginsection(pkgctx, 'pr_get_executions');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    
    open p_refcursor for
      select *
        from (select rownum id, s.symbol instrusment, i.matchprice price,
                      i.txtime "time", i.matchqtty qty,
                      decode(i.bors, 'B', 'buy', 'sell') side
                 from iod i, odmast o, afmast a, sbsecurities s
                where i.orgorderid = o.orderid
                  and o.afacctno = a.acctno
                  and o.codeid = s.codeid
                  and a.acctno = p_accountid
                  AND s.symbol = p_instrument
                order by to_date(i.txtime, 'hh24:mi:ss'))
       where id <= p_maxcount;

    plog.setendsection(pkgctx, 'pr_get_executions');
  exception
    when others THEN
      p_err_code := '-1';
      p_err_param := 'System Error';
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'pr_get_executions');
  end;
  
  /*
  /accounts/{accountId}/ordersHistory - Get Order History
  */
  procedure pr_get_ordershistory(p_refcursor in out ref_cursor,
                                 p_accountid in varchar2,
                                 p_maxcount in varchar2,
                                 p_err_code in out varchar2,
                                 p_err_param in out varchar2) as
  begin
    plog.setbeginsection(pkgctx, 'pr_get_ordershistory');
    p_err_code := 0;
    p_err_param := '';
    open p_refcursor for
      select id, instrument, qty,
             (case
               when side = 'NB' then
                'buy'
               else
                'sell'
             end) side, "type", filledqty, avgprice, limitprice, stopprice,
             parentid, parenttype, duration, status, lastModified
        from (select rownum, orderid id, symbol instrument, orderqtty qty,
                      exectype side,
                      (case
                        when pricetype = 'LO' then
                         'limit'
                        else
                         'market'
                      end) "type", round(execqtty, 15) filledqty,
                      round(case
                              when execqtty > 0 then
                               execamt / execqtty
                              else
                               0
                            end, 15) avgprice,
                      round(quoteprice * 1000, 15) limitprice, 0 stopprice,
                      nvl(c.reforderid, '') parentid, 'order' parenttype, '' duration,
                      (CASE
                         when orstatusvalue = '8' then
                          'placing'
                         when orstatusvalue IN ('A', 'C', '2') then
                          'working'
                         when orstatusvalue = '12' OR orstatusvalue = '4' OR execQtty > 0 then
                          'filled'
                         when orstatusvalue = '3' then
                          'cancelled'
                         when orstatusvalue IN ('0', '6', 'R', '5') then
                          'rejected'
                       end) status,
                      TIMESTAMP_TO_UNIX(c.odtimestamp)   lastModified
                 from buf_od_account c
                where c.afacctno = p_accountid
                  and c.timetypevalue IN ('G', 'T')
                  and c.orstatusvalue in ('0', '12', '3', '6', '4', 'R', '5', '10')
                order by odtimestamp desc)
       where rownum <= p_maxcount;

    plog.setendsection(pkgctx, 'pr_get_ordershistory');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_ordershistory');
  end;

  /*
  /accounts/{accountId}/ordersHistory - Get a list of tradeable instruments that are available for trading with the account specified.
  */
  procedure pr_get_instruments(p_refcursor in out ref_cursor,
                               p_accountid in varchar2,
                               p_err_code in out varchar2,
                               p_err_param in out varchar2) is
    l_actype    aftype.actype%TYPE;
  begin
    plog.setbeginsection(pkgctx, 'pr_get_instruments');
    p_err_code := systemnums.C_SUCCESS;
    p_err_param := '';
    SELECT actype INTO l_actype FROM afmast WHERE acctno = p_accountid;

    open p_refcursor for
      select s.symbol "name", i.fullname description, 0 minqty, 0 maxqty,
             0 qtystep, 0 pipsize, 0 pipvalue, t.ticksize mintick,
             s.tradelot lotsize, '' basecurrency, '' quotecurrency,
             case sb.sectype
                when '001' then
                 'stock'
                when '005' then
                 'futures'
                when '006' THEN
                  'bond'
                WHEN '012' THEN
                 'bond'
                WHEN '011' THEN
                  'warrant'
                WHEN '008' THEN
                  'fund'
              end "type",
              nvl(afs.mrratiorate, 0) marginRate
        from securities_info s, sbsecurities sb, issuers i,
             (select symbol, codeid, min(ticksize) ticksize
                 from securities_ticksize
                group by symbol, codeid) t,
             afserisk afs
       where sb.status = 'Y'
         and sb.sectype in ('001', '005', '006', '011', '012' , '008')
         and s.codeid = sb.codeid
         and s.codeid = t.codeid
         and sb.issuerid = i.issuerid
         AND instr(sb.symbol, '_WFT') = 0
         AND afs.codeid (+) = sb.codeid AND afs.actype (+) = l_actype;

    plog.setendsection(pkgctx, 'pr_get_instruments');
  exception
    when others THEN
      p_err_code := '-1';
      p_err_param := 'Account Not Found';
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_instruments');
  end;
  
  /*
  check a corebank accounts.
  */
  procedure pr_check_corebank_accounts(p_refcursor in out ref_cursor,
                            p_accountid in varchar2,
                            p_err_code in out varchar2,
                            p_err_param in out varchar2) as
  begin
    plog.setbeginsection(pkgctx, 'pr_check_corebank_accounts');
    open p_refcursor for
      select a.bankname, a.bankacctno, a.corebank
        from afmast a
       where a.acctno = p_accountid;

    plog.setendsection(pkgctx, 'pr_check_corebank_accounts');
  exception
    when others then
      p_err_code  := -1;
      p_err_param := cspks_system.fn_get_errmsg(p_err_code);
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_check_corebank_accounts');
  end;
  
  /*
  check host active
  */
  FUNCTION fn_check_system_active RETURN NUMBER
  IS
     v_hostatus  VARCHAR(1);
  BEGIN
     plog.setbeginsection(pkgctx, 'fn_check_system_active');
     
     SELECT VARVALUE
     INTO v_HOSTATUS
     FROM SYSVAR
     WHERE GRNAME = 'SYSTEM' AND VARNAME = 'HOSTATUS';

     IF v_hostatus = '0' THEN
        RETURN 0;
     END IF;
     
     RETURN 1;
     plog.setbeginsection(pkgctx, 'fn_check_system_active');
  EXCEPTION WHEN OTHERS THEN
     plog.error(pkgctx, sqlerrm);
     plog.setendsection(pkgctx, 'fn_check_system_active');
     RETURN 0;
  END;
begin
  -- Initialization
  for i in (select * from tlogdebug) loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;
  pkgctx := plog.init ('fopks_openapi', 
                      plevel => nvl(logrow.loglevel, 30),
                      plogtable => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace => (nvl(logrow.log4trace, 'N') = 'Y'));
end fopks_openapi;
/
