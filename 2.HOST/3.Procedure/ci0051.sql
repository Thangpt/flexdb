CREATE OR REPLACE PROCEDURE ci0051(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   PV_TLTX        IN       VARCHAR2,
   PV_MAKER       IN       VARCHAR2
 )
IS
--

-- ---------   ------  -------------------------------------------
   V_STROPTION     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID       VARCHAR2 (40);                   -- USED WHEN V_NUMOPTION > 0
   V_INBRID        VARCHAR2 (4);

   V_STRCUSTODYCD   VARCHAR2 (20);
   V_POTMAP varchar2(20);



   V_strtltxcd  varchar2(10);
   v_strmaker   varchar2(10);

BEGIN
   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   IF (V_STROPTION = 'A')
   THEN
      V_STRBRID := '%';
   ELSE if (V_STROPTION = 'B') then
            select brgrp.mapid into V_STRBRID from brgrp where brgrp.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
   END IF;

   -- GET REPORT'S PARAMETERS

    if(upper(PV_TLTX) = 'ALL' or LENGTH(PV_TLTX) <= 1 ) then
        V_strtltxcd := '%';
    else
        V_strtltxcd := PV_TLTX;
    end if;

    if(UPPER(PV_MAKER) = 'ALL' or LENGTH(PV_MAKER) <= 1 ) THEN
        v_strmaker := '%';
    else
        v_strmaker := PV_MAKER;
    end if;

   -- GET REPORT'S DATA

OPEN  PV_REFCURSOR FOR
/*
SELECT remt.txdate searchdate, brname f_chi_nhanh, tran.custodycd f_tkluuky, tran.acctno f_sotk, cf.fullname f_tenkh,
        remt.benefcustname t_nguoinhan, remt.beneflicense t_cmnd, remt.benefiddate t_ngaycap, remt.benefidplace t_noicap,
        remt.benefacct t_sotk,
         remt.benefbank || ' - ' || remt.cityef || ' - ' ||  remt.citybank t_nhnhan, remt.amt Sotien,tran.txdesc noidung
FROM ciremittance remt,vw_citran_gen tran, cfmast cf, brgrp br
WHERE ---remt.rmstatus = 'C' AND
    remt.deltd <> 'Y'
AND tran.txnum = remt.txnum
AND tran.tltxcd IN ('1101','1108','1111','1119','1133','1185')
and tran.tltxcd like V_strtltxcd
and (tran.brid like V_STRBRID or INSTR(V_STRBRID,tran.brid) <> 0)
and tran.field = 'FLOATAMT'
AND tran.txdate = remt.txdate--potxdate
AND tran.custodycd = cf.custodycd
AND tran.brid = br.brid
AND TRAN.txdate = to_date(I_DATE, 'DD/MM/RRRR')
and tran.tlid like v_strmaker
--and tran.brid like V_STRBRID
ORDER BY tran.txdate, tran.txnum;
*/

    SELECT * FROM (
        SELECT remt.txdate searchdate, brname f_chi_nhanh, tran.custodycd f_tkluuky, tran.acctno f_sotk, cf.fullname f_tenkh,
                remt.benefcustname t_nguoinhan, remt.beneflicense t_cmnd, remt.benefiddate t_ngaycap, remt.benefidplace t_noicap,
                remt.benefacct t_sotk,
                 t_nhnhan, remt.amt Sotien,tran.txdesc noidung
        FROM
        (
        select TXDATE,TXNUM,DELTD, benefcustname, beneflicense, benefiddate, benefidplace, benefacct,
            benefbank || ' - ' || cityef || ' - ' ||  citybank t_nhnhan, AMT
        FROM ciremittance
        UNION ALL
        select TXDATE,TXNUM,DELTD, benefcustname, beneflicense, benefiddate, benefidplace, benefacct,
            benefbank || ' - ' || cityef || ' - ' ||  citybank t_nhnhan, AMT
        FROM cirewithdraw) REMT,vw_citran_gen tran, cfmast cf, brgrp br
        WHERE ---remt.rmstatus = 'C' AND
            remt.deltd <> 'Y'
        AND tran.txnum = remt.txnum
        AND tran.tltxcd IN ('1101','1108','1111','1119','1133','1185')
        and tran.tltxcd like V_strtltxcd
        and (tran.brid like V_STRBRID or INSTR(V_STRBRID,tran.brid) <> 0)
        and tran.field = 'FLOATAMT'
        AND tran.txdate = remt.txdate--potxdate
        AND tran.custodycd = cf.custodycd
        AND tran.brid = br.brid
        AND TRAN.txdate = to_date(I_DATE, 'DD/MM/RRRR')
        --and tran.tlid like v_strmaker
        --and tran.brid like V_STRBRID
       -- ORDER BY tran.txdate, tran.txnum

        UNION ALL

        SELECT cr.txdate searchdate, bl.bankname f_chi_nhanh, tc.dcustodycd f_tkluuky, tc.dacctno f_sotk, cfd.fullname f_tenkh,
               cfc.fullname t_nguoinhan, cfc.idcode t_cmnd, cfc.iddate t_ngaycap, cfc.idplace t_noicap,
               cr.benefacct t_sotk,
               bl1.bankname t_nhnhan, cr.amt Sotien,tc.des noidung
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
                    AND cr.rmstatus <> 'R'
                    AND cr.txdate = to_date(I_DATE, 'DD/MM/RRRR')
                    AND '1201' like V_strtltxcd
                    AND (tc.brid like V_STRBRID or INSTR(V_STRBRID,tc.brid) <> 0)
    )
    ORDER BY searchdate;



EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
