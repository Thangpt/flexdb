CREATE OR REPLACE PROCEDURE mr0110 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   PV_CUSTODYCD         IN       VARCHAR2,
   PV_ACCTNO         IN       VARCHAR2,
   PV_SYMBOL         IN       VARCHAR2,
   I_DATE         IN       varchar2
 )
IS

    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);
    V_CUSTODYCD varchar2(10);
    V_ACCTNO varchar2(10);
    V_SYMBOL varchar2(10);
    V_DATE date;
    V_CURRDATE DATE;
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

    V_DATE := TO_DATE(I_DATE,'DD/MM/RRRR');
    SELECT TO_DATE(VARVALUE,'DD/MM/RRRR') INTO V_CURRDATE FROM SYSVAR WHERE VARNAME = 'CURRDATE' AND GRNAME = 'SYSTEM';

    IF PV_CUSTODYCD <> 'ALL' THEN
        V_CUSTODYCD := PV_CUSTODYCD;
    ELSE
        V_CUSTODYCD := '%';
    END IF;

    IF PV_ACCTNO <> 'ALL' THEN
        V_ACCTNO := PV_ACCTNO;
    ELSE
        V_ACCTNO := '%';
    END IF;

    IF PV_SYMBOL <> 'ALL' THEN
        V_SYMBOL := PV_SYMBOL;
    ELSE
        V_SYMBOL := '%';
    END IF;

OPEN PV_REFCURSOR FOR
select
    I_DATE i_date,cf.custodycd, cf.fullname, af.acctno, nvl(t0af.aft0used,0) AFT0USED
    , CASE WHEN V_DATE = V_CURRDATE THEN NVL(BUF.MARGINRATE,0) ELSE nvl(MR.marginrate,0) END RTT
    , CASE WHEN V_DATE = V_CURRDATE THEN NVL(LN.PRINOVD,0) ELSE nvl(t0prinamt,0)END T0PRINAMT
    , OD.SYMBOL, OD.B_ORDERQTTY, RE.BM_NAME
from
    cfmast cf, afmast af
    , ( select tran.acctno , sum(case when tl.tltxcd = '1810' then tran.namt else -tran.namt end) aft0used
            from (select * from aftran union select * from aftrana) tran, vw_tllog_all tl
            where tl.txdate =  V_DATE and tl.tltxcd in ('1810','1811')
                and tl.txdate = tran.txdate and tl.txnum = tran.txnum
        group by tran.acctno
      ) t0af

    /*( select acctno, sum(aft0used) aft0used
        from (select sum(acclimit) aft0used, acctno from  useraflimitlog where txdate = V_DATE group by acctno
            UNION ALL
            SELECT SUM(ACCLIMIT) AFT0USED, ACCTNO FROM USERAFLIMIT WHERE V_DATE = V_CURRDATE GROUP BY ACCTNO
            ) t0af
        group by acctno
       ) t0af*/
    , (select afacctno,  marginrate, t0prinamt from mr5005_log where txdate = V_DATE and rrtype = 'C') mr
    , (
        select sb.symbol, od.afacctno
            ,sum(case when instr(od.exectype,'B') <> 0 and txdate <> V_CURRDATE then od.execqtty
                      when instr(od.exectype,'B') <> 0 and txdate = V_CURRDATE  then od.execqtty + od.remainqtty else 0 end) B_orderqtty
        from vw_odmast_all od
            ,(select symbol, effdate, max(expdate) expdate
                from
                    (select symbol, effdate, nvl(expdate,to_date('01/01/2035','DD/MM/RRRR')) expdate from blacklistsymbol
                    union all
                    select symbol, effdate, expdate from blacklistsymbolhist
                    )bl
                group by symbol, effdate
            ) bl, sbsecurities sb
        where od.exectype not in ('AS','AB','CB','CS') and od.deltd <> 'Y' and sb.codeid = od.codeid and bl.symbol = sb.symbol
            and od.txdate between  bl.effdate and bl.expdate AND OD.TXDATE = V_DATE
        group by sb.symbol, od.afacctno
        HAVING sum(case when instr(od.exectype,'B') <> 0 and txdate <> V_CURRDATE then od.execqtty
                      when instr(od.exectype,'B') <> 0 and txdate = V_CURRDATE  then od.execqtty + od.remainqtty else 0 end) <> 0
        ) od
    , (select cf.custid, cf.fullname bm_name, r.afacctno, nvl(cf.mobile, cf.phone) bm_phone from reaflnk r, recfdef rd, recflnk rf, retype rt, cfmast cf
        where rf.autoid = rd.refrecflnkid and rf.custid = cf.custid
            and r.reacctno = rf.custid || rd.reactype
            and rd.reactype = rt.actype and rt.rerole in ('BM','RM')
            and V_DATE between r.frdate and nvl(r.clstxdate -1, r.todate)
            and V_DATE between rd.effdate and nvl(rd.closedate -1, rd.expdate)
        ) re
      , buf_ci_account BUF
      , (SELECT TRFACCTNO,SUM(OPRINOVD) PRINOVD FROM LNMAST GROUP BY TRFACCTNO)LN
where cf.custid = af.custid and nvl(t0af.aft0used,0) > 0 and OD.B_ORDERQTTY > 0
    and af.acctno = t0af.acctno(+)
    and af.acctno = mr.afacctno(+)
    and af.acctno = od.afacctno
    AND AF.ACCTNO = RE.AFACCTNO(+)
    AND AF.ACCTNO = BUF.AFACCTNO(+)
    AND AF.ACCTNO = LN.TRFACCTNO(+)
    AND CF.CUSTODYCD LIKE V_CUSTODYCD
    AND AF.ACCTNO LIKE V_ACCTNO
;

EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

