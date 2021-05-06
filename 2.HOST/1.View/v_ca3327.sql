CREATE OR REPLACE FORCE VIEW V_CA3327 AS
(
SELECT schd.autoid,ca.camastid,cf.custodycd,af.acctno afacctno,sec1.codeid,sec2.codeid tocodeid,
sec1.symbol,sec2.symbol tosymbol,
ca.reportdate,schd.pqtty,schd.trade,(schd.pqtty+schd.qtty) maxqtty,
schd.qtty,ca.begindate,ca.duedate ,af.acctno,cf.fullname
FROM camast ca, caschd schd,cfmast cf, afmast af,sbsecurities sec1, sbsecurities sec2
WHERE ca.camastid=schd.camastid
AND schd.afacctno=af.acctno AND af.custid=cf.custid
AND ca.codeid=sec1.codeid AND ca.tocodeid=sec2.codeid
AND to_date(ca.begindate,'DD/MM/YYYY') <= to_date(GETCURRDATE,'DD/MM/YYYY')
AND to_date(ca.duedate,'DD/MM/YYYY') >= to_date(GETCURRDATE,'DD/MM/YYYY')
AND ca.catype='023' AND schd.status='V'
AND schd.pqtty>=1
AND schd.deltd='N'
 );

