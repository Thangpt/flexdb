CREATE OR REPLACE FORCE VIEW VW_ADSCHD_INFO AS
SELECT AD.AUTOID, AD.ISMORTAGE, AD.STATUS, AD.DELTD, AD.ACCTNO, AD.TXDATE, AD.TXNUM, AD.REFADNO,
       AD.CLEARDT,AD.AMT, AD.FEEAMT, AD.VATAMT, AD.BANKFEE, AD.PAIDAMT, AD.RRTYPE, AD.CUSTBANK,
       AD.CIACCTNO, AD.ODDATE,AD.PAIDDATE, A1.CDCONTENT RRTYPENAME, MST.ADTYPE , AD.ADTYPE ACTYPE,
       decode(AD.RRTYPE, 'O', 1,0) CIDRAWNDOWN,
       decode(AD.RRTYPE, 'B', 1,0) BANKDRAWNDOWN,
       decode(AD.RRTYPE, 'C', 1,0) CMPDRAWNDOWN
FROM ALLCODE A1, ADSCHD AD
    inner join
    (
        Select af.acctno, af.actype aftype, adt.actype adtype from afmast af, aftype aft, afidtype map, adtype adt
        where af.actype = aft.actype
              and aft.actype = map.aftype
              and map.objname ='AD.ADTYPE'
              and map.actype =  adt.actype
              --AND AF.ACCTNO IN ('0001000135','0001000078')
    )mst on AD.acctno = mst.acctno
WHERE AD.RRTYPE = A1.CDVAL AND A1.CDNAME ='RRTYPE' AND A1.CDTYPE ='LN'
;

