CREATE OR REPLACE PACKAGE cspks_vsd as
  function fn_get_vsd_request(f_reqid in number) return varchar; --??c thông tin c?a yêu c?u dua thành XML thu vi?n
  procedure sp_auto_create_message; --Th? t?c t?o di?n MT t? d?ng
  procedure sp_message_tofile(f_msgcontent in varchar, f_reqid in number); --Th? t?c dua message t? Queue ra file
  procedure sp_create_message(f_reqid in number); --T?o XML message dua ra VSD Gateway
  procedure sp_receive_message(f_msgcontent in varchar); --Nh?n message
  procedure sp_parse_message(f_reqid in number); --X? l? XML message d?u vào
  procedure sp_auto_carightsubcription; --T? d?ng t?o yêu c?u dang k? quy?n mua
  procedure pr_opencustodyaccount(p_err_code in out varchar,
                                  --Ghi log m? tài kho?n luu k? c?a Core
                                  p_custodycd varchar, p_tellerid varchar,
                                  p_checkerid varchar, p_notes varchar);
  procedure pr_carightsubcription(p_err_code in out varchar,
                                  --T?o yêu c?u dang k? quy?n mua
                                  p_txdate varchar, p_txnum varchar);
  procedure pr_auto_process_message;
  procedure sp_auto_gen_vsd_req;
  procedure sp_gen_vsd_req(pv_autoid number);
  procedure auto_complete_confirm_msg(pv_reqid number, pv_cftltxcd varchar2,
                                      pv_vsdtrfid number);
  /*procedure sp_auto_complete_openaccount(pv_reqid number,
                                         pv_msgstatus varchar2);*/
  --procedure auto_call_txpks_0048(pv_reqid number, pv_vsdtrfid number);
  procedure auto_call_txpks_2246(pv_reqid number, pv_vsdtrfid number);
  procedure auto_call_txpks_2231(pv_reqid number, pv_vsdtrfid number);
  procedure auto_call_txpks_2294(pv_reqid number, pv_vsdtrfid number);
  procedure auto_call_txpks_2201(pv_reqid number, pv_vsdtrfid number);
  procedure auto_call_txpks_2266(pv_reqid number, pv_vsdtrfid number);
  procedure auto_call_txpks_2265(pv_reqid number, pv_vsdtrfid number);
  --procedure auto_call_txpks_8894(pv_reqid number, pv_vsdtrfid number);
  procedure auto_call_txpks_8816(pv_reqid number, pv_vsdtrfid number);
  procedure auto_call_txpks_8879(pv_reqid number, pv_vsdtrfid number);
  procedure auto_call_txpks_2248(pv_reqid number, pv_vsdtrfid number);
  --procedure auto_call_txpks_2249(pv_reqid number, pv_vsdtrfid number);
  --procedure auto_call_txpks_0059(pv_reqid number, pv_vsdtrfid number);
  procedure auto_call_txpks_2290(pv_reqid number, pv_vsdtrfid number);
  --procedure auto_call_txpks_3380(pv_reqid number, pv_vsdtrfid number);
  --procedure auto_call_txpks_2245(pv_reqid number, pv_vsdtrfid number);

  procedure auto_process_inf_message(pv_autoid number, pv_funcname varchar2,
                                     pv_autoconf varchar2, pv_reqid number);
  procedure auto_create_camast(pv_autoid number);
  PROCEDURE pr_receive_csv_by_xml(pv_filename IN VARCHAR2, pv_filecontent IN CLOB);
end cspks_vsd;
/
CREATE OR REPLACE PACKAGE BODY cspks_vsd as

  -- Private variable declarations
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;

  procedure sp_auto_carightsubcription as
    p_err_code varchar2(100);
    cursor v_cursor is
      select to_char(txdate, 'DD/MM/RRRR') vdate, txnum vtxnum
        from tllog
       where tltxcd = '3384'
         and to_char(txdate, 'DDMMRRRR') || txnum not in
             (select to_char(txdate, 'DDMMRRRR') || objkey
                from crbtxreq
               where trfcode = '500.INST//REGI.CORP');
    v_row v_cursor%rowtype;
  begin
    open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;
      --T?o message
      pr_carightsubcription(p_err_code, v_row.vdate, v_row.vtxnum);
    end loop;
  end sp_auto_carightsubcription;

  procedure pr_carightsubcription(p_err_code in out varchar,
                                  p_txdate varchar, p_txnum varchar) as
    v_txdate      date;
    v_trflogid    number;
    v_qtty        number;
    v_tltxcd      varchar2(4);
    v_codeid      varchar2(30);
    v_symbol      varchar2(30);
    v_board       varchar2(30);
    v_afacctno    varchar2(10);
    v_custodycd   varchar2(10);
    v_refcorpid   varchar2(60);
    v_camastid    varchar2(60);
    v_notes       varchar2(180);
    v_companyname varchar2(180);
  begin
    v_tltxcd := '3384';

    select to_date(varvalue, 'DD/MM/RRRR')
      into v_txdate
      from sysvar
     where grname = 'SYSTEM'
       and varname = 'CURRDATE';
    select seq_crbtxreq.nextval into v_trflogid from dual;

    select varvalue
      into v_companyname
      from sysvar
     where grname = 'SYSTEM'
       and varname = 'COMPANYNAME';

    select tltxcd into v_tltxcd from tllog where txnum = p_txnum;
    select cvalue
      into v_codeid
      from tllogfld
     where txnum = p_txnum
       and fldcd = '24';
    select cvalue
      into v_afacctno
      from tllogfld
     where txnum = p_txnum
       and fldcd = '03';
    select cvalue
      into v_custodycd
      from tllogfld
     where txnum = p_txnum
       and fldcd = '96';
    select cvalue
      into v_camastid
      from tllogfld
     where txnum = p_txnum
       and fldcd = '02';
    select nvalue
      into v_qtty
      from tllogfld
     where txnum = p_txnum
       and fldcd = '21';
    select cvalue
      into v_notes
      from tllogfld
     where txnum = p_txnum
       and fldcd = '30';

    select symbol into v_symbol from sbsecurities where codeid = v_codeid;
    select cdcontent refval
      into v_board
      from allcode a, sbsecurities b
     where a.cdtype = 'SE'
       and a.cdname = 'TRADEPLACE'
       and a.cdval = b.tradeplace
       and b.codeid = v_codeid;
   /* select refcorpid
      into v_refcorpid
      from camast
     where camastid = v_camastid;*/
     select ca.isincode
      into v_refcorpid
      from camast ca
     where camastid = v_camastid;

    --Ghi nh?n y?c?u
    insert into crbtxreq
      (reqid, objtype, objname, objkey, trfcode, refcode, txdate, afacctno,
       bankcode, bankacct, txamt, status, refval, reftxdate, reftxnum)
      select v_trflogid, 'T', v_tltxcd, p_txnum, '500.INST//REGI.CORP',
             v_refcorpid, v_txdate, v_custodycd, 'VSD', v_companyname,
             v_qtty, 'P', null, null, null
        from dual;

    insert into crbtxreqdtl
      (autoid, reqid, fldname, cval, nval)
      select seq_crbtxreqdtl.nextval, v_trflogid, 'CUSTODYCD', v_custodycd,
             0
        from dual;

    insert into crbtxreqdtl
      (autoid, reqid, fldname, cval, nval)
      select seq_crbtxreqdtl.nextval, v_trflogid, 'SYMBOL', v_symbol, 0
        from dual;

    insert into crbtxreqdtl
      (autoid, reqid, fldname, cval, nval)
      select seq_crbtxreqdtl.nextval, v_trflogid, 'QTTY', null, v_qtty
        from dual;

    insert into crbtxreqdtl
      (autoid, reqid, fldname, cval, nval)
      select seq_crbtxreqdtl.nextval, v_trflogid, 'BOARD', v_board, 0
        from dual;

    insert into crbtxreqdtl
      (autoid, reqid, fldname, cval, nval)
      select seq_crbtxreqdtl.nextval, v_trflogid, 'DESC', v_notes, 0
        from dual;

    insert into crbtxreqdtl
      (autoid, reqid, fldname, cval, nval)
      select seq_crbtxreqdtl.nextval, v_trflogid, 'REFCORPID', v_refcorpid,
             0
        from dual;

  end pr_carightsubcription;

  procedure pr_opencustodyaccount(p_err_code in out varchar,
                                  p_custodycd varchar, p_tellerid varchar,
                                  p_checkerid varchar, p_notes varchar) as
    v_txdate   date;
    v_trflogid number;
  begin
    select to_date(varvalue, 'DD/MM/RRRR')
      into v_txdate
      from sysvar
     where grname = 'SYSTEM'
       and varname = 'CURRDATE';
    select seq_crbtxreq.nextval into v_trflogid from dual;

    insert into crbtxreq
      (reqid, objtype, objname, objkey, trfcode, refcode, txdate, afacctno,
       bankcode, bankacct, txamt, status, refval, reftxdate, reftxnum)
      select v_trflogid, 'V', 'CFMAST', p_custodycd, '598.NEWM/AOPN', null,
             v_txdate, p_custodycd, 'VSD', p_custodycd, 0, 'P', null, null,
             null
        from dual;

    insert into crbtxreqdtl
      (autoid, reqid, fldname, cval, nval)
      select seq_crbtxreqdtl.nextval, v_trflogid, 'CUSTODYCD', p_custodycd,
             0
        from dual;

    insert into crbtxreqdtl
      (autoid, reqid, fldname, cval, nval)
      select seq_crbtxreqdtl.nextval, v_trflogid, 'NOTES', p_notes, 0
        from dual;

    insert into crbtxreqdtl
      (autoid, reqid, fldname, cval, nval)
      select seq_crbtxreqdtl.nextval, v_trflogid, 'TELLERID', p_tellerid, 0
        from dual;

    insert into crbtxreqdtl
      (autoid, reqid, fldname, cval, nval)
      select seq_crbtxreqdtl.nextval, v_trflogid, 'OFFID', p_checkerid, 0
        from dual;

    insert into crbtxreqdtl
      (autoid, reqid, fldname, cval, nval)
      select seq_crbtxreqdtl.nextval, v_trflogid, 'TXDATE',
             to_char(v_txdate, 'DD/MM/RRRR'), 0
        from dual;
  end pr_opencustodyaccount;

  procedure sp_receive_message(f_msgcontent in varchar) as
    v_trflogid number;
  begin
    plog.setbeginsection(pkgctx, 'sp_receive_message');
    --Ghi nhan Log
    select seq_vsdmsglog.nextval into v_trflogid from dual;
    insert into vsdmsglog
      (autoid, timecreated, timeprocess, status, msgbody)
      select v_trflogid, systimestamp, null, 'P', xmltype(f_msgcontent)
        from dual;
    --Parse message XML
    sp_parse_message(v_trflogid);

    plog.setendsection(pkgctx, 'sp_receive_message');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_receive_message');
  end sp_receive_message;

  procedure sp_parse_message(f_reqid in number) as
    v_funcname    varchar2(60);
    v_sender      varchar2(60);
    v_msgtype     varchar2(60);
    v_vsdmsgid    varchar2(60);
    v_referenceid varchar2(80);
    v_vsdfinfile  varchar2(60);
    v_errdesc     varchar2(1000);
    v_msgfields   varchar2(5000);
    v_msgbody     varchar2(5000);
    v_trflogid    number;
    v_count       number;
    v_autoconf    varchar2(1);
    l_count       number;
  begin
    plog.setbeginsection(pkgctx, 'sp_parse_message');
    select count(autoid)
      into v_count
      from vsdmsglog
     where autoid = f_reqid
       and status = 'P';
    if v_count > 0 then
      begin
        --Get message header information
        select x.msgbody.extract('//root/txcode/@funcname').getstringval(),
               x.msgbody.extract('//root/txcode/@sender').getstringval(),
               x.msgbody.extract('//root/txcode/@msgtype').getstringval(),
               x.msgbody.extract('//root/txcode/@msgid').getstringval(),
               x.msgbody.extract('//root/txcode/@referenceid')
               .getstringval(),
               x.msgbody.extract('//root/txcode/@finfile').getstringval(),
               x.msgbody.extract('/root/txcode/detail').getstringval(),
               x.msgbody.extract('/root/txcode/msgbody/message')
               .getstringval(),
               x.msgbody.extract('//root/txcode/@errdesc').getstringval()
          into v_funcname, v_sender, v_msgtype, v_vsdmsgid, v_referenceid,
               v_vsdfinfile, v_msgfields, v_msgbody, v_errdesc
          from vsdmsglog x
         where autoid = f_reqid;
        -- PhuongHT edit
        if instr(v_funcname, '.NAK') > 0 or instr(v_funcname, '.ACK') > 0 then

          begin
            select trf.autoconf
              into v_autoconf
              from vsdtrfcode trf, vsdtxreq req
             where req.reqid = v_referenceid
               and trf.trfcode = v_funcname
               and trf.status = 'Y'
               and trf.type in ('CFN')
               and req.objname = trf.reqtltxcd;

               update vsdtxreq set msgstatus = 'N', vsd_err_msg = v_errdesc
               where reqid = v_referenceid;
          exception
            when no_data_found then
              v_autoconf := 'Y';
          end;
        else
          select count(*)
            into l_count
            from vsdtrfcode
           where status = 'Y'
             and trfcode = v_funcname;
          if l_count = 1 then
            -- chi dung cho mot loai nghiep vu
            select autoconf
              into v_autoconf
              from vsdtrfcode
             where status = 'Y'
               and trfcode = v_funcname;
          elsif l_count = 2 then
            -- su dung chung cho hai nghiep vu: can link voi VSDTXREQ de biet loai yeu cau
            select trf.autoconf
              into v_autoconf
              from vsdtrfcode trf, vsdtxreq req
             where req.reqid = v_referenceid
               and trf.trfcode = v_funcname
               and trf.status = 'Y'
               and trf.type in ('CFO', 'CFN')
               and req.objname = trf.reqtltxcd;
          else
            -- chua dung den
            v_autoconf := 'N';
          end if;
        end if;
        -- end of PhuongHT edit

        --Write to VSDTRFLOG
        v_trflogid := seq_vsdtrflog.nextval;

        insert into vsdtrflog
          (autoid, sender, msgtype, funcname, refmsgid, referenceid,
           finfilename, timecreated, timeprocess, status, autoconf, errdesc)
          select v_trflogid, v_sender, v_msgtype, v_funcname, v_vsdmsgid,
                 v_referenceid, v_vsdfinfile, systimestamp, null, 'P',
                 v_autoconf, v_errdesc
            from dual;

        insert into vsdtrflogdtl
          (autoid, refautoid, fldname, fldval, caption)
          select seq_vsdtrflogdtl.nextval, v_trflogid, xt.fldname, xt.fldval,
                 xt.flddesc
            from (select * from vsdmsglog where autoid = f_reqid) mst,
                 xmltable('root/txcode/detail/field' passing mst.msgbody
                           columns fldname varchar2(200) path 'fldname',
                           fldval varchar2(200) path 'fldval',
                           flddesc varchar2(1000) path 'flddesc') xt;

        --Update status
        update vsdmsglog
           set status = 'A', timeprocess = systimestamp
         where autoid = f_reqid
           and status = 'P';
      end;
    end if;
    plog.setendsection(pkgctx, 'sp_parse_message');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_parse_message');
  end sp_parse_message;

  procedure sp_auto_create_message as
    v_trflogid number;
    cursor v_cursor is
      select reqid
        from vsdtxreq
       where status = 'P'
            --and adtxprocess = 'N'
         and trfcode in (select trfcode
                           from vsdtrfcode
                          where status = 'Y'
                            and type IN ('REQ','EXREQ'));
    v_row v_cursor%rowtype;
  begin

    open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;

      --Create message
      sp_create_message(v_row.reqid);
    end loop;
  end sp_auto_create_message;

  procedure sp_message_tofile(f_msgcontent in varchar, f_reqid in number) as
    v_filename varchar2(100);
    l_line     varchar2(255);
    l_done     number;
    l_file     utl_file.file_type;
  begin
    --Send to VSD Gateway
    v_filename := f_reqid || '.xml';
    l_file     := utl_file.fopen('DIR_VSD_OUTPUT', v_filename, 'A');
    loop
      exit when l_done = 1;
      dbms_output.get_line(l_line, l_done);
      utl_file.put_line(l_file, f_msgcontent);
    end loop;
    utl_file.fflush(l_file);
    utl_file.fclose(l_file);
  end sp_message_tofile;

  procedure sp_create_message(f_reqid in number) as
    v_request   varchar2(5000);
    v_count     number;
    l_sqlerrnum varchar2(200);
  begin
    --Neu message da tao hoac khoi luong bang 0 (ngoai tru msg mo tai khoan th?o tao message)
    select count(*)
      into v_count
      from vsdtxreq
     where reqid = f_reqid
       and msgstatus = 'P'
       and (case
             when trfcode in ('598.NEWM/AOPN', '598.NEWM/ACLS', '598.NEWM.ACCT//TBAC', '598.NEWM.ACCT//TWAC') then
              1
             else
              nvl(txamt, 0)
           end) > 0;

    if v_count = 0 then
      return;
    end if;

    --Get message
    v_request := fn_get_vsd_request(f_reqid);

    --Enqueue
    --sp_message_tofile(v_request, f_reqid);
    cspks_esb.sp_set_message_queue(v_request, 'txaqs_flex2vsd');

    insert into vsdmsgfromflex
      (reqid, msgbody, status)
    values
      (f_reqid, v_request, 'P');

    --Update status
    update vsdtxreq
       set status = 'S', msgstatus = 'S' --, adtxprocess = 'Y'
     where reqid = f_reqid
       and status = 'P';

  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'sp_create_message', l_sqlerrnum);
  end sp_create_message;

  function fn_get_vsd_request(f_reqid in number) return varchar as
    v_trfcode varchar2(60);
    v_sympend char(1);
    v_refval  varchar2(4000);
    v_field   varchar2(1180);
    v_request varchar2(4000);
    cursor v_cursor is
      select fldname,
             (case
               when (nval <> 0) then
                to_char(nval)
               else
                translate(cval,'A$','A')
             end) fldval, XMLElement("fldval",(case
               when (nval <> 0) then
                to_char(nval)
               else
                translate(cval,'A$','A')
             end)).getstringval() xmlval
        from vsdtxreqdtl
       where reqid = f_reqid;
    v_row v_cursor%rowtype;
  begin
    plog.setbeginsection(pkgctx, 'fn_get_vsd_request');
    --read header
    select trfcode into v_trfcode from vsdtxreq where reqid = f_reqid;
    v_sympend := 'N';
    --read body
    open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;
      if v_row.fldname = 'SYMBOL' then
        begin
          v_field := '<field><fldname convert="">' || v_row.fldname ||
                     '</fldname><fldval>' ||
                     replace(v_row.fldval, '_WFT', '') ||
                     '</fldval></field>';
          select nvl(codeid, '')
            into v_refval
            from sbsecurities
           where symbol = v_row.fldval;
          v_field := v_field ||
                     '<field><fldname>REFCORPID</fldname><fldval>' ||
                     v_refval || '</fldval></field>';
          if (instr(v_row.fldval, '_WFT') > 0) then
            v_sympend := 'Y';
          end if;
        end;
      else
        if (instr(v_row.fldname, 'DATE') > 0) then
          begin
            --Convert date value
            select to_char(to_date(v_row.fldval, 'DD/MM/RRRR'), 'YYYYMMDD')
              into v_refval
              from dual;
            v_field := '<field><fldname convert="">' || v_row.fldname ||
                       '</fldname><fldval>' || v_refval ||
                       '</fldval></field>';
          end;
        else
          if instr(v_row.fldname, 'FULLNAME') > 0 or
             instr(v_row.fldname, 'ADDRESS') > 0 or
             instr(v_row.fldname, 'NOTES') > 0 or
             instr(v_row.fldname, 'DESC') > 0 or
             instr(v_row.fldname, 'IDPLACE') > 0 or
             instr(v_row.fldname, 'IDCODE') > 0 then
            v_field := '<field><fldname convert="F">' || v_row.fldname ||
                       '</fldname>' || v_row.xmlval ||

                       '</field>';

          else
            v_field := '<field><fldname convert="">' || v_row.fldname ||
                       '</fldname>' || v_row.xmlval ||

                       '</field>';
          end if;
        end if;
      end if;
      v_request := v_request || v_field;
    end loop;
    v_request := v_request ||
                 '<field><fldname convert="">REQID</fldname><fldval>' ||
                 f_reqid || '</fldval></field>';
    if (v_sympend = 'Y' and v_trfcode = '500.INST//REGI.NORM') then
      return '<root><txcode funcname="500.INST//REGI.PEND" referenceid="' || f_reqid || '"><detail>' || v_request || '</detail></txcode></root>';
    else
      return '<root><txcode funcname="' || v_trfcode || '" referenceid="' || f_reqid || '"><detail>' || v_request || '</detail></txcode></root>';
    end if;
    plog.setendsection(pkgctx, 'fn_get_vsd_request');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_get_vsd_request');
      return '';
  end fn_get_vsd_request;

  procedure pr_auto_process_message
  --Process message receved VSD
   is
    l_sqlerrnum  varchar2(200);
    l_count      integer;
    l_vsdmode    varchar2(20);
    l_msgacct    varchar2(50);
    l_status     varchar2(10);
    l_cf_tltxcd  varchar2(10);
    l_cf_msgtype varchar2(5);
    l_reject_msg varchar2(500);
    l_req_tltxcd varchar2(10);
    v_tltxcd     varchar2(4);
    v_dt_txdate  date;
    v_reqid      number;
    v_HOSTATUS   VARCHAR2(1);
  begin
    /*   IF NOT fopks_api.fn_is_ho_active THEN
        RETURN;
    END IF;*/
    plog.setbeginsection(pkgctx, 'pr_auto_process_message');
    l_vsdmode   := cspks_system.fn_get_sysvar('SYSTEM', 'VSDMOD');
    l_cf_tltxcd := 'b';
    -- IF l_vsdmode <>'A' THEN-- khong ket noi
    -- RETURN;
    -- ELSE-- ket noi
    -- DungDT: Check host & branch active or inactive
    SELECT VARVALUE
    INTO v_HOSTATUS
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'HOSTATUS';
    -- DUNGDT: NEU HOI SO DONG CUA THI KO XU LY DIEN NHAN VE TU VSD
    IF v_HOSTATUS = '0' THEN
        plog.error(pkgctx, 'Error: dong cua hoi so' );
        plog.setendsection(pkgctx, 'pr_auto_process_message');
        return;
    END IF;

    --Duyet bang VSDTRFLOG
    for rec in (select * from vsdtrflog where status = 'P' order by autoid) loop
      select count(*)
        into l_count
        from vsdtxreq
       where reqid = rec.referenceid;
       
      l_cf_tltxcd := 'b';
      
      if l_count > 0 and rec.autoconf = 'Y' then
        begin
          select log.msgacct
            into l_msgacct
            from vsdtxreq req, vsd_process_log log
           where req.reqid = rec.referenceid
             and req.process_id = log.autoid;
        exception
          when others then
            l_msgacct := '';
        end;
        if instr(rec.funcname, '.ACK') > 0 then
          -- ACK
          if rec.funcname = '598.001.ACCT//AOPN.ACK' then
            --ACK Mo tk
            update cfmast set nsdstatus = 'A' where custodycd = l_msgacct;
          elsif rec.funcname = '598.001.ACCT//ACLS.ACK' then
            --ACK dong tk
            update cfmast set nsdstatus = 'A' where custid = l_msgacct;
          end if;
          plog.error (pkgctx, 'VAO2');
          update vsdtxreq
             set msgstatus = 'A', vsd_err_msg = rec.errdesc
           where reqid = rec.referenceid;
          update vsdtrflog set status = 'A' where autoid = rec.autoid;
          commit;
        elsif instr(rec.funcname, '.NAK') > 0 then
          -- NAK
          if rec.funcname = '598.001.ACCT//AOPN.NAK' then
            --NAK Mo tk
            update cfmast
            set    nsdstatus = 'R',
                   activests = 'N'
            where custodycd = l_msgacct;
          elsif rec.funcname = '598.001.ACCT//ACLS.NAK' then
            --NAK Mo tk
            update cfmast
            set nsdstatus = 'R',
                status = 'A'
            where custid = l_msgacct;
          end if;

          --Revert NAK bussiness
          begin
            select tltxcd
              into l_cf_tltxcd
              from vsdtrfcode
             where trfcode = rec.funcname
               and type = 'CFN'
               and status = 'Y';
