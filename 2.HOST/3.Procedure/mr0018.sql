CREATE OR REPLACE PROCEDURE mr0018 (
    PV_REFCURSOR            IN OUT   PKG_REPORT.REF_CURSOR,
    OPT                     IN       VARCHAR2,
    BRID                    IN       VARCHAR2,
    I_TLID                    IN       VARCHAR2,
    F_DATE                  IN       VARCHAR2,
    T_DATE                  IN       VARCHAR2,
    PV_CUSTODYCD            IN       VARCHAR2,
    PV_AFACCTNO             IN       VARCHAR2,
    P_REID                  IN       VARCHAR2,
    PV_RECUSTODYCD          IN       VARCHAR2,
    I_BRID                  IN       VARCHAR2,
    PRODUCCODE              IN       VARCHAR2
  )
IS
   V_STROPTION              VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID                VARCHAR2 (30);            -- USED WHEN V_NUMOPTION > 0
   v_brid                   varchar2 (4);
   v_FromDate               DATE;
   v_ToDate                 DATE;
   v_CurrDate               DATE;
   v_pvCustodycd            varchar(20);
   v_afacctno               varchar(20);
   v_reid                   varchar(20);
   v_ReCustodycd            varchar(20);
   v_IBrid                  varchar(100);
   v_PRODUCCODE             varchar(20);
