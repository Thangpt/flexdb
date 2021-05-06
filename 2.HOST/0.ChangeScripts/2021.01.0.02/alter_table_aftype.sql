-- Add/modify columns 
alter table AFTYPE add prodtype VARCHAR2(200);

UPDATE aftype
SET prodtype = CASE WHEN typename IN ('SA','SA 8.8','SA Light','SA 8.8') THEN 'SA'
                    WHEN typename IN ('MA','Rổ SBT_MA 10.5%','Rổ SBT_Miễn lãi UT T1_MA 10.5%','MA Light','MA 8.8','Rổ SBT_MA 12%') THEN 'MA'
                    WHEN typename IN ('MA S10','MA S10_GEX') THEN 'S10'
                    WHEN typename IN ('Topup VB','Topup VIP') THEN 'TOP'
                    WHEN typename = 'SS' THEN 'SS'
                    ELSE 'OTH' END;
COMMIT;
