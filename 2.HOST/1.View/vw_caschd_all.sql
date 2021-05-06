create or replace force view vw_caschd_all as
select "AUTOID","CAMASTID","BALANCE","QTTY","AMT","AQTTY","AAMT","STATUS","AFACCTNO","CODEID","EXCODEID","DELTD","PSTATUS","REFCAMASTID","RETAILSHARE","DEPOSIT","REQTTY","REAQTTY","RETAILBAL","PBALANCE","PQTTY","PAAMT","COREBANK","ISCISE","DFQTTY","ISCI","ISSE","ISRO","TQTTY","TRADE","INBALANCE","OUTBALANCE", "PITRATEMETHOD"
    from caschd
    union all
     select "AUTOID","CAMASTID","BALANCE","QTTY","AMT","AQTTY","AAMT","STATUS","AFACCTNO","CODEID","EXCODEID","DELTD","PSTATUS","REFCAMASTID","RETAILSHARE","DEPOSIT","REQTTY","REAQTTY","RETAILBAL","PBALANCE","PQTTY","PAAMT","COREBANK","ISCISE","DFQTTY","ISCI","ISSE","ISRO","TQTTY","TRADE","INBALANCE","OUTBALANCE","PITRATEMETHOD"
    from caschdhist;
