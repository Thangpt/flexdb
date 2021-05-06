create or replace package MSGPKS_PROCESSING as
  -- spec
  procedure SP_FSS_QO_GETCIFULL(qname    varchar2,
                                objqueue fss_objlog_queue_payload_type);
  procedure SP_FSS_QO_GETSEMAST(qname    varchar2,
                                objqueue fss_objlog_queue_payload_type);
  procedure SP_FSS_QO_ORDERBOOK(qname    varchar2,
                                objqueue fss_objlog_queue_payload_type);
  procedure SP_FSS_QO_SENDFO2OD(qname    varchar2,
                                objqueue fss_objlog_queue_payload_type);
  procedure SP_FSS_QO_PUSH2EXT(qname    varchar2,
                               objqueue fss_objlog_queue_payload_type);

  procedure SP_FSS_QO_MoneyTransfer(qname    varchar2,
                                    objqueue fss_objlog_queue_payload_type);
  procedure SP_FSS_QO_CRBTXREQ(qname    varchar2,
                                objqueue fss_objlog_queue_payload_type);
end MSGPKS_PROCESSING;
/

create or replace package body MSGPKS_PROCESSING as
  -- body
  pkgctx        plog.log_ctx;
  logrow        tlogdebug%rowtype;
  ownerschema   varchar2(50);
  databaseCache boolean;

  --Notify message cho h? th?ng ngoài
  procedure SP_FSS_QO_PUSH2EXT(qname    varchar2,
                               objqueue fss_objlog_queue_payload_type) is
    tmp_text_message SYS.AQ$_JMS_TEXT_MESSAGE;
    eopt             DBMS_AQ.enqueue_options_t;
    mprop            DBMS_AQ.message_properties_t;
    tmp_encode_text  varchar2(32767);
    l_record_key     varchar2(20);
    l_refobject      varchar2(50);
    l_afacctno       varchar2(50);
    enq_msgid        raw(16);
    v_notify         boolean;
    l_refcursor      pkg_report.ref_cursor;
  begin
    plog.setbeginsection(pkgctx, 'SP_FSS_QO_PUSH2EXT');
    plog.debug(pkgctx, 'BEGIN OF SP_FSS_QO_PUSH2EXT:' || qname);
  
    --Xác d?nh thông tin c?n d?y: AF, CI, SE, OD
    l_refobject  := objqueue.objname;
    l_record_key := objqueue.rcdkey;
    l_afacctno   := objqueue.oldval;
    v_notify     := true;
    plog.debug(pkgctx,
               'The content: ' || l_refobject || ' objqueue.rcdkey:' ||
               l_record_key);
    if instr(l_refobject, 'GET_CIFULL') > 0 then
      --Notify suc mua và tien
      open l_refcursor for
        select OL_ACCOUNT_CI.*, 'CSI' MSGTYPE
          from OL_ACCOUNT_CI
         where AFACCTNO = l_afacctno;
    elsif instr(l_refobject, 'GET_SEMAST') > 0 then
      --Notify so du chung khoan
      open l_refcursor for
        select OL_ACCOUNT_SE.*, 'SEL' MSGTYPE
          from OL_ACCOUNT_SE
         where ACCTNO = l_record_key;
    elsif instr(l_refobject, 'GET_ALL_SEMAST') > 0 then
      --Notify chung khoan theo tieu khoan
      open l_refcursor for
        select OL_ACCOUNT_SE.*, 'SEL' MSGTYPE
          from OL_ACCOUNT_SE
         where AFACCTNO = l_afacctno;
    elsif instr(l_refobject, 'GET_ORDERBOOK') > 0 then
      --Notify thong tin lenh
      open l_refcursor for
        select OL_ACCOUNT_OD.*, 'OBL' MSGTYPE
          from OL_ACCOUNT_OD
         where ORDERID = l_record_key;
    elsif instr(l_refobject, 'GET_ALL_ORDERBOOK') > 0 then
      --Notify so lenh theo tieu khoan
      open l_refcursor for
        select OL_ACCOUNT_OD.*, 'OBL' MSGTYPE
          from OL_ACCOUNT_OD
         where AFACCTNO = l_afacctno;
    elsif instr(l_refobject, 'LOGON') > 0 then
      -- AF account list
      open l_refcursor for
        select a.username, b.acctno afacctno, objqueue.oldval channel,
               a.fullname, 'AFL' MSGTYPE
          from cfmast a, afmast b
         where a.custid = b.custid
           and a.username = l_record_key;
    elsif instr(l_refobject, 'GET_IOD') > 0 then
      open l_refcursor for
        select ol_account_iod.*, 'IOD' msgtype
          from ol_account_iod
         where orderid = l_record_key;
    elsif instr(l_refobject, 'GET_ALL_IOD') > 0 then
      -- Danh sach khop lenh chi tiet
      open l_refcursor for
        select ol_account_iod.*, 'IOD' msgtype
          from ol_account_iod
         where afacctno = l_afacctno;
    else
      v_notify := false;
    end if;
  
    --G?i hàm d?y thông tin
    if v_notify = true then
      begin
        tmp_encode_text := fo_fn_encodeRefToString(l_refcursor);
        if LENGTH(tmp_encode_text) > 1 then
          tmp_text_message := SYS.AQ$_JMS_TEXT_MESSAGE.construct;
          tmp_text_message.set_text(tmp_encode_text);
          plog.debug(pkgctx, 'Message content: ' || tmp_encode_text);
        
          DBMS_AQ.ENQUEUE(queue_name         => ownerschema ||
                                                '.TXAQS_BO2FO',
                          enqueue_options    => eopt,
                          message_properties => mprop,
                          payload            => tmp_text_message,
                          msgid              => enq_msgid);
        
          if plog.isDebugEnabled(pkgctx) then
          
            DBMS_AQ.ENQUEUE(queue_name         => ownerschema ||
                                                  '.TXAQS_BO2FO_LOG',
                            enqueue_options    => eopt,
                            message_properties => mprop,
                            payload            => tmp_text_message,
                            msgid              => enq_msgid);
          
          end if;
        
          --SP_FSS_QO_OUT2EXT(v_refcursor, enq_msgid);
          close l_refcursor;
          plog.debug(pkgctx, 'Already sent!');
        end if;
      end;
    end if;
  
    plog.debug(pkgctx, '<<END OF SP_FSS_QO_PUSH2EXT');
    plog.setendsection(pkgctx, 'SP_FSS_QO_PUSH2EXT');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_FSS_QO_PUSH2EXT');
  end;

  --Chuyen tien
  procedure SP_FSS_QO_MoneyTransfer(qname    varchar2,
                                    objqueue fss_objlog_queue_payload_type) is
    v_afacctno    varchar2(20);
    v_groupleader varchar2(20);
  begin
    plog.setbeginsection(pkgctx, 'SP_FSS_QO_MoneyTransfer');
    plog.debug(pkgctx, 'BEGIN OF SP_FSS_QO_MoneyTransfer:' || qname);
  
    --Chuyen tien online
    plog.debug(pkgctx, 'rcdkey: ' || objqueue.rcdkey);
    if objqueue.rcdkey = 'TRF' then
      gwpks_auto.prMoneyTransfer;
    elsif objqueue.rcdkey = 'CAR' then
      gwpks_auto.prCARightOffRegister;
    end if;
  
    plog.debug(pkgctx, '<<END OF SP_FSS_QO_MoneyTransfer');
    plog.setendsection(pkgctx, 'SP_FSS_QO_MoneyTransfer');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_FSS_QO_MoneyTransfer');
  end;

  --Tính l?i s?c mua
  procedure SP_FSS_QO_GETCIFULL(qname    varchar2,
                                objqueue fss_objlog_queue_payload_type) is
    v_afacctno    varchar2(20);
    v_groupleader varchar2(20);
  begin
    plog.setbeginsection(pkgctx, 'SP_FSS_QO_GETCIFULL');
    plog.debug(pkgctx, 'BEGIN OF SP_FSS_QO_GETCIFULL:' || qname);
  
    --Tính toán l?i s?c mua (n?u là group liên thông thì ph?i tính l?i cho c? group)
    v_afacctno := objqueue.oldval;
    select NVL(A.groupleader, '1')
      into v_groupleader
      from afmast A
     where A.ACCTNO = v_afacctno;
    if LENGTH(v_groupleader) <> 10 then
      --Tính cho m?t ti?u kho?n
      SP_BD_GETACCOUNTPOSITION_OL(v_afacctno);
    else
      --Tính cho nhóm liên thông
      for V_ACC in (select ACCTNO
                      from AFMAST
                     where NVL(GROUPLEADER, '1') = v_groupleader)
      loop
        SP_BD_GETACCOUNTPOSITION_OL(V_ACC.ACCTNO);
      end loop;
    end if;
  
    plog.debug(pkgctx, '<<END OF SP_FSS_QO_GETCIFULL');
    plog.setendsection(pkgctx, 'SP_FSS_QO_GETCIFULL');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_FSS_QO_GETCIFULL');
  end;

  --Lay thong tin lenh chi tiet
  procedure SP_FSS_QO_GET_IOD(qname    varchar2,
                              objqueue fss_objlog_queue_payload_type) is
    v_afacctno    varchar2(20);
    v_groupleader varchar2(20);
  begin
    plog.setbeginsection(pkgctx, 'SP_FSS_QO_GET_IOD');
    plog.debug(pkgctx, 'BEGIN OF SP_FSS_QO_GET_IOD:' || qname);
  
    -- 1. Lay theo so tieu khoan
  
    -- 2. Lay theo so hieu lenh goc
  
    -- 3. Lay theo id cua tung lan khop
  
    plog.debug(pkgctx, '<<END OF SP_FSS_QO_GET_IOD');
    plog.setendsection(pkgctx, 'SP_FSS_QO_GET_IOD');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_FSS_QO_GET_IOD');
  end;

  --Tính l?i s? du ch?ng khoán
  procedure SP_FSS_QO_GETSEMAST(qname    varchar2,
                                objqueue fss_objlog_queue_payload_type) is
    l_afacctno varchar2(20);
    l_acctno   varchar2(20);
    l_cnt      pls_integer;
  begin
    plog.setbeginsection(pkgctx, 'SP_FSS_QO_GETSEMAST');
    plog.debug(pkgctx, 'BEGIN OF SP_FSS_QO_GETSEMAST:' || qname);
  
    plog.debug(pkgctx,
               'queue name: ' || qname || '-rcdkey:' || objqueue.rcdkey ||
               '-oldval:' || objqueue.oldval || '-newval:' ||
               objqueue.newval || 'objqueue.objname: ' || objqueue.objname);
  
    --Refresh l?i thông tin SE cho m?t sub-account
    l_acctno   := objqueue.rcdkey;
    l_afacctno := objqueue.oldval;
  
    select count(acctno)
      into l_cnt
      from ol_account_se
     where afacctno = l_afacctno;
  
    if l_cnt > 0 and objqueue.objname = 'SEMAST' then
      begin
        plog.debug(pkgctx, 'l_acctno: ' || l_acctno);
        delete from ol_account_se where acctno = l_acctno;
        insert into ol_account_se
          select * from VW_OL_ACCOUNT_SE where acctno = l_acctno;
      end;
    else
      begin
        plog.debug(pkgctx, 'l_afacctno: ' || l_afacctno);
        delete OL_ACCOUNT_SE where afacctno = l_afacctno;
        insert into ol_account_se
          select * from VW_OL_ACCOUNT_SE where afacctno = l_afacctno;
      end;
    end if;
  
    plog.debug(pkgctx, '<<END OF SP_FSS_QO_GETSEMAST');
    plog.setendsection(pkgctx, 'SP_FSS_QO_GETSEMAST');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_FSS_QO_GETSEMAST');
  end;

  --Tính l?i s? l?nh giao d?ch (dã dua ra gateway)
  procedure SP_FSS_QO_ORDERBOOK(qname    varchar2,
                                objqueue fss_objlog_queue_payload_type) is
    l_afacctno varchar2(20);
    l_orderid  varchar2(50);
    l_cnt      pls_integer;
  begin
    plog.setbeginsection(pkgctx, 'SP_FSS_QO_ORDERBOOK');
    plog.debug(pkgctx, 'BEGIN OF SP_FSS_QO_ORDERBOOK:' || qname);
  
    plog.debug(pkgctx,
               'RCDKEY:' || objqueue.rcdkey || ' OLDVAL:' ||
               objqueue.oldval || ' NEWVAL:' || objqueue.newval ||
               ' OBJNAME:' || objqueue.objname);
  
    l_afacctno := objqueue.oldval;
    l_orderid  := objqueue.rcdkey;
  
    select count(ol_account_od.orderid)
      into l_cnt
      from ol_account_od
     where ol_account_od.afacctno = l_afacctno;
  
    if l_cnt = 0 then
      begin
        insert into ol_account_od
          select *
            from VW_STRADE_SUBACCOUNT_OD
           where afacctno = l_afacctno
             and DELTD <> 'Y';
      end;
    else
      begin
        delete from ol_account_od where orderid = l_orderid;
      
        insert into ol_account_od
          select *
            from VW_STRADE_SUBACCOUNT_OD
           where orderid = l_orderid
             and DELTD <> 'Y';
      end;
    end if;
  
    plog.debug(pkgctx, '<<END OF SP_FSS_QO_ORDERBOOK');
    plog.setendsection(pkgctx, 'SP_FSS_QO_ORDERBOOK');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_FSS_QO_ORDERBOOK');
  end;

  --Ðua l?nh t? FO và OD (ALL)
  procedure SP_FSS_QO_SENDFO2OD(qname    varchar2,
                                objqueue fss_objlog_queue_payload_type) is
    v_afacctno varchar2(20);
    v_orderid  varchar2(50);
  begin
    plog.setbeginsection(pkgctx, 'SP_FSS_QO_SENDFO2OD');
    plog.debug(pkgctx,
               'BEGIN OF SP_FSS_QO_SENDFO2OD:' || objqueue.objname || '.' ||
               objqueue.rcdkey);
    v_afacctno := objqueue.oldval;
    v_orderid  := objqueue.rcdkey;
  
    --Ð?y l?nh t? FOMAST sang ODMAST
    txpks_auto.pr_fo2od;
  
    plog.debug(pkgctx, '<<END OF SP_FSS_QO_SENDFO2OD');
    plog.setendsection(pkgctx, 'SP_FSS_QO_SENDFO2OD');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_FSS_QO_SENDFO2OD');
  end;

  procedure SP_FSS_QO_CRBTXREQ(qname    varchar2,
                                objqueue fss_objlog_queue_payload_type) is
    v_afacctno varchar2(20);
    v_reqid  	number(20);
  begin
    plog.setbeginsection(pkgctx, 'SP_FSS_QO_CRBTXREQ');
    plog.debug(pkgctx,
               'BEGIN OF SP_FSS_QO_CRBTXREQ:' || objqueue.objname || '.' ||
               objqueue.rcdkey);
    v_afacctno := objqueue.oldval;
    v_reqid  := objqueue.rcdkey;
  
    --L?y thông tin trong CRBTXREQID
	  
    --X? lý xác nh?n HOLD n?u TRFCODE=HOLD, STATUS=C or R
  
    plog.debug(pkgctx, '<<END OF SP_FSS_QO_CRBTXREQ');
    plog.setendsection(pkgctx, 'SP_FSS_QO_CRBTXREQ');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_FSS_QO_CRBTXREQ');
  end;
begin
  --get current schema
  select sys_context('userenv', 'current_schema')
    into ownerschema
    from dual;

  databaseCache := false;

  for i in (select * from tlogdebug)
  loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;
  pkgctx := plog.init('MSGPKS_SYSTEM',
                      plevel         => NVL(logrow.loglevel, 30),
                      plogtable      => (NVL(logrow.log4table, 'N') = 'Y'),
                      palert         => (NVL(logrow.log4alert, 'N') = 'Y'),
                      ptrace         => (NVL(logrow.log4trace, 'N') = 'Y'));
end MSGPKS_PROCESSING;
/

