create or replace package nmpks_ems is

  -- Author  : THONGPM
  -- Created : 29/02/2012 4:55:43 PM
  -- Purpose : Lay thong tin cho email, sms template

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  procedure GenNotifyEvent(p_message_type varchar2, p_key_value varchar2);
  procedure GenTemplates(p_message_type varchar2, p_key_value varchar2);
  procedure GenTemplate0210(p_template_id varchar2);
  procedure GenTemplate0211(p_template_id varchar2);
  procedure GenTemplate0215(p_template_id varchar2);
  procedure GenTemplate0216(p_ca_id varchar2);
  procedure GenTemplate0217(p_ca_id varchar2);
  procedure GenTemplate0323(p_account varchar2);
  procedure GenTemplate0326(p_template_id varchar2);
  procedure GenTemplateTransaction(p_transaction_number varchar2);
  procedure GenTemplateTransaction1816(p_transaction_number varchar2);
  procedure GenTemplateScheduler(p_template_id varchar2);
  function CheckEmail(p_email varchar2) return boolean;
  procedure InsertEmailLog(p_email       varchar2,
                           p_template_id varchar2,
                           p_data_source varchar2,
                           p_account     varchar2);
  procedure InsertEmailLogWithCc(p_email       varchar2,
                                 p_email_cc    varchar2,
                                 p_template_id varchar2,
                                 p_data_source varchar2,
                                 p_account     varchar2);
  function fn_convert_to_vn(strinput in nvarchar2) return nvarchar2;
  function fn_GetNextRunDate(p_last_start_date in date, cycle in char)
    return date;
  PROCEDURE GenTemplate0329(p_template_id varchar2);
  procedure GenTemplate0333(p_ca_id varchar2);
  function fn_NumberFormat(p_number number) return varchar2;
  procedure GenTemplateSENDMG(p_ca_id varchar2);
  procedure GenTemplateEmailLimit(
  pv_autoid      VARCHAR2
);

