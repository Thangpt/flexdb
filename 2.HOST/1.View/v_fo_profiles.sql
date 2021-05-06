CREATE OR REPLACE FORCE VIEW V_FO_PROFILES AS
SELECT tl.tlid USERID, af.acctno,
    'B' ROLETYPE, '' AUTHSTR, tl.tlname
FROM tlgroups tlg, tlgrpusers gu, afmast af, tlprofiles tl, cfmast cf
WHERE af.careby = tlg.grpid
    and tlg.grpid = gu.grpid
    and gu.tlid = tl.tlid
    AND af.custid = cf.custid
    AND cf.custodycd IS NOT NULL
UNION ALL -- Chu tai khoan
Select cf.custid, af.acctno,
    'O' ROLETYPE, '' AUTHSTR ,'' tlname
From cfmast cf, afmast af
Where cf.custid = af.custid
     AND cf.custodycd IS NOT NULL
UNION ALL -- Uy quyen
Select cf.custid, cfa.acctno,
    'A' ROLETYPE, cfa.LINKAUTH AUTHSTR,'' tlname
From cfauth cfa, cfmast cf
Where cfa.custid  = cf.custid
  AND cf.custodycd IS NOT NULL
  AND cfa.EXPDATE >=GETCURRDATE AND cfa.VALDATE <=GETCURRDATE
;