/*            auto_complete_confirm_msg(rec.referenceid,
                                      l_cf_tltxcd,
                                      rec.autoid);*/
          exception
            when no_data_found then
              plog.warn(pkgctx, 'Dont have processing defined!');
            when others then
              plog.error(pkgctx,
                         sqlerrm || dbms_utility.format_error_backtrace);

          end;
          --swprocess -- P: pending, N nack, A ask
          --msgstatus: P pending, R reject, E error, C complete
          update vsdtxreq
             set msgstatus = 'N', status = 'R', vsd_err_msg = rec.errdesc
           where reqid = rec.referenceid;
          update vsdtrflog set status = 'A' where autoid = rec.autoid;
          --commit;
        elsif (rec.funcname = '598.002.ACCT//AOPN' or
              rec.funcname = '598.002.ACCT//ACLS') then
          -- Confirm Mo tk
          begin
            select fldval
              into l_status
              from vsdtrflogdtl
             where refautoid = rec.autoid
               and fldname = 'STATUS';
            l_cf_tltxcd := '0048';
            if l_status = 'PACK' then
              ---Dong y
              update vsdtxreq
                 set msgstatus = 'F'
               where reqid = rec.referenceid;
              update vsdtrflog set status = 'A' where autoid = rec.autoid;

              plog.debug(pkgctx, rec.referenceid || ' accepted');
              if (rec.funcname = '598.002.ACCT//ACLS') then
                update cfmast
                   set status = 'C', nsdstatus = 'K'
                 where custid = l_msgacct;
              elsif (rec.funcname = '598.002.ACCT//AOPN') then
                update cfmast
                   set nsdstatus = 'C', activests = 'Y'
                 where custodycd = l_msgacct;
              end if;
            else
              --Tu choi
              begin
                select fldval
                  into l_reject_msg
                  from vsdtrflogdtl
                 where refautoid = rec.autoid
                   and fldname = 'NOTES';
              exception
                when no_data_found then
                  l_reject_msg := 'NO EXISTS FIELD 70D';
              end;

              update vsdtxreq
                 set msgstatus = 'R', vsd_err_msg = l_reject_msg
               where reqid = rec.referenceid;

              update vsdtrflog set status = 'A' where autoid = rec.autoid;

              plog.debug(pkgctx,
                         rec.referenceid || ' rejected with reason: ' ||
                         l_reject_msg);

              if (rec.funcname = '598.002.ACCT//ACLS') then
                update cfmast
                set nsdstatus = 'R',
                    status = 'A'
                where custid = l_msgacct;
              elsif (rec.funcname = '598.002.ACCT//AOPN') then
                update cfmast
                   set nsdstatus = 'R', activests = 'N'
                 where custodycd = l_msgacct;
              end if;

            end if;
          exception
            when no_data_found then
              update vsdtxreq
                 set msgstatus = 'R'
               where reqid = rec.referenceid;
              update vsdtrflog set status = 'A' where autoid = rec.autoid;
          end;
        else
          -- confirm cua cac loai khac co phan biet duoc tu choi va thanh cong
          /*    SELECT COUNT(*) INTO L_COUNT FROM VSDTRFCODE
          WHERE STATUS='Y' AND TYPE IN ('CFO','CFN') AND TRFCODE=REC.FUNCNAME;*/
          select count(*)
            into l_count
            from vsdtrfcode trf, vsdtxreq req
           where req.reqid = rec.referenceid
             and trf.trfcode = rec.funcname
             and trf.status = 'Y'
             and trf.type in ('CFO', 'CFN', 'INF')
             and nvl(req.objname, 'a') = nvl(trf.reqtltxcd, 'a');
          if l_count = 1 THEN
            select trf.type, nvl(trf.tltxcd, 'a'), trf.reqtltxcd
              into l_cf_msgtype, l_cf_tltxcd, l_req_tltxcd
              from vsdtrfcode trf, vsdtxreq req
             where req.reqid = rec.referenceid
               and trf.trfcode = rec.funcname
               and trf.status = 'Y'
               and trf.type in ('CFO', 'CFN', 'INF')
               and nvl(req.objname, 'a') = nvl(trf.reqtltxcd, 'a');
            if l_cf_msgtype = 'CFO' THEN
              plog.ERROR(pkgctx, 'VAO CF0: ' );
              -- dong y
              update vsdtxreq
                 set msgstatus = 'C'
               where reqid = rec.referenceid;
              update vsdtrflog set status = 'A' where autoid = rec.autoid;
            elsif l_cf_msgtype = 'CFN' THEN
              --plog.ERROR(pkgctx, 'VAO CFN: ' || rec.autoid);
              -- tu choi
                l_reject_msg := ' ';
                           for v_ref in(select fldval
                                       from vsdtrflogdtl
                                      where refautoid = rec.autoid
                                      and fldname = 'REAS') loop
                                l_reject_msg :=  v_ref.fldval;
                           end loop;
              update vsdtxreq
                 set msgstatus = 'R',vsd_err_msg = l_reject_msg
               where reqid = rec.referenceid;
              update vsdtrflog set status = 'A' where autoid = rec.autoid;
            elsif l_cf_msgtype = 'INF' then
              -- thong tin
              auto_process_inf_message(rec.autoid,
                                       rec.funcname,
                                       rec.autoconf,
                                       rec.referenceid);
            end if;

          end if;
        end if;
        -- xu ly thanh cong cho tung nghiep vu rieng
        if l_cf_tltxcd <> 'a' and l_cf_tltxcd <> 'b' then
        --plog.ERROR(pkgctx, 'VAO XU LY GD: ' || l_cf_tltxcd);
          auto_complete_confirm_msg(rec.referenceid,
                                    l_cf_tltxcd,
                                    rec.autoid);
        elsif l_cf_tltxcd = 'a' then
          -- message khong can giao dich CONF-> xu ly luon thanh complete
          update vsdtxreq
             set status = 'C', msgstatus = 'F' -- boprocess = 'Y'
           where reqid = rec.referenceid;
          update vsdtrflog
             set status = 'C', timeprocess = systimestamp
           where autoid = rec.autoid;
        elsif l_cf_tltxcd <> 'b' THEN -- hotfix 27/01/2020
             -- xu ly cac msg INF da sinh VSDTXREQ va da duoc duyet
          auto_process_inf_message(rec.autoid,
                                   rec.funcname,
                                   rec.autoconf,
                                   rec.referenceid);
        end if;
      elsif l_count = 0 then
        -- xu ly cho cac msg INF moi ve va chua sinh VSDTXREQ
        select count(*)
          into l_count
          from vsdtrfcode
         where status = 'Y'
           and type = 'INF'
           and trfcode = rec.funcname;
        if l_count > 0 then
          -- UPDATE VSDTRFLOG SET STATUS='A' WHERE autoid = rec.autoid;
          select tltxcd
            into v_tltxcd
            from vsdtrfcode
           where type = 'INF'
             and status = 'Y'
             and trfcode = rec.funcname;
          v_dt_txdate := getcurrdate;
          v_reqid     := seq_vsdtxreq.nextval;
          -- sinh du lieu vao bang request
          insert into vsdtxreq
            (reqid, objtype, objname, objkey, trfcode, refcode, txdate,
             affectdate, afacctno, txamt, bankcode, bankacct, msgstatus,
             notes, /*swprocess, boprocess, adtxprocess,*/ rqtype, status,
             msgacct, process_id, brid, tlid)
          values
            (v_reqid, 'T', v_tltxcd, '', rec.funcname, null, v_dt_txdate,
             v_dt_txdate, null, 0, 'VSD',
             cspks_system.fn_get_sysvar('SYSTEM', 'COMPANYNAME'), 'C',
             utf8nums.c_const_DESC_VSD2245, /*'P', 'N', 'N',*/ 'A', 'P', null,
             null, '0000', '0000');
          -- cap nhat referenceid trong bang VSDTRFLOG
          update vsdtrflog
             set referenceid = v_reqid
           where autoid = rec.autoid;
          auto_process_inf_message(rec.autoid,
                                   rec.funcname,
                                   rec.autoconf,
                                   v_reqid);
          if nvl(v_tltxcd, 'a') = 'a' then
            -- message khong can giao dich CONF-> xu ly luon thanh complete
            update vsdtxreq
               set status = 'C', msgstatus = 'F' --boprocess = 'Y'
             where reqid = v_reqid;
            update vsdtrflog
               set status = 'C', timeprocess = systimestamp
             where autoid = rec.autoid;
          end if;
        end if;
      end if;
    end loop;
    -- END IF;
    plog.setendsection(pkgctx, 'pr_auto_process_message');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'pr_auto_process_message');
  end pr_auto_process_message;

  --purpose: tu sinh request day vao VSDTXREQ
  procedure sp_auto_gen_vsd_req as
    v_trflogid number;
    cursor v_cursor is
      select autoid
        from vsd_process_log
       where process = 'N'
         and trfcode in (select trfcode
                           from vsdtrfcode
                          where status = 'Y'
                            and type IN ('REQ','EXREQ'));
    v_row v_cursor%rowtype;
  begin
    plog.setbeginsection(pkgctx, 'sp_auto_gen_vsd_req');
    --Sinh request vao vsdtxreq
    open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;

      --sinh vao VSDTXREQ, vsdtxreqdtl
      sp_gen_vsd_req(v_row.autoid);

      update vsd_process_log set process = 'Y' where autoid = v_row.autoid;
    end loop;

    -- goi ham tu dong gen message day len VSD
    sp_auto_create_message;
    plog.setendsection(pkgctx, 'sp_auto_gen_vsd_req');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_auto_gen_vsd_req');
  end sp_auto_gen_vsd_req;

  procedure sp_gen_vsd_req(pv_autoid number) as
    type v_curtyp is ref cursor;
    v_trfcode          varchar2(100);
    v_tltxcd           varchar2(50);
    v_txnum            varchar2(10);
    v_custid           varchar2(10);
    l_vsdmode          varchar2(10);
    l_vsdtxreq         number;
    v_dt_txdate        date;
    v_notes            varchar2(1000);
    v_afacctno_field   varchar2(100);
    v_afacctno         varchar2(10);
    v_txamt_field      varchar2(100);
    v_txamt            number(20, 4);
    v_custodycd        varchar2(10);
    v_value            varchar2(1000);
    v_chartxdate       varchar2(50);
    v_extcmdsql        varchar2(2000);
    v_notes_field      varchar2(10);
    v_msgacct_field    varchar2(10);
    v_msgacct          varchar2(30);
    c0                 v_curtyp;
    l_sqlerrnum        varchar2(200);
    v_log_msgacct      varchar2(50);
    v_fldrefcode_field varchar2(50);
    v_refcode          varchar2(100);
    v_brid             varchar2(4);
    v_tlid             varchar2(4);
    l_vsdbiccode       varchar2(11);
    l_biccode          varchar2(11);
    l_count2247        number;
    l_custodycd2247    varchar2(10);
    l_count2255        number;
    l_custodycd2255    varchar2(10);
    l_count_vsdrxreq     NUMBER;
    l_count_vsdtxreq2255 NUMBER;
    l_vsdmessage_type    VARCHAR2(10);
    l_sendtovsd0059      VARCHAR2(1);
  begin
    plog.setbeginsection(pkgctx, 'sp_gen_vsd_req');
    l_vsdmode := cspks_system.fn_get_sysvar('SYSTEM', 'VSDMOD');
    /*INSERT INTO log_err(id, date_log, position, text)
            VALUES(seq_log_err.nextval, sysdate, 'SP_GEN_VSD_REQ 001:',l_vsdmode);
            COMMIT;
    */

    select trfcode, tltxcd, txnum, txdate, msgacct, brid, tlid
      into v_trfcode, v_tltxcd, v_txnum, v_dt_txdate, v_log_msgacct, v_brid,
           v_tlid
      from vsd_process_log
     where autoid = pv_autoid;

     if v_tltxcd = '2247' then

    plog.debug(pkgctx, 'auto id::' || pv_autoid || '-txnum::' || v_txnum );

      begin
        select cf.custodycd
          into l_custodycd2247
          from vsd_process_log vsd, afmast af, cfmast cf
         where vsd.msgacct = v_log_msgacct
           and af.custid = cf.custid
           and af.acctno = substr(v_log_msgacct, 0, 10)
           AND rownum = 1;
      exception
        when no_data_found then
          plog.warn(pkgctx,
                    'ACCTNO:' || v_log_msgacct ||
                    ':: not found in vsd_process_log');
          plog.setendsection(pkgctx, 'sp_gen_vsd_req');
          l_custodycd2247 := '';
      end;

    -- Kiem tra xem da lam het giao dich 2247
      select count(*)
        into l_count2247
        from v_se2247
       where custodycd = l_custodycd2247;

    -- Kiem tra xem da sinh dien Tat toan chua
       SELECT COUNT(*) INTO l_count_vsdrxreq
       FROM vsdtxreq vsd, cfmast cf, afmast af
           WHERE cf.custid = af.custid
           AND af.acctno = vsd.afacctno
           AND vsd.objname = '2247'
           AND cf.custodycd = l_custodycd2247
           AND vsd.msgstatus IN ('S','A','C','F','H','J','K');

      if l_count2247 > 0 OR l_count_vsdrxreq >0 then
        -- chi sinh 1 dien khi lam 2247
        plog.warn(pkgctx,
                  'Chi sinh 1 dien khi lam gd 2247 msgacct:' ||
                  v_log_msgacct);
        plog.setendsection(pkgctx, 'sp_gen_vsd_req');
        return;
      end if;
    end if;
    if v_tltxcd = '0059' THEN
      plog.debug(pkgctx, 'auto id::' || pv_autoid || '-txnum::' || v_txnum );
      SELECT cvalue INTO l_sendtovsd0059
      FROM tllogfld
      WHERE txnum = v_txnum
      AND fldcd = '99';

      --Check co sinh dien hay khong
      IF l_sendtovsd0059 <> 'Y' THEN
        plog.warn(pkgctx,'Khong sinh dien 0059');
        plog.setendsection(pkgctx, 'sp_gen_vsd_req');
        return;
        END IF;
    END IF;

    select biccode, vsdbiccode
      into l_biccode, l_vsdbiccode
      from vsdbiccode
     where brid = v_brid;

    if l_vsdmode = 'A' then
      -- ket noi tu dong
      v_chartxdate := to_char(v_dt_txdate, 'DD/MM/RRRR');

      -- lay du lieu trong vsdtxmap
      BEGIN
        IF v_tltxcd = '2255' THEN
          BEGIN
            SELECT cvalue INTO l_vsdmessage_type
            FROM tllogfld
            WHERE txnum = v_txnum
            AND fldcd = 97;
            --DungDT:Kiem tra loai dien gui VSD
            IF l_vsdmessage_type = 0
              THEN
                plog.warn(pkgctx,
                    'Khong sinh dien gui VSD');
                 plog.setendsection(pkgctx, 'sp_gen_vsd_req');
                RETURN;
            ELSIF instr(v_trfcode, l_vsdmessage_type) = 0 THEN
              plog.warn(pkgctx,
                    'trfcode: '||v_trfcode||'message type:'||l_vsdmessage_type||'Khong sinh dien gui VSD');
                 plog.setendsection(pkgctx, 'sp_gen_vsd_req');
                RETURN;
              END IF;

              --Kiem tra dien tat toan
              IF l_vsdmessage_type = 598 THEN
                plog.debug(pkgctx, 'auto id::' || pv_autoid || '-txnum::' || v_txnum || 'tltxcd: 2255 - 598');

              begin
                select cf.custodycd
                into l_custodycd2255
                from vsd_process_log vsd, afmast af, cfmast cf
                where vsd.msgacct = v_log_msgacct
                      and af.custid = cf.custid
                      and af.acctno = substr(v_log_msgacct, 0, 10)
                      AND rownum = 1;
                exception
                      when no_data_found then
                      plog.warn(pkgctx,'ACCTNO:' || v_log_msgacct ||
                    ':: not found in vsd_process_log');
                    plog.setendsection(pkgctx, 'sp_gen_vsd_req');
                    l_custodycd2255 := '';
               end;

               -- Kiem tra xem da lam het giao dich 2255
               SELECT COUNT(*) INTO l_count2255
               FROM SESENDOUT SEO, CFMAST CF, AFMAST AF
               WHERE SUBSTR(SEO.ACCTNO,0,10)=AF.ACCTNO
               AND AF.CUSTID=CF.CUSTID
               and seo.trade + seo.blocked + seo.caqtty + seo.rightoffqtty + seo.caqttyreceiv + seo.caqttydb + seo.caamtreceiv + seo.rightqtty > 0
               and deltd ='N'
               AND cf.custodycd = l_custodycd2255
               AND seo.vsdmessagetype = '598';

               SELECT COUNT(*) INTO l_count_vsdtxreq2255
               FROM vsdtxreq
               WHERE msgacct = v_log_msgacct
               AND trfcode = '598.NEWM.ACCT//TWAC'
               AND msgstatus IN ('P','S','A');

               if l_count2255 > 0 or l_count_vsdtxreq2255 > 0 then
               -- chi sinh dien tat toan sau khi lam xong giao dich tat toan 2255 cuoi cung
               plog.warn(pkgctx,
                  'Chi sinh 1 dien khi lam gd 2255 msgacct:' ||
                  v_log_msgacct);
                  plog.setendsection(pkgctx, 'sp_gen_vsd_req');
                  return;
                  end if;
                END IF;
              END;
         END if;


        select map.fldacctno, map.amtexp, map.fldnotes,
               nvl(map.fldrefcode, 'a')
          into v_afacctno_field, v_txamt_field, v_notes_field,
               v_fldrefcode_field
          from vsdtxmap map
         where map.objname = v_tltxcd
           and map.trfcode = v_trfcode;
      exception
        when no_data_found then
          plog.warn(pkgctx,
                    'TLTXCD:' || v_tltxcd || '::TRFCODE:' || v_trfcode ||
                    ':: not found in VSDTXMAP');
          plog.setendsection(pkgctx, 'sp_gen_vsd_req');
          return;
      end;

      v_txamt := fn_eval_amtexp(v_txnum, v_chartxdate, v_txamt_field);

      if v_txamt = 0 and v_trfcode <> '598.NEWM/AOPN' and
         v_trfcode <> '598.NEWM/ACLS' and
         v_trfcode <> '598.NEWM.ACCT//TBAC' AND
         v_trfcode <> '598.NEWM.ACCT//TWAC'
          then
        -- neu so luong bang 0, khong sinh request len VSD
        plog.warn(pkgctx,
                  'txnum:' || v_txnum || '::txdate:' || v_chartxdate ||
                  '::txamt_field:' || v_txamt_field || '::txamt = ' ||
                  v_txamt || ':: not gen msg request to VSD');
        plog.setendsection(pkgctx, 'sp_gen_vsd_req');
        return;
      end if;
      v_afacctno := fn_eval_amtexp(v_txnum, v_chartxdate, v_afacctno_field);
      v_txamt    := fn_eval_amtexp(v_txnum, v_chartxdate, v_txamt_field);
      v_notes    := fn_eval_amtexp(v_txnum, v_chartxdate, v_notes_field);
      if v_fldrefcode_field = 'a' then
        v_refcode := v_chartxdate || v_txnum;
      else
        v_refcode := fn_eval_amtexp(v_txnum,
                                    v_chartxdate,
                                    v_fldrefcode_field);
      end if;

      -- insert vao VSDTXREQ\
      select seq_vsdtxreq.nextval into l_vsdtxreq from dual;
      insert into vsdtxreq
        (reqid, objtype, objname, objkey, trfcode, refcode, txdate,
         affectdate, afacctno, txamt, bankcode, bankacct, msgstatus, notes,
         /*swprocess, boprocess, adtxprocess,*/ rqtype, status, msgacct,
         process_id, brid, tlid)
      values
        (l_vsdtxreq, 'T', v_tltxcd, v_txnum, v_trfcode, v_refcode,
         v_dt_txdate, v_dt_txdate, v_afacctno, v_txamt, 'VSD',
         cspks_system.fn_get_sysvar('SYSTEM', 'COMPANYNAME'), 'P', v_notes,
         /*'P', 'N', 'N',*/ 'A', 'P', v_log_msgacct, pv_autoid, v_brid,
         v_tlid);

      -- insert vao VSDTXREQDTL
      -- Header
      -- Biccode
      insert into vsdtxreqdtl
        (autoid, reqid, fldname, cval, nval)
      values
        (seq_crbtxreqdtl.nextval, l_vsdtxreq, 'BICCODE', l_biccode, 0);
      -- VSD Biccode
      insert into vsdtxreqdtl
        (autoid, reqid, fldname, cval, nval)
      values
        (seq_crbtxreqdtl.nextval, l_vsdtxreq, 'VSDCODE', l_vsdbiccode, 0);

      -- Detail
      plog.debug(pkgctx,
                 'tltxcd:' || v_tltxcd || '::trfcode:' || v_trfcode);
      for rc in (select fldname, fldtype, amtexp, cmdsql
                   from vsdtxmapext mst
                  where mst.objtype = 'T'
                    and mst.objname = v_tltxcd
                    and trfcode = v_trfcode) loop
        begin

          if not rc.amtexp is null then
            v_value := fn_eval_amtexp(v_txnum, v_chartxdate, rc.amtexp);
            plog.debug(pkgctx,
                       'txnum:' || v_txnum || '::txdate:' || v_chartxdate ||
                       '::value:' || v_value);
          end if;
          if not rc.cmdsql is null then
            begin
              v_extcmdsql := replace(rc.cmdsql, '<$FILTERID>', v_value);
              begin
                open c0 for v_extcmdsql;
                fetch c0
                  into v_value;
                close c0;

                plog.debug(pkgctx,
                           'cmdsql:' || v_extcmdsql || '::value:' ||
                           v_value);

              exception
                when others then
                  v_value := '0';
                  plog.warn(pkgctx,
                            'Khong lay duoc gia tri tren cau lenh select dong : SQL-' ||
                            v_extcmdsql);
              end;
            end;
          end if;

          insert into vsdtxreqdtl
            (autoid, reqid, fldname, cval, nval)
            select seq_crbtxreqdtl.nextval, l_vsdtxreq, rc.fldname,
                   decode(rc.fldtype, 'N', null, to_char(v_value)),
                   decode(rc.fldtype, 'N', v_value, 0)
              from dual;
        end;
      end loop;

      if v_trfcode = '598.NEWM/AOPN' then
        update cfmast set nsdstatus = 'S' where custodycd = v_log_msgacct;
      ELSIF v_trfcode = '598.NEWM/ACLS' then
        update cfmast set nsdstatus = 'S' where custid = v_log_msgacct;
      end if;

    else
      if v_trfcode = '598.NEWM/ACLS' then
        update cfmast set nsdstatus = 'C' where custid = v_log_msgacct;
      end if;
    end if;
    plog.setendsection(pkgctx, 'sp_gen_vsd_req');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'sp_gen_vsd_req');
  end sp_gen_vsd_req;

  procedure auto_complete_confirm_msg(pv_reqid number, pv_cftltxcd varchar2,
                                      pv_vsdtrfid number) as
  begin
    plog.setbeginsection(pkgctx, 'auto_complete_confirm_msg');
    plog.info(pkgctx,
              '::req Id:' || pv_reqid || '::confirm tltxcd:' || pv_cftltxcd ||
              '::vsd confirm Id:' || pv_vsdtrfid);
    if pv_cftltxcd = '2201' then
      -- XAC NHAN THANH CONG CUA RUT CK
      auto_call_txpks_2201(pv_reqid, pv_vsdtrfid);
   -- elsif pv_cftltxcd = '0048' then
      -- XAC NHAN THANH CONG CUA MO tai khoan
     -- auto_call_txpks_0048(pv_reqid, pv_vsdtrfid);
    elsif pv_cftltxcd = '2246' then
      -- XAC NHAN THANH CONG CUA LUU KY
      auto_call_txpks_2246(pv_reqid, pv_vsdtrfid);
    elsif pv_cftltxcd = '2248' then
      -- XAC NHAN CK DONG TK
      auto_call_txpks_2248(pv_reqid, pv_vsdtrfid);
    elsif pv_cftltxcd = '2290' then
      -- XAC NHAN TU CHOI CK DONG TK
      auto_call_txpks_2290(pv_reqid, pv_vsdtrfid);
     elsif pv_cftltxcd = '2231' then
      -- XAC NHAN KHONG THANH CONG CUA LUU KY
      auto_call_txpks_2231(pv_reqid, pv_vsdtrfid);
    elsif pv_cftltxcd = '2294' then
      -- XAC NHAN TU CHOI RUT CK
      auto_call_txpks_2294(pv_reqid, pv_vsdtrfid);
    --elsif pv_cftltxcd = '8816' then
      -- XAC NHAN TU CHOI CK LO LE RA NGOAI
      --auto_call_txpks_8816(pv_reqid, pv_vsdtrfid);
    elsif pv_cftltxcd = '8879' then
      -- XAC NHAN CK RA NGOAI THANH CONG
      auto_call_txpks_8879(pv_reqid, pv_vsdtrfid);
    elsif pv_cftltxcd = '2266' then
      -- XAC NHAN CK RA NGOAI THANH CONG
      auto_call_txpks_2266(pv_reqid, pv_vsdtrfid);
    elsif pv_cftltxcd = '2265' then
      -- XAC NHAN TU CHOI CK RA NGOAI
      auto_call_txpks_2265(pv_reqid, pv_vsdtrfid);
    /*elsif pv_cftltxcd = '3380' then
      -- XAC NHAN TU CHOI CK DONG TK
      auto_call_txpks_3380(pv_reqid, pv_vsdtrfid);*/
    end if;
    plog.setendsection(pkgctx, 'auto_complete_confirm_msg');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'auto_complete_confirm_msg');
  end auto_complete_confirm_msg;

  /*procedure auto_call_txpks_0048(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    varchar2(20);
    l_err_param   varchar2(100);
    l_sqlerrnum   varchar2(200);
  begin
    for rec0 in (select req.*, code.tltxcd, code.searchcode, code.filtername
                   from vsdtxreq req, vsdtrfcode code
                  where req.msgstatus in ('C', 'R', 'W')
                    and req.status <> 'C'
                       --                    and req.msgstatus = 'W'   -- cac msg chua hoan thanh giao dich
                    and req.trfcode = code.trfcode
                    and code.status = 'Y'
                    and code.type in ('CFO', 'CFN')
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '0048';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := getcurrdate;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select a4.cdval fntypeid, a4.cdcontent fntype, cf.custodycd,
                         cf.fullname, cf.idcode, cf.iddate, cf.address,
                         cf.idexpired, cf.mobile phone, cf.email,
                         rq.txdate voucherdate, rq.objkey vouchernumber,
                         cf.nsdstatus cfstatusid,
                         \*rq.adtxprocess sendstatusid,*\
                         \*a2.cdcontent sendstatus,*\
                         rq.msgstatus msgstatusid, a3.cdcontent msgstatus,
                         rq.rqtype rqtypeid, a5.cdcontent rqtype,
                         (case
                           when trflogdtl.fldval = 'OACK' then
                            'C'
                           else
                            'R'
                         end) cfstatus,
                         -- errmsg,
                         rq.refcode, rq.times, '' autoid, rq.reqid, cf.custid,
                         cf.idtype
                    from vsdtxreq rq, cfmast cf, allcode a1, \*allcode a2,*\
                         allcode a3, allcode a4, allcode a5, vsdtrflog trflog,
                         vsdtrflogdtl trflogdtl
                   where rq.objname in ('0047', '0059')
                     and cf.nsdstatus = a1.cdval
                     and a1.cdtype = 'SA'
                     and a1.cdname = 'NSDSTATUS'
                        \*                     and rq.adtxprocess = a2.cdval
                        and a2.cdtype = 'SY'
                        and a2.cdname = 'YESNO'*\
                     and rq.msgstatus = a3.cdval
                     and a3.cdtype = 'RM'
                     and a3.cdname = 'TXMSGSTATUS'
                     and 'N' = a4.cdval
                     and a4.cdtype = 'RM'
                     and a4.cdname = 'FNTYPE'
                     and rq.rqtype = a5.cdval
                     and a5.cdtype = 'RM'
                     and a5.cdname = 'RQTYPE'
                     and (rq.msgstatus in ('C', 'R') \*and rq.boprocess <> 'Y'*\
                         and cf.nsdstatus in ('A', 'P'))
                     and trflog.referenceid = to_char(rq.reqid)
                     and trflogdtl.refautoid = trflog.autoid
                     and trflogdtl.fldname = 'STATUS'
                     and (cf.custodycd = rec0.msgacct or
                         cf.custid = rec0.msgacct)
                     and rq.reqid = pv_reqid)

       loop
        --tx content
        --01    CUSTID     C
        l_txmsg.txfields('01').defname := 'CUSTID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.custid;
        --03    CUSTODYCD     C
        l_txmsg.txfields('03').defname := 'CUSTODYCD';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.custodycd;
        --05    REQID     C
        l_txmsg.txfields('05').defname := 'REQID';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.reqid;
        --06    REFCODE     C
        l_txmsg.txfields('06').defname := 'REFCODE';
        l_txmsg.txfields('06').type := 'C';
        l_txmsg.txfields('06').value := rec.refcode;
        --08    CONFSTATUS     C
        l_txmsg.txfields('08').defname := 'CONFSTATUS';
        l_txmsg.txfields('08').type := 'C';
        l_txmsg.txfields('08').value := rec.cfstatus; -- COMPLETE
        --09    AUTOID     C
        l_txmsg.txfields('09').defname := 'AUTOID';
        l_txmsg.txfields('09').type := 'C';
        l_txmsg.txfields('09').value := pv_vsdtrfid;
        --11    FNTYPE     C
        l_txmsg.txfields('11').defname := 'FNTYPE';
        l_txmsg.txfields('11').type := 'C';
        l_txmsg.txfields('11').value := rec.fntypeid;
        --12    TXNUM     C
        l_txmsg.txfields('12').defname := 'TXNUM';
        l_txmsg.txfields('12').type := 'C';
        l_txmsg.txfields('12').value := rec.vouchernumber;
        --13    TXDATE     D
        l_txmsg.txfields('13').defname := 'TXDATE';
        l_txmsg.txfields('13').type := 'D';
        l_txmsg.txfields('13').value := rec.voucherdate;
        --15    FULLNAME     C
        l_txmsg.txfields('15').defname := 'FULLNAME';
        l_txmsg.txfields('15').type := 'C';
        l_txmsg.txfields('15').value := rec.fullname;
        --16    IDCODE     C
        l_txmsg.txfields('16').defname := 'IDCODE';
        l_txmsg.txfields('16').type := 'C';
        l_txmsg.txfields('16').value := rec.idcode;
        --17    IDTYPE     C
        l_txmsg.txfields('17').defname := 'IDTYPE';
        l_txmsg.txfields('17').type := 'C';
        l_txmsg.txfields('17').value := rec.idtype;
        --18    ADDRESS     C
        l_txmsg.txfields('18').defname := 'ADDRESS';
        l_txmsg.txfields('18').type := 'C';
        l_txmsg.txfields('18').value := rec.address;
        --19    EXPDATE     D
        l_txmsg.txfields('19').defname := 'EXPDATE';
        l_txmsg.txfields('19').type := 'D';
        l_txmsg.txfields('19').value := rec.idexpired;
        --20    PHONENUMBER     C
        l_txmsg.txfields('20').defname := 'PHONENUMBER';
        l_txmsg.txfields('20').type := 'C';
        l_txmsg.txfields('20').value := rec.phone;
        --21    EMAIL     C
        l_txmsg.txfields('21').defname := 'EMAIL';
        l_txmsg.txfields('21').type := 'C';
        l_txmsg.txfields('21').value := rec.email;
        --22    TIMES     C
        l_txmsg.txfields('22').defname := 'TIMES';
        l_txmsg.txfields('22').type := 'C';
        l_txmsg.txfields('22').value := rec.times;
        --23    RQTYPE     C
        l_txmsg.txfields('23').defname := 'RQTYPE';
        l_txmsg.txfields('23').type := 'C';
        l_txmsg.txfields('23').value := rec.rqtypeid;
        --24    IDDATE     D
        l_txmsg.txfields('24').defname := 'IDDATE';
        l_txmsg.txfields('24').type := 'D';
        l_txmsg.txfields('24').value := rec.iddate;
        --30    DESC     C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;

        begin
          if txpks_#0048.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
            --  RETURN;
          end if;
        end;
      end loop;
      if nvl(p_err_code, '0') = '0' then
        -- Tr?ng th?CRBTXREQ
        if l_txmsg.txfields('08').value = 'C' then
          update vsdtxreq
             set status = 'C', msgstatus = 'F' --boprocess = 'Y'
           where reqid = pv_reqid;
        else
          update vsdtxreq
             set status = 'R', msgstatus = 'F' --boprocess = 'Y'
           where reqid = pv_reqid;
        end if;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E', boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_0048', l_sqlerrnum);
  end auto_call_txpks_0048;
*/
  procedure auto_call_txpks_2246(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_effect_date date;
  BEGIN
    -- Lay ngay hieu luc hach toan TRADDET.98A.ESET tu dien xac nhan cua VSD
    -- FLDNAME la VSDEFFDATE
    begin
      select to_date(fldval, 'YYYYMMDD')
        into l_effect_date
        from vsdtrflogdtl
       where refautoid = pv_vsdtrfid
         and fldname = 'VSDEFFDATE';
    exception
      when others then
        l_effect_date := getcurrdate;
    end;

    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where req.msgstatus in ('C', 'W')
                       --and req.status <> 'C'
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '2246';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := l_effect_date;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select distinct fn_get_location(cfmast.brid) location,
                                  sedeposit.senddepodate txdate,
                                  to_char(sedeposit.senddepodate,
                                           'YYYY/MM/DD') txdate1,
                                  a4.cdcontent tradeplace, semast.actype,
                                  semast.acctno, sym.symbol, sym.parvalue,
                                  semast.codeid, semast.afacctno, custodycd,
                                  semast.opndate, semast.clsdate,
                                  semast.lastdate, a1.cdcontent status,
                                  semast.pstatus, a2.cdcontent irtied,
                                  a3.cdcontent iccftied, ircd, costprice,
                                  sedeposit.depositqtty senddeposit,
                                  sedeposit.depositprice depositprice,
                                  sedeposit.description description,
                                  sedeposit.autoid autoid, cfmast.custid,
                                  costdt, sedeposit.senddepodate pdate,
                                  sedeposit.rdate, cfmast.fullname,
                                  cfmast.address, cfmast.idcode, depotrade,
                                  depoblock, a5.cdcontent cd_qttytype,
                                  sedeposit.typedepoblock qttytype,
                                  sedeposit.wtrade wtrade, ci.depolastdt,
                                  (semast.afacctno ||
                                   nvl(sym.refcodeid, sym.codeid)) acctno_updatecost,
                                   sedeposit.caqtty011, sedeposit.caqtty021, sedeposit.taxrate011, sedeposit.taxrate021
                    from semast, cfmast, sbsecurities sym, cimast ci,
                         vsdtxreq rq,
                         (select *
                             from sedeposit
                            where status = 'S'
                              and deltd <> 'Y') sedeposit, allcode a1,
                         allcode a2, allcode a3, allcode a4, allcode a5

                   where semast.senddeposit > 0
                     and a1.cdtype = 'SE'
                     and a1.cdname = 'STATUS'
                     and a1.cdval = semast.status
                     and semast.custid = cfmast.custid
                     and a2.cdtype = 'SY'
                     and a2.cdname = 'YESNO'
                     and a2.cdval = irtied
                     and nvl(a5.cdtype, 'SE') = 'SE'
                     and nvl(a5.cdname, 'QTTYTYPE') = 'QTTYTYPE'
                     and sedeposit.typedepoblock = a5.cdval(+)
                     and sym.codeid = semast.codeid
                     and a3.cdtype = 'SY'
                     and a3.cdname = 'YESNO'
                     and a3.cdval = semast.iccftied
                     and a4.cdtype = 'SE'
                     and a4.cdname = 'TRADEPLACE'
                     and a4.cdval = sym.tradeplace
                     and sedeposit.acctno = semast.acctno
                     and semast.afacctno = ci.acctno
                     and rq.refcode = sedeposit.autoid
                     and rq.reqid = pv_reqid
                     and rq.objname = '2241') loop
        --01    CODEID     C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --02    AFACCTNO     C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03    ACCTNO     C
        l_txmsg.txfields('03').defname := 'ACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --04    DEPOBLOCK     N
        l_txmsg.txfields('04').defname := 'DEPOBLOCK';
        l_txmsg.txfields('04').type := 'N';
        l_txmsg.txfields('04').value := rec.depoblock;
        --05    AUTOID     N
        l_txmsg.txfields('05').defname := 'AUTOID';
        l_txmsg.txfields('05').type := 'N';
        l_txmsg.txfields('05').value := rec.autoid;
        --06    DEPOTRADE     N
        l_txmsg.txfields('06').defname := 'DEPOTRADE';
        l_txmsg.txfields('06').type := 'N';
        l_txmsg.txfields('06').value := rec.depotrade;
        --07    PDATE     C
        l_txmsg.txfields('07').defname := 'PDATE';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.pdate;
        --08    QTTYTYPE     C
        l_txmsg.txfields('08').defname := 'QTTYTYPE';
        l_txmsg.txfields('08').type := 'C';
        l_txmsg.txfields('08').value := rec.qttytype;
        --09    DEPOSITPRICE     N
        l_txmsg.txfields('09').defname := 'PRICE';
        l_txmsg.txfields('09').type := 'N';
        l_txmsg.txfields('09').value := rec.depositprice;
        --10    SENDDEPOSIT     N
        l_txmsg.txfields('10').defname := 'QTTY';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.senddeposit;
        --11    PARVALUE     N
        l_txmsg.txfields('11').defname := 'PARVALUE';
        l_txmsg.txfields('11').type := 'N';
        l_txmsg.txfields('11').value := rec.parvalue;
        --12    SQTTY     N
        l_txmsg.txfields('12').defname := 'SQTTY';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.depoblock + rec.depotrade;
        --13    RDATE     D
        l_txmsg.txfields('13').defname := 'RDATE';
        l_txmsg.txfields('13').type := 'D';
        l_txmsg.txfields('13').value := rec.rdate;
        --14    WTRADE     N
        l_txmsg.txfields('14').defname := 'WTRADE';
        l_txmsg.txfields('14').type := 'N';
        l_txmsg.txfields('14').value := rec.wtrade;
        --15   WTRADE     N
        l_txmsg.txfields('15').defname := 'CIDFPOFEEACR';
        l_txmsg.txfields('15').type := 'N';
        l_txmsg.txfields('15').value := FN_CIGETDEPOFEEAMT(rec.afacctno,rec.codeid,l_effect_date,getcurrdate,rec.depoblock + rec.depotrade);
        --22    M?SD   C
       --l_txmsg.txfields ('22').defname   := 'VSDCODE';
       --l_txmsg.txfields ('22').TYPE      := 'C';
       --l_txmsg.txfields ('22').value      := rec.VSDCODE;
        --ACCTNO_UPDATECOST
        l_txmsg.txfields ('23').defname   := 'ACCTNO_UPDATECOST';
        l_txmsg.txfields ('23').TYPE   := 'C';
        l_txmsg.txfields ('23').VALUE   := REC.acctno_updatecost;
        --30    DESC     C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
        --32    DEPOLASTDT     C
        l_txmsg.txfields('32').defname := 'DEPOLASTDT';
        l_txmsg.txfields('32').type := 'C';
        l_txmsg.txfields('32').value := rec.depolastdt;
        --33    DEPOLASTDT     N
        l_txmsg.txfields('33').defname := 'CIDFPOFEEACR';
        l_txmsg.txfields('33').type := 'N';
        l_txmsg.txfields('33').value := FN_CIGETDEPOFEEACR(rec.afacctno,rec.codeid,l_effect_date,getcurrdate,rec.depoblock + rec.depotrade);
        --88    CUSTODYCD     C
        l_txmsg.txfields('88').defname := 'CUSTODYCD';
        l_txmsg.txfields('88').type := 'C';
        l_txmsg.txfields('88').value := rec.custodycd;
        --90    FULLNAME     C
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.fullname;
        --91    ADDRESS     C
        l_txmsg.txfields('91').defname := 'ADDRESS';
        l_txmsg.txfields('91').type := 'C';
        l_txmsg.txfields('91').value := rec.address;
        --92    IDCODE     C
        l_txmsg.txfields('92').defname := 'LICENSE';
        l_txmsg.txfields('92').type := 'C';
        l_txmsg.txfields('92').value := rec.idcode;
        
        --hotfix quyen
        --16   CAQTTY011     N
        l_txmsg.txfields('16').defname := 'CAQTTY011';
        l_txmsg.txfields('16').type := 'N';
        l_txmsg.txfields('16').value := rec.caqtty011;
        
        --17    TAXRATE011     N
        l_txmsg.txfields('17').defname := 'TAXRATE011';
        l_txmsg.txfields('17').type := 'N';
        l_txmsg.txfields('17').value := rec.taxrate011;
        
        --18    CAQTTY021     N
        l_txmsg.txfields('18').defname := 'CAQTTY021';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.caqtty021;
        
        --19    TAXRATE021     N
        l_txmsg.txfields('19').defname := 'TAXRATE021';
        l_txmsg.txfields('19').type := 'N';
        l_txmsg.txfields('19').value := rec.taxrate021;
        --
        begin

          if txpks_#2246.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
            --RETURN;
          end if;
        end;
      end loop;
      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'C', msgstatus = 'F' -- boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E', boprocess = 'E',
               boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_2246',
         l_sqlerrnum || dbms_utility.format_error_backtrace);
  end auto_call_txpks_2246;

  procedure auto_call_txpks_3380(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);

  begin
    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where req.msgstatus in ('C', 'W')
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '3380';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := getcurrdate;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select vw.*
                    from v_ca3380 vw, vsdtxreq rq
                   where rq.refcode = vw.autoid
                     and rq.reqid = pv_reqid
                     and rq.objname = '3387') loop
        --01    M??ch CA   C
     l_txmsg.txfields ('01').defname   := 'AUTOID';
     l_txmsg.txfields ('01').TYPE      := 'C';
     l_txmsg.txfields ('01').value      := rec.AUTOID;
