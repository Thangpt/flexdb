CREATE OR REPLACE PACKAGE txpks_#0027ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0027EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      03/07/2014     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in OUT TX.MSG_RECTYPE,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY txpks_#0027ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_afacctno         CONSTANT CHAR(2) := '03';
   c_fullname         CONSTANT CHAR(2) := '95';
   c_actype           CONSTANT CHAR(2) := '15';
   c_old_poolchk      CONSTANT CHAR(2) := '16';
   c_new_poolchk      CONSTANT CHAR(2) := '17';
   c_poollimit        CONSTANT CHAR(2) := '18';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in OUT TX.MSG_RECTYPE,p_err_code out varchar2)
RETURN NUMBER
IS
L_OLDPOOLCHK CHAR(1);
L_NEWPOOLCHK CHAR(1);
L_CHKSYS CHar(1);
L_COUNT NUMBER;
L_AFACCTNO        VARCHAR2(10);
L_LNTYPE          VARCHAR2(10);
L_VALUE           NUMBER;
L_AFUSED          NUMBER;
L_NEWPOOLLIMIT    NUMBER;
L_OLDPOOLLIMIT    NUMBER;
L_USED_INDAY      NUMBER;
L_USED            NUMBER;
L_USED_CHKSYS     NUMBER;
L_ALL_CHKSYS      NUMBER;
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
    L_OLDPOOLCHK:=p_txmsg.txfields('16').value;
    L_NEWPOOLCHK:=p_txmsg.txfields('17').value;
    L_AFACCTNO:=p_txmsg.txfields('03').value;
    L_NEWPOOLLIMIT:= p_txmsg.txfields('19').value;
    L_OLDPOOLLIMIT:= p_txmsg.txfields('18').value;
    L_VALUE:=0;
    L_USED:=0;
    L_USED_CHKSYS:=0;
     -- check xem tieu khoan co phai hoan toan tuan thu khong
    select COUNT(*) INTO L_COUNT from (
        select lnt.*
            from afmast af, aftype aft, afidtype afid, lntype LNT
            where aft.actype = afid.aftype
                and afid.actype = lnt.actype
                and af.actype = AFT.ACTYPE
                AND AF.ACCTNO=L_AFACCTNO
                and objname = 'LN.LNTYPE' and lnt.status <> 'N'
                ANd LNT.CHKSYSCTRL='N'
        union all
        select lnt.*
            from afmast af, aftype aft, lntype LNT
            where af.actype = AFT.ACTYPE
                and af.acctno = L_AFACCTNO
                and aft.lntype = lnt.actype and lnt.status <> 'N'
                AND LNT.CHKSYSCTRL='N'
                );
     IF L_COUNT>0 THEN
        L_ALL_CHKSYS:=0;
     ELSE
        L_ALL_CHKSYS:=1;
     END IF;

     -- So luong pool su dung trong ngay
    SELECT -least(nvl(adv.avladvance,0)
                      + mst.balance
                      - MST.ODAMT
                      - mst.dfdebtamt
                      - mst.dfintdebtamt
                      - NVL (advamt, 0)
                      - nvl(secureamt,0)
                      - ramt
                      - mst.depofeeamt
                        ,0)
           -NVL(LN.AMT,0)
     INTO L_USED_INDAY
     from cimast mst
          left join (select * from v_getbuyorderinfo where afacctno = L_AFACCTNO) al on mst.acctno = al.afacctno
          left join (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance where afacctno = L_AFACCTNO group by afacctno) adv on adv.afacctno=MST.ACCTNO
          left join (select SUM(PRINNML+PRINOVD+OPRINNML+OPRINOVD+
              intnmlacr+intnmlovd+intdue+intovdacr+fee+feeovd+feedue+feeintnmlacr+feeintnmlovd+feeintdue+FEEINTOVDACR
              +OINTNMLACR+OINTNMLOVD+OINTOVDACR+OINTDUE) AMT,TRFACCTNO  from LNMAST where TRFACCTNO = L_AFACCTNO group by TRFACCTNO ) LN on mst.acctno = LN.TRFACCTNO
          where mst.acctno = L_AFACCTNO;
    -- chuyen tu khong check pool sang check pool
    IF L_OLDPOOLCHK='N' AND L_NEWPOOLCHK='Y' THEN
         FOR REC IN (SELECT SUM(nvl(PRINNML+PRINOVD+OPRINNML+OPRINOVD,0)) AMT, nvl(ln.ACTYPE,lnt.actype) ACTYPE
                   FROm LNMAST ln,afmast af , aftype aft, lntype lnt
                   WHERE af.acctno = ln.TRFACCTNO(+) and  af.acctno=L_AFACCTNO
                   and af.actype = aft.actype and aft.lntype = lnt.actype
                   GROUP BY nvl(ln.ACTYPE,lnt.actype))
         LOOP
          L_LNTYPE:=REC.ACTYPE;
          L_VALUE:=REC.AMT;
          --Danh dau pool
          --Neu Tieu khoan khong danh dau bat buoc tuan thu he thong hoac ko phai lai tieu khoan margin
          -- -> Khong can hach toan nguon SYSTEM.
          SELECT LNT.CHKSYSCTRL INTO L_CHKSYS
          FROM LNTYPE LNT WHERE ACTYPE=REC.ACTYPE;
          L_USED:=L_USED+L_VALUE;
          IF L_CHKSYS='Y' AND L_ALL_CHKSYS=1 THEN
             L_USED_CHKSYS:=L_USED_CHKSYS+L_VALUE;
          END IF;
          FOR REC2 IN (
                      SELECT DISTINCT pm.prcode, pm.prname, pm.prtyp, pm.codeid, pm.prlimit,
                      pm.prinused, pm.expireddt, pm.prstatus,
                      (CASE WHEN PRT.TYPE='SYSTEM' THEN 1 ELSE 0 END ) PRS,
                      (CASE WHEN PRT.TYPE='SYSTEM' THEN 0 ELSE 1 END ) NOTPRS
                      FROM prmaster pm, prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm,AFMAST af
                      WHERE pm.prcode = brm.prcode
                      AND pm.prcode = prtm.prcode
                      AND prt.actype = prtm.prtype
                      AND prt.actype = TPM.PRTYPE
                      AND AF.ACCTNO=L_AFACCTNO
                      AND pm.prtyp = 'P'
                      AND (prt.TYPE = 'AFTYPE'
                      or (prt.type = 'SYSTEM' and L_CHKSYS = 'Y'))
                      AND pm.prstatus = 'A'
                      AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,AF.Actype)
                      AND brm.brid = decode(brm.brid,'ALL',brm.brid,AF.BRID)
                       )
                LOOP
                      SELECT COUNT(*) INTO L_COUNT FROM PRMASTER PR WHERE PR.PRCODE= REC2.PRCODE
                      AND PR.PRLIMIT-PR.PRINUSED>=REC2.NOTPRS*L_USED+REC2.PRS*L_USED_CHKSYS+L_USED_INDAY;

                      IF L_COUNT=0 THEN
                            p_err_code := '-100612';
                            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                            RETURN errnums.C_BIZ_RULE_INVALID;
                      END IF;
                END LOOP;
           END LOOP;
     ELSIF  (/*L_OLDPOOLCHK='Y' AND*/ L_NEWPOOLCHK='N') THEN -- check pool con lai cua rieng tieu khoan
            SELECT COUNT(*) INTO L_COUNT FROM LNMAST
            WHERE TRFACCTNO=L_AFACCTNO;
            IF L_COUNT>0 THEN
                SELECT SUM(PRINNML+PRINOVD+OPRINNML+OPRINOVD)
                INTO L_AFUSED
                FROM LNMAST
                WHERE TRFACCTNO=L_AFACCTNO;
                IF L_NEWPOOLLIMIT < L_AFUSED + L_USED_INDAY THEN
                    p_err_code := '-100613';
                    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
            else
                IF L_NEWPOOLLIMIT < L_USED_INDAY THEN
                    p_err_code := '-100613';
                    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
            END IF;
     END IF;

    IF NVL(L_OLDPOOLCHK,'A') = NVL(L_NEWPOOLCHK,'A') THEN
      /*  p_err_code := '-100611';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;*/
        p_txmsg.txWarningException('-1006111').value:= cspks_system.fn_get_errmsg('-100611');
        p_txmsg.txWarningException('-1006111').errlev:= '1';
    END IF;
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
L_OLDPOOLCHK CHAR(1);
L_NEWPOOLCHK CHAR(1);
L_CHKSYS CHar(1);
L_COUNT NUMBER;
L_AFACCTNO        VARCHAR2(10);
L_LNTYPE          VARCHAR2(10);
L_VALUE           NUMBER;
L_NEWPOOLLIMIT    NUMBER;
L_OLDPOOLLIMIT    NUMBER;
L_USED_INDAY   NUMBER;
L_ALL_CHKSYS   NUMBER;
v_action varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    L_OLDPOOLCHK:=p_txmsg.txfields('16').value;
    L_NEWPOOLCHK:=p_txmsg.txfields('17').value;
    L_AFACCTNO:=p_txmsg.txfields('03').value;
    L_NEWPOOLLIMIT:= p_txmsg.txfields('19').value;
    L_OLDPOOLLIMIT:= p_txmsg.txfields('18').value;
    -- check xem tieu khoan co phai hoan toan tuan thu khong
    select COUNT(*) INTO L_COUNT from (
        select lnt.*
            from afmast af, aftype aft, afidtype afid, lntype LNT
            where aft.actype = afid.aftype
                and afid.actype = lnt.actype
                and af.actype = AFT.ACTYPE
                AND AF.ACCTNO=L_AFACCTNO
                and objname = 'LN.LNTYPE' and lnt.status <> 'N'
                ANd LNT.CHKSYSCTRL='N'
        union all
        select lnt.*
            from afmast af, aftype aft, lntype LNT
            where af.actype = AFT.ACTYPE
                and af.acctno = L_AFACCTNO
                and aft.lntype = lnt.actype and lnt.status <> 'N'
                AND LNT.CHKSYSCTRL='N'
                );
     IF L_COUNT>0 THEN
        L_ALL_CHKSYS:=0;
     ELSE
        L_ALL_CHKSYS:=1;
     END IF;
     IF P_TXMSG.DELTD <> 'Y' THEN-- chieu xuoi giao dich
      FOR REC IN (SELECT * FROM (
               SELECT SUM(PRINNML+PRINOVD+OPRINNML+OPRINOVD) AMT, ACTYPE
               FROm LNMAST WHERE TRFACCTNO=L_AFACCTNO
               GROUP BY ACTYPE
               ) WHERE AMT >0)
       LOOP
        L_LNTYPE:=REC.ACTYPE;
        L_VALUE:=REC.AMT;
        --Danh dau pool
        --Neu Tieu khoan khong danh dau bat buoc tuan thu he thong hoac ko phai lai tieu khoan margin
        -- -> Khong can hach toan nguon SYSTEM.
        SELECT LNT.CHKSYSCTRL INTO L_CHKSYS
        FROM LNTYPE LNT WHERE ACTYPE=REC.ACTYPE;
        FOR REC2 IN (
                    SELECT DISTINCT pm.prcode, pm.prname, pm.prtyp, pm.codeid, pm.prlimit,
                    pm.prinused, pm.expireddt, pm.prstatus
                    FROM prmaster pm, prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm,AFMAST af
                    WHERE pm.prcode = brm.prcode
                    AND pm.prcode = prtm.prcode
                    AND prt.actype = prtm.prtype
                    AND prt.actype = TPM.PRTYPE
                    AND AF.ACCTNO=L_AFACCTNO
                    AND pm.prtyp = 'P'
                    AND (prt.TYPE = 'AFTYPE'
                    or (prt.type = 'SYSTEM' and L_CHKSYS = 'Y'))
                    AND pm.prstatus = 'A'
                    AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,AF.Actype)
                    AND brm.brid = decode(brm.brid,'ALL',brm.brid,AF.BRID)
                     )
              LOOP
                 IF L_OLDPOOLCHK='Y' AND L_NEWPOOLCHK='N' THEN -- chuyen tu check pool sang khong check pool
                     UPDATE PRMASTER SET PRINUSED=NVL(PRINUSED,0)- l_value WHERE PRCODE= REC2.PRCODE;
                     INSERT INTO PRTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                     VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),REC2.PRCODE,'0003',l_value,NULL,p_txmsg.deltd,'',seq_PRTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || p_txmsg.txdesc || '');
                 ELSIF L_OLDPOOLCHK='N' AND L_NEWPOOLCHK='Y' THEN
                     UPDATE PRMASTER SET PRINUSED=NVL(PRINUSED,0)+ l_value WHERE PRCODE= REC2.PRCODE;
                     INSERT INTO PRTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                     VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),REC2.PRCODE,'0004',l_value,NULL,p_txmsg.deltd,'',seq_PRTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || p_txmsg.txdesc || '');
                 END IF;
              END LOOP;

       END LOOP;

         -- So luong pool su dung trong ngay
       -- So luong pool su dung trong ngay
        SELECT -least(nvl(adv.avladvance,0)
                          + mst.balance
                          - MST.ODAMT
                          - mst.dfdebtamt
                          - mst.dfintdebtamt
                          - NVL (advamt, 0)
                          - nvl(secureamt,0)
                          - ramt
                          - mst.depofeeamt
                            ,0)
               -NVL(LN.AMT,0)
         INTO L_USED_INDAY
         from cimast mst
              left join (select * from v_getbuyorderinfo where afacctno = L_AFACCTNO) al on mst.acctno = al.afacctno
              left join (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance where afacctno = L_AFACCTNO group by afacctno) adv on adv.afacctno=MST.ACCTNO
              left join (select SUM(PRINNML+PRINOVD+OPRINNML+OPRINOVD+
              intnmlacr+intnmlovd+intdue+intovdacr+fee+feeovd+feedue+feeintnmlacr+feeintnmlovd+feeintdue+FEEINTOVDACR
              +OINTNMLACR+OINTNMLOVD+OINTOVDACR+OINTDUE) AMT,
              TRFACCTNO from LNMAST where TRFACCTNO = L_AFACCTNO  group by TRFACCTNO) LN on mst.acctno = LN.TRFACCTNO
              where mst.acctno = L_AFACCTNO;
        IF L_USED_INDAY>0 THEN

               IF L_OLDPOOLCHK='N' AND L_NEWPOOLCHK='Y' THEN-- chuyen tu khong check sang co check
                   -- xu ly cho phan lenh dat trong ngay
                   DELETE afprinusedlog where afacctno = L_AFACCTNO;
                   -- ghi (+) trong bang prinusedlog
                    /* p_err_code:=txpks_prchk.fn_SecuredUpdate('D',L_USED_INDAY),
                              L_AFACCTNO, P_TXMSG.TXNUM, P_TXMSG.txdate, p_err_code);
                     IF P_ERR_CODE <> systemnums.c_success THEN
                         plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                         RETURN errnums.C_BIZ_RULE_INVALID;
                     END IF;     */
                     FOR REC IN (
                            SELECT DISTINCT pm.prcode, pm.prname, pm.prtyp, pm.codeid, pm.prlimit,
                            pm.prinused, pm.expireddt, pm.prstatus,
                            (CASE WHEN prt.type = 'SYSTEM' THEN 1 ELSE 0 END ) CHKSYS
                            FROM prmaster pm, prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm,AFMAST af
                            WHERE pm.prcode = brm.prcode
                            AND pm.prcode = prtm.prcode
                            AND prt.actype = prtm.prtype
                            AND prt.actype = TPM.PRTYPE
                            AND AF.ACCTNO=L_AFACCTNO
                            AND pm.prtyp = 'P'
                            AND (prt.TYPE = 'AFTYPE'
                            or (prt.type = 'SYSTEM' and L_CHKSYS = 'Y'))
                            AND pm.prstatus = 'A'
                            AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,AF.Actype)
                            AND brm.brid = decode(brm.brid,'ALL',brm.brid,AF.BRID)
                             )
                     LOOP
                         IF NOT (REC.CHKSYS=1 AND L_ALL_CHKSYS=0 ) THEN
                            insert into prinusedlog (prcode,prinused,deltd,last_change,autoid,txnum,txdate)
                            values(REC.prcode, L_USED_INDAY, 'N', SYSTIMESTAMP, seq_prinusedlog.nextval, P_TXMSG.txnum,P_TXMSG.TXDATE );
                         END IF;
                     END LOOP;

               ELSIF L_OLDPOOLCHK='Y' AND L_NEWPOOLCHK='N' THEN-- chuyen tu co check sang khong check
                     -- xu ly cho phan lenh dat trong ngay
                     DELETE afprinusedlog where afacctno = L_AFACCTNO;
                          -- ghi (-) trong bang prinusedlog
                     FOR REC IN (
                            SELECT DISTINCT pm.prcode, pm.prname, pm.prtyp, pm.codeid, pm.prlimit,
                            pm.prinused, pm.expireddt, pm.prstatus,
                            (CASE WHEN prt.type = 'SYSTEM' THEN 1 ELSE 0 END ) CHKSYS
                            FROM prmaster pm, prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm,AFMAST af
                            WHERE pm.prcode = brm.prcode
                            AND pm.prcode = prtm.prcode
                            AND prt.actype = prtm.prtype
                            AND prt.actype = TPM.PRTYPE
                            AND AF.ACCTNO=L_AFACCTNO
                            AND pm.prtyp = 'P'
                            AND (prt.TYPE = 'AFTYPE'
                            or (prt.type = 'SYSTEM' and L_CHKSYS = 'Y'))
                            AND pm.prstatus = 'A'
                            AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,AF.Actype)
                            AND brm.brid = decode(brm.brid,'ALL',brm.brid,AF.BRID)
                             )
                     LOOP
                         IF NOT (REC.CHKSYS=1 AND L_ALL_CHKSYS=0 ) THEN
                            insert into prinusedlog (prcode,prinused,deltd,last_change,autoid,txnum,txdate)
                            values(REC.prcode, -1*L_USED_INDAY, 'N', SYSTIMESTAMP, seq_prinusedlog.nextval, P_TXMSG.txnum,P_TXMSG.TXDATE );
                         ENd IF;
                     END LOOP;

               END IF;
        END IF;
        -- cap nhat lai tham so trong AFMAST truoc khi xu insert vao prinusedlog
        UPDATE AFMAST SET POOLCHK=L_NEWPOOLCHK, POOLLIMIT=L_NEWPOOLLIMIT WHERE ACCTNO=L_AFACCTNO;
        --Tich hop NewFO
        plog.debug (pkgctx, 'Tich hop FO '||L_AFACCTNO ||' L_NEWPOOLCHK '|| L_NEWPOOLCHK ||' L_OLDPOOLCHK '||L_OLDPOOLCHK);
        IF L_OLDPOOLCHK='Y' AND L_NEWPOOLCHK='N'  THEN --chuyen sang pool dac biet dong bo xuong FO Pool moi.
            INSERT INTO t_fo_event (autoid,
                                    txnum,
                                    txdate,
                                    acctno,
                                    tltxcd,
                                    CVALUE,
                                    logtime,
                                    processtime,
                                    process,
                                    errcode,
                                    errmsg)
                    VALUES (seq_fo_event.NEXTVAL,
                            '',
                            '',
                            L_AFACCTNO,
                            'ADDSPROOM',
                            'VND',
                            systimestamp,
                            '',
                            'N',
                            '',
                            '');
             v_action :='I';
         ELSIF L_NEWPOOLCHK='N' AND L_OLDPOOLCHK='N' THEN

             v_action :='U';

             --Dieu chinh POOL.
            INSERT INTO t_fo_event (autoid,
                                        txnum,
                                        txdate,
                                        acctno,
                                        tltxcd,
                                        CVALUE,
                                        logtime,
                                        processtime,
                                        process,
                                        errcode,
                                        errmsg)
                        VALUES (seq_fo_event.NEXTVAL,
                                '',
                                '',
                                L_AFACCTNO,
                                'ADDSPROOM',
                                'VND',
                                systimestamp,
                                '',
                                'N',
                                '',
                                '');

         ELSE
             v_action :='D';
         END IF;

         INSERT INTO t_fo_event (autoid,
                        txnum,
                        txdate,
                        acctno,
                        tltxcd,
                        CVALUE,
                        logtime,
                        processtime,
                        process,
                        errcode,
                        errmsg)
        VALUES (seq_fo_event.NEXTVAL,
                '',
                '',
                L_AFACCTNO,
                'ACC2SPROOM',
                v_action||L_AFACCTNO,
                systimestamp,
                '',
                'N',
                '',
                '');


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
         plog.init ('TXPKS_#0027EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#0027EX;
/