BEGIN



   V_STROPTION := OPT;
   v_brid := BRID;


  IF V_STROPTION = 'A' THEN
      V_STRBRID    := '%';
  ELSIF V_STROPTION = 'B' THEN
      V_STRBRID    := substr(BRID,1,2) || '__' ;
  else
      V_STRBRID    :=BRID;
  END IF;

   IF  V_STROPTION = 'A' and BRID = '0001' then
    V_STRBRID := '%';
    elsif V_STROPTION = 'B' then
       select br.mapid into V_STRBRID from brgrp br where br.brid = v_brid;

    else V_STROPTION := BRID;
    END IF;

    if PV_CUSTODYCD = 'ALL' then
        v_pvCustodycd:= '%';
    else
        v_pvCustodycd:= PV_CUSTODYCD;
    end IF;

    if PV_AFACCTNO = 'ALL' then
        v_afacctno:= '%';
    else
        v_afacctno:= PV_AFACCTNO;
    end IF;


    if P_REID = 'ALL' then
        v_reid:= '%';
    else
        v_reid:= P_REID;
    end IF;

    if PV_RECUSTODYCD = 'ALL' then
        v_ReCustodycd:= '%';
    else
        v_ReCustodycd:= PV_RECUSTODYCD;
    end IF;

    if I_BRID = 'ALL' then
        v_IBrid:= '%';
    else
        v_IBrid:= I_BRID;
    end IF;

    if PRODUCCODE = 'ALL' then
        v_PRODUCCODE:= '%';
    else
        v_PRODUCCODE:= PRODUCCODE;
    end IF;

    v_FromDate                := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate                  := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

  SELECT TO_DATE(VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
  INTO   v_CurrDate
  FROM   SYSVAR
  WHERE  grname = 'SYSTEM' AND varname = 'CURRDATE';

OPEN PV_REFCURSOR
FOR
SELECT CF.FULLNAME, C.FULLNAME MG_NAME, br.brid, BR.brname,
CF.CUSTODYCD, AF.ACCTNO, tl.grpname, af.acctno,
od.FEEAMT, od.VAL_IO,r.status, round(nvl(tuoino,0),0) tuoino
FROM cfmast cf, afmast af, BRGRP BR,
(
     SELECT max(CF.CUSTID) CUSTID, max(CF.FULLNAME) FULLNAME, max(REA.AFACCTNO) AFACCTNO
     FROM REAFLNK REA, RETYPE RET, CFMAST  CF
     WHERE SUBSTR(REA.REACCTNO,11,4) = RET.ACTYPE AND RET.REROLE IN ('BM','RM')
           AND SUBSTR(REA.REACCTNO,1,10) =  CF.CUSTID (+)
           AND CF.CUSTID LIKE v_ReCustodycd
           --AND REA.STATUS <> 'C'
           and v_ToDate between REA.frdate and nvl(REA.clstxdate -1, REA.todate)
     GROUP BY CF.CUSTID, CF.FULLNAME, REA.AFACCTNO
) C,
(SELECT tl.grpid, tl.grpname FROM tlgroups tl, tlgrpusers tlu, tlprofiles tlp
WHERE tl.grpid = tlu.grpid AND tlp.tlid = tlu.tlid AND tlp.tlid = I_TLID
) tl,
(SELECT od.afacctno, SUM (OD.MATCHPRICE * MATCHQTTY) VAL_IO, sum(FEEAMT) FEEAMT
    FROM (SELECT OD.TXDATE,OD.AFACCTNO, OD.MATCHPRICE, SUM(OD.MATCHQTTY) MATCHQTTY,
            CASE WHEN OD.TXDATE = getcurrdate AND od.bchsts = 'N' THEN ROUND(SUM(OD.MATCHQTTY*OD.MATCHPRICE*OD.FEERATE/100)) ELSE SUM(OD.IODFEEACR) END FEEAMT
     FROM
     (
      SELECT  OD.TXDATE, OD.AFACCTNO,IOD.MATCHPRICE, IOD.MATCHQTTY, IOD.IODFEEACR, OD.FEEACR,OD.EXECAMT,OD.STSSTATUS,decode(nvl(bs.bchsts,'N'),'Y','Y','N') bchsts,
             CASE WHEN OD.EXECAMT >0 AND OD.FEEACR =0 AND OD.STSSTATUS = 'N' AND OD.TXDATE = v_CurrDate AND decode(nvl(bs.bchsts,'N'),'Y','Y','N') = 'N' THEN ROUND(ODT.DEFFEERATE,5) ELSE ROUND(OD.FEEACR/OD.EXECAMT*100,5) END FEERATE
      FROM VW_ODMAST_ALL OD, ODTYPE ODT,VW_IOD_ALL IOD, (SELECT * FROM sbbatchsts bs WHERE bs.bchmdl = 'ODFEECAL') bs
      WHERE  OD.TXDATE = bs.bchdate(+) AND ODT.ACTYPE = OD.ACTYPE
             AND OD.ORDERID = IOD.ORGORDERID AND IOD.DELTD = 'N' AND OD.DELTD = 'N'
             AND OD.TXDATE >= v_FromDate
             AND OD.TXDATE <= v_ToDate
     ) OD
    GROUP BY OD.TXDATE,OD.AFACCTNO, OD.MATCHPRICE, od.bchsts
    )OD
    GROUP BY OD.AFACCTNO
)OD,
(SELECT rl.afacctno, rl.produccode, max(autoid) autoid FROM (SELECT * FROM RegisterLog rl WHERE rl.txdate <= v_ToDate 
  ORDER BY TSYSDATE DESC ) rl GROUP BY afacctno,produccode
) rl,
(SELECT r.*, CASE WHEN p.produccode = r.produccode THEN 'Đăng ký' ELSE 'Đã hủy' END status 
  FROM RegisterLog r, RegisterProduc p WHERE r.afacctno = p.afacctno(+)
) r,
(
SELECT ln.TRFACCTNO, SUM(ls.PAIDDATE - ls.RLSDATE)/ COUNT(ln.TRFACCTNO) tuoino
FROM vw_lnschd_all ls, vw_lnmast_all LN 
WHERE ln.ACCTNO = ls.ACCTNO AND ls.PAIDDATE BETWEEN v_FromDate AND v_ToDate
AND ls.nml + ls.ovd+ ls.intnmlacr + ls.intdue + ls.intovd + ls.intovdprin + ls.feeintnmlacr + ls.feeintdue + ls.feeintnmlovd + ls.feeintovdacr <= 0
GROUP BY  ln.TRFACCTNO 
)LN
WHERE CF.CUSTODYCD LIKE v_pvCustodycd AND cf.brid LIKE v_IBrid AND af.careby LIKE v_reid 
AND af.acctno LIKE v_afacctno
AND af.careby = tl.grpid
AND (cf.brid LIKE V_STRBRID or instr(V_STRBRID,cf.brid) <> 0)
AND cf.custid = af.custid 
AND BR.BRID = SUBSTR(AF.ACCTNO,1,4) AND c.AFACCTNO(+) = af.acctno
AND af.acctno = od.AFACCTNO
AND rl.afacctno = af.acctno
AND rl.autoid = r.autoid AND r.produccode LIKE v_PRODUCCODE AND r.actiotion = 'R'
AND ln.TRFACCTNO(+) = af.acctno
;
EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
/
