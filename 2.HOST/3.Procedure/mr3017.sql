CREATE OR REPLACE PROCEDURE mr3017 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   pv_OPT            IN       VARCHAR2,
   pv_BRID           IN       VARCHAR2,
   pv_custbank       IN       VARCHAR2,
   pv_CUSTDYCD       IN       VARCHAR2,
   pv_AFACCTNO       IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   PV_TLID          IN      VARCHAR2

)
IS
---------------------------------------------------------------------------------
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;
---------------------------------------------------------------------------------
   l_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   l_STRBRID          VARCHAR2 (4);
   l_AFACCTNO         VARCHAR2 (20);
   l_CUSTDYCD         VARCHAR2 (20);
/*   l_MRAMT          number(20,0);
   l_T0AMT          number(20,0);
   l_DFAMT          number(20,0);
   l_BALANCE        number(20,0);
   l_DEPOFEEAMT     number(20,0);
   l_DFODAMT        number(20,0);
   l_AVLADVANCE        number(20,0);
   l_MRCRLIMITMAX          number(20,0);
   l_trfbuyamt_in   number(20,0);
   l_trfbuyamt_over number(20,0);
   l_trfbuyamt_inday number(20,0);
   l_secureamt_inday number(20,0);*/
   v_IDATE           DATE; --ngay lam viec gan ngay idate nhat
   v_CurrDate        DATE;
   l_custbank        VARCHAR2(10);
   V_TLID           VARCHAR2(4);
  /* l_NYOVDAMT       number(20,0);*/

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
 --  pr_error('MR3007','l_AFACCTNO:'|| l_AFACCTNO);

 -- END OF GETTING REPORT'S PARAMETERS

   SELECT max(sbdate) INTO v_IDATE  FROM sbcurrdate WHERE sbtype ='B' AND sbdate <= to_date(I_DATE,'DD/MM/RRRR');

   select to_date(varvalue,'DD/MM/RRRR') into v_CurrDate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';
plog.error (pkgctx, 'pv_custbank'||pv_custbank||'v_IDATE'||v_IDATE||'v_CurrDate'||v_CurrDate||'l_AFACCTNO'||l_AFACCTNO);
  IF   v_idate = v_CurrDate THEN
-- GET REPORT'S DATA
    OPEN PV_REFCURSOR
        for
    select v.*
        , cf.fullname , cf.idcode, to_date(I_DATE,'DD/MM/RRRR') ngay_tra_cuu, cf.custodycd so_tai_khoan
    from vw_mr9004 v, cfmast cf, AFMAST AF,
         (SELECT  ln.Trfacctno FROM lnmast ln , lnschd chd
            WHERE   ln.acctno=chd.acctno
          AND chd.rlsdate=to_date(I_DATE,'DD/MM/RRRR')
          AND chd.ovd + chd.nml >0
          AND NVL(ln.custbank,'123')  LIKE l_custbank
          GROUP BY ln.Trfacctno) LN
    where v.afacctno LIKE  l_AFACCTNO AND v.custodycd LIKE l_CUSTDYCD and cf.custodycd = v.custodycd AND V.AFACCTNO = AF.ACCTNO
    AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
    and v.trade + v.mortage + v.receiving + v.receivingt2 + v.totalreceiving + v.sellmatchqtty + v.buyqtty + v.totalbuyqtty > 0
    AND ln.trfacctno=v.afacctno
     order by v.symbol;

ELSE
  -- GET REPORT'S DATA
    OPEN PV_REFCURSOR
        for
    select v.*, cf.fullname, cf.idcode, to_date(I_DATE,'DD/MM/RRRR') ngay_tra_cuu,  cf.custodycd so_tai_khoan
    from tbl_mr3007_log  v, cfmast cf, AFMAST AF,
         (SELECT  ln.Trfacctno FROM lnmast ln , lnschd chd
            WHERE   ln.acctno=chd.acctno
          AND chd.rlsdate=to_date(I_DATE,'DD/MM/RRRR')
          AND chd.ovd + chd.nml >0
          AND NVL(ln.custbank,'123')  LIKE l_custbank
          GROUP BY ln.Trfacctno) LN
    where txdate = v_idate AND v.afacctno LIKE l_AFACCTNO AND v.custodycd LIKE l_CUSTDYCD and cf.custodycd = v.custodycd AND AF.ACCTNO = V.AFACCTNO
    AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
    and v.trade + v.mortage + v.receiving + v.receivingt2 + v.totalreceiving + v.sellmatchqtty + v.buyqtty + v.totalbuyqtty > 0
    AND ln.trfacctno=v.afacctno
   order by v.symbol;

END IF ;


 EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
/

