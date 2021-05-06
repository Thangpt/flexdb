CREATE OR REPLACE FUNCTION fn_fix_1131 (p_txnum VARCHAR2, p_txdate VARCHAR2)
    RETURN VARCHAR2
IS
    l_err_code  VARCHAR2(10000);
    v_count     NUMBER;
    l_txdate    DATE;
    l_namt      NUMBER;
    l_acctno    VARCHAR2(20);

BEGIN

    l_txdate := to_date(p_txdate,'dd/mm/rrrr');

    -- HAM THUC HIEN XOA GD 1131
    BEGIN
        SELECT namt, acctno INTO l_namt, l_acctno FROM citran WHERE TXNUM = p_txnum AND TXDATE = l_txdate AND txcd = '0012' AND deltd <> 'Y';
    EXCEPTION WHEN OTHERS THEN
        l_err_code := 'Error';
        RETURN l_err_code;
    END;

    UPDATE CIMAST SET
        BALANCE=BALANCE - l_namt,
        LASTDATE=TO_DATE(p_txdate, systemnums.C_DATE_FORMAT),
        CRAMT=CRAMT - l_namt, LAST_CHANGE = SYSTIMESTAMP
    WHERE ACCTNO=l_acctno;

    UPDATE TLLOG SET DELTD = 'Y'
    WHERE TXNUM = p_txnum AND TXDATE = l_txdate;

    UPDATE CITRAN SET DELTD = 'Y'
    WHERE TXNUM = p_txnum AND TXDATE = l_txdate;

    l_err_code:= 'OK';
    RETURN l_err_code;

EXCEPTION WHEN OTHERS THEN
    l_err_code := 'Error';
    RETURN l_err_code;
END;
/

