create or replace force view vw_crbtrflog_all as
select "AUTOID","VERSION","VERSIONLOCAL","TXDATE","CREATETST","SENDTST","REFBANK","TRFCODE","STATUS","PSTATUS","ERRCODE","FEEDBACK","ERRSTS","REFVERSION","NOTES","TLID","OFFID","APPRV_STS","DONESTS","AFFECTDATE" from crbtrflog
union
select "AUTOID","VERSION","VERSIONLOCAL","TXDATE","CREATETST","SENDTST","REFBANK","TRFCODE","STATUS","PSTATUS","ERRCODE","FEEDBACK","ERRSTS","REFVERSION","NOTES","TLID","OFFID","APPRV_STS","DONESTS","AFFECTDATE" from crbtrfloghist;

