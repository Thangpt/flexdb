CREATE OR REPLACE PROCEDURE pr_t_fo_accounts (
    pv_strafacctno IN VARCHAR2 DEFAULT NULL)
IS
    l_afacctno   VARCHAR2 (20);
    l_count      INTEGER;
    l_count_cls      INTEGER;
    l_count_1class  INTEGER;
    l_NumOfClass      NUMBER(20):=20; --4: Class 001,002,003,004.
    v_acclass    VARCHAR2(100);
    v_mod        number(20);
BEGIN
    -- 1. xoa du lieu
    IF pv_strafacctno IS NULL OR pv_strafacctno = 'ALL'
    THEN
        l_afacctno  := '%';
    ELSE
        l_afacctno  := pv_strafacctno;
    END IF;

    DELETE FROM   t_fo_account
          WHERE   acctno LIKE l_afacctno;

    COMMIT;
    -- 2. Tong hop lai du lieu da xoa
    l_count      := 0;
    l_count_cls  := 0;
    --SELECT ceil(count(*)/l_class) INTO l_count_1class  FROM v_fo_account;
    --dbms_output.put_line('l_count_1class: '||l_count_1class);
    FOR rec IN (  SELECT   *
                    FROM   v_fo_account
                   WHERE   acctno LIKE l_afacctno
                ORDER BY   acctno)
    LOOP
        l_count_cls:= l_count_cls + 1;
        v_mod:= mod(l_count_cls,l_NumOfClass);
        v_acclass:=lpad(v_mod,3,'0');


/*        IF  l_count_cls/l_count_1class <= 1 THEN
            v_acclass:='001';

        ELSIF   l_count_cls/l_count_1class >  1  AND l_count_cls/l_count_1class <= 2 THEN
            v_acclass:='002';

        ELSIF   l_count_cls/l_count_1class >  2  AND l_count_cls/l_count_1class <= 3 THEN
            v_acclass:='003';
        ELSE
            v_acclass:='004';
        END IF;*/



        INSERT INTO t_fo_account (acctno, actype, custodycd, policycd, grname, acclass, formulacd, poolid, roomid,
                                  basketid, status, rate_brk_s, rate_brk_b, rate_tax, rate_adv, ratio_init, ratio_main,
                                  ratio_exec, trfbuyext, trfbuyamt, banklink, bankacctno, bankcode, bod_nav, bod_seamt,
                                  bod_seass, bod_adv, bod_debt, bod_debt_m, bod_td, bod_balance, bod_intbal, bod_intacr,
                                  bod_payable, bod_crlimit, bod_t0value, bod_rcasht0, bod_rcasht1, bod_rcasht2, bod_rcasht3,
                                  bod_rcashtn, bod_scasht0, bod_scasht1, bod_scasht2, bod_scasht3, bod_scashtn, calc_ratio,
                                  calc_advbal, calc_pp0, calc_asset, calc_odramt, calc_trfbuy, lastchange, BOD_D_MARGIN,BOD_DEBT_T0 ,
                                  rate_ub, BASKETID_UB, BOD_D_MARGIN_UB,Rate_T0loan,Bod_Deal)
          VALUES   (rec.acctno,
                    rec.actype, rec.custodycd, rec.policycd, rec.grname, v_acclass, rec.formulacd, rec.poolid, rec.roomid,
                    rec.basketid, rec.status, rec.rate_brk_s, rec.rate_brk_b, rec.rate_tax, rec.rate_adv, rec.ratio_init, rec.ratio_main,
                    rec.ratio_exec, rec.trfbuyext, rec.trfbuyamt, rec.banklink, rec.bankacctno, rec.bankcode, 0, 0,
                    0, rec.bod_adv, rec.bod_debt, rec.bod_debt_m, rec.bod_td, rec.bod_balance, rec.bod_intbal, rec.bod_intacr,
                    rec.bod_payable, rec.bod_crlimit, rec.bod_t0value, rec.bod_rcasht0, rec.bod_rcasht1, rec.bod_rcasht2, rec.bod_rcasht3,
                    rec.bod_rcashtn, rec.bod_scasht0, rec.bod_scasht1, rec.bod_scasht2, rec.bod_scasht3, rec.bod_scashtn, 0 ,
                    0 , 0 , 0 , 0 , 0 , SYSTIMESTAMP, rec.BOD_D_MARGIN, rec.BOD_DEBT_T0, rec.rate_ub, rec.BASKETID_UB, rec.BOD_D_MARGIN_UB,
                    rec.Rate_T0loan, rec.Bod_Deal);

        l_count     := l_count + 1;

        IF l_count >= 10000
        THEN
            COMMIT;
            l_count     := 0;
        END IF;
    END LOOP;

    COMMIT;
EXCEPTION
    WHEN OTHERS
    THEN
        NULL;
END;
/

