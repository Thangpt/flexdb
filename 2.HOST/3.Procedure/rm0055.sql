CREATE OR REPLACE PROCEDURE rm0055 (
   PV_REFCURSOR             IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                      IN       VARCHAR2,
   BRID                     IN       VARCHAR2,
   F_DATE                   IN       VARCHAR2,
   T_DATE                   IN       VARCHAR2,
   PV_CUSTODYCD             IN       VARCHAR2,
   PV_AFACCTNO              IN       VARCHAR2,
   PV_ACCTYPE               IN       VARCHAR2,
   PV_CUSTODYPLACE          IN       VARCHAR2,
   PV_EXECTYPE              IN       VARCHAR2,
   PV_MATCHTYPE             IN       VARCHAR2,
   PV_TRADEPLACE            IN       VARCHAR2,
   CASHPLACE                IN       VARCHAR2,
   PV_BRID                  IN       VARCHAR2,
   CAREBY                   IN       VARCHAR2,
   DATE_T                   IN       VARCHAR2
   )
IS

   V_STROPTION         VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID           VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID            VARCHAR2 (4);

   V_FDATE             DATE;
   V_TDATE             DATE;
   V_CUSTODYCD         VARCHAR2(100);
   V_AFACCTNO          VARCHAR2(100);
   V_ACCTYPE           VARCHAR2(100);
   V_CUSTODYPLACE      VARCHAR2(100);
   V_EXECTYPE          VARCHAR2(100);
   V_MATCHTYPE         VARCHAR2(100);
   V_TRADEPLACE        VARCHAR2(100);

   V_CRRDATE           DATE;
   V_STRCASHPLACE    VARCHAR2(1000);


   V_pV_STRBRID           VARCHAR2 (50);
   V_p_STRBRID           VARCHAR2 (10);

   V_STRCAREBY           VARCHAR2 (10);

   v_chinhanh           varchar2(100);
   v_noilk              VARCHAR2 (50);
   v_noidetien          varchar2(100);
   v_nhomql             varchar2(50);
BEGIN

    V_STROPTION := upper(OPT);
    V_INBRID := BRID;
    IF (V_STROPTION = 'A') THEN
         V_STRBRID := '%';
    ELSE if (V_STROPTION = 'B') then
            select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    END IF;

