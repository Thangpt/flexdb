-- Start of DDL Script for Function HOSTMSTRADE.FN_GET_PRICE_NEXTDATE
-- Generated 26-Apr-2019 09:18:48 from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE 
FUNCTION fn_get_price_nextdate (pv_codeid IN VARCHAR2,pv_BasicPrice IN NUMBER,pv_Type IN VARCHAR2)
RETURN NUMBER
  IS
    v_Result_Price  NUMBER;
    v_N_Basic_Price NUMBER;
    v_count NUMBER;

BEGIN
    -- Tinh gia tuy theo Type truyen vao
    -- B: Basic Price
    -- C: Ceiling Price
    -- F: Floor Price

    -- Tinh lai gia tham chieu
    SELECT max(round(pv_BasicPrice / st.ticksize) * st.ticksize)
    INTO v_N_Basic_Price
    FROM securities_ticksize st
    WHERE st.codeid = pv_codeid
        AND st.fromprice <= pv_BasicPrice AND st.toprice >=  pv_BasicPrice;
    IF pv_type = 'B' THEN
        v_Result_Price := v_N_Basic_Price;
    ELSIF pv_Type = 'C' THEN
      --1.5.6.0: tinh lai gia tru sectype 012
      select count(*) into v_count
      from sbsecurities sb, securities_info se
      where sb.codeid = se.codeid and se.codeid = pv_codeid and sb.sectype ='012';
      if(v_count = 0) then
            SELECT max(ROUND(floor(CEILINGPRICE/st.ticksize)*st.ticksize)) CEILINGPRICE
            INTO v_Result_Price
            FROM
                (SELECT sb.codeid,
                    floor((CASE WHEN sb.tradeplace = '001' THEN TO_NUMBER(SYS2.VARVALUE)/100
                    WHEN sb.tradeplace = '002' THEN TO_NUMBER(SYS1.VARVALUE)/100
                    WHEN sb.tradeplace = '005' THEN TO_NUMBER(SYS3.VARVALUE)/100
                    ELSE 0 END + 1) * v_N_Basic_Price)  CEILINGPRICE
                FROM sbsecurities sb, sysvar sys1, sysvar sys2, sysvar sys3
                WHERE sb.codeid = pv_codeid
                    AND SYS1.grname = 'SYSTEM' AND SYS1.VARNAME = 'PRICELIMIT_HNX'
                    AND SYS2.grname = 'SYSTEM' AND SYS2.VARNAME = 'PRICELIMIT_HOSE'
                    AND SYS3.grname = 'SYSTEM' AND SYS3.VARNAME = 'PRICELIMIT_UPCOM'
                ) sec,
                securities_ticksize st
            WHERE sec.codeid = st.codeid
                AND sec.CEILINGPRICE >= st.fromprice AND sec.CEILINGPRICE <= st.toprice;
         else
            begin
                select sb.ceilingprice into v_Result_Price
                from securities_info sb  WHERE sb.codeid = pv_codeid AND sb.ceilingprice > 0;
            EXCEPTION WHEN others THEN
                    v_Result_Price := 10000000;
            END;
         end if;

    ELSIF pv_Type = 'F' THEN
       --1.5.6.0: tinh lai gia tru sectype 012
      select count(*) into v_count
      from sbsecurities sb, securities_info se
      where sb.codeid = se.codeid and se.codeid = pv_codeid and sb.sectype ='012';
      if(v_count = 0) then
              SELECT max(ROUND(ceil(FLOORPRICE/st.ticksize)*st.ticksize)) FLOORPRICE
              INTO v_Result_Price
              FROM
                  (SELECT sb.codeid,
                      ceil((1 - CASE WHEN sb.tradeplace = '001' THEN TO_NUMBER(SYS2.VARVALUE)/100
                      WHEN sb.tradeplace = '002' THEN TO_NUMBER(SYS1.VARVALUE)/100
                      WHEN sb.tradeplace = '005' THEN TO_NUMBER(SYS3.VARVALUE)/100
                      ELSE 0 END) * v_N_Basic_Price)  FLOORPRICE
                  FROM sbsecurities sb, sysvar sys1, sysvar sys2, sysvar sys3
                  WHERE sb.codeid = pv_codeid
                      AND SYS1.grname = 'SYSTEM' AND SYS1.VARNAME = 'PRICELIMIT_HNX'
                      AND SYS2.grname = 'SYSTEM' AND SYS2.VARNAME = 'PRICELIMIT_HOSE'
                      AND SYS3.grname = 'SYSTEM' AND SYS3.VARNAME = 'PRICELIMIT_UPCOM'
                  ) sec,
                  securities_ticksize st
              WHERE sec.codeid = st.codeid
                  AND sec.FLOORPRICE >= st.fromprice AND sec.FLOORPRICE <= st.toprice;
       else
            begin
                select sb.floorprice into v_Result_Price
                from securities_info sb  WHERE sb.codeid = pv_codeid AND sb.floorprice > 0;
            EXCEPTION WHEN others THEN
                    v_Result_Price := 1000;
            END;
       end if;

    END IF;

    RETURN v_Result_Price;
EXCEPTION WHEN others THEN
    plog.error(dbms_utility.format_error_backtrace);
    return  pv_BasicPrice;
END;
/



-- End of DDL Script for Function HOSTMSTRADE.FN_GET_PRICE_NEXTDATE
