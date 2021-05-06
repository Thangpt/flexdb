CREATE OR REPLACE FORCE VIEW V_GETPRINTCREATEDEAL AS
(   
    SELECT A."ACTYPE",A."CUSTID",A."ACCTNO",A."FULLNAME",A."IDCODE",A."IDDATE",A."IDPLACE",A."ADDRESS",A."CUSTODYCD",A."RLSDATE",A."RRTYPE",A."CUSTBANK",A."CIACCTNO",A."CFRATE2",A."RATE2", GREATEST (NVL(CFLM.LMAMT,0) , NVL(CFL.LMAMT,0)) LIMITAMT FROM 
    (
            SELECT DFT.ACTYPE,CF.CUSTID, AF.ACCTNO, CF.FULLNAME, CF.IDCODE, CF.IDDATE, CF.IDPLACE, CF.ADDRESS, CF.CUSTODYCD, 
            (SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE' ) RLSDATE,
            LN.RRTYPE, NVL(LN.CUSTBANK,'') CUSTBANK, NVL(LN.CIACCTNO,'') CIACCTNO, LN.CFRATE2, LN.RATE2
            FROM AFMAST AF , DFTYPE DFT, CFMAST CF, LNTYPE LN
                WHERE CF.CUSTID = AF.CUSTID AND DFT.LNTYPE=LN.ACTYPE 
                AND LN.CUSTBANK = CF.CUSTID 
                --AND DFT.ACTYPE='0006' AND CF.CUSTID='0001000006'
               
    ) A, CFLIMITEXT CFLM, CFLIMIT CFL
    WHERE A.CUSTBANK = CFLM.BANKID (+) AND A.CUSTID = CFLM.CUSTID(+)
    AND A.CUSTBANK = CFL.BANKID (+)
)
;

