

ALTER TABLE bl_odmast ADD priceChkType  VARCHAR2(1);
ALTER TABLE bl_odmast ADD orgforefid  VARCHAR2(50);
ALTER TABLE bl_odmast ADD ctlid  VARCHAR2(100);
ALTER TABLE bl_odmast ADD TargetStrategy  VARCHAR2(10);
ALTER TABLE bl_odmast ADD hasPlan  VARCHAR2(1);
create index IDX_bl_odmast_hftOrderId on bl_odmast (hftOrderId);
ALTER TABLE fix_message_temp ADD Text VARCHAR2(2000);
ALTER TABLE fix_message_temp ADD TargetStrategy VARCHAR2(10);
