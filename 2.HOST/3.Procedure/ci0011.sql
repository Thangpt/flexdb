CREATE OR REPLACE PROCEDURE ci0011(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   CUSTODYCD      IN       VARCHAR2,
   POTMAP         IN       VARCHAR2
 )
IS
--

-- ---------   ------  -------------------------------------------
   V_STROPTION     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID       VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   V_STRCUSTODYCD   VARCHAR2 (20);
   V_POTMAP varchar2(20);


BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS
  IF (CUSTODYCD <> 'ALL')
   THEN
      V_STRCUSTODYCD :=  CUSTODYCD;
   ELSE
      V_STRCUSTODYCD := '%%';
   END IF;

   IF (POTMAP <> 'ALL')
   THEN
      V_POTMAP :=  POTMAP;
   ELSE
      V_POTMAP := '%%';
   END IF;

   -- GET REPORT'S DATA

OPEN  PV_REFCURSOR FOR

        SELECT * FROM (
            select tr.bankacctno bankacctno , tr.fullname  bankname, tr.ownername bankfullname,
                to_date(I_DATE, 'DD/MM/RRRR') searchdate, cf.custodycd f_tkluuky, af.acctno f_sotk, cf.fullname f_tenkh,
                remt.benefcustname t_nguoinhan, remt.beneflicense t_cmnd, remt.benefiddate t_ngaycap,
                remt.benefidplace t_noicap, remt.benefacct t_sotk,
                remt.benefbank || ' - ' || remt.citybank || ' - ' || remt.cityef t_nhnhan,
                remt.amt Sotien, tl.txdesc noidung,
                CASE WHEN V_POTMAP = '%%' THEN 'ALL' ELSE remt.potxnum END  so_ban_ke
            from ciremittance remt,
                (
                    select DISTINCT tr.ref, bk.fullname, bk.ownername, bk.bankacctno  from vw_citran_gen tr,
                        vw_tllogfld_all tl, BANKNOSTRO bk
                    where tr.tltxcd = '1104'
                        and tr.txdate = to_date(I_DATE, 'DD/MM/RRRR')
                        and ref like V_POTMAP
                        and tr.txnum = tl.txnum
                        and tr.txdate = tl.txdate
                        and tl.fldcd = '08'
                        and REPLACE(bk.bankacctno,'.','') = tl.cvalue
                )  tr, afmast af, cfmast cf, vw_citran_gen tl
            where tr.ref = remt.potxnum
                and tl.tltxcd in ('1101','1108','1111','1119','1133')
                and tl.field = 'FLOATAMT'
                and tl.txtype = 'C'
                and remt.txdate = tl.txdate
                and remt.txnum = tl.txnum
                and remt.acctno = af.acctno
                and af.custid = cf.custid

        UNION ALL

            SELECT crb.refacctno bankacctno , bl.bankname bankname, crb.refacctname  bankfullname,
                to_date(I_DATE, 'DD/MM/RRRR') searchdate, tc.dcustodycd f_tkluuky, tc.dacctno f_sotk, cfd.fullname f_tenkh,
                cfc.fullname t_nguoinhan, cfc.idcode t_cmnd, cfc.iddate t_ngaycap,
                cfc.idplace t_noicap, cr.benefacct t_sotk,
                bl1.bankname t_nhnhan,
                cr.amt Sotien, tc.des noidung,
                '0' so_ban_ke
            FROM  ciremittance cr,(SELECT * FROM tcdt2DEPOACC_LOG UNION ALL SELECT * FROM tcdt2DEPOACC_LOG_HIST) tc,
             cfmast cfd, cfmast cfc, crbdefacct crb, CRBBANKMAP bm, CRBBANKLIST bl, CRBBANKMAP bm1, CRBBANKLIST bl1
            WHERE cr.txdate = tc.txdate AND cr.txnum = tc.txnum
            AND tc.dcustodycd = cfd.custodycd
            AND tc.ccustodycd = cfc.custodycd
            AND DECODE(Substr(tc.dacctno,1,4),'0101','BIDVHCM','BIDVHN') = crb.refbank
            AND crb.trfcode ='TCDT'
            AND substr(crb.refacctno,1,3) = bm.BankId (+)
            AND bm.BankCode = bl.BankCode (+)
            AND substr(cr.benefacct,1,3) = bm1.BankId (+)
            AND bm1.BankCode = bl1.BankCode (+)
            AND tc.TXDATE = to_date(I_DATE, 'DD/MM/RRRR')
            AND cr.rmstatus <> 'R'
        );
    /*

SELECT remt.txdate searchdate, brname f_chi_nhanh, tran.custodycd f_tkluuky, tran.acctno f_sotk, cf.fullname f_tenkh,
        remt.benefcustname t_nguoinhan, remt.beneflicense t_cmnd, remt.benefiddate t_ngaycap, remt.benefidplace t_noicap,
        remt.benefacct t_sotk, remt.benefbank t_nhnhan, remt.amt Sotien,
        tran.txdesc noidung,
        CASE WHEN V_POTMAP = '%%' THEN 'ALL' ELSE remt.potxnum END  so_ban_ke
FROM ciremittance remt,vw_citran_gen tran, cfmast cf, brgrp br
WHERE remt.rmstatus = 'C'
AND remt.deltd <> 'Y'
--AND tran.acctref = remt.potxnum
AND tran.txnum = remt.txnum
AND tran.tltxcd = '1101'
and tran.txcd ='0044'
AND tran.txdate = remt.txdate--potxdate
AND tran.custodycd = cf.custodycd
AND tran.brid = br.brid
AND remt.potxnum LIKE V_POTMAP
AND remt.txdate = to_date(I_DATE, 'DD/MM/RRRR')
ORDER BY tran.txdate, tran.txnum; */


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
