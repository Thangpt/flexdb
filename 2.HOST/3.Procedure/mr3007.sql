CREATE OR REPLACE PROCEDURE mr3007 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   pv_OPT            IN       VARCHAR2,
   pv_BRID           IN       VARCHAR2,
   pv_CUSTDYCD       IN       VARCHAR2,
   pv_AFACCTNO       IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   PV_TLID          IN      VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- LINHLNB   11-Apr-2012  CREATED
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

-- ---------   ------  -------------------------------------------
   l_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   l_STRBRID          VARCHAR2 (4);
   l_AFACCTNO         VARCHAR2 (20);
   l_MRAMT          number(20,0);
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
   l_secureamt_inday number(20,0);
   v_IDATE           DATE; --ngay lam viec gan ngay idate nhat
   v_CurrDate        DATE;
   V_TLID           VARCHAR2(4);
   l_NYOVDAMT       number(20,0);
   l_intnmlpbl      number(20,0);
   v_count          NUMBER;
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


   l_AFACCTNO  := replace(pv_AFACCTNO,'.','');
 --  pr_error('MR3007','l_AFACCTNO:'|| l_AFACCTNO);

 -- END OF GETTING REPORT'S PARAMETERS

   SELECT max(sbdate) INTO v_IDATE  FROM sbcurrdate WHERE sbtype ='B' AND sbdate <= to_date(I_DATE,'DD/MM/RRRR');

   select to_date(varvalue,'DD/MM/RRRR') into v_CurrDate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';
  -- TIEN HOLD TRA NO BAO LANH
       BEGIN
          SELECT nvl(SUM( gpamt+remaingpamt ),0)INTO l_NYOVDAMT FROM (select  * from  ln_gp_loghist union all select  * from  ln_gp_log)
          WHERE ACCTNO = l_AFACCTNO AND log_date =to_date(I_DATE,'DD/MM/RRRR');

       EXCEPTION   WHEN OTHERS   THEN
       l_NYOVDAMT:=0;
       END ;

   IF v_idate = v_CurrDate THEN
       select nvl(sum(t0amt),0), nvl(sum(marginamt),0) into l_T0AMT,l_MRAMT  from vw_lngroup_all where trfacctno = l_AFACCTNO;

       select nvl(sum(intnmlpbl),0) into l_intnmlpbl
       from lnmast where trfacctno = l_AFACCTNO and ftype <> 'DF';

       select nvl(sum(prinnml+prinovd+intnmlacr+intnmlovd+intovdacr+intdue+feeintnmlacr+feeintnmlovd+feeintovdacr+feeintdue),0) ,
              nvl(sum(prinnml+prinovd),0) into  l_DFAMT,l_DFODAMT
       from lnmast where trfacctno = l_AFACCTNO and ftype = 'DF';

       select nvl(sum(trfbuyamt_in),0), nvl(sum(trfbuyamt_over),0)
        into l_trfbuyamt_in, l_trfbuyamt_over
       from v_getbuyorderinfo
       where afacctno = l_AFACCTNO;

       select nvl(sum(trfsecuredamt_inday+trft0amt_inday),0),nvl(sum(secureamt_inday),0)
            into l_trfbuyamt_inday, l_secureamt_inday
       from vw_trfbuyinfo_inday
       where afacctno = l_AFACCTNO;


       select mrcrlimitmax into l_MRCRLIMITMAX
       from afmast af
       where af.acctno = l_AFACCTNO;

       select balance, depofeeamt into l_BALANCE, l_DEPOFEEAMT--, l_DFODAMT  , dfodamt
       from cimast
       where acctno = l_AFACCTNO;

       select nvl(sum(depoamt),0) into l_AVLADVANCE
       from v_getaccountavladvance
       where afacctno = l_AFACCTNO;


        --l_NYOVDAMT:=0;
   ELSE





        l_T0AMT:=0;
        l_MRAMT:=0;
        l_DFAMT:=0;
        l_trfbuyamt_in :=0;
       l_trfbuyamt_over:=0;
       l_trfbuyamt_inday:=0;
       l_secureamt_inday:=0;
       l_MRCRLIMITMAX:=0;
       l_BALANCE:=0;
       l_DEPOFEEAMT:=0;
       l_DFODAMT:=0;
       l_AVLADVANCE:=0;

   END IF ;

