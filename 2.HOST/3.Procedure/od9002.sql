CREATE OR REPLACE PROCEDURE od9002 (
   PV_REFCURSOR             IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                      IN       VARCHAR2,
   BRID                     IN       VARCHAR2,
   I_DATE                   IN       VARCHAR2,
   PV_CUSTODYCD             IN       VARCHAR2,
   PV_AFACCTNO              in       varchar2,
   VIATYPE                  IN       VARCHAR2,
   PV_CFRELATION            IN       VARCHAR2,
   PV_BORS                  in      varchar2
   )
IS

   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);            -- USED WHEN V_NUMOPTION > 0

   V_IN_DATE           DATE;
   V_CRRDATE           DATE;
   V_CUSTODYCD         VARCHAR2(100);
   /*V_AFACCTNO          VARCHAR2(100);*/
   V_VIATYPE           VARCHAR2(100);
   /*v_fullname_au       VARCHAR2(1000);
   v_licenseno_au         VARCHAR2(1000);*/
BEGIN
/*v_fullname_au:='';
v_licenseno_au:='';*/
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

/*FOR REC IN (select  fullname , licenseno   from cfauth  where acctno =PV_AFACCTNO and custid = p_custid)
LOOP
v_fullname_au:=REC.FULLNAME;
v_licenseno_au:=REC.licenseno;

END LOOP;*/

-- GET REPORT'S PARAMETERS

    V_CUSTODYCD    :=    upper(PV_CUSTODYCD);

    /*IF (PV_AFACCTNO <> 'ALL' OR PV_AFACCTNO <> '')
    THEN
         V_AFACCTNO    :=    PV_AFACCTNO;
    ELSE
         V_AFACCTNO    :=    '%';
    END IF;*/

    if(substr(VIATYPE,1,1) <> 'O') then
        V_VIATYPE    := 'F';
    else
        V_VIATYPE    := 'O';
    end if;


    V_IN_DATE         :=    TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);

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
    , od.via, od.txdate
    , a.cdcontent odstatus
    --, case when od.orstatus  not in ('5','7') then a1.cdcontent else a.cdcontent end odstatus
    , od.txtime, od.orderid
    , 'T+3' CK_TT
from
    (
        select * from odmast
        where  deltd = 'N' and txdate = V_IN_DATE
        union all
        select * from odmasthist
        where   deltd = 'N' and txdate = V_IN_DATE
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
        and af.acctno  = B.acctno(+)
        and od.orderid = ood.orgorderid
        and od.matchtype = 'P'
        and instr(od.exectype,PV_BORS) <> 0
        and a.cdtype = 'OD' and a.cdname = 'ORSTATUS' and a.cdval = od.orstatus
        and a1.cdtype = 'OD' and a1.cdname = 'OODSTATUS' and a1.cdval = ood.oodstatus
        --AND (substr(af.acctno,1,4) LIKE V_STRBRID OR instr(V_STRBRID,substr(af.acctno,1,4))<> 0)
        and cf.custodycd = V_CUSTODYCD
        and af.acctno = PV_AFACCTNO
        AND (CASE WHEN OD.VIA = 'O' THEN 'O' ELSE 'F' END) LIKE V_VIATYPE

/*select cf.fullname , (case when cf.country = '234' then cf.idcode else cf.tradingcode end) idcode, cf.custodycd, af.acctno,
    sb.symbol, od.orderqtty,-- od.quoteprice,
    (CASE WHEN OD.PRICETYPE IN ('ATO','ATC')THEN  OD.PRICETYPE  ELSE   TO_CHAR(OD.QUOTEPRICE) END ) quoteprice,
     od.via, od.txdate,
  v_fullname_au fullname_au, v_licenseno_au licenseno_au,
    substr(cf.custodycd,1,1) custodycd_1, substr(cf.custodycd,2,1) custodycd_2,
    substr(cf.custodycd,3,1) custodycd_3, substr(cf.custodycd,4,1) custodycd_4,
    substr(cf.custodycd,5,1) custodycd_5, substr(cf.custodycd,6,1) custodycd_6,
    substr(cf.custodycd,7,1) custodycd_7, substr(cf.custodycd,8,1) custodycd_8,
    substr(cf.custodycd,9,1) custodycd_9, substr(cf.custodycd,10,1) custodycd_10,
    substr(af.acctno,1,1) afacctno_1,substr(af.acctno,2,1) afacctno_2,
    substr(af.acctno,3,1) afacctno_3,substr(af.acctno,4,1) afacctno_4,
    substr(af.acctno,5,1) afacctno_5,substr(af.acctno,6,1) afacctno_6,
    substr(af.acctno,7,1) afacctno_7,substr(af.acctno,8,1) afacctno_8,
    substr(af.acctno,9,1) afacctno_9,substr(af.acctno,10,1) afacctno_10
    from
    (
        select * from odmast
        where exectype in ('NS','MS') and deltd = 'N' and txdate = V_IN_DATE
        union all
        select * from odmasthist
        where exectype in ('NS','MS') and deltd = 'N' and txdate = V_IN_DATE
    ) od, afmast af, cfmast cf, sbsecurities sb
    where od.afacctno = af.acctno
        and af.custid = cf.custid
        and od.codeid = sb.codeid
        and cf.custodycd = V_CUSTODYCD
        and af.acctno like V_AFACCTNO
        AND (CASE WHEN OD.VIA = 'O' THEN 'O' ELSE 'F' END) LIKE V_VIATYPE*/
    ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

