CREATE OR REPLACE PROCEDURE REVERT_REREVDGALL_REINTTRANA(p_txmsg in tx.msg_rectype, p_err_code out varchar2)
IS
   CURSOR cur_odcancel_rerevdgall(p_orderid odmasthist.orderid%TYPE, p_txdate DATE)
    IS
      SELECT ret.actype, sb.sectype, sb.tradeplace, re.refrecflnkid, re.reacctno, rem.reacctno orgreacctno, od.execamt matchamt, od.feeacr feeacr
      FROM reaflnk re, recfdef red, retype ret,
              (SELECT r.reacctno, r.afacctno
               FROM reaflnk r, retype t, recfdef rd
               WHERE r.status = 'A'
                  AND SUBSTR(r.reacctno, 11, 4) = t.actype
                  AND t.rerole = 'RD'
                  AND t.retype = 'D'
                  AND r.refrecflnkid = rd.refrecflnkid
                  AND SUBSTR(r.reacctno, 11, 4) = rd.reactype
                  AND rd.effdate <= p_txdate
                  AND p_txdate < rd.expdate) rem,
              odmast od,
              sbsecurities sb
       WHERE od.orderid = p_orderid
          AND re.status = 'A'
          AND re.deltd <> 'Y'
          AND re.frdate <= p_txdate
          AND p_txdate <= re.todate
          AND re.refrecflnkid = red.refrecflnkid
          AND SUBSTR(re.reacctno, 11, 4) = red.reactype
          AND red.effdate <= p_txdate
          AND p_txdate < red.expdate
          AND red.reactype = ret.actype
          AND ret.retype = 'D'
          AND ret.rerole IN ('BM', 'RM')
          AND re.afacctno = rem.afacctno
          AND od.deltd <> 'Y'
          AND od.txdate = p_txdate
          AND re.afacctno = od.afacctno
          AND od.execamt > 0
          AND (ret.rdisposal = 'N' OR (ret.rdisposal = 'Y' AND od.ISDISPOSAL = 'N')) -- khong tinh doanh so lenh xu ly
          AND sb.codeid = od.codeid;

    CURSOR cur_odcancel_reinttrana_direct(p_orderid odmast.orderid%TYPE, p_txdate DATE)
    IS
      SELECT ret.actype, sb.sectype, sb.tradeplace, re.refrecflnkid, re.reacctno, od.execamt matchamt,
             DECODE(rem.odfeetype,'F',od.execamt*rem.odfeerate/100,od.feeacr) feeacr,
             rem.DAMTLASTDT DAMTLASTDT,
             rem.odfeetype odfeetype,
             rem.odfeerate odfeerate
      FROM reaflnk re, odmast od, recfdef red, retype ret, remast rem, sbsecurities sb
      WHERE od.orderid = p_orderid
        AND re.status='A' AND re.deltd<>'Y'
        AND re.frdate<= p_txdate AND p_txdate <= re.todate
        AND od.deltd<>'Y'
        AND od.txdate = p_txdate
        AND re.afacctno=od.afacctno
        AND od.execamt > 0
        AND re.refrecflnkid = red.refrecflnkid
        AND SUBSTR(re.reacctno,11,4)=red.reactype
        AND red.effdate<= p_txdate AND  p_txdate < red.expdate
        AND red.reactype=ret.actype
        AND ret.retype='D'
        AND re.reacctno=rem.acctno
        AND sb.codeid=od.codeid
        AND (ret.rdisposal = 'N' OR (ret.rdisposal = 'Y' AND od.ISDISPOSAL = 'N'));  -- khong tinh doanh so lenh xu ly

    v_odrerevdgall cur_odcancel_rerevdgall%ROWTYPE;
    v_reinttrana_direct cur_odcancel_reinttrana_direct%ROWTYPE;
    v_dttxdate odmast.txdate%TYPE;
    v_norderid odmast.orderid%TYPE;
    v_reacctno reaflnk.reacctno%TYPE;
    v_rfmatchamt number(20,4);
    v_rffeeacr number(20,4);

