CREATE OR REPLACE PROCEDURE RM0054
   (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_TXTYPE      IN       VARCHAR2,
   PV_FUNDTYPE    IN       VARCHAR2,
   PV_BANKCODE    IN       VARCHAR2
   )
   IS
   v_BANKCODE VARCHAR2(500);
   v_TXTYPE VARCHAR2(20);

   V_STROPTION   VARCHAR2(10);
   V_STRBRID     VARCHAR2(40);
   V_INBRID      VARCHAR2(4);

BEGIN

    V_STROPTION := upper(OPT);
    V_INBRID := BRID;

    IF (V_STROPTION = 'A')
    THEN
        V_STRBRID := '%';
    ELSE if (V_STROPTION = 'B') then
            select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    END IF;

    IF PV_TXTYPE='ALL' THEN
         v_TXTYPE:='%%';
    ELSE
       v_TXTYPE:=PV_TXTYPE;
    END IF;

    IF PV_BANKCODE='ALL' THEN
         v_BANKCODE:='%%';
    ELSE
       v_BANKCODE:=PV_BANKCODE;
    END IF;

     ---GET REPORT DATA:

IF PV_FUNDTYPE = 'BVS' AND v_TXTYPE = 'DEPO' THEN
      --- Qui BVS + NOP
      OPEN PV_REFCURSOR
      FOR
      SELECT  CI.TLTXCD,PV_FUNDTYPE FUND,  CI.BUSDATE, CI.TXNUM, CF.FULLNAME, CI.CUSTODYCD, CI.ACCTNO, CI.NAMT, CI.TXDESC, CI.TXTYPE
      FROM    VW_CITRAN_GEN CI, CFMAST CF
      WHERE   CI.CUSTODYCD = CF.CUSTODYCD
      AND     FIELD = 'BALANCE'
      AND     TLTXCD IN ('1140')
      and (ci.brid like V_STRBRID or INSTR(V_STRBRID,ci.brid) <> 0)
      AND     CI.BUSDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND CI.BUSDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
      ------- AND   CI.brid LIKE V_STRBRID -- TheNN added, 26-Mar-2012
      order by ci.busdate,ci.autoid
      ;

ELSIF PV_FUNDTYPE = 'BVS' AND v_TXTYPE = 'WITH' THEN
      --- Qui BVS + RUT
      OPEN PV_REFCURSOR
      FOR
      SELECT  CI.TLTXCD, PV_FUNDTYPE FUND,  CI.BUSDATE, CI.TXNUM, CF.FULLNAME, CI.CUSTODYCD, CI.ACCTNO, CI.NAMT, CI.TXDESC, CI.TXTYPE
      FROM    VW_CITRAN_GEN CI, CFMAST CF
      WHERE   CI.CUSTODYCD = CF.CUSTODYCD
      AND     FIELD = 'BALANCE'
      AND     TLTXCD IN ('1100','1184')
      and (ci.brid like V_STRBRID or INSTR(V_STRBRID,ci.brid) <> 0)
      AND     CI.BUSDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND CI.BUSDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
      ----- AND   CI.brid LIKE V_STRBRID -- TheNN added, 26-Mar-2012
      order by  ci.busdate,ci.autoid
      ;

ELSIF PV_FUNDTYPE = 'BVS' AND PV_TXTYPE = 'ALL' THEN
      ---Qui BVS + NOP & RUT
      OPEN PV_REFCURSOR
      FOR
      SELECT  CI.TLTXCD, PV_FUNDTYPE FUND,  CI.BUSDATE, CI.TXNUM, CF.FULLNAME, CI.CUSTODYCD, CI.ACCTNO, CI.NAMT, CI.TXDESC, CI.TXTYPE
      FROM    VW_CITRAN_GEN CI, CFMAST CF
      WHERE   CI.CUSTODYCD = CF.CUSTODYCD
      AND     FIELD = 'BALANCE'
      AND     TLTXCD IN ('1140','1100','1184')
      and (ci.brid like V_STRBRID or INSTR(V_STRBRID,ci.brid) <> 0)
      AND     CI.BUSDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND CI.BUSDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
      ------ AND   CI.brid LIKE V_STRBRID -- TheNN added, 26-Mar-2012
      order by  ci.busdate,ci.autoid
      ;

