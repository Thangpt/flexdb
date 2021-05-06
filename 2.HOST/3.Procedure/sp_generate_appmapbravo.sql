CREATE OR REPLACE PROCEDURE sp_generate_appmapbravo (
       pv_txdate in VARCHAR,
       pv_txnum in VARCHAR,
       pv_errmsg out VARCHAR ) IS
       v_currdate               varchar2(20);
       v_busdate                varchar2(20);
       V_TXDATE                  varchar2(20);
       v_custid                 varchar2(10);
       v_custodycd              varchar2(10);
       v_custodycd_debit        varchar2(10);
       v_custodycd_credit      varchar2(10);
       v_bankid                varchar2(100);
       v_trans_type            varchar2(10);
       v_amount                varchar2(100);
       v_symbol                varchar2(20);
       v_symbol_qtty           number DEFAULT 0;
       v_symbol_price          number DEFAULT 0;
       v_costprice            number DEFAULT 0;
       v_txbrid               varchar2(10);
       v_brid                 varchar2(10);
       v_tradeplace           varchar2(10);
       v_iscorebank           varchar2(10);
       v_status               varchar2(10);
       v_custatcom            varchar2(10);
       v_custtype             varchar2(10);
       v_country             varchar2(10);
       v_sectype             varchar2(10);
       v_note                varchar2(2000);
       v_tltxcd              varchar2(10);
       v_acfld               varchar2(10);
       v_acsefld               varchar2(16);
       v_amtexp              varchar2(100);
       v_codeid              varchar2(100);
       v_qttyexp             varchar2(100);
       v_price               varchar2(100);
       v_pos_amtexp          NUMBER DEFAULT 0;
       v_expression          varchar2(100);
       v_evaluator           varchar2(100);
       v_bankname             varchar2(1000);
       v_orgorderid           varchar2(1000);
       v_bors                           varchar2(10);
       v_fullname              varchar2(1000);
       v_acname              varchar2(100);
       v_dorc                varchar2(10);
       v_reftran          varchar2(100);
       V_QTTYTYPE               varchar2(10);
 CURSOR v_cursor_appmapbravo(v_tltxcd VARCHAR2 ) is SELECT * FROM APPMAPBRAVO where tltxcd = v_tltxcd  ;
 v_appmapbravo_row v_cursor_appmapbravo%ROWTYPE;
BEGIN
V_TXDATE:= pv_txdate;
   select varvalue into v_currdate
       from sysvar where varname = 'CURRDATE';
--THONG TIN GIAO DICH
        SELECT tltxcd, to_char(busdate,'DD/MM/RRRR'), txdesc,brid
                 INTO v_tltxcd, v_busdate, v_note,v_txbrid
         FROM vw_tllog_all TL WHERE TL.TXDATE=TO_DATE(pv_txdate,'DD/MM/RRRR') AND TL.TXNUM=pv_txnum;


   OPEN v_cursor_appmapbravo(v_tltxcd);
      LOOP
        pv_errmsg:='Begin';
--        dbms_output.put_line(pv_errmsg);
        FETCH v_cursor_appmapbravo INTO v_appmapbravo_row;
        EXIT WHEN v_cursor_appmapbravo%NOTFOUND;
        v_trans_type := v_tltxcd || v_appmapbravo_row.Subtx;

          v_acname:=v_appmapbravo_row.acname;
          v_dorc:=v_appmapbravo_row.dorc;
--LAY KHOA
          v_acfld:=v_appmapbravo_row.acfld;

        SELECT CVALUE INTO v_acfld
        FROM vw_tllogfld_all TL WHERE TL.TXDATE=TO_DATE(PV_TXDATE,'DD/MM/RRRR') AND TL.TXNUM=PV_TXNUM AND FLDCD=V_APPMAPBRAVO_ROW.ACFLD;

        SELECT max(decode(fldcd, v_appmapbravo_row.acfld , CVALUE, '')), max(decode(fldcd, v_appmapbravo_row.bankid , CVALUE, ''))
        ,max(decode(fldcd, v_appmapbravo_row.codeid , CVALUE, '')),     max(decode(fldcd, v_appmapbravo_row.price , NVALUE, 0)), max(decode(fldcd, v_appmapbravo_row.acsefld , CVALUE, ''))
        , max(decode(fldcd, v_appmapbravo_row.symbol , CVALUE, '')), max(decode(fldcd, v_appmapbravo_row.reftran , CVALUE, ''))
        INTO v_acfld,v_bankid,v_codeid,v_price,v_acsefld,v_symbol,v_reftran
        FROM vw_tllogfld_all TL WHERE TL.TXDATE=TO_DATE(pv_txdate,'DD/MM/RRRR') AND TL.TXNUM=pv_txnum;

