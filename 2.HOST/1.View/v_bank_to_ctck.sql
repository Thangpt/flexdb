CREATE OR REPLACE VIEW V_BANK_TO_CTCK AS
(
-------Lay theo tieu khoan-----
---------- Giao dich Cho xu ly
Select requestid ,'B2C' Direction , case when trim(BO.DESCRIPTION) like 'QSDDN_%' then 'GWMSBQSDDN'
                                         when trim(BO.DESCRIPTION) like 'QSDTN_%' then 'GWMSBQSDTN'
                                         else 'GWMSB' end Tran_type , bo.txnum,bo.txdate ,To_char(bo.last_change,'hh24:mi:ss') TXTIME,
CF.Custodycd TK_ChungKhoan ,cf.fullname Ten_nguoi_nhan,  bo.msgamt So_Tien,  bo.status Ma_TrangThai,'Co loi' Trang_Thai,
0 errnum ,'' errdesc, bo.description, bo.createddt CREATE_DATE
From  borqslog BO , cfmast cf ,afmast af
where rqstyp in ('CRA','CRI') AND rqssrc ='MSB'
and bo.msgacct = af.acctno
and af.custid = cf.custid
and BO.status='P'
Union all
---------- Giao dich thanh cong
Select requestid , 'B2C' Direction , case when trim(BO.DESCRIPTION) like 'QSDDN_%' then 'GWMSBQSDDN'
                                         when trim(BO.DESCRIPTION) like 'QSDTN_%' then 'GWMSBQSDTN'
                                         else 'GWMSB' end Tran_type , bo.txnum,bo.txdate ,To_char(bo.last_change,'hh24:mi:ss') TXTIME,
CF.Custodycd TK_ChungKhoan ,cf.fullname Ten_nguoi_nhan,  bo.msgamt So_Tien,  bo.status Ma_TrangThai,A1.CDCONTENT Trang_Thai,
0 errnum ,'' errdesc, bo.description, bo.createddt CREATE_DATE
From  borqslog BO , cfmast CF ,  allcode A1, afmast af
where rqstyp in ('CRA','CRI') AND rqssrc ='MSB'
and bo.msgacct = af.acctno
and af.custid = cf.custid
and trim(BO.status) =trim(A1.cdval)
and A1.cdtype ='GW'
and BO.status='C'
and A1.cdname ='TRANSSTATUS'

UNION ALL
---------- Giao dich khong thanh cong
Select requestid , 'B2C' Direction , case when trim(BO.DESCRIPTION) like 'QSDDN_%' then 'GWMSBQSDDN'
                                         when trim(BO.DESCRIPTION) like 'QSDTN_%' then 'GWMSBQSDTN'
                                         else 'GWMSB' end Tran_type , bo.txnum,bo.txdate ,To_char(bo.last_change,'hh24:mi:ss') TXTIME,
CF.Custodycd TK_ChungKhoan ,cf.fullname Ten_nguoi_nhan,  bo.msgamt So_Tien,  bo.status Ma_TrangThai,'Co loi' Trang_Thai,
gw.errnum ,df.errdesc, bo.description, bo.createddt CREATE_DATE
From  borqslog BO , cfmast CF , afmast af, (Select * from gw_updatetrans union all  Select * from gw_updatetrans_hist) gw , (Select * from deferror where  modcode='RM') df
where bo.rqstyp in ('CRA','CRI') AND bo.rqssrc ='MSB'
and bo.msgacct = af.acctno
and af.custid = cf.custid
and BO.status='E'
and bo.requestid = gw.refid
and gw.direction='C2B'
and gw.errnum =df.errnum(+)

UNION ALL
-----------Lay theo so luu ky----------------
---------- Giao dich Cho xu ly
Select requestid ,'B2C' Direction , case when trim(BO.DESCRIPTION) like 'QSDDN_%' then 'GWMSBQSDDN'
                                         when trim(BO.DESCRIPTION) like 'QSDTN_%' then 'GWMSBQSDTN'
                                         else 'GWMSB' end Tran_type , bo.txnum,bo.txdate ,To_char(bo.last_change,'hh24:mi:ss') TXTIME,
CF.Custodycd TK_ChungKhoan ,cf.fullname Ten_nguoi_nhan,  bo.msgamt So_Tien,  bo.status Ma_TrangThai,'Co loi' Trang_Thai,
0 errnum ,'' errdesc, bo.description, bo.createddt CREATE_DATE
From  borqslog BO , cfmast cf
where rqstyp in ('CRA','CRI') AND rqssrc ='MSB'
and upper(bo.msgacct) = cf.custodycd
--and af.custid = cf.custid
and BO.status='P'
Union all
---------- Giao dich thanh cong
Select requestid , 'B2C' Direction , case when trim(BO.DESCRIPTION) like 'QSDDN_%' then 'GWMSBQSDDN'
                                         when trim(BO.DESCRIPTION) like 'QSDTN_%' then 'GWMSBQSDTN'
                                         else 'GWMSB' end Tran_type , bo.txnum,bo.txdate ,To_char(bo.last_change,'hh24:mi:ss') TXTIME,
CF.Custodycd TK_ChungKhoan ,cf.fullname Ten_nguoi_nhan,  bo.msgamt So_Tien,  bo.status Ma_TrangThai,A1.CDCONTENT Trang_Thai,
0 errnum ,'' errdesc, bo.description, bo.createddt CREATE_DATE
From  borqslog BO , cfmast CF ,  allcode A1
where rqstyp in ('CRA','CRI') AND rqssrc ='MSB'
and upper(bo.msgacct) = cf.custodycd
--and af.custid = cf.custid
and trim(BO.status) =trim(A1.cdval)
and A1.cdtype ='GW'
and BO.status='C'
and A1.cdname ='TRANSSTATUS'

UNION ALL
---------- Giao dich khong thanh cong
Select requestid , 'B2C' Direction , case when trim(BO.DESCRIPTION) like 'QSDDN_%' then 'GWMSBQSDDN'
                                         when trim(BO.DESCRIPTION) like 'QSDTN_%' then 'GWMSBQSDTN'
                                         else 'GWMSB' end Tran_type , bo.txnum,bo.txdate ,To_char(bo.last_change,'hh24:mi:ss') TXTIME,
CF.Custodycd TK_ChungKhoan ,cf.fullname Ten_nguoi_nhan,  bo.msgamt So_Tien,  bo.status Ma_TrangThai,'Co loi' Trang_Thai,
gw.errnum ,df.errdesc, bo.description, bo.createddt CREATE_DATE
From  borqslog BO , cfmast CF, (Select * from gw_updatetrans union all  Select * from gw_updatetrans_hist) gw , (Select * from deferror where  modcode='RM') df
where bo.rqstyp in ('CRA','CRI') AND bo.rqssrc ='MSB'
and upper(bo.msgacct) = cf.custodycd
--and af.custid = cf.custid
and BO.status='E'
and bo.requestid = gw.refid
and gw.direction='C2B'
and gw.errnum =df.errnum(+)

UNION ALL  -- Giao dich thu ho BIDV
Select To_char(rq.trnRef) requestid, 'B2C' Direction, 'GWBIDV' Tran_type,
    To_char(rq.transactionnumber) txnum, rq.txdate,
    To_char(rq.createdt,'hh24:mi:ss') TXTIME,
    rq.keyacct1 TK_ChungKhoan, rq.keyacct2 Ten_nguoi_nhan,
    rq.amount So_Tien, rq.Status Ma_TrangThai, A1.cdcontent Trang_Thai,
    0 errnum , RQ.errordesc errdesc, rq.transactiondescription description, trunc(rq.createdt) CREATE_DATE
From (SELECT * FROM  tcdtreceiverequest
      UNION ALL
      SELECT * FROM  tcdtreceiverequest_HIST) rq,
     ALLCODE A1
where rq.STATUS =A1.CDVAL AND A1.CDTYPE = 'RM' AND A1.CDNAME = 'CRBRQDSTS'
And rq.Status IN ('N', 'C', 'E', 'H')

union all

select tranid requestid, 'B2C' Direction, 'GWVPBANK' Tran_type,
rq.txnum, rq.txdate, To_char(rq.createdt,'hh24:mi:ss') TXTIME,
rq.custodycd TK_ChungKhoan, rq.afacctno Ten_nguoi_nhan,
rq.amount So_Tien, rq.status Ma_TrangThai, case when rq.status = 'C' then 'Thanh Cong' else 'Loi' end Trang_Thai,
to_number(rq.errorcode) errnum, rq.errordesc errdesc, trandesc description, to_date(rq.trandate,'dd/mm/yyyy') CREATE_DATE
from (SELECT * FROM  tcdtreceiverequestext
      UNION ALL
      SELECT * FROM  tcdtreceiverequestexthist) rq

union all

select rq.refnum requestid, 'B2C' Direction, 'GWVPBANK LNH' Tran_type,
rq.txnum, rq.txdate, To_char(rq.create_time,'hh24:mi:ss') TXTIME,
rq.description TK_ChungKhoan, rq.bankacct Ten_nguoi_nhan,
rq.amount So_Tien, rq.status Ma_TrangThai, case when rq.status = 'C' then 'Thanh Cong' else 'Loi' end Trang_Thai,
to_number(rq.errcode) errnum, rq.errmsg errdesc, rq.description, rq.trandate CREATE_DATE
from putfluctuationlog rq
)
;