--02    M?? ki?n   C
     l_txmsg.txfields ('02').defname   := 'CAMASTID';
     l_txmsg.txfields ('02').TYPE      := 'C';
     l_txmsg.txfields ('02').value      := rec.CAMASTID;
--03    S? Ti?u kho?n   C
     l_txmsg.txfields ('03').defname   := 'AFACCTNO';
     l_txmsg.txfields ('03').TYPE      := 'C';
     l_txmsg.txfields ('03').value      := rec.AFACCTNO;
--04    M?h?ng kho?ph?b?   C
     l_txmsg.txfields ('04').defname   := 'SYMBOL';
     l_txmsg.txfields ('04').TYPE      := 'C';
     l_txmsg.txfields ('04').value      := rec.SYMBOL;
--20    M?h?ng kho?s? h?u   C
     l_txmsg.txfields ('20').defname   := 'SYMBOLDIS';
     l_txmsg.txfields ('20').TYPE      := 'C';
     l_txmsg.txfields ('20').value      := rec.SYMBOLDIS;
--05    Lo?i th?c hi?n   C
     l_txmsg.txfields ('05').defname   := 'CATYPE';
     l_txmsg.txfields ('05').TYPE      := 'C';
     l_txmsg.txfields ('05').value      := rec.CATYPE;
--40    Tr?ng th?  C
     l_txmsg.txfields ('40').defname   := 'STATUS';
     l_txmsg.txfields ('40').TYPE      := 'C';
     l_txmsg.txfields ('40').value      := rec.STATUSCD;
--36    S? TK luu k?   C
     l_txmsg.txfields ('36').defname   := 'CUSTODYCD';
     l_txmsg.txfields ('36').TYPE      := 'C';
     l_txmsg.txfields ('36').value      := rec.CUSTODYCD;
--11    S? lu?ng   N
     l_txmsg.txfields ('11').defname   := 'QTTY';
     l_txmsg.txfields ('11').TYPE      := 'N';
     l_txmsg.txfields ('11').value      := rec.QTTY;
--19    SL? mua kh?n?p ti?n   N
     l_txmsg.txfields ('19').defname   := 'NMQTTY';
     l_txmsg.txfields ('19').TYPE      := 'N';
     l_txmsg.txfields ('19').value      := rec.NMQTTY;
--10    S? ti?n   N
     l_txmsg.txfields ('10').defname   := 'AMT';
     l_txmsg.txfields ('10').TYPE      := 'N';
     l_txmsg.txfields ('10').value      := rec.AMT;
--13    S? lu?ng li?quan   N
     l_txmsg.txfields ('13').defname   := 'AQTTY';
     l_txmsg.txfields ('13').TYPE      := 'N';
     l_txmsg.txfields ('13').value      := rec.AQTTY;
--12    S? ti?n ? mua   N
     l_txmsg.txfields ('12').defname   := 'AAMT';
     l_txmsg.txfields ('12').TYPE      := 'N';
     l_txmsg.txfields ('12').value      := rec.AAMT;
--08    S? TK SE   C
     l_txmsg.txfields ('08').defname   := 'SEACCTNO';
     l_txmsg.txfields ('08').TYPE      := 'C';
     l_txmsg.txfields ('08').value      := rec.SEACCTNO;
--09    S? TK SE li?quan   C
     l_txmsg.txfields ('09').defname   := 'EXSEACCTNO';
     l_txmsg.txfields ('09').TYPE      := 'C';
     l_txmsg.txfields ('09').value      := rec.EXSEACCTNO;
--15    M?nh gi?i?quan   N
     l_txmsg.txfields ('15').defname   := 'EXPARVALUE';
     l_txmsg.txfields ('15').TYPE      := 'N';
     l_txmsg.txfields ('15').value      := rec.EXPARVALUE;
--07    Ng?th?c hi?n quy?n DK   C
     l_txmsg.txfields ('07').defname   := 'ACTIONDATE';
     l_txmsg.txfields ('07').TYPE      := 'C';
     l_txmsg.txfields ('07').value      := rec.ACTIONDATE;
--30    M?   C
     l_txmsg.txfields ('30').defname   := 'DESCRIPTION';
     l_txmsg.txfields ('30').TYPE      := 'C';
     l_txmsg.txfields ('30').value      := rec.DESCRIPTION;
--66    L?KQM   N
     l_txmsg.txfields ('66').defname   := 'ISRIGHTOFF';
     l_txmsg.txfields ('66').TYPE      := 'N';
     l_txmsg.txfields ('66').value      := rec.ISRIGHTOFF;
