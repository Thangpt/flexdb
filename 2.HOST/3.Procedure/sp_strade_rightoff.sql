CREATE OR REPLACE PROCEDURE sp_strade_rightoff (
  v_afacctno in varchar,
  v_issubacct in varchar,
  v_qtty  in float,
  v_trfdesc in varchar,
  v_camastid in varchar,
  v_rqsid in varchar,
  v_errcode out integer) IS
  v_sequenceid integer;
  
  v_count integer;
  v_errmsg varchar(250);
  v_custodycd varchar(20);
  v_subaccount varchar(20);
  v_caid varchar(20);
  v_txdate varchar(20);
  v_txnum varchar(10);
  v_rqssrc varchar(3);
  v_rqstyp varchar(3);
  v_status varchar(3);
  v_timeallow NUMBER;
  v_remark varchar2(500);
  v_symbol varchar(30);
  
  v_Exvalue float;
  v_PurchasingPower number;
   
  pkgctx   plog.log_ctx;
  logrow   tlogdebug%ROWTYPE;
   
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
         plog.init ('sp_strade_rightoff',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
    plog.setbeginsection (pkgctx, 'sp_strade_rightoff');
    plog.debug (pkgctx, '<<BEGIN OF sp_strade_rightoff');
    plog.debug (pkgctx, 'v_afacctno: '|| v_afacctno);
    plog.debug (pkgctx, 'v_issubacct: '|| v_issubacct);
    plog.debug (pkgctx, 'v_qtty: '|| v_qtty);
    plog.debug (pkgctx, 'v_trfdesc: '|| v_trfdesc);
    plog.debug (pkgctx, 'v_camastid: '|| v_camastid);
    plog.debug (pkgctx, 'v_rqsid: '|| v_rqsid);   
     

      --Kiem tra thoi gian cho phep thuc hien chuyen tien.
    SELECT CASE WHEN max(case WHEN grname = 'SYSTEM' AND varname = 'HOSTATUS' THEN varvalue END) = 1
        AND to_date(to_char(SYSDATE,'hh24:mi:ss'),'hh24:mi:ss') >= to_date(max(case WHEN grname = 'STRADE' AND varname = 'CA_FRTIME' THEN varvalue END),'hh24:mi:ss')
        AND to_date(to_char(SYSDATE,'hh24:mi:ss'),'hh24:mi:ss') <= to_date(max(case WHEN grname = 'STRADE' AND varname = 'CA_TOTIME' THEN varvalue END),'hh24:mi:ss')
        THEN 1 ELSE 0 END
        INTO v_timeallow
    FROM sysvar;
  if v_timeallow = 0 then
    v_errcode:=619;  --nam ngoai thoi gian cho phep thuc hien chuyen tien qua strade.
    return;
  end if;
  --kiem tra khong duoc trung rqsid
  SELECT COUNT(*) INTO v_count FROM BORQSLOG WHERE REQUESTID=v_rqsid AND rqstyp = 'CAR' AND rqssrc = 'ONL';
  IF v_count<>0 THEN
    v_errcode:=620;  --trung yeu cau
  ELSE
    BEGIN
      --nhan yeu cau xu ly
      v_rqssrc:='ONL';
      v_rqstyp:='CAR';
      v_status:='P';

      BEGIN
            -- Neu truyen vao custodycd, thuc hien chuyen lai thanh afacctno voi tradeonline = Y
          IF v_issubacct='N' THEN
              BEGIN
                  SELECT AF.ACCTNO INTO v_subaccount FROM AFMAST AF, CFMAST CF WHERE CF.CUSTID=AF.CUSTID AND AF.TRADEONLINE='Y' and AF.STATUS <> 'C' AND CF.CUSTODYCD=v_afacctno;
              EXCEPTION
              WHEN OTHERS THEN
                    v_subaccount:= v_afacctno;
              END;
          ELSE
                v_subaccount:= v_afacctno;
          END IF;
          SELECT AFMAST.ACCTNO, CFMAST.CUSTODYCD INTO v_subaccount, v_custodycd FROM AFMAST, CFMAST WHERE AFMAST.CUSTID=CFMAST.CUSTID and AFMAST.STATUS <> 'C' AND AFMAST.ACCTNO=v_subaccount;
      EXCEPTION
          WHEN no_data_found THEN
            ---plog.debug (pkgctx, 'v_subaccount: '|| v_subaccount);   
            v_errcode:=621;  --khong thay subaccount
            raise;
            RETURN;
      END;

      -- Format camastid
      v_caid:=replace(v_camastid,'.','');
      -- Kiem tra trang thai quyen. Co cho phep thuc hien tiep dang ky quyen mua hay khong.
      BEGIN
          SELECT camastid INTO v_caid FROM camast WHERE status IN ('A','M') AND camastid = v_caid and deltd <> 'Y';
      EXCEPTION
          WHEN no_data_found THEN
            v_errcode:=622;  --Trang thai ma quyen ko hop le: chi dang ki quyen mua khi trang thai camast la A, M
            RETURN;
      END;
      -- Lay thong tin ma chung khoan de lam dien giai.
      BEGIN
          ---KhanhND 24/05/2011: Lay them exprice de tinh toan so tien thuc hien dang ky
          ---select s.symbol into v_symbol from camast c, sbsecurities s where s.codeid = c.codeid and c.status IN ('A','M') AND c.camastid = v_caid and c.deltd <> 'Y';
          select s.symbol,c.exprice*v_qtty into v_symbol, v_Exvalue from camast c, sbsecurities s 
          where s.codeid = c.codeid and c.status IN ('A','M') AND c.camastid = v_caid and c.deltd <> 'Y';
      EXCEPTION
          WHEN others THEN
            v_errcode:=623;  --ma chung khoan khong ton tai.
            RETURN;
      END;
      -- Kiem tra trang thai quyen. Co cho phep thuc hien tiep dang ky quyen mua hay khong.
      BEGIN
          SELECT camastid INTO v_caid FROM caschd WHERE status IN ('A','M') AND camastid = v_caid AND afacctno = v_subaccount and deltd <> 'Y';
      EXCEPTION
          WHEN no_data_found THEN
            v_errcode:=622;  --Trang thai ma quyen ko hop le: chi dang ki quyen mua khi trang thai camast la A, M
            RETURN;
      END;
      BEGIN
          -- Kiem tra: So luong dang ki mua co cho phep hay khong? PBALANCE > 0 AND PQTTY > 0
          SELECT camastid INTO v_caid
          FROM caschd
          WHERE status IN ('A','M') AND camastid = v_caid AND afacctno = v_subaccount AND PBALANCE > 0 AND PQTTY > 0 AND PQTTY >= v_qtty and deltd <> 'Y';
      EXCEPTION
          WHEN no_data_found THEN
            v_errcode:=624;  --Khoi luong chung khoan dk quyen mua khong hop le.
            RETURN;
      END;
      ---KhanhND: 24/05/2011: Kiem tra xem tai khoan co du tien khong
      BEGIN
        SELECT purchasingpower INTO v_PurchasingPower FROM OL_ACCOUNT_CI CI WHERE CI.AFACCTNO =v_subaccount;        
      EXCEPTION
          WHEN no_data_found THEN
            v_PurchasingPower:=0;  --So tien dang ky vuot qua tong suc mua cua tieu khoan
            RETURN;
      END;
      plog.debug (pkgctx, 'v_Exvalue: '|| v_Exvalue);   
      plog.debug (pkgctx, 'v_PurchasingPower: '|| v_PurchasingPower);   
      IF v_PurchasingPower < v_Exvalue THEN
        v_errcode:=618;  --So tien dang ky vuot qua tong suc mua cua tieu khoan
        RETURN;
      END IF;
      ----End of 24/05/2011
      -- desc dang ky quyen mua:
      v_remark:='Dang ky quyen mua cp ' || v_symbol;

      SELECT SEQ_BORQSLOG.NEXTVAL INTO v_sequenceid FROM DUAL;
      INSERT INTO BORQSLOG (AUTOID, CREATEDDT, RQSSRC, RQSTYP, REQUESTID, STATUS, TXDATE, TXNUM, ERRNUM, ERRMSG)
      SELECT v_sequenceid, SYSDATE, v_rqssrc, v_rqstyp, v_rqsid, v_status, v_txdate, v_txnum, v_errcode, v_errmsg FROM DUAL;

      INSERT INTO BORQSLOGDTL (AUTOID, VARNAME, VARTYPE, CVALUE, NVALUE)
      VALUES (v_sequenceid, 'AFACCTNO', 'C', v_subaccount, 0);

      INSERT INTO BORQSLOGDTL (AUTOID, VARNAME, VARTYPE, CVALUE, NVALUE)
      VALUES (v_sequenceid, 'CUSTODYCD', 'C', v_custodycd, 0);

      INSERT INTO BORQSLOGDTL (AUTOID, VARNAME, VARTYPE, CVALUE, NVALUE)
      VALUES (v_sequenceid, 'QTTY', 'N', NULL, v_qtty);

      INSERT INTO BORQSLOGDTL (AUTOID, VARNAME, VARTYPE, CVALUE, NVALUE)
      VALUES (v_sequenceid, 'CAMASTID', 'C', v_camastid, 0);

      INSERT INTO BORQSLOGDTL (AUTOID, VARNAME, VARTYPE, CVALUE, NVALUE)
      VALUES (v_sequenceid, 'TRFDESC', 'C', v_remark, 0);

    INSERT INTO BORQSLOGDTL (AUTOID, VARNAME, VARTYPE, CVALUE, NVALUE)
      VALUES (v_sequenceid, 'REFACCTNO', 'C', v_afacctno, 0);

    INSERT INTO BORQSLOGDTL (AUTOID, VARNAME, VARTYPE, CVALUE, NVALUE)
      VALUES (v_sequenceid, 'ISSUBACCT', 'C', v_issubacct, 0);

      IF v_errcode IS NULL THEN
            v_errcode:=0;
      END IF;

      COMMIT;
    END;
  END IF;
 plog.debug (pkgctx, '<<END OF sp_strade_rightoff');
    plog.setendsection (pkgctx, 'sp_strade_rightoff');
  
END;
/

