create or replace force view vw_dftran_all as
(
select "TXNUM","TXDATE","ACCTNO","TXCD","NAMT","CAMT","REF","DELTD","AUTOID","ACCTREF","TLTXCD","BKDATE" from dftran where nvl(deltd,'N') <> 'Y'
union all 
select "TXNUM","TXDATE","ACCTNO","TXCD","NAMT","CAMT","REF","DELTD","AUTOID","ACCTREF","TLTXCD","BKDATE" from dftrana where nvl(deltd,'N') <> 'Y'
);

