CREATE OR REPLACE PACKAGE cspks_esb AS
    PROCEDURE sp_place_order (f_orderid IN VARCHAR);    --Place order
    PROCEDURE sp_set_message_queue (f_content IN VARCHAR, f_queue IN VARCHAR);                  --Th? t?c dua message v?queue
    FUNCTION fn_get_message_queue (f_queue IN VARCHAR) RETURN varchar;                          --?c message trong queue
    FUNCTION fn_get_order_message (f_orderid IN VARCHAR, f_afacctno IN VARCHAR) RETURN varchar; --Tra chuoi order message
END CSPKS_ESB;
/

CREATE OR REPLACE PACKAGE BODY cspks_esb AS
    PROCEDURE sp_place_order(f_orderid IN VARCHAR) AS
    BEGIN
        --Goi ham dat lenh
        --INSERT INTO ESB2FLEXLOG (MSGBODY, MSGTIME) SELECT 'ORDERID: ' || f_orderid, SYSTIMESTAMP FROM DUAL;
        --txpks_auto.pr_fo2odbyorder(f_orderid);
        COMMIT;
    END sp_place_order;

    PROCEDURE sp_set_message_queue(f_content IN VARCHAR, f_queue IN VARCHAR) AS
        r_enqueue_options    DBMS_AQ.ENQUEUE_OPTIONS_T;
        r_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
        v_message_handle     RAW(16);
        o_payload            SYS.AQ$_JMS_TEXT_MESSAGE;
    BEGIN
        o_payload := SYS.AQ$_JMS_TEXT_MESSAGE.CONSTRUCT;
        o_payload.SET_TEXT(f_content);

        DBMS_AQ.ENQUEUE(
                queue_name         => f_queue,
                enqueue_options    => r_enqueue_options,
                message_properties => r_message_properties,
                payload            => o_payload,
                msgid              => v_message_handle
            );
        COMMIT;
    END sp_set_message_queue;

    FUNCTION fn_get_message_queue(f_queue IN VARCHAR) RETURN varchar AS
        r_dequeue_options    DBMS_AQ.DEQUEUE_OPTIONS_T;
        r_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
        v_message_handle     RAW(16);
        o_payload            SYS.AQ$_JMS_TEXT_MESSAGE;
        v_alert_msg          clob;
    BEGIN
        r_dequeue_options.dequeue_mode := DBMS_AQ.BROWSE;
        DBMS_AQ.DEQUEUE(
            queue_name         => f_queue,
            dequeue_options    => r_dequeue_options,
            message_properties => r_message_properties,
            payload            => o_payload,
            msgid              => v_message_handle
         );
        o_payload.GET_TEXT(v_alert_msg);

        return v_alert_msg;
    EXCEPTION
        WHEN OTHERS THEN
            return '';
    end fn_get_message_queue;

    FUNCTION fn_get_order_message(f_orderid IN VARCHAR, f_afacctno IN VARCHAR) RETURN varchar AS
        v_afclass   varchar(6);
        v_return    varchar2(1000);
    BEGIN
        select MOD(to_number(f_afacctno),20) into v_afclass from dual;
        v_return := '<?xml version="1.0" encoding="UTF-8"?><root><header><category>Orders</category><class>';
        v_return := v_return || v_afclass || '</class></header><body>{"OrderID": "' || f_orderid || '"}</body></root>';
        return v_return;
    EXCEPTION
        WHEN OTHERS THEN
            return '';
    end fn_get_order_message;

END CSPKS_ESB;
/

