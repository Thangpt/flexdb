CREATE INDEX rlsrptlog_eod_rlsdate ON rlsrptlog_eod(rlsdate);
CREATE INDEX rlsrptlog_eod_afacctno ON rlsrptlog_eod(afacctno);
CREATE INDEX rlsrptlog_eod_lnschdid ON rlsrptlog_eod(lnschdid);

CREATE INDEX adschd_acctno ON adschd(acctno);
CREATE INDEX adschd_txdate ON adschd(txdate);
CREATE INDEX adschd_CLEARDT ON adschd(CLEARDT);

CREATE INDEX lninttran_acctno ON lninttran(acctno);
CREATE INDEX lninttran_frdate ON lninttran(frdate);
CREATE INDEX lninttran_lnschdid ON lninttran(lnschdid);

CREATE INDEX log_pr0004_acctno_codeid ON log_pr0004(afacctno,codeid);

CREATE INDEX lntran_acctno ON lntran(acctno);
CREATE INDEX lntran_txnum_date ON lntran(txdate,txnum);
CREATE INDEX lntrana_acctno ON lntrana(acctno);
CREATE INDEX lntrana_txnum_date ON lntrana(txdate,txnum);

CREATE INDEX MR9004_FOR_LOG_TEMP_afacctno ON MR9004_FOR_LOG_TEMP(afacctno);
