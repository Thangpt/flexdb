-- Start of DDL Script for Package Body HOSTMSTRADE.MSGPKS_SYSTEM
-- Generated 11/04/2017 11:13:54 AM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE 
package msgpks_system as
  -- spec
  procedure SP_NOTIFICATION_TX(txdate varchar2,
                               txnum  varchar2,
                               tltxcd varchar2); --notify transaction change
  procedure SP_NOTIFICATION_OBJ(objname   varchar2,
                                recordkey varchar2,
                                afacctno  varchar2); --notify object change
  procedure SP_NOTIFICATION_FO(objname   varchar2,
                                recordkey varchar2,
                                afacctno  varchar2); -- xu ly queue fo
  procedure SP_MSG_QUEUE_SETUP; --t?o queue x? lý thông tin (nên h?n ch? s? d?ng)
  procedure SP_MSG_QUEUE_UNINSTALL; --h?y queue x? lý thông tin
  procedure SP_MSG_QUEUE_START; --start các queue c?a h? th?ng
  procedure SP_MSG_QUEUE_SHUTDOWN; --stop các queue c?a h? th?ng
  procedure SP_FSS_MSQ_ROUTING(context  raw,
                               reginfo  SYS.AQ$_REG_INFO,
                               descr    SYS.AQ$_DESCRIPTOR,
                               payload  raw,
                               payloadl number); --X? lý phân ph?i message t? QUEUE IN d?n các Queue x? lý
  procedure SP_FSS_MSQ_OBJ_ROUTING;
  procedure SP_FSS_QO_BASED(context  raw,
                            reginfo  SYS.AQ$_REG_INFO,
                            descr    SYS.AQ$_DESCRIPTOR,
                            payload  raw,
                            payloadl number); --x? lý queue object co b?n
  procedure SP_FSS_QT_BASED(context  raw,
                            reginfo  SYS.AQ$_REG_INFO,
                            descr    SYS.AQ$_DESCRIPTOR,
                            payload  raw,
                            payloadl number); --x? lý queue transaction co b?n
  procedure SP_FSS_FO_BASED(context  raw,
                            reginfo  SYS.AQ$_REG_INFO,
                            descr    SYS.AQ$_DESCRIPTOR,
                            payload  raw,
                            payloadl number);-- xu ly queue fo
  procedure SP_FSS_FOW_BASED(context  raw,
                            reginfo  SYS.AQ$_REG_INFO,
                            descr    SYS.AQ$_DESCRIPTOR,
                            payload  raw,
                            payloadl number);-- xu ly queue fo
end MSGPKS_SYSTEM;
/


