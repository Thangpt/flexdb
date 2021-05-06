CREATE OR REPLACE PROCEDURE DF9901 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTODYCD       IN       VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- danh sach cac deal vay care by OT

-- ---------   ------  -------------------------------------------
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_CUSTODYCD       VARCHAR2 (20);

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
          V_CUSTODYCD := '%';
       END IF;


     Open Pv_Refcursor For
         SELECT v.*, ln.overduedate, nvl(NML,0) DUEAMT,CD.CDCONTENT DEALSTATUS,CD1.CDCONTENT DEALFLAGTRIGGER,round(mrate/100*refprice,0) CALLPRICE,gr.grpname,tl.tlname,la.tlid,tl1.tlname UserTaoHD
          FROM v_getdealinfo v, ALLCODE CD,ALLCODE CD1,
              (select DISTINCT acctno, overduedate  from (select acctno, overduedate from lnschd union all select acctno, overduedate from lnschdhist) )ln,
              (SELECT S.ACCTNO, SUM(NML) NML, M.TRFACCTNO
                  FROM LNSCHD S, LNMAST M
                      WHERE S.OVERDUEDATE = TO_DATE((select varvalue from sysvar where grname ='SYSTEM' and varname ='CURRDATE'),'DD/MM/YYYY') AND S.NML > 0 AND S.REFTYPE IN ('P')
                          AND S.ACCTNO = M.ACCTNO AND M.STATUS NOT IN ('P','R','C')
                      GROUP BY S.ACCTNO, M.TRFACCTNO
                      Order By S.Acctno
              ) sts,cfmast cf,tlgroups gr,tlprofiles tl,tllogall la,tlprofiles tl1
          where v.lnacctno = sts.acctno (+)
              and CD.cdname = 'DEALSTATUS' and CD.cdtype ='DF' AND CD.CDVAL = v.STATUS
              and CD1.cdname = 'FLAGTRIGGER' and CD1.cdtype ='DF' AND CD1.CDVAL = v.FLAGTRIGGER
              And V.Lnacctno = Ln.Acctno
              And V.Custodycd = Cf.Custodycd
              And Cf.Custodycd  Like V_Custodycd
              and v.txdate <= TO_DATE (T_DATE ,'DD/MM/YYYY') and v.txdate >= TO_DATE (F_DATE ,'DD/MM/YYYY')
              And Cf.Careby = Gr.Grpid
              And Gr.Grpid =0026
              And Cf.Tlid = Tl.Tlid
              And V.Txnum = La.Txnum
              And V.Txdate = La.Txdate
              and la.tlid = tl1.tlid;

    EXCEPTION
       WHEN OTHERS
       THEN
          Return;
END;
/

