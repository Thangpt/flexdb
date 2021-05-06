CREATE OR REPLACE PROCEDURE ln0007ex (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PV_NUM      IN          VARCHAR2,
   PV_STATUS      IN       VARCHAR2,
   p_ISVSD       in       VARCHAR2,
   p_CUSTBANK         IN      VARCHAR2,
   P_PAIDSTATUS      IN      VARCHAR2
   )
IS
--
-- TONG HOP DU NO THEO KHACH HANG
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- THANHNM   28-JUN-2012  CREATE
-- ---------   ------  -------------------------------------------
-- PV_A            PKG_REPORT.REF_CURSOR;
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRI_TYPE      VARCHAR2 (5);

    V_STRBRID          VARCHAR2 (40);    -- USED WHEN V_NUMOPTION > 0
    V_INBRID     VARCHAR2 (5);

   V_F_DATE       DATE;
   V_T_DATE       DATE;
   V_STRSTATUS   VARCHAR2(3);
   V_CUSTODYCD  VARCHAR2(20);
   V_AFACCTNO   VARCHAR2(20);
   V_STRNUM       VARCHAR2(20);
   l_ISVSD varchar2(10);
   V_CUSTBANK   VARCHAR2(20);

   BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;


   IF (PV_NUM ='ALL') THEN
      V_STRNUM :='%';
   ELSE
      V_STRNUM := PV_NUM;
   END IF;

   IF (PV_CUSTODYCD ='ALL') THEN
      V_CUSTODYCD :='%%';
   ELSE
      V_CUSTODYCD := PV_CUSTODYCD;
   END IF;

    IF (PV_AFACCTNO ='ALL') THEN
      V_AFACCTNO :='%%';
    ELSE
      V_AFACCTNO := PV_AFACCTNO;
    END IF;
    IF p_CUSTBANK = 'ALL' OR p_CUSTBANK IS NULL THEN
        V_CUSTBANK := '%%';
    ELSE
        V_CUSTBANK := p_CUSTBANK;
    END IF;


    IF p_ISVSD = 'ALL' then
        l_ISVSD := '%%';
   elsIF p_ISVSD = 'DF' THEN
        l_ISVSD := 'N';
    else
        l_ISVSD := 'Y';
    end if;

    V_F_DATE := TO_DATE (F_DATE,'DD/MM/RRRR');
    V_T_DATE := TO_DATE (T_DATE,'DD/MM/RRRR');

