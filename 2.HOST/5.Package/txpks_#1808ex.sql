CREATE OR REPLACE PACKAGE txpks_#1808ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1808EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      21/08/2013     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY txpks_#1808ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_t0loanratenew    CONSTANT CHAR(2) := '13';
   c_t0loanlimit      CONSTANT CHAR(2) := '15';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

BEGIN
   plog.setbeginsection (pkgctx, 'fn_txPreAppCheck');
   plog.debug(pkgctx,'BEGIN OF fn_txPreAppCheck');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppCheck;

FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAftAppCheck');
   plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppCheck>>');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck>>');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txAftAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppCheck;

FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppUpdate');
    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

 l_txmsg            tx.msg_rectype;
 l_err_param        varchar2(300);
 v_desc             varchar2(100);
 v_currdate         date;
 v_T0LOANRATENEW    number(20,0);
 v_T0LOANLIMITNEW   number(20,0);

BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
     Select TO_DATE (varvalue, systemnums.c_date_format) into v_currdate
     From sysvar
     Where varname='CURRDATE';

      l_txmsg.msgtype:='T';
      l_txmsg.local:='N';
      l_txmsg.tlid        := p_txmsg.tlid;
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
      l_txmsg.txdate:=to_date(v_currdate,systemnums.c_date_format);
      l_txmsg.busdate:=to_date(v_currdate,systemnums.c_date_format);
      l_txmsg.tltxcd:='1809';

      SELECT TXDESC INTO v_desc FROM TLTX WHERE TLTXCD = '1809';
     l_txmsg.brid        := p_txmsg.brid;

    FOR REC in (SELECT CF.CUSTID,  case when CF.CUSTODYCD is null then '' else CF.CUSTODYCD end CUSTODYCD,
                    CF.FULLNAME, cf.idcode, t0loanlimit, cf.T0LOANRATE,
                    case when  to_number(p_txmsg.txfields('13').value) > 0 then to_number(p_txmsg.txfields('13').value) else  cf.T0LOANRATE end T0LOANRATENEW,
                    case when  to_number(p_txmsg.txfields('15').value) > 0 then to_number(p_txmsg.txfields('15').value) else  cf.t0loanlimit end T0LOANLIMITNEW
                FROM CFMAST CF where 0=0 AND STATUS='A' AND LENGTH(NVL(CF.CUSTODYCD,''))>0 and cf.contractchk='Y'

                )
    loop

        plog.debug(pkgctx, 'v_T0LOANRATENEW: ' || rec.T0LOANRATENEW );
        plog.debug(pkgctx, 'v_T0LOANLIMITNEW: ' || rec.T0LOANLIMITNEW );

        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;

         -- 03  C   APPLID
        l_txmsg.txfields ('03').defname   := 'APPLID';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := rec.CUSTID;

        -- 05  C   CUSTNAME
        l_txmsg.txfields ('05').defname   := 'CUSTNAME';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE     := rec.fullname;

        -- 06  C   IDCODE
        l_txmsg.txfields ('06').defname   := 'IDCODE';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').VALUE     := rec.IDCODE;

        -- 12  N   T0LOANRATE
        l_txmsg.txfields ('12').defname   := 'T0LOANRATE';
        l_txmsg.txfields ('12').TYPE      := 'N';
        l_txmsg.txfields ('12').VALUE     := rec.T0LOANRATE;

        --13  N   T0LOANRATENEW
        l_txmsg.txfields ('13').defname   := 'T0LOANRATENEW';
        l_txmsg.txfields ('13').TYPE      := 'N';
        l_txmsg.txfields ('13').VALUE     := rec.T0LOANRATENEW;

        -- 14  N   OLDT0LOANLIMIT
        l_txmsg.txfields ('14').defname   := 'OLDT0LOANLIMIT';
        l_txmsg.txfields ('14').TYPE      := 'N';
        l_txmsg.txfields ('14').VALUE     := rec.t0loanlimit;

        -- 15  N   T0LOANLIMIT
        l_txmsg.txfields ('15').defname   := 'T0LOANLIMIT';
        l_txmsg.txfields ('15').TYPE      := 'N';
        l_txmsg.txfields ('15').VALUE     :=  rec.T0LOANLIMITNEW;

        --30  C   DESC
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := v_desc;

        -- 88  C   CUSTODYCD
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').VALUE     := rec.CUSTODYCD;

            BEGIN
                IF txpks_#1809.fn_autotxprocess (l_txmsg,
                                                 p_err_code,
                                                 l_err_param
                   ) <> systemnums.c_success
                THEN
                   plog.debug (pkgctx,
                               'got error 1809: ' || p_err_code
                   );
                   ROLLBACK;
                   RETURN errnums.C_SYSTEM_ERROR;
                END IF;
            END;

    end loop;



    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppUpdate;

BEGIN
      FOR i IN (SELECT *
                FROM tlogdebug)
      LOOP
         logrow.loglevel    := i.loglevel;
         logrow.log4table   := i.log4table;
         logrow.log4alert   := i.log4alert;
         logrow.log4trace   := i.log4trace;
      END LOOP;
      pkgctx    :=
         plog.init ('TXPKS_#1808EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1808EX;
/

