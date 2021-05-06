CREATE OR REPLACE PACKAGE txpks_#1153ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1153EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      05/05/2010     Created
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
CREATE OR REPLACE PACKAGE BODY txpks_#1153ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_ismortage        CONSTANT CHAR(2) := '60';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_bankid           CONSTANT CHAR(2) := '05';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_duedate          CONSTANT CHAR(2) := '09';
   c_ordate           CONSTANT CHAR(2) := '08';
   c_amt              CONSTANT CHAR(2) := '10';
   c_maxamt           CONSTANT CHAR(2) := '20';
   c_days             CONSTANT CHAR(2) := '13';
   c_intrate          CONSTANT CHAR(2) := '12';
   c_feeamt           CONSTANT CHAR(2) := '11';
   c_bnkrate          CONSTANT CHAR(2) := '15';
   c_bnkfeeamt        CONSTANT CHAR(2) := '14';
   c_cmpminbal        CONSTANT CHAR(2) := '16';
   c_bnkminbal        CONSTANT CHAR(2) := '17';
   c_desc             CONSTANT CHAR(2) := '30';
   c_100              CONSTANT CHAR(2) := '40';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_cimastcheck_arr txpks_check.cimastcheck_arrtype;
l_baldefovd apprules.field%TYPE;
v_maxAvlAdv number;
v_count NUMBER; 
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
    /*if p_txmsg.deltd = 'Y' then
        --Kiem tra neu khong co tien thi khong cho xoa giao dich UT
        --10--94**10
        l_CIMASTcheck_arr := txpks_check.fn_CIMASTcheck(p_txmsg.txfields('03').value,'CIMAST','ACCTNO');
        l_BALDEFOVD := l_CIMASTcheck_arr(0).BALDEFOVD;
        IF NOT (to_number(l_BALDEFOVD) >= to_number(p_txmsg.txfields('10').value-p_txmsg.txfields('10').value*p_txmsg.txfields('94').value)) THEN
            p_err_code := '-400110';
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
    end if;*/
    -- begin 1.5.3.6|iss1871
    SELECT COUNT(*) INTO v_count FROM afmast 
           WHERE acctno =p_txmsg.txfields('03').value AND corebank ='Y' AND bankname LIKE 'BIDV%'; 
    IF v_count>0 THEN 
         p_err_code := '-670101';
         plog.setendsection (pkgctx, 'fn_txPreAppCheck');
         RETURN errnums.C_BIZ_RULE_INVALID;
    END IF; 
    -- end 1.5.6.3|iss1871
    if p_txmsg.deltd <> 'Y' then
      -- Check so am
     If (p_txmsg.txfields('10').value < 0 or p_txmsg.txfields('11').value < 0 or p_txmsg.txfields('60').value < 0  ) then
         p_err_code := '-100810';
         plog.setendsection (pkgctx, 'fn_txPreAppCheck');
         RETURN errnums.C_BIZ_RULE_INVALID;
     End if;
    -- End check so am

       begin
         SELECT GREATEST(MAXAVLAMT-ROUND(DEALPAID,0),0) MAXAVLAMT INTO v_maxAvlAdv
         FROM (
             SELECT VW.CUSTODYCD, VW.CUSTID, VW.FULLNAME, VW.ACCTNO, VW.AUTOADV, VW.ACTYPE, VW.TRFBANK, VW.COREBANK,
             VW.BANKACCT, VW.BANKCODE, VW.CLEARDATE, VW.TXDATE, VW.CURRDATE, VW.MAXAVLAMT, VW.EXECAMT, VW.AMT,
             VW.AAMT, VW.PAIDAMT, VW.PAIDFEEAMT, VW.BRKFEEAMT, VW.RIGHTTAX, VW.INCOMETAXAMT, VW.DAYS,
             (CASE WHEN VW.TXDATE =TO_DATE(SYS.VARVALUE,'DD/MM/RRRR') AND ISVSD='N' THEN fn_getdealgrppaid(VW.ACCTNO) ELSE 0 END)/
             (1-ADT.ADVRATE/100/360*VW.days) DEALPAID,CF.IDCODE, CF.IDTYPE, CF.IDDATE, CF.IDPLACE, CF.ADDRESS, ISVSD
             FROM VW_ADVANCESCHEDULE VW, SYSVAR SYS,AFMAST AF, AFTYPE AFT ,ADTYPE ADT,CFMAST CF
             WHERE SYS.GRNAME='SYSTEM' AND SYS.VARNAME ='CURRDATE'
             AND VW.ACCTNO = AF.ACCTNo AND AF.ACTYPE=AFT.ACTYPE AND AFT.ADTYPE=ADT.ACTYPE
           AND CF.CUSTID = AF.CUSTID
         ) WHERE ACCTNO=p_txmsg.txfields('03').value
             and CLEARDATE=TO_DATE(p_txmsg.txfields('08').value,'DD/MM/RRRR')
             and TXDATE=TO_DATE(p_txmsg.txfields('42').value,'DD/MM/RRRR')
             and (CASE WHEN ISVSD = 'N' THEN 0 ELSE 1 END)=p_txmsg.txfields('60').value ;
       exception when others then
            v_maxAvlAdv:=0;
       end;
       if v_maxAvlAdv< to_number(p_txmsg.txfields('10').value) then
          --Thong bao vuot qua so tien ung truoc
          p_err_code := '-400200';
          plog.error (pkgctx, p_err_code || dbms_utility.format_error_backtrace);
          plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
          RETURN errnums.C_BIZ_RULE_INVALID;
       end if;
       plog.error (pkgctx, 'v_maxAvlAdv:' || v_maxAvlAdv);
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
l_cimastcheck_arr txpks_check.cimastcheck_arrtype;
l_baldefovd apprules.field%TYPE;
l_mblock apprules.field%TYPE;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    if p_txmsg.deltd = 'Y' then
        --Kiem tra neu khong co tien thi khong cho xoa giao dich UT
        l_CIMASTcheck_arr := txpks_check.fn_CIMASTcheck(p_txmsg.txfields('03').value,'CIMAST','ACCTNO');

        if p_txmsg.txfields('60').value = 0 then -- Ung  truoc thuong`
            --10--94**10
            l_BALDEFOVD := l_CIMASTcheck_arr(0).BALDEFOVD;
            IF NOT (to_number(l_BALDEFOVD) >= to_number(p_txmsg.txfields('10').value-p_txmsg.txfields('10').value*p_txmsg.txfields('94').value)) THEN
                p_err_code := '-400110';
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        else    -- Ung  truoc cam co VSD
            l_mblock := l_CIMASTcheck_arr(0).MBLOCK;
            if l_mblock < p_txmsg.txfields('10').value then
                p_err_code := '-400110';
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        end if;

    end if;
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
--l_cimastcheck_arr txpks_check.cimastcheck_arrtype;
--l_baldefovd apprules.field%TYPE;
l_adtype varchar2(10);
l_Oldadtype varchar2(10);
l_reqid number;
l_status char(1);
l_count number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    if p_txmsg.deltd = 'Y' then
        --Kiem tra neu khong co tien thi khong cho xoa giao dich UT
        --10--94**10
        /*l_CIMASTcheck_arr := txpks_check.fn_CIMASTcheck(p_txmsg.txfields('03').value,'CIMAST','ACCTNO');
        l_BALDEFOVD := l_CIMASTcheck_arr(0).BALDEFOVD;
        IF NOT (to_number(l_BALDEFOVD) >= to_number(p_txmsg.txfields('10').value-p_txmsg.txfields('10').value*p_txmsg.txfields('94').value)) THEN
            p_err_code := '-400110';
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;*/

        --Kiem tra neu lam giao dich 1178 roi thi khong cho xoa
        select nvl(cvalue,'NULL') into l_adtype from tllogfld
        where txnum= p_txmsg.txnum and txdate = p_txmsg.txdate and fldcd ='06';
        select nvl(adtype,'NULL') into l_Oldadtype from adschd where txnum= p_txmsg.txnum and txdate = p_txmsg.txdate;
        if l_Oldadtype <> l_adtype then
            --Nguon ung truoc da bi doi.
            p_err_code := '-400209';
            plog.error (pkgctx, p_err_code || dbms_utility.format_error_backtrace);
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
    end if;
    IF cspks_ciproc.fn_DayAdvancedPayment(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
       RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    --Kiem tra neu la tai khoan corebank thi thuc hien goi giao dich gen bang ke sang ngan hang.
    if to_number(p_txmsg.txfields('94').value)=1 then
        if p_txmsg.deltd = 'Y' then
            --Kiem tra chi cho xoa khi chua gom bang ke
            begin
                select reqid, status into l_reqid, l_status from crbtxreq where refcode = p_txmsg.txnum and  txdate =p_txmsg.txdate;
                if l_status <> 'P' THEN
                    --Thong bao giao dich khong duoc xoa
                    p_err_code := '-400214';
                    plog.error (pkgctx, p_err_code || dbms_utility.format_error_backtrace);
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                else
                    --Neu co phat sinh trong crbtrflogdtl thi khong cho phep xoa
                    select count(1) into l_count from crbtrflogdtl where refreqid =l_reqid;
                    if l_count>0 then
                        --Thong bao khong cho xoa
                        p_err_code := '-400214';
                        plog.error (pkgctx, p_err_code || dbms_utility.format_error_backtrace);
                        plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    else
                        --Xu ly xoa
                        delete from crbtxreq where refcode = p_txmsg.txnum and  txdate =p_txmsg.txdate;
                    end if;
                end if;
            exception when others then
                --Thong bao giao dich khong duoc xoa
                p_err_code := '-400214';
                plog.error (pkgctx, p_err_code || dbms_utility.format_error_backtrace);
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end;
        else
             cspks_rmproc.pr_CreateAdvTransferTransact(p_txmsg,p_err_code);
             if p_err_code <> '0' then
                 plog.error (pkgctx, p_err_code || dbms_utility.format_error_backtrace);
                 plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                 RETURN errnums.C_BIZ_RULE_INVALID;
             end if;
        end if;
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
         plog.init ('TXPKS_#1153EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1153EX;
/
