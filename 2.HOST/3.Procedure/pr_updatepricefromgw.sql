CREATE OR REPLACE PROCEDURE pr_updatepricefromgw(p_symbol        in varchar2,
                                                 p_basic_price   in number,
                                                 p_floor_price   in number,
                                                 p_ceiling_price in number,
                                                 p_update_mode   in varchar2,
                                                 p_err_code      out varchar2,
                                                 p_err_message   out varchar2) is
  l_code_id     varchar2(6);
  l_update_mode varchar2(12);
  v_ticksize number;
  v_basicprice number;
  --l_trade_place varchar2(3);
  l_tradeplace varchar2(12);



  v_floorDiff NUMBER;
  v_ceilingDiff NUMBER;
  v_floor_price    NUMBER;
  v_ceiling_price  NUMBER;
  v_amt            NUMBER;
  l_sectype VARCHAR2(20); --1.5.6.0
  v_round_basicprice      NUMBER; --1.5.8.4

BEGIN

  -- Create : hai.letran
  -- Modify : quyet.kieu
  -- DN : Dau ngay
  -- CN : Cuoi ngay
  -- ELSE : Hien tai dang de bang DN , cho nay tuy cac bac xu ly
  v_basicprice:=p_basic_price;
  BEGIN
     SELECT   ticksize
       INTO   v_ticksize
       FROM   securities_ticksize
      WHERE       symbol = p_symbol
              AND (p_ceiling_price + p_floor_price) / 2 >= fromprice
              AND (p_ceiling_price + p_floor_price) / 2 <= toprice;
  EXCEPTION
     WHEN OTHERS
     THEN
         v_ticksize  := 1;
  END;
 --Neu chech lech 2 lan ticksize la thuc hien quyen -> lay trung binh tran va san
