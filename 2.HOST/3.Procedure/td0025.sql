CREATE OR REPLACE PROCEDURE td0025(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTODYCD       IN       VARCHAR2,
   TLTXCD         IN       VARCHAR2,
   ACCTNO         IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- Bao cao tinh trang no qua han
-- PERSON           DATE        COMMENTS
-- DUNGNH       24-MAR-2011     CREATED
-- CUONGTD      19-JUL-2011     MODIFIED
-- CHAUNH       16-NOV-2012     repaired many things, carefull when change order of case when
-- ---------       ------   -------------------------------------------
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_FROMDATE       DATE;
   V_TODATE         DATE;
   V_CUSTODYCD    VARCHAR2 (10);
   V_STRACCTNO      VARCHAR2 (30);
   V_STRTLTXCD      VARCHAR2 (10);

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

   if(upper(CUSTODYCD) <> 'ALL') then
        V_CUSTODYCD :=  CUSTODYCD;
   else
        V_CUSTODYCD := '%';
   end if;

   if(upper(ACCTNO) <> 'ALL') then
        V_STRACCTNO := ACCTNO;
   else
        V_STRACCTNO := '%';
   end if;

   if(upper(TLTXCD) <> 'ALL') then
        V_STRTLTXCD := TLTXCD;
   else
        V_STRTLTXCD := '%';
   end if;

   V_FROMDATE := to_date(F_DATE,'dd/mm/yyyy');
   V_TODATE := to_date(T_DATE,'dd/mm/yyyy');

   -- GET REPORT'S DATA
OPEN PV_REFCURSOR
       FOR

SELECT opndate, txdate, txnum, tltxcd, acctno, afacctno, fullname,actype, msgamt, frdate, todate,intrate,NAMT,INTAVLAMT,intamt, custodycd,
        ( case when a.tltxcd = '1600' then
                (case when txdate < todate and txdate >= frdate then
                    'Tat toan mon HTLS '||acctno||' tra goc va lai ve tai khoan '||afacctno||' lai suat KKH'
                   else 'Tat toan mon HTLS '||acctno||' tra goc va lai ve tai khoan '||afacctno||' lai suat '||currintrate||' %'
                   end)
               when a.tltxcd = '1610' then
               (
                   case when autornd = 'Y' then
                    (case when txdate < todate and txdate >=frdate then
                        'Tat toan mon HTLS '||acctno||' tra lai ve tai khoan '||afacctno||' lai suat KKH'
                      else  'Tat toan mon HTLS '||acctno||' tra lai ve tai khoan '||afacctno||' lai suat '||currintrate||' %'
                      end)
                   else
                     (case when txdate < todate and txdate >=frdate then
                     'Tat toan mon HTLS '||acctno||' tra goc va lai ve tai khoan '||afacctno||' lai suat KKH'
                     else  'Tat toan mon HTLS '||acctno||' tra goc va lai ve tai khoan '||afacctno||' lai suat '||currintrate||' %'
                     end)
                    end
               )
               when a.tltxcd = '1620' then
                    'Tat toan mon HTLS '||acctno||' tra goc ve tai khoan '||afacctno
               when a.tltxcd = '1630' then
                    'Gia han mon HTLS ' ||acctno|| ' , lai suat '||intrate||' %'
               else  to_char(a.txdesc)
          end
        ) txdesc,
        cdcontent

FROM
(--1670
    select td.txdate, td.txnum, td.tltxcd, td.acctno, td.afacctno, td.fullname, td.custodycd, td.actype, td.msgamt, td.opndate , td.frdate, td.todate,
           (case when td.schdtype = 'F' then td.intrate else nvl(SCHM.intrate,td.intrate) end) intrate,
           0 NAMT,
           (
                CASE WHEN td.todate > V_TODATE then  round(td.msgamt*(td.todate-td.frdate)*
                (case when td.schdtype = 'F' then td.intrate  else nvl(SCHM.intrate,td.intrate) end)/(100*360))
                 else 0 end
           ) INTAVLAMT,
           0 intamt, td.txdesc txdesc, td.cdcontent, td.autornd,
           0 currintrate
    from
        (
            select tl.txdate, tl.txnum, tl.tltxcd, TD.acctno, td.afacctno, cf.fullname, cf.custodycd,
                   td.actype, tl.msgamt, td.opndate , td.frdate, td.todate, td.intrate, td.tdterm,td.autornd,
                   td.orgamt, td.schdtype, tl.txdesc, (td.tdterm || ' ' || al.cdcontent) cdcontent
            from
                (
                    SELECT * FROM TLLOG WHERE TLTXCD = '1670' and txdate BETWEEN V_FROMDATE and V_TODATE
                    and DELTD <> 'Y' --and tltxcd like V_STRTLTXCD
                    UNION ALL
                    SELECT * FROM TLLOGALL WHERE TLTXCD = '1670' and txdate BETWEEN V_FROMDATE and V_TODATE
                    and DELTD <> 'Y' -- and tltxcd like V_STRTLTXCD
                ) TL,
                (
                   select td.txdate, td.txnum, td.acctno, td.afacctno, td.actype, td.autornd,td.orgamt, td.balance , td.opndate, td.frdate,
                        td.todate, td.intrate , td.tdterm, td.schdtype, td.termcd
                    from
                    (
                        select tdmast.txdate, tdmast.txnum, tdmast.acctno, tdmast.afacctno, tdmast.actype, tdmast.orgamt, tdmast.balance, tdmast.opndate,tdmast.deltd,
                            tdmast.frdate, (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                    AND SBDATE >= TODATE AND HOLIDAY = 'N') todate, tdmast.intrate, tdmast.tdterm, tdmast.schdtype, tdmast.termcd , tdmast.autornd
                        from tdmast, cfmast cf, afmast af  where tdmast.acctno like V_STRACCTNO AND cf.custid = af.custid and afacctno = af.acctno AND cf.custodycd like V_CUSTODYCD
                        union all
                        select tdmasthist.txdate, tdmasthist.txnum, tdmasthist.acctno, tdmasthist.afacctno, tdmasthist.actype, tdmasthist.orgamt, tdmasthist.balance, tdmasthist.opndate,tdmasthist.deltd,
                            tdmasthist.frdate, (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                    AND SBDATE >= TODATE AND HOLIDAY = 'N') todate, tdmasthist.intrate, tdmasthist.tdterm, tdmasthist.schdtype, tdmasthist.termcd , tdmasthist.autornd
                        from tdmasthist, cfmast cf, afmast af  where af.custid = cf.custid AND tdmasthist.acctno like V_STRACCTNO and afacctno = af.acctno AND cf.custodycd like V_CUSTODYCD
                    ) td where td.deltd <>'Y' and opndate = frdate
                ) TD,
                afmast af,
                cfmast cf,
                allcode al
            where tl.txnum = td.txnum
                and tl.txdate = td.txdate
                and td.afacctno = af.acctno
                and af.custid = cf.custid
                and td.acctno like V_STRACCTNO
                and cf.custodycd like V_CUSTODYCD
                and al.cdtype = 'TD' and al.cdname = 'TERMCD'
                and td.termcd = al.cdval

                --AND CF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_STRCAREBY)
        ) td

    left join

        ( select DISTINCT * from (
             select tdmstschm.refautoid,  tdmstschm.acctno,  tdmstschm.intrate,  framt ,toamt,  frterm,toterm  ,tdmast.frdate ,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                        AND SBDATE >= tdmast.todate AND HOLIDAY = 'N') todate
            from tdmstschm , tdmast , cfmast cf, afmast af
            where tdmstschm.acctno = tdmast.acctno AND cf.custid = af.custid
            and tdmast.acctno like V_STRACCTNO  and tdmast.afacctno = af.acctno AND cf.custodycd like V_CUSTODYCD
            union all
            select    tdmstschmhist.refautoid,  tdmstschmhist.acctno,  tdmstschmhist.intrate,  framt ,toamt,  frterm,toterm  ,tdmstschmhist.frdate ,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                        AND SBDATE >= tdmstschmhist.todate AND HOLIDAY = 'N') todate
            from tdmstschmhist
            where tdmstschmhist.acctno like V_STRACCTNO)
        )
                SCHM

        on td.acctno = SCHM.acctno(+)
        and td.orgamt >= SCHM.framt(+)
        and td.orgamt < SCHM.toamt(+)
        and td.tdterm >= SCHM.FRTERM(+)
        and td.tdterm < SCHM.toterm(+)
        and td.txdate >= SCHM.frdate(+)
        and td.txdate < SCHM.todate(+)


    UNION ALL