IF   v_idate = v_CurrDate THEN
  SELECT COUNT(acctno) INTO v_count FROM semast WHERE afacctno = l_AFACCTNO;
  IF v_count > 0 THEN
-- GET REPORT'S DATA
    OPEN PV_REFCURSOR
        for
    select a1.cdcontent roomchk,
       v.symbol,
       v.codeid,
       v.trade,
       v.mortage,
       v.receiving,
       v.receivingt2,
       v.totalreceiving,
       v.sellmatchqtty,
       v.buyqtty,
       v.totalbuyqtty,
       v.totalbuyamt,
       decode(v.roomchk,'Y',v.avlsysroom,v.avlgrproom) avlsysroom,
       decode(v.roomchk,'Y',v.usedsysroom,v.usedgrproom) usedsysroom,
       v.avl74room,
       v.used74room,
       v.ratecl,
       v.pricecl,
       v.callpricecl,
       v.rate74,
       v.price74,
       v.callprice74,
       v.ts_sucmua,
       v.ts_danhdau,
       v.ts_t2,
       v.ts_callt2,
       v.ts_withd,
       v.ts_call,
       v.realass,
       v.afacctno,
       v.custodycd,
       v.acctno,
       v.mrratiorate,
        l_MRCRLIMITMAX MRCRLIMITMAX,round(l_T0AMT) T0AMT, round(l_MRAMT) MRAMT, l_DFAMT DFAMT,
        l_trfbuyamt_in TRFBUYAMT_IN, l_trfbuyamt_over TRFBUYAMT_OVER, l_trfbuyamt_inday TRFBUYAMT_INDAY, l_secureamt_inday SECUREAMT_INDAY,
        l_BALANCE BALANCE, l_AVLADVANCE AVLADVANCE, l_DEPOFEEAMT DEPOFEEAMT, l_DFODAMT DFODAMT, l_intnmlpbl l_intnmlpbl
        , cf.fullname , cf.idcode, to_date(I_DATE,'DD/MM/RRRR') ngay_tra_cuu, pv_CUSTDYCD so_tai_khoan,l_NYOVDAMT NYOVDAMT
    from vw_mr9004 v, cfmast cf, AFMAST AF, allcode a1
    where v.afacctno = l_AFACCTNO and cf.custodycd = v.custodycd AND V.AFACCTNO = AF.ACCTNO
    AND a1.cdname = 'ROOMCHK' AND nvl(v.roomchk,'Y') = a1.cdval AND cdtype = 'MR'
    AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
    -- 1.5.7.6|iss:2016
    --and v.trade + v.mortage + v.receiving + v.receivingt2 + v.totalreceiving + v.sellmatchqtty + v.buyqtty + v.totalbuyqtty + l_T0AMT + l_MRAMT + l_DFAMT > 0
    order by v.symbol;
  ELSE
    -- GET REPORT'S DATA
    OPEN PV_REFCURSOR
        for
    select '' roomchk,
       '' symbol,
       '' codeid,
       0 trade,
       0 mortage,
       0 receiving,
       0 receivingt2,
       0 totalreceiving,
       0 sellmatchqtty,
       0 buyqtty,
       0 totalbuyqtty,
       0 totalbuyamt,
       0 avlsysroom,
       0 usedsysroom,
       0 avl74room,
       0 used74room,
       0 ratecl,
       0 pricecl,
       0 callpricecl,
       0 rate74,
       0 price74,
       0 callprice74,
       0 ts_sucmua,
       0 ts_danhdau,
       0 ts_t2,
       0 ts_callt2,
       0 ts_withd,
       0 ts_call,
       0 realass,
       af.acctno afacctno,
       cf.custodycd,
       '' acctno,
       0 mrratiorate,
        l_MRCRLIMITMAX MRCRLIMITMAX,round(l_T0AMT) T0AMT, round(l_MRAMT) MRAMT, l_DFAMT DFAMT,
        l_trfbuyamt_in TRFBUYAMT_IN, l_trfbuyamt_over TRFBUYAMT_OVER, l_trfbuyamt_inday TRFBUYAMT_INDAY, l_secureamt_inday SECUREAMT_INDAY,
        l_BALANCE BALANCE, l_AVLADVANCE AVLADVANCE, l_DEPOFEEAMT DEPOFEEAMT, l_DFODAMT DFODAMT, l_intnmlpbl l_intnmlpbl
        , cf.fullname , cf.idcode, to_date(I_DATE,'DD/MM/RRRR') ngay_tra_cuu, pv_CUSTDYCD so_tai_khoan,l_NYOVDAMT NYOVDAMT
    from cfmast cf, AFMAST AF
    where AF.ACCTNO = l_AFACCTNO
    AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID);
  END IF;
