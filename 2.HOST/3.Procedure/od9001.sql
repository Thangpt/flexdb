CREATE OR REPLACE PROCEDURE od9001 (
   PV_REFCURSOR             IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                      IN       VARCHAR2,
   BRID                     IN       VARCHAR2,
   I_DATE                   IN       VARCHAR2,
   PV_CUSTODYCD             IN       VARCHAR2,
   PV_AFACCTNO              in       varchar2,
   VIATYPE                  IN       VARCHAR2,
   PV_CFRELATION            IN       VARCHAR2
   )
IS
--recreated by CHAUNH at 24/04/2013
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);            -- USED WHEN V_NUMOPTION > 0

   V_IN_DATE           DATE;
   V_CRRDATE           DATE;
   V_CUSTODYCD         VARCHAR2(100);
   V_VIATYPE           VARCHAR2(100);
BEGIN
/*v_fullname_au:='';
v_licenseno_au:='';


FOR REC IN (select  fullname , licenseno   from cfauth  where acctno =PV_AFACCTNO and custid = p_custid)
LOOP
v_fullname_au:=REC.FULLNAME;
v_licenseno_au:=REC.licenseno;

END LOOP;
*/


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

-- GET REPORT'S PARAMETERS

    V_CUSTODYCD    :=    upper(PV_CUSTODYCD);

    if(substr(VIATYPE,1,1) <> 'O') then
        V_VIATYPE    := 'F';
    else
        V_VIATYPE    := 'O';
    end if;

    V_IN_DATE  :=    TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    SELECT TO_DATE(SY.VARVALUE, SYSTEMNUMS.C_DATE_FORMAT) INTO V_CRRDATE
    FROM SYSVAR SY WHERE SY.VARNAME = 'CURRDATE' AND SY.GRNAME = 'SYSTEM';


OPEN PV_REFCURSOR
FOR
select cf.fullname , cf.address, cf.iddate, cf.idplace, nvl(cf.mobile, cf.phone) phone, cf.custodycd, af.acctno
    , (case when cf.country = '234' then cf.idcode else cf.tradingcode end) idcode
    , t.tlfullname
    , B.fullname UQ_name
    , B.licenseno UQ_id
    , sb.symbol, od.orderqtty
    ,(CASE WHEN OD.PRICETYPE IN ('ATO','ATC')THEN  OD.PRICETYPE  ELSE   TO_CHAR(OD.QUOTEPRICE) END ) quoteprice
    , od.execqtty, od.execamt
    , case when instr(od.exectype,'S') <> 0 then 'Sell' else 'Buy' end bors
    , od.via, od.txdate, od.txtime
    , a.cdcontent odstatus
    --, case when od.orstatus  not in ('5','7') then a1.cdcontent else a.cdcontent end odstatus

from
    (
        select * from odmast
        where  deltd = 'N' and txdate = V_IN_DATE
        union all
        select * from odmasthist
        where  deltd = 'N' and txdate = V_IN_DATE
    ) od, afmast af, cfmast cf, sbsecurities sb, tlprofiles t
    ,(
        select *
        from cfauth
        where CUSTID = NVL(PV_CFRELATION,' ')
        ) B
    , allcode a, allcode a1
    , ( select * from ood union all select * from oodhist
        ) ood

    where od.afacctno = af.acctno
        and af.custid = cf.custid
        and od.codeid = sb.codeid
        and t.tlid = od.tlid
        and af.acctno = B.acctno(+)
        and od.orderid = ood.orgorderid
        and od.matchtype = 'N'
        and a.cdtype = 'OD' and a.cdname = 'ORSTATUS' and a.cdval = od.orstatus
        and a1.cdtype = 'OD' and a1.cdname = 'OODSTATUS' and a1.cdval = ood.oodstatus
        and cf.custodycd = V_CUSTODYCD
        and af.acctno = PV_AFACCTNO
        AND (CASE WHEN OD.VIA <> 'O' THEN 'F' ELSE 'O' END) LIKE V_VIATYPE
        --1.5.1.2: check brid theo phan he CF
        and cf.brid like V_STRBRID
       -- AND (substr(af.acctno,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(af.acctno,1,4))<> 0)
    ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

