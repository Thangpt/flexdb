UPDATE sbbatchctl SET rowperpage = 10000 WHERE bchmdl IN ('ODRCVS_EOD','ODRCVS_TP','ODTRFS','ODTRFM','ODTRFMS','ODPAIDBF','ODRCVM','ODPAIDSF','CFSELLVAT','CICRINTPRN');
COMMIT;
