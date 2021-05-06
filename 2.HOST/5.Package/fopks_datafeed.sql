create or replace package fopks_datafeed is

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
  
  -- Public type declarations
  type ref_cursor is ref cursor;
  
  /*
  quotes - Get current prices of the instrument
  */
  procedure pr_get_quotes(p_refcursor in out ref_cursor,
                          p_err_code  in out varchar2,
                          p_err_param in out varchar2);
  procedure pr_get_quotes_by_symbol (p_refcursor in out ref_cursor,
                        p_symbol    IN VARCHAR2,
                        p_err_code  in out varchar2,
                        p_err_param in out varchar2);
  /*
  depth - Get current depth of market for the instrument.
  */
  procedure pr_get_depths(p_refcursor in out ref_cursor,
                          p_symbol    in varchar2,
                          p_err_code  in out varchar2,
                          p_err_param in out varchar2);
  /*
  /mapping - Get mapping.
  */
  procedure pr_get_mapping(p_refcursor in out ref_cursor,
                           p_err_code  in out varchar2,
                           p_err_param in out varchar2);
  
end fopks_datafeed;
/
create or replace package body fopks_datafeed is

  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;
  
  /*
  quotes - Get current prices of the instrument
  */
  procedure pr_get_quotes(p_refcursor in out ref_cursor,
                          p_err_code  in out varchar2,
                          p_err_param in out varchar2) as
  begin
    plog.setbeginsection(pkgctx, 'pr_get_quotes');
    p_err_code  := 0;
    p_err_param := '';
    
    open p_refcursor for
      select se.symbol, se.basicprice prev_close_price,
             se.ceilingprice ceiling_price, se.floorprice floor_price, sb.sectype sectype
        from sbsecurities sb, securities_info se
       where sb.codeid = se.codeid
         and sb.sectype in ('001', '008', '012', '011')
         and sb.tradeplace in ('001', '002', '005')
         and sb.refcodeid is NULL
         AND CASE WHEN sb.sectype = '011' AND getcurrdate> sb.lasttradingdate THEN 0 ELSE 1 END > 0 --1.8.2.1: chem ma CW dao han
         AND sb.HALT ='N'
       order by se.symbol;
  
    plog.setendsection(pkgctx, 'pr_get_quotes');
  exception
    when others then
      p_err_code := -1;
      p_err_param := 'System Error';
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_quotes');
  end;
  
  procedure pr_get_quotes_by_symbol (p_refcursor in out ref_cursor,
                          p_symbol    IN VARCHAR2,
                          p_err_code  in out varchar2,
                          p_err_param in out varchar2) as
  begin
    plog.setbeginsection(pkgctx, 'pr_get_quotes_by_symbol');
    p_err_code  := 0;
    p_err_param := '';
    
    open p_refcursor for
      select se.symbol, se.basicprice prev_close_price,
             se.ceilingprice ceiling_price, se.floorprice floor_price
        from sbsecurities sb, securities_info se
       where sb.codeid = se.codeid
         and sb.sectype in ('001', '008', '012', '011')
         and sb.tradeplace in ('001', '002', '005')
         and sb.refcodeid is NULL
         AND sb.symbol = p_symbol
       order by se.symbol;
  
    plog.setendsection(pkgctx, 'pr_get_quotes_by_symbol');
  exception
    when others then
      p_err_code := -1;
      p_err_param := 'System Error';
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_quotes_by_symbol');
  end;

  /*
  depth - Get current depth of market for the instrument. 
  */
  procedure pr_get_depths(p_refcursor in out ref_cursor,
                          p_symbol    in varchar2,
                          p_err_code  in out varchar2,
                          p_err_param in out varchar2) as
    l_current_date varchar2(10);
  begin
    plog.setbeginsection(pkgctx, 'pr_get_depths');
    p_err_code  := 0;
    p_err_param := '';
  
    SELECT VARVALUE INTO l_current_date FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE';
  
    open p_refcursor for
      select s.bidprice1 price, s.bidvol1 vol, 'bids' side
        from stockinfor s
       where s.symbol = p_symbol
         and s.tradingdate = l_current_date
      union all
      select s.bidprice2 price, s.bidvol2 vol, 'bids' side
        from stockinfor s
       where s.symbol = p_symbol
         and s.tradingdate = l_current_date
      union all
      select s.bidprice3 price, s.bidvol3 vol, 'bids' side
        from stockinfor s
       where s.symbol = p_symbol
         and s.tradingdate = l_current_date
      union all
      select s.offerprice1 price, s.offervol1 vol, 'asks' side
        from stockinfor s
       where s.symbol = p_symbol
         and s.tradingdate = l_current_date
      union all
      select s.bidprice2 price, s.bidvol2 vol, 'asks' side
        from stockinfor s
       where s.symbol = p_symbol
         and s.tradingdate = l_current_date
      union all
      select s.bidprice3 price, s.bidvol3 vol, 'asks' side
        from stockinfor s
       where s.symbol = p_symbol
         and s.tradingdate = l_current_date;
  
    plog.setendsection(pkgctx, 'pr_get_depths');
  exception
    when others then
      p_err_code := '-1';
      p_err_param := 'System Error';
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_get_depths');
  end;
  
  /*
  /mapping - Get mapping.
  */
  procedure pr_get_mapping(p_refcursor in out ref_cursor,
                           p_err_code  in out varchar2,
                           p_err_param in out varchar2) as
  begin
    plog.setbeginsection(pkgctx, 'pr_get_mapping');
  
    p_err_code  := 0;
    p_err_param := '';
    open p_refcursor for
      select sb.symbol, al.cdcontent listedExchange
        from sbsecurities sb, allcode al
       where sb.tradeplace = al.cdval
         and al.cdtype = 'OD'
         and al.cdname = 'TRADEPLACE'
         and sb.sectype in ('001', '008', '012', '011')
         and sb.tradeplace in ('001', '002', '005')
         and sb.refcodeid is null
       order by sb.symbol;
  
    plog.setendsection(pkgctx, 'pr_get_mapping');
  exception
    when others then
      p_err_code := -1;
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'pr_get_mapping');
  end;
  
begin
  -- Initialization
  for i in (select * from tlogdebug) loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;
  pkgctx := plog.init ('fopks_datafeed', 
                      plevel => nvl(logrow.loglevel, 30),
                      plogtable => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace => (nvl(logrow.log4trace, 'N') = 'Y'));
end fopks_datafeed;
/
