CREATE OR REPLACE PACKAGE txpks_#6640
/** ----------------------------------------------------------------------------------------------------
 ** Module: TX
 ** Description: Hold balance
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      10/01/2012     Created
 ** (c) 2008 by Financial Software Solutions. JSC.
 ----------------------------------------------------------------------------------------------------*/
IS
    FUNCTION FN_TXPROCESS (P_XMLMSG      IN OUT VARCHAR2,
                           P_ERR_CODE    IN OUT VARCHAR2,
                           P_ERR_PARAM      OUT VARCHAR2)
        RETURN NUMBER;

    FUNCTION FN_AUTOTXPROCESS (P_TXMSG       IN OUT TX.MSG_RECTYPE,
                               P_ERR_CODE    IN OUT VARCHAR2,
                               P_ERR_PARAM      OUT VARCHAR2)
        RETURN NUMBER;

    FUNCTION FN_BATCHTXPROCESS (P_TXMSG       IN OUT TX.MSG_RECTYPE,
                                P_ERR_CODE    IN OUT VARCHAR2,
                                P_ERR_PARAM      OUT VARCHAR2)
        RETURN NUMBER;

    FUNCTION FN_TXREVERT (P_TXNUM              VARCHAR2,
                          P_TXDATE             VARCHAR2,
                          P_ERR_CODE    IN OUT VARCHAR2,
                          P_ERR_PARAM      OUT VARCHAR2)
        RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY txpks_#6640
