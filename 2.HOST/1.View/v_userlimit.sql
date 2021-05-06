CREATE OR REPLACE FORCE VIEW V_USERLIMIT AS
(
SELECT TLIDUSER,IDCODE,USERNAME,FULLNAME,ALLOCATELIMMIT,USEDLIMMIT,T0,T0MAX, (ALLOCATELIMMIT-USEDLIMMIT) REMAINISSUE,
BRID, ACCTLIMIT,  USERTYPE, T0USED,T0REMAIN, STATUS, a2.cdcontent blockstatus, valdate, expdate
FROM
(
    SELECT a1.cdcontent status, TLID TLIDUSER,TL.idcode idcode,BRID BRID, TL.TLNAME USERNAME ,TO_CHAR(TL.TLFULLNAME)  FULLNAME,NVL(T0,0) T0,NVL(T0MAX,0) T0MAX,NVL(ALLOCATELIMMIT,0) ALLOCATELIMMIT,
        NVL(USEDLIMMIT,0) USEDLIMMIT, ACCTLIMIT, 'Flex' USERTYPE, NVL(T0.T0USED,0) T0USED, NVL(T0,0) - NVL(T0.T0USED,0) T0REMAIN, CASE WHEN u.status = 'B' THEN 'Y' ELSE 'N' END blockstatus,
        to_date(u.valdate,'dd/mm/rrrr') valdate, to_date(u.expdate,'dd/mm/rrrr') expdate
    FROM userlimit u ,TLPROFILES TL, allcode a1,
        (Select sum(ACCLIMIT) T0USED ,TLIDUSER from useraflimit where TYPERECEIVE ='T0' Group by TLIDUSER) T0
    WHERE u.TLIDUSER(+) = TLID and T0.TLIDUSER(+) =TLID AND tl.signstatus = a1.cdval AND a1.cdname = 'YESNO' AND a1.cdtype = 'SY'
) u, allcode a2
WHERE u.blockstatus = a2.cdval AND a2.cdname = 'YESNO' AND a2.cdtype = 'SY'
)
----------------------
;

