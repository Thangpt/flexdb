

ALTER TABLE RegisterProduc ADD sbType VARCHAR2(10) DEFAULT 'N';
ALTER TABLE registerproduct_temp ADD sbType VARCHAR2(10) DEFAULT 'N';
UPDATE RegisterProduc SET produccode = 'MAS10' WHERE produccode = 'T10';
COMMIT;
