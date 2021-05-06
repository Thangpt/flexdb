CREATE OR REPLACE PACKAGE txpks_check
IS
   TYPE cimastcheck_rectype IS RECORD (
      actype           cimast.actype%TYPE,
      acctno           cimast.acctno%TYPE,
      ccycd            cimast.ccycd%TYPE,
      afacctno         cimast.afacctno%TYPE,
      custid           cimast.custid%TYPE,
      opndate          cimast.opndate%TYPE,
      clsdate          cimast.clsdate%TYPE,
      lastdate         cimast.lastdate%TYPE,
      dormdate         cimast.dormdate%TYPE,
      status           cimast.status%TYPE,
      pstatus          cimast.pstatus%TYPE,
      advanceline       number(20,0),
      balance          cimast.balance%TYPE,
      avlbal           number(38,4),
      cramt            cimast.cramt%TYPE,
      dramt            cimast.dramt%TYPE,
      crintacr         cimast.crintacr%TYPE,
      cidepofeeacr         cimast.cidepofeeacr%TYPE,
      crintdt          cimast.crintdt%TYPE,
      odintacr         cimast.odintacr%TYPE,
      odintdt          cimast.odintdt%TYPE,
      avrbal           cimast.avrbal%TYPE,
      mdebit           cimast.mdebit%TYPE,
      mcredit          cimast.mcredit%TYPE,
      aamt             cimast.aamt%TYPE,
      ramt             cimast.ramt%TYPE,
      bamt             cimast.bamt%TYPE,
      emkamt           cimast.emkamt%TYPE,
      mmarginbal       cimast.mmarginbal%TYPE,
      marginbal        cimast.marginbal%TYPE,
      iccfcd           cimast.iccfcd%TYPE,
      iccftied         cimast.iccftied%TYPE,
      odlimit          cimast.odlimit%TYPE,
      adintacr         cimast.adintacr%TYPE,
      adintdt          cimast.adintdt%TYPE,
      facrtrade        cimast.facrtrade%TYPE,
      facrdepository   cimast.facrdepository%TYPE,
      facrmisc         cimast.facrmisc%TYPE,
      minbal           cimast.minbal%TYPE,
      odamt            cimast.odamt%TYPE,
      dueamt            cimast.dueamt%TYPE,
      ovamt            cimast.ovamt%TYPE,
      namt             cimast.namt%TYPE,
      floatamt         cimast.floatamt%TYPE,
      holdbalance      cimast.holdbalance%TYPE,
      pendinghold      cimast.pendinghold%TYPE,
      pendingunhold    cimast.pendingunhold%TYPE,
      corebank         cimast.corebank%TYPE,
      receiving        cimast.receiving%TYPE,
      netting          cimast.netting%TYPE,
      mblock           cimast.mblock%TYPE,
      mrtype           varchar2(1),
      pp               NUMBER (38, 4),
      ppref               NUMBER (38, 4),
      avllimit         NUMBER (38, 4),
      avllimitt2         NUMBER (38, 4),
      avlmrlimit         NUMBER (38, 4),
      deallimit         NUMBER (20, 4),
      navaccount       NUMBER (20, 4),
      outstanding      NUMBER (20, 4),
      navaccountt2       NUMBER (20, 4),
      outstandingt2      NUMBER (20, 4),
      mrirate          NUMBER (20, 4),
      avlwithdraw      NUMBER (20, 4),
      baldefovd        NUMBER (20, 4),
      baldeftrfamt      number(20,4),
      baldeftrfamtex      number(20,4),
      baldefovd_released NUMBER (20, 4),
      dfdebtamt        NUMBER (20, 4),
      dfintdebtamt     NUMBER (20, 4),
      baldefovd_released_depofee NUMBER (20, 4),
      avladvance        number(38,4),
      advanceamount     number(38,4),
      paidamt           number(38,4),
      EXECBUYAMT        number(38,4),
      dealpaidamt       number(38,4),
      SEASS             number(38,4),
      MARGINRATE        number(38,4),
      trfbuyamt         cimast.trfbuyamt%TYPE,
      --PhuongHT edit 29.02.2016
      trfbuyamt_over NUMBER (20, 4),
      set0amt NUMBER (20, 4),
      rlsmarginrate_ex NUMBER (20, 4),
      NYOVDAMT NUMBER (20, 4),
      marginrate_Ex NUMBER (20, 4),
      semaxtotalcallass NUMBER (20, 4),
      secallass NUMBER (20, 4),
      CLAMT NUMBER (20, 4),
      navaccountt2_EX NUMBER (20, 4),
      outstanding_EX NUMBER (20, 4),
      navaccount_ex NUMBER (20, 4),
      MARGINRATE5 NUMBER (20, 4),
      outstanding5 NUMBER (20, 4),
      ODAMT_EX NUMBER (20, 4),
      outstandingT2_EX NUMBER (20, 4),
      semaxcallass NUMBER (20, 4),
      secureamt_inday NUMBER (20, 4),
      trfsecuredamt_inday NUMBER (20, 4)
      -- end of PhuongHT edit ngay 29.02.2016
   );

   TYPE cimastcheck_arrtype IS TABLE OF cimastcheck_rectype
      INDEX BY PLS_INTEGER;

   FUNCTION fn_cimastcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN cimastcheck_arrtype;

   TYPE GetPP_rectype IS RECORD (
       acctno           cimast.acctno%TYPE,
        pp               NUMBER (38, 4),
        ppref            NUMBER (38, 4),
        avllimit         NUMBER (38, 4),
        avlwithdraw      NUMBER (38, 4)
    );
    TYPE GetPP_arrtype IS TABLE OF GetPP_rectype
      INDEX BY PLS_INTEGER;

   FUNCTION fn_getpp (
      pv_condvalue   IN   VARCHAR2
      )
      RETURN GetPP_arrtype;

   TYPE semastcheck_rectype IS RECORD (
      actype          semast.actype%TYPE,
      acctno          semast.acctno%TYPE,
      codeid          semast.codeid%TYPE,
      afacctno        semast.afacctno%TYPE,
      opndate         semast.opndate%TYPE,
      clsdate         semast.clsdate%TYPE,
      lastdate        semast.lastdate%TYPE,
      status          semast.status%TYPE,
      pstatus         semast.pstatus%TYPE,
      irtied          semast.irtied%TYPE,
      ircd            semast.ircd%TYPE,
      costprice       semast.costprice%TYPE,
      trade           semast.trade%TYPE,
      mortage         semast.mortage%TYPE,
      dfmortage       semast.mortage%TYPE,
      margin          semast.margin%TYPE,
      netting         semast.netting%TYPE,
      standing        semast.standing%TYPE,
      withdraw        semast.withdraw%TYPE,
      deposit         semast.deposit%TYPE,
      loan            semast.loan%TYPE,
      blocked         semast.blocked%TYPE,
      receiving       semast.receiving%TYPE,
      transfer        semast.transfer%TYPE,
      prevqtty        semast.prevqtty%TYPE,
      dcrqtty         semast.dcrqtty%TYPE,
      dcramt          semast.dcramt%TYPE,
      depofeeacr      semast.depofeeacr%TYPE,
      repo            semast.repo%TYPE,
      pending         semast.pending%TYPE,
      tbaldepo        semast.tbaldepo%TYPE,
      custid          semast.custid%TYPE,
      costdt          semast.costdt%TYPE,
      secured         semast.secured%TYPE,
      iccfcd          semast.iccfcd%TYPE,
      iccftied        semast.iccftied%TYPE,
      tbaldt          semast.tbaldt%TYPE,
      senddeposit     semast.senddeposit%TYPE,
      sendpending     semast.sendpending%TYPE,
      ddroutqtty      semast.ddroutqtty%TYPE,
      ddroutamt       semast.ddroutamt%TYPE,
      dtoclose        semast.dtoclose%TYPE,
      sdtoclose       semast.sdtoclose%TYPE,
      qtty_transfer   semast.qtty_transfer%TYPE,
      trading         semast.trade%type
   );

   TYPE semastcheck_arrtype IS TABLE OF semastcheck_rectype
      INDEX BY PLS_INTEGER;

   TYPE afmastcheck_rectype IS RECORD (
      actype            afmast.actype%TYPE,
      custid            afmast.custid%TYPE,
      acctno            afmast.acctno%TYPE,
      aftype            afmast.aftype%TYPE,
      tradefloor        afmast.tradefloor%TYPE,
      tradetelephone    afmast.tradetelephone%TYPE,
      tradeonline       afmast.tradeonline%TYPE,
      pin               afmast.pin%TYPE,
      LANGUAGE          afmast.LANGUAGE%TYPE,
      tradephone        afmast.tradephone%TYPE,
      allowdebit        afmast.allowdebit%TYPE,
      bankacctno        afmast.bankacctno%TYPE,
      bankname          afmast.bankname%TYPE,
      swiftcode         afmast.swiftcode%TYPE,
      receivevia        afmast.receivevia%TYPE,
      email             afmast.email%TYPE,
      address           afmast.address%TYPE,
      fax               afmast.fax%TYPE,
      ciacctno          afmast.ciacctno%TYPE,
      ifrulecd          afmast.ifrulecd%TYPE,
      lastdate          afmast.lastdate%TYPE,
      status            afmast.status%TYPE,
      pstatus           afmast.pstatus%TYPE,
      marginline        afmast.marginline%TYPE,
      tradeline         afmast.tradeline%TYPE,
      advanceline       afmast.advanceline%TYPE,
      repoline          afmast.repoline%TYPE,
      depositline       afmast.depositline%TYPE,
      bratio            afmast.bratio%TYPE,
      termofuse         afmast.termofuse%TYPE,
      description       afmast.description%TYPE,
      iccfcd            afmast.iccfcd%TYPE,
      iccftied          afmast.iccftied%TYPE,
      telelimit         afmast.telelimit%TYPE,
      onlinelimit       afmast.onlinelimit%TYPE,
      cftelelimit       afmast.cftelelimit%TYPE,
      cfonlinelimit     afmast.cfonlinelimit%TYPE,
      traderate         afmast.traderate%TYPE,
      deporate          afmast.deporate%TYPE,
      miscrate          afmast.miscrate%TYPE,
      fax1              afmast.fax1%TYPE,
      phone1            afmast.phone1%TYPE,
      stmcycle          afmast.stmcycle%TYPE,
      isotc             afmast.isotc%TYPE,
      consultant        afmast.consultant%TYPE,
      pisotc            afmast.pisotc%TYPE,
      opndate           afmast.opndate%TYPE,
      feebase           afmast.feebase%TYPE,
      bankacctnoblock   afmast.bankacctnoblock%TYPE,
      corebank          afmast.corebank%TYPE,
      via               afmast.via%TYPE,
      dmatchamt         afmast.dmatchamt%TYPE,
      mrirate           afmast.mrirate%TYPE,
      mrmrate           afmast.mrmrate%TYPE,
      mrlrate           afmast.mrlrate%TYPE,
      mrdueday          afmast.mrdueday%TYPE,
      mrextday          afmast.mrextday%TYPE,
      mrclamt           afmast.mrclamt%TYPE,
      mrcrlimit         afmast.mrcrlimit%TYPE,
      mrcrlimitmax      afmast.mrcrlimitmax%TYPE,
      groupleader       afmast.groupleader%TYPE,
      t0amt             afmast.t0amt%TYPE,
      mrtype            CHAR (1),
      CUSTODIANTYP      char(1),
      CUSTTYPE          char(1),
      idexpdays         NUMBER(20),
      WARNINGTERMOFUSE  number(20)
   );

   TYPE afmastcheck_arrtype IS TABLE OF afmastcheck_rectype
      INDEX BY PLS_INTEGER;

   TYPE sewithdrawcheck_rectype IS RECORD (
      avlsewithdraw   NUMBER (20, 4)
   );

   TYPE sewithdrawcheck_arrtype IS TABLE OF sewithdrawcheck_rectype
      INDEX BY PLS_INTEGER;


   TYPE odmastcheck_rectype IS RECORD (
      ACTYPE                odmast.ACTYPE%TYPE,
      ORDERID                odmast.ORDERID%TYPE,
      CODEID                odmast.CODEID%TYPE,
      AFACCTNO                odmast.AFACCTNO%TYPE,
      SEACCTNO                odmast.SEACCTNO%TYPE,
      CIACCTNO                odmast.CIACCTNO%TYPE,
      TXNUM                odmast.TXNUM%TYPE,
      TXDATE                odmast.TXDATE%TYPE,
      TXTIME                odmast.TXTIME%TYPE,
      EXPDATE                odmast.EXPDATE%TYPE,
      BRATIO                odmast.BRATIO%TYPE,
      TIMETYPE                odmast.TIMETYPE%TYPE,
      EXECTYPE                odmast.EXECTYPE%TYPE,
      NORK                odmast.NORK%TYPE,
      MATCHTYPE                odmast.MATCHTYPE%TYPE,
      VIA                odmast.VIA%TYPE,
      CLEARDAY                odmast.CLEARDAY%TYPE,
      CLEARCD                odmast.CLEARCD%TYPE,
      ORSTATUS                odmast.ORSTATUS%TYPE,
      PRICETYPE                odmast.PRICETYPE%TYPE,
      QUOTEPRICE                odmast.QUOTEPRICE%TYPE,
      STOPPRICE                odmast.STOPPRICE%TYPE,
      LIMITPRICE                odmast.LIMITPRICE%TYPE,
      ORDERQTTY                odmast.ORDERQTTY%TYPE,
      REMAINQTTY                odmast.REMAINQTTY%TYPE,
      EXECQTTY                odmast.EXECQTTY%TYPE,
      STANDQTTY                odmast.STANDQTTY%TYPE,
      CANCELQTTY                odmast.CANCELQTTY%TYPE,
      ADJUSTQTTY                odmast.ADJUSTQTTY%TYPE,
      REJECTQTTY                odmast.REJECTQTTY%TYPE,
      REJECTCD                odmast.REJECTCD%TYPE,
      CUSTID                odmast.CUSTID%TYPE,
      EXPRICE                odmast.EXPRICE%TYPE,
      EXQTTY                odmast.EXQTTY%TYPE,
      ICCFCD                odmast.ICCFCD%TYPE,
      ICCFTIED                odmast.ICCFTIED%TYPE,
      EXECAMT                odmast.EXECAMT%TYPE,
      EXAMT                odmast.EXAMT%TYPE,
      FEEAMT                odmast.FEEAMT%TYPE,
      CONSULTANT                odmast.CONSULTANT%TYPE,
      VOUCHER                odmast.VOUCHER%TYPE,
      ODTYPE                odmast.ODTYPE%TYPE,
      FEEACR                odmast.FEEACR%TYPE,
      PORSTATUS                odmast.PORSTATUS%TYPE,
      RLSSECURED                odmast.RLSSECURED%TYPE,
      SECUREDAMT                odmast.SECUREDAMT%TYPE,
      MATCHAMT                odmast.MATCHAMT%TYPE,
      DELTD                odmast.DELTD%TYPE,
      REFORDERID                odmast.REFORDERID%TYPE,
      BANKTRFAMT                odmast.BANKTRFAMT%TYPE,
      BANKTRFFEE                odmast.BANKTRFFEE%TYPE,
      EDSTATUS                odmast.EDSTATUS%TYPE,
      CORRECTIONNUMBER                odmast.CORRECTIONNUMBER%TYPE,
      CONTRAFIRM                odmast.CONTRAFIRM%TYPE,
      TRADERID                odmast.TRADERID%TYPE,
      CLIENTID                odmast.CLIENTID%TYPE,
      CONFIRM_NO                odmast.CONFIRM_NO%TYPE,
      FOACCTNO                odmast.FOACCTNO%TYPE,
      HOSESESSION                odmast.HOSESESSION%TYPE,
      CONTRAORDERID                odmast.CONTRAORDERID%TYPE,
      PUTTYPE                odmast.PUTTYPE%TYPE,
      CONTRAFRM                odmast.CONTRAFRM %TYPE
   );

   TYPE odmastcheck_arrtype IS TABLE OF odmastcheck_rectype
      INDEX BY PLS_INTEGER;

    TYPE lnmastcheck_rectype IS RECORD (
        ACTYPE         LNMAST.ACTYPE%TYPE,
        ACCTNO         LNMAST.ACCTNO%TYPE,
        CCYCD         LNMAST.CCYCD%TYPE,
        BANKID         LNMAST.BANKID%TYPE,
        APPLID         LNMAST.APPLID%TYPE,
        OPNDATE         LNMAST.OPNDATE%TYPE,
        EXPDATE         LNMAST.EXPDATE%TYPE,
        EXTDATE         LNMAST.EXTDATE%TYPE,
        CLSDATE         LNMAST.CLSDATE%TYPE,
        RLSDATE         LNMAST.RLSDATE%TYPE,
        LASTDATE         LNMAST.LASTDATE%TYPE,
        ACRDATE         LNMAST.ACRDATE%TYPE,
        OACRDATE         LNMAST.OACRDATE%TYPE,
        STATUS         LNMAST.STATUS%TYPE,
        PSTATUS         LNMAST.PSTATUS%TYPE,
        TRFACCTNO         LNMAST.TRFACCTNO%TYPE,
        PRINAFT         LNMAST.PRINAFT%TYPE,
        INTAFT         LNMAST.INTAFT%TYPE,
        LNTYPE         LNMAST.LNTYPE%TYPE,
        LNCLDR         LNMAST.LNCLDR%TYPE,
        PRINFRQ         LNMAST.PRINFRQ%TYPE,
        PRINPERIOD         LNMAST.PRINPERIOD%TYPE,
        INTFRGCD         LNMAST.INTFRGCD%TYPE,
        INTDAY         LNMAST.INTDAY%TYPE,
        INTPERIOD         LNMAST.INTPERIOD%TYPE,
        NINTCD         LNMAST.NINTCD%TYPE,
        OINTCD         LNMAST.OINTCD%TYPE,
        RATE1         LNMAST.RATE1%TYPE,
        RATE2         LNMAST.RATE2%TYPE,
        RATE3         LNMAST.RATE3%TYPE,
        OPRINFRQ         LNMAST.OPRINFRQ%TYPE,
        OPRINPERIOD         LNMAST.OPRINPERIOD%TYPE,
        OINTFRQCD         LNMAST.OINTFRQCD%TYPE,
        OINTDAY         LNMAST.OINTDAY%TYPE,
        ORATE1         LNMAST.ORATE1%TYPE,
        ORATE2         LNMAST.ORATE2%TYPE,
        ORATE3         LNMAST.ORATE3%TYPE,
        DRATE         LNMAST.DRATE%TYPE,
        APRLIMIT         LNMAST.APRLIMIT%TYPE,
        RLSAMT         LNMAST.RLSAMT%TYPE,
        PRINPAID         LNMAST.PRINPAID%TYPE,
        PRINNML         LNMAST.PRINNML%TYPE,
        PRINOVD         LNMAST.PRINOVD%TYPE,
        INTNMLACR         LNMAST.INTNMLACR%TYPE,
        INTOVDACR         LNMAST.INTOVDACR%TYPE,
        INTNMLPBL         LNMAST.INTNMLPBL%TYPE,
        INTNMLOVD         LNMAST.INTNMLOVD%TYPE,
        INTDUE         LNMAST.INTDUE%TYPE,
        INTPAID         LNMAST.INTPAID%TYPE,
        INTPREPAID         LNMAST.INTPREPAID%TYPE,
        NOTES         LNMAST.NOTES%TYPE,
        LNCLASS         LNMAST.LNCLASS%TYPE,
        ADVPAY         LNMAST.ADVPAY%TYPE,
        ADVPAYFEE         LNMAST.ADVPAYFEE%TYPE,
        ORLSAMT         LNMAST.ORLSAMT%TYPE,
        OPRINPAID         LNMAST.OPRINPAID%TYPE,
        OPRINNML         LNMAST.OPRINNML%TYPE,
        OPRINOVD         LNMAST.OPRINOVD%TYPE,
        OINTNMLACR         LNMAST.OINTNMLACR%TYPE,
        OINTNMLOVD         LNMAST.OINTNMLOVD%TYPE,
        OINTOVDACR         LNMAST.OINTOVDACR%TYPE,
        OINTDUE         LNMAST.OINTDUE%TYPE,
        OINTPAID         LNMAST.OINTPAID%TYPE,
        OINTPREPAID         LNMAST.OINTPREPAID%TYPE,
        FEE         LNMAST.FEE%TYPE,
        FEEPAID         LNMAST.FEEPAID%TYPE,
        FEEDUE         LNMAST.FEEDUE%TYPE,
        FEEOVD         LNMAST.FEEOVD%TYPE,
        FEEPAID2         LNMAST.FEEPAID2%TYPE
   );

   TYPE lnmastcheck_arrtype IS TABLE OF lnmastcheck_rectype
      INDEX BY PLS_INTEGER;

    TYPE dfmastcheck_rectype IS RECORD (
        ACCTNO        dfmast.ACCTNO%TYPE,
        AFACCTNO        dfmast.AFACCTNO%TYPE,
        LNACCTNO        dfmast.LNACCTNO%TYPE,
        FULLNAME        cfmast.fullname%type,
        TXDATE        dfmast.TXDATE%TYPE,
        TXNUM        dfmast.TXNUM%TYPE,
        TXTIME        dfmast.TXTIME%TYPE,
        ACTYPE        dfmast.ACTYPE%TYPE,
        RRTYPE        dfmast.RRTYPE%TYPE,
        DFTYPE        dfmast.DFTYPE%TYPE,
        CUSTBANK        dfmast.CUSTBANK%TYPE,
        LNTYPE        dfmast.LNTYPE%TYPE,
        FEE        dfmast.FEE%TYPE,
        FEEMIN        dfmast.FEEMIN%TYPE,
        TAX        dfmast.TAX%TYPE,
        AMTMIN        dfmast.AMTMIN%TYPE,
        CODEID        dfmast.CODEID%TYPE,
        SYMBOL          varchar2(20),
        REFPRICE        dfmast.REFPRICE%TYPE,
        DFPRICE        dfmast.DFPRICE%TYPE,
        TRIGGERPRICE        dfmast.TRIGGERPRICE%TYPE,
        DFRATE        dfmast.DFRATE%TYPE,
        IRATE        dfmast.IRATE%TYPE,
        MRATE        dfmast.MRATE%TYPE,
        LRATE        dfmast.LRATE%TYPE,
        CALLTYPE        varchar2(500),
        DFQTTY        dfmast.DFQTTY%TYPE,
        BQTTY        dfmast.BQTTY%TYPE,
        RCVQTTY        dfmast.RCVQTTY%TYPE,
        CARCVQTTY        dfmast.CARCVQTTY%TYPE,
        BLOCKQTTY        dfmast.BLOCKQTTY%TYPE,
        RLSQTTY        dfmast.RLSQTTY%TYPE,
        DFAMT        dfmast.DFAMT%TYPE,
        RLSAMT        dfmast.RLSAMT%TYPE,
        AMT        dfmast.AMT%TYPE,
        INTAMTACR        dfmast.INTAMTACR%TYPE,
        FEEAMT        dfmast.FEEAMT%TYPE,
        RLSFEEAMT        dfmast.RLSFEEAMT%TYPE,
        STATUS        dfmast.STATUS%TYPE,
        DFREF        dfmast.DFREF%TYPE,
        DESCRIPTION        dfmast.DESCRIPTION%TYPE,
        PRINNML        lnmast.PRINNML%TYPE,
        PRINOVD        lnmast.PRINOVD%TYPE,
        INTNMLACR        lnmast.INTNMLACR%TYPE,
        INTOVDACR        lnmast.INTOVDACR%TYPE,
        INTNMLOVD        lnmast.INTNMLOVD%TYPE,
        INTDUE        lnmast.INTDUE%TYPE,
        INTPREPAID        lnmast.INTPREPAID%TYPE,
        OPRINNML        lnmast.OPRINNML%TYPE,
        OPRINOVD        lnmast.OPRINOVD%TYPE,
        OINTNMLACR        lnmast.OINTNMLACR%TYPE,
        OINTOVDACR        lnmast.OINTOVDACR%TYPE,
        OINTNMLOVD        lnmast.OINTNMLOVD%TYPE,
        OINTDUE        lnmast.OINTDUE%TYPE,
        OINTPREPAID        lnmast.OINTPREPAID%TYPE,
        FEEDUE        lnmast.FEEDUE%TYPE,
        FEEOVD        lnmast.FEEOVD%TYPE,
        DEALAMT         number(20,4),
        DEALFEE         number(20,4),
        RTT              number(20,4),
        REMAINQTTY    number(20,4),
        AVLFEEAMT        number(20,4),
        ODAMT        number(20,4),
        TAMT         number(20,4),
        CALLAMT     number(20,4),
        AVLRLSQTTY  number(20,4),
        AVLRLSAMT   number(20,4),
        DFTRADING      number(20,0),
        SECURED    number(20,0));
   TYPE dfmastcheck_arrtype IS TABLE OF dfmastcheck_rectype
      INDEX BY PLS_INTEGER;

    --TungNT added
   TYPE crbtrflogcheck_rectype IS RECORD (
        AUTOID crbtrflog.AUTOID%TYPE,
        VERSION crbtrflog.VERSION%TYPE,
        VERSIONLOCAL crbtrflog.VERSIONLOCAL%TYPE,
        TXDATE crbtrflog.TXDATE%TYPE,
        CREATETST crbtrflog.CREATETST%TYPE,
        SENDTST crbtrflog.SENDTST%TYPE,
        REFBANK crbtrflog.REFBANK%TYPE,
        TRFCODE crbtrflog.TRFCODE%TYPE,
        STATUS crbtrflog.STATUS%TYPE,
        PSTATUS crbtrflog.PSTATUS%TYPE,
        ERRCODE crbtrflog.ERRCODE%TYPE,
        FEEDBACK crbtrflog.FEEDBACK%TYPE,
        ERRSTS crbtrflog.ERRSTS%TYPE,
        REFVERSION crbtrflog.REFVERSION%TYPE,
        NOTES crbtrflog.NOTES%TYPE,
        TLID crbtrflog.TLID%TYPE,
        OFFID crbtrflog.OFFID%TYPE
   );

   TYPE crbtrflogcheck_arrtype IS TABLE OF crbtrflogcheck_rectype
      INDEX BY PLS_INTEGER;


