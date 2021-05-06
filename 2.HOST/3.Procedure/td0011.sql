CREATE OR REPLACE PROCEDURE td0011 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD       IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2,
   PV_TDACCTNO      IN       VARCHAR2

   )
IS

   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_FRDATE         DATE;
   V_TODATE         DATE;
    V_CURRDATE         DATE;
   V_STRCUSTODYCD    VARCHAR2 (10);
   V_STRAFACCTNO    VARCHAR2 (10);
   V_STRTDSRC    VARCHAR2 (1);
   V_STRTDACCTNO VARCHAR2 (20);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN

   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

    -- GET REPORT'S PARAMETERS


   IF(upper(PV_CUSTODYCD) <> 'ALL') THEN
        V_STRCUSTODYCD := trim(upper(PV_CUSTODYCD));
   ELSE
        V_STRCUSTODYCD := '%';
   END IF;

   IF(upper(PV_AFACCTNO) <> 'ALL') THEN
        V_STRAFACCTNO := trim(PV_AFACCTNO);
   ELSE
        V_STRAFACCTNO := '%';
   END IF;

   IF(upper(PV_TDACCTNO) <> 'ALL') THEN
        V_STRTDACCTNO := trim(PV_TDACCTNO);
   ELSE
        V_STRTDACCTNO := '%';
   END IF;



   V_FRDATE := to_date(F_DATE,'dd/mm/RRRR');
   V_TODATE := to_date(T_DATE,'dd/mm/RRRR');

SELECT TO_DATE(VARVALUE,'dd/mm/RRRR') INTO V_CURRDATE FROM SYSVAR WHERE VARNAME = 'CURRDATE';

   -- GET REPORT'S DATA

OPEN PV_REFCURSOR FOR
SELECT
a.txdate, a.afacctno, a.fullname, a.custodycd, a.acctno, a.tltxcd, a.actype,
 /*nvl(b.orgamt, CASE WHEN a.aorgamt - a.printpaid_org - a.intpaid_org <= 0 THEN a.printpaid_org
                    ELSE a.aorgamt - a.printpaid_org - a.intpaid_org END)*/ nvl(b.orgamt,c.orgamt) so_tien_gui,
CASE WHEN a.tltxcd = '1610' AND a.namt = 0 THEN 0
     WHEN a.tltxcd = '1610' AND a.namt <> 0 THEN a.namt
     WHEN a.tltxcd in ('1600','1620') THEN a.namt END goc_rut,
CASE WHEN a.tltxcd = '1610' AND a.namt = 0 THEN 0
     WHEN a.tltxcd = '1610' AND a.namt <> 0 THEN abs(intamt)
     WHEN a.tltxcd in ('1600','1620') THEN abs(intamt) END lai_rut,
 ( case when a.tltxcd = '1600' then
                (case when a.txdate < a.todate and a.txdate >= a.frdate then
                    'Rut mon HTLS '||a.acctno||' tra goc va lai ve tai khoan '||a.afacctno||' lai suat KKH'
                   else 'Rut mon HTLS '||a.acctno||' tra goc va lai ve tai khoan '||a.afacctno||' lai suat '||a.currintrate||' %'
                   end)
               when a.tltxcd = '1610' then
               (
                   case when a.autornd = 'Y' then
                    (case when a.txdate < a.todate and a.txdate >=a.frdate then
                        'Tat toan mon HTLS '||a.acctno||' tra lai ve tai khoan '||a.afacctno||' lai suat KKH'
                      else  'Tat toan mon HTLS '||a.acctno||' tra lai ve tai khoan '||a.afacctno||' lai suat '||a.currintrate||' %'
                      end)
                   else
                     (case when a.txdate < a.todate and a.txdate >=a.frdate then
                     'Tat toan mon HTLS '||a.acctno||' tra goc va lai ve tai khoan '||a.afacctno||' lai suat KKH'
                     else  'Tat toan mon HTLS '||a.acctno||' tra goc va lai ve tai khoan '||a.afacctno||' lai suat '||a.currintrate||' %'
                     end)
                    end
               )
               when a.tltxcd = '1620' then
                    'Rut mon HTLS '||a.acctno||' tra goc ve tai khoan '||a.afacctno
               when a.tltxcd = '1630' then
                    'Gia han mon HTLS ' ||a.acctno|| ' , lai suat '||a.intrate||' %'
               else  to_char(a.txdesc)
          end
        ) txdesc


