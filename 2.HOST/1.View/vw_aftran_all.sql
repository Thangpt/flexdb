create or replace force view vw_aftran_all as
select "TXNUM","TXDATE","ACCTNO","TXCD","NAMT","CAMT","REF","DELTD","AUTOID","ACCTREF","TLTXCD","BKDATE" from aftran where deltd <> 'Y'
union all
select "TXNUM","TXDATE","ACCTNO","TXCD","NAMT","CAMT","REF","DELTD","AUTOID","ACCTREF","TLTXCD","BKDATE" from aftrana where deltd <> 'Y';

