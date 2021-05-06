CREATE OR REPLACE PROCEDURE SE2255_1(PV_REFCURSOR      IN OUT PKG_REPORT.REF_CURSOR,
                                     OPT               IN VARCHAR2,
                                     PV_BRID           IN VARCHAR2,
                                     PV_AUTOID         IN VARCHAR2
                                     ) IS

  -- RP NAME : BAO CAO XAC NHAN CHUNG KHOAN CHUYEN KHOAN
  -- PERSON --------------------DATE---------------------COMMENTS
  -- MAI.NGUYENPHUONG           07/12/2020               CREATE NEW
  -- ---------   ------  -------------------------------------------

  V_INBRID      VARCHAR2(4);
  V_STRBRID     VARCHAR2(50);
  V_STROPTION   VARCHAR2(5);
  V_AUTOID      NUMBER(10);
BEGIN
  -- GET REPORT'S PARAMETERS
  V_STROPTION := upper(OPT);
  V_INBRID    := PV_BRID;
  if (V_STROPTION = 'A') then
    V_STRBRID := '%%';
  else
    if (V_STROPTION = 'B') then
      select br.brid into V_STRBRID from brgrp br where br.brid = V_INBRID;
    else
      V_STRBRID := V_INBRID;
    end if;
  end if;

  V_AUTOID := to_number(PV_AUTOID);

  -- GET REPORT'S DATA
  OPEN PV_REFCURSOR FOR
      SELECT cf.custodycd,ses.recustodycd,ses.txdate, ses.txnum,ses.autoid,max(a.cdcontent) tradeplace,max(NVL(sb2.symbol,sb.symbol)) symbol,
            max(de.fullname) member_name,max(cf.fullname) fullname, max(cf.idcode) idcode, max(cf.iddate) iddate,
            SUM(CASE WHEN sep.cacatype='021' AND instr(sb.symbol,'WFT') = 0 THEN sep.qtty ELSE 0 END) cophieuthuong_GD,
            SUM(CASE WHEN sep.cacatype='021' AND instr(sb.symbol,'WFT') > 0 THEN sep.qtty ELSE 0 END) cophieuthuong_CGD,
            SUM(CASE WHEN sep.cacatype='011' AND instr(sb.symbol,'WFT') = 0 THEN sep.qtty ELSE 0 END) cotucchungkhoan_GD,
            SUM(CASE WHEN sep.cacatype='011' AND instr(sb.symbol,'WFT') > 0 THEN sep.qtty ELSE 0 END) cotucchungkhoan_CGD
        FROM
        (SELECT se.recustodycd, se.txnum, se.txdate, se.autoid,se.acctno,substr(se.acctno,1,10) afacctno, se.codeid
           FROM Sesendout se
          WHERE se.deltd <> 'Y'
           AND se.trade + se.blocked + se.strade + se.sblocked > 0
        UNION ALL
        SELECT se47.recustodycd, se47.txnum, se47.txdate, se47.autoid,se47.acctno,substr(se47.acctno,1,10) afacctno, se47.codeid
           FROM se2247_log se47
          WHERE se47.deltd <> 'Y'
            AND se47.qtty > 0
        ) ses,
        afmast af, cfmast cf, deposit_member de, sbsecurities sb, allcode a, sbsecurities sb2,
        (SELECT s.*,NVL(ca.catype,s.catype) cacatype FROM SEPITALLOCATE s, CAMAST ca
          WHERE s.camastid = ca.camastid(+)
            AND NVL(ca.catype,'021') IN ('021','011'))  sep
          WHERE sep.txnum (+) = ses.txnum
            AND sep.txdate (+) = ses.txdate
            AND substr(ses.acctno,1,10) = af.acctno
            AND af.custid = cf.custid
            AND SUBSTR(ses.recustodycd,1,3) = de.depositid (+)
            AND sb.codeid = ses.codeid
            AND sb.refcodeid = sb2.codeid (+)
            AND a.cdval = NVL(sb2.tradeplace,sb.tradeplace) AND a.cdname='TRADEPLACE' AND a.cdtype='SE'
            AND ses.autoid = V_AUTOID
      GROUP BY cf.custodycd,ses.recustodycd,ses.txdate, ses.txnum,ses.autoid
      ORDER BY ses.txdate DESC, ses.txnum
      ;
EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END;
/