TYPE crbdefbankcheck_rectype IS RECORD (
        AUTOID crbdefbank.AUTOID%TYPE,
        BANKCODE crbdefbank.BANKCODE%TYPE,
        ROOTCODE crbdefbank.ROOTCODE%TYPE,
        BANKNAME crbdefbank.BANKNAME%TYPE,
        USERIDKEY crbdefbank.USERIDKEY%TYPE,
        ACCESSKEY crbdefbank.ACCESSKEY%TYPE,
        PRIVATEKEY crbdefbank.PRIVATEKEY%TYPE,
        STATUS crbdefbank.STATUS%TYPE,
        PASSWORD crbdefbank.PASSWORD%TYPE,
        PFXKEYNAME crbdefbank.PFXKEYNAME%TYPE,
        PFXKEYPASS crbdefbank.PFXKEYPASS%TYPE,
        MINAMOUNTI crbdefbank.MINAMOUNTI%TYPE,
        MINAMOUNTG crbdefbank.MINAMOUNTG%TYPE,
        SIGNER crbdefbank.SIGNER%TYPE,
        SIGNERPASS crbdefbank.SIGNERPASS%TYPE,
        RECEIVER crbdefbank.RECEIVER%TYPE
   );

   TYPE crbdefbankcheck_arrtype IS TABLE OF crbdefbankcheck_rectype
      INDEX BY PLS_INTEGER;
   --End

  FUNCTION fn_afmastcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN afmastcheck_arrtype;
  FUNCTION fn_sewithdrawcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN sewithdrawcheck_arrtype;
  FUNCTION fn_semastcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN semastcheck_arrtype;
  FUNCTION fn_dfmastcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN dfmastcheck_arrtype;

FUNCTION fn_aftxmapcheck (
      pv_acctno   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_acfld       IN varchar2,
      pv_tltxcd in varchar2
   )
      RETURN VARCHAR2;
     PROCEDURE pr_txcorecheck (
        pv_refcursor   IN OUT   pkg_report.ref_cursor,
        pv_condvalue   IN       VARCHAR2,
        pv_tblname     IN       VARCHAR2,
        pv_fldkey      IN       VARCHAR2,
        pv_busdate      IN       VARCHAR2
     );

