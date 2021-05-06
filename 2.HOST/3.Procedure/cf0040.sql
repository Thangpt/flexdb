CREATE OR REPLACE PROCEDURE cf0040 (
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
   l_NAVACCOUNTT3  number(20,0);
   l_NAVACCOUNT_NOTROOM  number(20,0);
   l_ODAMT number(20,0);
   l_DUEAMT number(20,0);
   l_OVAMT number(20,0);
   l_TRFBUYAMT number(20,0);
   l_TRFSECUREDAMT number(20,0);
   l_TRFSECUREDAMT_INDAY number(20,0);
   l_SECUREDAMT_INDAY number(20,0);
   l_ADDADVANCELINE_INDAY number(20,0);
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
   l_TRFBUYRATE number(20,4);
   l_TRFBUYEXT number(20,4);
   l_trfbuyamtnofee_inday number(20,0);
   l_trfbuyamtnofee number(20,0);
   l_fixtrfsecureamt number(20,0);
   l_systrfbuyrate number(20,0);
   l_AUTOADV    VARCHAR2(1);
   l_SELLNOTMATCHAMT    NUMBER;
   l_SELLNOTMATCHEXCAMT    NUMBER;
   l_MRSTATUS    VARCHAR2(1);
   l_AVLADVAMT  NUMBER;
   L_NYOVDAMT NUMBER;
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
   --pr_error('CF0040','l_AFACCTNO:'|| l_AFACCTNO);
   -- END OF GETTING REPORT'S PARAMETERS

   -- l_systrfbuyrate:=100 - to_number(cspks_system.fn_get_sysvar('SYSTEM','TRFBUYRATE'));
   select 100 - to_number(varvalue) into l_systrfbuyrate from sysvar where grname ='SYSTEM' and varname ='TRFBUYRATE';

   --l_CIMASTcheck_arr := txpks_check.fn_CIMASTcheck(l_AFACCTNO,'CIMAST','ACCTNO');
   l_CIMASTcheck_arr := fn_cimastcheck_for_report(l_AFACCTNO,'CIMAST','ACCTNO');

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
   select nvl(sum(TRFSECUREDAMT),0), nvl(sum(TRFT0AMT_OVER),0), nvl(sum(TRFT0AMT),0), nvl(sum(TRFBUYAMT_OVER),0), nvl(sum(trfbuyamtnofee),0)
        into l_TRFSECUREDAMT, l_TRFT0AMT_OVER, l_TRFT0AMT, l_TRFBUYAMT_OVER, l_trfbuyamtnofee
   from v_getbuyorderinfo where afacctno = l_AFACCTNO;


   select nvl(sum(trfsecuredamt_inday),0), nvl(sum(secureamt_inday),0), nvl(sum(ADDADVANCELINE_INDAY),0), nvl(sum(trfbuyamtnofee_inday),0)
        into l_TRFSECUREDAMT_INDAY, l_SECUREDAMT_INDAY, l_ADDADVANCELINE_INDAY, l_trfbuyamtnofee_inday
   from vw_trfbuyinfo_inday where afacctno =  l_AFACCTNO;

   -- DEPOFEEAMT
   select nvl(sum(DEPOFEEAMT),0), nvl(sum(DFODAMT),0) into l_DEPOFEEAMT, l_DFODAMT from cimast where acctno = l_AFACCTNO;

   -- Fix Trf Securedamt
   l_fixtrfsecureamt:= (l_trfbuyamtnofee + l_trfbuyamtnofee_inday) * l_systrfbuyrate/100;

   --
   select nvl(sum(MARGINRATE),0), nvl(sum(RLSMARGINRATE),0)--,  nvl(sum(NAVACCOUNT),0)
        into l_MARGINRATE, l_RLSMARGINRATE--,l_NAVACCOUNT_NOTROOM
   from v_getsecmarginratio
   where afacctno = l_AFACCTNO;

   SELECT nvl(sum(se.semaxtotalcallass),0) INTO l_NAVACCOUNT_NOTROOM FROM v_getsecmargininfo se
   where afacctno = l_AFACCTNO;
   --
   select MRIRATE, MRMRATE, MRLRATE, MRCRLIMITMAX, ADVANCELINE, TRFBUYRATE, TRFBUYEXT
   into l_MRIRATE, l_MRMRATE, l_MRLRATE, l_MRCRLIMITMAX, l_ADVANCELINE, l_TRFBUYRATE, l_TRFBUYEXT
   from afmast where acctno = l_AFACCTNO;


    select custodycd, fullname, af.autoadv, CASE WHEN mr.mrtype IN ('N','L') THEN 'N' WHEN mr.mrtype IN ('S','T') THEN 'Y' ELSE 'N' END MRSTATUS
    into l_CUSTODYCD, l_FULLNAME, l_AUTOADV, l_MRSTATUS
    from cfmast cf, afmast af, aftype aft, mrtype mr
    where cf.custid = af.custid
        AND af.actype = aft.actype
        AND aft.mrtype = mr.actype
        and af.acctno = l_AFACCTNO;

    -- LAY THONG TIN LENH BAN CHUA KHOP TRONG NGAY
    SELECT round(nvl(sum(OD.REMAINQTTY*OD.QUOTEPRICE*(1 - od.taxrate/100 - OD.DEFFEERATE/100)*(1 - 3*od.advrate/360/100)),0)) SELLAMT,
        round(nvl(sum(OD.REMAINQTTY*nvl(AFS.MRRATIORATE,0)/100 * LEAST(nvl(AFS.MRPRICERATE,0), od.MARGINPRICE)),0)) SELLEXCAMT
    INTO l_SELLNOTMATCHAMT, l_SELLNOTMATCHEXCAMT
    FROM
        (SELECT OD.REMAINQTTY, OD.QUOTEPRICE, ODT.DEFFEERATE, ADT.ADVRATE,
        SEIF.MARGINPRICE, OD.CODEID, AF.ACTYPE, TO_NUMBER(SYS.VARVALUE) TAXRATE
        FROM ODMAST OD, ODTYPE ODT, SYSVAR SYS, SECURITIES_INFO SEIF, /*AFSERISK AFS, */AFMAST AF, AFTYPE AFT, ADTYPE ADT
        WHERE OD.ACTYPE = ODT.ACTYPE
            AND OD.EXECTYPE IN ('NS','SS'/*,'MS'*/) AND OD.DELTD = 'N'
            AND OD.TXDATE = GETCURRDATE
            AND SYS.GRNAME = 'SYSTEM' AND SYS.VARNAME = 'ADVSELLDUTY'
            AND OD.CODEID = SEIF.CODEID
            --AND OD.CODEID = AFS.CODEID (+)
            --AND AF.ACTYPE = AFS.ACTYPE (+)
            AND OD.AFACCTNO = AF.ACCTNO
            AND AFT.ACTYPE = AF.ACTYPE AND AFT.ADTYPE = ADT.ACTYPE
            AND OD.AFACCTNO = l_AFACCTNO
        ) OD
        LEFT JOIN
        AFSERISK AFS
        ON OD.CODEID = AFS.CODEID AND OD.ACTYPE = AFS.ACTYPE;

    -- LAY THONG TIN SO TIEN CHUA UNG TRUOC
    SELECT nvl(sum(GREATEST(MAXAVLAMT-ROUND(DEALPAID,0),0)),0) MAXAVLAMT
    INTO l_AVLADVAMT
    FROM
        (
            SELECT VW.MAXAVLAMT,
                (CASE WHEN VW.TXDATE =TO_DATE(SYS.VARVALUE,'DD/MM/RRRR') THEN fn_getdealgrppaid(VW.ACCTNO) ELSE 0 END)/
                    (1-ADT.ADVRATE/100/360*VW.days) DEALPAID
            FROM VW_ADVANCESCHEDULE VW, SYSVAR SYS, AFMAST AF, AFTYPE AFT ,ADTYPE ADT
            WHERE SYS.GRNAME='SYSTEM' AND SYS.VARNAME ='CURRDATE'
                AND VW.ACCTNO = AF.ACCTNo AND AF.ACTYPE=AFT.ACTYPE AND AFT.ADTYPE=ADT.ACTYPE
                AND VW.acctno = l_AFACCTNO
        );

    -- NO BAO LANH CHUA DEN HAN
    BEGIN
    SELECT nvl(sum(case when mintermdate >= getcurrdate then   (lns.nml + lns.ovd + lns.intdue + lns.intovd + lns.feedue + lns.feeovd + lns.intovdprin
                            + lns.feeintnmlacr + lns.feeintovdacr + lns.feeintnmlovd + lns.feeintdue
                             + lns.nmlfeeint + lns.ovdfeeint + lns.feeintnml +lns. feeintovd ) else 0 end) ,0)  INTO L_NYOVDAMT

    from lnschd lns, lnmast ln WHERE lns.acctno = ln.acctno
    AND ln.trfacctno =  l_AFACCTNO AND  reftype = 'GP'     ;
    EXCEPTION  WHEN  OTHERS  THEN

    L_NYOVDAMT:=0;
    END ;

   -- GET REPORT'S DATA
    OPEN PV_REFCURSOR
        FOR
        select
            l_CUSTODYCD CUSTODYCD,
            l_FULLNAME FULLNAME,
            l_AFACCTNO AFACCTNO,
            l_TRFBUYRATE TRFBUYRATE,
            l_TRFBUYEXT TRFBUYEXT,
            l_BALANCE BALANCE,
            l_bamt SECUREDAMT,
            l_advanceamount ADVANCEAMOUNT,
            l_paidamt PAIDAMT,
            l_avladvance AVLADVANCE,
            case when l_MARGINTYPE = 'T' then l_OUTSTANDING  - greatest(l_ADVANCELINE - l_TRFT0AMT,0) else 0 end OUTSTANDING,
            case when l_MARGINTYPE = 'T' then l_OUTSTANDINGT2 - greatest(l_ADVANCELINE - l_TRFT0AMT,0) else 0 end OUTSTANDINGT2,
            l_NAVACCOUNT NAVACCOUNT,
            l_NAVACCOUNTT2 NAVACCOUNTT2,
            l_NAVACCOUNT_NOTROOM NAVACCOUNT_NOTROOM,
            l_ODAMT ODAMT,
            l_DUEAMT + l_OVAMT OVAMT,
            l_TRFBUYAMT TRFBUYAMT,
            l_TRFSECUREDAMT - (l_TRFBUYAMT_OVER - l_TRFT0AMT_OVER) + l_TRFSECUREDAMT_INDAY TRFSECUREDAMT_IN,
            l_SECUREDAMT_INDAY SECUREDAMT_INDAY,
            l_TRFSECUREDAMT_INDAY TRFSECUREDAMT_INDAY,
            l_ADDADVANCELINE_INDAY ADDADVANCELINE_INDAY,
            l_TRFT0AMT_OVER TRFT0AMT_OVER,
            l_TRFBUYAMT_OVER - l_TRFT0AMT_OVER TRFSECUREDAMT_OVER,
            l_fixtrfsecureamt FIXTRFSECUREAMT,
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
            l_MARGINTYPE MARGINTYPE,
            l_systrfbuyrate SYSTRFBUYRATE,
            l_AUTOADV AUTOADV,
            l_SELLNOTMATCHAMT SELLNOTMATCHAMT,
            l_SELLNOTMATCHEXCAMT SELLNOTMATCHEXCAMT,
            l_MRSTATUS  MRSTATUS,
            l_AVLADVAMT AVLADVAMT,
            L_NYOVDAMT  NYOVDAMT
        from dual;

 EXCEPTION
   WHEN OTHERS
   THEN
        --pr_error('CF0040',dbms_utility.format_error_backtrace || ':'|| SQLERRM);
        dbms_output.put_line('CF0040:'||dbms_utility.format_error_backtrace || ':'|| SQLERRM);
        RETURN;
END;
/

