create or replace force view vw_citran_all as
select "TXNUM","TXDATE","ACCTNO","TXCD","NAMT","CAMT","REF","DELTD","ACCTREF","AUTOID","TLTXCD","BKDATE","TRDESC" from citran where deltd <> 'Y'
        union all
        select "TXNUM","TXDATE","ACCTNO","TXCD","NAMT","CAMT","REF","DELTD","ACCTREF","AUTOID","TLTXCD","BKDATE","TRDESC" from citrana  where deltd <> 'Y';

