CREATE OR REPLACE PROCEDURE sp_bd_getaccount_custodycd(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,CUSTODYCD IN VARCHAR2)
  IS
  V_CUSTODYCD VARCHAR2(10);
  V_AFACCTNO  VARCHAR2(10);

  v_sub_refcursor PKG_REPORT.ref_cursor;
   v_sum_refcursor PKG_REPORT.ref_cursor;
  TYPE v_record_field IS RECORD(PURCHASINGPOWER  NUMBER,
  AVLLIMIT  NUMBER,
  CASH_ON_HAND  NUMBER,
  ORDERAMT  NUMBER,
  OUTSTANDING  NUMBER,
  ADVANCEDLINE  NUMBER,
  AVLADVANCED NUMBER,
   PAIDAMT  NUMBER,
   MRCRLIMITMAX  NUMBER,
   CASH_RECEIVING_T0 NUMBER,
   CASH_RECEIVING_T1  NUMBER,
   CASH_RECEIVING_T2  NUMBER,
   CASH_RECEIVING_T3  NUMBER,
   CASH_RECEIVING_TN  NUMBER,
   CASH_SENDING_T0  NUMBER,
   CASH_SENDING_T1  NUMBER,
   CASH_SENDING_T2  NUMBER,
   CASH_SENDING_T3 NUMBER,
    CASH_SENDING_TN NUMBER,
    TOTALDEB    NUMBER,
    ADVANCED_BALANCE    NUMBER,
    BALDEFOVD   NUMBER,
    DEALPAIDAMT NUMBER);

  v_record_field_sub v_record_field;
   v_record_field_sum v_record_field;
    i NUMBER;

