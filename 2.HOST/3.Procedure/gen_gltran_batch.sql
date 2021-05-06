CREATE OR REPLACE PROCEDURE gen_gltran_batch(l_tltxcd varchar2,l_txdate  VARCHAR2) IS
a VARCHAR2(1000);
v_tltxcd varchar (30);
v_custid varchar (30);
v_custodycd varchar (30);
v_iscorebank varchar (30);
v_custatcom varchar (30);
v_custtype varchar (30);
v_country varchar (30);
v_bankname varchar (3000);
v_fullname varchar (3000);
v_bankid varchar (300);
I NUMBER ;
v_brid  varchar2(10);

BEGIN

 if UPPER(l_tltxcd )='ALL' THEN
    v_tltxcd:='%';
    ELSE
    v_tltxcd:=l_tltxcd;
    END IF;
    delete gl_exp_tran where txdate =to_date(l_txdate,'DD/MM/YYYY') and INSTR(trans_type, decode( UPPER(l_tltxcd ),'ALL',trans_type,l_tltxcd))>0;
    I:=0;
     FOR REC IN
            (
             select to_CHAR(TXDATE,'DD/MM/YYYY')  TXDATE , TXNUM  from vw_tllog_all
             where tltxcd in( select  DISTINCT tltxcd from appmapbravo) -- and tltxcd not in ('8804','8809')
             and  txdate = to_date(l_txdate,'DD/MM/YYYY') and tltxcd like v_tltxcd
             /*UNION
            select to_CHAR(tl.TXDATE,'DD/MM/YYYY')  TXDATE , tl.TXNUM  from   vw_stschd_all sts, vw_tllog_all tl
            where tl.msgacct =sts.ORGORDERID and tltxcd in ('8804','8809')
            and sts.duetype in ('RM','RS') AND sts.CLEARDATE = TO_DATE (l_txdate,'DD/MM/YYYY') and tl.tltxcd like v_tltxcd*/
            )
        LOOP
           sp_generate_appmapbravo(REC.TXDATE,REC.TXNUM,a);
           I:=I+1 ;
         IF I=1000 THEN
             COMMIT;
              I:=0;
          END IF ;
         END LOOP;

 IF UPPER(l_tltxcd )='ALL' THEN
sp_generate_gldealpay(l_txdate);

for rec in ( select * from gldealpay where txdate = to_date(l_txdate,'DD/MM/YYYY') )
    loop
        SELECT cf.custid,cf.custodycd ,CF.custatcom,CF.CUSTTYPE,DECODE (CF.country,'234','001','002'),af.corebank,af.bankname,cf.fullname, cf.brid
        INTO v_custid,v_custodycd,v_custatcom,v_custtype,v_country ,v_iscorebank,v_bankname,v_fullname, v_brid
        FROM AFMAST AF, CFMAST CF
        WHERE AF.CUSTID =CF.CUSTID AND AF.ACCTNO = rec.afacctno;
             v_bankid:= (case when  rec.custbank ='0001000001' then 'MBBLD'
                             when  rec.custbank ='0001000012' then 'LVBTL'
                       else ''     END );

    insert into gl_exp_tran( ref, txdate, txnum, busdate, custid, custodycd,
       custodycd_debit, custodycd_credit, bankid, trans_type,
       amount, symbol, symbol_qtty, symbol_price, costprice,
       txbrid, brid, tradeplace, iscorebank, status,
       custatcom, custtype, country, sectype, note,bankname,fullname,acname,dorc,reftran)
    VALUES( seq_gltran.nextval, rec.txdate , rec.autoid,rec.txdate , v_custid, v_custodycd,
       '', '', v_bankid, '995501',
       rec.orgpaidamt  , '', '', 0, 0,
       v_brid, v_brid, '', v_iscorebank, '',
       v_custatcom, v_custtype, v_country, '', 'Goc',v_bankname,v_fullname,'','','');

    insert into gl_exp_tran( ref, txdate, txnum, busdate, custid, custodycd,
       custodycd_debit, custodycd_credit, bankid, trans_type,
       amount, symbol, symbol_qtty, symbol_price, costprice,
       txbrid, brid, tradeplace, iscorebank, status,
       custatcom, custtype, country, sectype, note,bankname,fullname,acname,dorc,reftran)
    VALUES( seq_gltran.nextval, rec.txdate , rec.autoid,rec.txdate , v_custid, v_custodycd,
       '', '', v_bankid, '995502',
       rec.bankintpaidamt  , '', '', 0, 0,
       v_brid, v_brid, '', v_iscorebank, '',
       v_custatcom, v_custtype, v_country, '', 'Lai',v_bankname,v_fullname,'','','');

        end loop ;
    end if ;