-- GET REPORT'S PARAMETERS
    IF (PV_CUSTODYCD <> 'ALL' OR PV_CUSTODYCD <> '')
    THEN
         V_CUSTODYCD    :=    PV_CUSTODYCD;
    ELSE
         V_CUSTODYCD    :=    '%';
    END IF;

    IF (PV_AFACCTNO <> 'ALL' OR PV_AFACCTNO <> '')
    THEN
         V_AFACCTNO    :=    PV_AFACCTNO;
    ELSE
         V_AFACCTNO    :=    '%';
    END IF;

    IF (PV_ACCTYPE <> 'ALL' OR PV_ACCTYPE <> '')
    THEN
         V_ACCTYPE    :=    PV_ACCTYPE;
    ELSE
         V_ACCTYPE    :=    '%';
    END IF;

    IF (PV_CUSTODYPLACE <> 'ALL' OR PV_CUSTODYPLACE <> '')
    THEN
         V_CUSTODYPLACE    :=    CASE WHEN PV_CUSTODYPLACE='001' then 'Y' else 'N' end;
    ELSE
         V_CUSTODYPLACE    :=    '%';
    END IF;

    IF (PV_EXECTYPE <> 'ALL' OR PV_EXECTYPE <> '')
    THEN
         V_EXECTYPE    :=    PV_EXECTYPE;
    ELSE
         V_EXECTYPE    :=    '%';
    END IF;

    IF (PV_MATCHTYPE <> 'ALL' OR PV_MATCHTYPE <> '')
    THEN
         V_MATCHTYPE    :=    PV_MATCHTYPE;
    ELSE
         V_MATCHTYPE    :=    '%';
    END IF;

    IF (PV_TRADEPLACE <> 'ALL' OR PV_TRADEPLACE <> '')
    THEN
         V_TRADEPLACE    :=    PV_TRADEPLACE;
    ELSE
         V_TRADEPLACE    :=    '%';
    END IF;

    IF  (CASHPLACE <> 'ALL')
    THEN
      V_STRCASHPLACE := CASHPLACE;
    ELSE
      V_STRCASHPLACE := '%';
    END IF;

    if(upper(PV_BRID) = 'ALL' OR LENGTH(PV_BRID) <= 1) then
        V_pV_STRBRID := '%';
        V_p_STRBRID := '%';
    else
        if(upper(PV_BRID) = 'GROUP1') then
            V_pV_STRBRID := '0002,0001,0003';
            V_p_STRBRID := 'D';
        ELSE IF (upper(PV_BRID) = 'GROUP2') THEN
            V_pV_STRBRID := '0101,0102,0103';
            V_p_STRBRID := 'D';
        else
            V_pV_STRBRID := 'D';
            V_p_STRBRID := PV_BRID;
        end if;
        end if;
    end if;

    if(upper(CAREBY) = 'ALL' or LENGTH(CAREBY) <= 1) then
        V_STRCAREBY := '%';
    else
        V_STRCAREBY := CAREBY;
    end if;


    V_FDATE              :=    TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_TDATE              :=    TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    SELECT TO_DATE(SY.VARVALUE, SYSTEMNUMS.C_DATE_FORMAT) INTO V_CRRDATE
    FROM SYSVAR SY WHERE SY.VARNAME = 'CURRDATE' AND SY.GRNAME = 'SYSTEM';

    -- Noi luu ky
    IF PV_CUSTODYPLACE = 'ALL' THEN
        v_noilk := ' T?t c? ';
    ELSIF PV_CUSTODYPLACE = '001' THEN
        v_noilk := ' T?i BVSC ';
    ELSE
        v_noilk := ' Luu k� noi kh�c ';
    END IF;

    -- Chi nhanh
    IF upper(PV_BRID) = 'ALL' THEN
        v_chinhanh := ' T?t c? ';
    ELSE
        SELECT nvl(display,' ') INTO v_chinhanh
        FROM
        (SELECT BRID VALUE, BRID VALUECD, BRNAME DISPLAY, BRNAME EN_DISPLAY, BRNAME DESCRIPTION
            FROM (SELECT BRID, BRNAME ,1 LSTODR FROM BRGRP
            UNION ALL
            select 'GROUP1' BRID , (brname_0002 || ' , ' || brname_0001 || ' , ' || brname_0003) BRNAME, -2 LSTODR
                        from(select max(case when brid = '0002' then brname else '' end) brname_0002,
                    max(case when brid = '0001' then brname else '' end) brname_0001,
                    max(case when brid = '0003' then brname else '' end) brname_0003
                from BRGRP where brid in ('0002','0001','0003'))
            UNION ALL
            select 'GROUP2' BRID , (brname_0101 || ' , ' || brname_0102 || ' , ' || brname_0103) BRNAME,-1 LSTODR
                from(select max(case when brid = '0101' then brname else '' end) brname_0101,
                        max(case when brid = '0102' then brname else '' end) brname_0102,
                        max(case when brid = '0103' then brname else '' end) brname_0103
                    from BRGRP where brid in ('0101','0102','0103')
                    )
                )
        ) a
        WHERE a.value = upper(PV_BRID);
    End IF;

    --Noi de tien
    IF CASHPLACE = 'ALL' THEN
        v_noidetien := ' T?t c? ';
    ELSIF CASHPLACE = '000' THEN
        v_noidetien := ' Cty ch?ng kho�n ';
    ELSIF CASHPLACE = '111' THEN
        v_noidetien := ' K?t n?i ng�n h�ng ';
    ELSE
        SELECT nvl(cdcontent,' ') INTO v_noidetien
        FROM allcode WHERE cdtype = 'CF' AND cdname = 'BANKNAME'
        AND cdval = CASHPLACE;
    END IF;

    --nhom quan ly
    IF CAREBY = 'ALL' THEN
        v_nhomql := ' T?t c? ';
    ELSE
        SELECT nvl(grpname,' ') INTO v_nhomql
        FROM  TLGROUPS WHERE GRPTYPE ='2' AND grpid = CAREBY;
    END IF;

