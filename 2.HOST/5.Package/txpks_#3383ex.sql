CREATE OR REPLACE PACKAGE txpks_#3383ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3383EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      04/01/2012     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY txpks_#3383ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '06';
   c_issuermember     CONSTANT CHAR(2) := '40';
   c_codeid           CONSTANT CHAR(2) := '01';
   c_symbol           CONSTANT CHAR(2) := '35';
   c_custodycd        CONSTANT CHAR(2) := '36';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_iddate           CONSTANT CHAR(2) := '93';
   c_issname          CONSTANT CHAR(2) := '38';
   c_idplace          CONSTANT CHAR(2) := '94';
   c_country          CONSTANT CHAR(2) := '80';
   c_toacctno         CONSTANT CHAR(2) := '07';
   c_tranto           CONSTANT CHAR(2) := '04';
   c_custname2        CONSTANT CHAR(2) := '95';
   c_license2         CONSTANT CHAR(2) := '97';
   c_address2         CONSTANT CHAR(2) := '96';
   c_iddate2          CONSTANT CHAR(2) := '98';
   c_idplace2         CONSTANT CHAR(2) := '99';
   c_country2         CONSTANT CHAR(2) := '81';
   c_amt              CONSTANT CHAR(2) := '21';
   c_ramt             CONSTANT CHAR(2) := '23';
   c_mamt             CONSTANT CHAR(2) := '22';
   c_trflimit         CONSTANT CHAR(2) := '31';
   c_tradeplace       CONSTANT CHAR(2) := '37';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_leader_license varchar2(100);
    l_leader_idexpired date;
    l_member_license varchar2(100);
    l_member_idexpired date;
    l_idexpdays apprules.field%TYPE;
    l_afmastcheck_arr txpks_check.afmastcheck_arrtype;
    l_leader_expired boolean;
    l_member_expired boolean;
    l_count number;
    l_trflimit varchar2(100);
    v_country VARCHAR2(5);
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
    if p_txmsg.deltd <> 'Y' then
        l_leader_expired:= false;
        l_member_expired:= false;

        BEGIN
        select idcode, idexpired,country into l_leader_license, l_leader_idexpired, v_country
        from cfmast cf, afmast af
        where cf.custid = af.custid
        and af.acctno = p_txmsg.txfields(c_afacctno).value;
        EXCEPTION
        WHEN OTHERS
        THEN
              p_err_code := '-900096';
              plog.setendsection (pkgctx, 'fn_txPreAppCheck');
              RETURN errnums.C_BIZ_RULE_INVALID;
       END ;

        if(v_country='234') THEN
        BEGIN
        select idcode, idexpired into l_member_license, l_member_idexpired
        from cfmast where idcode = p_txmsg.txfields(c_license).value AND status <> 'C';

        EXCEPTION
        WHEN OTHERS
        THEN
              p_err_code := '-900096';
              plog.setendsection (pkgctx, 'fn_txPreAppCheck');
              RETURN errnums.C_BIZ_RULE_INVALID;
       END ;

         IF l_leader_idexpired < p_txmsg.txdate THEN --leader expired
            l_leader_expired:=true;
        END IF;

        if l_leader_license <> l_member_license or l_leader_idexpired <> l_member_idexpired then
            if l_member_idexpired < p_txmsg.txdate then
                l_member_expired:=true;
            end if;
        end if;


        if l_leader_expired = true and l_member_expired = true then
            p_txmsg.txWarningException('-2002091').value:= cspks_system.fn_get_errmsg('-200209');
            p_txmsg.txWarningException('-2002091').errlev:= '1';
        else
            if l_leader_expired = true and l_member_expired = false then
                p_txmsg.txWarningException('-2002081').value:= cspks_system.fn_get_errmsg('-200208');
                p_txmsg.txWarningException('-2002081').errlev:= '1';
            elsif l_leader_expired = false and l_member_expired = true then
                p_txmsg.txWarningException('-2002071').value:= cspks_system.fn_get_errmsg('-200207');
                p_txmsg.txWarningException('-2002071').errlev:= '1';
            end if;

          END IF;

       end if;
        -------
        select TRFLIMIT into l_trflimit from CAMAST WHERE CAMASTID= p_txmsg.txfields(c_camastid).value;

        if l_trflimit = 'Y' then
            SELECT count(1)
                into l_count
            FROM CASCHD
            WHERE CAMASTID=p_txmsg.txfields(c_camastid).value
                AND AFACCTNO =p_txmsg.txfields(c_afacctno).value
                and to_number(p_txmsg.txfields(c_amt).value) > (pbalance-inbalance)
                and deltd <>'Y'
                AND autoid=p_txmsg.txfields('09').value;
            if l_count > 0 then
                p_err_code := '-300021'; -- Pre-defined in DEFERROR table
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else
            p_err_code := '-300019'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
        --
        SELECT count(1) into l_count FROM CAMAST WHERE CAMASTID= p_txmsg.txfields(c_camastid).value and catype = '014';
        if l_count <= 0 then
            p_err_code := '-300019'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
        --
         SELECT COUNT(1)
            into l_count
        FROM CAMAST CA, SYSVAR SYS
        WHERE SYS.VARNAME = 'CURRDATE' AND SYS.GRNAME = 'SYSTEM' AND CATYPE = '014'
        AND TO_DATE (VARVALUE,'DD/MM/RRRR') >= FRDATETRANSFER AND camastid = p_txmsg.txfields(c_camastid).value;
        if l_count <= 0 then
            p_err_code := '-300029'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
        --
        SELECT COUNT(1)
            into l_count
        FROM CAMAST CA, SYSVAR SYS
        WHERE SYS.VARNAME = 'CURRDATE' AND SYS.GRNAME = 'SYSTEM' AND CATYPE = '014'
        AND TO_DATE (VARVALUE,'DD/MM/RRRR') <= TODATETRANSFER
        AND camastid = p_txmsg.txfields(c_camastid).value;
        if l_count <= 0 then
            p_err_code := '-300031'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
    else
        null;
    end if;
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
    l_qtty number(20,4);
    l_left_rightoffrate varchar2(30);
    l_right_rightoffrate varchar2(30);
    l_roundtype number(20,4);
    l_exprice number(20,4);
    l_transfertimes number(20,4);
    l_retailbal number(20,4);
    l_optcodeid varchar2(100);
    l_count number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    l_qtty:= to_number(p_txmsg.txfields(c_amt).value);
    SELECT      substr(rightoffrate,1,instr(rightoffrate,'/')-1),
           substr(rightoffrate,instr(rightoffrate,'/') + 1,length(rightoffrate)),
           roundtype, TRANSFERTIMES, OPTCODEID, exprice
    INTO    l_left_rightoffrate, l_right_rightoffrate, l_roundtype, l_transfertimes, l_optcodeid, l_exprice
    from camast where camastid = p_txmsg.txfields(c_camastid).value and deltd <> 'Y';



    if p_txmsg.deltd <> 'Y' then

       plog.debug (pkgctx, '<<BEGIN 1');

        UPDATE CASCHD
        SET PBALANCE = PBALANCE - l_qtty, OUTBALANCE = OUTBALANCE +l_qtty ,
            PQTTY = TRUNC( FLOOR(( (PBALANCE - l_qtty) * l_right_rightoffrate) / l_left_rightoffrate)  ,l_roundtype) ,
            PAAMT= l_exprice *  TRUNC( FLOOR(( ( PBALANCE - l_qtty ) * l_right_rightoffrate ) / l_left_rightoffrate ) ,l_roundtype ),
            RETAILBAL =  RETAILBAL -  l_qtty
        WHERE AFACCTNO =p_txmsg.txfields(c_afacctno).value AND camastid = p_txmsg.txfields(c_camastid).value and  deltd <> 'Y'
        AND autoid=p_txmsg.txfields('09').value;

        -- insert mot dong vao CATRANSFER.
        -- su dung them trang thai P,C de phan biet voi jao dich lam qua 3382 (N,Y)
        plog.debug (pkgctx, '<<BEGIN 2');

         INSERT INTO catransfer (AUTOID,TXDATE,TXNUM,CAMASTID,OPTSEACCTNOCR,OPTSEACCTNODR,CODEID,OPTCODEID,AMT,STATUS,INAMT,retailbal,sendINAMT,SENDRETAILBAL,
          TOACCTNO,TOMEMCUS,COUNTRY2,CUSTNAME2,ADDRESS2,LICENSE2,IDDATE2,IDPLACE2,CASCHDID)
        VALUES(seq_catransfer.nextval, p_txmsg.txdate,p_txmsg.txnum,p_txmsg.txfields(c_camastid).value,
         '',p_txmsg.txfields(c_afacctno).value  || l_optcodeid,
         p_txmsg.txfields(c_codeid).value ,l_optcodeid, l_qtty,'P',0,0,0,0,
         p_txmsg.txfields('07').value,p_txmsg.txfields('08').value,p_txmsg.txfields('81').value,
         p_txmsg.txfields('95').value,p_txmsg.txfields('96').value,p_txmsg.txfields('97').value,
         TO_DATE(p_txmsg.txfields('98').value,'DD/MM/RRRR'),p_txmsg.txfields('99').value,p_txmsg.txfields('09').value);
		plog.debug (pkgctx, '<<BEGIN 3');

    ELSE
        NULL;
        --bo phan hach toan khi huy giao dich do khi o trang tai cho duyet gd chua hach toan nen khi huy bi hach toan nguoc sai
/*        UPDATE CASCHD
        SET PBALANCE = PBALANCE + l_qtty ,OUTBALANCE = OUTBALANCE - l_qtty  ,
            PQTTY = TRUNC( FLOOR(( (PBALANCE +  l_qtty ) * l_right_rightoffrate) / l_left_rightoffrate )  , l_roundtype ) ,
            PAAMT=  l_exprice * TRUNC(  FLOOR(( ( PBALANCE + l_qtty ) * l_right_rightoffrate ) / l_left_rightoffrate )  , l_roundtype)
            , RETAILBAL =  RETAILBAL +  l_qtty
        WHERE AFACCTNO =p_txmsg.txfields(c_afacctno).value AND camastid = p_txmsg.txfields(c_camastid).value and  deltd <> 'Y'
         AND autoid=p_txmsg.txfields('09').value;
*/
    end if;

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
         plog.init ('TXPKS_#3383EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3383EX;
/

