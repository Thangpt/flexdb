CREATE OR REPLACE PACKAGE txpks_#1810ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1810EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      23/12/2011     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY txpks_#1810ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_usertype         CONSTANT CHAR(2) := '02';
   c_contractchk      CONSTANT CHAR(2) := '86';
   c_userid           CONSTANT CHAR(2) := '01';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_toamt            CONSTANT CHAR(2) := '10';
   c_rlimit           CONSTANT CHAR(2) := '12';
   c_acclimit         CONSTANT CHAR(2) := '11';
   c_custavllimit     CONSTANT CHAR(2) := '16';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

l_AVLALLOCATE number(20,4);
l_T0MAX number(20,4);
l_T0ALLOC number(20,4);
l_T0 number(20,4);
l_OVAMT number(20,4);
l_count number(10);
v_T0OVRQ number(20,4);
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
        select  T0LOANLIMIT-af.advanceline
            into l_AVLALLOCATE
        from cfmast cf,
            (select  custid,  sum(advanceline) advanceline
                from afmast
                group by custid) af, afmast afc
        where afc.acctno=p_txmsg.txfields(c_acctno).value and cf.custid = af.custid and afc.custid = cf.custid;

        if l_AVLALLOCATE < to_number(p_txmsg.txfields(c_toamt).value) then
            p_err_code := '-180052'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

        begin
            select ul.t0, ul.t0max, nvl(t0acclimit,0) t0acclimit
                into l_T0, l_T0MAX, l_T0ALLOC
            from userlimit ul, (select tliduser,sum(decode(typereceive,'T0',acclimit, 0)) t0acclimit,sum(decode(typereceive,'MR',acclimit, 0)) mracclimit  from useraflimit where typeallocate = p_txmsg.txfields(c_usertype).value and TLIDUSER = p_txmsg.txfields(c_userid).value group by tliduser
            ) uflt
            where ul.tliduser = p_txmsg.txfields(c_userid).value and ul.usertype = p_txmsg.txfields(c_usertype).value and ul.tliduser = uflt.tliduser(+);
        exception when others then
            p_err_code := '-180030'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end;

        if l_T0 - l_T0ALLOC < to_number(p_txmsg.txfields(c_toamt).value) then
            p_err_code := '-180031'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

        SELECT nvl(SUM(ACCLIMIT),0)
            into l_T0ALLOC
        FROM USERAFLIMIT L
        WHERE TYPERECEIVE='T0' AND TLIDUSER= p_txmsg.txfields(c_userid).value
        AND TYPEALLOCATE =p_txmsg.txfields(c_usertype).value and ACCTNO =p_txmsg.txfields(c_acctno).value;

        if l_T0MAX - l_T0ALLOC < to_number(p_txmsg.txfields(c_toamt).value) THEN
            p_err_code := '-180032'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

        select count(1) into l_count
        from afmast af, tlgrpusers tlgrur, tlgroups tlgr
        where acctno = p_txmsg.txfields(c_acctno).value
        and af.careby = tlgrur.grpid
        and tlgrur.grpid = tlgr.grpid
        and tlgr.grptype = '2'
        and tlgrur.tlid = p_txmsg.txfields(c_userid).value;

        if l_count <= 0 then
            p_err_code := '-200211'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

        SELECT OVAMT into l_OVAMT FROM CIMAST WHERE ACCTNO =p_txmsg.txfields(c_acctno).value;
        if l_OVAMT > 1 then
           p_txmsg.ovrrqd := p_txmsg.ovrrqd || '@19';
        end if;




        select GREATEST (0,a.ADVANCELINE + TO_NUMBER(p_txmsg.txfields('10').value) - a.T0CAL)  into v_T0OVRQ from
        (
            SELECT CF.CUSTID, CF.CUSTODYCD, AF.ACCTNO,CF.FULLNAME,cf.t0loanrate, AF.ADVANCELINE, CF.MRLOANLIMIT, CF.T0LOANLIMIT,af.CAREBY, af.actype, CF.CONTRACTCHK
                ,  nvl((ci.balance - NVL(v_getbuy.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt - (NVL(ln.marginamt,0) + NVL(ln.t0amt,0)),0)
                    navamt, nvl(v_getsec.SELIQAMT,0) SELIQAMT,
                    ROUND(least (nvl((ci.balance - NVL(v_getbuy.secureamt,0)) + NVL(ADV.avladvance,0) + v_getsec.senavamt - (NVL(ln.marginamt,0) + NVL(ln.t0amt,0)),0) * cf.t0loanrate /100, nvl(v_getsec.SELIQAMT2,0) )) T0CAL
                    ,  GREATEST(0, NVL(NVL(ln.t0amt,0) - NVL(ci.balance +  NVL(v_getbuy.secureamt,0) + NVL(ADV.avladvance,0),0),0)) T0DEB
                FROM CFMAST CF, CIMAST CI, AFMAST AF,
                    (
                        select sum(aamt) aamt,sum(depoamt) avladvance,sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno
                        from v_getAccountAvlAdvance group by afacctno
                    ) adv
                    ,
                    (
                        select trfacctno, trunc(sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd),0) marginamt,
                                 trunc(sum(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd),0) t0amt,
                                 trunc(sum(prinovd+intovdacr+intnmlovd+feeintovdacr+feeintnmlovd + nvl(ls.dueamt,0) + intdue + feeintdue),0) marginovdamt,
                                 trunc(sum(oprinovd+ointovdacr+ointnmlovd),0) t0ovdamt
                        from lnmast ln, lntype lnt,
                                (select acctno, sum(nml) dueamt
                                        from lnschd, (select * from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') sy
                                        where reftype = 'P' and overduedate = to_date(varvalue,'DD/MM/RRRR')
                                        group by acctno) ls
                        where ftype = 'AF'
                                and ln.actype = lnt.actype
                                and ln.acctno = ls.acctno(+)
                        group by ln.trfacctno
                    )  ln
                    ,    v_getbuyorderinfo v_getbuy ,
                    v_getsecmargininfo_ALL v_getsec
                WHERE AF.ACCTNO = CI.ACCTNO
                    AND AF.CUSTID = CF.CUSTID (+)
                    AND AF.ACCTNO = ADV.AFACCTNO (+)
                    and af.acctno = v_getbuy.afacctno (+)
                    and af.acctno = v_getsec.afacctno (+)
                   and af.acctno = ln.trfacctno (+)
               and af.acctno = p_txmsg.txfields('03').value
        ) a;


        if to_number(p_txmsg.txfields('42').value) <> v_T0OVRQ then
            p_err_code := '-180055'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
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

FUNCTION fn_txAftAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    v_T0OVRQ VARCHAR2(100);
    l_lngErrCode number(20,0);
    l_err_param varchar2(1000);
    l_strOVRRQD varchar2(100);
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

    SELECT VARVALUE INTO v_T0OVRQ FROM SYSVAR WHERE GRNAME = 'MARGIN' AND VARNAME = 'MAXT0OVRQ';

    if TO_NUMBER(p_txmsg.txfields('42').value) >= TO_NUMBER(v_T0OVRQ) and TO_NUMBER(p_txmsg.txfields('42').value)>0 then
        l_strOVRRQD := l_strOVRRQD || errnums.OVRRQS_CHECKER_CONTROL;
        p_txmsg.ovrrqd := l_strOVRRQD;
    end if;

    If length(Trim(Replace(l_strOVRRQD, errnums.OVRRQS_CHECKER_CONTROL, ''))) > 0 And (length(p_txmsg.chkid) = 0 or p_txmsg.chkid is null) Then
        p_err_code :=errnums.C_CHECKER1_REQUIRED;
    Else
        If InStr(l_strOVRRQD, errnums.OVRRQS_CHECKER_CONTROL) > 0 And (Length(p_txmsg.offid)  = 0 or p_txmsg.offid is null) Then
            p_err_code :=errnums.C_CHECKER2_REQUIRED;
        End If;
    End If;


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
l_count number(20,0);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    if p_txmsg.deltd <> 'Y' then
        SELECT count(1) into l_count
        FROM USERAFLIMIT L
        WHERE TYPERECEIVE='T0'
        AND TLIDUSER=p_txmsg.txfields(c_userid).value
        AND TYPEALLOCATE =p_txmsg.txfields(c_usertype).value  and ACCTNO =p_txmsg.txfields(c_acctno).value;

        if l_count > 0 then
            UPDATE USERAFLIMIT
            SET ACCLIMIT=ACCLIMIT+to_number(p_txmsg.txfields(c_toamt).value)
            WHERE TYPERECEIVE='T0' AND TLIDUSER=p_txmsg.txfields(c_userid).value
            AND TYPEALLOCATE =p_txmsg.txfields(c_usertype).value and ACCTNO =p_txmsg.txfields(c_acctno).value;
        else
            INSERT INTO USERAFLIMIT (ACCTNO,ACCLIMIT,TLIDUSER,TYPEALLOCATE,TYPERECEIVE)
            VALUES (p_txmsg.txfields(c_acctno).value,to_number(p_txmsg.txfields(c_toamt).value),p_txmsg.txfields(c_userid).value,
            p_txmsg.txfields(c_usertype).value,'T0');
        end if;

        INSERT INTO USERAFLIMITLOG (TXNUM,TXDATE,ACCTNO,ACCLIMIT,TLIDUSER,TYPEALLOCATE,TYPERECEIVE)
        VALUES (p_txmsg.txnum,p_txmsg.txdate,p_txmsg.txfields(c_acctno).value,to_number(p_txmsg.txfields(c_toamt).value),
        p_txmsg.txfields(c_userid).value,p_txmsg.txfields(c_usertype).value,'T0');

        INSERT INTO T0LIMITSCHD(AUTOID, TLID, TYPEALLOCATE, ACCTNO, ALLOCATEDDATE, ALLOCATEDLIMIT, RETRIEVEDLIMIT)
        VALUES(SEQ_T0LIMITSCHD.NEXTVAL, p_txmsg.txfields(c_userid).value, p_txmsg.txfields(c_usertype).value, p_txmsg.txfields(c_acctno).value,
        p_txmsg.txdate, to_number(p_txmsg.txfields(c_toamt).value), 0);
    end if;

    update t0aflimit_import
    set status = 'C'
    where afacctno = p_txmsg.txfields(c_acctno).value;

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
         plog.init ('TXPKS_#1810EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1810EX;
/

