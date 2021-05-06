CREATE OR REPLACE PACKAGE txpks_#1816ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1816EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      02/03/2015     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg IN OUT tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in OUT tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/
CREATE OR REPLACE PACKAGE BODY txpks_#1816ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;


   c_custodycd        CONSTANT CHAR(2) := '88';
   c_contractchk      CONSTANT CHAR(2) := '86';
   c_usertype         CONSTANT CHAR(2) := '02';
   c_userid           CONSTANT CHAR(2) := '01';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_t0cal            CONSTANT CHAR(2) := '40';
   c_advanceline      CONSTANT CHAR(2) := '41';
   c_marginrate       CONSTANT CHAR(2) := '17';
   c_setotal          CONSTANT CHAR(2) := '18';
   c_totalloan        CONSTANT CHAR(2) := '19';
   c_pp               CONSTANT CHAR(2) := '20';
   c_t0deb            CONSTANT CHAR(2) := '43';
   c_period           CONSTANT CHAR(2) := '21';
   c_t0amtused        CONSTANT CHAR(2) := '22';
   c_t0amtpending     CONSTANT CHAR(2) := '23';
   c_toamt            CONSTANT CHAR(2) := '10';
   c_symbolamt        CONSTANT CHAR(2) := '24';
   c_source           CONSTANT CHAR(2) := '25';
   c_tlid             CONSTANT CHAR(2) := '26';
   c_rlimit           CONSTANT CHAR(2) := '12';
   c_acclimit         CONSTANT CHAR(2) := '11';
   c_custavllimit     CONSTANT CHAR(2) := '16';
   c_accused          CONSTANT CHAR(2) := '13';
   c_t0ovrq           CONSTANT CHAR(2) := '42';
   c_desc             CONSTANT CHAR(2) := '30';
   c_deal             CONSTANT CHAR(2) := '47';
