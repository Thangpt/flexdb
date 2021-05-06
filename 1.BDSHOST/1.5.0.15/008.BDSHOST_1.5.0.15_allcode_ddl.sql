
DELETE allcode WHERE cdtype = 'OD' AND cdname = 'VIA' AND cdval = 'L';
INSERT INTO allcode (cdtype, cdname, cdval, cdcontent, lstodr, cduser, en_cdcontent)
VALUES ('OD', 'VIA', 'L', 'Bloomberg', 1, 'Y', 'Bloomberg');
COMMIT;
/