--1600
        select  td.txdate, td.txnum, td.tltxcd, td.acctno, td.afacctno, td.fullname, td.custodycd,
                td.actype, org msgamt,td.opndate , td.frdate, td.todate,
                (case when td.schdtype = 'F' then td.intrate else nvl(SCHM.intrate,td.intrate) end) intrate,
                TD.namt NAMT, 0 INTAVLAMT, TD.intpaid intamt, td.txdesc, td.cdcontent,td.autornd,
                (case when td.txdate >= td.todate then
                           (case when td.schdtype = 'F' then td.intrate else nvl(SCHM.intrate,td.intrate) end)
                      else 0 end )    currintrate
        FROM
        ( SELECT txdate, txnum, tltxcd, txdesc, acctno, afacctno, fullname,
                custodycd, actype, opndate, min(frdate) frdate, min(todate) todate,
                intpaid, namt, intrate, orgamt, schdtype, min(tdterm) tdterm, min(cdcontent) cdcontent, autornd, flintrate, minbrterm, termcd,
                org
         FROM

          (  select tr.txdate, tr.txnum, tr.tltxcd, tr.txdesc, mst.acctno, mst.afacctno, mst.fullname, mst.custodycd,
                  mst.tdtype actype,  mst.opndate , mst.frdate frdate, mst.todate todate,
                  tr.INTPAID intpaid, tr.NAMT namt,   mst.intrate, main.msgamt orgamt,
                  mst.schdtype, mst.tdterm, mst.cdcontent , mst.autornd,mst.flintrate  ,mst.minbrterm,mst.termcd,
                  main.msgamt  - sum(div.namt) org
            from
                 (
                     select td.actype tdtype,-- tl.grpname careby,
                            td.acctno, af.acctno afacctno, cf.fullname, cf.custodycd, td.opndate,
                            td.orgamt, td.balance, td.frdate, td.intrate, -- cf.careby carebyid,
                            td.autornd,td.flintrate,td.minbrterm,td.termcd,
                            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                AND SBDATE >= td.TODATE AND HOLIDAY = 'N') todate,
                            (td.tdterm || ' ' || al.cdcontent) cdcontent, cf.careby carebyid,
                            af.actype aftype, td.schdtype, td.tdterm
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
                            and td.acctno LIKE V_STRACCTNO and cf.custodycd like V_CUSTODYCD
                  )
                  mst,
                  (
                        SELECT TR.ACCTNO, tr.txdate, tr.txnum,
                            sum(case when APP.FIELD = 'BALANCE' then (CASE WHEN APP.TXTYPE = 'D' THEN TR.NAMT ELSE -TR.NAMT END)
                                else 0 end) NAMT,
                            sum(case when APP.FIELD = 'INTPAID' then (CASE WHEN APP.TXTYPE = 'D' THEN -TR.NAMT ELSE TR.NAMT END)
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
                            AND tr.txdate BETWEEN V_FROMDATE and V_TODATE
                            --and tl.tltxcd like V_STRTLTXCD
                            and tr.acctno like V_STRACCTNO
                        group by TR.ACCTNO, tr.txdate, tr.txnum, tl.txdesc, tl.tltxcd
                    ) TR,
                    --so tien goc ban dau
                    (SELECT tl.msgamt, td.acctno FROM vw_tllog_all tl, tdmast td
                        WHERE tltxcd = '1670' AND td.txdate = tl.txdate AND td.txnum = tl.txnum AND tl.msgacct = td.afacctno
                        AND td.acctno like V_STRACCTNO
                    ) main,
                    -- tinh so luong tien thay doi qua tung giao dich
                    (
                    SELECT a.msgacct, a.txdate, a.txnum, a.tltxcd,
                           CASE WHEN ty.intduecd = 'N' THEN a.namt
                                ELSE
                                (
                                CASE --giao dich 1610 tat toan toan bo hoac nhap lai vao goc, neu balance = 0 thi la nhap lai vao goc
                                    WHEN a.tltxcd = '1610' AND a.namt = 0 THEN -a.INTPAID
                                    WHEN a.tltxcd = '1610' AND a.namt <> 0 THEN a.namt
                                    --giao 1600 lai khong bi tru vao goc nen khong tinh goc
                                    WHEN a.tltxcd = '1600' THEN a.namt
                                --cac giao dich rut tien khac
                                    ELSE a.NAMT + a.INTPAID
                                    END )
                                    END NAMT
                    FROM  (
                            SELECT tl.msgacct, tl.txdate, tl.txnum, tl.tltxcd,
                                  sum(case when APP.FIELD = 'BALANCE' then (CASE WHEN APP.TXTYPE = 'D' THEN TRan.NAMT ELSE -TRan.NAMT END)
                                            else 0 end) NAMT,
                                  sum(case when APP.FIELD = 'INTPAID' then (CASE WHEN APP.TXTYPE = 'D' THEN -TRan.NAMT ELSE TRan.NAMT END)
                                           else 0 end) INTPAID
                            FROM vw_tllog_all tl ,(SELECT * FROM tdtran UNION ALL SELECT * FROM tdtrana) tran, v_appmap_by_tltxcd app
                            WHERE tl.msgacct like V_STRACCTNO
                            AND tran.txdate = tl.txdate AND tran.txnum = tl.txnum
                            AND app.apptype = 'TD' AND app.apptxcd = tran.txcd AND app.tltxcd = tl.tltxcd
                            AND app.field IN ('BALANCE','INTPAID')
                            GROUP BY tl.msgacct, tl.txdate, tl.txnum, tl.tltxcd
                            ORDER BY tl.txdate, tl.txnum
                            ) a, tdmast td, tdtype ty
                    WHERE td.actype = ty.actype AND a.msgacct = td.acctno
                    ) div
                where mst.acctno = tr.acctno
                    AND main.acctno = tr.acctno
                    AND tr.acctno = div.msgacct
                    and tr.txnum >= (case when tr.txdate = div.txdate then div.txnum
                                            when tr.txdate <  div.txdate then '9999999999'
                                        else '0' end )
                    AND CASE --cac giao dich binh thuong
                            WHEN tr.txdate < mst.todate AND tr.txdate > mst.frdate  THEN 1
                            --giao dich 1610 co ngay giao dich bang ngay tat toan
                            WHEN tr.tltxcd = '1610' AND tr.txdate = mst.todate THEN 1
                            --ngay giao dich = ngay tat toan thi giao dich 1620 hoac 1600 chay tu dong
                           WHEN tr.txdate = mst.todate  THEN CASE WHEN tr.tltxcd = '1620' THEN 1
                                                                  WHEN tr.tltxcd = '1600' /*AND tr.txnum LIKE '99%'*/ THEN 1
                                                                  END
                           --ngay giao dich bang ngay gia han, giao dich 1600 khong phai tu dong
                           WHEN tr.txdate = mst.frdate AND tr.tltxcd = '1600' AND tr.txnum NOT LIKE '99%' THEN 1
                           --giao dich 1620 khi ngay gia han bang ngay giao dich, se gay ra lap, nen phai lay group min(frdate) min(todate)
                           WHEN tr.tltxcd = '1620' AND tr.txdate = mst.frdate THEN 1
                           ELSE 0 END = 1
                    and mst.acctno like V_STRACCTNO
                    and mst.custodycd like V_CUSTODYCD
        group BY tr.txdate , tr.txnum, tr.tltxcd, tr.txdesc, mst.acctno, mst.afacctno, mst.fullname, mst.custodycd,
                  mst.tdtype , mst.opndate ,
                  tr.INTPAID , tr.NAMT ,   mst.intrate, mst.frdate , mst.todate,
                  mst.schdtype, mst.tdterm, mst.cdcontent , mst.autornd,mst.flintrate  ,mst.minbrterm,mst.termcd,main.msgamt
        )
        GROUP BY txdate, txnum, tltxcd, txdesc, acctno, afacctno, fullname,
                custodycd, actype, opndate,
                intpaid, namt, intrate, orgamt, schdtype,  autornd, flintrate, minbrterm, termcd,
                org
        ORDER BY txdate, txnum
        ) TD

        left join

        ( select DISTINCT * from (
            select tdmstschm.refautoid,  tdmstschm.acctno,  tdmstschm.intrate,  framt ,toamt,  frterm,toterm  ,tdmast.frdate ,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                        AND SBDATE >= tdmast.todate AND HOLIDAY = 'N') todate
            from tdmstschm , tdmast, cfmast cf, afmast af
            where tdmstschm.acctno = tdmast.acctno AND cf.custid = af.custid
            and tdmast.acctno  like V_STRACCTNO and tdmast.afacctno = af.acctno AND cf.custodycd  like V_CUSTODYCD
            union all
            select    tdmstschmhist.refautoid,  tdmstschmhist.acctno,  tdmstschmhist.intrate,  framt ,toamt,  frterm,toterm  ,tdmstschmhist.frdate ,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                        AND SBDATE >= tdmstschmhist.todate AND HOLIDAY = 'N') todate
            from tdmstschmhist
            where tdmstschmhist.acctno like V_STRACCTNO )
        )  SCHM

            on td.acctno = SCHM.acctno(+)
            and td.orgamt >= SCHM.framt(+)
            and td.orgamt < SCHM.toamt(+)
            and td.tdterm >= SCHM.FRTERM(+)
            and td.tdterm < SCHM.toterm(+)
            and td.txdate > SCHM.frdate(+)
            and td.txdate <= SCHM.todate(+)