FROM
(
 select

  td.txdate, td.txnum, td.tltxcd, td.acctno, td.afacctno, td.fullname, td.custodycd,
                td.actype,td.balance, td.orgamt aorgamt , printpaid_org,intpaid_org, /*org_todate,*/td.opndate , td.frdate, td.todate,
                (case when td.schdtype = 'F' then td.intrate else nvl(SCHM.intrate,td.intrate) end) intrate,
                TD.namt NAMT, 0 INTAVLAMT, TD.intpaid intamt, td.txdesc, td.cdcontent,td.autornd
                ,
                (case when td.txdate >= td.todate then
                           (case when td.schdtype = 'F' then td.intrate else nvl(SCHM.intrate,td.intrate) end)
                      else 0 end )    currintrate
FROM
        (
            select tr.txdate, tr.txnum, tr.tltxcd, tr.txdesc, mst.acctno, mst.afacctno, mst.fullname, mst.custodycd,
                  mst.tdtype actype,  mst.orgamt,mst.balance,mst.opndate , MIN(mst.frdate) frdate, min(mst.todate) todate,
                  tr.INTPAID , tr.NAMT namt,   mst.intrate, printpaid_org, intpaid_org, --org_todate,
                  mst.schdtype, mst.tdterm, mst.cdcontent , mst.autornd,mst.flintrate  ,mst.minbrterm,mst.termcd
            from
                 (
                     select td.actype tdtype,-- tl.grpname careby,
                            td.acctno, af.acctno afacctno, cf.fullname, cf.custodycd, td.opndate,
                            td.orgamt, td.balance, td.frdate, td.intrate, -- cf.careby carebyid,
                            td.autornd,td.flintrate,td.minbrterm,td.termcd,
                            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                AND SBDATE >= td.TODATE AND HOLIDAY = 'N') todate, td.todate org_todate,
                            (td.tdterm || ' ' || al.cdcontent) cdcontent, cf.careby carebyid,
                            af.actype aftype, td.schdtype, td.tdterm, printpaid printpaid_org, intpaid intpaid_org
                      from   (select * from tdmast union select * from tdmasthist) td,
                              afmast af,
                              cfmast cf,
                              allcode al -- , tlgroups tl
                     where td.afacctno = af.acctno
                            and af.custid = cf.custid
                            and al.cdtype = 'TD' and al.cdname = 'TERMCD'
                            and td.DELTD <>'Y'
                            and td.termcd = al.cdval
                            --and cf.careby = tl.grpid
                            --AND cf.careby IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_STRCAREBY)
                            and td.acctno LIKE V_STRTDACCTNO and cf.custodycd like V_STRCUSTODYCD
                  )
                  mst,
                  (
                        SELECT TR.ACCTNO, tr.txdate, tr.txnum,
                            sum(case when APP.FIELD = 'BALANCE' then (CASE WHEN APP.TXTYPE = 'D' THEN TR.NAMT ELSE -TR.NAMT END)
                                else 0 end) NAMT,
                            sum(case when APP.FIELD = 'INTPAID' then (CASE WHEN APP.TXTYPE = 'D' THEN TR.NAMT ELSE -TR.NAMT END)
                                else 0 end) INTPAID,
                            tl.txdesc, tl.tltxcd
                        FROM (SELECT * FROM TDTRAN UNION ALL SELECT * FROM TDTRANA) TR,
                            (select * from tllog union all select * from tllogall) tl,
                            V_APPMAP_BY_TLTXCD APP
                        WHERE TR.NAMT > 0 AND tr.DELTD <> 'Y'
                            AND TR.TXNUM = TL.TXNUM
                            AND TR.TXDATE = TL.TXDATE
                            AND APP.tltxcd = TL.TLTXCD
                            AND TR.TXCD = APP.APPTXCD
                            AND APP.FIELD in ('BALANCE','INTPAID')
                            AND APP.APPTYPE = 'TD'
                            AND tr.txdate BETWEEN V_FRDATE and V_TODATE
                            --and tl.tltxcd like V_STRTLTXCD
                            and tr.acctno like V_STRTDACCTNO
                        group by TR.ACCTNO, tr.txdate, tr.txnum, tl.txdesc, tl.tltxcd
                    ) TR
                where mst.acctno = tr.acctno
                      AND CASE WHEN tr.txdate < mst.todate AND tr.txdate > mst.frdate THEN 1
                           WHEN tr.tltxcd = '1610' AND tr.txdate = mst.todate THEN 1
                           WHEN tr.txdate = mst.todate  THEN CASE WHEN tr.tltxcd = '1620' THEN 1
                                                                  WHEN tr.tltxcd = '1600' AND tr.txnum LIKE '99%' THEN 1
                                                                  END
                           WHEN tr.txdate = mst.frdate AND tr.tltxcd = '1600' AND tr.txnum NOT LIKE '99%' THEN 1
                           WHEN tr.tltxcd = '1620' AND tr.txdate = mst.frdate THEN 1
                           ELSE 0 END = 1
                    /*AND CASE --giao dich 1620 luon cua khoan truoc
                             WHEN tr.tltxcd = '1620' AND tr.txdate <= mst.todate AND tr.txdate >= mst.frdate THEN 1
                             --giao dich 1600 trong batch luon cua khoan truoc
                             WHEN tr.tltxcd = '1600' AND tr.txnum LIKE '99%' AND tr.txdate >= mst.frdate AND tr.txdate < mst.todate THEN 1
                             --giao dich 1600 bang tay luon cua khoan sau
                             WHEN tr.tltxcd = '1600' AND tr.txnum NOT LIKE '99%' AND tr.txdate > mst.frdate AND tr.txdate <= mst.todate THEN 1
                             --cac giao dich khac phai dien ra sau ngay bat dau gui
                             WHEN tr.tltxcd NOT IN ('1600','1620') AND mst.frdate < tr.txdate AND mst.todate >= tr.txdate THEN 1
                             --WHEN mst.todate >= tr.txdate AND mst.frdate  < tr.txdate  THEN 1
                             else 0  END = 1*/
                    and mst.acctno like V_STRTDACCTNO
                    and mst.custodycd like V_STRCUSTODYCD
            group BY tr.txdate , tr.txnum, tr.tltxcd, tr.txdesc, mst.acctno, mst.afacctno, mst.fullname, mst.custodycd,
                  mst.tdtype ,  mst.orgamt,mst.balance,mst.opndate , --(mst.frdate) frdate, (mst.todate) todate,
                  tr.INTPAID , tr.NAMT ,   mst.intrate, printpaid_org, intpaid_org,
                  mst.schdtype, mst.tdterm, mst.cdcontent , mst.autornd,mst.flintrate  ,mst.minbrterm,mst.termcd
            order by tr.txnum
        ) TD

        left join

        ( select DISTINCT * from (
            select tdmstschm.refautoid,  tdmstschm.acctno,  tdmstschm.intrate,  framt ,toamt,  frterm,toterm  ,tdmast.frdate ,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                        AND SBDATE >= tdmast.todate AND HOLIDAY = 'N') todate
            from tdmstschm , tdmast, cfmast cf, afmast af
            where tdmstschm.acctno = tdmast.acctno AND cf.custid = af.custid
            and tdmast.acctno  like V_STRTDACCTNO and tdmast.afacctno = af.acctno AND cf.custodycd  like V_STRCUSTODYCD
            union all
            select    tdmstschmhist.refautoid,  tdmstschmhist.acctno,  tdmstschmhist.intrate,  framt ,toamt,  frterm,toterm  ,tdmstschmhist.frdate ,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                        AND SBDATE >= tdmstschmhist.todate AND HOLIDAY = 'N') todate
            from tdmstschmhist
            where tdmstschmhist.acctno like V_STRTDACCTNO )
        )  SCHM

            on td.acctno = SCHM.acctno(+)
            and td.orgamt >= SCHM.framt(+)
            and td.orgamt < SCHM.toamt(+)
            and td.tdterm >= SCHM.FRTERM(+)
            and td.tdterm < SCHM.toterm(+)
            and td.txdate > SCHM.frdate(+)
            and td.txdate <= SCHM.todate(+)
) A,
(SELECT frdate,(SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                AND SBDATE >= td.TODATE AND HOLIDAY = 'N') todate, todate todate_org, orgamt, acctno
 FROM (SELECT * FROM tdmast UNION ALL SELECT * FROM tdmasthist) td WHERE acctno like V_STRTDACCTNO
) B,
(
SELECT txdate, txnum, min(orgamt) orgamt, acctno FROM (SELECT * FROM tdmast UNION ALL SELECT * FROM tdmasthist) td GROUP BY txdate, txnum,  acctno
) C
WHERE a.acctno = b.acctno (+) AND a.frdate = b.todate (+)
AND a.acctno = c.acctno (+)
AND CASE WHEN a.tltxcd = '1610' AND a.namt = 0 THEN 0
     WHEN a.tltxcd = '1610' AND a.namt <> 0 THEN a.namt
     WHEN a.tltxcd in ('1600','1620') THEN a.namt END +
