CREATE OR REPLACE PROCEDURE od0001 (
   PV_REFCURSOR             IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                      IN       VARCHAR2,
   BRID                     IN       VARCHAR2,
   F_DATE                   IN       VARCHAR2,
   T_DATE                   IN       VARCHAR2,
   CUSTODYCD                IN       VARCHAR2,
   PV_AFACCTNO              IN       VARCHAR2,
   EXECTYPE                 IN       VARCHAR2,
   SYMBOL                   IN       VARCHAR2,
   TLID                     IN       VARCHAR2,
   SECTYPE                 IN       VARCHAR2,
   BONDTYPE                 IN       VARCHAR2,
   CURRENT_INDEX            NUMBER   DEFAULT NULL,
   OFFSET_NUMBER            NUMBER   DEFAULT NULL,
   ONL                      VARCHAR2 DEFAULT NULL
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
    V_INBRID     VARCHAR2 (5);

   V_STREXECTYPE    VARCHAR2 (5);
   V_SECTYPE   	 VARCHAR2 (5);
   V_BONDTYPE    VARCHAR2 (5);
   V_STRSYMBOL      VARCHAR2 (15);
   V_STRTRADEPLACE  VARCHAR2 (3);
   V_AFACCTNO       VARCHAR2 (20);
   V_CUSTODYCD       VARCHAR2 (20);

   V_NUMBUY         NUMBER (20,2);

   --V_TRADELOG CHAR(2);
   --V_AUTOID NUMBER;
   v_TLID varchar2(4);
   V_CUR_DATE DATE ;
   v_vat    NUMBER;

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

    if tlid is null or length(tlid)=0 then
     v_TLID := 'ALL';
   else
       v_TLID := TLID;
    end if;



    -- GET REPORT'S PARAMETERS
   --
   IF (SYMBOL <> 'ALL')
   THEN
      V_STRSYMBOL := SYMBOL;
   ELSE
      V_STRSYMBOL := '%%';
   END IF;

   --
   IF (EXECTYPE <> 'ALL')
   THEN
      V_STREXECTYPE := EXECTYPE;
   ELSE
      V_STREXECTYPE := '%%';
   END IF;
   --1.7.2.1: MSBS-2280 Thêm tiêu chí đầu vào để xuất riêng GTGD và phí cho TPCP
   IF (SECTYPE <> 'ALL')
   THEN
      V_SECTYPE := SECTYPE;
   ELSE
      V_SECTYPE := '%%';
   END IF;
   --
   IF (BONDTYPE <> 'ALL')
   THEN
      V_BONDTYPE := BONDTYPE;
   ELSE
      V_BONDTYPE := '%%';
   END IF;
   --
   V_AFACCTNO := PV_AFACCTNO;

   IF  V_AFACCTNO = 'ALL' THEN
        V_AFACCTNO:= '%%';
   END IF;

   V_CUSTODYCD:= CUSTODYCD;

   SELECT TO_DATE(VARVALUE ,'DD/MM/YYYY') INTO V_CUR_DATE FROM SYSVAR WHERE VARNAME ='CURRDATE';


    BEGIN
        SELECT SUM(CASE WHEN ODM.EXECTYPE = 'NB' OR ODM.EXECTYPE = 'BC' THEN NVL(ODM.EXECAMT,0) ELSE 0 END )
        INTO V_NUMBUY
        FROM vw_odmast_all ODM, afmast af, cfmast cf
            WHERE ODM.TXDATE >= TO_DATE(F_DATE, 'DD/MM/YYYY')
                AND ODM.TXDATE <= TO_DATE(T_DATE, 'DD/MM/YYYY')
                AND ODM.EXECTYPE IN ('NB','CB')
                AND ODM.EXECTYPE like V_STREXECTYPE
                AND ODM.EXECAMT <> 0
                AND ODM.DELTD <> 'Y'
                AND af.acctno = odm.afacctno
                AND cf.custid = af.custid
                AND cf.custodycd = V_CUSTODYCD
                AND ODM.afacctno like V_AFACCTNO;
    EXCEPTION
    WHEN no_data_found THEN
    V_NUMBUY:=0;
    END;

    select to_number(varvalue) INTO v_vat from sysvar where varname = 'ADVSELLDUTY' and grname = 'SYSTEM';


   -- GET REPORT'S DATA
    OPEN PV_REFCURSOR FOR
        SELECT CF.CUSTODYCD, A2.CDCONTENT CLASS,AF.ACCTNO AFACCTNO, CF.FULLNAME, OD.TXDATE , OD.CLEARDATE,
            OD.EXECTYPE, OD.CODEID,SB.SYMBOL, AL.CDCONTENT EXECTYPE_NAME, OD.MATCHPRICE, OD.MATCHQTTY,
            OD.MATCHPRICE*OD.MATCHQTTY VAL_IO, OD.FEERATE, OD.TAXRATE, OD.FEEAMT, OD.TAXSELLAMT, nvl(V_NUMBUY,0) NUMBUY
        FROM
            SBSECURITIES SB, AFMAST AF, CFMAST CF, ALLCODE AL, ALLCODE A2,
            (
                SELECT OD.TXDATE, OD.CLEARDATE, OD.EXECTYPE, OD.AFACCTNO, OD.CODEID, OD.MATCHPRICE, SUM(OD.MATCHQTTY) MATCHQTTY,
                ROUND( AVG(OD.FEERATE),4) FEERATE,ROUND( AVG(v_vat),4) TAXRATE,
                    CASE WHEN OD.TXDATE = getcurrdate AND od.bchsts = 'N' THEN ROUND(SUM(OD.MATCHQTTY*OD.MATCHPRICE*OD.FEERATE/100)) ELSE SUM(OD.IODFEEACR) END FEEAMT,
                    SUM(CASE WHEN OD.EXECTYPE IN('NS','SS','MS') AND OD.VAT = 'Y' AND (SELECT count(*) FROM sbbatchsts WHERE bchdate = od.txdate AND bchmdl = 'SABFB' AND bchsts = 'Y') = 0
                            THEN v_vat * NVL(OD.MATCHPRICE,0) * NVL(OD.MATCHQTTY,0) /100 + NVL(OD.ARIGHT, 0)
                            ELSE OD.IODTAXSELLAMT + NVL(OD.ARIGHT, 0) END) TAXSELLAMT
                FROM
                    (
                    SELECT OD.TXDATE,STS.CLEARDATE, OD.CODEID,sp.ARIGHT, IOD.IODTAXSELLAMT,
                        (CASE WHEN OD.EXECTYPE IN('NB','BC','NS','SS') AND OD.REFORDERID IS NOT NULL AND OD.CORRECTIONNUMBER = 0 and OD.ferrod = 'N' THEN 'C'  ELSE OD.EXECTYPE END) EXECTYPE,
                        OD.AFACCTNO,IOD.MATCHPRICE, IOD.MATCHQTTY, IOD.IODFEEACR, OD.FEEACR,OD.EXECAMT,OD.STSSTATUS,decode(nvl(bs.bchsts,'N'),'Y','Y','N') bchsts,
                        CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' AND OD.TXDATE = V_CUR_DATE AND decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N' THEN ROUND(ODT.DEFFEERATE,5) ELSE ROUND(OD.FEEACR/OD.EXECAMT*100,5) END FEERATE, AFT.VAT
                    FROM VW_ODMAST_ALL OD,VW_STSCHD_ALL STS, VW_IOD_ALL IOD, ODTYPE ODT, AFMAST AF, AFTYPE AFT, (SELECT * FROM sbbatchsts bs WHERE bs.bchmdl = 'ODFEECAL') bs,
                    (SELECT orgorderid, txnum, sum(aright) aright FROM sepitallocate GROUP BY orgorderid, txnum) sp
                    WHERE  OD.ORDERID = STS.ORGORDERID AND STS.DUETYPE IN ('RM', 'RS') AND OD.TXDATE = bs.bchdate(+)
                        AND OD.ORDERID = IOD.ORGORDERID AND IOD.DELTD = 'N' AND STS.DELTD = 'N' AND OD.DELTD = 'N' AND iod.orgorderid = sp.orgorderid(+) AND iod.txnum = sp.txnum(+)
                        AND ODT.ACTYPE = OD.ACTYPE AND AF.ACTYPE = AFT.ACTYPE AND AF.ACCTNO = OD.AFACCTNO
                        AND OD.TXDATE >= TO_DATE (F_DATE, 'DD/MM/YYYY')
                        AND OD.TXDATE <= TO_DATE (T_DATE, 'DD/MM/YYYY')
                        AND OD.EXECTYPE LIKE V_STREXECTYPE
                    ) OD
                GROUP BY OD.TXDATE, OD.CLEARDATE, OD.EXECTYPE, OD.AFACCTNO, OD.CODEID, OD.MATCHPRICE, od.bchsts
            ) OD
        WHERE OD.CODEID = SB.CODEID
            AND OD.AFACCTNO = AF.ACCTNO
            AND AF.CUSTID = CF.CUSTID
            AND AL.CDNAME = 'EXECTYPE' AND AL.CDTYPE = 'OD' AND AL.CDVAL = OD.EXECTYPE
            AND A2.CDNAME = 'CLASS' AND A2.CDTYPE = 'CF' AND A2.CDVAL = CF.CLASS
             AND ( V_TLID='ALL' or AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID))
            AND SB.SYMBOL LIKE V_STRSYMBOL
            AND AF.ACCTNO LIKE V_AFACCTNO
            AND CF.CUSTODYCD = V_CUSTODYCD
            and sb.sectype like V_SECTYPE
            and nvl(sb.bondtype,'0') like V_BONDTYPE
            --bo check chi nhanh
            --AND (substr(af.acctno,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(af.acctno,1,4))<> 0)
        ORDER BY OD.AFACCTNO, OD.TXDATE, SB.SYMBOL, OD.MATCHPRICE;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
                                                     -- PROCEDURE
/