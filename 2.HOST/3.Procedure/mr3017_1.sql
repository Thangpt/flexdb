-- Start of DDL Script for Procedure HOSTUAT.MR3017_1
-- Generated 16/09/2020 5:46:54 PM from HOSTUAT@FLEXUAT

CREATE OR REPLACE 
PROCEDURE mr3017_1 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   pv_OPT            IN       VARCHAR2,
   pv_BRID           IN       VARCHAR2,
   pv_custbank       IN       VARCHAR2,
   pv_CUSTDYCD       IN       VARCHAR2,
   pv_AFACCTNO       IN       VARCHAR2,
   I_DATE            IN       VARCHAR2,
   PV_TLID           IN       VARCHAR2,
   I_TYPE            IN       VARCHAR2

)
IS
---------------------------------------------------------------------------------
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;
---------------------------------------------------------------------------------
   l_STROPTION          VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   l_STRBRID            VARCHAR2 (4);
   l_AFACCTNO           VARCHAR2 (20);
   l_CUSTDYCD           VARCHAR2 (20);
   v_CurrDate           DATE;
   l_custbank           VARCHAR2(10);
   V_TLID               VARCHAR2(4);
   v_IDATE              DATE; --ngay lam viec gan ngay idate nhat

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE

BEGIN
   l_STROPTION := pv_OPT;

   IF (l_STROPTION <> 'A') AND (pv_BRID <> 'ALL')
   THEN
      l_STRBRID := pv_BRID;
   ELSE
      l_STRBRID := '%%';
   END IF;

   V_TLID := PV_TLID;

   IF pv_custbank ='ALL' THEN
      l_custbank:='%%';
      ELSE
        l_custbank:=pv_custbank;
      END IF;

   IF pv_CUSTDYCD ='ALL' THEN
      l_CUSTDYCD:='%%';
      ELSE
        l_CUSTDYCD:=replace(pv_CUSTDYCD,'.','');
      END IF;

   IF pv_AFACCTNO ='ALL' THEN
      l_AFACCTNO:='%%';
      ELSE
        l_AFACCTNO:=replace(pv_AFACCTNO,'.','');
      END IF;

 -- END OF GETTING REPORT'S PARAMETERS

   SELECT max(sbdate) INTO v_IDATE  FROM sbcurrdate WHERE sbtype ='B' AND sbdate <= to_date(I_DATE,'DD/MM/RRRR');

   select to_date(varvalue,'DD/MM/RRRR') into v_CurrDate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';

