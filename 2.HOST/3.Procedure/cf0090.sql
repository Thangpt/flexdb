CREATE OR REPLACE PROCEDURE cf0090 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   CUSTODYCD      IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2
       )
IS

-- RP NAME : Bao cao cong viec dong tai khoan dang active
-- PERSON : PhucPP
-- DATE : 15/03/2012
-- COMMENTS :    CREATE NEW
-- ---------   ------  -------------------------------------------
   V_SYMBOL  VARCHAR2 (15);
   v_CustodyCD varchar2(20);
   v_AFAcctno varchar2(20);


BEGIN
-- GET REPORT'S PARAMETERS
   v_CustodyCD:= upper(replace(CUSTODYCD,'.',''));
v_AFAcctno:= upper(replace(PV_AFACCTNO,'.',''));

if v_AFAcctno = 'ALL' or v_AFAcctno is null then
    v_AFAcctno := '%';
else
    v_AFAcctno := v_AFAcctno;
end if;


-- GET REPORT'S DATA
 OPEN PV_REFCURSOR
 FOR
       SELECT CF.CUSTODYCD, CF.PHONE CUSTPHONE, CF.ADDRESS, '' TLFULLNAME,'' TXNUM, '' TXDATE, AF.ACCTNO AFACCTNO_R
       , NVL(CI.CRINTACR,0) CRINTACR_R, NVL(CI.ODINTACR,0) ODINTACR_R , NVL(CI.ODAMT,0) ODAMT_R,
       0 ADVBALANCE_R,
       NVL(SE.BLOCKED-sedtl.qtty,0) BLOCKED_R, NVL(DF.DF_QTTY,0) DF_QTTY_R, NVL(CI.BALANCE,0) BALANCE_R,
       FN_IS_FEETYPE(AF.ACCTNO) GROUPFEETYPE_R,
       AF.MRCRLIMITMAX MRCRLIMITMAX_R, AF.MRCRLIMIT MRCRLIMIT_R,  NVL(usl.acclimit,0) AS T0AMT_R,  NVL(CA_QTTY,0) CA_QTTY_R,
       (CASE WHEN mrtype.mrtype='N' THEN 'N' ELSE 'Y' END ) GROUPLEADER_R,
       0 CIDATEFEEACR_R,
       0 DATEFEEACR_R,
       nvl(sts.depoamt,0) DEPOAMT_R, NVL(SE.TRADE_QTTY,0) TRADE_QTTY_R, NVL(st.RS_QTTY+st.SS_QTTY,0) WAIT_QTTY_R,
       FN_IS_CAWAIT(AF.ACCTNO) ISCAWAIT_R,
       CI.EMKAMT EMKAMT_R, NVL(sestand.qtty,0) STANDING_R, '' FEETYPE_R, '' DESC_R, CF.FULLNAME NAME_R, CF.IDCODE IDCODE_R, nvl(sedtl.qtty,0) TRADE_LIMIT_QTTY_R,
       NVL(SE.DEPOSIT,0) DEPOSIT_QTTY_R,  NVL(SE.WITHDRAW,0) WITHDRAW_QTTY_R, NVL(seretl.qtty,0) SERETAIL_QTTY_R, nvl(CI.NS_CHK_QTTY,0) NS_CHK_QTTY_R,
        nvl(td.balance,0) TDAMT_R, nvl(CI.DEPOFEEAMT,0) DEPOFEEAMT_R , NVL( CI.CIDEPOFEEACR,0) CIDEPOFEEACR_R,
         nvl(CI.NB_CHK_QTTY,0) NB_CHK_QTTY_R,

        FN_GETTRFEE(AF.ACCTNO, '00007') TRFEE_R,
        0 TRCLOSEFEE_R,

        NVL(dfgr.dfblockamt,0) DFBLOCKAMT_R,
       (CASE WHEN  NVL(TBLRP.ORDERID,'0') = '0' THEN 'N' ELSE 'Y' END) RPPTSTATUS