IS
    PKGCTX   PLOG.LOG_CTX;
    LOGROW   TLOGDEBUG%ROWTYPE;

    PROCEDURE PR_TXLOG (P_TXMSG IN TX.MSG_RECTYPE, P_ERR_CODE OUT VARCHAR2)
    IS
    BEGIN
        PLOG.SETBEGINSECTION (PKGCTX, 'pr_txlog');
        PLOG.DEBUG (PKGCTX,
                    'abt to insert into tllog, txnum: ' || P_TXMSG.TXNUM);

        INSERT INTO TLLOG (AUTOID,
                           TXNUM,
                           TXDATE,
                           TXTIME,
                           BRID,
                           TLID,
                           OFFID,
                           OVRRQS,
                           CHID,
                           CHKID,
                           TLTXCD,
                           IBT,
                           BRID2,
                           TLID2,
                           CCYUSAGE,
                           OFF_LINE,
                           DELTD,
                           BRDATE,
                           BUSDATE,
                           TXDESC,
                           IPADDRESS,
                           WSNAME,
                           TXSTATUS,
                           MSGSTS,
                           OVRSTS,
                           BATCHNAME,
                           MSGAMT,
                           MSGACCT,
                           CHKTIME,
                           OFFTIME,
                           REFTXNUM)
          VALUES   (SEQ_TLLOG.NEXTVAL,
                    P_TXMSG.TXNUM,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    P_TXMSG.TXTIME,
                    P_TXMSG.BRID,
                    P_TXMSG.TLID,
                    P_TXMSG.OFFID,
                    P_TXMSG.OVRRQD,
                    P_TXMSG.CHID,
                    P_TXMSG.CHKID,
                    P_TXMSG.TLTXCD,
                    P_TXMSG.IBT,
                    P_TXMSG.BRID2,
                    P_TXMSG.TLID2,
                    P_TXMSG.CCYUSAGE,
                    P_TXMSG.OFF_LINE,
                    P_TXMSG.DELTD,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    TO_DATE (P_TXMSG.BUSDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    NVL (P_TXMSG.TXFIELDS ('30').VALUE, P_TXMSG.TXDESC),
                    P_TXMSG.IPADDRESS,
                    P_TXMSG.WSNAME,
                    P_TXMSG.TXSTATUS,
                    P_TXMSG.MSGSTS,
                    P_TXMSG.OVRSTS,
                    P_TXMSG.BATCHNAME,
                    P_TXMSG.TXFIELDS ('10').VALUE,
                    P_TXMSG.TXFIELDS ('03').VALUE,
                    TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), --
                    TO_CHAR(SYSDATE,systemnums.C_TIME_FORMAT), --
                    /*DECODE (
                        P_TXMSG.CHKID,
                        NULL,
                        TO_CHAR (SYSDATE,
                                 SYSTEMNUMS.C_TIME_FORMAT,
                                 P_TXMSG.CHKID)),*/
                    /*DECODE (
                        P_TXMSG.OFFTIME,
                        NULL,
                        TO_CHAR (SYSDATE,
                                 SYSTEMNUMS.C_TIME_FORMAT,
                                 P_TXMSG.OFFTIME)),*/
                    P_TXMSG.REFTXNUM);


        PLOG.DEBUG (PKGCTX, 'abt to insert into tllogfld');

        INSERT INTO TLLOGFLD (AUTOID,
                              TXNUM,
                              TXDATE,
                              FLDCD,
                              NVALUE,
                              CVALUE,
                              TXDESC)
          VALUES   (SEQ_TLLOGFLD.NEXTVAL,
                    P_TXMSG.TXNUM,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    '88',
                    0,
                    P_TXMSG.TXFIELDS ('88').VALUE,
                    'Custody code');

        PLOG.DEBUG (PKGCTX, 'abt to insert into tllogfld');

        INSERT INTO TLLOGFLD (AUTOID,
                              TXNUM,
                              TXDATE,
                              FLDCD,
                              NVALUE,
                              CVALUE,
                              TXDESC)
          VALUES   (SEQ_TLLOGFLD.NEXTVAL,
                    P_TXMSG.TXNUM,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    '03',
                    0,
                    P_TXMSG.TXFIELDS ('03').VALUE,
                    'RM Account No');

        PLOG.DEBUG (PKGCTX, 'abt to insert into tllogfld');

        INSERT INTO TLLOGFLD (AUTOID,
                              TXNUM,
                              TXDATE,
                              FLDCD,
                              NVALUE,
                              CVALUE,
                              TXDESC)
          VALUES   (SEQ_TLLOGFLD.NEXTVAL,
                    P_TXMSG.TXNUM,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    '90',
                    0,
                    P_TXMSG.TXFIELDS ('90').VALUE,
                    'Fullname');

        PLOG.DEBUG (PKGCTX, 'abt to insert into tllogfld');

        INSERT INTO TLLOGFLD (AUTOID,
                              TXNUM,
                              TXDATE,
                              FLDCD,
                              NVALUE,
                              CVALUE,
                              TXDESC)
          VALUES   (SEQ_TLLOGFLD.NEXTVAL,
                    P_TXMSG.TXNUM,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    '91',
                    0,
                    P_TXMSG.TXFIELDS ('91').VALUE,
                    'Address');

        PLOG.DEBUG (PKGCTX, 'abt to insert into tllogfld');

        INSERT INTO TLLOGFLD (AUTOID,
                              TXNUM,
                              TXDATE,
                              FLDCD,
                              NVALUE,
                              CVALUE,
                              TXDESC)
          VALUES   (SEQ_TLLOGFLD.NEXTVAL,
                    P_TXMSG.TXNUM,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    '92',
                    0,
                    P_TXMSG.TXFIELDS ('92').VALUE,
                    'License');

        PLOG.DEBUG (PKGCTX, 'abt to insert into tllogfld');

        INSERT INTO TLLOGFLD (AUTOID,
                              TXNUM,
                              TXDATE,
                              FLDCD,
                              NVALUE,
                              CVALUE,
                              TXDESC)
          VALUES   (SEQ_TLLOGFLD.NEXTVAL,
                    P_TXMSG.TXNUM,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    '97',
                    0,
                    P_TXMSG.TXFIELDS ('97').VALUE,
                    'Careby group');

        PLOG.DEBUG (PKGCTX, 'abt to insert into tllogfld');

        INSERT INTO TLLOGFLD (AUTOID,
                              TXNUM,
                              TXDATE,
                              FLDCD,
                              NVALUE,
                              CVALUE,
                              TXDESC)
          VALUES   (SEQ_TLLOGFLD.NEXTVAL,
                    P_TXMSG.TXNUM,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    '93',
                    0,
                    P_TXMSG.TXFIELDS ('93').VALUE,
                    'Bank acctno');

        PLOG.DEBUG (PKGCTX, 'abt to insert into tllogfld');

        INSERT INTO TLLOGFLD (AUTOID,
                              TXNUM,
                              TXDATE,
                              FLDCD,
                              NVALUE,
                              CVALUE,
                              TXDESC)
          VALUES   (SEQ_TLLOGFLD.NEXTVAL,
                    P_TXMSG.TXNUM,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    '95',
                    0,
                    P_TXMSG.TXFIELDS ('95').VALUE,
                    'Bank');

        PLOG.DEBUG (PKGCTX, 'abt to insert into tllogfld');

        INSERT INTO TLLOGFLD (AUTOID,
                              TXNUM,
                              TXDATE,
                              FLDCD,
                              NVALUE,
                              CVALUE,
                              TXDESC)
          VALUES   (SEQ_TLLOGFLD.NEXTVAL,
                    P_TXMSG.TXNUM,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    '11',
                    TO_NUMBER (P_TXMSG.TXFIELDS ('11').VALUE),
                    NULL,
                    'Avail balance at Bank');

        PLOG.DEBUG (PKGCTX, 'abt to insert into tllogfld');

        INSERT INTO TLLOGFLD (AUTOID,
                              TXNUM,
                              TXDATE,
                              FLDCD,
                              NVALUE,
                              CVALUE,
                              TXDESC)
          VALUES   (SEQ_TLLOGFLD.NEXTVAL,
                    P_TXMSG.TXNUM,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    '12',
                    TO_NUMBER (P_TXMSG.TXFIELDS ('12').VALUE),
                    NULL,
                    'Holed balance at bank');

        PLOG.DEBUG (PKGCTX, 'abt to insert into tllogfld');

        INSERT INTO TLLOGFLD (AUTOID,
                              TXNUM,
                              TXDATE,
                              FLDCD,
                              NVALUE,
                              CVALUE,
                              TXDESC)
          VALUES   (SEQ_TLLOGFLD.NEXTVAL,
                    P_TXMSG.TXNUM,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    '13',
                    TO_NUMBER (P_TXMSG.TXFIELDS ('13').VALUE),
                    NULL,
                    'Amount can be release');

        PLOG.DEBUG (PKGCTX, 'abt to insert into tllogfld');

        INSERT INTO TLLOGFLD (AUTOID,
                              TXNUM,
                              TXDATE,
                              FLDCD,
                              NVALUE,
                              CVALUE,
                              TXDESC)
          VALUES   (SEQ_TLLOGFLD.NEXTVAL,
                    P_TXMSG.TXNUM,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    '96',
                    TO_NUMBER (P_TXMSG.TXFIELDS ('96').VALUE),
                    NULL,
                    'Holded amount');

        PLOG.DEBUG (PKGCTX, 'abt to insert into tllogfld');

        INSERT INTO TLLOGFLD (AUTOID,
                              TXNUM,
                              TXDATE,
                              FLDCD,
                              NVALUE,
                              CVALUE,
                              TXDESC)
          VALUES   (SEQ_TLLOGFLD.NEXTVAL,
                    P_TXMSG.TXNUM,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    '10',
                    TO_NUMBER (P_TXMSG.TXFIELDS ('10').VALUE),
                    NULL,
                    'Hold Amount');

        PLOG.DEBUG (PKGCTX, 'abt to insert into tllogfld');

        INSERT INTO TLLOGFLD (AUTOID,
                              TXNUM,
                              TXDATE,
                              FLDCD,
                              NVALUE,
                              CVALUE,
                              TXDESC)
          VALUES   (SEQ_TLLOGFLD.NEXTVAL,
                    P_TXMSG.TXNUM,
                    TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                    '30',
                    0,
                    P_TXMSG.TXFIELDS ('30').VALUE,
                    'Description');

        PLOG.DEBUG (PKGCTX,
                    'Check if neccessary to poplulate FEETRAN and VATTRAN');

        IF P_TXMSG.TXINFO.EXISTS (TXNUMS.C_TXINFO_VATTRAN)
        THEN
            PLOG.DEBUG (PKGCTX, 'Abt to insert into VATTRAN');

            INSERT INTO VATTRAN (AUTOID,
                                 TXNUM,
                                 TXDATE,
                                 VOUCHERNO,
                                 VOUCHERTYPE,
                                 SERIENO,
                                 VOUCHERDATE,
                                 CUSTID,
                                 TAXCODE,
                                 CUSTNAME,
                                 ADDRESS,
                                 CONTENTS,
                                 QTTY,
                                 PRICE,
                                 AMT,
                                 VATRATE,
                                 VATAMT,
                                 DESCRIPTION,
                                 DELTD)
              VALUES   (SEQ_VATTRAN.NEXTVAL,
                        P_TXMSG.TXNUM,
                        TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                        P_TXMSG.TXINFO(TXNUMS.C_TXINFO_VATTRAN)(TXNUMS.C_VATTRAN_VOUCHERNO), -- voucherno
                        P_TXMSG.TXINFO(TXNUMS.C_TXINFO_VATTRAN)(TXNUMS.C_VATTRAN_VOUCHERTYPE), -- vouchertype
                        P_TXMSG.TXINFO(TXNUMS.C_TXINFO_VATTRAN)(TXNUMS.C_VATTRAN_SERIALNO), -- serieno
                        TO_DATE (
                            P_TXMSG.TXINFO(TXNUMS.C_TXINFO_VATTRAN)(TXNUMS.C_VATTRAN_VOUCHERDATE),
                            SYSTEMNUMS.C_DATE_FORMAT),           --voucherdate
                        P_TXMSG.TXINFO (
                            TXNUMS.C_TXINFO_VATTRAN)(TXNUMS.C_VATTRAN_CUSTID), -- CUSTID
                        P_TXMSG.TXINFO(TXNUMS.C_TXINFO_VATTRAN)(TXNUMS.C_VATTRAN_TAXCODE), -- TAXCODE
                        P_TXMSG.TXINFO(TXNUMS.C_TXINFO_VATTRAN)(TXNUMS.C_VATTRAN_CUSTNAME), -- CUSTNAME
                        P_TXMSG.TXINFO(TXNUMS.C_TXINFO_VATTRAN)(TXNUMS.C_VATTRAN_ADDRESS), -- ADDRESS
                        P_TXMSG.TXINFO(TXNUMS.C_TXINFO_VATTRAN)(TXNUMS.C_VATTRAN_CONTENTS), -- CONTENTS
                        P_TXMSG.TXINFO (
                            TXNUMS.C_TXINFO_VATTRAN)(TXNUMS.C_VATTRAN_QTTY), -- QTTY
                        P_TXMSG.TXINFO (
                            TXNUMS.C_TXINFO_VATTRAN)(TXNUMS.C_VATTRAN_PRICE), -- PRICE
                        P_TXMSG.TXINFO (
                            TXNUMS.C_TXINFO_VATTRAN)(TXNUMS.C_VATTRAN_AMT), -- AMT
                        P_TXMSG.TXINFO(TXNUMS.C_TXINFO_VATTRAN)(TXNUMS.C_VATTRAN_VATRATE), -- VATRATE
                        P_TXMSG.TXINFO (
                            TXNUMS.C_TXINFO_VATTRAN)(TXNUMS.C_VATTRAN_VATAMT), -- VATAMT
                        P_TXMSG.TXINFO(TXNUMS.C_TXINFO_VATTRAN)(TXNUMS.C_VATTRAN_DESCRIPTION), -- DESCRIPTION
                        TXNUMS.C_DELTD_TXNORMAL);
        END IF;

        PLOG.DEBUG (PKGCTX, 'Abt to insert into FEETRAN');

        IF P_TXMSG.TXINFO.EXISTS (TXNUMS.C_TXINFO_FEETRAN)
        THEN
            INSERT INTO FEETRAN (AUTOID,
                                 TXDATE,
                                 TXNUM,
                                 DELTD,
                                 FEECD,
                                 GLACCTNO,
                                 FEEAMT,
                                 VATAMT,
                                 TXAMT,
                                 FEERATE,
                                 VATRATE)
              VALUES   (SEQ_FEETRAN.NEXTVAL,
                        TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                        P_TXMSG.TXNUM,                                 --TXNUM
                        TXNUMS.C_DELTD_TXNORMAL,
                        P_TXMSG.TXINFO (
                            TXNUMS.C_TXINFO_FEETRAN)(TXNUMS.C_FEETRAN_FEECD), --FEECD
                        P_TXMSG.TXINFO(TXNUMS.C_TXINFO_FEETRAN)(TXNUMS.C_FEETRAN_GLACCTNO), --GLACCTNO
                        P_TXMSG.TXINFO (
                            TXNUMS.C_TXINFO_FEETRAN)(TXNUMS.C_FEETRAN_FEEAMT), --FEEAMT
                        P_TXMSG.TXINFO (
                            TXNUMS.C_TXINFO_FEETRAN)(TXNUMS.C_FEETRAN_VATAMT), --VATAMT
                        P_TXMSG.TXINFO (
                            TXNUMS.C_TXINFO_FEETRAN)(TXNUMS.C_FEETRAN_TXAMT), --TXAMT
                        P_TXMSG.TXINFO(TXNUMS.C_TXINFO_FEETRAN)(TXNUMS.C_FEETRAN_FEERATE), --FEERATE
                        P_TXMSG.TXINFO(TXNUMS.C_TXINFO_FEETRAN)(TXNUMS.C_FEETRAN_VATRATE));                                                                               --VATRATE
        END IF;

        PLOG.SETENDSECTION (PKGCTX, 'pr_txlog');
    EXCEPTION
        WHEN OTHERS
        THEN
            P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
            PLOG.ERROR (PKGCTX, SQLERRM);
            PLOG.SETENDSECTION (PKGCTX, 'pr_txlog');
            RAISE ERRNUMS.E_SYSTEM_ERROR;
    END PR_TXLOG;                                                           --


    PROCEDURE PR_PRINTINFO (P_TXMSG      IN OUT TX.MSG_RECTYPE,
                            P_ERR_CODE   IN OUT VARCHAR2)
    IS
        L_SECTYPE    SEMAST.ACTYPE%TYPE;
        L_CODEID     VARCHAR2 (6);
        L_ACCTNO     VARCHAR2 (30);
        L_CUSTID     AFMAST.CUSTID%TYPE;
        L_AFACCTNO   AFMAST.ACCTNO%TYPE;
        L_COUNT      NUMBER (10) := 0;
    BEGIN
        PLOG.SETBEGINSECTION (PKGCTX, 'pr_PrintInfo');


        --<<BEGIN OF PROCESS CIMAST>>
        L_ACCTNO := P_TXMSG.TXFIELDS ('03').VALUE;

        SELECT   COUNT ( * )
          INTO   L_COUNT
          FROM   CIMAST
         WHERE   ACCTNO = L_ACCTNO;

        IF L_COUNT = 0
        THEN
            P_ERR_CODE := ERRNUMS.C_PRINTINFO_ACCTNOTFOUND;
            RAISE ERRNUMS.E_PRINTINFO_ACCTNOTFOUND;
        END IF;

        BEGIN
            SELECT   FULLNAME CUSTNAME,
                     ADDRESS,
                     IDCODE LICENSE,
                     CUSTODYCD
              INTO   P_TXMSG.TXPRINTINFO ('03').CUSTNAME,
                     P_TXMSG.TXPRINTINFO ('03').ADDRESS,
                     P_TXMSG.TXPRINTINFO ('03').LICENSE,
                     P_TXMSG.TXPRINTINFO ('03').CUSTODY
              FROM   CFMAST A
             WHERE   EXISTS
                         (SELECT   1
                            FROM   CIMAST
                           WHERE   CUSTID = A.CUSTID AND ACCTNO = L_ACCTNO);
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                P_ERR_CODE := ERRNUMS.C_CF_CUSTOM_NOTFOUND;
                RAISE ERRNUMS.E_PRINTINFO_ACCTNOTFOUND;
        END;

        --<<END OF PROCESS CIMAST>>


        PLOG.SETENDSECTION (PKGCTX, 'pr_PrintInfo');
    END PR_PRINTINFO;

    FUNCTION FN_TXAPPAUTOCHECK (P_TXMSG      IN OUT TX.MSG_RECTYPE,
                                P_ERR_CODE   IN OUT VARCHAR2)
        RETURN NUMBER
    IS
        L_ALLOW             BOOLEAN;

        L_COREBANK          APPRULES.FIELD%TYPE;
        L_STATUS            APPRULES.FIELD%TYPE;
        L_CIMASTCHECK_ARR   TXPKS_CHECK.CIMASTCHECK_ARRTYPE;
    BEGIN
        PLOG.SETBEGINSECTION (PKGCTX, 'fn_txAppAutoCheck');

        IF P_TXMSG.DELTD = 'N'
        THEN
            IF TXPKS_CHECK.FN_AFTXMAPCHECK (P_TXMSG.TXFIELDS ('03').VALUE,
                                            'CIMAST',
                                            '03',
                                            '6640') <> 'TRUE'
            THEN
                P_ERR_CODE := ERRNUMS.C_SA_TLTX_NOT_ALLOW_BY_ACCTNO;
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END IF;

            L_CIMASTCHECK_ARR :=
                TXPKS_CHECK.FN_CIMASTCHECK (P_TXMSG.TXFIELDS ('03').VALUE,
                                            'CIMAST',
                                            'ACCTNO');

            L_STATUS := L_CIMASTCHECK_ARR (0).STATUS;
            L_COREBANK := L_CIMASTCHECK_ARR (0).COREBANK;

            IF NOT (INSTR ('A', L_STATUS) > 0)
            THEN
                P_ERR_CODE := '-400100';
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END IF;

            IF NOT (INSTR ('Y', L_COREBANK) > 0)
            THEN
                P_ERR_CODE := '-400111';
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END IF;
        END IF;

        PLOG.SETENDSECTION (PKGCTX, 'fn_txAppAutoCheck');
        RETURN SYSTEMNUMS.C_SUCCESS;
    EXCEPTION
        WHEN OTHERS
        THEN
            P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
            PLOG.ERROR (PKGCTX, SQLERRM);
            PLOG.SETENDSECTION (PKGCTX, 'fn_txAppAutoCheck');
            RAISE ERRNUMS.E_SYSTEM_ERROR;
    END FN_TXAPPAUTOCHECK;

    FUNCTION FN_TXAPPAUTOUPDATE (P_TXMSG      IN     TX.MSG_RECTYPE,
                                 P_ERR_CODE   IN OUT VARCHAR2)
        RETURN NUMBER
    IS
        L_TXDESC   VARCHAR2 (1000);
    BEGIN
        IF P_TXMSG.DELTD <> 'Y'
        THEN                                             -- Normal transaction
            INSERT INTO CITRAN (TXNUM,
                                TXDATE,
                                ACCTNO,
                                TXCD,
                                NAMT,
                                CAMT,
                                ACCTREF,
                                DELTD,
                                REF,
                                AUTOID,
                                TLTXCD,
                                BKDATE,
                                TRDESC)
              VALUES   (P_TXMSG.TXNUM,
                        TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                        P_TXMSG.TXFIELDS ('03').VALUE,
                        '0056',
                        ROUND (P_TXMSG.TXFIELDS ('10').VALUE, 0),
                        NULL,
                        '',
                        P_TXMSG.DELTD,
                        '',
                        SEQ_CITRAN.NEXTVAL,
                        P_TXMSG.TLTXCD,
                        P_TXMSG.BUSDATE,
                        '' || '' || '');



            UPDATE   CIMAST
               SET   PENDINGHOLD =
                         PENDINGHOLD
                         + (ROUND (P_TXMSG.TXFIELDS ('10').VALUE, 0)),
                     LASTDATE =
                         TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                     LAST_CHANGE = SYSTIMESTAMP
             WHERE   ACCTNO = P_TXMSG.TXFIELDS ('03').VALUE;
        ELSE                                                       -- Reversal
            UPDATE   TLLOG
               SET   DELTD = 'Y'
             WHERE   TXNUM = P_TXMSG.TXNUM
                     AND TXDATE =
                            TO_DATE (P_TXMSG.TXDATE,
                                     SYSTEMNUMS.C_DATE_FORMAT);

            UPDATE   CITRAN
               SET   DELTD = 'Y'
             WHERE   TXNUM = P_TXMSG.TXNUM
                     AND TXDATE =
                            TO_DATE (P_TXMSG.TXDATE,
                                     SYSTEMNUMS.C_DATE_FORMAT);



            UPDATE   CIMAST
               SET   PENDINGHOLD =
                         PENDINGHOLD
                         - (ROUND (P_TXMSG.TXFIELDS ('10').VALUE, 0)),
                     LASTDATE =
                         TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
                     LAST_CHANGE = SYSTIMESTAMP
             WHERE   ACCTNO = P_TXMSG.TXFIELDS ('03').VALUE;
        END IF;

        RETURN SYSTEMNUMS.C_SUCCESS;
    EXCEPTION
        WHEN OTHERS
        THEN
            P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
            PLOG.ERROR (PKGCTX, SQLERRM);
            PLOG.SETENDSECTION (PKGCTX, 'fn_txAppAutoUpdate');
            RAISE ERRNUMS.E_SYSTEM_ERROR;
    END FN_TXAPPAUTOUPDATE;

    FUNCTION FN_TXAPPUPDATE (P_TXMSG      IN     TX.MSG_RECTYPE,
                             P_ERR_CODE   IN OUT VARCHAR2)
        RETURN NUMBER
    IS
    BEGIN
        PLOG.SETBEGINSECTION (PKGCTX, 'fn_txAppUpdate');

        -- Run Pre Update
        IF TXPKS_#6640EX.FN_TXPREAPPUPDATE (P_TXMSG, P_ERR_CODE) <>
               SYSTEMNUMS.C_SUCCESS
        THEN
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        END IF;

        -- Run Auto Update
        IF FN_TXAPPAUTOUPDATE (P_TXMSG, P_ERR_CODE) <> SYSTEMNUMS.C_SUCCESS
        THEN
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        END IF;

        -- Run After Update
        IF TXPKS_#6640EX.FN_TXAFTAPPUPDATE (P_TXMSG, P_ERR_CODE) <>
               SYSTEMNUMS.C_SUCCESS
        THEN
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        END IF;

        PLOG.SETENDSECTION (PKGCTX, 'fn_txAppUpdate');
        RETURN SYSTEMNUMS.C_SUCCESS;
    EXCEPTION
        WHEN OTHERS
        THEN
            P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
            PLOG.ERROR (PKGCTX, SQLERRM);
            PLOG.SETENDSECTION (PKGCTX, 'fn_txAppUpdate');
            RAISE ERRNUMS.E_SYSTEM_ERROR;
    END FN_TXAPPUPDATE;

    FUNCTION FN_TXAPPCHECK (P_TXMSG      IN OUT TX.MSG_RECTYPE,
                            P_ERR_CODE      OUT VARCHAR2)
        RETURN NUMBER
    IS
    BEGIN
        PLOG.SETBEGINSECTION (PKGCTX, 'fn_txAppCheck');

        -- Run Pre check
        IF TXPKS_#6640EX.FN_TXPREAPPCHECK (P_TXMSG, P_ERR_CODE) <>
               SYSTEMNUMS.C_SUCCESS
        THEN
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        END IF;

        -- Run Auto check
        IF FN_TXAPPAUTOCHECK (P_TXMSG, P_ERR_CODE) <> SYSTEMNUMS.C_SUCCESS
        THEN
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        END IF;

        -- Run After check
        IF TXPKS_#6640EX.FN_TXAFTAPPCHECK (P_TXMSG, P_ERR_CODE) <>
               SYSTEMNUMS.C_SUCCESS
        THEN
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        END IF;

        PLOG.SETENDSECTION (PKGCTX, 'fn_txAppCheck');
        RETURN SYSTEMNUMS.C_SUCCESS;
    EXCEPTION
        WHEN OTHERS
        THEN
            P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
            PLOG.ERROR (PKGCTX, SQLERRM);
            PLOG.SETENDSECTION (PKGCTX, 'fn_txAppCheck');
            RETURN ERRNUMS.C_SYSTEM_ERROR;
    END FN_TXAPPCHECK;

    FUNCTION FN_TXPROCESS (P_XMLMSG      IN OUT VARCHAR2,
                           P_ERR_CODE    IN OUT VARCHAR2,
                           P_ERR_PARAM      OUT VARCHAR2)
        RETURN NUMBER
    IS
        L_RETURN_CODE   VARCHAR2 (30) := SYSTEMNUMS.C_SUCCESS;
        L_TXMSG         TX.MSG_RECTYPE;
        L_COUNT         NUMBER (3);
        L_APPROVE       BOOLEAN := FALSE;
        L_STATUS        VARCHAR2 (1);
    BEGIN
        PLOG.SETBEGINSECTION (PKGCTX, 'fn_txProcess');

        SELECT   COUNT ( * )
          INTO   L_COUNT
          FROM   SYSVAR
         WHERE       GRNAME = 'SYSTEM'
                 AND VARNAME = 'HOSTATUS'
                 AND VARVALUE = SYSTEMNUMS.C_OPERATION_ACTIVE;

        IF L_COUNT = 0
        THEN
            --RETURN errnums.C_HOST_OPERATION_ISINACTIVE;
           p_err_code := errnums.C_HOST_OPERATION_ISINACTIVE;
           plog.setendsection (pkgctx, 'fn_txProcess');
           RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        PLOG.DEBUG (PKGCTX, 'xml2obj');
        L_TXMSG := TXPKS_MSG.FN_XML2OBJ (P_XMLMSG);
        L_COUNT := 0;                                         -- reset counter

        SELECT   COUNT ( * )
          INTO   L_COUNT
          FROM   SYSVAR
         WHERE   GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE'
                 AND TO_DATE (VARVALUE, SYSTEMNUMS.C_DATE_FORMAT) =
                        L_TXMSG.TXDATE;

        IF L_COUNT = 0
        THEN
            RETURN ERRNUMS.C_BRANCHDATE_INVALID;
        END IF;

        PLOG.DEBUG (PKGCTX, 'l_txmsg.txaction: ' || L_TXMSG.TXACTION);
        L_STATUS := L_TXMSG.TXSTATUS;

        -- <<BEGIN OF PROCESSING A TRANSACTION>>
        IF L_TXMSG.DELTD <> TXNUMS.C_DELTD_TXDELETED
           AND L_TXMSG.TXSTATUS = TXSTATUSNUMS.C_TXDELETING
        THEN
            TXPKS_TXLOG.PR_UPDATE_STATUS (L_TXMSG);

            IF NVL (L_TXMSG.OVRRQD, '$X$') <> '$X$'
               AND LENGTH (L_TXMSG.OVRRQD) > 0
            THEN
                IF L_TXMSG.OVRRQD <> ERRNUMS.C_CHECKER_CONTROL
                THEN
                    P_ERR_CODE := ERRNUMS.C_CHECKER1_REQUIRED;
                ELSE
                    P_ERR_CODE := ERRNUMS.C_CHECKER2_REQUIRED;
                END IF;

                RETURN L_RETURN_CODE;
            END IF;
        END IF;

        IF L_TXMSG.DELTD = TXNUMS.C_DELTD_TXDELETED
           AND L_TXMSG.TXSTATUS = TXSTATUSNUMS.C_TXCOMPLETED
        THEN
            -- if Refuse a delete tx then update tx status
            TXPKS_TXLOG.PR_UPDATE_STATUS (L_TXMSG);
            RETURN L_RETURN_CODE;
        END IF;

        IF L_TXMSG.DELTD <> TXNUMS.C_DELTD_TXDELETED
        THEN
            PLOG.DEBUG (PKGCTX, '<<BEGIN PROCESS NORMAL TX>>');
            PLOG.DEBUG (PKGCTX, 'l_txmsg.pretran: ' || L_TXMSG.PRETRAN);

            IF L_TXMSG.PRETRAN = 'Y'
            THEN
                IF FN_TXAPPCHECK (L_TXMSG, P_ERR_CODE) <>
                       SYSTEMNUMS.C_SUCCESS
                THEN
                    RAISE ERRNUMS.E_BIZ_RULE_INVALID;
                END IF;

                PR_PRINTINFO (L_TXMSG, P_ERR_CODE);

                IF NVL (L_TXMSG.OVRRQD, '$X$') <> '$X$'
                   AND LENGTH (L_TXMSG.OVRRQD) > 0
                THEN
                    IF L_TXMSG.OVRRQD <> ERRNUMS.C_CHECKER_CONTROL
                    THEN
                        P_ERR_CODE := ERRNUMS.C_CHECKER1_REQUIRED;
                    ELSE
                        P_ERR_CODE := ERRNUMS.C_CHECKER2_REQUIRED;
                    END IF;
                END IF;

                IF LENGTH(TRIM(REPLACE (L_TXMSG.OVRRQD,
                                        ERRNUMS.C_CHECKER_CONTROL,
                                        ''))) > 0
                   AND (NVL (L_TXMSG.CHKID, '$NULL$') = '$NULL$'
                        OR LENGTH (L_TXMSG.CHKID) = 0)
                THEN
                    P_ERR_CODE := ERRNUMS.C_CHECKER1_REQUIRED;
                ELSE
                    IF INSTR (L_TXMSG.OVRRQD, ERRNUMS.OVRRQS_CHECKER_CONTROL) >
                           0
                       AND (NVL (L_TXMSG.OFFID, '$NULL$') = '$NULL$'
                            OR LENGTH (L_TXMSG.OFFID) = 0)
                    THEN
                        P_ERR_CODE := ERRNUMS.C_CHECKER2_REQUIRED;
                    ELSE
                        P_ERR_CODE := SYSTEMNUMS.C_SUCCESS;
                    END IF;
                END IF;
            ELSE                                                 --pretran='N'
                PLOG.DEBUG (PKGCTX, 'l_txmsg.nosubmit: ' || L_TXMSG.NOSUBMIT);

                IF L_TXMSG.NOSUBMIT = '1'
                THEN
                    IF FN_TXAPPCHECK (L_TXMSG, P_ERR_CODE) <>
                           SYSTEMNUMS.C_SUCCESS
                    THEN
                        RAISE ERRNUMS.E_BIZ_RULE_INVALID;
                    END IF;

                    IF NVL (L_TXMSG.OVRRQD, '$X$') <> '$X$'
                       AND LENGTH (L_TXMSG.OVRRQD) > 0
                    THEN
                        IF L_TXMSG.OVRRQD <> ERRNUMS.C_CHECKER_CONTROL
                        THEN
                            P_ERR_CODE := ERRNUMS.C_CHECKER1_REQUIRED;
                        ELSE
                            P_ERR_CODE := ERRNUMS.C_CHECKER2_REQUIRED;
                        END IF;
                    END IF;

                    IF LENGTH(TRIM(REPLACE (L_TXMSG.OVRRQD,
                                            ERRNUMS.C_CHECKER_CONTROL,
                                            ''))) > 0
                       AND (NVL (L_TXMSG.CHKID, '$NULL$') = '$NULL$'
                            OR LENGTH (L_TXMSG.CHKID) = 0)
                    THEN
                        P_ERR_CODE := ERRNUMS.C_CHECKER1_REQUIRED;
                    ELSE
                        IF INSTR (L_TXMSG.OVRRQD,
                                  ERRNUMS.OVRRQS_CHECKER_CONTROL) > 0
                           AND (NVL (L_TXMSG.OFFID, '$NULL$') = '$NULL$'
                                OR LENGTH (L_TXMSG.OFFID) = 0)
                        THEN
                            P_ERR_CODE := ERRNUMS.C_CHECKER2_REQUIRED;
                        ELSE
                            L_RETURN_CODE := SYSTEMNUMS.C_SUCCESS;
                        END IF;
                    END IF;
                END IF;                                   -- END OF NOSUBMIT=1

                PLOG.DEBUG (PKGCTX, 'l_return_code: ' || L_RETURN_CODE);

                IF L_RETURN_CODE = SYSTEMNUMS.C_SUCCESS
                THEN
                    IF NVL (L_TXMSG.OVRRQD, '$X$') = '$X$'
                       OR LENGTH (L_TXMSG.OVRRQD) = 0
                       OR (INSTR (L_TXMSG.OVRRQD, ERRNUMS.C_OFFID_REQUIRED) >
                               0
                           AND LENGTH (L_TXMSG.OFFID) > 0)
                       OR (LENGTH(REPLACE (L_TXMSG.OVRRQD,
                                           ERRNUMS.C_OFFID_REQUIRED,
                                           '')) > 0
                           AND LENGTH (L_TXMSG.CHKID) > 0)
                    THEN
                        L_APPROVE := TRUE;
                    END IF;

                    PLOG.DEBUG (
                        PKGCTX,
                        'l_txmsg.ovrrqd: ' || NVL (L_TXMSG.OVRRQD, '$NULL$'));
                    PLOG.DEBUG (
                        PKGCTX,
                        'l_approve,txstatus: '
                        || CASE
                               WHEN L_APPROVE = TRUE THEN 'TRUE'
                               ELSE 'FALSE'
                           END
                        || ','
                        || L_TXMSG.TXSTATUS);

                    IF L_APPROVE = TRUE
                       AND (L_TXMSG.TXSTATUS = TXSTATUSNUMS.C_TXLOGGED
                            OR L_TXMSG.TXSTATUS = TXSTATUSNUMS.C_TXPENDING)
                    THEN
                        IF FN_TXAPPCHECK (L_TXMSG, P_ERR_CODE) <>
                               SYSTEMNUMS.C_SUCCESS
                        THEN
                            RAISE ERRNUMS.E_BIZ_RULE_INVALID;
                        END IF;

                        IF NVL (L_TXMSG.OVRRQD, '$NULL$') <> '$NULL$'
                           AND LENGTH (L_TXMSG.OVRRQD) > 0
                        THEN
                            IF L_TXMSG.OVRRQD <> ERRNUMS.C_CHECKER_CONTROL
                            THEN
                                P_ERR_CODE := ERRNUMS.C_CHECKER1_REQUIRED;
                            ELSE
                                P_ERR_CODE := ERRNUMS.C_CHECKER2_REQUIRED;
                            END IF;
                        END IF;

                        L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;

                        IF FN_TXAPPUPDATE (L_TXMSG, P_ERR_CODE) <>
                               SYSTEMNUMS.C_SUCCESS
                        THEN
                            RAISE ERRNUMS.E_BIZ_RULE_INVALID;
                        END IF;

                        PR_TXLOG (L_TXMSG, P_ERR_CODE);
                    END IF;                             -- END IF APPROVE=TRUE
                END IF;                                  -- end of return_code
            END IF;                               --<<END OF PROCESS PRETRAN>>
        ELSE                                                    -- DELETING TX
            -- <<BEGIN OF DELETING A TRANSACTION>>
            -- This kind of tx has not yet updated mast table in the host
            -- Only need update tllog status
            IF FN_TXAPPUPDATE (L_TXMSG, P_ERR_CODE) <> SYSTEMNUMS.C_SUCCESS
            THEN
                RAISE ERRNUMS.E_BIZ_RULE_INVALID;
            END IF;
        -- <<END OF DELETING A TRANSACTION>>
        END IF;

        PLOG.DEBUG (PKGCTX, 'obj2xml');
        P_XMLMSG := TXPKS_MSG.FN_OBJ2XML (L_TXMSG);
        PLOG.SETENDSECTION (PKGCTX, 'fn_txProcess');
        RETURN L_RETURN_CODE;
    EXCEPTION
        WHEN ERRNUMS.E_BIZ_RULE_INVALID
        THEN
            FOR I IN (SELECT   ERRDESC, EN_ERRDESC
                        FROM   DEFERROR
                       WHERE   ERRNUM = P_ERR_CODE)
            LOOP
                P_ERR_PARAM := I.ERRDESC;
            END LOOP;

            L_TXMSG.TXEXCEPTION ('ERRSOURCE').VALUE := '';
            L_TXMSG.TXEXCEPTION ('ERRSOURCE').TYPE := 'System.String';
            L_TXMSG.TXEXCEPTION ('ERRCODE').VALUE := P_ERR_CODE;
            L_TXMSG.TXEXCEPTION ('ERRCODE').TYPE := 'System.Int64';
            L_TXMSG.TXEXCEPTION ('ERRMSG').VALUE := P_ERR_PARAM;
            L_TXMSG.TXEXCEPTION ('ERRMSG').TYPE := 'System.String';
            P_XMLMSG := TXPKS_MSG.FN_OBJ2XML (L_TXMSG);
            PLOG.SETENDSECTION (PKGCTX, 'fn_txProcess');
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        WHEN OTHERS
        THEN
            P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
            P_ERR_PARAM := 'SYSTEM_ERROR';
            PLOG.ERROR (PKGCTX, SQLERRM);
            L_TXMSG.TXEXCEPTION ('ERRSOURCE').VALUE := '';
            L_TXMSG.TXEXCEPTION ('ERRSOURCE').TYPE := 'System.String';
            L_TXMSG.TXEXCEPTION ('ERRCODE').VALUE := P_ERR_CODE;
            L_TXMSG.TXEXCEPTION ('ERRCODE').TYPE := 'System.Int64';
            L_TXMSG.TXEXCEPTION ('ERRMSG').VALUE := P_ERR_PARAM;
            L_TXMSG.TXEXCEPTION ('ERRMSG').TYPE := 'System.String';
            P_XMLMSG := TXPKS_MSG.FN_OBJ2XML (L_TXMSG);
            PLOG.SETENDSECTION (PKGCTX, 'fn_txProcess');
            RETURN ERRNUMS.C_SYSTEM_ERROR;
    END FN_TXPROCESS;

    FUNCTION FN_AUTOTXPROCESS (P_TXMSG       IN OUT TX.MSG_RECTYPE,
                               P_ERR_CODE    IN OUT VARCHAR2,
                               P_ERR_PARAM      OUT VARCHAR2)
        RETURN NUMBER
    IS
        L_RETURN_CODE   VARCHAR2 (30) := SYSTEMNUMS.C_SUCCESS;
    BEGIN
        PLOG.SETBEGINSECTION (PKGCTX, 'fn_AutoTxProcess');

        IF FN_TXAPPCHECK (P_TXMSG, P_ERR_CODE) <> SYSTEMNUMS.C_SUCCESS
        THEN
            RAISE ERRNUMS.E_BIZ_RULE_INVALID;
        END IF;

        IF FN_TXAPPUPDATE (P_TXMSG, P_ERR_CODE) <> SYSTEMNUMS.C_SUCCESS
        THEN
            RAISE ERRNUMS.E_BIZ_RULE_INVALID;
        END IF;

        IF P_TXMSG.DELTD <> 'Y'
        THEN                                             -- Normal transaction
            PR_TXLOG (P_TXMSG, P_ERR_CODE);
        ELSE                                             -- Delete transaction
            TXPKS_TXLOG.PR_TXDELLOG (P_TXMSG, P_ERR_CODE);
        END IF;

        PLOG.SETENDSECTION (PKGCTX, 'fn_AutoTxProcess');
        RETURN L_RETURN_CODE;
    EXCEPTION
        WHEN ERRNUMS.E_BIZ_RULE_INVALID
        THEN
            FOR I IN (SELECT   ERRDESC, EN_ERRDESC
                        FROM   DEFERROR
                       WHERE   ERRNUM = P_ERR_CODE)
            LOOP
                P_ERR_PARAM := I.ERRDESC;
            END LOOP;

            PLOG.SETENDSECTION (PKGCTX, 'fn_AutoTxProcess');
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        WHEN OTHERS
        THEN
            P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
            P_ERR_PARAM := 'SYSTEM_ERROR';
            PLOG.ERROR (PKGCTX, SQLERRM);
            PLOG.SETENDSECTION (PKGCTX, 'fn_AutoTxProcess');
            RETURN ERRNUMS.C_SYSTEM_ERROR;
    END FN_AUTOTXPROCESS;

    FUNCTION FN_BATCHTXPROCESS (P_TXMSG       IN OUT TX.MSG_RECTYPE,
                                P_ERR_CODE    IN OUT VARCHAR2,
                                P_ERR_PARAM      OUT VARCHAR2)
        RETURN NUMBER
    IS
        L_RETURN_CODE   VARCHAR2 (30) := SYSTEMNUMS.C_SUCCESS;
    BEGIN
        PLOG.SETBEGINSECTION (PKGCTX, 'fn_BatchTxProcess');

        IF FN_TXAPPCHECK (P_TXMSG, P_ERR_CODE) <> SYSTEMNUMS.C_SUCCESS
        THEN
            RAISE ERRNUMS.E_BIZ_RULE_INVALID;
        END IF;

        IF FN_TXAPPUPDATE (P_TXMSG, P_ERR_CODE) <> SYSTEMNUMS.C_SUCCESS
        THEN
            RAISE ERRNUMS.E_BIZ_RULE_INVALID;
        END IF;

        /* IF fn_txAutoPostmap(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
              RAISE errnums.E_BIZ_RULE_INVALID;
         END IF; */
        IF P_TXMSG.DELTD <> 'Y'
        THEN                                             -- Normal transaction
            PR_TXLOG (P_TXMSG, P_ERR_CODE);
        ELSE                                             -- Delete transaction
            TXPKS_TXLOG.PR_TXDELLOG (P_TXMSG, P_ERR_CODE);
        END IF;

        PLOG.SETENDSECTION (PKGCTX, 'fn_BatchTxProcess');
        RETURN L_RETURN_CODE;
    EXCEPTION
        WHEN ERRNUMS.E_BIZ_RULE_INVALID
        THEN
            FOR I IN (SELECT   ERRDESC, EN_ERRDESC
                        FROM   DEFERROR
                       WHERE   ERRNUM = P_ERR_CODE)
            LOOP
                P_ERR_PARAM := I.ERRDESC;
            END LOOP;

            PLOG.SETENDSECTION (PKGCTX, 'fn_BatchTxProcess');
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        WHEN OTHERS
        THEN
            P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
            P_ERR_PARAM := 'SYSTEM_ERROR';
            PLOG.ERROR (PKGCTX, SQLERRM);
            PLOG.SETENDSECTION (PKGCTX, 'fn_BatchTxProcess');
            RETURN ERRNUMS.C_SYSTEM_ERROR;
    END FN_BATCHTXPROCESS;

    FUNCTION FN_TXREVERT (P_TXNUM              VARCHAR2,
                          P_TXDATE             VARCHAR2,
                          P_ERR_CODE    IN OUT VARCHAR2,
                          P_ERR_PARAM      OUT VARCHAR2)
        RETURN NUMBER
    IS
        L_TXMSG         TX.MSG_RECTYPE;
        L_ERR_PARAM     VARCHAR2 (300);
        L_TLLOG         TX.TLLOG_RECTYPE;
        L_FLDNAME       VARCHAR2 (100);
        L_DEFNAME       VARCHAR2 (100);
        L_FLDTYPE       CHAR (1);
        L_RETURN        NUMBER (20, 0);
        PV_REFCURSOR    PKG_REPORT.REF_CURSOR;
        L_RETURN_CODE   VARCHAR2 (30) := SYSTEMNUMS.C_SUCCESS;
    BEGIN
        PLOG.SETBEGINSECTION (PKGCTX, 'fn_txrevert');

        OPEN PV_REFCURSOR FOR
            SELECT   *
              FROM   TLLOG
             WHERE   TXNUM = P_TXNUM
                     AND TXDATE =
                            TO_DATE (P_TXDATE, SYSTEMNUMS.C_DATE_FORMAT);

        LOOP
            FETCH PV_REFCURSOR INTO L_TLLOG;

            EXIT WHEN PV_REFCURSOR%NOTFOUND;

            IF L_TLLOG.DELTD = 'Y'
            THEN
                P_ERR_CODE := ERRNUMS.C_SA_CANNOT_DELETETRANSACTION;
                RETURN ERRNUMS.C_SYSTEM_ERROR;
            END IF;

            L_TXMSG.MSGTYPE := 'T';
            L_TXMSG.LOCAL := 'N';
            L_TXMSG.TLID := L_TLLOG.TLID;
            L_TXMSG.OFF_LINE := L_TLLOG.OFF_LINE;
            L_TXMSG.DELTD := TXNUMS.C_DELTD_TXDELETED;
            L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;
            L_TXMSG.MSGSTS := '0';
            L_TXMSG.OVRSTS := '0';
            L_TXMSG.BATCHNAME := 'DEL';
            L_TXMSG.TXDATE :=
                TO_DATE (L_TLLOG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT);
            L_TXMSG.BUSDATE :=
                TO_DATE (L_TLLOG.BUSDATE, SYSTEMNUMS.C_DATE_FORMAT);
            L_TXMSG.TXNUM := L_TLLOG.TXNUM;
            L_TXMSG.TLTXCD := L_TLLOG.TLTXCD;
            L_TXMSG.BRID := L_TLLOG.BRID;

            FOR REC
            IN (SELECT   *
                  FROM   TLLOGFLD
                 WHERE   TXNUM = P_TXNUM
                         AND TXDATE =
                                TO_DATE (P_TXDATE, SYSTEMNUMS.C_DATE_FORMAT))
            LOOP
                BEGIN
                    SELECT   FLDNAME, DEFNAME, FLDTYPE
                      INTO   L_FLDNAME, L_DEFNAME, L_FLDTYPE
                      FROM   FLDMASTER
                     WHERE   OBJNAME = L_TLLOG.TLTXCD AND FLDNAME = REC.FLDCD;

                    L_TXMSG.TXFIELDS (L_FLDNAME).DEFNAME := L_DEFNAME;
                    L_TXMSG.TXFIELDS (L_FLDNAME).TYPE := L_FLDTYPE;

                    IF L_FLDTYPE = 'C'
                    THEN
                        L_TXMSG.TXFIELDS (L_FLDNAME).VALUE := REC.CVALUE;
                    ELSIF L_FLDTYPE = 'N'
                    THEN
                        L_TXMSG.TXFIELDS (L_FLDNAME).VALUE := REC.NVALUE;
                    ELSE
                        L_TXMSG.TXFIELDS (L_FLDNAME).VALUE := REC.CVALUE;
                    END IF;

                    PLOG.DEBUG (
                        PKGCTX,
                           'field: '
                        || L_FLDNAME
                        || ' value:'
                        || TO_CHAR (L_TXMSG.TXFIELDS (L_FLDNAME).VALUE));
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        L_ERR_PARAM := 0;
                END;
            END LOOP;

            IF TXPKS_#6640.FN_AUTOTXPROCESS (L_TXMSG,
                                             P_ERR_CODE,
                                             P_ERR_PARAM) <>
                   SYSTEMNUMS.C_SUCCESS
            THEN
                PLOG.DEBUG (PKGCTX, 'got error 6640: ' || P_ERR_CODE);
                ROLLBACK;
                RETURN ERRNUMS.C_SYSTEM_ERROR;
            END IF;

            P_ERR_CODE := 0;
            RETURN 0;
            P_ERR_CODE := ERRNUMS.C_HOST_VOUCHER_NOT_FOUND;
            RETURN ERRNUMS.C_SYSTEM_ERROR;
        END LOOP;

        P_ERR_CODE := ERRNUMS.C_HOST_VOUCHER_NOT_FOUND;
        RETURN ERRNUMS.C_SYSTEM_ERROR;
        PLOG.SETENDSECTION (PKGCTX, 'fn_txrevert');
        RETURN L_RETURN_CODE;
    EXCEPTION
        WHEN ERRNUMS.E_BIZ_RULE_INVALID
        THEN
            FOR I IN (SELECT   ERRDESC, EN_ERRDESC
                        FROM   DEFERROR
                       WHERE   ERRNUM = P_ERR_CODE)
            LOOP
                P_ERR_PARAM := I.ERRDESC;
            END LOOP;

            PLOG.SETENDSECTION (PKGCTX, 'fn_txrevert');
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        WHEN OTHERS
        THEN
            P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
            P_ERR_PARAM := 'SYSTEM_ERROR';
            PLOG.ERROR (PKGCTX, SQLERRM);
            PLOG.SETENDSECTION (PKGCTX, 'fn_txrevert');
            RETURN ERRNUMS.C_SYSTEM_ERROR;
    END FN_TXREVERT;
BEGIN
    FOR I IN (SELECT   * FROM TLOGDEBUG)
    LOOP
        LOGROW.LOGLEVEL := I.LOGLEVEL;
        LOGROW.LOG4TABLE := I.LOG4TABLE;
        LOGROW.LOG4ALERT := I.LOG4ALERT;
        LOGROW.LOG4TRACE := I.LOG4TRACE;
    END LOOP;

    PKGCTX :=
        PLOG.INIT ('txpks_#6640',
                   PLEVEL      => NVL (LOGROW.LOGLEVEL, 30),
                   PLOGTABLE   => (NVL (LOGROW.LOG4TABLE, 'N') = 'Y'),
                   PALERT      => (NVL (LOGROW.LOG4ALERT, 'N') = 'Y'),
                   PTRACE      => (NVL (LOGROW.LOG4TRACE, 'N') = 'Y'));
END TXPKS_#6640;
/

