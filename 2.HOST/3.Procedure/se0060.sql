CREATE OR REPLACE PROCEDURE se0060 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   FROMMONTH          IN      VARCHAR2,
   TOMONTH          IN      VARCHAR2,
   SEARCHDATE      IN      VARCHAR2,
   I_CUSTODYCD     IN      VARCHAR2,
   PLSENT          IN      VARCHAR2,
   COREBANK         IN       VARCHAR2,
   BANKNAME         IN       VARCHAR2
   )
IS
--Bao cao tong hop phi luu ky hang thang
--created by CHaunh at 11/05/2012

-- ---------   ------  -------------------------------------------

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);            -- USED WHEN V_NUMOPTION > 0
   V_F_DATE    DATE;
   F_DATE    DATE;
   V_T_DATE    DATE;
   V_CURR_DATE DATE;
   V_STRCUSTODYCD varchar2(20);
   V_STRPLSENT       number;
   V_SEARCHDATE DATE;
   V_STRCOREBANK          VARCHAR(20);
   V_STRBANKNAME       VARCHAR(20);


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

   IF TO_NUMBER(SUBSTR(FROMMONTH,1,2)) <= 12 THEN
        V_F_DATE := TO_DATE('01/' || SUBSTR(FROMMONTH,1,2) || '/' || SUBSTR(FROMMONTH,3,4),'DD/MM/YYYY');
    ELSE
        V_F_DATE := TO_DATE('31/12/9999','DD/MM/YYYY');
    END IF;

    IF TO_NUMBER(SUBSTR(TOMONTH,1,2)) <= 12 THEN
        F_DATE := TO_DATE('01/' || SUBSTR(TOMONTH,1,2) || '/' || SUBSTR(TOMONTH,3,4),'DD/MM/YYYY');
    ELSE
        F_DATE := TO_DATE('31/12/9999','DD/MM/YYYY');
    END IF;

    V_T_DATE := LAST_DAY(F_DATE);

    V_SEARCHDATE:= to_date(SEARCHDATE,'DD/MM/RRRR');
    SELECT to_date(varvalue,'DD/MM/RRRR') INTO V_CURR_DATE FROM sysvar WHERE varname = 'CURRDATE';

   IF(I_CUSTODYCD = 'ALL' or I_CUSTODYCD is null )
   THEN
        V_STRCUSTODYCD := '%%';
   ELSE
        V_STRCUSTODYCD := I_CUSTODYCD;
   END IF;


   IF(PLSENT = 'ALL' OR PLSENT IS NULL)
    THEN
       V_STRPLSENT := -1; --tat ca
   ELSIF (PLSENT = '01') THEN
       V_STRPLSENT := 0; -- con no
   else
       V_STRPLSENT := 1; -- het no
   END IF;


   IF(COREBANK <> 'ALL')
   THEN
        V_STRCOREBANK  := COREBANK;
   ELSE
        V_STRCOREBANK  := '%%';
   END IF;
   IF(BANKNAME <> 'ALL')
   THEN
        V_STRBANKNAME  := BANKNAME;
   ELSE
        V_STRBANKNAME := '%%';
   END IF;

OPEN PV_REFCURSOR
FOR
SELECT V_T_DATE tomonth, V_F_DATE frommonth, V_SEARCHDATE tra_ngay, a.custodycd, a.fullname, thang, nam,
        sum(a.nmlamt) nmlamt, sum(a.paid) namt, sum(a.nmlamt - a.paid) con_no
