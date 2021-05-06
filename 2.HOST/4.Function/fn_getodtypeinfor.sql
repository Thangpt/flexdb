-- Start of DDL Script for Function HOSTMSTRADE.FN_GETODTYPEINFOR
-- Generated 11/04/2017 11:08:03 AM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE 
FUNCTION fn_getodtypeinfor(pv_ACCTNO varchar2, pv_EXECTYPE varchar2,pv_MatchType varchar2,pv_via varchar2, pv_PriceType varchar2, pv_Codeid varchar2,pv_TYPE number)
RETURN varchar2 IS
    v_Result  varchar2(20);
    l_feerate number;
    l_sectype varchar2(10);
    l_tradeplace varchar2(10);
    l_actype varchar2(10);
    l_bratio number;
    l_clearday  number;
    l_odtype varchar2(4);
    l_deffeerate number;

BEGIN

    select sectype, tradeplace into l_sectype,l_tradeplace from sbsecurities where codeid = pv_Codeid;
    select actype into l_actype from afmast where acctno = pv_ACCTNO;
     SELECT actype, bratio+deffeerate bratio, clearday, deffeerate
        into l_odtype, l_bratio, l_clearday, l_deffeerate
                  FROM (SELECT a.actype, a.clearday, a.bratio, a.minfeeamt, a.deffeerate, b.ODRNUM
                  FROM odtype a, afidtype b
                  WHERE     a.status = 'Y'
                        AND (a.via = pv_via OR a.via = 'A') --VIA
                        AND a.clearcd = 'B'       --CLEARCD
                        AND (a.exectype = pv_Exectype
                             OR a.exectype = 'AA')                    --EXECTYPE
                        AND (a.timetype = 'T'
                             OR a.timetype = 'A')                     --TIMETYPE
                        AND (a.pricetype = pv_PriceType
                             OR a.pricetype = 'AA')                  --PRICETYPE
                        AND (a.matchtype = pv_MatchType
                             OR a.matchtype = 'A')                   --MATCHTYPE
                        AND (a.tradeplace = l_TradePlace
                             OR a.tradeplace = '000')
                        AND (instr(case when l_secType in ('001','002','011') then l_secType || ',' || '111,333'
                                       when l_secType in ('003','006') then l_secType || ',' || '222,333,444'
                                       when l_secType in ('008') then l_secType || ',' || '111,444'
                                       else l_secType end, a.sectype)>0 OR a.sectype = '000')
                        AND (a.nork = 'N' OR a.nork = 'A') --NORK
                        AND (CASE WHEN A.CODEID IS NULL THEN pv_Codeid ELSE A.CODEID END)=pv_Codeid
                        AND a.actype = b.actype and b.aftype=l_actype and b.objname='OD.ODTYPE'
                        order by
                        CASE WHEN (SELECT VARVALUE FROM SYSVAR WHERE GRNAME = 'SYSTEM' AND VARNAME = 'ORDER_ORD') = 'ODRNUM' THEN ODRNUM ELSE DEFFEERATE END ASC
                        --b.odrnum desc
                        ) where rownum<=1;


    -- l_AMTPAID, l_INTPAID, l_FEEPAID, l_INTPENA, l_FEEPENA
    if pv_TYPE  =0 then
        v_Result:= l_odtype;
    elsif pv_TYPE = 1 then
         v_Result:= to_char(l_bratio);
    elsif pv_TYPE = 2 then
         v_Result:= to_char(l_clearday);
    else
         v_Result:= to_char(l_deffeerate);
    end if;
    return v_Result;
EXCEPTION when others then
    return '';
END;
/



-- End of DDL Script for Function HOSTMSTRADE.FN_GETODTYPEINFOR

