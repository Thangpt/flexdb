CREATE OR REPLACE PACKAGE pck_newfo
  IS
    FUNCTION fn_syn_info_2_fo(p_txmsg in tx.msg_rectype,p_err_code  OUT varchar2) RETURN NUMBER;
END; -- Package spec
/

CREATE OR REPLACE PACKAGE BODY pck_newfo
IS
    pkgctx plog.log_ctx;
    logrow tlogdebug%ROWTYPE;

FUNCTION fn_syn_info_2_fo(p_txmsg in tx.msg_rectype,p_err_code  OUT varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_syn_info_2_fo');
    plog.debug(pkgctx, p_txmsg.tltxcd||' txnum'||p_txmsg.txnum);
    plog.debug(pkgctx, p_txmsg.tltxcd||' txdate'||p_txmsg.txdate);
    -- SE
    DELETE FROM t_fo_stock_lot_update
     WHERE  txnum = p_txmsg.txnum
            AND txdate = p_txmsg.txdate
            AND acctno IN (SELECT substr(acctno,1,10) acctno FROM setran WHERE txnum = p_txmsg.txnum AND txdate = p_txmsg.txdate AND deltd = 'N');
    --Lay but toan giao dich truc tiep sinh ra
    INSERT INTO t_fo_stock_lot_update (txnum, txdate, acctno, symbol, qtty, dorc, trantype,pitqtty,taxrate)
        SELECT  p_txmsg.txnum txnum,
                p_txmsg.txdate txdate,
                substr(tr.acctno,1,10) acctno,
                MAX(sec.symbol) symbol,
                --SUM(CASE WHEN tx.txtype = 'C' THEN tr.namt ELSE - tr.namt END) qtty,
                SUM(tr.namt) qtty,
                tx.txtype dorc,
                CASE WHEN tx.field = 'TRADE' THEN 'T' ELSE 'B' END trantype,
                SUM(CASE WHEN p_txmsg.tltxcd ='3356' AND instr(sec.symbol,'WFT') =0 THEN NVL(sep.pitqtty,0) ELSE 0 END) pitqty, --1.8.2.5: thue quyen
                SUM(CASE WHEN p_txmsg.tltxcd ='3356' AND instr(sec.symbol,'WFT') =0 THEN NVL(sep.taxrate,0) ELSE 0 END) taxrate
          FROM  setran tr, sbsecurities sec, apptx tx,--, tllog tl
                (SELECT acctno,camastid, SUM(qtty - mapqtty) pitqtty , max(pitrate) taxrate
                        FROM sepitlog 
                       WHERE camastid=p_txmsg.txfields('03').value 
                         AND qtty - mapqtty > 0
                       GROUP BY acctno,camastid) sep
         WHERE  tr.txnum = p_txmsg.txnum
                --OR tl.reftxnum = p_txmsg.txnum
                AND tr.txdate = p_txmsg.txdate AND tr.deltd = 'N'
                AND substr(tr.acctno,11) = sec.codeid
                AND tr.txcd = tx.txcd AND tx.apptype = 'SE' AND tx.field IN ('TRADE', 'BLOCKED')
                AND tr.namt >0
                --AND tr.txnum = tl.txnum AND tr.txdate = tl.txdate
                AND tr.acctno = sep.acctno (+)
      GROUP BY  tr.acctno,tx.txtype,tx.field;
    --Lay but toan do giao dich duoc goi den sinh ra: vi du 3350 duoc sinh tu 3342.
    INSERT INTO t_fo_stock_lot_update (txnum, txdate, acctno, symbol, qtty, dorc, trantype,pitqtty,taxrate)
        SELECT  p_txmsg.txnum txnum,
                p_txmsg.txdate txdate,
                substr(tr.acctno,1,10) acctno,
                MAX(sec.symbol) symbol,
                --SUM(CASE WHEN tx.txtype = 'C' THEN tr.namt ELSE - tr.namt END) qtty,
                SUM(tr.namt) qtty,
                tx.txtype dorc,
                CASE WHEN tx.field = 'TRADE' THEN 'T' ELSE 'B' END trantype,
                SUM(CASE WHEN tl.tltxcd = '3351' AND instr(sec.symbol,'WFT') =0 THEN NVL(sep.pitqtty,0) ELSE 0 END) pitqty, --1.8.2.5: thue quyen
                SUM(CASE WHEN tl.tltxcd = '3351' AND instr(sec.symbol,'WFT') =0 THEN NVL(sep.taxrate,0) ELSE 0 END) taxrate
          FROM  setran tr, sbsecurities sec, apptx tx, tllog tl,
               (SELECT acctno,camastid, SUM(qtty - mapqtty) pitqtty , max(pitrate) taxrate
                  FROM sepitlog 
                 WHERE camastid=p_txmsg.txfields('03').value 
                   AND txdate=p_txmsg.txdate
                   AND qtty - mapqtty > 0
                 GROUP BY acctno,camastid) sep
         WHERE  tr.txnum = tl.txnum AND tr.txdate = tl.txdate
                AND tl.reftxnum = p_txmsg.txnum
                AND tl.txdate   = p_txmsg.txdate
                AND tr.deltd    = 'N'
                AND substr(tr.acctno,11) = sec.codeid
                AND tr.txcd = tx.txcd AND tx.apptype = 'SE' AND tx.field IN ('TRADE', 'BLOCKED')
                AND tr.namt >0
                AND tr.acctno = sep.acctno (+)
      GROUP BY  tr.acctno,tx.txtype,tx.field;

    -- CI
    DELETE FROM t_fo_cash_lot_update
     WHERE  txnum = p_txmsg.txnum
            AND txdate = p_txmsg.txdate
            AND acctno IN (SELECT acctno FROM citran WHERE txnum = p_txmsg.txnum AND txdate = p_txmsg.txdate AND deltd = 'N');

    INSERT INTO t_fo_cash_lot_update (txnum, txdate, acctno, amount, dorc)
        SELECT  p_txmsg.txnum txnum,
                p_txmsg.txdate txdate,
                tr.acctno,
                --SUM(CASE WHEN tx.txtype = 'C' THEN tr.namt ELSE - tr.namt END) amount,
                SUM(tr.namt) amount,
                tx.txtype dorc
          FROM  citran tr, apptx tx --, tllog tl
         WHERE  (tr.txnum = p_txmsg.txnum
                --OR tl.reftxnum = p_txmsg.txnum
                ) AND tr.txdate = p_txmsg.txdate AND tr.deltd = 'N'
                AND tr.txcd = tx.txcd AND tx.apptype = 'CI' AND tx.field = 'BALANCE'
                AND tr.namt >0
                --AND tr.txnum = tl.txnum AND tr.txdate = tl.txdate
      GROUP BY  tr.acctno,tx.txtype;

      --Insert cac but toan do giao dich gian tiep
      INSERT INTO t_fo_cash_lot_update (txnum, txdate, acctno, amount, dorc)
        SELECT  p_txmsg.txnum txnum,
                p_txmsg.txdate txdate,
                tr.acctno,
                SUM(tr.namt) amount,
                tx.txtype dorc
          FROM  citran tr, apptx tx , tllog tl
         WHERE   tl.reftxnum = p_txmsg.txnum
                AND tr.txdate = p_txmsg.txdate AND tr.deltd = 'N'
                AND tr.txcd = tx.txcd AND tx.apptype = 'CI' AND tx.field = 'BALANCE'
                AND tr.namt >0
                AND tr.txnum = tl.txnum AND tr.txdate = tl.txdate
      GROUP BY  tr.acctno,tx.txtype;

    p_err_code := systemnums.C_SUCCESS;
    plog.setendsection (pkgctx, 'fn_syn_info_2_fo');
    RETURN systemnums.C_SUCCESS;

EXCEPTION WHEN OTHERS THEN
    p_err_code := '-1';
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'fn_syn_info_2_fo');
    RETURN errnums.C_SYSTEM_ERROR ;
END fn_syn_info_2_fo;

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