FUNCTION fn_txPreAppCheck(p_txmsg IN OUT tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_marginrate2 NUMBER;
v_T0OveqRate NUMBER;
v_countFS NUMBER;
v_AMTUSED NUMBER;
v_countt0limit NUMBER;
v_countBlockUser NUMBER;
v_countDeal NUMBER;
v_countSigh NUMBER;
l_AVLALLOCATE number(20,4);
l_T0MAX number(20,4);
l_T0ALLOC number(20,4);
l_T0 number(20,4);
v_amtNeedApr NUMBER;
v_pp NUMBER;
v_advanceline NUMBER;
V_T0REAL NUMBER;
l_strNAVchiaNo number(20,4);
l_strRateNAVchiaNo number(20,4);
l_strRateNAVchiaNo1 number(20,4);
l_t0amt_all number(20,4);
l_t0amt_inday number(20,4);
l_t0amt_max number(20,4);
l_t0amt_1818    number(20,4);
l_intnmlpbl number(20,4);
v_countSymbol NUMBER;

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
     v_amtNeedApr:= p_txmsg.txfields('23').value;

    --check NAV/NO voi tham so cho phep mua CK
    SELECT to_number(varvalue) INTO l_strRateNAVchiaNo1 FROM sysvar WHERE varname = 'NAV/NO';
    IF p_txmsg.txfields('44').value < l_strRateNAVchiaNo1 THEN
        --check DS CK neu 'NAV/NO' < tham so cho phep mua CK
        IF p_txmsg.txfields('24').value = 'ALL' AND v_amtNeedApr = 0 THEN
            p_txmsg.txWarningException('-180065').value:= cspks_system.fn_get_errmsg('-180065');
            p_txmsg.txWarningException('-180065').errlev:= '1';
        ELSE
            IF p_txmsg.txfields('24').value = 'ALL' THEN
                p_err_code := '-180067';
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;

            FOR rec IN
            (
                SELECT regexp_substr(p_txmsg.txfields('24').value,'[^,;|]+',1,level) symbol FROM dual
                connect by regexp_substr(p_txmsg.txfields('24').value,'[^,;|]+',1,level) is not NULL
            )
            LOOP
                SELECT COUNT (*) INTO v_countSymbol FROM sbsecurities WHERE symbol = upper(rec.symbol);
                IF v_countSymbol = 0 THEN
                    p_err_code := '-180066';
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
            END LOOP;

        END IF;

    ELSE
        --check DS CK la ALL neu 'NAV/NO' >= tham so cho phep mua CK
        IF p_txmsg.txfields('24').value <> 'ALL' THEN
            p_err_code := '-180064';
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

    END IF;
    --end check NAV/NO

        --Kiem tra Rtt<=Rxl_bl (ty le bao lanh) hien canh bao
     SELECT  MARGINRATE  INTO   v_marginrate2
        FROM V_GETSECMARGINRATIO
        WHERE afacctno = p_txmsg.txfields('03').value;
       SELECT varvalue INTO v_T0OveqRate FROM sysvar WHERE varname ='T0OVRQRATIO' AND grname ='MARGIN';
        IF v_marginrate2 <= v_T0OveqRate THEN
            p_txmsg.txWarningException('-1001401').value:= cspks_system.fn_get_errmsg('-100140');
            p_txmsg.txWarningException('-1001401').errlev:= '1';
          END IF;
        --Ktra tk co bi force sell
        SELECT nvl(COUNT(*),0) INTO v_countFS FROM vw_mr0003 WHERE  acctno = p_txmsg.txfields('03').value;
        IF v_countFS >0 THEN
            p_err_code := '-100141';
            RETURN errnums.C_BIZ_RULE_INVALID;
          END IF;

     --Ktra du lieu moi nhat
      SELECT A.PP,A.ADVANCELINE, A.T0CAL T0REAL
             INTO   v_pp, v_advanceline, V_T0REAL
      FROM
       (  SELECT
             cf.t0loanrate,
             af.CAREBY,
             af.custid,
             af.acctno,
             se.PP,
             AF.ADVANCELINE,
             CF.T0LOANLIMIT,
             ROUND(least (nvl((ci.balance - NVL(v_getbuy.secureamt,0)) + NVL(ADV.avladvance,0) +
                v_getsec.senavamt - (NVL(ln.marginamt,0) + NVL(ln.t0amt,0)),0) * cf.t0loanrate /100,
                nvl(v_getsec.SELIQAMT2,0) )) T0CAL
        FROM
                CFMAST CF, CIMAST CI, AFMAST AF, AFTYPE AFT, LNTYPE LNT,
                (select sum(aamt) aamt,sum(depoamt) avladvance,sum(paidamt) paidamt, sum(advamt) advanceamount,afacctno from v_getAccountAvlAdvance group by afacctno) adv ,
                ( select trfacctno, trunc(sum(prinnml+prinovd+intnmlacr+intdue+intovdacr +intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd),0) marginamt,
                         trunc(sum(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd),0) t0amt,
                         trunc(sum(prinovd+intovdacr+intnmlovd+feeintovdacr+feeintnmlovd + nvl(ls.dueamt,0) + intdue + feeintdue),0) marginovdamt,
                         trunc(sum(oprinovd+ointovdacr+ointnmlovd),0) t0ovdamt
                  from lnmast ln, lntype lnt,
                       (select acctno, sum(nml) dueamt from lnschd, (select * from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') sy
                        where reftype = 'P' and overduedate = to_date(varvalue,'DD/MM/RRRR') group by acctno) ls
                  where ftype = 'AF' and ln.actype = lnt.actype
                        and ln.acctno = ls.acctno(+)
                  group by ln.trfacctno) ln ,
                  v_getbuyorderinfo v_getbuy , v_getsecmargininfo_ALL v_getsec ,V_GETSECMARGINRATIO se
                  , buf_ci_account   buf
        WHERE AF.ACCTNO = CI.ACCTNO  AND AF.CUSTID = CF.CUSTID (+)
              AND AF.ACCTNO = ADV.AFACCTNO (+)
              AND buf.afacctno=se.afacctno
              and af.acctno = v_getbuy.afacctno (+)   and af.acctno = v_getsec.afacctno (+)
              and af.acctno = ln.trfacctno (+)
              and af.acctno = buf.afacctno(+)
              and cf.contractchk = 'Y'
              and af.actype = aft.actype
              AND af.acctno=p_txmsg.txfields('03').value
              and aft.t0lntype= lnt.actype
          ) A,
          (SELECT CUSTID, SUM(ADVANCELINE) TOTALADVLINE FROM AFMAST GROUP BY CUSTID) v_t0,
          (select sum(acclimit) CUSTT0USED, af.CUSTID from useraflimit us, afmast af where af.acctno = us.acctno and
                  us.typereceive = 'T0'  group by custid) T0,
          (select sum(acclimit) AFT0USED, acctno FROM  useraflimit  us where us.typereceive = 'T0' group BY  acctno) T0af,
          (select tliduser,allocatelimmit,usedlimmit,acctlimit,t0,t0max from userlimit where tliduser = p_txmsg.txfields('01').value) urlt ,
          (select tliduser,sum(decode(typereceive,'T0',acclimit, 0)) t0acclimit,sum(decode(typereceive,'MR',acclimit, 0)) mracclimit
                  from useraflimit where typeallocate = 'Flex' and tliduser = p_txmsg.txfields('01').value
                  group by tliduser) uflt,
          tlprofiles tlp, TLGROUPS GRP

      WHERE A.CUSTID = v_t0.custid (+)
            AND A.custid = t0.custid (+)
            and a.acctno = T0af.acctno(+)
            and a.t0loanrate >=0
            and tlp.tlid = uflt.tliduser(+)
            AND tlp.tlid = urlt.tliduser(+)
            and tlp.tlid = p_txmsg.txfields('01').value
            AND a.CAREBY = GRP.GRPID AND
            GRP.GRPTYPE = '2'
            AND a.CAREBY IN (SELECT TLGRP.GRPID
            FROM TLGRPUSERS TLGRP
            WHERE TLID = p_txmsg.txfields('01').value)
            AND A.acctno=p_txmsg.txfields('03').value;

      IF abs(v_pp-to_number(p_txmsg.txfields('20').value))>0 OR abs(v_advanceline-to_number(p_txmsg.txfields('41').value))>0
        OR ABS(V_T0REAL-to_number(p_txmsg.txfields('40').value))>0  THEN
            p_err_code := '-100152';
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;


      /* SELECT  v.MARGINRATE, v.PP, af.advanceline  INTO   v_marginrate2, v_pp, v_advanceline
            FROM V_GETSECMARGINRATIO v, afmast af
            WHERE v.afacctno = p_txmsg.txfields('03').value
                  AND v.afacctno=af.acctno;
      IF abs(v_pp-to_number(p_txmsg.txfields('20').value))>0 OR abs(v_advanceline-to_number(p_txmsg.txfields('41').value))>0 THEN
            p_err_code := '-100152';
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;*/

    IF   v_amtNeedApr>0 THEN --GD can phe duyet

        --Ktra tieu khoan co deal dang cho duyet khong. Yeu cau duyet truoc khi tao deal moi
        SELECT nvl(COUNT(*), 0) INTO v_countDeal FROM olndetail oln  WHERE oln.status ='P'
               AND oln.acctno   = p_txmsg.txfields('03').value;
        IF  v_countDeal >0 THEN
           p_err_code := '-100144';
            RETURN errnums.C_BIZ_RULE_INVALID;
          END if;

       ---------------------
          --Ktra han muc con lai cap phe duyet
        ---------------------
        -- Tong Han muc da cap cua user.(A,E deal o trang thai da duoc phe duyet , da duoc duyet va dang bi vi pham)
        SELECT nvl(SUM(T0AMTPENDING),0) INTO v_AMTUSED FROM OLNDETAIl WHERE TLID = p_txmsg.txfields('26').value AND STATUS IN ('A','E') and duedate=getcurrdate;
        --Han muc con lai cua cac cap co the phe duyet
        SELECT NVL(COUNT(*),0) INTO v_countt0limit
        FROM usert0limit
          WHERE tlid =p_txmsg.txfields('26').value
          AND status ='A'
          AND period =p_txmsg.txfields('21').value
          AND t0limit - p_txmsg.txfields('23').value>=0
          AND t0limitall-v_AMTUSED- p_txmsg.txfields('23').value>=0
          ORDER BY t0limit;
        IF v_countt0limit=0 THEN
            p_err_code := '-100142';
            RETURN errnums.C_BIZ_RULE_INVALID;
          END IF;
    ELSE
        IF p_txmsg.txfields('20').value < 0 THEN
            p_err_code := '-100154';
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
    END IF;
     -------------------
     --Ktra MG tao GD
     -------------------
     --ktr MG bi treo han muc
    SELECT nvl(COUNT(*),0) INTO v_countBlockUser FROM userlimit WHERE tliduser =p_txmsg.txfields('01').value AND STATUS ='B';
    IF v_countBlockUser>0 THEN
      p_err_code := '-100143';
        RETURN errnums.C_BIZ_RULE_INVALID;
      END IF;
      --ktra MG da ky cam ket
      SELECT nvl(COUNT(*),0) INTO v_countSigh FROM tlprofiles WHERE tlid =p_txmsg.txfields('01').value AND signstatus ='Y';
      IF v_countSigh=0 THEN
         p_err_code := '-100146';
        RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
        --Ktra han muc cap toi da 1 ngay cho 1 tieu khoan
         begin
            select ul.t0max
                into  l_T0MAX
            from userlimit ul, (select tliduser,sum(decode(typereceive,'T0',acclimit, 0)) t0acclimit,sum(decode(typereceive,'MR',acclimit, 0)) mracclimit  from useraflimit where typeallocate = p_txmsg.txfields(c_usertype).value and TLIDUSER = p_txmsg.txfields(c_userid).value group by tliduser
            ) uflt
            where ul.tliduser = p_txmsg.txfields(c_userid).value and ul.usertype = p_txmsg.txfields(c_usertype).value and ul.tliduser = uflt.tliduser(+);
        exception when others then
            p_err_code := '-180030'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end;

          SELECT nvl(SUM(ACCLIMIT),0)
            into l_T0ALLOC
        FROM USERAFLIMIT L
        WHERE TYPERECEIVE='T0' AND TLIDUSER= p_txmsg.txfields(c_userid).value
        AND TYPEALLOCATE =p_txmsg.txfields(c_usertype).value and ACCTNO =p_txmsg.txfields(c_acctno).value;

        if l_T0MAX - l_T0ALLOC < to_number(p_txmsg.txfields(c_toamt).value) THEN
            p_err_code := '-100149'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
     ---------------------

    ----Check ty le NAV/No cua mon BL
    SELECT to_number(varvalue) INTO l_strRateNAVchiaNo FROM sysvar WHERE varname = 'NAV/OVD';
    IF p_txmsg.txfields('44').value <= l_strRateNAVchiaNo THEN
        p_err_code := '-180058';
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    --End check ty le NAV/No cua mon BL

    ----Check han muc BL toan cong ty
    SELECT to_number(varvalue) INTO l_t0amt_max FROM sysvar WHERE varname = 'ADVALCELINE_MAX';
    --SELECT nvl(sum(t0amt),0) INTO l_t0amt_all FROM vw_lngroup_all;
    SELECT nvl(sum(af.advanceline),0) INTO l_t0amt_inday FROM afmast af, cfmast cf
    where af.custid = cf.custid and cf.custatcom = 'Y';-- luu ky tai cong ty ;
    SELECT nvl(sum(toamt),0) INTO l_t0amt_1818 FROM olndetail WHERE duedate = getcurrdate AND status = 'P';
    --SELECT nvl(sum(intnmlpbl),0) INTO l_intnmlpbl FROM lnmast WHERE ftype <> 'DF';

    --IF l_t0amt_all + l_t0amt_inday + l_intnmlpbl + p_txmsg.txfields('10').value > l_t0amt_max THEN
    --Sua CT HM da cap trong ngay + HM cho phe duyet trong ngay + so tien cap <= HM BL toan cty
    IF l_t0amt_inday + l_t0amt_1818 + p_txmsg.txfields('10').value > l_t0amt_max THEN
        p_err_code := '-180059';
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    --End Check han muc BL toan cong ty

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

FUNCTION fn_txAftAppCheck(p_txmsg IN OUT tx.msg_rectype,p_err_code out varchar2)
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
v_amtNeedApr NUMBER ;
l_count NUMBER;
v_countSymbol NUMBER;
v_autoid NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_amtNeedApr:= p_txmsg.txfields('23').value;
      --Giam HM MG

    if p_txmsg.deltd <> 'Y' THEN
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
            --Ghi log cap han muc
            INSERT INTO USERAFLIMITLOG (TXNUM,TXDATE,ACCTNO,ACCLIMIT,TLIDUSER,TYPEALLOCATE,TYPERECEIVE)
            VALUES (p_txmsg.txnum,p_txmsg.txdate,p_txmsg.txfields(c_acctno).value,to_number(p_txmsg.txfields(c_toamt).value),
            p_txmsg.txfields(c_userid).value,p_txmsg.txfields(c_usertype).value,'T0');

        IF v_amtNeedApr =0 THEN --Bao lanh tu dong
           --Ghi GD vao OLNDetail trang thai da duyet
           v_autoid:= seq_olndetail.NEXTVAL;
           INSERT INTO OLNDetail (autoid, UserID ,ACCTNO ,T0Cal  ,ADVANCELINE , MARGINRATE , MARGINRATE2 , SETOTAL , TOTALLOAN ,PP, T0DEB , PERIOD, T0AMTUSED
                   ,T0AMTPENDING ,TOAMT, SYMBOLAMT ,SOURCE ,TLID ,RLIMIT  ,ACCLIMIT , CUSTAVLLIMIT , ACCUSED , T0OVRQ  , DESCIPTION,DUEDATE ,STATUS ,PSTATUS,NAVNO,DEAL1816)
             VALUES (v_autoid, p_txmsg.txfields('01').value, p_txmsg.txfields('03').value,p_txmsg.txfields('40').value
             ,p_txmsg.txfields('41').value,p_txmsg.txfields('17').value,p_txmsg.txfields('89').value ,p_txmsg.txfields('18').value
             ,p_txmsg.txfields('19').value,p_txmsg.txfields('20').value ,p_txmsg.txfields('43').value,p_txmsg.txfields('21').value
             ,p_txmsg.txfields('22').value,p_txmsg.txfields('23').value,p_txmsg.txfields('10').value,upper(p_txmsg.txfields('24').value)
             ,p_txmsg.txfields('25').value,p_txmsg.txfields('26').value,p_txmsg.txfields('12').value,p_txmsg.txfields('11').value
             ,p_txmsg.txfields('16').value,p_txmsg.txfields('13').value,p_txmsg.txfields('42').value,p_txmsg.txfields('30').value
             ,TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),'A','',p_txmsg.txfields('44').value,p_txmsg.txfields(c_deal).value);
           --Tang suc mua
             INSERT INTO AFTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('03').value,'0062',ROUND(p_txmsg.txfields('10').value,0),NULL,p_txmsg.txfields ('03').value,p_txmsg.deltd,p_txmsg.txfields ('03').value,seq_AFTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            UPDATE AFMAST
               SET
                 DEAL = p_txmsg.txfields(c_deal).value, -- 1.5.8.9|iss:2046
                 ADVANCELINE = ADVANCELINE + (ROUND(p_txmsg.txfields('10').value,0)), LAST_CHANGE = SYSTIMESTAMP
              WHERE ACCTNO=p_txmsg.txfields('03').value;
            INSERT INTO T0LIMITSCHD(AUTOID, TLID, TYPEALLOCATE, ACCTNO, ALLOCATEDDATE, ALLOCATEDLIMIT, RETRIEVEDLIMIT, refautoid )
              VALUES(SEQ_T0LIMITSCHD.NEXTVAL, p_txmsg.txfields(c_userid).value, p_txmsg.txfields(c_usertype).value, p_txmsg.txfields(c_acctno).value,
                p_txmsg.txdate, to_number(p_txmsg.txfields(c_toamt).value), 0,v_autoid);

            --Insert vao t_fo_event de GEN Msg sang FO
                INSERT INTO t_fo_event (AUTOID, TXNUM, TXDATE, ACCTNO, TLTXCD,LOGTIME,PROCESSTIME,PROCESS,ERRCODE,ERRMSG,NVALUE,CVALUE)
                SELECT seq_fo_event.NEXTVAL, p_txmsg.txnum, p_txmsg.txdate, p_txmsg.txfields(c_acctno).value,'1816',systimestamp,systimestamp,'N','0',NULL, NULL,p_txmsg.txfields(c_userid).value
                    FROM DUAL WHERE EXISTS (SELECT TLTXCD FROM FOTXMAP WHERE TLTXCD = '1816');

            --insert vao afserule
            IF not (p_txmsg.txfields('24').value = 'ALL' OR p_txmsg.txfields('24').value IS NULL) THEN
                FOR rec IN
                (
                    SELECT regexp_substr(p_txmsg.txfields('24').value,'[^,;|/]+',1,level) symbol FROM dual
                    connect by regexp_substr(p_txmsg.txfields('24').value,'[^,;|/]+',1,level) is not NULL
                )
                LOOP
                    --check da ton tai voi tieu tri cung ma CK, tk, loai hinh, trang thai, ngay hieu luc thi ko insert
                    SELECT COUNT (*) INTO v_countSymbol FROM afserule afse, sbsecurities sb
                    WHERE afse.refid = p_txmsg.txfields('03').value AND afse.afseruletype = 'BL'
                        AND sb.codeid = afse.codeid AND sb.symbol = upper(rec.symbol) AND afse.status = 'A' AND afse.effdate = getcurrdate;
                    IF v_countSymbol = 0 THEN
                        INSERT INTO afserule (AUTOID,BORS,TYPORMST,REFID,CODEID,FOA,TERMVAL,TERMRATIO,EFFDATE,EXPDATE,STATUS,AFSERULETYPE)
                        VALUES(seq_afserule.NEXTVAL,'B','M',p_txmsg.txfields('03').value,(SELECT codeid FROM sbsecurities WHERE symbol = upper(rec.symbol)),'F',0,0,TO_DATE(getcurrdate,'DD/MM/RRRR'),TO_DATE(getcurrdate,'DD/MM/RRRR'),'A','BL');
                    END IF;
                END LOOP;

                --log DS CK co the dc mua
                INSERT INTO afseruledetail (REFID,SYMBOL,AFSERULETYPE,MAKER,APPROVE,ACTION,TXDATE,TXTIME)
                VALUES(p_txmsg.txfields('03').value,upper(p_txmsg.txfields('24').value),'BL',p_txmsg.txfields('01').value,NULL,'GD1816',getcurrdate,to_char(SYSTIMESTAMP,'hh24:mi:ss'));
                --end log DS CK

            END IF;
            --end insert

        ELSIF v_amtNeedApr> 0 THEN --Bao lanh phe duyet
               --Ghi GD vao OLNDetail trang thai cho duyet
           INSERT INTO OLNDetail (Autoid, UserID ,ACCTNO ,T0Cal  ,ADVANCELINE , MARGINRATE , MARGINRATE2 , SETOTAL , TOTALLOAN ,PP, T0DEB , PERIOD, T0AMTUSED
                   ,T0AMTPENDING ,TOAMT, SYMBOLAMT ,SOURCE ,TLID ,RLIMIT  ,ACCLIMIT , CUSTAVLLIMIT , ACCUSED , T0OVRQ  , DESCIPTION,DUEDATE ,STATUS ,PSTATUS,NAVNO,DEAL1816)
             VALUES (seq_olndetail.NEXTVAL,p_txmsg.txfields('01').value, p_txmsg.txfields('03').value,p_txmsg.txfields('40').value
             ,p_txmsg.txfields('41').value,p_txmsg.txfields('17').value,p_txmsg.txfields('89').value ,p_txmsg.txfields('18').value
             ,p_txmsg.txfields('19').value,p_txmsg.txfields('20').value ,p_txmsg.txfields('43').value,p_txmsg.txfields('21').value
             ,p_txmsg.txfields('22').value,p_txmsg.txfields('23').value,p_txmsg.txfields('10').value,upper(p_txmsg.txfields('24').value)
             ,p_txmsg.txfields('25').value,p_txmsg.txfields('26').value,p_txmsg.txfields('12').value,p_txmsg.txfields('11').value
             ,p_txmsg.txfields('16').value,p_txmsg.txfields('13').value,p_txmsg.txfields('42').value,p_txmsg.txfields('30').value
             ,TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),'P','',p_txmsg.txfields('44').value,p_txmsg.txfields(c_deal).value);
        END IF;

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
         plog.init ('TXPKS_#1816EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1816EX;
/
