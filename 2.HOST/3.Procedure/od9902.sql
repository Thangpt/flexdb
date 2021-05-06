CREATE OR REPLACE PROCEDURE OD9902 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_Date         In       Varchar2,
   CUSTODYCD       IN       VARCHAR2,

   CURRENT_INDEX         NUMBER  DEFAULT NULL,
   OFFSET_NUMBER         NUMBER  DEFAULT NULL,
   ONL                   VARCHAR2  DEFAULT NULL
   )
IS
-- MODIFICATION HISTORY
--danh so cac lenh dat online cua OT
-- ---------   ------  -------------------------------------------
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_Strbrid        Varchar2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_Custodycd       Varchar2 (20);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
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
          V_CUSTODYCD := CUSTODYCD;
       ELSE
          V_Custodycd := '%';
       End If;

OPEN PV_REFCURSOR FOR

      select  od.txtime,od.txdate,od.EXECTYPE,uf.tlid,uf.tlname,cf.custodycd,br.brname,cn.branch ChiNhanh,
              case when od.via = 'O' then 'ONLINE' else 'OFFLINE' end LOAI_GD,
              case sb.tradeplace when '001' then 'HOSE' when '002' then 'HNX' when '005'  then 'UPCOM' end SAN_GD,sb.symbol,
              CASE WHEN od.EXECTYPE IN ('NB','MB','SB','NS','MS','SS') THEN od.ORDERQTTY ELSE 0 END KL_DAT,
              CASE WHEN od.EXECTYPE IN ('NB','MB','SB','NS','MS','SS') THEN od.QUOTEPRICE ELSE 0 END GIA_DAT,
              CASE WHEN od.EXECTYPE IN ('NB','MB','SB','NS','MS','SS') THEN od.EXECQTTY ELSE 0 END KL_KHOP,
              CASE WHEN od.EXECTYPE IN ('NB','MB','SB','NS','MS','SS') THEN od.EXECAMT ELSE 0 END GT_KHOP,
              Od.Feeamt Phi_Thuc_Thu
      From Cfmast Cf , Tlprofiles Uf, Brgrp Br , Tlgroups Gr, Vw_Odmast_All Od, Sbsecurities Sb,Afmast Af,Tlgrpusers Grus,Sbs_Cfmast_Mapping_Branch Cn
      Where cf.custodycd = cn.custodycd
          and cf.tlid = uf.tlid
          and uf.brid = br.brid
          and uf.tlid = grus.tlid
          and grus.grpid = gr.grpid
          and cf.custid = af.custid
          and af.acctno = od.afacctno
          and sb.codeid = od.codeid
          and od.execqtty > 0
          and od.EXECTYPE IN ('NB','MB','SB','NS','MS','SS')
          And Od.Txdate <= To_Date (T_Date ,'DD/MM/YYYY') And Od.Txdate >= To_Date (F_Date ,'DD/MM/YYYY')
          And Cf.Custodycd Like V_Custodycd
          --and gr.grpid ='0001'
          and od.via = 'O'
      order by od.txdate;

EXCEPTION
   WHEN OTHERS
   THEN
      Return;
END;
/

