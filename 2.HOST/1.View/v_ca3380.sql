CREATE OR REPLACE FORCE VIEW V_CA3380 AS
SELECT
      CA.AUTOID, CA.TRADE BALANCE, SUBSTR(CA.CAMASTID,1,4) ||
      '.' || SUBSTR(CA.CAMASTID,5,6) || '.' ||
      SUBSTR(CA.CAMASTID,11,6) CAMASTID,
      CA.AFACCTNO,A0.CDCONTENT CATYPE, CA.CODEID, CA.EXCODEID,
      CA.QTTY, CA.AMT, CA.AQTTY,CA.NMQTTY,
      CA.AAMT, (CASE WHEN nvl(CAMAST.TOCODEID,'A') = 'A' THEN sym.symbol ELSE symto.symbol END ) SYMBOL,SYM.SYMBOL SYMBOLDIS, A1.CDCONTENT STATUS, CA.STATUS
      STATUSCD,CA.AFACCTNO || (CASE WHEN CAMAST.ISWFT='Y' THEN (CASE WHEN nvl(CAMAST.TOCODEID,'A') = 'A' THEN (SELECT CODEID FROM SBSECURITIES WHERE REFCODEID =SYM.CODEID) ELSE (SELECT CODEID FROM SBSECURITIES WHERE REFCODEID =SYMTO.CODEID) END)
      ELSE (CASE WHEN nvl(CAMAST.TOCODEID,'A') = 'A' THEN CAMAST.CODEID ELSE CAMAST.TOCODEID END ) END)  SEACCTNO,CA.AFACCTNO
      || (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID
      ELSE CAMAST.EXCODEID END) EXSEACCTNO,
      SYM.PARVALUE PARVALUE, EXSYM.PARVALUE EXPARVALUE,
      CAMAST.REPORTDATE REPORTDATE, CAMAST.ACTIONDATE  ,
      camast.description,cf.custodycd,cf.fullname,cf.idcode, --decode (camast.catype, '014', 0, 1) ISRIGHTOFF,
      case when camast.catype in ('014') then 0 else 1 end ISRIGHTOFF,
      (CASE WHEN camast.catype IN ('014','023') THEN ca.qtty ELSE nvl(CA.TRADE,0) END) QTTYDIS,
      (CASE WHEN camast.catype='014' THEN camast.exprice
            WHEN camast.catype IN ('017','020','023')
                THEN (SELECT
                            case when ( costprice <> 0 )
                                    then ROUND( costprice * round(CA.Aqtty)/ GREATEST(CA.Qtty,1),4)
                                 when   costprice = 0
                                    then  round(ROUND((PREVQTTY*COSTPRICE+DCRAMT-DDROUTAMT)/(GREATEST(DCRQTTY+PREVQTTY-DDROUTQTTY,1)),4)
                                               * round(CA.Aqtty)/ GREATEST(CA.Qtty,1),4)  --xu ly trong truong hop ngay chung khoan ve (costprice = 0) trung ngay cat quyen --> tam tinh costprice
                                 end
                            FROM semast
                            WHERE acctno= (CA.AFACCTNO || (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID
                                                                 ELSE CAMAST.EXCODEID END))
                     )
            ELSE 0 END)  costprice,
      (CASE WHEN  camast.catype IN ('017','020','023') THEN 1 ELSE 0 END ) ISCDCROUTAMT,
       (ca.afacctno || nvl(camast.tocodeid,camast.codeid)) ACCTNO_CR_UPDATECOST,
       (ca.afacctno || camast.codeid) ACCTNO_DB_UPDATECOST,
       ROUND(CASE WHEN camast.catype IN ('017','020','023') THEN nvl(se.trade,0) ELSE 0 END ) AQTTY2
FROM CASCHD CA, SBSECURITIES SYM,SBSECURITIES SYMTO, SBSECURITIES EXSYM,
     ALLCODE A0, ALLCODE A1, CAMAST ,AFMAST AF , CFMAST CF, semast se
WHERE
      A0.CDTYPE = 'CA' AND A0.CDNAME = 'CATYPE' AND A0.CDVAL = CAMAST.CATYPE
      AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS' AND
      A1.CDVAL = CA.STATUS
      AND CA.AFACCTNO = AF.ACCTNO AND AF.CUSTID =CF.CUSTID
      AND CA.CAMASTID = CAMAST.CAMASTID AND camast.codeid=sym.codeid AND SYMTO.CODEID=(CASE WHEN nvl(CAMAST.TOCODEID,'A') <> 'A' THEN CAMAST.TOCODEID ELSE CAMAST.CODEID END)
      AND CA.DELTD ='N' AND  ((ca.status IN('V','M') and CAMAST.catype IN ('014','023'))
      or(ca.status IN('A','M') and CAMAST.catype<>'014' and CAMAST.catype<>'023'  )) and
      CAMAST.CATYPE not in('018','019','002','026','019')and   cf.custatcom='Y'
      AND EXSYM.CODEID = (CASE WHEN CAMAST.EXCODEID IS NULL
      THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END)
      and ((CAMAST.catype = '014' and CA.TQTTY = CA.QTTY  )
      or CAMAST.catype <> '014')
      AND ca.afacctno||ca.codeid=se.acctno(+)
;