IF UPPER(l_tltxcd )='ALL' or l_tltxcd ='9956' THEN


for rec in ( select * from vw_odmast_all where txdate = to_date(l_txdate,'DD/MM/YYYY') )
    loop
        SELECT cf.custid,cf.custodycd ,CF.custatcom,CF.CUSTTYPE,DECODE (CF.country,'234','001','002'),af.corebank,af.bankname,cf.fullname, cf.brid
        INTO v_custid,v_custodycd,v_custatcom,v_custtype,v_country ,v_iscorebank,v_bankname,v_fullname, v_brid
        FROM AFMAST AF, CFMAST CF
        WHERE AF.CUSTID =CF.CUSTID AND AF.ACCTNO = rec.afacctno;

    insert into gl_exp_tran( ref, txdate, txnum, busdate, custid, custodycd,
       custodycd_debit, custodycd_credit, bankid, trans_type,
       amount, symbol, symbol_qtty, symbol_price, costprice,
       txbrid, brid, tradeplace, iscorebank, status,
       custatcom, custtype, country, sectype, note,bankname,fullname,acname,dorc,reftran)
    VALUES( seq_gltran.nextval, rec.txdate , rec.txnum,rec.txdate , v_custid, v_custodycd,
       '', '', '', '995601',
       rec.taxsellamt  , '', '', 0, 0,
       v_brid, v_brid, '', v_iscorebank, '',
       v_custatcom, v_custtype, v_country, '', 'Thue',v_bankname,v_fullname,'','',rec.orderid);

    end loop ;
    end if ;


---PHI  ---T0

IF UPPER(l_tltxcd )='ALL' or l_tltxcd ='9957' THEN


for rec in ( select od.* from vw_odmast_all od ,cfmast cf ,afmast af  where cf.custid= af.custid  and od.afacctno = af.acctno and cf.custatcom='Y'  and   txdate = to_date(l_txdate,'DD/MM/YYYY') and exectype ='NB' and feeacr>0  )
    loop
        SELECT cf.custid,cf.custodycd ,CF.custatcom,CF.CUSTTYPE,DECODE (CF.country,'234','001','002'),af.corebank,af.bankname,cf.fullname, cf.brid
        INTO v_custid,v_custodycd,v_custatcom,v_custtype,v_country ,v_iscorebank,v_bankname,v_fullname, v_brid
        FROM AFMAST AF, CFMAST CF
        WHERE AF.CUSTID =CF.CUSTID AND AF.ACCTNO = rec.afacctno;

    insert into gl_exp_tran( ref, txdate, txnum, busdate, custid, custodycd,
       custodycd_debit, custodycd_credit, bankid, trans_type,
       amount, symbol, symbol_qtty, symbol_price, costprice,
       txbrid, brid, tradeplace, iscorebank, status,
       custatcom, custtype, country, sectype, note,bankname,fullname,acname,dorc,reftran)
    VALUES( seq_gltran.nextval, rec.txdate , rec.txnum,rec.txdate , v_custid, v_custodycd,
       '', '', '', '995701',
       rec.feeacr  , '', '', 0, 0,
       v_brid, v_brid, '', v_iscorebank, '',
       v_custatcom, v_custtype, v_country, '', 'Phi',v_bankname,v_fullname,'','',rec.orderid);

    end loop ;