-- GET REPORT'S DATA

    IF v_idate = v_CurrDate THEN
        IF pv_CUSTDYCD <> 'ALL' THEN
            OPEN PV_REFCURSOR FOR
            SELECT ROOMCHK,v.SYMBOL,v.CODEID,TRADE,MORTAGE,RECEIVING,RECEIVINGT2,TOTALRECEIVING,SELLMATCHQTTY,BUYQTTY,TOTALBUYQTTY,TOTALBUYAMT,AVLSYSROOM,USEDSYSROOM,AVL74ROOM,USED74ROOM,AVLGRPROOM,USEDGRPROOM,
            45 RATECL, CASE WHEN PRICECL = 0 THEN s.marginprice ELSE PRICECL END PRICECL,
            CALLPRICECL,RATE74,PRICE74,CALLPRICE74,TS_SUCMUA,TS_DANHDAU,TS_T2,TS_CALLT2,TS_WITHD,TS_CALL,REALASS,AFACCTNO,v.CUSTODYCD,v.ACCTNO,MRRATIORATE, cf.fullname ,cf.idcode, to_date(I_DATE,'DD/MM/RRRR') ngay_tra_cuu, cf.custodycd so_tai_khoan
            from vw_mr9004 v, cfmast cf, AFMAST AF, securities_info s
            WHERE v.afacctno LIKE  l_AFACCTNO AND v.custodycd LIKE l_CUSTDYCD and cf.custodycd = v.custodycd AND V.AFACCTNO = AF.ACCTNO AND v.codeid = s.codeid
                AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
                AND v.trade + v.mortage + v.receiving + v.receivingt2 + v.totalreceiving + v.sellmatchqtty + v.buyqtty + v.totalbuyqtty > 0
            ORDER BY v.symbol;
        ELSE
            OPEN PV_REFCURSOR FOR
            SELECT ROOMCHK,v.SYMBOL,v.CODEID,TRADE,MORTAGE,RECEIVING,RECEIVINGT2,TOTALRECEIVING,SELLMATCHQTTY,BUYQTTY,TOTALBUYQTTY,TOTALBUYAMT,AVLSYSROOM,USEDSYSROOM,AVL74ROOM,USED74ROOM,AVLGRPROOM,USEDGRPROOM,
            45 RATECL, CASE WHEN PRICECL = 0 THEN s.marginprice ELSE PRICECL END PRICECL,
            CALLPRICECL,RATE74,PRICE74,CALLPRICE74,TS_SUCMUA,TS_DANHDAU,TS_T2,TS_CALLT2,TS_WITHD,TS_CALL,REALASS,AFACCTNO,v.CUSTODYCD,v.ACCTNO,MRRATIORATE, cf.fullname , cf.idcode, to_date(I_DATE,'DD/MM/RRRR') ngay_tra_cuu, cf.custodycd so_tai_khoan
            FROM vw_mr9004 v, cfmast cf, AFMAST AF, securities_info s,
            (
                SELECT  ln.Trfacctno FROM lnmast ln , lnschd chd
                WHERE   ln.acctno=chd.acctno
                    AND ((chd.rlsdate=to_date(I_DATE,'DD/MM/RRRR') AND I_TYPE = 1) OR (I_TYPE = 0 AND chd.ovd + chd.nml >0 ))
                    AND NVL(ln.custbank,'123') = l_custbank
                GROUP BY ln.Trfacctno
            ) LN
            WHERE v.afacctno LIKE  l_AFACCTNO AND v.custodycd LIKE l_CUSTDYCD and cf.custodycd = v.custodycd AND V.AFACCTNO = AF.ACCTNO AND v.codeid = s.codeid
                AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
                AND v.trade + v.mortage + v.receiving + v.receivingt2 + v.totalreceiving + v.sellmatchqtty + v.buyqtty + v.totalbuyqtty > 0
                AND ln.trfacctno=v.afacctno
            ORDER BY v.symbol;
        END IF;
    ELSE
        IF pv_CUSTDYCD <> 'ALL' THEN
            OPEN PV_REFCURSOR
            for
            SELECT v.AUTOID,v.TXDATE,v.AFACCTNO,v.CUSTODYCD,v.T0AMT,MRAMT,DFAMT,TRFBUYAMT_IN,TRFBUYAMT_OVER,TRFBUYAMT_INDAY,SECUREAMT_INDAY,v.MRCRLIMITMAX,BALANCE,DEPOFEEAMT,DFODAMT,AVLADVANCE,v.SYMBOL,v.CODEID,TRADE,MORTAGE,RECEIVING,RECEIVINGT2,TOTALRECEIVING,SELLMATCHQTTY,BUYQTTY,TOTALBUYQTTY,AVLSYSROOM,USEDSYSROOM,AVL74ROOM,USED74ROOM,
            45 RATECL, CASE WHEN PRICECL = 0 THEN s.marginprice ELSE PRICECL END PRICECL,CALLPRICECL,RATE74,PRICE74,CALLPRICE74,TS_SUCMUA,TS_DANHDAU,TS_T2,TS_CALLT2,TS_CALL,REALASS,v.ACCTNO,MRRATIORATE,TS_WITHD,ROOMCHK,AVLGRPROOM,USEDGRPROOM, cf.fullname, cf.idcode, to_date(I_DATE,'DD/MM/RRRR') ngay_tra_cuu,  cf.custodycd so_tai_khoan
            from tbl_mr3007_log  v, cfmast cf, AFMAST AF, (SELECT * FROM securities_info_hist WHERE histdate = v_idate) s
            where v.txdate = v_idate AND v.afacctno LIKE l_AFACCTNO AND v.custodycd LIKE l_CUSTDYCD and cf.custodycd = v.custodycd AND AF.ACCTNO = V.AFACCTNO AND v.codeid = s.codeid
                AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
                and v.trade + v.mortage + v.receiving + v.receivingt2 + v.totalreceiving + v.sellmatchqtty + v.buyqtty + v.totalbuyqtty > 0
            order BY v.symbol;
        ELSE
            OPEN PV_REFCURSOR
            for
            SELECT v.AUTOID,v.TXDATE,v.AFACCTNO,v.CUSTODYCD,v.T0AMT,MRAMT,DFAMT,TRFBUYAMT_IN,TRFBUYAMT_OVER,TRFBUYAMT_INDAY,SECUREAMT_INDAY,v.MRCRLIMITMAX,BALANCE,DEPOFEEAMT,DFODAMT,AVLADVANCE,v.SYMBOL,v.CODEID,TRADE,MORTAGE,RECEIVING,RECEIVINGT2,TOTALRECEIVING,SELLMATCHQTTY,BUYQTTY,TOTALBUYQTTY,AVLSYSROOM,USEDSYSROOM,AVL74ROOM,USED74ROOM,
            45 RATECL, CASE WHEN PRICECL = 0 THEN s.marginprice ELSE PRICECL END PRICECL,CALLPRICECL,RATE74,PRICE74,CALLPRICE74,TS_SUCMUA,TS_DANHDAU,TS_T2,TS_CALLT2,TS_CALL,REALASS,v.ACCTNO,MRRATIORATE,TS_WITHD,ROOMCHK,AVLGRPROOM,USEDGRPROOM, cf.fullname, cf.idcode, to_date(I_DATE,'DD/MM/RRRR') ngay_tra_cuu,  cf.custodycd so_tai_khoan
            from tbl_mr3007_log  v, cfmast cf, AFMAST AF, (SELECT * FROM securities_info_hist WHERE histdate = v_idate) s,
            (
                SELECT mr.afacctno FROM mr5005_log mr,
                (
                    SELECT 1 rls, ln.Trfacctno FROM vw_lnmast_all ln , vw_lnschd_all chd
                    WHERE   ln.acctno=chd.acctno
                        AND chd.rlsdate=to_date(I_DATE,'DD/MM/RRRR')
                        AND NVL(ln.custbank,'123') = l_custbank
                    GROUP BY ln.Trfacctno
                ) LN
                WHERE NVL(mr.custbank,'123') = l_custbank AND mr.rrtype = 'B'
                    AND mr.afacctno = ln.Trfacctno(+)
                    AND ((I_TYPE = 0 AND mr.mrprinamt > 0) OR (nvl(ln.rls,0) = 1 AND I_TYPE = 1))
                    AND mr.txdate = v_idate
                    AND mr.custodycd LIKE l_CUSTDYCD
                    AND mr.afacctno LIKE l_AFACCTNO
            ) mr
            WHERE v.txdate = v_idate AND v.afacctno LIKE l_AFACCTNO AND v.custodycd LIKE l_CUSTDYCD and cf.custodycd = v.custodycd AND AF.ACCTNO = V.AFACCTNO AND v.codeid = s.codeid
                AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
                and v.trade + v.mortage + v.receiving + v.receivingt2 + v.totalreceiving + v.sellmatchqtty + v.buyqtty + v.totalbuyqtty > 0
                AND mr.afacctno=v.afacctno
            ORDER BY v.symbol;
        END IF;

    END IF ;


 EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
/



-- End of DDL Script for Procedure HOSTUAT.MR3017_1

