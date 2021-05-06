CREATE OR REPLACE PROCEDURE od0086 (
   PV_REFCURSOR             IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                      IN       VARCHAR2,
   BRID                     IN       VARCHAR2,
   I_DATE                   IN       VARCHAR2,
   DATE_T                   IN       VARCHAR2,
   PV_CUSTODYCD             IN       VARCHAR2,
   CIACCTNO                 IN       VARCHAR2,
   SYMBOL                   IN       VARCHAR2,
   PV_TLID                  in       varchar2
   )
IS
-- MODIFICATION HISTORY
-- KET QUA KHOP LENH CUA KHACH HANG
-- PERSON      DATE    COMMENTS
-- NAMNT   15-JUN-08  CREATED
-- DUNGNH  08-SEP-09  MODIFIED
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);            -- USED WHEN V_NUMOPTION > 0
   V_STREXECTYPE    VARCHAR2 (5);
   V_STRSYMBOL      VARCHAR2 (15);
   V_STRTRADEPLACE  VARCHAR2 (3);

   V_STRAFACCTNO       VARCHAR2 (20);
   V_CUSTODYCD       VARCHAR2 (20);

   V_NUMBUY         NUMBER (20,2);

   V_TRADELOG   CHAR(2);
   V_AUTOID     NUMBER;
   V_CUR_DATE   DATE ;
   TRAN_DATE    DATE;
   V_F_DATE     DATE;
   V_TLID       varchar2(4);
   v_repo2      VARCHAR2(1);
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
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
   V_TLID := PV_TLID;

   -- GET REPORT'S PARAMETERS
   --
   IF (SYMBOL <> 'ALL')
   THEN
      V_STRSYMBOL := SYMBOL;
   ELSE
      V_STRSYMBOL := '%%';
   END IF;

   --

   V_F_DATE := to_date(I_DATE,'dd/mm/rrrr');
   TRAN_DATE :=  getduedate(V_F_DATE, 'B', '000', TO_NUMBER(DATE_T));

   V_STRAFACCTNO := case when upper(CIACCTNO) = 'ALL' then '%' else CIACCTNO end;
   V_CUSTODYCD:= upper(PV_CUSTODYCD);

   SELECT TO_DATE(VARVALUE ,'dd/mm/rrrr') INTO V_CUR_DATE FROM SYSVAR WHERE VARNAME ='CURRDATE';
   SELECT varvalue INTO v_repo2 FROM sysvar WHERE varname = 'FEE_REPO2';
   -- GET REPORT'S DATA

OPEN PV_REFCURSOR
FOR
    select max(cf.fullname) fullname, cf.custodycd, max(cf.address) address,
        DATE_T DATE_T, TRAN_DATE tr_date,
        max(od.orderid) orderid, max(io.symbol) symbol, sum(io.matchqtty) matchqtty, io.matchprice matchprice,
        sum(case when od.execamt > 0 and decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N' AND (v_repo2 = 'N' AND od.repotype <> 2) and od.TXDATE = V_CUR_DATE then
                  ROUND(floor(odt.deffeerate* od.execamt/100)*io.matchqtty * io.matchprice / od.execamt, 2)
             else
               (CASE WHEN (od.execamt * od.feeacr) = 0 THEN 0 ELSE
                     ROUND(od.feeacr*io.matchqtty * io.matchprice / od.execamt , 2) END)
        end)  feeamt, od.txdate, od.codeid, od.afacctno, max(od.matchtype) matchtype
    from vw_odmast_all od , vw_iod_all io, cfmast cf, odtype odt, afmast af,
    (SELECT * FROM sbbatchsts bs WHERE bs.bchmdl = 'ODFEECAL') bs
    where od.deltd <> 'Y'
        and od.execamt <> 0
        and od.actype = odt.actype
        and od.orderid = io.orgorderid
        and od.exectype =  'NB'
        and io.custodycd = cf.custodycd and cf.custid = af.custid
        and od.txdate = V_F_DATE
        and trim(cf.custodycd) = V_CUSTODYCD
        and od.afacctno like V_STRAFACCTNO
        and od.clearday = TO_NUMBER(DATE_T)
        AND od.AFACCTNO=af.acctno
        AND od.txdate = bs.bchdate(+)
        and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = V_TLID )
        and io.symbol like V_STRSYMBOL
    group by od.txdate, cf.custodycd,od.afacctno,od.codeid, io.matchprice;
EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
/