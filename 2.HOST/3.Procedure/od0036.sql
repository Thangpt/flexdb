CREATE OR REPLACE PROCEDURE od0036 (
   PV_REFCURSOR             IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                      IN       VARCHAR2,
   BRID                     IN       VARCHAR2,
   P_DATE                   IN       VARCHAR2,
   PV_CUSTODYCD             IN       VARCHAR2,
   PV_AFACCTNO              IN       VARCHAR2,
   TLID           IN       VARCHAR2
----   p_SIGNTYPE               IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- B?O C?O GIAO D?CH CH?NG KHO?N THEO S? T?I KHO?N KI? B?NG K?HOA H?NG M? GI?I PH?T SINH TRONG TH?NG
-- PERSON   DATE  COMMENTS
-- QUOCTA  29-12-2011  CREATED
-- GianhVG 03/03/2012 _modify
-- Them phan chia theo nguon tien quan ly cua khach hang
-- ---------   ------  -------------------------------------------
  V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);            -- USED WHEN V_NUMOPTION > 0

  V_STRACCTNO      VARCHAR2 (10);

   V_STRREMISER     VARCHAR2 (10);
   V_NUMTRADE       NUMBER (20, 2);
   V_STRCAREBY      VARCHAR2 (4);
   V_STRCAREBYNAME  VARCHAR2 (50);
   V_CUSTODYCD      VARCHAR2 (20);
   V_CURRDATE   DATE;
   V_VAT        number;
   v_TLID varchar2(4);
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

    SELECT VARVALUE INTO V_CURRDATE FROM SYSVAR WHERE VARNAME = 'CURRDATE';
    select varvalue into V_VAT from sysvar where varname = 'ADVSELLDUTY' and grname = 'SYSTEM';
   --