ELSIF PV_FUNDTYPE = 'NHG' AND v_TXTYPE = 'DEPO' THEN
  --- --- ---Qui Ngan hang + NOP
      OPEN PV_REFCURSOR
      FOR
      /*SELECT  CI.TLTXCD, PV_FUNDTYPE FUND, LG.CVALUE BANKCODE, BANK.FULLNAME BANKNAME,  CI.BUSDATE, CI.TXNUM, CF.FULLNAME, CI.CUSTODYCD, CI.ACCTNO, CI.NAMT, CI.TXDESC, CI.TXTYPE
      FROM    VW_CITRAN_GEN CI, CFMAST CF, BANKNOSTRO BANK,
      (
      SELECT * FROM TLLOGFLD
      UNION ALL
      SELECT * FROM TLLOGFLDALL
      ) LG
      WHERE   CI.CUSTODYCD = CF.CUSTODYCD
      AND     FIELD = 'BALANCE'
      AND     CI.TXDATE = LG.TXDATE
      AND     CI.TXNUM = LG.TXNUM
      AND     TLTXCD IN ('1131')
      AND     LG.FLDCD = '02'
      AND     LG.CVALUE = BANK.SHORTNAME
      AND     LG.CVALUE LIKE v_BANKCODE
      AND     CI.BUSDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND CI.BUSDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
      AND   CI.brid LIKE V_STRBRID -- TheNN added, 26-Mar-2012
      */
      select tl.TLTXCD, PV_FUNDTYPE FUND,
            fld.CVALUE BANKCODE, decode(v_BANKCODE,'%%','ALL',BANK.bankacctno) bankacctno,BANK.FULLNAME BANKNAME,  tl.BUSDATE, tl.TXNUM, CF.FULLNAME,
            CF.CUSTODYCD, AF.ACCTNO, tl.msgamt NAMT, tl.TXDESC, 'C' TXTYPE
        From vw_tllog_all tl, vw_tllogfld_all fld,
            afmast af, CFMAST CF, BANKNOSTRO BANK
        where tl.TLTXCD = '1131'
            and tl.msgacct = af.acctno
            and af.custid = cf.custid
            and fld.fldcd = '02'
            and tl.txnum = fld.txnum
            and tl.txdate = fld.txdate
            and fld.CVALUE = BANK.SHORTNAME
            and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
            AND fld.CVALUE LIKE v_BANKCODE
           ------ AND tl.brid LIKE V_STRBRID
            AND tl.BUSDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND tl.BUSDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
        order by  tl.busdate,tl.autoid
      ;

ELSIF PV_FUNDTYPE = 'NHG' AND v_TXTYPE = 'WITH' THEN
      --- --- --- Qui Ngan hang + RUT
      OPEN PV_REFCURSOR
      FOR
      /*
      SELECT  CI.TLTXCD, PV_FUNDTYPE FUND, LG.CVALUE BANKCODE, BANK.FULLNAME BANKNAME,  CI.BUSDATE, CI.TXNUM, CF.FULLNAME, CI.CUSTODYCD, CI.ACCTNO, CI.NAMT, CI.TXDESC, CI.TXTYPE
      FROM    VW_CITRAN_GEN CI, CFMAST CF, BANKNOSTRO BANK,
      (
      SELECT * FROM TLLOGFLD
      UNION ALL
      SELECT * FROM TLLOGFLDALL
      ) LG
      WHERE   CI.CUSTODYCD = CF.CUSTODYCD
      AND     FIELD = 'BALANCE'
      AND     TLTXCD IN ('1132','1136')
      AND     CI.TXDATE = LG.TXDATE
      AND     CI.TXNUM = LG.TXNUM
      AND     LG.FLDCD = '02'
      AND     LG.CVALUE = BANK.SHORTNAME
      AND     LG.CVALUE LIKE v_BANKCODE
      AND     CI.BUSDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND CI.BUSDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
      AND   CI.brid LIKE V_STRBRID -- TheNN added, 26-Mar-2012
      */
      select tl.TLTXCD, PV_FUNDTYPE FUND,
            fld.CVALUE BANKCODE, decode(v_BANKCODE,'%%','ALL',BANK.bankacctno) bankacctno, BANK.FULLNAME BANKNAME,  tl.BUSDATE, tl.TXNUM, CF.FULLNAME,
            CF.CUSTODYCD, AF.ACCTNO, tl.msgamt NAMT, tl.TXDESC, 'D' TXTYPE
        From vw_tllog_all tl, vw_tllogfld_all fld,
            afmast af, CFMAST CF, BANKNOSTRO BANK
        where tl.TLTXCD IN ('1132','1136','1189','1184')
            and tl.msgacct = af.acctno
            and af.custid = cf.custid
            and fld.fldcd = '02'
            and tl.txnum = fld.txnum
            and tl.txdate = fld.txdate
            and fld.CVALUE = BANK.SHORTNAME
            AND fld.CVALUE LIKE v_BANKCODE
            and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
            ------AND tl.brid LIKE V_STRBRID
            AND tl.BUSDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND tl.BUSDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
        order by  tl.busdate,tl.autoid
      ;

