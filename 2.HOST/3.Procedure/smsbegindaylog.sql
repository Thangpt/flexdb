CREATE OR REPLACE PROCEDURE smsbegindaylog(id in varchar2 ) is
     v_currdate date;
     v_prevdate date;
     v_msg varchar2(1000);
     d number;
     l_datasource varchar2(3000);
     v_mobile varchar2(50);
BEGIN
    Select to_date(varvalue,'dd/mm/yyyy') into v_currdate
    From sysvar
    Where varname='CURRDATE' and grname='SYSTEM';
    Select to_date(varvalue,'dd/mm/yyyy') into v_prevdate
    From sysvar
    Where varname='PREVDATE' and grname='SYSTEM';
    DELETE smsbeginday WHERE TXDATE=v_currdate;
    INSERT INTO smsbeginday(AUTOID,TXDATE,afacctno, custodycd,  balance, acctno, symbol,
       codeid, trade)
    SELECT SEQ_smsbeginday.NEXTVAL AUTOID,
         V_currdate TXDATE,
         AF.ACCTNO AFACCTNO ,
        CF.CUSTODYCD,
        CI.BALANCE,
        NVL(T1.ACCTNO,'') ACCTNO,
        NVL(T1.SYMBOL,'') SYMBOL ,NVL(T1.CODEID,'') CODEID,NVL(T1.TRADE,0) TRADE
    FROM CFMAST CF, AFMAST AF,CIMAST CI,
        (SELECT * FROM vw_mr9004_for_log ) T1
        WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = CI.AFACCTNO
       AND AF.ACCTNO = T1.AFACCTNO (+) ;
    COMMIT;
    For vc in
    (
        Select s2.afacctno,s2.custodycd,s2.balance
        From
           (select afacctno,txdate,custodycd, balance
            from smsbeginday
            where txdate=v_prevdate
            group by  afacctno,txdate,custodycd, balance ) s1,
            (select afacctno,txdate,custodycd, balance
            from smsbeginday
            where txdate=v_currdate
            group by  afacctno,txdate,custodycd, balance ) s2
        Where  s2.afacctno=s1.afacctno(+)
           and s2.balance <> nvl(s1.balance,-999)
        Union all
        Select s2.afacctno,s2.custodycd,s2.balance
        From
           (select afacctno,acctno,txdate, symbol,trade, custodycd, balance
            from smsbeginday
            where txdate=v_prevdate and acctno is not null
            ) s1,
            (select afacctno,acctno,txdate, symbol,trade, custodycd, balance
            from smsbeginday
            where txdate=v_currdate and acctno is not null
             ) s2
        Where  s2.acctno=s1.acctno(+)
           and s2.trade <> nvl(s1.trade,-999)
    )
    Loop
           v_mobile:='';
           For rec in(select fax1 from afmast where acctno=vc.afacctno)
           Loop
                v_mobile:=rec.fax1;
           End loop;
           v_msg:='KBSV '||to_char(v_currdate,'dd/mm/yyyy')||'. Tbao So du TK '
                   ||vc.custodycd||' tieu khoan '||vc.afacctno||'. Tien co the GD:'
                   ||to_char(vc.balance)||'VND.';
                  -- Chung khoan: SHB 4000, PPC 2000';
           d:=0;
           For rec in(SELECT symbol,trade
                      from vw_mr9004_for_log
                      where  afacctno=vc.afacctno and trade>0
                       )
           Loop
              IF d=0 then
                   v_msg:=v_msg || ' Chung khoan: '||rec.symbol||' '||rec.trade;
              else
                   v_msg:=v_msg || ', '||rec.symbol||' '||rec.trade;
              end if;
              d:=d+1;
           End loop;
           l_datasource:='SELECT '''||V_MSG||''' detail from dual';
           --dbms_output.put_line(v_msg);
           nmpks_ems.InsertEmailLog(v_mobile,
                       '329A',
                       l_datasource,
                       v_mobile);
    End loop;

END; -- Procedure
/