---KHANHND 29/05/2011: BO SUNG THEM TRUONG CHK_QTTY PHUC VU CHO GIAO DICH 0088
----CHK_QTTY: TONG KHOI LUONG DAT CON HIEU LUC TRONG NGAY CUA AF
--- NEU CHK_QTTY > 0 THI KHONG CHO PHEP DONG
       FROM ALLCODE A0, CFMAST CF, AFTYPE TYP, AFMAST AF, MRTYPE,
           (
              SELECT (CASE WHEN  (NVL(AMT,0) - CI.BALANCE) > 0 THEN (NVL(AMT,0) - CI.BALANCE) ELSE 0 END) AMT, NB_CHK_QTTY,NS_CHK_QTTY,
               CI.*
              FROM CIMAST CI,
               (
                  SELECT AFACCTNO, SUM(AMT) AMT, SUM(NB_CHK_QTTY) NB_CHK_QTTY, SUM(NS_CHK_QTTY) NS_CHK_QTTY
                  FROM(
                  SELECT OD.AFACCTNO, SUM((OD.ORDERQTTY) * OD.QUOTEPRICE * (1 +  (MOD(OD.BRATIO,1)/100)))  AS AMT, SUM(OD.REMAINQTTY) NB_CHK_QTTY,0 as NS_CHK_QTTY
                  FROM ODMAST OD, (SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') CURRDATE FROM sysvar WHERE varname ='CURRDATE') SY
                  WHERE OD.EXECTYPE ='NB' AND OD.TXDATE = SY.CURRDATE
                  GROUP BY OD.AFACCTNO
                  UNION ALL
                  SELECT OD.AFACCTNO, 0  AS AMT, 0 AS NB_CHK_QTTY ,SUM(OD.REMAINQTTY) NS_CHK_QTTY
                  FROM ODMAST OD, (SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') CURRDATE FROM sysvar WHERE varname ='CURRDATE') SY
                  WHERE OD.EXECTYPE IN ('NS','MS') AND OD.TXDATE = SY.CURRDATE
                  GROUP BY OD.AFACCTNO
                  )GROUP BY AFACCTNO
               ) OD
               WHERE CI.AFACCTNO = OD.AFACCTNO(+)
             )CI,
           (
             SELECT AFACCTNO, SUM(TRADE) TRADE_QTTY, SUM(MORTAGE) LOAN_QTTY, SUM(BLOCKED) BLOCKED,
                    SUM(WITHDRAW) WITHDRAW, SUM(SE.DEPOSIT + SE.SENDDEPOSIT) DEPOSIT,
                    SUM(standing) STANDING
             FROM SEMAST SE, SBSECURITIES SB WHERE SE.CODEID = SB.CODEID AND SB.SECTYPE <> '004' GROUP BY AFACCTNO
           ) SE,
           (
             SELECT AFACCTNO, SUM(CASE WHEN DUETYPE='RS' THEN ST_QTTY ELSE 0 END) RS_QTTY,
                    SUM(CASE WHEN DUETYPE='SS' THEN ST_QTTY ELSE 0 END) SS_QTTY,
                    SUM(CASE WHEN DUETYPE='RM' THEN ST_AMT ELSE 0 END) RM_AMT,
                    SUM(CASE WHEN DUETYPE='SM' THEN ST_AMT ELSE 0 END) SM_AMT
             FROM VW_BD_PENDING_SETTLEMENT GROUP BY AFACCTNO
             ) ST,
             (
               -- DU NO
               SELECT LNMAST.TRFACCTNO AFACCTNO, SUM(PRINNML+PRINOVD+INTNMLACR+INTOVDACR+INTNMLOVD+INTDUE +
                      OPRINNML+OPRINOVD+OINTNMLACR+OINTOVDACR+OINTNMLOVD+
                      OINTDUE+FEE+FEEDUE+FEEOVD+
                      FEEINTNMLACR+FEEINTOVDACR+FEEINTNMLOVD+FEEINTDUE) AS LNOUTSTANDING
               FROM LNMAST GROUP BY LNMAST.TRFACCTNO
             )LN,
             (
               -- PHI
               SELECT DFMAST.AFACCTNO, SUM(greatest(INTAMTACR+FEEAMT,FEEMIN-RLSFEEAMT)) AS FEE,
               SUM(DFQTTY + BLOCKQTTY + RCVQTTY + CARCVQTTY) DF_QTTY
               FROM DFMAST GROUP BY DFMAST.AFACCTNO

             )DF,
             /*(
               -- TIEN KY QUY
               SELECT V.AFACCTNO AFACCTNO, (ADVAMT + SECUREAMT) AS SECUREAMT FROM V_GETBUYORDERINFO V
             )SEC,*/
             (
               SELECT AFACCTNO, SUM(QTTY) CA_QTTY
               FROM CASCHD WHERE STATUS<> 'C'
               GROUP BY AFACCTNO
             )CAS,
             (-- UTTB
                 SELECT AFACCTNO,SUM(DEPOAMT) DEPOAMT
                 FROM v_getaccountavladvance
                 GROUP BY AFACCTNO
             ) STS,
             ( -- CK han che chuyen nhuong
             SELECT SUM(qtty) qtty, afacctno
             FROM       (
                    SELECT  qtty, substr(acctno,0,10) afacctno
                    from semastdtl
                    WHERE deltd='N' AND qttytype ='002' AND status='N'

                       )
               GROUP BY afacctno
              ) sedtl,
              ( -- CK  cam co VSD
             SELECT SUM(qtty) qtty, afacctno
             FROM       (
                    SELECT  qtty, substr(acctno,0,10) afacctno
                    from semastdtl
                    WHERE deltd='N' AND qttytype ='011' AND status<> 'C'

                       )
               GROUP BY afacctno
              ) sestand,
             ( -- T0amt
             SELECT typereceive,SUM(acclimit) acclimit, acctno
             FROM useraflimit
             WHERE typereceive='T0'
             GROUP BY acctno,typereceive
             )usl,
              ( -- CK cho ban lo le
             SELECT SUM(qtty) qtty, afacctno
             FROM       (
                    SELECT  qtty, substr(acctno,0,10) afacctno
                    from SERETAIL
                    WHERE status <> 'C'

                       )
               GROUP BY afacctno
              ) seretl,
              (
              SELECT SUM(balance) balance, afacctno FROM TDMAST
              GROUP BY afacctno
              ) TD,
          ( SELECT SUM(dfblockamt)dfblockamt ,afacctno FROM dfgroup GROUP BY afacctno) dfgr,
           --lenh Repo
          (SELECT MAX(ORDERID) ORDERID , ACCTNO FROM
(SELECT ORDERID,
(CASE WHEN FIRM = 2 THEN ACCTNO ELSE REF_AFACCTNO END) ACCTNO
FROM (
SELECT (ORDERID) ORDERID, A.ACCTNO,A.REF_AFACCTNO, B.FIRM FROM ( SELECT *  FROM (SELECT OD.ORDERID ORDERID,MAX(CF.CUSTODYCD) CUSTODYCD , MAX(AF.ACCTNO) ACCTNO , MAX(OD.TXDATE) TXDATE,
MAX(NVL(CF2.CUSTODYCD,'')) REF_CUSTODYCD,MAX(TBL.REF_AFACCTNO) REF_AFACCTNO,
MAX(CASE WHEN TBL.REF_CUSTODYCD IS NULL THEN '2' ELSE '1' END) FIRM,
MAX(GREATEST(OD.EXECQTTY,FN_GET_GRP_EXEC_QTTY (OD.ORDERID))) EXECQTTY,--SOLUONG KHOP LAN 1
MAX(GREATEST(OD2.EXECQTTY,FN_GET_GRP_EXEC_QTTY (OD2.ORDERID))) EXECQTTY2,--SOLUONG KHOP LAN 2
MAX(NVL(OD2.QUOTEPRICE,0))  QUOTEPRICE2, MAX(NVL(OD2.ORDERQTTY,0)) ORDERQTTY2,
MAX(CD.CDCONTENT) ORSTATUS, MAX(CD2.CDCONTENT) GRPORDER,MAX(TBL.REF_ORDERID) REF_ORDERID,
MAX(NVL(OD2.ORDERID,0))  ORDERID2,
MAX(CASE WHEN OD3.EXECQTTY > 0 OR (OD3.REMAINQTTY>0 AND OD3.TXDATE =TO_DATE(SYS.VARVALUE,'DD/MM/RRRR'))  THEN TBL.REF_ORDERID2 ELSE '' END) REF_ORDERID2,
MAX(OD.REMAINQTTY) REMAINQTTY, MAX(SYS.VARVALUE) CURRDATE,
MAX(OD2.TXDATE) OD2_TXDATE,MAX(NVL(OD2.REMAINQTTY,0)) REMAINQTTY2
FROM  AFMAST AF, CFMAST CF,
    VW_ODMAST_ALL OD, --LENH GOC
    SBSECURITIES SB,ALLCODE CD,ALLCODE CD2,
    TBL_ODREPO TBL,
    CFMAST CF2,
    (SELECT * FROM
       VW_ODMAST_ALL OD
        WHERE (CASE WHEN OD.GRPORDER ='Y' THEN 'N' ELSE  OD.DELTD END )= 'N'
        AND (CASE WHEN OD.GRPORDER ='Y' THEN 0 ELSE  OD.CANCELQTTY END )=0
        AND OD.MATCHTYPE = 'P'
     ) OD2,--, --LENH MUA HOAC BAN LAI
     (SELECT * FROM
       VW_ODMAST_ALL OD
        WHERE (CASE WHEN OD.GRPORDER ='Y' THEN 'N' ELSE  OD.DELTD END )= 'N'
        AND (CASE WHEN OD.GRPORDER ='Y' THEN 0 ELSE  OD.CANCELQTTY END )=0
        AND OD.MATCHTYPE = 'P'
     ) OD3, SYSVAR SYS
WHERE CF.CUSTID = AF.CUSTID
    AND OD.AFACCTNO = AF.ACCTNO
    AND OD.CODEID = SB.CODEID
    AND OD.MATCHTYPE = 'P'
    AND CD.CDNAME = 'ORSTATUS' AND CD.CDTYPE='OD'
    AND CD.CDVAL = OD.ORSTATUS
    AND  CD2.CDTYPE ='SY' AND  CD2.CDNAME ='YESNO'
    AND OD.GRPORDER = CD2.CDVAL
    AND (CASE WHEN OD.GRPORDER ='Y' THEN 'N' ELSE  OD.DELTD END )= 'N'
    AND OD.ORDERID = TBL.ORDERID
    AND TBL.REF_CUSTODYCD = CF2.CUSTODYCD(+)
    AND TBL.ORDERID2 = OD2.ORDERID(+)
    AND TBL.REF_ORDERID2 = OD3.ORDERID(+)
   AND SYS.GRNAME ='SYSTEM' AND SYS.VARNAME ='CURRDATE'
    GROUP BY OD.ORDERID ) OD WHERE 0=0
    AND (GREATEST(OD.EXECQTTY,FN_GET_GRP_EXEC_QTTY (OD.ORDERID)) > 0
            OR (OD.REMAINQTTY>0 AND OD.TXDATE =TO_DATE(CURRDATE,'DD/MM/RRRR'))
            OR (FN_GET_GRP_REMAIN_QTTY(OD.ORDERID) >0 AND OD.TXDATE =TO_DATE(CURRDATE,'DD/MM/RRRR'))
        )
    AND ((NVL(EXECQTTY2,0) = 0 AND NVL(OD2_TXDATE,TO_DATE('01/01/2000','DD/MM/RRRR')) <> TO_DATE(CURRDATE,'DD/MM/RRRR'))
            OR  (NVL(REMAINQTTY2,0) = 0 AND NVL(OD2_TXDATE,TO_DATE('01/01/2000','DD/MM/RRRR')) = TO_DATE(CURRDATE,'DD/MM/RRRR'))
            OR (FN_GET_GRP_REMAIN_QTTY(ORDERID2) >0 AND NVL(OD2_TXDATE,TO_DATE('01/01/2000','DD/MM/RRRR')) =TO_DATE(CURRDATE,'DD/MM/RRRR'))
        )
        ) A,
        (SELECT '1' FIRM FROM DUAL
         UNION
         SELECT '2' FIRM FROM DUAL
        )B ) ) WHERE ACCTNO IS NOT NULL GROUP BY ACCTNO) TBLRP
  WHERE A0.CDTYPE='CF' AND A0.CDNAME='STATUS' AND A0.CDVAL=AF.STATUS
      AND CF.STATUS IN ('A','P','N')
      AND AF.STATUS IN ('A','P','N')
      AND CF.CUSTID=AF.CUSTID
      AND AF.ACTYPE=TYP.ACTYPE
      AND MRTYPE.ACTYPE=TYP.Mrtype
      AND AF.ACCTNO=CI.AFACCTNO (+)
      AND AF.ACCTNO=SE.AFACCTNO (+)
      AND AF.ACCTNO=ST.AFACCTNO (+)
      AND AF.ACCTNO=LN.AFACCTNO (+)
      AND AF.ACCTNO=DF.AFACCTNO (+)
      --AND AF.ACCTNO=SEC.AFACCTNO (+)
      AND AF.ACCTNO = CAS.AFACCTNO (+)
      AND af.acctno=sts.afacctno (+)
      AND af.acctno=usl.acctno   (+)
      AND af.acctno=sedtl.afacctno (+)
      AND af.acctno=seretl.afacctno (+)
      AND af.acctno=sestand.afacctno (+)
      AND af.acctno=td.afacctno(+)
      AND af.acctno=dfgr.afacctno(+)
       AND af.acctno = TBLRP.ACCTNO(+)
   --ORDER BY AF.ACCTNO;;;


    AND CF.CUSTODYCD = v_CustodyCD
    AND AF.ACCTNO LIKE v_AFAcctno

      ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

