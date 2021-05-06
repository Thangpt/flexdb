CREATE OR REPLACE PACKAGE txpks_#2263ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2263EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      30/03/2011     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#2263ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_codeid           CONSTANT CHAR(2) := '01';
   c_custodycd        CONSTANT CHAR(2) := '04';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_seacctnodr       CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_seacctnocr       CONSTANT CHAR(2) := '05';
   c_trade            CONSTANT CHAR(2) := '10';
   c_mortage          CONSTANT CHAR(2) := '12';
   c_standing         CONSTANT CHAR(2) := '15';
   c_withdraw         CONSTANT CHAR(2) := '16';
   c_deposit          CONSTANT CHAR(2) := '17';
   c_blocked          CONSTANT CHAR(2) := '19';
   c_senddeposit      CONSTANT CHAR(2) := '22';
   c_dtoclose         CONSTANT CHAR(2) := '25';
   c_parvalue         CONSTANT CHAR(2) := '11';
   c_price            CONSTANT CHAR(2) := '09';
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
v_txnum varchar2(20);
V_txdate date;
v_DEPOSIT number default 0;
v_SENDDEPOSIT  number default 0;
v_BLOCKED  number default 0;
v_STANDING number default 0;
v_MORTAGE  number default 0;
v_SEWITHDRAW  number default 0;
v_codeid  varchar2(20);
v_wftcodeid  varchar2(20);
v_SEACCTNODR varchar2(20);
v_SEACCTNOCR varchar2(20);
l_blocked_change NUMBER(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    v_SEACCTNOCR := p_txmsg.txfields('05').VALUE;
    v_SEACCTNODR := p_txmsg.txfields('03').VALUE;
    v_DEPOSIT := p_txmsg.txfields('17').VALUE;
    v_SENDDEPOSIT := p_txmsg.txfields('22').VALUE;
    v_BLOCKED := p_txmsg.txfields('19').VALUE;
    v_STANDING := p_txmsg.txfields('15').VALUE;
    v_MORTAGE := p_txmsg.txfields('12').VALUE;
    v_codeid := p_txmsg.txfields('01').VALUE;
    v_SEWITHDRAW := p_txmsg.txfields('16').VALUE;
    v_txnum:= p_txmsg.txnum;
    V_txdate:= p_txmsg.txdate;

    select codeid into v_wftcodeid  from sbsecurities where refcodeid = v_codeid;

    plog.debug (pkgctx, v_SEWITHDRAW || '-'|| v_SEACCTNOCR || '-'||v_SEACCTNODR );
    IF p_txmsg.deltd <> 'Y' THEN
        ---HaiLT them
        UPDATE SEPITLOG SET CODEID=v_codeid,acctno=p_txmsg.txfields('05').VALUE WHERE CODEID=v_wftcodeid and afacctno=p_txmsg.txfields('02').VALUE;

        if v_SEWITHDRAW >0 THEN
            update SEWITHDRAWdtl set acctno = v_SEACCTNOCR where acctno = v_SEACCTNODR;

            INSERT INTO setran (TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,AUTOID,ACCTREF,TLTXCD,BKDATE,TRDESC)
            VALUES(v_txnum,V_txdate,v_SEACCTNODR,'0083',0,v_SEACCTNOCR,NULL,'N',seq_setran.nextval,NULL,'2263',V_txdate,NULL);
        end if ;
        if v_DEPOSIT>0 or v_SENDDEPOSIT >0 then
            update sedeposit set acctno = v_SEACCTNOCR where acctno = v_SEACCTNODR;
            INSERT INTO setran (TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,AUTOID,ACCTREF,TLTXCD,BKDATE,TRDESC)
            VALUES(v_txnum,V_txdate,v_SEACCTNODR,'0081',0,v_SEACCTNOCR,NULL,'N',seq_setran.nextval,NULL,'2263',V_txdate,NULL);
        end if;

        if v_BLOCKED >0 then
         l_blocked_change:=0; -- so luong ck da chuyen sang jao dich trong semastdtl
              FOR rec_semastdtl IN
                           (SELECT * FROM semastdtl WHERE acctno= v_SEACCTNODR
                            AND DELTD <> 'Y' AND status <> 'C' AND qttytype IN ('002','007')
                            ORDER BY autoid )
              LOOP
                if(l_blocked_change <v_BLOCKED) THEN -- neu van chua chuyen het
                     IF ((v_BLOCKED-l_blocked_change)>= rec_semastdtl.qtty) THEN --  neu sl chua chuyen lon hon record dang xet
                        update semastdtl set acctno =v_SEACCTNOCR where autoid = rec_semastdtl.autoid;
                        l_blocked_change:=l_blocked_change+rec_semastdtl.qtty;

                     INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                     VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('05').value,'0043',rec_semastdtl.qtty,NULL,'05',p_txmsg.deltd,rec_semastdtl.qttytype,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

                      INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                      VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('03').value,'0044',rec_semastdtl.qtty,NULL,'03',p_txmsg.deltd,rec_semastdtl.qttytype,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');


                     ELSE -- chi update giam mot phan, ghi them mot dong cho chung khoan jao dich moi
                        UPDATE semastdtl SET qtty=qtty-(v_BLOCKED-l_blocked_change) WHERE autoid=rec_semastdtl.autoid;

                         INSERT INTO SEMASTDTL (ACCTNO,QTTY,QTTYTYPE,TXNUM,TXDATE,DELTD,DFQTTY,STATUS,AUTOID)
                         SELECT v_SEACCTNOCR,(v_BLOCKED-l_blocked_change),qttytype,txnum,txdate,deltd,0,status,sEQ_SEMASTDTL.NEXTVAL
                         FROM semastdtl WHERE autoid=rec_semastdtl.autoid;


                       INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                       VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('05').value,'0043',(v_BLOCKED-l_blocked_change),NULL,'05',p_txmsg.deltd,rec_semastdtl.qttytype,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

                      INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                      VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('03').value,'0044',(v_BLOCKED-l_blocked_change),NULL,'03',p_txmsg.deltd,rec_semastdtl.qttytype,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');


                         l_blocked_change:=l_blocked_change+(v_BLOCKED-l_blocked_change);

                     END IF;

                END IF;

              exit when l_blocked_change >=v_blocked;
              END LOOP;



            INSERT INTO setran (TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,AUTOID,ACCTREF,TLTXCD,BKDATE,TRDESC)
            VALUES(v_txnum,V_txdate,v_SEACCTNODR,'0082',0,v_SEACCTNOCR,NULL,'N',seq_setran.nextval,NULL,'2263',V_txdate,NULL);
        end if;

        if v_MORTAGE-v_STANDING >0 then
            update dfmast set codeid = v_codeid where codeid = v_wftcodeid and afacctno=p_txmsg.txfields('02').VALUE;

            INSERT INTO dftran (TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,REF,DELTD,AUTOID,ACCTREF,TLTXCD,BKDATE,TRDESC)
            VALUES(v_txnum,V_txdate,v_wftcodeid,'0008',0,v_codeid,NULL,'N',seq_dftran.nextval,NULL,'2262',V_txdate,NULL);
        end if;

        update caschd set status ='W' where status in('S','C') AND ISSE='Y'
        AND camastid in ( SELECT CAMASTID FROM CAMAST WHERE ISWFT='Y' AND CODEID =v_codeid AND CATYPE IN( '011','014','022') )
        and afacctno=p_txmsg.txfields('02').VALUE;

    -- XOA GIAO DICH
    else
        update caschd set status ='S' where status ='W' AND ISSE='Y'
        AND camastid in ( SELECT CAMASTID FROM CAMAST WHERE ISWFT='Y' AND CODEID =v_codeid AND CATYPE IN( '011','014','022') )
        and afacctno=p_txmsg.txfields('02').VALUE;

        if v_DEPOSIT>0 or v_SENDDEPOSIT >0 then
            update sedeposit set acctno = v_SEACCTNODR  where acctno = v_SEACCTNOCR;

            update setran set deltd ='Y'  where txdate = V_txdate and txnum = v_txnum ;
        end if;

        if v_BLOCKED >0 then
            update semastdtl set acctno = v_SEACCTNODR  where acctno = v_SEACCTNOCR;
            update setran set deltd ='Y'  where txdate = V_txdate and txnum = v_txnum ;
        end if;

        if v_MORTAGE-v_STANDING >0 then
            update dfmast set codeid = v_wftcodeid  where codeid = v_codeid and afacctno=p_txmsg.txfields('02').VALUE;

            update setran set deltd ='Y'  where txdate = V_txdate and txnum = v_txnum ;
        end if;

        if v_SEWITHDRAW >0 THEN
            update SEWITHDRAWdtl set acctno = v_SEACCTNODR  where acctno = v_SEACCTNOCR;

            update setran set deltd ='Y'  where txdate = V_txdate and txnum = v_txnum ;
        end if ;
        ---HaiLT them
        UPDATE SEPITLOG SET CODEID=v_wftcodeid,acctno=p_txmsg.txfields('03').VALUE WHERE CODEID=v_codeid and afacctno=p_txmsg.txfields('02').VALUE;
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
         plog.init ('TXPKS_#2263EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2263EX;
/

