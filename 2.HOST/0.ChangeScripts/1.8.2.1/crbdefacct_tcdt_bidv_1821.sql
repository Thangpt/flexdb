
CREATE TABLE crbdefacct_tcdt_bidv_1821 AS 
SELECT * FROM crbdefacct WHERE trfcode='TCDT' AND refbank IN ('BIDVHCM','BIDVHN');

BEGIN
  
UPDATE crbdefacct
SET refacctno='12210000709095'
WHERE trfcode='TCDT' AND refbank IN ('BIDVHCM','BIDVHN');

COMMIT;
END;
