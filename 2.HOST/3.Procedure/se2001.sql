CREATE OR REPLACE PROCEDURE se2001 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         in       varchar2,
   T_DATE         in       varchar2,
   PV_CUSTODYCD         IN       VARCHAR2,
   PV_CFRELATION    IN  VARCHAR2
 )
IS

    V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);



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


OPEN PV_REFCURSOR FOR
SELECT   FN_GET_LOCATION(AF.BRID) LOCATION, cf.custodycd,cf.address, cf.fullname,
        cf.iddate, cf.idcode, cf.idplace, UQ.fullname UQ_nam, UQ.idcode UQ_code,
        UQ.iddate UQ_IDDATE, UQ.idplace UQ_idplace, UQ.chuc_vu UQ_Position,
        tt.*
  FROM   (SELECT   sedtl.acctno,  SUBSTR (sedtl.acctno, 1, 4)|| '.'|| SUBSTR (sedtl.acctno, 5, 6) afacctno,
                    sedtl.qtty qtty,sedtl.dfqtty,sedtl.txnum,TO_CHAR (sedtl.txdate, 'DD/MM/RRRR') txdate,
                    TO_CHAR (tl.BUSDATE, 'DD/MM/RRRR') BUSDATE, a0.cdcontent cd_qttytype,sedtl.qttytype,
                    tl.txdesc, dt.*
            FROM   (SELECT   sb.symbol, sb.codeid, sb.parvalue, sein.prevcloseprice price, a4.cdcontent tradeplace
                   FROM   securities_info sein, sbsecurities sb, allcode a4
                    WHERE     sb.codeid = sein.codeid
                    AND a4.cdtype = 'SE'
                    AND a4.cdname = 'TRADEPLACE'
                    AND a4.cdval = sb.tradeplace) dt,
           semastdtl sedtl,VW_TLLOG_ALL TL,
           allcode a0
           WHERE     sedtl.deltd <> 'Y'
            and sedtl.TXNUM = TL.TXNUM AND sedtl.TXDATE = TL.TXDATE
           AND a0.cdtype = 'SE'
           AND a0.cdname = 'QTTYTYPE'
           AND a0.cdval = sedtl.qttytype
           AND sedtl.qtty > 0
           AND SUBSTR (sedtl.acctno, 11, 6) = dt.codeid
           and sedtl.qttytype = '007'
           and sedtl.txdate <= to_date(T_DATE, 'DD/MM/RRRR')
           and sedtl.txdate >= to_date(F_DATE, 'DD/MM/RRRR')) tt,
cfmast cf,
afmast af,
(
    select trim(r.custid) custid, c.fullname, c.idcode, c.iddate, c.idplace,  a.cdcontent chuc_vu
    from CFRELATION r, cfmast c, allcode a
    where c.custid = trim(r.recustid) and a.cdname = 'RETYPE' and a.cdtype = 'CF' and a.cdval = r.retype AND C.CUSTID = NVL(PV_CFRELATION,' ')
) UQ
 WHERE   af.acctno = SUBSTR (tt.acctno, 1, 10) AND af.custid = cf.custid  and cf.custid = UQ.custid (+)  and cf.custodycd =  PV_CUSTODYCD
;
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/

