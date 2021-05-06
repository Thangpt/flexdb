CREATE OR REPLACE PACKAGE txpks_#8879ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8879EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      03/02/2012     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#8879ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_codeid           CONSTANT CHAR(2) := '01';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_seacctno         CONSTANT CHAR(2) := '03';
   c_afacctno2        CONSTANT CHAR(2) := '07';
   c_seacctno2        CONSTANT CHAR(2) := '08';
   c_txdate           CONSTANT CHAR(2) := '04';
   c_txnum            CONSTANT CHAR(2) := '05';
   c_orderqtty        CONSTANT CHAR(2) := '10';
   c_quoteprice       CONSTANT CHAR(2) := '11';
   c_tax              CONSTANT CHAR(2) := '14';
   c_taxamt           CONSTANT CHAR(2) := '15';
   c_parvalue         CONSTANT CHAR(2) := '12';
   c_iscorebank       CONSTANT CHAR(2) := '60';
   c_feeamt           CONSTANT CHAR(2) := '22';
   c_depolastdt       CONSTANT CHAR(2) := '32';
   c_depofeeamt       CONSTANT CHAR(2) := '17';
   c_depofeeacr       CONSTANT CHAR(2) := '16';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_caqtty number;
l_date   DATE;
l_status VARCHAR2(10);
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
    --Kiem tra so luong chung khoan quyen con lai phai lon hon so luong chung khoan quyen khi ban
    if p_txmsg.txfields('18').VALUE>0 then
        begin
            select sum(qtty-mapqtty) qtty into v_caqtty
                from sepitlog where deltd <> 'Y' and qtty-mapqtty>0
                and acctno = p_txmsg.txfields('03').VALUE;
            if v_caqtty<p_txmsg.txfields('18').VALUE then
                --Thong bao khong du CK quyen
                plog.debug(pkgctx,'l_lngErrCode: ' || '-300044');
                p_err_code := '-300044';
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        exception when others then
            --Thong bao khong du CK quyen
            plog.debug(pkgctx,'l_lngErrCode: ' || '-300044');
            p_err_code := '-300044';
            RETURN errnums.C_BIZ_RULE_INVALID;
        end;
    end if;
    SELECT vdate,status INTO l_date ,l_status
    FROM seretail
    WHERE txdate=TO_DATE( p_txmsg.txfields('04').VALUE,'DD/MM/RRRR')
    AND txnum=p_txmsg.txfields('05').VALUE;
    IF (p_txmsg.busdate < l_date ) THEN
          p_err_code := '-200406'; -- Pre-defined in DEFERROR table
          plog.setendsection (pkgctx, 'fn_txPreAppCheck');
          RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;


        if  l_status <> 'S' then
          p_err_code := -901203;
          plog.error (pkgctx, p_err_code );
          RETURN errnums.C_BIZ_RULE_INVALID;
       end if;


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
l_qtty NUMBER;
V_txdate DATE;
l_txnum VARCHAR2(20);
v_TBALDT DATE;
v_count_days NUMBER;
v_caqtty number;
v_dblPrice number;
v_parvalue number;
l_srtxdate  varchar2(10);
l_srtxnum   varchar2(10);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
    l_qtty:= p_txmsg.txfields('10').VALUE;
    V_txdate:= to_date(p_txmsg.txdate,'DD/MM/RRRR');
    l_txnum:=p_txmsg.txnum;
       v_TBALDT:= Greatest(to_date ( p_txmsg.txfields('32').value,'DD/MM/RRRR')+1, p_txmsg.busdate);

   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    l_srtxdate := substr(p_txmsg.txfields('06').VALUE,1,10);
    l_srtxnum := substr(p_txmsg.txfields('06').VALUE,11);
    IF p_txmsg.deltd <> 'Y' THEN
        UPDATE SERETAIL SET
            STATUS  = 'I',
            SDATE   = p_txmsg.busdate,
            taxamt  = p_txmsg.txfields('14').VALUE,
            PITAMT  = p_txmsg.txfields('19').VALUE
        WHERE TXDATE = to_date(l_srtxdate,'dd/mm/yyyy') AND txnum = l_srtxnum;
        --TO_DATE( p_txmsg.txfields('04').VALUE,'DD/MM/RRRR') AND (TXNUM) = p_txmsg.txfields('05').VALUE;
         -- log them mot dong cong don trong sedepobal
         IF ( p_txmsg.txfields('16').VALUE > 0 ) THEN
             INSERT INTO SEDEPOBAL (AUTOID, ACCTNO, TXDATE, DAYS, QTTY, DELTD,ID)
             VALUES (SEQ_SEDEPOBAL.NEXTVAL, p_txmsg.txfields('08').value,v_TBALDT,v_count_days, p_txmsg.txfields('10').value, 'N',to_char(v_txdate)||l_txnum);
         END IF;
         -- ghi nhan them mot dong phi LK den han
            IF ( p_txmsg.txfields('17').VALUE > 0 ) THEN
               IF cspks_ciproc.fn_FeeDepoMaturityBackdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
               RETURN errnums.C_BIZ_RULE_INVALID;
               END IF;
             END IF;
         --End of PhuongHT edit
         --Cap nhat phan bo cho chung khoan quyen
         v_caqtty:=p_txmsg.txfields('18').VALUE;

            SELECT PARVALUE INTO v_parvalue from sbsecurities where codeid=p_txmsg.txfields('01').VALUE;
            v_dblPrice:= p_txmsg.txfields('11').VALUE;

            if v_dblPrice<v_parvalue then
                v_parvalue:=v_dblPrice;
            end if;

         for rec in(
             select * from sepitlog where deltd <> 'Y' and qtty-mapqtty>0
             and acctno =p_txmsg.txfields('03').VALUE
             order by txdate, autoid
         )
         loop
             if v_caqtty > rec.qtty-rec.mapqtty then
                 update sepitlog set mapqtty = mapqtty + rec.qtty - rec.mapqtty where autoid = rec.autoid;
                 v_caqtty :=v_caqtty -rec.qtty+rec.mapqtty;

                 INSERT INTO SEPITALLOCATE (CAMASTID,AFACCTNO,CODEID,PITRATE,QTTY,PRICE,ARIGHT,ORGORDERID,TXNUM,TXDATE,CARATE,SEPITLOG_ID) VALUES(
                         rec.CAMASTID, rec.AFACCTNO, rec.CODEID, rec.PITRATE, rec.qtty - rec.mapqtty , v_parvalue, (rec.qtty - rec.mapqtty) * rec.CARATE * v_parvalue * rec.PITRATE/100,
                         /*p_txmsg.txfields('04').VALUE || p_txmsg.txfields('05').VALUE*/ p_txmsg.txfields('06').VALUE ,l_txnum,V_txdate,rec.CARATE,rec.AUTOID);
             else
                 update sepitlog set mapqtty = mapqtty + v_caqtty where autoid = rec.autoid;

                 INSERT INTO SEPITALLOCATE (CAMASTID,AFACCTNO,CODEID,PITRATE,QTTY,PRICE,ARIGHT,ORGORDERID,TXNUM,TXDATE,CARATE,SEPITLOG_ID) VALUES(
                         rec.CAMASTID, rec.AFACCTNO, rec.CODEID, rec.PITRATE, v_caqtty , v_parvalue, v_caqtty * rec.CARATE * v_parvalue * rec.PITRATE/100,
                         /*p_txmsg.txfields('04').VALUE || p_txmsg.txfields('05').VALUE*/ p_txmsg.txfields('06').VALUE , l_txnum,V_txdate,rec.CARATE,rec.AUTOID);
                 v_caqtty:=0;
             end if;
             exit when v_caqtty <=0;
         end loop;

       ELSE -- xoa jao dich
            UPDATE SERETAIL SET STATUS='S'    WHERE TXDATE = TO_DATE( p_txmsg.txfields('04').VALUE,'DD/MM/RRRR') AND TRIM(TXNUM) = p_txmsg.txfields('05').VALUE;

            IF ( p_txmsg.txfields('16').VALUE > 0 ) THEN
                UPDATE sedepobal SET deltd='Y' WHERE id=to_char(V_txdate)||l_txnum ;
            END IF;
            -- ghi nhan them mot dong phi LK den han
            IF ( p_txmsg.txfields('17').VALUE > 0 ) THEN
                IF cspks_ciproc.fn_FeeDepoMaturityBackdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
                     RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
            END IF;

            for rec in(
             select * from sepitlog where deltd <> 'Y' and mapqtty>0
                 and acctno =p_txmsg.txfields('03').VALUE
                 and autoid in (select SEPITLOG_ID from SEPITALLOCATE where txdate =V_txdate and txnum = l_txnum)
                 order by txdate desc, autoid desc
             )
             loop
                 if v_caqtty >rec.mapqtty then
                     update sepitlog set mapqtty = mapqtty - rec.mapqtty where autoid = rec.autoid;
                     v_caqtty :=v_caqtty -rec.mapqtty;
                 else
                     update sepitlog set mapqtty = mapqtty - v_caqtty where autoid = rec.autoid;
                     v_caqtty:=0;
                 end if;
                 exit when v_caqtty<=0;
             end loop;

             delete from SEPITALLOCATE where txdate =V_txdate and txnum = l_txnum;
       END IF;



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
         plog.init ('TXPKS_#8879EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8879EX;
/

