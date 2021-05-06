CREATE OR REPLACE PROCEDURE ln0024(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                                   OPT          IN VARCHAR2,
                                   BRID         IN VARCHAR2,
                                   I_DATE       IN VARCHAR2,
                                   PV_CUSTODYCD IN VARCHAR2,
                                   PV_AFACCTNO  IN VARCHAR2,
                                   PV_ACTION    IN VARCHAR2) IS
  --
  -- TONG HOP DU NO THEO KHACH HANG
  -- MODIFICATION HISTORY
  -- PERSON      DATE    COMMENTS
  -- THANHNM   28-JUN-2012  CREATE
  -- ---------   ------  -------------------------------------------
  -- PV_A            PKG_REPORT.REF_CURSOR;
  V_STROPTION VARCHAR2(5); -- A: ALL; B: BRANCH; S: SUB-BRANCH
  V_STRI_TYPE VARCHAR2(5);

  V_STRBRID VARCHAR2(40); -- USED WHEN V_NUMOPTION > 0
  V_INBRID  VARCHAR2(5);

  V_I_DATE    DATE;
  V_CUSTODYCD VARCHAR2(20);
  V_AFACCTNO  VARCHAR2(20);
  V_ACTION    VARCHAR2(20);

BEGIN

  V_STROPTION := upper(OPT);
  V_INBRID    := BRID;

  if (V_STROPTION = 'A') then
    V_STRBRID := '%';
  else
    if (V_STROPTION = 'B') then
      select br.mapid
        into V_STRBRID
        from brgrp br
       where br.brid = V_INBRID;
    else
      V_STRBRID := BRID;
    end if;
  end if;

  IF (PV_CUSTODYCD = 'ALL') THEN
    V_CUSTODYCD := '%%';
  ELSE
    V_CUSTODYCD := PV_CUSTODYCD;
  END IF;

  IF (PV_AFACCTNO = 'ALL') THEN
    V_AFACCTNO := '%%';
  ELSE
    V_AFACCTNO := PV_AFACCTNO;
  END IF;
  IF PV_ACTION = 'ALL' OR PV_ACTION IS NULL THEN
    V_ACTION := '%%';
  ELSE
    V_ACTION := PV_ACTION;
  END IF;

  V_I_DATE := TO_DATE(I_DATE, 'DD/MM/RRRR');

  OPEN PV_REFCURSOR FOR
    SELECT I_DATE I_DATE,
           PV_CUSTODYCD PV_CUSTODYCD,
           PV_AFACCTNO PV_AFACCTNO,
           PV_ACTION PV_ACTION,
           cf.custodycd CUSTODYCD,
           afs.refid AFACCTNO,
           cf.fullname USERNAME,
           RTRIM(afs.symbol,',') CODEID,
           decode(afs.action, 'DEL', 'Xóa', 'ADD', 'Thêm', afs.action) ACTIONNAME,
           (select tl.tlfullname
              from tlprofiles tl
             where tl.tlid = afs.maker) USERDEAL,
           (select tl.tlfullname
              from tlprofiles tl
             where tl.tlid = afs.approve) USERDUYET,
           RE.FULLNAME PCC,
           to_char(afs.txdate, 'dd/MM/yyyy') VALUEDATE,
           afs.txtime VALUETIME
      FROM afseruledetail afs,
           afmast af,
           cfmast cf,
           (select g.fullname,
                   r.afacctno,
                   r.reacctno,
                   substr(r.reacctno, 1, 10) recustid
              from reaflnk  r,
                   retype   rt,
                   regrplnk gl,
                   regrp    g,
                   recflnk  cl,
                   cfmast   cf
             where substr(r.reacctno, 11, 4) = rt.actype
               and rt.rerole in ('BM', 'RM') and r.status ='A'
               and gl.reacctno = r.reacctno
               and g.autoid = gl.refrecflnkid
               and cf.custid = cl.custid
               and cl.autoid = r.refrecflnkid
               and TO_DATE(I_DATE, 'DD/MM/YYYY') between r.frdate and
                   nvl(r.clstxdate - 1, r.todate)

               and TO_DATE(I_DATE, 'DD/MM/YYYY') between gl.frdate and
                   nvl(gl.clstxdate - 1, gl.todate)
               and TO_DATE(I_DATE, 'DD/MM/YYYY') between g.effdate and
                   g.expdate) RE
     where af.custid = cf.custid
       and afs.refid = af.ciacctno
       and afs.action like V_ACTION
       and cf.custodycd like V_CUSTODYCD
       and afs.refid like V_AFACCTNO
       and to_date(afs.txdate, 'DD/MM/RRRR') = V_I_DATE
       and re.afacctno(+) = af.acctno
	   AND afs.symbol IS NOT NULL
       order by afs.txdate,afs.txtime desc ;

EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END; -- PROCEDURE
/

