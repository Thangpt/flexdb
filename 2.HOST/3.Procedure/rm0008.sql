CREATE OR REPLACE PROCEDURE rm0008(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   EXECTYPE       IN       VARCHAR2,
   COREBANK       IN       VARCHAR2,
   CLEARDAY       IN       VARCHAR2,
   TRFBUYDATE     IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- BAO CAO SO LENH THEO NGAY
-- chaunh 16-06-2011 them truong icrate
-- ---------   ------  -------------------------------------------
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);
   --v_CurrDate       DATE;
   --CurrDate         VARCHAR2 (20);
   V_STREXECTYPE              VARCHAR2(20);
   V_COREBANK              VARCHAR2(20);
   V_CLEARDAY       VARCHAR2(10);
   V_TRFBUYDATE     varchar2(10);
BEGIN

    V_STROPTION := OPT;
    V_CLEARDAY := CLEARDAY;
    V_TRFBUYDATE := TRFBUYDATE;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := '%%';
   ELSE
      V_STRBRID := '%%';
   END IF;

    IF (COREBANK <> 'ALL')
  THEN
     V_COREBANK := COREBANK;

  ELSE
      V_COREBANK := '%%';
   END IF;

   IF (EXECTYPE <> 'ALL')
  THEN
     V_STREXECTYPE := EXECTYPE;

  ELSE
      V_STREXECTYPE := '%%';
   END IF;

 --select varvalue into CurrDate  from sysvar  where varname='CURRDATE';
 --v_CurrDate := to_date(CurrDate,'DD/MM/RRRR');


OPEN PV_REFCURSOR FOR
          SELECT  T.ACCTNO,T.CUSTODYCD,T.SYMBOL,T.ORDERID,T.contraorderid, T.TXDATE , T.EXECTYPE,
          T.fullname,T.idcode,T.iddate,T.idplace,T.address, T.tradeplace, T.clearcd,
              (CASE  WHEN T.EXECTYPE IN('NB','BC')  THEN   NVL(IO.MATCHQTTY,0)  END)MATCHQTTYB,
              (CASE  WHEN T.EXECTYPE IN('NS','SS','MS')  THEN   NVL(IO.MATCHQTTY,0) END)MATCHQTTYS,
              (CASE  WHEN T.EXECTYPE IN('NB','BC')  THEN   NVL(IO.MATCHPRICE,0)  END)MATCHPRICEB,
              (CASE  WHEN T.EXECTYPE IN('NS','SS','MS')  THEN   NVL(IO.MATCHPRICE,0) END)MATCHPRICES,
              NVL(IO.MATCHQTTY,0)* NVL(IO.MATCHPRICE,0) EXECAMT,
             case when t.execamt = 0 then 0
               /*when t.txdate = v_CurrDate then io.matchqtty * io.matchprice * t.deffeerate/100*/
                else  round( io.matchqtty * io.matchprice/t.execamt * t.feeacr,2)
             end feeamt_detail,

              case when t.execamt = 0 then 0 when (IO.MATCHPRICE*IO.MATCHQTTY) = 0 then 0
                   /*when t.txdate = v_CurrDate  and T.EXECTYPE IN('NS','SS','MS')

                        then round( (io.matchqtty * io.matchprice * t.deffeerate/100 )* 100 / (IO.MATCHPRICE*IO.MATCHQTTY),2)
*/
                        when  T.EXECTYPE IN('NS','SS','MS') then

                              round ((io.matchqtty * io.matchprice/t.execamt * t.feeacr)*100/ (IO.MATCHPRICE*IO.MATCHQTTY),2)

