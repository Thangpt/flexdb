UPDATE allcode SET cduser = 'Y' WHERE CDTYPE='SA' AND TRIM(CDNAME)='PRICETYPE' AND cdval = 'PLO';
COMMIT; 
UPDATE allcode SET cduser = 'Y' WHERE CDTYPE='OD' AND TRIM(CDNAME)='PRICETYPE' AND cdval = 'PLO';
COMMIT; 
