create or replace force view vw_tllogfld_all as
select "AUTOID","TXNUM","TXDATE","FLDCD","NVALUE","CVALUE","TXDESC" from tllogfld 
union all
select "AUTOID","TXNUM","TXDATE","FLDCD","NVALUE","CVALUE","TXDESC" from tllogfldall;

