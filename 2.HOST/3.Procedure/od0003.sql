CREATE OR REPLACE PROCEDURE od0003 (
   PV_REFCURSOR             IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                      IN       VARCHAR2,
   BRID                     IN       VARCHAR2,
   F_DATE                   IN       VARCHAR2,
   T_DATE                   IN       VARCHAR2,
   CUSTODYCD                IN       VARCHAR2,
   PV_AFACCTNO              IN       VARCHAR2,
   CUSTBANK                 IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- KET QUA KHOP LENH CUA KHACH HANG
-- PERSON      DATE    COMMENTS
-- NAMNT   15-JUN-08  CREATED
-- DUNGNH  08-SEP-09  MODIFIED
-- THENN    27-MAR-2012 MODIFIED    SUA LAI TINH PHI, THUE DUNG
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);            -- USED WHEN V_NUMOPTIfON > 0
   V_STREXECTYPE    VARCHAR2 (5);
   V_STRSYMBOL      VARCHAR2 (15);
   V_STRTRADEPLACE  VARCHAR2 (3);
   V_AFACCTNO       VARCHAR2 (20);
   V_CUSTODYCD       VARCHAR2 (20);
   V_CUSTBANK          varchar2(10);

   V_NUMBUY         NUMBER (20,2);

   --V_TRADELOG CHAR(2);
   --V_AUTOID NUMBER;
   --v_TLID varchar2(4);
   V_CUR_DATE DATE ;
   v_vat        NUMBER;

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

    IF CUSTBANK = 'ALL' OR CUSTBANK IS NULL THEN
        V_CUSTBANK := '%%';
    ELSE
        V_CUSTBANK := CUSTBANK;
    END IF;
    -- GET REPORT'S PARAMETERS
   --


   --
   V_AFACCTNO := PV_AFACCTNO;

   IF  V_AFACCTNO = 'ALL' OR V_AFACCTNO IS NULL THEN
        V_AFACCTNO:= '%%';
   END IF;

    IF CUSTODYCD = 'ALL' OR CUSTODYCD IS NULL THEN
        V_CUSTODYCD := '%%';
    ELSE
        V_CUSTODYCD := CUSTODYCD;
    END IF;

   SELECT TO_DATE(VARVALUE ,'DD/MM/YYYY') INTO V_CUR_DATE FROM SYSVAR WHERE VARNAME ='CURRDATE';
   select to_number(varvalue) INTO v_vat from sysvar where varname = 'ADVSELLDUTY' and grname = 'SYSTEM';