--21    S? lu?ng hi?n th?   N
     l_txmsg.txfields ('21').defname   := 'TRADE';
     l_txmsg.txfields ('21').TYPE      := 'N';
     l_txmsg.txfields ('21').value      := rec.QTTYDIS;
--06    Ng?dang k? cu?i c?ng   C
     l_txmsg.txfields ('06').defname   := 'REPORTDATE';
     l_txmsg.txfields ('06').TYPE      := 'C';
     l_txmsg.txfields ('06').value      := rec.REPORTDATE;
--22    M?h?ng kho?  C
     l_txmsg.txfields ('22').defname   := 'CODEID';
     l_txmsg.txfields ('22').TYPE      := 'C';
     l_txmsg.txfields ('22').value      := rec.CODEID;
--41    Tr?ng th?m?i   C
     l_txmsg.txfields ('41').defname   := 'NEWSTATUS';
     l_txmsg.txfields ('41').TYPE      := 'C';
     l_txmsg.txfields ('41').value      := 'S';
--14    M?nh gi? N
     l_txmsg.txfields ('14').defname   := 'PARVALUE';
     l_txmsg.txfields ('14').TYPE      := 'N';
     l_txmsg.txfields ('14').value      := rec.parvalue;

        begin

          if txpks_#3380.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
            --RETURN;
          end if;
        end;
      end loop;
      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E' /*boprocess = 'E'*/,
               boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_3380',
         l_sqlerrnum || dbms_utility.format_error_backtrace);
  end auto_call_txpks_3380;

  procedure auto_call_txpks_2231(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_status      char(1);
  begin
    plog.setbeginsection(pkgctx, 'auto_call_txpks_2231');

    for rec_debug in (select req.*
                        from vsdtxreq req
                       where req.reqid = pv_reqid) loop
      plog.info(pkgctx,
                'Req:' || pv_reqid || '::msg status' || rec_debug.msgstatus);
    end loop;

    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where req.msgstatus in ('N','R', 'W')
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd := '2231';
      plog.info(pkgctx,
                'Req:' || pv_reqid || '::vsdTrfId' || pv_vsdtrfid ||
                'with tltxcd:' || l_tltxcd);

      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := getcurrdate;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day

      for rec in (select distinct fn_get_location(cfmast.brid) location,
                                  actype, semast.acctno, sym.symbol,
                                  sym.parvalue, semast.codeid,
                                  semast.afacctno, custodycd, semast.opndate,
                                  clsdate, semast.lastdate,
                                  a1.cdcontent status,
                                  a4.cdcontent tradeplace, semast.pstatus,
                                  a2.cdcontent irtied, a3.cdcontent iccftied,
                                  ircd, costprice,
                                  sedeposit.depositqtty senddeposit,
                                  sedeposit.depotrade, sedeposit.depoblock,
                                  sedeposit.typedepoblock,
                                  sedeposit.depositprice depositprice,
                                  sedeposit.description description,
                                  sedeposit.autoid autoid, cfmast.custid,
                                  costdt, cfmast.fullname custname,
                                  cfmast.address address,
                                  cfmast.idcode license,
                                  sedeposit.senddepodate pdate,
                                  sedeposit.txdate,
                                  sedeposit.typedepoblock qttytype,
                                  sedeposit.depositprice price
                    from semast, cfmast, sbsecurities sym, vsdtxreq rq,
                         (select *
                             from sedeposit
                            where status = 'S'
                              and deltd <> 'Y') sedeposit, allcode a1,
                         allcode a2, allcode a3, allcode a4,
                         (select *
                             from tllog
                            where txstatus = '1'
                              and deltd = 'N'
                              and tltxcd = '2241'
                           union all
                           select *
                             from tllogall
                            where txstatus = '1'
                              and deltd = 'N'
                              and tltxcd = '2241') log
                   where semast.senddeposit > 0
                     and a1.cdtype = 'SE'
                     and a1.cdname = 'STATUS'
                     and a1.cdval = semast.status
                     and semast.custid = cfmast.custid
                     and a2.cdtype = 'SY'
                     and a2.cdname = 'YESNO'
                     and a2.cdval = irtied
                     and sym.codeid = semast.codeid
                     and a3.cdtype = 'SY'
                     and a3.cdname = 'YESNO'
                     and a3.cdval = semast.iccftied
                     and a4.cdtype = 'SE'
                     and a4.cdname = 'TRADEPLACE'
                     and a4.cdval = sym.tradeplace
                     and sedeposit.acctno = semast.acctno
                     and log.msgacct = semast.acctno
                     and rq.refcode = sedeposit.autoid
                     and rq.reqid = pv_reqid) loop
        --01      M?h?ng kho?         C
        l_txmsg.txfields('01').defname := 'CODEID   ';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --02      S? Ti?u kho?n           C
        l_txmsg.txfields('02').defname := 'AFACCTNO ';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03      S? t?kho?n            C
        l_txmsg.txfields('03').defname := 'ACCTNO   ';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --04      S? CK HCCN              N
        l_txmsg.txfields('04').defname := 'DEPOBLOCK';
        l_txmsg.txfields('04').type := 'N';
        l_txmsg.txfields('04').value := rec.depoblock;
        --05      S? t? t?ng              N
        l_txmsg.txfields('05').defname := 'AUTOID   ';
        l_txmsg.txfields('05').type := 'N';
        l_txmsg.txfields('05').value := rec.autoid;
        --06      S? CK TDCN              N
        l_txmsg.txfields('06').defname := 'DEPOTRADE';
        l_txmsg.txfields('06').type := 'N';
        l_txmsg.txfields('06').value := rec.depotrade;
        --07      Posted date             C
        l_txmsg.txfields('07').defname := 'PDATE    ';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.pdate;
        --08      Lo?i ?i?u ki?n          C
        l_txmsg.txfields('08').defname := 'QTTYTYPE ';
        l_txmsg.txfields('08').type := 'C';
        l_txmsg.txfields('08').value := rec.qttytype;
        --09      Gi??n                 N
        l_txmsg.txfields('09').defname := 'PRICE    ';
        l_txmsg.txfields('09').type := 'N';
        l_txmsg.txfields('09').value := rec.price;
        --10      S? l??ng                N
        l_txmsg.txfields('10').defname := 'QTTY     ';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.depoblock + rec.depotrade;
        --11      M?nh gi?              N
        l_txmsg.txfields('11').defname := 'PARVALUE ';
        l_txmsg.txfields('11').type := 'N';
        l_txmsg.txfields('11').value := rec.parvalue;
        --30      M?                   C
        l_txmsg.txfields('30').defname := 'DESC     ';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
        --90      H? t?                 C
        l_txmsg.txfields('90').defname := 'CUSTNAME ';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.custname;
        --91      ??a ch?                 C
        l_txmsg.txfields('91').defname := 'ADDRESS  ';
        l_txmsg.txfields('91').type := 'C';
        l_txmsg.txfields('91').value := rec.address;
        --92      CMND/GPKD               C
        l_txmsg.txfields('92').defname := 'LICENSE  ';
        l_txmsg.txfields('92').type := 'C';
        l_txmsg.txfields('92').value := rec.license;

        begin
          if txpks_#2231.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;
      FOR REC_1 IN (SELECT * FROM VSDTRFLOG LOG WHERE LOG.AUTOID = pv_vsdtrfid)
      LOOP
        if nvl(p_err_code, 0) = 0 THEN
          IF INSTR(REC_1.FUNCNAME,'.NAK') = 0 THEN

        update vsdtxreq
           set status = 'R', msgstatus = 'R' --boprocess = 'Y'
         where reqid = pv_reqid;
         END IF;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid; --l_txmsg.txfields('09').value;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;
      END LOOP;
    end loop;
    plog.setendsection(pkgctx, 'auto_call_txpks_2231');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'auto_call_txpks_2231');
  end auto_call_txpks_2231;

  ---
 /* procedure sp_auto_complete_openaccount(pv_reqid number,
                                         pv_msgstatus varchar2) as
    l_sqlerrnum varchar2(200);
    v_custodycd varchar2(10);
    v_custid    varchar2(10);
    v_nsdstatus varchar2(1);
    v_txdate    date;
  begin

    v_txdate    := getcurrdate;
    v_nsdstatus := pv_msgstatus;
    select cval
      into v_custid
      from vsdtxreqdtl
     where reqid = pv_reqid
       and fldname = 'CUSTID';

    insert into log_err
      (id, date_log, position, text)
    values
      (seq_log_err.nextval, sysdate, 'sp_auto_complete_openaccount 01',
       v_txdate);
    insert into aftran
      (txnum, txdate, acctno, txcd, namt, camt, acctref, deltd, ref, autoid,
       tltxcd, bkdate, trdesc)
    values
      (to_char(pv_reqid), v_txdate, v_custid, '0006', 0, v_nsdstatus,
       v_custid, 'N', v_custid, seq_aftran.nextval, '0042', v_txdate,
       '' || '' || '');
    insert into log_err
      (id, date_log, position, text)
    values
      (seq_log_err.nextval, sysdate, 'sp_auto_complete_openaccount 02',
       v_nsdstatus);
    update cfmast
       set nsdstatus = v_nsdstatus, last_change = systimestamp
     where custid = v_custid;
    -- VSDTXREQ
    if v_nsdstatus = 'C' then
      update vsdtxreq
         set status = 'C', msgstatus = 'F' --boprocess = 'Y'
       where reqid = pv_reqid;
    else
      update vsdtxreq
         set status = 'E', msgstatus = 'F' --boprocess = 'Y'
       where reqid = pv_reqid;
    end if;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'sp_auto_complete_openaccount',
         l_sqlerrnum);
  end sp_auto_complete_openaccount;*/

  procedure auto_call_txpks_2294(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    varchar2(20);
    l_err_param   varchar2(20);
    l_sqlerrnum   varchar2(200);
  begin
    plog.setbeginsection(pkgctx, 'auto_call_txpks_2294');
    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where req.msgstatus in ('N', 'R', 'W')
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '2294';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := getcurrdate;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select distinct semast.acctno, sym.symbol, semast.afacctno,
                                  sewd.withdraw withdraw, semast.codeid,
                                  sym.parvalue, seinfo.basicprice price,
                                  cf.idcode license, cf.idplace licenseplace,
                                  iddate licensedate, cf.address,
                                  semast.lastdate selastdate,
                                  af.lastdate aflastdate,
                                  nvl(semast.lastdate, af.lastdate) lastdate,
                                  cf.custodycd, a1.cdcontent tradeplace,
                                  cf.fullname, sewd.txdate, sewd.txnum,
                                  sewd.txdatetxnum,
                                  SEWD.WITHDRAW sumqtty
                    from semast, sbsecurities sym, afmast af, cfmast cf,
                         allcode a1, securities_info seinfo,
                         sewithdrawdtl sewd, vsdtxreq rq
                   where sym.codeid = seinfo.codeid
                     and a1.cdtype = 'SA'
                     and a1.cdname = 'TRADEPLACE'
                     and a1.cdval = sym.tradeplace
                     and cf.custid = af.custid
                     and sym.codeid = semast.codeid
                     and semast.afacctno = af.acctno
                     and semast.withdraw > 0
                     and semast.acctno = sewd.acctno
                     and sewd.status = 'A'
                     and rq.refcode = sewd.txdatetxnum
                     and rq.reqid = pv_reqid
                     ) loop
        --05    Ng?TH GD xin r?t   D
     l_txmsg.txfields ('05').defname   := 'TXDATE';
     l_txmsg.txfields ('05').TYPE      := 'D';
     l_txmsg.txfields ('05').value      := rec.TXDATE;
--06    S? CT c?a GD xin r?t   C
     l_txmsg.txfields ('06').defname   := 'TXNUM';
     l_txmsg.txfields ('06').TYPE      := 'C';
     l_txmsg.txfields ('06').value      := rec.TXNUM;
--04    M?h?ng kho?  C
     l_txmsg.txfields ('04').defname   := 'SYMBOL';
     l_txmsg.txfields ('04').TYPE      := 'C';
     l_txmsg.txfields ('04').value      := rec.SYMBOL;
--90    H? t?  C
     l_txmsg.txfields ('90').defname   := 'CUSTNAME';
     l_txmsg.txfields ('90').TYPE      := 'C';
     l_txmsg.txfields ('90').value      := rec.FULLNAME;
--02    S? Ti?u kho?n   C
     l_txmsg.txfields ('02').defname   := 'AFACCTNO';
     l_txmsg.txfields ('02').TYPE      := 'C';
     l_txmsg.txfields ('02').value      := rec.AFACCTNO;
--03    T?kho?n ch?ng kho?  C
     l_txmsg.txfields ('03').defname   := 'ACCTNO';
     l_txmsg.txfields ('03').TYPE      := 'C';
     l_txmsg.txfields ('03').value      := rec.ACCTNO;
--10    KL ch?ng kho?xin r?t   N
     l_txmsg.txfields ('10').defname   := 'AMT';
     l_txmsg.txfields ('10').TYPE      := 'N';
     l_txmsg.txfields ('10').value      := rec.WITHDRAW;
--14    KL ch?ng kho?hccn xin r?t   N
   ---  l_txmsg.txfields ('14').defname   := 'BLOCKWITHDRAW';
   --  l_txmsg.txfields ('14').TYPE      := 'N';
   --  l_txmsg.txfields ('14').value      := rec.BLOCKWITHDRAW;
--55    T?ng KL ch?ng kho?xin r?t   N
     l_txmsg.txfields ('55').defname   := 'SUMQTTY';
     l_txmsg.txfields ('55').TYPE      := 'N';
     l_txmsg.txfields ('55').value      := rec.SUMQTTY;
--07    Key   C
     l_txmsg.txfields ('07').defname   := 'TXDATETXNUM';
     l_txmsg.txfields ('07').TYPE      := 'C';
     l_txmsg.txfields ('07').value      := rec.TXDATETXNUM;
--92    CMND/GPKD   C
     l_txmsg.txfields ('92').defname   := 'LICENSE';
     l_txmsg.txfields ('92').TYPE      := 'C';
     l_txmsg.txfields ('92').value      := rec.LICENSE;
--95    Ng?c?p   D
     l_txmsg.txfields ('95').defname   := 'LICENSEDATE';
     l_txmsg.txfields ('95').TYPE      := 'D';
     l_txmsg.txfields ('95').value      := rec.LICENSEDATE;
--97    ?a ch?   C
     l_txmsg.txfields ('97').defname   := 'ADDRESS';
     l_txmsg.txfields ('97').TYPE      := 'C';
     l_txmsg.txfields ('97').value      := rec.address;
--30    Di?n gi?i   C
     l_txmsg.txfields ('30').defname   := 'DESC';
     l_txmsg.txfields ('30').TYPE      := 'C';
     l_txmsg.txfields ('30').value      := l_strdesc;


        begin
          if txpks_#2294.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;
      FOR REC_1 IN (SELECT * FROM VSDTRFLOG LOG WHERE LOG.AUTOID = pv_vsdtrfid)
      LOOP
        if nvl(p_err_code, 0) = 0 THEN
          IF INSTR(REC_1.FUNCNAME,'.NAK') = 0 THEN
            update vsdtxreq
               set status = 'R', msgstatus = 'R' --boprocess = 'Y'
             where reqid = pv_reqid;
          END IF;
          -- Tr?ng th?VSDTRFLOG
          update vsdtrflog
             set status = 'C', timeprocess = systimestamp
           where autoid = pv_vsdtrfid; -- l_txmsg.txfields('09').value;
        else
          -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
          update vsdtxreq
             set status = 'E', msgstatus = 'E'
                 --boprocess = 'E'
                , boprocess_err = p_err_code
           where reqid = pv_reqid;
          -- Tr?ng th?VSDTRFLOG
          update vsdtrflog
             set status = 'C', timeprocess = systimestamp
           where autoid = pv_vsdtrfid;
        end if;
      END LOOP;
    end loop;
    plog.setendsection(pkgctx, 'auto_call_txpks_2294');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'auto_call_txpks_2294');
  end auto_call_txpks_2294;

  procedure auto_call_txpks_2201(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_effect_date date;
  BEGIN
    -- Lay ngay hieu luc hach toan TRADDET.98A.ESET tu dien xac nhan cua VSD
    -- FLDNAME la VSDEFFDATE
    begin
      select to_date(fldval, 'YYYYMMDD')
        into l_effect_date
        from vsdtrflogdtl
       where refautoid = pv_vsdtrfid
         and fldname = 'VSDEFFDATE';
    exception
      when others then
        l_effect_date := getcurrdate;
    end;

    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where req.msgstatus in ('C', 'W')
                    and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '2201';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := l_effect_date;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select distinct fn_get_location(af.brid) location,
                                  semast.acctno, sym.symbol, semast.afacctno,
                                  sewd.withdraw withdraw, semast.codeid,sewd.withdraw  sumqtty,
                                  sym.parvalue, sewd.price price, cf.fullname,
                                  cf.idcode license, cf.iddate, cf.idplace,
                                  cf.address, semast.lastdate selastdate,
                                  af.lastdate aflastdate,
                                  confirmtxdate lastdate, cf.custodycd,
                                  a1.cdcontent tradeplace, sewd.txdatetxnum,
                                  sewd.txdate, sewd.txnum,
                                  semast.acctno acctno_updatecost,ISSU.fullname ISSFULLNAME
                    from semast, sbsecurities sym, afmast af, cfmast cf,
                         allcode a1, securities_info seinfo,
                         sewithdrawdtl sewd, sbsecurities sb, vsdtxreq rq,
                         ISSUERS ISSU
                   where sym.codeid = seinfo.codeid
                   AND SYM.ISSUERID = ISSU.ISSUERID(+)
                     and a1.cdtype = 'SE'
                     and a1.cdname = 'TRADEPLACE'
                     and a1.cdval = sym.tradeplace
                     and cf.custid = af.custid
                     and sym.codeid = semast.codeid
                     and semast.afacctno = af.acctno
                     and semast.withdraw > 0
                     and semast.acctno = sewd.acctno
                     and sewd.status = 'A'
                     and seinfo.codeid = sb.codeid
                     and rq.refcode = sewd.txdatetxnum
                     and rq.reqid = pv_reqid) loop
        p_err_code := 0;
        --05    Ng?TH GD xin r?t   D
     l_txmsg.txfields ('05').defname   := 'TXDATE';
     l_txmsg.txfields ('05').TYPE      := 'D';
     l_txmsg.txfields ('05').value      := rec.TXDATE;
--06    S? CT c?a GD xin r?t   C
     l_txmsg.txfields ('06').defname   := 'TXNUM';
     l_txmsg.txfields ('06').TYPE      := 'C';
     l_txmsg.txfields ('06').value      := rec.TXNUM;
--01    M?h?ng kho?  C
     l_txmsg.txfields ('01').defname   := 'CODEID';
     l_txmsg.txfields ('01').TYPE      := 'C';
     l_txmsg.txfields ('01').value      := rec.CODEID;
--02    S? Ti?u kho?n   C
     l_txmsg.txfields ('02').defname   := 'AFACCTNO';
     l_txmsg.txfields ('02').TYPE      := 'C';
     l_txmsg.txfields ('02').value      := rec.AFACCTNO;
--03    S? ti?u kho?n ch?ng kho?  C
     l_txmsg.txfields ('03').defname   := 'ACCTNO';
     l_txmsg.txfields ('03').TYPE      := 'C';
     l_txmsg.txfields ('03').value      := rec.ACCTNO;
--10    S? lu?ng   N
     l_txmsg.txfields ('10').defname   := 'AMT';
     l_txmsg.txfields ('10').TYPE      := 'N';
     l_txmsg.txfields ('10').value      := rec.WITHDRAW;
--14    S? lu?ng r?t HCCN    N
     --l_txmsg.txfields ('14').defname   := 'BLOCKWITHDRAW';
     --l_txmsg.txfields ('14').TYPE      := 'N';
     --l_txmsg.txfields ('14').value      := rec.BLOCKWITHDRAW;
--55    T?ng KL ch?ng kho?xin r?t   N
    -- l_txmsg.txfields ('55').defname   := 'SUMQTTY';
    -- l_txmsg.txfields ('55').TYPE      := 'N';
    -- l_txmsg.txfields ('55').value      := rec.SUMQTTY;
--11    M?nh gi? N
     l_txmsg.txfields ('11').defname   := 'PARVALUE';
     l_txmsg.txfields ('11').TYPE      := 'N';
     l_txmsg.txfields ('11').value      := rec.PARVALUE;
--09    Gi? N
     l_txmsg.txfields ('09').defname   := 'PRICE';
     l_txmsg.txfields ('09').TYPE      := 'N';
     l_txmsg.txfields ('09').value      := rec.PRICE;
--07    Key   C
     l_txmsg.txfields ('07').defname   := 'TXDATETXNUM';
     l_txmsg.txfields ('07').TYPE      := 'C';
     l_txmsg.txfields ('07').value      := rec.TXDATETXNUM;
--90    H? t?  C
     l_txmsg.txfields ('90').defname   := 'CUSTNAME';
     l_txmsg.txfields ('90').TYPE      := 'C';
     l_txmsg.txfields ('90').value      := rec.FULLNAME;
--91    ?a ch?   C
     l_txmsg.txfields ('91').defname   := 'ADDRESS';
     l_txmsg.txfields ('91').TYPE      := 'C';
     l_txmsg.txfields ('91').value      := rec.ADDRESS;
--92    CMND/GPKD   C
     l_txmsg.txfields ('92').defname   := 'LICENSE';
     l_txmsg.txfields ('92').TYPE      := 'C';
     l_txmsg.txfields ('92').value      := rec.LICENSE;
--95    Ng?c?p   D
     l_txmsg.txfields ('95').defname   := 'LICENSEDATE';
     l_txmsg.txfields ('95').TYPE      := 'D';
     l_txmsg.txfields ('95').value      := rec.IDDATE;
--36    Chi nh?   C
   --  l_txmsg.txfields ('36').defname   := 'BRNAME';
   --  l_txmsg.txfields ('36').TYPE      := 'C';
   --  l_txmsg.txfields ('36').value      := '';
--35    T?ngu?i d?t l?nh   C
   --  l_txmsg.txfields ('35').defname   := 'TLFULLNAME';
    -- l_txmsg.txfields ('35').TYPE      := 'C';
    -- l_txmsg.txfields ('35').value      := rec.FULLNAME;
--37    T?c?ty   C
  --   l_txmsg.txfields ('37').defname   := 'ISSUERSNAME';
  --   l_txmsg.txfields ('37').TYPE      := 'C';
  --   l_txmsg.txfields ('37').value      := rec.ISSFULLNAME;
--30    Di?n gi?i   C
     l_txmsg.txfields ('30').defname   := 'DESC';
     l_txmsg.txfields ('30').TYPE      := 'C';
     l_txmsg.txfields ('30').value      := l_strdesc;
--96    Noi c?p   C
     l_txmsg.txfields ('96').defname   := 'LICENSEPLACE';
     l_txmsg.txfields ('96').TYPE      := 'C';
     l_txmsg.txfields ('96').value      := rec.idplace;
--29    S? s? c? d?  C
    -- l_txmsg.txfields ('29').defname   := 'SSCD';
    -- l_txmsg.txfields ('29').TYPE      := 'C';
    -- l_txmsg.txfields ('29').value      := '';
--12  SO TK UPDATE GIA VON
      l_txmsg.txfields ('12').defname   := 'ACCTNO_UPDATECOST';
      l_txmsg.txfields ('12').TYPE   := 'C';
      l_txmsg.txfields ('12').VALUE   := REC.acctno_updatecost;
        begin
          if txpks_#2201.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;

      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;

      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_2201', l_sqlerrnum);
  end auto_call_txpks_2201;

