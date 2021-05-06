CREATE OR REPLACE PACKAGE txpks_#0088ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0088EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      16/09/2011     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
 IS
  FUNCTION FN_TXPREAPPCHECK(P_TXMSG    IN OUT TX.MSG_RECTYPE,
                            P_ERR_CODE OUT VARCHAR2) RETURN NUMBER;
  FUNCTION FN_TXAFTAPPCHECK(P_TXMSG    IN TX.MSG_RECTYPE,
                            P_ERR_CODE OUT VARCHAR2) RETURN NUMBER;
  FUNCTION FN_TXPREAPPUPDATE(P_TXMSG    IN TX.MSG_RECTYPE,
                             P_ERR_CODE OUT VARCHAR2) RETURN NUMBER;
  FUNCTION FN_TXAFTAPPUPDATE(P_TXMSG    IN TX.MSG_RECTYPE,
                             P_ERR_CODE OUT VARCHAR2) RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY txpks_#0088ex IS
  PKGCTX PLOG.LOG_CTX;
  LOGROW TLOGDEBUG%ROWTYPE;

  C_ACCTNO       CONSTANT CHAR(2) := '03';
  C_NAME         CONSTANT CHAR(2) := '31';
  C_IDCODE       CONSTANT CHAR(2) := '32';
  C_BALANCE      CONSTANT CHAR(2) := '10';
  C_CRINTACR     CONSTANT CHAR(2) := '04';
  C_ODAMT        CONSTANT CHAR(2) := '06';
  C_ODINTACR     CONSTANT CHAR(2) := '05';
  C_CIWITHDRAWAL CONSTANT CHAR(2) := '07';
  C_BLOCKED      CONSTANT CHAR(2) := '08';
  C_WITHDRAW     CONSTANT CHAR(2) := '09';
  C_DEPOSIT      CONSTANT CHAR(2) := '11';
  C_MRCRLIMITMAX CONSTANT CHAR(2) := '12';
  C_MRCRLIMIT    CONSTANT CHAR(2) := '13';
  C_T0AMT        CONSTANT CHAR(2) := '14';
  C_CA_QTTY      CONSTANT CHAR(2) := '15';
  C_GROUPLEADER  CONSTANT CHAR(2) := '16';
  C_CIDEPOFEEACR CONSTANT CHAR(2) := '66';
  C_DATEFEEAC    CONSTANT CHAR(2) := '18';
  C_CIDATEFEEACR CONSTANT CHAR(2) := '17';
  C_CHK_QTTY     CONSTANT CHAR(2) := '67';
  C_TRFEE        CONSTANT CHAR(2) := '68';
  C_DESC         CONSTANT CHAR(2) := '30';

  FUNCTION FN_TXPREAPPCHECK(P_TXMSG    IN OUT TX.MSG_RECTYPE,
                            P_ERR_CODE OUT VARCHAR2) RETURN NUMBER IS
    V_NUMBER     NUMBER;
    V_AAMT       NUMBER;
    V_RAMT       NUMBER;
    V_BAMT       NUMBER;
    V_NAMT       NUMBER;
    V_EMKAMT     NUMBER;
    V_MMARGINBAL NUMBER;
    V_MARGINBAL  NUMBER;
    V_AUTOADV    VARCHAR2(2);
    V_TRFBUYAMT  NUMBER;

    V_MORTAGE     NUMBER;
    V_MARGIN      NUMBER;
    V_NETTING     NUMBER;
    V_STADING     NUMBER;
    V_SECURED     NUMBER;
    V_RECEIVING   NUMBER;
    V_WITHDRAW    NUMBER;
    V_SENDDEPOSIT NUMBER;
    V_DEPOSIT     NUMBER;
    V_LOAN        NUMBER;
    V_BLOCKED     NUMBER;
    V_REPO        NUMBER;
    V_PENDING     NUMBER;
    V_TRANSFER    NUMBER;

    V_STATUS VARCHAR2(10);
    V_SUMSE  NUMBER;
    V_SUMCI  NUMBER;
    V_COUNT  NUMBER;

    V_MRTYPE    VARCHAR2(10);
    V_MRSTATUS  VARCHAR2(10);
    V_ODAMT     NUMBER;
    V_AFCOUNT   NUMBER;
    V_LIMITMAX  NUMBER;
    V_AFCOUNTT0 NUMBER;
    V_AFCOUNTT1 NUMBER;
    V_ACCNUM    NUMBER;
    --
    V_OUTSTANDING  NUMBER;
    V_MRCRLIMITMAX NUMBER;
    V_MRCRLIMIT    NUMBER;
    V_T0AMT        NUMBER;
    V_CHK_QTTY     NUMBER;
    V_STANDING     NUMBER;
    V_DF_QTTY      NUMBER;

    L_LEADER_LICENSE   VARCHAR2(100);
    L_LEADER_IDEXPIRED DATE;
    L_IDEXPDAYS        APPRULES.FIELD%TYPE;
    L_AFMASTCHECK_ARR  TXPKS_CHECK.AFMASTCHECK_ARRTYPE;
  BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'fn_txPreAppCheck');
    PLOG.DEBUG(PKGCTX, 'BEGIN OF fn_txPreAppCheck');
    /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    -- Neu la tk cuoi cung con chung khoan thi bat phai nhap so TVLK, ma ck nguoi nhan
    IF (P_TXMSG.TXFIELDS('45').VALUE = 'Y') THEN
      IF ((LENGTH(NVL(P_TXMSG.TXFIELDS('48').VALUE, 'a')) < 3) OR
         (LENGTH(NVL(P_TXMSG.TXFIELDS('47').VALUE, 'a')) < 10)) THEN
        P_ERR_CODE := '-260163';
        PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
        RETURN ERRNUMS.C_BIZ_RULE_INVALID;
      END IF;
    END IF;

    BEGIN
      SELECT IDCODE, IDEXPIRED
        INTO L_LEADER_LICENSE, L_LEADER_IDEXPIRED
        FROM CFMAST CF, AFMAST AF
       WHERE CF.CUSTID = AF.CUSTID
         AND AF.ACCTNO = P_TXMSG.TXFIELDS(C_ACCTNO).VALUE;
    EXCEPTION
      WHEN OTHERS THEN
        P_ERR_CODE := '-900096';
        PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
        RETURN ERRNUMS.C_BIZ_RULE_INVALID;
    END;

    IF L_LEADER_IDEXPIRED < P_TXMSG.TXDATE THEN
      --leader expired
      P_TXMSG.TXWARNINGEXCEPTION('-2002081').VALUE := CSPKS_SYSTEM.FN_GET_ERRMSG('-200208');
      P_TXMSG.TXWARNINGEXCEPTION('-2002081').ERRLEV := '1';
    END IF;

    BEGIN
      /* Check CI,SE*/

      BEGIN
        SELECT EMKAMT,
               OUTSTANDING,
               MRCRLIMITMAX,
               MRCRLIMIT,
               T0AMT,
               (NB_CHK_QTTY + NS_CHK_QTTY) CHK_QTTY,
               BLOCKED,
               DF_QTTY,
               STANDING
          INTO V_EMKAMT,
               V_OUTSTANDING,
               V_MRCRLIMITMAX,
               V_MRCRLIMIT,
               V_T0AMT,
               V_CHK_QTTY,
               V_BLOCKED,
               V_DF_QTTY,
               V_STANDING
          FROM VW_AFMAST_FOR_CLOSE_ACCOUNT
         WHERE AFACCTNO = P_TXMSG.TXFIELDS('03').VALUE;
      EXCEPTION
        WHEN OTHERS THEN
          V_EMKAMT       := 0;
          V_OUTSTANDING  := 0;
          V_MRCRLIMITMAX := 0;
          V_MRCRLIMIT    := 0;
          V_T0AMT        := 0;
          V_CHK_QTTY     := 0;
          V_BLOCKED      := 0;
          V_DF_QTTY      := 0;
          V_STANDING     := 0;

      END;

      IF V_EMKAMT <> 0 THEN
        P_ERR_CODE := '-400205';
        PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
        RETURN ERRNUMS.C_BIZ_RULE_INVALID;
      END IF;

      IF V_OUTSTANDING <> 0 THEN
        P_ERR_CODE := '-400206';
        PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
        RETURN ERRNUMS.C_BIZ_RULE_INVALID;
      END IF;

      IF V_STANDING <> 0 THEN
        P_ERR_CODE := '-260156';
        PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
        RETURN ERRNUMS.C_BIZ_RULE_INVALID;
      END IF;

      IF V_MRCRLIMITMAX <> 0 THEN
        P_ERR_CODE := '-400207';
        PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
        RETURN ERRNUMS.C_BIZ_RULE_INVALID;
      END IF;

      IF V_MRCRLIMIT <> 0 THEN
        P_ERR_CODE := '-260157';
        PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
        RETURN ERRNUMS.C_BIZ_RULE_INVALID;
      END IF;

      IF V_T0AMT <> 0 THEN
        P_ERR_CODE := '-400208';
        PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
        RETURN ERRNUMS.C_BIZ_RULE_INVALID;
      END IF;

      IF V_CHK_QTTY <> 0 THEN
        P_ERR_CODE := '-260158';
        PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
        RETURN ERRNUMS.C_BIZ_RULE_INVALID;
      END IF;

      IF V_BLOCKED <> 0 THEN
        P_ERR_CODE := '-260159';
        PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
        RETURN ERRNUMS.C_BIZ_RULE_INVALID;
      END IF;

      IF V_DF_QTTY <> 0 THEN
        P_ERR_CODE := '-260160';
        PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
        RETURN ERRNUMS.C_BIZ_RULE_INVALID;
      END IF;
      BEGIN
        SELECT SUMCI, SUMSE, AF.STATUS
          INTO V_SUMCI, V_SUMSE, V_STATUS
          FROM (SELECT (ROUND(AAMT, 0) + ROUND(RAMT, 0) + ROUND(BAMT, 0) +
                       ROUND(NAMT, 0) + ROUND(MMARGINBAL, 0) +
                       ROUND(MARGINBAL, 0)) SUMCI
                  FROM CIMAST
                 WHERE AFACCTNO = P_TXMSG.TXFIELDS('03').VALUE) CI,
               (SELECT SUM(ROUND(MORTAGE, 0) + ROUND(MARGIN, 0) +
                           ROUND(NETTING, 0) + ROUND(STANDING, 0) +
                           ROUND(SECURED, 0) + ROUND(WITHDRAW, 0) /*+ROUND(DEPOSIT,0)*/
                           +ROUND(LOAN, 0) + ROUND(REPO, 0) +
                           ROUND(PENDING, 0) + ROUND(TRANSFER, 0)) SUMSE
                  FROM SEMAST
                 WHERE AFACCTNO = P_TXMSG.TXFIELDS('03').VALUE) SE,
               AFMAST AF
         WHERE ACCTNO = P_TXMSG.TXFIELDS('03').VALUE;
      EXCEPTION
        WHEN OTHERS THEN
          V_SUMCI  := 0;
          V_SUMSE  := 0;
          V_STATUS := 'A';
      END;

      /*  if  v_sumci>=100 then
          p_err_code:='-200033';
          plog.setendsection(pkgctx, 'fn_txPreAppCheck');
          RETURN errnums.C_BIZ_RULE_INVALID;
      end if;*/

      -- check xem co tieu khoan co ton tai khong
      BEGIN
        SELECT COUNT(1)
          INTO V_COUNT
          FROM (SELECT (ROUND(AAMT, 0) + ROUND(RAMT, 0) + ROUND(BAMT, 0) +
                       ROUND(NAMT, 0) + ROUND(MMARGINBAL, 0) +
                       ROUND(MARGINBAL, 0)) SUMCI
                  FROM CIMAST
                 WHERE AFACCTNO = P_TXMSG.TXFIELDS('03').VALUE) CI,
               (SELECT SUM(ROUND(MORTAGE, 0) + ROUND(MARGIN, 0) +
                           ROUND(NETTING, 0) + ROUND(STANDING, 0) +
                           ROUND(SECURED, 0) + ROUND(WITHDRAW, 0) +
                           ROUND(DEPOSIT, 0) + ROUND(LOAN, 0) +
                           ROUND(REPO, 0) + ROUND(PENDING, 0) +
                           ROUND(TRANSFER, 0)) SUMSE
                  FROM SEMAST
                 WHERE AFACCTNO = P_TXMSG.TXFIELDS('03').VALUE) SE,
               AFMAST AF
         WHERE ACCTNO = P_TXMSG.TXFIELDS('03').VALUE;
      EXCEPTION
        WHEN OTHERS THEN
          V_COUNT := 1;
      END;
      IF V_COUNT <= 0 THEN
        P_ERR_CODE := '-200012';
        PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
        RETURN ERRNUMS.C_BIZ_RULE_INVALID;
      END IF;
    END;
    /* end  Check CI,SE*/

    /* Neu la hop dong margin thi check*/
    BEGIN
      BEGIN
        SELECT MR.MRTYPE MRTYPE
          INTO V_MRTYPE
          FROM AFMAST AF, AFTYPE A, MRTYPE MR
         WHERE AF.ACTYPE = A.ACTYPE
           AND A.MRTYPE = MR.ACTYPE
           AND ACCTNO = P_TXMSG.TXFIELDS('03').VALUE;
      EXCEPTION
        WHEN OTHERS THEN
          V_MRTYPE := 'N';
      END;

      IF V_MRTYPE <> 'N' THEN
        BEGIN
          SELECT AF.STATUS
            INTO V_MRSTATUS
            FROM AFMAST AF
           WHERE ACCTNO = P_TXMSG.TXFIELDS('03').VALUE;
        EXCEPTION
          WHEN OTHERS THEN
            V_MRSTATUS := 'A';
        END;
        IF V_MRSTATUS <> 'A' THEN
          P_ERR_CODE := '-100606'; -- Pre-defined in DEFERROR table
          PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
          RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        END IF;

        BEGIN
          SELECT COUNT(1)
            INTO V_AFCOUNT
            FROM AFMAST AF
           WHERE AF.GROUPLEADER IS NULL
             AND ACCTNO = P_TXMSG.TXFIELDS('03').VALUE;
        EXCEPTION
          WHEN OTHERS THEN
            V_AFCOUNT := 1;
        END;

        IF V_AFCOUNT <= 0 THEN
          P_ERR_CODE := '-100700'; -- Pre-defined in DEFERROR table
          PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
          RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        END IF;

      END IF;
    END;

    --Check lenh repo
    IF (P_TXMSG.TXFIELDS('72').VALUE = 'Y') THEN
      P_ERR_CODE := '-260164';
      PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
      RETURN ERRNUMS.C_BIZ_RULE_INVALID;
    END IF;

    /* End Neu la hop dong margin thi check*/
    PLOG.DEBUG(PKGCTX, '<<END OF fn_txPreAppCheck');
    PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
    RETURN SYSTEMNUMS.C_SUCCESS;
  EXCEPTION
    WHEN OTHERS THEN
      P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
      PLOG.ERROR(PKGCTX, SQLERRM);
      PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppCheck');
      RAISE ERRNUMS.E_SYSTEM_ERROR;
  END FN_TXPREAPPCHECK;

  FUNCTION FN_TXAFTAPPCHECK(P_TXMSG    IN TX.MSG_RECTYPE,
                            P_ERR_CODE OUT VARCHAR2) RETURN NUMBER IS
    L_BALDEFOVD       APPRULES.FIELD%TYPE;
    L_CIMASTCHECK_ARR TXPKS_CHECK.CIMASTCHECK_ARRTYPE;
  BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'fn_txAftAppCheck');
    PLOG.DEBUG(PKGCTX, '<<BEGIN OF fn_txAftAppCheck>>');
    /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    L_CIMASTCHECK_ARR := TXPKS_CHECK.FN_CIMASTCHECK(P_TXMSG.TXFIELDS('03')
                                                    .VALUE,
                                                    'CIMAST',
                                                    'ACCTNO');

    L_BALDEFOVD := L_CIMASTCHECK_ARR(0).BALDEFOVD;

    IF NOT (ROUND(TO_NUMBER(L_BALDEFOVD) +
                  TO_NUMBER(P_TXMSG.TXFIELDS('04').VALUE)) >=
        ROUND(TO_NUMBER(P_TXMSG.TXFIELDS('06')
                            .VALUE + P_TXMSG.TXFIELDS('05').VALUE + P_TXMSG.TXFIELDS('17')
                            .VALUE + P_TXMSG.TXFIELDS('66').VALUE + P_TXMSG.TXFIELDS('68')
                            .VALUE + P_TXMSG.TXFIELDS('64').VALUE))) THEN
      P_ERR_CODE := '-400110';
      PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppUpdate');
      RETURN ERRNUMS.C_BIZ_RULE_INVALID;
    END IF;
    PLOG.DEBUG(PKGCTX, '<<END OF fn_txAftAppCheck>>');
    PLOG.SETENDSECTION(PKGCTX, 'fn_txAftAppCheck');
    RETURN SYSTEMNUMS.C_SUCCESS;
  EXCEPTION
    WHEN OTHERS THEN
      P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
      PLOG.ERROR(PKGCTX, SQLERRM);
      PLOG.SETENDSECTION(PKGCTX, 'fn_txAftAppCheck');
      RAISE ERRNUMS.E_SYSTEM_ERROR;
  END FN_TXAFTAPPCHECK;

  FUNCTION FN_TXPREAPPUPDATE(P_TXMSG    IN TX.MSG_RECTYPE,
                             P_ERR_CODE OUT VARCHAR2) RETURN NUMBER IS
    V_FEEACR     NUMBER(20, 4);
    V_DBLNUMDATE NUMBER(10);
  BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'fn_txPreAppUpdate');
    PLOG.DEBUG(PKGCTX, '<<BEGIN OF fn_txPreAppUpdate');
    /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    -- log v?SEDEPOBAL hai ngay luu ky thu them
    IF (P_TXMSG.TXFIELDS('18').VALUE > 0) THEN
      V_DBLNUMDATE := TO_NUMBER(P_TXMSG.TXFIELDS('18').VALUE);
      FOR REC IN (SELECT SE.ACCTNO,
                         SE.TBALDT,
                         (SE.TRADE + SE.MARGIN + SE.MORTAGE + SE.BLOCKED +
                         SE.SECURED + SE.REPO + SE.NETTING + SE.DTOCLOSE +
                         SE.WITHDRAW) QTTY
                    FROM SEMAST SE
                   WHERE SE.AFACCTNO = P_TXMSG.TXFIELDS('03').VALUE) LOOP

        BEGIN
          SELECT ROUND(FEEACR, 4)
            INTO V_FEEACR
            FROM (SELECT A2.AFACCTNO,
                         DECODE(A2.FORP, 'P', A2.FEEAMT / 100, A2.FEEAMT) *
                         A2.SEBAL * V_DBLNUMDATE / (A2.LOTDAY * A2.LOTVAL) FEEACR
                    FROM (SELECT T.ACCTNO, MIN(T.ODRNUM) RFNUM
                            FROM VW_SEMAST_VSDDEP_FEETERM T
                           GROUP BY T.ACCTNO) A1,
                         VW_SEMAST_VSDDEP_FEETERM A2
                   WHERE A1.ACCTNO = A2.ACCTNO
                     AND A1.RFNUM = A2.ODRNUM
                     AND A2.ACCTNO = REC.ACCTNO) T2;

        EXCEPTION
          WHEN OTHERS THEN
            V_FEEACR := 0;
        END;

        INSERT INTO SEDEPOBAL
          (AUTOID, ACCTNO, TXDATE, DAYS, QTTY, DELTD, AMT, ID)
        VALUES
          (SEQ_SEDEPOBAL.NEXTVAL,
           REC.ACCTNO,
           REC.TBALDT,
           P_TXMSG.TXFIELDS('18').VALUE,
           REC.QTTY,
           'N',
           V_FEEACR,
           P_TXMSG.TXDATE || P_TXMSG.TXNUM);

      END LOOP;
    END IF;

    PLOG.DEBUG(PKGCTX, '<<END OF fn_txPreAppUpdate');
    PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppUpdate');
    RETURN SYSTEMNUMS.C_SUCCESS;
  EXCEPTION
    WHEN OTHERS THEN
      P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
      PLOG.ERROR(PKGCTX, SQLERRM);
      PLOG.SETENDSECTION(PKGCTX, 'fn_txPreAppUpdate');
      RAISE ERRNUMS.E_SYSTEM_ERROR;
  END FN_TXPREAPPUPDATE;

  FUNCTION FN_TXAFTAPPUPDATE(P_TXMSG    IN TX.MSG_RECTYPE,
                             P_ERR_CODE OUT VARCHAR2) RETURN NUMBER IS
    V_SENTDEPOSIT NUMBER;
    V_SUMDETAIL   NUMBER;
    V_ACCTNO      VARCHAR2(20);
    V_MRCOUNT     VARCHAR2(10);
    V_ACCNUM      NUMBER;
    V_CUSTID      VARCHAR2(10);
    V_CUSTODYCD   VARCHAR2(10);
    V_IDATE       DATE;
    V_MARKETNAME  VARCHAR2(100);
    V_RIGHTNAME_A VARCHAR2(100);
    V_RIGHTNAME_B VARCHAR2(100);
    V_RIGHTNAME_C VARCHAR2(100);
    V_RIGHTNAME_D VARCHAR2(100);
    V_RIGHTNAME_E VARCHAR2(100);
    V_RIGHTNAME_F VARCHAR2(100);
    V_RIGHTNAME_G VARCHAR2(100);
    V_RIGHTNAME_H VARCHAR2(100);

  BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'fn_txAftAppUpdate');
    PLOG.DEBUG(PKGCTX, '<<BEGIN OF fn_txAftAppUpdate');
    /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    -- update CIDEPOFEEACR, DEPOFEEAMT cua CIMAST =0 cho TK sai so nen nhan ja tri am hoac le
    UPDATE CIMAST
       SET CIDEPOFEEACR = 0, DEPOFEEAMT = 0
     WHERE ACCTNO = P_TXMSG.TXFIELDS('03').VALUE;
    UPDATE CIFEESCHD
       SET PAIDAMT    = NMLAMT,
           PAIDTXNUM  = P_TXMSG.TXNUM,
           PAIDTXDATE = P_TXMSG.BUSDATE
     WHERE AFACCTNO = P_TXMSG.TXFIELDS('03').VALUE AND  PAIDAMT <>  NMLAMT;--PAIDTXNUM IS NULL AND PAIDTXDATE IS NULL;

    SELECT CUSTID
      INTO V_CUSTID
      FROM AFMAST
     WHERE ACCTNO = P_TXMSG.TXFIELDS('03').VALUE;
    --check se SENDDEPOSIT
    -- PhuongHT comment theo yeu cau BVS
    /*   Begin
            Select  sum( NVL(SENDDEPOSIT,0)) into v_sentdeposit
            from semast where AFACCTNO=p_txmsg.txfields('03').value;
        EXCEPTION
            WHEN OTHERS   THEN
            v_sentdeposit:=-1;
        End;

        if v_sentdeposit >0  then
            p_err_code := '-200064'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
    */

    /*
    NEU LA TK CUOI CUNG THI UPDATE SO DU
        */
    BEGIN
      SELECT COUNT(ACCTNO)
        INTO V_ACCNUM
        FROM AFMAST
       WHERE CUSTID =
             (SELECT CUSTID
                FROM AFMAST
               WHERE ACCTNO = P_TXMSG.TXFIELDS('03').VALUE)
         AND STATUS <> 'N'
         AND ACCTNO <> P_TXMSG.TXFIELDS('03').VALUE;

      IF V_ACCNUM = 0 THEN

        UPDATE CIMAST
           SET DRAMT   = DRAMT + P_TXMSG.TXFIELDS('68').VALUE,
               BALANCE = BALANCE - P_TXMSG.TXFIELDS('68').VALUE
         WHERE ACCTNO = P_TXMSG.TXFIELDS('03').VALUE;
        --insert citran
        INSERT INTO CITRAN
          (TXNUM,
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
        VALUES
          (P_TXMSG.TXNUM,
           TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
           P_TXMSG.TXFIELDS('03').VALUE,
           '0011',
           ROUND(P_TXMSG.TXFIELDS('68').VALUE, 0),
           NULL,
           '',
           P_TXMSG.DELTD,
           '',
           SEQ_CITRAN.NEXTVAL,
           P_TXMSG.TLTXCD,
           P_TXMSG.BUSDATE,
           UTF8NUMS.C_CONST_TLTX_TXDESC_0088_FEE);

        INSERT INTO CITRAN
          (TXNUM,
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
        VALUES
          (P_TXMSG.TXNUM,
           TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),
           P_TXMSG.TXFIELDS('03').VALUE,
           '0016',
           ROUND(P_TXMSG.TXFIELDS('68').VALUE, 0),
           NULL,
           '',
           P_TXMSG.DELTD,
           '',
           SEQ_CITRAN.NEXTVAL,
           P_TXMSG.TLTXCD,
           P_TXMSG.BUSDATE,
           '' || '' || '');

      END IF;
    END;

    /*
    Select (NVL(MORTAGE,0)+ NVL(TRADE,0)+NVL(DTOCLOSE,0) +NVL(MARGIN,0)+NVL(NETTING,0)+NVL(STANDING,0)+NVL(SECURED,0)+ NVL(WITHDRAW,0)+NVL(DEPOSIT,0)+NVL(LOAN,0)+NVL(BLOCKED,0)+NVL(REPO,0)+ NVL(PENDING,0)+NVL(TRANSFER,0) + NVL(SENDDEPOSIT,0)) SUMSEDETAIL,ACCTNO
    INTO v_sumdetail,v_acctno
    from semast where AFACCTNO=p_txmsg.txfields('03').value;
    */
    --Thay doi trang thai SE sang pending to close

    -- PhuongHT comment de co the re-active sau khi lam 0088
    /*  for rec in
    (
        Select nvl((NVL(MORTAGE,0)+ NVL(TRADE,0)+NVL(DTOCLOSE,0) + NVL(MARGIN,0)+NVL(NETTING,0)+NVL(STANDING,0)+NVL(SECURED,0)+ NVL(WITHDRAW,0)+NVL(DEPOSIT,0)+NVL(LOAN,0)+NVL(BLOCKED,0)+NVL(REPO,0)+ NVL(PENDING,0)+NVL(TRANSFER,0) + NVL(SENDDEPOSIT,0)),0) SUMSEDETAIL,ACCTNO
        from semast where AFACCTNO=p_txmsg.txfields('03').value
    )loop
        if rec.SUMSEDETAIL = 0 then
            UPDATE SEMAST
                SET STATUS='N',
                    PSTATUS=PSTATUS || STATUS,
                    LASTDATE=TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT )
            WHERE ACCTNO=rec.acctno;
        end if;
    end loop;*/
    --end of PhuongHT comment

    --Kiem tra neu tai khoan la margin co ky han thi neu ODINT + ODAMT > 0 thi khong cho lam.
    --Bat phai tra no het theo ky han thi moi duoc lam
    IF ((P_TXMSG.TXFIELDS('05').VALUE) + (P_TXMSG.TXFIELDS('06').VALUE)) > 0 THEN
      BEGIN
        SELECT COUNT(1)
          INTO V_MRCOUNT
          FROM AFMAST AF, AFTYPE AT, MRTYPE MT
         WHERE AF.ACCTNO = P_TXMSG.TXFIELDS('03').VALUE
           AND AF.ACTYPE = AT.ACTYPE
           AND AT.MRTYPE = MT.ACTYPE
           AND MT.MRTYPE = 'T';
      EXCEPTION
        WHEN OTHERS THEN
          V_MRCOUNT := 0;
      END;

      IF V_MRCOUNT > 0 THEN
        P_ERR_CODE := '-200070'; -- Pre-defined in DEFERROR table
        PLOG.SETENDSECTION(PKGCTX, 'fn_txAftAppUpdate');
        RETURN ERRNUMS.C_BIZ_RULE_INVALID;
      END IF;
    END IF;
    UPDATE CIDEPOFEETRAN
       SET STATUS = 'C'
     WHERE STATUS <> 'C'
       AND AFACCTNO = P_TXMSG.TXFIELDS('03').VALUE;
    -- neu la tk cuoi cung va chuyen CK insert vao bang SENDSETOCLOSE
    IF (P_TXMSG.TXFIELDS('45').VALUE = 'Y') THEN
      UPDATE SENDSETOCLOSE SET DELTD = 'Y' WHERE CUSTID = V_CUSTID;
      INSERT INTO SENDSETOCLOSE
        (AUTOID, CUSTID, REFCUSTODYCD, REFINWARD, DELTD, TXNUM, TXDATE)
      VALUES
        (SEQ_SENDSETOCLOSE.NEXTVAL,
         V_CUSTID,
         P_TXMSG.TXFIELDS('47').VALUE,
         P_TXMSG.TXFIELDS('48').VALUE,
         'N',
         P_TXMSG.TXNUM,
         TO_DATE(P_TXMSG.TXDATE, 'DD/MM/RRRR'));
    END IF;

    SELECT CUSTODYCD INTO V_CUSTODYCD FROM CFMAST WHERE CUSTID = V_CUSTID;
    SELECT COUNT(*)
      INTO V_MRCOUNT
      FROM AFMAST
     WHERE CUSTID = V_CUSTID
       AND STATUS NOT IN ('N', 'C');

    -- HaiLT them de log cho bao cao CF0080
    INSERT INTO CF0080_LOG
      (CUSTODYCD,
       AFACCTNO,
       TXDATE,
       TXNUM,
       TLTXCD,
       BRID,
       BRNAME,
       FULLNAME,
       IDCODE,
       IDDATE,
       IDPLACE,
       ADDRESS,
       PHONE,
       MOBILE,
       SYMBOL,
       TRADEPLACE,
       TRADE,
       BLOCKED,
       TRADE_WFT,
       BLOCKED_WFT,
       ISCLOSED,
       INWARD,
       RCVCUSTODYCD)
      SELECT V_CUSTODYCD,
             P_TXMSG.TXFIELDS('03').VALUE,
             TO_DATE(P_TXMSG.TXDATE, 'DD/MM/RRRR'),
             P_TXMSG.TXNUM,
             P_TXMSG.TLTXCD,
             BRID,
             BRNAME,
             MAIN.FULLNAME,
             MAIN.IDCODE,
             MAIN.IDDATE,
             MAIN.IDPLACE,
             MAIN.ADDRESS,
             MAIN.PHONE,
             MAIN.MOBILE,
             MAIN.WFT_SYMBOL SYMBOL,
             TRADEPLACE,
             SUM(CASE
                   WHEN INSTR(SYMBOL, '_WFT') = 0 THEN
                    NVL(TRADE, 0) + NVL(B.BUYQTTY, 0) - NVL(B.SELLQTTY, 0)
                   ELSE
                    0
                 END) TRADE,
             SUM(CASE
                   WHEN INSTR(SYMBOL, '_WFT') = 0 THEN
                    BLOCKED
                   ELSE
                    0
                 END) BLOCKED,
             SUM(CASE
                   WHEN INSTR(SYMBOL, '_WFT') <> 0 THEN
                    NVL(TRADE, 0) + NVL(B.BUYQTTY, 0) - NVL(B.SELLQTTY, 0)
                   ELSE
                    0
                 END) TRADE_WFT,
             SUM(CASE
                   WHEN INSTR(SYMBOL, '_WFT') <> 0 THEN
                    BLOCKED
                   ELSE
                    0
                 END) BLOCKED_WFT,
             CASE
               WHEN 0 > 0 THEN
                'N'
               ELSE
                'Y'
             END ISCLOSED,
             P_TXMSG.TXFIELDS('48').VALUE INWARD,
             P_TXMSG.TXFIELDS('47').VALUE RCVCUSTODYCD
        FROM (

               SELECT BR.BRID,
                       BRNAME,
                       CF.FULLNAME,
                       DECODE(SUBSTR(CF.CUSTODYCD, 4, 1),
                              'F',
                              CF.TRADINGCODE,
                              CF.IDCODE) IDCODE,
                       DECODE(SUBSTR(CF.CUSTODYCD, 4, 1),
                              'F',
                              CF.TRADINGCODEDT,
                              CF.IDDATE) IDDATE,
                       CF.IDPLACE,
                       CF.ADDRESS,
                       CF.PHONE,
                       CF.MOBILE,
                       CF.CUSTODYCD,
                       NVL(SB.SYMBOL, '') SYMBOL,
                       NVL(SB_WFT.SYMBOL, '') WFT_SYMBOL,
                       NVL(SB_WFT.SECTYPE, '') SECTYPE,
                       NVL(SB_WFT.ISSUERID, '') ISSUERID,
                       --nvl(sb_wft.tradeplace,'') tradeplace,
                       NVL(SE.TRADE, 0) - nvl(tran.TRADE,0)/*SUM(CASE
                                                WHEN TRAN.FIELD = 'TRADE' AND TRAN.TXCD = 'D' THEN
                                                 -NVL(TRAN.NAMT, 0)
                                                WHEN TRAN.FIELD = 'TRADE' AND TRAN.TXCD = 'C' THEN
                                                 NVL(TRAN.NAMT, 0)
                                                ELSE
                                                 0
                                              END)*/ TRADE,
                       NVL(SE.BLOCKED, 0) - nvl(tran.BLOCKED,0)/*SUM(CASE
                                                  WHEN TRAN.FIELD = 'BLOCKED' AND TRAN.TXCD = 'D' THEN
                                                   -NVL(TRAN.NAMT, 0)
                                                  WHEN TRAN.FIELD = 'BLOCKED' AND TRAN.TXCD = 'C' THEN
                                                   NVL(TRAN.NAMT, 0)
                                                  ELSE
                                                   0
                                                END)*/ BLOCKED,
                       SE.RECEIVING,
                       CASE
                         WHEN SB.MARKETTYPE = '001' AND
                              SB.SECTYPE IN ('003', '006', '222', '333', '444') THEN
                          UTF8NUMS.C_CONST_DF_MARKETNAME
                         WHEN NVL(SB_WFT.TRADEPLACE, '') = '001' THEN
                          'HOSE'
                         WHEN NVL(SB_WFT.TRADEPLACE, '') = '002' THEN
                          'HNX'
                         WHEN NVL(SB_WFT.TRADEPLACE, '') = '005' THEN
                          'UPCOM'
                       END TRADEPLACE

                 FROM /*( SELECT cf.custodycd
                       FROM vw_tllog_all lg, afmast af, cfmast cf
                       WHERE af.custid = cf.custid AND lg.msgacct = af.acctno
                       AND lg.tltxcd = '0088'
                        group by cf.custodycd) tl, */ BRGRP BR,
                       CFMAST CF,
                       AFMAST AF,
                       SEMAST SE,
                                           (SELECT acctno, SUM(CASE WHEN FIELD = 'TRADE' AND TXCD = 'D' THEN -NVL(NAMT, 0)
                                                WHEN FIELD = 'TRAE' AND TXCD = 'C' THEN NVL(NAMT, 0) ELSE 0 END) TRADE,
                                       SUM(CASE WHEN FIELD = 'BLOCKED' AND TXCD = 'D' THEN -NVL(NAMT, 0)
                                                  WHEN FIELD = 'BLOCKED' AND TXCD = 'C' THEN NVL(NAMT, 0) ELSE 0 END) BLOCKED
                       FROM VW_SETRAN_GEN WHERE TXDATE >= TO_DATE(V_IDATE, 'DD/MM/RRRR') AND FIELD IN ('TRADE', 'BLOCKED')
                       group by acctno)

                       /*(SELECT *
                          FROM VW_SETRAN_GEN
                         WHERE TXDATE >= TO_DATE(P_TXMSG.TXDATE, 'DD/MM/RRRR')
                           AND FIELD IN ('TRADE', 'BLOCKED'))*/ TRAN,
                       SBSECURITIES SB,
                       SBSECURITIES SB_WFT
                WHERE
               --tl.custodycd = cf.custodycd      and
                CF.CUSTODYCD = V_CUSTODYCD
             AND AF.CUSTID = CF.CUSTID
             AND SB.SECTYPE NOT IN ('111', '222', '333', '444', '004')
             AND BR.BRID = SUBSTR(CF.CUSTID, 1, 4)
             AND AF.ACCTNO = SE.AFACCTNO(+)
             AND SE.ACCTNO = TRAN.ACCTNO(+)
             AND SE.CODEID = SB.CODEID(+)
             AND NVL(SB.REFCODEID, SB.CODEID) = SB_WFT.CODEID(+)
               --AND (substr(cf.custid,1,4) LIKE '%%' OR instr('%%',substr(cf.custid,1,4))<> 0)
                /*GROUP BY BR.BRID,
                          BRNAME,
                          SB.MARKETTYPE,
                          SB.SECTYPE,
                          CF.FULLNAME,
                          CF.IDCODE,
                          CF.IDDATE,
                          CF.IDPLACE,
                          CF.ADDRESS,
                          CF.PHONE,
                          CF.MOBILE,
                          CF.CUSTODYCD,
                          SE.TRADE,
                          SE.BLOCKED,
                          SE.RECEIVING,
                          SB.SYMBOL,
                          SB_WFT.SYMBOL,
                          SB_WFT.SECTYPE,
                          SB_WFT.ISSUERID,
                          SB_WFT.TRADEPLACE,
                          CF.TRADINGCODEDT,
                          CF.TRADINGCODE --, tran.field*/
               ) MAIN
        LEFT JOIN (SELECT CUSTODYCD,
                          CODEID,
                          SYMBOL SYMBOLL,
                          SUM(CASE
                                WHEN BORS = 'S' THEN
                                 QTTY
                                ELSE
                                 0
                              END) SELLQTTY,
                          SUM(CASE
                                WHEN BORS = 'B' THEN
                                 QTTY
                                ELSE
                                 0
                              END) BUYQTTY
                     FROM IOD
                    WHERE DELTD <> 'Y'
                      AND CUSTODYCD = V_CUSTODYCD
                    GROUP BY CUSTODYCD, CODEID, SYMBOL) B
          ON MAIN.CUSTODYCD = B.CUSTODYCD
         AND MAIN.SYMBOL = B.SYMBOLL
       GROUP BY BRID,
                BRNAME,
                MAIN.FULLNAME,
                MAIN.IDCODE,
                MAIN.IDDATE,
                MAIN.IDPLACE,
                MAIN.ADDRESS,
                MAIN.PHONE,
                MAIN.MOBILE,
                MAIN.CUSTODYCD,
                MAIN.WFT_SYMBOL,
                MAIN.TRADEPLACE;

    -- HaiLT them de log cho bao cao CF0081

    INSERT INTO CF0081_LOG
      SELECT V_CUSTODYCD,
             P_TXMSG.TXFIELDS('03').VALUE,
             TO_DATE(P_TXMSG.TXDATE, 'DD/MM/RRRR'),
             P_TXMSG.TXNUM,
             P_TXMSG.TLTXCD,
             CAMASTID,
             CA_GROUP,
             CATYPENAME,
             TRADEPLACE,
             SYMBOL,
             DEVIDENTSHARES,
             DEVIDENTRATE,
             RIGHTOFFRATE,
             EXPRICE,
             INTERESTRATE,
             EXRATE,
             REPORTDATE,
             CATYPE,
             SUM(TRADE) TRADE,
             SUM(AMT) AMT,
             SUM(QTTY) QTTY,
             SUM(RQTTY) RQTTY,
             SUM(PBALANCE) PBALANCE,
             SUM(BALANCE) BALANCE,
             CASE
               WHEN V_MRCOUNT > 0 THEN
                'N'
               ELSE
                'Y'
             END ISCLOSED
        FROM (SELECT CAS.CAMASTID,
                     CAS.BALANCE,
                     CAS.PBALANCE,
                     CAS.RQTTY,
                     CAS.QTTY,
                     CAS.AMT,
                     CAS.TRADE,
                     CA.CATYPE,
                     CA.REPORTDATE,
                     CA.EXRATE,
                     CA.INTERESTRATE,
                     CA.EXPRICE,
                     CA.RIGHTOFFRATE,
                     CASE
                       WHEN CA.CATYPE = '010' AND CA.DEVIDENTRATE = 0 THEN
                        TO_CHAR(CA.DEVIDENTVALUE)
                       ELSE
                        CA.DEVIDENTRATE
                     END DEVIDENTRATE,
                     CA.DEVIDENTSHARES,
                     SB.SYMBOL,
                     A1.CDCONTENT TRADEPLACE,
                     CASE
                       WHEN CA.CATYPE = '011' THEN
                        UTF8NUMS.C_CONST_CA_RIGHTNAME_A -- 'A. QUY?N NH?N C? T?C B?NG C? PHI?U'
                       WHEN CA.CATYPE = '010' THEN
                        UTF8NUMS.C_CONST_CA_RIGHTNAME_C -- 'C. QUY?N NH?N C? T?C B?NG TI?N'
                       WHEN CA.CATYPE = '021' THEN
                        UTF8NUMS.C_CONST_CA_RIGHTNAME_B -- 'B. QUY?N C? PHI?U THU?NG'
                       WHEN CA.CATYPE = '014' THEN
                        UTF8NUMS.C_CONST_CA_RIGHTNAME_D -- 'D. QUY?N MUA'
                       WHEN CA.CATYPE = '020' THEN
                        UTF8NUMS.C_CONST_CA_RIGHTNAME_E -- 'E. QUY?N HO?N ?I C? PHI?U'
                       WHEN CA.CATYPE IN ('017', '023') THEN
                        UTF8NUMS.C_CONST_CA_RIGHTNAME_F --'F. QUY?N CHUY?N ?I TR?I PHI?U'
                       WHEN CA.CATYPE IN ('022', '005', '006') THEN
                        UTF8NUMS.C_CONST_CA_RIGHTNAME_G --'G. QUY?N BI?U QUY?T'
                       ELSE
                        --V_RIGHTNAME_H --'H. QUY?N KH?C'
                       UTF8NUMS.C_CONST_CA_RIGHTNAME_H
                     END CATYPENAME,
                     CASE
                       WHEN CA.CATYPE IN ('011', '021') THEN
                        1
                       WHEN CA.CATYPE IN ('010') THEN
                        2
                       WHEN CA.CATYPE IN ('014') THEN
                        3
                       WHEN CA.CATYPE IN ('020') THEN
                        4
                       WHEN CA.CATYPE IN ('017', '023') THEN
                        5
                       WHEN CA.CATYPE IN ('022', '005', '006') THEN
                        6
                       ELSE
                        7
                     END CA_GROUP
                FROM CASCHD       CAS,
                     CAMAST       CA,
                     SBSECURITIES SB,
                     ALLCODE      A1,
                     ALLCODE      A2,
                     AFMAST       AF,
                     CFMAST       CF
               WHERE CAS.CAMASTID = CA.CAMASTID
                 AND CAS.CODEID = SB.CODEID
                 AND CAS.AFACCTNO = AF.ACCTNO
                 AND AF.CUSTID = CF.CUSTID
                 AND A1.CDNAME = 'TRADEPLACE'
                 AND A1.CDTYPE = 'SE'
                 AND A1.CDVAL = SB.TRADEPLACE
                 AND A2.CDNAME = 'CATYPE'
                 AND A2.CDTYPE = 'CA'
                 AND CA.CATYPE = A2.CDVAL
                 AND CF.CUSTODYCD = V_CUSTODYCD
                 AND AF.STATUS = 'N'
                 AND CAS.DELTD <> 'Y'
                 AND (CASE
                       WHEN CAS.STATUS IN ('C', 'J') THEN
                        0
                       ELSE
                        1
                     END) > 0) A
       GROUP BY CATYPE,
                REPORTDATE,
                EXRATE,
                INTERESTRATE,
                EXPRICE,
                RIGHTOFFRATE,
                DEVIDENTRATE,
                DEVIDENTSHARES,
                SYMBOL,
                TRADEPLACE,
                CATYPENAME,
                CA_GROUP,
                CAMASTID
       ORDER BY A.CATYPENAME;

    -- End of HaiLT them de log cho bao cao CF0081

    PLOG.DEBUG(PKGCTX, '<<END OF fn_txAftAppUpdate');
    PLOG.SETENDSECTION(PKGCTX, 'fn_txAftAppUpdate');
    RETURN SYSTEMNUMS.C_SUCCESS;
  EXCEPTION
    WHEN OTHERS THEN
      P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
      PLOG.ERROR(PKGCTX, SQLERRM);
      PLOG.SETENDSECTION(PKGCTX, 'fn_txAftAppUpdate');
      RAISE ERRNUMS.E_SYSTEM_ERROR;
  END FN_TXAFTAPPUPDATE;

BEGIN
  FOR I IN (SELECT * FROM TLOGDEBUG) LOOP
    LOGROW.LOGLEVEL  := I.LOGLEVEL;
    LOGROW.LOG4TABLE := I.LOG4TABLE;
    LOGROW.LOG4ALERT := I.LOG4ALERT;
    LOGROW.LOG4TRACE := I.LOG4TRACE;
  END LOOP;
  PKGCTX := PLOG.INIT('TXPKS_#0088EX',
                      PLEVEL         => NVL(LOGROW.LOGLEVEL, 30),
                      PLOGTABLE      => (NVL(LOGROW.LOG4TABLE, 'N') = 'Y'),
                      PALERT         => (NVL(LOGROW.LOG4ALERT, 'N') = 'Y'),
                      PTRACE         => (NVL(LOGROW.LOG4TRACE, 'N') = 'Y'));
END TXPKS_#0088EX;
/

