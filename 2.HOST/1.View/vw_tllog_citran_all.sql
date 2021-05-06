create or replace force view vw_tllog_citran_all as
select tl."AUTOID",tl."TXNUM",tr."TXDATE",tl."TXTIME",tl."BRID",tl."TLID",tl."OFFID",tl."OVRRQS",tl."CHID",tl."CHKID",tl."TLTXCD",tl."IBT",tl."BRID2",tl."TLID2",tl."CCYUSAGE",tl."OFF_LINE",tl."DELTD",tl."BRDATE",tl."BUSDATE",tl."TXDESC",tl."IPADDRESS",tl."WSNAME",tl."TXSTATUS",tl."MSGSTS",tl."OVRSTS",tl."BATCHNAME",tl."MSGAMT",tl."MSGACCT",tl."CHKTIME",tl."OFFTIME",tl."CAREBYGRP", tr.acctno, tr.txcd, tr.namt, tr.camt, tr.ref, tr.acctref, tr.autoid tran_autoid
from vw_tllog_all tl, vw_citran_all tr
where tl.txdate = tr.txdate and tl.txnum = tr.txnum;

