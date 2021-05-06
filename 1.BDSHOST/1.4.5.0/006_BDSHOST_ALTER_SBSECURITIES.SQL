alter table sbsecurities add 
(
    UnderlyingType      VARCHAR2(10),   /*Loai CKCS*/
    UnderlyingSymbol    VARCHAR2(50),   /*Ma CKCS*/
    IssuerName          VARCHAR2(1000),   /*Ten TCPH CKCS*/
    CoveredWarrantType  VARCHAR2(10),   /*Loai chung quyen*/    
    SettlementType      VARCHAR2(10),   /*Phuong thuc thanh toan*/
    --SettlementPrice     NUMBER(20,2),   /*Giá thanh toan*/
    CWTerm              NUMBER,         /*Thoi han cua chung quyen*/
    MaturityDate        DATE,           /*Ngay het han chung quyen*/           
    LastTradingDate     DATE,           /*Ngay giao dich cuoi cung*/
    ExercisePrice       NUMBER(20,4),   /*Gia thuc hien*/
    ExerciseRatio       NUMBER(20,4),   /*Ty le thuc hien*/
    Nvalue              NUMBER(20,2)    /*He so nhan*/
);