END;
--select * from fldmaster where modcode='MR' and fldname ='MRLMMAX'
/
CREATE OR REPLACE PACKAGE BODY txpks_check
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   PROCEDURE pr_txcorecheck (
      pv_refcursor   IN OUT   pkg_report.ref_cursor,
      pv_condvalue   IN       VARCHAR2,
      pv_tblname     IN       VARCHAR2,
      pv_fldkey      IN       VARCHAR2,
      pv_busdate      IN       VARCHAR2
   )
   IS
      v_fldkey                VARCHAR2 (50);
      v_tblname               VARCHAR2 (50);
      v_txdate                DATE;
      v_cmdsql                VARCHAR2 (2000);
      v_margintype            CHAR (1);
      v_actype                VARCHAR2 (4);
      v_groupleader           VARCHAR2 (10);
      v_baldefovd             NUMBER (20, 0);
      v_pp                    NUMBER (20, 0);
      v_avllimit              NUMBER (20, 0);
      v_navaccount            NUMBER (20, 0);
      v_outstanding           NUMBER (20, 0);
      v_mrirate               NUMBER (20, 4);
      v_deallimit             number(20,4);
      l_cimastcheck_rectype   cimastcheck_rectype;
      l_cimastcheck_arrtype   cimastcheck_arrtype;
      l_ismarginallow varchar2(1);
      l_count number;
      l_isChkSysCtrlDefault varchar2(1);
      l_isMarginAcc varchar2(2);
      l_TRFBUYRATE number(20,4);
      l_isstopadv   varchar2(10);
   BEGIN                                                               -- Proc
      v_tblname := UPPER (pv_tblname);
      v_fldkey := pv_fldkey;

      SELECT TO_DATE (varvalue, 'dd/MM/yyyy')
        INTO v_txdate
        FROM sysvar
       WHERE UPPER (varname) = 'CURRDATE';

    plog.setbeginsection(pkgctx, 'pr_txcorecheck');
    plog.debug(pkgctx, 'pv_condvalue=' || pv_condvalue || '::pv_tblname=' || pv_tblname || '::pv_fldkey=' || pv_fldkey);
    l_isstopadv := cspks_system.fn_get_sysvar('MARGIN','ISSTOPADV');
    if v_tblName = 'ODMAST' then
        OPEN PV_REFCURSOR FOR
        SELECT * FROM ODMAST WHERE ORDERID = pv_CONDVALUE;
    elsif v_tblName = 'FNMAST' then
        OPEN PV_REFCURSOR FOR
        SELECT FNMAST.*, FNTYPE.FNTYPE, FNTYPE.CODEID FROM FNMAST, FNTYPE
        WHERE FNMAST.ACCTNO = pv_CONDVALUE AND FNTYPE.ACTYPE = FNMAST.ACTYPE;
    elsif v_tblName = 'TDMAST' then
        OPEN PV_REFCURSOR FOR
        SELECT TXDATE, TXNUM, ACCTNO, AFACCTNO, ACTYPE, STATUS, PSTATUS, DELTD, CIACCTNO,
               CUSTBANK, TDSRC, TDTYPE, ORGAMT, BALANCE, PRINTPAID, AUTOPAID, INTNMLACR, INTPAID,
               TAXRATE, BONUSRATE, TPR, SCHDTYPE, INTRATE, TERMCD, TDTERM, BREAKCD, MINBRTERM, INTTYPBRCD,
               FLINTRATE, OPNDATE, FRDATE, TODATE, AUTORND, INTDUECD, INTFRQ, BUYINGPOWER, MORTGAGE,
               BALANCE-MORTGAGE AVLWITHDRAW
        FROM TDMAST WHERE ACCTNO = pv_CONDVALUE;
    elsif v_tblName = 'OOD' then
        OPEN PV_REFCURSOR FOR
        SELECT * FROM OOD WHERE ORGORDERID = pv_CONDVALUE;

    elsif v_tblName = 'LNMAST' then
        OPEN PV_REFCURSOR FOR
        SELECT ACTYPE,ACCTNO,CCYCD,BANKID,APPLID,OPNDATE,EXPDATE,EXTDATE,CLSDATE,RLSDATE,LASTDATE,ACRDATE,OACRDATE,STATUS,PSTATUS,
            TRFACCTNO,PRINAFT,INTAFT,LNTYPE,LNCLDR,PRINFRQ,PRINPERIOD,INTFRGCD,INTDAY,INTPERIOD,NINTCD,OINTCD,RATE1,RATE2,RATE3,
            OPRINFRQ,OPRINPERIOD,OINTFRQCD,OINTDAY,ORATE1,ORATE2,ORATE3,DRATE,APRLIMIT,RLSAMT,PRINPAID,
            ceil(PRINNML) PRINNML, ceil(PRINOVD) PRINOVD,
            ceil(INTNMLACR) INTNMLACR, ceil(INTOVDACR) INTOVDACR, INTNMLPBL, ceil(INTNMLOVD) INTNMLOVD,
            INTDUE,INTPAID,INTPREPAID,NOTES,LNCLASS,ADVPAY,ADVPAYFEE,
            ORLSAMT,OPRINPAID,OPRINNML,OPRINOVD,ceil(OINTNMLACR) OINTNMLACR,ceil(OINTNMLOVD) OINTNMLOVD,
            ceil(OINTOVDACR) OINTOVDACR,OINTDUE,OINTPAID,OINTPREPAID,
            FEE,FEEPAID,FEEDUE,FEEOVD,FEEPAID2,FTYPE,LAST_CHANGE
        FROM LNMAST
        WHERE acctno = pv_CONDVALUE;

    elsif v_tblName = 'CIMAST' then
        l_TRFBUYRATE:= (100 - to_number(cspks_system.fn_get_sysvar('SYSTEM', 'TRFBUYRATE')))/100;
        SELECT MR.MRTYPE,af.actype,mst.groupleader into v_margintype,v_actype,v_groupleader from afmast mst,aftype af, mrtype mr where mst.actype=af.actype and af.mrtype=mr.actype and mst.acctno=pv_CONDVALUE;
        if v_margintype='N' or v_margintype='L' then
            --Tai khoan binh thuong khong Margin
            OPEN PV_REFCURSOR FOR
                SELECT ci.actype,ci.acctno,ci.ccycd,ci.afacctno,ci.custid,ci.opndate,ci.clsdate,ci.lastdate,ci.dormdate,ci.status,ci.pstatus,
                ci.balance-nvl(secureamt,0) balance,
                ci.balance + decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) avlbal,
                ci.DFDEBTAMT, ci.HOLDMNLAMT,
                ci.cramt,ci.dramt,ci.crintacr,ci.cidepofeeacr,ci.crintdt,ci.odintacr,ci.odintdt,ci.avrbal,ci.mdebit,ci.mcredit,ci.aamt,ci.ramt,
                nvl(secureamt,0) bamt,
                ci.emkamt,ci.mmarginbal,ci.marginbal,ci.iccfcd,ci.iccftied,ci.odlimit,ci.adintacr,ci.adintdt,
                ci.facrtrade,ci.facrdepository,ci.facrmisc,ci.minbal,ci.odamt,ci.namt,ci.floatamt,ci.holdbalance,
                ci.pendinghold,ci.pendingunhold,ci.corebank,ci.receiving,ci.netting,ci.mblock,
                greatest(decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt - odamt - ci.dfdebtamt - ci.dfintdebtamt - NVL (advamt, 0) - nvl(secureamt,0) - ramt-nvl(pd.dealpaidamt,0) - ci.depofeeamt,0) AVLWITHDRAW,
                   greatest(
                        decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - NVL (overamt, 0) - nvl(secureamt,0) - ramt-nvl(pd.dealpaidamt,0) - ci.depofeeamt
                        ,0) BALDEFOVD,
                   greatest(
                        decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - ramt-nvl(pd.dealpaidamt,0) - ci.depofeeamt
                                    - greatest(
                                            nvl(trfi.secureamt_inday,0)
                                            + (nvl(trfi.trfbuyamtnofee_inday,0) + nvl(trfbuyamtnofee,0)) * l_TRFBUYRATE
                                            ,
                                            nvl(b.buyamt,0) + nvl(b.buyfeeacr,0) - least(af.trfbuyrate/100* nvl(b.buyamt,0) + case when af.trfbuyrate > 0 then nvl(b.buyfeeacr,0) else 0 end, af.advanceline - nvl(b.trft0amt,0) )
                                            + nvl(b.trfsecuredamt,0)
                                            + nvl(b.trft0amt_over,0))
                        ,0) baldeftrfamt,
                   greatest(
                        decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - ramt-nvl(pd.dealpaidamt,0) - ci.depofeeamt
                                    - greatest(0
                                            ,
                                            nvl(b.buyamt,0) + nvl(b.buyfeeacr,0) - least(af.trfbuyrate/100* nvl(b.buyamt,0) + case when af.trfbuyrate > 0 then nvl(b.buyfeeacr,0) else 0 end, af.advanceline - nvl(b.trft0amt,0) )
                                            + nvl(b.trfsecuredamt,0)
                                            + nvl(b.trft0amt_over,0))
                        ,decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - NVL (overamt, 0) - nvl(secureamt,0) - ramt-nvl(pd.dealpaidamt,0) - ci.depofeeamt
                        ,0) baldeftrfamtex,
                greatest(decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt - odamt - ci.dfdebtamt - ci.dfintdebtamt - NVL (advamt, 0) - nvl(secureamt,0) - ramt-nvl(pd.dealpaidamt,0),0) baldefovd_released_depofee,
                greatest(decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt - ci.dfdebtamt - ci.dfintdebtamt - NVL (advamt, 0) - nvl(secureamt,0) - ramt - nvl(pd.dealpaidamt,0),0) BALDEFOVD_RLSODAMT ,
                greatest(round(least(decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt ,nvl(adv.avladvance,0) + balance - trfbuyamt  + af.advanceline -NVL (advamt, 0)-nvl(secureamt,0)-ramt),0) ,0) baldefovd_released,
                round(
                    decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + nvl(balance,0) - nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - NVL (advamt, 0)- nvl(secureamt,0) + advanceline - nvl(trft0amt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) - nvl(ramt,0) - ci.depofeeamt + least(af.mrcrlimitmax+af.mrcrlimit - ci.dfodamt,af.mrcrlimit)
                    ,0) pp,
                decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + AF.mrcrlimitmax + af.mrcrlimit - dfodamt
                        + af.advanceline - nvl(b.trft0amt,0) + balance - odamt - ci.dfdebtamt - ci.dfintdebtamt - nvl (overamt, 0)-nvl(secureamt,0) - ramt - ci.depofeeamt -nvl(b.trfsecuredamt,0)-nvl(b.trft0addamt,0) avllimit,
                decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + AF.mrcrlimitmax +LEAST(af.mrcrlimit,nvl(secureamt,0)) - dfodamt
                        + balance- trfbuyamt - odamt - ci.dfdebtamt - ci.dfintdebtamt - nvl (overamt, 0)-nvl(secureamt,0) - ramt - ci.depofeeamt avlmrlimit,
                greatest(least(AF.mrcrlimitmax - dfodamt,
                        AF.mrcrlimitmax - dfodamt + af.advanceline -odamt - ci.depofeeamt),0) deallimit
                from cimast ci inner join afmast af on ci.acctno=af.acctno
                left join
                (select * from v_getbuyorderinfo where afacctno = pv_CONDVALUE) b
                on  ci.acctno = b.afacctno
                left join
                (select * from vw_trfbuyinfo_inday where afacctno = pv_CONDVALUE) trfi
                on  ci.acctno = trfi.afacctno
                left join
                (select sum(depoamt) avladvance,afacctno
                    from v_getAccountAvlAdvance where afacctno = pv_CONDVALUE group by afacctno) adv
                on adv.afacctno=ci.acctno
                LEFT JOIN
                    (select * from v_getdealpaidbyaccount p where p.afacctno = pv_CONDVALUE) pd
                    on pd.afacctno=ci.acctno
                WHERE ci.acctno = pv_CONDVALUE;
        elsif v_margintype in ('S','T') and (length(v_groupleader)=0 or  v_groupleader is null) then
            select count(1)
                into l_count
            from afmast af
            where af.acctno = pv_condvalue
            and (exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y')
                or exists (select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y'));

            if l_count > 0 then
                l_isMarginAcc:='Y';
            else
                l_isMarginAcc:='N';
            end if;

            -- Day la tieu khoan gan loai hinh mac dinh la tuan thu.
            select count(1)
                into l_count
            from afmast af
            where af.acctno = pv_condvalue
            and exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y');

            if l_count > 0 then
                l_isChkSysCtrlDefault:='Y';
            else
                l_isChkSysCtrlDefault:='N';
            end if;
            --Tai khoan margin khong tham gia group
            OPEN PV_REFCURSOR FOR
                SELECT
                ACTYPE,ACCTNO,CCYCD,AFACCTNO,CUSTID,OPNDATE,CLSDATE,LASTDATE,
                DORMDATE,STATUS,PSTATUS,BALANCE,AVLBAL,CRAMT,DRAMT,CRINTACR,CRINTDT,ODINTACR,ODINTDT,
                AVRBAL,MDEBIT,MCREDIT,AAMT,RAMT,BAMT,EMKAMT,MMARGINBAL,MARGINBAL,ICCFCD,ICCFTIED,
                ODLIMIT,ADINTACR,ADINTDT,FACRTRADE,FACRDEPOSITORY,FACRMISC,MINBAL,ODAMT,NAMT,FLOATAMT,
                HOLDBALANCE,PENDINGHOLD,PENDINGUNHOLD,COREBANK,RECEIVING,NETTING,MBLOCK,PP,AVLLIMIT,AVLMRLIMIT,DEALLIMIT,
                NAVACCOUNT,OUTSTANDING,MRIRATE, DFDEBTAMT, HOLDMNLAMT,
                greatest(case when l_isChkSysCtrlDefault = 'Y' then
                    least( (MARGINRATIO/100 - MRIRATIO/100) * (serealass) + greatest(0,balance+nvl(avladvance,0)-ovamt-dueamt-depofeeamt)
                        ,
                        TRUNC(
                            GREATEST(
                                (CASE WHEN MRIRATE>0 THEN least(NAVACCOUNT*100/MRIRATE + (OUTSTANDING-(ADVANCELINE-trft0amt)),AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE NAVACCOUNT + OUTSTANDING END)
                            ,0) - DEALPAIDAMT
                        ,0)
                        )
                else
                    TRUNC(
                        GREATEST(
                            (CASE WHEN MRIRATE>0 THEN least(NAVACCOUNT*100/MRIRATE + (OUTSTANDING-(ADVANCELINE-trft0amt)),AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE NAVACCOUNT + OUTSTANDING END)
                        ,0) - DEALPAIDAMT
                    ,0)
                end,0) AVLWITHDRAW,
                --Neu co bao lanh T0 thi khong duoc rut
                greatest(case when l_isChkSysCtrlDefault = 'Y' then
                    least(
                            (MARGINRATIO/100 - MRIRATIO/100) * (serealass) + greatest(0,balance+bamt+nvl(avladvance,0)-ovamt-dueamt-depofeeamt)
                            ,
                            TRUNC(
                        -- (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNT + (OUTSTANDING-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
                        -- HaiLT sua ct rut tien thuong theo y/c MR001
                        (CASE WHEN MRIRATE>0  THEN LEAST(PP,BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
                        - DEALPAIDAMT
                    ,0) )
                else
                    TRUNC(
                       --(CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNT + (OUTSTANDING-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
                        -- HaiLT sua ct rut tien thuong theo y/c MR001
                        (CASE WHEN MRIRATE>0  THEN LEAST(PP,BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
                        - DEALPAIDAMT
                    ,0)
                end,0) BALDEFOVD,
                greatest(case when l_isChkSysCtrlDefault = 'Y' then
                    least(
                            (MARGINRATIO/100 - MRIRATIO/100) * (serealass) + greatest(0,balance+bamt+nvl(avladvance,0)-ovamt-dueamt-depofeeamt)
                            ,
                            TRUNC(
                        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNTT2 + (OUTSTANDINGT2-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),baldeftrfamt,avllimitt2-(ADVANCELINE-trft0amt)) ELSE baldeftrfamt END)
                        - DEALPAIDAMT
                    ,0) )
                else
                    TRUNC(
                        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNTT2 + (OUTSTANDINGT2-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),baldeftrfamt,avllimitt2-(ADVANCELINE-trft0amt)) ELSE baldeftrfamt END)
                        - DEALPAIDAMT
                    ,0)
                end,0) BALDEFTRFAMT,
                greatest(case when l_isChkSysCtrlDefault = 'Y' then
                    least(
                            (MARGINRATIO/100 - MRIRATIO/100) * (serealass) + greatest(0,balance+bamt+nvl(avladvance,0)-ovamt-dueamt-depofeeamt)
                            ,
                            TRUNC(
                        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNTT2 + (OUTSTANDINGT2EX-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),baldeftrfamt,avllimitt2-(ADVANCELINE-trft0amt)) ELSE baldeftrfamt END)
                        - DEALPAIDAMT
                    ,0) )
                else
                    greatest(
                    TRUNC(
                        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNT + (OUTSTANDING-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
                        - DEALPAIDAMT
                    ,0),
                    TRUNC(
                        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNTT2 + (OUTSTANDINGT2EX-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),baldeftrfamt,avllimitt2-(ADVANCELINE-trft0amt)) ELSE baldeftrfamt END)
                        - DEALPAIDAMT
                    ,0))
                end,0) BALDEFTRFAMTEX,
                BALDEFOVD_5540, baldefovd_released_depofee

                FROM
                    (SELECT af.advanceline,ci.actype,ci.acctno,ci.ccycd,ci.afacctno,ci.custid,ci.opndate,ci.clsdate,ci.lastdate,ci.dormdate,ci.status,ci.pstatus,
                    ci.balance-nvl(secureamt,0) balance,
                    ci.balance + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) avlbal,
                    ci.DFDEBTAMT, ci.HOLDMNLAMT,
                    ci.cramt,ci.dramt,ci.crintacr,ci.crintdt,ci.odintacr,ci.odintdt,ci.avrbal,ci.mdebit,ci.mcredit,ci.aamt,ci.ramt,
                    nvl(secureamt,0) bamt,
                    ci.emkamt,ci.mmarginbal,ci.marginbal,ci.iccfcd,ci.iccftied,ci.odlimit,ci.adintacr,ci.adintdt,
                    ci.facrtrade,ci.facrdepository,ci.facrmisc,ci.minbal,ci.odamt,ci.namt,ci.floatamt,ci.holdbalance,
                    ci.pendinghold,ci.pendingunhold,ci.corebank,ci.receiving,ci.netting,ci.mblock,
                    decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance - trfbuyamt - ovamt-dueamt - dfdebtamt - dfintdebtamt - ramt-af.advanceline-nvl(dealpaidamt,0) baldefovd_released_depofee,
                    greatest(decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance - trfbuyamt  - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - NVL (advamt, 0) - ramt-nvl(se.dealpaidamt,0),0) baldefovd_5540,
                    greatest(
                         decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance /*- trfbuyamt*/ - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt /*- NVL (overamt, 0) - nvl(secureamt,0)*/ - ramt-nvl(se.dealpaidamt,0) - ci.depofeeamt
                         ,0) BALDEFOVD,
                    greatest(
                         decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - ramt-nvl(se.dealpaidamt,0) - ci.depofeeamt
                                     /*- greatest(0, nvl(se.buyamt,0) + nvl(se.buyfeeacr,0) - least(af.trfbuyrate/100* nvl(se.buyamt,0) + case when af.trfbuyrate > 0 then nvl(se.buyfeeacr,0) else 0 end, af.advanceline - nvl(se.trft0amt,0) )
                                             + nvl(trfsecuredamt,0)
                                             + nvl(se.trft0addamt,0))*/
                         ,0) baldeftrfamt,
                   greatest(round(least(decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance- trfbuyamt ,decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance- trfbuyamt  + af.advanceline -NVL (advamt, 0)-nvl(secureamt,0)-ramt),0) ,0) baldefovd_released,
                   case when l_isChkSysCtrlDefault = 'Y' then
                       least(
                       round(ci.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                           - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.semramt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt - ci.depofeeamt,0),
                       round(ci.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                           - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                       )
                   else
                       round(ci.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                           - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                   end PP,
                   decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + nvl(af.advanceline,0) - nvl(trft0amt,0)- nvl(trfsecuredamt,0) + nvl(SE.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)- dfodamt + balance - odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - nvl(secureamt,0) - ramt avllimit,
                   decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + nvl(af.advanceline,0) - nvl(trfsecuredamt,0) + nvl(SE.mrcrlimitmax,0)+nvl(af.mrcrlimit,0)- dfodamt + balance - odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - ramt
                        -nvl(trf.trfsecuredamt_inday,0)-nvl(trf.secureamt_inday,0)
                        avllimitt2,
                   decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + nvl(SE.mrcrlimitmax,0)+ least(nvl(af.mrcrlimit,0),nvl(secureamt,0))- dfodamt + balance- trfbuyamt - odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - nvl(secureamt,0) - ramt avlmrlimit,
                   greatest(least(nvl(SE.mrcrlimitmax,0) - dfodamt,
                        nvl(SE.mrcrlimitmax,0) - dfodamt + nvl(af.advanceline,0) -odamt),0) deallimit,
                   least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SETOTALCALLASS,0),nvl(SE.mrcrlimitmax,0) - dfodamt) NAVACCOUNT,
                   least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SET0CALLASS,0),nvl(SE.mrcrlimitmax,0) - dfodamt) NAVACCOUNTT2,
                   nvl(af.advanceline,0)  - nvl(trft0amt,0) + ci.balance +least(nvl(af.mrcrlimit,0),nvl(secureamt,0))- trfbuyamt + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - NVL (se.advamt, 0)-nvl(se.secureamt,0) - ci.ramt OUTSTANDING, --kHI DAT LENH THI THEM PHAN T0
                   least(nvl(af.advanceline,0)  - nvl(trft0amt,0) + ci.balance + least(nvl(af.mrcrlimit,0),nvl(trf.trfsecuredamt_inday,0)+nvl(se.trfsecuredamt,0)+ nvl(trf.secureamt_inday,0)+nvl(se.trft0amt_over,0))+
                                                decode(l_isstopadv,'Y',0,nvl(se.avladvance,0))- ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - ci.ramt - nvl(se.trft0amt_over,0)
                                -nvl(trf.trfsecuredamt_inday,0) - nvl(se.trfsecuredamt,0) -nvl(trf.secureamt_inday,0),
                            nvl(af.advanceline,0)  - nvl(trft0amt,0) + ci.balance
                            + least(nvl(af.mrcrlimit,0),nvl(trf.secureamt_inday,0)+(nvl(trf.trfbuyamtnofee_inday,0)+nvl(trfbuyamtnofee,0)) * l_TRFBUYRATE)
                                + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - ci.ramt
                                -(nvl(trf.trfbuyamtnofee_inday,0)+nvl(trfbuyamtnofee,0)) * l_TRFBUYRATE - nvl(trf.secureamt_inday,0)
                                ) OUTSTANDINGT2,
                   nvl(af.advanceline,0)  - nvl(trft0amt,0) + ci.balance + least(nvl(af.mrcrlimit,0),nvl(trf.trfsecuredamt_inday,0)+nvl(se.trfsecuredamt,0)+ nvl(trf.secureamt_inday,0)+ nvl(se.trft0amt_over,0))
                               + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - ci.ramt - nvl(se.trft0amt_over,0)
                                -nvl(trf.trfsecuredamt_inday,0) - nvl(se.trfsecuredamt,0) -nvl(trf.secureamt_inday,0) OUTSTANDINGT2EX,
                   af.mrirate,nvl(se.dealpaidamt,0) dealpaidamt, nvl(trft0amt,0) trft0amt, nvl(margin74amt,0) margin74amt, decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) avladvance,
                   nvl(serealass,0) serealass, nvl(MARGINRATIO,0) MARGINRATIO, nvl(af.MRIRATIO,0) MRIRATIO, depofeeamt, dueamt,ovamt
                   from cimast ci inner join afmast af on ci.acctno=af.acctno
                               inner join aftype aft on af.actype = aft.actype
                        left join (select * from v_getsecmarginratio where afacctno = pv_CONDVALUE) se on se.afacctno=ci.acctno
                        left join (select * from vw_trfbuyinfo_inday where afacctno = pv_CONDVALUE) trf on trf.afacctno=ci.acctno
                        left join (select TRFACCTNO, nvl(sum(ln.PRINOVD + ln.INTOVDACR + ln.INTNMLOVD + ln.OPRINOVD + ln.OPRINNML + ln.OINTNMLOVD + ln.OINTOVDACR+ln.OINTDUE+ln.OINTNMLACR + nvl(lns.nml,0) + nvl(lns.intdue,0)),0) OVDAMT,
                                                       nvl(sum(ln.OPRINOVD + ln.OPRINNML + ln.OINTNMLOVD + ln.OINTOVDACR+ln.OINTDUE+ln.OINTNMLACR),0) T0AMT,
                                                       nvl(sum(ln.PRINNML - nvl(nml,0) + ln.INTNMLACR),0) NMLMARGINAMT,
                                            nvl(sum(decode(lnt.chksysctrl,'Y',1,0)*(ln.prinnml+ln.prinovd+ln.intnmlacr+ln.intdue+ln.intovdacr+ln.intnmlovd+ln.feeintnmlacr+ln.feeintdue+ln.feeintovdacr+ln.feeintnmlovd)),0) margin74amt
                               from lnmast ln, lntype lnt, (select acctno, sum(nml) nml, sum(intdue) intdue  from lnschd
                                                   where reftype = 'P' and  overduedate = to_date(cspks_system.fn_get_sysvar('SYSTEM','CURRDATE'),'DD/MM/RRRR') group by acctno) lns
                               where ln.actype = lnt.actype and ln.acctno = lns.acctno(+) and ln.ftype = 'AF'
                               and ln.trfacctno = pv_CONDVALUE
                               group by ln.trfacctno) OVDAF on OVDAF.TRFACCTNO = ci.acctno
                   left join (select afacctno, sum(amt) receivingamt from stschd where afacctno = pv_CONDVALUE and duetype = 'RM' and status <> 'C' and deltd <> 'Y' group by afacctno) sts_rcv
                             on ci.acctno = sts_rcv.afacctno
                   WHERE ci.acctno = pv_CONDVALUE);
        else
            --Tai khoan margin join theo group
            SELECT LEAST(SUM(NVL(AF.MRCRLIMIT,0) + NVL(SE.SEAMT,0))
                            ,sum(greatest(NVL(AF.MRCRLIMITMAX,0)+NVL(AF.MRCRLIMIT,0)- dfodamt,0)))
                       + sum(BALANCE + NVL(adv.avladvance,0) - ODAMT - NVL (ADVAMT, 0)-NVL(SECUREAMT,0)-nvl(trfsecuredamt,0)-nvl(TRFT0ADDAMT,0) - RAMT - ci.depofeeamt) PP,
                   greatest(sum(nvl(adv.avladvance,0) + nvl(AF.mrcrlimitmax,0)+NVL(AF.MRCRLIMIT,0)- dfodamt + balance - odamt - ci.dfdebtamt - ci.dfintdebtamt - nvl(secureamt,0) - ramt - ci.depofeeamt),0) avllimit,
                   greatest(least(sum(nvl(AF.mrcrlimitmax,0) - dfodamt),
                        sum(nvl(AF.mrcrlimitmax,0) - dfodamt + nvl(af.advanceline,0) -odamt)),0) deallimit,
                   GREATEST(SUM(nvl(adv.avladvance,0) + balance - trfbuyamt - ovamt-dueamt - ci.dfdebtamt - ci.dfintdebtamt - ramt - ci.depofeeamt),0) baldefovd,
                   SUM(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SEASS,0))  NAVACCOUNT,
                   SUM(ci.balance+least(nvl(af.MRCRLIMIT,0),nvl(b.secureamt,0))- trfbuyamt + nvl(adv.avladvance,0)- ci.odamt - ci.dfdebtamt - ci.dfintdebtamt- nvl(b.secureamt,0) - ci.ramt) OUTSTANDING,
                   SUM(CASE WHEN AF.ACCTNO <> v_groupleader THEN 0 ELSE AF.MRIRATE END) MRIRATE
               into v_pp,v_avllimit,v_deallimit, v_baldefovd,v_navaccount,v_outstanding,v_mrirate
               from cimast ci inner join afmast af on ci.acctno=af.acctno and af.groupleader=v_groupleader
               left join
                (select b.* from v_getbuyorderinfo  b, afmast af where b.afacctno =af.acctno and af.groupleader=v_groupleader) b
                on  ci.acctno = b.afacctno
                LEFT JOIN
                (select b.* from v_getsecmargininfo b, afmast af where b.afacctno =af.acctno and af.groupleader=v_groupleader) se
                on se.afacctno=ci.acctno
                left join
                (select sum(depoamt) avladvance,afacctno
                    from v_getAccountAvlAdvance b , afmast af where b.afacctno =af.acctno and af.groupleader=v_groupleader group by afacctno) adv
                on adv.afacctno=ci.acctno
                ;
            OPEN PV_REFCURSOR FOR
            SELECT ci.actype,ci.acctno,ci.ccycd,ci.afacctno,ci.custid,ci.opndate,ci.clsdate,ci.lastdate,ci.dormdate,ci.status,ci.pstatus,
                ci.balance-nvl(secureamt,0) balance,
                ci.balance + nvl(adv.avladvance,0) avlbal,
                ci.DFDEBTAMT, ci.HOLDMNLAMT,
                ci.cramt,ci.dramt,ci.crintacr,ci.CIDEPOFEEACR,ci.crintdt,ci.odintacr,ci.odintdt,ci.avrbal,ci.mdebit,ci.mcredit,ci.aamt,ci.ramt,
                nvl(secureamt,0) bamt,
                ci.emkamt,ci.mmarginbal,ci.marginbal,ci.iccfcd,ci.iccftied,ci.odlimit,ci.adintacr,ci.adintdt,
                ci.facrtrade,ci.facrdepository,ci.facrmisc,ci.minbal,ci.odamt,ci.namt,ci.floatamt,ci.holdbalance,
                ci.pendinghold,ci.pendingunhold,ci.corebank,ci.receiving,ci.netting,ci.mblock,
                greatest(nvl(af.advanceline,0) + v_pp,0) pp,nvl(af.advanceline,0) - nvl(trft0amt,0) + v_avllimit avllimit,v_avllimit avlmrlimit,v_deallimit deallimit,
                TRUNC(GREATEST((CASE WHEN v_mrirate>0 THEN least(v_navaccount*100/v_mrirate + v_outstanding,v_avllimit) ELSE v_navaccount + v_outstanding  END),0),0) AVLWITHDRAW,
                TRUNC((case when v_mrirate>0
                                 --then least(greatest((100* v_navaccount + v_outstanding * v_mrirate)/v_mrirate,0),
                                -- HaiLT sua ct rut tien thuong theo y/c MR001
                                then least(greatest(nvl(af.advanceline,0) + v_pp,0),
                                                    greatest( nvl(adv.avladvance,0) + balance - trfbuyamt - ovamt-dueamt- dfdebtamt - dfintdebtamt - ramt-(af.advanceline - nvl(trft0amt,0)) -nvl(pd.dealpaidamt,0) - ci.depofeeamt,0),
                                                    v_avllimit)
                             else greatest(nvl(adv.avladvance,0) + balance - trfbuyamt - odamt - NVL (advamt, 0)-nvl(secureamt,0)-dfdebtamt - dfintdebtamt - ramt - ci.depofeeamt,0)
                             end),0) baldefovd,
                TRUNC((case when v_mrirate>0
                                 --then least(greatest((100* v_navaccount + v_outstanding * v_mrirate)/v_mrirate,0),
                                -- HaiLT sua ct rut tien thuong theo y/c MR001
                                then least(greatest(nvl(af.advanceline,0) + v_pp,0),
                                                    greatest( nvl(adv.avladvance,0) + balance - trfbuyamt - ovamt-dueamt- dfdebtamt - dfintdebtamt - ramt-af.advanceline-nvl(pd.dealpaidamt,0),0),
                                                    v_avllimit)
                             else greatest(nvl(adv.avladvance,0) + balance - trfbuyamt - odamt - NVL (advamt, 0)-nvl(secureamt,0)-dfdebtamt - dfintdebtamt - ramt,0)
                             end),0) baldefovd_released_depofee
               from cimast ci inner join afmast af on ci.acctno=af.acctno
               left join
                (select * from v_getbuyorderinfo where afacctno = pv_CONDVALUE) b
                on  ci.acctno = b.afacctno
                LEFT JOIN
                (select * from v_getsecmargininfo SE where se.afacctno = pv_CONDVALUE) se
                on se.afacctno=ci.acctno
                LEFT JOIN
                (select aamt,depoamt avladvance, advamt advanceamount,afacctno, paidamt from v_getAccountAvlAdvance where afacctno = pv_CONDVALUE ) adv
                on adv.afacctno=ci.acctno
                LEFT JOIN
                (select * from v_getdealpaidbyaccount p where p.afacctno = pv_CONDVALUE) pd
                on pd.afacctno=ci.acctno
                WHERE ci.acctno = pv_CONDVALUE;
        end if;
    elsif v_tblname='DFMAST' then
        OPEN PV_REFCURSOR FOR
        select * from v_getDealInfo df where df.acctno = pv_CONDVALUE;

    elsif v_tblName = 'CAMAST' then
        OPEN PV_REFCURSOR FOR
        SELECT * FROM CAMAST WHERE CAMASTID = pv_CONDVALUE;

    elsif v_tblName = 'CASCHD' then
        OPEN PV_REFCURSOR FOR
        SELECT * FROM CASCHD WHERE TRIM(AUTOID) = pv_CONDVALUE;

    elsif v_tblName = 'CFMAST' then
        OPEN PV_REFCURSOR FOR
        SELECT * FROM CFMAST WHERE CUSTID = pv_CONDVALUE;

    elsif v_tblName = 'AFMAST' then
        /*
        OPEN PV_REFCURSOR FOR
        SELECT AF.*, MR.MRTYPE,
        (CASE WHEN SUBSTR(CF.CUSTODYCD,1,3)=FN_GET_COMPANYCD THEN 'C' ELSE 'T' END) CUSTODIANTYP
        FROM CFMAST CF, AFMAST AF,AFTYPE AFT,MRTYPE MR
        WHERE AF.actype =AFT.actype AND AF.aftype =AFT.aftype AND AF.CUSTID=CF.CUSTID
        AND AFT.mrtype =MR.actype AND AF.ACCTNO =pv_CONDVALUE;
        */
        OPEN PV_REFCURSOR FOR
        SELECT AF.*, MR.MRTYPE,
        (CASE WHEN CF.CUSTATCOM='Y' THEN 'C' ELSE 'T' END) CUSTODIANTYP,
        substr(cf.custodycd,4,1) CUSTTYPE,
        (cf.idexpired - v_txdate) idexpdays,
        decode(af.TERMOFUSE,'003',0,1) WARNINGTERMOFUSE
        FROM CFMAST CF, AFMAST AF,AFTYPE AFT,MRTYPE MR, sysvar sys
        WHERE AF.actype =AFT.actype --AND AF.aftype =AFT.aftype
        AND AF.CUSTID=CF.CUSTID
        AND sys.grname ='SYSTEM' and sys.varname ='COMPANYCD'
        AND AFT.mrtype =MR.actype AND AF.ACCTNO =pv_CONDVALUE;
    elsif v_tblName = 'SEMAST' then
       OPEN PV_REFCURSOR FOR
        select semast.actype, semast.acctno, semast.codeid, semast.afacctno, semast.opndate, semast.clsdate,
                    semast.lastdate, semast.status, semast.pstatus, semast.irtied, semast.ircd, semast.costprice,
                    semast.trade - nvl(b.secureamt,0) trade, semast.mortage-nvl(b.securemtg,0) mortage,nvl(df.sumdfqtty,0)-nvl(b.securemtg,0) dfmortage, semast.margin, semast.netting, abs(semast.standing) standing, semast.withdraw,
                   semast.deposit, semast.loan, semast.blocked, semast.receiving, semast.transfer,
                   semast.prevqtty, semast.dcrqtty, semast.dcramt, semast.depofeeacr, semast.repo, semast.pending,
                   semast.tbaldepo, semast.custid, semast.costdt,nvl(b.securemtg,0)+nvl(b.secureamt,0) secured, semast.iccfcd, semast.iccftied,
                   semast.tbaldt, semast.senddeposit, semast.sendpending, semast.ddroutqtty,
                   semast.ddroutamt, semast.dtoclose, semast.sdtoclose, semast.qtty_transfer,
                   greatest(semast.trade - nvl(b.secureamt,0) + nvl(b.sereceiving,0),0) trading,
                   abs(semast.standing) absstanding, mod(semast.trade,seinfo.tradelot) retaillot
            from SEMAST,
                v_getsellorderinfo b, (select codeid, tradelot from securities_info) seinfo,
                (SELECT afacctno,codeid, sum(dfqtty) sumdfqtty FROM dfmast GROUP BY afacctno, codeid) df
            WHERE acctno = pv_CONDVALUE AND semast.codeid = seinfo.codeid(+) AND ACCTNO = b.seacctno(+) AND df.afacctno(+) = semast.afacctno AND df.codeid(+) = semast.codeid;
    elsif v_tblName = 'SEREVERT' then
                OPEN PV_REFCURSOR FOR
                        select SUM(serevert) SESTATUS
                      from ((SELECT count(*) serevert FROM SEMAST
                            WHERE afacctno = pv_CONDVALUE and status = 'N')
                            UNION ALL (SELECT count(*) serevert FROM caschd
                            WHERE afacctno = pv_CONDVALUE and status = 'O' AND deltd='N'));

    elsif v_tblName = 'CFBANK' then
          if length(trim(pv_CONDVALUE)) > 0 then
             OPEN PV_REFCURSOR FOR
                        select count(1) ISBANKSTATUS
                      from CFMAST
                            WHERE custid = pv_CONDVALUE and isbanking = 'Y' and status = 'A';
          else
             OPEN PV_REFCURSOR FOR
                        select 1 ISBANKSTATUS
                      from dual;
          end if;

    elsif v_tblName = 'SEBLOCKDEAL' then
             OPEN PV_REFCURSOR FOR
                     SELECT sum(nvl(s.blocked,0) + nvl(d.blockqtty,0)) BLOCKQTTY
                     FROM   semast s,
                                 (SELECT sum(blockqtty) blockqtty,afacctno,codeid,acctno FROM dfmast WHERE afacctno || codeid = pv_CONDVALUE GROUP BY afacctno,codeid,acctno) d
                     WHERE d.afacctno(+) = s.afacctno AND d.codeid(+) = s.codeid
                                 AND s.acctno = pv_CONDVALUE;

    elsif v_tblName = 'SEWITHDRAW' then
        SELECT MR.MRTYPE,af.actype,mst.groupleader into v_margintype,v_actype,v_groupleader from afmast mst,aftype af, mrtype mr where mst.actype=af.actype and af.mrtype=mr.actype and mst.acctno=substr(pv_CONDVALUE,1,10);
        if v_margintype='N' or v_margintype='L' then
        OPEN PV_REFCURSOR FOR
            SELECT 1000000000 AVLSEWITHDRAW FROM DUAL;
        elsif v_margintype in ('S','T') and (length(v_groupleader)=0 or  v_groupleader is null) then
            --Tai khoan margin khong tham gia group
            OPEN PV_REFCURSOR FOR


            select least(se.trade- nvl(od.SELLQTTY,0),
                            (CASE WHEN LEAST(NVL(SB.MARGINCALLPRICE,0),NVL(RSK.MRPRICERATE,0)) * NVL(RSK.MRRATIORATE,0) <=0 THEN 1000000000
                                ELSE
                                    CASE WHEN SETOTALCALLASS + (OUTSTANDING - ci.depofeeamt) <= 0 THEN 0 ELSE
                                        trunc(GREATEST((100* SEMAXTOTALCALLASS + (OUTSTANDING - ci.depofeeamt) * MRIRATE)/MRIRATE,0)/LEAST(sb.marginprice/*SB.MARGINCALLPRICE*/,rsk.mrpriceloan/*RSK.MRPRICERATE*/) / (rsk.mrratioloan/*MRRATIORATE*//100),0)   --them phi luu ky den han MSBS-776
                                    END
                            END)) avlsewithdraw
             from semast se, securities_info sb, cimast ci,
             (select af.acctno afacctno,af.advanceline,af.MRIRATE, nvl(rsk.mrpricerate,1) mrpricerate, nvl(rsk.mrratiorate,0) mrratiorate, nvl(rsk.mrratioloan,0) mrratioloan, nvl(rsk.mrpriceloan,0) mrpriceloan
                from afmast af, (select * from afserisk where codeid = substr(pv_condvalue,11,6)) rsk
                where af.acctno = substr(pv_CONDVALUE,1,10) and af.actype = rsk.actype(+)) rsk,
             (select * from v_getsecmarginratio where afacctno = substr(pv_CONDVALUE,1,10)) sec,
             (select od.seacctno,
                        sum(case when od.exectype in ('NS','SS') and to_date(sy.varvalue,'DD/MM/RRRR') = od.txdate then remainqtty + execqtty else 0 end) SELLQTTY,
                        sum(case when od.exectype in ('NS','SS') and to_date(sy.varvalue,'DD/MM/RRRR') = od.txdate then execqtty else 0 end) EXECSELLQTTY,
                        sum(case when od.exectype in ('MS') and to_date(sy.varvalue,'DD/MM/RRRR') = od.txdate then remainqtty + execqtty else 0 end) MTGSELLQTTY,
                        sum(case when od.exectype = 'NB' then sts.qtty - sts.aqtty else 0 end) RECEIVING,
                        sum(CASE WHEN OD.EXECTYPE = 'NB' and to_date(sy.varvalue,'DD/MM/RRRR') = od.txdate then od.REMAINQTTY ELSE 0 END) REMAINQTTY
                        from odmast od, (select * from stschd where duetype in ('RS','SS')) sts, sysvar sy
                        where od.orderid = sts.orgorderid(+)
                        and sy.varname = 'CURRDATE'
                        group by od.seacctno) od
             where se.acctno = pv_CONDVALUE and se.afacctno = sec.afacctno(+)
                and se.afacctno = rsk.afacctno(+)
                and se.acctno = od.seacctno(+)
                and se.codeid = sb.codeid and ci.acctno = se.afacctno;
        else
            --Tai khoan margin join theo group
            OPEN PV_REFCURSOR FOR
            SELECT
                (CASE WHEN LEAST(NVL(SB.MARGINCALLPRICE,0),NVL(RSK.MRPRICERATE,0)) * NVL(RSK.MRRATIORATE,0) <=0 THEN 1000000000
                ELSE
                trunc((NAVACCOUNT*100+OUTSTANDING*MRIRATE)/LEAST(SB.MARGINCALLPRICE,RSK.MRPRICERATE) / MRRATIORATE,0)
                END) AVLSEWITHDRAW FROM (
                SELECT AF.ACCTNO,AF.ACTYPE,AF.MRIRATE, NAVACCOUNT,OUTSTANDING

                                FROM
                                (SELECT substr(pv_CONDVALUE,1,10) AFACCTNO,
                                           SUM(/*NVL(AF.MRCRLIMIT,0)*/ + NVL(SE.SEASS,0)) NAVACCOUNT,
                                           SUM(BALANCE +least(NVL(AF.MRCRLIMIT,0),NVL(SECUREAMT,0))- trfbuyamt + NVL(SE.RECEIVINGAMT,0)- ODAMT - NVL (ADVAMT, 0)-NVL(SECUREAMT,0) - RAMT) OUTSTANDING
                                   FROM CIMAST ci INNER JOIN AFMAST AF ON AF.ACCTNO = ci.AFACCTNO AND AF.GROUPLEADER=v_groupleader
                                   LEFT JOIN
                                    (SELECT B.* FROM V_GETBUYORDERINFO B,AFMAST AF WHERE B.AFACCTNO = AF.ACCTNO AND AF.GROUPLEADER=v_groupleader) B
                                    ON  ci.ACCTNO = B.AFACCTNO

                                   LEFT JOIN
                                    (SELECT B.* FROM V_GETSECMARGININFO B,AFMAST AF WHERE B.AFACCTNO = AF.ACCTNO AND AF.GROUPLEADER=v_groupleader) SE
                                    ON SE.AFACCTNO=ci.ACCTNO
                                    GROUP BY AF.GROUPLEADER
                                ) A, AFMAST AF WHERE A.AFACCTNO =AF.ACCTNO) MST,
                AFSERISK RSK,SECURITIES_INFO SB
                WHERE MST.ACTYPE =RSK.ACTYPE(+) AND SB.CODEID=substr(pv_CONDVALUE,11,6) AND RSK.CODEID(+)=substr(pv_CONDVALUE,11,6);
        end if;
    else
        v_cmdSQL := 'SELECT * FROM ' || v_tblname
                    || ' WHERE ' || v_fldkey || ' = ''' || pv_condvalue || '''';
        OPEN PV_REFCURSOR FOR
        v_cmdSQL;
    end if;

        plog.setendsection(pkgctx, 'pr_txcorecheck');

   EXCEPTION
      WHEN OTHERS
      THEN
           plog.error(pkgctx, SQLERRM);
        plog.setendsection(pkgctx, 'pr_txcorecheck');
         RETURN;
   END pr_txcorecheck;

   FUNCTION fn_cimastcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN cimastcheck_arrtype
   IS
      l_margintype            CHAR (1);
      l_actype                VARCHAR2 (4);
      l_groupleader           VARCHAR2 (10);
      l_baldefovd             NUMBER (20, 0);
      l_baldefovd_Released    NUMBER (20, 0);

      l_pp                    NUMBER (20, 0);
      l_avllimit              NUMBER (20, 0);
      l_deallimit             NUMBER (20, 0);
      l_navaccount_EX            NUMBER (20, 0);
      l_outstanding           NUMBER (20, 0);
      l_mrirate               NUMBER (20, 4);

      l_baldefovd_Released_depofee    NUMBER (20, 0);

      l_cimastcheck_rectype   cimastcheck_rectype;
      l_cimastcheck_arrtype   cimastcheck_arrtype;
      l_i                     NUMBER (10);
      pv_refcursor            pkg_report.ref_cursor;
      l_count number;
      l_isChkSysCtrlDefault varchar2(1);
      l_isMarginAcc varchar2(1);

      l_avladvance  NUMBER; -- TheNN added
      l_advanceamount NUMBER; -- TheNN added
      l_paidamt       NUMBER; -- TheNN added
      l_EXECBUYAMT       NUMBER; -- TheNN added
      l_TRFBUYRATE       NUMBER;
      --PhuongHT edit ngay 29.02.2015: tunning view MR01-02-03
      l_trfbuyamt_over number;
      l_set0amt number;
      l_rlsmarginrate number;
      l_marginrate_EX number;
      l_NYOVDAMT      number;
      l_semaxtotalcallass number;
      l_secallass number;
      l_clamt number;
      l_navaccountt2 number;
      l_outstanding_EX number;
      l_navaccount number;
      l_marginrate5 number;
      l_outstanding5      number;
      l_odamt number;
      l_outstandingt2 number;
      l_semaxcallass number;
      l_secureamt_inday number;
      l_trfsecuredamt_inday number;
      l_t0loanrate          NUMBER;
      l_currdate            DATE;
      --end of PhuongHT edit ngay 29.02.2015: tunning view MR
      l_isstopadv   varchar2(10);
   BEGIN
         -- Proc
       l_currdate := to_date(cspks_system.fn_get_sysvar('SYSTEM', 'CURRDATE'),'dd/mm/rrrr');
      l_TRFBUYRATE:= (100 - to_number(cspks_system.fn_get_sysvar('SYSTEM', 'TRFBUYRATE')))/100;
      l_isstopadv := cspks_system.fn_get_sysvar('MARGIN','ISSTOPADV');
      SELECT mr.mrtype, af.actype, mst.groupleader, cf.t0loanrate
        INTO l_margintype, l_actype, l_groupleader, l_t0loanrate
        FROM afmast mst, aftype af, mrtype mr, cfmast cf
       WHERE mst.actype = af.actype
         AND af.mrtype = mr.actype
         AND mst.custid = cf.custid
         AND mst.acctno = pv_condvalue;

      IF l_margintype = 'N' or l_margintype = 'L'
      THEN
         --Tai khoan binh thuong khong Margin
         OPEN pv_refcursor FOR
            SELECT ci.actype, ci.acctno, ci.ccycd,
                   ci.afacctno, ci.custid, ci.opndate,
                   ci.clsdate, ci.lastdate, ci.dormdate,
                   ci.status, ci.pstatus,
                   af.advanceline - nvl(trft0amt,0) advanceline,
                   ci.balance - NVL (secureamt, 0) balance,
                   ci.balance + decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) avlbal,
                   ci.cramt,
                   ci.dramt, ci.crintacr,ci.CIDEPOFEEACR, ci.crintdt,
                   ci.odintacr, ci.odintdt, ci.avrbal,
                   ci.mdebit, ci.mcredit, ci.aamt, ci.ramt,
                   NVL (secureamt, 0) bamt, ci.emkamt, ci.mmarginbal,
                   ci.marginbal, ci.iccfcd, ci.iccftied,
                   ci.odlimit, ci.adintacr, ci.adintdt,
                   ci.facrtrade, ci.facrdepository, ci.facrmisc,
                   ci.minbal, ci.odamt, ci.dueamt, ci.ovamt, ci.namt, ci.floatamt,
                   ci.holdbalance, ci.pendinghold,
                   ci.pendingunhold, ci.corebank, ci.receiving,
                   ci.netting, ci.mblock, l_margintype mrtype,
                   round(
                    decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + nvl(balance,0) - nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - NVL (advamt, 0)- nvl(secureamt,0) +
                    /*advanceline */
                    --1.5.8.9
                    CASE WHEN nvl(af.deal,'N') = 'N'
                         THEN greatest(least(ROUND(least(nvl((ci.balance-NVL(b.secureamt,0)) + decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + v_getsec.senavamt -
                              NVL(ci.ovamt,0),0) * l_t0loanrate /100,nvl(v_getsec.SELIQAMT2,0))),af.advanceline),0)
                         ELSE af.advanceline END
                    - nvl(trft0amt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) - nvl(ramt,0) - ci.depofeeamt + least(af.mrcrlimitmax + af.mrcrlimit- ci.dfodamt,af.mrcrlimit)
                    ,0) pp,
                   round(
                    decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + nvl(balance,0) - nvl(odamt,0) - nvl(dfdebtamt,0) - nvl(dfintdebtamt,0) - NVL (advamt, 0)- nvl(secureamt,0) + advanceline
                    - nvl(trft0amt,0) - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) - nvl(ramt,0) - ci.depofeeamt + least(af.mrcrlimitmax + af.mrcrlimit - ci.dfodamt,af.mrcrlimit)
                    ,0) ppref,
                    decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0))
                   + AF.mrcrlimitmax +af.mrcrlimit - dfodamt +
                   /*advanceline */
                    --1.5.8.9
                    CASE WHEN nvl(af.deal,'N') = 'N'
                         THEN greatest(least(ROUND(least(nvl((ci.balance-NVL(b.secureamt,0)) + decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + v_getsec.senavamt -
                              NVL(ci.ovamt,0),0) * l_t0loanrate /100,nvl(v_getsec.SELIQAMT2,0))),af.advanceline),0)
                         ELSE af.advanceline END
                   - nvl(trft0amt,0)
                   + balance
                   - odamt
                   - dfdebtamt
                   - dfintdebtamt
                   - NVL (overamt, 0)
                   - NVL (secureamt, 0) - nvl(trfsecuredamt,0) - nvl(trft0addamt,0)
                   - ramt
                   - ci.depofeeamt avllimit,
                    decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0))
                   + AF.mrcrlimitmax +af.mrcrlimit - dfodamt
                   + af.advanceline - nvl(trft0amt,0)
                   + balance
                   - odamt
                   - dfdebtamt
                   - dfintdebtamt
                   - NVL (overamt, 0)
                   - NVL (secureamt, 0) - nvl(trfsecuredamt,0) - nvl(trft0addamt,0)
                   - ramt
                   - ci.depofeeamt avllimitt2,
                   decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) +
                   AF.mrcrlimitmax +least(af.mrcrlimit, NVL (secureamt, 0) + nvl(trfsecuredamt,0)+ nvl(trft0addamt,0))- dfodamt
                   + balance- trfbuyamt
                   - odamt
                   - dfdebtamt
                   - dfintdebtamt
                   - NVL (overamt, 0)
                   - NVL (secureamt, 0) - nvl(trfsecuredamt,0) - nvl(trft0addamt,0)
                   - ramt
                   - ci.depofeeamt avlmrlimit,
                   greatest(least(
                                    AF.mrcrlimitmax - dfodamt,
                                    AF.mrcrlimitmax - dfodamt + af.advanceline -odamt
                                    ),
                                0
                        ) deallimit,
                   0 navaccount, 0 outstanding,
                   0 NAVACCOUNTT2, 0 OUTSTANDINGT2, af.mrirate,
                   GREATEST (decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt
                             - odamt
                             - dfdebtamt
                             - dfintdebtamt
                             - NVL (advamt, 0)
                             - NVL (secureamt, 0)
                             - ramt
                             - nvl(pd.dealpaidamt,0)
                             - ci.depofeeamt,
                             0
                            ) avlwithdraw,
                   --Da co giao dich cap bao lanh ko duoc phep rut tien
                   CASE WHEN AF.ADVANCELINE>0 THEN 0 ELSE
                   greatest(
                        decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - NVL (overamt, 0) - nvl(secureamt,0) - ramt-nvl(pd.dealpaidamt,0) - ci.depofeeamt
                        ,0) END BALDEFOVD,
                   greatest(
                        decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - ramt-nvl(pd.dealpaidamt,0) - ci.depofeeamt
                                    - greatest(
                                            nvl(trfi.secureamt_inday,0)
                                            + (nvl(trfi.trfbuyamtnofee_inday,0) + nvl(trfbuyamtnofee,0)) * l_TRFBUYRATE
                                            ,
                                            nvl(b.buyamt,0) + nvl(b.buyfeeacr,0) - least(af.trfbuyrate/100* nvl(b.buyamt,0) + case when af.trfbuyrate > 0 then nvl(b.buyfeeacr,0) else 0 end, af.advanceline - nvl(b.trft0amt,0) )
                                            + nvl(b.trfsecuredamt,0)
                                            + nvl(b.trft0amt_over,0))
                        ,0) BALDEFTRFAMT,
                   greatest(
                        decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - ramt-nvl(pd.dealpaidamt,0) - ci.depofeeamt
                                    - greatest(0
                                            ,
                                            nvl(b.buyamt,0) + nvl(b.buyfeeacr,0) - least(af.trfbuyrate/100* nvl(b.buyamt,0) + case when af.trfbuyrate > 0 then nvl(b.buyfeeacr,0) else 0 end, af.advanceline - nvl(b.trft0amt,0) )
                                            + nvl(b.trfsecuredamt,0)
                                            + nvl(b.trft0amt_over,0))
                        ,0) BALDEFTRFAMTEX,

                   GREATEST (  round(least(decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt ,
                                    decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt  +
                                    af.advanceline -NVL (advamt, 0)-
                                    nvl(secureamt,0)-ramt
                            ),0
                   ) ,0) baldefovd_released,
                   dfdebtamt,
                   dfintdebtamt,
                   GREATEST ( decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) + balance - trfbuyamt
                             - odamt
                             - dfdebtamt
                             - dfintdebtamt
                             - NVL (advamt, 0)
                             - NVL (secureamt, 0)
                             - ramt
                             - nvl(pd.dealpaidamt,0),
                             0
                            ) baldefovd_released_depofee,  -- Su dung de check khi thu phi luu ky
                   decode(l_isstopadv,'Y',0,nvl(adv.avladvance,0)) avladvance, nvl(adv.advanceamount,0) advanceamount, nvl(adv.paidamt,0) paidamt,
                   nvl(b.EXECBUYAMT,0) EXECBUYAMT, nvl(pd.dealpaidamt,0) dealpaidamt, 0 SEASS, 10000 MARGINRATE,
                   ci.trfbuyamt,
                   --PhuongHT edit 29.02.2016
                    nvl(b.trfbuyamt_over,0) trfbuyamt_over, 0 set0amt,
                    (case when ci.balance  + nvl(adv.avladvance,0)  + NVL(lns.NYOVDAMT,0) - ci.odamt - ci.ramt>=0 then 10000000
                    else 0 end) rlsmarginrate_ex,
                    0 NYOVDAMT,
                    (case when ci.balance  + nvl(adv.avladvance,0)  + NVL(lns.NYOVDAMT,0) - ci.odamt - ci.ramt>=0 then 10000000
                    else 0 end) marginrate_Ex,
                    0 semaxtotalcallass,0 secallass,
                    0 CLAMT,0 navaccountt2_EX,
                    0 outstanding_EX,
                    0 navaccount_ex,10000000 MARGINRATE5,
                    0 outstanding5,0 ODAMT_EX,
                    0 outstandingT2_EX,
                    0 semaxcallass,
                    nvl(trfi.secureamt_inday,0) secureamt_inday,
                    nvl(trfi.trfsecuredamt_inday,0)trfsecuredamt_inday
                   -- end of PhuongHT edit ngay 29.02.2016

              FROM cimast ci INNER JOIN afmast af ON ci.acctno = af.acctno
                   LEFT JOIN (SELECT *
                                FROM v_getbuyorderinfo
                               WHERE afacctno = pv_condvalue) b
                               ON ci.acctno = b.afacctno
                   LEFT JOIN (SELECT *
                                FROM vw_trfbuyinfo_inday
                               WHERE afacctno = pv_condvalue) trfi
                               ON ci.acctno = trfi.afacctno
                   left join
                            (select sum(depoamt) avladvance,afacctno, sum(advamt) advanceamount, sum(paidamt) paidamt
                                from v_getAccountAvlAdvance
                                where afacctno = pv_condvalue group by afacctno) adv
                                on adv.afacctno=ci.acctno
                   LEFT JOIN
                            (select *
                                from v_getdealpaidbyaccount p
                                where p.afacctno = pv_CONDVALUE) pd
                            on pd.afacctno=ci.acctno
                   LEFT JOIN
                            (SELECT trfacctno,SUM(NYOVDAMT) NYOVDAMT
                             FROM (SELECT trfacctno,LN.ACCTNO,
                              sum((case when mintermdate >= l_currdate
                                then (lns.nml + lns.ovd + lns.intdue + lns.intovd + lns.feedue + lns.feeovd + lns.intovdprin + lns.intnmlacr
                                 + lns.feeintnmlacr + lns.feeintovdacr + lns.feeintnmlovd + lns.feeintdue + lns.nmlfeeint + lns.ovdfeeint + lns.feeintnml + lns.feeintovd )
                            else 0 end)
                             ) + MAX(nvl(LN.intnmlpbl,0)) NYOVDAMT
                            FROM lnschd lns, lnmast ln ,lntype lnt
                            WHERE lns.acctno = ln.acctno
                            AND  ln.actype = lnt.actype
                            and  lns.reftype = 'GP'
                            AND trfacctno = pv_CONDVALUE
                            group by trfacctno,LN.ACCTNO)
                            GROUP BY trfacctno
                            )lns
                            on ci.acctno=lns.trfacctno
                   --1.5.8.9
                   LEFT JOIN
                            (SELECT * FROM v_getsecmargininfo_ALL WHERE afacctno = pv_CONDVALUE) v_getsec
                            ON ci.acctno = v_getsec.afacctno
             WHERE ci.acctno = pv_condvalue;
      ELSIF     l_margintype in  ('S','T')
            AND (LENGTH (l_groupleader) = 0 OR l_groupleader IS NULL)
      THEN
            select count(1)
                into l_count
            from afmast af
            where af.acctno = pv_condvalue
            and (exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y')
                or exists (select 1 from afidtype afi, lntype lnt where afi.aftype = af.actype and afi.objname = 'LN.LNTYPE' and afi.actype = lnt.actype and lnt.chksysctrl = 'Y'));

            if l_count > 0 then
                l_isMarginAcc:='Y';
            else
                l_isMarginAcc:='N';
            end if;


            -- Day la tieu khoan gan loai hinh mac dinh la tuan thu.
            select count(1)
                into l_count
            from afmast af
            where af.acctno = pv_condvalue
            and exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y');

            if l_count > 0 then
                l_isChkSysCtrlDefault:='Y';
            else
                l_isChkSysCtrlDefault:='N';
            end if;
         --Tai khoan margin khong tham gia group
         OPEN pv_refcursor FOR
                SELECT
                ACTYPE,ACCTNO,CCYCD,AFACCTNO,CUSTID,OPNDATE,CLSDATE,LASTDATE,
                DORMDATE,STATUS,PSTATUS,(ADVANCELINE-trft0amt) ADVANCELINE, BALANCE,AVLBAL,CRAMT,DRAMT,CRINTACR, cidepofeeacr, CRINTDT,ODINTACR,ODINTDT,
                AVRBAL,MDEBIT,MCREDIT,AAMT,RAMT,BAMT,EMKAMT,MMARGINBAL,MARGINBAL,ICCFCD,ICCFTIED,
                ODLIMIT,ADINTACR,ADINTDT,FACRTRADE,FACRDEPOSITORY,FACRMISC,MINBAL,ODAMT,dueamt, ovamt,NAMT,FLOATAMT,
                HOLDBALANCE,PENDINGHOLD,PENDINGUNHOLD,COREBANK,RECEIVING,NETTING,MBLOCK,l_margintype mrtype,PP,PPREF,AVLLIMIT,AVLLIMITT2,AVLMRLIMIT,DEALLIMIT,
                NAVACCOUNT,OUTSTANDING,NAVACCOUNTT2, OUTSTANDINGT2,MRIRATE,
                TRUNC(
                    GREATEST(
                        (CASE WHEN MRIRATE>0 THEN least(NAVACCOUNT*100/MRIRATE + (OUTSTANDING-(ADVANCELINE-trft0amt)),AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE NAVACCOUNT + OUTSTANDING END)
                    ,0) - DEALPAIDAMT
                ,0) AVLWITHDRAW,
                --Neu co bao lanh T0 thi khong duoc rut
                CASE WHEN ADVANCELINE>0 THEN 0 ELSE
                greatest(case when l_isChkSysCtrlDefault = 'Y' then
                    least(
                        (MARGINRATIO/100 - MRIRATIO/100) * (serealass) + greatest(0,balance+nvl(bamt,0)+nvl(avladvance,0)-ovamt-dueamt-depofeeamt)
                        ,
                       TRUNC(
                        --(CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNT + (OUTSTANDING-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
                        -- HaiLT sua ct rut tien thuong theo y/c MR001
                        (CASE WHEN MRIRATE>0  THEN LEAST(PP,BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
                        - DEALPAIDAMT
                    ,0))
                else
                    TRUNC(
                        --(CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNT + (OUTSTANDING-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
                        -- HaiLT sua ct rut tien thuong theo y/c MR001
                        (CASE WHEN MRIRATE>0  THEN LEAST(PP,BALDEFOVD,AVLLIMIT-(ADVANCELINE-trft0amt)) ELSE BALDEFOVD END)
                        - DEALPAIDAMT
                    ,0)
                end,0) END BALDEFOVD,
                greatest(case when l_isChkSysCtrlDefault = 'Y' then
                    least(
                        (MARGINRATIO/100 - MRIRATIO/100) * (serealass) + greatest(0,balance+nvl(bamt,0)+nvl(avladvance,0)-ovamt-dueamt-depofeeamt)
                        ,
                       TRUNC(
                        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNTT2 + (OUTSTANDINGT2-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFTRFAMT,AVLLIMITT2-(ADVANCELINE-trft0amt)) ELSE BALDEFTRFAMT END)
                        - DEALPAIDAMT
                    ,0))
                else
                    TRUNC(
                        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNTT2 + (OUTSTANDINGT2-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFTRFAMT,AVLLIMITT2-(ADVANCELINE-trft0amt)) ELSE BALDEFTRFAMT END)
                        - DEALPAIDAMT
                    ,0)
                end,0) BALDEFTRFAMT,
                greatest(case when l_isChkSysCtrlDefault = 'Y' then
                    least(
                        (MARGINRATIO/100 - MRIRATIO/100) * (serealass) + greatest(0,balance+nvl(bamt,0)+nvl(avladvance,0)-ovamt-dueamt-depofeeamt)
                        ,
                       TRUNC(
                        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNTT2 + (OUTSTANDINGT2EX-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFTRFAMT,AVLLIMITT2-(ADVANCELINE-trft0amt)) ELSE BALDEFTRFAMT END)
                        - DEALPAIDAMT
                    ,0))
                else
                    TRUNC(
                        (CASE WHEN MRIRATE>0  THEN LEAST(GREATEST((100* NAVACCOUNTT2 + (OUTSTANDINGT2EX-(ADVANCELINE-trft0amt)) * MRIRATE)/MRIRATE,0),BALDEFTRFAMT,AVLLIMITT2-(ADVANCELINE-trft0amt)) ELSE BALDEFTRFAMT END)
                        - DEALPAIDAMT
                    ,0)
                end,0) BALDEFTRFAMTEX,
                baldefovd_Released,
                DFDEBTAMT, dfintdebtamt,
                TRUNC
                ((CASE
                     WHEN mrirate > 0
                        THEN LEAST (GREATEST (  (  100 * navaccount
                                                 +   (  outstanding + depofeeamt
                                                      - (advanceline-nvl(trft0amt,0))
                                                     )
                                                   * mrirate
                                                )
                                              / mrirate,
                                              0
                                             ),
                                    baldefovd + depofeeamt,
                                    avllimit + depofeeamt - (advanceline-nvl(trft0amt,0))
                                   )
                     ELSE baldefovd + depofeeamt
                  END
                 ) - dealpaidamt ,
                 0
                ) Baldefovd_Released_Depofee,  -- Su dung de check khi thu phi luu ky
                avladvance, advanceamount, paidamt, EXECBUYAMT, dealpaidamt, SEASS, MARGINRATE,
                trfbuyamt,
                --PhuongHT edit ngay 29.02.2016
                trfbuyamt_over,set0amt, rlsmarginrate_ex,
                NYOVDAMT, marginrate_Ex,
                semaxtotalcallass, secallass,
                CLAMT,navaccountt2_EX,
                outstanding_EX,
                navaccount_ex, MARGINRATE5,
                outstanding5,ODAMT_EX,
                outstandingT2_EX,
                semaxcallass,
                secureamt_inday,
                trfsecuredamt_inday
                 -- end of PhuongHT edit ngay 29.02.2016

                FROM
                    (SELECT cidepofeeacr, af.advanceline,ci.actype,ci.acctno,ci.ccycd,ci.afacctno,ci.custid,ci.opndate,ci.clsdate,ci.lastdate,ci.dormdate,ci.status,ci.pstatus,
                        ci.balance-nvl(secureamt,0) balance,
                        ci.balance + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) avlbal,
                        ci.DFDEBTAMT,
                        ci.cramt,ci.dramt,ci.crintacr,ci.crintdt,ci.odintacr,ci.odintdt,ci.avrbal,ci.mdebit,ci.mcredit,ci.aamt,ci.ramt,
                        nvl(secureamt,0) bamt,
                        ci.emkamt,ci.mmarginbal,ci.marginbal,ci.iccfcd,ci.iccftied,ci.odlimit,ci.adintacr,ci.adintdt,
                        ci.facrtrade,ci.facrdepository,ci.facrmisc,ci.minbal,ci.odamt,ci.namt,ci.floatamt,ci.holdbalance,
                        ci.pendinghold,ci.pendingunhold,ci.corebank,ci.receiving,ci.netting,ci.mblock, ci.dfintdebtamt,
                        greatest(
                             decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance /*- trfbuyamt*/ - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt /*- NVL (overamt, 0) - nvl(secureamt,0)*/ - ramt-nvl(se.dealpaidamt,0) - ci.depofeeamt
                             ,0) BALDEFOVD,
                        greatest(
                             decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance - ovamt - dueamt - ci.dfdebtamt - ci.dfintdebtamt - ramt-nvl(se.dealpaidamt,0) - ci.depofeeamt
                                         /*- greatest(0, nvl(se.buyamt,0) + nvl(se.buyfeeacr,0) - least(af.trfbuyrate/100* nvl(se.buyamt,0) + case when af.trfbuyrate > 0 then nvl(se.buyfeeacr,0) else 0 end, af.advanceline - nvl(se.trft0amt,0) )
                                                 + nvl(trfsecuredamt,0)
                                                 + nvl(se.trft0addamt,0))*/
                             ,0) baldeftrfamt,
                        greatest(ci.balance - trfbuyamt - nvl(se.secureamt,0) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - af.advanceline,0) BALDEFOVD_RLSODAMT ,
                        greatest(round(least(decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance - trfbuyamt ,decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + balance - trfbuyamt  + af.advanceline -NVL (advamt, 0)-nvl(secureamt,0)-ramt),0) ,0) baldefovd_released,
                        case when l_isChkSysCtrlDefault = 'Y' then
                             least(
                             round(ci.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                                 - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+ nvl(af.mrcrlimit,0)  - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.semramt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt - ci.depofeeamt,0),
                             round(ci.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                                 - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+ nvl(af.mrcrlimit,0)  - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                             )
                        else
                             round(ci.balance - (nvl(se.buyamt,0) * (1-af.trfbuyrate/100) + (case when af.trfbuyrate > 0 then 0 else nvl(se.buyfeeacr,0) end))
                                 - nvl(trft0addamt,0) -nvl(trfsecuredamt,0) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+ nvl(af.mrcrlimit,0)  - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.seamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                        end PP,
                        case when l_isChkSysCtrlDefault = 'Y' then
                             least(
                             round(ci.balance - nvl(se.secureamt,0) - nvl(se.overamt,0)
                                 - ci.trfbuyamt + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+ nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.setotalmramt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt - ci.depofeeamt,0),
                             round(ci.balance - nvl(se.secureamt,0) - nvl(se.overamt,0)
                                 - ci.trfbuyamt + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0)+ nvl(af.mrcrlimit,0) - dfodamt,nvl(af.mrcrlimit,0) + nvl(se.setotalamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                             )
                        else
                             round(ci.balance - nvl(se.secureamt,0) - nvl(se.overamt,0)
                                 - ci.trfbuyamt + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + least(nvl(se.mrcrlimitmax,0) + nvl(af.mrcrlimit,0)- dfodamt,nvl(af.mrcrlimit,0) + nvl(se.setotalamt,0)) - nvl(ci.odamt,0) - ci.dfdebtamt - ci.dfintdebtamt - ramt  - ci.depofeeamt,0)
                        end PPREF,
                        round(
                            decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + nvl(af.advanceline,0) - nvl(trft0amt,0) - nvl(trfsecuredamt,0) + nvl(se.mrcrlimitmax,0) + nvl(af.mrcrlimit,0)- dfodamt + balance - odamt - ci.dfdebtamt - ci.dfintdebtamt - nvl(secureamt,0) - ramt - ci.depofeeamt
                        ,0) AVLLIMIT,
                        round(
                            decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + nvl(af.advanceline,0) - nvl(trfsecuredamt,0) + nvl(se.mrcrlimitmax,0)+ nvl(af.mrcrlimit,0)- dfodamt + balance - odamt - ci.dfdebtamt - ci.dfintdebtamt -nvl(trf.trfsecuredamt_inday,0)-nvl(trf.secureamt_inday,0) - ramt - ci.depofeeamt
                        ,0) AVLLIMITT2,
                        decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) + nvl(se.mrcrlimitmax,0) +least(nvl(af.mrcrlimit,0),nvl(secureamt,0))- dfodamt + balance - trfbuyamt - odamt - ci.dfdebtamt - ci.dfintdebtamt  - nvl(secureamt,0) - ramt - ci.depofeeamt  avlmrlimit,
                        greatest(least(nvl(se.mrcrlimitmax,0) - dfodamt,
                                nvl(se.mrcrlimitmax,0) - dfodamt + nvl(af.advanceline,0) -odamt),0) deallimit,
                        least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SETOTALCALLASS,0),nvl(SE.mrcrlimitmax,0) - dfodamt) NAVACCOUNT,
                        least(/*nvl(af.MRCRLIMIT,0) +*/ nvl(se.SET0CALLASS,0),nvl(SE.mrcrlimitmax,0) - dfodamt) NAVACCOUNTT2,
                        nvl(af.advanceline,0) - nvl(trft0amt,0) + ci.balance - trfbuyamt + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - NVL (se.advamt, 0)-nvl(se.secureamt,0) - ci.ramt OUTSTANDING, --kHI DAT LENH THI THEM PHAN T0
                        least(nvl(af.advanceline,0)  - nvl(trft0amt,0) + ci.balance + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - ci.ramt - nvl(se.trft0amt_over,0)
                                    -nvl(trf.trfsecuredamt_inday,0) - nvl(se.trfsecuredamt,0) -nvl(trf.secureamt_inday,0)
                                    + least(nvl(af.mrcrlimit,0),nvl(trf.trfsecuredamt_inday,0) + nvl(se.trfsecuredamt,0) +nvl(trf.secureamt_inday,0)+nvl(se.trft0amt_over,0)),
                                nvl(af.advanceline,0)  - nvl(trft0amt,0) + ci.balance + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - ci.ramt
                                    -(nvl(trf.trfbuyamtnofee_inday,0)+nvl(trfbuyamtnofee,0)) * l_TRFBUYRATE - nvl(trf.secureamt_inday,0)
                                    + least(nvl(af.mrcrlimit,0),nvl(trf.secureamt_inday,0)+(nvl(trf.trfbuyamtnofee_inday,0)+nvl(trfbuyamtnofee,0)) * l_TRFBUYRATE)
                                ) OUTSTANDINGT2,
                        nvl(af.advanceline,0)  - nvl(trft0amt,0) + ci.balance + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - ci.odamt - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt - ci.ramt - nvl(se.trft0amt_over,0)
                                    -nvl(trf.trfsecuredamt_inday,0) - nvl(se.trfsecuredamt,0) -nvl(trf.secureamt_inday,0)
                                    +least(nvl(af.mrcrlimit,0),nvl(trf.trfsecuredamt_inday,0) + nvl(se.trfsecuredamt,0) +nvl(trf.secureamt_inday,0)+nvl(se.trft0amt_over,0))  OUTSTANDINGT2EX,
                        af.mrirate,nvl(se.dealpaidamt,0) dealpaidamt,
                        se.chksysctrl, nvl(se.trft0amt,0) trft0amt,
                        decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) avladvance, nvl(se.advanceamount,0) advanceamount, nvl(se.paidamt,0) paidamt,
                        nvl(se.EXECBUYAMT,0) EXECBUYAMT, nvl(se.SEASS,0) SEASS, nvl(se.MARGINRATE,0) MARGINRATE , nvl(margin74amt,0) margin74amt, nvl(serealass,0) serealass,
                        af.MRIRATIO, nvl(MARGINRATIO,0) MARGINRATIO, depofeeamt, dueamt, ovamt, ci.trfbuyamt,
                        --PhuongHT edit ngay 29.02.2016
                        nvl(se.trfbuyamt_over,0) trfbuyamt_over, nvl(se.set0amt,0) set0amt,nvl(se.rlsmarginrate_ex,0) rlsmarginrate_ex,
                        nvl(se.NYOVDAMT,0) NYOVDAMT,nvl(se.marginrate_ex,0) marginrate_Ex,
                        nvl(se.semaxtotalcallass,0) semaxtotalcallass,nvl(secallass,0) secallass,
                        nvl(se.navaccount,0) CLAMT,nvl(se.navaccountt2,0) navaccountt2_EX,
                        nvl(se.outstanding,0)+nvl(se.NYOVDAMT,0) outstanding_EX,
                        nvl(se.navaccount,0) navaccount_ex,nvl(se.MARGINRATE5,0) MARGINRATE5,
                        nvl(se.outstanding,0)outstanding5,
                        abs(ci.balance +LEAST(nvl(af.MRCRLIMIT,0), nvl(secureamt,0)+ trfbuyamt) + decode(l_isstopadv,'Y',0,nvl(se.avladvance,0)) - trfbuyamt - ci.odamt - nvl(secureamt,0) - ci.ramt) odAMT_EX,
                        nvl(se.outstandingt2,0)+nvl(se.NYOVDAMT,0) outstandingT2_EX,
                        nvl(se.semaxcallass,0) semaxcallass,
                        nvl(trf.secureamt_inday,0) secureamt_inday,
                        nvl(trf.trfsecuredamt_inday,0)trfsecuredamt_inday
                        -- end of PhuongHT edit ngay 29.02.2016

                   from cimast ci inner join afmast af on ci.acctno=af.acctno
                        left join (select * from v_getsecmarginratio where afacctno = pv_CONDVALUE) se on se.afacctno=ci.acctno
                        left join (select * from vw_trfbuyinfo_inday where afacctno = pv_CONDVALUE) trf on trf.afacctno=ci.acctno
                        left join (select TRFACCTNO, nvl(sum(ln.PRINOVD + ln.INTOVDACR + ln.INTNMLOVD + ln.OPRINOVD + ln.OPRINNML + ln.OINTNMLOVD + ln.OINTOVDACR+ln.OINTDUE+ln.OINTNMLACR + nvl(lns.nml,0) + nvl(lns.intdue,0)),0) OVDAMT,
                                                       nvl(sum(ln.PRINNML - nvl(nml,0)+ ln.INTNMLACR),0) NMLMARGINAMT,
                                            nvl(sum(decode(lnt.chksysctrl,'Y',1,0)*(ln.prinnml+ln.prinovd+ln.intnmlacr+ln.intdue+ln.intovdacr+ln.intnmlovd+ln.feeintnmlacr+ln.feeintdue+ln.feeintovdacr+ln.feeintnmlovd)),0) margin74amt
                                        from lnmast ln, lntype lnt, (select acctno, sum(nml) nml, sum(intdue) intdue  from lnschd
                                                            where reftype = 'P' and  overduedate = to_date(cspks_system.fn_get_sysvar('SYSTEM','CURRDATE'),'DD/MM/RRRR') group by acctno) lns
                                        where ln.actype = lnt.actype and ln.acctno = lns.acctno(+) and ln.ftype = 'AF'
                                        and ln.trfacctno = pv_CONDVALUE
                                        group by ln.trfacctno) OVDAF on OVDAF.TRFACCTNO = ci.acctno
                        left join (select afacctno, sum(amt) receivingamt from stschd where afacctno = pv_CONDVALUE and duetype = 'RM' and status <> 'C' and deltd <> 'Y' group by afacctno) sts_rcv
                                on ci.acctno = sts_rcv.afacctno
                   WHERE ci.acctno = pv_CONDVALUE);

      ELSE
         --Tai khoan margin join theo group
         SELECT LEAST(SUM((NVL(AF.MRCRLIMIT,0) + NVL(SE.SEAMT,0)+
                                    NVL(adv.avladvance,0)))
                            ,sum(nvl(adv.avladvance,0)+ greatest(NVL(AF.MRCRLIMITMAX,0)+NVL(AF.MRCRLIMIT,0)- dfodamt,0)))
                       + sum(BALANCE - ODAMT- dfdebtamt- dfintdebtamt - NVL (ADVAMT, 0)-NVL(SECUREAMT,0) -nvl(trfsecuredamt,0)-nvl(TRFT0ADDAMT,0) - RAMT - ci.depofeeamt) PP,
                GREATEST (SUM ( NVL (AF.mrcrlimitmax, 0)+ NVL(AF.MRCRLIMIT,0) - dfodamt
                               + balance
                               - odamt
                               - dfdebtamt
                               - dfintdebtamt
                               - NVL (secureamt, 0)
                               - ramt
                               - ci.depofeeamt
                              ),
                          0
                         ) avllimit,
                greatest(least(sum(nvl(AF.mrcrlimitmax,0) - dfodamt),
                        sum(nvl(AF.mrcrlimitmax,0) - dfodamt + nvl(af.advanceline,0) -odamt)),0) deallimit,
                GREATEST (SUM (nvl(adv.avladvance,0) + balance - trfbuyamt - dfdebtamt
                             - dfintdebtamt- ovamt - dueamt - ramt- ci.depofeeamt), 0) baldefovd,
                greatest(round(least(sum(nvl(adv.avladvance,0) + balance- trfbuyamt ),
                                    sum(nvl(adv.avladvance,0) + balance- trfbuyamt  +
                                    af.advanceline -NVL (advamt, 0)-
                                    nvl(secureamt,0)-ramt)
                            ),0
                   ),0) baldefovd_released,
                SUM (  /*NVL (af.mrcrlimit, 0)
                     +*/ NVL (se.seass, 0)
                    ) navaccount,
                SUM (  ci.balance- trfbuyamt
                     + NVL (adv.avladvance, 0)
                     - ci.odamt
                     - ci.dfdebtamt
                     - ci.dfintdebtamt
                     - NVL (b.secureamt, 0)
                     - ci.ramt
                     + least(nvl(af.mrcrlimit,0),NVL (b.secureamt, 0))
                    ) outstanding,
                SUM (CASE
                        WHEN af.acctno <> pv_condvalue
                           THEN 0
                        ELSE af.mrirate
                     END) mrirate,
                GREATEST (SUM (nvl(adv.avladvance,0) + balance - trfbuyamt - dfdebtamt
                             - dfintdebtamt- ovamt - dueamt - ramt), 0) baldefovd_released_depofee, -- Su dung de check khi thu phi luu ky,
                nvl(adv.avladvance,0) avladvance, nvl(adv.advanceamount,0) advanceamount, nvl(adv.paidamt,0) paidamt,
                nvl(b.EXECBUYAMT,0) EXECBUYAMT
           INTO l_pp,
                l_avllimit,
                l_deallimit,
                l_baldefovd,
                l_baldefovd_Released,
                l_navaccount_EX,
                l_outstanding,
                l_mrirate,
                l_baldefovd_Released_depofee,
                l_avladvance,
                l_advanceamount,
                l_paidamt,
                l_EXECBUYAMT
           FROM cimast ci INNER JOIN afmast af ON ci.acctno = af.acctno
                                          AND af.groupleader = l_groupleader
                LEFT JOIN (SELECT b.*
                             FROM v_getbuyorderinfo b, afmast af
                            WHERE b.afacctno = af.acctno
                              AND af.groupleader = l_groupleader) b ON ci.acctno =
                                                                         b.afacctno
                LEFT JOIN (SELECT b.*
                             FROM v_getsecmargininfo b, afmast af
                            WHERE b.afacctno = af.acctno
                              AND af.groupleader = l_groupleader) se ON se.afacctno =
                                                                          ci.acctno
                left join
                        (select sum(depoamt) avladvance,afacctno, sum(advamt) advanceamount, sum(paidamt) paidamt
                            from v_getAccountAvlAdvance b , afmast af where b.afacctno =af.acctno and af.groupleader=l_groupleader group by afacctno) adv
                        on adv.afacctno=ci.acctno
                ;

         OPEN pv_refcursor FOR
            SELECT ci.actype, ci.acctno, ci.ccycd,
                   ci.afacctno, ci.custid, ci.opndate,
                   ci.clsdate, ci.lastdate, ci.dormdate,
                   ci.status, ci.pstatus,
                   af.advanceline - nvl(trft0amt,0) advanceline,
                   ci.balance  - NVL (secureamt, 0) balance,
                   ci.balance + l_avladvance avlbal,
                   ci.cramt,
                   ci.dramt, ci.crintacr,ci.CIDEPOFEEACR, ci.crintdt,
                   ci.odintacr, ci.odintdt, ci.avrbal,
                   ci.mdebit, ci.mcredit, ci.aamt, ci.ramt,
                   NVL (secureamt, 0) bamt, ci.emkamt, ci.mmarginbal,
                   ci.marginbal, ci.iccfcd, ci.iccftied,
                   ci.odlimit, ci.adintacr, ci.adintdt,
                   ci.facrtrade, ci.facrdepository, ci.facrmisc,
                   ci.minbal, ci.odamt, ci.namt, ci.floatamt,
                   ci.holdbalance, ci.pendinghold,
                   ci.pendingunhold, ci.corebank, ci.receiving,
                   ci.netting, ci.mblock,l_margintype mrtype,
                   greatest(NVL (af.advanceline, 0) + l_pp,0) pp,
                   NVL (af.advanceline, 0) - nvl(trft0amt,0) + l_avllimit avllimit,
                   l_avllimit avlmrlimit,l_deallimit deallimit,
                   l_navaccount_EX navaccount, l_outstanding outstanding,
                   l_mrirate mrirate,
                   TRUNC
                      (GREATEST ((CASE
                                     WHEN l_mrirate > 0
                                        THEN   least(l_navaccount * 100 / l_mrirate
                                             + l_outstanding,l_avllimit)
                                     ELSE l_navaccount + l_outstanding
                                  END
                                 )- nvl(pd.dealpaidamt,0),
                                 0
                                ),
                       0
                      ) avlwithdraw,
                   TRUNC
                      ((CASE
                           WHEN l_mrirate > 0
                              THEN LEAST (GREATEST (  (  100 * l_navaccount
                                                       +   l_outstanding
                                                         * l_mrirate
                                                      )
                                                    / l_mrirate,
                                                    0
                                                   ),
                                          --l_baldefovd,
                                          greatest(balance- trfbuyamt - dfdebtamt-dfintdebtamt - ovamt-dueamt - ramt-af.advanceline,0),
                                          l_avllimit
                                         )
                           ELSE GREATEST (  balance- trfbuyamt
                                          - odamt
                                          - dfdebtamt-dfintdebtamt
                                          - NVL (advamt, 0)
                                          - NVL (secureamt, 0)
                                          - ramt,
                                          0
                                         )
                        END
                       ) - nvl(pd.dealpaidamt,0) - ci.depofeeamt,
                       0
                      ) baldefovd,
                      l_baldefovd_Released baldefovd_Released,
                      dfdebtamt, dfintdebtamt,
                      TRUNC
                      ((CASE
                           WHEN l_mrirate > 0
                              THEN LEAST (GREATEST (  (  100 * l_navaccount
                                                       +   l_outstanding
                                                         * l_mrirate
                                                      )
                                                    / l_mrirate,
                                                    0
                                                   ),
                                          --l_baldefovd,
                                          greatest(balance- trfbuyamt - dfdebtamt-dfintdebtamt - ovamt-dueamt - ramt-af.advanceline,0),
                                          l_avllimit
                                         )
                           ELSE GREATEST (  balance- trfbuyamt
                                          - odamt
                                          - dfdebtamt-dfintdebtamt
                                          - NVL (advamt, 0)
                                          - NVL (secureamt, 0)
                                          - ramt,
                                          0
                                         )
                        END
                       ) - nvl(pd.dealpaidamt,0),
                       0
                      ) baldefovd_Released_depofee, -- Su dung check khi thu phi luu ky
                      l_avladvance avladvance,
                        l_advanceamount advanceamount,
                        l_paidamt paidamt, l_EXECBUYAMT EXECBUYAMT, nvl(pd.dealpaidamt,0) dealpaidamt, nvl(se.SEASS,0) SEASS, nvl(se1.MARGINRATE,0) MARGINRATE,
                        --PhuongHT edit ngay 29.02.2016
                        0 trfbuyamt_over, 0 set0amt,0 rlsmarginrate_ex,
                        0 NYOVDAMT,0 marginrate_Ex,
                        0 semaxtotalcallass,0 secallass,
                        0 CLAMT,0 navaccountt2_EX,
                        0 outstanding_EX,
                        0 navaccount_ex,0 MARGINRATE5,
                        0 outstanding5,0 ODAMT_EX,
                        0  outstandingT2_EX,
                        0 semaxcallass,
                        0 secureamt_inday,
                        0 trfsecuredamt_inday
                        -- end of PhuongHT edit ngay 29.02.2016
              FROM cimast ci INNER JOIN afmast af ON ci.acctno = af.acctno
                   LEFT JOIN (SELECT *
                                FROM v_getbuyorderinfo
                               WHERE afacctno = pv_condvalue) b ON ci.acctno =
                                                                     b.afacctno
                   LEFT JOIN (SELECT *
                                FROM v_getsecmargininfo se
                               WHERE se.afacctno = pv_condvalue) se ON se.afacctno =
                                                                         ci.acctno
                   LEFT JOIN (SELECT  AFACCTNO, MARGINRATE
                                FROM v_getsecmarginratio se
                               WHERE se.afacctno = pv_condvalue) se1 ON se1.afacctno =
                                                                         ci.acctno
                   LEFT JOIN
                              (select *
                                  from v_getdealpaidbyaccount p where p.afacctno = pv_condvalue) pd
                              on pd.afacctno=ci.acctno
             WHERE ci.acctno = pv_condvalue;
      END IF;

      l_i := 0;
      LOOP
         FETCH pv_refcursor
          INTO l_cimastcheck_rectype;

         l_cimastcheck_arrtype (l_i) := l_cimastcheck_rectype;
         EXIT WHEN pv_refcursor%NOTFOUND;
         l_i := l_i + 1;
      END LOOP;
      --close pv_refcursor;
      /*FETCH pv_refcursor
          bulk collect INTO l_cimastcheck_arrtype;
      close pv_refcursor;*/
      RETURN l_cimastcheck_arrtype;
   EXCEPTION
      WHEN OTHERS
      THEN
         if pv_refcursor%ISOPEN THEN
            CLOSE pv_refcursor;
         END IF;
         RETURN l_cimastcheck_arrtype;
   END fn_cimastcheck;

   FUNCTION fn_semastcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN semastcheck_arrtype
   IS
      l_semastcheck_rectype   semastcheck_rectype;
      l_semastcheck_arrtype   semastcheck_arrtype;
      l_i                     NUMBER (10);
      pv_refcursor            pkg_report.ref_cursor;
      l_txdate                DATE;
      l_setype                setype.actype%TYPE;
      l_custid                semast.custid%TYPE;
   BEGIN                                                               -- Proc
      SELECT TO_DATE (varvalue, 'DD/MM/YYYY')
        INTO l_txdate
        FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

      OPEN pv_refcursor FOR
         SELECT semast.actype, semast.acctno, semast.codeid, semast.afacctno,
                semast.opndate, semast.clsdate, semast.lastdate,
                semast.status, semast.pstatus, semast.irtied, semast.ircd,
                semast.costprice, greatest(semast.trade - NVL (b.secureamt, 0) + NVL(b.sereceiving,0),0) trade,
                semast.mortage - NVL (b.securemtg, 0) mortage,nvl(df.sumdfqtty,0) - NVL (b.securemtg, 0) dfmortage, semast.margin,
                semast.netting, abs(semast.standing)standing, semast.withdraw,
                semast.deposit, semast.loan, semast.blocked, semast.receiving,
                semast.transfer, semast.prevqtty, semast.dcrqtty,
                semast.dcramt, semast.depofeeacr, semast.repo, semast.pending,
                semast.tbaldepo, semast.custid, semast.costdt,
                NVL (b.securemtg, 0) + NVL (b.secureamt, 0) secured,
                semast.iccfcd, semast.iccftied, semast.tbaldt,
                semast.senddeposit, semast.sendpending, semast.ddroutqtty,
                semast.ddroutamt, semast.dtoclose, semast.sdtoclose,
                semast.qtty_transfer,
                greatest(semast.trade - nvl(b.secureamt,0) + nvl(b.sereceiving,0),0) trading
           FROM semast, v_getsellorderinfo b,
           (SELECT afacctno,codeid, sum(dfqtty) sumdfqtty FROM dfmast GROUP BY afacctno, codeid) df
          WHERE acctno = pv_condvalue AND acctno = b.seacctno(+) AND df.afacctno(+) = semast.afacctno AND df.codeid(+) = semast.codeid;

      l_i := 0;

      LOOP
         FETCH pv_refcursor
          INTO l_semastcheck_rectype;
         EXIT WHEN pv_refcursor%NOTFOUND;
         l_semastcheck_arrtype (l_i) := l_semastcheck_rectype;
         l_i := l_i + 1;
      END LOOP;
      --close pv_refcursor;
      /*FETCH pv_refcursor
          bulk collect INTO l_semastcheck_arrtype;
      close pv_refcursor;*/

      IF (l_semastcheck_arrtype.count) <= 0
      THEN
         --Securities account does not exits
         --Automatic open sub securities account
         SELECT aft.setype, af.custid
           INTO l_setype, l_custid
           FROM afmast af, aftype aft
          WHERE af.actype = aft.actype AND af.acctno = SUBSTR(pv_condvalue,1,10);

         INSERT INTO semast
                     (actype, custid, acctno,
                      codeid,
                      afacctno, opndate, lastdate,
                      costdt, tbaldt, status, irtied, ircd, costprice, trade,
                      mortage, margin, netting, standing, withdraw, deposit,
                      loan
                     )
              VALUES (l_setype, l_custid, pv_condvalue,
                      SUBSTR (pv_condvalue, 11, 6),
                      SUBSTR (pv_condvalue, 1, 10), l_txdate, l_txdate,
                      l_txdate, l_txdate, 'A', 'Y', '000', 0, 0,
                      0, 0, 0, 0, 0, 0,
                      0
                     )
           RETURNING actype,
                     custid,
                     acctno,
                     codeid,
                     afacctno,
                     opndate,
                     lastdate,
                     costdt,
                     tbaldt,
                     status,
                     irtied,
                     ircd,
                     costprice,
                     trade,
                     mortage,
                     margin,
                     netting,
                     standing,
                     withdraw,
                     deposit,
                     loan,
                     l_txdate,    --      clsdate         semast.clsdate%TYPE,
                     '',          --      pstatus         semast.pstatus%TYPE,
                     0,           --      blocked         semast.blocked%TYPE,
                     0,         --      receiving       semast.receiving%TYPE,
                     0,          --      transfer        semast.transfer%TYPE,
                     0,          --      prevqtty        semast.prevqtty%TYPE,
                     0,           --      dcrqtty         semast.dcrqtty%TYPE,
                     0,            --      dcramt          semast.dcramt%TYPE,
                     0,        --      depofeeacr      semast.depofeeacr%TYPE,
                     0,              --      repo            semast.repo%TYPE,
                     0,           --      pending         semast.pending%TYPE,
                     0,          --      tbaldepo        semast.tbaldepo%TYPE,
                     0,           --      secured         semast.secured%TYPE,
                     '',           --      iccfcd          semast.iccfcd%TYPE,
                     '',         --      iccftied        semast.iccftied%TYPE,
                     0,       --      senddeposit     semast.senddeposit%TYPE,
                     0,       --      sendpending     semast.sendpending%TYPE,
                     0,        --      ddroutqtty      semast.ddroutqtty%TYPE,
                     0,         --      ddroutamt       semast.ddroutamt%TYPE,
                     0,          --      dtoclose        semast.dtoclose%TYPE,
                     0,         --      sdtoclose       semast.sdtoclose%TYPE,
                     0,       --      qtty_transfer   semast.qtty_transfer%TYPE
                     0
                INTO l_semastcheck_arrtype (0).actype,
                     l_semastcheck_arrtype (0).custid,
                     l_semastcheck_arrtype (0).acctno,
                     l_semastcheck_arrtype (0).codeid,
                     l_semastcheck_arrtype (0).afacctno,
                     l_semastcheck_arrtype (0).opndate,
                     l_semastcheck_arrtype (0).lastdate,
                     l_semastcheck_arrtype (0).costdt,
                     l_semastcheck_arrtype (0).tbaldt,
                     l_semastcheck_arrtype (0).status,
                     l_semastcheck_arrtype (0).irtied,
                     l_semastcheck_arrtype (0).ircd,
                     l_semastcheck_arrtype (0).costprice,
                     l_semastcheck_arrtype (0).trade,
                     l_semastcheck_arrtype (0).mortage,
                     l_semastcheck_arrtype (0).margin,
                     l_semastcheck_arrtype (0).netting,
                     l_semastcheck_arrtype (0).standing,
                     l_semastcheck_arrtype (0).withdraw,
                     l_semastcheck_arrtype (0).deposit,
                     l_semastcheck_arrtype (0).loan,
                     l_semastcheck_arrtype (0).clsdate,
                     l_semastcheck_arrtype (0).pstatus,
                     l_semastcheck_arrtype (0).blocked,
                     l_semastcheck_arrtype (0).receiving,
                     l_semastcheck_arrtype (0).transfer,
                     l_semastcheck_arrtype (0).prevqtty,
                     l_semastcheck_arrtype (0).dcrqtty,
                     l_semastcheck_arrtype (0).dcramt,
                     l_semastcheck_arrtype (0).depofeeacr,
                     l_semastcheck_arrtype (0).repo,
                     l_semastcheck_arrtype (0).pending,
                     l_semastcheck_arrtype (0).tbaldepo,
                     l_semastcheck_arrtype (0).secured,
                     l_semastcheck_arrtype (0).iccfcd,
                     l_semastcheck_arrtype (0).iccftied,
                     l_semastcheck_arrtype (0).senddeposit,
                     l_semastcheck_arrtype (0).sendpending,
                     l_semastcheck_arrtype (0).ddroutqtty,
                     l_semastcheck_arrtype (0).ddroutamt,
                     l_semastcheck_arrtype (0).dtoclose,
                     l_semastcheck_arrtype (0).sdtoclose,
                     l_semastcheck_arrtype (0).qtty_transfer,
                     l_semastcheck_arrtype (0).trading;
      END IF;

      RETURN l_semastcheck_arrtype;
   EXCEPTION
      WHEN OTHERS
      THEN
        if pv_refcursor%ISOPEN THEN
            CLOSE pv_refcursor;
         END IF;
         RETURN l_semastcheck_arrtype;
   END fn_semastcheck;

   FUNCTION fn_afmastcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN afmastcheck_arrtype
   IS
      l_afmastcheck_rectype   afmastcheck_rectype;
      l_afmastcheck_arrtype   afmastcheck_arrtype;
      l_i                     NUMBER (10);
      pv_refcursor            pkg_report.ref_cursor;
      l_currdate              DATE;
   BEGIN                                                               -- Proc

      l_currdate:= to_date(cspks_system.fn_get_sysvar('SYSTEM', 'CURRDATE'),SYSTEMNUMS.c_date_format);
      OPEN pv_refcursor FOR
         SELECT af.actype, af.custid, af.acctno, af.aftype, af.tradefloor,
                af.tradetelephone, af.tradeonline, af.pin, af.LANGUAGE,
                af.tradephone, af.allowdebit, af.bankacctno, af.bankname,
                af.swiftcode, af.receivevia, af.email, af.address, af.fax,
                af.ciacctno, af.ifrulecd, af.lastdate, af.status, af.pstatus,
                af.marginline, af.tradeline, af.advanceline, af.repoline,
                af.depositline, af.bratio, af.termofuse, af.description,
                af.iccfcd, af.iccftied, af.telelimit, af.onlinelimit,
                af.cftelelimit, af.cfonlinelimit, af.traderate, af.deporate,
                af.miscrate, af.fax1, af.phone1, af.stmcycle, af.isotc,
                af.consultant, af.pisotc, af.opndate, af.feebase,
                af.bankacctnoblock, af.corebank, af.via, af.dmatchamt,
                af.mrirate, af.mrmrate, af.mrlrate, af.mrdueday, af.mrextday,
                af.mrclamt, af.mrcrlimit, af.mrcrlimitmax, af.groupleader,
                af.t0amt, mr.mrtype,
                (case when cf.custatcom= 'Y' then 'C' else 'T' end) CUSTODIANTYP,
                substr(cf.custodycd,4,1) CUSTTYPE,
                (cf.idexpired - l_currdate) idexpdays,
                decode(af.TERMOFUSE,'003',0,1) WARNINGTERMOFUSE
           FROM afmast af, aftype aft, mrtype mr, cfmast cf
          WHERE af.custid = cf.custid
            and af.actype = aft.actype
            --AND af.aftype = aft.aftype
            AND aft.mrtype = mr.actype
            AND af.acctno = pv_condvalue;

         l_i := 0;
         LOOP
             FETCH pv_refcursor
              INTO l_afmastcheck_rectype;

             l_afmastcheck_arrtype (l_i) := l_afmastcheck_rectype;
             EXIT WHEN pv_refcursor%NOTFOUND;
             l_i := l_i + 1;
         END LOOP;
         --close pv_refcursor;
         /*FETCH pv_refcursor
          bulk collect INTO l_afmastcheck_arrtype;
         close pv_refcursor;*/


      RETURN l_afmastcheck_arrtype;
   EXCEPTION
      WHEN OTHERS
      THEN
         if pv_refcursor%ISOPEN THEN
            CLOSE pv_refcursor;
         END IF;
         RETURN l_afmastcheck_arrtype;
   END fn_afmastcheck;

   FUNCTION fn_dfmastcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN dfmastcheck_arrtype
   IS
      l_dfmastcheck_rectype   dfmastcheck_rectype;
      l_dfmastcheck_arrtype   dfmastcheck_arrtype;
      l_i                     NUMBER (10);
      pv_refcursor            pkg_report.ref_cursor;
   BEGIN                                                               -- Proc
      OPEN pv_refcursor FOR
         select
            ACCTNO,AFACCTNO,LNACCTNO,FULLNAME,TXDATE,TXNUM,TXTIME,ACTYPE,RRTYPE,DFTYPE,
            CUSTBANK,LNTYPE,FEE,FEEMIN,TAX,AMTMIN,CODEID,SYMBOL,REFPRICE,DFPRICE,
            TRIGGERPRICE,DFRATE,IRATE,MRATE,LRATE,CALLTYPE,DFQTTY,BQTTY,RCVQTTY,CARCVQTTY,BLOCKQTTY,
            RLSQTTY,DFAMT,RLSAMT,AMT,INTAMTACR,FEEAMT,RLSFEEAMT,STATUS,DFREF,DESCRIPTION,
            PRINNML,PRINOVD,INTNMLACR,INTOVDACR,INTNMLOVD,INTDUE,INTPREPAID,
            OPRINNML,OPRINOVD,OINTNMLACR,OINTOVDACR,OINTNMLOVD,OINTDUE,OINTPREPAID,
            FEEDUE,FEEOVD,DEALAMT,DEALFEE,RTT,REMAINQTTY ,AVLFEEAMT,ODAMT,TAMT,CALLAMT,AVLRLSQTTY,AVLRLSAMT,DFTRADING,SECURED
        from v_getDealInfo df where df.acctno =pv_condvalue;
         l_i := 0;
         LOOP
             FETCH pv_refcursor
              INTO l_dfmastcheck_rectype;

             l_dfmastcheck_arrtype (l_i) := l_dfmastcheck_rectype;
             EXIT WHEN pv_refcursor%NOTFOUND;
             l_i := l_i + 1;
         END LOOP;

         --close pv_refcursor;
         /*FETCH pv_refcursor
          bulk collect INTO l_afmastcheck_arrtype;
         close pv_refcursor;*/


      RETURN l_dfmastcheck_arrtype;
   EXCEPTION
      WHEN OTHERS
      THEN
         if pv_refcursor%ISOPEN THEN
            CLOSE pv_refcursor;
         END IF;
         RETURN l_dfmastcheck_arrtype;
   END fn_dfmastcheck;

   FUNCTION fn_sewithdrawcheck (
      pv_condvalue   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_fldkey      IN   VARCHAR2
   )
      RETURN sewithdrawcheck_arrtype
   IS
      l_margintype                CHAR (1);
      l_actype                    VARCHAR2 (4);
      l_groupleader               VARCHAR2 (10);
      l_baldefovd                 NUMBER (20, 0);
      l_pp                        NUMBER (20, 0);
      l_avllimit                  NUMBER (20, 0);
      l_navaccount                NUMBER (20, 0);
      l_outstanding               NUMBER (20, 0);
      l_mrirate                   NUMBER (20, 4);
      l_sewithdrawcheck_rectype   sewithdrawcheck_rectype;
      l_sewithdrawcheck_arrtype   sewithdrawcheck_arrtype;
      l_i                         NUMBER (10);
      pv_refcursor                pkg_report.ref_cursor;
      l_count                     number;
      l_getpp_arr                 txpks_check.getpp_arrtype;
      l_isChkSysCtrlDefault       VARCHAR2 (4);

   BEGIN                                                               -- Proc
      SELECT mr.mrtype, af.actype, mst.groupleader
        INTO l_margintype, l_actype, l_groupleader
        FROM afmast mst, aftype af, mrtype mr
       WHERE mst.actype = af.actype
         AND af.mrtype = mr.actype
         AND mst.acctno = SUBSTR (pv_condvalue, 1, 10);

--them vao de check pp va TK tuan thu
    l_getpp_arr := txpks_check.fn_getpp(SUBSTR (pv_condvalue, 1, 10));
    l_pp:=l_getpp_arr(0).pp;

    select count(1) into l_count
    from afmast af, aftype aft, mrtype mrt, lntype lnt
    where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
        and aft.lntype = lnt.actype(+)
        and (lnt.chksysctrl = 'Y'
            or exists (select 1 from afidtype afid, lntype lnt
                    where afid.actype = lnt.actype and afid.aftype = aft.actype and afid.objname = 'LN.LNTYPE' and lnt.chksysctrl = 'Y'))
        and af.acctno = SUBSTR (pv_condvalue, 1, 10);

    if l_count > 0 then
        l_isChkSysCtrlDefault:='Y';
    else
        l_isChkSysCtrlDefault:='N';
    end if;
--End them vao de check pp va TK tuan thu

      IF l_margintype = 'N' or l_margintype = 'L'
      THEN
         OPEN pv_refcursor FOR
            SELECT CASE WHEN l_pp < 0 THEN 0 ELSE 1000000000 END avlsewithdraw

              FROM DUAL;
      ELSIF     l_margintype in ('S','T')
            AND (LENGTH (l_groupleader) = 0 OR l_groupleader IS NULL)
      THEN
         --Tai khoan margin khong tham gia group
         OPEN pv_refcursor FOR
            select
                CASE WHEN l_pp < 0 THEN 0
                ELSE
                    CASE WHEN l_isChkSysCtrlDefault = 'Y' THEN
                        least(se.trade- nvl(od.SELLQTTY,0),
                                (CASE WHEN (OUTSTANDING_UB) >= 0 THEN 1000000000 ELSE
                                    CASE WHEN LEAST(NVL(SB.MARGINREFPRICE,0),NVL(RSK.MRPRICELOAN1,0)) * NVL(RSK.MRRATIOLOAN1,0) <=0 THEN 1000000000
                                    ELSE trunc(GREATEST((100* SETOTALMRAMT + (OUTSTANDING_UB) * MRIRATE)/MRIRATE,0)/LEAST(SB.MARGINREFPRICE,RSK.MRPRICELOAN1) / (MRRATIOLOAN1/100),0)
                                    END
                                END) +
                                CASE WHEN se.roomchk = 'Y' THEN GREATEST((se.trade- nvl(od.EXECSELLQTTY,0) + nvl(od.RECEIVING,0) + nvl(od.REMAINQTTY,0) - nvl(afpr.prinused,0) - nvl(pr.pravlremain,0)),0) ELSE 0 END
                                ,
                                (
                                CASE WHEN (OUTSTANDING_SY - ci.depofeeamt) >= 0 THEN 1000000000 ELSE
                                    CASE WHEN LEAST(NVL(SB.MARGINPRICE,0),NVL(RSK.MRPRICELOAN,0)) * NVL(RSK.MRRATIOLOAN,0) <=0 THEN 1000000000
                                    ELSE trunc(GREATEST((100* SETOTALAMT + (OUTSTANDING_SY- ci.depofeeamt) * MRIRATE)/MRIRATE,0)/LEAST(SB.MARGINPRICE,RSK.MRPRICELOAN) / (MRRATIOLOAN/100),0)
                                    END
                                END) +
                                CASE WHEN se.roomchk = 'Y' THEN GREATEST((se.trade- nvl(od.EXECSELLQTTY,0) + nvl(od.RECEIVING,0) + nvl(od.REMAINQTTY,0) - nvl(afpr.sy_prinused,0) - nvl(pr.sy_pravlremain,0)),0) ELSE 0 END
                                ,
                                (
                                CASE WHEN (OUTSTANDING - ci.depofeeamt) >= 0 THEN 1000000000 ELSE
                                    CASE WHEN LEAST(NVL(SB.MARGINCALLPRICE,0),NVL(RSK.MRPRICERATE,0)) * NVL(RSK.MRRATIORATE,0) <=0 THEN 1000000000
                                    ELSE trunc(GREATEST((100* SEMAXTOTALCALLASS + (OUTSTANDING- ci.depofeeamt) * MRIRATE)/MRIRATE,0)/LEAST(SB.MARGINCALLPRICE,RSK.MRPRICERATE) / (MRRATIORATE/100),0)
                                    END
                                END)
                            )
                    ELSE
                        least(se.trade- nvl(od.SELLQTTY,0),
                                (
                                CASE WHEN (OUTSTANDING_SY - ci.depofeeamt) >= 0 THEN 1000000000 ELSE
                                    CASE WHEN LEAST(NVL(SB.MARGINPRICE,0),NVL(RSK.MRPRICELOAN,0)) * NVL(RSK.MRRATIOLOAN,0) <=0 THEN 1000000000
                                    ELSE trunc(GREATEST((100* SETOTALAMT + (OUTSTANDING_SY- ci.depofeeamt) * MRIRATE)/MRIRATE,0)/LEAST(SB.MARGINPRICE,RSK.MRPRICELOAN) / (MRRATIOLOAN/100),0)
                                    END
                                END) + CASE WHEN se.roomchk = 'Y' THEN GREATEST((se.trade- nvl(od.EXECSELLQTTY,0) + nvl(od.RECEIVING,0) + nvl(od.REMAINQTTY,0) - nvl(afpr.sy_prinused,0) - nvl(pr.sy_pravlremain,0)),0) ELSE 0 END
                                ,
                                (
                                    CASE WHEN (OUTSTANDING - ci.depofeeamt) >= 0 THEN 1000000000 ELSE
                                        CASE WHEN LEAST(NVL(SB.MARGINCALLPRICE,0),NVL(RSK.MRPRICERATE,0)) * NVL(RSK.MRRATIORATE,0) <=0 THEN 1000000000
                                        ELSE trunc(GREATEST((100* SEMAXTOTALCALLASS + (OUTSTANDING- ci.depofeeamt) * MRIRATE)/MRIRATE,0)/LEAST(SB.MARGINCALLPRICE,RSK.MRPRICERATE) / (MRRATIORATE/100),0)
                                        END
                                    END)
                            )
                    END
                END avlsewithdraw
                   --chinh lai cong thuc theo issiu MSBS-1222
                       /*    (CASE WHEN LEAST(NVL(SB.MARGINCALLPRICE,0),NVL(RSK.MRPRICERATE,0)) * NVL(RSK.MRRATIORATE,0) <=0 THEN 1000000000
                                ELSE
                                    CASE WHEN SETOTALCALLASS + (OUTSTANDING - ci.depofeeamt) <= 0 THEN 0 ELSE
                                        trunc(GREATEST((100* SEMAXTOTALCALLASS + (OUTSTANDING - ci.depofeeamt) * MRIRATE)/MRIRATE,0)/LEAST(sb.marginprice\*SB.MARGINCALLPRICE*\,rsk.mrpriceloan\*RSK.MRPRICERATE*\) / (rsk.mrratioloan\*MRRATIORATE*\/100),0)   --them phi luu ky den han MSBS-776
                                    END
                            END)) avlsewithdraw*/
             from semast se, securities_info sb, cimast ci,
             (select af.acctno afacctno,af.advanceline,af.MRIRATE, nvl(rsk.mrpricerate,1) mrpricerate, nvl(rsk.mrratiorate,0) mrratiorate, nvl(rsk.mrratioloan,0) mrratioloan, nvl(rsk.mrpriceloan,0) mrpriceloan,
                    nvl(rsk1.mrpricerate,1) mrpricerate1, nvl(rsk1.mrratiorate,0) mrratiorate1, nvl(rsk1.mrratioloan,0) mrratioloan1, nvl(rsk1.mrpriceloan,0) mrpriceloan1
                from afmast af, (select * from afserisk where codeid = substr(pv_condvalue,11,6)) rsk,
                    (select * from afmrserisk where codeid = substr(pv_condvalue,11,6)) rsk1
                where af.acctno = substr(pv_CONDVALUE,1,10) and af.actype = rsk.actype(+) and af.actype = rsk1.actype(+)) rsk,
             (select * from v_getsecmarginratio where afacctno = substr(pv_CONDVALUE,1,10)) sec,
             (select od.seacctno,
                        sum(case when od.exectype in ('NS','SS') and to_date(sy.varvalue,'DD/MM/RRRR') = od.txdate then remainqtty + execqtty else 0 end) SELLQTTY,
                        sum(case when od.exectype in ('NS','SS') and to_date(sy.varvalue,'DD/MM/RRRR') = od.txdate then execqtty else 0 end) EXECSELLQTTY,
                        sum(case when od.exectype in ('MS') and to_date(sy.varvalue,'DD/MM/RRRR') = od.txdate then remainqtty + execqtty else 0 end) MTGSELLQTTY,
                        sum(case when od.exectype = 'NB' then sts.qtty - sts.aqtty else 0 end) RECEIVING,
                        sum(CASE WHEN OD.EXECTYPE = 'NB' and to_date(sy.varvalue,'DD/MM/RRRR') = od.txdate then od.REMAINQTTY ELSE 0 END) REMAINQTTY
                        from odmast od, (select * from stschd where duetype in ('RS','SS')) sts, sysvar sy
                        where od.orderid = sts.orgorderid(+)
                        and sy.varname = 'CURRDATE'
                        group by od.seacctno
            ) od,
            (
                select afacctno, codeid, afacctno||codeid seacctno,substr(pv_CONDVALUE,1,10),substr(pv_CONDVALUE,11,6),
                    nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                    nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                from vw_afpralloc_all WHERE afacctno = substr(pv_CONDVALUE,1,10) AND codeid = substr(pv_CONDVALUE,11,6)
                group by afacctno, codeid
            ) afpr,
            (
                select pr.codeid,
                    greatest(max(pr.roomlimit) - nvl(sum(case when restype = 'M' then nvl(afpr.prinused,0) else 0 end),0),0) pravlremain,
                    greatest(max(pr.syroomlimit) - max(pr.syroomused) - nvl(sum(case when restype = 'S' then nvl(afpr.prinused,0) else 0 end),0),0) sy_pravlremain
                from vw_marginroomsystem pr, vw_afpralloc_all afpr
                where pr.codeid = afpr.codeid(+) AND pr.codeid = substr(pv_CONDVALUE,11,6)
                group BY pr.codeid
            ) pr

             where se.acctno = pv_CONDVALUE and se.afacctno = sec.afacctno(+)
                and se.afacctno = rsk.afacctno(+)
                and se.acctno = od.seacctno(+)
                and se.acctno = afpr.seacctno(+)
                AND se.codeid = pr.codeid(+)
                and se.codeid = sb.codeid and ci.acctno = se.afacctno;
      ELSE
         --Tai khoan margin join theo group
         OPEN pv_refcursor FOR
            SELECT (CASE
                       WHEN   LEAST (NVL (sb.margincallprice, 0),
                                     NVL (rsk.mrpricerate, 0)
                                    )
                            * NVL (rsk.mrratiorate, 0) <= 0
                          THEN 1000000000
                       ELSE TRUNC (  (navaccount * 100 + outstanding * mrirate
                                     )
                                   / LEAST (sb.margincallprice, rsk.mrpricerate)
                                   / mrratiorate,
                                   0
                                  )
                    END
                   ) avlsewithdraw
              FROM (SELECT af.acctno, af.actype, af.mrirate, navaccount,
                           outstanding
                      FROM (SELECT   SUBSTR (pv_condvalue, 1, 10) afacctno,
                                     SUM (  NVL (af.mrcrlimit, 0)
                                          + NVL (se.seass, 0)
                                         ) navaccount,
                                     SUM (  balance- trfbuyamt
                                          + NVL (se.receivingamt, 0)
                                          - odamt
                                          - NVL (advamt, 0)
                                          - NVL (secureamt, 0)
                                          - ramt
                                          - ci.depofeeamt       --them phi luu ky den han MSBS-776
                                         ) outstanding
                                FROM cimast ci INNER JOIN afmast af ON af.acctno =
                                                                      ci.afacctno
                                                               AND af.groupleader =
                                                                      l_groupleader
                                     LEFT JOIN (SELECT b.*
                                                  FROM v_getbuyorderinfo b,
                                                       afmast af
                                                 WHERE b.afacctno = af.acctno
                                                   AND af.groupleader =
                                                                 l_groupleader) b ON ci.acctno =
                                                                                       b.afacctno
                                     LEFT JOIN (SELECT b.*
                                                  FROM v_getsecmargininfo b,
                                                       afmast af
                                                 WHERE b.afacctno = af.acctno
                                                   AND af.groupleader =
                                                                 l_groupleader) se ON se.afacctno =
                                                                                        ci.acctno
                            GROUP BY af.groupleader) a,
                           afmast af
                     WHERE a.afacctno = af.acctno) mst,
                   afserisk rsk,
                   securities_info sb
             WHERE mst.actype = rsk.actype(+)
               AND sb.codeid = SUBSTR (pv_condvalue, 11, 6)
               AND rsk.codeid(+) = SUBSTR (pv_condvalue, 11, 6);
      END IF;

      l_i := 0;

      LOOP
         FETCH pv_refcursor
          INTO l_sewithdrawcheck_rectype;

         l_sewithdrawcheck_arrtype (l_i) := l_sewithdrawcheck_rectype;
         EXIT WHEN pv_refcursor%NOTFOUND;
         l_i := l_i + 1;
      END LOOP;
      --close pv_refcursor;
      /*FETCH pv_refcursor
          bulk collect INTO l_sewithdrawcheck_arrtype;
      close pv_refcursor;*/

      RETURN l_sewithdrawcheck_arrtype;
   EXCEPTION
      WHEN OTHERS
      THEN
         if pv_refcursor%ISOPEN THEN
            CLOSE pv_refcursor;
         END IF;
         RETURN l_sewithdrawcheck_arrtype;
   END fn_sewithdrawcheck;

FUNCTION fn_aftxmapcheck (
      pv_acctno   IN   VARCHAR2,
      pv_tblname     IN   VARCHAR2,
      pv_acfld       IN varchar2,
      pv_tltxcd in varchar2
   )
      RETURN VARCHAR2
   IS
     l_result boolean;
     l_afacctno varchar2(10);
     l_currdate date;
     l_count number(5);
     l_actype VARCHAR2(4);
   BEGIN
      /*if pv_acfld='05' and pv_tltxcd='1120' then
         --Khong check voi tai khoan duoc chuyen den trong giao dich chuyen doi ung
         return 'TRUE';
      end if;*/
      l_result:=true;
      l_afacctno:='';
      select to_date(varvalue,systemnums.c_date_format) into l_currdate from sysvar where varname ='CURRDATE' and grname ='SYSTEM';
      if pv_tblname='AFMAST' then
          l_afacctno:=   pv_acctno;
      elsif pv_tblname='CIMAST' then
          l_afacctno:=   pv_acctno;
      elsif pv_tblname='SEMAST' then
          l_afacctno:=   substr(pv_acctno,1,10);
      elsif pv_tblname='LNMAST' then
          select trfacctno into l_afacctno from lnmast where acctno =   pv_acctno;
      elsif pv_tblname='DFMAST' then
          select afacctno into l_afacctno from dfmast where acctno =   pv_acctno;
      elsif pv_tblname='ODMAST' then
          select afacctno into l_afacctno from odmast where orderid =   pv_acctno;
      end if;


      -- TruongLD Add
      -- Lay loai hinh cua tieu khoan
      if l_afacctno is not null THEN
         SELECT actype INTO l_actype FROM afmast WHERE acctno = l_afacctno;
      END IF;

      l_count := 0;
      if l_actype is not null THEN
         BEGIN
           SELECT COUNT(1) INTO l_count FROM aftxmap WHERE actype = l_actype AND upper(afacctno) = 'ALL';
           EXCEPTION
                  WHEN OTHERS THEN
                       l_count := 0;
         END;
      END IF;
      -- End TruongLD

      IF l_count <> 0 THEN
         -- Chan theo loai hinh.
         l_count := 0;
         select count(1) into l_count from aftxmap where actype = l_actype and tltxcd = pv_tltxcd
            and effdate<=l_currdate and expdate>l_currdate;
            l_result:= case when l_count>0 then false else true end;
      end if;
      if l_result then
          IF l_afacctno is not null THEN
                -- Chan theo tieu khoan.
                l_count := 0;
                select count(1) into l_count from aftxmap where afacctno = l_afacctno and tltxcd = pv_tltxcd
                and effdate<=l_currdate and expdate>l_currdate;
                l_result:= case when l_count>0 then false else true end;
          END IF;
      end if;
      RETURN case when l_result then 'TRUE' else 'FALSE' end;
   exception when others then
        return 'TRUE';
   END fn_aftxmapcheck;

   FUNCTION fn_getpp (
      pv_condvalue   IN   VARCHAR2

   )
      RETURN getpp_arrtype
   IS
      l_margintype            CHAR (1);
      l_actype                VARCHAR2 (4);
      l_getpp_rectype   getpp_rectype;
      l_getpp_arrtype   getpp_arrtype;
      l_i                     NUMBER (10);
      pv_refcursor            pkg_report.ref_cursor;
      l_count number;
      l_isChkSysCtrlDefault varchar2(1);
      l_t0loanrate          NUMBER;

   BEGIN
         -- Proc

      SELECT mr.mrtype, af.actype, cf.t0loanrate
        INTO l_margintype, l_actype,l_t0loanrate
        FROM afmast mst, aftype af, mrtype mr, cfmast cf
       WHERE mst.actype = af.actype
         AND af.mrtype = mr.actype
         AND mst.custid =cf.custid
         AND mst.acctno = pv_condvalue;


      IF l_margintype = 'N' or l_margintype = 'L'
      THEN
         --Tai khoan binh thuong khong Margin
         OPEN pv_refcursor FOR
             SELECT
                 af.acctno,
                 --1.5.8.9 MSBS-2055
                  round(CASE WHEN nvl(af.deal,'Y') = 'N'
                        THEN greatest(least(ROUND(least(nvl(ci.balance-NVL(od.secureamt,0) + NVL(ADV.avladvance,0) + v_getsec.senavamt -
                             NVL(ci.ovamt,0),0) * l_t0loanrate /100,
                             nvl(v_getsec.SELIQAMT2,0))),nvl(af.advanceline,0)),0)
                       ELSE nvl(af.advanceline,0) END
                   +ci.balance
                  - nvl(OD.secureamt,0)
                  + nvl(adv.avladvance,0)
                  + least(nvl(AF.mrcrlimitmax,0) + nvl(af.mrcrlimit,0) - dfodamt ,
                          nvl(af.mrcrlimit,0) )
                  - nvl(ci.odamt,0)
                  - ramt
                  - ci.depofeeamt,0) PP,
                  --1.5.8.9 MSBS-2055
                  round(CASE WHEN nvl(af.deal,'Y') = 'N'
                        THEN greatest(least(ROUND(least(nvl(ci.balance-NVL(od.secureamt,0) + NVL(ADV.avladvance,0) + v_getsec.senavamt -
                             NVL(ci.ovamt,0),0) * l_t0loanrate /100,
                             nvl(v_getsec.SELIQAMT2,0))),nvl(af.advanceline,0)),0)
                       ELSE nvl(af.advanceline,0) END
                  +ci.balance
                  - nvl(OD.secureamt,0)
                  + nvl(adv.avladvance,0)
                  + least(nvl(AF.mrcrlimitmax,0) + nvl(af.mrcrlimit,0) - dfodamt ,
                          nvl(af.mrcrlimit,0) )
                  - nvl(ci.odamt,0)
                  - ramt
                  - ci.depofeeamt,0) PPref,
                    nvl(adv.avladvance,0)
                    --1.5.8.9 MSBS-2055
                    + CASE WHEN nvl(af.deal,'Y') = 'N'
                        THEN greatest(least(ROUND(least(nvl(ci.balance-NVL(od.secureamt,0) + NVL(ADV.avladvance,0) + v_getsec.senavamt -
                             NVL(ci.ovamt,0),0) * l_t0loanrate /100,
                             nvl(v_getsec.SELIQAMT,0))),nvl(af.advanceline,0)),0)
                       ELSE nvl(af.advanceline,0) END
                    + nvl(AF.mrcrlimitmax,0)
                    +nvl(af.mrcrlimit,0)
                    - ci.dfodamt
                    + ci.balance
                    - ci.odamt
                    - ci.dfdebtamt
                    - ci.dfintdebtamt
                    - ci.depofeeamt
                    -  nvl(OD.secureamt,0)
                     - ci.ramt avllimit,
                  GREATEST ( nvl(adv.avladvance,0) + ci.balance
                             - ci.odamt
                             - ci.dfdebtamt
                             - ci.dfintdebtamt
                             /*- NVL (advamt, 0)*/
                             - NVL (od.secureamt, 0)
                             - ci.ramt
                             - ci.depofeeamt,
                             0
                            ) avlwithdraw
             From  cimast ci ,
                   afmast af ,
                         --v_getbuyorderinfo ,
                 (SELECT
                   od.afacctno afacctno,
                   sum(od.quoteprice* od.remainqtty* (od.bratio/100)
                        + od.execamt * (od.bratio/100)
                        + od.execamt * (case when od.execqtty<=0 then 0 else od.dfqtty/od.execqtty end) * (1 + typ.deffeerate / 100 - od.bratio/100)
                        + nvl( greatest((abod.ORDERQTTY-od.execqtty) * abod.BRATIO/100 * abod.QUOTEPRICE - od.remainqtty * od.QUOTEPRICE * od.BRATIO/100  ,0),0))   secureamt
                    FROM odmast od, odtype typ,  sysvar sy_CURRDATE,
                         ( select om.reforderid,om.orderqtty,om.quoteprice,om.bratio
                           from odmast om, ood od
                           where om.exectype ='AB'
                           and om.orderid = od.orgorderid
                           and od.oodstatus='N'   )abod
                    WHERE od.actype = typ.actype
                        AND od.txdate = to_date(sy_CURRDATE.VARVALUE,'DD/MM/RRRR')
                        AND od.deltd <> 'Y'
                        AND od.exectype IN ('NB', 'BC')
                        and od.stsstatus <> 'C'
                        and od.orderid = abod.REFORDERID(+)
                       and sy_CURRDATE.grname='SYSTEM' and sy_CURRDATE.varname='CURRDATE'
                     group by od.afacctno
                           ) OD,
                   (select sum(depoamt) avladvance,afacctno
                    from v_getAccountAvlAdvance group by afacctno) adv,
                    -- begin 1.5.8.9
                    v_getsecmargininfo_ALL v_getsec
                   WHERE   ci.acctno=af.acctno
                     AND   ci.acctno = od.afacctno(+)
                     AND   CI.ACCTNO = ADV.afacctno(+)
                     and   ci.acctno = v_getsec.afacctno(+) --1.5.8.9
                     and   ci.acctno = pv_condvalue;
      ELSIF     l_margintype in  ('S','T') then
           -- Day la tieu khoan gan loai hinh mac dinh la tuan thu.
            select count(1)
                into l_count
            from afmast af
            where af.acctno = pv_condvalue
            and exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y');

            if l_count > 0 then
                l_isChkSysCtrlDefault:='Y';
            else
                l_isChkSysCtrlDefault:='N';
            end if;
         --Tai khoan margin khong tham gia group
         OPEN pv_refcursor FOR
              SELECT
                  af.acctno,
                  case when l_isChkSysCtrlDefault='Y' then
                   least(round(--af.advanceline +
                                ci.balance
                               - nvl(OD.secureamt,0)
                               + nvl(adv.avladvance,0)
                               + least(nvl(AF.mrcrlimitmax,0) + nvl(af.mrcrlimit,0) - dfodamt ,
                                       nvl(af.mrcrlimit,0) + nvl(se.semramt,0))
                               - nvl(ci.odamt,0)
                               -nvl(dfdebtamt,0)
                               - nvl(dfintdebtamt,0)
                               - ramt
                               - ci.depofeeamt,
                               0)
                          ,
                           round(--af.advanceline +
                           ci.balance
                           - nvl(OD.secureamt,0)
                           + nvl(adv.avladvance,0)
                           + least(nvl(AF.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,
                                   nvl(af.mrcrlimit,0) + nvl(se.seamt,0))
                           -nvl(dfdebtamt,0)
                           - nvl(dfintdebtamt,0)
                           - nvl(ci.odamt,0)
                           - ramt
                           - ci.depofeeamt,0)
                    )
                   else
                     round(--af.advanceline +
                           ci.balance
                           - nvl(OD.secureamt,0)
                           + nvl(adv.avladvance,0)
                           + least(nvl(AF.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,
                                   nvl(af.mrcrlimit,0) + nvl(se.seamt,0))
                           -nvl(dfdebtamt,0)
                           - nvl(dfintdebtamt,0)
                           - nvl(ci.odamt,0)
                           - ramt
                           - ci.depofeeamt,0)
                   END PP,
                  case when l_isChkSysCtrlDefault='Y' then
                   least(round(--af.advanceline +
                                ci.balance
                               - nvl(OD.secureamt,0)
                               + nvl(adv.avladvance,0)
                               + least(nvl(AF.mrcrlimitmax,0) + nvl(af.mrcrlimit,0) - dfodamt ,
                                       nvl(af.mrcrlimit,0) + nvl(se.semramt,0))
                               - nvl(ci.odamt,0)
                               -nvl(dfdebtamt,0)
                               - nvl(dfintdebtamt,0)
                               - ramt
                               - ci.depofeeamt,0),
                           round(--af.advanceline +
                           ci.balance
                           - nvl(OD.secureamt,0)
                           + nvl(adv.avladvance,0)
                           + least(nvl(AF.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,
                                   nvl(af.mrcrlimit,0) + nvl(se.seamt,0))
                           - nvl(ci.odamt,0)
                           -nvl(dfdebtamt,0)
                           - nvl(dfintdebtamt,0)
                           - ramt
                           - ci.depofeeamt,0)
                   )
                   else
                         round(--af.advanceline +
                       ci.balance
                       - nvl(OD.secureamt,0)
                       + nvl(adv.avladvance,0)
                       + least(nvl(AF.mrcrlimitmax,0)+nvl(af.mrcrlimit,0) - dfodamt,
                               nvl(af.mrcrlimit,0) + nvl(se.seamt,0))
                       - nvl(ci.odamt,0)
                       -nvl(dfdebtamt,0)
                       - nvl(dfintdebtamt,0)
                       - ramt
                       - ci.depofeeamt,0)
                   END PPREF,
                   ROUND(
                   nvl(adv.avladvance,0) + nvl(af.advanceline,0)  + nvl(AF.mrcrlimitmax,0)
                   +nvl(af.mrcrlimit,0)- ci.dfodamt + ci.balance - ci.odamt
                   - ci.dfdebtamt - ci.dfintdebtamt - ci.depofeeamt -  nvl(OD.secureamt,0) - ci.ramt)
                    avllimit,
                    GREATEST ( nvl(adv.avladvance,0) + ci.balance
                             - ci.odamt
                             - ci.dfdebtamt
                             - ci.dfintdebtamt
                             /*- NVL (advamt, 0)*/
                             - NVL (od.secureamt, 0)
                             - ci.ramt
                             - ci.depofeeamt,
                             0
                            ) avlwithdraw
           from  cimast ci ,
                 (SELECT af.*,CASE WHEN exists (select 1 from aftype aft, lntype lnt where aft.actype = af.actype and aft.lntype = lnt.actype and lnt.chksysctrl = 'Y')
                                            THEN 'Y' ELSE 'N' END isChkSysCtrlDefault
                 from afmast af) af,
                 --v_getbuyorderinfo ,
                  (SELECT
                    od.afacctno afacctno,
                    sum(od.quoteprice* od.remainqtty* (od.bratio/100)
                         + od.execamt * (od.bratio/100)
                         + od.execamt * (case when od.execqtty<=0 then 0 else od.dfqtty/od.execqtty end) * (1 + typ.deffeerate / 100 - od.bratio/100)
                         + nvl( greatest((abod.ORDERQTTY-od.execqtty) * abod.BRATIO/100 * abod.QUOTEPRICE - od.remainqtty * od.QUOTEPRICE * od.BRATIO/100  ,0),0))   secureamt
                     FROM odmast od, odtype typ,  sysvar sy_CURRDATE,
                          ( select om.reforderid,om.orderqtty,om.quoteprice,om.bratio
                            from odmast om, ood od
                            where om.exectype ='AB'
                            and om.orderid = od.orgorderid
                            and od.oodstatus='N'   )abod
                     WHERE od.actype = typ.actype
                         AND od.txdate = to_date(sy_CURRDATE.VARVALUE,'DD/MM/RRRR')
                         AND od.deltd <> 'Y'
                         AND od.exectype IN ('NB', 'BC')
                         and od.stsstatus <> 'C'
                         and od.orderid = abod.REFORDERID(+)
                        and sy_CURRDATE.grname='SYSTEM' and sy_CURRDATE.varname='CURRDATE'
                      group by od.afacctno
                            ) OD,
                 --v_getsecmargininfo se,
                 ( select se.afacctno ,
                   sum ((case when se.roomchk ='Y' then least(se.trade + se.receiving - se.execqtty + se.buyqtty,nvl(sy_pravlremain,0) + nvl(sy_prinused,0))
                        else (se.trade + se.receiving - se.execqtty + se.buyqtty) end)
                          * nvl(rsk1.mrratioloan,0)/100
                          * least(sb.MARGINPRICE,nvl(rsk1.mrpriceloan,0)))
                       SEAMT,
                   sum ((case when se.roomchk ='Y' then least(se.trade + se.receiving - se.execqtty + se.buyqtty, nvl(pravlremain,0) + nvl(prinused,0))
                        else (se.trade + se.receiving - se.execqtty + se.buyqtty) end)
                        * least(nvl(rsk2.mrratioloan,0),100-se.mriratio)/100
                        * least(sb.MARGINREFPRICE,nvl(rsk2.mrpriceloan,0))) SEMRAMT
                   from
                    (select se.roomchk,se.codeid, af.actype, af.mriratio, af.acctno afacctno,se.acctno, se.trade ,
                        nvl(sts.receiving,0) receiving,
                        nvl(od.BUYQTTY,0) BUYQTTY,
                        nvl(od.EXECQTTY,0) EXECQTTY,
                        nvl(afpr.prinused,0) prinused,
                        nvl(afpr.sy_prinused,0) sy_prinused
                     from semast se,
                             afmast af,
                            (select sum(BUYQTTY) BUYQTTY,
                                    sum(EXECQTTY) EXECQTTY , AFACCTNO, CODEID
                                    from (
                                        SELECT (case when od.exectype IN ('NB','BC')
                                                    then  REMAINQTTY + EXECQTTY - DFQTTY
                                                    else 0 end) BUYQTTY,
                                                (case when od.exectype IN ('NS','MS') and od.stsstatus <> 'C'
                                                    then EXECQTTY
                                                    else 0 end) EXECQTTY,AFACCTNO, CODEID
                                        FROM odmast od
                                        where
                                            od.txdate =(select to_date(VARVALUE,'DD/MM/RRRR') from sysvar where grname='SYSTEM' and varname='CURRDATE')
                                           AND od.deltd <> 'Y'
                                           and not(od.grporder='Y' and od.matchtype='P') --Lenh thoa thuan tong khong tinh vao
                                           AND od.exectype IN ('NS', 'MS','NB','BC')
                                        )
                             group by AFACCTNO, CODEID
                             ) OD,
                            (SELECT sts.CODEID,sts.AFACCTNO,
                                SUM( QTTY-AQTTY ) RECEIVING
                             FROM STSCHD STS,  sysvar sy
                             WHERE STS.DUETYPE IN ('RS') AND STS.STATUS ='N'
                                and sy.grname = 'SYSTEM' and sy.varname = 'CURRDATE'
                                AND STS.TXDATE <> TO_DATE(sy.VARVALUE,'DD/MM/RRRR')
                                AND STS.DELTD <>'Y'
                                GROUP BY sts.AFACCTNO,sts.CODEID
                              ) sts,
                            (  select afacctno, codeid,
                                    nvl(sum(case when restype = 'M' then prinused else 0 end),0) prinused,
                                    nvl(sum(case when restype = 'S' then prinused else 0 end),0) sy_prinused
                                from vw_afpralloc_all
                                group by afacctno, codeid
                            ) afpr
                     where     se.afacctno =af.acctno
                               and  se.afacctno =OD.afacctno (+)
                               and  se.codeid = OD.codeid(+)
                               and  se.afacctno = sts.afacctno(+)
                               and  se.codeid = sts.codeid(+)
                               and  se.afacctno = afpr.afacctno (+)
                               and  se.codeid = afpr.codeid(+)
                        ) se,
                        afserisk rsk1,
                        afmrserisk rsk2,
                        securities_info sb,
                        (
                            select pr.codeid,
                                greatest(max(pr.roomlimit) -
                                         nvl(sum(case when restype = 'M' then nvl(afpr.prinused,0) else 0 end),0),0) pravlremain,
                                greatest(max(pr.syroomlimit)- max(pr.syroomused)
                                        - nvl(sum(case when restype = 'S' then nvl(afpr.prinused,0) else 0 end),0),0) sy_pravlremain
                            from vw_marginroomsystem pr, vw_afpralloc_all afpr
                            where pr.codeid = afpr.codeid(+)
                            group by pr.codeid
                        ) pr
                        where se.codeid = pr.codeid
                        and (se.actype =rsk1.actype and se.codeid=rsk1.codeid)
                        and (se.actype =rsk2.actype and se.codeid=rsk2.codeid)
                        and se.codeid=sb.codeid
                        group by se.afacctno
                 )se,
           (select sum(depoamt) avladvance,afacctno
            from v_getAccountAvlAdvance group by afacctno) adv
           WHERE   ci.acctno=af.acctno
             and   ci.acctno=se.afacctno(+)
             AND   ci.acctno = od.afacctno(+)
             AND   CI.ACCTNO = ADV.afacctno(+)
             and   ci.acctno =  pv_condvalue;
      END IF;

      l_i := 0;
      LOOP
         FETCH pv_refcursor
          INTO l_getpp_rectype;
          l_getpp_arrtype (l_i) := l_getpp_rectype;
         EXIT WHEN pv_refcursor%NOTFOUND;
         l_i := l_i + 1;
      END LOOP;
      RETURN l_getpp_arrtype;
   EXCEPTION
      WHEN OTHERS
      THEN
         if pv_refcursor%ISOPEN THEN
            CLOSE pv_refcursor;
         END IF;
         RETURN l_getpp_arrtype;
   END fn_getpp;

BEGIN
   FOR i IN (SELECT *
               FROM tlogdebug)
   LOOP
      logrow.loglevel := i.loglevel;
      logrow.log4table := i.log4table;
      logrow.log4alert := i.log4alert;
      logrow.log4trace := i.log4trace;
   END LOOP;

   pkgctx :=
      plog.init ('TXPKS_CHECK',
                 plevel         => NVL (logrow.loglevel, 30),
                 plogtable      => (NVL (logrow.log4table, 'N') = 'Y'),
                 palert         => (NVL (logrow.log4alert, 'N') = 'Y'),
                 ptrace         => (NVL (logrow.log4trace, 'N') = 'Y')
                );
END txpks_check;
/