CASE WHEN a.tltxcd = '1610' AND a.namt = 0 THEN 0
     WHEN a.tltxcd = '1610' AND a.namt <> 0 THEN abs(intamt)
     WHEN a.tltxcd in ('1600','1620') THEN abs(intamt) END <> 0
ORDER BY a.txdate, a.custodycd, a.txnum
/*        SELECT TL.MSGACCT,CF.FULLNAME, CI.*, TLFLD.NVALUE ORGAMT, A1.cdcontent, TDP.ACTYPE, TD.description
        FROM (SELECT * FROM vw_citran_gen WHERE txdate between V_FRDATE AND V_TODATE ) CI,
            (SELECT * FROM vw_tllog_all WHERE txdate between V_FRDATE AND V_TODATE ) TL,
            (SELECT * FROM vw_tllogfld_all WHERE FLDCD = '09' and
                txdate between V_FRDATE AND V_TODATE
            ) TLFLD,
            CFMAST CF, TDMAST TD, TDTYPE TDP,
            ALLCODE A1
        WHERE CI.TXDATE=TL.TXDATE AND TL.TXDATE = TLFLD.TXDATE AND CI.TXNUM=TL.TXNUM AND
        TL.TXNUM = TLFLD.TXNUM AND CI.CUSTID = CF.CUSTID
        AND TL.MSGACCT = TD.ACCTNO AND TD.ACTYPE = TDP.ACTYPE
        and ci.deltd <> 'Y'
        AND A1.CDNAME= 'TDSRC'  AND A1.CDVAL=TDP.TDSRC
        AND CI.TLTXCD IN ('1600','1610','1620')
        AND cf.custodycd LIKE V_STRCUSTODYCD
        AND td.afacctno LIKE V_STRAFACCTNO
        AND TD.ACCTNO LIKE V_STRTDACCTNO
        AND CI.TXDATE between V_FRDATE AND V_TODATE
        ORDER BY  CI.TXDATE, CI.CUSTODYCD, CI.ACCTNO,TL.MSGACCT, ci.txnum

        ;
*/

