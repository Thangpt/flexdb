CREATE OR REPLACE VIEW CW_PR9001 AS
(
select a.*, NVL(B.SYSCALLMARGIN,0) princallprice from (
    select sb.codeid, sb.symbol, rm.syroomlimit prlimit, nvl(afpr.prinused,0) + sb.syroomused prinused,SB.margincallprice,
    sb.syroomlimit, sb.syroomlimit_set, sb.syroomused, sb.listingqtty,
    nvl(afpr.prinused,0) markedqtty,
    rm.syroomlimit - sb.syroomused - nvl(afpr.prinused,0) PRAVLLIMIT, 'S' roomtype
    from vw_marginroomsystem rm, securities_info sb, sbsecurities sbs,
           (select codeid, sum(prinused) prinused from vw_afpralloc_all where restype = 'S' group by codeid) afpr
    where rm.codeid = afpr.codeid(+) and rm.codeid = sb.codeid
    and rm.codeid = sbs.codeid and sbs.TRADEPLACE not in ('006','003')
) a ,
(
    select a.CODEID, A.CODEID_NUM, SUM(PRINUSED * NVL(afm.mrratioloan,0) /100 * MARGINREFPRICE) PRINCALLMARGIN,
     SUM(SYPRINUSED * NVL(afs.mrratioloan,0)/100 * MARGINPRICE) SYSCALLMARGIN from (
     SELECT  cf.custodycd, AFACCTNO, af.actype , SB.SYMBOL CODEID, SB.MARGINPRICE , SB.MARGINREFPRICE, sb.codeid codeid_num,
        SUM(case when AFPR.restype = 'M' then PRINUSED else 0 end) PRINUSED,
        SUM(case when AFPR.restype = 'S' then PRINUSED else 0 end) SYPRINUSED
        FROM vw_afpralloc_all AFPR, securities_info SB, afmast af, cfmast cf
        where SB.codeid = afpr.codeid and AFPR.afacctno = af.acctno and af.custid = cf.custid
        GROUP BY  AFACCTNO, SB.SYMBOL,sb.codeid,cf.custodycd,af.actype,SB.MARGINPRICE , SB.MARGINREFPRICE
        ORDER BY  AFACCTNO,cf.custodycd, CODEID

    ) a, AFSERISK AFS, afmrserisk afm
    where a.actype = afs.actype(+) and a.codeid_num = afs.codeid(+)
    and  a.actype = afm.actype(+) and a.codeid_num = afm.codeid(+)
    GROUP BY A.CODEID, A.CODEID_NUM
) b where a.codeid = b.CODEID_NUM(+)
);