OPEN PV_REFCURSOR
FOR

     SELECT  v_noidetien noi_de_tien, v_chinhanh chi_nhanh, v_noilk noi_luu_ky, v_nhomql nhom_ql, DATE_T ck_thanh_toan,
             T.TXDATE, T.SECTYPE_NAME, T.SYMBOL, T.EXECTYPE, T.EXECTYPE_NAME, T.ORDERID,
             T.CUSTODYCD, T.ACCTNO AFACCTNO, T.VAT, T.CUSTTYPE, T.CUSTTYPE_NAME, T.CUSTODY_PLACE,
             T.MATCHTYPE, T.TRADEPLACE, T.GR_I, T.GR_II, T.TYPE_OD_NAME, T.TYPE_TRANS_NAME,
             --- GIAO DICH MUA
             sum(CASE WHEN T.EXECTYPE IN('NB','BC') THEN NVL(IO.MATCHQTTY,0) ELSE 0 END) MATCHQTTY_B,
             sum(CASE WHEN T.EXECTYPE IN('NB','BC') THEN (NVL(IO.MATCHQTTY,0) * NVL(IO.MATCHPRICE,0)) ELSE 0 END) EXECAMT_B,

             --- GIAO DICH BAN
             sum(CASE WHEN T.EXECTYPE IN('NS','SS','MS') THEN NVL(IO.MATCHQTTY,0) ELSE 0 END) MATCHQTTY_S,
             sum(CASE WHEN T.EXECTYPE IN('NS','SS','MS') THEN (NVL(IO.MATCHQTTY,0) * NVL(IO.MATCHPRICE,0)) ELSE 0 END) EXECAMT_S,

             --- TI LE HOA HONG --> TI LE PHI LENH
             max(case when t.execamt>0 and t.feeacr=0 then
                  t.deffeerate
             else
               (CASE WHEN (t.execamt * t.feeacr) = 0 THEN 0 ELSE
                   (CASE WHEN T.TXDATE = V_CRRDATE AND T.EXECTYPE IN('NS','SS','MS')
                         THEN round(100 * t.feeacr/(t.execamt),2)
                         WHEN T.EXECTYPE IN('NS','SS','MS') THEN ROUND ((io.matchqtty * io.matchprice / t.execamt * t.feeacr) * 100 / (IO.MATCHPRICE*IO.MATCHQTTY), 2)
                         WHEN T.txdate = V_CRRDATE AND T.EXECTYPE IN('NB','BC')
                         THEN round(100 * t.feeacr/(t.execamt),2)
                         WHEN T.EXECTYPE IN('NB','BC') THEN ROUND((io.matchqtty * io.matchprice/t.execamt * t.feeacr)*100/ (IO.MATCHPRICE*IO.MATCHQTTY),2) END)
               END)
             end)  FEE_RATE,

             --- TIEN HOA HONG
             sum(case when t.execamt > 0 and t.feeacr=0 then
                  ROUND(IO.matchqtty * io.matchprice * t.deffeerate / 100, 2)
             else
               (CASE WHEN (t.execamt * t.feeacr) = 0 THEN 0 ELSE
                   (CASE WHEN T.TXDATE = V_CRRDATE THEN round(t.feeacr * io.matchqtty * io.matchprice / t.execamt,2)--ROUND(IO.matchqtty * io.matchprice * t.deffeerate / 100, 2)
                         ELSE ROUND(io.matchqtty * io.matchprice / t.execamt * t.feeacr, 2) END)
               END)
             end)  FEE_AMT_DETAIL,
             --- THUE TNCN
             sum(CASE WHEN T.EXECTYPE IN('NS','SS','MS') AND T.VAT = 'Y' THEN
              ROUND(IO.MATCHQTTY * IO.MATCHPRICE * (SELECT VARVALUE FROM SYSVAR WHERE VARNAME = 'ADVSELLDUTY' AND GRNAME = 'SYSTEM')/100, 2) + NVL(T.ARIGHT, 0)
              ELSE 0 END) FEETAX_AMT_DETAIL
     FROM
            (SELECT      AF.ACCTNO, CF.CUSTODYCD, OD.TXDATE, OD.ORDERID, OD.CONTRAORDERID, CF.FULLNAME, CF.IDCODE, CF.IDDATE, CF.IDPLACE,
                         CF.ADDRESS, AFT.VAT, OD.EXECTYPE, ----A1.CDCONTENT PUTTYPE,
                         SB.SYMBOL, ODT.DEFFEERATE , OD.FEEACR, io.matchamt EXECAMT,
                         A2.CDCONTENT SECTYPE_NAME, A3.CDCONTENT EXECTYPE_NAME, CF.CUSTTYPE, OD.MATCHTYPE, SB.TRADEPLACE,
                         (TRIM(CF.CUSTTYPE) || TRIM(SUBSTR(CF.CUSTODYCD, 4, 1))) CUSTTYPE_NAME, STS.ARIGHT,
                         (CASE WHEN (TRIM(CF.CUSTTYPE) || TRIM(SUBSTR(CF.CUSTODYCD, 4, 1))) = 'IC' THEN utf8nums.c_const_custtype_custodycd_ic
                               WHEN (TRIM(CF.CUSTTYPE) || TRIM(SUBSTR(CF.CUSTODYCD, 4, 1))) = 'BC' THEN utf8nums.c_const_custtype_custodycd_bc
                               WHEN (TRIM(CF.CUSTTYPE) || TRIM(SUBSTR(CF.CUSTODYCD, 4, 1))) = 'IF' THEN utf8nums.c_const_custtype_custodycd_if
                               WHEN (TRIM(CF.CUSTTYPE) || TRIM(SUBSTR(CF.CUSTODYCD, 4, 1))) = 'BF' THEN utf8nums.c_const_custtype_custodycd_bf
                          ELSE NULL END) GR_I,
                         (CASE WHEN (TRIM(SUBSTR(CF.CUSTODYCD, 4, 1))) = 'C' THEN utf8nums.c_const_custodycd_type_c
                               WHEN (TRIM(SUBSTR(CF.CUSTODYCD, 4, 1))) = 'F' THEN utf8nums.c_const_custodycd_type_f
                               WHEN (TRIM(SUBSTR(CF.CUSTODYCD, 4, 1))) = 'P' THEN utf8nums.c_const_custodycd_type_p
                          ELSE NULL END) GR_II,
                         CF.CUSTATCOM CUSTODY_PLACE,
                         (CASE WHEN OD.PRICETYPE IN('ATO','ATC') AND OD.EXECTYPE IN('NB','BC') THEN OD.PRICETYPE
                               WHEN OD.EXECTYPE  IN('NB','BC') THEN TO_CHAR(OD.QUOTEPRICE) END) QUOTEPRICE_B,
                         (CASE WHEN OD.PRICETYPE IN('ATO','ATC') AND OD.EXECTYPE IN('NS','SS') THEN OD.PRICETYPE
                               WHEN OD.EXECTYPE  IN('NS','SS','MS') THEN TO_CHAR(OD.QUOTEPRICE) END )QUOTEPRICE_S,
                         (CASE WHEN OD.EXECTYPE  IN('NB','BC') THEN OD.ORDERQTTY END) ORDERQTTY_B,
                         (CASE WHEN OD.EXECTYPE  IN('NS','SS','MS') THEN OD.ORDERQTTY END) ORDERQTTY_S,
                         (CASE WHEN OD.EXECTYPE  = 'NS' THEN 'TT'
                               WHEN OD.EXECTYPE  = 'MS' THEN 'CC'
                               ELSE NULL END) TYPE_OD_NAME,
                         (CASE WHEN OD.EXECTYPE  IN('NS', 'MS') THEN 'S' ELSE 'B' END) TYPE_TRANS_NAME
             FROM
                         VW_ODMAST_ALL OD, SBSECURITIES SB,
                         (select * from afmast where (case when CASHPLACE = 'ALL' then 'ALL'
                                                        when CASHPLACE = '000' or CASHPLACE = '---' then corebank
                                                        when CASHPLACE = '111' then corebank
                                                        else corebank || bankname end)
                                                   = case when CASHPLACE = 'ALL' then 'ALL'
                                                        when CASHPLACE = '000'  or CASHPLACE = '---' then 'N'
                                                        when CASHPLACE = '111'  then 'Y'
                                                        else 'Y' || V_STRCASHPLACE  end ) AF,
                         CFMAST CF, ODTYPE ODT, ---ALLCODE A1,
                         ALLCODE A2, ALLCODE A3, AFTYPE AFT,
                         (SELECT * FROM STSCHD UNION ALL SELECT * FROM STSCHDHIST) STS,
                         (select orgorderid, sum(matchqtty * matchprice) matchamt
                         from VW_IOD_ALL
                         group by orgorderid
                         ) io
             WHERE       OD.CODEID        =    SB.CODEID
                    and od.orderid = io.orgorderid
                  AND    OD.AFACCTNO      =    AF.ACCTNO
                  AND    AF.ACCTNO        LIKE V_AFACCTNO
                  AND    OD.EXECTYPE      LIKE V_EXECTYPE
                  AND    AF.CUSTID        =    CF.CUSTID
                  AND    CF.CUSTODYCD     LIKE V_CUSTODYCD
                  AND    OD.ACTYPE        =    ODT.ACTYPE
                  AND    OD.DELTD         <>   'Y'
                  AND    OD.TXDATE        BETWEEN V_FDATE AND V_TDATE
                  AND    A2.CDNAME        =    'SECTYPE'
                  AND    A2.CDTYPE        =    'SA'
                  AND    A2.CDVAL         =    SB.SECTYPE
                  AND    A3.CDNAME        =    'EXECTYPE'
                  AND    A3.CDTYPE        =    'OD'
                  AND    A3.CDVAL         =    OD.EXECTYPE
                  AND    AF.ACTYPE        =    AFT.ACTYPE
                  AND    OD.MATCHTYPE     LIKE V_MATCHTYPE
                  AND    (case when V_TRADEPLACE = '999' and SB.TRADEPLACE IN ('001','002') then '999'
                    else SB.TRADEPLACE end ) LIKE V_TRADEPLACE
                  and   (case when TO_NUMBER(DATE_T) = 0 then 0 else od.clearday end)     =    TO_NUMBER(DATE_T)
                  AND    OD.ORDERID       =    STS.ORGORDERID(+)
                  AND    STS.DELTD        <>   'Y'
                  AND    nvl(STS.DUETYPE ,(CASE WHEN OD.EXECTYPE IN('NB','BC') THEN 'SM' ELSE 'RM' END))    =    (CASE WHEN OD.EXECTYPE IN('NB','BC') THEN 'SM' ELSE 'RM' END)
                  AND    OD.EXECTYPE      IN ('NB','NS','MS')
                  AND    SB.TRADEPLACE    IN ('001','002','005')
                  AND (af.brid like V_p_STRBRID or instr(V_pV_STRBRID,af.brid) <> 0 )
                  and (af.brid like V_STRBRID or instr(V_STRBRID,af.brid) <> 0)
                  and af.careby like V_STRCAREBY
            ) T INNER JOIN VW_IOD_ALL IO ON T.ORDERID = IO.ORGORDERID
     WHERE    IO.DELTD                   <>    'Y'
     AND      T.CUSTTYPE_NAME            LIKE  V_ACCTYPE
     AND      T.CUSTODY_PLACE            LIKE  V_CUSTODYPLACE
      GROUP BY T.TXDATE, T.SECTYPE_NAME, T.SYMBOL, T.EXECTYPE, T.EXECTYPE_NAME, T.ORDERID,
             T.CUSTODYCD, T.ACCTNO, T.VAT, T.CUSTTYPE, T.CUSTTYPE_NAME, T.CUSTODY_PLACE,
             T.MATCHTYPE, T.TRADEPLACE, T.GR_I, T.GR_II, T.TYPE_OD_NAME, T.TYPE_TRANS_NAME

     ORDER BY T.TXDATE, T.SYMBOL, T.ACCTNO;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

