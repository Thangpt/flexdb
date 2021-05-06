CREATE OR REPLACE PROCEDURE mr5005 (
    PV_REFCURSOR            IN OUT   PKG_REPORT.REF_CURSOR,
    OPT                     IN       VARCHAR2,
    BRID                    IN       VARCHAR2,
    F_DATE                  IN       VARCHAR2,
    T_DATE                  IN       VARCHAR2,
    PV_CUSTODYCD            IN       VARCHAR2,
    CUSTODYCD               IN       VARCHAR2,
    RRATE                   IN       VARCHAR2,
    p_BANKNAME              IN       VARCHAR2
  )
IS



   CUR                      PKG_REPORT.REF_CURSOR;
   V_STROPTION              VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID                VARCHAR2 (30);            -- USED WHEN V_NUMOPTION > 0
    v_brid                  varchar2 (4);
   v_FromDate               DATE;
   v_ToDate                 DATE;
   v_CurrDate               DATE;
   v_pvCustodycd            varchar(20);
   v_Custodycd              varchar(20);
   v_RRATE                  varchar(20);
   l_BANKNAME               varchar(20);
   v_strbankname            varchar(100);
BEGIN



   V_STROPTION              := OPT;
    v_brid:= BRID;
    l_BANKNAME:=p_BANKNAME; -- ALL, KBSV, CF.SHORTNAME


  IF V_STROPTION = 'A' THEN
      V_STRBRID    := '%';
  ELSIF V_STROPTION = 'B' THEN
      V_STRBRID    := substr(BRID,1,2) || '__' ;
  else
      V_STRBRID    :=BRID;
  END IF;

  if l_bankname = 'ALL' then
    v_strbankname:= '';
 elsif l_bankname = 'KBSV' then
    v_strbankname := 'KBSV';
 else
    select nvl(fullname, shortname) into v_strbankname from cfmast where custid = l_bankname;
 end if;


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


    if CUSTODYCD = 'ALL' then
        v_Custodycd:= '%';
    else
        v_Custodycd:= CUSTODYCD;
    end IF;

/*    if RRATE = 'ALL' then
        v_RRATE:= '%';
    elsIF  RRATE = 'MRATE'
        v_RRATE:= RRATE;
    end IF;
    */
    v_RRATE:=RRATE;

  v_FromDate                := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
  --v_ToDate                  := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);


