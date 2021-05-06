CREATE OR REPLACE PROCEDURE od0087 (
   PV_REFCURSOR             IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                      IN       VARCHAR2,
   BRID                     IN       VARCHAR2,
   I_DATE                   IN       VARCHAR2,
   DATE_T                   IN       VARCHAR2,
   PV_CUSTODYCD             IN       VARCHAR2,
   CIACCTNO                 IN       VARCHAR2,
   SYMBOL                   IN       VARCHAR2,
   PV_TLID                  in      varchar2
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
    V_INBRID     VARCHAR2 (5);           -- USED WHEN V_NUMOPTION > 0
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

   V_NUM_TT     number;
   V_NUM_CC     number;
   V_VAT        number;

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

   if upper(CIACCTNO) = 'ALL' then
    v_strafacctno:= '%';
   else
    v_strafacctno:= ciacctno;
   end if;


   V_CUSTODYCD:= upper(PV_CUSTODYCD);

   SELECT TO_DATE(VARVALUE ,'dd/mm/rrrr') INTO V_CUR_DATE FROM SYSVAR WHERE VARNAME ='CURRDATE';
   select varvalue into V_VAT from sysvar where varname = 'ADVSELLDUTY' and grname = 'SYSTEM';
   select varvalue into v_repo2 from sysvar where varname = 'FEE_REPO2' and grname = 'SYSTEM';
   V_NUM_CC := 0;
   V_NUM_TT := 0;
BEGIN
   select sum(nvl(io.matchqtty*io.matchprice-
        (case when od.execamt > 0 and decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N' AND od.TXDATE = V_CUR_DATE AND (v_repo2 = 'N' AND od.repotype <> 2) THEN
                  ROUND(floor(odt.deffeerate* od.execamt/100)*io.matchqtty * io.matchprice / od.execamt, 2)
         else
         (CASE WHEN (od.execamt * od.feeacr) = 0 THEN 0 ELSE
           ROUND(od.feeacr*io.matchqtty * io.matchprice / od.execamt, 2)
           END)
         end) -
        case
            when IO.iodtaxsellamt>0 then IO.iodtaxsellamt
        else
            (CASE WHEN aft.VAT = 'Y' THEN (V_VAT/100)*(IO.matchqtty * io.matchprice) else 0 end)
        end ---
            --CASE WHEN io.iodvatsellamt>0 THEN io.iodvatsellamt ELSE 0 END
         ,0)) into V_NUM_CC
    from vw_odmast_all od , vw_iod_all io, cfmast cf, aftype aft, afmast af, odtype odt,
    (SELECT * FROM sbbatchsts bs WHERE bs.bchmdl = 'ODFEECAL') bs
    where od.deltd <> 'Y'
        and cf.custid = af.custid
        and od.execamt <> 0
        and od.actype = odt.actype
        and od.orderid = io.orgorderid
        and od.exectype in ('MS')
        and af.actype = aft.actype
        and od.afacctno = af.acctno
        and od.txdate = V_F_DATE
        and trim(cf.custodycd) = V_CUSTODYCD
        and od.afacctno like V_STRAFACCTNO
        and od.clearday = TO_NUMBER(DATE_T)
        and io.symbol like V_STRSYMBOL
        and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = V_TLID )
        AND od.txdate = bs.bchdate(+)
        ;
EXCEPTION WHEN OTHERS THEN
    V_NUM_CC := 0;
