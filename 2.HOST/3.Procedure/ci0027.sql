CREATE OR REPLACE PROCEDURE ci0027 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   pv_OPT            IN       VARCHAR2,
   pv_BRID           IN       VARCHAR2,
   pv_AFACCTNO       IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- LINHLNB   11-Apr-2012  CREATED
-- ---------   ------  -------------------------------------------
   l_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   l_STRBRID          VARCHAR2 (4);
   l_AFACCTNO         VARCHAR2 (20);


   l_cimastcheck_arr txpks_check.cimastcheck_arrtype;
   l_baldefovd number(20,0);
   l_baldeftrfamt number(20,0);
   l_balance number(20,0);
   l_emkamt number(20,0);
   l_bamt number(20,0);
   l_avladvance number(20,0);
   l_paidamt number(20,0);
   l_advanceamount  number(20,0);
   l_OUTSTANDING  number(20,0);
   l_OUTSTANDINGT2  number(20,0);
   l_NAVACCOUNT  number(20,0);
   l_NAVACCOUNTT2  number(20,0);
   l_ODAMT number(20,0);
   l_DUEAMT number(20,0);
   l_OVAMT number(20,0);
   l_TRFBUYAMT number(20,0);
   l_TRFSECUREDAMT number(20,0);
   l_TRFSECUREDAMT_INDAY number(20,0);
   l_TRFT0AMT number(20,0);
   l_TRFT0AMT_OVER number(20,0);
   l_TRFBUYAMT_OVER number(20,0);
   l_DEPOFEEAMT number(20,0);
   l_DFODAMT number(20,0);
   l_MARGINRATE number(20,4);
   l_RLSMARGINRATE number(20,4);
   l_MRIRATE number(20,4);
   l_MRMRATE number(20,4);
   l_MRLRATE number(20,4);
   l_MRCRLIMITMAX number(20,4);
   l_ADVANCELINE number(20,4);
   l_AVLLIMIT number(20,4);
   l_AVLLIMITT2 number(20,4);
   l_CUSTODYCD varchar2(20);
   l_FULLNAME varchar2(2000);
   l_MARGINTYPE varchar2(1);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   l_STROPTION := pv_OPT;

   IF (l_STROPTION <> 'A') AND (pv_BRID <> 'ALL')
   THEN
      l_STRBRID := pv_BRID;
   ELSE
      l_STRBRID := '%%';
   END IF;

   l_AFACCTNO  := replace(pv_AFACCTNO,'.','');
   pr_error('CI0027','l_AFACCTNO:'|| l_AFACCTNO);
   -- END OF GETTING REPORT'S PARAMETERS

   l_CIMASTcheck_arr := txpks_check.fn_CIMASTcheck(l_AFACCTNO,'CIMAST','ACCTNO');

   l_BALDEFOVD := l_CIMASTcheck_arr(0).BALDEFOVD;
   l_BALDEFTRFAMT := l_CIMASTcheck_arr(0).BALDEFTRFAMT;
   l_BALANCE := l_CIMASTcheck_arr(0).BALANCE;
   l_bamt := l_CIMASTcheck_arr(0).bamt;
   l_avladvance := l_CIMASTcheck_arr(0).avladvance;
   l_paidamt := l_CIMASTcheck_arr(0).paidamt;
   l_advanceamount := l_CIMASTcheck_arr(0).advanceamount;
   l_OUTSTANDING := l_CIMASTcheck_arr(0).OUTSTANDING;
   l_OUTSTANDINGT2 := l_CIMASTcheck_arr(0).OUTSTANDINGT2;
   l_NAVACCOUNT := l_CIMASTcheck_arr(0).NAVACCOUNT;
   l_NAVACCOUNTT2 := l_CIMASTcheck_arr(0).NAVACCOUNTT2;
   l_ODAMT := to_number(l_CIMASTcheck_arr(0).ODAMT);
   l_DUEAMT := l_CIMASTcheck_arr(0).DUEAMT;
   l_OVAMT := l_CIMASTcheck_arr(0).OVAMT;
   l_TRFBUYAMT := to_number(l_CIMASTcheck_arr(0).TRFBUYAMT);
   l_AVLLIMIT := to_number(l_CIMASTcheck_arr(0).AVLLIMIT);
   l_AVLLIMITT2 := to_number(l_CIMASTcheck_arr(0).AVLLIMITT2);
   l_emkamt := l_CIMASTcheck_arr(0).EMKAMT;
   l_MARGINTYPE := l_CIMASTcheck_arr(0).MRTYPE;

   -- TRFSECUREDAMT
   select nvl(sum(TRFSECUREDAMT),0), nvl(sum(TRFT0AMT_OVER),0), nvl(sum(TRFT0AMT),0), nvl(sum(TRFBUYAMT_OVER),0)
        into l_TRFSECUREDAMT, l_TRFT0AMT_OVER, l_TRFT0AMT, l_TRFBUYAMT_OVER
   from v_getbuyorderinfo where afacctno = l_AFACCTNO;
   select nvl(sum(trfsecuredamt_inday),0) into l_TRFSECUREDAMT_INDAY from vw_trfbuyinfo_inday where afacctno =  l_AFACCTNO;

   -- DEPOFEEAMT
   select nvl(sum(DEPOFEEAMT),0), nvl(sum(DFODAMT),0) into l_DEPOFEEAMT, l_DFODAMT from cimast where acctno = l_AFACCTNO;

   --
   select MARGINRATE, RLSMARGINRATE
        into l_MARGINRATE, l_RLSMARGINRATE
   from v_getsecmarginratio
   where afacctno = l_AFACCTNO;
   --
   select MRIRATE, MRMRATE, MRLRATE, MRCRLIMITMAX, ADVANCELINE into l_MRIRATE, l_MRMRATE, l_MRLRATE, l_MRCRLIMITMAX, l_ADVANCELINE
   from afmast where acctno = l_AFACCTNO;

   select custodycd, fullname
    into l_CUSTODYCD, l_FULLNAME
   from cfmast cf, afmast af
   where cf.custid = af.custid and af.acctno = l_AFACCTNO;


   -- GET REPORT'S DATA
    OPEN PV_REFCURSOR
        FOR
        select
            l_CUSTODYCD CUSTODYCD,
            l_FULLNAME FULLNAME,
            l_AFACCTNO AFACCTNO,
            l_BALANCE BALANCE,
            l_bamt SECUREDAMT,
            l_advanceamount ADVANCEAMOUNT,
            l_paidamt PAIDAMT,
            l_avladvance AVLADVANCE,
            case when l_MARGINTYPE = 'T' then l_OUTSTANDING  - greatest(l_ADVANCELINE - l_TRFT0AMT,0) else 0 end OUTSTANDING,
            case when l_MARGINTYPE = 'T' then l_OUTSTANDINGT2 - greatest(l_ADVANCELINE - l_TRFT0AMT,0) else 0 end OUTSTANDINGT2,
            l_NAVACCOUNT NAVACCOUNT,
            l_NAVACCOUNTT2 NAVACCOUNTT2,
            l_ODAMT ODAMT,
            l_DUEAMT + l_OVAMT OVAMT,
            l_TRFBUYAMT TRFBUYAMT,
            l_TRFSECUREDAMT - (l_TRFBUYAMT_OVER - l_TRFT0AMT_OVER) + l_TRFSECUREDAMT_INDAY TRFSECUREDAMT_IN,
            l_TRFT0AMT_OVER TRFT0AMT_OVER,
            l_TRFBUYAMT_OVER - l_TRFT0AMT_OVER TRFSECUREDAMT_OVER,
            l_DEPOFEEAMT DEPOFEEAMT,
            l_DFODAMT DFODAMT,
            l_MRIRATE MRIRATE,
            l_MRMRATE MRMRATE,
            l_MRLRATE MRLRATE,
            l_MARGINRATE MARGINRATE,
            l_RLSMARGINRATE RLSMARGINRATE,
            l_MRCRLIMITMAX MRCRLIMITMAX,
            l_ADVANCELINE ADVANCELINE,
            l_ADVANCELINE - l_TRFT0AMT T0ADVANCE,
            l_AVLLIMIT AVLLIMIT,
            l_AVLLIMITT2 AVLLIMITT2,
            l_emkamt EMKAMT,
            l_BALDEFOVD BALDEFOVD,
            l_BALDEFTRFAMT BALDEFTRFAMT,
            l_MARGINTYPE MARGINTYPE

        from dual;

 EXCEPTION
   WHEN OTHERS
   THEN
        pr_error('CI0027',dbms_utility.format_error_backtrace || ':'|| SQLERRM);
        RETURN;
END;
/

