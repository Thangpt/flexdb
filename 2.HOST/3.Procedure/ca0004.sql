CREATE OR REPLACE PROCEDURE ca0004 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   CACODE         IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2,
   PLSENT          IN      VARCHAR2
  )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO TAI KHOAN TIEN TONG HOP CUA NGUOI DAU TU
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- HUNG.LB    23/Aug/2010 UPDATED
-- TRUONGLD MODIFYED 10/04/2010
-- CHAUNH them dk, ten moi gioi 11/05/2012
-- ---------   ------  -------------------------------------------

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    V_STRCACODE    VARCHAR2 (20);
    V_STRAFACCTNO   VARCHAR2 (20);
    V_STRPLSENT       number;

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

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   IF (CACODE <> 'ALL')
   THEN
      V_STRCACODE := CACODE;
   ELSE
      V_STRCACODE := '%%';
   END IF;

      IF (AFACCTNO <> 'ALL')
   THEN
      V_STRAFACCTNO := AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;

   IF(PLSENT = 'ALL' OR PLSENT IS NULL)
    THEN
       V_STRPLSENT := -1; --tat ca
   ELSIF (PLSENT = '01') THEN
       V_STRPLSENT := 0; -- chua dang ky
   else
       V_STRPLSENT := 1; -- da dang ky
   END IF;

   -- GET REPORT'S PARAMETERS

--Tinh ngay nhan thanh toan bu tru


