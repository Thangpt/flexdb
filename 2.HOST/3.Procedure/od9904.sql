CREATE OR REPLACE PROCEDURE OD9904 (
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
--doanh so careby CTV
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

    select  od.txdate,cf.custodycd,uf.tlname,gr.grpname,cf.refname,cf1.fullname,dl.branch DaiLy,
            sum(CASE WHEN od.EXECTYPE IN ('NS','MS','SS','NB','MB','SB') THEN od.EXECAMT ELSE 0 END) GT_GD,
            Sum(Od.Feeamt) Phi
      From Cfmast Cf , Tlprofiles Uf, Brgrp Br , Tlgroups Gr, Vw_Odmast_All Od, Sbsecurities Sb,Afmast Af,Tlgrpusers Grus,Afmast Af1,Cfmast Cf1,Sbs_Cfmast_Mapping_Branch Dl
      Where cf.custodycd = dl.custodycd (+)
          and cf.tlid = uf.tlid
          And Uf.Brid = Br.Brid
         -- and uf.tlid = grus.tlid
         -- and grus.grpid = gr.grpid
          and cf.careby = gr.grpid
          and cf.custid = af.custid
          and af.acctno = od.afacctno
          and sb.codeid = od.codeid
          and od.execqtty > 0
          and od.EXECTYPE IN ('NB','MB','SB','NS','MS','SS')
          And Od.Txdate <= To_Date (T_Date ,'DD/MM/YYYY') And Od.Txdate >= To_Date (F_Date ,'DD/MM/YYYY')
          And Cf.Custodycd Like V_Custodycd
          --and gr.grpid ='0026'
          --and cf.careby = 0026
          and od.via <> 'O'
          and cf.refname = af1.acctno
          And Af1.Custid = Cf1.Custid
      group by od.txdate, cf.custodycd, uf.tlname, gr.grpname, cf.refname, cf1.fullname,dl.branch
      order by od.txdate,cf.custodycd;

EXCEPTION
   WHEN OTHERS
   THEN
      Return;
END;
/

