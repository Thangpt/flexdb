CREATE OR REPLACE PACKAGE txpks_#3342ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3342EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      11/10/2011     Created
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
CREATE OR REPLACE PACKAGE BODY txpks_#3342ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '03';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_catype           CONSTANT CHAR(2) := '05';
   c_actiondate       CONSTANT CHAR(2) := '07';
   c_contents         CONSTANT CHAR(2) := '13';
   c_desc             CONSTANT CHAR(2) := '30';
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
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppCheck;

FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
-- 1.6.1.3 check them dk lam gd 3342
    l_catype VARCHAR2(3);
    l_codeid VARCHAR2(6);
    v_count  NUMBER;
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
    SELECT ca.catype, ca.codeid
    INTO l_Catype ,l_codeid from camast ca
    WHERE camastid = p_txmsg.txfields('03').value;
    if(l_Catype = '028') then
     select count(*) into v_count
     from sbsecurities 
     where codeid = l_codeid and sectype = '011' 
           and EXERCISERATIO is not null
           and instr(EXERCISERATIO, '/') >0;
       IF(v_count = 0) THEN
            p_err_code := '-300071';
            plog.setEndSection(pkgctx,'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
       END IF;
        SELECT count(*) into v_count
        from camast ca
        WHERE camastid = p_txmsg.txfields('03').value and pitrate is not null and  EXPRICE is not null;
        IF(v_count = 0) THEN
            p_err_code := '-300071';
            plog.setEndSection(pkgctx,'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
       END IF;
    end if;
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
    l_err_param varchar2(500);
    v_countCI number;
    v_countSE number;
    l_catype VARCHAR2(3);
    l_codeid VARCHAR2(6);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    --cspks_caproc.pr_exec_money_cop_action(p_txmsg.txfields('03').value,p_err_code);
    SELECT ca.catype, ca.codeid
    INTO l_Catype ,l_codeid from camast ca
    WHERE camastid = p_txmsg.txfields('03').value;
    if p_txmsg.deltd<>'Y' then
        cspks_caproc.pr_3350_Exec_Money_CA(p_txmsg,p_err_code);
        if p_err_code <> systemnums.C_SUCCESS THEN
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
        --Kiem tra neu lam xong thi chuyen trang thai cua su kien quyen
        SELECT count(1) into v_countCI FROM CASCHD
         WHERE  CAMASTID=p_txmsg.txfields('03').value  AND DELTD ='N'
         AND amt> 0 AND ISCI='N' AND isexec='Y';
        -- kiem tra xem co tai khoan nao chua dc phan bo CK khong
         SELECT count(1) into v_countSE FROM CASCHD
         WHERE  CAMASTID=p_txmsg.txfields('03').value  AND DELTD ='N'
         AND (qtty > 0 or aqtty >0) AND ISSE='N' AND isexec='Y';
         -- update trang thai trong CAMAST
         if(v_countCI = 0 AND v_countSE = 0) THEN
         UPDATE CAMAST SET STATUS ='J'
         WHERE CAMASTID=p_txmsg.txfields('03').value;
         ELSIF (v_countCI= 0 AND v_countSE > 0) THEN
         UPDATE CAMAST SET STATUS ='G'
         WHERE CAMASTID=p_txmsg.txfields('03').value;
         END IF;
            -- NEU LA TRA GOC LAI TRAI PHIEU: UPDATE SEMAST CUA CAC TK SE ko duoc phan bo = 0
         IF(L_CATYPE ='016') THEN
         FOR rec IN (SELECT se.acctno,se.trade
                     FROM semast se
                     WHERE codeid= l_codeid AND trade >0
                     AND afacctno NOT IN
                           (SELECT afacctno from caschd WHERE deltd='N' AND camastid=p_txmsg.txfields('03').value)
                     )
         LOOP
           INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
           VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.acctno,'0011',rec.trade,NULL,p_txmsg.txfields ('03').value,p_txmsg.deltd,NULL,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

           UPDATE semast SET trade=0 WHERE acctno=rec.acctno;

         END LOOP;

         END IF;
       plog.debug (pkgctx, 'Begin processing 4 fo txnum'||p_txmsg.txnum);
       plog.debug (pkgctx, 'Begin processing 4 fo txdate'||p_txmsg.txdate);
            -- Begin processing 4 fo
       IF pck_newfo.fn_syn_info_2_fo(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
            plog.debug (pkgctx, 'Error '||p_err_code);
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
       END IF;
       plog.debug (pkgctx, 'Dua vao su kien de xu ly:');
       --Dua vao su kien de xu ly:
       INSERT INTO t_fo_event (autoid,
                                txnum,
                                txdate,
                                acctno,
                                tltxcd,
                                logtime,
                                processtime,
                                process,
                                errcode,
                                errmsg)
                VALUES (seq_fo_event.NEXTVAL,
                        p_txmsg.txnum,
                        TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                        '',
                        p_txmsg.tltxcd,
                        systimestamp,
                        '',
                        'N',
                        '',
                        '');
       -- End processing 4 fo

    ELSE
        for rec in
        (
            select * from tllog where reftxnum =p_txmsg.txnum
        )
        loop
            if rec.tltxcd = '3350' then
                if txpks_#3350.fn_txrevert(rec.txnum,to_char(rec.txdate,'dd/mm/rrrr'),p_err_code,l_err_param) <> 0 then
                    plog.error (pkgctx, 'Loi khi thuc hien xoa giao dich');
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    return errnums.C_SYSTEM_ERROR;
                end if;
            ELSIF rec.tltxcd = '3354' then
                if txpks_#3354.fn_txrevert(rec.txnum,to_char(rec.txdate,'dd/mm/rrrr'),p_err_code,l_err_param) <> 0 then
                    plog.error (pkgctx, 'Loi khi thuc hien xoa giao dich');
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    return errnums.C_SYSTEM_ERROR;
                end if;
            end if ;
        end loop;

        SELECT count(1) into v_countCI FROM CASCHD
         WHERE  CAMASTID=p_txmsg.txfields('03').value  AND DELTD ='N'
         AND  ISCI='N' AND isexec='Y';
        -- kiem tra xem co tai khoan nao chua dc phan bo CK khong
         SELECT count(1) into v_countSE FROM CASCHD
         WHERE  CAMASTID=p_txmsg.txfields('03').value  AND DELTD ='N'
         AND  ISSE='N' AND isexec='Y';
         -- update trang thai trong CAMAST
         if(v_countCI > 0 AND v_countSE > 0) THEN
         UPDATE CAMAST SET STATUS ='I'
         WHERE CAMASTID=p_txmsg.txfields('03').value;
         ELSIF (v_countCI> 0 AND v_countSE = 0) THEN
         UPDATE CAMAST SET STATUS ='H'
         WHERE CAMASTID=p_txmsg.txfields('03').value;
         ELSIF (v_countCI= 0 AND v_countSE > 0) THEN
         UPDATE CAMAST SET STATUS ='G'
         WHERE CAMASTID=p_txmsg.txfields('03').value;
         END IF;
           -- revert lai doi voi cac TK ko duoc chia co tuc cua su kien tra goc lai trai phieu
         IF(L_CATYPE ='016') THEN
         FOR  rec IN
         (SELECT acctno,namt from setran WHERE deltd='N' AND TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)) LOOP

              UPDATE semast SET trade=trade+rec.namt WHERE acctno=rec.acctno;

         END LOOP;

         -- xoa trong setran
         UPDATE SETRAN        SET DELTD = 'Y'
         WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
         END IF;
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
         plog.init ('TXPKS_#3342EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3342EX;
/