OPEN PV_REFCURSOR
   FOR
    SELECT (CASE WHEN SUBSTR(CA.custodycd,4,1) = 'P' THEN utf8nums.c_const_custodycd_type_p ELSE utf8nums.c_const_custodycd_type_re END) TYPELG_NAME, CA.CUSTTYPE_NAME
            , CA.ISS_NAME, ca.country,
           ca.acctno, ca.custodycd, ca.fullname, ca.address, ca.MOBILE, ca.IDCODE, ca.RIGHTOFFRATE, ca.Catype,ca.status_af status_af,
           ca.status, ca.camastid, ca.amt, ca.symbol, ca.reportdate, ca.stcv, ca.actiondate, NVL(TL.NUM_TRF,0) NUM_TRF
           ,CA.NMQTTY,CA.EXPRICE,
           NVL(TL.NUM_RectrF,0) NUM_RectrF, CA.codeid codeca, tl.codeid codetl,
           --NVL(SLQUYEN.Balance,0) SLSH,
           NVL(SLQUYEN.trade,0) SLSH,
           NVL(TL.SLDKM,0) SLDKM, ca.roundtype, CA.slctm,ca.aamt,
           reaflnk.fullname ten_moi_gioi,
           ca.tocodeid, ca.tosymbol,
           ca.pbalance,
           ca.BRNAME, ca.caREBY --1.5.6.1 MSBS-1896

    FROM (
            SELECT cfmast.fullname, reaflnk.afacctno FROM reaflnk, retype, cfmast
            WHERE retype.actype = substr(reaflnk.reacctno,11,4)
            AND retype.rerole IN ('BM','RM')
            AND reaflnk.status = 'A'
            AND cfmast.custid = substr(reaflnk.reacctno,1,10)
         )reaflnk,
        (
            SELECT  cas.aamt,af.acctno acctno , cf.custodycd custodycd, cf.fullname fullname, cf.MOBILE mobile, (case when cf.country = '234' then cf.idcode else cf.tradingcode end) idcode, cf.country, cf.address,
                    cas.balance SLCKSH, cam.RIGHTOFFRATE rightoffrate, A0.cdcontent Catype, (case when cas.status<>'C' and cas.tqtty >0 then 'Đã thực hiện 3387' else to_char( A1.cdcontent) end  ) status, cam.camastid camastid,
                    cas.AMT AMT, se.symbol symbol, se.codeid codeid, cam.REPORTDATE reportdate, cas.qtty SLQMDNG,cas.NMqtty , cas.amt STCV, CAS.PQTTY SLQMDPB,
                    cam.ACTIONDATE actiondate, cas.PBALANCE PBALANCE, cam.optcodeid optcodeid, cam.roundtype, AF.status status_af, CAM.EXPRICE,
                    (cas.PQTTY+cas.QTTY) slctm, a2.cdcontent  AS CUSTTYPE_NAME, SE.ISS_NAME,
                    nvl(sb2.symbol,se.symbol) tosymbol, nvl(sb2.codeid,se.codeid) tocodeid, cas.autoid,
                    cf.brid,cf.brid || ' - ' || brgrp.brname BRNAME, cf.careby || ' - ' || tlgroups.grpname CAREBY --1.5.6.1 MSBS-1896
            FROM caschd cas, (SELECT ISSUERS.FULLNAME ISS_NAME, SB.* from SBSECURITIES SB, ISSUERS  WHERE SB.ISSUERID = ISSUERS.ISSUERID) se,
                 camast cam, afmast af, cfmast cf, allcode A0, Allcode A1, allcode a2,
                 sbsecurities sb2,
                 brgrp, tlgroups --1.5.6.1 MSBS-1896
            WHERE cas.codeid = se.codeid
            AND nvl(cam.tocodeid, cas.codeid) = sb2.codeid
            AND cam.camastid = cas.camastid
            AND cas.afacctno = af.acctno
            AND af.custid = cf.custid
            AND a0.CDTYPE = 'CA' AND a0.CDNAME = 'CATYPE' AND a0.CDVAL = cam.CATYPE
            AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS' AND A1.CDVAL = cas.STATUS
            AND A2.CDTYPE = 'CF' AND A2.CDNAME = 'CUSTTYPE' AND A2.CDVAL = cf.CUSTTYPE
            AND cam.catype ='014'
            and cas.afacctno like V_STRAFACCTNO
            AND cam.camastid LIKE V_STRCACODE
            --AND (af.brid LIKE V_STRBRID or instr(V_STRBRID,af.brid) <> 0)
            AND CAS.deltd<>'Y'
            AND cf.brid = brgrp.brid AND cf.careby = tlgroups.grpid --1.5.6.1 MSBS-1896
        ) CA,
        (
           SELECT Sum(NVL(Num_trf,0)) NUM_TRF, sum(NVL(num_rectrf,0)) NUM_RectrF, sum(NVL(SLDKM,0)) SLDKM,  acctno, codeid, autoid FROM
            (
               SELECT    substr(se.acctno,1,10) acctno, substr(se.acctno,11,6) codeid,
                        CASE WHEN tl.tltxcd in ( '3382','3383','3392') AND SE.TXCD IN('0040') then SE.NAMT
                             WHEN tl.tltxcd IN ('3392','3353') AND se.txcd IN ('0045') THEN - se.namt
                             ELSE 0 END  Num_trf,
                        CASE WHEN tl.tltxcd = '3385' AND se.txcd = '0045' THEN SE.NAMT
                             WHEN tl.tltxcd = '3382' AND se.txtype = 'C' THEN se.namt
                             WHEN tl.tltxcd = '3392' AND se.txtype = 'D' THEN -se.namt
                             ELSE 0 END  Num_rectrf, 0 SLDKM, se.acctref autoid
                FROM vw_TLLOG_all TL, vw_SETRAN_gen SE
                WHERE TL.TXNUM = SE.TXNUM AND TL.TXDATE = SE.TXDATE
                AND TL.DELTD <> 'Y' AND TL.TLTXCD IN( '3382','3383','3392','3353','3385')
                AND SE.TXCD IN('0040','0045')
               --3384
                UNION ALL
              SELECT  CA.AFACCTNO acctno  ,CAMAST.optcodeid  codeid , 0 Num_trf, 0 Num_rectrf,  SUM(CA.QTTY + CA.SENDQTTY + CA.CUTQTTY)  SLDKM, to_char(ca.autoid) autoid
              FROM caschd CA , CAMAST
              WHERE CAMAST.camastid  = CA.camastid AND CAMAST.catype ='014'AND CA.QTTY + CA.SENDQTTY + CA.CUTQTTY >0 GROUP BY CA.AFACCTNO  ,CAMAST.optcodeid, ca.autoid
            )GROUP BY acctno, codeid, autoid
        )TL,
        ( -- Begin SLQuyen
            select (mst.BALANCE -nvl(AMT.amt,0))balance , mst.acctno, mst.CODEID ,MST.CAMASTID, mst.autoid, mst.trade  from
            (
                   SELECT (CAS.PBALANCE + CAS.BALANCE ) BALANCE, CAS.AFACCTNO ACCTNO, CAM.CODEID CODEID, CAM.CAMASTID CAMASTID, CAM.OPTCODEID, cas.autoid, cas.trade
                   FROM  CAMAST CAM, CASCHD CAS  WHERE  CAS.CAMASTID = CAM.CAMASTID AND  CAS.DELTD <>'Y'
             )mst,
             (
                   SELECT SUBSTR (AMT.ACCTNO,1,10) AFACCTNO , SUBSTR (AMT.ACCTNO,11,6)CODEID , SUM (AMT.AMT) AMT, AMT.acctref
                   FROM
                          (
                          SELECT  SE.ACCTNO ,(CASE WHEN APP.TXTYPE = 'D'THEN -SE.NAMT WHEN APP.TXTYPE = 'C' THEN SE.NAMT ELSE 0  END ) AMT, se.acctref
                                 FROM TLLOG TL, SETRAN SE, APPTX APP
                                 WHERE TL.TXNUM = SE.TXNUM AND TL.TXDATE = SE.TXDATE
                                 AND SE.TXCD = APP.TXCD AND TL.DELTD <> 'Y' AND TL.TLTXCD IN( '3382','3383','3385','3392','3353')
                                 AND SE.TXCD IN('0045','0040') AND APP.apptype ='SE'

                                 UNION ALL

                                 SELECT  SE.ACCTNO ,(CASE WHEN APP.TXTYPE = 'D'THEN -SE.NAMT WHEN APP.TXTYPE = 'C' THEN SE.NAMT ELSE 0  END ) AMT, se.acctref
                                 FROM TLLOGALL TL, SETRANA SE, APPTX APP
                                 WHERE TL.TXNUM = SE.TXNUM AND TL.TXDATE = SE.TXDATE
                                 AND SE.TXCD = APP.TXCD AND TL.DELTD <> 'Y' AND TL.TLTXCD IN( '3382','3383','3385', '3392','3353')
                                 AND SE.TXCD IN('0045','0040')AND APP.apptype ='SE'
                               )AMT

                            GROUP BY AMT.ACCTNO, AMT.acctref
                  )AMT
          where  mst.ACCTNO = AMT.AFACCTNO(+) AND  MST.OPTCODEID = AMT.CODEID(+) AND mst.autoid = amt.acctref(+)

        )SLQuyen
    WHERE CA.camastid LIKE V_STRCACODE
    AND ca.acctno = reaflnk.afacctno (+)
    AND  CA.acctno = TL.acctno (+)
    AND CA.optcodeid = TL.codeid (+)
    AND ca.autoid = TL.autoid (+)
    AND CA.camastid = SLQuyen.camastid
    AND CA.acctno = SLQuyen.acctno
    AND CA.autoid = SLQuyen.autoid
    --AND (ca.brid LIKE V_STRBRID or instr(V_STRBRID,ca.brid) <> 0) --1.5.6.1 MSBS-1896
    AND CASE WHEN  NVL(SLQUYEN.Balance,0)-NVL(TL.NUM_TRF,0)+NVL(TL.NUM_RectrF,0) > 0 AND  V_STRPLSENT = 0 AND  ca.aamt = 0 THEN 1
             WHEN  NVL(SLQUYEN.Balance,0)-NVL(TL.NUM_TRF,0)+NVL(TL.NUM_RectrF,0) > 0 AND  V_STRPLSENT = 1 AND  ca.aamt > 0 THEN 1
             WHEN  V_STRPLSENT = -1 THEN 1
        ELSE 0
        END = 1
    ORDER  BY ca.acctno


  ;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END; 
/
                                                             -- PROCEDURE
/
