-- Start of DDL Script for Procedure HOSTUAT.OD0019
-- Generated 21-May-2020 17:47:43 from HOSTUAT@FLEXUAT

CREATE OR REPLACE 
PROCEDURE od0019_home (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_RECUSTID IN       VARCHAR2,
   PV_TLID        IN       VARCHAR2,
   PV_CFAFACCTNO  IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO        IN       VARCHAR2,
   PV_VIA   IN       VARCHAR2,
   PV_CONFIRMED        IN       VARCHAR2,
   GRCAREBY        in      varchar2,
   PV_VIACONFIRMED  in      varchar2
   )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- TONG HOP KET QUA KHOP LENH
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   21-NOV-06  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPT          VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID            VARCHAR2 (100);               -- USED WHEN V_NUMOPTION > 0
    V_INBRID       VARCHAR2 (5);
   V_STRVIA             VARCHAR2 (10);
   V_STRTLID           VARCHAR2(6);
   v_strCustodycd      VARCHAR2(10);
   v_strAfacctno      VARCHAR2(10);
   v_strConfirmed     VARCHAR2(2);
   v_strRECustid   VARCHAR2(10);
   v_strCFAfacctno    VARCHAR2(10);
   v_strGRCAREBY      varchar2(10);
   v_viaconfirmed     varchar2 (2);
   V_CRRDATE        DATE;

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
  /* V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;*/

  V_STROPT := upper(OPT);
    V_INBRID := BRID;
    if(V_STROPT = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPT = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

    -- GET REPORT'S PARAMETERS
   IF (PV_TLID <> 'ALL')
   THEN
      V_STRTLID := PV_TLID;
   ELSE
      V_STRTLID := '%%';
   END IF;
   --
  IF (PV_CUSTODYCD <> 'ALL')
   THEN
      v_strCustodycd := PV_CUSTODYCD;
   ELSE
      v_strCustodycd := '%%';
   END IF;
   --
   IF (PV_afacctno <> 'ALL')
   THEN
      v_strAfacctno := PV_afacctno;
   ELSE
      v_strAfacctno := '%%';
   END IF;
   --
   IF (PV_CONFIRMED <> 'ALL')
   THEN
      v_strConfirmed := PV_CONFIRMED;
   ELSE
      v_strConfirmed := '%%';
   END IF;
   --
    IF (PV_RECUSTID <> 'ALL')
   THEN
      v_strRECustid := PV_RECUSTID;
   ELSE
      v_strRECustid := '%%';
   END IF;
   --
    IF (PV_CFAFACCTNO <> 'ALL')
   THEN
      v_strCFAfacctno := PV_CFAFACCTNO;
   ELSE
      v_strCFAfacctno := '%%';
   END IF;
   --
      IF (PV_VIA <> 'ALL')
   THEN
      v_strVIA := PV_VIA;
   ELSE
      v_strVIA := '%%';
   END IF;

   IF (GRCAREBY <> 'ALL')
   THEN
      v_strGRCAREBY := GRCAREBY;
   ELSE
      v_strGRCAREBY := '%%';
   END IF;

   IF (PV_VIACONFIRMED <> 'ALL')
   THEN
      v_viaconfirmed := PV_VIACONFIRMED;
   ELSE
      v_viaconfirmed := '%%';
   END IF;
   --- TINH GT KHOP MG

    SELECT TO_DATE(SY.VARVALUE, SYSTEMNUMS.C_DATE_FORMAT) INTO V_CRRDATE
    FROM SYSVAR SY WHERE SY.VARNAME = 'CURRDATE' AND SY.GRNAME = 'SYSTEM';

OPEN PV_REFCURSOR
 FOR
SELECT * FROM (
    SELECT distinct OD.ORDERID,OD.CODEID, A0.CDCONTENT TRADEPLACE, A1.CDCONTENT EXECTYPE,A5.CDCONTENT MATCHTYPE,
        OD.PRICETYPE, A3.CDCONTENT VIA, OD.ORDERQTTY,OD.QUOTEPRICE, OD.REFORDERID, od.symbol,
        CASE WHEN od.via in ('O','M','K','P','T','B','C') OR (od.via IN ('E','L') AND od.tlid = 'ONLINE') OR (od.isdisposal = 'Y') THEN 'Y' ELSE nvl(c.CONFIRMED,'N') END CONFIRMED, --1.5.4.7 MSBS-1824
        od.afacctno, od.custodycd, od.fullname, ' ' ROOTORDERID,
        od.txdate, od.txtime, od.refullname, od.DFS,od.custid,od.via viaod,
        od.tlid, c.Userid, c.custid cfafacctno,
        (CASE WHEN od.via in ('O','M','K','P','T','B','C') OR (od.via IN ('E','L') AND od.tlid = 'ONLINE') OR (od.isdisposal = 'Y') THEN 'Y' ELSE nvl(c.CONFIRMED,'N') END) CONFIRMEDVAL, --1.5.4.7 MSBS-1824
        nvl(a4.cdcontent,A3.CDCONTENT) via_confirm_name, c.via via_confirmed,
        (CASE WHEN NVL(c.userid,'a') <> 'a' THEN c.userid || ' - ' || tl.tlfullname
              WHEN  NVL(c.custid,'a') <> 'a' THEN c.custid || ' - ' || cf.fullname
              ELSE  od.custid || ' - ' || od.fullname  END) confirmdesc
    FROM (select od.*,VOD.MATCHTYPE,vod.custid from odmastdtl OD, vw_odmast_all VOD WHERE OD.orderid=VOD.orderid)OD,
          confirmodrsts c, ALLCODE A0, ALLCODE A1, ALLCODE A2, ALLCODE A3,aLLCODE A4,ALLCODE A5, tlprofiles tl, cfmast cf, afmast af
    WHERE od.orderid = c.orderid(+) AND od.afacctno = af.acctno
    AND A3.cdtype = 'OD' AND A3.cdname = 'VIA' AND A3.cdval = OD.VIA
    AND a0.cdtype = 'OD' AND a0.cdname = 'TRADEPLACE' AND a0.cdval = od.tradeplace
    AND A1.cdtype = 'OD' AND A1.cdname = 'EXECTYPE'
    AND A1.cdval =(case when nvl(od.reforderid,'a') <>'a' and OD.EXECTYPE = 'NB' then 'AB'
                    when  nvl(od.reforderid,'a') <>'a' and OD.EXECTYPE in ( 'NS','MS') then 'AS'
                    else od.EXECTYPE end)
    AND A2.cdtype = 'OD' AND A2.cdname = 'PRICETYPE' AND A2.cdval = OD.PRICETYPE
    AND A5.CDTYPE='OD' AND A5.CDNAME='MATCHTYPE' AND A5.CDVAL=OD.MATCHTYPE
    AND a4.cdtype(+) = 'OD' and a4.cdname(+) = 'VIA' AND c.via = a4.cdval(+)
    AND c.userid = tl.tlid(+)
    AND c.custid = cf.custid(+)
    AND od.txdate <= to_date(T_DATE,'DD/MM/YYYY')
    AND od.txdate >= to_date(F_DATE,'DD/MM/YYYY')
    AND od.custodycd LIKE v_strCustodycd
    AND od.afacctno LIKE v_strAfacctno
    AND nvl(od.recustid,' ') LIKE v_strRECustid
    AND NVL(c.CUSTID,'a') LIKE v_strCFAfacctno
    AND od.via LIKE V_STRVIA
    AND AF.CAREBY like v_strGRCAREBY
    AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_STRTLID)
    AND (CASE WHEN od.via in ('O','M','K','P','T','B','C') OR (od.via IN ('E','L') AND od.tlid = 'ONLINE') OR (od.isdisposal = 'Y') THEN 'Y' ELSE nvl(c.CONFIRMED,'N') END) LIKE v_strConfirmed --1.5.4.7 MSBS-1824
    AND nvl(c.via,' ') like v_viaconfirmed

UNION all
      SELECT distinct mst.*,
      (CASE WHEN NVL(mst.userid,'a') <> 'a' THEN mst.userid || ' - ' || tl.tlfullname
          WHEN  NVL(mst.cfafacctno,'a') <> 'a' THEN mst.cfafacctno || ' - ' || cf.fullname
          ELSE  mst.custid || '-' || mst.fullname  END) confirmdesc

      FROM
          (SELECT OD.ORDERID,OD.CODEID, A0.CDCONTENT TRADEPLACE, A1.CDCONTENT EXECTYPE,A5.CDCONTENT MATCHTYPE,
            OD.PRICETYPE, A3.CDCONTENT VIA, OD.ORDERQTTY,OD.QUOTEPRICE, OD.REFORDERID,
            se.symbol,
            CASE WHEN od.via in ('O','M','K','P','T','B','C') OR (od.via IN ('E','L') AND od.tlid = systemnums.C_ONLINE_USERID) OR (od.isdisposal = 'Y') OR (OD_MAS.isdisposal = 'Y') THEN 'Y' ELSE nvl(CFMSTS.CONFIRMED,'N') END CONFIRMED, --1.5.4.7 MSBS-1824
            od.afacctno, cf.custodycd, cf.fullname, ' ' ROOTORDERID,
            od.txdate, od.txtime, re.refullname, re1.DFS,od.custid,od.via viaod,
            tl.tlname tlid, CFMSTS.Userid,CFMSTS.custid cfafacctno,
            (CASE WHEN od.via in ('O','M','K','P','T','B','C') OR (od.via IN ('E','L') AND od.tlid = systemnums.C_ONLINE_USERID) OR (od.isdisposal = 'Y') OR (OD_MAS.isdisposal = 'Y') THEN 'Y' ELSE nvl(CFMSTS.CONFIRMED,'N') END) CONFIRMEDVAL,
            nvl(a4.cdcontent,A3.CDCONTENT) via_confirm_name, cfmsts.via via_confirmed
          FROM CONFIRMODRSTS CFMSTS,-- vao truc tiep day cho nhanh
          (SELECT * FROM odmast od
            WHERE od.txdate = V_CRRDATE AND V_CRRDATE = to_date(T_DATE,'DD/MM/YYYY')) OD, SBSECURITIES SE,
          ALLCODE A0, ALLCODE A1, ALLCODE A2, ALLCODE A3,aLLCODE A4,ALLCODE A5,
          afmast af, cfmast cf,
              (select re.afacctno, (cf.fullname) refullname,(cf.custid) recustid, (retype.rerole) rerole, re.frdate, nvl(re.clstxdate-1,re.todate) todate
                    from reaflnk re, cfmast cf,retype
                    where substr(re.reacctno,0,10) = cf.custid
                    and re.deltd <> 'Y'
                    AND substr(re.reacctno,11) = RETYPE.ACTYPE
                    AND rerole IN ( 'RM','BM')
                ) re,
                (select re.afacctno, (cf.fullname) dfs,(cf.custid) recustid, (retype.rerole) rerole, re.frdate, nvl(re.clstxdate-1,re.todate) todate
                    from reaflnk re, cfmast cf,retype
                    WHERE substr(re.reacctno,0,10) = cf.custid
                    AND re.deltd <> 'Y'
                    AND substr(re.reacctno,11) = RETYPE.ACTYPE
                    AND rerole IN ('RD')
                ) re1,
                tlprofiles tl,
                (SELECT * FROM odmast od
                         WHERE od.txdate = V_CRRDATE AND V_CRRDATE = to_date(T_DATE,'DD/MM/YYYY')) OD_MAS

          WHERE CFMSTS.ORDERID(+)=OD.ORDERID
          AND OD.REFORDERID = OD_MAS.ORDERID(+)
          AND OD.CODEID=SE.CODEID
          AND a0.cdtype = 'OD' AND a0.cdname = 'TRADEPLACE' AND a0.cdval = se.tradeplace
          AND A1.cdtype = 'OD' AND A1.cdname = 'EXECTYPE'
          AND A1.cdval =(case when nvl(od.reforderid,'a') <>'a' and OD.EXECTYPE = 'NB' then 'AB'
          when  nvl(od.reforderid,'a') <>'a' and OD.EXECTYPE in ( 'NS','MS') then 'AS'
            else od.EXECTYPE end)
          AND A2.cdtype = 'OD' AND A2.cdname = 'PRICETYPE' AND A2.cdval = OD.PRICETYPE
          AND A5.CDTYPE='OD' AND A5.CDNAME='MATCHTYPE' AND A5.CDVAL=OD.MATCHTYPE
          AND A3.cdtype = 'OD' AND A3.cdname = 'VIA' AND A3.cdval = OD.VIA
          AND a4.cdtype(+) = 'OD' and a4.cdname(+) = 'VIA' AND cfmsts.via = a4.cdval(+)
          and ( (od.exectype in ('NB','NS','MS') AND od.via in ('F','T','O','H','M','K','E','P','B','C')) or (od.exectype  not in ('NB','NS','MS')))
          and od.exectype not in ('AB','AS')
          and od.afacctno=af.acctno and af.custid=cf.custid
          AND od.afacctno = re.afacctno (+) AND od.txdate >= re.frdate(+) AND od.txdate <= re.todate(+)
          AND od.afacctno = re1.afacctno (+) AND od.txdate >= re1.frdate(+) AND od.txdate <= re1.todate(+)
          AND cf.custodycd LIKE v_strCustodycd
          And substr(cf.custodycd,4,1) <> 'P'
          AND af.acctno LIKE v_strAfacctno
          AND nvl(re.recustid,' ') LIKE v_strRECustid
          AND NVL(CFMSTS.CUSTID,'a') LIKE v_strCFAfacctno
          AND (CASE WHEN (nvl(od.reforderid,'a') = 'a' OR od.exectype IN ('CB','CS'))  THEN od.tlid
                    ELSE (SELECT max(tlid) tlid FROM (SELECT * FROM odmast od
                                                        WHERE od.txdate = V_CRRDATE AND V_CRRDATE = to_date(T_DATE,'DD/MM/YYYY')) od2
                           WHERE od2.orderid <> od.orderid AND od.reforderid= od2.reforderid ) END) = tl.tlid
          AND od.via LIKE V_STRVIA
          AND AF.CAREBY like v_strGRCAREBY
          and AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_STRTLID)
          ----
          ) mst, tlprofiles tl,
          cfmast cf
          WHERE mst.userid=tl.tlid(+)
          AND mst.cfafacctno=cf.custid(+)
          AND mst.CONFIRMEDVAL  LIKE v_strConfirmed
          and nvl(mst.via_confirmed,' ') like v_viaconfirmed
    )
    ORDER BY TXDATE, CUSTODYCD, AFACCTNO, TXTIME
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                             
/



-- End of DDL Script for Procedure HOSTUAT.OD0019