CREATE OR REPLACE 
PACKAGE BODY msgpks_system as
  -- body
  pkgctx        plog.log_ctx;
  logrow        tlogdebug%rowtype;
  v_ownerschema varchar2(50);

  --*******************************************************************************************
  --BEGIN: TH? T?C GHI NH?N THAY ?I (NOTIFICATION)
  --*******************************************************************************************
  --GHI NH?N TH?G TIN THAY ?I C?A GIAO D?CH
  procedure SP_NOTIFICATION_TX(txdate varchar2,
                               txnum  varchar2,
                               tltxcd varchar2) is
    r_enqueue_options    DBMS_AQ.ENQUEUE_OPTIONS_T;
    r_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
    v_message_handle     raw(16);
    o_payload            fss_txlog_queue_payload_type;
    v_logmsg_id          number(20, 0);
    v_logmsg_date        date;
    v_refqueuename       varchar2(100);
  begin
    plog.setbeginsection(pkgctx, 'SP_NOTIFICATION_TX');
    plog.debug(pkgctx, 'BEGIN OF SP_NOTIFICATION_TX:' || txdate || txnum);

    begin
      select RF.QUEUENAME
        into v_refqueuename
        from APPMSGMAP RF
       where RF.OBJNAME = tltxcd;
      --T?o message
      select SEQ_APPMSG.NEXTVAL, sysdate
        into v_logmsg_id, v_logmsg_date
        from DUAL;
      o_payload := fss_txlog_queue_payload_type(v_logmsg_id,
                                                v_logmsg_date,
                                                tltxcd,
                                                to_date(txdate, 'DD/MM/YYYY'),
                                                txnum);
      --?a th?tin v? fss_qt_based_queue
      v_refqueuename := v_ownerschema || '.FSS_QT_BASED_QUEUE';
      plog.debug(pkgctx, 'Enqueue to: ' || v_refqueuename);
      DBMS_AQ.ENQUEUE(queue_name         => v_refqueuename,
                      enqueue_options    => r_enqueue_options,
                      message_properties => r_message_properties,
                      payload            => o_payload,
                      msgid              => v_message_handle);
    exception
      when NO_DATA_FOUND then
        --G?queue x? l? m?c d?nh
        v_refqueuename := '';
    end;

    plog.debug(pkgctx, '<<END OF SP_NOTIFICATION_TX');
    plog.setendsection(pkgctx, 'SP_NOTIFICATION_TX');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_NOTIFICATION_TX');
  end;

  --GHI NH?N TH?G TIN THAY ?I C?A OBJECT
  procedure SP_NOTIFICATION_OBJ(objname   varchar2,
                                recordkey varchar2,
                                afacctno  varchar2) is
    r_enqueue_options    DBMS_AQ.ENQUEUE_OPTIONS_T;
    r_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
    v_message_handle     raw(16);
    o_payload            fss_objlog_queue_payload_type;
    v_logmsg_id          number(20, 0);
    v_logmsg_date        date;
    v_refqueuename       varchar2(100);
  begin
    plog.setbeginsection(pkgctx, 'SP_NOTIFICATION_OBJ');
    plog.debug(pkgctx,
               'BEGIN OF SP_NOTIFICATION_OBJ:' || objname || recordkey);
    --T?o message
    select SEQ_APPMSG.NEXTVAL, sysdate
      into v_logmsg_id, v_logmsg_date
      from DUAL;
    o_payload := fss_objlog_queue_payload_type(v_logmsg_id,
                                               v_logmsg_date,
                                               objname,
                                               recordkey,
                                               'R',
                                               'AFACCTNO',
                                               afacctno,
                                               afacctno);
    --?a th?tin v? fss_qo_based_queue
    v_refqueuename := v_ownerschema || '.FSS_QO_BASED_QUEUE';
    plog.debug(pkgctx, 'Enqueue to: ' || v_refqueuename);
    DBMS_AQ.ENQUEUE(queue_name         => v_refqueuename,
                    enqueue_options    => r_enqueue_options,
                    message_properties => r_message_properties,
                    payload            => o_payload,
                    msgid              => v_message_handle);
    plog.debug(pkgctx, '<<END OF SP_NOTIFICATION_OBJ');
    plog.setendsection(pkgctx, 'SP_NOTIFICATION_OBJ');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_NOTIFICATION_OBJ');
  end;

  --LENH FO
  procedure SP_NOTIFICATION_FO(objname   varchar2,
                                recordkey varchar2,
                                afacctno  varchar2) is
    r_enqueue_options    DBMS_AQ.ENQUEUE_OPTIONS_T;
    r_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
    v_message_handle     raw(16);
    o_payload            fss_objlog_queue_payload_type;
    v_logmsg_id          number(20, 0);
    v_logmsg_date        date;
    v_refqueuename       varchar2(100);
  begin
    plog.setbeginsection(pkgctx, 'SP_NOTIFICATION_FO');
    plog.debug(pkgctx,
               'BEGIN OF SP_NOTIFICATION_FO:' || objname || recordkey);
    --T?o message
    select SEQ_APPMSG.NEXTVAL, sysdate
      into v_logmsg_id, v_logmsg_date
      from DUAL;
    o_payload := fss_objlog_queue_payload_type(v_logmsg_id,
                                               v_logmsg_date,
                                               objname,
                                               recordkey,
                                               'R',
                                               'AFACCTNO',
                                               afacctno,
                                               afacctno);
    --?a th?tin v? fss_qo_based_queue
    if objname='FOW' then
       v_refqueuename := v_ownerschema || '.FSS_FOW_QUEUE';
    else
       v_refqueuename := v_ownerschema || '.FSS_FO_QUEUE';
    end if;
    plog.debug(pkgctx, 'Enqueue to: ' || v_refqueuename);
    DBMS_AQ.ENQUEUE(queue_name         => v_refqueuename,
                    enqueue_options    => r_enqueue_options,
                    message_properties => r_message_properties,
                    payload            => o_payload,
                    msgid              => v_message_handle);
    plog.debug(pkgctx, '<<END OF SP_NOTIFICATION_FO');
    plog.setendsection(pkgctx, 'SP_NOTIFICATION_FO');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_NOTIFICATION_FO');
  end;
  --*******************************************************************************************
  --END: TH? T?C GHI NH?N THAY ?I (NOTIFICATION)
  --*******************************************************************************************

  --*******************************************************************************************
  --BEGIN: TH? T?C QU?N TR? H? TH?NG MESSAGE BUS CHUNG
  --*******************************************************************************************
  --Drop c?queue x? l? th?tin theo b?ng tham s?
  procedure SP_MSG_QUEUE_UNINSTALL as
    v_exectyp   varchar2(2);
    v_objtype   varchar2(2);
    v_queuename varchar2(50);
    v_spname    varchar2(50);

    queue_does_not_exist exception;
    pragma exception_init(queue_does_not_exist, -24010);

    aq_agent_is_not_a_subscriber exception;
    pragma exception_init(aq_agent_is_not_a_subscriber, -24035);

    cursor c_queue_def is
      select EXECTYP, OBJTYPE, QUEUENAME, STOREDNAME
        from APPMSGTX
       where STATUS = 'Y';
  begin
    plog.setbeginsection(pkgctx, 'SP_MSG_QUEUE_UNINSTALL');
    --Stop and drop queue
    open c_queue_def;
    loop
      --fetch queue
      fetch c_queue_def
        into v_exectyp, v_objtype, v_queuename, v_spname;
      exit when c_queue_def%notfound;

      begin
        --drop
        plog.debug(pkgctx, 'Drop queue: ' || v_queuename);
        --Remove subcriber
        if v_exectyp = 'S' then
          plog.debug(pkgctx,
                     'Subcriber queue: ' || v_queuename || '_subscriber');
          DBMS_AQADM.REMOVE_SUBSCRIBER(QUEUE_NAME => v_queuename,
                                       SUBSCRIBER => SYS.AQ$_AGENT(v_queuename ||
                                                                   '_subscriber',
                                                                   null,
                                                                   null));
        end if;
        --Drop queue
        DBMS_AQADM.DROP_QUEUE(queue_name => v_ownerschema || '.' ||
                                            v_queuename);

      exception
        when queue_does_not_exist then
          plog.error(pkgctx, 'Queue ' || v_queuename || ' does not exists');
        when aq_agent_is_not_a_subscriber then
          plog.error(pkgctx, 'AQ agent ' || v_queuename || '_subscriber is not a subscriber');
      end;
    end loop;
    close c_queue_def;

    --remove default subcriber
    DBMS_AQADM.REMOVE_SUBSCRIBER(QUEUE_NAME => v_ownerschema || '.' ||
                                               'FSS_QT_BASED_QUEUE',
                                 SUBSCRIBER => SYS.AQ$_AGENT('FSS_QT_BASED_QUEUE_SUBSCRIBER',
                                                             null,
                                                             null));

    DBMS_AQADM.REMOVE_SUBSCRIBER(QUEUE_NAME => v_ownerschema || '.' ||
                                               'FSS_QO_BASED_QUEUE',
                                 SUBSCRIBER => SYS.AQ$_AGENT('FSS_QO_BASED_QUEUE_SUBSCRIBER',
                                                             null,
                                                             null));

    DBMS_AQADM.REMOVE_SUBSCRIBER(QUEUE_NAME => v_ownerschema || '.' ||
                                               'FSS_FO_QUEUE',
                                 SUBSCRIBER => SYS.AQ$_AGENT('FSS_FO_QUEUE_SUBSCRIBER',
                                                             null,
                                                             null));
    plog.setendsection(pkgctx, 'SP_MSG_QUEUE_UNINSTALL');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_MSG_QUEUE_UNINSTALL');
  end;

  --Create c?queue x? l? th?tin theo b?ng tham s?
  procedure SP_MSG_QUEUE_SETUP as
    v_exectyp   varchar2(2);
    v_objtype   varchar2(2);
    v_queuetbl  varchar2(50);
    v_queuename varchar2(50);
    v_spname    varchar2(50);
    v_count     number(10, 0); --S? lu?ng Subcriber
    v_idx       number(10, 0); --Th? t?
    reginfolist sys.aq$_reg_info_list := sys.aq$_reg_info_list();
    cursor c_queue_def is
      select EXECTYP, OBJTYPE, QUEUENAME, STOREDNAME
        from APPMSGTX
       where STATUS = 'Y';
  begin
    plog.setbeginsection(pkgctx, 'SP_MSG_QUEUE_SETUP');
    select count(*) + 3 into v_count from APPMSGTX where STATUS = 'Y';
    --?ng k? x? l? subcribe cho queue m?c d?nh
    DBMS_AQADM.ADD_SUBSCRIBER(QUEUE_NAME => 'FSS_QT_BASED_QUEUE',
                              SUBSCRIBER => SYS.AQ$_AGENT('FSS_QT_BASED_QUEUE_SUBSCRIBER',
                                                          null,
                                                          null));
    DBMS_AQADM.ADD_SUBSCRIBER(QUEUE_NAME => 'FSS_QO_BASED_QUEUE',
                              SUBSCRIBER => SYS.AQ$_AGENT('FSS_QO_BASED_QUEUE_SUBSCRIBER',
                                                          null,
                                                          null));
    DBMS_AQADM.ADD_SUBSCRIBER(QUEUE_NAME => 'FSS_FO_QUEUE',
                              SUBSCRIBER => SYS.AQ$_AGENT('FSS_FO_QUEUE_SUBSCRIBER',
                                                          null,
                                                          null));

    --?ng k? c? x? l? s? ki?n
    DBMS_AQ.REGISTER(SYS.AQ$_REG_INFO_LIST(SYS.AQ$_REG_INFO('FSS_QT_BASED_QUEUE:FSS_QT_BASED_QUEUE_SUBSCRIBER',
                                                            DBMS_AQ.NAMESPACE_AQ,
                                                            'PLSQL://MSGPKS_SYSTEM.SP_FSS_MSQ_ROUTING',
                                                            HEXTORAW('FF'))),
                     1);
    DBMS_AQ.REGISTER(SYS.AQ$_REG_INFO_LIST(SYS.AQ$_REG_INFO('FSS_QO_BASED_QUEUE:FSS_QO_BASED_QUEUE_SUBSCRIBER',
                                                            DBMS_AQ.NAMESPACE_AQ,
                                                            'PLSQL://MSGPKS_SYSTEM.SP_FSS_MSQ_ROUTING',
                                                            HEXTORAW('FF'))),
                     1);
    DBMS_AQ.REGISTER(SYS.AQ$_REG_INFO_LIST(SYS.AQ$_REG_INFO('FSS_FO_QUEUE:FSS_FO_QUEUE_SUBSCRIBER',
                                                            DBMS_AQ.NAMESPACE_AQ,
                                                            'PLSQL://MSGPKS_SYSTEM.SP_FSS_FO_BASED',
                                                            HEXTORAW('FF'))),
                     1);

    v_idx := 4;
    --Create and start queue
    open c_queue_def;
    loop
      --fetch queue
      fetch c_queue_def
        into v_exectyp, v_objtype, v_queuename, v_spname;
      exit when c_queue_def%notfound;
      if v_objtype = 'O' then
        v_queuetbl := 'FSS_QO_PROCESS_TABLE';
      elsif v_objtype = 'T' then
        v_queuetbl := 'FSS_QT_PROCESS_TABLE';
      else
        --m?c d?nh
        v_queuetbl := 'FSS_QO_PROCESS_TABLE';
      end if;
      --create
      plog.debug(pkgctx, 'Create queue: ' || v_queuename);
      DBMS_AQADM.CREATE_QUEUE(queue_name  => v_queuename,
                              queue_table => v_queuetbl);
      --X? l? n?u l?ubcribed queue
      if v_exectyp = 'S' then
        plog.debug(pkgctx,
                   'Subcriber queue: ' || v_queuename || '_SUBSCRIBER');
        DBMS_AQADM.ADD_SUBSCRIBER(queue_name => v_queuename,
                                  subscriber => SYS.AQ$_AGENT(v_queuename ||
                                                              '_SUBSCRIBER',
                                                              null,
                                                              null));
        plog.debug(pkgctx,
                   'Register queue: ' || v_queuename || '_SUBSCRIBER');

        DBMS_AQ.REGISTER(SYS.AQ$_REG_INFO_LIST(SYS.AQ$_REG_INFO(v_queuename || ':' ||
                                                                v_queuename ||
                                                                '_subscriber',
                                                                DBMS_AQ.NAMESPACE_AQ,
                                                                'plsql://' ||
                                                                v_spname,
                                                                HEXTORAW('FF'))),
                         1);

        v_idx := v_idx + 1;
      end if;
    end loop;
    close c_queue_def;

    -- do the registration
    plog.debug(pkgctx, 'Number of subcribed queue: ' || v_count);
    plog.setendsection(pkgctx, 'SP_MSG_QUEUE_SETUP');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_MSG_QUEUE_SETUP');
  end;

  --CREATE V? START QUEUE THEO B?NG THAM S? APPMSGTX
  procedure SP_MSG_QUEUE_START as
    v_exectyp   varchar2(2);
    v_objtype   varchar2(2);
    v_queuetbl  varchar2(50);
    v_queuename varchar2(50);
    v_spname    varchar2(50);
    cursor c_queue_def is
      select EXECTYP, OBJTYPE, QUEUENAME, STOREDNAME
        from APPMSGTX
       where STATUS = 'Y';
  begin
    plog.setbeginsection(pkgctx, 'SP_MSG_QUEUE_START');
    plog.debug(pkgctx, 'BEGIN OF SP_MSG_QUEUE_START');
    --Create and start queue
    open c_queue_def;
    loop
      --fetch queue
      fetch c_queue_def
        into v_exectyp, v_objtype, v_queuename, v_spname;
      exit when c_queue_def%notfound;
      --start
      plog.debug(pkgctx, 'Start queue: ' || v_queuename);
      DBMS_AQADM.START_QUEUE(queue_name => v_queuename);
    end loop;
    close c_queue_def;

    --Start queue h? th?ng
    DBMS_AQADM.START_QUEUE(queue_name => 'FSS_QT_BASED_QUEUE');
    DBMS_AQADM.START_QUEUE(queue_name => 'FSS_QO_BASED_QUEUE');
    DBMS_AQADM.START_QUEUE(queue_name => 'FSS_FO_QUEUE');
    DBMS_AQADM.START_QUEUE(queue_name => 'TXAQS_BO2FO');
    DBMS_AQADM.START_QUEUE(queue_name => 'TXAQS_FO2BO');

    plog.debug(pkgctx, '<<END OF SP_MSG_QUEUE_START');
    plog.setendsection(pkgctx, 'SP_MSG_QUEUE_START');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_MSG_QUEUE_START');
  end;

  --STOP AND DROP QUEUE THEO B?NG THAM S? APPMSGTX
  procedure SP_MSG_QUEUE_SHUTDOWN as
    v_exectyp   varchar2(2);
    v_objtype   varchar2(2);
    v_queuename varchar2(50);
    v_spname    varchar2(50);

    queue_does_not_exist exception;
    pragma exception_init(queue_does_not_exist, -24010);

    aq_agent_is_not_a_subscriber exception;
    pragma exception_init(aq_agent_is_not_a_subscriber, -24035);

    cursor c_queue_def is
      select EXECTYP, OBJTYPE, QUEUENAME, STOREDNAME
        from APPMSGTX
       where STATUS = 'Y';
  begin
    plog.setbeginsection(pkgctx, 'SP_MSG_QUEUE_SHUTDOWN');
    plog.debug(pkgctx, 'BEGIN OF SP_MSG_QUEUE_SHUTDOWN');

    --Stop queue x? l?
    open c_queue_def;
    loop
      --fetch queue
      fetch c_queue_def
        into v_exectyp, v_objtype, v_queuename, v_spname;
      exit when c_queue_def%notfound;
      --stop
      begin
        plog.debug(pkgctx, 'Stop queue: ' || v_queuename);
        DBMS_AQADM.STOP_QUEUE(queue_name => v_queuename);
      exception
        when queue_does_not_exist then
          plog.error(pkgctx, 'Queue ' || v_queuename || ' does not exists');
        when aq_agent_is_not_a_subscriber then
          plog.error(pkgctx, 'AQ agent ' || v_queuename || '_subscriber is not a subscriber');
      end;
    end loop;
    close c_queue_def;

    --STOP AND DROP QUEUE IN
    DBMS_AQADM.STOP_QUEUE(queue_name => 'FSS_QT_BASED_QUEUE');
    DBMS_AQADM.STOP_QUEUE(queue_name => 'FSS_QO_BASED_QUEUE');
    DBMS_AQADM.STOP_QUEUE(queue_name => 'TXAQS_BO2FO');
    DBMS_AQADM.STOP_QUEUE(queue_name => 'TXAQS_FO2BO');

    plog.debug(pkgctx, '<<END OF SP_MSG_QUEUE_SHUTDOWN');
    plog.setendsection(pkgctx, 'SP_MSG_QUEUE_SHUTDOWN');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_MSG_QUEUE_SHUTDOWN');
  end;
  --*******************************************************************************************
  --END: TH? T?C QU?N TR? H? TH?NG MESSAGE BUS CHUNG
  --*******************************************************************************************

  --*******************************************************************************************
  --BEGIN: TH? T?C X? L?ON_EVENT: C?C SUBCRIBED QUEUE S? K?H HO?T C?C TH? T?C N?Y
  --*******************************************************************************************
  --Ph?ph?i object/transaction
  procedure SP_FSS_MSQ_ROUTING(context  raw,
                               reginfo  SYS.AQ$_REG_INFO,
                               descr    SYS.AQ$_DESCRIPTOR,
                               payload  raw,
                               payloadl number) as
    r_enqueue_options    DBMS_AQ.ENQUEUE_OPTIONS_T;
    r_dequeue_options    DBMS_AQ.DEQUEUE_OPTIONS_T;
    r_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
    v_message_handle     raw(16);
    o_tx_payload         fss_txlog_queue_payload_type;
    o_obj_payload        fss_objlog_queue_payload_type;
    v_refobject          varchar2(100); --t?b?ng ho?c m?iao d?ch
    v_refqueuename       varchar2(100); --queue nh?n d? li?u
    v_refqueuetype       varchar2(2); --queue nh?n d? li?u
    v_refmessage         varchar2(1000);
    type r_cursor is ref cursor;
    c_queue_def r_cursor;
  begin
    plog.setbeginsection(pkgctx, 'SP_FSS_MSQ_ROUTING');
    plog.debug(pkgctx, 'BEGIN OF SP_FSS_MSQ_ROUTING');

    r_dequeue_options.msgid         := descr.msg_id;
    r_dequeue_options.consumer_name := descr.consumer_name;

    --dequeue
    plog.debug(pkgctx, 'Dequeue: ' || descr.queue_name);
    if instr(descr.queue_name, 'FSS_QO_BASED_QUEUE') > 0 then
      begin
        DBMS_AQ.DEQUEUE(queue_name         => descr.queue_name,
                        dequeue_options    => r_dequeue_options,
                        message_properties => r_message_properties,
                        payload            => o_obj_payload,
                        msgid              => v_message_handle);
        v_refqueuetype := 'O';
        v_refqueuename := 'FSS_QO_DEFAULT'; --default queue
        v_refobject    := o_obj_payload.objname;
        v_refmessage   := o_obj_payload.objname || '.' ||
                          o_obj_payload.rcdkey;
      end;
    elsif instr(descr.queue_name, 'FSS_QT_BASED_QUEUE') > 0 then
      begin
        DBMS_AQ.DEQUEUE(queue_name         => descr.queue_name,
                        dequeue_options    => r_dequeue_options,
                        message_properties => r_message_properties,
                        payload            => o_tx_payload,
                        msgid              => v_message_handle);
        v_refqueuetype := 'T';
        v_refqueuename := 'FSS_QT_DEFAULT'; --default queue
        v_refobject    := o_tx_payload.tltxcd;
        v_refmessage   := TO_CHAR(o_tx_payload.txdate, 'DD/MM/YYYY') || '.' ||
                          o_tx_payload.txnum || '.' || o_tx_payload.tltxcd;
      end;
    else
      v_refobject := '';
    end if;
    plog.debug(pkgctx, 'message content: ' || v_refmessage);

    --X?d?nh queue nh?n d? li?u:
    --M?t object/transaction c?? c?i?u Queue nh?n d? li?u. N?u kh?d?nh nghia s? m?t message
    plog.debug(pkgctx, 'object name: ' || v_refobject);
    --Stop queue x? l?
    open c_queue_def for
      select QUEUENAME from APPMSGMAP where OBJNAME = v_refobject;
    loop
      --fetch queue definition
      fetch c_queue_def
        into v_refqueuename;
      exit when c_queue_def%notfound;

      --?a v?queue x? l? tuong ?ng
      v_refqueuename := v_ownerschema || '.' || v_refqueuename;
      plog.debug(pkgctx, 'forward to: ' || v_refqueuename);
      if v_refqueuetype = 'T' then
        DBMS_AQ.ENQUEUE(queue_name         => v_refqueuename,
                        enqueue_options    => r_enqueue_options,
                        message_properties => r_message_properties,
                        payload            => o_tx_payload,
                        msgid              => v_message_handle);
      elsif v_refqueuetype = 'O' then
        DBMS_AQ.ENQUEUE(queue_name         => v_refqueuename,
                        enqueue_options    => r_enqueue_options,
                        message_properties => r_message_properties,
                        payload            => o_obj_payload,
                        msgid              => v_message_handle);
      end if;
    end loop;
    close c_queue_def;
    commit;

    plog.debug(pkgctx, '<<END OF SP_FSS_MSQ_ROUTING');
    plog.setendsection(pkgctx, 'SP_FSS_MSQ_ROUTING');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_FSS_MSQ_ROUTING');
  end;

  procedure SP_FSS_MSQ_OBJ_ROUTING as
    l_obj_payload  fss_objlog_queue_payload_type;
    l_demprop      DBMS_AQ.message_properties_t;
    l_deqopt       DBMS_AQ.dequeue_options_t;
    l_msgid        raw(16);
    l_refqueuename varchar2(100);
    type r_cursor is ref cursor;
    c_queue_def r_cursor;

    no_msg_found exception;
    pragma exception_init(no_msg_found, -25228);
  begin
    plog.setbeginsection(pkgctx, 'SP_FSS_MSQ_OBJ_ROUTING');
    plog.debug(pkgctx, 'BEGIN OF SP_FSS_MSQ_OBJ_ROUTING');

    l_deqopt.WAIT          := DBMS_AQ.no_wait;
    l_deqopt.navigation    := DBMS_AQ.first_message;
    l_deqopt.dequeue_mode  := DBMS_AQ.remove;
    l_deqopt.consumer_name := 'FSS_QO_BASED_QUEUE_SUBSCRIBER';

    loop

      --dequeue
      plog.debug(pkgctx, 'Dequeue: FSS_QO_BASED_QUEUE');

      DBMS_AQ.DEQUEUE(queue_name         => 'FSS_QO_BASED_QUEUE',
                      dequeue_options    => l_deqopt,
                      message_properties => l_demprop,
                      payload            => l_obj_payload,
                      msgid              => l_msgid);

      --X?d?nh queue nh?n d? li?u:
      --M?t object/transaction c?? c?i?u Queue nh?n d? li?u. N?u kh?d?nh nghia s? m?t message
      --Stop queue x? l?
      open c_queue_def for
        select QUEUENAME
          from APPMSGMAP
         where OBJNAME = l_obj_payload.objname;
      loop
        --fetch queue definition
        fetch c_queue_def
          into l_refqueuename;
        exit when c_queue_def%notfound;

        plog.debug(pkgctx,
                   'l_refqueuename: ' || l_refqueuename || '-objname ' ||
                   l_obj_payload.objname || '-rcdkey ' ||
                   l_obj_payload.rcdkey || '-oldval ' ||
                   l_obj_payload.oldval || '-newval ' ||
                   l_obj_payload.newval);

        sp_fss_qo_process_default(qname    => l_refqueuename,
                                  objqueue => l_obj_payload);

      end loop;
      close c_queue_def;
      commit;

      l_deqopt.navigation := DBMS_AQ.next_message;
    end loop;
    plog.debug(pkgctx, '<<END OF SP_FSS_MSQ_OBJ_ROUTING');
    plog.setendsection(pkgctx, 'SP_FSS_MSQ_OBJ_ROUTING');
    return;
  exception
    when no_msg_found then
      --plog.DEBUG(pkgctx, 'NO MORE MESSAGE ' || SQLERRM);
      commit;
      plog.setendsection(pkgctx, 'pr_market_info_process');
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_FSS_MSQ_OBJ_ROUTING');
  end;

  --X? L?QUEUE OBJECT CO B?N (DEFAULT)
  procedure SP_FSS_QO_BASED(context  raw,
                            reginfo  SYS.AQ$_REG_INFO,
                            descr    SYS.AQ$_DESCRIPTOR,
                            payload  raw,
                            payloadl number) as
    r_dequeue_options    DBMS_AQ.DEQUEUE_OPTIONS_T;
    r_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
    v_message_handle     raw(16);
    o_payload            fss_objlog_queue_payload_type;
    v_refobject          varchar2(100); --t?b?ng ho?c m?iao d?ch
    v_refqueuename       varchar2(100); --queue nh?n d? li?u
    v_refqueuetype       varchar2(2); --queue nh?n d? li?u
    v_refmessage         varchar2(1000);
  begin
    plog.setbeginsection(pkgctx, 'SP_FSS_QO_BASED');
    plog.debug(pkgctx, 'BEGIN OF SP_FSS_QO_BASED');
    r_dequeue_options.msgid         := descr.msg_id;
    r_dequeue_options.consumer_name := descr.consumer_name;

    --Dequeue
    DBMS_AQ.DEQUEUE(queue_name         => descr.queue_name,
                    dequeue_options    => r_dequeue_options,
                    message_properties => r_message_properties,
                    payload            => o_payload,
                    msgid              => v_message_handle);

    v_refmessage := o_payload.objname || '.' || o_payload.rcdkey;
    plog.debug(pkgctx, 'refmsg: ' || v_refmessage);
    --X? l?
    SP_FSS_QO_PROCESS_DEFAULT(descr.queue_name, o_payload);
    commit;

    plog.debug(pkgctx, '<<END OF SP_FSS_QO_BASED');
    plog.setendsection(pkgctx, 'SP_FSS_QO_BASED');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_FSS_QO_BASED');
  end;

  --X? L?QUEUE TRANSACT CO B?N
  procedure SP_FSS_QT_BASED(context  raw,
                            reginfo  SYS.AQ$_REG_INFO,
                            descr    SYS.AQ$_DESCRIPTOR,
                            payload  raw,
                            payloadl number) as
    r_dequeue_options    DBMS_AQ.DEQUEUE_OPTIONS_T;
    r_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
    v_message_handle     raw(16);
    o_payload            fss_txlog_queue_payload_type;
    v_refobject          varchar2(100); --t?b?ng ho?c m?iao d?ch
    v_refqueuename       varchar2(100); --queue nh?n d? li?u
    v_refqueuetype       varchar2(2); --queue nh?n d? li?u
    v_refmessage         varchar2(1000);
  begin
    plog.setbeginsection(pkgctx, 'SP_FSS_QT_BASED');
    plog.debug(pkgctx, 'BEGIN OF SP_FSS_QT_BASED');

    r_dequeue_options.msgid         := descr.msg_id;
    r_dequeue_options.consumer_name := descr.consumer_name;

    --Dequeue
    DBMS_AQ.DEQUEUE(queue_name         => descr.queue_name,
                    dequeue_options    => r_dequeue_options,
                    message_properties => r_message_properties,
                    payload            => o_payload,
                    msgid              => v_message_handle);

    v_refmessage := to_char(o_payload.txdate, 'DD/MM/YYYY') || '.' ||
                    o_payload.txnum || '.' || o_payload.tltxcd;
    plog.debug(pkgctx, 'refmsg: ' || v_refmessage);
    --X? l?
    SP_FSS_QT_PROCESS_DEFAULT(descr.queue_name, o_payload);
    commit;

    plog.debug(pkgctx, '<<END OF SP_FSS_QT_BASED');
    plog.setendsection(pkgctx, 'SP_FSS_QT_BASED');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_FSS_QT_BASED');
  end;

  --X? L?QUEUE OBJECT CO B?N (DEFAULT)
  procedure SP_FSS_FO_BASED(context  raw,
                            reginfo  SYS.AQ$_REG_INFO,
                            descr    SYS.AQ$_DESCRIPTOR,
                            payload  raw,
                            payloadl number) as
    r_dequeue_options    DBMS_AQ.DEQUEUE_OPTIONS_T;
    r_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
    v_message_handle     raw(16);
    o_payload            fss_objlog_queue_payload_type;
    v_refobject          varchar2(100); --t?b?ng ho?c m?iao d?ch
    v_refqueuename       varchar2(100); --queue nh?n d? li?u
    v_refqueuetype       varchar2(2); --queue nh?n d? li?u
    v_refmessage         varchar2(1000);

    l_err_code           varchar2(50);
  begin
    plog.setbeginsection(pkgctx, 'SP_FSS_FO_BASED');
    plog.debug(pkgctx, 'BEGIN OF SP_FSS_FO_BASED');
    r_dequeue_options.msgid         := descr.msg_id;
    r_dequeue_options.consumer_name := descr.consumer_name;

    --Dequeue
    DBMS_AQ.DEQUEUE(queue_name         => descr.queue_name,
                    dequeue_options    => r_dequeue_options,
                    message_properties => r_message_properties,
                    payload            => o_payload,
                    msgid              => v_message_handle);

    v_refmessage := o_payload.objname || '.' || o_payload.rcdkey;
    plog.debug(pkgctx, 'refmsg: ' || v_refmessage);
    --X? l?
    txpks_auto.pr_fo2odbyorder(p_orderid => o_payload.rcdkey,p_err_code => l_err_code);
    commit;

    plog.debug(pkgctx, '<<END OF SP_FSS_FO_BASED');
    plog.setendsection(pkgctx, 'SP_FSS_FO_BASED');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_FSS_FO_BASED');
  end;
