CREATE OR REPLACE PROCEDURE od0049 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTODYCD      IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2,
   PV_CAREBY      IN       VARCHAR2,
   PV_VIA         IN       VARCHAR2,
   PV_TLID        in       varchar2
   )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDUREa
-- BAO CAO GIAO DICH CUA KHACH HANG THEO TUNG MOI GIOI DOC LAP
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DUNGNH   04-sep-09  CREATED
-- QUYETKD  04-JUL-12  MODIFY
-- ElseIf Trim(mv_arrObjFields(v_intIndex).DefaultValue) = "<$TELLERID>" Then
--                                        v_mskData.Text = Me.TellerId
-- ---------   ------  -------------------------------------------
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

  V_STRACCTNO      VARCHAR2 (10);

   V_STRREMISER     VARCHAR2 (10);
   V_NUMTRADE       NUMBER (20, 2);
   V_STRCAREBY      VARCHAR2 (4);
   V_STRCAREBYNAME  VARCHAR2 (50);
   V_CUSTODYCD      VARCHAR2 (20);
   V_CAREBY  VARCHAR2 (20);
   V_VIA  VARCHAR2 (20);

   v_Symbol varchar2(20);

   v_TLID varchar2(4);
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;


    v_tlid := PV_TLID;
   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%';
   END IF;
   --

IF (CUSTODYCD <> 'ALL')
   THEN
      V_CUSTODYCD := CUSTODYCD;
   ELSE
      V_CUSTODYCD := '%';
   END IF;

   IF (PV_AFACCTNO <> 'ALL')
   THEN
      V_STRACCTNO := PV_AFACCTNO;
   ELSE
      V_STRACCTNO := '%';
   END IF;

   IF (upper(PV_SYMBOL) <> 'ALL' )
   THEN
      v_Symbol := upper(REPLACE (PV_SYMBOL,' ','_'));
   ELSE
      v_Symbol := '%%';
   END IF;




   IF (PV_CAREBY <> 'ALL')
   THEN
      V_CAREBY := PV_CAREBY;
   ELSE
      V_CAREBY := '%';
   END IF;


      IF (PV_VIA <> 'ALL')
   THEN
      V_VIA := PV_VIA;
   ELSE
      V_VIA := '%';
   END IF;


OPEN PV_REFCURSOR
       FOR
SELECT a.txdate busdate,  A.ACCTNO ACCTNO ,A.CUSTODYCD CUSTODYCD ,to_char(A.TXDATE,'DD/MM/RRRR') TXDATE,A.ORDERID,A.contraorderid,A.EXECTYPE, A.PUTTYPE,
    A.SYMBOL,A.MATCHTYPE,A.EXECTYPENAME,
     NVL(A.matchprice,0)  MATCHPRICENBS,
     NVL(A.matchqtty,0) matchqttyBS,
     NVL(A.quoteprice,0)   quotepriceNBS,
     NVL(A.orderqtty,0) orderqttyNBS,
    (CASE WHEN NVL(cancelqtty,0) <> 0 THEN NVL(A.quoteprice,0) ELSE 0 END) quotepriceCBS,
    NVL(cancelqtty,0) orderqttyCBS,
    quoteprice_adjust quotepriceABS,
    orderqtty_adjust orderqttyABS,
    A.VIA,
    V_CUSTODYCD V_CUSTODYCD ,
    V_STRACCTNO V_STRACCTNO,
    A.clearday
