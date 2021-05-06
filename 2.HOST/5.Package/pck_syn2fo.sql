CREATE OR REPLACE PACKAGE pck_syn2fo
  IS
  gc_CallWSSuccessCode varchar2(10):='200';
  gc_Success           varchar2(10):='0';
PROCEDURE PRC_OPENACCOUNT_OPNACCT(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_account  VARCHAR2,
          v_strMsg IN OUT  VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          );
PROCEDURE PRC_CHANGESTATUS_ACCT(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_account  VARCHAR2,
          v_status   VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          );
PROCEDURE PRC_GENMSG2FO(v_txnum varchar2,
        v_strMsg IN OUT VARCHAR2,
        v_errcode IN OUT VARCHAR2,
        v_errmsg IN OUT VARCHAR2);

PROCEDURE PRC_GEN7001MSG2FO(v_OrderId varchar2,
        v_strMsg IN OUT VARCHAR2,
        v_errcode IN OUT VARCHAR2,
        v_errmsg IN OUT VARCHAR2);
PROCEDURE PRC_GEN9000MSG2FO(v_EXCHANGE varchar2,
        v_SESSIONEX VARCHAR2,
        v_strMsg IN OUT VARCHAR2,
        v_errcode IN OUT VARCHAR2,
        v_errmsg IN OUT VARCHAR2);
PROCEDURE PRC_CALLWEBSERVICE(pv_StrMessage VARCHAR2,v_errcode IN OUT VARCHAR2,
                             v_errmsg IN OUT VARCHAR2,v_Type VARCHAR2 DEFAULT NULL);
PROCEDURE PRC_HOLDAMOUNT(v_reqid varchar2,
        v_strMsg IN OUT VARCHAR2 ,
        v_errcode IN OUT VARCHAR2,
        v_errmsg IN OUT VARCHAR2);
PROCEDURE PRC_CAEXEC(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_tltxcd VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          );
PROCEDURE PRC_PROCESSEVENT;
PROCEDURE PRC_GENSYSTEM_PARAM;
PROCEDURE PRC_GEN_MSG_SYSPARAM(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_tltxcd VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          );
PROCEDURE PRC_CHANGE_ODFEE;
PROCEDURE PRC_GEN_MSG_ODFEE(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_tltxcd VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          );
PROCEDURE PRC_CHANGEAFTYPE(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_account  VARCHAR2,
          v_tltxcd  VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          );
PROCEDURE PRC_GEN_MSG_CHGPOOL(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_PoolID VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          );
PROCEDURE PRC_GEN_MSG_CHGROOM(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_RoomID VARCHAR2,
          v_Symbol VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          );
PROCEDURE PRC_GEN_MSG_ADDSPROOM(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_RoomID VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          );
PROCEDURE PRC_GEN_MSG_ACC2SPROOM(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_RoomID VARCHAR2,
          v_Acctno VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          );
PROCEDURE PRC_GEN_MSG_CHGDEFRULE(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_tltxcd VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          );
PROCEDURE PRC_GEN_MSG_SYNROOM(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_tltxcd VARCHAR2,
          v_Acctno VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          );
PROCEDURE PRC_GEN_RELEASEOD_MSG2FO(v_userid varchar2,v_via varchar2,v_symbol varchar2,v_Acctno varchar2,v_OrderId varchar2,
        v_strMsg IN OUT VARCHAR2,
        v_errcode IN OUT VARCHAR2,
        v_errmsg IN OUT VARCHAR2);

PROCEDURE PRC_CHECK_SYN2FO(v_txnum varchar2,
        v_errcode IN OUT VARCHAR2,
        v_errmsg IN OUT VARCHAR2);
PROCEDURE PRC_GEN_MSG_2290(
                               v_txnum    VARCHAR2,
                               v_strMsg IN OUT  VARCHAR2 ,
                               v_errcode IN OUT VARCHAR2,
                               v_errmsg  IN OUT VARCHAR2
                                                  );
PROCEDURE PRC_GEN_MSG_CHGSYSVAR (
   v_tltxcd   VARCHAR2,
   v_key      VARCHAR2,
   v_strMsg   IN OUT VARCHAR2 ,
   v_errcode  IN OUT VARCHAR2,
   v_errmsg   IN OUT VARCHAR2
);
PROCEDURE PRC_GENSEINFO_PARAM;
PROCEDURE PRC_GEN_MSG_CHGSEINFO(
   v_tltxcd   VARCHAR2,
   v_strMsg   IN OUT VARCHAR2 ,
   v_errcode  IN OUT VARCHAR2,
   v_errmsg   IN OUT VARCHAR2
);
PROCEDURE PRC_GEN_PLACEORDERS(pv_accountNo  IN VARCHAR2,
                              pv_execType   IN VARCHAR2,
                              pv_symbol     IN VARCHAR2,
                              pv_priceType  IN VARCHAR2,
                              pv_price      IN NUMBER,
                              pv_quantity   IN NUMBER,
                              pv_userID     IN VARCHAR2,
                              pv_via        IN VARCHAR2,
                              pv_isdisposal IN VARCHAR2 DEFAULT 'N',
                              pv_timetype   IN VARCHAR2 DEFAULT 'T',
                              pv_strMessage IN OUT VARCHAR2);
PROCEDURE PRC_PLACEORDERS(pv_accountNo   IN VARCHAR2,
                          pv_execType    IN VARCHAR2,
                          pv_symbol      IN VARCHAR2,
                          pv_priceType   IN VARCHAR2,
                          pv_price       IN NUMBER,
                          pv_quantity    IN NUMBER,
                          pv_userID      IN VARCHAR2,
                          pv_via         IN VARCHAR2,
                          pv_isdisposal	 IN VARCHAR2 DEFAULT 'N',
                          pv_timetype	 IN VARCHAR2 DEFAULT 'T',
                          pv_errorCode   OUT VARCHAR2,
                          pv_returnValue OUT VARCHAR2);
END; -- Package spec
/
CREATE OR REPLACE PACKAGE BODY pck_syn2fo
IS
  pkgctx plog.log_ctx;
  logrow tlogdebug%ROWTYPE;

PROCEDURE PRC_PROCESSEVENT
 IS
 v_Tltxcd    VARCHAR2(10);
 v_Acctno    VARCHAR2(10);
 v_strMsg    VARCHAR2(4000);
 v_msgHeader  VARCHAR2(4000);
 v_ErrCode    VARCHAR2(100);
 v_ErrMsg     VARCHAR2(4000);
 v_FOMODE     varchar2(5);
 v_ex        EXCEPTION;
 v_process_type VARCHAR2(10);

BEGIN
 IF  NOT fopks_api.fn_is_ho_active  THEN
    RETURN;
 END IF;

 BEGIN
    SELECT NVL(varvalue, 'OFF') INTO v_FOMODE FROM sysvar WHERE varname = 'FOMODE';
 EXCEPTION WHEN OTHERS THEN
        v_FOMODE:='OFF';
 END;

 IF v_FOMODE = 'OFF' THEN
    RETURN;
 END IF;

 IF to_char(SYSDATE,'SS') IN ('00','01') THEN

    v_process_type:='EN';
 ELSE
    v_process_type:='N';
 END IF;


 FOR i IN (SELECT * FROM t_fo_event WHERE instr(v_process_type,process) >0)
 LOOP

  BEGIN
    v_errcode:= gc_Success; --1.8.1.2: khoi tao gia tri trong moi vong lap
    v_strMsg := ''; -- reset msg
    IF  i.tltxcd  NOT IN ('CHGLNTYPE') THEN

        IF i.tltxcd  ='OPNACCT' THEN
                --Gen msg dong bo FO.
                dbms_output.put_line(' v_account '||i.acctno); PCK_SYN2FO.PRC_OPENACCOUNT_OPNACCT(v_txdate=>to_date(i.txdate,'dd/mm/yyyy'),
                                                v_txnum =>i.txnum,
                                                v_account=>i.acctno,
                                                v_strMsg=>v_strMsg ,
                                                v_errcode=>v_ErrCode,
                                                v_errmsg=>v_ErrMsg);
                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;

          ELSIF i.tltxcd  ='CHGAFTYPE' THEN
                --Gen msg dong bo FO.
                dbms_output.put_line(' v_account '||i.acctno);
                PCK_SYN2FO.PRC_CHANGEAFTYPE(v_txdate=>to_date(i.txdate,'dd/mm/yyyy'),
                                                v_txnum =>i.txnum,
                                                v_account=>i.acctno,
                                                v_tltxcd =>i.tltxcd,
                                                v_strMsg=>v_strMsg ,
                                                v_errcode=>v_ErrCode,
                                                v_errmsg=>v_ErrMsg);
                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;

          ELSIF i.tltxcd  ='CLOSEACCT' THEN
                --Gen msg dong bo FO.

                PCK_SYN2FO.PRC_CHANGESTATUS_ACCT(v_txdate=>to_date(i.txdate,'dd/mm/yyyy'),
                                                v_txnum =>i.txnum,
                                                v_account=>i.acctno,
                                                v_status => i.cvalue,
                                                v_strMsg=>v_strMsg ,
                                                v_errcode=>v_ErrCode,
                                                v_errmsg=>v_ErrMsg);
                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;

           ELSIF i.tltxcd  ='HOLD' THEN
                PCK_SYN2FO.PRC_HOLDAMOUNT(v_reqid=>i.cvalue,
                    v_strMsg=>v_strMsg ,
                    v_errcode=>v_ErrCode,
                    v_errmsg=>v_ErrMsg);

                plog.error(pkgctx, 'PRC_PROCESSEVENT_HOLD - before call FO: ' || v_strMsg);

                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;

             ELSIF i.tltxcd  IN ('3341','3342','3356') THEN
                PCK_SYN2FO.PRC_CAEXEC(v_txdate=>to_date(i.txdate,'dd/mm/yyyy'),
                                                v_txnum =>i.txnum,
                                                v_tltxcd =>i.tltxcd,
                                                v_strMsg=>v_strMsg ,
                                                v_errcode=>v_ErrCode,
                                                v_errmsg=>v_ErrMsg);

                plog.error(pkgctx, 'PRC_CAEXEC - Before call FO: ' || v_strMsg);

                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;

             ELSIF i.tltxcd  IN ('5503','CHGMRPRICE') THEN --giao dich 5503 thay doi basket
                                               --va thay doi gia marignprice trong securities_info
                -- 1.5.8.4|MSBS-1990: Tam Thoi UpDate Da Xu Ly De Tranh Lost Symbol
                UPDATE t_fo_event SET process = 'A' WHERE autoid = i.autoid;
                COMMIT;
                PCK_SYN2FO.PRC_GENSYSTEM_PARAM;
                --Gen msg gui FO
                PCK_SYN2FO.PRC_GEN_MSG_SYSPARAM(v_txdate=>to_date(i.txdate,'dd/mm/yyyy'),
                                                v_txnum =>i.txnum,
                                                v_tltxcd =>i.tltxcd,
                                                v_strMsg=>v_strMsg ,
                                                v_errcode=>v_ErrCode,
                                                v_errmsg=>v_ErrMsg);

                plog.error(pkgctx, 'PRC_GEN_MSG_SYSPARAM - Before call FO: ' || v_strMsg);

                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;

             ELSIF i.tltxcd  IN ('CHGODFEE') THEN
          -- 1.8.1.2
        UPDATE t_fo_event set process ='A' WHERE autoid = i.autoid AND process ='N';
        commit;
                PCK_SYN2FO.PRC_CHANGE_ODFEE;
                --Gen msg gui FO
                PCK_SYN2FO.PRC_GEN_MSG_ODFEE(v_txdate=>to_date(i.txdate,'dd/mm/yyyy'),
                                                v_txnum =>i.txnum,
                                                v_tltxcd =>i.tltxcd,
                                                v_strMsg=>v_strMsg ,
                                                v_errcode=>v_ErrCode,
                                                v_errmsg=>v_ErrMsg);

                plog.error(pkgctx, 'PRC_GEN_MSG_ODFEE - Before call FO: ' || v_strMsg);

                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;

          ELSIF i.tltxcd  IN ('CHGPOOL') THEN

                --Gen msg gui FO
                PCK_SYN2FO.PRC_GEN_MSG_CHGPOOL( v_txdate => '',
                                                v_txnum  => '',
                                                v_PoolID => i.ACCTNO,
                                                v_strMsg=>v_strMsg ,
                                                v_errcode=>v_ErrCode,
                                                v_errmsg=>v_ErrMsg
                                              );

                plog.error(pkgctx, 'PRC_GEN_MSG_CHGPOOL - Before call FO: ' || v_strMsg);

                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;

         ELSIF i.tltxcd  IN ('CHGROOM') THEN
                --Thay doi Room
                --Gen msg gui FO
                PCK_SYN2FO.PRC_GEN_MSG_CHGROOM( v_txdate => '',
                                                v_txnum  => '',
                                                v_ROOMID => i.ACCTNO,
                                                v_Symbol => i.cvalue,
                                                v_strMsg=>v_strMsg ,
                                                v_errcode=>v_ErrCode,
                                                v_errmsg=>v_ErrMsg
                                              );

                plog.error(pkgctx, 'PRC_GEN_MSG_CHGROOM - Before call FO: ' || v_strMsg);

                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;

            ELSIF i.tltxcd  IN ('ADDSPROOM') THEN
                --Them moi room dac biet
                --Gen msg gui FO
                PCK_SYN2FO.PRC_GEN_MSG_ADDSPROOM( v_txdate => '',
                                                v_txnum  => '',
                                                v_RoomID => i.ACCTNO,
                                                v_strMsg=>v_strMsg ,
                                                v_errcode=>v_ErrCode,
                                                v_errmsg=>v_ErrMsg
                                              );

                plog.error(pkgctx, 'PRC_GEN_MSG_ADDSPROOM - Before call FO: ' || v_strMsg);

                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;

         ELSIF i.tltxcd  IN ('ACC2SPROOM') THEN
                --Gan tai khoan vao room dac biet
                --Gen msg gui FO
                PCK_SYN2FO.PRC_GEN_MSG_ACC2SPROOM( v_txdate => '',
                                                v_txnum  => '',
                                                v_RoomID => i.ACCTNO,
                                                v_acctno => i.CVALUE,
                                                v_strMsg=>v_strMsg ,
                                                v_errcode=>v_ErrCode,
                                                v_errmsg=>v_ErrMsg
                                              );

                plog.error(pkgctx, 'PRC_GEN_MSG_ADDSPROOM - Before call FO: ' || v_strMsg);

                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;



         ELSIF i.tltxcd  IN ('CHGDEFRULE') THEN
                --Chan mua, chan ban
                --Gen msg gui FO
                PCK_SYN2FO.PRC_GEN_MSG_CHGDEFRULE( v_txdate => '',
                                                v_txnum  => '',
                                                v_tltxcd => i.tltxcd,
                                                v_strMsg=>v_strMsg ,
                                                v_errcode=>v_ErrCode,
                                                v_errmsg=>v_ErrMsg
                                              );

                plog.error(pkgctx, 'PRC_GEN_MSG_CHGDEFRULE - Before call FO: ' || v_strMsg);

                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;
          ELSIF i.tltxcd  IN ('1141','1204','1114') THEN -- 1.8.2.1: chuyen khoan 2 tk luu ky
                PCK_SYN2FO.PRC_GENMSG2FO(v_txnum  => i.txnum,
                                    v_strMsg=>v_strMsg ,
                                    v_errcode=>v_ErrCode,
                                    v_errmsg=>v_ErrMsg
                                    );

                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;
          ELSIF i.tltxcd  IN ('0111') THEN      --Dong bo thong tin Room (su kien sinh trong giao dich 0111 tren Flex)
                PCK_SYN2FO.PRC_GEN_MSG_SYNROOM(v_txdate =>i.txdate,
                                                  v_txnum    =>i.txnum,
                                                  v_tltxcd   =>i.tltxcd,
                                                  v_Acctno   =>i.acctno,
                                                  v_strMsg   =>v_strMsg ,
                                                  v_errcode  =>v_ErrCode,
                                                  v_errmsg   => v_ErrMsg
                                                  );
          ELSIF i.tltxcd  IN ('1816', '1809') THEN
          --Them tiep cac su kien vao day
            PCK_SYN2FO.PRC_GENMSG2FO(v_txnum  => i.txnum,
                                    v_strMsg=>v_strMsg ,
                                    v_errcode=>v_ErrCode,
                                    v_errmsg=>v_ErrMsg
                                    );

                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;
          ELSIF i.tltxcd  IN ('2285') THEN
          --Them tiep cac su kien vao day
            v_strMsg := '{"msgtype": "tx9001", "symbol" : "'||i.acctno||'"}'  ;
          ELSIF i.tltxcd  IN ('2290','2246','8879') THEN
                PCK_SYN2FO.PRC_GEN_MSG_2290(      v_txnum    =>i.txnum,
                                                  v_strMsg   =>v_strMsg ,
                                                  v_errcode  =>v_ErrCode,
                                                  v_errmsg   => v_ErrMsg
                                                  );
                     IF v_ErrCode <> gc_Success THEN
                      RAISE v_ex;
                    END IF;

          ELSIF i.tltxcd  IN ('8868') THEN
                PCK_SYN2FO.PRC_GENMSG2FO(v_txnum  => i.txnum,
                                    v_strMsg=>v_strMsg ,
                                    v_errcode=>v_ErrCode,
                                    v_errmsg=>v_ErrMsg
                                    );

                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;
          ELSIF i.tltxcd = 'CHGSYSVAR' THEN
             PCK_SYN2FO.PRC_GEN_MSG_CHGSYSVAR(i.tltxcd, i.cvalue, v_strMsg, v_ErrCode, v_ErrMsg);
             IF v_ErrCode <> gc_Success THEN
                RAISE v_ex;
             END IF;
          ELSIF i.tltxcd = 'CHGSEINFO' THEN
             PRC_GENSEINFO_PARAM;
             PCK_SYN2FO.PRC_GEN_MSG_CHGSEINFO(i.tltxcd, v_strMsg, v_ErrCode, v_ErrMsg);
             IF v_ErrCode <> gc_Success THEN
                RAISE v_ex;
             END IF;
          END IF;


          IF i.cvalue IN ('6800','0000') AND i.tltxcd  NOT IN ('1816','2242') THEN --Neu cac giao dich thuc hien tren ONLINE, HOME, MOBILE
                PCK_SYN2FO.PRC_GENMSG2FO(v_txnum  => i.txnum,
                                    v_strMsg=>v_strMsg ,
                                    v_errcode=>v_ErrCode,
                                    v_errmsg=>v_ErrMsg
                                    );

                IF v_ErrCode <> gc_Success THEN
                  RAISE v_ex;
                END IF;
          END IF;

          --Ghi log p_strmsg.
          INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                               VALUES(seq_fo_logcallws.NEXTVAL, i.tltxcd, i.ACCTNO, v_strMsg, SYSTIMESTAMP);
          COMMIT;

          --Call ws
          IF v_strMsg IS NOT NULL THEN
            PCK_SYN2FO.PRC_CALLWEBSERVICE(pv_StrMessage => v_strMsg,
                                          v_errcode     => v_ErrCode,
                                          v_errmsg      => v_ErrMsg,
                                          v_type        => 'BO');
            IF v_ErrCode <> gc_Success THEN
              -- 1.7.4.9: voi 2 sk ADDSPROOM/ cap nhat bang tam thanh tran thai loi
              IF (I.TLTXCD = 'ADDSPROOM')THEN
                UPDATE t_fo_inday_poolroom SET STATUS = 'E' WHERE POLICYCD = i.ACCTNO AND STATUS = 'N';
                COMMIT;
              END IF;
              IF (I.TLTXCD = 'ACC2SPROOM')THEN
                 UPDATE t_fo_inday_ownpoolroom SET STATUS = 'E' WHERE PRID = i.ACCTNO AND ACCTNO = substr(i.CVALUE,2) AND STATUS = 'N';
                 COMMIT;

              END IF;
              RAISE v_ex;
            END IF;
          END IF;
          --Tien trinh xu ly thanh cong.
          UPDATE t_fo_event SET  errcode = v_ErrCode, process ='Y', processtime =SYSTIMESTAMP
          WHERE autoid = i.autoid;
          COMMIT;

    ELSIF i.tltxcd  IN ('CHGLNTYPE') THEN
            --Duyet cac tai khoan
            FOR j IN (SELECT acctno FROM afmast WHERE actype = i.acctno )
            LOOP
                BEGIN
                    --Gen msg dong bo FO.

                    PCK_SYN2FO.PRC_CHANGEAFTYPE(v_txdate=>to_date(i.txdate,'dd/mm/yyyy'),
                                                    v_txnum =>i.txnum,
                                                    v_account=>j.acctno,
                                                    v_tltxcd =>'CHGAFTYPE',
                                                    v_strMsg=>v_strMsg ,
                                                    v_errcode=>v_ErrCode,
                                                    v_errmsg=>v_ErrMsg);
                    IF v_ErrCode <> gc_Success THEN
                      RAISE v_ex;
                    END IF;
                   --Ghi log p_strmsg.
                   INSERT INTO t_fo_logcallws(id , tltxcd , acctno, strmsg , logtime)
                                       VALUES(seq_fo_logcallws.NEXTVAL, i.tltxcd, i.ACCTNO, v_strMsg, SYSTIMESTAMP);
                   COMMIT;
                    --Call ws
                    IF v_strMsg IS NOT NULL then
                        PCK_SYN2FO.PRC_CALLWEBSERVICE(pv_StrMessage => v_strMsg,
                                                      v_errcode     => v_ErrCode,
                                                      v_errmsg      => v_ErrMsg,
                                                      v_type        => 'BO');
                    ELSE
                        v_ErrCode := gc_Success;
                    END IF;

                    IF v_ErrCode <> gc_Success THEN
                      RAISE v_ex;
                    END IF;
                 EXCEPTION
                 WHEN v_ex THEN
                   v_ErrMsg:= v_ErrMsg ||'Acctno '||j.acctno;

                 WHEN OTHERS THEN
                   v_ErrMsg:= v_ErrMsg ||'Acctno '||j.acctno ||' sqlerrm '||sqlerrm;
                 END;
            END LOOP;

            --Tien trinh xu ly thanh cong.
            UPDATE t_fo_event SET  errcode = v_ErrCode, process ='Y', processtime =SYSTIMESTAMP
            WHERE autoid = i.autoid;
            COMMIT;

    END IF;

    EXCEPTION WHEN v_ex THEN
          -- goi 1.7.1.0 iss 2211
          IF i.tltxcd  ='HOLD' AND v_ErrCode LIKE '-95%' THEN
            UPDATE t_fo_event SET  process ='Y', errcode = v_ErrCode, errmsg =  v_ErrMsg, processtime =SYSTIMESTAMP
            WHERE autoid = i.autoid;
          ELSE -- end of -- goi 1.7.1.0 iss 2211
             UPDATE t_fo_event SET  process ='E', errcode = v_ErrCode, errmsg =  v_ErrMsg, processtime =SYSTIMESTAMP
            WHERE autoid = i.autoid;
          END IF;
          COMMIT;
        WHEN OTHERS THEN
          v_ErrMsg:=SQLERRM;
          UPDATE t_fo_event SET  process ='E', errcode = v_ErrCode, errmsg =  v_ErrMsg , processtime =SYSTIMESTAMP
          WHERE autoid = i.autoid;
          COMMIT;
   END;
 END LOOP;
