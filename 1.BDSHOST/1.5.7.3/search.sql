UPDATE search SET SEARCHCMDSQL = 'Select t.Txdate,t.Txnum,t.Afacctno,t.Produccode,a.Custodycd, cf.Fullname, re.fullname refullname, tl.GRPNAME
From Registerproduc t,Registerlog a,  tlgroups tl, cfmast cf, afmast af,
(SELECT cf.fullname,re.afacctno FROM reaflnk re, cfmast cf, retype ret 
WHERE SUBSTR(re.reacctno,1,10) = cf.custid AND SUBSTR(re.reacctno,11,4) = ret.actype
AND ret.rerole  IN (''BM'',''RM'') AND re.status = ''A''
) re
WHERE t.Afacctno = a.Afacctno AND t.Txnum = a.Txnum AND t.afacctno = af.acctno
AND af.custid = cf.custid AND af.careby = tl.grpid AND re.afacctno(+) = af.acctno' WHERE searchcode = 'CF0068';
COMMIT;