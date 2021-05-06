CREATE OR REPLACE FORCE VIEW VW_SPLIT_ORDER_PARAMETERS AS
SELECT '001' TRADEPLACE, 'HSX' EXCHANGENAME,
SUM(CASE WHEN VARNAME='HSX_START_QTTY' THEN TO_NUMBER(VARVALUE) ELSE 0 END) START_QTTY,
SUM(CASE WHEN VARNAME='HSX_MINBREAKSIZE_QTTY' THEN TO_NUMBER(VARVALUE) ELSE 0 END) MIN_QTTY,
SUM(CASE WHEN VARNAME='HSX_MAXBREAKSIZE_QTTY' THEN TO_NUMBER(VARVALUE) ELSE 0 END) MAX_QTTY,
SUM(CASE WHEN VARNAME='HSX_MINBREAKSIZE_CNT' THEN TO_NUMBER(VARVALUE) ELSE 0 END) MIN_CNT,
SUM(CASE WHEN VARNAME='HSX_MAXBREAKSIZE_CNT' THEN TO_NUMBER(VARVALUE) ELSE 0 END) MAX_CNT
FROM SYSVAR
WHERE VARNAME IN ('HSX_MINBREAKSIZE_QTTY','HSX_MAXBREAKSIZE_QTTY','HSX_MINBREAKSIZE_CNT','HSX_MAXBREAKSIZE_CNT','HSX_START_QTTY')
UNION ALL
SELECT '002' TRADEPLACE, 'HNX' EXCHANGENAME,
SUM(CASE WHEN VARNAME='HNX_START_QTTY' THEN TO_NUMBER(VARVALUE) ELSE 0 END) START_QTTY,
SUM(CASE WHEN VARNAME='HNX_MINBREAKSIZE_QTTY' THEN TO_NUMBER(VARVALUE) ELSE 0 END) MIN_QTTY,
SUM(CASE WHEN VARNAME='HNX_MAXBREAKSIZE_QTTY' THEN TO_NUMBER(VARVALUE) ELSE 0 END) MAX_QTTY,
SUM(CASE WHEN VARNAME='HNX_MINBREAKSIZE_CNT' THEN TO_NUMBER(VARVALUE) ELSE 0 END) MIN_CNT,
SUM(CASE WHEN VARNAME='HNX_MAXBREAKSIZE_CNT' THEN TO_NUMBER(VARVALUE) ELSE 0 END) MAX_CNT
FROM SYSVAR
WHERE VARNAME IN ('HNX_MINBREAKSIZE_QTTY','HNX_MAXBREAKSIZE_QTTY','HNX_MINBREAKSIZE_CNT','HNX_MAXBREAKSIZE_CNT','HNX_START_QTTY')
UNION ALL
SELECT '005' TRADEPLACE, 'UPCOM' EXCHANGENAME,
SUM(CASE WHEN VARNAME='UPCOM_START_QTTY' THEN TO_NUMBER(VARVALUE) ELSE 0 END) START_QTTY,
SUM(CASE WHEN VARNAME='UPCOM_MINBREAKSIZE_QTTY' THEN TO_NUMBER(VARVALUE) ELSE 0 END) MIN_QTTY,
SUM(CASE WHEN VARNAME='UPCOM_MAXBREAKSIZE_QTTY' THEN TO_NUMBER(VARVALUE) ELSE 0 END) MAX_QTTY,
SUM(CASE WHEN VARNAME='UPCOM_MINBREAKSIZE_CNT' THEN TO_NUMBER(VARVALUE) ELSE 0 END) MIN_CNT,
SUM(CASE WHEN VARNAME='UPCOM_MAXBREAKSIZE_CNT' THEN TO_NUMBER(VARVALUE) ELSE 0 END) MAX_CNT
FROM SYSVAR
WHERE VARNAME IN ('UPCOM_MINBREAKSIZE_QTTY','UPCOM_MAXBREAKSIZE_QTTY','UPCOM_MINBREAKSIZE_CNT','UPCOM_MAXBREAKSIZE_CNT','UPCOM_START_QTTY');

