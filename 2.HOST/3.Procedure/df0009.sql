CREATE OR REPLACE PROCEDURE df0009 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   AMOUNT         IN       VARCHAR2
   )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO TAI KHOAN TIEN TONG HOP CUA NGUOI DAU TU
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DUNGNH   17-MAY-10  CREATED
-- ---------   ------  -------------------------------------------

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_STRCIACCTNO  VARCHAR2 (20);


   V_FROMDATE     DATE;
   V_TODATE       DATE;
   V_NAMOUNT      NUMBER;


BEGIN
   V_STROPTION := OPT;

   IF V_STROPTION = 'A' THEN     -- TOAN HE THONG
      V_STRBRID := '%';
   ELSIF V_STROPTION = 'B' THEN
      V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
   ELSE
      V_STRBRID := BRID;
   END IF;


   V_FROMDATE := to_date(F_DATE,'DD/MM/YYYY');
   V_TODATE := to_date(T_DATE,'DD/MM/YYYY');

   V_NAMOUNT := TO_NUMBER(AMOUNT);

OPEN PV_REFCURSOR
FOR
select ci.txdate, ci.txnum, cfmast.custodycd, cfmast.fullname, ci.txdesc, ci.namt
    from vw_tllog_citran_all ci, apptx tx, afmast, cfmast
        where ci.txcd = tx.txcd
            and tx.field = 'BALANCE'
            AND tx.txtype in ('C','D')
            and tx.apptype = 'CI'
            and ci.acctno = afmast.acctno
            and afmast.custid = cfmast.custid
            and ci.txdate >= V_FROMDATE
            and ci.txdate <= V_TODATE
            and ci.namt >= AMOUNT
;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

