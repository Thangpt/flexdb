CREATE OR REPLACE PROCEDURE od0006 (
   pv_refcursor   IN OUT   pkg_report.ref_cursor,
   opt            IN       VARCHAR2,
   brid           IN       VARCHAR2,
   f_date         IN       VARCHAR2,
   t_date         IN       VARCHAR2

)
IS
--
-- Purpose: Briefly explain the functionality of the procedure
--

-- MODIFICATION HISTORY
-- Person      Date    Comments
-- NAMNT   21-Nov-06  Created
-- ---------   ------  -------------------------------------------
   v_stroption     VARCHAR2 (5);          -- A: All; B: Branch; S: Sub-branch
   v_strbrid       VARCHAR2 (4);                 -- Used when v_numOption > 0

-- Declare program variables as shown above
BEGIN
   v_stroption := opt;

   IF (v_stroption <> 'A') AND (brid <> 'ALL')
   THEN
      v_strbrid := brid;
   ELSE
      v_strbrid := '%%';
   END IF;

OPEN pv_refcursor
  FOR
SELECT OD.ORDERID,IO.CUSTODYCD,
IO.REFCUSTCD,SB.SYMBOL,IO.MATCHPRICE,IO.MATCHQTTY,TLPR1.TLNAME MAKER ,TLPR2.TLNAME CHECKER ,io.EXORDERID EXORDERID
,CF.CUSTODYCD
FROM
(SELECT * FROM ODMAST WHERE DELTD<>'Y' UNION ALL SELECT * FROM ODMASTHIST WHERE DELTD<>'Y')OD,
(SELECT * FROM IOD WHERE DELTD<>'Y' UNION ALL SELECT * FROM IODHIST WHERE DELTD<>'Y'  )IO,
(SELECT * FROM TLLOG WHERE DELTD<>'Y' AND TLTXCD ='8809' UNION ALL SELECT * FROM TLLOGALL WHERE DELTD<>'Y' AND TLTXCD ='8809'   )TL,
SBSECURITIES SB,TLPROFILES TLPR1,TLPROFILES TLPR2,AFMAST AF ,CFMAST CF
WHERE SB.CODEID =OD.CODEID
AND TLPR1.TLID(+) = TL.TLID
AND TLPR2.TLID(+)= TL.OFFID
AND OD.TXDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY')
AND OD.TXDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
AND SUBSTR(OD.ORDERID,1,4) LIKE V_STRBRID
AND OD.ORDERID = IO.ORGORDERID
AND IO.TXDATE = TL.TXDATE
AND IO.TXNUM = TL.TXNUM
AND OD.AFACCTNO= AF.ACCTNO
AND AF.CUSTID= CF.CUSTID
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- Procedure
/

