CREATE OR REPLACE PROCEDURE td0024 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   AFACCTNO       IN       VARCHAR2,
   TLTXCD         IN       VARCHAR2,
   ACCTNO         IN       VARCHAR2,
   CAREBY         IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- Bao cao tinh trang no qua han
-- PERSON           DATE        COMMENTS
-- DUNGNH       24-MAR-2011     CREATED
-- CUONGTD      20-JUL-2011     MODIFIED
-- ---------       ------   -------------------------------------------
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_FROMDATE       DATE;
   V_TODATE         DATE;
   V_STRAFACCTNO    VARCHAR2 (10);
   V_STRACCTNO      VARCHAR2 (20);
   V_STRTLTXCD      VARCHAR2 (10);
   V_STRCAREBY      VARCHAR2 (10);
   V_CURRDATE1      VARCHAR2 (10);
   V_CURRDATE       DATE;

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

   if(upper(AFACCTNO) <> 'ALL') then
        V_STRAFACCTNO :=  AFACCTNO;
   else
        V_STRAFACCTNO := '%';
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

   V_STRCAREBY :=  CAREBY;

   V_FROMDATE := to_date(F_DATE,'dd/mm/yyyy');
   V_TODATE := to_date(T_DATE,'dd/mm/yyyy');

   BEGIN
     select varvalue into V_CURRDATE1 from sysvar where varname like 'CURRDATE';
     V_CURRDATE := TO_DATE(V_CURRDATE1,'DD/MM/YYYY');
    END;

   -- GET REPORT'S DATA
OPEN PV_REFCURSOR
       FOR