ELSIF PV_FUNDTYPE = 'NHG' AND PV_TXTYPE = 'ALL' THEN
      --- --- --- Qui Ngan hang + NOP & RUT
      OPEN PV_REFCURSOR
      FOR
      /*
      SELECT  CI.TLTXCD, PV_FUNDTYPE FUND, LG.CVALUE BANKCODE, BANK.FULLNAME BANKNAME,  CI.BUSDATE, CI.TXNUM, CF.FULLNAME, CI.CUSTODYCD, CI.ACCTNO, CI.NAMT, CI.TXDESC, CI.TXTYPE
      FROM    VW_CITRAN_GEN CI, CFMAST CF, BANKNOSTRO BANK,
      (
      SELECT * FROM TLLOGFLD
      UNION ALL
      SELECT * FROM TLLOGFLDALL
      ) LG
      WHERE   CI.CUSTODYCD = CF.CUSTODYCD
      AND     FIELD = 'BALANCE'
      AND     TLTXCD IN ('1131','1132')
      AND     CI.TXDATE = LG.TXDATE
      AND     CI.TXNUM = LG.TXNUM
      AND     LG.FLDCD = '02'
      AND     LG.CVALUE = BANK.SHORTNAME
      AND     LG.CVALUE LIKE v_BANKCODE
      AND     CI.BUSDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND CI.BUSDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
      AND   CI.brid LIKE V_STRBRID -- TheNN added, 26-Mar-2012
      */
      select tl.TLTXCD, PV_FUNDTYPE FUND,
            fld.CVALUE BANKCODE,  decode(v_BANKCODE,'%%','ALL',BANK.bankacctno) bankacctno,BANK.FULLNAME BANKNAME,  tl.BUSDATE, tl.TXNUM, CF.FULLNAME,
            CF.CUSTODYCD, AF.ACCTNO, tl.msgamt NAMT, tl.TXDESC,
            (case when tl.TLTXCD = '1131' then 'C' else 'D' end) TXTYPE
        From vw_tllog_all tl, vw_tllogfld_all fld,
            afmast af, CFMAST CF, BANKNOSTRO BANK
        where tl.TLTXCD IN ('1131','1132','1136','1189','1184')
            and tl.msgacct = af.acctno
            and af.custid = cf.custid
            and fld.fldcd = '02'
            and tl.txnum = fld.txnum
            and tl.txdate = fld.txdate
            and fld.CVALUE = BANK.SHORTNAME
            AND fld.CVALUE LIKE v_BANKCODE
            and (tl.brid like V_STRBRID or INSTR(V_STRBRID,tl.brid) <> 0)
            ------- AND tl.brid LIKE V_STRBRID
            AND tl.BUSDATE <= TO_DATE (T_DATE ,'DD/MM/YYYY') AND tl.BUSDATE >= TO_DATE (F_DATE ,'DD/MM/YYYY')
        order by  tl.busdate,tl.autoid
      ;

END IF;

EXCEPTION
    WHEN OTHERS THEN
        RETURN ;
END; -- Procedure
/