FROM
(
SELECT  cf.custodycd, cf.fullname, nmlamt, to_char(fee.todate,'MM') thang, to_char(fee.todate,'YYYY') nam,
        CASE WHEN paidtxdate <= V_SEARCHDATE THEN paidamt ELSE 0 END paid
FROM cifeeschd fee, afmast af, cfmast cf
WHERE fee.afacctno = af.acctno AND af.custid = cf.custid
AND cf.custodycd  like V_STRCUSTODYCD
AND nvl(cf.brid,V_STRBRID) LIKE V_STRBRID 
AND  fee.todate <= V_T_DATE AND fee.todate >= V_F_DATE
--Them dieu kien loc theo ngan hang
and af.corebank like V_STRCOREBANK
and af.bankname like V_STRBANKNAME
and af.corebank = 'N'
union all

select fee.custodycd, fee.fullname, fee.nmlamt, fee.thang, fee.nam, least(fee.paid,nvl(trf.txamt,0)) paid
from (
    SELECT  cf.custodycd, cf.fullname, nmlamt, to_char(fee.todate,'MM') thang, to_char(fee.todate,'YYYY') nam,
            CASE WHEN paidtxdate <= V_SEARCHDATE THEN paidamt ELSE 0 END paid,
            fee.paidtxnum,fee.paidtxdate
    FROM cifeeschd fee, afmast af, cfmast cf
    WHERE fee.afacctno = af.acctno AND af.custid = cf.custid
    AND cf.custodycd  like V_STRCUSTODYCD
    AND nvl(cf.brid,V_STRBRID) LIKE V_STRBRID 
    AND  fee.todate <= V_T_DATE AND fee.todate >= V_F_DATE
    --Them dieu kien loc theo ngan hang
    and af.corebank like V_STRCOREBANK
    and af.bankname like V_STRBANKNAME
    and af.corebank ='Y'
) fee,
(
select a.* from (select * from crbtxreq union select * from crbtxreqhist) a,
                (select * from crbtrflogdtl union select * from crbtrflogdtlhist) dtl --,vw_tllog_all b
    where a.trfcode ='TRFSEFEE'
    --and a.refcode = b.txnum and a.txdate = b.txdate
    and DTL.REFREQID=a.REQID and dtl.status ='C'
) trf
where fee.paidtxnum = trf.refcode(+) and  fee.paidtxdate =trf.txdate(+)

UNION all
-- phat sinh phi trong thang hien tai
SELECT a.custodycd, a.fullname, a.nmlamt - nvl(b.paid,0) nmlamt, to_char(V_CURR_DATE,'MM') thang, to_char(V_CURR_DATE,'YYYY') nam, 0 paid FROM

    (
    SELECT custodycd , fullname,
           SUM(CASE WHEN TO_CHAR(V_CURR_DATE,'MONTH') = TO_CHAR(SE.TXDATE, 'MONTH')
                    and TO_CHAR(V_CURR_DATE,'YEAR') = TO_CHAR(SE.TXDATE, 'YEAR')  THEN AMT ELSE 0 END) NMLAMT
           --sum(CASE WHEN to_char(V_CURR_DATE,'MONTH') = to_char(V_T_DATE,'MONTH') THEN  amt ELSE 0 END)  nmlamt
    FROM sedepobal se, cfmast cf, afmast af
    WHERE substr(se.acctno,1,10) = af.acctno AND af.custid = cf.custid
    AND cf.custodycd LIKE V_STRCUSTODYCD
    AND se.txdate >= V_F_DATE AND se.txdate <= V_T_DATE
    --Them dieu kien loc theo ngan hang
    and af.corebank like V_STRCOREBANK
    and af.bankname like V_STRBANKNAME
    GROUP BY custodycd , fullname
    ) a,
    (
    SELECT cf.custodycd, cf.fullname,
        sum(CASE WHEN to_char(V_CURR_DATE,'MONTH') = to_char(txdate,'MONTH')
                      and TO_CHAR(V_CURR_DATE,'YEAR') = TO_CHAR(TXDATE, 'YEAR') THEN  namt ELSE 0 END)  paid
    FROM vw_citran_gen tran, cfmast cf WHERE tltxcd = '0088'
    AND field IN ('CIDEPOFEEACR') AND txtype = 'D'
    AND tran.custid = cf.custid
    AND tran.custodycd  like V_STRCUSTODYCD
    AND nvl(cf.brid,V_STRBRID) LIKE V_STRBRID 
    AND txdate <= V_SEARCHDATE AND txdate <= V_T_DATE AND txdate >= V_F_DATE
    GROUP BY  cf.custodycd, cf.fullname
    ) b
    WHERE a.custodycd = b.custodycd(+)


union ALL
SELECT cf.custodycd, cf.fullname, (namt) nmlamt, to_Char(tran.txdate,'MM') thang,to_Char(tran.txdate,'YYYY') nam,
     (namt) paid
FROM vw_citran_gen tran, afmast af, cfmast cf WHERE tltxcd = '0088'
AND field IN ('CIDEPOFEEACR') AND txtype = 'D'
--AND tran.custid = cf.custid
and tran.acctno = af.acctno and af.custid = cf.custid
AND tran.custodycd  like V_STRCUSTODYCD
--Them dieu kien loc theo ngan hang
and af.corebank like V_STRCOREBANK
and af.bankname like V_STRBANKNAME
AND nvl(cf.brid,V_STRBRID) LIKE V_STRBRID
AND txdate <= V_SEARCHDATE AND txdate <= V_T_DATE AND txdate >= V_F_DATE

) a

GROUP BY a.custodycd, a.fullname, a.thang, a.nam
having sum(a.nmlamt) + sum(a.paid) <> 0
AND case WHEN V_STRPLSENT = 0 AND sum(a.nmlamt - a.paid) > 0 THEN 1
           WHEN V_STRPLSENT = -1 THEN 1
           WHEN V_STRPLSENT = 1 AND sum(a.nmlamt - a.paid) = 0 THEN 1
           ELSE 0
      END = 1
ORDER BY custodycd

;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/
