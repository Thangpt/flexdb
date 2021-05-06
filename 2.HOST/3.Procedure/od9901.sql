CREATE OR REPLACE PROCEDURE OD9901 (
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
--danh sach cac lenh offline cua user OT
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


   IF (CUSTODYCD <> 'ALL')
       THEN
          V_CUSTODYCD := CUSTODYCD;
       ELSE
          V_Custodycd := '%';
       End If;
    -- GET REPORT'S PARAMETERS

Open Pv_Refcursor For
        select  od.txtime,od.EXECTYPE,od.txdate,tl1.tlid,Nvl(tl1.Tlname,'ONLINE') Tlname,cf.custodycd,
              case when od.via = 'O' then 'ONLINE' else 'OFFLINE' end LOAI_GD, 
              case sb.tradeplace when '001' then 'HOSE' when '002' then 'HNX' when '005'  then 'UPCOM' end SAN_GD,sb.symbol,
              CASE WHEN od.EXECTYPE IN ('NS','MS','SS','NB','MB','SB') THEN od.ORDERQTTY ELSE 0 END KL_DAT,                                                                                                                                         
              CASE WHEN od.EXECTYPE IN ('NS','MS','SS','NB','MB','SB') THEN od.QUOTEPRICE ELSE 0 END GIA_DAT,                                                                                                                                         
              CASE WHEN od.EXECTYPE IN ('NS','MS','SS','NB','MB','SB') THEN od.EXECQTTY ELSE 0 END KL_KHOP,                                                                                                                                                                                                     
              CASE WHEN od.EXECTYPE IN ('NS','MS','SS','NB','MB','SB') THEN od.EXECAMT ELSE 0 END GT_KHOP,                                                                                                                                                    
              Od.Feeamt Phi_Thuc_Thu
      from cfmast cf , tlprofiles uf, brgrp br , tlgroups gr, vw_odmast_all od, sbsecurities sb,afmast af,tlgrpusers grus,vw_tllog_all vl,tlprofiles tl1
      where cf.tlid = uf.tlid                                                                                
          and uf.brid = br.brid   
          and uf.tlid = grus.tlid
          and grus.grpid = gr.grpid
          --and cf.careby = gr.grpid                                                                          
          and cf.custid = af.custid
          and af.acctno = od.afacctno                                                                      
          and sb.codeid = od.codeid    
          and od.ORDERQTTY >0
          and od.EXECTYPE IN ('NS','MS','SS','NB','MB','SB')
          --and od.execqtty > 0             
          And Od.Txdate <= To_Date (T_Date ,'DD/MM/YYYY') And Od.Txdate >= To_Date (F_Date ,'DD/MM/YYYY')
          And Cf.Custodycd Like V_Custodycd
          And Od.Txnum = Vl.Txnum And Od.Txdate = Vl.Txdate
          and vl.tlid = tl1.Tlid(+)  
          and gr.grpid ='0001'
          And Od.Via <> 'O'   
      order by od.txdate asc;
EXCEPTION
   WHEN OTHERS
   THEN
      Return;
END;
/

