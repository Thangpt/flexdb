CREATE OR REPLACE PROCEDURE pr_t_fo_defrules
IS
    v_strMsg    VARCHAR2(4000);
    v_ErrCode    VARCHAR2(100);
    v_ErrMsg     VARCHAR2(4000);
BEGIN
--Dong bo lai chinh sach mua ban dau ngay
--Tong hop lai t_fo_inday_defrules
PCK_SYN2FO.PRC_GEN_MSG_CHGDEFRULE( v_txdate => '',
                                    v_txnum  => '',
                                    v_tltxcd => 'CHGDEFRULE',
                                    v_strMsg=>v_strMsg ,
                                    v_errcode=>v_ErrCode,
                                    v_errmsg=>v_ErrMsg
                                  );
--Lay du lieu tu trong t_fo_inday_defrules insert vao t_fo_defrules
DELETE FROM t_fo_defrules;
INSERT INTO t_fo_defrules(autoid, REFTYPE, REFCODE, RULENAME, REFCVAL, REFNVAL,lastchange)
SELECT  SEQ_DEFRULES.NEXTVAL@DBL_FO,
        REFTYPE, REFCODE, RULENAME, REFCVAL, REFNVAL,
        SYSTIMESTAMP lastchange
      FROM v_fo_defrules;

EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/

