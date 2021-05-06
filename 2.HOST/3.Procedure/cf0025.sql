CREATE OR REPLACE PROCEDURE cf0025 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       varchar2,
   T_DATE         IN       varchar2,
   AFACCTNO       IN       VARCHAR2,
   R_TYPE         IN       VARCHAR2
  )
IS
-- Date :20/07/2010
--code  : quyet.kieu
--Test : vananh.ha
--modify Huydung(30_05_2011)
-- ---------   ------  -------------------------------------------

   CUR             PKG_REPORT.REF_CURSOR;
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0
   V_STRAFACCTNO    VARCHAR2 (20);
   V_BEGIN_BALANCE  NUMBER;
   V_STRFULLNAME    VARCHAR2 (100);
   V_STRADDRESS     VARCHAR2 (500);
   V_Status         VARCHAR2 (100);
   v_ISGroup        VARCHAR2 (100);
   Cursor c_Group(v_acct Varchar2) is Select * From AFGROUP where ACCMEMBER =v_acct;
   v_Group c_Group%Rowtype;
   v_Rtt   Number(20,4);
   v_Acc_Leader varchar2(30);
   v_Fullname varchar2(100);
   V_Curdate varchar2(10);
   -- THEM

   V_TYLE_AT  Number(20,4) ; -- TY LE AN TOAN
   v_err varchar2(200);
   V_AFACCTNO VARCHAR2 (20);
   V_ADDVND Number(20,4) ;

   Cursor c_margin_group(v_Acctno varchar2) is Select * from V_GROUPACOOUNTMARGINRATE where acctno =v_acctno;
   v_margin_group c_margin_group%rowtype;

BEGIN

 Select VARVALUE into V_Curdate from sysvar where VARNAME='CURRDATE';
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS

   IF (R_TYPE <> 'G')
   THEN
      V_STRAFACCTNO :=  AFACCTNO;
   ELSE
      V_STRAFACCTNO := '%%';
   END IF;

   --Lay thong tin Group
   v_ISGroup:='C';
   v_Rtt :=10000000;
   Open c_Group(AFACCTNO);
   Fetch c_Group Into v_Group;
       If c_Group%notfound then --Khong trong Afgroup co the la: Ko margin or margin ko thuoc group
           Open c_margin_group(AFACCTNO);
           Fetch c_margin_group into v_margin_group;
             If c_margin_group%notfound then
                v_Status :='Normal';
                --v_Status :='Stand Alone';
                v_ISGroup:='N';
                v_Acc_Leader :='';
             Else
                v_Status :='Stand Alone';
                --v_Status :='Member of Group';
                v_ISGroup:='U';
                v_Acc_Leader :=AFACCTNO;
             End if;
           Close c_margin_group;

       Elsif v_Group.MBTYPE ='L' Then
        v_Status :='Group leader';
        v_ISGroup:='U';
        v_Acc_Leader :=v_Group.ACCLEADER;
       Else
         v_Status :='Member of Group';
         v_ISGroup:='U';
         v_Acc_Leader :=v_Group.ACCLEADER;
       End if;
   Close c_Group;

  --Lay ty le an toan: Neu Group thi theo Group.

  Begin
    Select marginrate into v_Rtt from  V_GROUPACOOUNTMARGINRATE where acctno =v_Acc_Leader;
  Exception when others then
    v_Rtt :=10000000;
  End;

  Begin
    Select fullname into v_Fullname from  cfmast where custid in (Select custid from afmast where acctno =AFACCTNO);
  Exception when others then
    v_Fullname:='';
  End;


  Begin
            -- Lay ti te an toan cua nhom tai khoan
             V_AFACCTNO :=AFACCTNO;
             Select  MARGINRATE Into V_TYLE_AT
             From v_accountmarginrate v where v.afacctno = v_Acc_Leader;
  Exception when others then
    V_TYLE_AT:=0;
  End;

        --thong tin so tien bi call margin cua (nhom)tai khoan
  Begin
        SELECT
        round((case when mst.MARGINRATE * mst.MRIRATE =0 then greatest(-mst.OUTSTANDING,0) else
        greatest( 0,-mst.OUTSTANDING-mst.NAVACCOUNT *100/mst.MRIRATE) end),0) ADDVND into V_ADDVND
        FROM v_groupacoountmarginrate mst where acctno =v_Acc_Leader;
  Exception when others then
    V_ADDVND:=0;
  End;

   -- END OF GETTING REPORT'S PARAMETERS

