-- Start of DDL Script for View HOSTMSTRADE.V_IT_STOCKINFO
-- Generated 11/04/2017 3:44:55 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE VIEW v_it_stockinfo (
   tradeplace,
   symbol,
   currprice,
   ceilingprice,
   floorprice,
   halt )
AS
SELECT      decode(SBSEC.TRADEPLACE,'001','HOSE','002','HASTC',SBSEC.TRADEPLACE) TRADEPLACE, SEC.SYMBOL, SEC.currprice, SEC.CEILINGPRICE, SEC.FLOORPRICE,SBSEC.HALT
FROM        ISSUERS ISS, SECURITIES_INFO SEC, SBSECURITIES SBSEC
WHERE       ISS.ISSUERID = SBSEC.ISSUERID
            AND SBSEC.CODEID = SEC.CODEID
            and SBSEC.SECTYPE in ('001','008','011')
            and SBSEC.TRADEPLACE not in ('003','005')
            --and SBSEC.HALT='N'
            AND (LENGTH(SEC.SYMBOL)=3 or replace(SEC.SYMBOL,'_','--') like '%--%')
Order by SBSEC.TRADEPLACE,SEC.SYMBOL
/


-- End of DDL Script for View HOSTMSTRADE.V_IT_STOCKINFO

