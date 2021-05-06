CREATE OR REPLACE FORCE VIEW VW_ACCOUNT_ADVT0 AS
SELECT AF.CAREBY, TL.TLID, TL.TLNAME, CF.CUSTODYCD, AF.ACCTNO, CF.FULLNAME, U.ACCLIMIT, UL.T0 USRLIMIT, AF.ADVANCELINE, AF.T0AMT, NVL(T0ACCUSER,0) T0ACCUSER,
        nvl(CASE WHEN mrt.mrtype IN ('S','T') THEN
                    round(GREATEST(least(af.advanceline - round(nvl(bor.trft0amt,0)) + greatest(round(nvl(trft0addamt,0))-greatest(round(u.accountpp)-round(nvl(bor.secureamt,0)*af.trfbuyrate/100),0),0),
                                            af.advanceline - round(nvl(bor.trft0amt,0)) + round(u.accountpp)-round(nvl(bor.secureamt,0)*af.trfbuyrate/100),
                                            NVL(T0S.T0ACCUSER,0)),0),0)
            ELSE
                    ROUND(GREATEST(LEAST(af.advanceline - round(nvl(bor.trft0amt,0)) + greatest(round(nvl(trft0addamt,0))-greatest(round(u.accountpp)-round(nvl(bor.secureamt,0)*af.trfbuyrate/100),0),0),
                                            nvl(greatest(round(u.accountpp)-round(nvl(bor.secureamt,0)*af.trfbuyrate/100),0),0),
                                            round(NVL(T0S.T0ACCUSER,0))),0), 0) -- BL USER CO THE THU HOI NGAY HIEN TAI
            END,0) ADVT0AMT,
               GREATEST(LEAST(round(AF.T0AMT), round(U.ACCLIMIT - NVL(T0ACCUSER,0))),0) ADVAMTHIST, -- BL USER CO THE THU HOI
               round(U.ACCLIMIT - T0ACCUSER) ACCUSERHIST -- BL USER CAP NGAY QUA KHU
               , CF.Custodycd||'.'||AFT.TYPENAME AFACCTNOFORMAT
        from (select u.*, FN_GET_ACCOUNT_PP(u.acctno,'U') accountpp from USERAFLIMIT U where  U.TYPERECEIVE='T0' and acclimit>0) u, AFMAST AF, CFMAST CF, TLPROFILES TL, USERLIMIT UL, AFTYPE AFT, MRTYPE MRT,
             (SELECT TLID, ACCTNO, SUM(S.ALLOCATEDLIMIT - S.RETRIEVEDLIMIT) T0ACCUSER FROM T0LIMITSCHD S
                   --WHERE S.ALLOCATEDDATE= (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME='SYSTEM' AND VARNAME='CURRDATE')
                   GROUP BY TLID, ACCTNO) T0S,
             v_getbuyorderinfo bor
        WHERE AF.CUSTID = CF.CUSTID

              AND AF.ACCTNO = U.ACCTNO
              AND TL.TLID  = U.TLIDUSER
              AND U.TLIDUSER = UL.TLIDUSER
              AND U.TLIDUSER = T0S.TLID(+)
              AND U.ACCTNO = T0S.ACCTNO(+)
              AND AFT.ACTYPE = AF.ACTYPE
              AND MRT.ACTYPE = AFT.MRTYPE(+)
              AND af.acctno = bor.afacctno(+)
;