IF LENGTH(v_bankid)  <=3 then
    Begin
        select  glaccount into v_bankid  from banknostro where shortname =v_bankid;
    EXCEPTION
      WHEN OTHERS THEN
      null;
    End;

   /* ELSIF LENGTH(v_bankid)  > 3 then

       IF v_tltxcd IN ('2646','2648','2665') THEN
               select case when  custbank ='0001000001' then 'MBBLD'
                           when  custbank ='0001000012' then 'LVBTL'
                           END into v_bankid
               from (SELECT * FROM dfgroup UNION SELECT * FROM dfgrouphist) WHERE GROUPID  = v_bankid;
        ELSif v_tltxcd ='2674' then

               select case when  v_bankid ='0001000001' then 'MBBLD'
                           when  v_bankid ='0001000012' then 'LVBTL'
                           END into v_bankid
               from dual ;
        else

               select case when  custbank ='0001000001' then 'MBBLD'
                           when  custbank ='0001000012' then 'LVBTL'
                           END into v_bankid
               from vw_lnmast_all WHERE ACCTNO = v_bankid;
       END IF ;*/
End if;
-- DUCNV voi c?giao dich giai ngan v?hu no th?ankid= so tk no -> lay l?i rrtype trong lnmast de xac dinh nguon cty hay nguon NH
IF v_tltxcd in ('5566','5540','5567') then
    For vc in (select rrtype,custbank  from lnmast where acctno = v_bankid) loop
        IF vc.rrtype ='C'       then
            v_bankid:='MSBS';
        Else
            If vc.custbank ='0001001990' then
                v_bankid:='MSB';
            ELSIF vc.custbank ='0001010992' then
                v_bankid:='TTP';
            ELSIF vc.custbank ='0001021686' then
                v_bankid:='VB';
            else
                v_bankid:='NEW';
            End if;
        End if;
    End loop;
End if;
-- LAY CAC TRUONG LIEN QUAN DEN TIEU KHOAN
SELECT cf.custid,cf.custodycd , cf.brid,CF.custatcom,CF.CUSTTYPE,DECODE (CF.country,'234','001','002'),af.corebank,af.bankname,cf.fullname
INTO v_custid,v_custodycd, v_brid,v_custatcom,v_custtype,v_country ,v_iscorebank,v_bankname,v_fullname
FROM AFMAST AF, CFMAST CF
WHERE AF.CUSTID =CF.CUSTID AND AF.ACCTNO = v_acfld;

-- LAY CAC TRUONG LIEN QUAN DEN THONG TIN CHUNG KHOAN
if  LENGTH(v_acsefld)  >0 then
for rec in
(select nvl( sb.symbol,'') symbol , decode ( v_price,0, sb.parvalue, v_price) price,nvl(se.COSTPRICE,0) COSTPRICE
,nvl( sb.TRADEPLACE,'') TRADEPLACE , nvl(sb.SECTYPE,'') SECTYPE
from sbsecurities sb,semast se
where  se.codeid =sb.codeid  and  se.acctno = v_acsefld
)
loop
 v_symbol:=rec.symbol ;
 v_price:= rec.price;
 v_costprice:= rec.costprice;
 v_tradeplace := rec.tradeplace;
 v_sectype := rec.sectype;

end loop ;

else


for rec in
(select nvl( sb.symbol,'') symbol , decode ( v_price,0, sb.parvalue, v_price) price,nvl(se.COSTPRICE,0) COSTPRICE
,nvl( sb.TRADEPLACE,'') TRADEPLACE , nvl(sb.SECTYPE,'') SECTYPE
from sbsecurities sb,semast se
where  se.codeid =sb.codeid  and  se.afacctno = v_acfld and sb.symbol =v_symbol
)
loop
 v_symbol:=rec.symbol ;
 v_price:= rec.price;
 v_costprice:= rec.costprice;
 v_tradeplace := rec.tradeplace;
 v_sectype := rec.sectype;

