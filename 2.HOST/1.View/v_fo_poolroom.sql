CREATE OR REPLACE FORCE VIEW V_FO_POOLROOM AS
(
SELECT   DECODE(p.TYPE,'AFTYPE','SYSTEM','UB') policycd, prs.prtyp policytype,
                     scr.shortcd refsymbol,
                     prs.prlimit granted, prs.prinused inused
                  FROM   prmaster prs, sbcurrency scr ,PRTYPE p, PRTYPEMAP ptm
                 WHERE   prs.prtyp = 'P' AND prs.codeid = scr.ccycd
                    AND prs.PRCODE = ptm.PRCODE AND  ptm.PRTYPE =P.actype
UNION ALL
  SELECT   'SYSTEM', 'R', pr.symbol, max(pr.syroomlimit) roomlimit,
            max(pr.syroomused) + NVL (SUM(CASE WHEN restype = 'S' THEN NVL (afpr.prinused, 0) ELSE 0 END), 0)
               roomuse
    FROM   vw_marginroomsystem_fo pr, vw_afpralloc_all afpr
   WHERE   pr.codeid = afpr.codeid(+)
GROUP BY   pr.symbol
UNION ALL
SELECT   'UB', 'R', pr.symbol, max(pr.roomlimit) roomlimit,
            NVL (SUM(CASE WHEN restype = 'M' THEN NVL (afpr.prinused, 0) ELSE 0 END), 0)
               roomuse
    FROM   vw_marginroomsystem_fo pr, vw_afpralloc_all afpr
   WHERE   pr.codeid = afpr.codeid(+)
GROUP BY   pr.symbol
UNION ALL
SELECT to_char(MST.AUTOID) POLICYCD, 'R' POLICYTYPE,  SB.SYMBOL REFSYMBOL, MST.SELIMIT GRANTED,
fn_getusedselimitbygroup(MST.AUTOID) INUSED
FROM SELIMITGRP MST, SBSECURITIES SB
WHERE MST.CODEID= SB.CODEID AND MST.STATUS IN ('A','P')
UNION ALL
SELECT af.acctno POLICYCD, 'P' POLICYTYPE, 'VND'  REFSYMBOL , af.poollimit GRANTED, af.poollimit-
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
            and af.poolchk ='N'
);