FROM
( SELECT  T.ACCTNO ACCTNO ,T.CUSTODYCD CUSTODYCD ,T.TXDATE,T.ORDERID,T.contraorderid,T.EXECTYPE, T.PUTTYPE, T.SYMBOL,
          T.quoteprice , T.orderqtty ,nvl(io.matchprice,0) matchprice,nvl(io.matchqtty,0) matchqtty ,T.MATCHTYPE ,T.EXECTYPENAME,
          T.clearday, t.cancelqtty, nvl(odab.quoteprice,0) quoteprice_adjust, nvl(odab.orderqtty,0) orderqtty_adjust, a.cdcontent Via
         FROM allcode a,
             (SELECT AF.ACCTNO,CF.CUSTODYCD,OD.TXDATE,OD.ORDERID, OD.contraorderid,
                     OD.EXECTYPE, A1.CDCONTENT PUTTYPE, SB.SYMBOL ,od.quoteprice , od.orderqtty,
                     A2.CDCONTENT  MATCHTYPE, A3.CDCONTENT EXECTYPENAME,
                    --to_char(getduedate(od.txdate, od.clearcd, '000', od.clearday),'DD/MM/RRRR') clearday,
                     OD.TXDATE clearday,
                     OD.cancelqtty, OD.VIA
               FROM  SBSECURITIES SB, AFMAST AF, CFMAST CF, ALLCODE A1,
                      ALLCODE A2, ALLCODE A3, vw_odmast_all OD
               WHERE  OD.CODEID = SB.CODEID
                     AND OD.CIACCTNO = AF.ACCTNO
                     AND od.deltd <> 'Y'
                     AND OD.EXECTYPE IN ('NB','NS','SS','BC','MS')
                     AND AF.CUSTID = CF.CUSTID
                     AND A1.CDNAME = 'PUTTYPE' AND A1.CDVAL = decode(od.puttype,'N','N','E','E','O','O','N')/*OD.PUTTYPE*/ AND A1.CDTYPE = 'OD'
                     AND A2.CDNAME = 'MATCHTYPE' AND A2.CDVAL = OD.MATCHTYPE AND A2.CDTYPE = 'OD'
                     AND A3.CDNAME = 'EXECTYPE' AND A3.CDVAL = OD.EXECTYPE AND A3.CDTYPE = 'OD'
                     AND (substr(CF.CUSTID,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(CF.CUSTID,1,4))<> 0)
                     AND CF.CUSTODYCD like V_CUSTODYCD
                     AND AF.ACCTNO LIKE V_STRACCTNO
                     AND sb.symbol like v_Symbol
                     --AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
                     AND OD.TXDATE >= to_date(F_DATE , 'DD/MM/YYYY')
                     AND OD.TXDATE <= to_date(T_DATE , 'DD/MM/YYYY')
                     AND AF.careby like V_CAREBY
                     AND OD.VIA like V_VIA
            ) T LEFT JOIN
                (SELECT * FROM IOD WHERE DELTD <> 'Y'
                    AND TXDATE >= to_date(F_DATE , 'DD/MM/YYYY')
                    AND TXDATE <= to_date(T_DATE , 'DD/MM/YYYY')
                    AND CUSTODYCD like V_CUSTODYCD
                 UNION ALL
                 SELECT * FROM IODHIST  WHERE DELTD <> 'Y'
                    AND TXDATE >= to_date(F_DATE , 'DD/MM/YYYY')
                    AND TXDATE <= to_date(T_DATE , 'DD/MM/YYYY')
                    AND CUSTODYCD like V_CUSTODYCD
                 ) IO
            ON IO.ORGORDERID = T.ORDERID
            left join
            ( select * from vw_odmast_all where EXECTYPE IN ('AB','AS')
                AND TXDATE >= to_date(F_DATE , 'DD/MM/YYYY')
                AND TXDATE <= to_date(T_DATE , 'DD/MM/YYYY')
                AND afacctno like V_STRACCTNO and deltd <> 'Y'
                AND VIA like V_VIA
            ) odab
            on T.orderid = odab.reforderid
    where a.cdname = 'VIA' and a.cdtype = 'OD' and a.cdval = T.VIA
            /*UNION ALL
           ( SELECT AF.ACCTNO,CF.CUSTODYCD,OD.TXDATE,OD.ORDERID, OD.contraorderid,OD.EXECTYPE, A1.CDCONTENT PUTTYPE, SB.SYMBOL,
               od.quoteprice, od.orderqtty, NULL matchprice, NULL matchqtty,A2.CDCONTENT MATCHTYPE,A3.CDCONTENT EXECTYPENAME,
               to_char(nvl(sts.cleardate,'')) clearday, 0 cancelqtty
               FROM SBSECURITIES SB,
                      AFMAST AF,
                      CFMAST CF,
                      ALLCODE A1,
                      ALLCODE A2,
                      ALLCODE A3,
                      (SELECT * FROM ODMAST   WHERE DELTD <> 'Y'
                        UNION ALL
                      SELECT * FROM ODMASTHIST   WHERE DELTD<>'Y') OD
                      left join vw_stschd_all sts
                on od.orderid = sts.orgorderid AND sts.duetype in ('RM', 'RS')
              WHERE  OD.CODEID = SB.CODEID
                   AND OD.CIACCTNO = AF.ACCTNO
                   AND AF.ACCTNO LIKE V_STRACCTNO
                   AND OD.EXECTYPE IN ('AB','AS')
                   AND AF.CUSTID = CF.CUSTID
                   AND exists (SELECT vw.value CIACCTNO FROM vw_custodycd_subaccount vw
                    WHERE vw.filtercd like V_CUSTODYCD
                        and OD.CIACCTNO = vw.value)
                   AND OD.TXDATE >= to_date(F_DATE , 'DD/MM/YYYY')
                   AND OD.TXDATE <= to_date(T_DATE , 'DD/MM/YYYY')
                   AND A3.CDNAME = 'EXECTYPE' AND A3.CDVAL = OD.EXECTYPE AND A3.CDTYPE = 'OD'
                   AND A2.CDNAME = 'MATCHTYPE' AND A2.CDVAL = OD.MATCHTYPE AND A2.CDTYPE = 'OD'
                   AND A1.CDNAME = 'PUTTYPE' AND A1.CDVAL = OD.PUTTYPE AND A1.CDTYPE = 'OD'
                   and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = v_TLID)   -- check careby cf.careby = gu.grpid

        )*/
    ) A
ORDER BY A.CUSTODYCD, A.TXDATE;



EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

