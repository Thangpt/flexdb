CREATE OR REPLACE FORCE VIEW VW_MR9000_MSBS AS
(
SELECT A."TXDATE",A."CUSTODYCD",A."FULLNAME",A."AFACCTNO",A."BALANCE",A."DEPOFEEAMT",A."MRCRLIMITMAX",A."MRCRLIMIT",A."DFODAMT",A."CAREBY",A."ACCTNOKEY",A."REFULLNAME",A."GRPNAME",A."SECUREAMT",A."AVLADVANCE",A."BALADV",A."IODFEE",A."LNAMT",A."MARGINAMTADVPAY",A."AMTBFADVPAY",A."AVLMARGIN",
--14  = Max( 0,  Min ( 13, max(5-12,0) ) )
    GREATEST(0, LEAST(A.avlmargin, GREATEST(A.SECUREAMT - A.AMTBFADVPAY + A.lngplogAMT,0 ) )) EXMARGINAMT,
--15 = Min ( af.mrcrlimit, MAX (5 -12 -14,0), 5 )
    LEAST(A.MRCRLIMIT, GREATEST(A.SECUREAMT - A.AMTBFADVPAY - GREATEST(0, LEAST(A.avlmargin, GREATEST(A.SECUREAMT - A.AMTBFADVPAY,0 ) )),0  ),A.SECUREAMT)
        EXBREAKTDAMT,
--16 = Max (0, 5 - 12 - 14 -15)
    GREATEST(0, A.SECUREAMT - A.AMTBFADVPAY - GREATEST(0, LEAST(A.avlmargin, GREATEST(A.SECUREAMT - A.AMTBFADVPAY,0 ) ))
               - LEAST(A.MRCRLIMIT, GREATEST(A.SECUREAMT - A.AMTBFADVPAY - GREATEST(0, LEAST(A.avlmargin, GREATEST(A.SECUREAMT - A.AMTBFADVPAY,0 ) )),0  ),A.SECUREAMT)
            )
    EXT0AMT,remainamt

FROM

(
    SELECT A.*,RE.refullname, TL.GRPNAME, V_BUY.SECUREAMT,V_BUY.SECUREAMT-v_buy.execbuyamt-v_buy.buyfeeacr remainamt , NVL(V_ADV.DEPOAMT,0) AVLADVANCE, A.BALANCE +  NVL(V_ADV.DEPOAMT,0) BALADV, 0 IODFEE,
        --10,11
        NVL(LN.marginovdamt + ln.t0ovdamt + A.DEPOFEEAMT,0) LNAMT, NVL(LNADVPAY.marginamtadvpay,0) marginamtadvpay,
        --12 =  max (0, BALANCE + UTTB - 9 - 10 - 11)+ min (0,BALANCE +UTTB)
        GREATEST(0, A.BALANCE +  NVL(V_ADV.DEPOAMT,0) - 0 - NVL(LN.marginovdamt + ln.t0ovdamt + A.DEPOFEEAMT,0) - NVL(LNADVPAY.marginamtadvpay,0) )
            + LEAST (0, A.BALANCE +  NVL(V_ADV.DEPOAMT,0)) AMTBFADVPAY,
       least( GREATEST (0, A.BALANCE +  NVL(V_ADV.DEPOAMT,0)-nvl(ln.t0amt,0)) ,nvl(ln.NMLt0amt,0))   lngplogAMT,
        --13
        greatest(least(a.mrcrlimitmax - a.dfodamt, nvl(se.set0amt,0))
                - (
                    GREATEST (
                            nvl(ln.marginamt,0)
                            -  least(
                                        greatest(a.balance + nvl(V_ADV.DEPOAMT,0)- nvl(ln.NMLt0amt,0)- a.depofeeamt ,0) ,nvl(ln.marginovdamt,0) + NVL(LNADVPAY.marginamtadvpay,0)
                                    )
                         ,0 )
                  )
         ,0) avlmargin
    FROM (
        SELECT DISTINCT OD.TXDATE, CF.CUSTODYCD, CF.FULLNAME, OD.AFACCTNO, CI.BALANCE, CI.DEPOFEEAMT, af.MRCRLIMITMAX,af.MRCRLIMIT, ci.dfodamt, af.careby,
            af.ACCTNO || nvl(to_char(OD.TXDATE,'DD/MM/RRRR'),'') ACCTNOKEY
        FROM ODMAST OD, AFMAST AF, CFMAST CF, CIMAST CI
        WHERE OD.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID AND AF.ACCTNO = CI.AFACCTNO AND
            OD.TXDATE = GETCURRDATE
    ) A, v_getbuyorderinfo V_BUY, v_getAccountAvlAdvance V_ADV, v_getsecmargininfo SE,
    (
        select trfacctno, trunc(sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd),0) marginamt,
                         --trunc(sum(oprinnml+oprinovd+ointnmlacr+ointdue+ointovdacr+ointnmlovd),0) t0amt,
                          trunc(sum(t0amt),0) t0amt,
                          trunc(sum(NMLt0amt),0) NMLt0amt,
                         trunc(sum(prinovd+intovdacr+intnmlovd+feeintovdacr+feeintnmlovd + nvl(ls.dueamt,0) + intdue + feeintdue),0) marginovdamt,
                         trunc(sum(oprinovd+ointovdacr+ointnmlovd),0) t0ovdamt
                from lnmast ln, lntype lnt,
                        (select acctno, sum(nml) dueamt
                                from lnschd, (select * from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM') sy
                                where reftype = 'P' and overduedate = to_date(varvalue,'DD/MM/RRRR')
                                group by acctno) ls
                    ,(select acctno,
                            sum(case when mintermdate <= getcurrdate then   (nml + ovd + intdue + intovd + feedue + feeovd + intovdprin
                            + feeintnmlacr + feeintovdacr + feeintnmlovd + feeintdue
                             + nmlfeeint + ovdfeeint + feeintnml + feeintovd ) else 0 end)  t0amt
                             ,
                            sum(case when mintermdate >= getcurrdate then   (nml + ovd + intdue + intovd + feedue + feeovd + intovdprin
                            + feeintnmlacr + feeintovdacr + feeintnmlovd + feeintdue
                             + nmlfeeint + ovdfeeint + feeintnml + feeintovd ) else 0 end)  NMLt0amt
                        from lnschd where reftype = 'GP'  group by acctno
                        ) l
                where ftype = 'AF'
                        and ln.actype = lnt.actype
                        and ln.acctno = ls.acctno(+) and ln.acctno = l.acctno(+)
                group by ln.trfacctno
    )  ln,

    (
    select trfacctno,
             --trunc(sum(prinnml+intnmlacr+feeintnmlacr),0) marginamtadvpay
             trunc(sum(ls.nml + ls.intnmlacr + ls.feeintnmlacr),0) marginamtadvpay
    from lnmast ln, lntype lnt, lnschd ls
    where ftype = 'AF' and ln.advpay = 'Y'
            and ln.actype = lnt.actype  and ls.acctno = ln.acctno and ls.mintermdate <= getcurrdate
    group by ln.trfacctno
    ) LNADVPAY,

    (select re.afacctno, MAX(cf.fullname) refullname
        from reaflnk re, sysvar sys, cfmast cf,RETYPE
        where to_date(varvalue,'DD/MM/RRRR') between re.frdate and re.todate
        and substr(re.reacctno,0,10) = cf.custid
        and varname = 'CURRDATE' and grname = 'SYSTEM'
        and re.status <> 'C' and re.deltd <> 'Y'
        AND   substr(re.reacctno,11) = RETYPE.ACTYPE
        AND  rerole IN ( 'RM','BM')
        GROUP BY AFACCTNO
    ) re,
    (SELECT * FROM TLGROUPS WHERE GRPTYPE = '2') TL
WHERE A.AFACCTNO = V_BUY.AFACCTNO
    AND A.AFACCTNO = LN.trfacctno (+)
    AND A.AFACCTNO = LNADVPAY.trfacctno (+)
    AND A.AFACCTNO = V_ADV.AFACCTNO (+)
    AND A.AFACCTNO = se.AFACCTNO (+)
    AND A.AFACCTNO = RE.AFACCTNO(+)
    AND A.CAREBY = TL.GRPID(+)
) A

)
;

