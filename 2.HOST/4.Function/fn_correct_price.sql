CREATE OR REPLACE FUNCTION fn_correct_price
   (pv_CodeID IN  char,
    pv_PRICE in number,
    pv_PRICETYPE in char -- tran hay san
    )
RETURN number
  IS
  v_return number;
  v_PRICE  number;
  v_strError NVARCHAR2(200);
  v_ticksize number;
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

BEGIN
   v_PRICE :=0;
   v_PRICE:=GREATEST(pv_PRICE,0);

--them vao tinh lai tran san cho HO_
    BEGIN
        SELECT st.ticksize INTO v_ticksize FROM securities_ticksize st
        WHERE st.fromprice <= v_PRICE AND st.toprice >= v_PRICE AND st.codeid = pv_CodeID;
    EXCEPTION WHEN OTHERS THEN
        IF v_PRICE < 10000 THEN v_ticksize := 10;
        ELSIF v_PRICE < 50000 THEN v_ticksize := 50;
        ELSE v_ticksize := 100;
        END IF;
    END;

    If pv_PRICETYPE='C' then
        v_return:=GREATEST(Floor(v_PRICE/v_ticksize)*v_ticksize,0);
    else
        v_return:=GREATEST(Ceil(v_PRICE/v_ticksize)*v_ticksize,0);
    end if;

/*case
when v_PRICE <50000 then
         -- Buoc gia lam tron den don vi 100-------------
         If pv_PRICETYPE='C' then
           v_return:=Floor(v_PRICE/100)*100;
         else
           v_return:=Ceil(v_PRICE/100)*100;
         end if;

when v_PRICE <100000 And v_PRICE >= 50000 then

        If pv_PRICETYPE='C' then
           v_return:=Floor(v_PRICE/500)*500;
         else
           v_return:=Ceil(v_PRICE/500)*500;
         end if;

when v_PRICE >=100000  then
     -- Buoc gia lam tron den don vi 1000-------------
     If pv_PRICETYPE='C' then
           v_return:=Floor(v_PRICE/1000)*1000;
         else
           v_return:=Ceil(v_PRICE/1000)*1000;
         end if;
null;

end case;*/

return v_return;

EXCEPTION
    WHEN others THEN
      v_strError :=SQLERRM ;
            INSERT INTO log_err (id,date_log, POSITION, text)
            VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' quyet.kieu : fn_correct_price' || pv_CodeID  ,v_strError);
           commit;
        return 0;
END;
/

