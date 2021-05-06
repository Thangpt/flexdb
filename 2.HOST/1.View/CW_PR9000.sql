create or replace view CW_PR9000 as
(
select a.*, NVL(B.PRINCALLMARGIN,0) princallprice from (
    select sb.codeid, sb.symbol, rm.roomlimit prlimit, nvl(afpr.prinused,0) prinused, sb.margincallprice,
    rm.roomlimit - nvl(afpr.prinused,0) pravllimit, sb.roomlimit, sb.roomlimitmax,sb.roomlimitmax_set, sb.listingqtty,
    nvl(afpr.prinused,0) markedqtty, c1.cdcontent ismarginallow, 'M' roomtype
    from vw_marginroomsystem rm, securities_info sb,
           (select codeid, sum(prinused) prinused from vw_afpralloc_all where restype = 'M' group by codeid) afpr,
                 securities_risk prallow,
                 allcode c1
    where rm.codeid = afpr.codeid(+) and rm.codeid = sb.codeid and rm.codeid = prallow.codeid(+) and nvl(prallow.ismarginallow,'N') = 'Y'
    and c1.cdname = 'YESNO' and c1.cdtype = 'SY' and c1.cdval = nvl(prallow.ismarginallow,'N')
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
) b where a.codeid = b.codeid_NUM(+)
);
