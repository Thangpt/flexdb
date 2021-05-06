CREATE OR REPLACE FORCE VIEW V_GETDEALSELLAMT AS
select afacctno, groupid, sum(ADDAMOUNT) sellamount from (
    select a.orderid,a.afacctno,df.groupid, b.acctno, b.dfrate,df.mrate, QUOTEPRICE,remainqtty, A1.VARVALUE , B1.ADVRATE,
    TO_DATE(LNS.OVERDUEDATE,'DD/MM/RRRR') - TO_DATE(( SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') due  , od.DEFFEERATE,
    ROUND(QUOTEPRICE * remainqtty * (1 - (od.DEFFEERATE + A1.VARVALUE)  / 100) * (1 - ( B1.ADVRATE / 100 * 3) / 360) -
    (case when TO_DATE(LNS.OVERDUEDATE,'DD/MM/RRRR') - TO_DATE(( SELECT VARVALUE FROM SYSVAR WHERE VARNAME='CURRDATE'),'DD/MM/RRRR') >=0 then (remainqtty * b.dfrate /100 * S.FLOORPRICE) / (df.mrate/100) ELSE 0 END ),0) ADDAMOUNT

    from odmast a, dfmast b, dfgroup df, SYSVAR a1, lnschd lns, odtype od,SECURITIES_INFO S,
    (select AFM.ACCTNO, ADVRATE fROM ADTYPE AD, AFTYPE AF, AFMAST AFM WHERE AD.ACTYPE=AF.ADTYPE AND AF.ACTYPE=AFM.ACTYPE) B1
    where a.exectype in ('NS','MS') AND A.CODEID=S.CODEID
        and a1.VARNAME = 'ADVSELLDUTY'
        AND A.AFACCTNO=B1.ACCTNO and a.actype=od.actype
        and df.lnacctno=lns.acctno and lns.reftype = 'P'
        and isdisposal = 'Y' and a.dfacctno=b.acctno and a.afacctno=b.afacctno and df.groupid=b.groupid
) a  group by afacctno, groupid;

