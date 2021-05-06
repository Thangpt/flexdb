CREATE OR REPLACE FUNCTION need_trf_se_be4close(pv_strAFACCTNO VARCHAR2)
    RETURN VARCHAR2 IS
    v_Result  char(1);
    v_qtty_remain NUMBER;
    v_custid VARCHAR2(10);
    v_count NUMBER (20);

BEGIN
  v_Result:='N';
  v_qtty_remain:=0;
  SELECT custid INTO v_custid FROM afmast WHERE acctno=pv_strAFACCTNO;
-- kiem tra xem co pai TK cuoi cung ko
  SELECT COUNT(*) INTO v_count FROM afmast   WHERE custid = v_custid AND status  IN ('A','P');
  if(v_count>1) THEN
  RETURN v_Result;

  END IF;

-- Neu la TK cuoi cung kiem tra xem KH co con CK khong
   SELECT COUNT(*) INTO v_count FROM semast WHERE  custid=v_custid;
   IF (v_count>0) THEN
    SELECT ( SUM (trade+blocked+mortage+margin+abs(netting)+withdraw+deposit+receiving+senddeposit) ) INTO v_qtty_remain
    FROM semast se, sbsecurities sb WHERE se.codeid = sb.codeid
        AND sb.sectype <> '004' AND custid=v_custid
    GROUP BY custid;
   END IF;

   if(v_qtty_remain > 0) THEN
   v_Result:='Y';
   END IF;

    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 'N';
END;
/

