CREATE OR REPLACE PACKAGE txpks_#0090ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0090EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      25/06/2012     Created
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
CREATE OR REPLACE PACKAGE BODY txpks_#0090ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custid           CONSTANT CHAR(2) := '03';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_username         CONSTANT CHAR(2) := '05';
   c_loginpwd         CONSTANT CHAR(2) := '10';
   c_ismaster         CONSTANT CHAR(2) := '14';
   c_authtype         CONSTANT CHAR(2) := '11';
   c_tradingpwd       CONSTANT CHAR(2) := '12';
   c_days             CONSTANT CHAR(2) := '13';
   c_email            CONSTANT CHAR(2) := '06';
   c_tokenid          CONSTANT CHAR(2) := '15';
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
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppCheck;

FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_custid varchar2(20);
    l_custodycd varchar2(20);
    l_username varchar2(100);
    l_username_old varchar2(100);
    l_cfstatus varchar2(10);
    l_afstatus varchar2(10);
    l_tradeonline varchar2(10);
    l_rightcount varchar2(10);
    l_currdate varchar2(10);
    l_count number(20,0);
    l_havecustodycd number;
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAftAppCheck');
   plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppCheck>>');


   l_custid := p_txmsg.txfields(c_custid).value;
   l_username := upper(p_txmsg.txfields(c_username).value);
   l_custodycd := upper(p_txmsg.txfields(c_custodycd).value);

   --Kiem tra xem user nay da cap cho thang nao khac chua
   SELECT NVL(COUNT(*),0) INTO l_count FROM CFMAST WHERE USERNAME=l_username AND CUSTID<>l_custid;
   IF l_count>0 THEN
    BEGIN
        p_err_code := errnums.C_CF_USERNAME_DUPLICATE;
        RETURN errnums.C_BIZ_RULE_INVALID;
    END;
   END IF;
   --Kiem tra trang thai tieu khoan khach hang (AF) la hoat dong, truong TRADEONLINE cua AFMAST = Y
   --Co quyen con hieu luc trong bang OTRIGHT
   l_count:=3;
   select nvl(count(custodycd),0) into l_havecustodycd from cfmast where custid = l_custid;
    FOR rec IN (
            SELECT AF.STATUS,AF.TRADEONLINE,NVL(OT.AFACCTNO,'N/A') OTAFACCTNO
            FROM AFMAST AF, ( select af.acctno AFACCTNO  from otright o , afmast af
                  where o.authcustid = o.cfcustid and o.via ='A'
                  AND o.deltd = 'N'
                  AND O.VALDATE<= getcurrdate
                 AND O.EXPDATE>= getcurrdate
                  AND o.AUTHCUSTID = l_custid) OT
            WHERE AF.ACCTNO=OT.AFACCTNO (+)
            AND AF.TRADEONLINE='Y' AND AF.CUSTID=l_custid
        ) LOOP
           plog.debug (pkgctx, 'afstatus : ' || rec.STATUS || ' , tradeonline : ' || rec.TRADEONLINE || ' , otacctno : ' || rec.OTAFACCTNO);

                IF rec.STATUS <> 'A' THEN
                    l_count:=1;
                ELSIF rec.TRADEONLINE <> 'Y' THEN
                    l_count:=2;
                ELSIF rec.OTAFACCTNO = 'N/A' THEN
                    l_count:=3;
                ELSE
                    l_count:=0;
                END IF;

                IF l_count=0 THEN
                    EXIT;
                END IF;

        END LOOP;
   IF l_count=1 THEN
        p_err_code:=errnums.C_CF_AFMAST_STATUS_INVALIDE;
        RETURN errnums.C_BIZ_RULE_INVALID;
   ELSIF l_count=2 THEN
        p_err_code:=errnums.C_CF_AFMAST_NOTSIGNONLINE;
        RETURN errnums.C_BIZ_RULE_INVALID;
   ELSIF l_count=3 THEN
        p_err_code:=errnums.C_CF_ONLINENOTHAVERIGHT;
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;
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
--1.5.3.0: chinh sua de sinh dung thong tin
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_custid varchar2(10);
    l_username varchar2(50);
    l_userpass varchar2(50);
    l_authtype varchar2(10);
    l_tradingpass varchar2(50);
    l_tradingpass_send_email varchar2(50);
    l_tradingpass_send varchar2(50);
    l_days varchar2(10);
    l_email varchar2(250);
    l_ismaster varchar2(10);
    l_tokenid varchar2(100);
    l_oldusername varchar2(50);
    l_fullname varchar2(250);
    l_custodycode varchar2(50);
    l_templateid varchar2(50);
    l_datasourcesql varchar2(3000);
    l_count number(20,0);
    l_timechange  varchar2(400);
    l_mobile varchar(20);
    l_datasourcesms varchar2(3000);
    l_sex varchar2(3000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');

    l_count:=0;

    l_custid := p_txmsg.txfields(c_custid).value;
    l_username := upper(p_txmsg.txfields(c_username).value);
    l_userpass := p_txmsg.txfields(c_loginpwd).value;
    l_tradingpass := p_txmsg.txfields(c_tradingpwd).value;
    l_days := p_txmsg.txfields(c_days).value;
    l_authtype := p_txmsg.txfields(c_authtype).value;
    l_email := p_txmsg.txfields(c_email).value;
    l_ismaster := p_txmsg.txfields(c_ismaster).value;
    l_tokenid := p_txmsg.txfields(c_tokenid).value;
    l_timechange:= p_txmsg.txtime ||' ' || TO_CHAR( p_txmsg.txdate,'dd/MM/YYYY');
    l_mobile:=SUBSTR(l_tokenid,
                              instr(l_tokenid, '{', 1, 3) + 1,
                              instr(l_tokenid, '}', 1, 1) -
                              instr(l_tokenid, '{', 1, 3) - 1);
    BEGIN
        SELECT USERNAME, FULLNAME, CUSTODYCD, decode( CFMAST.sex,'001','Ông','002','Bà')
        INTO l_oldusername,l_fullname,l_custodycode,l_sex
        FROM CFMAST WHERE CUSTID = l_custid;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        p_err_code:=errnums.C_CF_CUSTOM_NOTFOUND;
        return errnums.C_CF_CUSTOM_NOTFOUND;
    END;

    IF l_username<>l_oldusername THEN
        BEGIN
            DELETE FROM USERLOGIN WHERE USERNAME = l_username;
        END;
    END IF;
    --1.5.3.0
       select count(*) into l_count
       from otright o
       where  o.cfcustid = o.authcustid  and o.deltd ='N' and o.via ='A' and o.authtype = '0'
          and cfcustid =  l_custid;
       if(l_count = 1) then
	   --1.5.8.2: MSBS-1963
        l_tradingpass_send := ' - Mat khau dat lenh: ' || l_tradingpass;
        l_tradingpass_send_email := 'Mật khẩu đặt lệnh (PIN): '|| l_tradingpass;
       else
        l_tradingpass_send:= '';
        l_tradingpass_send_email := '';
       end if;

    SELECT NVL(COUNT(*),0) INTO l_count FROM USERLOGIN WHERE USERNAME=l_username;
    IF l_count>0 THEN
        BEGIN
            l_templateid:='0213';
            UPDATE USERLOGIN SET ISRESET = 'Y', ISMASTER = l_ismaster,
            TOKENID = l_tokenid, LASTCHANGED=SYSDATE, NUMBEROFDAY=l_days, LOGINPWD=GENENCRYPTPASSWORD(UPPER(l_userpass)),
            AUTHTYPE=l_authtype,TRADINGPWD=GENENCRYPTPASSWORD(UPPER(l_tradingpass)) WHERE UPPER(USERNAME)=l_username;

              l_datasourcesql:='select ''' || l_username || ''' username, ''' || l_userpass || ''' loginpwd, ''' || l_tradingpass_send_email || ''' tradingpwd, ''' || l_fullname || ''' fullname, ''' || l_custodycode || ''' custodycode,'''|| l_timechange || ''' timechange,'''|| l_sex || ''' sex from dual';
        END;
    ELSE
        BEGIN
            l_templateid:='0212';

            INSERT INTO USERLOGIN (USERNAME, LOGINPWD, AUTHTYPE, TRADINGPWD, STATUS,
                            LASTLOGIN, LOGINSTATUS, LASTCHANGED, NUMBEROFDAY, ISMASTER, ISRESET, TOKENID, EXPDATE)
            SELECT l_username,GENENCRYPTPASSWORD(UPPER(l_userpass)),l_authtype,GENENCRYPTPASSWORD(UPPER(l_tradingpass)),
            'A',SYSDATE,'O',SYSDATE,l_days,l_ismaster,'Y',l_tokenid, getcurrdate FROM DUAL;

            UPDATE CFMAST SET USERNAME =l_username WHERE CUSTID = l_custid;
             l_datasourcesql:='select ''' || l_username || ''' username, ''' || l_userpass || ''' loginpwd, ''' || l_tradingpass_send_email || ''' tradingpwd, ''' || l_fullname || ''' fullname, '''|| l_sex || ''' sex, '''
            || l_custodycode || ''' custodycode, rights  from vw_email_otrightdtl where authcustid =' ||l_custid ;

        END;
    END IF;
    If length(l_mobile)>0 then

       l_datasourcesms:='select ''' || l_username || ''' username, ''' || l_userpass || ''' loginpwd, ''' || l_tradingpass_send || ''' tradingpwd from dual';
        nmpks_ems.InsertEmailLog(l_mobile, '328B', l_datasourcesms, '');
    end if;

    INSERT INTO emaillog (autoid, email, templateid, datasource, status, createtime)
                VALUES(seq_emaillog.nextval,l_email,l_templateid,l_datasourcesql,'A', SYSDATE);

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
         plog.init ('TXPKS_#0090EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#0090EX;
/