END;

--Dong bo mo tai khoan moi.
PROCEDURE PRC_OPENACCOUNT_OPNACCT(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_account  VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          )
 IS
 v_Tltxcd    VARCHAR2(10):='OPNACCT';
 v_strTxnum  VARCHAR2(100);
 v_strTxdate Date;
 v_Msgformat VARCHAR2(4000);
 v_Txcode    VARCHAR2(100);
 v_Columname VARCHAR2(100);
 v_msgHeader  VARCHAR2(500);

BEGIN
 plog.setbeginsection (pkgctx, 'PRC_OPENACCOUNT_OPNACCT');
 v_errcode:= gc_Success;
 BEGIN
   SELECT  fm.MSGFORMAT, fm.TXCODE INTO v_Msgformat, v_Txcode
     FROM  fotxmap tx, fotxformat fm
    WHERE  tx.TXCODE= fm.TXCODE
      AND  fm.Status = 'Y'  AND  tx.TXCODE ='tx5101' AND tx.TLTXCD = v_tltxcd AND tx.runmod ='DB';
 EXCEPTION WHEN OTHERS THEN
   --dbms_output.put_line('Chua khai bao format cho msg giao dich 0080');
   v_errmsg:= 'Chua khai bao format cho msg giao dich 0080';
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_OPENACCOUNT_OPNACCT');
   RETURN;
 END;

/* --v_msgformat 0080
  {"msgtype" : "<$MSGTYPE>",
   "acctno"  : "<$ACCTNO>",
   "actype"  : "<$ACTYPE>",
   "custid"  : "<$CUSTID>",
   "dof"     : "<$DOF>",
   "grname"  : "<$GRNAME>",
   "policycd" : "<$POLICYCD>",
   "poolid"   : "<$POOLID>",
   "roomid"   : "<$ROOMID>",
   "acclass"  : "<$ACCLASS>",
   "custodycd" : "<$CUSTODYCD>",
   "formulacd" : "<$FORMULACD>",
   "basketid"  : "<$BASKETID>",
   "status"    : "<$STATUS>",
   "trfbuyamt" : <$TRFBUYAMT>,
   "trfbuyext" : <$TRFBUYEXT>,
   "banklink"  : "<$BANKLINK>",
   "bankacctno" : "<$BANKACCTNO>",
   "bankcode"  : "<$BANKCODE>",
   "rate_brk_s" : <$RATE_BRK_S>,
   "rate_brk_b" : <$RATE_BRK_B>,
   "rate_tax"   : <$RATE_TAX>,
   "rate_adv"   : <$RATE_ADV>,
   "ratio_init" : <$RATIO_INIT>,
   "ratio_main" : <$RATIO_MAIN>,
   "ratio_exec" : <$RATIO_EXEC>,
   "ratio_exec" : <$RATIO_EXEC>
   }
*/
     SELECT  '99' || LPAD (seq_batchtxnum.NEXTVAL, 8, '0') txnum  INTO v_strTxnum  FROM dual;
     SELECT to_date(VARVALUE,'DD/MM/YYYY')  INTO v_strTxdate FROM sysvar WHERE  VARNAME='CURRDATE';

     v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "P", "tlxtcd" : "<$TLTXCD>"';
     v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_strTxnum);
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',to_char(v_strTxdate,'dd/mm/yyyy'));
     v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>','');

     FOR rec IN (
       SELECT * FROM  v_fo_account_opn  WHERE ACCTNO = v_account
     )
     LOOP

      v_Msgformat := Replace(v_Msgformat,'<$MSGTYPE>', v_Txcode);
      v_Msgformat := Replace(v_Msgformat,'<$ACCTNO>' , rec.ACCTNO);
      v_Msgformat := Replace(v_Msgformat,'<$ACTYPE>' , rec.ACTYPE);
      v_Msgformat := Replace(v_Msgformat,'<$CUSTID>',  rec.CUSTID);
      v_Msgformat := Replace(v_Msgformat,'<$DOF>',     rec.DOF);
      v_Msgformat := Replace(v_Msgformat,'<$GRNAME>',  rec.GRNAME);
      v_Msgformat := Replace(v_Msgformat,'<$POLICYCD>',rec.POLICYCD);
      v_Msgformat := Replace(v_Msgformat,'<$POOLID>',  rec.POOLID);
      v_Msgformat := Replace(v_Msgformat,'<$ROOMID>',  rec.ROOMID);
      v_Msgformat := Replace(v_Msgformat,'<$ACCLASS>', rec.ACCLASS);
      v_Msgformat := Replace(v_Msgformat,'<$CUSTODYCD>', rec.CUSTODYCD);
      v_Msgformat := Replace(v_Msgformat,'<$FORMULACD>', rec.FORMULACD);
      v_Msgformat := Replace(v_Msgformat,'<$BASKETID>', rec.BASKETID);
      v_Msgformat := Replace(v_Msgformat,'<$STATUS>'  , rec.STATUS);
      v_Msgformat := Replace(v_Msgformat,'<$TRFBUYAMT>', rec.TRFBUYAMT);
      v_Msgformat := Replace(v_Msgformat,'<$TRFBUYEXT>', rec.TRFBUYEXT);
      v_Msgformat := Replace(v_Msgformat,'<$BANKLINK>',  rec.BANKLINK);
      v_Msgformat := Replace(v_Msgformat,'<$BANKACCTNO>', rec.BANKACCTNO);
      v_Msgformat := Replace(v_Msgformat,'<$BANKCODE>',   rec.BANKCODE);
      v_Msgformat := Replace(v_Msgformat,'<$RATE_BRK_S>', rec.RATE_BRK_S);
      v_Msgformat := Replace(v_Msgformat,'<$RATE_BRK_B>', rec.RATE_BRK_B);
      v_Msgformat := Replace(v_Msgformat,'<$RATE_TAX>', rec.RATE_TAX);
      v_Msgformat := Replace(v_Msgformat,'<$RATE_ADV>', rec.RATE_ADV);
      v_Msgformat := Replace(v_Msgformat,'<$RATIO_INIT>', rec.RATIO_INIT);
      v_Msgformat := Replace(v_Msgformat,'<$RATIO_MAIN>', rec.RATIO_MAIN);
      v_Msgformat := Replace(v_Msgformat,'<$RATIO_EXEC>', rec.RATIO_EXEC);
      v_Msgformat := Replace(v_Msgformat,'<$RATE_UB>', rec.RATE_UB);
      v_Msgformat := Replace(v_Msgformat,'<$BASKETID_UB>', rec.BASKETID_UB);
      v_Msgformat := Replace(v_Msgformat,'<$BOD_D_MARGIN_UB>', rec.BOD_D_MARGIN_UB);
      v_Msgformat := Replace(v_Msgformat,'<$BOD_T0VALUE>', rec.BOD_T0VALUE);

     END LOOP;
     v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';
     plog.debug(pkgctx, v_strMsg);


  plog.setendsection (pkgctx, 'PRC_OPENACCOUNT_OPNACCT');
 EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_OPENACCOUNT_OPNACCT');
END;


--Thay doi thong tin loai hinh tai khoan.
PROCEDURE PRC_CHANGEAFTYPE(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_account  VARCHAR2,
          v_tltxcd  VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          )
 IS
 v_strTxnum  VARCHAR2(100);
 v_strTxdate Date;
 v_Msgformat VARCHAR2(4000);
 v_Txcode    VARCHAR2(100);
 v_Columname VARCHAR2(100);
 v_msgHeader  VARCHAR2(500);

BEGIN
 plog.setbeginsection (pkgctx, 'PRC_CHANGEAFTYPE');
 v_errcode:= gc_Success;
 BEGIN
   SELECT  fm.MSGFORMAT, fm.TXCODE INTO v_Msgformat, v_Txcode
     FROM  fotxmap tx, fotxformat fm
    WHERE  tx.TXCODE= fm.TXCODE
      AND  fm.Status = 'Y'  AND  tx.TXCODE ='tx5105' AND tx.TLTXCD = v_tltxcd AND tx.runmod ='DB';
 EXCEPTION WHEN OTHERS THEN
   v_errmsg:= 'Chua khai bao format cho msg giao dich thay doi loai hinh tai khoan CHANGEAFTYPE';
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_CHANGEAFTYPE');
   RETURN;
 END;

/* --v_msgformat change aftype 5105
  {"msgtype" : "<$MSGTYPE>",
   "acctno"  : "<$ACCTNO>",
   "actype"  : "<$ACTYPE>",
   "custid"  : "<$CUSTID>",
   "dof"     : "<$DOF>",
   "grname"  : "<$GRNAME>",
   "policycd" : "<$POLICYCD>",
   "poolid"   : "<$POOLID>",
   "roomid"   : "<$ROOMID>",
   "acclass"  : "<$ACCLASS>",
   "custodycd" : "<$CUSTODYCD>",
   "formulacd" : "<$FORMULACD>",
   "basketid"  : "<$BASKETID>",
   "status"    : "<$STATUS>",
   "trfbuyamt" : <$TRFBUYAMT>,
   "trfbuyext" : <$TRFBUYEXT>,
   "banklink"  : "<$BANKLINK>",
   "bankacctno" : "<$BANKACCTNO>",
   "bankcode"  : "<$BANKCODE>",
   "rate_brk_s" : <$RATE_BRK_S>,
   "rate_brk_b" : <$RATE_BRK_B>,
   "rate_tax"   : <$RATE_TAX>,
   "rate_adv"   : <$RATE_ADV>,
   "ratio_init" : <$RATIO_INIT>,
   "ratio_main" : <$RATIO_MAIN>,
   "ratio_exec" : <$RATIO_EXEC>
   }
*/
     SELECT  '99' || LPAD (seq_batchtxnum.NEXTVAL, 8, '0') txnum  INTO v_strTxnum  FROM dual;
     SELECT to_date(VARVALUE,'DD/MM/YYYY')  INTO v_strTxdate FROM sysvar WHERE  VARNAME='CURRDATE';

     v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "P", "tlxtcd" : "<$TLTXCD>"';
     v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_strTxnum);
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',to_char(v_strTxdate,'dd/mm/yyyy'));
     v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>','');

     FOR rec IN (
       SELECT * FROM  v_fo_account  WHERE ACCTNO = v_account
     )
     LOOP

      v_Msgformat := Replace(v_Msgformat,'<$MSGTYPE>', v_Txcode);
      v_Msgformat := Replace(v_Msgformat,'<$ACCTNO>' , rec.ACCTNO);
      v_Msgformat := Replace(v_Msgformat,'<$ACTYPE>' , rec.ACTYPE);
      v_Msgformat := Replace(v_Msgformat,'<$GRNAME>',  rec.GRNAME);
      v_Msgformat := Replace(v_Msgformat,'<$POLICYCD>',rec.POLICYCD);
      v_Msgformat := Replace(v_Msgformat,'<$POOLID>',  rec.POOLID);
      v_Msgformat := Replace(v_Msgformat,'<$ROOMID>',  rec.ROOMID);
      v_Msgformat := Replace(v_Msgformat,'<$ACCLASS>', rec.ACCLASS);
      v_Msgformat := Replace(v_Msgformat,'<$CUSTODYCD>', rec.CUSTODYCD);
      v_Msgformat := Replace(v_Msgformat,'<$FORMULACD>', rec.FORMULACD);
      v_Msgformat := Replace(v_Msgformat,'<$BASKETID>', rec.BASKETID);
      v_Msgformat := Replace(v_Msgformat,'<$STATUS>'  , rec.STATUS);
      v_Msgformat := Replace(v_Msgformat,'<$TRFBUYAMT>', rec.TRFBUYAMT);
      v_Msgformat := Replace(v_Msgformat,'<$TRFBUYEXT>', rec.TRFBUYEXT);
      v_Msgformat := Replace(v_Msgformat,'<$BANKLINK>',  rec.BANKLINK);
      v_Msgformat := Replace(v_Msgformat,'<$BANKACCTNO>', rec.BANKACCTNO);
      v_Msgformat := Replace(v_Msgformat,'<$BANKCODE>',   rec.BANKCODE);
      v_Msgformat := Replace(v_Msgformat,'<$RATE_BRK_S>', rec.RATE_BRK_S);
      v_Msgformat := Replace(v_Msgformat,'<$RATE_BRK_B>', rec.RATE_BRK_B);
      v_Msgformat := Replace(v_Msgformat,'<$RATE_TAX>',   rec.RATE_TAX);
      v_Msgformat := Replace(v_Msgformat,'<$RATE_ADV>',   rec.RATE_ADV);
      v_Msgformat := Replace(v_Msgformat,'<$RATIO_INIT>', rec.RATIO_INIT);
      v_Msgformat := Replace(v_Msgformat,'<$RATIO_MAIN>', rec.RATIO_MAIN);
      v_Msgformat := Replace(v_Msgformat,'<$RATIO_EXEC>', rec.RATIO_EXEC);
      v_Msgformat := Replace(v_Msgformat,'<$BOD_ADV>', rec.BOD_ADV);
      v_Msgformat := Replace(v_Msgformat,'<$CALC_ADVBAL>', rec.CALC_ADVBAL);
      v_Msgformat := Replace(v_Msgformat,'<$BASKETID_UB>', rec.BASKETID_UB);
      v_Msgformat := Replace(v_Msgformat,'<$BOD_D_MARGIN_UB>', rec.BOD_D_MARGIN_UB);
     END LOOP;
     v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';
     plog.debug(pkgctx, v_strMsg);


  plog.setendsection (pkgctx, 'PRC_CHANGEAFTYPE');
 EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_CHANGEAFTYPE');
