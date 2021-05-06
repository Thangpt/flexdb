CREATE OR REPLACE PACKAGE txpks_#3314ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3314EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      21/08/2010     Created
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

CREATE OR REPLACE PACKAGE BODY txpks_#3314ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '03';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_catype           CONSTANT CHAR(2) := '05';
   c_reportdate       CONSTANT CHAR(2) := '06';
   c_actiondate       CONSTANT CHAR(2) := '07';
   c_rate             CONSTANT CHAR(2) := '10';
   c_status           CONSTANT CHAR(2) := '20';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_camastid varchar2(30);
    l_catype varchar2(30);
    l_count NUMBER;
    l_reportdate DATE;
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
     l_camastid varchar2(30);
    l_catype varchar2(30);
    L_qtty number ;
    L_status varchar2 (300);
    v_txdate varchar2(30);
    V_SE_RECEIVING NUMBER;
    V_CI_RECEIVING NUMBER;
    v_SEACCTNO VARCHAR2(30);
    v_CIACCTNO VARCHAR2(10);

BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_camastid:= p_txmsg.txfields('03').value;

select catype into l_catype  from camast where camastid =l_camastid;
select TO_CHAR(Max(TXDATE),'DD/MM/RRRR') into v_txdate from vw_tllog_all where tltxcd ='3340' and msgacct = l_camastid;

for rec in
(
select tl.txnum , tl.txdate ,se.acctno, se.namt, tlfld.cvalue, se.txcd from vw_tllog_all tl,
 vw_tllogfld_all tlfld, vw_setran_gen se
where tl.txnum = tlfld.txnum and tl.txdate = tlfld.txdate
and tl.txnum = se.txnum and tl.txdate= se.txdate
and tl.tltxcd ='3380'  and  se.tltxcd ='3380'and tlfld.fldcd='02'
and tlfld.cvalue = l_camastid
)
loop

    BEGIN
       SELECT NAMT, ACCTNO INTO V_SE_RECEIVING,V_SEACCTNO
       FROM VW_SETRAN_GEN
       WHERE TXNUM=REC.TXNUM AND TXDATE=REC.TXDATE AND TXCD='0016';
    EXCEPTION WHEN OTHERS THEN
       V_SE_RECEIVING:=0;
       V_SEACCTNO:='0000';
    END;

    if rec.namt <> 0 then
        FOR REC_GV IN
            (
                SELECT * FROM SETRAN_GEN
                WHERE TXDATE=rec.txdate AND TXNUM=REC.TXNUM
                AND TXCD IN ('0051','0052','0067','0068') AND DELTD <> 'Y'
            )
        LOOP
            IF TO_DATE(V_TXDATE,'DD/MM/RRRR') <> P_TXMSG.TXDATE THEN
                IF REC_GV.TXCD='0051' THEN --0067
                    INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (P_TXMSG.txnum,P_TXMSG.TXDATE,REC_GV.ACCTNO,'0051',-REC_GV.NAMT,
                    NULL,REC_GV.ACCTREF,'N',REC_GV.Ref,SEQ_SETRAN.NEXTVAL,'3314',REC_GV.BUSDATE,'Revert cho giao dich '|| REC_GV.TXDESC);
                END IF;
                IF REC_GV.TXCD='0052' THEN --
                    INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (P_TXMSG.txnum,P_TXMSG.TXDATE,REC_GV.ACCTNO,'0052',-REC_GV.NAMT,
                    NULL,REC_GV.ACCTREF,'N',REC_GV.Ref,SEQ_SETRAN.NEXTVAL,'3314',REC_GV.BUSDATE,'Revert cho giao dich '|| REC_GV.TXDESC);
                END IF;
                IF REC_GV.TXCD='0067' THEN --
                    INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (P_TXMSG.txnum,P_TXMSG.TXDATE,REC_GV.ACCTNO,'0067',-REC_GV.NAMT,
                    NULL,REC_GV.ACCTREF,'N',REC_GV.Ref,SEQ_SETRAN.NEXTVAL,'3314',REC_GV.BUSDATE,'Revert cho giao dich '|| REC_GV.TXDESC);
                END IF;
                IF REC_GV.TXCD='0068' THEN --0067
                    INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (P_TXMSG.txnum,P_TXMSG.TXDATE,REC_GV.ACCTNO,'0068',-REC_GV.NAMT,
                    NULL,REC_GV.ACCTREF,'N',REC_GV.Ref,SEQ_SETRAN.NEXTVAL,'3314',REC_GV.BUSDATE,'Revert cho giao dich '|| REC_GV.TXDESC);
                END IF;
            ENd IF;

            IF REC_GV.TXCD='0051' THEN
                UPDATE SEMAST SET DCRAMT=DCRAMT-REC_GV.NAMT WHERE ACCTNO=REC_GV.ACCTNO;
            ELSIF REC_GV.TXCD='0052' THEN
                UPDATE SEMAST SET DCRQTTY=DCRQTTY-REC_GV.NAMT WHERE ACCTNO=REC_GV.ACCTNO;
            ELSIF REC_GV.TXCD='0067' THEN
                UPDATE SEMAST SET DDROUTAMT=DDROUTAMT-REC_GV.NAMT WHERE ACCTNO=REC_GV.ACCTNO;
            ELSIF REC_GV.TXCD='0068' THEN
                UPDATE SEMAST SET DDROUTQTTY=DDROUTQTTY-REC_GV.NAMT WHERE ACCTNO=REC_GV.ACCTNO;
            END IF;
        END LOOP;
    end if;

    UPDATE SEMAST SET RECEIVING = RECEIVING - V_SE_RECEIVING  WHERE ACCTNO = V_SEACCTNO ;
    update  tllog set deltd ='Y' where txnum = rec.txnum and txdate= rec.txdate ;
    update  setran set deltd ='Y' where txnum = rec.txnum and txdate= rec.txdate ;
    update  tllogall set deltd ='Y' where txnum = rec.txnum and txdate= rec.txdate ;
    update  setrana set deltd ='Y' where txnum = rec.txnum and txdate= rec.txdate ;
    update  setran_gen set deltd ='Y' where txnum = rec.txnum and txdate= rec.txdate ;

