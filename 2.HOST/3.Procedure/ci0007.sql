CREATE OR REPLACE PROCEDURE ci0007 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   p_OPT            IN       VARCHAR2,
   p_BRID           IN       VARCHAR2,
   p_I_DATE         IN       VARCHAR2,
   p_BANKNAME       IN       VARCHAR2,
   --p_LOANTYPE       IN       VARCHAR2,
   --p_SIGNTYPE       IN       VARCHAR2,
   PV_CUSTODYCD     IN       VARCHAR2,
   PV_AFACCTNO      IN       VARCHAR2
       )
IS

-- RP NAME : Giai Ngan Tien Vay
-- PERSON : LinhLNB
-- DATE : 04/04/2012
-- COMMENTS : Create New
-- ---------   ------  -------------------------------------------
--l_LOANTYPE varchar2(100);
l_BANKNAME varchar2(100);
l_OPT varchar2(10);
l_BRID varchar2(1000);
l_BRID_FILTER varchar2(1000);
--l_TXDATE         IN       VARCHAR2,
V_CUSTODYCD       VARCHAR2(10);
V_AFACCTNO         VARCHAR2(10);
V_BRID              VARCHAR2(4);
BEGIN
-- GET REPORT'S PARAMETERS
l_BANKNAME:=p_BANKNAME; -- ALL, KBSV, CF.SHORTNAME
--l_LOANTYPE:=p_LOANTYPE; -- ALL, BL, CL, DF

l_OPT:=p_OPT;

    IF (PV_CUSTODYCD <> 'ALL' OR PV_CUSTODYCD <> '' OR PV_CUSTODYCD <> NULL) THEN
       V_CUSTODYCD  := PV_CUSTODYCD;
    ELSE
       V_CUSTODYCD  := '%';
    END IF;

    IF (PV_AFACCTNO <> 'ALL' OR PV_AFACCTNO <> '' OR PV_AFACCTNO <> NULL) THEN
       V_AFACCTNO  := PV_AFACCTNO;
    ELSE
       V_AFACCTNO  := '%';
    END IF;

    IF (p_BANKNAME <> 'ALL' OR p_BANKNAME <> '' OR p_BANKNAME <> NULL) THEN
       l_BANKNAME  := p_BANKNAME;
    ELSE
       l_BANKNAME  := '%';
    END IF;
/*
    IF (p_LOANTYPE <> 'ALL' OR p_LOANTYPE <> '' OR p_LOANTYPE <> NULL) THEN
       l_LOANTYPE  := p_LOANTYPE;
    ELSE
       l_LOANTYPE  := '%';
    END IF;*/
--l_TXDATE:= to_date(p_I_DATE,'DD/MM/RRRR');




IF (l_OPT = 'A') THEN
  l_BRID_FILTER := '%';
ELSE if (l_OPT = 'B') then
        select brgrp.mapid into l_BRID_FILTER from brgrp where brgrp.brid = p_BRID;
    else
        l_BRID_FILTER := p_BRID;
    end if;
END IF;

--select nvl(min(rlsdate),to_date(p_I_DATE,'DD/MM/RRRR')+1) into l_INITRLSDATE from rlsrptlog_eod;

-- GET REPORT'S DATA

OPEN PV_REFCURSOR FOR
SELECT DISTINCT UNG_TRUOC.ACCTNO,UNG_TRUOC.NGAYKHOP ,UNG_TRUOC.NGAY_UT,UNG_TRUOC.NGAY_THU_NO,UNG_TRUOC.TEN_KH,UNG_TRUOC.CUSTODYCD, UNG_TRUOC.ACCTNO,
UNG_TRUOC.TIEN_GN,UNG_TRUOC.HAN_MUC,UNG_TRUOC.DU_NO,getcurrdate NGAY_BANGKE,bank.contractno HOP_DONG_TD, UNG_TRUOC.SHORTNAME BANK_NAME
FROM (
     select * from
            (SELECT DISTINCT AD.ACCTNO ACCTNO_1,ADBF.DU_NO ,AD.TXDATE TX1
                    FROM (SELECT  ACCTNO,TXDATE, STATUS FROM adschd WHERE TXDATE <=TO_DATE(p_I_DATE ,'DD/MM/RRRR')
                      GROUP BY ACCTNO,TXDATE,STATUS)AD ,
                       (SELECT SUM(AMT) DU_NO , ACCTNO FROM adschd WHERE TXDATE <TO_DATE(p_I_DATE ,'DD/MM/RRRR')
                         GROUP BY ACCTNO) ADBF
                         WHERE AD.ACCTNO = ADBF.ACCTNO(+)
                               AND AD.STATUS <>'C'
                              -- AND AD.TXDATE= TO_DATE(p_I_DATE ,'DD/MM/RRRR')
              )AMT_NO,
              (select ads.txdate TX2,af.acctno ACCTNO_2,
                   NVL( cfb.fullname ,'KBSV') SHORTNAME , NVL(lm.lmamtmax,0) HAN_MUC
                     from adsource ads,afmast af, cfmast cfb, cflimit LM
                      where ads.acctno = af.acctno
                           and ads.custbank = cfb.custid(+)
                                and ads.status ='N'
                                   AND ads.deltd ='N'
                                    and ads.custbank = lm.bankid(+)
                 )HM,
                 (SELECT DISTINCT AF.acctno acctno, NVL(SUM(ADS.AMT + NVL(ADS.FEEAMT,0)),0) TIEN_GN,
                         CF.fullname TEN_KH, CF.custodycd CUSTODYCD, CHD.txdate NGAY_UT,CHD.cleardt NGAY_THU_NO,CHD.oddate NGAYKHOP
                  FROM ADSCHD CHD, adsource ADS, afmast AF, CFMAST CF
                  WHERE CHD.autoid = ADS.autoid
                        AND ADS.acctno = AF.acctno
                        AND AF.custid = CF.custid
                        AND ADS.DELTD <>'Y'
                        AND ADS.STATUS ='N'
                     GROUP BY AF.acctno, CF.fullname, CF.custodycd ,CHD.txdate,CHD.cleardt,CHD.oddate
                     ) TT_CHUNG
                     WHERE TT_CHUNG.ACCTNO=AMT_NO.ACCTNO_1
                            AND TT_CHUNG.ACCTNO=HM.ACCTNO_2
                            AND AMT_NO.TX1=HM.TX2
                            AND TT_CHUNG.NGAY_UT=AMT_NO.TX1
                            AND AMT_NO.TX1= TO_DATE(p_I_DATE ,'DD/MM/RRRR')
                              AND TT_CHUNG.ACCTNO LIKE V_AFACCTNO
                             AND TT_CHUNG.CUSTODYCD LIKE V_CUSTODYCD
                             AND NVL( HM.SHORTNAME,'-') LIKE  l_BANKNAME
)UNG_TRUOC
  left join bankcontractinfo bank on UNG_TRUOC.acctno = bank.acctno
  ;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