END;

PROCEDURE PRC_GENMSG2FO(v_txnum varchar2,
        v_strMsg IN OUT VARCHAR2,
        v_errcode IN OUT VARCHAR2,
        v_errmsg IN OUT VARCHAR2)
IS
    v_Amount    NUMBER;
    v_QTTY      NUMBER;
    v_CODEID    varchar2(30);
    v_SYMBOL    varchar2(30);
    v_ACCTNO    varchar2(30);
    v_strTltxcd varchar2(4);
    v_Txcode    varchar2(10);
    v_DOC       varchar2(1);
    v_EXTRA     NUMBER;
    v_Msgformat VARCHAR2(4000);
    v_MsgformatTotal VARCHAR2(4000);
    v_MsgDetail VARCHAR2(4000);
    v_msgHeader VARCHAR2(500);
    v_Txdate    DATE;
    v_Count     NUMBER;
    v_Date_adv  DATE;
    v_Bod_adv   NUMBER;
    v_advbal    NUMBER;
    v_ISFO      varchar2(1);
    v_TXTYPE    VARCHAR2(100);
BEGIN
    SELECT tltxcd INTO v_strTltxcd FROM tllog WHERE txnum = v_txnum;

    IF NOT NVL(v_strTltxcd, 'ZZZ') = 'ZZZ' THEN

         SELECT to_date(VARVALUE,'DD/MM/YYYY')  INTO v_Txdate FROM sysvar WHERE  VARNAME='CURRDATE';

         v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "A", "tlxtcd" : "<$TLTXCD>"';
         v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
         v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_txnum);
         v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',to_char(v_Txdate,'dd/mm/yyyy'));
         v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>',v_strTltxcd);

        v_Count :=1;
        v_MsgformatTotal := NULL;

        FOR rec IN ( SELECT * FROM FOTXMAP WHERE TLTXCD = v_strTltxcd)
        LOOP

            SELECT MSGFORMAT INTO v_MsgDetail FROM fotxformat WHERE txcode = rec.txcode AND status = 'Y' And rownum = 1;


            IF nvl(rec.amount,'ZZZ') <> 'ZZZ' Then
                SELECT NVL(NVALUE,0) INTO v_Amount FROM tllogfld WHERE txnum = v_txnum AND fldcd = nvl(rec.amount,'ZZZ');
            END if;

            IF nvl(rec.extra,'ZZZ') <> 'ZZZ' Then
                SELECT NVL(NVALUE,0) INTO v_EXTRA FROM tllogfld WHERE txnum = v_txnum AND fldcd = nvl(rec.extra,'ZZZ');
            END if;

            IF nvl(rec.qtty,'ZZZ') <> 'ZZZ' Then
                SELECT NVL(NVALUE,0) INTO v_QTTY FROM tllogfld WHERE txnum = v_txnum AND fldcd = nvl(rec.qtty,'ZZZ');
            END IF;

            IF nvl(rec.codeid,'ZZZ') <> 'ZZZ' Then
                SELECT NVL(CVALUE,'AAA') INTO v_CODEID FROM tllogfld WHERE txnum = v_txnum AND fldcd = nvl(rec.codeid,'ZZZ');
            END IF;


            IF nvl(rec.acctno,'ZZZ') <> 'ZZZ' Then
                SELECT NVL(CVALUE,'AAA') INTO v_ACCTNO FROM tllogfld WHERE txnum = v_txnum AND fldcd = nvl(rec.acctno,'ZZZ');
            END IF;

            IF nvl(rec.symbol,'ZZZ') <> 'ZZZ' Then
                SELECT NVL(CVALUE,'AAA') INTO v_SYMBOL FROM tllogfld WHERE txnum = v_txnum AND fldcd = nvl(rec.symbol,'ZZZ');
            END IF;

            IF NVL(v_CODEID, 'ZZZ') <> 'ZZZ' AND NVL(v_SYMBOL, 'ZZZ') = 'ZZZ' THEN
                SELECT SYMBOL INTO v_SYMBOL From sbsecurities where codeid = v_CODEID;
            END IF;

            IF nvl(rec.txtype,'ZZZ') <> 'ZZZ' Then
                SELECT CVALUE INTO v_TXTYPE FROM tllogfld WHERE txnum = v_txnum AND fldcd = nvl(rec.txtype,'ZZZ');
            END IF;

            v_MsgDetail := Replace(v_MsgDetail,'<$MSGTYPE>', rec.txcode);
            v_MsgDetail := Replace(v_MsgDetail,'<$ACCTNO>' , v_ACCTNO);
            v_MsgDetail := Replace(v_MsgDetail,'<$QTTY>' , TO_CHAR(v_QTTY));
            v_MsgDetail := Replace(v_MsgDetail,'<$TYPE>' , v_TXTYPE);

            if nvl(v_Amount, 0) <> 0 then
                v_MsgDetail := Replace(v_MsgDetail,'<$AMOUNT>' , TO_CHAR(v_Amount));
            ELSIF v_strTltxcd = '1114' AND NVL(v_EXTRA, 0) <> 0 THEN
                v_MsgDetail := Replace(v_MsgDetail,'<$AMOUNT>' , TO_CHAR(v_EXTRA));
            ELSE
                v_MsgDetail := Replace(v_MsgDetail,'<$AMOUNT>' , '0');
            end if;

            v_MsgDetail := Replace(v_MsgDetail,'<$DOC>' , rec.doc);
            v_MsgDetail := Replace(v_MsgDetail,'<$COD>' , rec.doc);
            v_MsgDetail := Replace(v_MsgDetail,'<$CODEID>' , v_CODEID);
            v_MsgDetail := Replace(v_MsgDetail,'<$SYMBOL>' , v_SYMBOL);
            v_MsgDetail := Replace(v_MsgDetail,'<$AMOUNT>' , TO_CHAR(v_EXTRA));
            --1.8.2.5: thue quyen
            v_MsgDetail := Replace(v_MsgDetail,'<$TAXRATE>' , NVL(v_EXTRA,0));

            if v_strTltxcd = '1153' then
                SELECT TO_DATE(CVALUE, systemnums.c_date_format) INTO v_Date_adv FROM tllogfld WHERE txnum = v_txnum AND fldcd = 42;

                if v_Txdate = v_Date_adv then
                    v_advbal := v_Amount;
                    v_Bod_adv := 0;
                else
                    v_advbal := 0;
                    v_Bod_adv := v_Amount;
                end if;

                if nvl(v_advbal, 0) <> 0 then
                    v_MsgDetail := Replace(v_MsgDetail,'<$CALC_ADVBAL>' , TO_CHAR(v_advbal));
                else
                    v_MsgDetail := Replace(v_MsgDetail,'<$CALC_ADVBAL>' , '0');
                end if;

                if nvl(v_Bod_adv, 0) <> 0 then
                    v_MsgDetail := Replace(v_MsgDetail,'<$BOD_ADV>' , TO_CHAR(v_Bod_adv));
                Else
                    v_MsgDetail := Replace(v_MsgDetail,'<$BOD_ADV>' , '0');
                end if;

                if nvl(v_Amount, 0) <> 0 then
                    v_MsgDetail := Replace(v_MsgDetail,'<$BOD_BALANCE>' , TO_CHAR(v_Amount));
                Else
                    v_MsgDetail := Replace(v_MsgDetail,'<$BOD_BALANCE>' , '0');
                end if;
            end if;

            -- 1.5.8.9|iss:2056 Dong bo theo TK thi k can check
            IF v_strTltxcd NOT IN ('1809') THEN
               plog.debug(pkgctx, ' v_ACCTNO :'||v_ACCTNO);
               BEGIN
                  SELECT NVL(ISFO, 'N') INTO v_ISFO FROM afmast WHERE acctno = v_ACCTNO;
               exception
               when others then
                 v_ISFO := 'N';
               end;

               IF v_ISFO = 'N' THEN
                   v_MsgDetail := NULL;
               END IF;
            END IF;

            v_MsgformatTotal := v_MsgformatTotal || v_MsgDetail;

            IF v_MsgDetail IS NOT NULL THEN
                IF v_Count = 1 THEN
                   v_Msgformat := v_MsgDetail;
                ELSE
                   v_Msgformat := v_Msgformat || ',' || v_MsgDetail;
                END IF;

                v_Count := v_Count + 1;
            END IF;

        END LOOP;

        IF v_MsgformatTotal IS NULL THEN
            v_strMsg := NULL;
        ELSE
            v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';
        END IF;

        plog.debug(pkgctx, v_strMsg);

        plog.setendsection (pkgctx, 'PRC_GENMSG2FO');


    END IF;

EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_GENMSG2FO');
END;


PROCEDURE PRC_GEN7001MSG2FO(v_OrderId varchar2,
        v_strMsg IN OUT VARCHAR2,
        v_errcode IN OUT VARCHAR2,
        v_errmsg IN OUT VARCHAR2)
IS
BEGIN
    v_errcode := '0';
    v_strMsg := '{"msgtype" : "tx7001", "orderid" : "<$ORDERID>"}';
    v_strMsg := Replace(v_strMsg,'<$ORDERID>' , v_OrderId);

EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_GENMSG2FO');
END;

--{"msgtype":"tx2006","userid":"0001","via":"B","symbol":"ABT","acctno":"0001000089","orderid":"201506190002809988"}
PROCEDURE PRC_GEN_RELEASEOD_MSG2FO(v_userid varchar2,v_via varchar2,v_symbol varchar2,v_Acctno varchar2,v_OrderId varchar2,
        v_strMsg IN OUT VARCHAR2,
        v_errcode IN OUT VARCHAR2,
        v_errmsg IN OUT VARCHAR2)
IS
BEGIN
    v_errcode := '0';
    v_strMsg := '{"msgtype" : "tx2006", "userid" : "<$USERID>", "via" : "<$VIA>", "symbol" : "<$SYMBOL>", "acctno" : "<$ACCTNO>", "orderid" : "<$ORDERID>"}';
    v_strMsg := Replace(v_strMsg,'<$USERID>',  v_userid);
    v_strMsg := Replace(v_strMsg,'<$VIA>' ,    v_via);
    v_strMsg := Replace(v_strMsg,'<$SYMBOL>' , v_symbol);
    v_strMsg := Replace(v_strMsg,'<$ACCTNO>' , v_Acctno);
    v_strMsg := Replace(v_strMsg,'<$ORDERID>', v_OrderId);

EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
END;



PROCEDURE PRC_GEN9000MSG2FO(v_EXCHANGE varchar2,
        v_SESSIONEX VARCHAR2,
        v_strMsg IN OUT VARCHAR2,
        v_errcode IN OUT VARCHAR2,
        v_errmsg IN OUT VARCHAR2)
IS
BEGIN
    v_errcode := '0';
    v_strMsg := '{"msgtype":"tx9000","type":"market","message" : "{\"Id\": \"\",\"sequenceMsg\": 0,\"marketCode\": \"<$EXCHANGE>\",\"marketStatus\": \"<$SESSIONEX>\"}"}';
    v_strMsg := Replace(v_strMsg,'<$EXCHANGE>' , v_EXCHANGE);
    v_strMsg := Replace(v_strMsg,'<$SESSIONEX>' , v_SESSIONEX);

EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_GENMSG2FO');
END;

PROCEDURE PRC_HOLDAMOUNT(v_reqid varchar2,
        v_strMsg IN OUT VARCHAR2,
        v_errcode IN OUT VARCHAR2,
        v_errmsg IN OUT VARCHAR2)
IS
     v_strTxnum  VARCHAR2(100);
     v_strTxdate Date;
     v_Msgformat VARCHAR2(4000);
     v_Txcode    VARCHAR2(100);
     v_Columname VARCHAR2(100);
     v_msgHeader  VARCHAR2(500);
     v_DOC      VARCHAR2(1);
     v_forequestid varchar2(50);
BEGIN
    BEGIN
        SELECT  fm.MSGFORMAT, fm.TXCODE, tx.doc INTO v_Msgformat, v_Txcode, v_DOC
             FROM  fotxmap tx, fotxformat fm
            WHERE  tx.TXCODE= fm.TXCODE
              AND  fm.Status = 'Y'  AND  tx.TXCODE ='tx5104' AND tx.TLTXCD = 'HOLD' AND tx.runmod ='DB';
         EXCEPTION WHEN OTHERS THEN
           --dbms_output.put_line('Chua khai bao format cho msg giao dich 0080');
           v_errmsg:= 'Chua khai bao format cho msg giao dich 0080';
           v_errcode:=errnums.C_SYSTEM_ERROR;
           plog.setendsection (pkgctx, 'PRC_HOLDAMOUNT');
           RETURN;
     END;

     SELECT  '99' || LPAD (seq_batchtxnum.NEXTVAL, 8, '0') txnum  INTO v_strTxnum  FROM dual;
     SELECT to_date(VARVALUE,'DD/MM/YYYY')  INTO v_strTxdate FROM sysvar WHERE  VARNAME='CURRDATE';

     v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "A", "tlxtcd" : "<$TLTXCD>"';
     v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_strTxnum);
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',to_char(v_strTxdate,'dd/mm/yyyy'));
     v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>','');

    FOR rec IN (
       SELECT * FROM crbtxreq where reqid = v_reqid And Status IN ('C','E')
     )
     LOOP
        v_Msgformat := Replace(v_Msgformat,'<$MSGTYPE>', v_Txcode);
        v_Msgformat := Replace(v_Msgformat,'<$ACCTNO>' , rec.afacctno);

        --Lay requestID FO trong bang map
        BEGIN
         SELECT n.foreq INTO v_forequestid FROM  newfo_crbtxreqmap n  WHERE n.reqid = v_reqid;
        EXCEPTION WHEN OTHERS THEN
          v_forequestid :=NULL;
        END;
        --v_Msgformat := Replace(v_Msgformat,'<$REQUESTID>' , rec.reqid);
        v_Msgformat := Replace(v_Msgformat,'<$REQUESTID>' , v_forequestid);
        v_Msgformat := Replace(v_Msgformat,'<$AMOUNT>' , rec.txamt);
        v_Msgformat := Replace(v_Msgformat,'<$DOC>' , v_DOC);
        v_Msgformat := Replace(v_Msgformat,'<$ERRORCODE>' , nvl(rec.errorcode, '0'));
        v_Msgformat := Replace(v_Msgformat,'<$ERRORMSG>' , nvl(rec.notes,''));


     END LOOP;

     v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';
     plog.debug(pkgctx, v_strMsg);

     plog.setendsection (pkgctx, 'PRC_HOLDAMOUNT');
EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_HOLDAMOUNT');
END;

--Dong bo dong, block tai khoan.
PROCEDURE PRC_CHANGESTATUS_ACCT(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_account  VARCHAR2,
          v_status   VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          )
 IS
 v_Tltxcd    VARCHAR2(10):='CLOSEACCT';
 v_strTxnum  VARCHAR2(100);
 v_strTxdate Date;
 v_Msgformat VARCHAR2(4000);
 v_Txcode    VARCHAR2(100);
 v_Columname VARCHAR2(100);
 v_msgHeader  VARCHAR2(500);

BEGIN
 plog.setbeginsection (pkgctx, 'PRC_CLOSEACCT');
 v_errcode:= gc_Success;
 BEGIN


  SELECT  fm.MSGFORMAT, fm.TXCODE INTO v_Msgformat, v_Txcode
     FROM  fotxmap tx, fotxformat fm
    WHERE  tx.TXCODE= fm.TXCODE
      AND  fm.Status = 'Y'  AND  tx.TXCODE ='tx5106'
      AND tx.TLTXCD = v_tltxcd
      AND tx.runmod ='DB';

 EXCEPTION WHEN OTHERS THEN
   --dbms_output.put_line('Chua khai bao format cho msg giao dich 0080');
   v_errmsg:= 'Chua khai bao format cho msg CLOSEACCT';
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_CLOSEACCT');
   RETURN;
 END;

     SELECT  '99' || LPAD (seq_batchtxnum.NEXTVAL, 8, '0') txnum  INTO v_strTxnum  FROM dual;
     SELECT to_date(VARVALUE,'DD/MM/YYYY')  INTO v_strTxdate FROM sysvar WHERE  VARNAME='CURRDATE';

     v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "P", "tlxtcd" : "<$TLTXCD>"';
     v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_strTxnum);
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',to_char(v_strTxdate,'dd/mm/yyyy'));
     v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>','');

     --{"msgtype" : "<$MSGTYPE>", "acctno" : "<$ACCTNO>", "status" : "<$STATUS>"}


      v_Msgformat := Replace(v_Msgformat,'<$MSGTYPE>', v_Txcode);
      v_Msgformat := Replace(v_Msgformat,'<$ACCTNO>' , v_account);
      v_Msgformat := Replace(v_Msgformat,'<$STATUS>' , v_status);

     v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';
     plog.debug(pkgctx, v_strMsg);


  plog.setendsection (pkgctx, 'PRC_CLOSEACCT');
 EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_CLOSEACCT');
