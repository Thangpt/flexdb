create or replace force view vw_lntran_all as
select "AUTOID","TXNUM","TXDATE","ACCTNO","TXCD","NAMT","CAMT","REF","DELTD","ACCTREF","TLTXCD","BKDATE" from lntran where deltd <> 'Y'
        union all
        select "AUTOID","TXNUM","TXDATE","ACCTNO","TXCD","NAMT","CAMT","REF","DELTD","ACCTREF","TLTXCD","BKDATE" from lntrana  where deltd <> 'Y';

