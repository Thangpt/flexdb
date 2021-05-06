CREATE OR REPLACE PROCEDURE pr_view_mr9000(
   PV_REFCURSOR             IN OUT   PKG_REPORT.REF_CURSOR,
   p_GET_TOTAL_ROW              in out number,
   p_FROM_ROW               in number,
   p_TO_ROW                 in number,
   p_PARA_STRING            IN       VARCHAR2
   )
as
l_count number;
l_item varchar2(1000);
l_condition varchar2(500);
l_value varchar2(500);
l_PARA_STRING varchar2(4000);

--general para
l_gBranchId varchar2(10);
l_gHO_BranchId varchar2(10);
l_gBusdate varchar2(10);
l_gAfAcctno varchar2(10);
l_gCustID varchar2(10);
l_gKeyValue varchar2(100);
l_gTellerID varchar2(10);

--Adhoc para
l_CustodyCD varchar2(20);
l_AfAcctno varchar2(20);
l_ExMarginAmt number;
l_ExT0Amt number;
l_TrfBuyDT varchar2(20);
begin
l_gBranchId:='%%';
l_gHO_BranchId:='%%';
l_gBusdate:='%%';
l_gAfAcctno:='%%';
l_gCustID:='%%';
l_gKeyValue:='%%';
l_gTellerID:='%%';