end loop;

for rec in
(
select tl.txnum , tl.txdate ,  tlfld.cvalue ,tl.msgamt,tl.msgacct, tl1.nvalue amt
from (select * from tllog union select * from tllogall) tl, vw_tllogfld_all tlfld, vw_tllogfld_all tl1
where tl.txnum = tlfld.txnum and tl.txdate = tlfld.txdate
and tl.tltxcd ='3380'  and tlfld.fldcd='02'
and tlfld.cvalue = l_camastid
and tl.txnum = tl1.txnum and tl.txdate = tl1.txdate and tl1.fldcd = '10'
)
LOOP
    update  tllog set deltd ='Y' where txnum = rec.txnum and txdate= rec.txdate ;
    update  citran set deltd ='Y' where txnum = rec.txnum and txdate= rec.txdate ;
    update  tllogall set deltd ='Y' where txnum = rec.txnum and txdate= rec.txdate ;
    update  citrana set deltd ='Y' where txnum = rec.txnum and txdate= rec.txdate ;
    update  citran_gen set deltd ='Y' where txnum = rec.txnum and txdate= rec.txdate ;
    if rec.amt <> 0 then
        update cimast set receiving = receiving - rec.amt  where acctno = rec.msgacct ;
    end if;
end loop;

IF l_catype ='023' then
L_status :='V';
ELSIF l_catype ='014' THEN
    select SUM (qtty) into L_qtty  from CASCHD where CAMASTID = l_camastid ;
    IF L_qtty >0 THEN
     L_status :='M';
    ELSE
    L_status := 'V';
    END IF;
ELSE
L_status :='A';
END IF ;


UPDATE CASCHD SET  STATUS = L_status WHERE CAMASTID = l_camastid;
UPDATE CAMAST SET  STATUS = L_status WHERE CAMASTID = l_camastid;

    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppUpdate;

END TXPKS_#3314EX;
/