/*SELECT tdr_to.CUSTODYCD, tdr_to.CUSTID, tdr_to.ACCTNO AFACCTNO, tdr_to.fullname, tdr_to.ADDRESS,
TD.TLTXCD ,TD.TXDATE, TD.TXNUM, TDM.ACTYPE, TD.ACCTNO,
case when txtype = 'D' then namt else 0 end TD_DEBIT, case when txtype = 'C' then namt else 0 end TD_CREDIT ,
TD.TXCD,
tdr_to.TONG_GUI, tdr_to.TONG_RUT, tdr_to.TONG_LAI,
TDB.balance + NVL(tdr_cur.TONG_RUT,0) - NVL(tdr_cur.TONG_GUI,0) DAU_KY,
TDB.balance + NVL(tdr_cur.TONG_RUT,0) - NVL(tdr_cur.TONG_GUI,0) - tdr_to.TONG_RUT + tdr_to.TONG_GUI CUOI_KY,
TRDESC
FROM vw_tdtran_all TD, APPTX APP, vw_tdmast_all TDM , (SELECT AFACCTNO,SUM(BALANCE) BALANCE FROM TDMAST GROUP BY AFACCTNO) TDB ,

( -- Tong phat sinh trong FRDATE den TODATE
    SELECT CF.CUSTODYCD, CF.CUSTID, AF.ACCTNO,CF.fullname, CF.ADDRESS, SUM(CASE WHEN TLTXCD in ('1670','1610') AND td.TXCD = '0022' THEN NAMT ELSE 0 END) TONG_GUI,
        SUM(CASE WHEN TLTXCD IN ('1600','1610','1620') AND td.TXCD IN('0023') THEN NAMT ELSE 0 END) TONG_RUT,
        SUM(CASE WHEN TLTXCD IN ('1600','1610') AND td.TXCD = '0026' THEN NAMT ELSE 0 END) TONG_LAI
    FROM vw_tdtran_all td, apptx app,vw_tdmast_all TDM, AFMAST AF, CFMAST CF
    WHERE td.txcd = app.txcd and app.apptype = 'TD'
        AND TD.ACCTNO = TDM.ACCTNO AND TDM.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID
        and TD.txdate >= V_FRDATE AND TD.txdate <= V_TODATE
        AND td.TLTXCD IN ('1600','1610','1670','1620')
        AND td.TXCD IN('0022','0023','0026')
    GROUP BY CF.CUSTODYCD, CF.CUSTID, AF.ACCTNO,CF.fullname, CF.ADDRESS
)  tdr_to
,( -- Tong phat sinh tu FRDATE den ngay hien tai
    SELECT CF.CUSTODYCD, CF.CUSTID, AF.ACCTNO,CF.fullname, CF.ADDRESS, SUM(CASE WHEN TLTXCD in ('1670','1610') AND td.TXCD = '0022' THEN NAMT ELSE 0 END) TONG_GUI,
        SUM(CASE WHEN TLTXCD IN ('1600','1610','1620') AND td.TXCD IN('0023') THEN NAMT ELSE 0 END) TONG_RUT,
        SUM(CASE WHEN TLTXCD IN ('1600','1610') AND td.TXCD = '0026' THEN NAMT ELSE 0 END) TONG_LAI
    FROM vw_tdtran_all td, apptx app,vw_tdmast_all TDM, AFMAST AF, CFMAST CF
    WHERE td.txcd = app.txcd and app.apptype = 'TD'
        AND TD.ACCTNO = TDM.ACCTNO AND TDM.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID
        and TD.txdate >= V_FRDATE AND TD.txdate <= V_CURRDATE
        AND td.TLTXCD IN ('1600','1610','1670','1620')
        AND td.TXCD IN('0022','0023','0026')
    GROUP BY CF.CUSTODYCD, CF.CUSTID, AF.ACCTNO,CF.fullname, CF.ADDRESS

)  tdr_cur


WHERE TD.ACCTNO = TDM.ACCTNO AND TDM.AFACCTNO = TDB.AFACCTNO
    and tdb.afacctno = tdr_to.acctno (+)
    and tdr_to.ACCTNO = tdr_cur.ACCTNO (+)
    AND td.txcd = app.txcd and app.apptype = 'TD'
    and TD.txdate >= V_FRDATE AND TD.txdate <= V_TODATE
    AND tdr_to.custodycd LIKE V_STRCUSTODYCD
    AND tdr_to.acctno LIKE V_STRAFACCTNO
    AND td.TLTXCD IN ('1600','1610','1670','1620')
    AND td.TXCD IN('0022','0023','0026')
AND TD.DELTD <> 'Y' AND namt > 0
ORDER BY TD.TXDATE,tdr_to.CUSTODYCD, tdr_to.ACCTNO, TD.ACCTNO,TD.TXNUM*/
;






EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

