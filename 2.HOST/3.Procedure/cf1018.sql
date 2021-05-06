CREATE OR REPLACE PROCEDURE cf1018(
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD      IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PV_REID        IN VARCHAR2,
   TS_STATUS      IN VARCHAR2,
   PV_TLID        IN VARCHAR2
   )
IS
-- MODIFICATION HISTORY
-- BAO CAO TINH HINH GIAO DICH CHO QUY DAU TU
-- PERSON   DATE  COMMENTS
-- THANHNNM 12-JUL-12  CREATED
-- ---------   ------  -------------------------------------------
   V_CUSTODYCD      VARCHAR2 (20);
   V_AFACCTNO       VARCHAR2(20);
   V_REID           VARCHAR2(20);
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   v_brid           VARCHAR2(4);
   V_TS_STATUS      VARCHAR2 (5);            --trang thai tai san dong. 001: ts>=0, 002: ts<0
   V_TLID           VARCHAR2(4);

BEGIN

    V_STROPTION := OPT;
    v_brid := brid;
    V_TLID := PV_TLID;

    IF  V_STROPTION = 'A'  THEN
    V_STRBRID := '%';
    elsif V_STROPTION = 'B' then
        select br.mapid into V_STRBRID from brgrp br where br.brid = v_brid;
       else V_STRBRID := v_brid;
    END IF;

   V_TS_STATUS := TS_STATUS;

   IF (PV_CUSTODYCD <> 'ALL')
   THEN
      V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
      V_CUSTODYCD := '%';
   END IF;

      IF (PV_AFACCTNO <> 'ALL')
   THEN
      V_AFACCTNO := PV_AFACCTNO;
   ELSE
      V_AFACCTNO := '%';
   END IF;


   IF (PV_REID <> 'ALL')
   THEN
      V_REID := PV_REID;
   ELSE
      V_REID := '%';
   END IF;


 OPEN PV_REFCURSOR
       FOR
        ---GET DATA


        SELECT * FROM (
        SELECT AF.ACCTNO, CF.CUSTODYCD, CF.FULLNAME,
        '[' || AFT.ACTYPE || ']: '  || AFT.TYPENAME  AFTYPE_DES,
        NVL(OD.AMT,0) ODAMT,

        CASE WHEN  MRT.MRTYPE <>'N' THEN  NVL(se.seamt,0) + NVL(CI.BALANCE,0) -
        NVL(CI.trfbuyamt,0) - NVL(CI.depofeeamt,0) + NVL(ADV.DEPOAMT,0)
        -- -  NVL(ODSE.execbuyamt,0) - nvl(odse.buyfeeacr,0) -
        - nvl(odse.secureamt,0) -
        NVL(LN.BL_AMT,0) - NVL(LN.DF_CL_AMT,0)
        ELSE
        NVL(se.seamt,0) + NVL(CI.BALANCE,0) -
        NVL(CI.trfbuyamt,0) - NVL(CI.depofeeamt,0) + NVL(ADV.DEPOAMT,0)
       -- -     NVL(ODSE.execbuyamt,0) - nvl(odse.buyfeeacr,0)
          - nvl(odse.secureamt,0)
         END  TS_SUCMUA,

        NVL(LN.BL_AMT,0) BL_AMT,
        NVL(LN.DF_CL_AMT,0) DF_CL_AMT,
        TO_DATE(T_DATE , 'DD/MM/YYYY') - TO_DATE(F_DATE , 'DD/MM/YYYY') + 1  DAYS,
        CF.T0LOANLIMIT,
        (CASE WHEN  MRT.MRTYPE ='N' THEN -1
        ELSE
        (CASE WHEN AF.TRFBUYEXT>0 AND AF.TRFBUYRATE >0 THEN NVL(SEC.RLSMARGINRATE,0)
        ELSE NVL(SEC.MARGINRATE,0)END ) END) MR_RATE,
        --can bo moi gioi
        '[' || nvl(CFLK.custid,' ' ) || ']: '  || NVL(CFLK.FULLNAME, ' ') CBMG
        FROM CFMAST CF, AFMAST AF, AFTYPE AFT, MRTYPE MRT,
             --GIA TRI LENH
             (SELECT OD.AFACCTNO,SUM(IOD.MATCHPRICE*IOD.MATCHQTTY) AMT FROM
                        (SELECT * FROM IOD  WHERE DELTD='N'
                          UNION ALL SELECT * FROM IODHIST  WHERE DELTD='N' ) IOD,

                          (SELECT ORDERID, AFACCTNO FROM ODMAST WHERE DELTD='N'
                           UNION ALL
                           SELECT ORDERID, AFACCTNO FROM ODMASTHIST WHERE DELTD='N' ) OD
                           WHERE  IOD.ORGORDERID = OD.ORDERID AND IOD.TXDATE >= TO_DATE(F_DATE , 'DD/MM/YYYY')
                AND IOD.TXDATE <= TO_DATE(T_DATE , 'DD/MM/YYYY')  GROUP BY OD.AFACCTNO ) OD,
                --DUNO
                (SELECT LN.TRFACCTNO,
                              SUM(CASE WHEN LNS.REFTYPE ='GP' AND LN.FTYPE ='AF' THEN  LNS.NML + LNS.OVD     ELSE 0 END ) BL_AMT,
                              SUM(CASE WHEN LNS.REFTYPE ='GP' AND LN.FTYPE ='AF' THEN    0 ELSE LNS.NML + LNS.OVD  END ) DF_CL_AMT
                       FROM   LNMAST LN, LNSCHD LNS
                      WHERE LN.ACCTNO = LNS.ACCTNO  GROUP BY LN.TRFACCTNO ) LN,
                 -- TY LE MR
                (SELECT AFACCTNO,RLSMARGINRATE,MARGINRATE FROM  V_GETSECMARGINRATIO)  SEC,
                --TIEN, TRA CHAM, PHI LK
                (SELECT AFACCTNO, SUM(BALANCE) BALANCE, SUM (trfbuyamt) trfbuyamt,
                 SUM(depofeeamt) depofeeamt FROM CIMAST GROUP BY AFACCTNO ) CI,
                 --CK
                 ( SELECT se.afacctno,
                    sum((se.TRADE + se.BLOCKED + se.WITHDRAW + se.MORTAGE
                     + SE.DTOCLOSE + NVL(STS.TOTALRECEIVING,0) - NVL(OD.EXECQTTY,0)
                     + NVL(OD.TOTALBUYQTTY,0)) * SB.BASICPRICE)  SEAMT
                    FROM  securities_info sb,
                     (SELECT afacctno, codeid,TRADE,BLOCKED,WITHDRAW,MORTAGE,DTOCLOSE FROM semast) se
                      LEFT JOIN
                     (select sum(BUYQTTY) BUYQTTY,sum(TOTALBUYQTTY) TOTALBUYQTTY, sum(EXECQTTY) EXECQTTY , AFACCTNO, CODEID
                      from (
                          SELECT (case when od.exectype IN ('NB','BC')
                                      then (case when (af.trfbuyext * af.trfbuyrate) > 0 then 0 else REMAINQTTY end)
                                              + (case when nvl(sts_trf.islatetransfer,0) > 0 then 0 else EXECQTTY - DFQTTY end)
                                      else 0 end) BUYQTTY,
                                      (case when od.exectype IN ('NB','BC') then REMAINQTTY + EXECQTTY - DFQTTY else 0 end) TOTALBUYQTTY,
                                  (case when od.exectype IN ('NS','MS') and od.stsstatus <> 'C' then EXECQTTY - nvl(dfexecqtty,0) else 0 end) EXECQTTY, AFACCTNO, CODEID
                          FROM odmast od, afmast af,
                              (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                              (select orderid, sum(execqtty) dfexecqtty from odmapext where type = 'D' group by orderid) dfex
                             where od.afacctno = af.acctno and od.orderid = sts_trf.orgorderid(+) and od.orderid = dfex.orderid(+)
                             and od.txdate =(select to_date(VARVALUE,'DD/MM/RRRR') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                             AND od.deltd <> 'Y'
                             and not(od.grporder='Y' and od.matchtype='P') --Lenh thoa thuan tong khong tinh vao
                             AND od.exectype IN ('NS', 'MS','NB','BC')
                          )
                           group by  AFACCTNO, CODEID
                      ) OD
                    on OD.afacctno =se.afacctno and OD.codeid =se.codeid
                      LEFT JOIN
                      (SELECT STS.CODEID,STS.AFACCTNO,
                              SUM(CASE WHEN DUETYPE ='RM' THEN AMT-AAMT-FAMT+PAIDAMT+PAIDFEEAMT-AMT*TYP.DEFFEERATE/100 ELSE 0 END) MAMT,
                              SUM(CASE WHEN DUETYPE ='RS' and nvl(sts_trf.islatetransfer,0) = 0 AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR') THEN QTTY-AQTTY ELSE 0 END) RECEIVING,
                              SUM(CASE WHEN DUETYPE ='RS' AND (nvl(sts_trf.islatetransfer,0) = 0 or sts_trf.trfbuydt = TO_DATE(sy.VARVALUE,'DD/MM/RRRR')) AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR') THEN QTTY-AQTTY ELSE 0 END) T0RECEIVING,
                              SUM(CASE WHEN DUETYPE ='RS' AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR') THEN QTTY-AQTTY ELSE 0 END) TOTALRECEIVING
                          FROM STSCHD STS, ODMAST OD, ODTYPE TYP,
                          (select orgorderid, (trfbuyext * trfbuyrate * (amt - trfexeamt)) islatetransfer, trfbuydt from stschd where duetype = 'SM' and deltd <> 'Y') sts_trf,
                          sysvar sy
                          WHERE STS.DUETYPE IN ('RM','RS') AND STS.STATUS ='N'
                              and sy.grname = 'SYSTEM' and sy.varname = 'CURRDATE'
                              AND STS.DELTD <>'Y' AND STS.ORGORDERID=OD.ORDERID AND OD.ACTYPE =TYP.ACTYPE
                              and od.orderid = sts_trf.orgorderid(+)
                              GROUP BY STS.AFACCTNO,STS.CODEID
                       ) sts
                      on sts.afacctno =se.afacctno and sts.codeid=se.codeid

                      WHERE se.codeid = sb.codeid GROUP BY se.afacctno) se,

                 --UNG TRUOC
                 (SELECT AFACCTNO ,SUM(AMT - EXFEEAMT) DEPOAMT FROM V_ADVANCESCHEDULE  GROUP BY AFACCTNO) ADV,
                 -- KY QUY
                 (SELECT AFACCTNO,secureamt ,execbuyamt,buyfeeacr  FROM V_GETBUYORDERINFO) ODSE,
                 (SELECT AFACCTNO, MAX(SUBSTR(REACCTNO,1,10)) REID  FROM REAFLNK
                 WHERE   DELTD='N' AND  STATUS ='A' GROUP BY  AFACCTNO) REL,
                (SELECT custid , fullname FROM CFMAST WHERE custid LIKE V_REID)  CFLK

        WHERE AF.CUSTID = CF.CUSTID
        AND AFT.MRTYPE = MRT.ACTYPE
        AND AF.ACTYPE = AFT.ACTYPE AND AF.ACCTNO = OD.AFACCTNO(+)
        AND AF.ACCTNO = ADV.AFACCTNO(+) AND  AF.ACCTNO = ODSE.AFACCTNO(+)
        AND AF.ACCTNO = LN.TRFACCTNO(+) AND AF.ACCTNO = SEC.afacctno(+)
        AND AF.ACCTNO = CI.AFACCTNO (+)
        AND AF.ACCTNO = se.AFACCTNO (+)
        AND AF.ACCTNO = rel.AFACCTNO (+)
        AND REL.REID  = cflk.custid(+)
        AND CF.CUSTODYCD LIKE V_CUSTODYCD
        AND AF.ACCTNO LIKE V_AFACCTNO
        AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = V_TLID)
        AND  (AF.BRID LIKE V_STRBRID OR INSTR(V_STRBRID,AF.BRID) <> 0)
        ) WHERE 0=0 AND (CASE  WHEN V_TS_STATUS = 'ALL' THEN 0
                               WHEN V_TS_STATUS ='001' AND TS_SUCMUA >=0 THEN 0
                               WHEN V_TS_STATUS ='002' AND TS_SUCMUA < 0 THEN 0
                               ELSE 1 END ) =0
 ;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/

