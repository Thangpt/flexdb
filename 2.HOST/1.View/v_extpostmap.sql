create or replace force view v_extpostmap as
select      tltxcd, ibt, dorc, fldtype, brid,
            case when fldtype = 'V' then (select acctno from glref where acname = ext.acname and glgrp = '0000')
            else (select acctno from glrefcom where acname = ext.acname) end acctno,
            acname, amtexp,
            acfld,
            (select caption from fldmaster where objname = ext.tltxcd and fldname = ext.acfld) acflddesc,
            subtxno, reffld, negativecd, isrun, txcd
from        extpostmap ext
order by    tltxcd, subtxno, dorc desc;