/*  IF ABS((p_ceiling_price + p_floor_price)/2 - p_basic_price) > 2* v_ticksize THEN
     v_basicprice:= (p_ceiling_price + p_floor_price)/2;
  END IF;*/
  select codeid, tradeplace, sectype    --1.5.6.0
  into l_code_id, l_tradeplace, l_sectype   --1.5.6.0
  from sbsecurities
  where SYMBOL = p_symbol;

  v_basicprice:=p_basic_price;
  v_floor_price:=p_floor_price;
  v_ceiling_price:= p_ceiling_price;

  -- ThongPM: Chi dieu chinh gia doi voi san HOSE
  IF l_sectype <> '012' AND l_tradeplace = '001' and ABS((p_ceiling_price + p_floor_price)/2 - p_basic_price) > 2* v_ticksize THEN --1.5.6.0
        v_basicprice:= Round(
                               ((p_ceiling_price + p_floor_price)/2)
                               /v_ticksize
                             )
                             * v_ticksize ;
    END IF;


  l_update_mode := p_update_mode;


  case
    when l_update_mode = 'DN' then
      -- DN : Dau ngay


      update securities_info
         set --FLOORPRICE         = p_floor_price,  --1.5.6.0
             --CEILINGPRICE       = p_ceiling_price,    --1.5.6.0
             BASICPRICE         = v_basicprice,
             avgprice           = v_basicprice,
             dfrlsprice         = v_basicprice,
             dfrefprice         = v_basicprice,
             marginprice        = v_basicprice,
             margincallprice    = v_basicprice,
             marginrefprice     = v_basicprice,
             marginrefcallprice = v_basicprice
       where (CODEID = l_code_id or
             CODEID in (select CODEID from SBSECURITIES where REFCODEID = l_code_id));
       --1.5.6.0
       update securities_info
         set FLOORPRICE         = p_floor_price,
             CEILINGPRICE       = p_ceiling_price
         where p_floor_price >0 and p_ceiling_price >0 and
           CODEID in (Select CODEID From SBSECURITIES  Where sectype  not in ('003','006') and (CODEID = l_code_id or REFCODEID = l_code_id));
       --1.5.6.0

    when l_update_mode = 'CN' THEN

        If l_tradeplace ='001' THEN

        -- CN : Cuoi ngay
            --San HOSE thi cap nhat tran san theo so tra ve , gia tham chieu da dieu chinh
        Update securities_info
        Set newprice           = '1',
            --avgprice           = v_basicprice,
            --newbasicprice      = p_basic_price, --v_basicprice,
            newceilingprice    = v_ceiling_price,
            newfloorprice      = v_floor_price
        Where  newprice        = '0'
            and CODEID in (Select CODEID From SBSECURITIES  Where sectype  in ('003','006') and (CODEID = l_code_id or REFCODEID = l_code_id));

        Update securities_info
        Set newprice           = '1',
            avgprice           = v_basicprice,
            newbasicprice      = p_basic_price, --v_basicprice,
            newceilingprice    = v_ceiling_price,
            newfloorprice      = v_floor_price
        Where  newprice        = '0'
            and CODEID in (Select CODEID From SBSECURITIES  Where sectype not in ('003','006') and (CODEID = l_code_id or REFCODEID = l_code_id));

       ELSE
             --san upcom, lam tron theo ticksize
            if mod(p_basic_price,v_ticksize) <> 0 and l_tradeplace ='005' then
                v_round_basicprice:= round(p_basic_price/v_ticksize) * v_ticksize;
            else
                v_round_basicprice:=p_basic_price;
            end if;
            --San HNX thi cap nhat tran,san theo gai dong cua cua so p_basic_price
            --San HNX,UPCOM thi cap nhat tran,san theo gai dong cua cua so p_basic_price
			--1.5.6.0: tinh gia new tran/san/Basic
			v_ceiling_price := fn_get_price_nextdate(l_code_id, nvl(v_round_basicprice,0), 'C');
			v_floor_price := fn_get_price_nextdate(l_code_id, nvl(v_round_basicprice,0), 'F');
			v_basicprice := fn_get_price_nextdate(l_code_id, nvl(v_round_basicprice,0), 'B');
            Update securities_info
            Set newprice       = '1',
               -- avgprice       = p_basic_price,
               -- newbasicprice  = p_basic_price,
                newceilingprice = v_ceiling_price,
                newfloorprice   =  v_floor_price
            Where  newprice       = '0'
                 and CODEID in (Select CODEID From SBSECURITIES  Where sectype  in ('003','006') and (CODEID = l_code_id or REFCODEID = l_code_id));

            Update securities_info
            Set newprice       = '1',
                avgprice       = v_round_basicprice,
                newbasicprice  = v_basicprice,
                newceilingprice = v_ceiling_price,
                newfloorprice   =  v_floor_price
            Where  newprice       = '0'
               and CODEID in (Select CODEID From SBSECURITIES  Where sectype  not in ('003','006') and (CODEID = l_code_id or REFCODEID = l_code_id));


            --Check neu tran=san=tham chieu
            SELECT newceilingprice-newfloorprice INTO v_amt FROM securities_info
                   Where  CODEID in (Select CODEID
                                   From SBSECURITIES
                                   Where  CODEID = l_code_id
                                   );
            IF v_amt=0 THEN
               Update securities_info
                Set newceilingprice = newceilingprice+ v_ticksize,
                    newfloorprice   = greatest( newfloorprice-v_ticksize,v_ticksize)
                Where  CODEID in (Select CODEID
                                   From SBSECURITIES
                                   Where  CODEID = l_code_id or REFCODEID = l_code_id
                                   );
              END IF;
        End if;

  end case;

  commit;
  p_err_code    := '0';
  p_err_message := 'Cap nhat gia thanh cong';
exception
  when NO_DATA_FOUND then
    p_err_code    := '-100010';
    p_err_message := 'Khong tim thay ma chung khoan';
    rollback;
  when others then
    p_err_code    := '-100011';
    p_err_message := 'Cap nhat gia chung khoan khong thanh cong';
    rollback;
end;
/