UNION
--1630
    SELECT td.txdate, tl.txnum,tltxcd,td.acctno,td.afacctno,fullname, custodycd,td.ACTYPE , msgamt , td.opndate , td.frdate,td.todate,
           (case when td.schdtype = 'F' then td.intrate else nvl(SCHM.intrate,td.intrate) end) intrate ,
           --tyintrate intrate,
           0 namt,
           (
             CASE WHEN td.todate > V_TODATE
             THEN round(msgamt *(td.todate-td.frdate)*
             --(case when schdtype = 'F' then tdintrate else nvl(intrate1,tdintrate)
             (case when td.schdtype = 'F' then td.intrate else nvl(SCHM.intrate,td.intrate)
             end)/(100*360)) ELSE 0 END
           ) intavlamt,
           0 intamt,txdesc,
           (td.tdterm ||' '|| td.cdcontent) cdcontent ,
           autornd,
           0 currintrate
           --,schdtype,tdintrate,intrate1
    FROM
    (
        SELECT td.* , tdroot.intrate , tdroot.tdterm , tdroot.opndate ,
               (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= ( td.frdate + tdroot.tdterm)   AND HOLIDAY = 'N')  todate
        FROM
        (
            SELECT  (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TD.TODATE AND HOLIDAY = 'N') txdate,
                     tltxcd,TD.acctno,TD.afacctno,CF.fullname, cf.custodycd,
                    (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TD.TODATE AND HOLIDAY = 'N') frdate,
                   -- (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= ((SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                   --            AND SBDATE >= TD.TODATE AND HOLIDAY = 'N')+ td.tdterm)   AND HOLIDAY = 'N')  todate,
                    td.balance msgamt,
                    --td.tdterm,
                    td.schdtype ,
                    --td.intrate ,
                    txdesc, td.autornd , td.actype , al.cdcontent
            FROM TDMASTHIST TD, TLTX , afmast af , cfmast cf,allcode al
            WHERE TLTX.TLTXCD = '1630'
            and td.DELTD <>'Y'
            and td.afacctno = af.acctno
            and af.custid = cf.custid
            and al.cdtype = 'TD'
            and al.cdname = 'TERMCD'
            and td.termcd = al.cdval
            and td.acctno LIKE V_STRACCTNO
            and cf.custodycd LIKE V_CUSTODYCD
            and td.balance<>0
            AND (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= td.TODATE AND HOLIDAY = 'N') BETWEEN V_FROMDATE and V_TODATE
            --AND cf.careby IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_STRCAREBY)
        )  td,
        (
            select tdmasthist.acctno ,tdmasthist.orgamt,tdmasthist.balance,tdmasthist.intrate,tdmasthist.frdate,tdmasthist.tdterm,tdmasthist.opndate,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TODATE AND HOLIDAY = 'N') todate
            from tdmasthist, cfmast cf, afmast af  WHERE cf.custid = af.custid AND  tdmasthist.acctno LIKE V_STRACCTNO and afacctno = af.acctno AND cf.custodycd like V_CUSTODYCD
            union all
            select tdmast.acctno ,tdmast.orgamt,tdmast.balance,tdmast.intrate,tdmast.frdate,tdmast.tdterm,tdmast.opndate,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TODATE AND HOLIDAY = 'N') todate
            from tdmast, afmast af, cfmast cf where tdmast.acctno LIKE V_STRACCTNO and cf.custid = af.custid  and afacctno = af.acctno AND cf.custodycd like V_CUSTODYCD
        )  tdroot
        where td.frdate = tdroot.frdate(+)
        --and   td.todate = tdroot.todate
        and   td.acctno = tdroot.acctno(+)
    ) TD

    LEFT JOIN
    (
        SELECT tl.txdate, tl.txnum, tl.msgacct FROM vw_tllog_all tl  WHERE tltxcd = '1630'
    ) tl
    ON td.txdate = tl.txdate AND td.acctno = tl.msgacct

    left join
    ( select DISTINCT * from (
        select tdmstschm.refautoid,  tdmstschm.acctno,  tdmstschm.intrate,  framt ,toamt,  frterm,toterm  ,tdmast.frdate ,
        (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                    AND SBDATE >= tdmast.todate AND HOLIDAY = 'N') todate
        from tdmstschm , tdmast, cfmast cf, afmast af
        where tdmstschm.acctno = tdmast.acctno AND cf.custid = af.custid
        and tdmast.acctno like V_STRACCTNO and tdmast.afacctno = af.acctno AND cf.custodycd like V_CUSTODYCD
        union all
        select    tdmstschmhist.refautoid,  tdmstschmhist.acctno,  tdmstschmhist.intrate,  framt ,toamt,  frterm,toterm  ,tdmstschmhist.frdate ,
        (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                    AND SBDATE >= tdmstschmhist.todate AND HOLIDAY = 'N') todate
        from tdmstschmhist
        where tdmstschmhist.acctno like V_STRACCTNO )
    )
        SCHM

    on td.acctno = SCHM.acctno
    and td.msgamt >= SCHM.framt
    and td.msgamt < SCHM.toamt
    and td.tdterm >= SCHM.FRTERM
    and td.tdterm < SCHM.toterm
    and td.txdate >= SCHM.frdate
    and td.txdate < SCHM.todate



)a
WHERE tltxcd LIKE V_STRTLTXCD
AND custodycd LIKE V_CUSTODYCD
ORDER BY custodycd, afacctno, acctno,TXDATE,txnum--, opndate
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