/*                              when t.txdate = v_CurrDate  and T.EXECTYPE IN('NB','BC')
                                   then  round ((io.matchqtty * io.matchprice * t.deffeerate/100 )* 100 / (IO.MATCHPRICE*IO.MATCHQTTY),2)*/
                                   when  T.EXECTYPE IN('NB','BC') then

                                         round((io.matchqtty * io.matchprice/t.execamt * t.feeacr)*100/ (IO.MATCHPRICE*IO.MATCHQTTY),2)
             end fee_bs , I.ICRATE,
               V_TRFBUYDATE ngay_tttm, COREBANK V_COREBANK--,V_N_dat_L V_N_dat_L ,V_CAREBY V_CAREBY , V_NGT_SHOW V_NGT_SHOW

         FROM
             (SELECT AF.ACCTNO,CF.CUSTODYCD,OD.TXDATE,OD.ORDERID, OD.contraorderid,CF.fullname,cf.idcode,cf.iddate,cf.idplace,cf.address,
                     OD.EXECTYPE,  SB.SYMBOL, ODTYPE.DEFFEERATE , OD.feeacr,  od.execamt, sb.tradeplace, OD.clearcd,

                     (CASE  WHEN OD.PRICETYPE IN ('ATO','ATC')AND OD.EXECTYPE IN('NB','BC')  THEN  OD.PRICETYPE
                           WHEN OD.EXECTYPE IN('NB','BC') THEN to_char( OD.QUOTEPRICE) END )QUOTEPRICEB,

                     (CASE  WHEN OD.PRICETYPE IN ('ATO','ATC')AND OD.EXECTYPE IN('NS','SS')  THEN  OD.PRICETYPE
                           WHEN OD.EXECTYPE IN('NS','SS','MS') THEN to_char( OD.QUOTEPRICE) END )QUOTEPRICES,

                     (CASE  WHEN OD.EXECTYPE IN('NB','BC')  THEN   OD.ORDERQTTY END)ORDERQTTYB,
                     (CASE  WHEN OD.EXECTYPE IN('NS','SS','MS')  THEN   OD.ORDERQTTY END)ORDERQTTYS,
                     OD.TLID, af.actype--, icc.icrate
                 FROM vw_odmast_all OD,
                      SBSECURITIES SB,
                      AFMAST AF,
                      CFMAST CF,
                      ODTYPE
                     --iccftypedef icc
              WHERE  OD.CODEID = SB.CODEID
                   AND od.DELTD <> 'Y'
                   AND od.EXECQTTY <> 0
                   AND OD.CIACCTNO = AF.ACCTNO
                   AND OD.EXECTYPE IN ('NB','NS','SS','BC','MS')
                   AND AF.CUSTID = CF.CUSTID
                   AND ODTYPE.ACTYPE = OD.ACTYPE
                   --AND af.actype = icc.actype
                   --and icc.deltd <> 'Y'
                   AND OD.TXDATE >= to_date(F_DATE, 'DD/MM/YYYY')
                   AND OD.TXDATE <= to_date(T_DATE , 'DD/MM/YYYY')
                   And OD.exectype like V_STREXECTYPE
                   AND AF.COREBANK like V_COREBANK
                   AND OD.CLEARDAY = V_CLEARDAY
                   AND CF.Custodycd not like '%080P%'
            ) T
            LEFT JOIN (SELECT trfbuydt, orgorderid from STSCHD WHERE duetype = 'SM'
                        UNION ALL
                       SELECT trfbuydt, orgorderid FROM STSCHDHIST WHERE duetype = 'SM' ) S ON S.orgorderid = T.orderid
           LEFT JOIN (SELECT icrate, actype FROM iccftypedef WHERE deltd <> 'Y' and eventcode='CFSELLVAT') I ON T.actype = I.actype
            INNER JOIN (SELECT * FROM vw_iod_all WHERE DELTD <> 'Y' ) IO  ON IO.ORGORDERID = T.ORDERID
WHERE  GETDUEDATE(T.txdate, T.clearcd, T.tradeplace,to_number(V_TRFBUYDATE)) = nvl(trfbuydt,T.txdate)
ORDER BY T.TXDATE, T.Symbol, T.ACCTNO ;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