IF (PV_CUSTODYCD <> 'ALL')
   THEN
      V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
      V_CUSTODYCD := '%';
   END IF;

   IF (PV_AFACCTNO <> 'ALL')
   THEN
      V_STRACCTNO := PV_AFACCTNO;
   ELSE
      V_STRACCTNO := '%';
   END IF;

   v_TLID := TLID;

    IF V_CURRDATE <> P_DATE THEN
        OPEN PV_REFCURSOR FOR
        SELECT  T.ACCTNO ACCTNO ,T.CUSTODYCD CUSTODYCD ,T.TXDATE,T.ORDERID,T.contraorderid,T.EXECTYPE, T.PUTTYPE, T.SYMBOL,
                  T.quoteprice , T.orderqtty ,T.MATCHTYPE ,T.EXECTYPENAME, T.execqtty, T.taxsellamt, T.feeacr, T.TXTIME, T.execamt,
                  T.clearday, t.cancelqtty,  getduedate (T.TXDATE ,'B','001',T.clearday ) SETT_DATE, V_CUSTODYCD V_CUSTODYCD , V_STRACCTNO V_STRACCTNO,
                  T.CDCONTENT, T.FULLNAME, T.ADDRESS, T.edstatus
                 FROM
                     (SELECT AF.ACCTNO,CF.CUSTODYCD,OD.TXDATE,OD.ORDERID, OD.contraorderid,
                             OD.EXECTYPE, A1.CDCONTENT PUTTYPE, SB.SYMBOL ,od.quoteprice , od.orderqtty,
                             A2.CDCONTENT  MATCHTYPE, A3.CDCONTENT EXECTYPENAME, OD.clearday, A4.CDCONTENT,
                            OD.cancelqtty, OD.execqtty, OD.taxsellamt, OD.feeacr, OD.TXTIME, OD.execamt, CF.FULLNAME, CF.ADDRESS,
                            OD.edstatus
                       FROM  SBSECURITIES SB, AFMAST AF, CFMAST CF, ALLCODE A1,
                              ALLCODE A2, ALLCODE A3, ALLCODE A4, vw_odmast_all OD
                      WHERE  OD.CODEID = SB.CODEID
                           AND OD.CIACCTNO = AF.ACCTNO
                           AND AF.ACCTNO LIKE V_STRACCTNO
                           and od.deltd <> 'Y'
                           AND OD.EXECTYPE IN ('NB','NS','SS','BC','MS')
                           AND AF.CUSTID = CF.CUSTID
                           AND A1.CDNAME = 'PUTTYPE' AND A1.CDVAL = OD.PUTTYPE AND A1.CDTYPE = 'OD'
                           AND A2.CDNAME = 'MATCHTYPE' AND A2.CDVAL = OD.MATCHTYPE AND A2.CDTYPE = 'OD'
                           AND A3.CDNAME = 'EXECTYPE' AND A3.CDVAL = OD.EXECTYPE AND A3.CDTYPE = 'OD'
                           AND A4.CDNAME = 'TRADEPLACE' AND A4.CDVAL = SB.TRADEPLACE AND A4.CDTYPE = 'OD'
                            AND exists (SELECT vw.value CIACCTNO FROM vw_custodycd_subaccount vw
                            WHERE vw.filtercd like V_CUSTODYCD
                                and OD.CIACCTNO = vw.value)
                           AND OD.TXDATE = to_date(P_DATE , 'DD/MM/YYYY')
                           and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = v_TLID)   -- check careby cf.careby = gu.grpid
                           AND (substr(af.acctno,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(af.acctno,1,4))<> 0)
                    ) T
                 ORDER BY T.SYMBOL;
    ELSE
        OPEN PV_REFCURSOR FOR
        SELECT  T.ACCTNO ACCTNO ,T.CUSTODYCD CUSTODYCD ,T.TXDATE,T.ORDERID,T.contraorderid,T.EXECTYPE, T.PUTTYPE, T.SYMBOL,
                  T.quoteprice , T.orderqtty ,T.MATCHTYPE ,T.EXECTYPENAME, T.execqtty, T.taxsellamt, T.feeacr, T.TXTIME, T.execamt,
                  T.clearday, t.cancelqtty, getduedate (T.TXDATE ,'B','001',T.clearday ) SETT_DATE, V_CUSTODYCD V_CUSTODYCD , V_STRACCTNO V_STRACCTNO,
                  T.CDCONTENT, T.FULLNAME, T.ADDRESS, T.edstatus
                 FROM
                     (SELECT AF.ACCTNO,CF.CUSTODYCD,OD.TXDATE,OD.ORDERID, OD.contraorderid,
                             OD.EXECTYPE, A1.CDCONTENT PUTTYPE, SB.SYMBOL ,od.quoteprice , od.orderqtty,
                             A2.CDCONTENT  MATCHTYPE, A3.CDCONTENT EXECTYPENAME, OD.clearday, A4.CDCONTENT,
                            OD.cancelqtty, OD.execqtty, OD.TXTIME, OD.execamt, CF.FULLNAME, CF.ADDRESS,
                            (CASE WHEN aft.VAT = 'Y' THEN V_VAT/100 * OD.matchamt else 0 end) taxsellamt,
                            NVL(ROUND(OD.matchamt * odt.deffeerate/100), 0) feeacr, OD.edstatus
                       FROM  SBSECURITIES SB, AFMAST AF, CFMAST CF, ALLCODE A1,
                              ALLCODE A2, ALLCODE A3, ALLCODE A4, aftype aft, vw_odmast_all OD
                              LEFT JOIN ODTYPE ODT ON ODT.ACTYPE = OD.actype
                      WHERE  OD.CODEID = SB.CODEID
                           AND OD.CIACCTNO = AF.ACCTNO
                           AND AF.ACCTNO LIKE V_STRACCTNO
                           and od.deltd <> 'Y'
                           and af.actype = aft.actype
                           AND OD.EXECTYPE IN ('NB','NS','SS','BC','MS')
                           AND AF.CUSTID = CF.CUSTID
                           AND A1.CDNAME = 'PUTTYPE' AND A1.CDVAL = OD.PUTTYPE AND A1.CDTYPE = 'OD'
                           AND A2.CDNAME = 'MATCHTYPE' AND A2.CDVAL = OD.MATCHTYPE AND A2.CDTYPE = 'OD'
                           AND A3.CDNAME = 'EXECTYPE' AND A3.CDVAL = OD.EXECTYPE AND A3.CDTYPE = 'OD'
                           AND A4.CDNAME = 'TRADEPLACE' AND A4.CDVAL = SB.TRADEPLACE AND A4.CDTYPE = 'OD'
                            AND exists (SELECT vw.value CIACCTNO FROM vw_custodycd_subaccount vw
                            WHERE vw.filtercd like V_CUSTODYCD
                                and OD.CIACCTNO = vw.value)
                           AND OD.TXDATE = to_date(P_DATE , 'DD/MM/YYYY')
                           and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = v_TLID)   -- check careby cf.careby = gu.grpid
                           AND (substr(af.acctno,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(af.acctno,1,4))<> 0)
                    ) T
                 ORDER BY T.SYMBOL;
    END IF;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