END;
begin
    select sum(nvl(io.matchqtty*io.matchprice-
        (case when od.execamt > 0 and decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N' AND OD.TXDATE= V_CUR_DATE AND (v_repo2 = 'N' AND od.repotype <> 2) then
                  ROUND(floor(odt.deffeerate* od.execamt/100)*io.matchqtty * io.matchprice / od.execamt, 2)
         else
         (CASE WHEN (od.execamt * od.feeacr) = 0 THEN 0 ELSE
              ROUND(od.feeacr*io.matchqtty * io.matchprice / od.execamt, 2)
           END)
          end) -
        case
            when IO.iodtaxsellamt>0 then IO.iodtaxsellamt
        else
            (CASE WHEN aft.VAT = 'Y' THEN (V_VAT/100)*(IO.matchqtty * io.matchprice) else 0 end)
        end ---
            --CASE WHEN io.iodvatsellamt>0 THEN io.iodvatsellamt ELSE 0 END
        ,0)) into V_NUM_TT
    from vw_odmast_all od , vw_iod_all io, cfmast cf, aftype aft, afmast af, odtype odt,
    (SELECT * FROM sbbatchsts bs WHERE bs.bchmdl = 'ODFEECAL') bs
    where od.deltd <> 'Y'
        and cf.custid = af.custid
        and od.execamt <> 0
        and od.actype = odt.actype
        and od.orderid = io.orgorderid
        and od.exectype in ('NS')
        and af.actype = aft.actype
        and od.afacctno = af.acctno
        and od.txdate = V_F_DATE
        and trim(cf.custodycd) = V_CUSTODYCD
        and od.afacctno like V_STRAFACCTNO
        and od.clearday = TO_NUMBER(DATE_T)
        and io.symbol like V_STRSYMBOL
        and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = V_TLID )
        AND od.txdate = bs.bchdate(+)
        ;
EXCEPTION WHEN OTHERS THEN
    V_NUM_TT := 0;
END;
   -- GET REPORT'S DATA

OPEN PV_REFCURSOR
FOR
    select V_NUM_TT NUM_TT, V_NUM_CC NUM_CC,  cf.fullname, cf.custodycd, cf.address,
        DATE_T DATE_T, TRAN_DATE tr_date,
        max(od.orderid) orderid, io.symbol, sum(io.matchqtty) matchqtty, io.matchprice,
        sum(case when od.execamt > 0 and decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N' AND  od.TXDATE = V_CUR_DATE AND (v_repo2 = 'N' AND od.repotype <> 2) then
                  ROUND(floor(odt.deffeerate* od.execamt/100)*io.matchqtty * io.matchprice / od.execamt, 2)
             else
             (CASE WHEN (od.execamt * od.feeacr) = 0 THEN 0 ELSE
               ROUND(od.feeacr*io.matchqtty * io.matchprice / od.execamt, 2)
               END)
             end)  feeamt,
        od.txdate, od.codeid, od.afacctno, od.exectype matchtype,
        sum(
            case
                when IO.iodtaxsellamt>0 then IO.iodtaxsellamt
            else
                (CASE WHEN aft.VAT = 'Y' THEN (V_VAT/100)*(IO.matchqtty * io.matchprice) else 0 end)
            end --+
            --CASE WHEN io.iodvatsellamt>0 THEN io.iodvatsellamt ELSE 0 END
        ) taxsellamt
    from vw_odmast_all od , vw_iod_all io, cfmast cf, aftype aft, afmast af, odtype odt,
    (SELECT * FROM sbbatchsts bs WHERE bs.bchmdl = 'ODFEECAL') bs
    where od.deltd <> 'Y'
        and cf.custid = af.custid
        and od.execamt <> 0
        and od.actype = odt.actype
        and od.orderid = io.orgorderid
        and od.exectype in ('MS','NS')
        and af.actype = aft.actype
        and od.afacctno = af.acctno
        and od.txdate = V_F_DATE
        and trim(cf.custodycd) = V_CUSTODYCD
        and od.afacctno like V_STRAFACCTNO
        and od.clearday = TO_NUMBER(DATE_T)
        and io.symbol like V_STRSYMBOL
        and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = V_TLID )
        AND od.txdate = bs.bchdate(+)
    group by  io.symbol, io.matchprice, od.txdate, od.codeid, od.afacctno, od.exectype,
          cf.fullname, cf.custodycd,cf.address;

EXCEPTION
   WHEN OTHERS
   THEN
        RETURN;
END;
/