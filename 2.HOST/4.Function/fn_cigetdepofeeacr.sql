-- Start of DDL Script for Function HOSTMSTRADE.FN_CIGETDEPOFEEACR
-- Generated 11/04/2017 11:04:44 AM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE 
FUNCTION fn_cigetdepofeeacr(strACCTNO IN varchar2, strCODEID IN varchar2, strBUSDATE IN varchar2, strTXDATE IN varchar2, dblQTTY IN NUMBER)
  RETURN  number
  IS
  v_strTRADEPLACE  varchar2(10);
  v_strSECTYPEEXT  varchar2(10);
  v_strSECTYPE    varchar2(10);
  v_strFORP      varchar2(10);
  v_strROUNDTYP    varchar2(10);
  v_dtmLASTACRDT  DATE;
  v_dblFEEAMT    number(20,4);
  v_dblLOTDAY    number(20,0);
  v_dblLOTVAL    number(20,0);
  v_dblFEERATIO    number(20,6);  --h? s? fee
  v_dblNUMOFDAYS  number(20,0);
  v_Result      number(20);
  V_CODEID_NEW  varchar2(10);
BEGIN
V_CODEID_NEW:=strCODEID;
  --L?y tham s? c?a ch?ng kho?
  SELECT TRADEPLACE, SECTYPE INTO v_strTRADEPLACE, v_strSECTYPE FROM SBSECURITIES WHERE CODEID=V_CODEID_NEW;
  IF v_strSECTYPE='001' OR v_strSECTYPE='002' OR v_strSECTYPE='007' OR v_strSECTYPE='008' OR v_strSECTYPE='011' THEN
    v_strSECTYPEEXT := '111'; --Co phieu va chung chi quy
  ELSIF v_strSECTYPE='003' OR v_strSECTYPE='006' THEN
    v_strSECTYPEEXT := '222'; --Trai phieu
  ELSE
    v_strSECTYPEEXT := v_strSECTYPE;
  END IF;
  --X?d?nh s? ng?t? ph??ng d?n:
  --N?u strBUSDATE<=v_dtmLASTACRDT th?? t? v_dtmLASTACRDT
  --N?u strBUSDATE>v_dtmLASTACRDT th?? t? strBUSDATE
  SELECT nvl(DEPOLASTDT,TO_DATE(strBUSDATE,'DD/MM/RRRR')-1) into v_dtmLASTACRDT FROM CIMAST WHERE AFACCTNO=strACCTNO;

  SELECT (TO_DATE(strBUSDATE,'DD/MM/RRRR')-v_dtmLASTACRDT)  INTO v_dblNUMOFDAYS FROM DUAL;
  IF v_dblNUMOFDAYS>0 THEN
    SELECT (TO_DATE(strTXDATE,'DD/MM/RRRR')-TO_DATE(strBUSDATE,'DD/MM/RRRR')) INTO v_dblNUMOFDAYS FROM DUAL;
  ELSE
    SELECT (TO_DATE(strTXDATE,'DD/MM/RRRR')-v_dtmLASTACRDT) -1 INTO v_dblNUMOFDAYS FROM DUAL;
  END IF;
  IF v_dblNUMOFDAYS<=0 THEN
    RETURN 0;
  END IF;

  --L?y bi?u ph?K c?a ch?ng kho?
  --Uu ti?ph??t ri? cho ch?ng kho?
  --N?u kh?c?d?t ri? theo ch?ng kho?s? x?d?n c?d?t ri? cho TRADEPLACE
  SELECT FORP, FEEAMT, LOTDAY, LOTVAL, ROUNDTYP INTO v_strFORP, v_dblFEEAMT, v_dblLOTDAY, v_dblLOTVAL, v_strROUNDTYP
  FROM (SELECT * FROM (SELECT RF.AUTOID, RF.FORP, RF.FEEAMT, RF.LOTDAY, RF.LOTVAL, RF.ROUNDTYP, 0 ODRNUM
  FROM CIMAST MST, CITYPE TYP, CIFEEDEF RF, AFMAST AF
  WHERE TYP.ACTYPE=MST.ACTYPE AND TYP.ACTYPE=RF.ACTYPE AND RF.FEETYPE='VSDDEP' AND MST.AFACCTNO=strACCTNO
  AND rf.status='A'
  AND RF.CODEID=strCODEID
  AND MST.ACCTNO=AF.ACCTNO
  AND AF.STATUS IN ('A','P')
  UNION ALL
  SELECT RF.AUTOID, RF.FORP, RF.FEEAMT, RF.LOTDAY, RF.LOTVAL, RF.ROUNDTYP, 1 ODRNUM
  FROM CIMAST MST, CITYPE TYP, CIFEEDEF RF,AFMAST AF
  WHERE TYP.ACTYPE=MST.ACTYPE AND TYP.ACTYPE=RF.ACTYPE AND RF.FEETYPE='VSDDEP' AND MST.AFACCTNO=strACCTNO
  AND rf.status='A'
  AND RF.CODEID IS NULL AND (RF.SECTYPE=v_strSECTYPE or RF.SECTYPE=v_strSECTYPEEXT) AND RF.TRADEPLACE=v_strTRADEPLACE
  AND MST.ACCTNO=AF.ACCTNO
  AND AF.STATUS IN ('A','P')
  UNION ALL
  SELECT RF.AUTOID, RF.FORP, RF.FEEAMT, RF.LOTDAY, RF.LOTVAL, RF.ROUNDTYP, 2 ODRNUM
  FROM CIMAST MST, CITYPE TYP, CIFEEDEF RF,AFMAST AF
  WHERE TYP.ACTYPE=MST.ACTYPE AND TYP.ACTYPE=RF.ACTYPE AND RF.FEETYPE='VSDDEP' AND MST.AFACCTNO=strACCTNO
  AND rf.status='A'
  AND MST.ACCTNO=AF.ACCTNO
  AND AF.STATUS IN ('A','P')
  AND RF.CODEID IS NULL AND (RF.SECTYPE=v_strSECTYPE or RF.SECTYPE=v_strSECTYPEEXT) AND RF.TRADEPLACE='999') ORDER BY ODRNUM) RFFEE
  WHERE ROWNUM=1;

  IF v_strFORP='P' THEN
    v_dblFEEAMT := v_dblFEEAMT/100;
  END IF;

    v_Result :=ROUND( v_dblFEEAMT*dblQTTY*v_dblNUMOFDAYS/(v_dblLOTDAY*v_dblLOTVAL),4);
    RETURN v_result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/



-- End of DDL Script for Function HOSTMSTRADE.FN_CIGETDEPOFEEACR

