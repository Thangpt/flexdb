create or replace force view vw_email_otrightdtl as
select authcustid , CollectionToString(cast(collect(a.cdcontent) as collection),'</li><li>')||'</li><li>Và nhi?u tính nang khác.' rights
                        from  (select otmncode,authcustid from  otrightdtl where  instr(otright,'Y')>0 and deltd = 'N' group by otmncode,authcustid  )otr,
                             (select cdcontent, cdval, lstodr
                                 from allcode
                                where cdname = 'OTFUNC' and cdval not in ('SMARTALERT','MARKETALERT','COMPANYALERT')
                                order by lstodr ) a
                       where a.cdval = otr.otmncode
                         group by authcustid;

