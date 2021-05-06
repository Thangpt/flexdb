CREATE OR REPLACE PROCEDURE ci0006(
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

/*select  remt.bankid bankacctno , remt.benefbank  bankname, remt.benefbank bankfullname,
    to_date(I_DATE, 'DD/MM/RRRR') searchdate, cf.custodycd f_tkluuky, af.acctno f_sotk, cf.fullname f_tenkh,
    remt.benefcustname t_nguoinhan, remt.beneflicense t_cmnd, remt.benefiddate t_ngaycap,
    remt.benefidplace t_noicap, remt.benefacct t_sotk,
    remt.benefbank t_nhnhan,
    remt.citybank  t_diachi_nhnhan, remt.cityef,
    remt.amt Sotien, tl.txdesc noidung,
    CASE WHEN V_POTMAP = '%%' THEN 'ALL' ELSE remt.potxnum END  so_ban_ke
from ciremittance remt, afmast af, cfmast cf, vw_citran_gen tl
where tl.tltxcd in ('1101','1108','1111','1119','1133')
    and tl.field = 'FLOATAMT'
    and tl.txtype = 'C'
    and remt.txdate = tl.txdate
    and remt.txdate = to_date(I_DATE, 'DD/MM/RRRR')
    and remt.txnum = tl.txnum
    and remt.acctno = af.acctno
    and af.custid = cf.custid;*/

/*select tr.bankacctno bankacctno , tr.fullname  bankname, tr.ownername bankfullname,
    to_date(I_DATE, 'DD/MM/RRRR') searchdate, cf.custodycd f_tkluuky, af.acctno f_sotk, cf.fullname f_tenkh,
    remt.benefcustname t_nguoinhan, remt.beneflicense t_cmnd, remt.benefiddate t_ngaycap,
    remt.benefidplace t_noicap, remt.benefacct t_sotk,
    remt.benefbank t_nhnhan,
    remt.citybank  t_diachi_nhnhan, remt.cityef,
    remt.amt Sotien, tl.txdesc noidung,
    CASE WHEN V_POTMAP = '%%' THEN 'ALL' ELSE remt.potxnum END  so_ban_ke
from ciremittance remt,
    (
        select DISTINCT tr.ref, bk.fullname, bk.ownername, bk.bankacctno, tr.txdate from vw_citran_gen tr,
            vw_tllogfld_all tl,   BANKNOSTRO bk
        where tr.tltxcd = '1104'
            and tr.txdate = to_date(I_DATE, 'DD/MM/RRRR')
            and ref like V_POTMAP
            and tr.txnum = tl.txnum
            and tr.txdate = tl.txdate
            and tl.fldcd = '08'
            and tl.cvalue =  REPLACE(bk.bankacctno,'.','')
    )  tr, afmast af, cfmast cf, vw_citran_gen tl
where tr.ref = remt.potxnum
    and tr.txdate = remt.txdate
    and tl.tltxcd in ('1101','1108','1111','1119','1133','1185')
    and tl.field = 'FLOATAMT'
    and tl.txtype = 'C'
    and remt.txdate = tl.txdate
    and remt.txnum = tl.txnum
    and remt.acctno = af.acctno
    and af.custid = cf.custid;*/

select
    cre.txdate, cre.txnum, bno.bankacctno bankacctno , bno.fullname  bankname, bno.ownername bankfullname,
    to_date(I_DATE, 'DD/MM/RRRR') searchdate, cf.custodycd f_tkluuky, af.acctno f_sotk, cf.fullname f_tenkh,
    cre.benefcustname t_nguoinhan, cre.beneflicense t_cmnd, cre.benefiddate t_ngaycap,
    cre.benefidplace t_noicap, cre.benefacct t_sotk,
    cre.benefbank t_nhnhan,
    cre.citybank  t_diachi_nhnhan, cre.cityef,
    cre.amt Sotien, gen.acctno ||' : ' || gen.txdesc noidung,
    CASE WHEN V_POTMAP = '%%' THEN 'ALL' ELSE cre.potxnum END  so_ban_ke
from ciremittance cre, vw_citran_gen ci, vw_tllogfld_all log, banknostro bno, cfmast cf, afmast af, vw_citran_gen gen
where ci.txdate = cre.potxdate and ci.ref = cre.potxnum
and cre.potxdate = I_DATE and cre.potxnum like V_POTMAP--and cre.potxnum not like '68%'
and log.txnum = ci.txnum and log.txdate = ci.txdate and log.fldcd = '08'
and log.cvalue =  REPLACE(bno.bankacctno,'.','')
and ci.tltxcd = '1104' and ci.field = 'FLOATAMT'
and cf.custid = af.custid and cre.acctno = af.acctno
--them vao de lay dien giai cua giao dich chuyen tien
and gen.txdate = cre.txdate and gen.txnum = cre.txnum and gen.tltxcd <> '1104' and gen.field = 'FLOATAMT'
;





EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

