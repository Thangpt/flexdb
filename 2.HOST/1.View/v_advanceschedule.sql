CREATE OR REPLACE FORCE VIEW V_ADVANCESCHEDULE AS
(
select af.autoadv,mta.afacctno, mta.execamt, mta.amt, mta.famt, mta.aamt, mta.paidamt, mta.paidfeeamt,  af.actype aftype,
       cf.custid, mta.cleardate, MTA.TXDATE, mta.vatrate, mta.feerate, MTA.CURRDATE,
       adt.advrate, adt.advminamt, adt.advbankrate, adt.advminfeebank, adt.ADVMINBANK,RIGHTVAT,
       adt.vatrate avatrate, adt.advmaxamt, adt.advminfee, adt.advmaxfee, adt.rrtype, adt.custbank, adt.ciacctno,
       (CASE WHEN AFT.VAT ='Y' THEN MTA.EXFEEAMT ELSE (MTA.EXFEEAMT-MTA.TAXSELLAMT-MTA.RIGHTVAT) END) EXFEEAMT,
       adt.advrate AINTRATE, adt.advbankrate AFEEBANK, adt.advminfee AMINBAL, adt.ADVMINBANK AMINFEEBANK,
       MTA.DAYS,
       adt.actype adtype, adt.typename adtypename,
       (CASE WHEN AFT.VAT ='Y' THEN MTA.AVLADVAMT ELSE (MTA.AVLADVAMT+MTA.TAXSELLAMT+MTA.RIGHTVAT) END) AVLADVAMT
from (select mt.afacctno, mt.cleardate, MAX(MT.TXDATE) TXDATE, round((sum(case when mt.feeacr <= 0 then (mt.deffeerate/100)*mt.execamt
                                                        else mt.feeacr end)/sum(execamt))*100,4) feerate,
             sum(MT.FEEACR + MT.TAXSELLAMT + MT.RIGHTVAT)  exfeeamt, sum(mt.execamt) execamt, sum(mt.amt) amt,
             sum(mt.aamt) aamt, sum(mt.paidamt) paidamt, sum(mt.paidfeeamt) paidfeeamt, sum(mt.famt) famt,sum(rightvat) rightvat,
             max(mt.TAXSELLRATE) vatrate,MAX(MT.DAYS) DAYS, MAX(CURRDATE) CURRDATE, SUM(MT.AMT - MT.FEEACR - MT.TAXSELLAMT) AVLADVAMT,
             SUM(MT.TAXSELLAMT) TAXSELLAMT
      from  (


            SELECT STS.AFACCTNO,STS.CLEARDATE,max(STS.TXDATE) TXDATE, --MST.ACTYPE,
                SUM(STS.AMT - NVL(ODM.EXECQTTY,0) * STS.AMT/STS.QTTY) EXECAMT,
                SUM(STS.AMT - NVL(ODM.EXECQTTY,0) * STS.AMT/STS.QTTY - (STS.AAMT - NVL(ODM.AAMT,0) ) -STS.FAMT+STS.PAIDAMT+STS.PAIDFEEAMT) AMT,
                SUM(STS.FAMT) FAMT,SUM(STS.AAMT) AAMT,
                SUM(STS.PAIDAMT) PAIDAMT,SUM(STS.PAIDFEEAMT) PAIDFEEAMT,
                max(odt.deffeerate) DEFFEERATE, max(to_number(sys.varvalue)) TAXSELLRATE,
                SUM(CASE WHEN MST.FEEACR >0 THEN MST.FEEACR ELSE round((STS.AMT - NVL(ODM.EXECQTTY,0) * STS.AMT/STS.QTTY) *ODT.DEFFEERATE/100) END) FEEACR,
                SUM(CASE WHEN MST.TAXSELLAMT >0 THEN MST.TAXSELLAMT ELSE round((STS.AMT - NVL(ODM.EXECQTTY,0) * STS.AMT/STS.QTTY)*TO_NUMBER(SYS.VARVALUE)/100) END) TAXSELLAMT,
                SUM(sts.ARIGHT) RIGHTVAT, MAX(TO_DATE(SYS2.varvalue,'DD/MM/YYYY')) CURRDATE,
                (CASE WHEN STS.CLEARDATE - MAX(TO_DATE(SYS2.varvalue,'DD/MM/YYYY')) =0 THEN 1 ELSE STS.CLEARDATE - MAX(TO_DATE(SYS2.varvalue,'DD/MM/YYYY')) END) DAYS
                --sum(SB.PARVALUE*RIGHTQTTY*to_number(sys1.varvalue)/100) RIGHTVAT
             FROM STSCHD STS,ODMAST MST, SYSVAR SYS, ODTYPE ODT, sbsecurities SB, SYSVAR SYS1, sysvar sys2,
                    (SELECT ORDERID,SUM(EXECQTTY) EXECQTTY, SUM(AAMT) AAMT FROM ODMAPEXT WHERE ISVSD='Y' AND DELTD <> 'Y' GROUP BY ORDERID) ODM

             WHERE STS.orgorderid=MST.orderid
                    AND STS.CODEID=SB.CODEID
                    AND STS.DELTD <> 'Y' AND STS.STATUS='N' AND STS.DUETYPE='RM'
                    and sys.varname = 'ADVSELLDUTY' and sys.grname = 'SYSTEM'
                    and sys1.varname = 'ADVVATDUTY' and sys1.grname = 'SYSTEM'
                    AND SYS2.VARNAME='CURRDATE' AND SYS2.GRNAME='SYSTEM'
                    and mst.actype = odt.actype
                    and mst.grporder<>'Y'
                    AND MST.ERROD = 'N'
                    AND STS.orgorderid = ODM.ORDERID (+)
             GROUP BY STS.AFACCTNO,STS.CLEARDATE


             ) MT
      group by mt.afacctno, mt.cleardate) mta,
            afmast af, cfmast cf, aftype aft, adtype adt
where mta.afacctno =  af.acctno and af.custid = cf.custid and af.actype = aft.actype
      and aft.adtype = adt.actype
      --AND aft.actype = map.aftype and adt.actype = map.actype and map.objname ='AD.ADTYPE' and adt.autoadv = 'Y'
      and cf.custatcom='Y' --Loai di nhung tai khoan luu ky ben ngoai
)
;

