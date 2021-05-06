CREATE OR REPLACE PROCEDURE pr_smsbeginday
 is
     p_template_id  varchar2(20);
     v_currdate date;
     v_prevdate date;
     v_msg varchar2(2700);
     d number;
     l_datasource varchar2(3000);
     v_mobile varchar2(50);
     v_pp0 number(20);
     v_typename varchar2(20);

  BEGIN
     p_template_id:='0329';
    IF to_char(sysdate,'hh24miss') >'080000' or to_char(sysdate,'hh24miss') <'072500' then
        dbms_output.put_line('Het gio ');
        plog.error( 'pr_smsbeginday::Het gio::'  || to_char(sysdate,'hh24miss'));
        return;
    End if;
    plog.error( 'pr_smsbeginday::'  || to_char(sysdate,'hh24miss'));
    Select to_date(varvalue,'dd/mm/yyyy') into v_currdate
    From sysvar
    Where varname='CURRDATE' and grname='SYSTEM';

    If  v_currdate <> trunc(sysdate) then
       dbms_output.put_line('Khong phai ngay giao dich');
       plog.error( 'pr_smsbeginday::Khong phai ngay giao dich');
       return;
    End if;

    d:=0;
    Select count(1) into d
    From emaillog
    Where templateid='0329';

    If d>0 then
         dbms_output.put_line('Da thuc hien');
         plog.error( 'pr_smsbeginday::Da thuc hien');
        Return;
    End if;

    Select to_date(varvalue,'dd/mm/yyyy') into v_prevdate
    From sysvar
    Where varname='PREVDATE' and grname='SYSTEM';

    For vc in
    (
/*        Select s2.afacctno,s2.custodycd--,s2.balance
        From
           (select afacctno,txdate,custodycd, balance
            from smsbeginday
            where txdate=v_prevdate
            group by  afacctno,txdate,custodycd, balance ) s1,
            (select afacctno,txdate,custodycd, balance
            from smsbeginday
            where txdate=v_currdate --AND BALANCE>100000
            group by  afacctno,txdate,custodycd, balance ) s2
        Where  s2.afacctno=s1.afacctno(+)
           and abs(s2.balance - nvl(s1.balance,-999))>=500000
        Union*/
        Select s2.afacctno,s2.custodycd,s2.typename--,s2.balance
        From
           (select s.afacctno,s.acctno,s.txdate, s.symbol,s.trade, s.custodycd, s.balance,f.typename
            from smsbeginday s,afmast af,aftype f
            where s.txdate=v_prevdate
            and s.afacctno=af.acctno and af.actype=f.actype
            and s.acctno is not null
            ) s1,
            (select s.afacctno,s.acctno,s.txdate, s.symbol,s.trade, s.custodycd, s.balance,f.typename
            from smsbeginday s,afmast af,aftype f
            where txdate=v_currdate
            and s.afacctno=af.acctno and af.actype=f.actype
            and s.acctno is not null  AND TRADE>0
             ) s2
        Where  s2.acctno=s1.acctno(+)
           and s2.trade <> nvl(s1.trade,-999)
        Union
        Select afacctno, custodycd,typename--,0 balance
        From
           (select s.afacctno,s.acctno, s.symbol,s.trade, s.CUSTODYCD,f.typename
            from smsbeginday s,afmast af,aftype f
            where txdate=v_prevdate
            and s.afacctno=af.acctno and af.actype=f.actype
            and s.acctno is not null AND TRADE>0
            MINUS
            select s.afacctno,s.acctno,s.symbol,s.trade, s.CUSTODYCD,f.typename
            from smsbeginday s,afmast af,aftype f
            where txdate=v_currdate
            and s.afacctno=af.acctno and af.actype=f.actype
            and s.acctno is not null
             )

    )
    Loop
           v_mobile:='';

           For rec in(select af.fax1,b.pp,aft.typename from afmast af, buf_ci_account b,aftype aft where af.acctno=b.afacctno and acctno=vc.afacctno and b.AFACCTNO =af.acctno and af.actype =aft.actype)
           Loop
                v_mobile:=rec.fax1;
                v_pp0:=rec.pp;
                v_typename:=rec.typename;

           End loop;
          -- If v_pp0>1000000 then
              If v_pp0<0 then
                v_pp0:=0;
              end if;
                   v_msg:='KBSV '||to_char(v_currdate,'dd/mm/yyyy')||' TB So du TK '
                       ||vc.custodycd||vc.typename||'. Suc mua CB: '

                           ||ltrim(replace(to_char(v_pp0,
                                                        '9,999,999,999,999'),
                                                ',',
                                                '.'))||'d.';
                          -- Chung khoan: SHB 4000, PPC 2000';
                   d:=0;
                   For rec in(SELECT symbol,trade
                              from vw_mr9004_for_log
                              where  afacctno=vc.afacctno and trade>0
                               )
                   Loop
                      IF d=0 then
                           v_msg:=v_msg || ' CK: '||rec.symbol||' '||ltrim(replace(to_char(rec.trade,
                                                        '9,999,999,999,999'),
                                                ',',
                                                '.'));
                      else
                          if length(v_msg)>1 then
                            v_msg:=v_msg || ', '||rec.symbol||' '||ltrim(replace(to_char(rec.trade,
                                                        '9,999,999,999,999'),
                                                ',',
                                                '.'));
                          else
                            v_msg:=rec.symbol||' '||ltrim(replace(to_char(rec.trade,
                                                        '9,999,999,999,999'),
                                                ',',
                                                '.'));
                          end if;
                      end if;
                      d:=d+1;
/*                      IF length(V_MSG) >210 then
                        l_datasource:='SELECT '''||V_MSG||''' detail from dual';
                   --dbms_output.put_line(v_msg);
                        nmpks_ems.InsertEmailLog(v_mobile,
                               p_template_id,
                               l_datasource,
                               vc.afacctno);
                        V_MSG:='';
                        --d:=0;
                      End if;*/
                   End loop;
/*                   iF D>0 AND LENGTH(V_MSG)>1 THEN
                   v_msg:=v_msg||'.';
                   END IF;*/

                   l_datasource:='SELECT '''||V_MSG||''' detail from dual';
                   --dbms_output.put_line(v_msg);
                   nmpks_ems.InsertEmailLog(v_mobile,
                               p_template_id,
                               l_datasource,
                               vc.afacctno);
          -- End if;
    End loop;
  commit;
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('pr_smsbeginday::loi thuc hien');
END;



-- End of DDL Script for Procedure HOST.PR_SMSBEGINDAY
/