l_CustodyCD:='%%';
l_AfAcctno:='%%';
l_ExMarginAmt:=null;
l_ExT0Amt:=null;
l_TrfBuyDT:='01/01/1999';
/*
p_PARA_STRING
*/
/*    insert into buf_AvlAdvance
    select * from v_getAccountAvlAdvance;*/

    l_PARA_STRING:='||'||p_PARA_STRING||'||';
    plog.error('pr_view_mr9000 _l_count:'||l_PARA_STRING);
    begin
        select length(l_PARA_STRING) - length(replace(l_PARA_STRING,'||','')) into l_count from dual;
    exception when others then
        l_count:=0;
    end;
    for i in 1..nvl(l_count,0) loop
        begin
            if i=1 then
                l_item:=substr( l_PARA_STRING,0,instr( l_PARA_STRING,'||')-2);
            else
                l_item :=  substr( l_PARA_STRING,instr( l_PARA_STRING,'||',1,i-1)+2,instr( l_PARA_STRING,'||',1,i)-instr( l_PARA_STRING,'||',1,i-1)-2 ) ;
            end  if;
            l_condition:=substr( l_item,0,instr( l_item,':')-1);
            l_value:=replace( l_item,l_condition||':','');

            --mv_strSearchFilterStore &= "||" & "<$BRID>" & ":" & Me.BranchId
            if l_condition = '<$BRID>' then
                l_gBranchId:=l_value;
            end if;
            --mv_strSearchFilterStore &= "||" & "<$HO_BRID>" & ":" & HO_BRID
            if l_condition = '<$HO_BRID>' then
                l_gHO_BranchId:=l_value;
            end if;
            --mv_strSearchFilterStore &= "||" & "<$BUSDATE>" & ":" & Me.BusDate
            if l_condition = '<$BUSDATE>' then
                l_gBusdate:=l_value;
            end if;
            --mv_strSearchFilterStore &= "||" & "<$AFACCTNO>" & ":" & Me.AFACCTNO
            if l_condition = '<$AFACCTNO>' then
                l_gAfAcctno:=l_value;
            end if;
            --mv_strSearchFilterStore &= "||" & "<$CUSTID>" & ":" & Me.CUSTID
            if l_condition = '<$CUSTID>' then
                l_gCustID:=l_value;
            end if;
            --mv_strSearchFilterStore &= "||" & "<@KEYVALUE>" & ":" & LinkValue
            if l_condition = '<@KEYVALUE>' then
                l_gKeyValue:=l_value;
            end if;
            --mv_strSearchFilterStore &= "||" & "<$TELLERID>" & ":" & Me.TellerId
            if l_condition = '<$TELLERID>' then
                l_gTellerID:=l_value;
            end if;

            -- Adhoc Paras
            if l_condition = 'CUSTODYCD' then
                l_CustodyCD:='%'||upper(l_value)||'%';
            end if;
            if l_condition = 'AFACCTNO' then
                l_AfAcctno:='%'||upper(l_value)||'%';
            end if;
            if l_condition = 'TRFBUYDT' then
                l_TrfBuyDT:=l_value;
            end if;
            if l_condition = 'EXMARGINAMT' then
                l_ExMarginAmt:=l_value;
            end if;
            if l_condition = 'EXT0AMT' then
                l_ExT0Amt:=l_value;
            end if;
        exception when others then
            null;
        end;
    end loop;
    plog.error('pr_view_mr9000 l_gTellerID:'||l_gTellerID);
    plog.error('pr_view_mr9000 l_CustodyCD:'||l_CustodyCD);
    plog.error('pr_view_mr9000 l_AfAcctno:'||l_AfAcctno);
    plog.error('pr_view_mr9000 p_FROM_ROW:'||p_FROM_ROW);
    plog.error('pr_view_mr9000 p_TO_ROW:'||p_TO_ROW);

    if p_GET_TOTAL_ROW = 1 then
        OPEN PV_REFCURSOR
        FOR
        select count(1) COUNTROW
        from vw_mr9000 v, (select * from tlgroups where GRPTYPE = '2') t
        where v.careby = t.grpid(+)
            and exists (SELECT 1 FROM TLGRPUSERS TLGRP WHERE TLGRP.GRPID = v.CAREBY and TLID = l_gTellerID)
            and custodycd like l_CustodyCD and afacctno like l_AfAcctno
            and exmarginamt > to_number(nvl(l_ExMarginAmt,exmarginamt-1)) and ext0amt > to_number(nvl(l_ExT0Amt,ext0amt-1))
            and case when l_TrfBuyDT = '01/01/1999' then 0 else trfbuydt - to_date(l_TrfBuyDT,'DD/MM/RRRR') end = 0;
    else        
      if p_TO_ROW = 900000000 then
            OPEN PV_REFCURSOR
            FOR
            select v.*, t.grpname
            from vw_mr9000 v, (select * from tlgroups where GRPTYPE = '2') t
            where v.careby = t.grpid(+)
                 and exists (SELECT 1 FROM TLGRPUSERS TLGRP WHERE TLGRP.GRPID = v.CAREBY and TLID = l_gTellerID)
                 and custodycd like l_CustodyCD and afacctno like l_AfAcctno
                 and exmarginamt > to_number(nvl(l_ExMarginAmt,exmarginamt-1)) and ext0amt > to_number(nvl(l_ExT0Amt,ext0amt-1))
                 and case when l_TrfBuyDT = '01/01/1999' then 0 else trfbuydt - to_date(l_TrfBuyDT,'DD/MM/RRRR') end = 0;
        else
            OPEN PV_REFCURSOR
            FOR
            select * from (
                select t.*, rownum rn from (
                    select v.*, t.grpname
                    from vw_mr9000 v, (select * from tlgroups where GRPTYPE = '2') t
                    where v.careby = t.grpid(+)
                        and exists (SELECT 1 FROM TLGRPUSERS TLGRP WHERE TLGRP.GRPID = v.CAREBY and TLID = l_gTellerID)
                        and custodycd like l_CustodyCD and afacctno like l_AfAcctno
                        and exmarginamt > to_number(nvl(l_ExMarginAmt,exmarginamt-1)) and ext0amt > to_number(nvl(l_ExT0Amt,ext0amt-1))
                        and case when l_TrfBuyDT = '01/01/1999' then 0 else trfbuydt - to_date(l_TrfBuyDT,'DD/MM/RRRR') end = 0
                ) t
            ) where rn between p_FROM_ROW and p_TO_ROW;
        end if;
    end if;
    commit;
exception when others then
    plog.error('pr_view_mr9000:'||dbms_utility.format_error_backtrace);
    null;
end;
/