END;


PROCEDURE PRC_CAEXEC(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_tltxcd VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          )
IS
     v_strTxnum  VARCHAR2(100);
     v_strTxdate Date;
     v_Msgformat VARCHAR2(4000);
     v_Txcode    VARCHAR2(100);
     v_Columname VARCHAR2(100);
     v_msgHeader  VARCHAR2(500);
     v_DOC      VARCHAR2(1);
BEGIN
    plog.SETBEGINSECTION (pkgctx, 'PRC_CAEXEC');
    BEGIN
        SELECT  fm.MSGFORMAT, fm.TXCODE, tx.doc INTO v_Msgformat, v_Txcode, v_DOC
             FROM  fotxmap tx, fotxformat fm
            WHERE  tx.TXCODE= fm.TXCODE
              AND  fm.Status = 'Y'  AND  tx.TXCODE ='tx5102' AND tx.TLTXCD = v_tltxcd  AND tx.runmod ='DB';
         EXCEPTION WHEN OTHERS THEN
           --dbms_output.put_line('Chua khai bao format cho msg giao dich 0080');
           v_errmsg:= 'Chua khai bao format cho msg giao dich 0080';
           v_errcode:=errnums.C_SYSTEM_ERROR;
           plog.setendsection (pkgctx, 'PRC_CAEXEC');
           RETURN;
     END;

     v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "A", "tlxtcd" : "<$TLTXCD>"';
     v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_txnum);
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',to_char(v_txdate,'dd/mm/yyyy'));
     v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>',v_tltxcd);

    v_Msgformat := Replace(v_Msgformat,'<$MSGTYPE>', v_Txcode);
    v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';
    plog.debug(pkgctx, v_strMsg);

    plog.setendsection (pkgctx, 'PRC_CAEXEC');
EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_CAEXEC');
END;


PROCEDURE PRC_GEN_MSG_SYSPARAM(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_tltxcd VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          )
IS
     v_strTxnum  VARCHAR2(100);
     v_strTxdate Date;
     v_Msgformat VARCHAR2(4000);
     v_Txcode    VARCHAR2(100);
     v_Columname VARCHAR2(100);
     v_msgHeader  VARCHAR2(500);
     v_DOC      VARCHAR2(1);
BEGIN
     plog.SETBEGINSECTION (pkgctx, 'PRC_GEN_MSG_SYSPARAM');
    BEGIN
        SELECT  fm.MSGFORMAT, fm.TXCODE, tx.doc INTO v_Msgformat, v_Txcode, v_DOC
             FROM  fotxmap tx, fotxformat fm
            WHERE  tx.TXCODE= fm.TXCODE
              AND  fm.Status = 'Y'  AND  tx.TXCODE ='tx3016' AND tx.TLTXCD IN ('5503')  AND tx.runmod ='DB';
         EXCEPTION WHEN OTHERS THEN
           --dbms_output.put_line('Chua khai bao format cho msg giao dich 0080');
           v_errmsg:= 'Chua khai bao format cho msg giao dich 5503';
           v_errcode:=errnums.C_SYSTEM_ERROR;
           plog.setendsection (pkgctx, 'PRC_GEN_MSG_SYSPARAM');
           RETURN;
     END;
     SELECT  '99' || LPAD (seq_batchtxnum.NEXTVAL, 8, '0') txnum  INTO v_strTxnum  FROM dual;
     SELECT to_date(VARVALUE,'DD/MM/YYYY')  INTO v_strTxdate FROM sysvar WHERE  VARNAME='CURRDATE';

     v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "A", "tlxtcd" : "<$TLTXCD>"';
     v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_strTxnum);
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',to_char(v_strTxdate,'dd/mm/yyyy'));
     v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>',v_tltxcd);

    v_Msgformat := Replace(v_Msgformat,'<$MSGTYPE>', v_Txcode);
    v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';
    plog.debug(pkgctx, v_strMsg);

    plog.setendsection (pkgctx, 'PRC_GEN_MSG_SYSPARAM');
EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_GEN_MSG_SYSPARAM');
END;


PROCEDURE PRC_GEN_MSG_ODFEE(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_tltxcd VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          )
IS
     v_strTxnum  VARCHAR2(100);
     v_strTxdate Date;
     v_Msgformat VARCHAR2(4000);
     v_Txcode    VARCHAR2(100);
     v_Columname VARCHAR2(100);
     v_msgHeader  VARCHAR2(500);
     v_DOC      VARCHAR2(1);
BEGIN
     plog.SETBEGINSECTION (pkgctx, 'PRC_GEN_MSG_ODFEE');
     SELECT  '99' || LPAD (seq_batchtxnum.NEXTVAL, 8, '0') txnum  INTO v_strTxnum  FROM dual;
     SELECT to_date(VARVALUE,'DD/MM/YYYY')  INTO v_strTxdate FROM sysvar WHERE  VARNAME='CURRDATE';


    BEGIN
        SELECT  fm.MSGFORMAT, fm.TXCODE, tx.doc INTO v_Msgformat, v_Txcode, v_DOC
             FROM  fotxmap tx, fotxformat fm
            WHERE  tx.TXCODE= fm.TXCODE
              AND  fm.Status = 'Y'  AND  tx.TXCODE ='tx5109' AND tx.TLTXCD = v_tltxcd  AND tx.runmod ='DB';
         EXCEPTION WHEN OTHERS THEN
           --dbms_output.put_line('Chua khai bao format cho msg giao dich 0080');
           v_errmsg:= 'Chua khai bao format cho msg giao dich tx5109';
           v_errcode:=errnums.C_SYSTEM_ERROR;
           plog.setendsection (pkgctx, 'PRC_GEN_MSG_SYSPARAM');
           RETURN;
     END;

     v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "A", "tlxtcd" : "<$TLTXCD>"';
     v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_strTxnum);
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',to_char(v_strTxdate,'dd/mm/yyyy'));
     v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>',v_tltxcd);

    v_Msgformat := Replace(v_Msgformat,'<$MSGTYPE>', v_Txcode);
    v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';
    plog.debug(pkgctx, v_strMsg);

    plog.setendsection (pkgctx, 'PRC_GEN_MSG_ODFEE');
EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_GEN_MSG_ODFEE');
END;

PROCEDURE PRC_CALLWEBSERVICE(pv_StrMessage VARCHAR2,v_errcode IN OUT VARCHAR2,
                             v_errmsg IN OUT VARCHAR2,v_Type VARCHAR2 DEFAULT NULL)  --v_Type: 'FO' call FOService, 'BO' call BOService
IS
    l_http_request   UTL_HTTP.req;
    l_http_response  UTL_HTTP.resp;
    l_buffer         VARCHAR2(4000);
    l_buffer_size    NUMBER(10) := 512;
    l_line_size      NUMBER(10) := 50;
    l_lines_count    NUMBER(10) := 20;
    l_string_request VARCHAR2(4000);
    l_line           VARCHAR2(4000);
    l_substring_msg  VARCHAR2(4000);
    l_raw_data       RAW(4000);
    l_clob_response  CLOB;
    v_sqlerrm        VARCHAR2(4000);
    l_UrlWS          VARCHAR2(4000);

BEGIN
    plog.setbeginsection (pkgctx, 'PRC_CALLWEBSERVICE');
    v_errcode:=gc_Success;
    IF v_Type IS NULL OR v_Type ='BO' THEN
        l_string_request := '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:tem="http://tempuri.org/" xmlns:wsa="http://www.w3.org/2005/08/addressing">
           <soap:Header> <wsa:Action>http://tempuri.org/IHOSTService/MessageStringFO</wsa:Action></soap:Header>
           <soap:Body>
              <tem:MessageStringFO>
                  <tem:pv_strMessage>'||pv_StrMessage||'
                 </tem:pv_strMessage>
              </tem:MessageStringFO>
           </soap:Body>
       </soap:Envelope>';
   ELSE
        l_string_request := '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:tem="http://tempuri.org/" xmlns:wsa="http://www.w3.org/2005/08/addressing">
           <soap:Header> <wsa:Action>http://tempuri.org/IHOSTService/MessageStringFOLong</wsa:Action></soap:Header>
           <soap:Body>
              <tem:MessageStringFOLong>
                  <tem:pv_strMessage>'||pv_StrMessage||'
                 </tem:pv_strMessage>
              </tem:MessageStringFOLong>
           </soap:Body>
       </soap:Envelope>';
   END IF;

   BEGIN
    SELECT  VARVALUE INTO l_UrlWS  FROM sysvar WHERE  VARNAME ='HOSTSERVICEURL';
   EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx,'l_UrlWS is missing in sysvar');
    l_UrlWS :=NULL;
    RETURN;
   END;
   UTL_HTTP.set_transfer_timeout(180);
   l_http_request := UTL_HTTP.begin_request(url => l_UrlWS, method => 'POST', http_version => 'HTTP/1.1');

   UTL_HTTP.set_header(l_http_request, 'User-Agent', 'Mozilla/4.0');
   UTL_HTTP.set_header(l_http_request, 'Content-Type', 'application/soap+xml;charset=UTF-8');
   IF v_Type IS NULL OR v_Type ='BO' Then
      UTL_HTTP.set_header(l_http_request, 'action', '"http://tempuri.org/IHOSTService/MessageStringFO"');
   ELSE
      UTL_HTTP.set_header(l_http_request, 'action', '"http://tempuri.org/IHOSTService/MessageStringFOLong"');
   END IF;
   UTL_HTTP.set_header(l_http_request, 'Content-Length', LENGTHB(l_string_request));

    <<request_loop>>
    FOR i IN 0..CEIL(LENGTHB(l_string_request) / l_buffer_size) - 1 LOOP
        l_substring_msg := SUBSTR(l_string_request, i * l_buffer_size + 1, l_buffer_size);
        plog.debug(pkgctx, 'l_substring_msg '||l_substring_msg);
        BEGIN
            l_raw_data := utl_raw.cast_to_raw(l_substring_msg);
            UTL_HTTP.write_raw(r => l_http_request, data => l_raw_data);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    EXIT request_loop;
        END;
     END LOOP request_loop;

     l_http_response := UTL_HTTP.get_response(l_http_request);

     plog.debug(pkgctx,'l_string_request: '||l_string_request);
     plog.debug(pkgctx,'status_code '||l_http_response.status_code);
     plog.debug(pkgctx,'reason_phrase '||l_http_response.reason_phrase);

     v_errmsg:= l_http_response.reason_phrase;


     IF l_http_response.status_code = gc_CallWSSuccessCode THEN
          BEGIN
            LOOP
              utl_http.read_line(l_http_response, l_buffer);
              IF v_Type IS NULL OR v_Type ='BO' THEN
                  v_errcode:=
                    substr(l_buffer,
                           instr(l_buffer,'<MessageStringFOResult>') + length('<MessageStringFOResult>'),
                           instr(l_buffer,'</MessageStringFOResult>')
                            -  instr(l_buffer,'<MessageStringFOResult>') - length('<MessageStringFOResult>')
                           );
              ELSE
                   v_errcode:=
                    substr(l_buffer,
                           instr(l_buffer,'<MessageStringFOLongResult>') + length('<MessageStringFOLongResult>'),
                           instr(l_buffer,'</MessageStringFOLongResult>')
                            -  instr(l_buffer,'<MessageStringFOLongResult>') - length('<MessageStringFOLongResult>')
                           );
              END IF;
              plog.debug(pkgctx,'l_buffer '||l_buffer);
              plog.debug(pkgctx,'v_errcode '||v_errcode);
              plog.debug(pkgctx,'l_http_response.status_code '||l_http_response.status_code);
              IF   v_errcode <>  l_http_response.status_code THEN
                EXIT;
              END IF;
            END LOOP;

         EXCEPTION
          WHEN utl_http.end_of_body THEN
            utl_http.end_response(l_http_response);
          END;
          utl_http.end_response(l_http_response);
     ELSE
      v_errcode:=l_http_response.status_code;
      utl_http.end_response(l_http_response);
     END IF;
   plog.setendsection (pkgctx, 'PRC_CALLWEBSERVICE');
   EXCEPTION WHEN OTHERS THEN
   v_sqlerrm:='Loi ' ||SQLERRM;
   plog.error(pkgctx,'l_string_request: '||l_string_request);
   plog.error(pkgctx,v_sqlerrm);
   UTL_HTTP.end_response(l_http_response);
   plog.setendsection (pkgctx, 'PRC_CALLWEBSERVICE');
END;

PROCEDURE PRC_GENSYSTEM_PARAM
IS
v_count number(20);

BEGIN
    SELECT count(*) INTO v_count FROM T_FO_TMP_BASKET;
    IF v_count =0 THEN
          INSERT INTO  T_FO_TMP_BASKET SELECT * FROM  T_FO_BASKET;

    END IF;

  -- 1.5.8.4|MSBS-1990: Su dung bang t_fo_buf_basket Thay View v_fO_BASKET
  DELETE FROM t_fo_buf_basket;
  INSERT INTO t_fo_buf_basket (basketid, symbol, price_margin, price_asset,
                 rate_buy, rate_margin, rate_asset, txdate, lastchange)
    SELECT  basketid, symbol, price_margin, price_asset,
                 rate_buy, rate_margin, rate_asset, txdate,
                systimestamp lastchange
    FROM v_fO_BASKET;

    --So sanh du lieu
    --1.Neu co trong view, ko co trong bang Temp thi tao moi:
    INSERT INTO T_FO_INDAY_BASKET
    (basketid, symbol, price_margin, price_asset,
                 rate_buy, rate_margin, rate_asset, txdate, lastchange, ACTIONTYPE, status)
     SELECT  basketid, symbol, price_margin, price_asset,
                 rate_buy, rate_margin, rate_asset, txdate, systimestamp lastchange, 'I' ACTIONTYPE,'N' status
     FROM   t_fo_buf_basket v WHERE NOT EXISTS (SELECT * FROM T_FO_TMP_BASKET t
                                           WHERE t.basketid = v.basketid
                                             AND t.symbol   =v.symbol);


    --Neu co trong Temp ma khong co trong view la Delete

    INSERT INTO T_FO_INDAY_BASKET
    (basketid, symbol, price_margin, price_asset,
                 rate_buy, rate_margin, rate_asset, txdate,  lastchange, ACTIONTYPE, status)
     SELECT  basketid, symbol, price_margin, price_asset,
                 rate_buy, rate_margin, rate_asset, txdate, SYSTIMESTAMP lastchange, 'D' ACTIONTYPE,'N' status
     FROM  T_FO_TMP_BASKET v WHERE NOT EXISTS (SELECT * FROM t_fo_buf_basket t
                                           WHERE t.basketid = v.basketid
                                             AND t.symbol   =v.symbol);
    --Neu du lieu khac nhau giua lan dong bo cuoi cung (temp) va hien tai (view) thi update
    INSERT INTO T_FO_INDAY_BASKET
    (basketid, symbol, price_margin, price_asset,
                 rate_buy, rate_margin, rate_asset, txdate, lastchange, ACTIONTYPE, status)
     SELECT   v.basketid, v.symbol, v.price_margin, v.price_asset,
              v.rate_buy, v.rate_margin, v.rate_asset, v.txdate, SYSTIMESTAMP lastchange, 'U' ACTIONTYPE,'N' status
     FROM   t_fo_buf_basket v , T_FO_TMP_BASKET t WHERE t.basketid = v.basketid
                                                AND t.symbol   =v.symbol
                                                AND (t.price_margin<> v.price_margin
                                                   OR t.price_asset<> v.price_asset
                                                   OR t.rate_buy   <> v.rate_buy
                                                   OR t.rate_margin <> v.rate_margin
                                                   OR t.rate_asset  <> v.rate_asset )
                                                    ;

    --Dua du lieu sau khi thay doi vao bang TMP.
    DELETE FROM T_FO_TMP_BASKET ;
    INSERT INTO T_FO_TMP_BASKET (basketid, symbol, price_margin, price_asset,
                 rate_buy, rate_margin, rate_asset, txdate, lastchange)
    SELECT  basketid, symbol, price_margin, price_asset,
                 rate_buy, rate_margin, rate_asset, txdate,
                systimestamp lastchange
    FROM t_fo_buf_basket;
    COMMIT;
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
END;

PROCEDURE PRC_CHANGE_ODFEE
IS
v_count number(20);