OPEN PV_REFCURSOR
    FOR
        select *
        from
            (
                select
                A.CUSTID, A.CUSTODYCD, A.FULLNAME, A.ADDRESS, A.ACCTNO,
                            A.LNACC,a.lnacctno,
                            A.RLSDATE, A.EXPDATE,
                            DECODE (nvl(df.isvsd,'N') ,'Y' ,  A.F_TYPE||'-VSD',A.F_TYPE  )F_TYPE ,
                            A.F_BANK,
                            A.F_LOAIVAY,
                            A.NML,
                            A.OVD, A.PAID,
                            A.INT_MOVE  , A.FEE_MOVE, A.TXDATE, a.be_amt

                , nvl(df.isvsd,'N') isvsd
                from
                    (   --lay du no dau ky
                        (select a.*, nvl(b.be_amt,0) be_amt from
                        (SELECT CF.CUSTID, CF.CUSTODYCD, CF.FULLNAME, CF.ADDRESS, AF.ACCTNO,
                            TO_CHAR(LNS.AUTOID) LNACC, ln.acctno lnacctno,
                            lns.RLSDATE, lns.OVERDUEDATE EXPDATE,
                            CASE WHEN LN.FTYPE ='DF' THEN 'DF' ELSE
                                (CASE WHEN LNS.REFTYPE ='GP' THEN 'BL' ELSE 'CL' END) END  F_TYPE,
                            CASE WHEN LN.RRTYPE = 'B' AND LN.CUSTBANK IS NOT NULL THEN NVL(CFB.SHORTNAME,'')
                                ELSE 'KBSV' END F_BANK,
                            CASE WHEN DT.NML >0 THEN '1' ELSE
                                (CASE WHEN DT.PAID >0 THEN '2' ELSE
                                    (CASE WHEN DT.INT_MOVE>0 THEN '3' ELSE '4' END ) END ) END F_LOAIVAY,
                            DT.NML  NML,
                            DT.OVD OVD, DT.PAID PAID,
                            DT.INT_MOVE  INT_MOVE, DT.FEE_MOVE  FEE_MOVE, DT.TXDATE TXDATE
                        FROM CFMAST CF, AFMAST AF,
                            (SELECT * FROM LNMAST UNION SELECT * FROM LNMASTHIST) LN,
                            (SELECT LNS.*,'N' L_HIST FROM LNSCHD LNS where reftype in ('P','GP') UNION SELECT LNS.*,'Y' L_HIST FROM LNSCHDHIST LNS where reftype in ('P','GP')) LNS,
                            (SELECT AUTOID,TXDATE, NML, OVD,PAID,INTPAID INT_MOVE,FEEPAID FEE_MOVE
                                FROM (

                                        select lnslog.autoid,lnslog.txnum,lnslog.txdate,
                                            case when ln.ftype ='DF' then lnslog.nml + lnslog.ovd + lnslog.paid
                                            else lnslog.nml end nml,
                                            0 ovd,0 paid,0 intpaid,0 feepaid,lnslog.deltd
                                       from   vw_lnmast_all ln,vw_lnschd_all lns, vw_lnschdlog_all lnslog
                                              WHERE ln.acctno = lns.acctno  and lns.autoid = lnslog.autoid
                                              and lns.reftype in ('P','GP')
                                              and (case when ln.ftype ='DF' then
                                              0 else lnslog.paid + lnslog.intpaid +lnslog.feepaid end)  = 0
                                              AND (case when ln.ftype ='DF' then lnslog.nml + lnslog.paid + lnslog.ovd
                                               else lnslog.nml end ) >0
                                        UNION
                                        --goc
                                        SELECT autoid,txnum,txdate,0 nml,0 ovd,paid,0 intpaid,0 feepaid,deltd
                                        FROM (
                                            SELECT * FROM LNSCHDLOG
                                            UNION ALL
                                            SELECT * FROM LNSCHDLOGHIST )
                                        WHERE paid  <> 0
                                            --AND abs(nml)+ abs(ovd) +abs(paid) + abs(intpaid) + abs(feepaid) > 0
                                        UNION
                                        --lai
                                        SELECT autoid,txnum,txdate,0 nml,0 ovd,0 paid,
                                            intpaid, 0 feepaid,deltd
                                        FROM (
                                            SELECT * FROM LNSCHDLOG
                                            UNION ALL
                                            SELECT * FROM LNSCHDLOGHIST )
                                        WHERE  intpaid <> 0
                                            AND abs(nml)+abs(ovd) +abs(paid) + abs(intpaid) + abs(feepaid) > 0
                                        --phi
                                        UNION
                                        --lai
                                        SELECT autoid,txnum,txdate,0 nml,0 ovd,0 paid,0 intpaid,feepaid + feeintpaid,deltd
                                        FROM (
                                            SELECT * FROM LNSCHDLOG
                                            UNION ALL
                                            SELECT * FROM LNSCHDLOGHIST )
                                        WHERE  feepaid + feeintpaid <> 0
                                            AND abs(nml)+abs(ovd) +abs(paid) + abs(intpaid) + abs(feepaid) + abs(feeintpaid) > 0 ) LNSLOG
                                WHERE NVL(DELTD,'N') <>'Y' ) DT, CFMAST  CFB
                        WHERE  CF.CUSTID = AF.CUSTID AND AF.ACCTNO = LN.TRFACCTNO
                            AND LN.ACCTNO = LNS.ACCTNO AND LNS.AUTOID = DT.AUTOID
                            AND LN.CUSTBANK = CFB.CUSTID (+)
                            AND CF.CUSTODYCD LIKE  V_CUSTODYCD
                            AND AF.ACCTNO LIKE V_AFACCTNO
                            --AND CFB.shortname LIKE V_CUSTBANK
                            AND DT.TXDATE >= V_F_DATE
                            AND DT.TXDATE <= V_T_DATE
                            AND LN.ACCTNO LIKE V_STRNUM
                            AND (CASE WHEN LN.FTYPE = 'DF' THEN (CASE WHEN PV_STATUS ='ALL' OR  PV_STATUS ='DF' THEN 1 ELSE 0 END)
                                   WHEN LN.FTYPE ='GP' THEN  (CASE WHEN PV_STATUS ='ALL' OR  PV_STATUS ='GR' THEN 1 ELSE 0 END)
                                   ELSE  (CASE WHEN PV_STATUS ='ALL' OR  PV_STATUS ='MR' THEN 1 ELSE 0 END) END) =1
                            AND (CASE WHEN  P_PAIDSTATUS ='ALL' THEN 1
                                      WHEN  P_PAIDSTATUS ='001' AND LNS.L_HIST ='Y' THEN 1
                                      WHEN  P_PAIDSTATUS ='002' AND LNS.L_HIST ='N' THEN 1
                                      ELSE 0 END ) = 1 ) a
                        left join
                        (SELECT A.AUTOID, A.AMT - NVL(MOV_PAID,0)  BE_AMT FROM
                            (SELECT SUM(NML + OVD + PAID) AMT, AUTOID  FROM VW_LNSCHD_ALL
                            WHERE NML + OVD + PAID <>0 AND RLSDATE < V_F_DATE  GROUP BY AUTOID) A
                            LEFT JOIN
                            (SELECT  AUTOID, SUM(PAID) MOV_PAID FROM VW_LNSCHDLOG_ALL
                            WHERE NVL(DELTD,'N') <>'Y' AND TXDATE < V_F_DATE GROUP BY AUTOID
                            ) B  ON A.AUTOID = B.AUTOID
                        ) b on a.LNACC = b.autoid)
                    ) a ,
                    (select lnacctno, df.actype dftype, dft.isvsd
                    from dfgroup df, dftype dft
                    where df.actype=dft.actype) df
                where a.lnacctno = df.lnacctno (+)
            ) a
        where NVL(a.isvsd,'%') like l_ISVSD and a.F_BANK like V_CUSTBANK
       AND (substr(a.custid,1,4) LIKE V_STRBRID or instr(V_STRBRID,substr(a.custid,1,4)) <> 0)
  ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/

