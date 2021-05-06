CREATE OR REPLACE FUNCTION fn_getclosefee(PV_AFACCTNO IN VARCHAR2,P_FEETYPE IN VARCHAR2)
    RETURN NUMBER IS
-- PURPOSE: PHI dong tai khoan
-- MODIFICATION HISTORY
-- PERSON      DATE         COMMENTS
-- ---------   ------       -------------------------------------------

    V_RESULT NUMBER;
    V_FEERATE NUMBER;
    V_FEEMAX NUMBER;
    V_ACCNUM NUMBER;

BEGIN
V_FEERATE :=0;
V_FEEMAX :=0;
V_RESULT :=0;
V_ACCNUM :=0;
/*
KIEM TRA XEM CO PHAI TIEU KHOAN CUOI CUNG KHONG
DUNG: RETURN FEE
SAI: RETURN 0
*/
 SELECT COUNT(ACCTNO) INTO V_ACCNUM  FROM AFMAST WHERE
 CUSTID = (SELECT CUSTID FROM AFMAST WHERE  ACCTNO=PV_AFACCTNO )
 AND STATUS NOT IN ( 'N','C') AND ACCTNO <> PV_AFACCTNO;

 IF V_ACCNUM >0 THEN
    RETURN 0;
 else
    SELECT FEEAMT INTO  V_RESULT
    FROM FEEMASTER WHERE FEECD = P_FEETYPE AND STATUS ='Y';
 END IF;

RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/

