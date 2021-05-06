CREATE OR REPLACE PROCEDURE mr0017 (
    PV_REFCURSOR            IN OUT   PKG_REPORT.REF_CURSOR,
    OPT                     IN       VARCHAR2,
    BRID                    IN       VARCHAR2,
    I_TLID                    IN       VARCHAR2,
    I_DATE                  IN       VARCHAR2,
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
   v_Date                   DATE;
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

    v_Date := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);

  SELECT TO_DATE(VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
  INTO   v_CurrDate
  FROM   SYSVAR
  WHERE  grname = 'SYSTEM' AND varname = 'CURRDATE';

OPEN PV_REFCURSOR
FOR
SELECT v_Date tdate, CF.FULLNAME, C.FULLNAME MG_NAME, br.brid, BR.brname,
MR.CUSTODYCD, MR.AFACCTNO, tl.grpname, af.acctno,
--giai ngan mr
MR.PRIN_DRAWNDOWN_MARGIN,
--thanh toan goc mr
MR.PRIN_MOVE_MARGIN,
--thanh toan lai mr
MR.INT_MOVE_MARGIN,
--du no dau ky
MR.MRPRINAMT + MR.T0PRINAMT + MR.PRIN_MOVE_T0 + MR.PRIN_MOVE_MARGIN - MR.PRIN_DRAWNDOWN_MARGIN - MR.PRIN_DRAWNDOWN_T0  PRINAMT_DAUKY,
--du no cuoi ky
MR.mrprinamt,MR.t0prinamt,
--no lai
MR.t0intamt,MR.mrintamt
FROM cfmast cf, afmast af, BRGRP BR, MR5005_LOG mr,
(
     SELECT max(CF.CUSTID) CUSTID, max(CF.FULLNAME) FULLNAME, max(REA.AFACCTNO) AFACCTNO
     FROM REAFLNK REA, RETYPE RET, CFMAST  CF
     WHERE SUBSTR(REA.REACCTNO,11,4) = RET.ACTYPE AND RET.REROLE IN ('BM','RM')
           AND SUBSTR(REA.REACCTNO,1,10) =  CF.CUSTID(+)
           AND CF.CUSTID LIKE v_ReCustodycd
           --AND REA.STATUS <> 'C'
           and v_Date between REA.frdate and nvl(REA.clstxdate -1, REA.todate)
     GROUP BY CF.CUSTID, CF.FULLNAME, REA.AFACCTNO
) C,
(SELECT tl.grpid, tl.grpname FROM tlgroups tl, tlgrpusers tlu, tlprofiles tlp
WHERE tl.grpid = tlu.grpid AND tlp.tlid = tlu.tlid AND tlp.tlid = I_TLID
) tl,
(SELECT rl.afacctno, rl.produccode, max(autoid) autoid FROM (SELECT * FROM RegisterLog rl WHERE rl.txdate <= v_Date
ORDER BY TSYSDATE DESC ) rl GROUP BY afacctno,produccode) rl,
RegisterLog r
WHERE CF.CUSTODYCD = MR.CUSTODYCD AND CF.CUSTODYCD LIKE v_pvCustodycd
AND BR.BRID = SUBSTR(MR.AFACCTNO,1,4) AND cf.brid LIKE v_IBrid
AND af.careby LIKE v_reid
AND mr.txdate = v_Date
AND MR.AFACCTNO = af.ACCTNO --1.5.7.3 MSBS-1934
AND c.AFACCTNO = af.ACCTNO --1.5.7.3 MSBS-1934
AND cf.custid = af.custid AND af.acctno LIKE v_afacctno
AND af.careby = tl.grpid
AND (cf.brid LIKE V_STRBRID or instr(V_STRBRID,cf.brid) <> 0)
AND rl.afacctno = af.acctno
AND rl.autoid = r.autoid AND r.produccode LIKE v_PRODUCCODE AND r.actiotion = 'R'
;
EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
/