BEGIN
    SELECT count(*) INTO v_count FROM T_FO_TMP_ODFEE;
    IF v_count =0 THEN
          INSERT INTO  T_FO_TMP_ODFEE(ACCTNO,RATE_BRK_S, RATE_BRK_B, LASTCHANGE )
          SELECT ACCTNO,RATE_BRK_S, RATE_BRK_B, systimestamp FROM T_FO_ACCOUNT ;

    END IF;
    COMMIT;
    --So sanh du lieu
  --1.8.1.2: BUF lai thong tin hien tai
    DELETE FROM T_FO_BUF_ODFEE;
    INSERT INTO T_FO_BUF_ODFEE(ACCTNO,RATE_BRK_S, RATE_BRK_B, LASTCHANGE)
    SELECT ACCTNO,RATE_BRK_S, RATE_BRK_B, systimestamp
    FROM v_fo_tmp_odfee;
    --1.Neu co trong view, ko co trong bang Temp thi tao moi:
    INSERT INTO T_FO_INDAY_ODFEE
    (ACCTNO,RATE_BRK_S, RATE_BRK_B, LASTCHANGE, ACTIONTYPE, STATUS)
    SELECT  ACCTNO,RATE_BRK_S, RATE_BRK_B, systimestamp lastchange, 'U' ACTIONTYPE,'N' status
    FROM   T_FO_BUF_ODFEE v WHERE NOT EXISTS (SELECT * FROM T_FO_TMP_ODFEE t
                                           WHERE t.acctno = v.acctno );

    COMMIT;
    --Neu co trong Temp ma khong co trong view la Delete

    INSERT INTO T_FO_INDAY_ODFEE
    (ACCTNO,RATE_BRK_S, RATE_BRK_B, LASTCHANGE, ACTIONTYPE, STATUS)
     SELECT  ACCTNO,RATE_BRK_S, RATE_BRK_B, SYSTIMESTAMP lastchange, 'U' ACTIONTYPE,'N' status
     FROM  T_FO_TMP_ODFEE v WHERE NOT EXISTS (SELECT * FROM T_FO_BUF_ODFEE t
                                           WHERE  t.acctno = v.acctno );
    --Neu du lieu khac nhau thi update
    INSERT INTO T_FO_INDAY_ODFEE
    (ACCTNO,RATE_BRK_S, RATE_BRK_B, LASTCHANGE, ACTIONTYPE, STATUS)
     SELECT   v.ACCTNO, v.RATE_BRK_S, v.RATE_BRK_B, SYSTIMESTAMP lastchange, 'U' ACTIONTYPE,'N' status
     FROM   T_FO_BUF_ODFEE v , T_FO_TMP_ODFEE t WHERE t.acctno = v.acctno
                                                AND (t.RATE_BRK_S<> v.RATE_BRK_S
                                                   OR t.RATE_BRK_B   <> v.RATE_BRK_B
                                                    )
                                                    ;
    COMMIT;
    --Dua du lieu sau khi thay doi vao bang TMP.
    DELETE FROM T_FO_TMP_ODFEE ;
    INSERT INTO T_FO_TMP_ODFEE (ACCTNO,RATE_BRK_S, RATE_BRK_B, LASTCHANGE)
            Select ACCTNO,RATE_BRK_S, RATE_BRK_B, systimestamp lastchange
            FROM T_FO_BUF_ODFEE ;
    COMMIT;
END;

PROCEDURE PRC_GEN_MSG_CHGPOOL(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_PoolID VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          )
IS
     v_strTxnum  VARCHAR2(100);
     v_strTxdate Date;
     v_Msgformat VARCHAR2(4000);
     v_Txcode    VARCHAR2(100);
     v_Columname VARCHAR2(100);
     v_msgHeader  VARCHAR2(500);
     v_DOC      VARCHAR2(1);
BEGIN
     plog.SETBEGINSECTION (pkgctx, 'PRC_GEN_MSG_CHGPOOL');
     SELECT  '99' || LPAD (seq_batchtxnum.NEXTVAL, 8, '0') txnum  INTO v_strTxnum  FROM dual;
     SELECT to_date(VARVALUE,'DD/MM/YYYY')  INTO v_strTxdate FROM sysvar WHERE  VARNAME='CURRDATE';
     v_strMsg:=NULL;
     FOR rec IN ( SELECT   DECODE(p.TYPE,'AFTYPE','SYSTEM','UB') policycd, prs.prtyp policytype,
                     scr.shortcd refsymbol,
                     prs.prlimit granted, prs.prinused inused
                  FROM   prmaster prs, sbcurrency scr ,PRTYPE p, PRTYPEMAP ptm
                 WHERE   prs.prtyp = 'P' AND prs.codeid = scr.ccycd
                    AND prs.PRCODE = ptm.PRCODE AND  ptm.PRTYPE =P.actype
                   AND   prs.PRCODE =v_PoolID
             )
     LOOP


         v_Msgformat:='{"msgtype" : "tx5014" , "amount" : <$AMOUNT>, "doc" : "<$DORC>", "poolid" : "<$POOLID>"}';
         v_Msgformat := Replace(v_Msgformat,'<$AMOUNT>', rec.granted);
         v_Msgformat := Replace(v_Msgformat,'<$DORC>', 'C');
         v_Msgformat := Replace(v_Msgformat,'<$POOLID>', rec.policycd);

         v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "A", "tlxtcd" : "<$TLTXCD>"';
         v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
         v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_strTxnum);
         v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',to_char(v_strTxdate,'dd/mm/yyyy'));
         v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>','');


         v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';
         plog.debug(pkgctx, v_strMsg);
    END LOOP;
    plog.setendsection (pkgctx, 'PRC_GEN_MSG_CHGPOOL');
EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_GEN_MSG_CHGPOOL');
END;


PROCEDURE PRC_GEN_MSG_CHGROOM(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_RoomID VARCHAR2,
          v_Symbol VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          )
IS
     v_strTxnum  VARCHAR2(100);
     v_strTxdate Date;
     v_Msgformat VARCHAR2(4000);
     v_Txcode    VARCHAR2(100);
     v_Columname VARCHAR2(100);
     v_msgHeader  VARCHAR2(500);
     v_DOC      VARCHAR2(1);
BEGIN
     plog.SETBEGINSECTION (pkgctx, 'PRC_GEN_MSG_CHGROOM');
     SELECT  '99' || LPAD (seq_batchtxnum.NEXTVAL, 8, '0') txnum  INTO v_strTxnum  FROM dual;
     SELECT to_date(VARVALUE,'DD/MM/YYYY')  INTO v_strTxdate FROM sysvar WHERE  VARNAME='CURRDATE';
     v_strMsg:=NULL;
     FOR rec IN ( SELECT  POLICYCD, POLICYTYPE, symbol REFSYMBOL, roomlimit GRANTED, roomuse INUSED
                        FROM
                        (
                        SELECT   'SYSTEM' POLICYCD, 'R' POLICYTYPE, pr.symbol, max(pr.syroomlimit) roomlimit,
                                    max(pr.syroomused) + NVL (SUM(CASE WHEN restype = 'S' THEN NVL (afpr.prinused, 0) ELSE 0 END), 0)
                                       roomuse
                            FROM   vw_marginroomsystem_fo pr, vw_afpralloc_all afpr
                           WHERE   pr.codeid = afpr.codeid(+)
                        GROUP BY   pr.symbol
                        UNION ALL
                        SELECT   'UB' POLICYCD, 'R' POLICYTYPE, pr.symbol, max(pr.roomlimit) roomlimit,
                                    NVL (SUM(CASE WHEN restype = 'M' THEN NVL (afpr.prinused, 0) ELSE 0 END), 0)
                                       roomuse
                            FROM   vw_marginroomsystem_fo pr, vw_afpralloc_all afpr
                           WHERE   pr.codeid = afpr.codeid(+)
                        GROUP BY   pr.symbol
                        UNION ALL
                        SELECT to_char(MST.AUTOID) POLICYCD, 'R' POLICYTYPE,  SB.SYMBOL REFSYMBOL, MST.SELIMIT GRANTED,
                        fn_getusedselimitbygroup(MST.AUTOID) INUSED
                        FROM SELIMITGRP MST, SBSECURITIES SB
                        WHERE MST.CODEID= SB.CODEID AND MST.STATUS ='A'
                        ) WHERE  POLICYCD = v_RoomID AND symbol =v_Symbol
             )
     LOOP


         v_Msgformat:='{"msgtype" : "tx5015" , "amount" : <$AMOUNT>, "symbol" : "<$SYMBOL>", "doc" : "<$DORC>", "roomid" : "<$ROOMID>"}';
         v_Msgformat := Replace(v_Msgformat,'<$AMOUNT>', rec.granted);
         v_Msgformat := Replace(v_Msgformat,'<$DORC>', 'C');
         v_Msgformat := Replace(v_Msgformat,'<$ROOMID>', rec.policycd);
         v_Msgformat := Replace(v_Msgformat,'<$SYMBOL>', rec.REFSYMBOL);

         v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "A", "tlxtcd" : "<$TLTXCD>"';
         v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
         v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_strTxnum);
         v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',to_char(v_strTxdate,'dd/mm/yyyy'));
         v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>','');


         v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';
         plog.debug(pkgctx, v_strMsg);
    END LOOP;
    plog.setendsection (pkgctx, 'PRC_GEN_MSG_CHGROOM');
EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_GEN_MSG_CHGROOM');
END;


PROCEDURE PRC_GEN_MSG_ADDSPROOM(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_RoomID VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          )
IS
     v_strTxnum  VARCHAR2(100);
     v_strTxdate Date;
     v_Msgformat VARCHAR2(4000);
     v_Txcode    VARCHAR2(100);
     v_Columname VARCHAR2(100);
     v_msgHeader  VARCHAR2(500);
     v_DOC      VARCHAR2(1);
     v_acction  VARCHAR2(1);
     v_count    number(20,2);
BEGIN
     plog.SETBEGINSECTION (pkgctx, 'PRC_GEN_MSG_ADDSPROOM');
     SELECT  '99' || LPAD (seq_batchtxnum.NEXTVAL, 8, '0') txnum  INTO v_strTxnum  FROM dual;
     SELECT to_date(VARVALUE,'DD/MM/YYYY')  INTO v_strTxdate FROM sysvar WHERE  VARNAME='CURRDATE';
     --Kiem tra neu co pool, room nay roi thi gui ActionType la: U, chua co gui I.
     SELECT count(*) INTO v_count FROM
       (SELECT 1 stt FROM   t_fo_inday_poolroom WHERE POLICYCD =  v_RoomID
       UNION ALL
        SELECT 1 stt FROM   T_FO_POOLROOM  WHERE POLICYCD =  v_RoomID
        );
     IF v_count > 0 THEN
       v_acction :='U';
     ELSE
       v_acction :='I';
     END IF;
     --Dua vao bang t_fo_INDAY_POOLROOM
     INSERT INTO t_fo_inday_poolroom (policycd,
                                     policytype,
                                     refsymbol,
                                     granted,
                                     inused,
                                     actiontype,
                                     lastchange,
                                     autoid,
                                     status)
    SELECT  policycd, policytype, refsymbol, granted, inused,
     v_acction actiontype, SYSTIMESTAMP lastchange, seq_fo_inday_poolroom.NEXTVAL, 'N' status
     FROM
      (
        SELECT to_char(s.AUTOID) policycd, 'R' policytype, si.symbol refsymbol, SELIMIT granted, 0 inused
         FROM SELIMITGRP s, SECURITIES_INFO si WHERE s.codeid =si.codeid AND s.autoid = v_RoomID

         UNION ALL
         SELECT  --Doi voi Pool tu giao dich 0027
                  af.acctno policycd, 'P' POLICYTYPE, 'VND' REFSYMBOL,
                  af.poollimit granted, af.poollimit -
               round(least(  af.poollimit, nvl(adv.avladvance,0)
                        + mst.balance
                        + af.poollimit
                        - mst.odamt
                        - mst.dfdebtamt
                        - mst.dfintdebtamt
                        - mst.depofeeamt
                        - NVL (advamt, 0)
                        - nvl(secureamt,0)
                        - ramt
                        - nvl(dealpaidamt,0)),0) INUSED
            from cimast mst,afmast af ,cfmast cf,
                (select * from v_getbuyorderinfo) al,
                (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance group by afacctno) adv,
                (select * from v_getdealpaidbyaccount p) pd
            where mst.acctno = af.acctno and af.custid = cf.custid
            and mst.acctno = al.afacctno(+)
            and adv.afacctno(+)=MST.acctno
            and pd.afacctno(+)=mst.acctno
            and af.poolchk ='N'
            AND af.acctno  =v_RoomID
            )
            ;
     COMMIT;

     v_Msgformat:='{"msgtype" : "tx5108" , "action" : "A"}';

     v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "A", "tlxtcd" : "<$TLTXCD>"';
     v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_strTxnum);
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',to_char(v_strTxdate,'dd/mm/yyyy'));
     v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>','');


     v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';
     plog.debug(pkgctx, v_strMsg);

    plog.setendsection (pkgctx, 'PRC_GEN_MSG_ADDSPROOM');
EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_GEN_MSG_ADDSPROOM');
END;

PROCEDURE PRC_GEN_MSG_ACC2SPROOM(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_RoomID VARCHAR2,
          v_Acctno VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          )
IS
     v_strTxnum  VARCHAR2(100);
     v_strTxdate Date;
     v_Msgformat VARCHAR2(4000);
     v_Txcode    VARCHAR2(100);
     v_Columname VARCHAR2(100);
     v_msgHeader  VARCHAR2(500);
     v_DOC      VARCHAR2(1);
BEGIN
     plog.SETBEGINSECTION (pkgctx, 'PRC_GEN_MSG_ACC2SPROOM');
     SELECT  '99' || LPAD (seq_batchtxnum.NEXTVAL, 8, '0') txnum  INTO v_strTxnum  FROM dual;
     SELECT to_date(VARVALUE,'DD/MM/YYYY')  INTO v_strTxdate FROM sysvar WHERE  VARNAME='CURRDATE';
     --Dua vao bang t_fo_INDAY_DEFRULES
     INSERT INTO t_fo_inday_ownpoolroom (PRID,
                                     ACCTNO,
                                     POLICYTYPE,
                                     REFSYMBOL,
                                     INUSED,
                                     ACTIONTYPE,
                                     lastchange,
                                     status)
     SELECT to_char(s.AUTOID) PRID,  a.afacctno ACCTNO,'R' policytype, si.symbol refsymbol,
      0 inused,substr(v_Acctno,1,1) ACTIONTYPE,
      SYSTIMESTAMP lastchange, 'N' status
     FROM SELIMITGRP s, SECURITIES_INFO si,  AFSELIMITGRP a
     WHERE s.codeid =si.codeid AND  s.autoid = a.refautoid
           and s.autoid = v_RoomID and a.afacctno =  substr(v_Acctno,2)
           and substr(v_Acctno,1,1) <>'D'
     UNION ALL
     SELECT to_char(s.AUTOID) PRID, substr(v_Acctno,2) ACCTNO,'R' policytype, si.symbol refsymbol,
      0 inused, 'D' ACTIONTYPE,
      SYSTIMESTAMP lastchange, 'N' status
     FROM SELIMITGRP s, SECURITIES_INFO si
     WHERE s.codeid =si.codeid AND s.autoid = v_RoomID
           and substr(v_Acctno,1,1) = 'D'
     UNION ALL

     SELECT
                  af.acctno PRID, af.acctno ACCTNO, 'P' POLICYTYPE, 'VND' REFSYMBOL,
                  af.poollimit -
               round(least(  af.poollimit, nvl(adv.avladvance,0)
                        + mst.balance
                        + af.poollimit
                        - mst.odamt
                        - mst.dfdebtamt
                        - mst.dfintdebtamt
                        - mst.depofeeamt
                        - NVL (advamt, 0)
                        - nvl(secureamt,0)
                        - ramt
                        - nvl(dealpaidamt,0)),0) INUSED,substr(v_Acctno,1,1) ACTIONTYPE,SYSTIMESTAMP lastchange, 'N' status
            from cimast mst,afmast af ,cfmast cf,
                (select * from v_getbuyorderinfo) al,
                (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance group by afacctno) adv,
                (select * from v_getdealpaidbyaccount p) pd
            where mst.acctno = af.acctno and af.custid = cf.custid
            and mst.acctno = al.afacctno(+)
            and adv.afacctno(+)=MST.acctno
            and pd.afacctno(+)=mst.acctno
            --and af.poolchk ='N' trong truong hop remove khoi Pool dac biet cung dung msg nay
            AND af.acctno  =v_RoomID;

     COMMIT;

     v_Msgformat:='{"msgtype" : "tx5108" , "action" : "D"}';

     v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "A", "tlxtcd" : "<$TLTXCD>"';
     v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_strTxnum);
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',to_char(v_strTxdate,'dd/mm/yyyy'));
     v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>','');


     v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';
     plog.debug(pkgctx, v_strMsg);

    plog.setendsection (pkgctx, 'PRC_GEN_MSG_ACC2SPROOM');
EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_GEN_MSG_ACC2SPROOM');
END;


PROCEDURE PRC_GEN_MSG_CHGDEFRULE(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_tltxcd VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          )
IS
     v_strTxnum  VARCHAR2(100);
     v_strTxdate Date;
     v_Msgformat VARCHAR2(4000);
     v_Txcode    VARCHAR2(100);
     v_Columname VARCHAR2(100);
     v_msgHeader  VARCHAR2(500);
     v_DOC      VARCHAR2(1);
     v_Symbollist   varchar2(4000);
     v_Symbol   varchar2(20);
     v_chkdefrule BOOLEAN;
     v_chkrule varchar2(10);
     v_errcode_chkFlex  varchar2(10);
     v_advanceline  NUMBER;
     v_count    NUMBER;