end NMPKS_EMS;
/
CREATE OR REPLACE PACKAGE BODY nmpks_ems is

  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;

  -- Function and procedure implementations
  /*
  function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
    <LocalVariable> <Datatype>;
  begin
    <Statement>;
    return(<Result>);
  end;
  */

  procedure GenNotifyEvent(p_message_type varchar2, p_key_value varchar2) is
  begin
    plog.setBeginSection(pkgctx, 'GenNotifyEvent');

    insert into log_notify_event
      (AUTOID,
       MSGTYPE,
       KEYVALUE,
       STATUS,
       LOGTIME,
       APPLYTIME,
       COMMANDTYPE,
       COMMANDTEXT)
    values
      (seq_log_notify_event.nextval,
       p_message_type,
       p_key_value,
       'A',
       sysdate,
       null,
       'P',
       'GENERATE_TEMPLATES');

    plog.setEndSection(pkgctx, 'GenNotifyEvent');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenNotifyEvent');
  end;

  procedure GenTemplates(p_message_type varchar2, p_key_value varchar2) is
  begin
    plog.setBeginSection(pkgctx, 'GenTemplates');
    plog.debug(pkgctx,
               '[message_type]: ' || p_message_type || ' - [key_value]: ' ||
               p_key_value);
    if p_message_type = 'CAMAST_V' or p_message_type = 'CAMAST_S' then
      -- Mau thu thong bao thuc hien quyen
      GenTemplate0216(p_key_value);
    elsif p_message_type = 'CAMAST_A' then
      -- Mau thu thong bao thuc hien quyen mua phat hanh them
      --GenTemplate0217(p_key_value);
      GenTemplate0333(p_key_value);
    elsif p_message_type = 'ODMATCHED' then
      -- SMS thong bao ket qua khop lenh
      GenTemplate0323(p_key_value);
    elsif p_message_type = 'TRANSACT' then
      GenTemplateTransaction(p_key_value);
    elsif p_message_type = 'TRAN1816' then
      GenTemplateTransaction1816(p_key_value);
    elsif p_message_type = 'SCHD0326' then
      GenTemplate0326(p_key_value);
    elsif p_message_type = 'SCHD0210' then
      GenTemplate0210(p_key_value);
    elsif p_message_type = 'SCHD0211' then
      GenTemplate0211(p_key_value);
    elsif p_message_type = 'SCHD0215' then
      GenTemplate0215(p_key_value);
    elsif substr(p_message_type, 1, 4) = 'SCHD' then
      GenTemplateScheduler(p_key_value);
    elsif p_message_type = 'REAFLNK' then
      emaillog_reaflink(p_key_value, getcurrdate);
      -- begin binhvt
    elsif (p_message_type = 'SENDMG') then
      GenTemplateSENDMG(p_key_value);
      -- end binhvt
    end if;

    plog.setEndSection(pkgctx, 'GenTemplates');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplates');
  end;

  procedure GenTemplate0210(p_template_id varchar2) is
    v_Curdate       varchar2(20);
    v_CurYear       varchar2(20);
    v_Nextdate      varchar2(20);
    l_data_source   varchar2(5000);
    l_datasourcesms varchar2(5000);
  begin
    Select varvalue into v_Curdate from sysvar where varname = 'CURRDATE';
    Select varvalue into v_Nextdate from sysvar where varname = 'NEXTDATE';
    Select '/' || substr(trim(varvalue), 7, 4)
      into v_CurYear
      from sysvar
     where varname = 'NEXTDATE';

    plog.setBeginSection(pkgctx, 'GenTemplate0210');
    for c_scheduler IN (select cf.custodycd,
                               cf.fullname,
                               af.acctno,
                               f.typename,
                               af.fax1 mobile,
                               af.email,
                               TO_CHAR(ls.overduedate,'dd/mm/rrrr') overduedate,  --thuyct edit dinh dang date
                               ls.rlsdate,
                               ls.nml,
                               ls.intnmlacr,
                               lnt.warningdays2,
                               lnt.warningdays
                          from lnschd ls,
                               lnmast lm,
                               afmast af,
                               lntype lnt,
                               cfmast cf,aftype f -- thuyct edit 29_12_2020
                         where ls.reftype = 'P'
                           and ls.acctno = lm.acctno
                           and lm.actype = lnt.actype
                           and lm.trfacctno = af.acctno
                           and af.custid = cf.custid
                           and af.actype=f.actype
                           and ((getprevdate(ls.overduedate, lnt.warningdays) =
                               getcurrdate and lnt.warningdays <> 0) or
                               (getprevdate(ls.overduedate,
                                             lnt.warningdays2) =
                               getcurrdate and lnt.warningdays2 <> 0))) loop

      l_data_source := 'select ''' || c_scheduler.custodycd ||
                       ''' custodycd,''' || c_scheduler.fullname ||
                       ''' fullname, ''' || c_scheduler.acctno ||
                       ''' acctno,''' || c_scheduler.typename ||
                       ''' typename, ''' || to_char(c_scheduler.nml,          -- thuyct edit 29_12_2020
                                                 '9,999,999,999,999') || ''' nml, ''' ||
                       to_char(c_scheduler.intnmlacr,
                                                 '9,999,999,999,999') || ''' intnmlacr, ''' ||
                       c_scheduler.rlsdate || ''' rlsdate, ''' ||
                       c_scheduler.overduedate || ''' overduedate, ''' ||
                       sysdate || ''' txdate  from dual;';

      InsertEmailLog(c_scheduler.email,
                     p_template_id,
                     l_data_source,
                     c_scheduler.acctno);

      If length(c_scheduler.mobile) > 1 then
        --l_datasourcesms:='select ''TK '||c_scheduler.custodycd ||' tieu khoan '||c_scheduler.acctno||' cua Quy khach co khoan vay den han ngay '||c_scheduler.overduedate||'. Vui long kiem tra Email hoac goi (844)3776 5929/(848)3521 4299'' detail from dual';
        l_datasourcesms := 'SELECT ''KBSV thong bao: TK ' ||
                           c_scheduler.custodycd ||
                           c_scheduler.typename ||      -- thuyct edit 29_12_2020
                           ' co khoan vay den han. Ngay den han ' ||
                           c_scheduler.overduedate ||
                           '. So tien vay den han: ' ||
                           ltrim(replace(to_char(c_scheduler.nml +
                                                 c_scheduler.intnmlacr,
                                                 '9,999,999,999,999'),
                                         ',',
                                         '.')) ||'VND' || ''' DETAIL FROM DUAL';
        nmpks_ems.InsertEmailLog(c_scheduler.mobile,
                                 '0332',
                                 l_datasourcesms,
                                 '');
      End if;

    end loop;

    insert into templates_scheduler_log
      (template_id, log_date)
    values
      (p_template_id, getcurrdate);

    update templates_scheduler
       set last_start_date = getcurrdate,
           next_run_date   = fn_GetNextRunDate(getcurrdate, repeat_interval)
     where template_id = p_template_id;

    plog.setEndSection(pkgctx, 'GenTemplate0215');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate0215');
  end;

  procedure GenTemplate0211(p_template_id varchar2) is
    v_Curdate       varchar2(20);
    v_CurYear       varchar2(20);
    v_PREVDATE      varchar2(20);
    l_data_source   varchar2(5000);
    l_datasourcesms varchar2(5000);
  l_custodycd  cfmast.custodycd%type;    --thuy edit 30082019
    l_fullname   cfmast.fullname%type;
    l_email      afmast.email%type;
  l_sex      varchar2(100);
  begin
    Select varvalue into v_Curdate from sysvar where varname = 'CURRDATE';
    Select varvalue into v_PREVDATE from sysvar where varname = 'PREVDATE';
    Select '/' || substr(trim(varvalue), 7, 4)
      into v_CurYear
      from sysvar
     where varname = 'CURRDATE';

    plog.setBeginSection(pkgctx, 'GenTemplate0211');
    for c_scheduler IN (select cf.custodycd,
                               max(cf.fullname) fullname,
                               max(t.code) code,
                               max(mst.acctno) afacctno,
                               max(mst.email) address,
                               max(mst.fax1) mobile
                          from templates t,
                               --aftemplates a,
                               afmast mst,
                               cfmast cf
                         where
                        --a.template_code = t.code
                        -- and a.afacctno = mst.acctno
                         mst.custid = cf.custid
                     and mst.status in ('A', 'P')
                     and mst.email is not null
                     and to_date(decode(TO_CHAR(cf.dateofbirth, 'DD/MM'),
                                        '29/02',
                                        '28/02',
                                        TO_CHAR(cf.dateofbirth, 'DD/MM')) ||
                                 v_CurYear,
                                 'DD/MM/YYYY') >
                         to_date(v_PREVDATE, 'DD/MM/YYYY')
                     and to_date(decode(TO_CHAR(cf.dateofbirth, 'DD/MM'),
                                        '29/02',
                                        '28/02',
                                        TO_CHAR(cf.dateofbirth, 'DD/MM')) ||
                                 v_CurYear,
                                 'DD/MM/YYYY') <=
                         to_date(v_Curdate, 'DD/MM/YYYY')
                     and t.code = p_template_id
                         group by custodycd)


     Loop
     -- Thong tin khach hang  --thuy edit 30082019
        select c.custodycd,
               c.email,
               c.fullname,
               decode(c.sex, '001', 'Ông/Sir', '002', 'Bà/Madam', '')
          into l_custodycd, l_email, l_fullname, l_sex
          from cfmast c--, afmast a
         where c.custodycd = c_scheduler.custodycd  ; --thuyct edit 15_12_2020

      l_data_source := 'select ''' || l_custodycd ||
                       ''' custodycd,''' || l_fullname ||
                       ''' fullname,''' || l_sex ||
                       ''' sex,''' || sysdate ||
                       ''' txdate  from dual;';        --thuy edit 30082019

      If length(c_scheduler.mobile) > 1 then
        l_datasourcesms := 'select ''Ban giam doc cung toan the nhan vien Cong ty Co phan Chung khoan KB Viet Nam (KBSV) kinh chuc Quy khach mot sinh nhat tran ngap NIEM VUI, HANH PHUC, THANH CONG'' detail from dual';
        InsertEmailLog(c_scheduler.mobile,
                       '0331',
                       l_datasourcesms,
                       c_scheduler.afacctno);
      End if;

      InsertEmailLog(c_scheduler.address,
                     p_template_id,
                     l_data_source,
                     c_scheduler.afacctno);

    end loop;

    insert into templates_scheduler_log
      (template_id, log_date)
    values
      (p_template_id, getcurrdate);

    update templates_scheduler
       set last_start_date = getcurrdate,
           next_run_date   = fn_GetNextRunDate(getcurrdate, repeat_interval)
     where template_id = p_template_id;

    plog.setEndSection(pkgctx, 'GenTemplate0215');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate0215');
  end;


  procedure GenTemplate0215(p_template_id varchar2) is

    l_next_run_date date;
    l_data_source   varchar2(4000);
    l_template_id   templates.code%type;
    l_afacctno      afmast.acctno%type;
    l_address       varchar2(100);
    l_fullname      cfmast.fullname%type;
    l_custody_code  cfmast.custodycd%type;
    l_sex           varchar2(100);
    l_aftype        aftype.typename%type;    --Thuy edit 30082019
    type scheduler_cursor is ref cursor;

    type scheduler_record is record(
      template_id templates.code%type,
      afacctno    afmast.acctno%type,
      address     varchar2(100));

    c_scheduler   scheduler_cursor;
    scheduler_row scheduler_record;

    type ty_scheduler is table of scheduler_record index by binary_integer;

    scheduler_list         ty_scheduler;
    l_scheduler_cache_size number(23) := 1000;
    l_row                  pls_integer;
  begin
    plog.setBeginSection(pkgctx, 'GenTemplate0215');

    open c_scheduler for
      select t.code,
             a.afacctno,
             decode(t.type, 'E', mst.email, 'S', mst.fax1) address
        from templates t,
             aftemplates a,
             afmast mst,
             (select afacctno
                from odmast
               where txdate =
                     to_date(cspks_system.fn_get_sysvar('SYSTEM', 'PREVDATE'),
                             'DD/MM/RRRR')
                 and deltd <> 'Y'
                 and execqtty > 0
               group by afacctno) od
       where a.template_code = t.code
         and a.afacctno = mst.acctno
         and mst.acctno = od.afacctno
         and decode(t.type, 'E', mst.email, 'S', mst.fax1) is not null
         and t.code = p_template_id;

    loop
      fetch c_scheduler bulk collect
        into scheduler_list limit l_scheduler_cache_size;

      plog.DEBUG(pkgctx, 'CNT: ' || scheduler_list.COUNT);

      exit when scheduler_list.COUNT = 0;
      l_row := scheduler_list.FIRST;

      while (l_row is not null)

       loop
        scheduler_row := scheduler_list(l_row);
        l_template_id := scheduler_row.template_id;
        l_afacctno    := scheduler_row.afacctno;
        l_address     := scheduler_row.address;

        begin
          select a.custodycd,
                 a.fullname,
                 decode(a.sex, '001', 'Ông/Sir', '002', 'Bà/Madam', ''),         --thuy edit 30082019
         c.typename
            into l_custody_code, l_fullname, l_sex,l_aftype
            from cfmast a, afmast b, aftype c
           where a.custid = b.custid
      and b.actype=c.actype
             and b.acctno = l_afacctno;
        exception
          when NO_DATA_FOUND then
            plog.error(pkgctx,
                       'Sub account ' || l_afacctno || ' not found');
            l_custody_code := 'No Data Found';
            l_fullname     := 'No Data Found';
        end;

        l_data_source := 'select ''' || l_custody_code ||
                         ''' custodycode, ''' || l_fullname ||
                         ''' fullname, ''' || l_afacctno ||
                         ''' account, ''' || l_aftype || ''' typename,
                          ''' || l_sex || ''' sex, ''' ||
                         fn_get_sysvar_for_report('SYSTEM', 'PREVDATE') ||
                         ''' daily from dual;';

        InsertEmailLog(l_address, l_template_id, l_data_source, l_afacctno);

        l_row := scheduler_list.NEXT(l_row);
      end loop;
    end loop;

    insert into templates_scheduler_log
      (template_id, log_date)
    values
      (p_template_id, getcurrdate);

    update templates_scheduler
       set last_start_date = getcurrdate,
           next_run_date   = fn_GetNextRunDate(getcurrdate, repeat_interval)
     where template_id = p_template_id;

    plog.setEndSection(pkgctx, 'GenTemplate0215');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate0215');
  end;

  -- Mau thu thong bao thuc hien quyen
  procedure GenTemplate0216(p_ca_id varchar2) is
    l_custodycd  cfmast.custodycd%type;
    l_fullname   cfmast.fullname%type;
    l_email      afmast.email%type;
    l_templateid varchar2(6);
    l_datasource varchar2(2000);
    l_symbol     sbsecurities.symbol%type;
    l_tocodeid   camast.tocodeid%type;
    l_to_symbol  sbsecurities.symbol%type;

    l_catype camast.catype%type;

    l_report_date     varchar2(10);
    l_trade_date      varchar2(10);
    l_begin_date      varchar2(10);
    l_due_date        varchar2(10);
    l_frdate_transfer varchar2(10);
    l_todate_transfer varchar2(10);

    l_rate            varchar2(10);
    l_devident_shares varchar2(10);
    l_devident_value  varchar2(10);
    l_exrate          varchar2(10);
    --T11/2017 CW_PhaseII
    l_gia             varchar2(10);
    l_smsrate         varchar2(15);
    --End CW_PhaseII
    l_right_off_rate varchar2(10);
    l_devident_rate  varchar2(10);
    l_interest_rate  varchar2(10);
    l_trade_place    varchar2(10);
    l_to_floor_code  varchar2(10);
    l_fr_floor_code  varchar2(10);
    l_fr_trade_place varchar2(10);
    l_to_trade_place varchar2(10);
    l_issuer         varchar2(250);
    l_inaction_date  varchar2(10);
    l_typerate       char(1);
    l_exprice        camast.exprice%type;
    l_advdesc        camast.advdesc%type;
    l_purpose_desc   camast.purposedesc%type;
    l_sex            varchar2(10);
  l_aftype        aftype.typename%type;    --Thuy edit 30082019

    --l_to_codeid       varchar2(10);
    --l_to_symbol       varchar2(10);
    --l_catype_desc     varchar2(100);
    --l_floor_code      varchar2(10);

    type caschd_cursor is ref cursor;

    c_caschd  caschd_cursor;
    caschdrow caschd%rowtype;

    type ty_caschd is table of caschd%rowtype index by binary_integer;

    caschd_list         ty_caschd;
    l_caschd_cache_size number(23) := 1000000;
    l_row               pls_integer;
  begin
    plog.setBeginSection(pkgctx, 'GenTemplate0216');
    l_templateid := '0216';

    select s.symbol,
           s.tradeplace,
           nvl(i.fullname, i.shortname) issuer,
           ca.catype,
           ca.devidentrate,
           ca.devidentshares,
           ca.rightoffrate,
           to_char(ca.reportdate, 'DD/MM/YYYY') reportdate,
           to_char(nvl(ca.actiondate, ca.actiondate), 'DD/MM/YYYY') actiondate,
           ca.advdesc,
           a.cdcontent,
           ca.purposedesc,
           ca.interestrate,
           ca.typerate,
           ca.exrate,
           ca.exprice,
           ca.tocodeid,
           ca.totradeplace,
           to_char(ca.begindate, 'DD/MM/YYYY') begindate,
           to_char(ca.duedate, 'DD/MM/YYYY') duedate,
           to_char(ca.frdatetransfer, 'DD/MM/YYYY') frdatetransfer,
           to_char(ca.todatetransfer, 'DD/MM/YYYY') todatetransfer,
           ca.devidentvalue,
           ca.frtradeplace
      into l_symbol,
           l_trade_place,
           l_issuer,
           l_catype,
           l_devident_rate,
           l_devident_shares,
           l_right_off_rate,
           l_report_date,
           l_inaction_date,
           l_advdesc,
           l_trade_date,
           l_purpose_desc,
           l_interest_rate,
           l_typerate,
           l_exrate,
           l_exprice,
           l_tocodeid,
           l_to_floor_code,
           l_begin_date,
           l_due_date,
           l_frdate_transfer,
           l_todate_transfer,
           l_devident_value,
           l_fr_floor_code
      from camast ca, sbsecurities s, issuers i, allcode a
     where ca.codeid = s.codeid
       and s.issuerid = i.issuerid
       and a.cdval = s.tradeplace
       and a.cdtype = 'SE'
       and a.cdname = 'TRADEPLACE'
       and ca.camastid = p_ca_id;

    -- CATYPE : 011, 014
    /*
    001 ?u gi    002 T?m ng?ng giao d?ch
    003 H?y ni?y?t
    004 Mua l?i
    005 Tham d? d?i h?i c? d?    006 L?y ? ki?n c? d?    007 B?c? phi?u qu?
    008 C?p nh?t t.tin
    009 Tr? c? t?c b?ng c? phi?u kh?    010 Chia c? t?c b?ng ti?n
    011 Chia c? t?c b?ng c? phi?u
    012 T? c? phi?u
    013 G?p c? phi?u
    014 Quy?n mua
    015 Tr? l?tr?phi?u
    016 Tr? g?c v??tr?phi?u
    017 Chuy?n d?i tr?phi?u th? c? phi?u
    018 Chuy?n quy?n th? c? phi?u
    019 Chuy?n s?    020 Chuy?n d?i c? phi?u th? c? phi?u
    021 C? phi?u thu?ng
    022 Quy?n b? phi?u
    026 Chuy?n c? phi?u ch? giao d?ch th? giao d?ch
    */

    if l_catype = '005' then
      l_rate       := l_devident_shares;
      l_templateid := '216A';
    elsif l_catype = '006' then
      l_rate       := l_devident_shares;
      l_templateid := '216A';
    elsif l_catype = '010' then
      if l_typerate = 'R' then
        l_rate := l_devident_rate || '%';
      elsif l_typerate = 'V' then
        l_rate := l_devident_value || ' d/CP';
      end if;

      l_templateid := '0216';
    elsif l_catype = '011' then
      l_rate       := l_devident_shares;
      l_templateid := '216B';
    elsif l_catype = '021' then
      l_rate       := l_exrate;
      l_templateid := '216B';
    elsif l_catype in ('014', '023') then
      l_rate       := l_right_off_rate;
      l_exrate     := l_exrate;
      l_templateid := '216D';
    elsif l_catype = '010' then
      l_rate := l_right_off_rate;
    elsif l_catype in ('015', '016') then
      l_rate       := l_interest_rate || '%';
      l_templateid := '216C';
    elsif l_catype = '017' then
      l_rate       := l_exrate;
      l_templateid := '216E';

      select symbol
        into l_to_symbol
        from sbsecurities
       where codeid = l_tocodeid;
    elsif l_catype = '019' then
      l_templateid := '216F';
      l_rate       := '0';
      select cdcontent
        into l_to_trade_place
        from allcode
       where cdtype = 'SE'
         and cdname = 'TRADEPLACE'
         and cdval = l_to_floor_code;

      select cdcontent
        into l_fr_trade_place
        from allcode
       where cdtype = 'SE'
         and cdname = 'TRADEPLACE'
         and cdval = l_fr_floor_code;

    elsif l_catype = '020' then
      l_rate       := l_devident_shares;
      l_templateid := '216E';

      select symbol
        into l_to_symbol
        from sbsecurities
       where codeid = l_tocodeid;
    elsif l_catype = '021' then
      l_rate       := l_exrate;
      l_templateid := '216B';
    elsif l_catype = '022' then
      l_rate       := l_devident_shares;
      l_templateid := '216A';
    --T11/2017 CW_PhaseII
    elsif l_catype = '028' then
      if l_typerate = 'R' then
        l_rate := l_devident_rate;
        l_gia := l_exprice;
        l_smsrate := l_rate||'%';
      elsif l_typerate = 'V' then
        l_rate := l_devident_value || ' d/CW';
        l_gia := l_devident_value;
        l_smsrate := l_rate;
      end if;

      l_templateid := '121E';
    --End CW_PhaseII
    end if;
    IF l_templateid = '0216' THEN
      RETURN;
    END IF;
    open c_caschd for
      select * from caschd where camastid = p_ca_id and deltd = 'N';

    loop
      fetch c_caschd bulk collect
        into caschd_list limit l_caschd_cache_size;

      plog.DEBUG(pkgctx, 'count ' || caschd_list.COUNT);
      exit when caschd_list.COUNT = 0;
      l_row := caschd_list.FIRST;

      while (l_row is not null)

       loop
        caschdrow := caschd_list(l_row);

        -- Thong tin khach hang
        select c.custodycd,
               a.email,
               c.fullname,
               decode(c.sex, '001', 'Ông/Sir', '002', 'Bà/Madam', ''),    --thuy edit 30082019
         b.typename
          into l_custodycd, l_email, l_fullname, l_sex,l_aftype
          from cfmast c, afmast a,aftype b
         where c.custid = a.custid
      and a.actype=b.actype
           and a.acctno = caschdrow.afacctno;

        if CheckEmail(l_email) and length(l_rate) > 0 then

          l_datasource := 'select ''' || l_fullname || ''' fullname, ''' ||
                          l_custodycd || ''' custodycode, ''' || l_aftype || ''' typename,
                           ''' || caschdrow.afacctno || ''' account, ''' ||
                          l_symbol || ''' symbol, ''' || l_issuer ||
                          ''' issuer, ''' || l_trade_date ||
                          ''' tradeplace, ''' ||
                          to_char(ROUND(caschdrow.trade),
                                  '99G999G999G999G999MI') || ''' trade, ''' ||
                          l_report_date || ''' reportdate, ''' || l_advdesc ||
                          ''' advdesc, ''' || l_rate || ''' rate, ''' ||
                          l_inaction_date || ''' inactiondate, ''' ||
                          l_purpose_desc || ''' purpose, ''' || l_exrate ||
                          ''' exrate, ''' || l_to_symbol ||
                          ''' tosymbol, ''' || l_begin_date ||
                          ''' begindate, ''' || l_due_date ||
                          ''' duedate, ''' || l_frdate_transfer ||
                          ''' frdatetransfer, ''' || l_todate_transfer ||
                          ''' todatetransfer, ''' ||
                          to_char(ROUND(l_exprice), '99G999G999G999G999MI') ||
                          ''' exprice, ''' ||
                          to_char(ROUND(caschdrow.pqtty),
                                  '99G999G999G999G999MI') || ''' pqtty, ''' ||
                          l_to_trade_place || ''' totradeplace, ''' ||
                          l_sex || ''' sex, ''' || l_fr_trade_place ||
                          ''' frtradeplace from dual';

          plog.debug(pkgctx, 'EMAIL DATA: ' || l_datasource);

          /*          insert into emaillog
            (autoid, email, templateid, datasource, status, createtime)
          values
            (seq_emaillog.nextval,
             l_email,
             l_templateid,
             l_datasource,
             'A',
             sysdate);*/
          InsertEmailLog(l_email,
                         l_templateid,
                         l_datasource,
                         caschdrow.afacctno);

        end if;

        l_row := caschd_list.NEXT(l_row);
      end loop;

    end loop;

    plog.setEndSection(pkgctx, 'GenTemplate0216');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate0216');
  end;

  -- Mau thu thong bao thuc hien quyen mua phat hanh them
  procedure GenTemplate0217(p_ca_id varchar2) is

    l_custodycd   cfmast.custodycd%type;
    l_fullname    cfmast.fullname%type;
    l_email       afmast.email%type;
    l_datasource  varchar2(2000);
    l_idcode      cfmast.idcode%type;
    l_iddate      varchar2(10);
    l_phone       afmast.phone1%type;
    l_address     cfmast.address%type;
    l_symbol      sbsecurities.symbol%type;
    l_exprice     camast.exprice%type;
    l_duedate     varchar2(10);
    l_parvalue    sbsecurities.parvalue%type;
    l_issuer_name issuers.fullname%type;

    type caschd_cursor is ref cursor;

    c_caschd  caschd_cursor;
    caschdrow caschd%rowtype;

    type ty_caschd is table of caschd%rowtype index by binary_integer;

    caschd_list         ty_caschd;
    l_caschd_cache_size number(23) := 1000000;
    l_row               pls_integer;
  begin
    plog.setBeginSection(pkgctx, 'GenTemplate0217');

    select se.symbol,
           ca.exprice,
           to_char(ca.duedate, 'DD/MM/RRRR'),
           se.parvalue,
           i.fullname
      into l_symbol, l_exprice, l_duedate, l_parvalue, l_issuer_name
      from camast ca, sbsecurities se, issuers i
     where ca.camastid = p_ca_id
       and ca.codeid = se.codeid
       and se.issuerid = i.issuerid;

    open c_caschd for
      select * from caschd where camastid = p_ca_id and deltd = 'N';

    loop
      fetch c_caschd bulk collect
        into caschd_list limit l_caschd_cache_size;

      plog.DEBUG(pkgctx, 'count ' || caschd_list.COUNT);
      exit when caschd_list.COUNT = 0;
      l_row := caschd_list.FIRST;

      while (l_row is not null)

       loop
        caschdrow := caschd_list(l_row);

        -- Thong tin khach hang
        select c.custodycd,
               a.email,
               c.fullname,
               c.idcode,
               to_char(c.iddate, 'DD/MM/RRRR'),
               a.phone1,
               c.address
          into l_custodycd,
               l_email,
               l_fullname,
               l_idcode,
               l_iddate,
               l_phone,
               l_address
          from cfmast c, afmast a
         where c.custid = a.custid
           and a.acctno = caschdrow.afacctno;

        l_datasource := 'select ''' || l_fullname || ''' fullname, ''' ||
                        l_custodycd || ''' custodycode, ''' ||
                        caschdrow.afacctno || ''' account, ''' || p_ca_id ||
                        ''' cacode, ''' || l_symbol || ''' symbol, ''' ||
                        l_fullname || ''' p_custname, ''' || l_idcode ||
                        ''' p_license, ''' || l_iddate || ''' p_iddate, ''' ||
                        l_phone || ''' p_phone, ''' || l_address ||
                        ''' p_address, ''' || l_symbol || ''' p_symbol, ''' ||
                        ltrim(to_char(l_exprice, '9,999,999,999')) ||
                        ''' p_price, ''' || l_duedate || ''' p_duedate, ''' ||
                        ltrim(to_char(caschdrow.trade, '9,999,999,999')) ||
                        ''' p_balance, ''' ||
                        ltrim(to_char(caschdrow.pqtty, '9,999,999,999')) ||
                        ''' p_mqtty, ''' ||
                        ltrim(to_char(l_parvalue, '9,999,999,999')) ||
                        ''' p_parvalue, ''' || l_custodycd ||
                        ''' p_custodycd, ''' || caschdrow.afacctno ||
                        ''' p_afacctno, ''' || l_issuer_name ||
                        ''' p_issname, ''Ðăng ký mua cổ phiếu phát hành thêm'' p_desc from dual';

        plog.error(pkgctx, 'EMAIL DATA: ' || l_datasource);

        InsertEmailLog(l_email, '0217', l_datasource, caschdrow.afacctno);

        l_row := caschd_list.NEXT(l_row);
      end loop;

    end loop;
    plog.setEndSection(pkgctx, 'GenTemplate0217');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
	  
	  
      plog.setEndSection(pkgctx, 'GenTemplate0217');
  end;

  procedure GenTemplate0326(p_template_id varchar2) is

    l_datasource varchar2(4000);

    type ca_cursor is ref cursor;

    type ca_record is record(
      camastid       camast.camastid%type,
      duedate        camast.duedate%type,
      todatetransfer camast.todatetransfer%type,
      exprice        camast.exprice%type,
      symbol         sbsecurities.symbol%type,
      custodycd      cfmast.custodycd%type,
      afacctno       afmast.acctno%type,
      typename       aftype.typename%type,
      pqtty          caschd.pqtty%type,
      mobile         afmast.fax1%type);

    c_ca   ca_cursor;
    ca_row ca_record;

    type ty_ca is table of ca_record index by binary_integer;

    ca_list         ty_ca;
    l_ca_cache_size number(23) := 1000;
    l_row           pls_integer;

  begin
    plog.setBeginSection(pkgctx, 'GenTemplate0326');

    open c_ca for
      select mst.camastid,
             mst.duedate,mst.todatetransfer,
             --TO_CHAR(mst.duedate,'dd/mm/rrrr') duedate,                 --thuyct edit dinh dang date
             --TO_CHAR(mst.todatetransfer,'dd/mm/rrrr') todatetransfer,
             mst.exprice,
             s.symbol,
             cf.custodycd,
             schd.afacctno,
             f.typename,
             schd.pqtty,
             af.fax1 mobile
        from camast mst, caschd schd, sbsecurities s, afmast af, cfmast cf,aftype f --thuy edit aftype 29_12_2020
       where mst.camastid = schd.camastid
         and mst.codeid = s.codeid
         and schd.afacctno = af.acctno
         and af.custid = cf.custid
         and af.actype=f.actype
         and schd.pqtty > 0
         and schd.deltd = 'N'
         and getprevdate(mst.duedate, 3) = getcurrdate
         and mst.catype = '014';

    loop
      fetch c_ca bulk collect
        into ca_list limit l_ca_cache_size;

      plog.DEBUG(pkgctx, 'count ' || ca_list.COUNT);
      exit when ca_list.COUNT = 0;
      l_row := ca_list.FIRST;

      while (l_row is not null)

       loop
        ca_row := ca_list(l_row);

        l_datasource := 'select ''' || ca_row.custodycd ||               --thuy edit typenam 29_12_2020
                        ca_row.typename || ''' custodycode, ''' ||
                        ca_row.pqtty || ''' pqtty, ''' || ca_row.symbol ||
                        ''' symbol, ''' || ca_row.exprice ||
                        ''' exprice, ''' || TO_CHAR(ca_row.todatetransfer,'dd/mm/rrrr') ||
                        ''' todatetransfer, ''' || TO_CHAR(ca_row.duedate,'dd/mm/rrrr') ||
                        ''' duedate from dual';

        plog.debug(pkgctx, 'DATA: ' || l_datasource);

        InsertEmailLog(ca_row.mobile,
                       p_template_id,
                       l_datasource,
                       ca_row.afacctno);

        l_row := ca_list.NEXT(l_row);
      end loop;

    end loop;
    plog.setEndSection(pkgctx, 'GenTemplate0326');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      
      plog.setEndSection(pkgctx, 'GenTemplate0326');
  end;

  procedure GenTemplate0323(p_account varchar2) is
    type smsmatched_cursor is ref cursor;

    type smsmatch is record(
      autoid     smsmatched.autoid%type,
      custodycd  smsmatched.custodycd%type,
      orderid    smsmatched.orderid%type,
      txdate     smsmatched.txdate%type,
      matchprice smsmatched.matchprice%type,
      header     smsmatched.header%type,
      header1    varchar2(30),
      detail     varchar2(300),
      detail1    varchar2(300),
      footer     varchar2(100),
      footer1    varchar2(100));

    c_smsmatched  smsmatched_cursor;
    smsmatchedrow smsmatch;

    type ty_smsmatched is table of smsmatch index by binary_integer;

    smsmatched_list         ty_smsmatched;
    l_smsmatched_cache_size number(23) := 1000;
    l_row                   pls_integer;

    l_message_template varchar2(160) := 'KBSV thong bao KQKL TK [custodycode] ngay [txdate]: [detail]';
    l_message_template1   varchar2(300) := 'TK [custodycode] ngày [txdate]: [detail]';
    l_template_id      char(4) := '0323';
    l_template_id1     char(4) := '0223';
    l_prefix_message   varchar2(160) := '';
    l_prefix_message1  varchar2(4000) := '';
    l_message          varchar2(300) := '';
    l_message1         varchar2(4000) := '';
    l_message_temp     varchar2(300) := '';
    l_message_temp1    varchar2(4000) := '';
    l_previous_message varchar2(160) := '';
    l_previous_message1 varchar2(4000) := '';
    l_detail           varchar2(300) := '';
    l_detail1          varchar2(300) := '';
    l_custodycd        varchar2(10) := '';
    l_typename         varchar2(200) := '';
    l_smsmobile        varchar2(20) := '';
    l_email            varchar2(50) := '';
    l_datasource       varchar2(1000) := '';
    l_datasource1      varchar2(4000) := '';
    l_previous_header  varchar2(20) := '';
    l_previous_header1 varchar2(20) := '';
    l_header           varchar2(20) := '';
    l_header1          varchar2(20) := '';
    l_orderid          varchar2(20) := '';
    l_orderid1          varchar2(20) := '';
    l_previous_orderid varchar2(20) := '';
    l_previous_orderid1 varchar2(20) := '';
    l_footer           varchar2(50) := '';
    l_footer1          varchar2(50) := '';
    l_previous_footer  varchar2(50) := '';
    l_previous_footer1 varchar2(50) := '';
    l_autoid           number(20);
    l_status           char(1) := 'L'; -- L: Less than, E: equal, G: greater than
  begin
    plog.setBeginSection(pkgctx, 'GenTemplate0323');

    select c.custodycd, a.fax1 , c.email, af.typename
      into l_custodycd, l_smsmobile, l_email, l_typename
      from cfmast c, afmast a, aftype af
     where c.custid = a.custid
       and a.actype = af.actype
       and a.acctno = p_account;

    -- Init prefix message
    l_prefix_message := replace(l_message_template,
                                '[custodycode]',
                                l_custodycd);
    l_prefix_message1 := replace(l_message_template1,
                                '[custodycode]',
                                l_custodycd||'-'||l_typename);
    l_prefix_message := replace(l_prefix_message,
                                '[txdate]',
                                to_char(getcurrdate,
                                        systemnums.C_DATE_FORMAT));
    l_prefix_message1 := replace(l_prefix_message1,
                                '[txdate]',
                                to_char(getcurrdate,
                                        systemnums.C_DATE_FORMAT));
    l_prefix_message := replace(l_prefix_message, '[detail]');
    l_prefix_message1 := replace(l_prefix_message1, '[detail]');
    plog.debug(pkgctx, 'SMS prefix: ' || l_prefix_message);

    /*    open c_smsmatched for
    select max(autoid) autoid, custodycd, orderid, txdate, header,
           listagg(detail, ',') within group(order by detail) || ', ' || max(footer) as detail
      from (select a.*, rownum top
               from (select max(autoid) autoid, txdate, custodycd, orderid, header,
                             max(footer) footer,
                             'KL ' || sum(matchqtty) || ' GIA ' || matchprice as detail
                        from smsmatched
                       where status = 'N'
                         and custodycd = l_custodycd
                       group by txdate, custodycd, orderid, header, matchprice
                       order by autoid) a)
     group by custodycd, orderid, txdate, header
     order by autoid;*/

    --l_prefix_message := l_message_template;
    --plog.debug(pkgctx, 'Template: ' || l_message);

    open c_smsmatched for
      select max(autoid) autoid,
             custodycd,
             orderid,
             txdate,
             matchprice,
             header,
             replace(header,'BAN','BÁN') header1,
             'KL ' || sum(matchqtty) || ' GIA ' || matchprice as detail,
             'KL ' || sum(matchqtty) || ' GIÁ ' || matchprice as detail1,
             'TONG_KHOP ' || max(TOTALQTTY) || '/' || MAX(ORDERQTTY) footer,
             'TỔNG KHỚP ' || max(TOTALQTTY) || '/' || MAX(ORDERQTTY) footer1
        from smsmatched
       where status = 'N'
         and afacctno = p_account
       group by txdate, custodycd, orderid, header, matchprice
       order by orderid, autoid;

    loop
      fetch c_smsmatched bulk collect
        into smsmatched_list limit l_smsmatched_cache_size;

      plog.DEBUG(pkgctx, 'CNT: ' || smsmatched_list.COUNT);

      exit when smsmatched_list.COUNT = 0;
      l_row := smsmatched_list.FIRST;

      while (l_row is not null)

       loop
        smsmatchedrow := smsmatched_list(l_row);

        plog.DEBUG(pkgctx, 'Round [' || l_row || ']');

        l_detail  := smsmatchedrow.detail;
        l_detail1 := smsmatchedrow.detail1;
        l_header  := smsmatchedrow.header;
        l_header1 := smsmatchedrow.header1;
        l_orderid := smsmatchedrow.orderid;
        l_footer  := smsmatchedrow.footer;
        l_footer1 := smsmatchedrow.footer1;
        l_autoid  := smsmatchedrow.autoid;

        plog.debug(pkgctx, 'Previous SMS: ' || l_previous_message);
        if l_previous_message = '' or l_previous_message is null then
          l_message_temp := l_prefix_message || l_header || l_detail;
          l_message_temp1 := l_prefix_message1 || l_header1 || l_detail1;
        else
          l_message_temp := l_previous_message; -- || ',' || l_header || l_detail;
          l_message_temp1 := l_previous_message1;
        end if;

        plog.debug(pkgctx, 'orderid: ' || l_orderid);

        if l_previous_orderid <> '' or l_previous_orderid is not null then
          plog.debug(pkgctx, 'prev. orderid: ' || l_previous_orderid);
          if l_orderid = l_previous_orderid then
            l_message      := l_message_temp || ', ' || l_detail || ', ' ||
                              l_footer;
            l_message1     := l_message_temp1 || ', ' || l_detail1 || ', ' ||
                              l_footer1;
            l_message_temp := l_message_temp || ', ' || l_detail;
            l_message_temp1 := l_message_temp1 || ', ' || l_detail1;
          else
            l_message_temp := l_message_temp || ', ' || l_previous_footer;
            l_message_temp1 := l_message_temp1 || ', ' || l_previous_footer1;
            if l_previous_header <> l_header then
              l_message_temp := l_message_temp || '; ' || l_header ||
                                l_detail;
              l_message_temp1 := l_message_temp1 || '; ' || l_header1 ||
                                l_detail1;
            else
              l_message_temp := l_message_temp || ', ' || l_detail;
              l_message_temp1 := l_message_temp1 || ', ' || l_detail1;
            end if;

            l_message := l_message_temp || ', ' || l_footer;
            l_message1 := l_message_temp1 || ', ' || l_footer1;
          end if;
        else
          l_message := l_message_temp || ', ' || l_footer;
          l_message1 := l_message_temp1 || ', ' || l_footer1;
        end if;

          l_previous_message1 := l_message_temp1;
          l_previous_orderid1 := l_orderid;
          l_previous_footer1  := l_footer1;
          l_previous_header1  := l_header1;

        plog.debug(pkgctx, 'Message temp: ' || l_message_temp);
        plog.debug(pkgctx,
                   'SMS message: ' || l_message || ' [' ||
                   length(l_message) || ']');

        if length(l_message) < 160 then
          l_previous_message := l_message_temp;
          l_previous_orderid := l_orderid;
          l_previous_footer  := l_footer;
          l_previous_header  := l_header;
          l_status           := 'L';

        elsif length(l_message) = 160 then

          plog.debug(pkgctx, 'SMS length equal 160');

          l_datasource := 'SELECT ''' || l_custodycd ||
                          ''' custodycode, ''' || smsmatchedrow.txdate ||
                          ''' txdate, ''' || l_message ||
                          ''' detail FROM DUAL';

          if l_smsmobile is not null and length(l_smsmobile) > 0 then

            InsertEmailLog(l_smsmobile,
                           l_template_id,
                           l_datasource,
                           p_account);

            /*            insert into emaillog
              (autoid, email, templateid, datasource, status, createtime)
            values
              (seq_emaillog.nextval,
               l_smsmobile,
               l_template_id,
               l_datasource,
               'A',
               sysdate);*/
          end if;

          l_previous_message := '';
          l_previous_orderid := '';
          l_previous_footer  := '';
          l_previous_header  := '';
          l_status           := 'E';

        else

          plog.debug(pkgctx, 'SMS length greater than 160');

          l_datasource := 'SELECT ''' || l_custodycd ||
                          ''' custodycode, ''' || smsmatchedrow.txdate ||
                          ''' txdate, ''' || l_previous_message || ', ' ||
                          l_previous_footer || ''' detail FROM DUAL';

          if l_smsmobile is not null and length(l_smsmobile) > 0  then
            InsertEmailLog(l_smsmobile,
                           l_template_id,
                           l_datasource,
                           p_account);
            /*            insert into emaillog
              (autoid, email, templateid, datasource, status, createtime)
            values
              (seq_emaillog.nextval,
               l_smsmobile,
               l_template_id,
               l_datasource,
               'A',
               sysdate);*/
          end if;

          l_message          := l_prefix_message || l_header || l_detail;
          l_previous_message := l_message;
          l_previous_orderid := l_orderid;
          l_previous_footer  := l_footer;
          l_previous_header  := l_header;
          l_status           := 'G';
          plog.debug(pkgctx, 'NEW SMS: ' || l_message);

        end if;

        if l_row = smsmatched_list.COUNT and l_status <> 'E' then

          if l_status = 'G' then
            l_message := l_message || ', ' || l_footer;
          end if;

          l_datasource := 'SELECT ''' || l_custodycd ||
                          ''' custodycode, ''' || smsmatchedrow.txdate ||
                          ''' txdate, ''' || l_message || --', ' || l_footer ||
                          ''' detail FROM DUAL';

          if l_smsmobile is not null and length(l_smsmobile) > 0 then

            InsertEmailLog(l_smsmobile,
                           l_template_id,
                           l_datasource,
                           p_account);
          end if;
            /*            insert into emaillog
              (autoid, email, templateid, datasource, status, createtime)
            values
              (seq_emaillog.nextval,
               l_smsmobile,
               l_template_id,
               l_datasource,
               'A',
               sysdate);*/
          end if;


        --Danh dau lenh khop
        plog.debug(pkgctx,
                   'AUTOID: [' || l_autoid || '] - ORDERID: [' || l_orderid ||
                   '] MATCHED PRICE: [' || smsmatchedrow.matchprice || ']');
        update smsmatched
           set status = 'M', sentdate = sysdate
         where orderid = l_orderid
           and matchprice = smsmatchedrow.matchprice
           and autoid <= l_autoid;

        l_row := smsmatched_list.NEXT(l_row);
      end loop;

    end loop;
    -- insert email
        l_datasource1 := 'SELECT ''' || l_custodycd ||
                          ''' custodycode,'''|| l_typename ||
                          ''' typename,''' || to_char(smsmatchedrow.txdate,'dd/mm/rrrr') ||
                          ''' txdate, ''' || l_message1 ||
                          ''' detail FROM DUAL';
        if l_email is not null and length(l_email) > 0 and l_message1 IS NOT NULL then
             InsertEmailLog(l_email,
                           l_template_id1,
                           l_datasource1,
                           p_account);
        end if;

    update smsmatched
       set status = 'S'
     where afacctno = p_account
       and status = 'M';

    plog.setEndSection(pkgctx, 'GenTemplate0323');
  exception
    when others then
      update smsmatched set status = 'R' where afacctno = p_account;
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate0323');
  end;

  procedure GenTemplateTransaction(p_transaction_number varchar2) is

    type transaction_cursor is ref cursor;

    type transaction_record is record(
      apptype apptx.apptype%type,
      TXTYPE  apptx.txtype%type,
      namt    citran.namt%type,
      acctno  citran.acctno%type,
      trdesc  citran.trdesc%type,
      balance cimast.balance%type);

    c_transaction   transaction_cursor;
    transaction_row transaction_record;

    type ty_transaction is table of transaction_record index by binary_integer;

    transaction_list         ty_transaction;
    l_transaction_cache_size number(23) := 1000;
    l_row                    pls_integer;

    l_message_type     tltx.msgtype%type;
    l_message_content  allcode.cdcontent%type;
    l_message_account  tllog.msgacct%type;
    l_message_amount   tllog.msgamt%type;
    l_transaction_date tllog.txdate%type;
    l_custody_code     cfmast.custodycd%type;
    l_type_name         aftype.typename%type;--thuyct edit them typename 29_12_2020
    l_txtype           apptx.txtype%type;
    l_amount           number(20);
    l_account          varchar2(20);
    l_transaction_desc appmap.trdesc%type;
    l_balance          cimast.balance%type;
    --l_trade            semast.trade%type;
    l_sms_number afmast.fax1%type;
    l_symbol     sbsecurities.symbol%type;

    l_app_type           char(2);
    l_template_id        char(4);
    l_message_ci_credit  char(4) := '324A';
    l_message_ci_dedit   char(4) := '324B';
    l_message_se_credit  char(4) := '325E';
    l_message_se_dedit   char(4) := '325F';
    l_datasource         varchar2(1000);
    str_transaction_date varchar2(20);
  begin
    plog.setBeginSection(pkgctx, 'GenTemplateTransaction');

    plog.info(pkgctx, 'PROCESS: [TXNUM: ' || p_transaction_number || ']');

    select t.msgtype,
           a.cdcontent,
           l.msgamt,
           l.msgacct, /*c.custodycd, */
           l.txdate --, m.fax1
      into l_message_type,
           l_message_content,
           l_message_amount,
           l_message_account, --l_custody_code,
           l_transaction_date --, l_sms_number
      from tllog l, tltx t, allcode a --, afmast m--, cfmast c
     where t.tltxcd = l.tltxcd
       and a.cdtype = 'NM'
       and a.cdname = 'MSGTYPE'
       and a.cdval = t.msgtype --and m.custid = c.custid
          --and substr(l.msgacct,1,10) = m.acctno
       and l.txnum = p_transaction_number;

    plog.info(pkgctx,
              'TYPE: [' || l_message_type || '] CONTENT: [' ||
              l_message_content || '] AMOUNT: [' || l_message_amount ||
              '] ACCOUNT: [' || l_message_account || '] TRANS. DATE [' ||
              to_char(l_transaction_date, 'DD/MM/RRRR') || ']');
    str_transaction_date := to_char(l_transaction_date, 'DD/MM/RRRR');
    open c_transaction for
      select a.apptype,
             a.txtype,
             t.namt,
             t.acctno,
             t.trdesc,
             m.trade balance
        from setran t, semast m, apptx a
       where t.txcd = a.txcd
         and a.apptype = 'SE'
         and a.field = 'TRADE'
         and a.txtype in ('C', 'D')
         and t.namt > 0
         and t.acctno = m.acctno
         and t.txdate = l_transaction_date
         and t.txnum = p_transaction_number
      union all
      select a.apptype, a.txtype, t.namt, t.acctno, t.trdesc, m.balance
        from citran t, cimast m, apptx a
       where t.txcd = a.txcd
         and a.apptype = 'CI'
         and a.field = 'BALANCE'
         and a.txtype in ('C', 'D')
         and t.namt > 0
         and t.acctno = m.acctno
         and t.txdate = l_transaction_date
         and t.txnum = p_transaction_number
            -- Khong nhan tin cac but toan phi chuyen tien
         and not
              (a.txcd = '0028' and
              t.tltxcd in ('1201','1101', '1111', '1120', '1130', '1185', '1188'));  --KB them 1201

    loop
      fetch c_transaction bulk collect
        into transaction_list limit l_transaction_cache_size;

      plog.DEBUG(pkgctx, 'CNT: ' || transaction_list.COUNT);

      exit when transaction_list.COUNT = 0;
      l_row := transaction_list.FIRST;

      while (l_row is not null)

       loop

        transaction_row    := transaction_list(l_row);
        l_app_type         := transaction_row.apptype;
        l_txtype           := transaction_row.TXTYPE;
        l_amount           := transaction_row.namt;
        l_account          := substr(transaction_row.acctno, 1, 10);
        l_transaction_desc := transaction_row.trdesc;
        l_balance          := transaction_row.balance;

        plog.info(pkgctx,
                  'TXTYPE: [' || l_txtype || '] AMT: [' || l_amount ||
                  '] ACCT: [' || l_account || '] TRANS. DESC. [' ||
                  l_transaction_desc || '] BAL. [' || l_balance || ']');

        select c.custodycd, a.fax1,f.typename
          into l_custody_code, l_sms_number, l_type_name
          from afmast a, cfmast c,aftype f --thuyct edit add aftype 29_12_2020
         where a.custid = c.custid
            and a.actype=f.actype
           and a.acctno = l_account;

        plog.info(pkgctx,
                  'CUSTODY CODE: [' || l_custody_code || '] SMS NO: [' ||
                  l_sms_number || ']');

        if l_transaction_desc <> '' or l_transaction_desc is not null then
          l_message_content := l_transaction_desc;
        end if;

        if l_app_type = 'CI' then
          if l_txtype = 'C' then
            l_template_id := l_message_ci_credit;
          else
            l_template_id := l_message_ci_dedit;
          end if;

          l_datasource := 'select ''' || l_custody_code ||         --thuyct edit 29_12_2020
                          l_type_name || ''' custodycode, ''' ||
                          str_transaction_date || ''' txdate, ''' ||
                          l_message_content || ''' txdesc, ''' ||
                          ltrim(replace(to_char(l_amount,
                                                '9,999,999,999,999'),
                                        ',',
                                        '.')) || ''' amount, ''' ||
                          ltrim(replace(to_char(l_balance,
                                                '9,999,999,999,999'),
                                        ',',
                                        '.')) || ''' balance from dual';

        elsif l_app_type = 'SE' then
          if l_txtype = 'C' then
            l_template_id := l_message_se_credit;
          else
            l_template_id := l_message_se_dedit;
          end if;

          select b.symbol
            into l_symbol
            from semast a, sbsecurities b
           where a.codeid = b.codeid
             and a.acctno = transaction_row.acctno;

          l_datasource := 'select ''' || l_custody_code || l_type_name ||              --thuyct edit 29_12_2020
                          ''' custodycode, ''' || l_transaction_date ||
                          ''' txdate, ''' || l_message_content ||
                          ''' txdesc, ''' ||
                          ltrim(replace(to_char(l_amount,
                                                '9,999,999,999,999'),
                                        ',',
                                        '.')) || ''' amount, ''' ||
                          ltrim(replace(to_char(l_balance,
                                                '9,999,999,999,999'),
                                        ',',
                                        '.')) || ''' trade, ''' || l_symbol ||
                          ''' symbol from dual';
        end if;

        if l_template_id <> '' or l_template_id is not null then

          InsertEmailLog(l_sms_number,
                         l_template_id,
                         l_datasource,
                         l_account);
        end if;

        l_row := transaction_list.NEXT(l_row);
      end loop;
    end loop;

    plog.setEndSection(pkgctx, 'GenTemplateTransaction');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplateTransaction');
  end;

  procedure GenTemplateTransaction1816(p_transaction_number varchar2) is

    l_period          char(1); --PERIOD
    l_custody_code    cfmast.custodycd%type; --CUSTODYCD
    l_fullname        cfmast.fullname%type; --FULLNAME
    l_broker_fullname cfmast.fullname%type; --TLFULLNAME
    l_sub_account     afmast.acctno%type; --ACCTNO
    l_t0_cal          number(23, 2); --T0CAL
    l_advance_line    number(23, 2); --ADVANCELINE
    l_margin_rate     number(23, 2); --MARGINRATE
    l_margin_rate_to  number(23, 2); --MARGINRATE_TO
    l_setotal         number(23, 2); --SETOTAL
    l_total_loan      number(23, 2); --TOTALLOAN
    l_pp0             number(23, 2); --PP
    l_t0deb           number(23, 2); --ADVANCELINE+T0DEB
    l_t0_used         number(23, 2); --T0AMTUSED
    l_t0_pending      number(23, 2); --T0AMTPENDING
    l_amount          number(23, 2); --TOAMT
    l_assetanv          number(23, 3); --TOAMT
    l_maker_id        tlprofiles.tlid%type; --TLID
    l_approver        cfmast.fullname%type; --TLIDNAME
    l_approver_id     tlprofiles.tlid%type; --TLID
    l_email           usert0limit.email%type;
    l_email_cc        usert0limit.ccemail%type;
    l_department      tlgroups.grpname%type;
    l_maker_email     tlprofiles.email%type;
    l_title_id        usert0limit.tltitle%type;
    l_branch_id       tlprofiles.brid%type;
    l_email_pcc       cfmast.email%type;
    l_template_id     char(4) := '0221';
    l_data_source     varchar2(4000);
    l_cusid           varchar2(20);
    l_str             varchar2(20);
    l_ds             varchar2(1000);
    l_deal           varchar2(20);
  begin
    plog.setBeginSection(pkgctx, 'GenTemplateTransaction1816');

    plog.info(pkgctx, 'PROCESS: [TXNUM: ' || p_transaction_number || ']');

    select *
      into l_amount,
           l_t0_cal,
           l_advance_line,
           l_margin_rate,
           l_setotal,
           l_total_loan,
           l_pp0,
           l_t0deb,
           l_t0_used,
           l_t0_pending,
           l_period,
           l_margin_rate_to

      from (select l.nvalue, f.defname
              from tllogfld l, fldmaster f
             where l.fldcd = f.fldname
               and f.objname = '1816'
               and l.txnum = p_transaction_number
               and f.fldtype = 'N') pivot(sum(nvl(nvalue, 0)) as F for(defname) in('TOAMT' as
                                                                                   TOAMT,
                                                                                   'T0CAL' as
                                                                                   T0CAL,
                                                                                   'ADVANCELINE' as
                                                                                   ADVANCELINE,
                                                                                   'MARGINRATE' as
                                                                                   MARGINRATE,
                                                                                   'SETOTAL' as
                                                                                   SETOTAL,
                                                                                   'TOTALLOAN' as
                                                                                   TOTALLOAN,
                                                                                   'PP' as PP,
                                                                                   'T0DEB' as
                                                                                   T0DEB,
                                                                                   'T0AMTUSED' as
                                                                                   T0AMTUSED,
                                                                                   'T0AMTPENDING' as
                                                                                   T0AMTPENDING,
                                                                                   'PERIOD' as
                                                                                   PERIOD,
                                                                                   'MARGINRATE_T0' as
                                                                                    MARGINRATE_T0));

    select *
      into l_sub_account,
           l_custody_code,
           l_fullname,
           l_broker_fullname,
           l_approver_id,
           l_approver,
           l_maker_id,
           l_department,
           l_ds,
           l_deal
      from (select l.cvalue, f.defname
              from tllogfld l, fldmaster f
             where l.fldcd = f.fldname
               and f.objname = '1816'
               and l.txnum = p_transaction_number
               and f.fldtype = 'C') pivot(max(cvalue) as F for(defname) in('ACCTNO' as
                                                                           ACCTNO,
                                                                           'CUSTODYCD' as
                                                                           CUSTODYCD,
                                                                           'FULLNAME' as
                                                                           FULLNAME,
                                                                           'TLFULLNAME' as
                                                                           TLFULLNAME,
                                                                           'TLID' as TLID,
                                                                           'TLIDNAME' as
                                                                           TLIDNAME,
                                                                           'USERID' as
                                                                           USERID,
                                                                           'TLGROUP' as
                                                                           TLGROUP,'SYMBOLAMT' as  SYMBOLAMT,
                                                                           'DEAL' AS DEAL
                                                                           ));
     -- tinh nav/no
    /*if FN_GET_NO(l_sub_account) = 0 then l_assetanv := 0;
    else l_assetanv := round(FN_GET_NETASSET(l_CUSTDYCD => l_custody_code,l_AFACCTNO => l_sub_account)/FN_GET_NO(l_sub_account),2)*100;
    end if;
    if l_assetanv <= 0 then  l_str := '10,000';
    else l_str := l_assetanv;
    end if;*/
    l_str := fn_get_nav_no(l_custody_code,l_sub_account);
    IF l_str = 10000 THEN
        l_str := '10,000';
    ELSE
        l_str := l_str;
    END IF;
    IF l_deal = 'N' THEN
        l_deal := 'Không';
    ELSIF  l_deal = 'Y' THEN
        l_deal := 'Có';
    ELSE
        l_deal := 'Null';
    END IF;

    -- l_t0deb       := l_t0deb + l_advance_line; binhvt(chinh sua de khop voi flex )
    l_data_source := 'select ''' || l_custody_code || ''' CUSTODYCD, ''' ||
                     l_sub_account || ''' ACCTNO, ''' || l_fullname ||
                     ''' FULLNAME, ''' || l_broker_fullname ||
                     ''' TLFULLNAME, ''' || l_approver || ''' TLIDNAME, ''' ||
                     fn_NumberFormat(l_amount) || ''' TOAMT, ''' ||
                     fn_NumberFormat(l_t0_cal) || ''' T0CAL, ''' ||
                     fn_NumberFormat(l_advance_line) ||
                     ''' ADVANCELINE, ''' || fn_NumberFormat(l_margin_rate) ||
                     ''' MARGINRATE, ''' || fn_NumberFormat(l_setotal) ||
                     ''' SETOTAL, ''' || fn_NumberFormat(l_total_loan) ||
                     ''' TOTALLOAN, ''' || fn_NumberFormat(l_pp0) ||
                     ''' PP, ''' || fn_NumberFormat(l_t0deb) ||
                     ''' T0DEB, ''' || fn_NumberFormat(l_t0_used) ||
                     ''' T0AMTUSED, ''' || fn_NumberFormat(l_t0_pending) ||
                     ''' T0AMTPENDING, ''' || l_period || ''' PERIOD, ''' ||
                     l_maker_id || ''' MAKER, ''' || l_department ||
                     ''' DEPARTMENT,''' || fn_NumberFormat(l_margin_rate_to) ||
                     ''' RTT,'''|| l_deal ||
                     ''' DEAL,'''|| l_str ||
                     ''' NAV,'''|| upper(l_ds)||''' DS    from dual;';

    select u.email, u.ccemail, u.tltitle
      into l_email, l_email_cc, l_title_id
      from usert0limit u
     where tlid = l_approver_id
       and period = l_period;
    /*
    TLTITLE 001 Giám đốc TT KD DVCK
    TLTITLE 002 Giám đốc chi nhánh/SGD
    TLTITLE 003 Tổng Giám đốc
    TLTITLE 004 Chủ tịch HĐCS
    TLTITLE 005 Khác
  TLTITLE 006 Giam doc khu vuc
    */

    if l_title_id = '003' or l_title_id = '004' then
      begin
        select brid
          into l_branch_id
          from tllog
         where txnum = p_transaction_number;

      exception
        when no_data_found then
          l_branch_id := '0001';
      end;

      select u.email, u.ccemail, u.tltitle
        into l_email, l_email_cc, l_title_id
        from usert0limit u, tlprofiles p
       where u.tlid = p.tlid
         and u.tltitle = '002'
         and p.brid = l_branch_id
         and period = l_period;

    end if;
    ---- neu cap phe duyet la giam doc chinh nhanh tro len
    ---- thi phai cc cho giam doc pcc quan ly userid
  --1.7.3.3: tham gd khu vuc
    if (l_title_id = '002' or l_title_id = '003' or l_title_id = '004' or l_title_id = '006') then
      begin
        -- lay cusid cua giam doc PCC cua user dang nhap
        SELECT regrp.custid
          into l_cusid
          FROM REGRPLNK tlgr, recflnk re, REGRP
         WHERE re.custid = tlgr.custid
           AND RE.REFTLID = l_maker_id
           AND TLGR.STATUS = 'A'
           AND regrp.autoid = tlgr.refrecflnkid
           AND re.effdate <= getcurrdate
           AND re.expdate >= getcurrdate
           AND tlgr.frdate <= getcurrdate
           AND tlgr.todate >= getcurrdate
         Group by regrp.custid;
        --  lay email cua giam doc pcc
        select max(u.email)
          into l_email_pcc
          from recflnk k, usert0limit u
         where custid = l_cusid
           and k.reftlid = u.tlid;
        if l_email_pcc is null or length(l_email_pcc) = 0 then
          begin
            select t.email
              into l_email_pcc
              from tlprofiles t, recflnk k
             where t.tlid = k.reftlid
               and k.custid = l_cusid;
          exception
            when no_data_found then
              plog.error('Khong tim thay email cua giam doc pcc');
              l_email_pcc := '';
          end;
        end if;

      exception
        when no_data_found then

          plog.error('Khong tim thay email cua giam doc pcc');
          l_email_pcc := '';

      end;
    end if;
    begin
      select email
        into l_maker_email
        from tlprofiles
       where tlid = l_maker_id;

      if l_maker_email is not null and length(l_maker_email) > 0 then
        if l_email_cc is not null and length(l_email_cc) > 0 then
          l_email_cc := l_maker_email || ',' || l_email_cc;
          if l_email_pcc is not null and length(l_email_pcc) > 0 then
            l_email_cc := l_email_cc || ',' || l_email_pcc;
          end if;
        else
          if l_email_pcc is not null and length(l_email_pcc) > 0 then
            l_email_cc := l_email_pcc || ',' || l_maker_email;
          else
            l_email_cc := l_maker_email;
          end if;
        end if;
      end if;
    exception
      when no_data_found then
        plog.warn(pkgctx, 'Chua khai bao email cho user ' || l_maker_id);
    end;

    InsertEmailLogWithCc(l_email,
                         l_email_cc,
                         l_template_id,
                         l_data_source,
                         l_sub_account);

    plog.setEndSection(pkgctx, 'GenTemplateTransaction1816');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'GenTemplateTransaction1816');
  end;

  procedure GenTemplateScheduler(p_template_id varchar2) is
    l_next_run_date date;
    l_data_source   varchar2(4000);
    l_template_id   templates.code%type;
    l_afacctno      afmast.acctno%type;
    l_address       varchar2(100);
    l_fullname      cfmast.fullname%type;
    l_custody_code  cfmast.custodycd%type;
    l_sex           varchar2(100);
  l_aftype     aftype.typename%type;      --Thuy edit 30082019;
    type scheduler_cursor is ref cursor;

    type scheduler_record is record(
      template_id templates.code%type,
      afacctno    afmast.acctno%type,
      address     varchar2(100));

    c_scheduler   scheduler_cursor;
    scheduler_row scheduler_record;

    type ty_scheduler is table of scheduler_record index by binary_integer;

    scheduler_list         ty_scheduler;
    l_scheduler_cache_size number(23) := 1000;
    l_row                  pls_integer;
    l_first_day            date;
    l_last_day             date;
    l_count                number;
  begin
    plog.setBeginSection(pkgctx, 'GenTemplateScheduler');

    Begin
      select to_date(fn_get_sysvar_for_report('SYSTEM', 'PREVDATE'),
                     'DD/MM/RRRR') lastday,
             trunc(to_date(fn_get_sysvar_for_report('SYSTEM', 'PREVDATE'),
                           'DD/MM/RRRR'),
                   'MM') firstday
        into l_last_day, l_first_day
        from dual;
    Exception
      When others then
        null;
    End;
    open c_scheduler for
      select t.code,
             max(a.afacctno) afacctno,
             decode(t.type, 'E', max(mst.email), 'S', max(mst.fax1)) address
        from templates t, aftemplates a, afmast mst, cfmast cf
       where a.template_code = t.code
         and a.afacctno = mst.acctno
         and mst.custid = cf.custid
         and decode(t.type, 'E', mst.email, 'S', mst.fax1) is not null
         and t.code = p_template_id
       group by cf.custodycd, t.code, t.type;

    loop
      fetch c_scheduler bulk collect
        into scheduler_list limit l_scheduler_cache_size;

      plog.DEBUG(pkgctx, 'CNT: ' || scheduler_list.COUNT);

      exit when scheduler_list.COUNT = 0;
      l_row := scheduler_list.FIRST;

      while (l_row is not null)

       loop
        scheduler_row := scheduler_list(l_row);
        l_template_id := scheduler_row.template_id;
        l_afacctno    := scheduler_row.afacctno;
        l_address     := scheduler_row.address;

        begin
          select a.custodycd,
                 a.fullname,
                 decode(a.sex, '001', 'Ông/Sir', '002', 'Bà/Madam', ''),      --thuy edit 30082019
         c.typename
            into l_custody_code, l_fullname, l_sex,l_aftype
            from cfmast a, afmast b,aftype c
           where a.custid = b.custid
      and b.actype=c.actype
             and b.acctno = l_afacctno;
        exception
          when NO_DATA_FOUND then
            plog.error(pkgctx,
                       'Sub account ' || l_afacctno || ' not found');
            l_custody_code := 'No Data Found';
            l_fullname     := 'No Data Found';
        end;

        if p_template_id = '0214' then
          l_data_source := 'select ''' || l_custody_code ||
                           ''' custodycode, ''' || l_fullname ||
                           ''' fullname, ''' || l_afacctno ||
                           ''' account,''' || l_aftype || ''' typename,
                            ''' || l_sex || ''' sex, ''' ||
                           to_char(to_date(fn_get_sysvar_for_report(p_sys_grp  => 'SYSTEM',
                                                                    p_sys_name => 'PREVDATE'),
                                           'DD/MM/RRRR'),
                                   'MM/RRRR') || ''' monthly from dual;';
        elsif p_template_id = '0215' then
          l_data_source := 'select ''' || l_custody_code ||
                           ''' custodycode, ''' || l_fullname ||
                           ''' fullname, ''' || l_afacctno ||
                           ''' account,''' || l_aftype || ''' typename,
                            ''' || l_sex || ''' sex, ''' ||
                           fn_get_sysvar_for_report('SYSTEM', 'PREVDATE') ||
                           ''' daily from dual;';
        else

          l_data_source := 'select ''' || l_custody_code ||
                           ''' custodycode, ''' || l_fullname ||
                           ''' fullname, ''' || l_sex || ''' sex, ''' ||
                           l_afacctno || ''' account from dual;';

        end if;
        IF p_template_id <> '0214' then
          InsertEmailLog(l_address,
                         l_template_id,
                         l_data_source,
                         l_afacctno);
        Else
          l_count := 0;
          Select Count(1)
            into l_count
            From citran_gen
           Where acctno = l_afacctno
             and l_first_day <= busdate
             and busdate <= l_last_day;
          IF l_count > 0 and CheckEmail(l_address) then
            InsertEmailLog(l_address,
                           l_template_id,
                           l_data_source,
                           l_afacctno);
          End IF;
        End if;
        l_row := scheduler_list.NEXT(l_row);
      end loop;
    end loop;

    insert into templates_scheduler_log
      (template_id, log_date)
    values
      (p_template_id, getcurrdate);

    update templates_scheduler
       set last_start_date = getcurrdate,
           next_run_date   = fn_GetNextRunDate(getcurrdate, repeat_interval)
     where template_id = p_template_id;

    plog.setEndSection(pkgctx, 'GenTemplateScheduler');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplateScheduler');
  end;

  function CheckEmail(p_email varchar2) return boolean as

    l_is_email_valid boolean;
  begin

    plog.setBeginSection(pkgctx, 'CheckEmail');

    if owa_pattern.match(p_email,
                         '^\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}' ||
                         '@\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}$') then
      l_is_email_valid := true;
    else
      l_is_email_valid := false;
    end if;

    /*IF( ( REPLACE( p_email, ' ','') IS NOT NULL ) AND
         ( NOT owa_pattern.match(
                   p_email, '^[a-z]+[\.\_\-[a-z0-9]+]*[a-z0-9]@[a-z0-9]+\-?[a-z0-9]{1,63}\.?[a-z0-9]{0,6}\.?[a-z0-9]{0,6}\.[a-z]{0,6}$') ) ) THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;*/

    plog.setEndSection(pkgctx, 'CheckEmail');

    return l_is_email_valid;

  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'CheckEmail');
  end;

  procedure InsertEmailLog(p_email       varchar2,
                           p_template_id varchar2,
                           p_data_source varchar2,
                           p_account     varchar2) is

    l_status             char(1) := 'A';
    l_reject_status      char(1) := 'R';
    l_receiver_address   emaillog.email%type;
    l_template_id        emaillog.templateid%type;
    l_datasource         emaillog.datasource%type;
    l_account            emaillog.afacctno%type;
    l_message_type       templates.type%type;
    l_is_required        templates.require_register%type;
    l_aftemplates_autoid aftemplates.autoid%type;
    l_can_create_message boolean := true;
  begin

    plog.setBeginSection(pkgctx, 'InsertEmailLog');
    plog.info(pkgctx, 'DATA [' || p_data_source || ']');

    l_receiver_address := p_email;
    l_template_id      := p_template_id;
    l_account          := p_account;

    select t.type, t.require_register
      into l_message_type, l_is_required
      from templates t
     where code = p_template_id;

    if l_message_type = 'S' then
      l_datasource := fn_convert_to_vn(p_data_source);
    else
      l_datasource := p_data_source;
    end if;

    --Kiem tra xem mau co bat buoc dang ky khong,
    --neu co thi kiem tra xem da duoc dang ky chua
    if l_is_required = 'Y' then
      begin
        select af.autoid
          into l_aftemplates_autoid
          from aftemplates af
         where af.afacctno = l_account
           and af.template_code = l_template_id;

        l_can_create_message := true;

      exception
        when NO_DATA_FOUND then
          l_can_create_message := false;
      end;
    end if;

    if l_can_create_message then
      if l_receiver_address is not null and length(l_receiver_address) > 0 then
        insert into emaillog
          (autoid,
           email,
           templateid,
           datasource,
           status,
           createtime,
           afacctno)
        values
          (seq_emaillog.nextval,
           l_receiver_address,
           l_template_id,
           l_datasource,
           l_status,
           sysdate,
           l_account);
      else
        insert into emaillog
          (autoid, email, templateid, datasource, status, createtime, note)
        values
          (seq_emaillog.nextval,
           l_receiver_address,
           l_template_id,
           l_datasource,
           l_reject_status,
           sysdate,
           '---');
      end if;
    else
      insert into emaillog
        (autoid, email, templateid, datasource, status, createtime, note)
      values
        (seq_emaillog.nextval,
         l_receiver_address,
         l_template_id,
         l_datasource,
         l_reject_status,
         sysdate,
         'This template not registed yet');
    end if;
    plog.setEndSection(pkgctx, 'InsertEmailLog');

  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'InsertEmailLog');
  end;

  procedure InsertEmailLogWithCc(p_email       varchar2,
                                 p_email_cc    varchar2,
                                 p_template_id varchar2,
                                 p_data_source varchar2,
                                 p_account     varchar2) is

    l_status             char(1) := 'A';
    l_reject_status      char(1) := 'R';
    l_receiver_address   emaillog.email%type;
    l_template_id        emaillog.templateid%type;
    l_datasource         emaillog.datasource%type;
    l_account            emaillog.afacctno%type;
    l_message_type       templates.type%type;
    l_is_required        templates.require_register%type;
    l_aftemplates_autoid aftemplates.autoid%type;
    l_can_create_message boolean := true;
  begin

    plog.setBeginSection(pkgctx, 'InsertEmailLog');
    plog.info(pkgctx, 'DATA [' || p_data_source || ']');

    l_receiver_address := p_email;
    l_template_id      := p_template_id;
    l_account          := p_account;

    select t.type, t.require_register
      into l_message_type, l_is_required
      from templates t
     where code = p_template_id;

    if l_message_type = 'S' then
      l_datasource := fn_convert_to_vn(p_data_source);
    else
      l_datasource := p_data_source;
    end if;

    --Kiem tra xem mau co bat buoc dang ky khong,
    --neu co thi kiem tra xem da duoc dang ky chua
    if l_is_required = 'Y' then
      begin
        select af.autoid
          into l_aftemplates_autoid
          from aftemplates af
         where af.afacctno = l_account
           and af.template_code = l_template_id;

        l_can_create_message := true;

      exception
        when NO_DATA_FOUND then
          l_can_create_message := false;
      end;
    end if;

    if l_can_create_message then
      if l_receiver_address is not null and length(l_receiver_address) > 0 then
        insert into emaillog
          (autoid,
           email,
           emailcc,
           templateid,
           datasource,
           status,
           createtime,
           afacctno)
        values
          (seq_emaillog.nextval,
           l_receiver_address,
           p_email_cc,
           l_template_id,
           l_datasource,
           l_status,
           sysdate,
           l_account);
      else
        insert into emaillog
          (autoid,
           email,
           emailcc,
           templateid,
           datasource,
           status,
           createtime,
           note)
        values
          (seq_emaillog.nextval,
           l_receiver_address,
           p_email_cc,
           l_template_id,
           l_datasource,
           l_reject_status,
           sysdate,
           '---');
      end if;
    else
      insert into emaillog
        (autoid, email, templateid, datasource, status, createtime, note)
      values
        (seq_emaillog.nextval,
         l_receiver_address,
         l_template_id,
         l_datasource,
         l_reject_status,
         sysdate,
         'This template not registed yet');
    end if;
    plog.setEndSection(pkgctx, 'InsertEmailLog');

  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'InsertEmailLog');
  end;

  function fn_convert_to_vn(strinput in nvarchar2) return nvarchar2 is
    strconvert nvarchar2(32527);
  begin
 strconvert := translate(strinput,
                            'áàảãạăắằẳẵặâấầẩẫậđéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵáàảãạăắằẳẵặâấầẩẫậđéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬĐÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬĐÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴ',
                            'aaaaaaaaaaaaaaaaadeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyaaaaaaaaaaaaaaaaadeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyAAAAAAAAAAAAAAAAADEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYAAAAAAAAAAAAAAAAADEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYY');

    return strconvert;
  end;

  function fn_GetNextRunDate(p_last_start_date in date, cycle in char)
    return date is
    l_next_run_date date;
  begin

    if cycle = 'D' then
      l_next_run_date := p_last_start_date + 1;
      /*          update templates_scheduler
        set repeat_interval = :new.cycle,
            next_run_date   = last_start_date + 1
      where template_id = l_template_id;*/
    elsif cycle = 'M' then

      l_next_run_date := TRUNC(add_months(p_last_start_date, 1), 'MONTH');
      /*          update templates_scheduler
        set repeat_interval = :new.cycle,
            next_run_date   = add_months(last_start_date, 1)
      where template_id = l_template_id;*/
    elsif cycle = 'Y' then
      l_next_run_date := add_months(p_last_start_date, 12);
      /*          update templates_scheduler
        set repeat_interval = :new.cycle,
            next_run_date   =  add_months(last_start_date, 12)
      where template_id = l_template_id;*/
    end if;

    return l_next_run_date;
  end;

  function fn_NumberFormat(p_number number) return varchar2 is
    l_number_formated varchar2(25);
  begin
    l_number_formated := ltrim(to_char(ROUND(p_number),
                                       '99G999G999G999G999'));
    return l_number_formated;
  exception
    when others then
      return to_char(p_number);
  end;

  PROCEDURE GenTemplate0329(p_template_id IN varchar2) is
    v_currdate   date;
    v_prevdate   date;
    v_msg        varchar2(4000);
    d            number;
    l_datasource varchar2(3000);
    v_mobile     varchar2(50);
  BEGIN
    Select to_date(varvalue, 'dd/mm/yyyy')
      into v_currdate
      From sysvar
     Where varname = 'CURRDATE'
       and grname = 'SYSTEM';
    Select to_date(varvalue, 'dd/mm/yyyy')
      into v_prevdate
      From sysvar
     Where varname = 'PREVDATE'
       and grname = 'SYSTEM';
    DELETE smsbeginday WHERE TXDATE = v_currdate;
    INSERT INTO smsbeginday
      (AUTOID,
       TXDATE,
       afacctno,
       custodycd,
       balance,
       acctno,
       symbol,
       codeid,
       trade)
      SELECT SEQ_smsbeginday.NEXTVAL AUTOID,
             V_currdate TXDATE,
             AF.ACCTNO AFACCTNO,
             CF.CUSTODYCD,
             CI.BALANCE,
             NVL(T1.ACCTNO, '') ACCTNO,
             NVL(T1.SYMBOL, '') SYMBOL,
             NVL(T1.CODEID, '') CODEID,
             NVL(T1.TRADE, 0) TRADE
        FROM CFMAST CF,
             AFMAST AF,
             CIMAST CI,
             (SELECT * FROM vw_mr9004_for_log) T1
       WHERE CF.CUSTID = AF.CUSTID
         AND AF.ACCTNO = CI.AFACCTNO
         AND AF.ACCTNO = T1.AFACCTNO(+);
    COMMIT;
    For vc in (Select s2.afacctno, s2.custodycd, s2.balance,s2.typename  --thuyct edit 29_12_2020
                 From (select s.afacctno, s.txdate, s.custodycd, s.balance,f.typename
                         from smsbeginday s,afmast af,aftype f
                        where s.txdate = v_prevdate
                             and s.afacctno=af.acctno
                             and af.actype=f.actype
                        group by s.afacctno, s.txdate, s.custodycd, s.balance,f.typename) s1,
                      (select s.afacctno, s.txdate, s.custodycd, s.balance,f.typename
                         from smsbeginday s,afmast af,aftype f
                        where s.txdate = v_currdate
                        and s.afacctno=af.acctno
                             and af.actype=f.actype
                        group by s.afacctno, s.txdate, s.custodycd, s.balance,f.typename) s2
                Where s2.afacctno = s1.afacctno(+)
                  and s2.balance <> nvl(s1.balance, -999)
               Union all
               Select s2.afacctno, s2.custodycd, s2.balance,s2.typename
                 From (select s.afacctno,
                              s.acctno,
                              s.txdate,
                              s.symbol,
                              s.trade,
                              s.custodycd,
                              s.balance,
                              f.typename
                         from smsbeginday s,afmast af,aftype f
                        where s.txdate = v_prevdate
                              and s.afacctno=af.acctno
                             and af.actype=f.actype
                          and s.acctno is not null) s1,
                      (select s.afacctno,
                              s.acctno,
                              s.txdate,
                              s.symbol,
                              s.trade,
                              s.custodycd,
                              s.balance,
                              f.typename
                         from smsbeginday s,afmast af,aftype f
                        where s.txdate = v_currdate
                              and s.afacctno=af.acctno
                             and af.actype=f.actype
                          and s.acctno is not null) s2
                Where s2.acctno = s1.acctno(+)
                  and s2.trade <> nvl(s1.trade, -999)) Loop
      v_mobile := '';
      For rec in (select fax1 from afmast where acctno = vc.afacctno) Loop
        v_mobile := rec.fax1;
      End loop;
      v_msg := 'KBSV ' || to_char(v_currdate, 'dd/mm/yyyy') ||
               '. TB So du TK ' || vc.custodycd ||                  --thuyct edit
               vc.typename || '. Tien co the GD:' || to_char(vc.balance) ||
               'VND.';
      -- Chung khoan: SHB 4000, PPC 2000';
      d := 0;
      For rec in (SELECT symbol, trade
                    from vw_mr9004_for_log
                   where afacctno = vc.afacctno
                     and trade > 0) Loop
        IF d = 0 then
          v_msg := v_msg || ' Chung khoan: ' || rec.symbol || ' ' ||
                   rec.trade;
        ELSE
          v_msg := v_msg || ', ' || rec.symbol || ' ' || rec.trade;
        end if;
        d := d + 1;
      End loop;
      l_datasource := 'SELECT ''' || V_MSG || ''' detail from dual';
      --dbms_output.put_line(v_msg);
      nmpks_ems.InsertEmailLog(v_mobile,
                               p_template_id,
                               l_datasource,
                               v_mobile);
    End loop;

  END; -- Procedure  smsbegindaylog
  procedure GenTemplate0333(p_ca_id varchar2) is
    l_datasourcesms varchar2(1000);
  begin
    --plog.setBeginSection(pkgctx, 'GenTemplate0333');
    For VC in (Select mst.camastid,
                      to_char(mst.duedate, 'dd/mm/yyyy') duedate,
                      mst.exprice,
                      s.symbol,
                      cf.custodycd,
                      sum(schd.pqtty) pqtty,
                      max(af.fax1) mobile
                 From camast       mst,
                      caschd       schd,
                      sbsecurities s,
                      afmast       af,
                      cfmast       cf
                Where mst.camastid = schd.camastid
                  and mst.codeid = s.codeid
                  and schd.afacctno = af.acctno
                  and af.custid = cf.custid
                  and schd.pqtty > 0
                  and mst.catype = '014'
                  and mst.camastid = p_ca_id and schd.deltd = 'N'
                GROUP BY mst.camastid,
                         mst.duedate,
                         mst.exprice,
                         s.symbol,
                         cf.custodycd,
                         schd.afacctno) Loop
      l_datasourcesms := 'select ''KBSV xin TB:TK' || VC.custodycd ||
                         ' duoc huong quyen mua ' || VC.pqtty || ' cp ' ||
                         VC.symbol || ' phat hanh them, gia ' || VC.exprice ||
                         ' d, Han dang ky va nop tien mua truoc ngay ' ||
                         VC.duedate || ''' detail from dual';
      IF LENGTH(VC.mobile) > 0 then
        nmpks_ems.InsertEmailLog(VC.mobile,
                                 '0333',
                                 l_datasourcesms,
                                 vc.custodycd);
      END IF;
    End loop;
    plog.setEndSection(pkgctx, 'GenTemplate0333');
  exception
    when others then
      null;
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate0333');
  end;

  --- Begin binhvt
  procedure GenTemplateSENDMG(p_ca_id varchar2) is
    l_acctno      varchar2(1000);
    l_data_source varchar2(5000);
    l_emailMG     varchar2(100);
    l_emailGDCN   varchar2(100);
    l_emailGDPCC  varchar2(100);
    l_tlid        varchar2(100);
    l_cusid       varchar2(20);
    l_email_cc    usert0limit.ccemail%type;
    l_emailcc     usert0limit.ccemail%type;
  begin
    plog.setBeginSection(pkgctx, 'GenTemplate2218');
    ---1 lay so tieu khoan va noi dung mail
    select s.acctno, s.msgbody
      into l_acctno, l_data_source
      from log_notify_event l, sendmsglog s
     where s.autoid = l.keyvalue
       and l.keyvalue = p_ca_id;
    -- 2 lay mail moi gioi cham soc tai khoan
    begin
      select tp.email, tp.tlid, substr(reff.reacctno, 0, 10)
        into l_emailMG, l_tlid, l_cusid
        from recflnk rec,
             tlprofiles tp,
             (select re.afacctno, max(cf.fullname) refullname, re.reacctno
                from reaflnk re, sysvar sys, cfmast cf, RETYPE
               where to_date(varvalue, 'DD/MM/RRRR') between re.frdate and
                     re.todate
                 and substr(re.reacctno, 0, 10) = cf.custid
                 and varname = 'CURRDATE'
                 and grname = 'SYSTEM'
                 and re.status <> 'C'
                 and re.deltd <> 'Y'
                 AND substr(re.reacctno, 11) = RETYPE.ACTYPE
                 AND rerole IN ('RM', 'BM')
               GROUP BY AFACCTNO, reacctno) reff
       where substr(reff.reacctno, 0, 10) = rec.custid
         and rec.reftlid = tp.tlid
         and reff.afacctno = l_acctno;

    exception
      when no_data_found then
        plog.error('Khong tim thay email cua moi gioi');
        l_emailMG := '';
    end;
    -- 3 lay email giam doc chi nhanh va quan tri rui ro
    l_emailGDCN := fn_get_emailmg(str_afacctno => l_acctno,
                                  str_type     => 'EMAILCN');
    l_email_cc  := fn_get_emailmg(str_afacctno => l_acctno,
                                  str_type     => 'EMAILNV');

    -- 4 lay email giam doc pcc
    l_emailGDPCC := fn_get_emailmg(str_afacctno => l_acctno,
                                   str_type     => 'EMAILPCC');

    if l_email_cc is not null and length(l_email_cc) > 0 then
      if l_emailGDCN is not null and length(l_emailGDCN) > 0 then
        l_emailcc := l_email_cc || ',' || l_emailGDCN;
        if l_emailGDPCC is not null and length(l_emailGDPCC) > 0 then
          l_emailcc := l_emailcc || ',' || l_emailGDPCC;
        end if;
      else
        if l_emailGDPCC is not null and length(l_emailGDPCC) > 0 then
          l_emailcc := l_email_cc || ',' || l_emailGDPCC;
        else
          l_emailcc := l_email_cc;

        end if;
      end if;

    end if;
    if (l_email_cc is null or length(l_email_cc) = 0) and
       (l_emailGDCN is not null and length(l_emailGDCN) > 0) and
       (l_emailGDPCC is not null and length(l_emailGDPCC) > 0) then
      l_emailcc := l_emailGDCN || ',' || l_emailGDPCC;
    end if;
    -- Neu chua co email moi gioi hoac chua khai bao email moi gioi thi gan bang email mac dinh
    if l_emailMG is null or length(l_emailMG) = 0 then
      l_emailMG := 'KBSV.MLRISK@kbsec.com.vn';
    end if;
    if (instr(l_data_source, 'T2218') > 0) then
      nmpks_ems.InsertEmailLogWithCc(p_email       => l_emailMG,
                                     p_email_cc    => l_emailcc,
                                     p_template_id => '2218',
                                     p_data_source => l_data_source,
                                     p_account     => l_acctno);

    elsif (instr(l_data_source, 'T2219') > 0) then
      nmpks_ems.InsertEmailLogWithCc(p_email       => l_emailMG,
                                     p_email_cc    => l_emailcc,
                                     p_template_id => '2219',
                                     p_data_source => l_data_source,
                                     p_account     => l_acctno);
    elsif (instr(l_data_source, 'T4084') > 0) then
      nmpks_ems.InsertEmailLogWithCc(p_email       => l_emailMG,
                                     p_email_cc    => l_emailcc,
                                     p_template_id => '4084',
                                     p_data_source => l_data_source,
                                     p_account     => l_acctno);
    elsif (instr(l_data_source, 'T4033') > 0) then
      nmpks_ems.InsertEmailLogWithCc(p_email       => l_emailMG,
                                     p_email_cc    => l_emailcc,
                                     p_template_id => '4033',
                                     p_data_source => l_data_source,
                                     p_account     => l_acctno);
    end if;
    plog.setEndSection(pkgctx, 'GenTemplate2218');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplate2218');
  end;