procedure SP_FSS_FOW_BASED(context  raw,
                            reginfo  SYS.AQ$_REG_INFO,
                            descr    SYS.AQ$_DESCRIPTOR,
                            payload  raw,
                            payloadl number) as
    r_dequeue_options    DBMS_AQ.DEQUEUE_OPTIONS_T;
    r_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
    v_message_handle     raw(16);
    o_payload            fss_objlog_queue_payload_type;
    v_refobject          varchar2(100); --t?b?ng ho?c m?iao d?ch
    v_refqueuename       varchar2(100); --queue nh?n d? li?u
    v_refqueuetype       varchar2(2); --queue nh?n d? li?u
    v_refmessage         varchar2(1000);
    v_txdate             date;
    v_orderid            varchar2(50);
    v_afacctno           varchar2(50);
    v_exectype           varchar2(50);
    v_pricetype          varchar2(50);
    v_symbol             varchar2(50);
    v_bankacct           varchar2(50);
    v_bankcode           varchar2(50);
    v_notes              varchar2(250);
    v_qtty               number(20);
    v_price              number(20,4);
    v_avlbal             number(20);
    v_holdamt            number(20);
    v_actype             varchar2(50);
    v_clearday          number(5);
    v_bratio             number(10,4);
    v_minfeeamt         number(10);
    v_deffeerate        number(10,4);
    l_err_code           varchar2(50);
  begin
    plog.setbeginsection(pkgctx, 'SP_FSS_FOW_BASED');
    plog.debug(pkgctx, 'BEGIN OF SP_FSS_FOW_BASED');
    r_dequeue_options.msgid         := descr.msg_id;
    r_dequeue_options.consumer_name := descr.consumer_name;

    --Dequeue
    DBMS_AQ.DEQUEUE(queue_name         => descr.queue_name,
                    dequeue_options    => r_dequeue_options,
                    message_properties => r_message_properties,
                    payload            => o_payload,
                    msgid              => v_message_handle);

    v_refmessage := o_payload.objname || '.' || o_payload.rcdkey;
    plog.debug(pkgctx, 'refmsg: ' || v_refmessage);

    --X? l?
    --X?d?nh s? ti?n c?n HOLD th?d? dua v?b?ng CRBTXREQ b?ng c? so s? PP0 v?i gi?r? c?n s? d?ng d? d?t l?nh
    --Sub-account Corebank t?m th?i ch? l?i?u kho?n thu?ng (kh?c?o l?)
    SELECT actype, clearday, bratio, minfeeamt, deffeerate
    INTO v_actype, v_clearday, v_bratio, v_minfeeamt, v_deffeerate
    FROM (SELECT a.actype, a.clearday, a.bratio, a.minfeeamt, a.deffeerate, b.ODRNUM
    FROM odtype a, afidtype b, fomast f, sbsecurities s, afmast af
    WHERE     a.status = 'Y' and f.codeid=s.codeid and f.afacctno=af.acctno
        AND (a.via = f.via OR a.via = 'A') --VIA
        AND a.clearcd = f.clearcd       --CLEARCD
        AND (a.exectype = f.exectype           --l_build_msg.fld22
             OR a.exectype = 'AA')                    --EXECTYPE
        AND (a.timetype = f.timetype
             OR a.timetype = 'A')                     --TIMETYPE
        AND (a.pricetype = f.pricetype
             OR a.pricetype = 'AA')                  --PRICETYPE
        AND (a.matchtype = f.matchtype
             OR a.matchtype = 'A')                   --MATCHTYPE
        AND (a.tradeplace = s.tradeplace
             OR a.tradeplace = '000')
        AND (instr(case when s.sectype in ('001','002','011') then s.sectype || ',' || '111,333'
                       when s.sectype in ('003','006') then s.sectype || ',' || '222,333,444'
                       when s.sectype in ('008') then s.sectype || ',' || '111,444'
                       else s.sectype end, a.sectype)>0 OR a.sectype = '000')
        AND (a.nork = f.nork OR a.nork = 'A') --NORK
        AND (CASE WHEN A.CODEID IS NULL THEN f.codeid ELSE A.CODEID END)=f.codeid
        AND a.actype = b.actype and b.aftype=af.actype and b.objname='OD.ODTYPE'
        order by b.odrnum desc) where rownum<=1;

    SELECT FO.ACCTNO ORDERID, TO_DATE(SUBSTR(FO.ACCTNO,1,10),'DD/MM/RRRR'), AF.BANKACCTNO, AF.BANKNAME, FO.AFACCTNO,
        FO.QUOTEPRICE*1000*FO.QUANTITY*v_bratio/100-getavlpp(AF.ACCTNO)+
    (case when v_minfeeamt> (FO.QUOTEPRICE*1000*FO.QUANTITY*v_deffeerate/100) then v_minfeeamt else (FO.QUOTEPRICE*1000*FO.QUANTITY*v_deffeerate/100) end) HOLDAMT,
        FO.EXECTYPE || '.' || FO.SYMBOL || ': ' || TO_CHAR(FO.QUANTITY) || '@' || DECODE(FO.PRICETYPE,'LO', TO_CHAR(FO.QUOTEPRICE), FO.PRICETYPE)
        INTO v_orderid, v_txdate, v_bankacct, v_bankcode, v_afacctno, v_holdamt, v_notes
    FROM FOMAST FO, AFMAST AF, CIMAST CI WHERE FO.ACCTNO=o_payload.rcdkey AND FO.AFACCTNO=AF.ACCTNO AND CI.AFACCTNO=AF.ACCTNO;
    if v_holdamt>0 then
        --T?o y?c?u HOLD g?i sang Bank. REFCODE=ORDERID
        INSERT INTO CRBTXREQ (REQID, OBJTYPE, OBJNAME, TRFCODE, REFCODE, OBJKEY, TXDATE,
            BANKCODE, BANKACCT, AFACCTNO, TXAMT, STATUS, REFTXNUM, REFTXDATE, REFVAL, NOTES)
        SELECT SEQ_CRBTXREQ.NEXTVAL, 'V', 'FOMAST', 'HOLD', v_orderid, v_orderid, v_txdate,
            v_bankcode, v_bankacct, v_afacctno, v_holdamt, 'P', null, null, null, v_notes
        FROM DUAL;
  else
    UPDATE FOMAST SET STATUS='P', DIRECT='N' WHERE ACCTNO=v_orderid;
    end if;
    commit;

    plog.debug(pkgctx, '<<END OF SP_FSS_FOW_BASED');
    plog.setendsection(pkgctx, 'SP_FSS_FOW_BASED');
    return;
  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setendsection(pkgctx, 'SP_FSS_FOW_BASED');
  end;
  --*******************************************************************************************
--END: TH? T?C X? L?ON_EVENT: C?C SUBCRIBED QUEUE S? K?H HO?T C?C TH? T?C N?Y
--*******************************************************************************************

begin
  --get current schema
  select sys_context('userenv', 'current_schema')
    into v_ownerschema
    from dual;
  --init debug
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
end MSGPKS_SYSTEM;
/


-- End of DDL Script for Package Body HOSTMSTRADE.MSGPKS_SYSTEM

