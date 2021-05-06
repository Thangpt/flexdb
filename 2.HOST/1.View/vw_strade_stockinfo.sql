-- Start of DDL Script for View HOSTMSTRADE.VW_STRADE_STOCKINFO
-- Generated 11/04/2017 3:45:09 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE VIEW vw_strade_stockinfo (
   codeid,
   fullname,
   symbol,
   tradelot,
   tradeunit,
   openprice,
   ceilingprice,
   floorprice,
   basicprice,
   currprice,
   marginprice,
   halt,
   tradeplace )
AS
SELECT      SEC.CODEID, ISS.FULLNAME, SEC.SYMBOL,SEC.TRADELOT,SEC.TRADEUNIT, SEC.OPENPRICE, SEC.CEILINGPRICE, SEC.FLOORPRICE,SEC.BASICPRICE,SEC.CURRPRICE,SEC.MARGINPRICE,
             SBSEC.HALT, SBSEC.TRADEPLACE
FROM        ISSUERS ISS, SECURITIES_INFO SEC, SBSECURITIES SBSEC
WHERE       ISS.ISSUERID = SBSEC.ISSUERID
            AND SBSEC.CODEID = SEC.CODEID
            and SBSEC.SECTYPE in ('001','008','011')
/


-- End of DDL Script for View HOSTMSTRADE.VW_STRADE_STOCKINFO

