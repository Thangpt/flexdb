CREATE OR REPLACE FORCE VIEW V_RM_GETT0LIST AS
SELECT CF.CUSTODYCD,AF.ACCTNO,CF.FULLNAME,CF.CAREBY,GRP.GRPNAME CBGROUP,AF.ACCTNO AFACCTNO,AF.BANKACCTNO,
CRB.BANKCODE,CRB.BANKCODE||':'||CRB.BANKNAME BANKNAME,
CI.BALANCE HOLDBALANCE,AF.advanceline,CI.depofeeamt,
B.EXECBUYAMT + B.BUYFEEACR EXECBUYAMT,NVL(C.SECUREAMT_INDAY,0) + B.trfbuyamt_over - CI.BALANCE + CI.DEPOFEEAMT MUSTHOLDAMT
FROM CIMAST CI,AFMAST AF,CFMAST CF,CRBDEFBANK CRB,TLGROUPS GRP,v_getbuyorderinfo B,vw_trfbuyinfo_inday C
WHERE B.AFACCTNO=CI.AFACCTNO AND B.AFACCTNO=C.AFACCTNO(+)
AND CI.AFACCTNO = AF.ACCTNO AND AF.CUSTID=CF.CUSTID
AND CRB.BANKCODE=AF.BANKNAME AND CI.COREBANK='Y' AND CF.CAREBY=GRP.GRPID(+)
AND GREATEST(NVL(C.SECUREAMT_INDAY,0) + B.trfbuyamt_over - CI.BALANCE + CI.DEPOFEEAMT,0)>0
ORDER BY CF.CUSTODYCD ASC;