BEGIN
---------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
    V_CUSTODYCD:=CUSTODYCD;

    FOR rec IN (SELECT af.acctno FROM afmast af, cfmast cf WHERE af.custid=cf.custid AND cf.custodycd=V_CUSTODYCD)
      LOOP
       V_AFACCTNO:=rec.acctno;
       --v_sub_refcursor:=null;
        SP_BD_GETACCOUNTPOSITION( v_sub_refcursor, V_AFACCTNO);
        LOOP
        FETCH v_sub_refcursor INTO  v_record_field_sub;
            EXIT WHEN v_sub_refcursor%NOTFOUND;
            --pr_tuning_log('SP_BD_GETACCOUNT_CUSTODYCD', to_char(v_record_field_sub.PURCHASINGPOWER));
        END LOOP;
        v_record_field_sum.PURCHASINGPOWER:=nvl(v_record_field_sum.PURCHASINGPOWER,0) + nvl(v_record_field_sub.PURCHASINGPOWER,0);
        v_record_field_sum.AVLLIMIT:=nvl(v_record_field_sum.AVLLIMIT,0) + nvl(v_record_field_sub.AVLLIMIT,0);
        v_record_field_sum.CASH_ON_HAND:=nvl(v_record_field_sum.CASH_ON_HAND,0) + nvl(v_record_field_sub.CASH_ON_HAND,0);
        v_record_field_sum.ORDERAMT:=nvl(v_record_field_sum.ORDERAMT,0) + nvl(v_record_field_sub.ORDERAMT,0);
        v_record_field_sum.OUTSTANDING:=nvl(v_record_field_sum.OUTSTANDING,0) + nvl(v_record_field_sub.OUTSTANDING,0);
        v_record_field_sum.ADVANCEDLINE:=nvl(v_record_field_sum.ADVANCEDLINE,0) + nvl(v_record_field_sub.ADVANCEDLINE,0);
        v_record_field_sum.AVLADVANCED:=nvl(v_record_field_sum.AVLADVANCED,0) + nvl(v_record_field_sub.AVLADVANCED,0);
        v_record_field_sum.PAIDAMT:=nvl(v_record_field_sum.PAIDAMT,0) + nvl(v_record_field_sub.PAIDAMT,0);
        v_record_field_sum.MRCRLIMITMAX:=nvl(v_record_field_sum.MRCRLIMITMAX,0) + nvl(v_record_field_sub.MRCRLIMITMAX,0);
        v_record_field_sum.CASH_RECEIVING_T0:=nvl(v_record_field_sum.CASH_RECEIVING_T0,0) + nvl(v_record_field_sub.CASH_RECEIVING_T0,0);
        v_record_field_sum.CASH_RECEIVING_T1:=nvl(v_record_field_sum.CASH_RECEIVING_T1,0) + nvl(v_record_field_sub.CASH_RECEIVING_T1,0);
        v_record_field_sum.CASH_RECEIVING_T2:=nvl(v_record_field_sum.CASH_RECEIVING_T2,0) + nvl(v_record_field_sub.CASH_RECEIVING_T2,0);
        v_record_field_sum.CASH_RECEIVING_T3:=nvl(v_record_field_sum.CASH_RECEIVING_T3,0) + nvl(v_record_field_sub.CASH_RECEIVING_T3,0);

         v_record_field_sum.CASH_RECEIVING_TN:=nvl(v_record_field_sum.CASH_RECEIVING_TN,0) + nvl(v_record_field_sub.CASH_RECEIVING_TN,0);
        v_record_field_sum.CASH_SENDING_T0:=nvl(v_record_field_sum.CASH_SENDING_T0,0) + nvl(v_record_field_sub.CASH_SENDING_T0,0);
        v_record_field_sum.CASH_SENDING_T1:=nvl(v_record_field_sum.CASH_SENDING_T1,0) + nvl(v_record_field_sub.CASH_SENDING_T1,0);
        v_record_field_sum.CASH_SENDING_T2:=nvl(v_record_field_sum.CASH_SENDING_T2,0) + nvl(v_record_field_sub.CASH_SENDING_T2,0);
        v_record_field_sum.CASH_SENDING_T3:=nvl(v_record_field_sum.CASH_SENDING_T3,0) + nvl(v_record_field_sub.CASH_SENDING_T3,0);

         v_record_field_sum.CASH_SENDING_TN:=nvl(v_record_field_sum.CASH_SENDING_TN,0) + nvl(v_record_field_sub.CASH_SENDING_TN,0);
        v_record_field_sum.TOTALDEB:=nvl(v_record_field_sum.TOTALDEB,0) + nvl(v_record_field_sub.TOTALDEB,0);
        v_record_field_sum.ADVANCED_BALANCE:=nvl(v_record_field_sum.ADVANCED_BALANCE,0) + nvl(v_record_field_sub.ADVANCED_BALANCE,0);
        v_record_field_sum.BALDEFOVD:=nvl(v_record_field_sum.BALDEFOVD,0) + nvl(v_record_field_sub.BALDEFOVD,0);
        v_record_field_sum.DEALPAIDAMT:=nvl(v_record_field_sum.DEALPAIDAMT,0) + nvl(v_record_field_sub.DEALPAIDAMT,0);


        END LOOP;


        open PV_REFCURSOR for select v_record_field_sum.PURCHASINGPOWER PURCHASINGPOWER,v_record_field_sum.AVLLIMIT AVLLIMIT,
                                       v_record_field_sum.CASH_ON_HAND CASH_ON_HAND, v_record_field_sum.ORDERAMT ORDERAMT,
                                       v_record_field_sum.OUTSTANDING OUTSTANDING, v_record_field_sum.ADVANCEDLINE ADVANCEDLINE,
                                        v_record_field_sum.AVLADVANCED AVLADVANCED, v_record_field_sum.PAIDAMT PAIDAMT,
                                         v_record_field_sum.MRCRLIMITMAX MRCRLIMITMAX ,v_record_field_sum.CASH_RECEIVING_T0 CASH_RECEIVING_T0,
                                         v_record_field_sum.CASH_RECEIVING_T1 CASH_RECEIVING_T1,v_record_field_sum.CASH_RECEIVING_T2 CASH_RECEIVING_T2,
                                         v_record_field_sum.CASH_RECEIVING_T3 CASH_RECEIVING_T3, v_record_field_sum.CASH_RECEIVING_TN CASH_RECEIVING_TN,
                                         v_record_field_sum.CASH_SENDING_T0 CASH_SENDING_T0,v_record_field_sum.CASH_SENDING_T1 CASH_SENDING_T1,
                                         v_record_field_sum.CASH_SENDING_T2 CASH_SENDING_T2 ,v_record_field_sum.CASH_SENDING_T3 CASH_SENDING_T3,
                                         v_record_field_sum.CASH_SENDING_TN CASH_SENDING_TN, v_record_field_sum.TOTALDEB TOTALDEB,
                                         v_record_field_sum.ADVANCED_BALANCE ADVANCED_BALANCE ,v_record_field_sum.BALDEFOVD BALDEFOVD,
                                           v_record_field_sum.DEALPAIDAMT DEALPAIDAMT



                                       from dual;

EXCEPTION
    WHEN others THEN
        return;
END;
/

