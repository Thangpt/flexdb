CREATE OR REPLACE PROCEDURE RM0001(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2
  )
IS
--
-- RP NAME : BAO CAO BAN LO LE - TAI KHOAN COREBANK
-- PERSON : QUYET.KIEU
-- DATE :   25/05/2011
-- COMMENTS : CREATE NEWS
-- ---------   ------  -------------------------------------------

v_CustodyCD varchar2(20);


BEGIN

IF  (PV_CUSTODYCD <> 'ALL')
THEN
      v_CustodyCD := replace(upper(PV_CUSTODYCD),' ','_');
ELSE
      v_CustodyCD := '%%';
END IF;

-- Main report
OPEN PV_REFCURSOR FOR


Select

 TL.txnum,
 TL.txdate,
 substr(TL.msgacct,0,10) afacctno,
 substr(TL.msgacct,11,6) codeid,
 sb.symbol,
 cf.custodycd,
 cf.fullname,
 cf.idcode,
 cf.iddate,
 nvl(msgamt,0) KL_GD,
 nvl(gia.gia,0) Gia,
(nvl(gia.gia,0)*nvl(msgamt,0) - nvl(phi.phi,0) ) Gia_tri,
 nvl(phi.phi,0) phi ,
 nvl(thue.thue,0) thue
 from
(
Select * from tllog   where  tltxcd='8815'  and txdate= to_date(I_DATE,'dd/mm/yyyy')
union all
Select * from tllogall where tltxcd='8815'and txdate= to_date(I_DATE,'dd/mm/yyyy')
)TL,
(
Select txnum , txdate , nvalue gia from
(
Select * from tllogfld where fldcd ='11' and txdate= to_date(I_DATE,'dd/mm/yyyy')
union all
Select * from tllogfldall where fldcd ='11' and txdate= to_date(I_DATE,'dd/mm/yyyy')
)
)Gia,
(
Select txnum , txdate , nvalue Phi from
(
Select * from tllogfld where fldcd ='22'  and txdate= to_date(I_DATE,'dd/mm/yyyy')
union all
Select * from tllogfldall where fldcd ='22'  and txdate= to_date(I_DATE,'dd/mm/yyyy')
)
)
phi ,
(
Select txnum , txdate , nvalue thue from
(
Select * from tllogfld where fldcd ='14'     and txdate= to_date(I_DATE,'dd/mm/yyyy')
union all
Select * from tllogfldall where fldcd ='14'  and txdate= to_date(I_DATE,'dd/mm/yyyy')
)
)thue,
afmast af,
cfmast cf,
sbsecurities sb
where
sb.codeid= substr(TL.msgacct,11,6)
and substr(TL.msgacct,0,10) = af.acctno
and af.custid = cf.custid
and af.corebank='Y'
and tl.txnum = phi.txnum
and tl.txdate = phi.txdate
and tl.txnum= thue.txnum
and tl.txdate= thue.txdate
and tl.txnum= gia.txnum
and tl.txdate= gia.txdate
and tl.txdate  = to_date(I_DATE,'dd/mm/yyyy')
and cf.custodycd like v_CustodyCD
;
EXCEPTION
  WHEN OTHERS
   THEN
      RETURN;
END;
/

