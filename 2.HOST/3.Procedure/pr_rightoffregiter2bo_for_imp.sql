CREATE OR REPLACE PROCEDURE pr_rightoffregiter2bo_for_imp
    (p_camastid IN   varchar,
    p_account   IN   varchar,
    p_qtty      IN   number,
    p_desc      IN   varchar2,
    p_err_code  OUT varchar2,
    p_err_message  OUT varchar2
    )
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      l_symbol  varchar2(20);
      l_codeid   varchar2(20);
      l_exprice number;
      l_optcodeid varchar2(20);
      l_iscorebank  number;
      l_balance number;
      l_caschdautoid NUMBER;
      l_maxqtty NUMBER;
      l_parvalue NUMBER;
      l_cashbalance NUMBER;
      l_sebalance   NUMBER;
      l_fullname    varchar2(100);
      l_idcode      varchar2(20);
      l_iddate      varchar2(20);
      l_idplace     varchar2(200);
      l_reportdate  varchar2(20);
      l_custodycd   varchar2(10);
      l_phone       varchar2(50);
      l_count number;
  BEGIN

    -- Check host & branch active or inactive

    UPDATE CASCHD SET STATUS='V' WHERE CAMASTID =p_camastid;

    IF p_err_code <> systemnums.C_SUCCESS THEN
        p_err_message:=cspks_system.fn_get_errmsg(p_err_code);

        return;
    END IF;
    -- End: Check host & branch active or inactive

    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.C_ONLINE_USERID;
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
    l_txmsg.tltxcd:='3348';

    --Set txnum
    SELECT systemnums.C_OL_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
    l_txmsg.brid        := substr(p_account,1,4);

    --p_txnum:=l_txmsg.txnum;
    --p_txdate:=l_txmsg.txdate;
--BEGIN
plog.error('p_account:'||p_account);
plog.error('p_camastid:'||p_camastid);
select count(1) into l_count from caschd where camastid = p_camastid;
plog.error('caschd number of rows:'||l_count);
select count(1) into l_count from caschd where camastid = p_camastid and afacctno = p_account;
plog.error('af caschd number of rows:'||l_count);

    select ca.autoid, b.SYMBOL,a.exprice,a.codeid,optcodeid,CA.balance + CA.pbalance balance, ca.pqtty,a.parvalue,
        (case when ci.corebank ='Y' then 0 else 1 end) iscorebank, ci.balance, ca.trade, cf.fullname, cf.idcode,
        to_char(cf.iddate,'DD/MM/YYYY') iddate, cf.idplace, to_char(a.reportdate,'DD/MM/YYYY') reportdate,
        cf.custodycd, cf.phone
    into l_caschdautoid,l_symbol,l_exprice , l_codeid,l_optcodeid,l_balance,l_maxqtty, l_parvalue,l_iscorebank,
        l_cashbalance, l_sebalance, l_fullname, l_idcode , l_iddate, l_idplace, l_reportdate, l_custodycd, l_phone
    from camast a, caschd ca, sbsecurities b,cimast ci, cfmast cf, afmast af
    where a.codeid = b.codeid and a.camastid=p_camastid and ca.camastid=a.camastid
        AND cf.custid = af.custid AND af.acctno = ca.afacctno
        and ca.afacctno=p_account
        and ci.acctno=ca.afacctno;