for rec in (select od.* from vw_odmast_all od ,cfmast cf ,afmast af  where cf.custid= af.custid  and od.afacctno = af.acctno and cf.custatcom='Y' and txdate = to_date(l_txdate,'DD/MM/YYYY') and exectype <>'NB' and feeacr>0 )
    loop
        SELECT cf.custid,cf.custodycd ,CF.custatcom,CF.CUSTTYPE,DECODE (CF.country,'234','001','002'),af.corebank,af.bankname,cf.fullname, cf.brid
        INTO v_custid,v_custodycd,v_custatcom,v_custtype,v_country ,v_iscorebank,v_bankname,v_fullname, v_brid
        FROM AFMAST AF, CFMAST CF
        WHERE AF.CUSTID =CF.CUSTID AND AF.ACCTNO = rec.afacctno;

    insert into gl_exp_tran( ref, txdate, txnum, busdate, custid, custodycd,
       custodycd_debit, custodycd_credit, bankid, trans_type,
       amount, symbol, symbol_qtty, symbol_price, costprice,
       txbrid, brid, tradeplace, iscorebank, status,
       custatcom, custtype, country, sectype, note,bankname,fullname,acname,dorc,reftran)
    VALUES( seq_gltran.nextval, rec.txdate , rec.txnum,rec.txdate , v_custid, v_custodycd,
       '', '', '', '995702',
       rec.feeacr  , '', '', 0, 0,
       v_brid, v_brid, '', v_iscorebank, '',
       v_custatcom, v_custtype, v_country, '', 'Phi ban',v_bankname,v_fullname,'','',rec.orderid);

    end loop ;
    end if ;


---3341

IF UPPER(l_tltxcd )='ALL' or l_tltxcd ='3341' THEN


for rec in ( select * from vw_setran_gen where TXDATE = to_date(l_txdate,'DD/MM/YYYY') AND TLTXCD ='3341' )
    loop
        SELECT cf.custid,cf.custodycd ,CF.custatcom,CF.CUSTTYPE,DECODE (CF.country,'234','001','002'),af.corebank,af.bankname,cf.fullname, cf.brid
        INTO v_custid,v_custodycd,v_custatcom,v_custtype,v_country ,v_iscorebank,v_bankname,v_fullname, v_brid
        FROM AFMAST AF, CFMAST CF
        WHERE AF.CUSTID =CF.CUSTID AND AF.ACCTNO = rec.afacctno;

    insert into gl_exp_tran( ref, txdate, txnum, busdate, custid, custodycd,
       custodycd_debit, custodycd_credit, bankid, trans_type,
       amount, symbol, symbol_qtty, symbol_price, costprice,
       txbrid, brid, tradeplace, iscorebank, status,
       custatcom, custtype, country, sectype, note,bankname,fullname,acname,dorc,reftran)
    VALUES( seq_gltran.nextval, rec.txdate , rec.txnum,rec.BUSDATE , v_custid, v_custodycd,
       '', '', '', '334102',
       0  , REC.SYMBOL, REC.NAMT, 0, 0,
       v_brid, v_brid, '', v_iscorebank, '',
       v_custatcom, v_custtype, v_country, '', 'Phi',v_bankname,v_fullname,'','',rec.REF);

    end loop ;
    end if ;


---1153

IF UPPER(l_tltxcd )='ALL' or l_tltxcd ='1153' THEN


