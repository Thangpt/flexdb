create or replace force view vw_afpralloc_all as
select "AUTOID","AFACCTNO","PRINUSED","CODEID","ALLOCTYP","ORGORDERID","TXDATE","TXNUM","RESTYPE" from afpralloc
union all
select "AUTOID","AFACCTNO","PRINUSED","CODEID","ALLOCTYP","ORGORDERID","TXDATE","TXNUM","RESTYPE" from afprallocation;