end loop ;

end if ;

v_symbol_qtty:=0;
v_amount:=0;
-- TINH AMOUNT
 pv_errmsg:='Generate account number';
                --Thuc hien tinh bieu thuc
if v_appmapbravo_row.AMTEXP is not null then
                v_amtexp:=v_appmapbravo_row.AMTEXP;
                v_pos_amtexp:=1;
                v_expression:='';
--                dbms_output.put_line(pv_errmsg);
                WHILE v_pos_amtexp<length(v_amtexp) LOOP
                    v_evaluator:=substr(v_amtexp,v_pos_amtexp,2);
                    v_pos_amtexp:=v_pos_amtexp+2;
                    IF (v_evaluator='++' OR  v_evaluator='--' OR  v_evaluator='**' OR  v_evaluator='//' OR  v_evaluator='((' OR v_evaluator='))') THEN
                       v_expression:=v_expression || SUBSTR(v_evaluator,1,1);
                    ELSE
                       BEGIN
                            SELECT NVALUE+TO_NUMBER(NVL(CVALUE,0)) INTO v_amount FROM  VW_TLLOGFLD_ALL TL
                            WHERE TXDATE=TO_DATE(pv_txdate,'DD/MM/RRRR') AND TXNUM=pv_txnum AND FLDCD=v_evaluator;
                            v_expression:=v_expression || v_amount;
                       END;
                    END IF;
                END LOOP;

          v_expression:='UPDATE EVAL_EXPRESSTION SET EVAL=' || v_expression;
          execute immediate v_expression;
          pv_errmsg:='Evaluate: ' || v_expression;
          SELECT EVAL INTO v_amount FROM EVAL_EXPRESSTION;
UPDATE EVAL_EXPRESSTION SET EVAL =0;

end if;
-- TINH v_symbol_qtty
if v_appmapbravo_row.QTTYEXP is not null then
                --Thuc hien tinh bieu thuc
                v_qttyexp:=v_appmapbravo_row.QTTYEXP;
                v_pos_amtexp:=1;
                v_expression:='';
--                dbms_output.put_line(pv_errmsg);
                WHILE v_pos_amtexp<length(v_qttyexp) LOOP
                    v_evaluator:=substr(v_qttyexp,v_pos_amtexp,2);
                    v_pos_amtexp:=v_pos_amtexp+2;
                    IF (v_evaluator='++' OR  v_evaluator='--' OR  v_evaluator='**' OR  v_evaluator='//' OR  v_evaluator='((' OR v_evaluator='))') THEN
                       v_expression:=v_expression || SUBSTR(v_evaluator,1,1);
                    ELSE
                       BEGIN
                            SELECT NVALUE+TO_NUMBER(NVL(CVALUE,0)) INTO v_symbol_qtty FROM VW_TLLOGFLD_ALL TL
                            WHERE TXDATE=TO_DATE(pv_txdate,'DD/MM/RRRR') AND TXNUM=pv_txnum AND FLDCD=v_evaluator;
                            v_expression:=v_expression || v_symbol_qtty;
                       END;
                    END IF;
                END LOOP;
IF length(v_expression)>0  THEN
          v_expression:='UPDATE EVAL_EXPRESSTION SET EVAL=' || v_expression;
          execute immediate v_expression;
          pv_errmsg:='Evaluate: ' || v_expression;
          SELECT EVAL INTO v_symbol_qtty FROM EVAL_EXPRESSTION;
UPDATE EVAL_EXPRESSTION SET EVAL =0;
END IF;

end if ;




if v_tltxcd in ('8804','8809') then
--select  orgorderid,bors into v_orgorderid,v_bors from  vw_iod_all where TXDATE = TO_DATE (pv_txdate,'DD/MM/YYYY') AND TXNUM = pv_txnum;

