create or replace force view vw_gltran_all as
(
    select "ACCTNO","TXDATE","TXNUM","BKDATE","CCYCD","DORC","SUBTXNO","AMT","DELTD","AUTOID","TLTXCD" from gltran where nvl(deltd, 'N') <> 'Y'
    union all
    select "ACCTNO","TXDATE","TXNUM","BKDATE","CCYCD","DORC","SUBTXNO","AMT","DELTD","AUTOID","TLTXCD" from gltrana where nvl(deltd, 'N') <> 'Y'
);