/*EXCEPTION
    when others then
      ROLLBACK;
INSERT INTO cimastcv (CUSTODYCD,BALANCE,EMKAMT)
VALUES(p_account,'test',p_camastid);
commit;
end;*/


    --Set cac field giao dich
    --01   AUTOID      C
    l_txmsg.txfields ('01').defname   := 'AUTOID';
    l_txmsg.txfields ('01').TYPE      := 'C';
    l_txmsg.txfields ('01').VALUE     := to_char(nvl(l_caschdautoid,''));
    --02   CAMASTID      C
    l_txmsg.txfields ('02').defname   := 'CAMASTID';
    l_txmsg.txfields ('02').TYPE      := 'C';
    l_txmsg.txfields ('02').VALUE     := p_camastid;
    --03   AFACCTNO      C
    l_txmsg.txfields ('03').defname   := 'AFACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := p_account;
    --04   SYMBOL        C
    l_txmsg.txfields ('04').defname   := 'SYMBOL';
    l_txmsg.txfields ('04').TYPE      := 'C';
    l_txmsg.txfields ('04').VALUE     := l_symbol;
    --05   EXPRICE       N
    l_txmsg.txfields ('05').defname   := 'EXPRICE';
    l_txmsg.txfields ('05').TYPE      := 'N';
    l_txmsg.txfields ('05').VALUE     := l_exprice;
    --06   SEACCTNO      C
    l_txmsg.txfields ('06').defname   := 'SEACCTNO';
    l_txmsg.txfields ('06').TYPE      := 'C';
    l_txmsg.txfields ('06').VALUE     := p_account || l_codeid;
    --07   SE BALANCE       N
    l_txmsg.txfields ('07').defname   := 'BALANCE';
    l_txmsg.txfields ('07').TYPE      := 'N';
    l_txmsg.txfields ('07').VALUE     := l_sebalance;
    --08   FULLNAME      C
    l_txmsg.txfields ('08').defname   := 'FULLNAME';
    l_txmsg.txfields ('08').TYPE      := 'C';
    l_txmsg.txfields ('08').VALUE     := l_fullname;
    --09   OPTSEACCTNO   C
    l_txmsg.txfields ('09').defname   := 'OPTSEACCTNO';
    l_txmsg.txfields ('09').TYPE      := 'C';
    l_txmsg.txfields ('09').VALUE     := p_account || l_optcodeid;
    --10   AMT          N
    l_txmsg.txfields ('10').defname   := 'AMT';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     :=  0 ;-- round(nvl(p_qtty,0) * nvl(l_exprice,0),0)
    --11   CI BALANCE          N
    l_txmsg.txfields ('11').defname   := 'CIBALANCE';
    l_txmsg.txfields ('11').TYPE      := 'N';
    l_txmsg.txfields ('11').VALUE     := l_cashbalance;
    --12   CI BALANCE          N
    l_txmsg.txfields ('12').defname   := 'BALANCE';
    l_txmsg.txfields ('12').TYPE      := 'N';
    l_txmsg.txfields ('12').VALUE     := l_cashbalance;
    --16   TASKCD        C
    l_txmsg.txfields ('16').defname   := 'TASKCD';
    l_txmsg.txfields ('16').TYPE      := 'C';
    l_txmsg.txfields ('16').VALUE     := '';
    --20   MAXQTTY          N
    l_txmsg.txfields ('20').defname   := 'MAXQTTY';
    l_txmsg.txfields ('20').TYPE      := 'N';
    l_txmsg.txfields ('20').VALUE     := l_maxqtty;
    --21   QTTY          N
    l_txmsg.txfields ('21').defname   := 'QTTY';
    l_txmsg.txfields ('21').TYPE      := 'N';
    l_txmsg.txfields ('21').VALUE     := p_qtty;
    --22   PARVALUE          N
    l_txmsg.txfields ('22').defname   := 'PARVALUE';
    l_txmsg.txfields ('22').TYPE      := 'N';
    l_txmsg.txfields ('22').VALUE     := l_parvalue;
    --23   REPORTDATE          N
    l_txmsg.txfields ('23').defname   := 'REPORTDATE';
    l_txmsg.txfields ('23').TYPE      := 'C';
    l_txmsg.txfields ('23').VALUE     := l_reportdate;
    --30   DESCRIPTION   C
    l_txmsg.txfields ('30').defname   := 'DESCRIPTION';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE     := p_desc;
    --40   STATUS        C
    l_txmsg.txfields ('40').defname   := 'STATUS';
    l_txmsg.txfields ('40').TYPE      := 'C';
    l_txmsg.txfields ('40').VALUE     := 'M';
    --60   ISCOREBANK        C
    l_txmsg.txfields ('60').defname   := 'ISCOREBANK';
    l_txmsg.txfields ('60').TYPE      := 'N';
    l_txmsg.txfields ('60').VALUE     := l_iscorebank;
    --70   PHONE    C
    l_txmsg.txfields ('70').defname   := 'PHONE';
    l_txmsg.txfields ('70').TYPE      := 'C';
    l_txmsg.txfields ('70').VALUE     := l_phone;
    --90   CUSTNAME    C
    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
    l_txmsg.txfields ('90').TYPE      := 'C';
    l_txmsg.txfields ('90').VALUE     := l_fullname;
    --91   ADDRESS     C
    l_txmsg.txfields ('91').defname   := 'ADDRESS';
    l_txmsg.txfields ('91').TYPE      := 'C';
    l_txmsg.txfields ('91').VALUE     := '';
    --92   LICENSE     C
    l_txmsg.txfields ('92').defname   := 'LICENSE';
    l_txmsg.txfields ('92').TYPE      := 'C';
    l_txmsg.txfields ('92').VALUE     := l_idcode;
    --93   IDDATE    C
    l_txmsg.txfields ('93').defname   := 'IDDATE';
    l_txmsg.txfields ('93').TYPE      := 'C';
    l_txmsg.txfields ('93').VALUE     := l_iddate;
    --94   IDPLACE    C
    l_txmsg.txfields ('94').defname   := 'IDPLACE';
    l_txmsg.txfields ('94').TYPE      := 'C';
    l_txmsg.txfields ('94').VALUE     := l_idplace;
    --95   ISSNAME    C
    l_txmsg.txfields ('95').defname   := 'ISSNAME';
    l_txmsg.txfields ('95').TYPE      := 'C';
    l_txmsg.txfields ('95').VALUE     :='';
    --96   CUSTODYCD    C
    l_txmsg.txfields ('96').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('96').TYPE      := 'C';
    l_txmsg.txfields ('96').VALUE     := l_custodycd;


    BEGIN
        IF txpks_#3348.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
                ROLLBACK;
           --p_err_message:=cspks_system.fn_get_errmsg(p_err_code);

           RETURN;
        END IF;
         --ROLLBACK;
    END;
    p_err_code:=0;

  EXCEPTION
  WHEN OTHERS
   THEN

      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error('Row:'||dbms_utility.format_error_backtrace);
      plog.error(SQLERRM);

      RAISE errnums.E_SYSTEM_ERROR;
  END ;
/