procedure auto_call_txpks_2266(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_effect_date date;
    l_messagetype VARCHAR2(10);
  begin
    plog.setbeginsection(pkgctx, 'auto_call_txpks_2266');
    -- Lay ngay hieu luc hach toan TRADDET.98A.ESET tu dien xac nhan cua VSD
    -- FLDNAME la VSDEFFDATE
    begin
      select to_date(fldval, 'YYYYMMDD')
        into l_effect_date
        from vsdtrflogdtl
       where refautoid = pv_vsdtrfid
         and fldname = 'VSDEFFDATE';
    exception
      when others then
        l_effect_date := getcurrdate;
    end;

    --Lay thong tin dien confirm
     for rec0 in (select req.*, cf.custodycd, SUBSTR(req.trfcode,0,3) msgtype
                   from vsdtxreq req, cfmast cf, afmast af
                  where req.msgstatus in ('C', 'W')
                    and req.boprocess = 'N'
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    AND cf.custid = af.custid
                    AND af.acctno = req.afacctno
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '2266';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := l_effect_date;
      l_txmsg.txdate    := getcurrdate;
      /*select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;*/
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day

      plog.debug(pkgctx, 'l_txmsg.txnum:' || l_txmsg.txnum);
      IF rec0.msgtype = '542' THEN
        BEGIN
      for rec in (select seo.autoid, seo.txnum, seo.txdate, seo.acctno, seo.trade, seo.blocked, seo.caqtty,
                         seo.strade, seo.sblocked, seo.scaqtty, seo.ctrade, seo.cblocked, seo.ccaqtty,
                         seo.recustodycd, seo.recustname, seo.deltd,
                         seo.status, seo.codeid, seo.price, seo.outward, seo.id2255,
                         seo.trtype, seo.qttytype,seo.vsdmessagetype, cf.fullname, cf.custodycd, af.acctno afacctno,
                         sec.symbol, se.costprice, seo.acctno acctno_updatecost,
                         seo.srightoffqtty, seo.Scaamtreceiv, seo.Scaqttydb, seo.srightqtty, seo.Scaqttyreceiv
                   from sesendout seo, cfmast cf, afmast af,
                         sbsecurities sec, semast se, vsdtxreq rq
                   where substr(seo.acctno, 0, 10) = af.acctno
                     and af.custid = cf.custid
                     and sec.codeid = seo.codeid
                     and se.acctno = seo.acctno
                     and seo.strade + seo.sblocked + seo.scaqtty + seo.srightoffqtty + seo.scaqttyreceiv + seo.scaqttydb + seo.scaamtreceiv + seo.srightqtty > 0
                     and deltd = 'N'
                     and rq.refcode = seo.autoid
                     and rq.reqid = pv_reqid
                     AND seo.vsdmessagetype = '542'
                  ) LOOP

        select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;

        --15    S? TKCK update gi??n   C
        l_txmsg.txfields('15').defname := 'ACCTNO_UPDATECOST';
        l_txmsg.txfields('15').type := 'C';
        l_txmsg.txfields('15').value := rec.acctno_updatecost;
        --16    T?ng s? lu?ng   N
        l_txmsg.txfields('16').defname := 'PRICE';
        l_txmsg.txfields('16').type := 'N';
        l_txmsg.txfields('16').value := rec.price;
        --18    AUTOID   N
        l_txmsg.txfields('18').defname := 'AUTOID';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.autoid;
        --05    S? LK   C
        l_txmsg.txfields('05').defname := 'CUSTODYCD';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.custodycd;
        --02    S? TK ghi N?   C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03    S? TK CK ghi N?   C
        l_txmsg.txfields('03').defname := 'ACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --90    H? t?  C
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.fullname;
        --07    Ch?ng kho?  C
        l_txmsg.txfields('07').defname := 'SYMBOL';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.symbol;
        --01    M?h?ng kho?  C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --10    S? lu?ng giao d?ch   N
        l_txmsg.txfields('10').defname := 'TRADE';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.strade;
        --06    S? lu?ng CK phong t?a   N
        l_txmsg.txfields('06').defname := 'BLOCKED';
        l_txmsg.txfields('06').type := 'N';
        l_txmsg.txfields('06').value := rec.sblocked;
        --13    S? lu?ng CK CA   N
        l_txmsg.txfields('13').defname := 'CAQTTY';
        l_txmsg.txfields('13').type := 'N';
        l_txmsg.txfields('13').value := rec.scaqtty;
        --23    S? LK ngu?i nh?n   C
        l_txmsg.txfields('23').defname := 'RECUSTODYCD';
        l_txmsg.txfields('23').type := 'C';
        l_txmsg.txfields('23').value := rec.recustodycd;
        --24    T?ngu?i nh?n   C
        l_txmsg.txfields('24').defname := 'RECUSTNAME';
        l_txmsg.txfields('24').type := 'C';
        l_txmsg.txfields('24').value := rec.recustname;
        --12    T?ng s? lu?ng   N
        l_txmsg.txfields('12').defname := 'QTTY';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.sblocked + rec.strade;
        --14    Lo?i di?u ki?n   C
        l_txmsg.txfields('14').defname := 'QTTYTYPE';
        l_txmsg.txfields('14').type := 'C';
        l_txmsg.txfields('14').value := '002';
        --30    Di?n gi?i   C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;

        --RIGHTQTTY
        l_txmsg.txfields ('19').defname   := 'RIGHTQTTY';
        l_txmsg.txfields ('19').TYPE   := 'N';
        l_txmsg.txfields ('19').VALUE   := REC.SRIGHTQTTY;
        --RIGHTOFFQTTY
        l_txmsg.txfields ('20').defname   := 'RIGHTOFFQTTY';
        l_txmsg.txfields ('20').TYPE   := 'N';
        l_txmsg.txfields ('20').VALUE   := REC.SRIGHTOFFQTTY;
        --CAQTTYRECEIV
        l_txmsg.txfields ('21').defname   := 'CAQTTYRECEIV';
        l_txmsg.txfields ('21').TYPE   := 'N';
        l_txmsg.txfields ('21').VALUE   := REC.SCAQTTYRECEIV;
        --CAQTTYDB
        l_txmsg.txfields ('22').defname   := 'CAQTTYDB';
        l_txmsg.txfields ('22').TYPE   := 'N';
        l_txmsg.txfields ('22').VALUE   := REC.SCAQTTYDB;
        --CAAMTRECEIV
        l_txmsg.txfields ('17').defname   := 'CAAMTRECEIV';
        l_txmsg.txfields ('17').TYPE   := 'N';
        l_txmsg.txfields ('17').VALUE   := REC.SCAAMTRECEIV;
         --VSDMESSAGETYPE
        l_txmsg.txfields ('97').defname   := 'VSDMESSAGETYPE';
        l_txmsg.txfields ('97').TYPE   := 'C';
        l_txmsg.txfields ('97').VALUE   := REC.VSDMESSAGETYPE;
        begin
          if txpks_#2266.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;
      END;
      ELSIF rec0.msgtype = '598' THEN
        BEGIN
      for rec in (select seo.autoid, seo.txnum, seo.txdate, seo.acctno, seo.trade, seo.blocked, seo.caqtty,
                         seo.strade, seo.sblocked, seo.scaqtty, seo.ctrade, seo.cblocked, seo.ccaqtty,
                         seo.recustodycd, seo.recustname, seo.deltd,
                         seo.status, seo.codeid, seo.price, seo.outward, seo.id2255,
                         seo.trtype, seo.qttytype,seo.vsdmessagetype, cf.fullname, cf.custodycd, af.acctno afacctno,
                         sec.symbol, se.costprice, seo.acctno acctno_updatecost,
                         seo.srightoffqtty, seo.Scaamtreceiv, seo.Scaqttydb, seo.srightqtty, seo.Scaqttyreceiv
                   from sesendout seo, cfmast cf, afmast af,
                         sbsecurities sec, semast se
                   where substr(seo.acctno, 0, 10) = af.acctno
                     and af.custid = cf.custid
                     and sec.codeid = seo.codeid
                     and se.acctno = seo.acctno
                     and seo.strade + seo.sblocked + seo.scaqtty + seo.srightoffqtty + seo.scaqttyreceiv + seo.scaqttydb + seo.scaamtreceiv + seo.srightqtty > 0
                     and deltd = 'N'
                     and cf.custodycd = rec0.custodycd
                     AND seo.vsdmessagetype <> '0'
                  ) LOOP

        select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;

        --15    S? TKCK update gi??n   C
        l_txmsg.txfields('15').defname := 'ACCTNO_UPDATECOST';
        l_txmsg.txfields('15').type := 'C';
        l_txmsg.txfields('15').value := rec.acctno_updatecost;
        --16    T?ng s? lu?ng   N
        l_txmsg.txfields('16').defname := 'PRICE';
        l_txmsg.txfields('16').type := 'N';
        l_txmsg.txfields('16').value := rec.price;
        --18    AUTOID   N
        l_txmsg.txfields('18').defname := 'AUTOID';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.autoid;
        --05    S? LK   C
        l_txmsg.txfields('05').defname := 'CUSTODYCD';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.custodycd;
        --02    S? TK ghi N?   C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03    S? TK CK ghi N?   C
        l_txmsg.txfields('03').defname := 'ACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --90    H? t?  C
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.fullname;
        --07    Ch?ng kho?  C
        l_txmsg.txfields('07').defname := 'SYMBOL';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.symbol;
        --01    M?h?ng kho?  C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --10    S? lu?ng giao d?ch   N
        l_txmsg.txfields('10').defname := 'TRADE';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.strade;
        --06    S? lu?ng CK phong t?a   N
        l_txmsg.txfields('06').defname := 'BLOCKED';
        l_txmsg.txfields('06').type := 'N';
        l_txmsg.txfields('06').value := rec.sblocked;
        --13    S? lu?ng CK CA   N
        l_txmsg.txfields('13').defname := 'CAQTTY';
        l_txmsg.txfields('13').type := 'N';
        l_txmsg.txfields('13').value := rec.scaqtty;
        --23    S? LK ngu?i nh?n   C
        l_txmsg.txfields('23').defname := 'RECUSTODYCD';
        l_txmsg.txfields('23').type := 'C';
        l_txmsg.txfields('23').value := rec.recustodycd;
        --24    T?ngu?i nh?n   C
        l_txmsg.txfields('24').defname := 'RECUSTNAME';
        l_txmsg.txfields('24').type := 'C';
        l_txmsg.txfields('24').value := rec.recustname;
        --12    T?ng s? lu?ng   N
        l_txmsg.txfields('12').defname := 'QTTY';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.sblocked + rec.strade;
        --14    Lo?i di?u ki?n   C
        l_txmsg.txfields('14').defname := 'QTTYTYPE';
        l_txmsg.txfields('14').type := 'C';
        l_txmsg.txfields('14').value := '002';
        --30    Di?n gi?i   C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
        --RIGHTQTTY
        l_txmsg.txfields ('19').defname   := 'RIGHTQTTY';
        l_txmsg.txfields ('19').TYPE   := 'N';
        l_txmsg.txfields ('19').VALUE   := REC.SRIGHTQTTY;
        --RIGHTOFFQTTY
        l_txmsg.txfields ('20').defname   := 'RIGHTOFFQTTY';
        l_txmsg.txfields ('20').TYPE   := 'N';
        l_txmsg.txfields ('20').VALUE   := REC.SRIGHTOFFQTTY;
        --CAQTTYRECEIV
        l_txmsg.txfields ('21').defname   := 'CAQTTYRECEIV';
        l_txmsg.txfields ('21').TYPE   := 'N';
        l_txmsg.txfields ('21').VALUE   := REC.SCAQTTYRECEIV;
        --CAQTTYDB
        l_txmsg.txfields ('22').defname   := 'CAQTTYDB';
        l_txmsg.txfields ('22').TYPE   := 'N';
        l_txmsg.txfields ('22').VALUE   := REC.SCAQTTYDB;
        --CAAMTRECEIV
        l_txmsg.txfields ('17').defname   := 'CAAMTRECEIV';
        l_txmsg.txfields ('17').TYPE   := 'N';
        l_txmsg.txfields ('17').VALUE   := REC.SCAAMTRECEIV;
         --VSDMESSAGETYPE
        l_txmsg.txfields ('97').defname   := 'VSDMESSAGETYPE';
        l_txmsg.txfields ('97').TYPE   := 'C';
        l_txmsg.txfields ('97').VALUE   := REC.VSDMESSAGETYPE;
        begin
          if txpks_#2266.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;
      END;
      END IF;

      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;

      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
    plog.setendsection(pkgctx, 'auto_call_txpks_2266');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'auto_call_txpks_2266');
  end auto_call_txpks_2266;

  procedure auto_call_txpks_2265(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
  begin
    --Lay thong tin dien confirm
    for rec0 in (select req.*, cf.custodycd, SUBSTR(req.trfcode,0,3) msgtype
                   from vsdtxreq req, cfmast cf, afmast af
                  where req.msgstatus in ('N', 'R', 'W')
                    AND req.boprocess = 'N'
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    AND cf.custid = af.custid
                    AND af.acctno = req.afacctno
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '2265';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := getcurrdate;
      l_txmsg.txdate    := getcurrdate;

      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      --DungDT: neu la dien tu choi cua 598 thi revert toan bo giao dich cua tk
      IF rec0.msgtype = '598' THEN
        BEGIN
      for rec in (select seo.autoid, seo.txnum, seo.txdate, seo.acctno, seo.trade, seo.blocked, seo.caqtty,
                         seo.strade, seo.sblocked, seo.scaqtty, seo.ctrade, seo.cblocked, seo.ccaqtty,
                         seo.recustodycd, seo.recustname, seo.deltd,
                         seo.status, seo.codeid, seo.price, seo.outward, seo.id2255,
                         seo.trtype, seo.qttytype,seo.vsdmessagetype, cf.fullname, cf.custodycd, af.acctno afacctno,
                         sec.symbol, se.costprice,
                         seo.srightoffqtty, seo.Scaamtreceiv, seo.Scaqttydb, seo.srightqtty, seo.Scaqttyreceiv
                   from sesendout seo, cfmast cf, afmast af,
                         sbsecurities sec, semast se
                   where substr(seo.acctno, 0, 10) = af.acctno
                     and af.custid = cf.custid
                     and sec.codeid = seo.codeid
                     and se.acctno = seo.acctno
                     and seo.strade + seo.sblocked + seo.scaqtty + seo.srightoffqtty + seo.scaqttyreceiv + seo.scaqttydb + seo.scaamtreceiv + seo.srightqtty > 0
                     and deltd = 'N'
                     and cf.custodycd = rec0.custodycd
                     AND seo.vsdmessagetype = rec0.msgtype
        ) LOOP
        select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
        --01    M? ch?ng kho?n   C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --02    S? TK ghi N?   C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03    S? TK CK ghi N?   C
        l_txmsg.txfields('03').defname := 'ACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --05    S? LK   C
        l_txmsg.txfields('05').defname := 'CUSTODYCD';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.custodycd;
        --06    S? lu?ng CK phong t?a   N
        l_txmsg.txfields('06').defname := 'BLOCKED';
        l_txmsg.txfields('06').type := 'N';
        l_txmsg.txfields('06').value := rec.sblocked;
        --07    Ch?ng kho?n   C
        l_txmsg.txfields('07').defname := 'SYMBOL';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.symbol;
        --10    S? lu?ng giao d?ch   N
        l_txmsg.txfields('10').defname := 'TRADE';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.strade;
        --12    T?ng s? lu?ng   N
        l_txmsg.txfields('12').defname := 'QTTY';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.strade + rec.sblocked;
        --13    S? lu?ng CK CA   N
        l_txmsg.txfields('13').defname := 'CAQTTY';
        l_txmsg.txfields('13').type := 'N';
        l_txmsg.txfields('13').value := rec.scaqtty;
        --18    AUTOID   N
        l_txmsg.txfields('18').defname := 'AUTOID';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.autoid;
        --23    S? LK ngu?i nh?n   C
        l_txmsg.txfields('23').defname := 'RECUSTODYCD';
        l_txmsg.txfields('23').type := 'C';
        l_txmsg.txfields('23').value := rec.recustodycd;
        --24    T?n ngu?i nh?n   C
        l_txmsg.txfields('24').defname := 'RECUSTNAME';
        l_txmsg.txfields('24').type := 'C';
        l_txmsg.txfields('24').value := rec.recustname;
        --30    Di?n gi?i   C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
        --90    H? t?n   C
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.fullname;
        --RIGHTOFFQTTY
        l_txmsg.txfields ('14').defname   := 'RIGHTOFFQTTY';
        l_txmsg.txfields ('14').TYPE   := 'N';
        l_txmsg.txfields ('14').VALUE   := REC.SRIGHTOFFQTTY;
        --CAQTTYRECEIV
        l_txmsg.txfields ('15').defname   := 'CAQTTYRECEIV';
        l_txmsg.txfields ('15').TYPE   := 'N';
        l_txmsg.txfields ('15').VALUE   := REC.SCAQTTYRECEIV;
        --CAQTTYDB
        l_txmsg.txfields ('16').defname   := 'CAQTTYDB';
        l_txmsg.txfields ('16').TYPE   := 'N';
        l_txmsg.txfields ('16').VALUE   := REC.SCAQTTYDB;
        --CAAMTRECEIV
        l_txmsg.txfields ('17').defname   := 'CAAMTRECEIV';
        l_txmsg.txfields ('17').TYPE   := 'N';
        l_txmsg.txfields ('17').VALUE   := REC.SCAAMTRECEIV;

        --RIGHTQTTY
        l_txmsg.txfields ('19').defname   := 'RIGHTQTTY';
        l_txmsg.txfields ('19').TYPE   := 'N';
        l_txmsg.txfields ('19').VALUE   := REC.SRIGHTQTTY;

        --VSDMESSAGETYPE
        l_txmsg.txfields ('97').defname   := 'VSDMESSAGETYPE';
        l_txmsg.txfields ('97').TYPE   := 'C';
        l_txmsg.txfields ('97').VALUE   := REC.VSDMESSAGETYPE;
        begin
          if txpks_#2265.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;
      END;
      ELSIF rec0.msgtype = '542' THEN
        BEGIN
          for rec in (select seo.autoid, seo.txnum, seo.txdate, seo.acctno, seo.trade, seo.blocked, seo.caqtty,
                         seo.strade, seo.sblocked, seo.scaqtty, seo.ctrade, seo.cblocked, seo.ccaqtty,
                         seo.recustodycd, seo.recustname, seo.deltd,
                         seo.status, seo.codeid, seo.price, seo.outward, seo.id2255,
                         seo.trtype, seo.qttytype,seo.vsdmessagetype, cf.fullname, cf.custodycd, af.acctno afacctno,
                         sec.symbol, se.costprice,
                         seo.srightoffqtty, seo.Scaamtreceiv, seo.Scaqttydb, seo.srightqtty, seo.Scaqttyreceiv
                   from sesendout seo, cfmast cf, afmast af,
                         sbsecurities sec, semast se, vsdtxreq rq
                   where substr(seo.acctno, 0, 10) = af.acctno
                     and af.custid = cf.custid
                     and sec.codeid = seo.codeid
                     and se.acctno = seo.acctno
                     and seo.strade + seo.sblocked + seo.scaqtty + seo.srightoffqtty + seo.scaqttyreceiv + seo.scaqttydb + seo.scaamtreceiv + seo.srightqtty > 0
                     and deltd = 'N'
                     and rq.refcode = seo.autoid
                     and rq.reqid = pv_reqid
                    ) LOOP

        select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
        --01    M?h?ng kho?  C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --02    S? TK ghi N?   C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03    S? TK CK ghi N?   C
        l_txmsg.txfields('03').defname := 'ACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --05    S? LK   C
        l_txmsg.txfields('05').defname := 'CUSTODYCD';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.custodycd;
        --06    S? lu?ng CK phong t?a   N
        l_txmsg.txfields('06').defname := 'BLOCKED';
        l_txmsg.txfields('06').type := 'N';
        l_txmsg.txfields('06').value := rec.sblocked;
        --07    Ch?ng kho?  C
        l_txmsg.txfields('07').defname := 'SYMBOL';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.symbol;
        --10    S? lu?ng giao d?ch   N
        l_txmsg.txfields('10').defname := 'TRADE';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.strade;
        --12    T?ng s? lu?ng   N
        l_txmsg.txfields('12').defname := 'QTTY';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.strade + rec.sblocked;
        --13    S? lu?ng CK CA   N
        l_txmsg.txfields('13').defname := 'CAQTTY';
        l_txmsg.txfields('13').type := 'N';
        l_txmsg.txfields('13').value := rec.scaqtty;
        --18    AUTOID   N
        l_txmsg.txfields('18').defname := 'AUTOID';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.autoid;
        --23    S? LK ngu?i nh?n   C
        l_txmsg.txfields('23').defname := 'RECUSTODYCD';
        l_txmsg.txfields('23').type := 'C';
        l_txmsg.txfields('23').value := rec.recustodycd;
        --24    T?ngu?i nh?n   C
        l_txmsg.txfields('24').defname := 'RECUSTNAME';
        l_txmsg.txfields('24').type := 'C';
        l_txmsg.txfields('24').value := rec.recustname;
        --30    Di?n gi?i   C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
        --90    H? t?  C
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.fullname;

        --RIGHTOFFQTTY
        l_txmsg.txfields ('14').defname   := 'RIGHTOFFQTTY';
        l_txmsg.txfields ('14').TYPE   := 'N';
        l_txmsg.txfields ('14').VALUE   := REC.SRIGHTOFFQTTY;
        --CAQTTYRECEIV
        l_txmsg.txfields ('15').defname   := 'CAQTTYRECEIV';
        l_txmsg.txfields ('15').TYPE   := 'N';
        l_txmsg.txfields ('15').VALUE   := REC.SCAQTTYRECEIV;
        --CAQTTYDB
        l_txmsg.txfields ('16').defname   := 'CAQTTYDB';
        l_txmsg.txfields ('16').TYPE   := 'N';
        l_txmsg.txfields ('16').VALUE   := REC.SCAQTTYDB;
        --CAAMTRECEIV
        l_txmsg.txfields ('17').defname   := 'CAAMTRECEIV';
        l_txmsg.txfields ('17').TYPE   := 'N';
        l_txmsg.txfields ('17').VALUE   := REC.SCAAMTRECEIV;

        --RIGHTQTTY
        l_txmsg.txfields ('19').defname   := 'RIGHTQTTY';
        l_txmsg.txfields ('19').TYPE   := 'N';
        l_txmsg.txfields ('19').VALUE   := REC.SRIGHTQTTY;
         --VSDMESSAGETYPE
        l_txmsg.txfields ('97').defname   := 'VSDMESSAGETYPE';
        l_txmsg.txfields ('97').TYPE   := 'C';
        l_txmsg.txfields ('97').VALUE   := REC.VSDMESSAGETYPE;
        begin
          if txpks_#2265.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;
      END;
      END IF;
      FOR REC_1 IN (SELECT * FROM VSDTRFLOG LOG WHERE LOG.AUTOID = pv_vsdtrfid)
      LOOP
       if nvl(p_err_code, 0) = 0 THEN
        IF INSTR(REC_1.FUNCNAME,'.NAK') = 0 THEN
          update vsdtxreq
             set status = 'R', msgstatus = 'R' --boprocess = 'Y'
           where reqid = pv_reqid;
        END if;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid; -- l_txmsg.txfields('09').value;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;
END LOOP;
    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_2265',
         l_sqlerrnum || dbms_utility.format_error_backtrace);
  end auto_call_txpks_2265;

  procedure auto_call_txpks_8816(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
  begin
    --Lay thong tin dien confirm
    for rec0 in (select req.*, rl.funcname
                   from vsdtxreq req, vsdtrflog rl
                  where req.msgstatus in ('N', 'R', 'W')
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    and req.reqid = pv_reqid
                    AND req.reqid = rl.referenceid)
    loop

      -- nap giao dich de xu ly
      l_tltxcd       := '8816';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := getcurrdate;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (

                  select fn_get_location(af.brid) location, cf.custodycd,
                          c.codeid, c.symbol, c.parvalue, a.afacctno, b.*,
                          cf.idcode, a4.cdcontent tradeplace
                    from semast a, seretail b, sbsecurities c, afmast af,
                          cfmast cf, allcode a4, vsdtxreq rq
                   where a.acctno = b.acctno
                     and a.codeid = c.codeid
                     and b.qtty > 0
                     and b.status = 'S'
                     and af.acctno = a.afacctno
                     and af.custid = cf.custid
                     and a4.cdtype = 'SE'
                     and a4.cdname = 'TRADEPLACE'
                     and a4.cdval = c.tradeplace
                     and rq.refcode = b.txnum
                     and rq.reqid = pv_reqid
     ) loop
        --03    S? t?kho?n SE   C
        l_txmsg.txfields('03').defname := 'SEACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.afacctno;
        --04    Ng?l?p Ti?u kho?n   D
        l_txmsg.txfields('04').defname := 'TXDATE';
        l_txmsg.txfields('04').type := 'D';
        l_txmsg.txfields('04').value := rec.txdate;
        --12    Lo?i di?u ki?n   N
        l_txmsg.txfields('12').defname := 'PARVALUE';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.parvalue;
        --05    S? giao d?ch   C
        l_txmsg.txfields('05').defname := 'TXNUM';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.txnum;
        --30    M?   C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
        --02    S? Ti?u kho?n b?  C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --01    M?h?ng kho?  C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --11    Gi? N
        l_txmsg.txfields('11').defname := 'QUOTEPRICE';
        l_txmsg.txfields('11').type := 'N';
        l_txmsg.txfields('11').value := rec.price;
        --10    Kh?i lu?ng   N
        l_txmsg.txfields('10').defname := 'ORDERQTTY';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.qtty;

        begin
          if txpks_#8816.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;
      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'R', msgstatus = CASE WHEN instr(rec0.funcname,'NAK') > 0 THEN 'N' ELSE 'R' END  --boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_8816',
         l_sqlerrnum || dbms_utility.format_error_backtrace);
  end auto_call_txpks_8816;

/*  procedure auto_call_txpks_8894(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_effect_date date;
  BEGIN
    -- Lay ngay hieu luc hach toan TRADDET.98A.ESET tu dien xac nhan cua VSD
    -- FLDNAME la VSDEFFDATE
    begin
      select to_date(fldval, 'YYYYMMDD')
        into l_effect_date
        from vsdtrflogdtl
       where refautoid = pv_vsdtrfid
         and fldname = 'VSDEFFDATE';
    exception
      when others then
        l_effect_date := getcurrdate;
    end;

    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where req.msgstatus in ('C', 'W')
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '8894';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := l_effect_date;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select cf.custodycd, substr(b.desacctno, 1, 10) afddi,
                         c.codeid, c.symbol, c.parvalue, a.afacctno, b.txdate,
                         b.txnum, b.acctno, b.price, b.qtty, b.status,
                         b.desacctno, b.feeamt, b.taxamt, b.sdate, b.vdate,
                         cf.idcode, a4.cdcontent tradeplace,
                         case
                           when ci.corebank = 'Y' then
                            0
                           else
                            1
                         end iscorebank,
                          b.qtty *
                                b.price / 100 *
                                (select to_number(varvalue)
                                   from sysvar
                                  where varname = 'ADVSELLDUTY') tax,
                         ci.depolastdt, nvl(pit.qtty, 0) pitqtty,
                         nvl(pit.aright, 0) pitamt2, cf.fullname,
                         to_char(b.txdate, 'dd/mm/yyyy') || b.txnum accref
                    from semast a, seretail b, sbsecurities c, afmast af,
                         cfmast cf, allcode a4, aftype afty, cimast ci,
                         vsdtxreq rq,
                         (select orgorderid orderid, sum(qtty) qtty,
                                  sum(aright) aright
                             from sepitallocate
                            group by orgorderid) pit
                   where a.acctno = b.acctno
                     and a.codeid = c.codeid
                     and b.qtty > 0
                     and b.status = 'I'
                     and af.acctno = a.afacctno
                     and af.custid = cf.custid
                     and a4.cdtype = 'SE'
                     and a4.cdname = 'TRADEPLACE'
                     and a4.cdval = c.tradeplace
                     and af.actype = afty.actype
                     and af.acctno = ci.acctno
                     and to_char(b.txdate, 'DDMMRRRR') || b.txnum =
                         pit.orderid(+)
                     and rq.refcode = b.txnum
                     and rq.reqid = pv_reqid) loop
        --06    S? tham chi?u   C
        l_txmsg.txfields('06').defname := 'ACCREF';
        l_txmsg.txfields('06').type := 'C';
        l_txmsg.txfields('06').value := rec.accref;
        --30    Di?n gi?i   C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := '';
        --88    S? TK luu k? b?  C
        l_txmsg.txfields('88').defname := 'CUSTODYCD';
        l_txmsg.txfields('88').type := 'C';
        l_txmsg.txfields('88').value := rec.custodycd;
        --02    S? TK b?  C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03    S? TK SE  b?  C
        l_txmsg.txfields('03').defname := 'SEACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --10    Kh?i lu?ng   N
        l_txmsg.txfields('10').defname := 'ORDERQTTY';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.qtty;
        --19    Thu? b?CK quy?n   N
        l_txmsg.txfields('19').defname := 'PITAMT';
        l_txmsg.txfields('19').type := 'N';
        l_txmsg.txfields('19').value := rec.pitamt2;
        --14    Thu?   N
        l_txmsg.txfields('14').defname := 'TAX';
        l_txmsg.txfields('14').type := 'N';
        l_txmsg.txfields('14').value := rec.tax;
        --18    CK quy?n   N
        l_txmsg.txfields('18').defname := 'PITQTTY';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.pitqtty;
        --04    Ng?l?p Ti?u kho?n   C
        l_txmsg.txfields('04').defname := 'TXDATE';
        l_txmsg.txfields('04').type := 'C';
        l_txmsg.txfields('04').value := rec.txdate;
        --05    S? ch?ng t?   C
        l_txmsg.txfields('05').defname := 'TXNUM';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.txnum;
        --11    Gi? N
        l_txmsg.txfields('11').defname := 'QUOTEPRICE';
        l_txmsg.txfields('11').type := 'N';
        l_txmsg.txfields('11').value := rec.price;
        --01    M?h?ng kho?  C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --12    M?nh gi? N
        l_txmsg.txfields('12').defname := 'PARVALUE';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.parvalue;
        --07    S? TK mua   C
        l_txmsg.txfields('07').defname := 'AFACCTNO2';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.afddi;
        --22    Ph?D l?   N
        l_txmsg.txfields('22').defname := 'FEEAMT';
        l_txmsg.txfields('22').type := 'N';
        l_txmsg.txfields('22').value := rec.feeamt;
        --60    L?K ng?h?   N
        l_txmsg.txfields('60').defname := 'ISCOREBANK';
        l_txmsg.txfields('60').type := 'N';
        l_txmsg.txfields('60').value := rec.iscorebank;
        --90    H? t?  C
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.fullname;
        --08    S?TK SE  mua   C
        l_txmsg.txfields('08').defname := 'SEACCTNO2';
        l_txmsg.txfields('08').type := 'C';
        l_txmsg.txfields('08').value := rec.acctno;
        --15    Thu? TNCN   N
        l_txmsg.txfields('15').defname := 'TAXAMT';
        l_txmsg.txfields('15').type := 'N';
        l_txmsg.txfields('15').value := rec.taxamt;
        begin
          if txpks_#8894.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;

      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;

      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_8894',
         l_sqlerrnum || dbms_utility.format_error_backtrace);
  end auto_call_txpks_8894;*/

  procedure auto_call_txpks_8879(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
  begin
    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where req.msgstatus in ('C', 'W')
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    and req.reqid = pv_reqid) loop
      -- nap giao dich de xu ly
      l_tltxcd       := '8879';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := getcurrdate;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (

                  select fn_get_location(af.brid) location, cf.custodycd,
                          b.desacctno afddi, c.codeid, c.symbol, c.parvalue,
                          a.afacctno, to_char(b.txdate, 'dd/mm/yyyy') txdate,
                          b.txnum, b.acctno, b.price, b.qtty, b.status,
                          b.desacctno, b.feeamt, b.taxamt, b.sdate, b.vdate,
                          cf.idcode, a4.cdcontent tradeplace,
                          case
                            when ci.corebank = 'Y' then
                             0
                            else
                             1
                          end iscorebank,
                           b.qtty * b.price / 100 *
                                 (select to_number(varvalue)
                                    from sysvar
                                   where varname = 'ADVSELLDUTY') tax,
                          ci.depolastdt,
                          fn_get_retailsell_caqtty(b.qtty, b.acctno) pitqtty,
                          round(fn_get_retailsell_cavat(b.qtty, b.acctno) *
                                (case
                                   when b.price > c.parvalue then
                                    c.parvalue
                                   else
                                    b.price
                                 end) / 100) pitamt, cf.fullname,
                          to_char(b.txdate, 'dd/mm/yyyy') || b.txnum accref,
                          (a.afacctno || nvl(c.refcodeid, c.codeid)) db_acctno_updatecost,
                          (substr(b.desacctno, 1, 10) ||
                           nvl(c.refcodeid, c.codeid)) cd_acctno_updatecost
                    from semast a, seretail b, sbsecurities c, afmast af,
                          cfmast cf, allcode a4, aftype afty, cimast ci,
                          vsdtxreq rq
                   where a.acctno = b.acctno
                     and a.codeid = c.codeid
                     and b.qtty > 0
                     and b.status = 'S'
                     and af.acctno = a.afacctno
                     and af.custid = cf.custid
                     and a4.cdtype = 'SE'
                     and a4.cdname = 'TRADEPLACE'
                     and a4.cdval = c.tradeplace
                     and af.actype = afty.actype
                     and af.acctno = ci.acctno
                     and rq.refcode = b.txnum
                     and rq.reqid = pv_reqid)

       loop
        --01    M?h?ng kho?  C
        l_txmsg.txfields('01').defname := 'CODEID';
        l_txmsg.txfields('01').type := 'C';
        l_txmsg.txfields('01').value := rec.codeid;
        --19    Thu? d?u tu v?n   N
        l_txmsg.txfields('19').defname := 'PITAMT';
        l_txmsg.txfields('19').type := 'N';
        l_txmsg.txfields('19').value := rec.pitamt;
        --02    S? TK b?  C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --88    S? TK luu k? b?  C
        l_txmsg.txfields('88').defname := 'CUSTODYCD';
        l_txmsg.txfields('88').type := 'C';
        l_txmsg.txfields('88').value := rec.custodycd;
        --22    Ph?D l?   N
        l_txmsg.txfields('22').defname := 'FEEAMT';
        l_txmsg.txfields('22').type := 'N';
        l_txmsg.txfields('22').value := rec.feeamt;
        --32    Ng?chuy?n ph?K d?n h?n g?n nh?t   D
        l_txmsg.txfields('32').defname := 'DEPOLASTDT';
        l_txmsg.txfields('32').type := 'D';
        l_txmsg.txfields('32').value := rec.depolastdt;
        --15    Thu? TNCN   N
        l_txmsg.txfields('15').defname := 'TAXAMT';
        l_txmsg.txfields('15').type := 'N';
        l_txmsg.txfields('15').value := rec.taxamt;
        --14    Thu? chuy?n nhu?ng   N
        l_txmsg.txfields('14').defname := 'TAX';
        l_txmsg.txfields('14').type := 'N';
        l_txmsg.txfields('14').value := rec.tax;
        --11    Gi? N
        l_txmsg.txfields('11').defname := 'QUOTEPRICE';
        l_txmsg.txfields('11').type := 'N';
        l_txmsg.txfields('11').value := rec.price;
        --05    S? ch?ng t?   C
        l_txmsg.txfields('05').defname := 'TXNUM';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.txnum;
        --04    Ng?l?p Ti?u kho?n   C
        l_txmsg.txfields('04').defname := 'TXDATE';
        l_txmsg.txfields('04').type := 'C';
        l_txmsg.txfields('04').value := rec.txdate;
        --10    Kh?i lu?ng   N
        l_txmsg.txfields('10').defname := 'ORDERQTTY';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.qtty;
        --03    S? TK SE  b?  C
        l_txmsg.txfields('03').defname := 'SEACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --60    L?K ng?h?   N
        l_txmsg.txfields('60').defname := 'ISCOREBANK';
        l_txmsg.txfields('60').type := 'N';
        l_txmsg.txfields('60').value := rec.iscorebank;
        --18    CK quy?n   N
        l_txmsg.txfields('18').defname := 'PITQTTY';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.pitqtty;
        --12    M?nh gi? N
        l_txmsg.txfields('12').defname := 'PARVALUE';
        l_txmsg.txfields('12').type := 'N';
        l_txmsg.txfields('12').value := rec.parvalue;
        --07    S? TK mua   C
        l_txmsg.txfields('07').defname := 'AFACCTNO2';
        l_txmsg.txfields('07').type := 'C';
        l_txmsg.txfields('07').value := rec.afddi;
        --23    S? TK b?update gi??n   C
        l_txmsg.txfields('23').defname := 'SEACCTNO';
        l_txmsg.txfields('23').type := 'C';
        l_txmsg.txfields('23').value := rec.desacctno;
        --28    S? TK mua update i??n   C
        l_txmsg.txfields('28').defname := 'SEACCTNO2';
        l_txmsg.txfields('28').type := 'C';
        l_txmsg.txfields('28').value := rec.desacctno;
        --06    S? tham chi?u   C
        l_txmsg.txfields('06').defname := 'ACCREF';
        l_txmsg.txfields('06').type := 'C';
        l_txmsg.txfields('06').value := rec.accref;
        --90    H? t?  C
        l_txmsg.txfields('90').defname := 'CUSTNAME';
        l_txmsg.txfields('90').type := 'C';
        l_txmsg.txfields('90').value := rec.fullname;
        --08    S?TK SE  mua   C
        l_txmsg.txfields('08').defname := 'SEACCTNO2';
        l_txmsg.txfields('08').type := 'C';
        l_txmsg.txfields('08').value := rec.desacctno;
        --30    Di?n gi?i   C
        l_txmsg.txfields('30').defname := 'DESC';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
        --16    Ph?K chua d?n h?n   N
        l_txmsg.txfields('16').defname := 'DEPOFEEACR';
        l_txmsg.txfields('16').type := 'N';
        l_txmsg.txfields('16').value := 0;
        --17    Ph?K d?n h?n   N
        l_txmsg.txfields('17').defname := 'DEPOFEEAMT';
        l_txmsg.txfields('17').type := 'N';
        l_txmsg.txfields('17').value := 0;
        begin
          if txpks_#8879.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
          end if;
        end;
      end loop;
      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
  exception
    when others then
      l_sqlerrnum := substr(sqlerrm, 200);
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate, 'AUTO_CALL_TXPKS_8879',
         l_sqlerrnum || dbms_utility.format_error_backtrace);
  end auto_call_txpks_8879;
  procedure auto_call_txpks_2248(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_effect_date date;
    v_custodycd   VARCHAR2(500);
    v_count       NUMBER;
  begin
    plog.setbeginsection(pkgctx, 'auto_call_txpks_2248');
    plog.info(pkgctx, 'process req id:' || pv_reqid);
    -- Lay ngay hieu luc hach toan TRADDET.98A.ESET tu dien xac nhan cua VSD
    -- FLDNAME la VSDEFFDATE
    begin
      select to_date(fldval, 'YYYYMMDD')
        into l_effect_date
        from vsdtrflogdtl
       where refautoid = pv_vsdtrfid
         and fldname = 'VSDEFFDATE';
    exception
      when others then
        l_effect_date := getcurrdate;
    end;

    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where req.msgstatus in ('C', 'W')
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '2248';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := l_effect_date;
      l_txmsg.txdate    := getcurrdate;

      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select fn_get_location(substr(a.afacctno, 1, 4)) location,
                         replace(a.acctno, '.', '') acctno, a.symbol,
                         replace(a.afacctno, '.', '') afacctno, a.dtoclose, a.codeid, a.parvalue,
                         a.selastdate, a.aflastdate, a.lastdate, a.custodycd,
                         a.fullname, a.idcode, a.typename, a.tradeplace,
                         a.sendpbalance, a.sendamt, a.sendaqtty, a.rightqtty,
                         a.qtty,
                        -- a.BLOCKDTOCLOSE,
                          --(a.BLOCKDTOCLOSE+a.DTOCLOSE) SEQTTY
                          a.DTOCLOSE  SEQTTY
                    from v_se2248 a, vsdtxreq rq, cfmast cf, afmast af
                   where 0 = 0
                       /* and substr(rq.refcode, 1, 4) || '.' ||
                        substr(rq.refcode, 5, 6) || '.' ||
                        substr(rq.refcode, 11, 6) = a.acctno*/
                     and cf.custid = af.custid
                     and af.acctno = rq.afacctno
                     and a.custodycd = cf.custodycd
                     and rq.reqid = pv_reqid
                  ) LOOP
     select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;

        --08    S? lu?ng CK giao d?ch   N
    -- l_txmsg.txfields ('08').defname   := 'DTOCLOSE';
    -- l_txmsg.txfields ('08').TYPE      := 'N';
    -- l_txmsg.txfields ('08').value      := rec.DTOCLOSE;
--09    S? lu?ng CK HCCN   N
     --l_txmsg.txfields ('09').defname   := 'BLOCKDTOCLOSE';
     --l_txmsg.txfields ('09').TYPE      := 'N';
     --l_txmsg.txfields ('09').value      := rec.BLOCKDTOCLOSE;
--10    S? lu?ng   N
     l_txmsg.txfields ('10').defname   := 'QTTY';
     l_txmsg.txfields ('10').TYPE      := 'N';
     l_txmsg.txfields ('10').value      := rec.SEQTTY;
--16    SLCK CA ghi gi?m   N
     l_txmsg.txfields ('16').defname   := 'CAQTTYDB';
     l_txmsg.txfields ('16').TYPE      := 'N';
     l_txmsg.txfields ('16').value      := rec.SENDAQTTY;
--88    S? TK luu k? b?  C
     l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
     l_txmsg.txfields ('88').TYPE      := 'C';
     l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
--90    H? t?  C
     l_txmsg.txfields ('90').defname   := 'CUSTNAME';
     l_txmsg.txfields ('90').TYPE      := 'C';
     l_txmsg.txfields ('90').value      := rec.FULLNAME;
--02    S? Ti?u kho?n   C
     l_txmsg.txfields ('02').defname   := 'AFACCTNO';
     l_txmsg.txfields ('02').TYPE      := 'C';
     l_txmsg.txfields ('02').value      := rec.AFACCTNO;
--01    M?h?ng kho?  C
     l_txmsg.txfields ('01').defname   := 'CODEID';
     l_txmsg.txfields ('01').TYPE      := 'C';
     l_txmsg.txfields ('01').value      := rec.CODEID;
--03    S? t?kho?n   C
     l_txmsg.txfields ('03').defname   := 'ACCTNO';
     l_txmsg.txfields ('03').TYPE      := 'C';
     l_txmsg.txfields ('03').value      := rec.ACCTNO;
--14    SL Quy?n mua chua ?   N
     l_txmsg.txfields ('14').defname   := 'RIGHTOFFQTTY';
     l_txmsg.txfields ('14').TYPE      := 'N';
     l_txmsg.txfields ('14').value      := rec.SENDPBALANCE;
--15    SL Ch?ng kho?CA   N
     l_txmsg.txfields ('15').defname   := 'CAQTTYRECEIV';
     l_txmsg.txfields ('15').TYPE      := 'N';
     l_txmsg.txfields ('15').value      := rec.QTTY;
--17    S? ti?n CA   N
     l_txmsg.txfields ('17').defname   := 'CAAMTRECEIV';
     l_txmsg.txfields ('17').TYPE      := 'N';
     l_txmsg.txfields ('17').value      := rec.SENDAMT;
--18    S? quy?n bi?u quy?t   N
     l_txmsg.txfields ('18').defname   := 'RIGHTQTTY';
     l_txmsg.txfields ('18').TYPE      := 'N';
     l_txmsg.txfields ('18').value      := rec.RIGHTQTTY;
--11    M?nh gi? N
     l_txmsg.txfields ('11').defname   := 'PARVALUE';
     l_txmsg.txfields ('11').TYPE      := 'N';
     l_txmsg.txfields ('11').value      := rec.PARVALUE;
--30    M?   C
     l_txmsg.txfields ('30').defname   := 'DESC';
     l_txmsg.txfields ('30').TYPE      := 'C';
     l_txmsg.txfields ('30').value      := l_strdesc;
        begin

          if txpks_#2248.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
            --RETURN;
          end if;
        end;
      end loop;
      --if nvl(p_err_code, 0) = 0 THEN
    end loop;
    --KT DA THUC HIEN HET 2248 CHUA
      SELECT dtl.cval INTO v_custodycd FROM vsdtxreqdtl dtl WHERE dtl.reqid = pv_reqid AND dtl.fldname = 'CUSTODYCD';
      SELECT COUNT(*) INTO v_count FROM v_se2248 WHERE custodycd = v_custodycd;
    IF v_count = 0 THEN
      COMMIT;
        plog.error(pkgctx, 'GOI 2249');
        --auto_call_txpks_2249(pv_reqid,pv_vsdtrfid);
        update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;
         -- goi gd 2249


        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code || '2248'
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;
   plog.setendsection(pkgctx, 'auto_call_txpks_2248');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
         plog.setendsection(pkgctx, 'auto_call_txpks_2248');
  end auto_call_txpks_2248;

  /*procedure auto_call_txpks_2249(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_effect_date date;
    l_custodycd   VARCHAR2(50);
    l_custname    VARCHAR2(500);
    V_COUNT       NUMBER;
    V_BRID        VARCHAR2(10);
  begin
    plog.setbeginsection(pkgctx, 'auto_call_txpks_2249');
    plog.error(pkgctx, 'VAO XULY 2249');
    --plog.info(pkgctx, 'acctno:' || p_afacctno);
    SELECT DTL.CVAL, VSD.BRID INTO l_custodycd,V_BRID FROM VSDTXREQDTL DTL, VSDTXREQ VSD
    WHERE DTL.FLDNAME = 'CUSTODYCD' AND DTL.REQID = pv_reqid AND VSD.REQID = DTL.REQID;
     l_tltxcd       := '2249';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := l_effect_date;
      l_txmsg.txdate    := getcurrdate;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
        --Set txnum

      l_txmsg.brid := V_BRID;
      -- lay thoong tin kh
      FOR rec IN
        (
          SELECT cf.custodycd, cf.fullname, af.acctno  FROM cfmast cf, afmast af
          WHERE cf.custid = af.custid
          AND CF.CUSTODYCD = l_custodycd
          ) LOOP
             SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
      --acctno
      l_txmsg.txfields ('02').defname   := 'ACCTNO';
      l_txmsg.txfields ('02').TYPE   := 'C';
      l_txmsg.txfields ('02').VALUE   := rec.acctno;
      --DESC
      l_txmsg.txfields ('30').defname   := 'DESC';
      l_txmsg.txfields ('30').TYPE   := 'C';
      l_txmsg.txfields ('30').VALUE   := l_strdesc;

      --CUSTODYCD
      l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
      l_txmsg.txfields ('88').TYPE   := 'C';
      l_txmsg.txfields ('88').VALUE   := rec.custodycd;
      --CUSTNAME
      l_txmsg.txfields ('90').defname   := 'CUSTNAME';
      l_txmsg.txfields ('90').TYPE   := 'C';
      l_txmsg.txfields ('90').VALUE   := rec.fullname;

      begin

          if txpks_#2249.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
            --RETURN;
          --ELSE
             --auto_call_txpks_0059(l_custodycd);
             --RETURN;
          end if;
        end;
      END LOOP;
     --KIEM TRA XEM DA DONG HET CAC TIEU KHOAN CHUA
     COMMIT;
     SELECT COUNT(*) INTO V_COUNT FROM CFMAST CF, AFMAST AF
     WHERE CF.CUSTID = AF.CUSTID
     AND CF.CUSTODYCD = l_custodycd
     AND AF.STATUS <> 'C';
     --NEU DA DONG HET TIEU KHOAN THI GOI 0059 DE DONG TAI KHOAN
     IF V_COUNT = 0 THEN
       plog.error(pkgctx, 'GOI 0059');
      --auto_call_txpks_0059(pv_reqid, pv_vsdtrfid);
     ELSE
       update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code || '2249'
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
     END IF;
     plog.setendsection(pkgctx, 'auto_call_txpks_2249');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
         plog.setendsection(pkgctx, 'auto_call_txpks_2249');
  end auto_call_txpks_2249;*/

/*  procedure auto_call_txpks_0059(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    l_effect_date date;
    l_custid      VARCHAR2(50);
    l_custodycd VARCHAR2(50);
  begin
    plog.setbeginsection(pkgctx, 'auto_call_txpks_0059');
    --plog.info(pkgctx, 'custodycd:' || p_custodycd);
     SELECT DTL.CVAL INTO l_custodycd FROM VSDTXREQDTL DTL WHERE DTL.FLDNAME = 'CUSTODYCD' AND DTL.REQID = pv_reqid;
     l_tltxcd       := '0059';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := l_effect_date;
      l_txmsg.txdate    := getcurrdate;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
        --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
      SELECT cf.custid INTO l_custid FROM cfmast cf WHERE cf.custodycd = l_custodycd;

      l_txmsg.brid := substr(l_custid,1,4);

      --CUSTID
      l_txmsg.txfields ('03').defname   := 'CUSTID';
      l_txmsg.txfields ('03').TYPE   := 'C';
      l_txmsg.txfields ('03').VALUE   := l_custid;
      --DESC
      l_txmsg.txfields ('30').defname   := 'DESC';
      l_txmsg.txfields ('30').TYPE   := 'C';
      l_txmsg.txfields ('30').VALUE   := l_strdesc;
      --CUSTODYCD
      l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
      l_txmsg.txfields ('88').TYPE   := 'C';
      l_txmsg.txfields ('88').VALUE   := l_custodycd;
      --SENDTOVSD
      l_txmsg.txfields ('99').defname   := 'SENDTOVSD';
      l_txmsg.txfields ('99').TYPE   := 'C';
      l_txmsg.txfields ('99').VALUE   := 'N';
      begin

          if txpks_#0059.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            rollback;
            --RETURN;
          end if;
        end;
      if nvl(p_err_code, 0) = 0 THEN
        plog.error(pkgctx, 'HOAN THANH');

        update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code || '0059'
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

     plog.setendsection(pkgctx, 'auto_call_txpks_0059');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
         plog.setendsection(pkgctx, 'auto_call_txpks_0059');
  end auto_call_txpks_0059;*/

  procedure auto_call_txpks_2290(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
  begin
    plog.setbeginsection(pkgctx, 'auto_call_txpks_2290');
    plog.info(pkgctx, 'process req id:' || pv_reqid);
    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where req.msgstatus in ('N','R', 'W')
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    and req.reqid = pv_reqid) loop

      -- nap giao dich de xu ly
      l_tltxcd       := '2290';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := getcurrdate;
      l_txmsg.txdate    := getcurrdate;

      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid;
      plog.info(pkgctx, 'process req id:' || pv_reqid);-- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      for rec in (select a.*
                    from v_se2290 a, vsdtxreq rq
                   where 0 = 0
                     and rq.afacctno = a.afacctno
                     and rq.reqid = pv_reqid) LOOP
        select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;

        --02    S? Ti?u kho?n   C
        l_txmsg.txfields('02').defname := 'AFACCTNO';
        l_txmsg.txfields('02').type := 'C';
        l_txmsg.txfields('02').value := rec.afacctno;
        --03    T?kho?n ch?ng kho?  C
        l_txmsg.txfields('03').defname := 'ACCTNO';
        l_txmsg.txfields('03').type := 'C';
        l_txmsg.txfields('03').value := rec.acctno;
        --04    M?h?ng kho?  C
        l_txmsg.txfields('04').defname := 'SYMBOL';
        l_txmsg.txfields('04').type := 'C';
        l_txmsg.txfields('04').value := rec.symbol;
        --05    Tr?ng th?  C
        l_txmsg.txfields('05').defname := 'STATUS';
        l_txmsg.txfields('05').type := 'C';
        l_txmsg.txfields('05').value := rec.status;
        --06    S? du ch?ng kho?  N
        l_txmsg.txfields('06').defname := 'TRADE';
        l_txmsg.txfields('06').type := 'N';
        l_txmsg.txfields('06').value := rec.trade;
        --10    SL CK chuy?n ch? d?  N
        l_txmsg.txfields('10').defname := 'DTOCLOSE';
        l_txmsg.txfields('10').type := 'N';
        l_txmsg.txfields('10').value := rec.dtoclose;
        --11    SL CK phong t?a ch? d?  N
        l_txmsg.txfields('11').defname := 'BLOCKDTOCLOSE';
        l_txmsg.txfields('11').type := 'N';
        l_txmsg.txfields('11').value := rec.DTBLOCKED;
        --14    SL Quy?n mua chua ?   N
        l_txmsg.txfields('14').defname := 'RIGHTOFFQTTY';
        l_txmsg.txfields('14').type := 'N';
        l_txmsg.txfields('14').value := rec.sendpbalance;
        --15    SL Ch?ng kho?CA   N
        l_txmsg.txfields('15').defname := 'CAQTTYRECEIV';
        l_txmsg.txfields('15').type := 'N';
        l_txmsg.txfields('15').value := rec.qtty;
        --17    S? ti?n CA   N
        l_txmsg.txfields('17').defname := 'CAAMTRECEIV';
        l_txmsg.txfields('17').type := 'N';
        l_txmsg.txfields('17').value := rec.sendamt;
        --18    S? quy?n bi?u quy?t   N
        l_txmsg.txfields('18').defname := 'RIGHTQTTY';
        l_txmsg.txfields('18').type := 'N';
        l_txmsg.txfields('18').value := rec.rightqtty;
        --16    SLCK CA ghi gi?m   N
        l_txmsg.txfields('16').defname := 'CAQTTYDB';
        l_txmsg.txfields('16').type := 'N';
        l_txmsg.txfields('16').value := rec.sendaqtty;
        --30    M?   C
        l_txmsg.txfields('30').defname := 'DESCRIPTION';
        l_txmsg.txfields('30').type := 'C';
        l_txmsg.txfields('30').value := l_strdesc;
        
        -- hotfix thue quyen
        l_txmsg.txfields('19').defname := 'PITQTTY';
        l_txmsg.txfields('19').type := 'N';
        l_txmsg.txfields('19').value := rec.pitqtty;
        --
        begin
          if txpks_#2290.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success then
            --rollback;
            plog.setendsection(pkgctx, 'auto_call_txpks_2290');
          end if;
        end;
      end loop;
      plog.info(pkgctx, 'pp_err_code:' || p_err_code);
      FOR REC_1 IN (SELECT * FROM VSDTRFLOG LOG WHERE LOG.AUTOID = pv_vsdtrfid)
      LOOP
          if nvl(p_err_code, 0) = 0 THEN
             IF INSTR(REC_1.FUNCNAME,'.NAK') = 0 THEN
              update vsdtxreq
                 set status = 'R', msgstatus = 'R' --boprocess = 'Y'
               where reqid = pv_reqid;
            END if;
                   -- Tr?ng th?VSDTRFLOG
            update vsdtrflog
               set status = 'C', timeprocess = systimestamp
             where autoid = pv_vsdtrfid; --l_txmsg.txfields('09').value;
          else
            -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
            update vsdtxreq
               set status = 'E', msgstatus = 'E'
                   --boprocess = 'E'
                  , boprocess_err = p_err_code
             where reqid = pv_reqid;
            -- Tr?ng th?VSDTRFLOG
            update vsdtrflog
               set status = 'C', timeprocess = systimestamp
             where autoid = pv_vsdtrfid;
          end if;
      END LOOP;

    end loop;
    plog.setendsection(pkgctx, 'auto_call_txpks_2290');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
         plog.setendsection(pkgctx, 'auto_call_txpks_2290');
  end auto_call_txpks_2290;
  procedure auto_process_inf_message(pv_autoid number, pv_funcname varchar2,
                                     pv_autoconf varchar2, pv_reqid number) as
    v_tltxcd    varchar2(4);
    v_dt_txdate date;
    v_reqid     number;
    v_vsdmsgid  VARCHAR2(50);
    v_VSDPROMSG VARCHAR2(20);
    v_VSDPROMSG_value VARCHAR2(50);
    v_symbol          VARCHAR2(10);
    v_vsdmsgdate      VARCHAR2(10);
    v_vsdmsgdate_eff  VARCHAR2(10);
    v_vsdmsgtype      VARCHAR2(10);
    v_qtty            VARCHAR2(20);

  BEGIN
    plog.setbeginsection(pkgctx, 'auto_process_inf_message');

    plog.info(pkgctx, 'process auto id:' || pv_autoid || '::function:' || pv_funcname || '::auto confirm:' || pv_autoconf || '::reqId:' || pv_reqid);

        SELECT tltxcd INTO v_tltxcd
    FROM vsdtrfcode
    WHERE trfcode = pv_funcname;
    --Neu message la tu dong xu ly
    if pv_autoconf = 'Y' then
      update vsdtrflog set status = 'A' where autoid = pv_autoid;
      if pv_funcname = '564.NEWM' then
        auto_create_camast(pv_autoid);
        -- cap nhat trang thai req
        update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;
        update vsdtrflog set status = 'C' where autoid = pv_autoid;
      /*elsif v_tltxcd = '2245' then
        auto_call_txpks_2245(pv_reqid, pv_autoid);*/
      ELSIF pv_funcname = '598.007.' THEN
        BEGIN
          SELECT *
          INTO v_vsdmsgid, v_VSDPROMSG, v_VSDPROMSG_value, v_symbol, v_vsdmsgdate, v_vsdmsgdate_eff, v_vsdmsgtype, v_qtty
          FROM (
               SELECT fldname, fldval
               FROM vsdtrflogdtl
               WHERE REFAUTOID = pv_autoid) PIVOT (MAX(fldval) as F for(fldname) IN ('VSDMSGID',
                                                            'VSDPROMSG',
                                                             'VSDPROMSGDTL',
                                                               'SYMBOL',
                                                               'VSDMSGDATE','VSDMSGDATEEFF','VSDMSGTYPE','QTTY'));

          IF INSTR(v_qtty,',') > 0 THEN
             v_qtty := SUBSTR(v_qtty, 1, LENGTH(v_qtty) - 1);
          END IF;
          --Insert thong tin vao bang VSD_MT598_INF
          INSERT INTO vsd_mt598_inf(autoid, VSDMSGID, VSDPROMSG, VSDPROMSG_VALUE, SYMBOL, VSDMSGDATE,VSDMSGDATEEFF,VSDMSGTYPE,QTTY)
          VALUES(seq_vsd_mt598_inf.nextval, v_vsdmsgid, v_VSDPROMSG, v_VSDPROMSG_value, v_symbol, to_date(v_vsdmsgdate,'RRRRMMDD'), to_date(v_vsdmsgdate_eff,'RRRRMMDD'), v_vsdmsgtype, v_qtty);
          END;
      end if;
    end if;
plog.setendsection(pkgctx, 'auto_process_inf_message');
  exception
      when no_data_found then
      plog.warn(pkgctx, 'Chua khai bao ' || pv_funcname);
      UPDATE vsdtrflog SET status = 'E' WHERE autoid = pv_autoid;
      plog.setendsection(pkgctx, 'auto_process_inf_message');
    when others then
         plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
                 plog.setendsection(pkgctx, 'auto_process_inf_message');
  end auto_process_inf_message;

  /*procedure auto_call_txpks_2245(pv_reqid number, pv_vsdtrfid number) as
    l_txmsg       tx.msg_rectype;
    v_strcurrdate varchar2(20);
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    p_err_code    number(20);
    l_err_param   varchar2(1000);
    l_sqlerrnum   varchar2(200);
    n_codeid      varchar2(6);
    pv_funcname   varchar2(50);
    l_acctno      varchar2(10);
    l_symbol      varchar2(20);
    n_count       number;
    l_address     varchar2(1000);
    l_fullname    varchar2(400);
    l_idcode      varchar2(120);
    n_price       number;
    n_parvalue    number;
    d_depolastdt  date;
BEGIN
    plog.setbeginsection(pkgctx, 'auto_call_txpks_2245');
    plog.info(pkgctx, 'process req id:' || pv_reqid);
    --Lay thong tin dien confirm
    for rec0 in (select req.*
                   from vsdtxreq req
                  where req.msgstatus in ('C', 'W')
                       --and req.status <> 'C'
                       --and req.msgstatus = 'W'
                    and req.reqid = pv_reqid) loop
      -- nap giao dich de xu ly
      l_tltxcd       := '2245';
      l_txmsg.tltxcd := l_tltxcd;
      select txdesc into l_strdesc from tltx where tltxcd = l_tltxcd;
      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := systemnums.c_system_userid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := getcurrdate;
      l_txmsg.txdate    := getcurrdate;
      select systemnums.c_batch_prefixed ||
              lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txmsg.txnum
        from dual;
      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      l_txmsg.brid := rec0.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
      select tr.funcname
        into pv_funcname
        from vsdtrflog tr
       where tr.autoid = pv_vsdtrfid;
      for rec in (select trf.fldname, trf.fldval
                    from vsdtrflogdtl trf
                   where trf.refautoid = pv_vsdtrfid) loop
        if rec.fldname = 'SYMBOL' then
          begin
            -- select codeid into N_codeid from securities_info where SYMBOL=rec.fldval;
            --01    M?h?ng kho?  C

            select seinfo.basicprice price, sec.parvalue, sec.codeid
              into n_price, n_parvalue, n_codeid
              from sbsecurities sec, securities_info seinfo
             where sec.codeid = seinfo.codeid
               and sec.sectype <> '004'
               and sec.symbol = rec.fldval
             order by sec.symbol;
          exception
            when others then
              update vsdtxreq
                 set status = 'E', msgstatus = 'E'
                     --boprocess = 'E'
                    , boprocess_err = -900015
               where reqid = pv_reqid;
              -- Tr?ng th?VSDTRFLOG
              update vsdtrflog
                 set status = 'C', timeprocess = systimestamp
               where autoid = pv_vsdtrfid;
          end;
          l_txmsg.txfields('01').defname := 'CODEID';
          l_txmsg.txfields('01').type := 'C';
          l_txmsg.txfields('01').value := n_codeid;
          --09    Gi?huy?n kho?n   N
          l_txmsg.txfields('09').defname := 'PRICE';
          l_txmsg.txfields('09').type := 'N';
          l_txmsg.txfields('09').value := n_price;
          --11    M?nh gi? N
          l_txmsg.txfields('11').defname := 'PARVALUE';
          l_txmsg.txfields('11').type := 'N';
          l_txmsg.txfields('11').value := n_parvalue;

          --98    Lo?i chuy?n kho?n   C
     l_txmsg.txfields ('98').defname   := 'Type';
     l_txmsg.txfields ('98').TYPE      := 'C';
     l_txmsg.txfields ('98').value      := '001';

        elsif rec.fldname = 'QTTY' then
          if pv_funcname = '548.PACK//NARR.CLAS//NORM.OK' or
            pv_funcname = '544.NEWM.LINK//542.SETR//TRAD.STCO//DLWM.OK' or
            pv_funcname = '544.NEWM.LINK//542.SETR//OWNI.STCO//DLWM.OK'or
            pv_funcname = '544.NEWM.LINK//542.SETR//OWNE.STCO//DLWM.OK' OR
            pv_funcname = '544.NEWM.LINK//598...OK' then
            --06    S? lu?ng ck phong t?a   N
            l_txmsg.txfields('06').defname := 'DEPOBLOCK';
            l_txmsg.txfields('06').type := 'N';
            l_txmsg.txfields('06').value := 0;
            --12    T?ng s? lu?ng   N
            l_txmsg.txfields('12').defname := 'QTTY';
            l_txmsg.txfields('12').type := 'N';
            l_txmsg.txfields('12').value := rec.fldval;
            --10    Lu?ng ch?ng kho?  N
            l_txmsg.txfields('10').defname := 'AMT';
            l_txmsg.txfields('10').type := 'N';
            l_txmsg.txfields('10').value := rec.fldval;
            --55    Ph?iao d?ch   N
     l_txmsg.txfields ('55').defname   := 'FEECOMP';
     l_txmsg.txfields ('55').TYPE      := 'N';
     l_txmsg.txfields ('55').value      := FN_GET_SE_FEE_COMP_2245('002','001',rec.fldval,n_parvalue);

--45    Ph?huy?n nhu?ng   N
     l_txmsg.txfields ('45').defname   := 'FEE';
     l_txmsg.txfields ('45').TYPE      := 'N';
     l_txmsg.txfields ('45').value      := FN_GET_SE_FEE_2245('002','001',rec.fldval,n_parvalue);
          else
            --06    S? lu?ng ck phong t?a   N
            l_txmsg.txfields('06').defname := 'DEPOBLOCK';
            l_txmsg.txfields('06').type := 'N';
            l_txmsg.txfields('06').value := rec.fldval;
            --12    T?ng s? lu?ng   N
            l_txmsg.txfields('12').defname := 'QTTY';
            l_txmsg.txfields('12').type := 'N';
            l_txmsg.txfields('12').value := rec.fldval;
            --10    Lu?ng ch?ng kho?  N
            l_txmsg.txfields('10').defname := 'AMT';
            l_txmsg.txfields('10').type := 'N';
            l_txmsg.txfields('10').value := 0;

--55    Ph?iao d?ch   N
     l_txmsg.txfields ('55').defname   := 'FEECOMP';
     l_txmsg.txfields ('55').TYPE      := 'N';
     l_txmsg.txfields ('55').value      := FN_GET_SE_FEE_COMP_2245('002','001',rec.fldval,n_parvalue);

--45    Ph?huy?n nhu?ng   N
     l_txmsg.txfields ('45').defname   := 'FEE';
     l_txmsg.txfields ('45').TYPE      := 'N';
     l_txmsg.txfields ('45').value      := FN_GET_SE_FEE_2245('002','001',rec.fldval,n_parvalue);
          end if;
        elsif rec.fldname = 'CUSTODYCD' then
          begin
            --88    S? TK luu k?   C
            l_txmsg.txfields('88').defname := 'CUSTODYCD';
            l_txmsg.txfields('88').type := 'C';
            l_txmsg.txfields('88').value := rec.fldval;
            select address, fullname, idcode
              into l_address, l_fullname, l_idcode
              from cfmast
             where custodycd = rec.fldval;
            --92    CMND/GPKD   C
            l_txmsg.txfields('92').defname := 'LICENSE';
            l_txmsg.txfields('92').type := 'C';
            l_txmsg.txfields('92').value := l_idcode;
            --90    H? t?  C
            l_txmsg.txfields('90').defname := 'CUSTNAME';
            l_txmsg.txfields('90').type := 'C';
            l_txmsg.txfields('90').value := l_fullname;
            --91    ?a ch?   C
            l_txmsg.txfields('91').defname := 'ADDRESS';
            l_txmsg.txfields('91').type := 'C';
            l_txmsg.txfields('91').value := l_address;
            select trf.fldval
              into l_symbol
              from vsdtrflogdtl trf
             where trf.refautoid = pv_vsdtrfid
               and trf.fldname = 'SYMBOL';
            select codeid
              into n_codeid
              from securities_info
             where symbol = l_symbol;
            begin
              select af.acctno
                into l_acctno
                from afmast af, cfmast cf, aftype aft, mrtype mrt
               where cf.custid = af.custid
                 and af.actype = aft.actype
                 and aft.mrtype = mrt.actype
                 --and mrt.mrtype not in ('S', 'T')
                 and af.status = 'A'
                 and cf.custodycd = rec.fldval
                 and rownum = 1;
            exception
              when others then
                update vsdtxreq
                   set status = 'E', msgstatus = 'E'
                       --boprocess = 'E'
                      , boprocess_err = -900090
                 where reqid = pv_reqid;
                -- Tr?ng th?VSDTRFLOG
                update vsdtrflog
                   set status = 'C', timeprocess = systimestamp
                 where autoid = pv_vsdtrfid;
            end;

            if n_count > 0 then
              begin
                select se.afacctno
                  into l_acctno
                  from afmast af, cfmast cf, semast se
                 where cf.custid = af.custid
                   and se.afacctno = af.acctno
                   and cf.custodycd = rec.fldval
                   and se.codeid = n_codeid;
                --04    S? ti?u kho?n ghi c?C
                l_txmsg.txfields('04').defname := 'AFACCT2';
                l_txmsg.txfields('04').type := 'C';
                l_txmsg.txfields('04').value := l_acctno;
                --05    Ti?u kho?n CK ghi c?C
                l_txmsg.txfields('05').defname := 'ACCT2';
                l_txmsg.txfields('05').type := 'C';
                l_txmsg.txfields('05').value := l_acctno || n_codeid;
                --25    TKCK update gi??n   C
                l_txmsg.txfields('25').defname := 'ACCTNO_UPDATECOST';
                l_txmsg.txfields('25').type := 'C';
                l_txmsg.txfields('25').value := l_acctno || n_codeid;
                select to_date(ci.depolastdt, 'DD/MM/RRRR')
                  into d_depolastdt
                  from cimast ci, allcode a0, allcode a1, cfmast cf,
                       sbcurrency sb, afmast af, aftype aft
                 where cf.custid = ci.custid
                   and ci.ccycd = sb.ccycd
                   and a0.cdtype = 'CI'
                   and a0.cdname = 'STATUS'
                   and a0.cdval = ci.status
                   and a1.cdtype = 'SY'
                   and a1.cdname = 'YESNO'
                   and a1.cdval = ci.iccftied
                   and ci.afacctno = af.acctno
                   and af.actype = aft.actype
                   and af.acctno = l_acctno;
                --32    Ng?chuy?n ph?K d?n h?n g?n nh?t   C
                l_txmsg.txfields('32').defname := 'DEPOLASTDT';
                l_txmsg.txfields('32').type := 'C';
                l_txmsg.txfields('32').value := d_depolastdt;
              end;
            else
              begin
                select af.acctno
                  into l_acctno
                  from afmast af, cfmast cf
                 where cf.custid = af.custid
                   and cf.custodycd = rec.fldval
                   and rownum=1;
                --04    S? ti?u kho?n ghi c?C
                l_txmsg.txfields('04').defname := 'AFACCT2';
                l_txmsg.txfields('04').type := 'C';
                l_txmsg.txfields('04').value := l_acctno;
                --05    Ti?u kho?n CK ghi c?C
                l_txmsg.txfields('05').defname := 'ACCT2';
                l_txmsg.txfields('05').type := 'C';
                l_txmsg.txfields('05').value := l_acctno || n_codeid;
                --25    TKCK update gi??n   C
                l_txmsg.txfields('25').defname := 'ACCTNO_UPDATECOST';
                l_txmsg.txfields('25').type := 'C';
                l_txmsg.txfields('25').value := l_acctno || n_codeid;
                select to_date(ci.depolastdt, 'DD/MM/RRRR')
                  into d_depolastdt
                  from cimast ci, allcode a0, allcode a1, cfmast cf,
                       sbcurrency sb, afmast af, aftype aft
                 where cf.custid = ci.custid
                   and ci.ccycd = sb.ccycd
                   and a0.cdtype = 'CI'
                   and a0.cdname = 'STATUS'
                   and a0.cdval = ci.status
                   and a1.cdtype = 'SY'
                   and a1.cdname = 'YESNO'
                   and a1.cdval = ci.iccftied
                   and ci.afacctno = af.acctno
                   and af.actype = aft.actype
                   and af.acctno = l_acctno;
                --32    Ng?chuy?n ph?K d?n h?n g?n nh?t   C
                l_txmsg.txfields('32').defname := 'DEPOLASTDT';
                l_txmsg.txfields('32').type := 'C';
                l_txmsg.txfields('32').value := d_depolastdt;
              end;
            end if;
          end;
        elsif rec.fldname = 'REFCUSTODYCD' then
          begin
            --03    Chuyen tu   C
            l_txmsg.txfields('03').defname := 'INWARD';
            l_txmsg.txfields('03').type := 'C';
            l_txmsg.txfields('03').value := substr(rec.fldval, 1, 3);
          end;
        end if;
      end loop;

      --31    Lo?i chuy?n kho?n   C
      l_txmsg.txfields('31').defname := 'TRTYPE';
      l_txmsg.txfields('31').type := 'C';
      l_txmsg.txfields('31').value := '002';
      --30    Di?n gi?i   C
      l_txmsg.txfields('30').defname := 'DESC';
      l_txmsg.txfields('30').type := 'C';
      l_txmsg.txfields('30').value := '';
      --14    Lo?i di?u ki?n   C
      l_txmsg.txfields('14').defname := 'QTTYTYPE';
      l_txmsg.txfields('14').type := 'C';
      l_txmsg.txfields('14').value := '002';
      --99    S? t? sinh   C
      l_txmsg.txfields('99').defname := 'AUTOID';
      l_txmsg.txfields('99').type := 'C';
      l_txmsg.txfields('99').value := '';
      --13    Ph?K chua d?n h?n   N
      l_txmsg.txfields('13').defname := 'DEPOFEEACR';
      l_txmsg.txfields('13').type := 'N';
      l_txmsg.txfields('13').value := 0;
      --15    Ph?K d?n h?n   N
      l_txmsg.txfields('15').defname := 'DEPOFEEAMT';
      l_txmsg.txfields('15').type := 'N';
      l_txmsg.txfields('15').value := 0;
      --00    Lo?i ph? C
      l_txmsg.txfields('00').defname := 'FEETYPE';
      l_txmsg.txfields('00').type := 'C';
      l_txmsg.txfields('00').value := 'VSDDEP';

      begin

        if txpks_#2245.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
           systemnums.c_success then
          rollback;
          --RETURN;
        end if;
      end;
      if nvl(p_err_code, 0) = 0 then
        update vsdtxreq
           set status = 'C', msgstatus = 'F' --boprocess = 'Y'
         where reqid = pv_reqid;

        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      else
        -- neu giao dich loi: danh danh trang thai loi de lam lai bang tay
        update vsdtxreq
           set status = 'E', msgstatus = 'E'
               --boprocess = 'E'
              , boprocess_err = p_err_code
         where reqid = pv_reqid;
        -- Tr?ng th?VSDTRFLOG
        update vsdtrflog
           set status = 'C', timeprocess = systimestamp
         where autoid = pv_vsdtrfid;
      end if;

    end loop;
plog.setendsection(pkgctx, 'auto_call_txpks_2245');
  exception
    when others then
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
         plog.setendsection(pkgctx, 'auto_call_txpks_2245');
  end auto_call_txpks_2245;*/
  procedure auto_create_camast(pv_autoid number) as
    v_codeid         varchar2(10);
    v_catype         varchar2(3);
    v_reportdate     date;
    v_duedate        date;
    v_actiondate     date;
    v_exprice        number default 0;
    v_price          number;
    v_exrate         varchar2(20);
    v_rightoffrate   varchar2(20);
    v_devidentrate   varchar2(20);
    v_devidentshares varchar2(20);
    v_splitrate      varchar2(20);
    v_interestrate   varchar2(20);
    v_interestperiod number default 0;
    v_status         varchar2(1);
    v_camastid       varchar2(20);
    v_description    varchar2(250);
    v_pstatus        varchar2(50);
    v_rate           number default 0;
    v_trflimit       char(1) default 'N';
    v_parvalue       number default 0;
    v_roundtype      varchar2(2) default '0';
    v_optsymbol      varchar2(50);
    v_optcodeid      varchar2(50);
    v_tradedate      date;
    v_lastdate       date;
    v_frtradeplace   varchar2(3);
    v_totradeplace   varchar2(3);
    v_transfertimes  varchar2(1) default '0';
    v_frdatetransfer date;
    v_todatetransfer date;
    v_tocodeid       varchar2(10);
    v_pitratemethod  varchar2(2);
    v_iswft          varchar2(1);
    v_begindate      date;
    v_purposedesc    varchar2(250);
    v_devidentvalue  number(20);
    v_advdesc        varchar2(250);
    v_typerate       char(1);
    v_ciroundtype    number;
    v_pitratese      number;
    v_inactiondate   date;
    v_refcorpid      varchar2(50);
    v_txdate         date;
    v_datetype       varchar2(10);
    v_symbol         varchar2(10);
    v_tosymbol       varchar2(10);
    v_catype_desc    varchar2(50);
    v_sectype        varchar2(10);
  begin
    select a1.cdval, a2.cdcontent
      into v_catype, v_catype_desc
      from vsdtrflogdtl dtl, allcode a1, allcode a2
     where dtl.refautoid = pv_autoid
       and dtl.fldname = 'CATYPE'
       and dtl.fldval = a1.cdcontent
       and a1.cdname = 'VSDCATYPE'
       and a1.cdtype = 'CA'
       and a2.cdtype = 'CA'
       and a2.cdname = 'CATYPE'
       and a2.cdval = a1.cdval;
    begin
      select dtl.fldval
        into v_datetype
        from vsdtrflogdtl dtl
       where dtl.refautoid = pv_autoid
         and dtl.fldname = 'DATETYPE';
    exception
      when others then
        v_datetype := 'a';
    end;
    -- default gia tri reportdate va actiondate
    v_reportdate := to_char(getcurrdate);
    v_actiondate := to_char(getcurrdate);
    -- lay ra cac gia tri trong message tra ve de sinh vao CAMAST
    for rec in (select * from vsdtrflogdtl where refautoid = pv_autoid) loop

      if rec.fldname = 'SYMBOL' then
        begin
          select codeid, sectype
            into v_codeid, v_sectype
            from sbsecurities
           where symbol = rec.fldval;
          v_symbol := rec.fldval;
        exception
          when others then
            v_codeid := '';
            v_symbol := '';
        end;
      elsif rec.fldname = 'TOSYMBOL' then
        begin
          select codeid
            into v_tocodeid
            from sbsecurities
           where symbol = rec.fldval;
          v_tosymbol := rec.fldval;
        exception
          when others then
            v_tocodeid := '';
            v_tosymbol := '';
        end;
      elsif rec.fldname = 'REFCORPID' then
        v_refcorpid := rec.fldval;
      elsif rec.fldname = 'RIGHTOFFRATE' then
        v_rightoffrate := replace(rec.fldval, ':', '/');
      elsif rec.fldname = 'RATE' then
        if v_catype = '010' then
          if rec.fldval < 1 then
            v_devidentrate  := rec.fldval * 100;
            v_typerate      := 'R';
            v_devidentvalue := 0;
          else
            v_devidentrate  := 0;
            v_devidentvalue := rec.fldval;
            v_typerate      := 'V';
          end if;
        end if;
      elsif rec.fldname = 'EXRATE' then
        if v_catype = '014' then
          v_exrate := replace(rec.fldval, ':', '/');
        elsif v_catype <> '010' then
          v_devidentshares := replace(rec.fldval, ':', '/');
        end if;
      elsif rec.fldname = 'EXPRICE' then
        v_exprice := rec.fldval;
      elsif rec.fldname = 'FRDATETRANSFER' then
        v_frdatetransfer := to_char(to_date(rec.fldval, 'RRRRMMDD'),
                                    'DD/MM/RRRR');
      elsif rec.fldname = 'TODATETRANSFER' then
        v_todatetransfer := to_char(to_date(rec.fldval, 'RRRRMMDD'),
                                    'DD/MM/RRRR');
      elsif rec.fldname = 'DATE' then
        if v_datetype = 'RDTE' then
          v_reportdate := to_char(to_date(rec.fldval, 'RRRRMMDD'),
                                  'DD/MM/RRRR');
        elsif v_datetype = 'EFFD' then
          v_actiondate := to_char(to_date(rec.fldval, 'RRRRMMDD'),
                                  'DD/MM/RRRR');
        end if;
      elsif rec.fldname = 'BEGINDATE' then
        v_begindate := to_char(to_date(rec.fldval, 'RRRRMMDD'),
                               'DD/MM/RRRR');
      elsif rec.fldname = 'DUEDATE' then
        v_duedate := to_char(to_date(rec.fldval, 'RRRRMMDD'), 'DD/MM/RRRR');
      elsif rec.fldname = 'TRFLIMIT' then
        if rec.fldval = 'NREN' then
          v_trflimit := 'N';
        else
          v_trflimit := 'Y';
        end if;
      elsif rec.fldname = 'NOTES' then
        v_purposedesc := rec.fldval;
      elsif rec.fldname = 'PITRATEMETHOD' then
        if rec.fldval = 'NETT' then
          v_pitratemethod := 'IS';
        else
          v_pitratemethod := 'SC';
        end if;
      end if;
    end loop;
    v_camastid := '0000' || v_codeid || lpad(seq_camastid.nextval, 6, 0);
    if nvl(v_tocodeid, 'a') = 'a' then
      v_tocodeid := v_codeid;
    end if;
    if v_catype = '014' then
      v_advdesc   := fn_gen_advdesc(v_exrate, v_catype, v_rightoffrate);
      v_optsymbol := fn_gen_optsymbol(v_codeid, v_reportdate, v_optsymbol);
      -- sinh ma CK quyen
      select lpad((max(to_number(invacct)) + 1), 6, 0)
        into v_optcodeid
        from (select rownum odr, invacct
                 from (select codeid invacct
                          from sbsecurities
                         where substr(codeid, 1, 1) <> 9
                         order by codeid) dat) invtab;
      -- end of sinh ma CK quyen
    elsif v_catype <> '010' then
      v_advdesc := fn_gen_advdesc(v_devidentshares, v_catype, '0');
    end if;
    -- sinh description
    if v_catype = '005' then
      v_description := v_catype_desc || ', ' || v_symbol || ', ng?ch?t: ' ||
                       v_reportdate || ',t? l?: ' || v_devidentshares;
    elsif v_catype = '010' then
      v_description := v_catype_desc || ', ' || v_symbol || ', ' ||
                       'ng?ch?t: ' || v_reportdate || ', t? l?: ' ||
                       v_devidentrate;
    elsif v_catype = '011' then
      v_description := v_catype_desc || ', ' || v_symbol || ', ' ||
                       'ng?ch?t: ' || v_reportdate || ', t? l?: ' ||
                       v_devidentshares;
    elsif v_catype = '014' then
      v_description := v_catype_desc || ', ' || v_tosymbol || ', ' ||
                       'ng?ch?t: ' || v_reportdate ||
                       ', T? l? s? h?u quy?n: ' || v_exrate ||
                       ' ,t? l? quy?n/c? phi?u:  ' || v_rightoffrate;
    elsif v_catype = '020' then
      if (v_sectype <> '001' and v_sectype <> '002') then
        v_catype         := '017';
        v_exrate         := v_devidentshares;
        v_devidentshares := '';
      end if;
      v_description := v_catype_desc || ',chuy?n d?i ' || v_symbol ||
                       ',th? ' || v_tosymbol || 'ng?ch?t: ' ||
                       v_reportdate || ', t? l? chuy?n ' ||
                       v_devidentshares;
    end if;
    -- end of sinh description
    -- mot so gia tri tam thoi default
    v_iswft       := 'Y';
    v_ciroundtype := 0;
    v_roundtype   := 0;

    -- sinh du lieu vao camast
    insert into camast
      (autoid, codeid, catype, reportdate, duedate, actiondate, exprice,
       exrate, rightoffrate, devidentrate, devidentshares, status, camastid,
       description, excodeid, deltd, trflimit, parvalue, roundtype,
       optsymbol, optcodeid, transfertimes, frdatetransfer, todatetransfer,
       tocodeid, iswft, begindate, purposedesc, devidentvalue, advdesc,
       typerate, ciroundtype, inactiondate, makerid/*, refcorpid*/,
       pitratemethod)
    -- gia tri
    values
      (seq_camast.nextval, v_codeid, v_catype, v_reportdate, v_duedate,
       v_actiondate, v_exprice, v_exrate, v_rightoffrate, v_devidentrate,
       v_devidentshares, 'P', v_camastid, v_description, v_codeid, 'N',
       v_trflimit, 10000, v_roundtype, v_optsymbol, v_optcodeid, '1',
       v_frdatetransfer, v_todatetransfer, v_tocodeid, v_iswft, v_begindate,
       v_purposedesc, v_devidentvalue, v_advdesc, v_typerate, v_ciroundtype,
       v_actiondate, '0000'/*, v_refcorpid*/, v_pitratemethod);
    -- sinh du lieu vao maintain_log
    v_txdate := getcurrdate;

    insert into maintain_log
      (table_name, record_key, maker_id, maker_dt, approve_rqd, approve_id,
       approve_dt, mod_num, column_name, from_value, to_value, action_flag,
       child_table_name, child_record_key, maker_time/*, maketime, apprtime*/)
    values
      ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
       'Y', '', null, 0, 'CODEID', '', v_codeid, 'ADD', '', '',
       to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);

    insert into maintain_log
      (table_name, record_key, maker_id, maker_dt, approve_rqd, approve_id,
       approve_dt, mod_num, column_name, from_value, to_value, action_flag,
       child_table_name, child_record_key, maker_time/*, maketime, apprtime*/)
    values
      ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
       'Y', '', null, 0, 'TOCODEID', '', v_tocodeid, 'ADD', '', '',
       to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);

    insert into maintain_log
      (table_name, record_key, maker_id, maker_dt, approve_rqd, approve_id,
       approve_dt, mod_num, column_name, from_value, to_value, action_flag,
       child_table_name, child_record_key, maker_time/*, maketime, apprtime*/)
    values
      ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
       'Y', '', null, 0, 'CATYPE', '', v_catype, 'ADD', '', '',
       to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);

    insert into maintain_log
      (table_name, record_key, maker_id, maker_dt, approve_rqd, approve_id,
       approve_dt, mod_num, column_name, from_value, to_value, action_flag,
       child_table_name, child_record_key, maker_time/*, maketime, apprtime*/)
    values
      ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
       'Y', '', null, 0, 'CAMASTID', '', v_camastid, 'ADD', '', '',
       to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);

    insert into maintain_log
      (table_name, record_key, maker_id, maker_dt, approve_rqd, approve_id,
       approve_dt, mod_num, column_name, from_value, to_value, action_flag,
       child_table_name, child_record_key, maker_time/*, maketime, apprtime*/)
    values
      ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
       'Y', '', null, 0, 'REPORTDATE', '', '20/06/2013', 'ADD', '', '',
       to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);

    insert into maintain_log
      (table_name, record_key, maker_id, maker_dt, approve_rqd, approve_id,
       approve_dt, mod_num, column_name, from_value, to_value, action_flag,
       child_table_name, child_record_key, maker_time/*, maketime, apprtime*/)
    values
      ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
       'Y', '', null, 0, 'ACTIONDATE', '', '06/05/2014', 'ADD', '', '',
       to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);

    insert into maintain_log
      (table_name, record_key, maker_id, maker_dt, approve_rqd, approve_id,
       approve_dt, mod_num, column_name, from_value, to_value, action_flag,
       child_table_name, child_record_key, maker_time/*, maketime, apprtime*/)
    values
      ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
       'Y', '', null, 0, 'STATUS', '', 'P', 'ADD', '', '',
       to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);

    insert into maintain_log
      (table_name, record_key, maker_id, maker_dt, approve_rqd, approve_id,
       approve_dt, mod_num, column_name, from_value, to_value, action_flag,
       child_table_name, child_record_key, maker_time/*, maketime, apprtime*/)
    values
      ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
       'Y', '', null, 0, 'REFCORPID', '', v_refcorpid, 'ADD', '', '',
       to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);

    insert into maintain_log
      (table_name, record_key, maker_id, maker_dt, approve_rqd, approve_id,
       approve_dt, mod_num, column_name, from_value, to_value, action_flag,
       child_table_name, child_record_key, maker_time/*, maketime, apprtime*/)
    values
      ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
       'Y', '', null, 0, 'DESCRIPTION', '', v_description, 'ADD', '', '',
       to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);

    insert into maintain_log
      (table_name, record_key, maker_id, maker_dt, approve_rqd, approve_id,
       approve_dt, mod_num, column_name, from_value, to_value, action_flag,
       child_table_name, child_record_key, maker_time/*, maketime, apprtime*/)
    values
      ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
       'Y', '', null, 0, 'ADVDESC', '', v_advdesc, 'ADD', '', '',
       to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);

    insert into maintain_log
      (table_name, record_key, maker_id, maker_dt, approve_rqd, approve_id,
       approve_dt, mod_num, column_name, from_value, to_value, action_flag,
       child_table_name, child_record_key, maker_time/*, maketime, apprtime*/)
    values
      ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
       'Y', '', null, 0, 'EXPRICE', '', v_exprice, 'ADD', '', '',
       to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);

    insert into maintain_log
      (table_name, record_key, maker_id, maker_dt, approve_rqd, approve_id,
       approve_dt, mod_num, column_name, from_value, to_value, action_flag,
       child_table_name, child_record_key, maker_time/*, maketime, apprtime*/)
    values
      ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
       'Y', '', null, 0, 'ISWFT', '', v_iswft, 'ADD', '', '',
       to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);

    insert into maintain_log
      (table_name, record_key, maker_id, maker_dt, approve_rqd, approve_id,
       approve_dt, mod_num, column_name, from_value, to_value, action_flag,
       child_table_name, child_record_key, maker_time/*, maketime, apprtime*/)
    values
      ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
       'Y', '', null, 0, 'PURPOSEDESC', '', v_purposedesc, 'ADD', '', '',
       to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);

    insert into maintain_log
      (table_name, record_key, maker_id, maker_dt, approve_rqd, approve_id,
       approve_dt, mod_num, column_name, from_value, to_value, action_flag,
       child_table_name, child_record_key, maker_time/*, maketime, apprtime*/)
    values
      ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
       'Y', '', null, 0, 'PITRATEMETHOD', '', v_pitratemethod, 'ADD', '', '',
       to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);

    if v_roundtype <> null then
      insert into maintain_log
        (table_name, record_key, maker_id, maker_dt, approve_rqd,
         approve_id, approve_dt, mod_num, column_name, from_value, to_value,
         action_flag, child_table_name, child_record_key, maker_time/*,
         maketime, apprtime*/)
      values
        ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
         'Y', '', null, 0, 'ROUNDTYPE', '', v_roundtype, 'ADD', '', '',
         to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);
    end if;
    if v_ciroundtype <> null then
      insert into maintain_log
        (table_name, record_key, maker_id, maker_dt, approve_rqd,
         approve_id, approve_dt, mod_num, column_name, from_value, to_value,
         action_flag, child_table_name, child_record_key, maker_time/*,
         maketime, apprtime*/)
      values
        ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
         'Y', '', null, 0, 'CIROUNDTYPE', '', v_ciroundtype, 'ADD', '', '',
         to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);
    end if;
    if v_devidentshares <> null then
      insert into maintain_log
        (table_name, record_key, maker_id, maker_dt, approve_rqd,
         approve_id, approve_dt, mod_num, column_name, from_value, to_value,
         action_flag, child_table_name, child_record_key, maker_time/*,
         maketime, apprtime*/)
      values
        ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
         'Y', '', null, 0, 'DEVIDENTSHARES', '', v_devidentshares, 'ADD', '',
         '', to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);
    end if;
    if v_advdesc <> null then
      insert into maintain_log
        (table_name, record_key, maker_id, maker_dt, approve_rqd,
         approve_id, approve_dt, mod_num, column_name, from_value, to_value,
         action_flag, child_table_name, child_record_key, maker_time/*,
         maketime, apprtime*/)
      values
        ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
         'Y', '', null, 0, 'ADVDESC', '', v_advdesc, 'ADD', '', '',
         to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);
    end if;
    if v_rightoffrate <> null then
      insert into maintain_log
        (table_name, record_key, maker_id, maker_dt, approve_rqd,
         approve_id, approve_dt, mod_num, column_name, from_value, to_value,
         action_flag, child_table_name, child_record_key, maker_time/*,
         maketime, apprtime*/)
      values
        ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
         'Y', '', null, 0, 'RIGHTOFFRATE', '', v_rightoffrate, 'ADD', '', '',
         to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);
    end if;
    if v_typerate <> null then
      insert into maintain_log
        (table_name, record_key, maker_id, maker_dt, approve_rqd,
         approve_id, approve_dt, mod_num, column_name, from_value, to_value,
         action_flag, child_table_name, child_record_key, maker_time/*,
         maketime, apprtime*/)
      values
        ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
         'Y', '', null, 0, 'TYPERATE', '', v_typerate, 'ADD', '', '',
         to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);
    end if;
    if v_devidentrate <> null then
      insert into maintain_log
        (table_name, record_key, maker_id, maker_dt, approve_rqd,
         approve_id, approve_dt, mod_num, column_name, from_value, to_value,
         action_flag, child_table_name, child_record_key, maker_time/*,
         maketime, apprtime*/)
      values
        ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
         'Y', '', null, 0, 'DEVIDENTRATE', '', v_devidentrate, 'ADD', '', '',
         to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);
    end if;
    if v_devidentvalue <> null then
      insert into maintain_log
        (table_name, record_key, maker_id, maker_dt, approve_rqd,
         approve_id, approve_dt, mod_num, column_name, from_value, to_value,
         action_flag, child_table_name, child_record_key, maker_time/*,
         maketime, apprtime*/)
      values
        ('CAMAST', 'CAMASTID = ''' || v_camastid || '''', '0000', v_txdate,
         'Y', '', null, 0, 'DEVIDENTVALUE', '', v_devidentvalue, 'ADD', '',
         '', to_char(systimestamp, 'HH24:MI:SS')/*, systimestamp, ''*/);
    end if;

  exception
    when others then
      insert into log_err
        (id, date_log, position, text)
      values
        (seq_log_err.nextval, sysdate,
         'AUTO_CREATE_CAMAST,AUTOID ' || pv_autoid,
         dbms_utility.format_error_backtrace);
  end auto_create_camast;

PROCEDURE pr_receive_csv_by_xml(pv_filename IN VARCHAR2, pv_filecontent IN CLOB)
IS
    v_contentlog_id NUMBER;
BEGIN
    plog.setbeginsection(pkgctx, 'pr_receive_csv_by_xml');
plog.info(pkgctx, pv_filename);
    plog.setendsection(pkgctx, 'pr_receive_csv_by_xml');
EXCEPTION WHEN OTHERS THEN
  plog.error(pkgctx, sqlerrm);
    plog.setendsection(pkgctx, 'pr_receive_csv_by_xml');
END;

begin
  -- Initialization
  for i in (select * from tlogdebug) loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('cspks_vsd',
                      plevel     => nvl(logrow.loglevel, 30),
                      plogtable  => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert     => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace     => (nvl(logrow.log4trace, 'N') = 'Y'));
end cspks_vsd;
/