BEGIN

     plog.SETBEGINSECTION (pkgctx, 'PRC_GEN_MSG_CHGDEFRULE');
     SELECT  '99' || LPAD (seq_batchtxnum.NEXTVAL, 8, '0') txnum  INTO v_strTxnum  FROM dual;
     SELECT to_date(VARVALUE,'DD/MM/YYYY')  INTO v_strTxdate FROM sysvar WHERE  VARNAME='CURRDATE';
     --Dua vao bang t_fo_inday_defrules
     DELETE FROM T_FO_INDAY_DEFRULES;
    DELETE FROM t_fo_chkdefrules;

    --Check trong bang afserule
    FOR rec IN
    (   SELECT DISTINCT af.acctno, afs.codeid, aft.policycd, afs.bors FROM AFSERULE afs, afmast af, aftype aft
        WHERE ((afs.refid = af.acctno AND afs.typormst = 'M') OR (afs.refid = af.actype AND afs.typormst = 'T'))
        AND af.actype = aft.actype AND afs.status = 'A' AND afs.afseruletype = 'N' AND getcurrdate BETWEEN afs.effdate AND afs.expdate
    )
    LOOP
        IF rec.policycd = 'L' THEN
            IF rec.bors = 'A' THEN
                v_chkdefrule := cspks_odproc.fn_checkTradingAllow(rec.acctno, rec.codeid, 'B', v_errcode_chkFlex);
                v_chkrule := (CASE v_chkdefrule WHEN TRUE THEN 'CANBUY' ELSE 'CANNOTBUY' END);
                INSERT INTO t_fo_chkdefrules(acctno, codeid, bors, rule)
                SELECT rec.acctno, rec.codeid, 'B', v_chkrule FROM dual;
                v_chkdefrule := cspks_odproc.fn_checkTradingAllow(rec.acctno, rec.codeid, 'S', v_errcode_chkFlex);
                v_chkrule := (CASE v_chkdefrule WHEN TRUE THEN 'CANSELL' ELSE 'CANNOTSELL' END);
                INSERT INTO t_fo_chkdefrules(acctno, codeid, bors, rule)
                SELECT rec.acctno, rec.codeid, 'S', v_chkrule FROM dual;
            ELSIF rec.bors = 'B' THEN
                v_chkdefrule := cspks_odproc.fn_checkTradingAllow(rec.acctno, rec.codeid, rec.bors, v_errcode_chkFlex);
                v_chkrule := (CASE v_chkdefrule WHEN TRUE THEN 'CANBUY' ELSE 'CANNOTBUY' END);
                INSERT INTO t_fo_chkdefrules(acctno, codeid, bors, rule)
                SELECT rec.acctno, rec.codeid, rec.bors, v_chkrule FROM dual;
            ELSE
                v_chkdefrule := cspks_odproc.fn_checkTradingAllow(rec.acctno, rec.codeid, rec.bors, v_errcode_chkFlex);
                v_chkrule := (CASE v_chkdefrule WHEN TRUE THEN 'CANSELL' ELSE 'CANNOTSELL' END);
                INSERT INTO t_fo_chkdefrules(acctno, codeid, bors, rule)
                SELECT rec.acctno, rec.codeid, rec.bors, v_chkrule FROM dual;
            END IF;

        ELSIF rec.policycd = 'E' THEN
            IF rec.bors = 'A' THEN
                v_chkdefrule := cspks_odproc.fn_checkTradingAllow(rec.acctno, rec.codeid, 'B', v_errcode_chkFlex);
                v_chkrule := (CASE v_chkdefrule WHEN TRUE THEN 'CANBUY' ELSE 'CANNOTBUY' END);
                INSERT INTO t_fo_chkdefrules(acctno, codeid, bors, rule)
                SELECT rec.acctno, rec.codeid, 'B', v_chkrule FROM dual;
                v_chkdefrule := cspks_odproc.fn_checkTradingAllow(rec.acctno, rec.codeid, 'S', v_errcode_chkFlex);
                v_chkrule := (CASE v_chkdefrule WHEN TRUE THEN 'CANSELL' ELSE 'CANNOTSELL' END);
                INSERT INTO t_fo_chkdefrules(acctno, codeid, bors, rule)
                SELECT rec.acctno, rec.codeid, 'S', v_chkrule FROM dual;
            ELSIF rec.bors = 'B' THEN
                v_chkdefrule := cspks_odproc.fn_checkTradingAllow(rec.acctno, rec.codeid, rec.bors, v_errcode_chkFlex);
                v_chkrule := (CASE v_chkdefrule WHEN TRUE THEN 'CANBUY' ELSE 'CANNOTBUY' END);
                INSERT INTO t_fo_chkdefrules(acctno, codeid, bors, rule)
                SELECT rec.acctno, rec.codeid, rec.bors, v_chkrule FROM dual;
            ELSE
                v_chkdefrule := cspks_odproc.fn_checkTradingAllow(rec.acctno, rec.codeid, rec.bors, v_errcode_chkFlex);
                v_chkrule := (CASE v_chkdefrule WHEN TRUE THEN 'CANSELL' ELSE 'CANNOTSELL' END);
                INSERT INTO t_fo_chkdefrules(acctno, codeid, bors, rule)
                SELECT rec.acctno, rec.codeid, rec.bors, v_chkrule FROM dual;
            END IF;
        END IF;
    END LOOP;

    FOR rec IN
    (   SELECT DISTINCT af.acctno, afs.codeid, aft.policycd, afs.bors FROM AFSERULE afs, afmast af, aftype aft
        WHERE ((afs.refid = af.acctno AND afs.typormst = 'M') OR (afs.refid = af.actype AND afs.typormst = 'T'))
        AND af.actype = aft.actype AND afs.status = 'A' AND afs.afseruletype = 'BL'
    )
    LOOP
        SELECT af.advanceline INTO v_advanceline FROM afmast af WHERE af.acctno = rec.acctno;
        IF rec.bors = 'B' AND v_advanceline > 0 THEN
            v_chkdefrule := cspks_odproc.fn_checkTradingAllow(rec.acctno, rec.codeid, rec.bors, v_errcode_chkFlex);
            v_chkrule := (CASE v_chkdefrule WHEN TRUE THEN 'CANBUY' ELSE 'CANNOTBUY' END);
            INSERT INTO t_fo_chkdefrules(acctno, codeid, bors, rule)
            SELECT rec.acctno, rec.codeid, rec.bors, v_chkrule FROM dual;
        END IF;
    END LOOP;

    --Check trong truong hop khong co trong bang afserule
    --Lay CANNOT
    INSERT INTO t_fo_chkdefrules(acctno, codeid, bors, rule)
    SELECT af.acctno, 'ALL', 'B',
        CASE aft.policycd WHEN 'L' THEN 'CANNOTBUY' ELSE 'CANBUY' END rule FROM afmast af, aftype aft
    WHERE af.actype = aft.actype
        AND aft.policycd = 'L'
        AND (af.acctno NOT IN (SELECT refid FROM afserule af WHERE af.typormst = 'M')
            AND af.actype NOT IN (SELECT refid FROM afserule af WHERE af.typormst = 'T'));

    INSERT INTO t_fo_chkdefrules(acctno, codeid, bors, rule)
    SELECT af.acctno, 'ALL', 'S',
        CASE aft.policycd WHEN 'L' THEN 'CANNOTSELL' ELSE 'CANSELL' END rule FROM afmast af, aftype aft
    WHERE af.actype = aft.actype
        AND aft.policycd = 'L'
        AND (af.acctno NOT IN (SELECT refid FROM afserule af WHERE af.typormst = 'M')
            AND af.actype NOT IN (SELECT refid FROM afserule af WHERE af.typormst = 'T'));

    --Tong hop sang bang t_fo_inday_defrules: Xu ly neu la CAN thi xoa CANNOT:
    FOR recacc IN (SELECT DISTINCT acctno, rule FROM t_fo_chkdefrules WHERE codeid <> 'ALL')
    LOOP
        plog.debug (pkgctx, 'acctno: ' || recacc.acctno);


        --Khong xu ly CANNOTBUY khi co CAN
        SELECT COUNT (*) INTO v_count FROM t_fo_chkdefrules WHERE acctno = recacc.acctno AND rule = 'CANBUY';
        IF v_count > 0 THEN
            DELETE FROM t_fo_chkdefrules WHERE acctno = recacc.acctno AND rule = 'CANNOTBUY';
        END IF;

        SELECT COUNT (*) INTO v_count FROM t_fo_chkdefrules WHERE acctno = recacc.acctno AND rule = 'CANSELL';
        IF v_count > 0 THEN
            DELETE FROM t_fo_chkdefrules WHERE acctno = recacc.acctno AND rule = 'CANNOTSELL';
        END IF;
        --End Khong xu ly CANNOT khi co CAN
    END LOOP;

    --Ghep neu CAN nhieu hon 1 ma thi thanh chuoi: 0001000001, CANBUY: SSI, VND, VND
    FOR recacc IN (SELECT DISTINCT acctno, rule FROM t_fo_chkdefrules WHERE codeid <> 'ALL')
    LOOP
        v_Symbollist := '';
        FOR recsym IN (SELECT DISTINCT codeid FROM t_fo_chkdefrules WHERE codeid <> 'ALL' AND acctno = recacc.acctno AND rule = recacc.rule)
        LOOP
            SELECT symbol INTO v_Symbol FROM sbsecurities WHERE codeid = recsym.codeid;
            IF nvl(v_Symbol, 'ZZZZ') <> 'ZZZZ' /*AND instr(v_Symbollist,v_Symbol) = 0*/ THEN
                IF nvl(v_Symbollist,'ZZZZ') = 'ZZZZ' THEN
                    v_Symbollist := v_Symbol;
                ELSE
                    v_Symbollist := v_Symbollist || ',' || v_Symbol;
                END IF;
            END IF;
        END LOOP;

        plog.debug (pkgctx, 'v_Symbollist: ' || v_Symbollist);

        INSERT INTO t_fo_inday_defrules (autoid,
                           reftype,
                           refcode,
                           rulename,
                           refnval,
                           refcval,
                           actiontype,
                           status,
                           lastchange)
       SELECT  SEQ_DEFRULES.NEXTVAL@DBL_FO autoid, 'I' REFTYPE,
            recacc.acctno REFCODE, recacc.rule RULENAME, 0 REFNVAL ,
            v_Symbollist REFCVAL,'I' ACTIONTYPE, 'N' STATUS, SYSTIMESTAMP lastchange
       FROM dual;

    END LOOP;

    --Xu ly cho quy dinh mua ban tang loai hinh la "L" co BL va Thuong khai ma CK khac nhau
    FOR rec IN
    (
        SELECT a.* FROM t_fo_inday_defrules a, afmast af, aftype aft
        WHERE a.refcval <> 'ALL' AND a.refcode = af.acctno AND af.actype = aft.actype
        AND aft.policycd = 'L' AND a.rulename = 'CANNOTBUY'
    )
    LOOP
        SELECT COUNT (*) INTO v_count FROM t_fo_inday_defrules a WHERE a.refcode = rec.refcode;
        IF v_count = 1 THEN
            DELETE FROM t_fo_inday_defrules WHERE refcode = rec.refcode;
            INSERT INTO t_fo_inday_defrules (autoid,
                               reftype,
                               refcode,
                               rulename,
                               refnval,
                               refcval,
                               actiontype,
                               status,
                               lastchange)
            SELECT  SEQ_DEFRULES.NEXTVAL@DBL_FO autoid, 'I' REFTYPE,
                rec.refcode REFCODE, 'CANNOTBUY' RULENAME, 0 REFNVAL ,
                'ALL' REFCVAL,'I' ACTIONTYPE, 'N' STATUS, SYSTIMESTAMP lastchange
            FROM dual;

        END IF;
    END LOOP;

    FOR rec IN
    (
        SELECT a.* FROM t_fo_inday_defrules a, afmast af, aftype aft
        WHERE a.refcval <> 'ALL' AND a.refcode = af.acctno AND af.actype = aft.actype
        AND aft.policycd = 'L' AND a.rulename = 'CANNOTSELL'
    )
    LOOP
        SELECT COUNT (*) INTO v_count FROM t_fo_inday_defrules a WHERE a.refcode = rec.refcode;
        IF v_count = 1 THEN
            DELETE FROM t_fo_inday_defrules WHERE refcode = rec.refcode;
            INSERT INTO t_fo_inday_defrules (autoid,
                               reftype,
                               refcode,
                               rulename,
                               refnval,
                               refcval,
                               actiontype,
                               status,
                               lastchange)
            SELECT  SEQ_DEFRULES.NEXTVAL@DBL_FO autoid, 'I' REFTYPE,
                rec.refcode REFCODE, 'CANNOTSELL' RULENAME, 0 REFNVAL ,
                'ALL' REFCVAL,'I' ACTIONTYPE, 'N' STATUS, SYSTIMESTAMP lastchange
            FROM dual;

        END IF;
    END LOOP;

    FOR rec IN
    (
        SELECT DISTINCT af.acctno
        FROM afmast af, aftype aft
        WHERE af.actype = aft.actype
            AND aft.policycd = 'L'
            AND (af.acctno IN (SELECT refid FROM afserule af WHERE af.typormst = 'M')
                OR af.actype IN (SELECT refid FROM afserule af WHERE af.typormst = 'T'))
    )
    LOOP
        SELECT COUNT (*) INTO v_count FROM t_fo_inday_defrules a WHERE a.refcode = rec.acctno AND rulename IN ('CANBUY','CANSELL');
        IF v_count = 0 THEN
            DELETE FROM t_fo_inday_defrules WHERE refcode = rec.acctno;
            INSERT INTO t_fo_inday_defrules (autoid,
                               reftype,
                               refcode,
                               rulename,
                               refnval,
                               refcval,
                               actiontype,
                               status,
                               lastchange)
            SELECT  SEQ_DEFRULES.NEXTVAL@DBL_FO autoid, 'I' REFTYPE,
                rec.acctno REFCODE, 'CANNOTSELL' RULENAME, 0 REFNVAL ,
                'ALL' REFCVAL,'I' ACTIONTYPE, 'N' STATUS, SYSTIMESTAMP lastchange
            FROM dual;
            INSERT INTO t_fo_inday_defrules (autoid,
                               reftype,
                               refcode,
                               rulename,
                               refnval,
                               refcval,
                               actiontype,
                               status,
                               lastchange)
            SELECT  SEQ_DEFRULES.NEXTVAL@DBL_FO autoid, 'I' REFTYPE,
                rec.acctno REFCODE, 'CANNOTBUY' RULENAME, 0 REFNVAL ,
                'ALL' REFCVAL,'I' ACTIONTYPE, 'N' STATUS, SYSTIMESTAMP lastchange
            FROM dual;

        ELSE
            SELECT COUNT (*) INTO v_count FROM t_fo_inday_defrules a WHERE a.refcode = rec.acctno AND rulename IN ('CANBUY');
            IF v_count = 0 THEN
                DELETE FROM t_fo_inday_defrules WHERE refcode = rec.acctno AND rulename IN ('CANNOTBUY');
                INSERT INTO t_fo_inday_defrules (autoid,
                                   reftype,
                                   refcode,
                                   rulename,
                                   refnval,
                                   refcval,
                                   actiontype,
                                   status,
                                   lastchange)
                SELECT  SEQ_DEFRULES.NEXTVAL@DBL_FO autoid, 'I' REFTYPE,
                    rec.acctno REFCODE, 'CANNOTBUY' RULENAME, 0 REFNVAL ,
                    'ALL' REFCVAL,'I' ACTIONTYPE, 'N' STATUS, SYSTIMESTAMP lastchange
                FROM dual;
            END IF;
            SELECT COUNT (*) INTO v_count FROM t_fo_inday_defrules a WHERE a.refcode = rec.acctno AND rulename IN ('CANSELL');
            IF v_count = 0 THEN
                DELETE FROM t_fo_inday_defrules WHERE refcode = rec.acctno AND rulename IN ('CANNOTSELL');
                INSERT INTO t_fo_inday_defrules (autoid,
                                   reftype,
                                   refcode,
                                   rulename,
                                   refnval,
                                   refcval,
                                   actiontype,
                                   status,
                                   lastchange)
                SELECT  SEQ_DEFRULES.NEXTVAL@DBL_FO autoid, 'I' REFTYPE,
                    rec.acctno REFCODE, 'CANNOTSELL' RULENAME, 0 REFNVAL ,
                    'ALL' REFCVAL,'I' ACTIONTYPE, 'N' STATUS, SYSTIMESTAMP lastchange
                FROM dual;
            END IF;
        END IF;
    END LOOP;

    --End Xu ly cho quy dinh mua ban tang loai hinh la "L" co BL va Thuong khai ma CK khac nhau