OPEN PV_REFCURSOR
       FOR

       SELECT * FROM
(

  SELECT  '1' stt ,ACCTNO Grop, stt2 , AFACCTNO ACCTNO_acct,  v_Fullname fullname_acct , v_Status leader_der_acct, v_Rtt Margin_rate_acct,
       ACCTNO, ACTYPE, to_char(SYMBOL) SYMBOL,TRADE ,CURRPRICE ,M_VALUE,COLLATERAL_PRICE,COLLATERAL_VALUE ,LOAN_RATE ,MARGIN_RATE,V_Curdate TXdate,V_TYLE_AT TYLE_AT, V_ADDVND ADDVND
       From
   (
       select 1 stt2 , af.ACCTNO,af.ACTYPE , 'Ti?n m?t' SYMBOL, greatest(balance - NVL(v.execbuyamtfee,0),0)  TRADE, 1 CURRPRICE,
        greatest(balance - NVL(v.execbuyamt_fee,0),0) M_VALUE, 1 COLLATERAL_PRICE, greatest(balance - NVL(v.execbuyamt_fee,0),0) COLLATERAL_VALUE, 100 LOAN_RATE, 0 MARGIN_RATE
        from afmast af, Cimast ci, v_getbuyorderinfot0 v
        where ci.afacctno =v.AFACCTNO(+)
           and af.acctno =ci.afacctno
        and (
             ci.afacctno IN (SELECT ACCMEMBER FROM  AFGROUP WHERE ACCLEADER =v_Group.ACCLEADER)
             OR ci.afacctno =V_STRAFACCTNO
             )
       Union all
              Select 2 stt2 , CI.afacctno ACCTNO , '' ACTYPE,'Ti?n ch? v?'  SYMBOL, (nvl(a.UTTD_THT,0) + nvl(b.UTTD_TNH,0)) TRADE,1 CURRPRICE,
                             (nvl(a.UTTD_THT,0) + nvl(b.UTTD_TNH,0))  M_VALUE, 1 COLLATERAL_PRICE,(nvl(a.UTTD_THT,0) + nvl(b.UTTD_TNH,0)) COLLATERAL_VALUE,100  LOAN_RATE, 0 MARGIN_RATE

                              from CIMAST CI  ,
                               (
                             Select OD.afacctno,sum(St.amt -St.aamt - St.famt - OD.feeacr - (OD.matchamt *
                             decode(AFT.vat,'Y',(Select VARVALUE from sysvar where VARNAME='ADVSELLDUTY'),0)/100)) UTTD_THT
                             from ODMAST OD,STSCHD ST , AFMAST AF , AFTYPE AFT
                             Where OD.orderid = St.orgorderid
                             and OD.afacctno= AF.acctno
                             AND od.exectype <> 'MS'
                             and ST.duetype='RM'
                             and AF.actype= AFT.actype
                             and ST.deltd<>'Y'
                             and OD.deltd <>'Y'
                             and ST.txdate < to_date(V_Curdate,'DD/MM/RRRR')
                             group by OD.afacctno
                             )a,
                             (
                             Select OD.afacctno,
                             SUM(St.amt -St.aamt - St.famt - (OD.matchamt * (ODT.deffeerate + decode(AFT.vat,'Y',(Select VARVALUE from sysvar where VARNAME='ADVSELLDUTY'),0))/100)+PAIDAMT+PAIDFEEAMT) UTTD_TNH
                             From ODMAST OD,ODTYPE ODT,STSCHD ST,AFMAST AF,AFTYPE AFT where
                             OD.actype=ODT.actype
                             and OD.orderid = St.orgorderid
                             and ST.deltd <>'Y'
                             and OD.deltd <>'Y'
                             and OD.afacctno= AF.acctno
                             and od.exectype <> 'MS'
                             and AF.actype= AFT.actype
                             and ST.duetype='RM'
                             and ST.txdate = to_date(V_Curdate,'DD/MM/RRRR')
                             group by  OD.afacctno
                             )b
                         where CI.afacctno = a.afacctno(+)
                         and   CI.afacctno = b.afacctno(+)
                         and  CI.acctno IN (SELECT ACCMEMBER FROM  AFGROUP WHERE ACCLEADER =v_Group.ACCLEADER)

       Union all
        select 3 stt2, af.ACCTNO,af.ACTYPE , 'N? th?u chi' SYMBOL, -1*ODAMT + Least(balance - NVL(v.execbuyamt_fee,0),0)  TRADE, 1 CURRPRICE,
            -1 *ODAMT + Least(balance - NVL(v.execbuyamt_fee,0),0) M_VALUE, 1 COLLATERAL_PRICE, 0 COLLATERAL_VALUE, 100 LOAN_RATE, 0 MARGIN_RATE
            from afmast af, Cimast ci, v_getbuyorderinfot0 v
            where ci.afacctno =v.AFACCTNO(+)
               and af.acctno =ci.afacctno
            and (
                 ci.afacctno IN (SELECT ACCMEMBER FROM  AFGROUP WHERE ACCLEADER =v_Group.ACCLEADER)
                 OR ci.afacctno =V_STRAFACCTNO
                )
        Union all

        Select 4 stt2, g1.ACCTNO ACCTNO, g1.ACTYPE ACTYPE, to_char(SYMBOL) SYMBOL,(G1.TRADE + NVL(G4.RECEIVING,0) +  NVL(G3.BUYQTTY,0) - NVL(G3.EXECQTTY,0)),CURRPRICE,(G1.TRADE + NVL(G4.RECEIVING,0) +  NVL(G3.BUYQTTY,0) - NVL(G3.EXECQTTY,0))* G1.CURRPRICE M_VALUE,
        least(G1.MARGINPRICE,NVL( g2.MRPRICELOAN,0)) COLLATERAL_PRICE,
        (G1.TRADE + NVL(G4.RECEIVING,0) +  NVL(G3.BUYQTTY,0) - NVL(G3.EXECQTTY,0))  * least(G1.MARGINPRICE,NVL( g2.MRPRICELOAN,0)) * NVL(g2.mrratiorate,0)/100 COLLATERAL_VALUE,
               NVL(g2.mrratiorate,0) LOAN_RATE,NVL(g2.mrratiorate,0)  MARGIN_RATE
          from (
           Select AF.ACCTNO, AF.ACTYPE ACTYPE, SI.SYMBOL, SE.acctno seacctno, SI.CURRPRICE
             , SI.MARGINPRICE COLLATERAL_PRICE, SE.TRADE, SE.receiving ,  SI.MARGINPRICE MARGINPRICE, SI.CODEID
            FROM CIMAST CI, AFMAST AF, SEMAST SE , SECURITIES_INFO SI
            WHERE CI.AFACCTNO = AF.ACCTNO
                AND SE.AFACCTNO  = CI.AFACCTNO
                AND SE.CODEID  = SI.CODEID
                AND (
                     AF.ACCTNO IN (SELECT ACCMEMBER FROM  AFGROUP WHERE ACCLEADER =v_Group.ACCLEADER)
                     OR AF.ACCTNO = V_STRAFACCTNO)
                     ) G1, afserisk g2, (SELECT sum(case when od.exectype IN ('NB','BC') then ( EXECQTTY) else 0 end) BUYQTTY,
                                          sum(case when od.exectype IN ('NS') then (EXECQTTY) else 0 end) EXECQTTY,SEACCTNO
                                            FROM odmast od
                                            where od.txdate =(select to_date(VARVALUE,'DD/MM/YYYY') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                                            AND od.deltd <> 'Y'
                                            AND od.exectype IN ('NS', 'MS','NB','BC')
                                            Group by SEACCTNO) G3,
                                        (SELECT STS.CODEID,STS.AFACCTNO,
                                            SUM(CASE WHEN DUETYPE ='RM' THEN AMT-AAMT-FAMT+PAIDAMT+PAIDFEEAMT-AMT*TYP.DEFFEERATE/100 ELSE 0 END) MAMT,
                                            SUM(CASE WHEN DUETYPE ='RS' AND STS.TXDATE <> (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') FROM SYSVAR WHERE GRNAME='SYSTEM' AND VARNAME='CURRDATE') THEN QTTY ELSE 0 END) RECEIVING
                                        FROM STSCHD STS, ODMAST OD, ODTYPE TYP
                                        WHERE STS.DUETYPE IN ('RM','RS') AND STS.STATUS ='N'
                                            AND STS.DELTD <>'Y' AND STS.ORGORDERID=OD.ORDERID AND OD.ACTYPE =TYP.ACTYPE
                                            AND od.exectype <> 'MS'
                                            GROUP BY STS.AFACCTNO,STS.CODEID
                                     ) G4
                           where     G1.codeid =g2.codeid(+)
                                 and g1.actype =g2.actype(+)
                                 and g1.seacctno = g3.SEACCTNO(+)
                                 and g1.codeid = g4.codeid(+)
                                 and g1.ACCTNO = g4.afacctno(+)
                                 and G1.TRADE + NVL(G4.RECEIVING,0) +  NVL(G3.BUYQTTY,0) - NVL(G3.EXECQTTY,0) >0
      ) --Order by ACCTNO, stt, SYMBOL


Union all

SELECT  '0' stt ,'1a' Grop, 0 stt2,  AFACCTNO ACCTNO_acct,  v_Fullname fullname_acct , v_Status leader_der_acct, v_Rtt Margin_rate_acct,
       ACCTNO, '0c' ACTYPE, trim(to_char(Tien_T_chove,'999,999,999,999,999')) SYMBOL, GT_CK TRADE , GT_DUNO CURRPRICE ,TS_dong M_VALUE, HMDSD COLLATERAL_PRICE,HMCL COLLATERAL_VALUE , T_HMCAP LOAN_RATE ,0 MARGIN_RATE ,V_Curdate TXdate,V_TYLE_AT TYLE_AT, V_ADDVND ADDVND
FROM
 (
Select AF.acctno,AF.mrirate mrirate ,A1.Tien_T_chove Tien_T_chove , nvl(B1.GT_CK,0) GT_CK ,round(nvl(C1.GT_DUNO,0)) GT_DUNO,((A1.Tien_T_chove + nvl(B1.GT_CK,0)) + nvl(C1.GT_DUNO,0)) TS_dong,
                         (AF.advanceline +AF.mrcrlimitmax) T_HMCAP, nvl(C1.GT_DUNO,0)*(-1) HMDSD,
                         ((AF.advanceline +AF.mrcrlimitmax)+ nvl(C1.GT_DUNO,0)) HMCL, V_Curdate TXdate
                          from (select  * from AFMAST  where   acctno IN (SELECT ACCMEMBER FROM  AFGROUP WHERE ACCLEADER =v_Group.ACCLEADER)
                 OR acctno =V_STRAFACCTNO) AF,
                         (
                             Select CI.afacctno, (CI.balance + nvl(a.UTTD_THT,0) + nvl(b.UTTD_TNH,0)) Tien_T_chove from
             (
       SELECT 1 stt, af.acctno afacctno,
       GREATEST (balance - NVL (v.execbuyamt_fee, 0), 0) balance
       FROM afmast af, cimast ci, v_getbuyorderinfot0 v
       WHERE ci.afacctno = v.afacctno(+)
        AND af.acctno = ci.afacctno
       AND (    ci.afacctno IN (SELECT ACCMEMBER FROM  AFGROUP WHERE ACCLEADER =v_Group.ACCLEADER)
                 OR ci.afacctno =V_STRAFACCTNO
           )                 )
                                 CI
                              ,
                             (
                             Select OD.afacctno,sum(St.amt -St.aamt - St.famt - OD.feeacr - (OD.matchamt *
                             decode(AFT.vat,'Y',(Select VARVALUE from sysvar where VARNAME='ADVSELLDUTY'),0)/100)) UTTD_THT
                             from ODMAST OD,STSCHD ST , AFMAST AF , AFTYPE AFT
                             Where OD.orderid = St.orgorderid
                             and OD.afacctno= AF.acctno
                             AND od.exectype <> 'MS'
                             and ST.duetype='RM'
                             and AF.actype= AFT.actype
                             and ST.deltd<>'Y'
                             and OD.deltd <>'Y'
                             and ST.txdate < to_date(V_Curdate,'DD/MM/RRRR')
                             group by OD.afacctno
                             )a,
                             (
                             Select OD.afacctno,
                             SUM(St.amt -St.aamt - St.famt - (OD.matchamt * (ODT.deffeerate + decode(AFT.vat,'Y',(Select VARVALUE from sysvar where VARNAME='ADVSELLDUTY'),0))/100)+PAIDAMT+PAIDFEEAMT) UTTD_TNH
                             From ODMAST OD,ODTYPE ODT,STSCHD ST,AFMAST AF,AFTYPE AFT where
                             OD.actype=ODT.actype
                             and OD.orderid = St.orgorderid
                             and ST.deltd <>'Y'
                             and OD.deltd <>'Y'
                             and OD.afacctno= AF.acctno
                             and od.exectype <> 'MS'
                             and AF.actype= AFT.actype
                             and ST.duetype='RM'
                             and ST.txdate = to_date(V_Curdate,'DD/MM/RRRR')
                             group by  OD.afacctno
                             )b
                         where CI.afacctno = a.afacctno(+)
                         and   CI.afacctno = b.afacctno(+)
                         )A1,
                            (

        Select TR.afacctno ,  (nvl(TR.trade,0) +  nvl(RS.CK_Recei,0) - nvl(SS.CK_SELL,0) )GT_CK
      FROM
      (
       Select se.afacctno,
       sum ((se.trade)*sb.basicprice) TRADE
       from Semast se ,Securities_info sb
       where se.codeid =sb.codeid
       Group by se.afacctno

                 ) TR,
                 (   Select st.afacctno,
                     sum ((st.qtty )*sb.basicprice ) CK_Recei
                     from  stschd st,Securities_info sb
                     where st.duetype='RS'
                     and st.deltd <>'Y'
                     and st.codeid=sb.codeid
                     Group by st.afacctno
                 )  RS ,
                            (
                               Select st.afacctno,
                                sum ((st.qtty )*sb.basicprice ) CK_SELL
                                from  stschd st,Securities_info sb ,odmast od
                                 where st.duetype='SS'
                                  and ST.txdate = to_date(V_Curdate,'DD/MM/RRRR')
                                 and st.deltd <>'Y'
                                 and st.codeid=sb.codeid
                                 and od.exectype='NS'
                                 and od.orderid=st.ORGORDERID
                                 Group by st.afacctno

                             ) SS
                             WHERE TR.afacctno = RS.afacctno(+)
                             and  TR.afacctno = SS.afacctno(+)

                             )B1,
                            (
                              SELECT af.acctno afacctno, -1 * odamt + LEAST (balance - NVL (v.execbuyamt_fee, 0), 0) gt_duno
                           FROM afmast af, cimast ci, v_getbuyorderinfot0 v
                           WHERE ci.afacctno = v.afacctno(+)
                           AND af.acctno = ci.afacctno
                           AND (   ci.afacctno IN (SELECT accmember
                                                    FROM afgroup
                                                    WHERE accleader = v_group.accleader)
                                OR ci.afacctno = v_strafacctno
                               )
                            )C1
                             WHERE AF.acctno=A1.afacctno(+)
                             and   AF.acctno=B1.afacctno(+)
                             and   AF.acctno=C1.afacctno(+)

                             )
)

Where ACCTNO like v_strafacctno
order by stt, acctno,stt2 ,SYMBOL;

EXCEPTION
   WHEN OTHERS
   THEN
      v_err:=substr(sqlerrm,1,200);
      RETURN;
END;
/