BEGIN
    v_dttxdate := to_date(p_txmsg.txfields('08').value,'DD/MM/RRRR');
    v_norderid := p_txmsg.txfields('01').value;

    -- revert bang REREVDGALL
    OPEN cur_odcancel_rerevdgall(v_norderid, v_dttxdate);
       FETCH cur_odcancel_rerevdgall INTO v_odrerevdgall;

       IF cur_odcancel_rerevdgall%FOUND THEN

          SELECT NVL(SUM(DECODE(RF.CALTYPE, '0001', RF.RERFRATE, 0) * v_odrerevdgall.MATCHAMT / 100), 0), --  GIAM TRU DOANH SO
                 NVL(SUM(DECODE(RF.CALTYPE, '0002', RF.RERFRATE, 0) * v_odrerevdgall.FEEACR / 100), 0) --  GIAM TRU DOANH thu
          INTO v_rfmatchamt, v_rffeeacr
          FROM (SELECT rerftype, caltype, min(stt) stt
                FROM (SELECT rf.*,
                      CASE
                        WHEN RF.SYMTYPE <> '000' AND RF.TRADEPLACE <> '000' THEN 0
                        WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE <> '000' THEN 1
                        WHEN RF.SYMTYPE <> '000' AND RF.TRADEPLACE = '000' THEN 2
                        WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE = '000' THEN 3
                      END STT
                      FROM rerfee rf
                      WHERE rf.refobjid = v_odrerevdgall.ACTYPE
                          AND (v_odrerevdgall.TRADEPLACE = RF.TRADEPLACE OR RF.TRADEPLACE = '000')
                          AND (v_odrerevdgall.sectype = RF.SYMTYPE OR RF.SYMTYPE = '000')
                  )
                  GROUP BY rerftype, caltype) A,
                 Rerfee rf
           WHERE A.rerftype = rf.rerftype
             AND A.caltype = rf.caltype
             AND (v_odrerevdgall.TRADEPLACE = RF.TRADEPLACE OR RF.TRADEPLACE = '000')
             AND (v_odrerevdgall.sectype = RF.SYMTYPE OR RF.SYMTYPE = '000')
             AND rf.refobjid = v_odrerevdgall.actype
             AND (
             CASE
                WHEN RF.SYMTYPE <> '000' AND RF.TRADEPLACE <> '000' THEN 0
                WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE <> '000' THEN 1
                WHEN RF.SYMTYPE <> '000' AND RF.TRADEPLACE = '000' THEN 2
                WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE = '000' THEN 3
             END) = A.stt;
          -- Cap nhat lai
          UPDATE rerevdgall SET matchamt = matchamt - v_odrerevdgall.MATCHAMT,
                                feeacr = feeacr - v_odrerevdgall.FEEACR,
                                rfmatchamt = rfmatchamt - v_rfmatchamt,
                                rffeeacr = rffeeacr - v_rffeeacr
          WHERE reacctno = v_odrerevdgall.reacctno
            AND orgreacctno = v_odrerevdgall.orgreacctno
            AND tradeplace = v_odrerevdgall.tradeplace
            AND frdate = v_dttxdate
            AND todate = v_dttxdate;
       END IF;

    CLOSE cur_odcancel_rerevdgall;

    -- revert bang REINTTRANA
    OPEN cur_odcancel_reinttrana_direct(v_norderid, v_dttxdate);
       FETCH cur_odcancel_reinttrana_direct INTO v_reinttrana_direct;

       IF cur_odcancel_reinttrana_direct%FOUND THEN

          SELECT NVL(SUM(DECODE(RF.CALTYPE, '0001', RF.RERFRATE, 0)*v_reinttrana_direct.MATCHAMT/100), 0), --  GIAM TRU DOANH SO
                 NVL(SUM(DECODE(RF.CALTYPE, '0002', RF.RERFRATE, 0)*DECODE(v_reinttrana_direct.odfeetype, 'F', v_reinttrana_direct.odfeerate*v_reinttrana_direct.matchamt/100,v_reinttrana_direct.FEEACR)/100), 0) --  GIAM TRU DOANH thu
          INTO v_rfmatchamt, v_rffeeacr
          FROM (SELECT rerftype, caltype, MIN(stt) stt
                FROM (SELECT rf.*,
                      CASE
                         WHEN RF.SYMTYPE <> '000' AND RF.TRADEPLACE <> '000' THEN 0
                         WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE <> '000' THEN 1
                         WHEN RF.SYMTYPE <> '000' AND RF.TRADEPLACE = '000' THEN 2
                         WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE = '000' THEN 3
                       END STT
                       FROM rerfee rf
                       WHERE rf.refobjid = v_reinttrana_direct.ACTYPE
                         AND (v_reinttrana_direct.TRADEPLACE = RF.TRADEPLACE OR RF.TRADEPLACE = '000')
                         AND (v_reinttrana_direct.sectype = RF.SYMTYPE OR RF.SYMTYPE = '000')
                      )
                   GROUP BY rerftype, caltype) A,
                 Rerfee rf
           WHERE A.rerftype = rf.rerftype
             AND A.caltype = rf.caltype
             AND (v_reinttrana_direct.TRADEPLACE = RF.TRADEPLACE OR RF.TRADEPLACE = '000')
             AND (v_reinttrana_direct.sectype = RF.SYMTYPE OR RF.SYMTYPE = '000')
             AND rf.refobjid = v_reinttrana_direct.actype
             AND (CASE
                     WHEN RF.SYMTYPE <> '000' AND RF.TRADEPLACE <> '000' THEN 0
                     WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE <> '000' THEN 1
                     WHEN RF.SYMTYPE <> '000' AND RF.TRADEPLACE = '000' THEN 2
                     WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE = '000' THEN 3
                  END) = A.stt;
          -- truc tiep
          UPDATE reinttrana SET intbal = intbal - v_reinttrana_direct.MATCHAMT,
                                intamt = intamt - v_reinttrana_direct.FEEACR,
                                rfmatchamt = rfmatchamt - v_rfmatchamt,
                                rffeeacr = rffeeacr - v_rffeeacr
          WHERE acctno = v_reinttrana_direct.reacctno
            AND inttype = 'DBR'
            AND todate = v_dttxdate;
          -- gian tiep
          FOR vc IN(
             SELECT rg.custid||rg.actype reacctno
             FROM REGRP rg,
                 (SELECT rgl.refrecflnkid
                  FROM REGRPLNK rgl, remast rm, retype ret
                  WHERE rgl.reacctno = v_reinttrana_direct.reacctno
                    AND rgl.reacctno=rm.acctno
                    AND rgl.frdate<=getcurrdate and getcurrdate<=rgl.todate
                    AND rgl.deltd<>'Y'
                    AND rgl.status='A'
                    AND rm.status='A'
                    AND rm.actype=ret.actype
                    AND ret.retype='D' and ret.rerole in ('RM','BM')
                  GROUP BY rgl.refrecflnkid ) rgl
             WHERE SP_FORMAT_REGRP_MAPCODE( rgl.refrecflnkid) like SP_FORMAT_REGRP_MAPCODE(rg.autoid)||'%'
          ) LOOP
             UPDATE reinttrana SET intbal = intbal - v_reinttrana_direct.MATCHAMT,
                                   intamt = intamt - v_reinttrana_direct.FEEACR,
                                   rfmatchamt = rfmatchamt - v_rfmatchamt,
                                   rffeeacr = rffeeacr - v_rffeeacr
             WHERE acctno = vc.reacctno
               AND inttype = 'IBR'
               AND todate = v_dttxdate;
          END LOOP;
       END IF;
    CLOSE cur_odcancel_reinttrana_direct;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
END REVERT_REREVDGALL_REINTTRANA;
/
