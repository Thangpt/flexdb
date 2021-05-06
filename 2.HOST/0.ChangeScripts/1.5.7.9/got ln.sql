-- Lay Danh Sach Tk Can Xu Ly Du Lieu
select lnm.trfacctno, lnm.acctno, lnm.intnmlacr intnmlacr1, lns.intnmlacr intnmlacr2
from lnmast lnm
left join (select sum(intnmlacr) intnmlacr, acctno from lnschd group by acctno) lns on lnm.acctno = lns.acctno 
where lnm.intnmlacr <> lns.intnmlacr
and trfacctno IN (SELECT afacctno FROM registerproduc);

-- BackUp Du Lieu
CREATE TABLE lnmast_20190424 AS 
SELECT * FROM lnmast WHERE acctno IN ('0003180419000016','0101100419000034','0003090419000008','0002280319000033',
'0003080419000020','0003280319000031','0002050419000034','0101200319000025','0003090419000010','0101030419000007');
CREATE TABLE tbl_mr3007_log_20190424 AS
SELECT * FROM tbl_mr3007_log 
WHERE txdate >= TO_DATE('01/04/2019', 'dd/mm/rrrr') AND afacctno IN ('0003000650','0101023788','0003000654','0101023748','0003000715','0101023786',
'0002006245','0003000659','0003000647','0002006251');
CREATE TABLE mr5005_log_20190424 AS
SELECT * FROM mr5005_log 
WHERE txdate >= TO_DATE('01/04/2019', 'dd/mm/rrrr') AND afacctno IN ('0003000650','0101023788','0003000654','0101023748','0003000715','0101023786',
'0002006245','0003000659','0003000647','0002006251');

/*Update lai lnmast.intnmlacr*/
DECLARE
l_intnmlacr   NUMBER;
BEGIN
  FOR rec IN (SELECT * FROM lnmast WHERE trfacctno IN (SELECT afacctno FROM registerproduc) 
               AND acctno IN ('0003180419000016','0101100419000034','0003090419000008','0002280319000033',
'0003080419000020','0003280319000031','0002050419000034','0101200319000025','0003090419000010','0101030419000007'))
  LOOP
    BEGIN
      SELECT sum(l.intnmlacr) INTO l_intnmlacr
      FROM lnschd l
      WHERE l.acctno = rec.acctno;
    EXCEPTION
      WHEN OTHERS THEN
        l_intnmlacr := 0;
    END;
    
    UPDATE lnmast SET intnmlacr = NVL(l_intnmlacr, 0) WHERE acctno = rec.acctno;
  END LOOP;
  Commit;
END;
/
/*Update lai tbl_mr3007_log --> theo afacctno*/
DECLARE
  l_tranamt       NUMBER;
  l_currMarginAmt NUMBER;
  l_preAcctno     VARCHAR2(20) := 'x';
BEGIN
  FOR rec IN (
    SELECT distinct txdate, t.afacctno, t.mramt
    FROM tbl_mr3007_log t
    WHERE t.txdate >= TO_DATE('01/04/2019', 'dd/mm/rrrr')
    AND t.afacctno IN (SELECT afacctno FROM registerproduc)
    AND afacctno IN ('0003000650','0101023788','0003000654','0101023748','0003000715','0101023786','0002006245','0003000659','0003000647','0002006251')
    ORDER BY afacctno, txdate DESC
  ) LOOP
    IF l_preAcctno <> rec.afacctno THEN
      l_preAcctno := rec.afacctno;
      BEGIN
        -- marginAmt Hien tai
        SELECT SUM (prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd
                       +feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd) INTO l_currMarginAmt
        FROM lnmast
        WHERE trfacctno = rec.afacctno;
      EXCEPTION
        WHEN OTHERS THEN
          l_currMarginAmt := 0;
      END;
      l_currMarginAmt := NVL(l_currMarginAmt, 0);
    END IF;
    
    BEGIN
      -- Tong Phat Sinh Tu Ngay Den ngay Hien Tai
      SELECT SUM(l.nml + l.ovd + l.intnmlacr + l.intdue + l.intovd + l.intovdprin + l.feeintnmlacr) INTO l_tranamt
      FROM lnschdloghist l
      WHERE l.autoid IN (SELECT autoid FROM vw_lnschd_all lns, lnmast lnm 
                         WHERE lns.acctno = lnm.acctno AND lnm.trfacctno = rec.afacctno)
      AND l.txdate > rec.txdate;
    EXCEPTION
      WHEN OTHERS THEN
        l_tranamt := 0;
    END;
    l_tranamt := NVL(l_tranamt, 0);
    
    UPDATE tbl_mr3007_log SET mramt = l_currMarginAmt - l_tranamt WHERE txdate = rec.txdate AND afacctno = rec.afacctno;
  END LOOP;
  Commit;
END;

/
/*Update lai mr5005_log --> theo afacctno,  rrtype, custbank*/
DECLARE
  l_intNmlAcr     NUMBER;
  l_currMarginAmt NUMBER;
BEGIN
  FOR rec IN (
    SELECT distinct txdate, t.afacctno, rrtype, custbank
    FROM mr5005_log t
    WHERE t.txdate >= TO_DATE('01/04/2019', 'dd/mm/rrrr')
    AND t.afacctno IN (SELECT afacctno FROM registerproduc)
    AND afacctno IN ('0003000650','0101023788','0003000654','0101023748','0003000715','0101023786','0002006245','0003000659','0003000647','0002006251')
    ORDER BY txdate DESC
  ) LOOP
    BEGIN
      SELECT SUM (lnm.intnmlacr + intdue + intovdacr + intnmlovd + feeintnmlacr + feeintdue + feeintovdacr + feeintnmlovd) INTO l_currMarginAmt
      FROM lnmast lnm
      WHERE lnm.trfacctno = rec.afacctno AND lnm.rrtype = rec.rrtype AND NVL(lnm.custbank, 'x') = NVL(rec.custbank, 'x');
    EXCEPTION
      WHEN OTHERS THEN
        l_currMarginAmt := 0;
    END;
    l_currMarginAmt := NVL(l_currMarginAmt, 0);
    BEGIN
      SELECT SUM(l.INTNMLACR + INTOVDPRIN + FEEINTNMLACR + FEEINTOVDPRIN) INTO l_intNmlAcr
      FROM lnschdloghist l
      WHERE l.autoid IN (SELECT autoid FROM vw_lnschd_all lns, lnmast lnm 
                         WHERE lns.acctno = lnm.acctno AND lnm.trfacctno = rec.afacctno
                         AND lnm.rrtype = rec.rrtype AND NVL(lnm.custbank, 'x') = NVL(rec.custbank, 'x'))
      AND l.txdate > rec.txdate;
    EXCEPTION
      WHEN OTHERS THEN
        l_intNmlAcr := 0;
    END;
    l_intNmlAcr := NVL(l_intNmlAcr, 0);
    UPDATE mr5005_log SET mrintamt = l_currMarginAmt - l_intNmlAcr WHERE txdate = rec.txdate AND afacctno = rec.afacctno;
  END LOOP;
  Commit;
END;