select max(sbdate) into v_ToDate  from sbcldr  where sbdate <= TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT)  and holiday ='N';


  SELECT TO_DATE(VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
  INTO   v_CurrDate
  FROM   SYSVAR
  WHERE  grname = 'SYSTEM' AND varname = 'CURRDATE';

OPEN PV_REFCURSOR
FOR
select a.*,
    CASE WHEN a.amt = 0 THEN 'N'
        when bk.setotalcallass is null then 'Y'
      WHEN  BK.setotalcallass/
            DECODE(a.amt,0,0.0000001,a.amt) < 1 THEN 'Y'
     ELSE 'N' END NHAP_LAI_TS
     from
(
SELECT CF.FULLNAME, C.FULLNAME MG_NAME,  MR.RRTYPE, MR.custbank,br.brid, BR.brname,
MR.CUSTODYCD, MR.AFACCTNO,MR.PRIN_DRAWNDOWN_T0, MR.PRIN_DRAWNDOWN_MARGIN, MR.PRIN_MOVE_MARGIN, MR.prin_move_T0, MR.INT_MOVE_MARGIN, MR.INT_MOVE_T0,
MR.MRPRINAMT + MR.T0PRINAMT + MR.PRIN_MOVE_T0 + MR.PRIN_MOVE_MARGIN - MR.PRIN_DRAWNDOWN_MARGIN - MR.PRIN_DRAWNDOWN_T0  PRINAMT_DAUKY,
MR.mrprinamt,MR.t0prinamt, MR.setotalcallass, MR.t0intamt,MR.mrintamt, MR.marginrate, MR.mrmrate, MR.mrlrate, MR.amt2irate, MR.amt2mrate,
mr.marginrate_mr, MR.mrprinamt+MR.t0prinamt+MR.t0intamt+MR.mrintamt amt,
nvl((select max (txdate) from mr5005_log where txdate <= MR.txdate - 1),to_date('01/01/1999','DD/MM/RRRR')) beforeday
/*CASE WHEN MR.mrprinamt+MR.t0prinamt+MR.t0intamt+MR.mrintamt = 0 THEN 'N'
      WHEN  BK.setotalcallass/
            DECODE(MR.mrprinamt+MR.t0prinamt+MR.t0intamt+MR.mrintamt,0,0.0000001,MR.mrprinamt+MR.t0prinamt+MR.t0intamt+MR.mrintamt) < 1 THEN 'Y'
     ELSE 'N' END NHAP_LAI_TS*/
 FROM BRGRP BR, CFMAST CF, AFMAST AF--, MR5005_LOG bk
    , MR5005_LOG MR
   /* LEFT JOIN (
                SELECT CUSTODYCD, AFACCTNO,
                 SUM(PRIN_DRAWNDOWN_MARGIN) PRIN_DRAWNDOWN_MARGIN, SUM(PRIN_DRAWNDOWN_T0) PRIN_DRAWNDOWN_T0,
                 SUM(PRIN_MOVE_MARGIN) PRIN_MOVE_MARGIN, SUM(prin_move_T0) prin_move_T0,
                 SUM(INT_MOVE_MARGIN) INT_MOVE_MARGIN, SUM(INT_MOVE_T0) INT_MOVE_T0
                FROM (select * from MR5005_LOG
                   WHERE TXDATE BETWEEN v_FromDate AND v_ToDate) m
                GROUP BY   CUSTODYCD, AFACCTNO
                ORDER BY CUSTODYCD, AFACCTNO

               ) B ON MR.AFACCTNO = MR.AFACCTNO*/

    LEFT JOIN (
                --SELECT CF.CUSTID, CF.FULLNAME, REA.AFACCTNO FROM REAFLNK REA, RETYPE RET, CFMAST  CF
                SELECT max(CF.CUSTID) CUSTID, max(CF.FULLNAME) FULLNAME, max(REA.AFACCTNO) AFACCTNO FROM REAFLNK REA, RETYPE RET, CFMAST  CF
                    WHERE SUBSTR(REA.REACCTNO,11,4) = RET.ACTYPE AND RET.REROLE IN ('BM','RM')
                    AND SUBSTR(REA.REACCTNO,1,10) =  CF.CUSTID (+)
                    AND CF.CUSTID LIKE v_pvCustodycd
                    AND REA.STATUS <> 'C'
                group by CF.CUSTID, CF.FULLNAME, REA.AFACCTNO
              ) C ON MR.AFACCTNO = C.AFACCTNO

WHERE  MR.TXDATE BETWEEN v_FromDate AND v_ToDate AND CF.CUSTODYCD = MR.CUSTODYCD AND CF.CUSTODYCD LIKE v_Custodycd
AND MR.AFACCTNO = AF.ACCTNO
--AND MR.afacctno = BK.afacctno  and BK.txdate = (select max (txdate) from mr5005_log where txdate <= MR.txdate - 1)
-- and mr.rrtype = bk.rrtype
--and marginrate > (case when v_RRATE = 'ALL' THEN 0 end)
and (   (v_RRATE = 'ALL' and MR.marginrate >= 0 )
      or ((v_RRATE = 'MRATE') and (MR.marginrate > MR.mrlrate) and (MR.marginrate <= MR.mrmrate) )
      or  ( v_RRATE = 'LRATE' and MR.marginrate <= MR.mrlrate )
     )
and case when l_BANKNAME = 'ALL' then 1
       when l_BANKNAME = 'KBSV' and MR.rrtype = 'C' then 1
       when l_BANKNAME <> 'KBSV' and MR.rrtype = 'B' and l_BANKNAME like mr.custbank then 1
       else 0 end = 1
AND BR.BRID = cf.brid
and  (
    MR.MRPRINAMT + MR.T0PRINAMT + MR.PRIN_MOVE_T0 + MR.PRIN_MOVE_MARGIN - MR.PRIN_DRAWNDOWN_MARGIN - MR.PRIN_DRAWNDOWN_T0 >0
or  MR.PRIN_DRAWNDOWN_MARGIN + MR.PRIN_MOVE_MARGIN  + MR.INT_MOVE_MARGIN +  MR.PRIN_DRAWNDOWN_T0  + MR.PRIN_MOVE_T0 + MR.INT_MOVE_T0 > 0
)
AND  (cf.brid LIKE V_STRBRID or instr(V_STRBRID,cf.brid) <> 0 )
order by MR.CUSTODYCD, MR.AFACCTNO, RRTYPE, MR.custbank
) a
left join
MR5005_LOG bk
on a.afacctno = bk.afacctno and a.rrtype = bk.rrtype and a.beforeday = bk.txdate
and nvl(a.custbank,'XXXXX') = nvl(bk.custbank,'XXXXX')

;


EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;



/*
PROCEDURE mr5005 (
    PV_REFCURSOR            IN OUT   PKG_REPORT.REF_CURSOR,
    OPT                     IN       VARCHAR2,
    BRID                    IN       VARCHAR2,
    F_DATE                  IN       VARCHAR2,
    T_DATE                  IN       VARCHAR2,
    PV_CUSTODYCD            IN       VARCHAR2,
    CUSTODYCD               IN       VARCHAR2,
    RRATE                   IN       VARCHAR2
  )
IS



   CUR                      PKG_REPORT.REF_CURSOR;
   V_STROPTION              VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID                VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   v_FromDate               DATE;
   v_ToDate                 DATE;
   v_CurrDate               DATE;
   v_pvCustodycd            varchar(20);
   v_Custodycd              varchar(20);
   v_RRATE                  varchar(20);
BEGIN

   V_STROPTION              := OPT;

  IF V_STROPTION = 'A' THEN
      V_STRBRID    := '%';
  ELSIF V_STROPTION = 'B' THEN
      V_STRBRID    := substr(BRID,1,2) || '__' ;
  else
      V_STRBRID    :=BRID;
  END IF;

    if PV_CUSTODYCD = 'ALL' then
        v_pvCustodycd:= '%';
    else
        v_pvCustodycd:= PV_CUSTODYCD;
    end IF;


    if CUSTODYCD = 'ALL' then
        v_Custodycd:= '%';
    else
        v_Custodycd:= CUSTODYCD;
    end IF;

    v_RRATE:=RRATE;

  v_FromDate                := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
  --v_ToDate                  := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);


select max(sbdate) into v_ToDate  from sbcldr  where sbdate <= TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT)  and holiday ='N';


  SELECT TO_DATE(VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
  INTO   v_CurrDate
  FROM   SYSVAR
  WHERE  grname = 'SYSTEM' AND varname = 'CURRDATE';

OPEN PV_REFCURSOR
FOR


SELECT CF.FULLNAME, C.FULLNAME MG_NAME, B.CUSTODYCD, B.AFACCTNO,B.PRIN_DRAWNDOWN,  B.PRIN_MOVE, B.INT_MOVE, MRT0PRINAMT, setotalcallass,
MRT0PRINAMT +  B.PRIN_MOVE - B.PRIN_DRAWNDOWN  PRINAMT_dauky, mrt0intamt, marginrate, mrmrate, mrlrate, amt2irate, amt2mrate

 FROM CFMAST CF, MR5005_LOG MR
    LEFT JOIN (
                SELECT CUSTODYCD, AFACCTNO, SUM(PRIN_DRAWNDOWN) PRIN_DRAWNDOWN, SUM(PRIN_MOVE) PRIN_MOVE,SUM(INT_MOVE) INT_MOVE-- SUM(nvl(tl.msgamt,INT_MOVE)) INT_MOVE
                FROM (select * from MR5005_LOG
                    WHERE TXDATE BETWEEN v_FromDate AND v_ToDate) m
                GROUP BY   CUSTODYCD, AFACCTNO
                ORDER BY CUSTODYCD, AFACCTNO
               ) B ON MR.AFACCTNO = B.AFACCTNO

    LEFT JOIN (
                --SELECT CF.CUSTID, CF.FULLNAME, REA.AFACCTNO FROM REAFLNK REA, RETYPE RET, CFMAST  CF
                SELECT max(CF.CUSTID) CUSTID, max(CF.FULLNAME) FULLNAME, max(REA.AFACCTNO) AFACCTNO FROM REAFLNK REA, RETYPE RET, CFMAST  CF
                    WHERE SUBSTR(REA.REACCTNO,11,4) = RET.ACTYPE AND RET.REROLE IN ('BM','RM')
                    AND SUBSTR(REA.REACCTNO,1,10) =  CF.CUSTID (+)
                    AND CF.CUSTID LIKE v_pvCustodycd
                    AND REA.STATUS <> 'C'
                group by CF.CUSTID, CF.FULLNAME, REA.AFACCTNO
              ) C ON MR.AFACCTNO = C.AFACCTNO

WHERE  TXDATE = v_ToDate AND CF.CUSTODYCD = MR.CUSTODYCD AND CF.CUSTODYCD LIKE v_Custodycd
--and marginrate > (case when v_RRATE = 'ALL' THEN 0 end)
and (   (v_RRATE = 'ALL' and marginrate >= 0 )
      or ((v_RRATE = 'MRATE') and (marginrate > mrlrate) and (marginrate <= mrmrate) )
      or  ( v_RRATE = 'LRATE' and marginrate <= mrlrate )
     )
and  mr.PRIN_DRAWNDOWN + mr.PRIN_MOVE + mr.INT_MOVE + mr.MRT0PRINAMT >0
;


EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
*/
/