--  end binhvt
--begin 1.5.7.6
procedure GenTemplateEmailLimit(
  pv_autoid      VARCHAR2
) is
    l_custodycd      varchar2(10);
    l_data_source    varchar2(5000);
    l_emailMG        varchar2(100);
    l_emailGDCN      varchar2(100);
    l_emailQLCN      varchar2(1000);
    l_emailTPVN      varchar2(100);
    l_brname         varchar2(100);
    l_fullname       varchar2(100);
    l_refullname     VARCHAR2(100);
    l_acctno         VARCHAR2(10);
    p_custid         VARCHAR2(10);
    p_amt            NUMBER;
    p_advamt         NUMBER;
    p_balamt         NUMBER;
    p_sumadvamt      NUMBER;
    p_sumbalamt      NUMBER;
    p_sumamt         NUMBER;
    l_currdate       DATE;
    l_emailcc        VARCHAR2(4000);
    l_benefcustname  VARCHAR2(100);
    l_benefacct      VARCHAR2(20);
    p_readvance      NUMBER;
    p_retranfer      NUMBER;
    l_tlname         VARCHAR2(100);
    l_tlid           VARCHAR2(100);
    --1.8.1.4: iss 2336
    p_sumamt_ext     NUMBER;
  begin
    plog.setBeginSection(pkgctx, 'GenTemplateEmailLimit');

    SELECT getcurrdate INTO l_currdate FROM dual;
    --: 1.6.0.0: Lay them nguoi thu huong va tai khoan thu huong
    begin
      SELECT e.afacctno, e.amount, e.cashamt, e.advamt, e.curcashamt, e.curadvamt, e.curcashamt+ e.curadvamt, e.benefcustname,  e.benefacct, e.curcashamtext  ----1.8.1.4: iss 2336
      INTO l_acctno, p_amt, p_balamt, p_advamt, p_sumbalamt, p_sumadvamt, p_sumamt,l_benefcustname,l_benefacct,p_sumamt_ext
      FROM extranferreq e WHERE e.autoid = pv_autoid;
    EXCEPTION WHEN no_data_found THEN
      plog.setEndSection(pkgctx, 'GenTemplateEmailLimit');
      plog.error('Khong tim thay thong tin KH');
    END;
    -- lay thong tin KH
    BEGIN
      SELECT cf.custodycd, cf.fullname, cf.custid INTO l_custodycd, l_fullname, p_custid
      FROM cfmast cf, afmast af WHERE af.acctno = l_acctno AND af.custid = cf.custid;
    EXCEPTION WHEN no_data_found THEN
      plog.setEndSection(pkgctx, 'GenTemplateEmailLimit');
      plog.error('Khong tim thay thong tin KH');
    END;
    -- 1.6.0.0: lay thong tin nguoi kiem duyet va han muc con lai
    begin
       select a.tlid, a.tlname,a.readvancelimit,a.retotaltranlimit
        into l_tlid, l_tlname, p_readvance,p_retranfer
         from
               (select tl.tlid ,tl.tlname,tl.readvancelimit,tl.retotaltranlimit from tlemaillimit tl, cfmast cf, afmast af
               where tl.brid=cf.brid and cf.custid=af.custid and af.acctno=l_acctno
               and p_advamt <= tl.readvancelimit and p_balamt <= tl.retotaltranlimit
               order by tl.f_advancelimit)a where rownum = 1;

        update extranferreq e
        set e.aprvid=l_tlid
        WHERE e.autoid = pv_autoid;

      EXCEPTION WHEN no_data_found THEN
          plog.setEndSection(pkgctx, 'GenTemplateEmailLimit');
          plog.error('Khong lay duoc thong tin nguoi duyet');
    END;
    --end--

    begin
    --  1.6.0.0 sua cach lay mail GD - lay tu man hinh 020022
     select br.brname, e.mngemail, sys.varvalue, e.emplemail
     INTO l_brname, l_emailGDCN, l_emailTPVN, l_emailQLCN
         from  emaillimit e, sysvar sys, cfmast cf,brgrp br, afmast af
         where af.acctno=l_acctno and cf.custid= af.custid and cf.brid=br.brid
               and e.brid=cf.brid AND sys.grname = 'SYSTEM' AND sys.varname = 'MAIL_TPNV'
               and e.status = 'A' AND cf.status <> 'C';
    exception
      when no_data_found THEN
        plog.setEndSection(pkgctx, 'GenTemplateEmailLimit');
        plog.error('Chua khai bao email GD chi nhanh ');
        l_brname:='';
        l_emailGDCN:='';
        l_emailTPVN:='';
        l_emailQLCN:='';
    end;

    begin
     --1.6.0.8 MSBS-2142
     select c.* INTO l_refullname, l_emailMG  from
     (SELECT  tp.tlfullname, tp.email  FROM reaflnk re, recflnk rel, TLPROFILES tp, retype r
     where re.afacctno=l_acctno and re.refrecflnkid=rel.autoid and rel.reftlid=tp.tlid(+) AND substr(re.reacctno,11,4) = r.actype AND r.rerole = 'BM'
        and l_currdate between rel.effdate AND rel.expdate
        and l_currdate between re.frdate AND re.todate and re.status='A'
        ) c WHERE rownum = 1;
     --End 1.6.0.8 MSBS-2142
    exception when no_data_found THEN
        plog.setEndSection(pkgctx, 'GenTemplateEmailLimit');
        plog.error('Chua chua gan moi gioi');
        l_refullname:='';
        l_emailMG:='';
    end;

    IF l_emailMG IS NOT NULL THEN
      l_emailcc := l_emailMG ||',';
    END IF;
    IF l_emailTPVN IS NOT NULL THEN
      l_emailcc := l_emailcc || l_emailTPVN||',';
    END IF;
    IF l_emailQLCN IS NOT NULL THEN
      l_emailcc := l_emailcc || l_emailQLCN;
    END IF;

    l_data_source := 'select ''' || l_custodycd || ' - ' || l_fullname || ' - Tên MG '|| l_refullname ||''' custodycode, ''' ||
                        l_fullname || ''' fullname, ''' ||
                        l_refullname || ''' refullname, ''' ||
                        l_custodycd || ''' custody, ''' ||
                        l_tlname || ''' tlname, ''' ||
                        l_benefcustname || ''' benename, ''' ||
                        l_benefacct || ''' beneacctno, ''' ||
                        l_brname || ''' brname, ''' ||
                        trim(to_char(p_readvance,'999,999,999,999,999')) || ''' readvance, ''' ||
                        trim(to_char(p_retranfer,'999,999,999,999,999')) || ''' retranfer, ''' ||
                        trim(to_char(p_amt,'999,999,999,999,999')) || ''' amt, ''' ||
                        trim(to_char(p_advamt,'999,999,999,999,999')) || ''' advamt, ''' ||
                        trim(to_char(p_balamt,'999,999,999,999,999')) || ''' balamt, '''
                        || trim(to_char(p_sumadvamt,'999,999,999,999,999')) ||
                        ''' sumadvamt, ''' || trim(to_char(p_sumbalamt,'999,999,999,999,999')) || ''' sumbalamt, ''' ||
                        trim(to_char(p_sumamt,'999,999,999,999,999')) || ''' p_sumamt , ''' ||
                        trim(to_char(p_sumamt_ext,'999,999,999,999,999')) || ''' p_sumamt_ext from dual';  --1.8.1.4: iss2336

    InsertEmailLogWithCc(l_emailGDCN,l_emailcc, '0206', l_data_source, l_acctno);

    plog.setEndSection(pkgctx, 'GenTemplateEmailLimit');
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'GenTemplateEmailLimit');
  end;

--end 1.5.7.6
begin
  -- Initialization
  -- <Statement>;
  for i in (select * from tlogdebug) loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('NMPKS_EMS',
                      plevel     => nvl(logrow.loglevel, 30),
                      plogtable  => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert     => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace     => (nvl(logrow.log4trace, 'N') = 'Y'));
end NMPKS_EMS;
/
