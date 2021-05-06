CREATE OR REPLACE PROCEDURE pr_genpassafmast( p_err_code in OUT varchar2,
                            p_username varchar,
                            p_custid  varchar2,
                            p_acctnotlid varchar2
                           )
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      v_username   varchar2(200);
      v_custid    varchar2(200);
      v_tokenid  varchar2(200);
      v_LOGINPWD varchar2(200);
      v_tradingpwd varchar2(200);
      v_authtype varchar2(200);
      v_email varchar2(200);
      v_count number;
      v_custodycd varchar2(20);
       p_err_message  varchar2(250);
       v_acctno varchar(10);
       v_maxmod number;
       v_strCURRDATETIME varchar2(20);
       --v_tlname varchar(50);
    v_tlid varchar2(4);

  BEGIN
    v_tlid := substr(p_acctnotlid,11,4);
    v_acctno := substr(p_acctnotlid,1,10);
    v_custodycd := substr(p_acctnotlid,15,10);
     v_username := p_username;
    SELECT cf.custid,cf.email,
           '{MSBS{SMS{'||NVL(CF.mobile,'SDT')||'}}}' tokenid
    INTO   v_custid,v_email,v_tokenid
    FROM CFMAST CF
    WHERE CF.custid = p_custid
    ;
    v_tradingpwd:=cspks_system.fn_passwordgenerator(6);
    v_LOGINPWD:=cspks_system.fn_passwordgenerator(6);

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    --temporary update status of AFMAST = 'A' for ignore -200013 error
    --update afmast set status = 'A' where acctno = v_acctno;
    --commit;

    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_SYSTEM_USERID;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='0090';

    --Set txnum
    SELECT systemnums.C_FO_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;

     l_txmsg.brid        := substr(v_custid,1,4);

    --Set cac field giao dich
    --03   CUSTID     C
    l_txmsg.txfields ('03').defname   := 'CUSTID';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := v_custid;
    --05   USERNAME     C
    l_txmsg.txfields ('05').defname   := 'USERNAME';
    l_txmsg.txfields ('05').TYPE      := 'C';
    l_txmsg.txfields ('05').VALUE     := v_username;
    --06   EMAIL     C
    l_txmsg.txfields ('06').defname   := 'EMAIL';
    l_txmsg.txfields ('06').TYPE      := 'C';
    l_txmsg.txfields ('06').VALUE     := v_EMAIL;
    --10   LOGINPWD     C
    l_txmsg.txfields ('10').defname   := 'LOGINPWD';
    l_txmsg.txfields ('10').TYPE      := 'C';
    l_txmsg.txfields ('10').VALUE     := v_LOGINPWD;
    --11  AUTHTYPE
    l_txmsg.txfields ('11').defname   := 'AUTHTYPE';
    l_txmsg.txfields ('11').TYPE      := 'C';
    l_txmsg.txfields ('11').VALUE     := 'N';
    --12  TRADINGPWD
    l_txmsg.txfields ('12').defname   := 'TRADINGPWD';
    l_txmsg.txfields ('12').TYPE      := 'C';
    l_txmsg.txfields ('12').VALUE     := v_TRADINGPWD;
    --13  DAYS
    l_txmsg.txfields ('13').defname   := 'DAYS';
    l_txmsg.txfields ('13').TYPE      := 'N';
    l_txmsg.txfields ('13').VALUE     := 100;
    -- 14  ISMASTER
    l_txmsg.txfields ('14').defname   := 'ISMASTER';
    l_txmsg.txfields ('14').TYPE      := 'C';
    l_txmsg.txfields ('14').VALUE     := 'N';
    -- 15  TOKENID
    l_txmsg.txfields ('15').defname   := 'TOKENID';
    l_txmsg.txfields ('15').TYPE      := 'C';
    l_txmsg.txfields ('15').VALUE     := v_tokenid;
    --30 DESC
    l_txmsg.txfields ('30').defname   := 'DESC';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     := 'Reset online trading passs';
    --88 CUSTODYCD
    l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('88').TYPE      := 'C';
    l_txmsg.txfields ('88').VALUE     := v_custodycd;

--plog.debug(pkgctx, '  pr_resetpassonline 3 :');


    BEGIN
        IF txpks_#0090.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.error ('got error 0090: ' || p_err_code);
           ROLLBACK;
           p_err_message:=cspks_system.fn_get_errmsg(p_err_code);
          plog.error('Error:'  || p_err_message);
           --plog.setendsection(pkgctx, 'pr_resetpassonline');
           RETURN;
        END IF;
    END;

    p_err_code:='0';
/*
    --update status = Pending
    update afmast set status = 'P' where acctno = v_acctno;
    --get mod_num for maintain_log
    select nvl(max(mod_num),0) into v_maxmod from maintain_log where table_name = 'AFMAST' and  RECORD_KEY = 'ACCTNO = '''|| v_acctno ||'''';
    --insert into maintain_log for approve
    INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,
                            MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
    VALUES('AFMAST'
            ,'ACCTNO = ''' ||v_acctno|| ''''
            ,v_tlid
            ,to_date(v_strCURRDATE,systemnums.c_date_format)
            ,'Y',NULL,NULL
            ,v_maxmod + 1
            ,'USERNAME'
            ,NULL,upper(p_username)
            ,'EDIT'
            ,'CFMAST'
            ,'USERNAME = ''' || upper(p_username) ||''''
            ,trim(TO_CHAR(CURRENT_DATE, 'HH:MI:SS')));*/

  EXCEPTION
  WHEN OTHERS
   THEN
      --plog.debug (pkgctx,'got error on pr_resetpassonline');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
     -- plog.error (pkgctx, SQLERRM);
     -- plog.setendsection (pkgctx, 'pr_resetpassonline');
      RAISE errnums.E_SYSTEM_ERROR;
  END ;
/

