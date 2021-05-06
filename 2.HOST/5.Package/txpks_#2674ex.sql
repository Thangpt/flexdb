CREATE OR REPLACE PACKAGE txpks_#2674ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2674EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      18/09/2011     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#2674ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_groupid          CONSTANT CHAR(2) := '20';
   c_lnacctno         CONSTANT CHAR(2) := '21';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_afacctno         CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '57';
   c_address          CONSTANT CHAR(2) := '58';
   c_license          CONSTANT CHAR(2) := '59';
   c_contractchk      CONSTANT CHAR(2) := '86';
   c_limitcheck       CONSTANT CHAR(2) := '99';
   c_rrtype           CONSTANT CHAR(2) := '15';
   c_actype           CONSTANT CHAR(2) := '04';
   c_dftype           CONSTANT CHAR(2) := '06';
   c_irate            CONSTANT CHAR(2) := '14';
   c_mrate            CONSTANT CHAR(2) := '08';
   c_lrate            CONSTANT CHAR(2) := '09';
   c_amt              CONSTANT CHAR(2) := '41';
   c_rlsamt           CONSTANT CHAR(2) := '18';
   c_calltype         CONSTANT CHAR(2) := '17';
   c_autodrawndown    CONSTANT CHAR(2) := '16';
   c_cidrawndown      CONSTANT CHAR(2) := '51';
   c_bankdrawndown    CONSTANT CHAR(2) := '52';
   c_cmpdrawndown     CONSTANT CHAR(2) := '53';
   c_rrid             CONSTANT CHAR(2) := '50';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_status varchar2(30);
l_ORGAMT number ;
l_AFACCTNODRD varchar2(20);
l_AFACCTNO varchar2(20);
l_ACTYPE varchar2(20);
l_mrcrlimitmax number;
L_LIMITCHK NUMBER;
l_DFODAMT number ;
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

       select STATUS into l_status  from DFGROUP  where GROUPID =  p_txmsg.txfields ('20').VALUE  ;


      IF l_status ='A' THEN
          p_err_code:= -260020;
          RETURN -260020;
    END IF;

    --- Check han muc
    l_ORGAMT := p_txmsg.txfields ('41').VALUE;
    l_AFACCTNODRD  := p_txmsg.txfields ('03').VALUE ;
    l_AFACCTNO :=  p_txmsg.txfields ('03').VALUE ;
    L_LIMITCHK:=  p_txmsg.txfields ('99').VALUE ;

    select DFODAMT into l_DFODAMT from cimast where acctno = nvl(l_AFACCTNODRD,l_AFACCTNO) ;

    select mrcrlimitmax - l_DFODAMT into l_mrcrlimitmax  from afmast  where acctno = nvl(l_AFACCTNODRD,l_AFACCTNO) ;

    plog.debug (pkgctx, 'mrcrlimitmax ' || l_mrcrlimitmax || ' l_DFODAMT: ' || l_DFODAMT || ' l_ORGAMT ' || l_ORGAMT || ' L_LIMITCHK' || L_LIMITCHK);

    IF (l_mrcrlimitmax < l_ORGAMT) and (L_LIMITCHK=1) THEN
          p_err_code:= -400119;
          RETURN -400119;
    END IF;


    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
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
      plog.error (pkgctx, SQLERRM);
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
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
      p_err_code:=CSPKS_LNPROC.fn_CreateLoanSchedule(p_txmsg.txfields ('21').VALUE ,p_txmsg.txfields ('41').VALUE ,p_err_code);
     -- PhuongHT add
     -- insert vao lnschdlog
      INSERT INTO LNSCHDLOG(AUTOID, TXNUM, TXDATE, NML)
      VALUES((SELECT autoid FROM lnschd WHERE reftype='P' AND acctno=p_txmsg.txfields ('21').VALUE ),
       p_txmsg.txnum, TO_DATE(p_txmsg.txdate,'DD/MM/RRRR'), to_number(p_txmsg.txfields ('41').VALUE));
     --end of PhuongHT add

      UPDATE  DFgroup SET STATUS ='A', AMT=AMT+p_txmsg.txfields ('41').VALUE WHERE GROUPID=  p_txmsg.txfields ('20').VALUE  ;
     --  cspks_dfproc.pr_dfDrawndowndealdtl( p_txmsg ,p_err_code ) ;

     -- TheNN added, 03-Aug-2012
     -- Them doan log vao bang log de tao bao cao
    if not fn_gen_cl_drawndown_report('DF') then
        p_err_code:='-540229';
        plog.setendsection(pkgctx, 'fn_txAftAppUpdate');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;
    -- End TheNN added

    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
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
         plog.init ('TXPKS_#2674EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2674EX;
/

