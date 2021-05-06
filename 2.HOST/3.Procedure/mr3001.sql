CREATE OR REPLACE PROCEDURE mr3001 (
   PV_REFCURSOR             IN OUT   PKG_REPORT.REF_CURSOR,
   PV_OPT                      IN       VARCHAR2,
   PV_BRID                     IN       VARCHAR2,
   I_DATE                   IN       VARCHAR2,
   PV_ACTYPE                   IN       VARCHAR2,
   PV_CUSTODYCD             IN       VARCHAR2,
   PV_AFACCTNO              IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- BAO CAO TONG HOP MARGIN CALL THEO NGAY
-- PERSON   DATE  COMMENTS
-- QUOCTA  10-02-2012  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION         VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID           VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_ACTYPE            VARCHAR2 (20);
   V_CUSTODYCD         VARCHAR2(100);
   V_AFACCTNO          VARCHAR2(100);

BEGIN

    V_STROPTION := PV_OPT;

    IF (V_STROPTION <> 'A') AND (PV_BRID <> 'ALL')
    THEN
         V_STRBRID := PV_BRID;
    ELSE
         V_STRBRID := '%%';
    END IF;

-- GET REPORT'S PARAMETERS

    IF (PV_ACTYPE <> 'ALL' OR PV_ACTYPE <> '')
    THEN
         V_ACTYPE    :=    PV_ACTYPE;
    ELSE
         V_ACTYPE    :=    '%';
    END IF;

    IF (PV_CUSTODYCD <> 'ALL' OR PV_CUSTODYCD <> '')
    THEN
         V_CUSTODYCD    :=    PV_CUSTODYCD;
    ELSE
         V_CUSTODYCD    :=    '%';
    END IF;

    IF (PV_AFACCTNO <> 'ALL' OR PV_AFACCTNO <> '')
    THEN
         V_AFACCTNO    :=    PV_AFACCTNO;
    ELSE
         V_AFACCTNO    :=    '%';
    END IF;

OPEN PV_REFCURSOR
FOR
select af.actype, aft.typename, cf.custodycd, af.acctno, cf.fullname,
    ci.odamt, sec.NAVACCOUNT, sec.marginrate, ci.ovamt,
    greatest(round((case when nvl(sec.marginrate,0) * af.mrirate =0 then - outstanding else
                     greatest( 0,- outstanding - navaccount *100/af.mrirate) end),0),greatest(dueamt+ovamt+depofeeamt - balance - nvl(avladvance,0),0)) addvnd,
    tlg.grpname carebyname, nvl(SMSCOUNT,0) SMSCOUNT, calldate
from cfmast cf, afmast af, cimast ci, aftype aft, mrtype mrt, v_getsecmarginratio sec, tlgroups tlg,
(
   select count(1) SMSCOUNT, max(txdate) calldate, acctno from sendmsglog group by acctno
) sms
where cf.custid = af.custid and af.acctno = sec.afacctno
and af.actype = aft.actype and af.acctno = ci.acctno and af.careby = tlg.grpid
and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
and af.acctno = sms.acctno(+)
and cf.custodycd like V_CUSTODYCD
and af.acctno like V_AFACCTNO
and af.actype like V_ACTYPE
and ((af.mrlrate < round(sec.rlsmarginrate,0) AND round(sec.rlsmarginrate,0)<=af.mrmrate) or (ci.dueamt>1));


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