/*
    BEGIN
        SELECT SUM(CASE WHEN ODM.EXECTYPE = 'NB' OR ODM.EXECTYPE = 'BC' THEN NVL(ODM.EXECAMT,0) ELSE 0 END )
        INTO V_NUMBUY
        FROM vw_odmast_all ODM, afmast af, cfmast cf
            WHERE ODM.TXDATE >= TO_DATE(F_DATE, 'DD/MM/YYYY')
                AND ODM.TXDATE <= TO_DATE(T_DATE, 'DD/MM/YYYY')
                AND ODM.EXECTYPE IN ('NB','CB')
                AND ODM.EXECAMT <> 0
                AND ODM.DELTD <> 'Y'
                AND af.acctno = odm.afacctno
                AND cf.custid = af.custid
                AND cf.custodycd like V_CUSTODYCD
                AND ODM.afacctno like V_AFACCTNO;
    EXCEPTION
    WHEN no_data_found THEN
    V_NUMBUY:=0;
    END;*/

   -- GET REPORT'S DATA
    OPEN PV_REFCURSOR FOR
        SELECT
            case when V_AFACCTNO = '%%' AND V_CUSTODYCD = '%%' then '<ALL>'
                 else CF.CUSTODYCD end CUSTODYCD
            , CF.CUSTODYCD AFACCTNO --sua lai de len bao cao theo tai khoan
            , case when V_AFACCTNO = '%%' AND V_CUSTODYCD = '%%' then '<ALL>'
                 else CF.FULLNAME end FULLNAME
            , OD.TXDATE , OD.CLEARDATE,
            OD.EXECTYPE, OD.CODEID,SB.SYMBOL, AL.CDCONTENT EXECTYPE_NAME, OD.MATCHPRICE, OD.MATCHQTTY,
            OD.MATCHPRICE*OD.MATCHQTTY VAL_IO, OD.FEERATE, OD.TAXRATE, OD.FEEAMT, OD.TAXSELLAMT/*, nvl(V_NUMBUY,0) NUMBUY*/
        FROM
            SBSECURITIES SB, AFMAST AF, CFMAST CF, ALLCODE AL,
            (
                SELECT OD.TXDATE, OD.CLEARDATE, OD.EXECTYPE, OD.AFACCTNO, OD.CODEID, OD.MATCHPRICE, SUM(OD.MATCHQTTY) MATCHQTTY,
                ROUND( AVG(OD.FEERATE),4) FEERATE,ROUND( AVG(OD.TAXRATE),4) TAXRATE,
                    ROUND(SUM(OD.MATCHQTTY*OD.MATCHPRICE*OD.FEERATE/100)) FEEAMT,
                    ROUND(SUM(OD.MATCHQTTY*OD.MATCHPRICE*OD.TAXRATE/100+ od.ARIGHT)) TAXSELLAMT
                FROM
                    (
                    SELECT OD.TXDATE,STS.CLEARDATE, OD.CODEID, NVL(sts.ARIGHT, 0) ARIGHT,
                        (CASE WHEN OD.EXECTYPE IN('NB','BC','NS','SS') AND OD.REFORDERID IS NOT NULL AND OD.CORRECTIONNUMBER = 0 and OD.ferrod = 'N' THEN 'C'  ELSE OD.EXECTYPE END) EXECTYPE,
                        OD.AFACCTNO,IOD.MATCHPRICE, IOD.MATCHQTTY,
                        CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' AND OD.TXDATE = V_CUR_DATE AND decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N' THEN ROUND(ODT.DEFFEERATE,5) ELSE ROUND(OD.FEEACR/OD.EXECAMT*100,5) END FEERATE,
                       /*CASE WHEN OD.EXECAMT >0 AND INSTR(OD.EXECTYPE,'S')>0 AND OD.STSSTATUS = 'N'
                                THEN ROUND(TO_NUMBER(SYS.VARVALUE),5) ELSE NVL(OD.TAXRATE,0) END TAXRATE*/
                         CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.EXECTYPE IN ('MS','NS','SS') AND OD.TXDATE = V_CUR_DATE THEN v_vat ELSE NVL(OD.TAXRATE,0) END TAXRATE
                    FROM VW_ODMAST_ALL OD,VW_STSCHD_ALL STS, VW_IOD_ALL IOD, ODTYPE ODT, SYSVAR SYS
                        , ( select ln.trfacctno, ls.rlsdate from vw_lnschd_all ls, vw_lnmast_all ln, cfmast cfb
                            where ln.acctno = ls.acctno and ln.custbank = cfb.custid(+)
                            and NVL(CFb.shortname,'MSBS')  like V_CUSTBANK
                            group by ln.trfacctno, ls.rlsdate
                            )  ln, (SELECT * FROM sbbatchsts bs WHERE bs.bchmdl = 'ODFEECAL') bs

                    WHERE  OD.ORDERID = STS.ORGORDERID AND STS.DUETYPE IN ('RM', 'RS')
                        AND OD.ORDERID = IOD.ORGORDERID AND IOD.DELTD = 'N' AND STS.DELTD = 'N' AND OD.DELTD = 'N'
                        AND ODT.ACTYPE = OD.ACTYPE and ln.rlsdate = od.txdate and ln.trfacctno = od.afacctno
                        and iod.bors = 'B' AND OD.TXDATE = bs.bchdate(+)
                        AND SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'ADVSELLDUTY'
                        AND OD.TXDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY')
                        AND OD.TXDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')

                    ) OD
                GROUP BY OD.TXDATE, OD.CLEARDATE, OD.EXECTYPE, OD.AFACCTNO, OD.CODEID, OD.MATCHPRICE
            ) OD

        WHERE OD.CODEID = SB.CODEID
            AND OD.AFACCTNO = AF.ACCTNO
            AND AF.CUSTID = CF.CUSTID
            AND AL.CDNAME = 'EXECTYPE' AND AL.CDTYPE = 'OD' AND AL.CDVAL = OD.EXECTYPE
            --AND ( V_TLID='ALL' or AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID))
            --AND SB.SYMBOL LIKE V_STRSYMBOL
            AND AF.ACCTNO LIKE V_AFACCTNO
             AND (substr(af.acctno,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(af.acctno,1,4))<> 0)
            AND CF.CUSTODYCD like V_CUSTODYCD
        ORDER BY CF.CUSTODYCD, OD.TXDATE, SB.SYMBOL, OD.MATCHPRICE;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
                                                     -- PROCEDURE

-- End of DDL Script for Procedure HOSTTEST.OD0003
/

