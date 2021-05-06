CREATE OR REPLACE PACKAGE txpks_#2200ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2200EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      21/10/2011     Created
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
CREATE OR REPLACE PACKAGE BODY txpks_#2200ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_codeid           CONSTANT CHAR(2) := '01';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_licensedate      CONSTANT CHAR(2) := '95';
   c_license          CONSTANT CHAR(2) := '92';
   c_licenseplace     CONSTANT CHAR(2) := '96';
   c_tamt             CONSTANT CHAR(2) := '08';
   c_amt              CONSTANT CHAR(2) := '10';
   c_parvalue         CONSTANT CHAR(2) := '11';
   c_price            CONSTANT CHAR(2) := '09';
   c_custid           CONSTANT CHAR(2) := '05';
   c_fullnameauth     CONSTANT CHAR(2) := '16';
   c_iddateauth       CONSTANT CHAR(2) := '19';
   c_idcodeauth       CONSTANT CHAR(2) := '17';
   c_idplaceauth      CONSTANT CHAR(2) := '18';
   c_custodycd        CONSTANT CHAR(2) := '04';
   c_securitiesname   CONSTANT CHAR(2) := '12';
   c_phone            CONSTANT CHAR(2) := '93';
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
    l_leader_expired:= false;
    l_member_expired:= false;

    select idcode, idexpired into l_leader_license, l_leader_idexpired
    from cfmast cf, afmast af
    where cf.custid = af.custid
    and af.acctno = p_txmsg.txfields(c_afacctno).value;

    select idcode, idexpired into l_member_license, l_member_idexpired
    from cfmast where idcode = p_txmsg.txfields(c_license).value and status <> 'C';

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
    l_Count number;
    l_RefTxnum VARCHAR2(20);
    l_baldefovd apprules.field%TYPE;
    l_cimastcheck_arr txpks_check.cimastcheck_arrtype;
    l_afacctno varchar2(10);
    --1.8.2.5: thue quyen
    v_custid VARCHAR2(10);
    v_caqtty NUMBER;
    v_count NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_RefTxnum := to_char(p_txmsg.busdate, systemnums.C_DATE_FORMAT) || p_txmsg.txnum;
    --1.8.2.5: check tai khoan fo va modefo
    SELECT custid INTO v_custid FROM afmast WHERE acctno = p_txmsg.txfields('02').value;
    v_caqtty:= p_txmsg.txfields('15').value;

    If p_txmsg.deltd <> 'Y' THEN
        Begin
            SELECT Count(1) Into l_Count FROM SEWITHDRAWDTL WHERE TXDATETXNUM= l_RefTxnum;
            EXCEPTION When Others Then l_Count := 0;
        END;
        If l_Count <> 0 Then
            UPDATE SEWITHDRAWDTL SET WITHDRAW = p_txmsg.txfields('10').value, STATUS = 'P' WHERE TXDATETXNUM= l_RefTxnum;
        Else
            INSERT INTO SEWITHDRAWDTL (TXDATE, ACCTNO, CODEID, AFACCTNO, STATUS, PRICE, WITHDRAW, DELTD, TXNUM, TXDATETXNUM)
            VALUES (TO_DATE(p_txmsg.busdate, systemnums.C_DATE_FORMAT),
                    p_txmsg.txfields('03').value,
                    p_txmsg.txfields('01').value,
                    p_txmsg.txfields('02').value, 'P',
                    p_txmsg.txfields('09').value,
                    p_txmsg.txfields('10').value, 'N',
                    p_txmsg.txnum, l_RefTxnum);
        End If;

        --1.8.2.5: thue quyen
        IF v_caqtty >0 THEN
            FOR rec IN (SELECT * FROM (
                            SELECT se.*,NVL(ca.catype,se.catype) cacatype, decode(af.acctno,p_txmsg.txfields('02').value,0,1) lord FROM sepitlog se, afmast af, camast ca
                            WHERE se.afacctno = af.acctno
                              AND se.camastid = ca.camastid (+)
                              AND af.custid = v_custid
                              AND se.codeid = p_txmsg.txfields('01').value
                              AND se.deltd <> 'Y'
                              AND se.qtty - se.mapqtty >0)
                            ORDER BY lord, txdate, pitrate DESC
            )
            LOOP
                IF v_caqtty > rec.qtty - rec.mapqtty THEN

                    UPDATE sepitlog SET mapqtty = mapqtty + rec.qtty - rec.mapqtty WHERE autoid = rec.autoid;

                    INSERT INTO SEPITALLOCATE (Camastid,Afacctno,Codeid,Price,Pitrate,Qtty,Aright,Orgorderid,Txnum,Txdate,Carate,Sepitlog_Id,Catype)
                     VALUES (rec.camastid,rec.afacctno,rec.codeid,rec.price,rec.pitrate,rec.qtty-rec.mapqtty,0,to_char(p_txmsg.txdate,'DD/MM/RRRR')||p_txmsg.txnum,p_txmsg.txnum,p_txmsg.txdate,rec.carate, rec.autoid, rec.cacatype);

                    v_caqtty:=v_caqtty-(rec.qtty-rec.mapqtty);
                ELSE

                    UPDATE sepitlog SET mapqtty = mapqtty + v_caqtty, status ='C' WHERE autoid = rec.autoid;

                    INSERT INTO SEPITALLOCATE (Camastid,Afacctno,Codeid,Price,Pitrate,Qtty,Aright,Orgorderid,Txnum,Txdate,Carate,Sepitlog_Id,Catype)
                     VALUES (rec.camastid,rec.afacctno,rec.codeid,rec.price,rec.pitrate,v_caqtty,0,to_char(p_txmsg.txdate,'DD/MM/RRRR')||p_txmsg.txnum,p_txmsg.txnum,p_txmsg.txdate,rec.carate, rec.autoid, rec.cacatype);

                    v_caqtty:=0;
                END IF;
                EXIT WHEN v_caqtty<=0;
            END LOOP;
          END IF;
          --
    Else
      /*Add by ManhTV, check balance tai khoan ban co du tien hoan lai ko*/
      l_afacctno := p_txmsg.txfields('02').value;
      If txpks_check.fn_aftxmapcheck(l_afacctno,'CIMAST','02','8894')<>'TRUE' then
         p_err_code := errnums.C_SA_TLTX_NOT_ALLOW_BY_ACCTNO;
         plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
         RETURN errnums.C_BIZ_RULE_INVALID;
      End if;

      l_CIMASTcheck_arr := txpks_check.fn_CIMASTcheck(l_afacctno,'CIMAST','ACCTNO');
      l_BALDEFOVD := l_CIMASTcheck_arr(0).BALDEFOVD;
      plog.debug(pkgctx, 'l_BALDEFOVD := ' || l_BALDEFOVD);
      IF NOT (to_number(l_BALDEFOVD) >= to_number(p_txmsg.txfields('22').value)) THEN
         p_err_code := '-400110';
         plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
         RETURN errnums.C_BIZ_RULE_INVALID;
      END IF;
      /*End Add*/
        Begin
            SELECT Count(1) Into l_Count FROM SEWITHDRAWDTL WHERE TXDATETXNUM= l_RefTxnum;
            EXCEPTION When Others Then l_Count := 0;
        END;
        If l_Count <> 0 Then
            UPDATE SEWITHDRAWDTL SET DELTD='Y' WHERE STATUS = 'C' AND DELTD = 'N' AND TXDATETXNUM = l_RefTxnum;
        End If;
        --1.8.2.5: thue quyen
        IF v_caqtty >0 THEN
         FOR rec IN (
            SELECT * FROM SEPITALLOCATE WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate
        )
        LOOP
             SELECT COUNT(1) INTO v_count FROM sepitlog WHERE deltd<> 'Y' AND afacctno=rec.afacctno AND codeid=rec.codeid AND autoid = rec.sepitlog_id;
                  IF v_count > 0 THEN
                    UPDATE sepitlog set mapqtty = mapqtty - rec.qtty ,
                          status=(case when status='C' then 'N' else status end)
                          where autoid = rec.sepitlog_id;
                  ELSE
                    SELECT COUNT(1) INTO v_count FROM SEMAST WHERE ACCTNO=rec.afacctno||rec.codeid AND TRADE >0;
                    IF v_count > 0 THEN
                      INSERT INTO sepitlog ( autoid,acctno,txdate,txnum,qtty,mapqtty,codeid,camastid,afacctno,price,pitrate,catype,modifieddate)
                      SELECT seq_sepitlog.nextval,rec.afacctno||rec.codeid,rec.txdate,rec.txnum,rec.qtty,0,
                      rec.codeid, rec.camastid,rec.afacctno,price,pitrate,catype,p_txmsg.txdate
                      FROM sepitlog WHERE autoid = rec.sepitlog_id;
                    ELSE
                      INSERT INTO sepitlog ( autoid,acctno,txdate,txnum,qtty,mapqtty,codeid,camastid,afacctno,price,pitrate,catype,modifieddate)
                      SELECT seq_sepitlog.nextval,p_txmsg.txfields('03').value,p_txmsg.txdate,p_txmsg.txnum,rec.qtty,0,
                      p_txmsg.txfields('01').value, rec.camastid,p_txmsg.txfields('02').value,price,pitrate,catype,p_txmsg.txdate
                      FROM sepitlog WHERE autoid = rec.sepitlog_id;
                    END IF;
                    
                  END IF;
        END LOOP;
        DELETE SEPITALLOCATE WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate;
       END IF;
    End If;
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
         plog.init ('TXPKS_#2200EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2200EX;
/
