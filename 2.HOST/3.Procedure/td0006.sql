CREATE OR REPLACE PROCEDURE td0006 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD       IN       VARCHAR2,
   CAREBY         IN       VARCHAR2,
   ACCTNO         IN       VARCHAR2,
   TLTXCD         IN       VARCHAR2,
   ACTYPE         IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- Bao cao phat sinh giao dich
-- PERSON           DATE        COMMENTS
-- DUNGNH       24-MAR-2011     CREATED
-- ---------       ------   -------------------------------------------
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_FROMDATE       DATE;
   V_TODATE         DATE;
   V_CUSTODYCD    VARCHAR2 (10);
   V_STRACCTNO      VARCHAR2 (20);
   V_STRCAREBY      VARCHAR2 (10);
   V_STRTLTXCD      VARCHAR2 (15);
   V_STRACTYPE      VARCHAR2 (10);

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

   if(upper(PV_CUSTODYCD) <> 'ALL') then
        V_CUSTODYCD :=  PV_CUSTODYCD;
   else
        V_CUSTODYCD := '%';
   end if;

   if(upper(ACCTNO) <> 'ALL') then
        V_STRACCTNO := ACCTNO;
   else
        V_STRACCTNO := '%';
   end if;

   if(upper(CAREBY) <> 'ALL') then
        V_STRCAREBY :=  CAREBY;
   else
        V_STRCAREBY := '%';
   end if;

   if(upper(TLTXCD) <> 'ALL') then
        V_STRTLTXCD :=  TLTXCD;
   else
        V_STRTLTXCD := '%';
   end if;

   if(upper(ACTYPE) <> 'ALL') then
        V_STRACTYPE :=  ACTYPE;
   else
        V_STRACTYPE := '%';
   end if;

   V_FROMDATE := to_date(F_DATE,'dd/mm/yyyy');
   V_TODATE := to_date(T_DATE,'dd/mm/yyyy');

   -- GET REPORT'S DATA
OPEN PV_REFCURSOR FOR


