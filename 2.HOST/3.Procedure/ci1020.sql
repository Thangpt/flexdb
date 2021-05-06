CREATE OR REPLACE PROCEDURE ci1020 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   pv_symbol      IN       VARCHAR2,
   CACODE         IN       VARCHAR2
 )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (16);        -- USED WHEN V_NUMOPTION > 0
   V_STRCUSTOCYCD     VARCHAR2 (20);
   V_STRAFACCTNO       VARCHAR2 (30);
   V_STRCACODE         VARCHAR2 (30);
   V_BRID VARCHAR2 (30);
   v_taxrate   number;
   v_currdate  date ;
   v_strsymbol       varchar(200);
   V_STROPT       varchar(20);
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
-- INSERT INTO TEMP_BUG(TEXT) VALUES('CF0001');COMMIT;
   V_STROPTION := upper(OPT);
  v_brid := brid;

select to_number(varvalue) into v_taxrate  from sysvar  where varname ='ADVSELLDUTY'  ;
select to_DATE(varvalue,'DD/MM/YYYY') into v_currdate   from sysvar  where varname ='CURRDATE'  ;

/*  IF  V_STROPTION = 'A' and v_brid = '0001' then
    V_STRBRID := '%';
    elsif V_STROPTION = 'B' then
        select br.mapid into V_STRBRID from brgrp br where br.brid = v_brid;
    else V_STROPTION := v_brid;
END IF;*/

 V_STROPT := upper(OPT);
--    V_INBRID := BRID;
    if(V_STROPT = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPT = 'B') then
            --select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
            V_STRBRID := substr(BRID,1,2) || '__' ;
        else
            V_STRBRID := BRID;
        end if;
    end if;

   IF (PV_CUSTODYCD <> 'ALL')
   THEN
      V_STRCUSTOCYCD := upper(PV_CUSTODYCD);
   ELSE
      V_STRCUSTOCYCD := '%%';
   END IF;

   IF (pv_AFACCTNO <> 'ALL')
   THEN
      V_STRAFACCTNO := pv_AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;

 IF (CACODE <> 'ALL')
   THEN
      V_STRCACODE := CACODE;
   ELSE
      V_STRCACODE := '%%';
   END IF;

 IF (pv_symbol <> 'ALL')
   THEN
      v_strsymbol := pv_symbol;
   ELSE
      v_strsymbol := '%%';
   END IF;


OPEN PV_REFCURSOR
  FOR
select  sep.txdate,cf.custodycd,af.acctno,cf.fullname,io.symbol, max( decode ( ca.catype,'021', cas.qtty,0)) cpt_qtty,
sum(sep.qtty) SEQTTY ,IO.matchprice, sum(sep.qtty*IO.matchprice ) MATCHAMT
, max(decode ( ca.catype,'011', cas.qtty,0)) CT_qtty,ROUND( sum( aright))  aright ,
 ROUND(sum( case when IO.matchprice >=sb.parvalue then sep.qtty*IO.matchprice*
    ( case when io.txdate = v_currdate then decode (aftype.vat,'Y',1,0)*  v_taxrate else od.taxrate/100 end )
  else 0 end )) tax
-- io.matchprice,io.custodycd ,cf.fullname,io.symbol, sep.*
from sepitallocate sep , vw_iod_all  io,cfmast cf,afmast af,camast ca,
(SELECT camastid, afacctno, deltd, sum(qtty) qtty FROM  caschd GROUP BY camastid, afacctno, deltd) cas,vw_odmast_all od,sbsecurities sb,
aftype
where sep.orgorderid = io.orgorderid
and io.orgorderid =od.orderid
and af.actype = aftype.actype
and sb.codeid = io.codeid
and  ca.camastid = sep.camastid
and io.txnum = sep.txnum
and io.txdate = sep.txdate
and sep.afacctno= af.acctno
and af.custid = cf.custid
and ca.camastid = cas.camastid
and cas.afacctno = af.acctno
and io.deltd <>'Y'
and cas.deltd <>'Y'
and io.symbol like v_strsymbol
and ca.camastid  like  V_STRCACODE
and af.acctno  like  V_STRAFACCTNO
and cf.custodycd  like  V_STRCUSTOCYCD
and io.txdate BETWEEN to_date (F_DATE,'dd/mm/yyyy') and to_date (T_DATE,'dd/mm/yyyy')
and substr(af.acctno,1,4) like V_STRBRID
group by  sep.txdate,cf.custodycd,af.acctno,cf.fullname,io.symbol,IO.matchprice

union all


select  sep.txdate,cf.custodycd,af.acctno,cf.fullname,SB.SYmbol, max( decode ( ca.catype,'021', cas.qtty,0)) cpt_qtty,
sum(sep.qtty) SEQTTY  ,ser.price matchprice, sum(sep.qtty*ser.PRICE ) MATCHAMT
, max(decode ( ca.catype,'011', cas.qtty,0)) CT_qtty,ROUND( sum( aright) ) aright ,
ROUND(sum(ser.taxamt)) tax
from sepitallocate sep ,cfmast cf,afmast af,camast ca,
    (SELECT camastid, afacctno, deltd, sum(qtty) qtty FROM caschd GROUP BY camastid, afacctno, deltd) cas,sbsecurities sb, seretail ser
where   ca.camastid = sep.camastid
and sep.afacctno= af.acctno
and af.custid = cf.custid
and ca.camastid = cas.camastid
and cas.afacctno = af.acctno
and sep.codeid =sb.codeid
and cas.deltd <>'Y'
and  TO_DATE( SUBSTR(sep.orgorderid,1,8),'DD/MM/YYYY')= ser.txdate
and SUBSTR(sep.orgorderid,9)=ser.txnum
and LENGTH(sep.orgorderid)=18
and sb.symbol like v_strsymbol
and ca.camastid  like  V_STRCACODE
and af.acctno  like  V_STRAFACCTNO
and cf.custodycd  like  V_STRCUSTOCYCD
and sep.txdate BETWEEN to_date (F_DATE,'dd/mm/yyyy') and to_date (T_DATE,'dd/mm/yyyy')
and substr(af.acctno,1,4) like V_STRBRID
group by  sep.txdate,cf.custodycd,af.acctno,cf.fullname,SB.symbol,ser.PRICE
order by txdate,custodycd,acctno;

EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
-- End of DDL Script for Procedure HOST.CA1018
/