for rec in ( SELECT ads.* FROM adsource ads, adschd ad WHERE ads.autoid= ad.autoid   AND ads.txdate = to_date(l_txdate,'DD/MM/YYYY') )
    loop
        SELECT cf.custid,cf.custodycd ,CF.custatcom,CF.CUSTTYPE,DECODE (CF.country,'234','001','002'),af.corebank,af.bankname,cf.fullname, cf.brid
        INTO v_custid,v_custodycd,v_custatcom,v_custtype,v_country ,v_iscorebank,v_bankname,v_fullname, v_brid
        FROM AFMAST AF, CFMAST CF
        WHERE AF.CUSTID =CF.CUSTID AND AF.ACCTNO = rec.acctno;


       BEGIN
       select shortname into  v_bankid  from cfmast where custid  = rec.custbank;
       EXCEPTION
       WHEN OTHERS THEN
        v_bankid:='MSBS';
       END ;


    insert into gl_exp_tran( ref, txdate, txnum, busdate, custid, custodycd,
       custodycd_debit, custodycd_credit, bankid, trans_type,
       amount, symbol, symbol_qtty, symbol_price, costprice,
       txbrid, brid, tradeplace, iscorebank, status,
       custatcom, custtype, country, sectype, note,bankname,fullname,acname,dorc,reftran)
    VALUES( seq_gltran.nextval, rec.txdate , rec.txnum,rec.txdate , v_custid, v_custodycd,
       '', '', v_bankid, '115301',
       REC.AMT +REC.feeAMT , '',0 , 0, 0,
       v_brid, v_brid, '', v_iscorebank, '',
       v_custatcom, v_custtype, v_country, '', 'Tien ung',v_bankname,v_fullname,'','','');

       insert into gl_exp_tran( ref, txdate, txnum, busdate, custid, custodycd,
       custodycd_debit, custodycd_credit, bankid, trans_type,
       amount, symbol, symbol_qtty, symbol_price, costprice,
       txbrid, brid, tradeplace, iscorebank, status,
       custatcom, custtype, country, sectype, note,bankname,fullname,acname,dorc,reftran)
    VALUES( seq_gltran.nextval, rec.txdate , rec.txnum,rec.txdate , v_custid, v_custodycd,
       '', '', v_bankid, '115302',
      REC.feeAMT  , '', 0, 0, 0,
       v_brid, v_brid, '', v_iscorebank, '',
       v_custatcom, v_custtype, v_country, '', 'Tien phi',v_bankname,v_fullname,'','','');


    end loop ;
end if ;



IF UPPER(l_tltxcd )='ALL' or l_tltxcd ='8851' THEN


for rec in ( SELECT ads.* FROM adsource ads, adschd ad WHERE ads.autoid= ad.autoid   AND ads.cleardt = to_date(l_txdate,'DD/MM/YYYY') )
    loop
        SELECT cf.custid,cf.custodycd ,CF.custatcom,CF.CUSTTYPE,DECODE (CF.country,'234','001','002'),af.corebank,af.bankname,cf.fullname, cf.brid
        INTO v_custid,v_custodycd,v_custatcom,v_custtype,v_country ,v_iscorebank,v_bankname,v_fullname, v_brid
        FROM AFMAST AF, CFMAST CF
        WHERE AF.CUSTID =CF.CUSTID AND AF.ACCTNO = rec.acctno;

       BEGIN
       select shortname into  v_bankid  from cfmast where custid  = rec.custbank;
       EXCEPTION
       WHEN OTHERS THEN
        v_bankid:='MSBS';
       END ;

    insert into gl_exp_tran( ref, txdate, txnum, busdate, custid, custodycd,
       custodycd_debit, custodycd_credit, bankid, trans_type,
       amount, symbol, symbol_qtty, symbol_price, costprice,
       txbrid, brid, tradeplace, iscorebank, status,
       custatcom, custtype, country, sectype, note,bankname,fullname,acname,dorc,reftran)
    VALUES( seq_gltran.nextval, rec.cleardt , rec.autoid,rec.cleardt , v_custid, v_custodycd,
       '', '', v_bankid, '885101',
       REC.AMT +REC.feeAMT , '',0 , 0, 0,
       v_brid, v_brid, '', v_iscorebank, '',
       v_custatcom, v_custtype, v_country, '', 'Tien ung',v_bankname,v_fullname,'','','');


    end loop ;
end if ;

   EXCEPTION
  WHEN OTHERS THEN
  return;

  END ;
/