SELECT  afacctno,custodycd, fullname,acctno,actype,msgamt,frdate,todate,cdcontent,intrate,INTAMT,NAMT,tltxcd,txdate
FROM
(
    select td.afacctno,td.custodycd, td.fullname,td.acctno, td.actype, td.msgamt, td.frdate, td.todate,--td.txdate, td.tltxcd,
           td.cdcontent ,
           (case when td.schdtype = 'F' then td.intrate else nvl(SCHM.intrate,td.intrate) end) intrate,
           (
                CASE WHEN td.todate > V_TODATE then  round(td.msgamt*(td.todate-td.frdate)*
                (case when td.schdtype = 'F' then td.intrate  else nvl(SCHM.intrate,td.intrate) end)/(100*360))
                 else 0 end
           ) INTAMT,
           0 NAMT,
           td.tltxcd ,td.txdate,td.txnum
    from
        (
            select tl.txdate, tl.tltxcd, TD.acctno, td.afacctno, cf.custodycd, cf.fullname,td.txnum,
                   td.actype, tl.msgamt, td.frdate, td.todate, td.intrate, td.tdterm,td.autornd,
                   td.orgamt, td.schdtype, tl.txdesc, (td.tdterm || ' ' || al.cdcontent) cdcontent
            from
                (
                    SELECT * FROM TLLOG WHERE TLTXCD in ( '1670') and txdate BETWEEN V_FROMDATE and V_TODATE
                    and DELTD <> 'Y' --and tltxcd like V_STRTLTXCD
                    UNION ALL
                    SELECT * FROM TLLOGALL WHERE TLTXCD in ( '1670') and txdate BETWEEN V_FROMDATE and V_TODATE
                    and DELTD <> 'Y' -- and tltxcd like V_STRTLTXCD
                ) TL,
                (
                   select td.txdate, td.txnum, td.acctno, td.afacctno, td.actype, td.autornd,td.orgamt, td.balance , td.opndate, td.frdate,
                        td.todate, td.intrate , td.tdterm, td.schdtype, td.termcd
                    from
                    (
                        select tdmast.txdate, tdmast.txnum, tdmast.acctno, tdmast.afacctno, tdmast.actype, tdmast.orgamt, tdmast.balance, tdmast.opndate,tdmast.deltd,
                            tdmast.frdate, (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                    AND SBDATE >= TODATE AND HOLIDAY = 'N') todate,  tdmast.intrate,  tdmast.tdterm,  tdmast.schdtype,  tdmast.termcd ,  tdmast.autornd
                        from tdmast, cfmast cf, afmast af where tdmast.acctno like V_STRACCTNO and afacctno = af.acctno AND cf.custid = af.custid AND cf.custodycd like V_CUSTODYCD
                        union all
                        select tdmasthist.txdate, tdmasthist.txnum, tdmasthist.acctno, tdmasthist.afacctno, tdmasthist.actype, tdmasthist.orgamt, tdmasthist.balance, tdmasthist.opndate,tdmasthist.deltd,
                            tdmasthist.frdate, (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                    AND SBDATE >= TODATE AND HOLIDAY = 'N') todate, tdmasthist.intrate, tdmasthist.tdterm, tdmasthist.schdtype, tdmasthist.termcd , tdmasthist.autornd
                        from tdmasthist, cfmast cf, afmast af where tdmasthist.acctno like V_STRACCTNO and afacctno = af.acctno AND cf.custid = af.custid AND cf.custodycd like V_CUSTODYCD
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
                and td.actype like V_STRACTYPE
                and al.cdtype = 'TD' and al.cdname = 'TERMCD'
                and td.termcd = al.cdval
                AND CF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID like V_STRCAREBY)
                AND (CASE   WHEN V_STRTLTXCD = '%' THEN 1
                            WHEN V_STRTLTXCD = '1670' THEN 1
                            WHEN V_STRTLTXCD = '16301670' THEN 1
                            ELSE 0 END) = 1

        ) td

    left join

        ( select DISTINCT * from (
             select tdmstschm.refautoid,  tdmstschm.acctno,  tdmstschm.intrate,  framt ,toamt,  frterm,toterm  ,tdmast.frdate ,
            (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                        AND SBDATE >= tdmast.todate AND HOLIDAY = 'N') todate
            from tdmstschm , tdmast, cfmast cf, afmast af
            where tdmstschm.acctno = tdmast.acctno
            and tdmast.acctno like V_STRACCTNO  and tdmast.afacctno  = af.acctno AND cf.custid = af.custid AND cf.custodycd like V_CUSTODYCD
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


 select td.afacctno, td.custodycd, td.fullname, td.acctno,  td.actype, nvl(B.orgamt,C.orgamt) msgamt, td.frdate, td.todate, td.cdcontent ,
          (case when td.schdtype = 'F' then td.intrate else nvl(SCHM.intrate,td.intrate) end) intrate,
           0 INTAMT ,
           TD.namt NAMT,
           td.tltxcd , td.txdate , td.txnum
                /*td.opndate, TD.intpaid intamt, td.txdesc, ,td.autornd,
                   (case when td.txdate >= td.todate then
                       (case when td.schdtype = 'F' then td.intrate else nvl(SCHM.intrate,td.intrate) end)
                            else 0 end )    currintrate */
FROM

     (
            select tr.txdate, tr.tltxcd, tr.txdesc, mst.acctno, mst.afacctno,mst.custodycd, mst.fullname,mst.opndate,
                  mst.tdtype actype,  mst.orgamt,mst.balance, mst.frdate, mst.todate,
                  tr.INTPAID intpaid, tr.NAMT namt, tr.txnum,  mst.intrate,
                  mst.schdtype, mst.tdterm, mst.cdcontent , mst.autornd,mst.flintrate  ,mst.minbrterm,mst.termcd
            from
                 (
                     select td.actype tdtype, tl.grpname careby, td.acctno, af.acctno afacctno, cf.fullname, cf.custodycd,
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
                            and td.actype like V_STRACTYPE
                            AND cf.careby IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID like V_STRCAREBY)
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
                            and tl.tltxcd like V_STRTLTXCD
                            and tr.acctno like V_STRACCTNO
                        group by TR.ACCTNO, tr.txdate, tr.txnum, tl.txdesc, tl.tltxcd
                    ) TR
                where mst.acctno = tr.acctno
                    and tr.txdate <= mst.todate
                    and tr.txdate > mst.frdate
                    and mst.acctno like V_STRACCTNO
                    and mst.custodycd like V_CUSTODYCD
                    order by tr.txnum
        ) TD

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
        )  SCHM

            on td.acctno = SCHM.acctno(+)
            and td.orgamt >= SCHM.framt(+)
            and td.orgamt < SCHM.toamt(+)
            and td.tdterm >= SCHM.FRTERM(+)
            and td.tdterm < SCHM.toterm(+)
            and td.txdate > SCHM.frdate(+)
            and td.txdate <= SCHM.todate(+)
            --order by acctno,TXDATE--,tltxcd
        LEFT JOIN
        (
            SELECT frdate,(SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000'
                                AND SBDATE >= td.TODATE AND HOLIDAY = 'N') todate, todate todate_org, orgamt, acctno
            FROM (SELECT * FROM tdmast UNION ALL SELECT * FROM tdmasthist) td WHERE acctno like V_STRACCTNO
        ) B
          ON td.acctno = B.acctno AND td.frdate = b.todate
        LEFT JOIN
        (
            SELECT txdate, txnum, min(orgamt) orgamt, acctno FROM (SELECT * FROM tdmast UNION ALL SELECT * FROM tdmasthist) td WHERE acctno like V_STRACCTNO GROUP BY txdate, txnum,  acctno
        ) C
            ON td.acctno = C.acctno

UNION

SELECT td.afacctno,custodycd, fullname,td.acctno, td.actype, msgamt,td.frdate,td.todate,
(td.tdterm ||' '|| td.cdcontent) cdcontent ,
(case when td.schdtype = 'F' then td.intrate else nvl(SCHM.intrate,td.intrate) end) intrate ,
0 intamt, 0 namt, tltxcd,td.txdate, td.txnum
    FROM
    (
        SELECT td.* , tdroot.intrate , tdroot.tdterm , tdroot.opndate ,
               (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= ( td.frdate + tdroot.tdterm)   AND HOLIDAY = 'N')  todate
        FROM
        (
            SELECT  (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= TD.TODATE AND HOLIDAY = 'N') txdate, td.txnum,
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
            and td.actype like V_STRACTYPE
            and td.acctno LIKE V_STRACCTNO
            and cf.custodycd LIKE V_CUSTODYCD
            and td.balance<>0
            AND (SELECT min(sbdate) FROM SBCLDR WHERE CLDRTYPE = '000' AND SBDATE >= td.TODATE AND HOLIDAY = 'N') BETWEEN V_FROMDATE and V_TODATE
            AND cf.careby IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID like V_STRCAREBY)
            AND (CASE WHEN V_STRTLTXCD = '1630' THEN 1
                    WHEN V_STRTLTXCD = '16301670' THEN 1
                    ELSE 0 END) = 1

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
    )
         td

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

    on td.acctno = SCHM.acctno(+)
    and td.msgamt >= SCHM.framt(+)
    and td.msgamt < SCHM.toamt(+)
    and td.tdterm >= SCHM.FRTERM(+)
    and td.tdterm < SCHM.toterm(+)
    and td.txdate >= SCHM.frdate(+)
    and td.txdate < SCHM.todate(+)

 )

WHERE --TLTXCD LIKE V_STRTLTXCD
--and   namt <>0
--and
not ( tltxcd = '1610' and namt = 0)
ORDER BY afacctno , acctno , txdate , txnum asc ;--, tltxcd desc;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