select TO_CHAR ( txdate,'DD/MM/YYYY'), case when duetype ='RS' THEN 'B' ELSE 'S' END   into V_TXDATE,v_bors  from   vw_stschd_all sts
where sts.duetype in ('RM','RS') AND orgorderid = v_reftran;

if v_bors ='B' then
v_trans_type:=v_tltxcd||'02';
else
v_trans_type:=v_tltxcd||'03';
end if ;
 v_busdate:=V_TXDATE;

v_amount:= v_symbol_qtty*v_price;

end if;



if v_tltxcd ='8879' then

select custodycd into v_custodycd_debit   from vw_setran_gen where txdate =TO_DATE( V_TXDATE ,'DD/MM/YYYY')
and txnum  = pv_txnum and txcd ='0020';

v_custodycd_credit:= v_custodycd;

end if ;


if v_tltxcd ='8868' AND v_appmapbravo_row.APPTYPE='CI' then
select v_tltxcd || CASE WHEN trfbuyext= 0 THEN '01' ELSE '02' END  INTO v_trans_type  from   vw_stschd_all sts
where sts.duetype ='SM' AND orgorderid = v_reftran ;
end if ;

IF v_symbol_qtty >0  AND v_acname IN ('BLOCKED') THEN

SELECT  NVL( REF,'-') INTO V_QTTYTYPE  FROM vw_setran_gen WHERE TXDATE = TO_DATE(pv_txdate ,'DD/MM/YYYY') AND  TXNUM = pv_txnum AND FIELD IN ('BLOCKED','DTOCLOSE')  ;
IF V_QTTYTYPE = '002' THEN
v_trans_type:=v_tltxcd||'09';
END IF;

END IF ;


if v_tltxcd ='2248' then

for rec in ( select * from  vw_setran_gen where txdate =TO_DATE( V_TXDATE ,'DD/MM/YYYY') and txnum  = pv_txnum  )
loop

insert into gl_exp_tran( ref, txdate, txnum, busdate, custid, custodycd,
       custodycd_debit, custodycd_credit, bankid, trans_type,
       amount, symbol, symbol_qtty, symbol_price, costprice,
       txbrid, brid, tradeplace, iscorebank, status,
       custatcom, custtype, country, sectype, note,bankname,fullname,acname,dorc,reftran)
VALUES( seq_gltran.nextval,TO_DATE( V_TXDATE ,'DD/MM/YYYY') , pv_txnum,TO_DATE( v_busdate,'DD/MM/YYYY'), v_custid, v_custodycd,
       v_custodycd_debit, v_custodycd_credit, v_bankid,  v_tltxcd || case when nvl(rec.ref,'-') = '002' then '09' else '02'   end  ,
       v_amount, v_symbol, rec.namt, v_price, v_costprice,
       v_txbrid, v_brid, v_tradeplace, v_iscorebank, v_status,
       v_custatcom, v_custtype, v_country, v_sectype, v_note,v_bankname,v_fullname,v_acname,v_dorc,v_reftran);

end loop ;

else

if nvl(v_symbol_qtty,0)+ nvl(v_amount,0) >0 then

insert into gl_exp_tran( ref, txdate, txnum, busdate, custid, custodycd,
       custodycd_debit, custodycd_credit, bankid, trans_type,
       amount, symbol, symbol_qtty, symbol_price, costprice,
       txbrid, brid, tradeplace, iscorebank, status,
       custatcom, custtype, country, sectype, note,bankname,fullname,acname,dorc,reftran)
VALUES( seq_gltran.nextval,TO_DATE( V_TXDATE ,'DD/MM/YYYY') , pv_txnum,TO_DATE( v_busdate,'DD/MM/YYYY'), v_custid, v_custodycd,
       v_custodycd_debit, v_custodycd_credit, v_bankid, v_trans_type,
       v_amount, v_symbol, v_symbol_qtty, v_price, v_costprice,
       v_txbrid, v_brid, v_tradeplace, v_iscorebank, v_status,
       v_custatcom, v_custtype, v_country, v_sectype, v_note,v_bankname,v_fullname,v_acname,v_dorc,v_reftran);

end if ;
end if;

end loop;
  CLOSE v_cursor_appmapbravo;
--  dbms_output.put_line('End');
EXCEPTION
  WHEN OTHERS THEN
  return;

END;
/

