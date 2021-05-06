CREATE OR REPLACE PACKAGE txpks_#0391ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0391EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      06/11/2012     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#0391ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_custname         CONSTANT CHAR(2) := '90';
   c_afstatus         CONSTANT CHAR(2) := '01';
   c_changere         CONSTANT CHAR(2) := '02';
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
   l_CUSTODYCD  VARCHAR2(20);
   v_currdate DATE;
   v_check NUMBER(2);
   l_strTXDATE varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_CUSTODYCD:= p_txmsg.txfields('88').value;
    l_strTXDATE :=p_txmsg.TXDATE;
    v_currdate:=TO_DATE( l_strTXDATE , systemnums.C_DATE_FORMAT);
    UPDATE CFMAST SET AFSTATUS = DECODE(AFSTATUS,'O','N','O') WHERE CUSTODYCD=l_CUSTODYCD;
        For rec in(SELECT r.autoid, r.txdate, r.txnum, r.refrecflnkid, r.reacctno,
                       r.afacctno, r.frdate, r.todate, r.deltd, r.clstxdate, r.clstxnum,
                       r.pstatus, r.status, r.furefrecflnkid, r.fureacctno
                     From reaflnk r,afmast af, cfmast cf, retype rty
                     WHERE r.status='A'
                      And r.afacctno= af.acctno
                      and af.custid=cf.custid
                      and substr(reacctno,11,4)=rty.actype
                      and rty.rerole in ('BM')
                      And cf.custodycd =  l_CUSTODYCD)
         Loop
                insert into reaflnk(autoid, txdate, txnum, refrecflnkid, reacctno,
                   afacctno, frdate, todate, deltd, clstxdate, clstxnum,
                   pstatus, status, furefrecflnkid, fureacctno)
                          values (seq_reaflnk.nextval,rec.txdate,rec.txnum,rec.furefrecflnkid,rec.fureacctno,
                   rec.afacctno,v_currdate,rec.todate,rec.deltd,null,null,
                   rec.pstatus,rec.status,rec.refrecflnkid,rec.reacctno);

               Update reaflnk
               Set  status='C',
                    clstxdate=v_currdate
               Where autoid = rec.autoid
                    and  reacctno=rec.reacctno
                    and  afacctno=rec.afacctno
                    and   status='A';

               --Kiem tra da ton tai tk moi gioi tuong lai chua
                v_check:=0;
                Begin
                    Select count(custid) into v_check
                    From remast
                    Where status='A' and ACCTNO=rec.fureacctno;
                EXCEPTION when OTHERS then
                     v_check:=0;
                End;
                If v_check=0 then
                     INSERT INTO REMAST (ACCTNO,CUSTID,ACTYPE,STATUS,PSTATUS,
                                        LAST_CHANGE,RATECOMM,BALANCE,DAMTACR,DAMTLASTDT,
                                         IAMTACR, IAMTLASTDT,DIRECTACR,INDIRECTACR,ODFEETYPE,ODFEERATE,COMMTYPE,LASTCOMMDATE)
                     SELECT  rec.fureacctno ACCTNO ,substr(rec.fureacctno,1,10) CUSTID,substr(rec.fureacctno,11,4) ACTYPE, 'A' STATUS,'' PSTATUS,
                                         sysdate LAST_CHANGE, RATECOMM, 0 BALANCE, 0 DAMTACR, v_currdate DAMTLASTDT,
                                         0 IAMTACR , v_currdate IAMTLASTDT , 0 DIRECTACR, 0 INDIRECTACR, ODFEETYPE,ODFEERATE,COMMTYPE,v_currdate  LASTCOMMDATE
                     FROM RETYPE WHERE ACTYPE=substr(rec.fureacctno,11,4);
                End if;
         End loop;
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
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate 1');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate 2');
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
         plog.init ('TXPKS_#0391EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#0391EX;
/