/*    --Khong tong hop CAN ALL
    INSERT INTO t_fo_inday_defrules (autoid,
                   reftype,
                   refcode,
                   rulename,
                   refnval,
                   refcval,
                   actiontype,
                   status,
                   lastchange)
    SELECT seq_FO_INDAY_DEFRULES.NEXTVAL autoid, 'I' REFTYPE,
        chk.acctno REFCODE, chk.rule RULENAME, 0 REFNVAL,
        sbs.symbol, 'I' ACTIONTYPE, 'N' STATUS, SYSTIMESTAMP lastchange
    FROM t_fo_chkdefrules chk, sbsecurities sbs
        WHERE chk.codeid = sbs.codeid
            AND (chk.codeid <> 'ALL' AND (chk.rule <> 'CANBUY' OR chk.rule <> 'CANSELL'));*/

    INSERT INTO t_fo_inday_defrules (autoid,
                   reftype,
                   refcode,
                   rulename,
                   refnval,
                   refcval,
                   actiontype,
                   status,
                   lastchange)
    SELECT SEQ_DEFRULES.NEXTVAL@DBL_FO autoid, 'I' REFTYPE,
        chk.acctno REFCODE, chk.rule RULENAME, 0 REFNVAL,
        chk.codeid, 'I' ACTIONTYPE, 'N' STATUS, SYSTIMESTAMP lastchange
    FROM t_fo_chkdefrules chk WHERE codeid = 'ALL' AND (rule = 'CANNOTBUY' OR rule = 'CANNOTSELL');

    FOR rec IN
    (
        SELECT DISTINCT afacctno
        FROM AFTXMAP
        WHERE EFFDATE <= (SELECT to_date(VARVALUE,'dd/mm/yyyy') FROM sysvar WHERE VARNAME ='CURRDATE')
            AND EXPDATE > (SELECT to_date(VARVALUE,'dd/mm/yyyy') FROM sysvar WHERE VARNAME ='CURRDATE')
            AND TLTXCD IN ('8874','8876') AND DELTD <> 'Y'
    )
    LOOP
        SELECT COUNT (*) INTO v_count FROM t_fo_inday_defrules WHERE refcode = rec.afacctno;
        IF v_count > 0 THEN
            DELETE FROM t_fo_inday_defrules WHERE refcode = rec.afacctno AND rulename LIKE '%BUY%';
        END IF;

        INSERT INTO t_fo_inday_defrules (autoid,
                               reftype,
                               refcode,
                               rulename,
                               refnval,
                               refcval,
                               actiontype,
                               status,
                               lastchange)
        SELECT  SEQ_DEFRULES.NEXTVAL@DBL_FO autoid, 'I' REFTYPE,
            rec.afacctno REFCODE, 'CANNOTBUY' RULENAME, 0 REFNVAL ,
            'ALL' REFCVAL,'I' ACTIONTYPE, 'N' STATUS, SYSTIMESTAMP lastchange
        FROM dual;

    END LOOP;

    FOR rec IN
    (
        SELECT DISTINCT afacctno
        FROM AFTXMAP
        WHERE EFFDATE <= (SELECT to_date(VARVALUE,'dd/mm/yyyy') FROM sysvar WHERE VARNAME ='CURRDATE')
            AND EXPDATE > (SELECT to_date(VARVALUE,'dd/mm/yyyy') FROM sysvar WHERE VARNAME ='CURRDATE')
            AND TLTXCD IN ('8875','8877') AND DELTD <> 'Y'
    )
    LOOP
        SELECT COUNT (*) INTO v_count FROM t_fo_inday_defrules WHERE refcode = rec.afacctno;
        IF v_count > 0 THEN
            DELETE FROM t_fo_inday_defrules WHERE refcode = rec.afacctno AND rulename LIKE '%SELL%';
        END IF;

        INSERT INTO t_fo_inday_defrules (autoid,
                               reftype,
                               refcode,
                               rulename,
                               refnval,
                               refcval,
                               actiontype,
                               status,
                               lastchange)
        SELECT  SEQ_DEFRULES.NEXTVAL@DBL_FO autoid, 'I' REFTYPE,
            rec.afacctno REFCODE, 'CANNOTSELL' RULENAME, 0 REFNVAL ,
            'ALL' REFCVAL,'I' ACTIONTYPE, 'N' STATUS, SYSTIMESTAMP lastchange
        FROM dual;
    END LOOP;

    COMMIT;


     v_Msgformat:='{"msgtype" : "tx5110" }';

     v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "A", "tlxtcd" : "<$TLTXCD>"';
     v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_strTxnum);
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',to_char(v_strTxdate,'dd/mm/yyyy'));
     v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>','');


     v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';
     plog.debug(pkgctx, v_strMsg);

    plog.setendsection (pkgctx, 'PRC_GEN_MSG_CHGDEFRULE');
EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_GEN_MSG_CHGDEFRULE');
END;


PROCEDURE PRC_GEN_MSG_SYNROOM(v_txdate DATE,
          v_txnum  VARCHAR2,
          v_tltxcd VARCHAR2,
          v_Acctno VARCHAR2,
          v_strMsg IN OUT VARCHAR2 ,
          v_errcode IN OUT VARCHAR2,
          v_errmsg IN OUT VARCHAR2
          )
IS
     v_strTxnum  VARCHAR2(100);
     v_strTxdate Date;
     v_Msgformat VARCHAR2(4000);
     v_Txcode    VARCHAR2(100);
     v_Columname VARCHAR2(100);
     v_msgHeader  VARCHAR2(500);
     v_DOC      VARCHAR2(1);
     i number(20);
BEGIN
     plog.SETBEGINSECTION (pkgctx, 'PRC_GEN_MSG_SYNROOM');
     SELECT  '99' || LPAD (seq_batchtxnum.NEXTVAL, 8, '0') txnum  INTO v_strTxnum  FROM dual;
     SELECT to_date(VARVALUE,'DD/MM/YYYY')  INTO v_strTxdate FROM sysvar WHERE  VARNAME='CURRDATE';
     --Cap nhat bang Danh muc
     i:=0;
     --Backup cac bang phuc vu check:
    INSERT INTO ALLOCATION_B@DBL_FO(AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,PRICE,QTTY,DOC,POLICYCD,POOLID,
              POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
    SELECT AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,PRICE,QTTY,DOC,POLICYCD,POOLID,
              POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE
    FROM ALLOCATION@DBL_FO;


    INSERT INTO T_FO_OWNPOOLROOM_HIST  SELECT * FROM  T_FO_OWNPOOLROOM;
    INSERT INTO T_FO_POOLROOM_HIST     SELECT * FROM   T_FO_POOLROOM ;
    INSERT INTO T_FO_PORTFOLIOS_HIST   SELECT * FROM  T_FO_PORTFOLIOS;
    COMMIT;
     --
     IF v_Acctno <> 'ALL' THEN
         FOR j IN  (SELECT * FROM V_FO_PORTFOLIOS v WHERE acctno =v_Acctno AND NOT EXISTS (SELECT 1 FROM t_fo_portfolios t WHERE t.acctno = v.acctno AND t.symbol = v.symbol))
         LOOP


            INSERT INTO t_fo_portfolios (acctno, symbol, trade, mortage, receiving, avgprice, rt0, rt1, rt2, rt3,
                                     rtn, st0, st1, st2, st3, stn, buyingqtty, sellingqtty, buyingqttymort,
                                     sellingqttymort, assetqtty, lastchange, marked, markedcom)
                VALUES (j.acctno, j.symbol, j.trade, j.mortage, j.receiving, j.avgprice, j.rt0, j.rt1, j.rt2, j.rt3,
                                         j.rtn, j.st0, j.st1, j.st2, j.st3, j.stn, j.buyingqtty, j.sellingqtty, j.buyingqttymort,
                                         j.sellingqttymort, j.assetqtty, SYSTIMESTAMP, j.marked,j.markedcom);
           i:=i+1;
           IF i > 1000 THEN
             i:=0;
             COMMIT;
           END IF;
         END LOOP;
         COMMIT;
         --
         i:=0;
         FOR j IN  (SELECT * FROM V_FO_PORTFOLIOS v WHERE  v.acctno= v_Acctno)
         LOOP
           UPDATE  t_fo_portfolios SET  marked = j.marked,  markedcom = j.markedcom, lastchange = systimestamp
           WHERE   acctno = j.acctno AND  symbol = j.symbol;
           i:=i+1;
           IF i > 1000 THEN
             i:=0;
             COMMIT;
           END IF;
         END LOOP;
     ELSE
          FOR j IN  (SELECT * FROM V_FO_PORTFOLIOS v WHERE NOT EXISTS (SELECT 1 FROM t_fo_portfolios t WHERE t.acctno = v.acctno AND t.symbol = v.symbol))
         LOOP


            INSERT INTO t_fo_portfolios (acctno, symbol, trade, mortage, receiving, avgprice, rt0, rt1, rt2, rt3,
                                     rtn, st0, st1, st2, st3, stn, buyingqtty, sellingqtty, buyingqttymort,
                                     sellingqttymort, assetqtty, lastchange, marked, markedcom)
                VALUES (j.acctno, j.symbol, j.trade, j.mortage, j.receiving, j.avgprice, j.rt0, j.rt1, j.rt2, j.rt3,
                                         j.rtn, j.st0, j.st1, j.st2, j.st3, j.stn, j.buyingqtty, j.sellingqtty, j.buyingqttymort,
                                         j.sellingqttymort, j.assetqtty, SYSTIMESTAMP, j.marked,j.markedcom);
           i:=i+1;
           IF i > 1000 THEN
             i:=0;
             COMMIT;
           END IF;
         END LOOP;
         COMMIT;
         --
         i:=0;
         FOR j IN  (SELECT * FROM V_FO_PORTFOLIOS v)
         LOOP
           UPDATE  t_fo_portfolios SET  marked = j.marked,  markedcom = j.markedcom, lastchange = systimestamp
           WHERE   acctno = j.acctno AND  symbol = j.symbol;
           i:=i+1;
           IF i > 1000 THEN
             i:=0;
             COMMIT;
           END IF;
         END LOOP;
     END IF;
     COMMIT;
     --
     pr_t_fo_poolroom;
     pr_t_fo_ownpoolroom;
     COMMIT;

     v_Msgformat:='{"acctno" : "<$ACCTNO>","msgtype" : "tx3017" }';

     v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "A", "tlxtcd" : "<$TLTXCD>"';
     v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_strTxnum);
     v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',to_char(v_strTxdate,'dd/mm/yyyy'));
     v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>','');

     v_Msgformat:= REPLACE(v_Msgformat,'<$ACCTNO>',v_Acctno);
     v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';
     plog.debug(pkgctx, v_strMsg);

    plog.setendsection (pkgctx, 'PRC_GEN_MSG_SYNROOM');
EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_GEN_MSG_SYNROOM');
END;

--Thu tuc nay dung de gen msg va call xuong FO, neu loi tu FO se tra ve ma loi.



PROCEDURE PRC_CHECK_SYN2FO(v_txnum varchar2,
        v_errcode IN OUT VARCHAR2,
        v_errmsg IN OUT VARCHAR2)
IS
  v_strMsg varchar2(4000);

  v_FOMODE     varchar2(5);
BEGIN
    plog.setbeginsection (pkgctx, 'PRC_CHECK_SYN2FO');
    v_errcode:='0';
    --Kiem tra neu FOMODE la OFF thi khong lam gi
    BEGIN
    SELECT NVL(varvalue, 'OFF') INTO v_FOMODE FROM sysvar WHERE varname = 'FOMODE';
    EXCEPTION WHEN OTHERS THEN
        v_FOMODE:='OFF';
    END;
    IF v_FOMODE = 'OFF' THEN

      RETURN;
    END IF;
    plog.debug (pkgctx, ' PRC_GENMSG2FO v_txnum'|| v_txnum);

    PRC_GENMSG2FO(v_txnum,
                  v_strMsg,
                  v_errcode,
                  v_errmsg);
    plog.debug (pkgctx, ' PRC_GENMSG2FO '|| v_errcode ||' v_strMsg ' || v_strMsg);

    IF v_errcode <> gc_Success THEN
        plog.debug (pkgctx, ' PRC_GENMSG2FO Loi '|| v_errcode ||' v_strMsg ' || v_strMsg);
        plog.error (pkgctx, v_strMsg);
        RAISE errnums.E_SYSTEM_ERROR;
    END IF;

    plog.debug (pkgctx, v_strMsg);
    --Call sang FO de thuc hien:
    IF v_strMsg IS NOT NULL THEN
        PCK_SYN2FO.PRC_CALLWEBSERVICE
        (
            pv_StrMessage => v_strMsg,
            v_errcode => v_errcode,
            v_errmsg => v_ErrMsg,
            v_type => 'FO'
        );
        plog.debug (pkgctx, 'PRC_CALLWEBSERVICE p_err_code '||v_errcode);
        IF v_errcode <> gc_Success THEN
            plog.error (pkgctx, v_strMsg);
        END IF;
    END IF;


    plog.setendsection (pkgctx, 'PRC_CHECK_SYN2FO');




EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_CHECK_SYN2FO');
END;



PROCEDURE PRC_GEN_MSG_2290(
                               v_txnum   VARCHAR2,
                               v_strMsg  IN OUT VARCHAR2,
                               v_errcode IN OUT VARCHAR2,
                               v_errmsg IN OUT  VARCHAR2)
IS
    v_Amount    NUMBER;
    v_QTTY      NUMBER;
    v_QTTY1     NUMBER;
    v_QTTY2     NUMBER;
    v_CODEID    varchar2(30);
    v_SYMBOL    varchar2(30);
    v_ACCTNO    varchar2(30);
    v_strTltxcd varchar2(4);
    v_Txcode    varchar2(10);
    v_DOC       varchar2(1);
    v_EXTRA     NUMBER;
    v_Msgformat VARCHAR2(4000);
    v_MsgformatTotal VARCHAR2(4000);
    v_MsgDetail VARCHAR2(4000);
    v_msgHeader VARCHAR2(500);
    v_Txdate    DATE;
    v_Count     NUMBER;
    v_Date_adv  DATE;
    v_Bod_adv   NUMBER;
    v_advbal    NUMBER;
    v_ISFO      varchar2(1);
    v_taxrate   number (20,4);
    v_taxratetemp   number (20,4);
BEGIN
    SELECT tltxcd INTO v_strTltxcd FROM tllog WHERE txnum = v_txnum;

    IF NOT NVL(v_strTltxcd, 'ZZZ') = 'ZZZ' THEN

         SELECT to_date(VARVALUE,'DD/MM/YYYY')  INTO v_Txdate FROM sysvar WHERE  VARNAME='CURRDATE';

         v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "A", "tlxtcd" : "<$TLTXCD>"';
         v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
         v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_txnum);
         v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',to_char(v_Txdate,'dd/mm/yyyy'));
         v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>',v_strTltxcd);

        v_Count :=1;
        v_MsgformatTotal := NULL;

        FOR rec IN ( SELECT * FROM FOTXMAP WHERE TLTXCD = v_strTltxcd)
        LOOP

            SELECT MSGFORMAT INTO v_MsgDetail FROM fotxformat WHERE txcode = rec.txcode AND status = 'Y' And rownum = 1;


            /*IF nvl(rec.amount,'ZZZ') <> 'ZZZ' Then
                SELECT NVL(NVALUE,0) INTO v_Amount FROM tllogfld WHERE txnum = v_txnum AND fldcd = nvl(rec.amount,'ZZZ');
            END if;*/

            IF nvl(rec.extra,'ZZZ') <> 'ZZZ' Then
                SELECT NVL(NVALUE,0) INTO v_EXTRA FROM tllogfld WHERE txnum = v_txnum AND fldcd = nvl(rec.extra,'ZZZ');
            END if;

        IF rec.txcode = 'tx5005' AND v_strTltxcd ='2290' THEN--sua vi truong qtty = '10--11' gd2290
        IF nvl(rec.qtty,'ZZZ') <> 'ZZZ' THEN
              SELECT NVL(NVALUE,0) INTO v_QTTY1 FROM tllogfld WHERE txnum = v_txnum AND fldcd = substr(nvl(rec.qtty,'ZZZ'), 1, 2);
              SELECT NVL(NVALUE,0) INTO v_QTTY2 FROM tllogfld WHERE txnum = v_txnum AND fldcd = substr(nvl(rec.qtty,'ZZZ'), 5, 2);
              v_QTTY := v_QTTY1-v_QTTY2;
            END IF;
        ELSE
            IF nvl(rec.qtty,'ZZZ') <> 'ZZZ' Then
                SELECT NVL(NVALUE,0) INTO v_QTTY FROM tllogfld WHERE txnum = v_txnum AND fldcd = nvl(rec.qtty,'ZZZ');
            END IF;
        END IF;

            IF nvl(rec.codeid,'ZZZ') <> 'ZZZ' Then
                SELECT NVL(CVALUE,'AAA') INTO v_CODEID FROM tllogfld WHERE txnum = v_txnum AND fldcd = nvl(rec.codeid,'ZZZ');
            END IF;


            IF nvl(rec.acctno,'ZZZ') <> 'ZZZ' Then
                SELECT substr(NVL(CVALUE,'AAA'),0,10) INTO v_ACCTNO FROM tllogfld WHERE txnum = v_txnum AND fldcd = nvl(rec.acctno,'ZZZ');
            END IF;

            IF nvl(rec.symbol,'ZZZ') <> 'ZZZ' Then
                SELECT NVL(CVALUE,'AAA') INTO v_SYMBOL FROM tllogfld WHERE txnum = v_txnum AND fldcd = nvl(rec.symbol,'ZZZ');
            END IF;

            IF NVL(v_CODEID, 'ZZZ') <> 'ZZZ' AND NVL(v_SYMBOL, 'ZZZ') = 'ZZZ' THEN
                SELECT SYMBOL INTO v_SYMBOL From sbsecurities where codeid = v_CODEID;
            END IF;
             --20210303 - chinh sua them TAXRATE 
            v_taxrate := 0;
             IF rec.txcode = 'tx5016' then
               if v_strTltxcd = '2290'then
                  -- lay taxrate la max trong sepitlog
                  select nvl(max(PITRATE), 0) into v_taxrate
                  from sepitlog se, sbsecurities sb
                  where se.codeid =  sb.codeid 
                  and sb.symbol = v_SYMBOL and se.afacctno = v_ACCTNO
                  and se.qtty - se.mapqtty > 0;
               end if;
               if v_strTltxcd = '2246'then 
                  v_taxrate := v_EXTRA;
               end if;
             end IF;

            v_MsgDetail := Replace(v_MsgDetail,'<$MSGTYPE>', rec.txcode);
            v_MsgDetail := Replace(v_MsgDetail,'<$ACCTNO>' , v_ACCTNO);
            v_MsgDetail := Replace(v_MsgDetail,'<$QTTY>' , TO_CHAR(v_QTTY));
            v_MsgDetail := Replace(v_MsgDetail,'<$SYMBOL>' , v_SYMBOL);
            v_MsgDetail := Replace(v_MsgDetail,'<$COD>' , rec.doc);
            v_MsgDetail := Replace(v_MsgDetail,'<$AMOUNT>' , TO_CHAR(v_EXTRA));
            v_MsgDetail := Replace(v_MsgDetail,'<$TAXRATE>' , TO_CHAR(v_taxrate));

            /*if nvl(v_Amount, 0) <> 0 then
                v_MsgDetail := Replace(v_MsgDetail,'<$AMOUNT>' , TO_CHAR(v_Amount));
            else
                v_MsgDetail := Replace(v_MsgDetail,'<$AMOUNT>' , '0');
            end if;*/

            --v_MsgDetail := Replace(v_MsgDetail,'<$DOC>' , rec.doc);

            --v_MsgDetail := Replace(v_MsgDetail,'<$CODEID>' , v_CODEID);

            plog.debug(pkgctx, ' v_ACCTNO :'||v_ACCTNO);

            v_MsgformatTotal := v_MsgformatTotal || v_MsgDetail;

            IF v_MsgDetail IS NOT NULL THEN
                IF v_Count = 1 THEN
                   v_Msgformat := v_MsgDetail;
                ELSE
                   v_Msgformat := v_Msgformat || ',' || v_MsgDetail;
                END IF;

                v_Count := v_Count + 1;
            END IF;

        END LOOP;

        IF v_MsgformatTotal IS NULL THEN
            v_strMsg := NULL;
        ELSE
            v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';
        END IF;

        plog.debug(pkgctx, v_strMsg);

        --plog.setendsection (pkgctx, 'PRC_GEN_MSG_2290');


    END IF;

EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_GEN_MSG_2290');
END;

PROCEDURE PRC_GEN_MSG_CHGSYSVAR (
   v_tltxcd   VARCHAR2,
   v_key      VARCHAR2,
   v_strMsg   IN OUT VARCHAR2 ,
   v_errcode  IN OUT VARCHAR2,
   v_errmsg   IN OUT VARCHAR2
)
IS
   v_Msgformat  VARCHAR2(4000);
   v_Txcode     VARCHAR2(100);
   v_msgHeader  VARCHAR2(500);
   v_strTxnum   VARCHAR2(100);
   v_strTxdate  VARCHAR2(20);
   v_value      VARCHAR2(100);
BEGIN
   plog.setbeginsection (pkgctx, 'PRC_CHANGESYSVAR');
   v_errcode:= gc_Success;
   BEGIN
      SELECT fm.MSGFORMAT, fm.TXCODE INTO v_Msgformat, v_Txcode
      FROM fotxmap tx, fotxformat fm
      WHERE tx.TXCODE= fm.TXCODE AND tx.TLTXCD = v_tltxcd;
   EXCEPTION WHEN OTHERS THEN
      v_errmsg:= 'Chua khai bao format cho msg giao dich ' || v_tltxcd;
      v_errcode:=errnums.C_SYSTEM_ERROR;
      plog.setendsection (pkgctx, 'PRC_CHANGESYSVAR');
      RETURN;
   END;

   /*{"msgtype" : "<$MSGTYPE>", "key"  : "<$VARNAME>", "value"  : "<$VARVALUE>" }*/

   SELECT '99' || LPAD (seq_batchtxnum.NEXTVAL, 8, '0') txnum INTO v_strTxnum FROM dual;
   SELECT VARVALUE INTO v_strTxdate FROM sysvar WHERE VARNAME = 'CURRDATE';
   SELECT VARVALUE INTO v_value FROM sysvar WHERE VARNAME = v_key;

   v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "A", "tlxtcd" : "<$TLTXCD>"';
   v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
   v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_strTxnum);
   v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',v_strTxdate);
   v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>','');

   v_Msgformat := Replace(v_Msgformat,'<$MSGTYPE>', v_Txcode);
   v_Msgformat := Replace(v_Msgformat,'<$VARNAME>' , v_key);
   v_Msgformat := Replace(v_Msgformat,'<$VARVALUE>' , v_value);

   v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';

   plog.debug(pkgctx, v_strMsg);
   plog.setendsection (pkgctx, 'PRC_CHANGESYSVAR');
EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_CHANGESYSVAR');
END;

PROCEDURE PRC_GENSEINFO_PARAM
IS
   v_count NUMBER;
BEGIN
  SELECT count(*) INTO v_count FROM T_FO_TMP_INSTRUMENTS;
  IF v_count = 0 THEN
    INSERT INTO T_FO_TMP_INSTRUMENTS(SYMBOL, PRICE_NAV, QTTY_AVRTRADE, LASTCHANGE)
    SELECT SYMBOL, PRICE_NAV, QTTY_AVRTRADE, LASTCHANGE
    FROM  T_FO_INSTRUMENTS;
  END IF;

  DELETE FROM T_FO_BUF_INSTRUMENTS;
  INSERT INTO T_FO_BUF_INSTRUMENTS(SYMBOL, PRICE_NAV, QTTY_AVRTRADE, LASTCHANGE)
  SELECT SYMBOL, PRICE_NAV, QTTY_AVRTRADE, SYSTIMESTAMP
  FROM V_FO_INSTRUMENTS;

  --So sanh du lieu
  INSERT INTO T_FO_INDAY_INSTRUMENTS(SYMBOL, PRICE_NAV, QTTY_AVRTRADE, ACTIONTYPE, STATUS, LASTCHANGE)
  SELECT SYMBOL, PRICE_NAV, QTTY_AVRTRADE, 'U', 'N', LASTCHANGE
  FROM T_FO_BUF_INSTRUMENTS v
  WHERE NOT EXISTS (SELECT * FROM T_FO_TMP_INSTRUMENTS t WHERE t.symbol = v.symbol);

  INSERT INTO T_FO_INDAY_INSTRUMENTS(SYMBOL, PRICE_NAV, QTTY_AVRTRADE, ACTIONTYPE, STATUS, LASTCHANGE)
  SELECT SYMBOL, PRICE_NAV, QTTY_AVRTRADE, 'U', 'N', SYSTIMESTAMP
  FROM T_FO_TMP_INSTRUMENTS t
  WHERE NOT EXISTS (SELECT * FROM T_FO_BUF_INSTRUMENTS v WHERE t.symbol = v.symbol);

  INSERT INTO T_FO_INDAY_INSTRUMENTS(SYMBOL, PRICE_NAV, QTTY_AVRTRADE, ACTIONTYPE, STATUS, LASTCHANGE)
  SELECT v.SYMBOL, v.PRICE_NAV, v.QTTY_AVRTRADE, 'U', 'N', SYSTIMESTAMP
  FROM T_FO_BUF_INSTRUMENTS v, T_FO_TMP_INSTRUMENTS t
  WHERE t.symbol = v.symbol
   AND (t.PRICE_NAV <> v.PRICE_NAV OR t.QTTY_AVRTRADE <> v.QTTY_AVRTRADE);

  --Dua du lieu sau khi thay doi vao bang TMP.
  DELETE FROM T_FO_TMP_INSTRUMENTS;
  INSERT INTO T_FO_TMP_INSTRUMENTS(SYMBOL, PRICE_NAV, QTTY_AVRTRADE, LASTCHANGE)
  SELECT SYMBOL, PRICE_NAV, QTTY_AVRTRADE, SYSTIMESTAMP
  FROM  T_FO_BUF_INSTRUMENTS;
  COMMIT;
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
END;

PROCEDURE PRC_GEN_MSG_CHGSEINFO (
   v_tltxcd   VARCHAR2,
   v_strMsg   IN OUT VARCHAR2 ,
   v_errcode  IN OUT VARCHAR2,
   v_errmsg   IN OUT VARCHAR2
)
IS
   v_Msgformat  VARCHAR2(4000);
   v_Txcode     VARCHAR2(100);
   v_msgHeader  VARCHAR2(500);
   v_strTxnum   VARCHAR2(100);
   v_strTxdate  VARCHAR2(20);
   v_value      VARCHAR2(100);
BEGIN
   plog.setbeginsection (pkgctx, 'PRC_GEN_MSG_CHGSEINFO');
   v_errcode:= gc_Success;
   BEGIN
      SELECT fm.MSGFORMAT, fm.TXCODE INTO v_Msgformat, v_Txcode
      FROM fotxmap tx, fotxformat fm
      WHERE tx.TXCODE= fm.TXCODE AND tx.TLTXCD = v_tltxcd;
   EXCEPTION WHEN OTHERS THEN
      v_errmsg:= 'Chua khai bao format cho msg giao dich ' || v_tltxcd;
      v_errcode:=errnums.C_SYSTEM_ERROR;
      plog.setendsection (pkgctx, 'PRC_GEN_MSG_CHGSEINFO');
      RETURN;
   END;

   /*{"msgtype" : "<$MSGTYPE>", "key"  : "<$VARNAME>", "value"  : "<$VARVALUE>" }*/

   SELECT '99' || LPAD (seq_batchtxnum.NEXTVAL, 8, '0') txnum INTO v_strTxnum FROM dual;
   SELECT VARVALUE INTO v_strTxdate FROM sysvar WHERE VARNAME = 'CURRDATE';

   v_msgHeader:='{"msgtype": "<$MSGTYPE>", "txnum" : "<$TXNUM>", "txdate" : "<$TXDATE>", "action" : "A", "tlxtcd" : "<$TLTXCD>"';
   v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>','tx5100');
   v_msgHeader:= REPLACE(v_msgHeader,'<$TXNUM>', v_strTxnum);
   v_msgHeader:= REPLACE(v_msgHeader,'<$TXDATE>',v_strTxdate);
   v_msgHeader:= REPLACE(v_msgHeader,'<$TLTXCD>','');

   v_Msgformat := Replace(v_Msgformat,'<$MSGTYPE>', v_Txcode);

   v_strMsg:= v_msgHeader || ',"detail":['||  v_Msgformat ||']}';

   plog.debug(pkgctx, v_strMsg);
   plog.setendsection (pkgctx, 'PRC_GEN_MSG_CHGSEINFO');
EXCEPTION WHEN OTHERS THEN
   v_errmsg:= SQLERRM;
   v_errcode:=errnums.C_SYSTEM_ERROR;
   plog.setendsection (pkgctx, 'PRC_GEN_MSG_CHGSEINFO');
END;

PROCEDURE PRC_GEN_PLACEORDERS(pv_accountNo  IN VARCHAR2,
                              pv_execType   IN VARCHAR2,
                              pv_symbol     IN VARCHAR2,
                              pv_priceType  IN VARCHAR2,
                              pv_price      IN NUMBER,
                              pv_quantity   IN NUMBER,
                              pv_userID     IN VARCHAR2,
                              pv_via        IN VARCHAR2,
                              pv_isdisposal IN VARCHAR2 DEFAULT 'N',
                              pv_timetype   IN VARCHAR2 DEFAULT 'T',
                              pv_strMessage IN OUT VARCHAR2)
IS
   v_msgHeader      VARCHAR2(4000);
   l_currdate       DATE;
   l_msgType        VARCHAR2(20);
   l_requestid      VARCHAR2(100);
   l_typecd         VARCHAR2(20);
   l_classcd        VARCHAR2(20);
BEGIN
   plog.setbeginsection (pkgctx, 'PCK_API_CALL_FOSERVICE.PRC_GEN_PLACEORDERS');
   v_msgHeader := '{';
   v_msgHeader := v_msgHeader || '"msgtype":"<$MSGTYPE>",';
   v_msgHeader := v_msgHeader || '"requestid":"<$REQUESTID>",';
   v_msgHeader := v_msgHeader || '"userid":"<$USERID>",';
   v_msgHeader := v_msgHeader || '"acctno":"<$ACCTNO>",';
   v_msgHeader := v_msgHeader || '"symbol":"<$SYMBOL>",';
   v_msgHeader := v_msgHeader || '"via":"<$VIA>",';
   v_msgHeader := v_msgHeader || '"typecd":"<$TYPECD>",';
   v_msgHeader := v_msgHeader || '"subtypecd":"<$PRICETYPE>",';
   v_msgHeader := v_msgHeader || '"qtty": <$QTTY>,';
   v_msgHeader := v_msgHeader || '"price": <$PRICE>,';
   v_msgHeader := v_msgHeader || '"classcd":"<$CLASSCD>"';
   --v_msgHeader := v_msgHeader || '"createddt":"<$CREATEDATE>",';
   --v_msgHeader := v_msgHeader || '"expireddt":"<$EXPDATE>"';
   v_msgHeader := v_msgHeader || '}';


   -------
   SELECT getcurrdate,
          TO_CHAR(getcurrdate,'RRRRMMDD')||'68'||seq_api_foservice_reqid.nextval requestid,
          --DECODE(pv_execType, 'NB', 'tx0001', 'tx0000') msgType,
      (CASE
             WHEN pv_execType = 'NB' THEN 'tx0001'
             WHEN pv_execType = 'CB' OR pv_execType = 'CS' THEN 'tx0100'
             WHEN pv_execType = 'NS' THEN 'tx0000'
             WHEN pv_execType = 'AS' OR pv_execType = 'AB' THEN 'tx0200'
             ELSE 'tx0000'
          END) msgType,
          DECODE(pv_priceType, 'LO', 'LO', 'MK') typecd,
          CASE WHEN pv_isdisposal ='Y' THEN 'FSO'
         WHEN pv_timetype ='G' THEN 'GTC'
         WHEN pv_priceType ='LO' THEN 'DLO'
         ELSE 'DMO' END classcd
   INTO l_currdate,
        l_requestid,
        l_msgType,
        l_typecd,
        l_classcd
   FROM DUAL;



   v_msgHeader:= REPLACE(v_msgHeader,'<$MSGTYPE>',l_msgType);
   v_msgHeader:= REPLACE(v_msgHeader,'<$REQUESTID>',l_requestid);
   v_msgHeader:= REPLACE(v_msgHeader,'<$USERID>',pv_userID);
   v_msgHeader:= REPLACE(v_msgHeader,'<$ACCTNO>',pv_accountNo);
   v_msgHeader:= REPLACE(v_msgHeader,'<$SYMBOL>',pv_symbol);
   v_msgHeader:= REPLACE(v_msgHeader,'<$VIA>',pv_via);
   v_msgHeader:= REPLACE(v_msgHeader,'<$TYPECD>',l_typecd);
   v_msgHeader:= REPLACE(v_msgHeader,'<$PRICETYPE>',pv_priceType);
   v_msgHeader:= REPLACE(v_msgHeader,'<$QTTY>',pv_quantity);
   v_msgHeader:= REPLACE(v_msgHeader,'<$PRICE>',pv_price);
   v_msgHeader:= REPLACE(v_msgHeader,'<$CLASSCD>',l_classcd);
   v_msgHeader:= REPLACE(v_msgHeader,'<$CREATEDATE>', TO_CHAR(l_currdate,'RRRR-MM-DD'));
   v_msgHeader:= REPLACE(v_msgHeader,'<$EXPDATE>','');

   pv_strMessage := v_msgHeader;
   plog.setendsection (pkgctx, 'PCK_API_CALL_FOSERVICE.PRC_GEN_PLACEORDERS');
EXCEPTION WHEN OTHERS THEN
   pv_strMessage := '';
   plog.error (pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
   plog.setendsection (pkgctx, 'PCK_API_CALL_FOSERVICE.PRC_GEN_PLACEORDERS');
END;

PROCEDURE PRC_PLACEORDERS(pv_accountNo   IN VARCHAR2,
                          pv_execType    IN VARCHAR2,
                          pv_symbol      IN VARCHAR2,
                          pv_priceType   IN VARCHAR2,
                          pv_price       IN NUMBER,
                          pv_quantity    IN NUMBER,
                          pv_userID      IN VARCHAR2,
                          pv_via         IN VARCHAR2,
                          pv_isdisposal  IN VARCHAR2 DEFAULT 'N',
                          pv_timetype  IN VARCHAR2 DEFAULT 'T',
                          pv_errorCode   OUT VARCHAR2,
                          pv_returnValue OUT VARCHAR2)
IS
    l_httpStatus      VARCHAR2(20);
    l_httpErrmsg      VARCHAR2(20);
    l_strMessage      VARCHAR2(4000);
    l_strResponse     VARCHAR2(4000);
    j_objectResponse  json;
    l_requestid       VARCHAR2(100);

BEGIN
    plog.setbeginsection (pkgctx, 'PCK_API_CALL_FOSERVICE.PRC_PLACEORDERS');
    --l_httpStatus := gc_httpsatus;

    PRC_GEN_PLACEORDERS(pv_accountNo,
                      pv_execType,
                      pv_symbol,
                      pv_priceType,
                      pv_price,
                      pv_quantity,
                      pv_userID,
                      pv_via,
                      pv_isdisposal,
                      pv_timetype,
                      l_strMessage);

    plog.debug(pkgctx,'l_strMessage: '||l_strMessage);

    PRC_CALLWEBSERVICE(l_strMessage,
                         pv_errorCode,
                         pv_returnValue,
                         l_strResponse);

    plog.debug(pkgctx,'l_strResponse: '||l_strResponse);

    pv_returnValue := l_strResponse;
    plog.setendsection(pkgctx, 'PCK_API_CALL_FOSERVICE.PRC_PLACEORDERS');
    RETURN;
EXCEPTION WHEN OTHERS THEN
  pv_errorCode := -1;
  plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
  plog.setendsection(pkgctx, 'PCK_API_CALL_FOSERVICE.PRC_PLACEORDERS');
  RETURN;
END;

BEGIN
  FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;

  pkgctx := plog.init('txpks_msg',
                      plevel => NVL(logrow.loglevel,30),
                      plogtable => (NVL(logrow.log4table,'Y') = 'Y'),
                      palert => (logrow.log4alert = 'Y'),
                      ptrace => (logrow.log4trace = 'Y'));
END;
/