SELECT  opndate ,txdate, tltxcd, acctno, afacctno, fullname,actype, msgamt, frdate, todate,intrate,NAMT,INTAVLAMT,intamt,
        ( case when a.tltxcd = '1600' then
                (case when txdate < todate and txdate >=frdate then
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
(
    select td.txdate, td.tltxcd, td.acctno, td.afacctno, td.fullname,td.actype, td.msgamt,td.opndate, td.frdate, td.todate,
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
            select tl.txdate, tl.tltxcd, TD.acctno, td.afacctno, cf.fullname, td.opndate,
                   td.actype, tl.msgamt, td.frdate, td.todate, td.intrate, td.tdterm,td.autornd,
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
                        select txdate, txnum, acctno, afacctno, actype, orgamt, balance, opndate,deltd,
                            frdate, (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                    AND SBDATE >= TODATE AND HOLIDAY = 'N') todate, intrate, tdterm, schdtype, termcd , autornd
                        from tdmast where acctno like V_STRACCTNO and afacctno like V_STRAFACCTNO
                        union all
                        select txdate, txnum, acctno, afacctno, actype, orgamt, balance, opndate,deltd,
                            frdate, (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                    AND SBDATE >= TODATE AND HOLIDAY = 'N') todate, intrate, tdterm, schdtype, termcd , autornd
                        from tdmasthist where acctno like V_STRACCTNO and afacctno like V_STRAFACCTNO
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
                and af.acctno like V_STRAFACCTNO
                and al.cdtype = 'TD' and al.cdname = 'TERMCD'
                and td.termcd = al.cdval
                AND CF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID like decode(V_STRCAREBY,'0001','%',V_STRCAREBY))
        ) td

    left join

        (   select DISTINCT * from (
             select tdmstschm.refautoid,  tdmstschm.acctno,  tdmstschm.intrate,  framt ,toamt,  frterm,toterm  ,tdmast.frdate ,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                        AND SBDATE >= tdmast.todate AND HOLIDAY = 'N') todate
            from tdmstschm , tdmast
            where tdmstschm.acctno = tdmast.acctno
            and tdmast.acctno like V_STRACCTNO  and tdmast.afacctno like V_STRAFACCTNO
            union all
            select    tdmstschmhist.refautoid,  tdmstschmhist.acctno,  tdmstschmhist.intrate,  framt ,toamt,  frterm,toterm  ,tdmstschmhist.frdate ,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                        AND SBDATE >= tdmstschmhist.todate AND HOLIDAY = 'N') todate
            from tdmstschmhist
            where tdmstschmhist.acctno like V_STRACCTNO )
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

        select  td.txdate, td.tltxcd, td.acctno, td.afacctno, td.fullname,
                td.actype, td.orgamt msgamt,td.opndate, td.frdate, td.todate,
                (case when td.schdtype = 'F' then td.intrate else nvl(SCHM.intrate,td.intrate) end) intrate,
                TD.namt NAMT, 0 INTAVLAMT, TD.intpaid intamt, td.txdesc, td.cdcontent,td.autornd,
                /*
                (
                   case when txdate < todate and txdate >= frdate
                        and (txdate - frdate) >= DECODE(termcd , 'D',minbrterm,'W',minbrterm * 7,'M',add_months(txdate,minbrterm)-txdate)
                       then (case when td.schdtype = 'F' then td.flintrate else nvl(TDMSTSCHM1.intrate,td.flintrate) end)
                   when txdate >= todate then
                     (case when td.schdtype = 'F' then td.intrate else nvl(TDMSTSCHM.intrate,td.intrate) end)
                    else 0
                   end
                )           currintrate
                */

                (case when td.txdate >= td.todate then
                           (case when td.schdtype = 'F' then td.intrate else nvl(SCHM.intrate,td.intrate) end)
                      else 0 end )    currintrate

               -- round((TD.intpaid * 360 * 100 / (( case when TD.namt <>0 then TD.namt else td.balance end ) * (td.txdate - td.frdate))) ,1 ) currintrate
        FROM
        (
            select tr.txdate, tr.tltxcd, tr.txdesc, mst.acctno, mst.afacctno, mst.fullname,mst.opndate,
                  mst.tdtype actype,  mst.orgamt,mst.balance, mst.frdate, mst.todate,
                  tr.INTPAID intpaid, tr.NAMT namt, tr.txnum,  mst.intrate,
                  mst.schdtype, mst.tdterm, mst.cdcontent , mst.autornd,mst.flintrate  ,mst.minbrterm,mst.termcd
            from
                 (
                     select td.actype tdtype, tl.grpname careby, td.acctno, af.acctno afacctno, cf.fullname,
                            td.orgamt, td.balance, td.opndate , td.frdate, td.intrate, cf.careby carebyid, td.autornd,td.flintrate,td.minbrterm,td.termcd,
                            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                AND SBDATE >= td.TODATE AND HOLIDAY = 'N') todate,
                            (td.tdterm || ' ' || al.cdcontent) cdcontent, cf.careby carebyid,
                            af.actype aftype, td.schdtype, td.tdterm
                      from   (select * from tdmast union select * from tdmasthist) td,
                              afmast af,
                              cfmast cf,
                              allcode al,
                              tlgroups tl
                     where td.afacctno = af.acctno
                            and af.custid = cf.custid
                            and al.cdtype = 'TD' and al.cdname = 'TERMCD'
                            and td.DELTD <>'Y'
                            and td.termcd = al.cdval
                            and cf.careby = tl.grpid
                            AND cf.careby IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID like decode(V_STRCAREBY,'0001','%',V_STRCAREBY))
                            and td.acctno LIKE V_STRACCTNO and td.afacctno like V_STRAFACCTNO
                            --order by opndate
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
                            and tl.tltxcd like V_STRTLTXCD
                            and tr.acctno like V_STRACCTNO
                        group by TR.ACCTNO, tr.txdate, tr.txnum , tl.txdesc, tl.tltxcd
                  ) TR
                where mst.acctno = tr.acctno
                    and tr.txdate <= mst.todate
                    and tr.txdate > mst.frdate
                    and mst.acctno like V_STRACCTNO
                    and mst.afacctno like V_STRAFACCTNO
                    order by tr.txnum
        ) TD

        left join

        ( select DISTINCT * from (
            select tdmstschm.refautoid,  tdmstschm.acctno,  tdmstschm.intrate,  framt ,toamt,  frterm,toterm  ,tdmast.frdate ,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                        AND SBDATE >= tdmast.todate AND HOLIDAY = 'N') todate
            from tdmstschm , tdmast
            where tdmstschm.acctno = tdmast.acctno
            and tdmast.acctno like V_STRACCTNO and tdmast.afacctno like V_STRAFACCTNO
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

    SELECT td.txdate,tltxcd,td.acctno,td.afacctno,fullname,td.ACTYPE,msgamt, td.opndate , td.frdate,td.todate,
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
        SELECT td.* , tdroot.intrate , tdroot.tdterm ,tdroot.opndate,
               (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= ( td.frdate + tdroot.tdterm)   AND HOLIDAY = 'N')  todate
        FROM
        (
            SELECT  (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TD.TODATE AND HOLIDAY = 'N') txdate,
                     tltxcd,TD.acctno,TD.afacctno,CF.fullname,
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
            and af.acctno LIKE V_STRAFACCTNO
            and td.balance<>0
            AND (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= td.TODATE AND HOLIDAY = 'N') BETWEEN V_FROMDATE and V_TODATE
            AND cf.careby IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID like decode(V_STRCAREBY,'0001','%',V_STRCAREBY))
        )  td,
        (
            select acctno ,orgamt,balance,intrate,opndate , frdate,tdterm,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TODATE AND HOLIDAY = 'N') todate
            from tdmasthist where acctno LIKE V_STRACCTNO and afacctno like V_STRAFACCTNO
            union all
            select acctno ,orgamt,balance,intrate, opndate , frdate,tdterm,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TODATE AND HOLIDAY = 'N') todate
            from tdmast where acctno LIKE V_STRACCTNO and afacctno like V_STRAFACCTNO
        )  tdroot
        where td.frdate = tdroot.frdate(+)
        --and   td.todate = tdroot.todate
        and   td.acctno = tdroot.acctno(+)  --order by opndate
    )
         td

    left join
    ( select DISTINCT * from (
        select tdmstschm.refautoid,  tdmstschm.acctno,  tdmstschm.intrate,  framt ,toamt,  frterm,toterm  ,tdmast.frdate ,
        (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                    AND SBDATE >= tdmast.todate AND HOLIDAY = 'N') todate
        from tdmstschm , tdmast
        where tdmstschm.acctno = tdmast.acctno
        and tdmast.acctno like V_STRACCTNO and tdmast.afacctno like V_STRAFACCTNO
        union all
        select    tdmstschmhist.refautoid,  tdmstschmhist.acctno,  tdmstschmhist.intrate,  framt ,toamt,  frterm,toterm  ,tdmstschmhist.frdate ,
        (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                    AND SBDATE >= tdmstschmhist.todate AND HOLIDAY = 'N') todate
        from tdmstschmhist
        where tdmstschmhist.acctno like V_STRACCTNO )
    )
        SCHM

    on td.acctno = SCHM.acctno(+)
    and td.msgamt >= SCHM.framt(+)
    and td.msgamt < SCHM.toamt(+)
    and td.tdterm >= SCHM.FRTERM(+)
    and td.tdterm < SCHM.toterm(+)
    and td.txdate >= SCHM.frdate(+)
    and td.txdate < SCHM.todate(+)

)a
ORDER BY opndate ,acctno , TXDATE ,tltxcd
;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