ELSE
  -- GET REPORT'S DATA
    OPEN PV_REFCURSOR
        for
    select a1.cdcontent roomchk,
        v.AUTOID,
        v.TXDATE,
        v.AFACCTNO,
        v.CUSTODYCD,
        v.T0AMT,
        v.MRAMT,
        v.DFAMT,
        v.TRFBUYAMT_IN,
        v.TRFBUYAMT_OVER,
        v.TRFBUYAMT_INDAY,
        v.SECUREAMT_INDAY,
        v.MRCRLIMITMAX,
        v.BALANCE,
        v.DEPOFEEAMT,
        v.DFODAMT,
        v.AVLADVANCE,
        v.SYMBOL,
        v.CODEID,
        v.TRADE,
        v.MORTAGE,
        v.RECEIVING,
        v.RECEIVINGT2,
        v.TOTALRECEIVING,
        v.SELLMATCHQTTY,
        v.BUYQTTY,
        v.TOTALBUYQTTY,
        decode(nvl(v.roomchk,'Y'),'Y',v.avlsysroom,v.avlgrproom) avlsysroom,
        decode(nvl(v.roomchk,'Y'),'Y',v.usedsysroom,v.usedgrproom) usedsysroom,
        v.AVL74ROOM,
        v.USED74ROOM,
        v.RATECL,
        v.PRICECL,
        v.CALLPRICECL,
        v.RATE74,
        v.PRICE74,
        v.CALLPRICE74,
        v.TS_SUCMUA,
        v.TS_DANHDAU,
        v.TS_T2,
        v.TS_CALLT2,
        v.TS_CALL,
        v.REALASS,
        v.ACCTNO,
        v.MRRATIORATE,
        v.TS_WITHD,
        cf.fullname, cf.idcode, to_date(I_DATE,'DD/MM/RRRR') ngay_tra_cuu, pv_CUSTDYCD so_tai_khoan,l_NYOVDAMT  NYOVDAMT, l_intnmlpbl l_intnmlpbl
    from tbl_mr3007_log  v, cfmast cf, AFMAST AF, allcode a1
    where txdate = v_idate AND v.afacctno = l_AFACCTNO and cf.custodycd = v.custodycd
    AND AF.ACCTNO = V.AFACCTNO AND a1.cdname = 'ROOMCHK' AND nvl(v.roomchk,'Y') = a1.cdval AND cdtype = 'MR'
    AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
    -- 1.5.7.6|iss:2016
    --and v.trade + v.mortage + v.receiving + v.receivingt2 + v.totalreceiving + v.sellmatchqtty + v.buyqtty + v.totalbuyqtty + v.T0AMT + V.MRAMT + v.DFAMT >0
    order by v.symbol;

END IF ;


 EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
/

