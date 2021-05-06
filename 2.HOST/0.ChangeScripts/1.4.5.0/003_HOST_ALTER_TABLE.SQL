alter table ho_sec_info add 
(
    UnderlyingSymbol    VARCHAR2(50),   /*Ma CK co so*/
    IssuerName          VARCHAR2(50),   /*Ten TCPH CKSC*/
    CoveredWarrantType  VARCHAR2(10),   /*Loai chung quyen*/    
    MaturityDate        DATE,           /*Ngay het han chung quyen*/           
    LastTradingDate     DATE,           /*Ngay giao dich cuoi cung*/
    ExercisePrice       NUMBER(20,4),   /*Gia thuc hien*/
    ExerciseRatio       NUMBER(20,4)    /*Ty le thuc hien*/
);

alter table stockinfor add 
(
    --UnderlyingSymbol    VARCHAR2(50),   /*Ma CK co so*/
    IssuerName          VARCHAR2(50),   /*Ten TCPH CKSC*/
    CoveredWarrantType  VARCHAR2(10),   /*Loai chung quyen*/    
    MaturityDate        DATE,           /*Ngay het han chung quyen*/           
    --LastTradingDate     DATE,           /*Ngay giao dich cuoi cung*/
    ExercisePrice       NUMBER(20,4),   /*Gia thuc hien*/
    ExerciseRatio       NUMBER(20,4),    /*Ty le thuc hien*/
	  listedshare         VARCHAR2(255)
);

DROP VIEW v_mo_am_tien_ck_bk;

ALTER TABLE stockinfor MODIFY lasttradingdate NVARCHAR2(255);
ALTER TABLE stockinfor MODIFY maturitydate NVARCHAR2(255);
ALTER TABLE stockinfor MODIFY exerciseprice NVARCHAR2(255);
ALTER TABLE stockinfor MODIFY exerciseratio NVARCHAR2(255);

ALTER TABLE marketinfor MODIFY tradingdate NVARCHAR2(255);