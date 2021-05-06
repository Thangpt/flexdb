CREATE OR REPLACE FORCE VIEW V_FO_OWNPOOLROOM AS
SELECT to_char(MST.AUTOID) PRID , af.AFACCTNO ACCTNO, 'R' POLICYTYPE , SB.SYMBOL REFSYMBOL,
fn_getUsedSeLimit(af.afacctno, sb.codeid) INUSED
FROM SELIMITGRP MST, SBSECURITIES SB, afselimitgrp af
WHERE
MST.CODEID= SB.CODEID AND MST.STATUS IN ('A','P')
AND af.REFAUTOID = mst.AUTOID
UNION ALL
select af.acctno PRID, af.acctno ACCTNO, 'P' POLICYTYPE, 'VND' REFSYMBOL,af.poollimit -
               round(least(  af.poollimit, nvl(adv.avladvance,0)
                        + mst.balance
                        + af.poollimit
                        - mst.odamt
                        - mst.dfdebtamt
                        - mst.dfintdebtamt
                        - mst.depofeeamt
                        - NVL (advamt, 0)
                        - nvl(secureamt,0)
                        - ramt
                        - nvl(dealpaidamt,0)),0) INUSED
            from cimast mst,afmast af ,cfmast cf,
                (select * from v_getbuyorderinfo) al,
                (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance group by afacctno) adv,
                (select * from v_getdealpaidbyaccount p) pd
            where mst.acctno = af.acctno and af.custid = cf.custid
            and mst.acctno = al.afacctno(+)
            and adv.afacctno(+)=MST.acctno
            and pd.afacctno(+)=mst.acctno
            and af.poolchk ='N';

