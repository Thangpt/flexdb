CREATE OR REPLACE VIEW V_CTCK_TO_BANK AS
(
Select 'C2B'Direction ,'Manual' Tran_type, ci.txnum,ci.txdate ,To_char(ci.last_change,'hh24:mi:ss') TXTIME ,CF.Custodycd TK_ChungKhoan , ci.acctno Tieu_Khoan ,cf.fullname Ten_nguoi_chuyen,
ci.benefacct TK_Nhan , Ci.benefcustname Ten_Nguoi_Nhan , CI.amt So_Tien ,
CI.rmstatus Ma_TrangThai,A1.CDCONTENT Trang_Thai,ci.deltd GD_DaXoa,ci.bankid Ma_NH_ThuHuong ,ci.benefbank Ten_NH_ThuHuong, trunc(ci.last_change) CREATE_DATE
from ciremittance CI , AFMAST af , CFMAST CF , ALLCODE A1
where CI.acctno = af.acctno
and af.custid= cf.custID
AND CI.rmstatus =A1.cdval
and A1.cdtype ='GW'
and A1.cdname ='TRANSSTATUS'
and (ci.txnum || ci.txdate) not in (Select txnum || Txdate from gw_putbatchtrans Union ALL Select txnum || Txdate from gw_putbatchtrans_hist)
and (ci.txnum || ci.txdate) not in (Select txnum || Txdate from TCDTBANKREQUEST Union ALL Select txnum || Txdate from TCDTBANKREQUEST_hist)
and (ci.txnum || ci.txdate) not in (Select txnum || Txdate from newbankgw_log Union ALL Select txnum || Txdate from newbankgw_log_hist)
Union all
------ Da duoc boc di qua GW va  giao dich cho xu ly
Select 'C2B'Direction , case when trim(gw.remark) like 'QSDCN_%' then 'GWMSBQSDCN' else 'GWMSB' end Tran_type, ci.txnum,ci.txdate ,To_char(ci.last_change,'hh24:mi:ss') TXTIME ,CF.Custodycd TK_ChungKhoan , ci.acctno Tieu_Khoan ,cf.fullname Ten_nguoi_chuyen,
ci.benefacct TK_Nhan , Ci.benefcustname Ten_Nguoi_Nhan , CI.amt So_Tien ,
CI.rmstatus Ma_TrangThai,A1.CDCONTENT Trang_Thai,ci.deltd GD_DaXoa,ci.bankid Ma_NH_ThuHuong ,ci.benefbank Ten_NH_ThuHuong, trunc(ci.last_change) CREATE_DATE
from ciremittance CI , AFMAST af , CFMAST CF , (Select * from gw_putbatchtrans union Select * from gw_putbatchtrans_hist) gw , allcode A1
where CI.acctno = af.acctno
and af.custid= cf.custID
and CI.txnum = gw.txnum
and ci.txdate = gw.txdate
and gw.status ='S'
and gw.status =A1.cdval
and A1.cdtype ='GW'
and A1.cdname ='TRANSSTATUS'

union all
------ Da duoc boc di qua GW va  giao dich da thanh cong
Select 'C2B'Direction , case when trim(gw.remark) like 'QSDCN_%' then 'GWMSBQSDCN' else 'GWMSB' end Tran_type, ci.txnum,ci.txdate ,To_char(ci.last_change,'hh24:mi:ss') TXTIME ,CF.Custodycd TK_ChungKhoan , ci.acctno Tieu_Khoan ,cf.fullname Ten_nguoi_chuyen,
ci.benefacct TK_Nhan , Ci.benefcustname Ten_Nguoi_Nhan , CI.amt So_Tien ,
CI.rmstatus Ma_TrangThai,A1.CDCONTENT Trang_Thai,ci.deltd GD_DaXoa,ci.bankid Ma_NH_ThuHuong ,ci.benefbank Ten_NH_ThuHuong, trunc(ci.last_change) CREATE_DATE
from ciremittance CI , AFMAST af , CFMAST CF , (Select * from gw_putbatchtrans union Select * from gw_putbatchtrans_hist) gw , allcode A1
where CI.acctno = af.acctno
and af.custid= cf.custID
and CI.txnum = gw.txnum
and ci.txdate = gw.txdate
and gw.status ='C'
and gw.status =A1.cdval
and A1.cdtype ='GW'
and A1.cdname ='TRANSSTATUS'

union all
------ Da duoc boc di qua GW va  giao dich khong thanh cong
Select 'C2B'Direction , case when trim(gw.remark) like 'QSDCN_%' then 'GWMSBQSDCN' else 'GWMSB' end Tran_type, ci.txnum,ci.txdate ,To_char(ci.last_change,'hh24:mi:ss') TXTIME ,CF.Custodycd TK_ChungKhoan , ci.acctno Tieu_Khoan ,cf.fullname Ten_nguoi_chuyen,
ci.benefacct TK_Nhan , Ci.benefcustname Ten_Nguoi_Nhan , CI.amt So_Tien ,
CI.rmstatus Ma_TrangThai,A1.CDCONTENT Trang_Thai,ci.deltd GD_DaXoa,ci.bankid Ma_NH_ThuHuong ,ci.benefbank Ten_NH_ThuHuong, trunc(ci.last_change) CREATE_DATE
from ciremittance CI , AFMAST af , CFMAST CF , (Select * from gw_putbatchtrans union Select * from gw_putbatchtrans_hist) gw , allcode A1
where CI.acctno = af.acctno
and af.custid= cf.custID
and CI.txnum = gw.txnum
and ci.txdate = gw.txdate
and gw.status ='E'
and gw.status =A1.cdval
and A1.cdtype ='GW'
and A1.cdname ='TRANSSTATUS'
UNION ALL
------ Da duoc boc di len GW nhung mat ket noi chua cap nhat trang thai j
Select 'C2B'Direction , case when trim(gw.remark) like 'QSDCN_%' then 'GWMSBQSDCN' else 'GWMSB' end Tran_type, ci.txnum,ci.txdate ,To_char(ci.last_change,'hh24:mi:ss') TXTIME ,CF.Custodycd TK_ChungKhoan , ci.acctno Tieu_Khoan ,cf.fullname Ten_nguoi_chuyen,
ci.benefacct TK_Nhan , Ci.benefcustname Ten_Nguoi_Nhan , CI.amt So_Tien ,
CI.rmstatus Ma_TrangThai,A1.CDCONTENT Trang_Thai,ci.deltd GD_DaXoa,ci.bankid Ma_NH_ThuHuong ,ci.benefbank Ten_NH_ThuHuong, trunc(ci.last_change) CREATE_DATE
from ciremittance CI , AFMAST af , CFMAST CF , (Select * from gw_putbatchtrans union Select * from gw_putbatchtrans_hist) gw , allcode A1
where CI.acctno = af.acctno
and af.custid= cf.custID
and CI.txnum = gw.txnum
and ci.txdate = gw.txdate
and gw.status ='P'
and gw.status =A1.cdval
and A1.cdtype ='GW'
and A1.cdname ='TRANSSTATUS'

UNION ALL -- Lay giao dich chi ho BIDV
Select 'C2B'Direction ,'GWBIDV' Tran_type, ci.txnum,ci.txdate ,To_char(ci.last_change,'hh24:mi:ss') TXTIME ,CF.Custodycd TK_ChungKhoan , ci.acctno Tieu_Khoan ,cf.fullname Ten_nguoi_chuyen,
ci.benefacct TK_Nhan , Ci.benefcustname Ten_Nguoi_Nhan , CI.amt So_Tien ,
TB.status Ma_TrangThai,
case
 when TB.status='C' then A1.CDCONTENT
Else A1.CDCONTENT||'-'||tb.errordesc
end Trang_Thai,
ci.deltd GD_DaXoa,ci.bankid Ma_NH_ThuHuong ,ci.benefbank Ten_NH_ThuHuong, trunc(ci.last_change) CREATE_DATE
from ciremittance CI , AFMAST af , CFMAST CF , ALLCODE A1,
(SELECT * FROM TCDTBANKREQUEST
 UNION ALL
 SELECT *FROM TCDTBANKREQUEST_HIST)TB
where CI.acctno = af.acctno
AND af.custid= cf.custID
AND TB.status =A1.cdval
and tb.acctno=af.acctno
AND A1.CDTYPE = 'RM'
AND A1.CDNAME = 'CRBSTATUS'
AND CI.txdate = TB.txdate
AND CI.txnum = TB.txnum
--and ci.rmstatus='W'

UNION ALL -- Lay giao dich chi ho VPBANK
Select 'C2B'Direction ,'GWVPBANK' Tran_type, ci.txnum,ci.txdate ,To_char(ci.last_change,'hh24:mi:ss') TXTIME ,CF.Custodycd TK_ChungKhoan , ci.acctno Tieu_Khoan ,cf.fullname Ten_nguoi_chuyen,
ci.benefacct TK_Nhan , Ci.benefcustname Ten_Nguoi_Nhan , CI.amt So_Tien ,
TB.status Ma_TrangThai,
case
 when TB.status='C' then A1.CDCONTENT
Else A1.CDCONTENT||'-'||tb.errmsg
end Trang_Thai,
ci.deltd GD_DaXoa,ci.bankid Ma_NH_ThuHuong ,ci.benefbank Ten_NH_ThuHuong, nvl(to_date(tb.banktime,'yyyy-mm-dd'),trunc(tb.createdt)) CREATE_DATE
from ciremittance CI , AFMAST af , CFMAST CF , ALLCODE A1,
(SELECT * FROM newbankgw_log
 UNION ALL
 SELECT *FROM newbankgw_log_hist) TB
where CI.acctno = af.acctno
AND af.custid= cf.custID
AND TB.status =A1.cdval
--and tb.acctno=af.acctno
AND A1.CDTYPE = 'RM'
AND A1.CDNAME = 'CRBSTATUS'
AND CI.txdate = TB.txdate
AND CI.txnum = TB.txnum
--and ci.rmstatus='W'
)
;

