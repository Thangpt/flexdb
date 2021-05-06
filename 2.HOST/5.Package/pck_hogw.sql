CREATE OR REPLACE PACKAGE pck_hogw
is
 /*----------------------------------------------------------------------------------------------------
     ** Module   : COMMODITY SYSTEM
     ** and is copyrighted by FSS.
     **
     **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
     **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
     **    graphic, optic recording or otherwise, translated in any language or computer language,
     **    without the prior written permission of Financial Software Solutions. JSC.
     **
     **  MODIFICATION HISTORY
     **  Person      Date           Comments
     **  TienPQ      09-JUNE-2009    Created
     ** (c) 2009 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/

    FUNCTION fn_obj2xml(p_txmsg tx.msg_rectype)
    RETURN VARCHAR2;

    FUNCTION fn_xml2obj(p_xmlmsg    VARCHAR2)
    RETURN tx.msg_rectype;

  FUNCTION fn_xml2obj_2B(p_xmlmsg    VARCHAR2) RETURN tx.msg_2B;
  FUNCTION fn_xml2obj_2D(p_xmlmsg    VARCHAR2) RETURN tx.msg_2D;
  FUNCTION fn_xml2obj_2G(p_xmlmsg    VARCHAR2) RETURN tx.msg_2G;
  FUNCTION fn_xml2obj_3B(p_xmlmsg    VARCHAR2) RETURN tx.msg_3B;
  FUNCTION fn_xml2obj_AA(p_xmlmsg    VARCHAR2) RETURN tx.msg_AA;
  Procedure PRC_PROCESS2G(V_MSGXML VARCHAR2);
  Procedure PRC_PROCESS3B(V_MSGXML VARCHAR2);
  Procedure PRC_1I(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_1C(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_1F(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_1G(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_1D(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_3B(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_3C(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_3D(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  Procedure PRC_GETORDER(PV_REF IN OUT PKG_REPORT.REF_CURSOR, v_MsgType VARCHAR2);
  Procedure PRC_PROCESS2B(V_MSGXML VARCHAR2);
  Procedure PRC_PROCESSMSG(V_MSGGROUP VARCHAR2);
  FUNCTION fn_xml2obj_2C(p_xmlmsg    VARCHAR2) RETURN tx.msg_2C;
  Procedure PRC_PROCESS2C(V_MSGXML VARCHAR2);
  PROCEDURE          CONFIRM_CANCEL_NORMAL_ORDER (
   pv_orderid   IN   VARCHAR2,
   pv_qtty      IN   NUMBER
);

 PROCEDURE CONFIRM_REPLACE_NORMAL_ORDER (
   pv_ordernumber   IN   VARCHAR2,
   pv_price         IN   NUMBER
);

  FUNCTION fn_xml2obj_2E(p_xmlmsg    VARCHAR2) RETURN tx.msg_2E;
  Procedure PRC_PROCESS2E(V_MSGXML VARCHAR2);
  Procedure PRC_PROCESS2I(V_MSGXML VARCHAR2);
  FUNCTION fn_xml2obj_2I(p_xmlmsg    VARCHAR2) RETURN tx.msg_2I;
  FUNCTION fn_xml2obj_2F(p_xmlmsg    VARCHAR2) RETURN tx.msg_2F;
  FUNCTION fn_xml2obj_2L(p_xmlmsg    VARCHAR2) RETURN tx.msg_2L;
  FUNCTION fn_xml2obj_3C(p_xmlmsg    VARCHAR2) RETURN tx.msg_3C;
  FUNCTION fn_xml2obj_3D(p_xmlmsg    VARCHAR2) RETURN tx.msg_3D;
  FUNCTION fn_xml2obj_TS(p_xmlmsg    VARCHAR2) RETURN tx.msg_TS;
  FUNCTION fn_xml2obj_SC(p_xmlmsg    VARCHAR2) RETURN tx.msg_SC;
  FUNCTION fn_xml2obj_TR(p_xmlmsg    VARCHAR2) RETURN tx.msg_TR;
  FUNCTION fn_xml2obj_BS(p_xmlmsg    VARCHAR2) RETURN tx.msg_BS;
  FUNCTION fn_xml2obj_TC(p_xmlmsg    VARCHAR2) RETURN tx.msg_TC;
  Procedure PRC_PROCESS2L(V_MSGXML VARCHAR2);
  Procedure PRC_PROCESS2F(V_MSGXML VARCHAR2);
  Procedure PRC_PROCESS3C(V_MSGXML VARCHAR2);
  Procedure PRC_PROCESSSC(V_MSGXML VARCHAR2);
  Procedure PRC_PROCESSTR(V_MSGXML VARCHAR2);
  FUNCTION fn_xml2obj_GA(p_xmlmsg    VARCHAR2) RETURN tx.msg_GA;
  Procedure PRC_PROCESSGA(V_MSGXML VARCHAR2);
  FUNCTION fn_xml2obj_SU(p_xmlmsg    VARCHAR2) RETURN tx.msg_SU;
  FUNCTION fn_xml2obj_SS(p_xmlmsg    VARCHAR2) RETURN tx.msg_SS;
  Procedure PRC_PROCESSSU(V_MSGXML VARCHAR2);
  Procedure PRC_PROCESSSS(V_MSGXML VARCHAR2);
  Procedure PRC_PROCESSTS(V_MSGXML VARCHAR2,V_MSG_DATE VARCHAR2);
  Procedure PRC_PROCESSTC(V_MSGXML VARCHAR2);
  Procedure PRC_PROCESSBS(V_MSGXML VARCHAR2);
  Procedure PRC_PROCESS3D(V_MSGXML VARCHAR2);
  Procedure PRC_PROCESS2D(V_MSGXML VARCHAR2);
   Procedure PRC_PROCESSAA(V_MSGXML VARCHAR2);
  FUNCTION          FNC_CHECK_ROOM
  ( v_Symbol IN varchar2,
    v_Volumn In number,
    v_Custodycd in varchar2,
    v_BorS in  Varchar2)
  RETURN  number;
  FUNCTION fnc_check_sec_hcm
      ( v_Symbol IN varchar2)
      RETURN  number;
  FUNCTION fnc_check_traderid
      ( v_Machtype IN varchar2,
        v_BORS IN varchar2,
        v_Via in varchar2 default null)
      RETURN  number;
  FUNCTION    FNC_CHECK_ISNOTBOND
      ( v_Symbol IN Varchar2)
      RETURN  number;
  FUNCTION          FNC_CHECK_P_STOCKBOND
      ( v_Msgtype Varchar2,v_Symbol IN Varchar2)
      RETURN  number;
  Procedure PRC_1E(PV_REF IN OUT PKG_REPORT.REF_CURSOR);
  PROCEDURE          MATCHING_NORMAL_ORDER (
   firm               IN   VARCHAR2,
   order_number       IN   NUMBER,
   order_entry_date   IN   VARCHAR2,
   side_alph          IN   VARCHAR2,
   filler             IN   VARCHAR2,
   deal_volume        IN   NUMBER,
   deal_price         IN   NUMBER,
   confirm_number     IN   Varchar2
);
  Procedure PRC_PROCESSMSG_ERR;
  FUNCTION fn_caculate_hose_time
  RETURN VARCHAR2;
  FUNCTION fn_get_delta_time
  RETURN INTEGER;
END;
/
CREATE OR REPLACE PACKAGE BODY pck_hogw IS
  pkgctx plog.log_ctx;
  logrow tlogdebug%ROWTYPE;
  v_CheckProcess Boolean;
  FUNCTION fn_xml2obj(p_xmlmsg    VARCHAR2) RETURN tx.msg_rectype IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_rectype;
  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Header');
    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/TransactMessage');
    --<<Begin of header transformation>>
    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse header i: ' || i);
      l_node         := xmldom.item(l_nodeList, i);
      l_txmsg.msgtype  := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                'MSGTYPE'));
      l_txmsg.txnum  := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                'TXNUM'));
      l_txmsg.txdate := TO_DATE(xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                        'TXDATE')),
                                systemnums.c_date_format);

      l_txmsg.txtime := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                'TXTIME'));

      l_txmsg.brid := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                              'BRID'));

      l_txmsg.tlid := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                              'TLID'));

      l_txmsg.offid := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                               'OFFID'));
      plog.debug(pkgctx,'get ovrrqs from xml: ' ||xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                'OVRRQD')));
      l_txmsg.ovrrqd := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                'OVRRQD'));

      l_txmsg.chid := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                              'CHID'));

      l_txmsg.chkid := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                               'CHKID'));

      l_txmsg.txaction := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                  'MSGTYPE'));

      --l_txmsg.txaction := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),'ACTIONFLAG'));

      l_txmsg.tltxcd := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                'TLTXCD'));

      l_txmsg.ibt := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                             'IBT'));

      l_txmsg.brid2 := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                               'BRID2'));

      l_txmsg.tlid2 := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                               'TLID2'));

      l_txmsg.ccyusage := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                  'CCYUSAGE'));

      l_txmsg.off_line := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                  'OFFLINE'));

      l_txmsg.deltd := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                               'DELTD'));

      l_txmsg.brdate := TO_DATE(xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                        'BRDATE')),
                                systemnums.c_date_format);

      l_txmsg.busdate := TO_DATE(xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                         'BUSDATE')),
                                 systemnums.c_date_format);

      l_txmsg.txdesc := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                'TXDESC'));

      l_txmsg.ipaddress := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                   'IPADDRESS'));

      l_txmsg.wsname := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                'WSNAME'));

      l_txmsg.txstatus := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                  'STATUS'));

      l_txmsg.msgsts := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                'MSGSTS'));

      l_txmsg.ovrsts := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                'OVRSTS'));

      l_txmsg.batchname := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                   'BATCHNAME'));

      plog.debug(pkgctx, 'msgamt: ' || xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                'MSGAMT')));
      l_txmsg.msgamt := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                'MSGAMT'));

      plog.debug(pkgctx, 'msgacct: ' || xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                'msgacct')));
      l_txmsg.msgacct := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                 'MSGACCT'));

      l_txmsg.msgamt := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                'FEEAMT'));

      l_txmsg.msgacct := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                 'VATAMT'));

      l_txmsg.chktime := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                 'VOUCHER'));

      l_txmsg.chktime := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                 'CHKTIME'));

      l_txmsg.offtime := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                 'OFFTIME'));
      -- tx control

      l_txmsg.txtype := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                'TXTYPE'));

      l_txmsg.nosubmit := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                  'NOSUBMIT'));

      l_txmsg.pretran := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                 'PRETRAN'));

      l_txmsg.late := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                 'LATE'));
      l_txmsg.local := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                 'LOCAL'));
      l_txmsg.glgp := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                 'GLGP'));
      l_txmsg.careby := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                 'CAREBY'));
      plog.debug(pkgctx,'Header:' || CHR(10) || 'txnum: ' ||
                           l_txmsg.txnum || CHR(10) || 'txaction: ' ||
                           l_txmsg.txaction || CHR(10) || 'txstatus: ' ||
                           l_txmsg.txstatus || CHR(10) || 'pretran: ' ||
                           l_txmsg.pretran
                           );
    END LOOP;
    --<<End of header transformation>>

    --<<Begin of fields transformation>>
    plog.debug(pkgctx,'Prepare to parse Message Fields');
    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/TransactMessage/fields/entry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      l_fldname := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                           'fldname'));
      l_txmsg.txfields(l_fldname).type := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                  'fldtype'));
      l_txmsg.txfields(l_fldname).defname := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                     'defname'));
      l_txmsg.txfields(l_fldname).value := xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      plog.debug(pkgctx,'l_fldname(' || l_fldname || '): ' ||
                           l_txmsg.txfields(l_fldname).value);

    END LOOP;

    plog.debug(pkgctx,'Prepare to parse printinfo');
    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/TransactMessage/printinfo/entry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse PrinInfo: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      l_fldname := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                           'fldname'));
      l_txmsg.txPrintInfo(l_fldname).custname := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                         'custname'));
      l_txmsg.txPrintInfo(l_fldname).address := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                        'address'));
      l_txmsg.txPrintInfo(l_fldname).license := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                        'license'));
      l_txmsg.txPrintInfo(l_fldname).custody := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                        'custody'));
      l_txmsg.txPrintInfo(l_fldname).bankac := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                       'bankac'));
      l_txmsg.txPrintInfo(l_fldname).bankname := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                       'bankname'));
      l_txmsg.txPrintInfo(l_fldname).bankque := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                       'bankque'));
      l_txmsg.txPrintInfo(l_fldname).holdamt := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                       'holdamt'));
      l_txmsg.txPrintInfo(l_fldname).value := xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      plog.debug(pkgctx,'printinfo(' || l_fldname || '): ' ||
                           l_txmsg.txPrintInfo(l_fldname).value);

    END LOOP;

    plog.debug(pkgctx,'Prepare to parse Feemap');
    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/TransactMessage/feemap/entry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse feemap: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      l_txmsg.txInfo(l_fldname)(txnums.C_FEETRAN_FEECD) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                   'feecd'));
      l_txmsg.txInfo(l_fldname)(txnums.C_FEETRAN_GLACCTNO) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                      'glacctno'));
      l_txmsg.txInfo(l_fldname)(txnums.C_FEETRAN_FEEAMT) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                    'feeamt'));
      l_txmsg.txInfo(l_fldname)(txnums.C_FEETRAN_VATAMT) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                    'vatamt'));
      l_txmsg.txInfo(l_fldname)(txnums.C_FEETRAN_TXAMT) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                   'txamt'));
      l_txmsg.txInfo(l_fldname)(txnums.C_FEETRAN_FEERATE) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                     'feerate'));
      l_txmsg.txInfo(l_fldname)(txnums.C_FEETRAN_VATRATE) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                     'vatrate'));
    END LOOP;

    plog.debug(pkgctx,'Prepare to parse vatvoucher');
    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/TransactMessage/vatvoucher/entry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse vatvoucher: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      l_txmsg.txInfo(l_fldname)(txnums.C_VATTRAN_VOUCHERNO) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                       'voucherno'));
      l_txmsg.txInfo(l_fldname)(txnums.C_VATTRAN_VOUCHERTYPE) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                         'vouchertype'));
      l_txmsg.txInfo(l_fldname)(txnums.C_VATTRAN_SERIALNO) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                      'serieno'));
      l_txmsg.txInfo(l_fldname)(txnums.C_VATTRAN_VOUCHERDATE) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                         'voucherdate'));
      l_txmsg.txInfo(l_fldname)(txnums.C_VATTRAN_CUSTID) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                    'custid'));
      l_txmsg.txInfo(l_fldname)(txnums.C_VATTRAN_TAXCODE) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                     'taxcode'));
      l_txmsg.txInfo(l_fldname)(txnums.C_VATTRAN_CUSTNAME) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                      'custname'));
      l_txmsg.txInfo(l_fldname)(txnums.C_VATTRAN_ADDRESS) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                     'address'));
      l_txmsg.txInfo(l_fldname)(txnums.C_VATTRAN_CONTENTS) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                      'contents'));
      l_txmsg.txInfo(l_fldname)(txnums.C_VATTRAN_QTTY) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                  'qtty'));
      l_txmsg.txInfo(l_fldname)(txnums.C_VATTRAN_PRICE) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                   'price'));
      l_txmsg.txInfo(l_fldname)(txnums.C_VATTRAN_AMT) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                 'amt'));
      l_txmsg.txInfo(l_fldname)(txnums.C_VATTRAN_VATRATE) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                     'vatrate'));
      l_txmsg.txInfo(l_fldname)(txnums.C_VATTRAN_VATAMT) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                    'vatamt'));
      l_txmsg.txInfo(l_fldname)(txnums.C_VATTRAN_DESCRIPTION) := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                                         'description'));

    END LOOP;

    plog.debug(pkgctx,'Prepare to parse exception');
    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/TransactMessage/errorexception/entry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse txException: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      l_fldname := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                           'fldname'));
      l_txmsg.txException(l_fldname).type:= xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                         'fldtype'));
      l_txmsg.txException(l_fldname).oldval := xmldom.getvalue(xmldom.getattributenode(xmldom.makeelement(l_node),
                                                                                        'oldval'));
      l_txmsg.txException(l_fldname).value := xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      plog.debug(pkgctx,'Exception(' || l_fldname || '): ' ||
                           l_txmsg.txException(l_fldname).value);

    END LOOP;

    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);
    plog.setendsection(pkgctx, 'fn_xml2obj');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj;

  FUNCTION fn_obj2xml(p_txmsg tx.msg_rectype)
  RETURN VARCHAR2
  IS
   -- xmlparser
   l_parser              xmlparser.parser;
   -- Document
   l_doc            xmldom.domdocument;
   -- Elements
   l_element             xmldom.domelement;
   -- Nodes
   headernode      xmldom.domnode;
   docnode        xmldom.domnode;
   entrynode   xmldom.domnode;
   childnode   xmldom.domnode;
   textnode xmldom.DOMText;

   l_index varchar2(30); -- this must be match with arrtype index
   temp1          VARCHAR2 (32000);
   temp2          VARCHAR2 (2500);
BEGIN
   plog.setbeginsection(pkgctx, 'fn_obj2xml');

   l_parser              := xmlparser.newparser;
   xmlparser.parsebuffer (l_parser, '<TransactMessage/>');
   l_doc            := xmlparser.getdocument (l_parser);
   --xmldom.setversion (l_doc, '1.0');
   docnode        := xmldom.makenode (l_doc);

   --<< BEGIN OF CREATING MESSAGE HEADER>>
   l_element := xmldom.getdocumentelement(l_doc);
   xmldom.setattribute (l_element, 'MSGTYPE', p_txmsg.msgtype);
   xmldom.setattribute (l_element, 'TXNUM', p_txmsg.txnum);
   xmldom.setattribute (l_element, 'TXDATE', TO_CHAR(p_txmsg.txdate,systemnums.C_DATE_FORMAT));
   xmldom.setattribute (l_element, 'TXTIME', p_txmsg.txtime);
   xmldom.setattribute (l_element, 'BRID', p_txmsg.brid);
   xmldom.setattribute (l_element, 'TLID', p_txmsg.tlid);
   xmldom.setattribute (l_element, 'OFFID', p_txmsg.offid);
   xmldom.setattribute (l_element, 'OVRRQD', p_txmsg.ovrrqd);
   xmldom.setattribute (l_element, 'CHID', p_txmsg.chid);
   xmldom.setattribute (l_element, 'CHKID', p_txmsg.chkid);
   --xmldom.setattribute (l_element, 'ACTIONFLAG', p_txmsg.txaction);
   xmldom.setattribute (l_element, 'TLTXCD', p_txmsg.tltxcd);
   xmldom.setattribute (l_element, 'IBT', p_txmsg.ibt);
   xmldom.setattribute (l_element, 'BRID2', p_txmsg.brid2);
   xmldom.setattribute (l_element, 'TLID2', p_txmsg.tlid2);
   xmldom.setattribute (l_element, 'CCYUSAGE', p_txmsg.ccyusage);
   xmldom.setattribute (l_element, 'OFFLINE', p_txmsg.off_line);
   xmldom.setattribute (l_element, 'DELTD', p_txmsg.deltd);
   xmldom.setattribute (l_element, 'BRDATE', to_char(p_txmsg.brdate,systemnums.C_DATE_FORMAT));
   --xmldom.setattribute (l_element, 'PAGENO', p_txmsg.pageno);
   --xmldom.setattribute (l_element, 'TOTALPAGE', p_txmsg.totalpage);
   xmldom.setattribute (l_element, 'BUSDATE', to_char(p_txmsg.busdate,systemnums.C_DATE_FORMAT));
   xmldom.setattribute (l_element, 'TXDESC', p_txmsg.txdesc);
   xmldom.setattribute (l_element, 'IPADDRESS', p_txmsg.ipaddress);
   xmldom.setattribute (l_element, 'WSNAME', p_txmsg.wsname);
   xmldom.setattribute (l_element, 'STATUS', p_txmsg.txstatus);
   xmldom.setattribute (l_element, 'MSGSTS', p_txmsg.msgsts);
   xmldom.setattribute (l_element, 'OVRSTS', p_txmsg.ovrsts);
   xmldom.setattribute (l_element, 'BATCHNAME', p_txmsg.batchname);
   xmldom.setattribute (l_element, 'MSGAMT', p_txmsg.msgamt);
   xmldom.setattribute (l_element, 'MSGACCT', p_txmsg.msgacct);

   xmldom.setattribute (l_element, 'FEEAMT', p_txmsg.feeamt);
   xmldom.setattribute (l_element, 'VATAMT', p_txmsg.vatamt);
   xmldom.setattribute (l_element, 'VOUCHER', p_txmsg.voucher);

   xmldom.setattribute (l_element, 'CHKTIME', p_txmsg.chktime);
   xmldom.setattribute (l_element, 'OFFTIME', p_txmsg.offtime);
   xmldom.setattribute (l_element, 'TXTYPE', p_txmsg.txtype);
   xmldom.setattribute (l_element, 'NOSUBMIT', p_txmsg.nosubmit);
   xmldom.setattribute (l_element, 'PRETRAN', p_txmsg.pretran);

   --xmldom.setattribute (l_element, 'UPDATEMODE', p_txmsg.updatemode);
   xmldom.setattribute (l_element, 'LOCAL', p_txmsg.local);
   xmldom.setattribute (l_element, 'LATE', p_txmsg.late);
   --xmldom.setattribute (l_element, 'HOSTTIME', p_txmsg.HOSTTIME);
   --xmldom.setattribute (l_element, 'REFERENCE', p_txmsg.REFERENCE);
   xmldom.setattribute (l_element, 'GLGP', p_txmsg.glgp);
   xmldom.setattribute (l_element, 'CAREBY', p_txmsg.careby);

   headernode   := xmldom.appendchild (docnode, xmldom.makenode (l_element));
   --<< END of creating Message Header>>


   l_element             := xmldom.createelement (l_doc, 'fields');
   childnode    := xmldom.appendchild (headernode, xmldom.makenode (l_element));
   -- Create Fields
   l_index := p_txmsg.txfields.FIRST;
   plog.debug(pkgctx,'abt to populate fields,l_index: ' || l_index);
   WHILE (l_index IS NOT NULL)
   LOOP
       plog.debug(pkgctx,'loop with l_index: ' || l_index || ':' || p_txmsg.txfields(l_index).defname);

       l_element := xmldom.createelement (l_doc, 'entry');

       xmldom.setattribute (l_element, 'fldname', l_index);
       xmldom.setattribute (l_element, 'fldtype', p_txmsg.txfields(l_index).type);
       xmldom.setattribute (l_element, 'defname', p_txmsg.txfields(l_index).defname);
       entrynode   := xmldom.appendchild (childnode, xmldom.makenode(l_element));

       textnode := xmldom.createTextNode(l_doc, p_txmsg.txfields(l_index).value);
       entrynode := xmldom.appendChild(entrynode, xmldom.makeNode(textnode));
       -- get the next field
       l_index := p_txmsg.txfields.NEXT (l_index);
   END LOOP;
   -- Populate printInfo
   l_element             := xmldom.createelement (l_doc, 'printinfo');
   childnode    := xmldom.appendchild (headernode, xmldom.makenode (l_element));

   l_index := p_txmsg.txPrintInfo.FIRST;
   plog.debug(pkgctx,'prepare to populate printinfo, l_index: ' || l_index);
   WHILE (l_index IS NOT NULL)
   LOOP
       plog.debug(pkgctx,'loop with l_index: ' || l_index);
       l_element             := xmldom.createelement (l_doc, 'entry');

       xmldom.setattribute (l_element, 'fldname', l_index);
       xmldom.setattribute (l_element, 'custname', p_txmsg.txPrintInfo(l_index).custname);
       xmldom.setattribute (l_element, 'address', p_txmsg.txPrintInfo(l_index).address);
       xmldom.setattribute (l_element, 'license', p_txmsg.txPrintInfo(l_index).license);
       xmldom.setattribute (l_element, 'custody', p_txmsg.txPrintInfo(l_index).custody);
       xmldom.setattribute (l_element, 'bankac', p_txmsg.txPrintInfo(l_index).bankac);
       xmldom.setattribute (l_element, 'bankname', p_txmsg.txPrintInfo(l_index).bankname);
       xmldom.setattribute (l_element, 'bankque', p_txmsg.txPrintInfo(l_index).bankque);
       xmldom.setattribute (l_element, 'holdamt', p_txmsg.txPrintInfo(l_index).holdamt);
       entrynode   := xmldom.appendchild (childnode, xmldom.makenode (l_element));

       textnode := xmldom.createTextNode(l_doc, p_txmsg.txPrintInfo(l_index).value);
       entrynode := xmldom.appendChild(entrynode, xmldom.makeNode(textnode));
       -- get the next field
       l_index := p_txmsg.txPrintInfo.NEXT (l_index);
   END LOOP;

   -- Populate printInfo
   l_element             := xmldom.createelement (l_doc, 'ErrorException');
   childnode    := xmldom.appendchild (headernode, xmldom.makenode (l_element));

   l_index := p_txmsg.txException.FIRST;
   plog.debug(pkgctx,'prepare to populate ErrorException, l_index: ' || l_index);
   WHILE (l_index IS NOT NULL)
   LOOP
       plog.debug(pkgctx,'loop with l_index: ' || l_index);
       l_element             := xmldom.createelement (l_doc, 'entry');

       xmldom.setattribute (l_element, 'fldname', l_index);
       xmldom.setattribute (l_element, 'type', p_txmsg.txException(l_index).type);
       xmldom.setattribute (l_element, 'oldval', p_txmsg.txException(l_index).oldval);
       entrynode   := xmldom.appendchild (childnode, xmldom.makenode (l_element));

       textnode := xmldom.createTextNode(l_doc, p_txmsg.txException(l_index).value);
       entrynode := xmldom.appendChild(entrynode, xmldom.makeNode(textnode));
       -- get the next field
       l_index := p_txmsg.txException.NEXT (l_index);
   END LOOP;

   /*
   l_element             := xmldom.createelement (l_doc, 'ErrorException');
   childnode     := xmldom.appendchild (headernode, xmldom.makenode (l_element));

   l_element             := xmldom.createelement (l_doc, 'Entry');
   xmldom.setattribute (l_element, 'fldname', 'ERRSOURCE');
   xmldom.setattribute (l_element, 'fldtype', 'System.String');
   xmldom.setattribute (l_element, 'oldval', '');
   entrynode   := xmldom.appendchild (childnode, xmldom.makenode (l_element));
   textnode := xmldom.createTextNode(l_doc, '-100010');
   entrynode := xmldom.appendChild(entrynode, xmldom.makeNode(textnode));

   l_element             := xmldom.createelement (l_doc, 'Entry');
   xmldom.setattribute (l_element, 'fldname', 'ERRCODE');
   xmldom.setattribute (l_element, 'fldtype', 'System.Int64');
   xmldom.setattribute (l_element, 'oldval', '');
   entrynode   := xmldom.appendchild (childnode, xmldom.makenode (l_element));
   textnode := xmldom.createTextNode(l_doc, '-100010');
   entrynode := xmldom.appendChild(entrynode, xmldom.makeNode(textnode));

   l_element             := xmldom.createelement (l_doc, 'Entry');
   xmldom.setattribute (l_element, 'fldname', 'ERRMSG');
   xmldom.setattribute (l_element, 'fldtype', 'System.String');
   xmldom.setattribute (l_element, 'oldval', '');
   entrynode   := xmldom.appendchild (childnode, xmldom.makenode (l_element));
   textnode := xmldom.createTextNode(l_doc, '-100010');
   entrynode := xmldom.appendChild(entrynode, xmldom.makeNode(textnode));
   */

   xmldom.writetobuffer (l_doc, temp1);
   plog.debug(pkgctx,'got xml,length: ' || length(temp1));
   plog.debug(pkgctx,'got xml: ' || SUBSTR (temp1, 1, 1500));
   plog.debug(pkgctx,'got xml: ' || SUBSTR (temp1, 1501, 3000));
   --temp2          := SUBSTR (temp1, 1, 250);
   --DBMS_OUTPUT.put_line (temp2);

   --temp2          := SUBSTR (temp1, 251, 250);
   --DBMS_OUTPUT.put_line (temp2);
   plog.setendsection(pkgctx, 'fn_obj2xml');
   return temp1;
-- deal with exceptions
EXCEPTION
   WHEN others
   THEN
      plog.error(pkgctx,SQLERRM);
      plog.setendsection(pkgctx, 'fn_obj2xml');
      RAISE errnums.E_SYSTEM_ERROR;
END;


FUNCTION fn_xml2obj_2B(p_xmlmsg    VARCHAR2) RETURN tx.msg_2B IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_2B;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='order_number'  Then
        l_txmsg.order_number := TRIM(v_Value);
      Elsif v_Key ='firm' Then
        l_txmsg.firm := v_Value;
      Elsif v_Key ='order_entry_date' Then
        l_txmsg.order_entry_date := v_Value;
      End if;

      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild('key'));
    END LOOP;


    plog.debug(pkgctx,'msg 2B l_txmsg.order_number: '||l_txmsg.order_number||' l_txmsg.firm ='|| l_txmsg.firm);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_2B;

  FUNCTION fn_xml2obj_2E(p_xmlmsg    VARCHAR2) RETURN tx.msg_2E IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_2E;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_2E');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='order_number'  Then
        l_txmsg.order_number := TRIM(v_Value);
      Elsif v_Key ='confirm_number' Then
        l_txmsg.confirm_number := TRIM(v_Value);
      Elsif v_Key ='price' Then
        l_txmsg.price := v_Value;
      Elsif v_Key ='side' Then
        l_txmsg.side := v_Value;
      Elsif v_Key ='firm' Then
        l_txmsg.firm := v_Value;
      Elsif v_Key ='volume' Then
        l_txmsg.volume := v_Value;
      Elsif v_Key ='order_entry_date' Then
        l_txmsg.order_entry_date := v_Value;
      Elsif v_Key ='filler' Then
        l_txmsg.order_entry_date := v_Value;
      End if;

      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild('key'));
    END LOOP;


    plog.debug(pkgctx,'msg 2E l_txmsg.order_number: '||l_txmsg.order_number||' l_txmsg.confirm_number ='|| l_txmsg.confirm_number);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_2E');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_2E');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_2E;


  FUNCTION fn_xml2obj_2F(p_xmlmsg    VARCHAR2) RETURN tx.msg_2F IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_2F;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_2F');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='confirm_number'  Then
        l_txmsg.confirm_number := v_Value;
      Elsif v_Key ='firm_buy' Then
        l_txmsg.firm_buy := v_Value;
      Elsif v_Key ='price' Then
        l_txmsg.price := v_Value;
      Elsif v_Key ='side_b' Then
        l_txmsg.side_b := v_Value;
      Elsif v_Key ='volume' Then
        l_txmsg.volume := v_Value;
      Elsif v_Key ='security_symbol' Then
        l_txmsg.security_symbol := v_Value;
      Elsif v_Key ='trader_id_buy' Then
        l_txmsg.trader_id_buy := v_Value;
      Elsif v_Key ='board' Then
        l_txmsg.board := v_Value;
      Elsif v_Key ='contra_firm_sell' Then
        l_txmsg.contra_firm_sell := v_Value;
      Elsif v_Key ='trader_id_contra_side_sell' Then
        l_txmsg.trader_id_contra_side_sell := v_Value;
      End if;

      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild('key'));
    END LOOP;


    plog.debug(pkgctx,'msg 2F l_txmsg.confirm_number: '||l_txmsg.confirm_number
                    ||' l_txmsg.contra_firm_sell'|| l_txmsg.contra_firm_sell);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_2F');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_2F');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_2F;

  FUNCTION fn_xml2obj_2L(p_xmlmsg    VARCHAR2) RETURN tx.msg_2L IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_2L;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_2L');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='confirm_number'  Then
        l_txmsg.confirm_number := v_Value;
      Elsif v_Key ='price' Then
       --Format v_Price 000066500000 value: 66.5
        l_txmsg.price := Substr(v_Value,1,6)+ To_number('0.'||Substr(v_Value,7,6));
      Elsif v_Key ='side' Then
        l_txmsg.side := v_Value;
      Elsif v_Key ='contra_firm' Then
        l_txmsg.contra_firm := v_Value;
      Elsif v_Key ='firm' Then
        l_txmsg.firm := v_Value;
      Elsif v_Key ='volume' Then
        l_txmsg.volume := v_Value;
      Elsif v_Key ='deal_id' Then
        l_txmsg.deal_id := v_Value;
      End if;

      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild('key'));
    END LOOP;


    plog.debug(pkgctx,'msg 2L l_txmsg.confirm_number: '||l_txmsg.confirm_number
                    ||' l_txmsg.firm'|| l_txmsg.firm);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_2L');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_2L');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_2L;

  FUNCTION fn_xml2obj_3C(p_xmlmsg    VARCHAR2) RETURN tx.msg_3C IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_3C;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_3C');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='contra_firm'  Then
        l_txmsg.contra_firm := v_Value;
      Elsif v_Key ='security_symbol' Then
        l_txmsg.security_symbol := v_Value;
      Elsif v_Key ='confirm_number' Then
        l_txmsg.confirm_number := v_Value;
      Elsif v_Key ='firm' Then
        l_txmsg.firm := v_Value;
      Elsif v_Key ='side' Then
        l_txmsg.side := v_Value;
      Elsif v_Key ='trader_id' Then
        l_txmsg.trader_id := v_Value;
      End if;

      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild('key'));
    END LOOP;


    plog.debug(pkgctx,'msg 3C l_txmsg.confirm_number: '||l_txmsg.confirm_number
                    ||' l_txmsg.contra_firm'|| l_txmsg.contra_firm);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_3C');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_3C');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_3C;

  FUNCTION fn_xml2obj_3D(p_xmlmsg    VARCHAR2) RETURN tx.msg_3D IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_3D;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_3D');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='firm'  Then
        l_txmsg.firm := v_Value;
      Elsif v_Key ='confirm_number' Then
        l_txmsg.confirm_number := v_Value;
      Elsif v_Key ='reply_code' Then
        l_txmsg.reply_code := v_Value;
      End if;

      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild('key'));
    END LOOP;


    plog.debug(pkgctx,'msg 3D l_txmsg.confirm_number: '||l_txmsg.confirm_number
                    ||' l_txmsg.firm'|| l_txmsg.firm);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_3D');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_3D');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_3D;

/*
  FUNCTION fn_xml2obj_2D(p_xmlmsg    VARCHAR2) RETURN tx.msg_2D IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_2D;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_2D');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='ordernumber'  Then
        l_txmsg.ordernumber := v_Value;
      ELSIF v_Key ='clientid'  Then
        l_txmsg.clientid := v_Value;

      End if;

      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild('key'));
    END LOOP;


    plog.debug(pkgctx,'msg 2D l_txmsg.ordernumber: '||l_txmsg.ordernumber
                    );
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_2D');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_3D');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_2D;

  */

    FUNCTION fn_xml2obj_2D(p_xmlmsg    VARCHAR2) RETURN tx.msg_2D IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_2D;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_2D');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='ordernumber'  Then
        l_txmsg.ordernumber := Trim(v_Value);
      Elsif v_Key ='price' Then
        l_txmsg.price := Trim(v_Value);
      End if;

      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild('key'));
    END LOOP;


    plog.debug(pkgctx,'msg 2D l_txmsg.order_number: '||l_txmsg.ordernumber
                    ||' l_txmsg.price'|| l_txmsg.price);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_2D');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_2D');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_2D;

FUNCTION fn_xml2obj_AA(p_xmlmsg    VARCHAR2) RETURN tx.msg_AA IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_AA;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_AA');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='security_number'  Then
        l_txmsg.security_number := v_Value;
      Elsif v_Key ='firm' Then
        l_txmsg.firm := v_Value;
      Elsif v_Key ='price' Then
        l_txmsg.price := v_Value;
      Elsif v_Key ='side' Then
        l_txmsg.side := v_Value;
      Elsif v_Key ='volume' Then
        l_txmsg.volume := v_Value;
      Elsif v_Key ='contact' Then
        l_txmsg.contact := v_Value;
      Elsif v_Key ='trader' Then
        l_txmsg.trader := v_Value;
      Elsif v_Key ='board' Then
        l_txmsg.board := v_Value;
      Elsif v_Key ='time' Then
        l_txmsg.txtime := v_Value;
      Elsif v_Key ='add_cancel_flag' Then
        l_txmsg.add_cancel_flag := v_Value;
      End if;

      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild('key'));
    END LOOP;


    plog.debug(pkgctx,'msg AA l_txmsg.security_number: '||l_txmsg.security_number
                    ||' l_txmsg.firm'|| l_txmsg.firm);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_AA');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_AA');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_AA;

  FUNCTION fn_xml2obj_TS(p_xmlmsg    VARCHAR2) RETURN tx.msg_TS IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_TS;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_TS');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='timestamp'  Then
        l_txmsg.timestamp := v_Value;
      End if;

    END LOOP;


    plog.debug(pkgctx,'msg TS l_txmsg.timestamp: '||l_txmsg.timestamp);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_TS');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_TS');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_TS;


  FUNCTION fn_xml2obj_SC(p_xmlmsg    VARCHAR2) RETURN tx.msg_SC IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_SC;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_SC');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='timestamp'  Then
        l_txmsg.timestamp := v_Value;
      Elsif v_Key ='system_control_code' Then
        l_txmsg.system_control_code := v_Value;
      End if;

    END LOOP;


    plog.debug(pkgctx,'msg SC l_txmsg.timestamp: '||l_txmsg.timestamp
                       ||'l_txmsg.system_control_code: '||l_txmsg.system_control_code);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_SC');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_SC');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_SC;



 FUNCTION fn_xml2obj_SU(p_xmlmsg    VARCHAR2) RETURN tx.msg_SU IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_SU;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_SU');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='floor_price'  Then
        l_txmsg.floor_price := v_Value;
      Elsif v_Key ='benefit' Then
        l_txmsg.benefit := v_Value;
      Elsif v_Key ='ceiling_price' Then
        l_txmsg.ceiling_price := v_Value;
      Elsif v_Key ='open_price' Then
        l_txmsg.open_price := v_Value;
      Elsif v_Key ='security_name' Then
        l_txmsg.security_name := v_Value;
      Elsif v_Key ='security_number_new' Then
        l_txmsg.security_number_new := v_Value;
      Elsif v_Key ='prior_close_price' Then
        l_txmsg.prior_close_price := v_Value;
      Elsif v_Key ='halt_resume_flag' Then
        l_txmsg.halt_resume_flag := v_Value;
      Elsif v_Key ='notice' Then
        l_txmsg.notice := v_Value;
      Elsif v_Key ='delist' Then
        l_txmsg.delist := v_Value;
      Elsif v_Key ='par_value' Then
        l_txmsg.par_value := v_Value;
      Elsif v_Key ='total_shares_traded' Then
        l_txmsg.total_shares_traded := v_Value;
      Elsif v_Key ='security_number_old' Then
        l_txmsg.security_number_old := v_Value;
      Elsif v_Key ='board_lot' Then
        l_txmsg.board_lot := v_Value;
      Elsif v_Key ='highest_price' Then
        l_txmsg.highest_price := v_Value;
      Elsif v_Key ='suspension' Then
        l_txmsg.suspension := v_Value;
      Elsif v_Key ='sector_number' Then
        l_txmsg.sector_number := v_Value;
      Elsif v_Key ='client_id_required' Then
        l_txmsg.client_id_required := v_Value;
      Elsif v_Key ='sdc_flag' Then
        l_txmsg.sdc_flag := v_Value;
      Elsif v_Key ='prior_close_date' Then
        l_txmsg.prior_close_date := v_Value;
      Elsif v_Key ='market_id' Then
        l_txmsg.market_id := v_Value;
      Elsif v_Key ='meeting' Then
        l_txmsg.meeting := v_Value;
      Elsif v_Key ='filler_5' Then
        l_txmsg.filler_5 := v_Value;
      Elsif v_Key ='security_symbol' Then
        l_txmsg.security_symbol := v_Value;
      Elsif v_Key ='split' Then
        l_txmsg.split := v_Value;
      Elsif v_Key ='filler_4' Then
        l_txmsg.filler_4 := v_Value;
      Elsif v_Key ='security_type' Then
        l_txmsg.security_type := v_Value;
      Elsif v_Key ='filler_3' Then
        l_txmsg.filler_3 := v_Value;
      Elsif v_Key ='lowest_price' Then
        l_txmsg.lowest_price := v_Value;
      Elsif v_Key ='filler_2' Then
        l_txmsg.filler_2 := v_Value;
      Elsif v_Key ='filler_1' Then
        l_txmsg.filler_1 := v_Value;
      Elsif v_Key ='last_sale_price' Then
        l_txmsg.last_sale_price := v_Value;
      Elsif v_Key ='underlying_symbol' Then
        l_txmsg.underlyingsymbol := v_Value;
      Elsif v_Key ='issuer_name' Then
        l_txmsg.issuername := v_Value;
      Elsif v_Key ='covered_warrant_type' Then
        l_txmsg.coveredwarranttype := v_Value;
      Elsif v_Key ='maturity_date' Then
        l_txmsg.maturitydate := v_Value;
      Elsif v_Key ='last_trading_date' Then
        l_txmsg.lasttradingdate := v_Value;
      Elsif v_Key ='exercise_price' Then
        l_txmsg.exerciseprice := v_Value;
      Elsif v_Key ='exercise_ratio' Then
        l_txmsg.exerciseratio := v_Value;
      Elsif v_Key ='listed_share' Then
        l_txmsg.listedshare := v_Value;
      End if;
    END LOOP;


    plog.debug(pkgctx,'msg SU l_txmsg.security_symbol: '||l_txmsg.security_symbol
                       ||'l_txmsg.ceiling_price: '||l_txmsg.ceiling_price
                       ||'l_txmsg.floor_price: '||l_txmsg.floor_price);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_SU');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_SU');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_SU;




FUNCTION fn_xml2obj_SS(p_xmlmsg    VARCHAR2) RETURN tx.msg_SS IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_SS;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_SS');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP

      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);

      If v_Key ='board_lot'  Then
        l_txmsg.board_lot := v_Value;
      Elsif v_Key ='floor_price' Then
        l_txmsg.floor_price := v_Value;
      Elsif v_Key ='benefit' Then
        l_txmsg.benefit := v_Value;
      Elsif v_Key ='suspension' Then
        l_txmsg.suspension := v_Value;
      Elsif v_Key ='sector_number' Then
        l_txmsg.sector_number := v_Value;
      Elsif v_Key ='system_control_code' Then
        l_txmsg.system_control_code := v_Value;
      Elsif v_Key ='ceiling' Then
        l_txmsg.ceiling := v_Value;
      Elsif v_Key ='meeting' Then
        l_txmsg.meeting := v_Value;
      Elsif v_Key ='security_number' Then
        l_txmsg.security_number := v_Value;
      Elsif v_Key ='filler_6' Then
        l_txmsg.filler_6 := v_Value;
      Elsif v_Key ='filler_5' Then
        l_txmsg.filler_5 := v_Value;
      Elsif v_Key ='prior_close_price' Then
        l_txmsg.prior_close_price := v_Value;
      Elsif v_Key ='halt_resume_flag' Then
        l_txmsg.halt_resume_flag := v_Value;
      Elsif v_Key ='filler_4' Then
        l_txmsg.filler_4 := v_Value;
      Elsif v_Key ='split' Then
        l_txmsg.split := v_Value;
      Elsif v_Key ='security_type' Then
        l_txmsg.security_type := v_Value;
      Elsif v_Key ='filler_3' Then
        l_txmsg.filler_3 := v_Value;
      Elsif v_Key ='delist' Then
        l_txmsg.delist := v_Value;
      Elsif v_Key ='filler_2' Then
        l_txmsg.filler_2 := v_Value;
      Elsif v_Key ='notice' Then
        l_txmsg.notice := v_Value;
      Elsif v_Key ='filler_1' Then
        l_txmsg.filler_1 := v_Value;
      Elsif v_Key ='underlying_symbol' Then
        l_txmsg.underlyingsymbol := v_Value;
      Elsif v_Key ='issuer_name' Then
        l_txmsg.issuername := v_Value;
      Elsif v_Key ='covered_warrant_type' Then
        l_txmsg.coveredwarranttype := v_Value;
      Elsif v_Key ='maturity_date' Then
        l_txmsg.maturitydate := v_Value;
      Elsif v_Key ='last_trading_date' Then
        l_txmsg.lasttradingdate := v_Value;
      Elsif v_Key ='exercise_price' Then
        l_txmsg.exerciseprice := v_Value;
      Elsif v_Key ='exercise_ratio' Then
        l_txmsg.exerciseratio := v_Value;
      Elsif v_Key ='listed_share' Then
        l_txmsg.listedshare := v_Value;
      End if;
    END LOOP;


    plog.debug(pkgctx,'msg SU l_txmsg.security_number: '||l_txmsg.security_number
                       ||'l_txmsg.ceiling: '||l_txmsg.ceiling
                       ||'l_txmsg.floor_price: '||l_txmsg.floor_price);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_SS');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_SS');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_SS;


  FUNCTION fn_xml2obj_TR(p_xmlmsg    VARCHAR2) RETURN tx.msg_TR IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_TR;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_TR');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='current_room'  Then
        l_txmsg.current_room := v_Value;
      Elsif v_Key ='security_number' Then
        l_txmsg.security_number := v_Value;
      Elsif v_Key ='total_room' Then
        l_txmsg.total_room := v_Value;
      End if;

    END LOOP;


    plog.debug(pkgctx,'msg TR l_txmsg.security_number: '||l_txmsg.security_number
                       ||'l_txmsg.current_room: '||l_txmsg.current_room);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_TR');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_TR');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_TR;


FUNCTION fn_xml2obj_GA(p_xmlmsg    VARCHAR2) RETURN tx.msg_GA IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_GA;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_GA');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='admin_message_text'  Then
        l_txmsg.admin_message_text := v_Value;
      Elsif v_Key ='admin_message_length' Then
        l_txmsg.admin_message_length := v_Value;
      End if;

    END LOOP;


    plog.debug(pkgctx,'msg GA l_txmsg.admin_message_text: '||l_txmsg.admin_message_text
                       ||'l_txmsg.admin_message_length: '||l_txmsg.admin_message_length);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_GA');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_GA');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_GA;

  FUNCTION fn_xml2obj_BS(p_xmlmsg    VARCHAR2) RETURN tx.msg_BS IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_BS;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_BS');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='firm'  Then
        l_txmsg.firm := v_Value;
      Elsif v_Key ='automatch_halt_flag' Then
        l_txmsg.automatch_halt_flag := v_Value;
      Elsif v_Key ='put_through_halt_flag' Then
        l_txmsg.put_through_halt_flag := v_Value;
      End if;

    END LOOP;


    plog.debug(pkgctx,'msg BS l_txmsg.firm: '||l_txmsg.firm
                       ||'l_txmsg.automatch_halt_flag: '||l_txmsg.automatch_halt_flag
                       ||'l_txmsg.put_through_halt_flag: '||l_txmsg.put_through_halt_flag);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_BS');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_BS');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_BS;

  FUNCTION fn_xml2obj_TC(p_xmlmsg    VARCHAR2) RETURN tx.msg_TC IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_TC;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_TC');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='firm'  Then
        l_txmsg.firm := v_Value;
      Elsif v_Key ='trader_id' Then
        l_txmsg.trader_id := v_Value;
      Elsif v_Key ='trader_status' Then
        l_txmsg.trader_status := v_Value;
      End if;

    END LOOP;


    plog.debug(pkgctx,'msg TC l_txmsg.firm: '||l_txmsg.firm
                       ||'l_txmsg.trader_id: '||l_txmsg.trader_id
                       ||'l_txmsg.trader_status: '||l_txmsg.trader_status);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_TC');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_TC');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_TC;



  FUNCTION fn_xml2obj_2I(p_xmlmsg    VARCHAR2) RETURN tx.msg_2I IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_2I;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_2I');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='confirm_number'  Then
        l_txmsg.confirm_number := TRIM(v_Value);
      Elsif v_Key ='price' Then
        l_txmsg.price := v_Value;
      Elsif v_Key ='order_number_sell' Then
        l_txmsg.order_number_sell := v_Value;
      Elsif v_Key ='order_entry_date_sell' Then
        l_txmsg.order_entry_date_sell := v_Value;
      Elsif v_Key ='firm' Then
        l_txmsg.firm := v_Value;
      Elsif v_Key ='volume' Then
        l_txmsg.volume := v_Value;
      Elsif v_Key ='order_number_buy' Then
        l_txmsg.order_number_buy := v_Value;
      Elsif v_Key ='order_entry_date_buy' Then
        l_txmsg.order_entry_date_buy := v_Value;
      End if;

      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild('key'));
    END LOOP;


    plog.debug(pkgctx,'msg 2I l_txmsg.order_number_sell: '||l_txmsg.order_number_sell
                     ||' l_txmsg.order_number_buy: '||l_txmsg.order_number_buy
                     ||' l_txmsg.confirm_number: '||l_txmsg.confirm_number);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj_2I');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj_2I');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_2I;


FUNCTION fn_xml2obj_2C(p_xmlmsg    VARCHAR2) RETURN tx.msg_2C IS
    l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_2C;
    v_Key Varchar2(100);
    v_Value Varchar2(100);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='order_number'  Then
        l_txmsg.order_number := v_Value;
      Elsif v_Key ='firm' Then
        l_txmsg.firm := v_Value;
      Elsif v_Key ='order_entry_date' Then
        l_txmsg.order_entry_date := v_Value;
      Elsif v_Key ='cancel_shares' Then
        l_txmsg.cancel_shares := v_Value;
      Elsif v_Key ='order_cancel_status' Then
        l_txmsg.order_cancel_status := v_Value;
      End if;

      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild('key'));
    END LOOP;


    plog.debug(pkgctx,'msg 2C l_txmsg.order_number: '||l_txmsg.order_number||
                        ' l_txmsg.firm ='|| l_txmsg.firm ||'l_txmsg.cancel_shares ='||l_txmsg.cancel_shares);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_xml2obj_2C;
FUNCTION fn_xml2obj_2G(p_xmlmsg    VARCHAR2) RETURN tx.msg_2G IS
 l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_2G;
    v_Key Varchar2(100);
    v_Value Varchar2(500);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_2G');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='order_number'  Then
        l_txmsg.order_number := v_Value;
      Elsif v_Key ='firm' Then
        l_txmsg.firm := v_Value;
      Elsif v_Key ='order_entry_date' Then
        l_txmsg.order_entry_date := v_Value;
      Elsif v_Key ='reject_reason_code' Then
        l_txmsg.reject_reason_code := v_Value;
      Elsif v_Key ='original_message_text' Then
        l_txmsg.original_message_text := v_Value;
      ELSIF v_key='msg_type' then
        l_txmsg.msg_type:=v_Value;
      End if;


      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild('key'));
    END LOOP;


    plog.debug(pkgctx,'msg 2G l_txmsg.order_number: '||l_txmsg.order_number||' l_txmsg.firm ='|| l_txmsg.firm);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj');
      RAISE errnums.E_SYSTEM_ERROR;
End   fn_xml2obj_2G;
FUNCTION fn_xml2obj_3B(p_xmlmsg    VARCHAR2) RETURN tx.msg_3B IS
 l_parser   xmlparser.parser;
    l_doc      xmldom.domdocument;
    l_nodeList xmldom.domnodelist;
    l_node     xmldom.domnode;
    n     xmldom.domnode;

    l_fldname fldmaster.fldname%TYPE;
    l_txmsg   tx.msg_3B;
    v_Key Varchar2(100);
    v_Value Varchar2(500);


  BEGIN
    plog.setbeginsection (pkgctx, 'fn_xml2obj_3b');

    plog.debug(pkgctx,'msg length: ' || length(p_xmlmsg));
    l_parser := xmlparser.newparser();
    plog.debug(pkgctx,'1');
    xmlparser.parseclob(l_parser, p_xmlmsg);
    plog.debug(pkgctx,'2');
    l_doc := xmlparser.getdocument(l_parser);
    plog.debug(pkgctx,'3');
    xmlparser.freeparser(l_parser);

    plog.debug(pkgctx,'Prepare to parse Message Fields');

    l_nodeList := xslprocessor.selectnodes(xmldom.makenode(l_doc),
                                           '/ArrayOfHoSEMessageEntry/hoSEMessageEntry');

    FOR i IN 0 .. xmldom.getlength(l_nodeList) - 1 LOOP
      plog.debug(pkgctx,'parse fields: ' || i);
      l_node := xmldom.item(l_nodeList, i);
      dbms_xslprocessor.valueOf(l_node,'key',v_Key);
      dbms_xslprocessor.valueOf(l_node,'value',v_Value);
      If v_Key ='confirm_number'  Then
        l_txmsg.confirm_number := v_Value;
      Elsif v_Key ='firm' Then
        l_txmsg.firm := v_Value;
      Elsif v_Key ='deal_id' Then
        l_txmsg.deal_id := v_Value;
      Elsif v_Key ='client_id_buyer' Then
        l_txmsg.client_id_buyer := v_Value;
      Elsif v_Key ='reply_code' Then
        l_txmsg.reply_code := v_Value;
      End if;
      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild(l_node));
      --v_Key:=xmldom.getnodevalue(xmldom.getfirstchild('key'));
    END LOOP;


    plog.debug(pkgctx,'msg 3b l_txmsg.deal_id: '||l_txmsg.deal_id||' l_txmsg.firm ='|| l_txmsg.firm);
    plog.debug(pkgctx,'Free resources associated');

    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
    -- Only used if variant is CLOB
    -- dbms_lob.freetemporary(p_xmlmsg);

    plog.setendsection(pkgctx, 'fn_xml2obj');
    RETURN l_txmsg;
  EXCEPTION
    WHEN OTHERS THEN
      --dbms_lob.freetemporary(p_xmlmsg);
      DBMS_XMLPARSER.freeparser(l_parser);
      DBMS_XMLDOM.freedocument(l_doc);
      plog.error(pkgctx, SQLERRM);
      plog.setendsection(pkgctx, 'fn_xml2obj');
      RAISE errnums.E_SYSTEM_ERROR;
End   fn_xml2obj_3B;

/*
  --Day message lenh thong thuong 1I len Gw
  Procedure PRC_1I(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);

    CURSOR C_1I IS
        SELECT seq_ordermap.NEXTVAL ORDER_NUMBER,'M' BOARD_ALPH,CUSTODYCD CLIENT_ID_ALPH,'     ' FILLER_1,'     ' FILLER_2,
        FIRM,
        CASE
        WHEN  SUBSTR(CUSTODYCD,4,1) = 'A' OR SUBSTR(CUSTODYCD,4,1) ='B' THEN 'M'
        WHEN  SUBSTR(CUSTODYCD,4,1) ='E' OR SUBSTR(CUSTODYCD,4,1) ='F' THEN 'F'
        ELSE  SUBSTR(CUSTODYCD,4,1) END PORT_CLIENT_FLAG_ALPH,
        QUOTEPRICE PRICE,ORDERQTTY PUBLISHED_VOLUME ,ORDERQTTY VOLUME,SYMBOL SECURITY_SYMBOL_ALPH,
        BORS SIDE_ALPH, PCK_HOGW.FNC_CHECK_TRADERID('N',BORS,VIA) TRADER_ID_ALPH,ORDERID FROM
        ho_send_order
        WHERE ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='HOSESENDSIZE')
        and PCK_HOGW.FNC_CHECK_TRADERID('N',BORS) <> '0'
        --Da check trong view
        --and PCK_HOGW.FNC_CHECK_ISNOTBOND(SYMBOL) <>'0'
        and PCK_HOGW.FNC_CHECK_ROOM(SYMBOL,ORDERQTTY,CUSTODYCD,BORS)<>'0'
        --and PCK_HOGW.FNC_CHECK_SEC_HCM(SYMBOL) <> '0'
        ;
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_1I');
      FOR I IN C_1I
      LOOP
        INSERT INTO ho_1i
                (firm, trader_id_alph, order_number, client_id_alph,
                 security_symbol_alph, side_alph, volume, published_volume,
                 price, board_alph, filler_1, port_client_flag_alph,
                 filler_2, orderid, status
                )
         VALUES (I.firm, I.trader_id_alph, I.order_number, I.client_id_alph,
                 I.security_symbol_alph, I.side_alph, I.volume, I.published_volume,
                 I.price, I.board_alph, I.filler_1, I.port_client_flag_alph,
                 I.filler_2, I.orderid, 'N'
                );
      --XU LY LENH 1I
        --1.1DAY VAO ORDERMAP.
        INSERT INTO ORDERMAP(ctci_order,orgorderid) VALUES (I.order_number,I.orderid);
        --1.2 CAP NHAT OOD.
        UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
        --1.3 DAY LENH VAO ODQUEUE
        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;
      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        RPAD(FIRM,3,' ') FIRM,
        RPAD(TRADER_ID_ALPH,4,' ') TRADER_ID,
        RPAD(ORDER_NUMBER,8,' ') ORDER_NUMBER,
        RPAD(CLIENT_ID_ALPH,10,' ') CLIENT_ID,
        RPAD(SECURITY_SYMBOL_ALPH,8,' ') SECURITY_SYMBOL,
        RPAD(SIDE_ALPH,1,' ') SIDE,
        RPAD(VOLUME,8,' ') VOLUME,
        RPAD(PUBLISHED_VOLUME,8,' ') PUBLISHED_VOLUME,
        RPAD(PRICE,6,' ') PRICE,
        RPAD(BOARD_ALPH,1,' ') BOARD,
        RPAD(FILLER_1,5,' ') FILLER_1,
        RPAD(PORT_CLIENT_FLAG_ALPH,1,' ') PORT_CLIENT_FLAG,
        RPAD(FILLER_2,5,' ') FILLER_2
        FROM ho_1i WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ho_1i SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_1I');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_1I');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_1I;*/


  --Day message lenh thong thuong 1I len Gw
  --Day message lenh thong thuong 1I len Gw


 Procedure PRC_1I(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);
    v_Temp VARCHAR2(30);
    v_Check BOOLEAN;
    v_strSysCheckBuySell VARCHAR2(30);
    v_Order_Number varchar2(10);
    v_count_ood Number;

    CURSOR C_1I IS
        SELECT 'M' BOARD_ALPH,CUSTODYCD CLIENT_ID_ALPH,'     ' FILLER_1,'     ' FILLER_2,
        FIRM,
        CASE
        WHEN  SUBSTR(CUSTODYCD,4,1) = 'A' OR SUBSTR(CUSTODYCD,4,1) ='B' THEN 'M'
        WHEN  SUBSTR(CUSTODYCD,4,1) ='E' OR SUBSTR(CUSTODYCD,4,1) ='F' THEN 'F'
        ELSE  SUBSTR(CUSTODYCD,4,1) END PORT_CLIENT_FLAG_ALPH,
        QUOTEPRICE PRICE,ORDERQTTY PUBLISHED_VOLUME ,ORDERQTTY VOLUME,SYMBOL SECURITY_SYMBOL_ALPH,
        BORS SIDE_ALPH, PCK_HOGW.FNC_CHECK_TRADERID('N',BORS,VIA) TRADER_ID_ALPH,ORDERID,CODEID FROM
        ho_send_order
        --WHERE ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='HOSESENDSIZE')
            --WHERE
            --(
            --ROWNUM BETWEEN 0 AND 100
            -- AND to_char(sysdate,'hh24miss') >'090000'
            --OR
            --ROWNUM BETWEEN 0 AND 10 AND to_char(sysdate,'hh24miss') <'090000'
            -- to_char(sysdate,'hh24miss') <'090000' AND rownum <=10 - (Select Count(*) from ho_1i )
            --)

        --and PCK_HOGW.FNC_CHECK_TRADERID('N',BORS,VIA) <> '0'
        --Da check trong view
        --and PCK_HOGW.FNC_CHECK_ISNOTBOND(SYMBOL) <>'0'
        --and PCK_HOGW.FNC_CHECK_ROOM(SYMBOL,ORDERQTTY,CUSTODYCD,BORS)<>'0'
        --and PCK_HOGW.FNC_CHECK_SEC_HCM(SYMBOL) <> '0'
        ;
    Cursor c_Check_Doiung(v_BorS Varchar2, v_Custodycd Varchar2,v_Codeid Varchar2, v_controlcode VARCHAR2, v_strTRADEBUYSELLPT varchar2 ) is
                       SELECT ORGORDERID FROM ood o , odmast od
                       WHERE o.orgorderid = od.orderid and o.custodycd =v_Custodycd and o.codeid=v_Codeid
                             And o.bors <> v_BorS
                             And od.remainqtty >0
                             and od.deltd<>'Y'
                             AND od.EXECTYPE in ('NB','NS','MS')
                             And o.oodstatus in ('B','S')
                             AND NVL(od.hosesession,'N') = v_controlcode
                             and (v_strTRADEBUYSELLPT='N'
                                  or (v_strTRADEBUYSELLPT='Y' and od.matchtype <>'P'));

   Cursor C_Send_Size is SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='HOSESENDSIZE';
   v_Send_Size  Number;
   v_Count_Order varchar2(10);
   l_controlcode varchar2(10);
   l_strTRADEBUYSELLPT  VARCHAR2(10); -- Y Thi cho phep dat lenh thoa thuan doi ung

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_1I');

    Begin
        Select VARVALUE into v_strSysCheckBuySell from sysvar where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELL';
    Exception When OTHERS Then
        v_strSysCheckBuySell:='N';
    End;

    Begin
          Select VARVALUE Into l_strTRADEBUYSELLPT
          From sysvar
          Where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELLPT' ;
    EXCEPTION when OTHERS Then
            l_strTRADEBUYSELLPT:='N';
    End;

    Open C_Send_Size;
    Fetch C_Send_Size Into v_Send_Size;
    If C_Send_Size%notfound Then
     v_Send_Size:=100;
    End if;
    Close C_Send_Size;

    v_Count_Order:=0;

      FOR I IN C_1I
      LOOP

         --Kiem tra neu co lenh doi ung Block, Sent chua khop het thi khong day len GW.
         --Sysvar ko cho BuySell thi check doi ung.
         v_Check:=False;

            l_controlcode:=fn_get_controlcode(i.security_symbol_alph);
            If v_strSysCheckBuySell ='N' and l_controlcode in ('P','A','I','J','G','K') Then

                 Open c_Check_Doiung(I.SIDE_ALPH, I.CLIENT_ID_ALPH,I.CODEID,l_controlcode,l_strTRADEBUYSELLPT);
                 Fetch c_Check_Doiung into v_Temp;
                   If c_Check_Doiung%found then
                    v_Check:=True;
                   End if;
                 Close c_Check_Doiung;
         End if;

         IF Not v_Check THEN
            v_count_ood:=0;
            SELECT count(*) into v_count_ood FROM OOD WHERE ORGORDERID=I.orderid;
            IF v_count_ood >0 Then

               SELECT '6'||seq_ordermap.NEXTVAL Into v_Order_Number From dual;

               INSERT INTO ho_1i
                        (firm, trader_id_alph, order_number, client_id_alph,
                         security_symbol_alph, side_alph, volume, published_volume,
                         price, board_alph, filler_1, port_client_flag_alph,
                         filler_2, orderid, status
                        )
                 VALUES (I.firm, I.trader_id_alph, v_Order_Number, I.client_id_alph,
                         I.security_symbol_alph, I.side_alph, I.volume, I.published_volume,
                         I.price, I.board_alph, I.filler_1, I.port_client_flag_alph,
                         I.filler_2, I.orderid, 'N'
                        );
              --XU LY LENH 1I
                --1.1DAY VAO ORDERMAP.
                INSERT INTO ORDERMAP(ctci_order,orgorderid) VALUES (v_Order_Number,I.orderid);
                --1.2 CAP NHAT OOD.
                UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
                UPDATE ODMAST SET hosesession= l_controlcode WHERE ORDERID=I.orderid;
                --1.3 DAY LENH VAO ODQUEUE
                INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;
                v_Count_Order:=v_Count_Order+1;
              End if;
          END IF;
          Exit WHEN v_Count_Order >= v_Send_Size;
   END LOOP;

   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        RPAD(FIRM,3,' ') FIRM,
        RPAD(TRADER_ID_ALPH,4,' ') TRADER_ID,
        RPAD(ORDER_NUMBER,8,' ') ORDER_NUMBER,
        RPAD(CLIENT_ID_ALPH,10,' ') CLIENT_ID,
        RPAD(SECURITY_SYMBOL_ALPH,8,' ') SECURITY_SYMBOL,
        RPAD(SIDE_ALPH,1,' ') SIDE,
        RPAD(VOLUME,8,' ') VOLUME,
        RPAD(PUBLISHED_VOLUME,8,' ') PUBLISHED_VOLUME,
        RPAD(PRICE,6,' ') PRICE,
        RPAD(BOARD_ALPH,1,' ') BOARD,
        RPAD(FILLER_1,5,' ') FILLER_1,
        RPAD(PORT_CLIENT_FLAG_ALPH,1,' ') PORT_CLIENT_FLAG,
        RPAD(FILLER_2,5,' ') FILLER_2
        FROM ho_1i WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ho_1i SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_1I');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_1I');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_1I;

  --Day lenh huy len Gw
  Procedure PRC_1C(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);

    CURSOR C_1C IS

        SELECT FIRM,CTCI_ORDER ORDER_NUMBER,ORDERID,--'2708' ORDER_ENTRY_DATE
        SUBSTR(ORDERID,5,4) ORDER_ENTRY_DATE
        FROM (
        SELECT ODM.CTCI_ORDER,S.VARVALUE FIRM, A.ORGORDERID ORDERID
        FROM OOD A, SBSECURITIES B, ODMAST C,ODMAST E,
             --AFMAST I, CFMAST J,
             TLLOG, SYSVAR S,ORDERMAP ODM
        WHERE (A.CODEID = B.CODEID AND A.ORGORDERID = E.ORDERID
          AND E.REFORDERID=C.ORDERID)
          AND NVL(c.ISFO_ORDER,'N') <>'Y'
          AND E.REFORDERID=ODM.ORGORDERID
          AND A.TXDATE = TLLOG.TXDATE AND A.TXNUM = TLLOG.TXNUM
          AND (TLLOG.TXSTATUS = '1' OR (TLLOG.TLTXCD IN ('8882','8883') AND TLLOG.TXSTATUS = '1' ) )
          AND B.CODEID = C.CODEID
          AND C.ORSTATUS NOT IN ('3','0','6','8') AND C.MATCHTYPE ='N' AND C.REMAINQTTY >0
          AND B.TRADEPLACE='001'
          AND OODSTATUS IN ('N') AND C.DELTD <> 'Y'  AND TLLOG.TLTXCD IN ('8882','8883')
          AND S.GRNAME='SYSTEM' AND S.VARNAME='FIRM'
          AND C.ORDERQTTY >  (SELECT NVL(SUM(VOLUME),0) FROM F2E_2I WHERE ORDERNUMBER =ODM.CTCI_ORDER)
          --AND TO_CHAR(SYSDATE,'HH24MI')>='0847'
          --AND to_char(sysdate,'hh24miss') <='104505'
          AND C.HOSESESSION <>'A'
          AND INSTR((select inperiod from msgmast where msgtype ='1C'),
                    (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='CONTROLCODE')) >0
          )
         WHERE ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='HOSESENDSIZE');

         CURSOR C_1C_ADMEND IS
                SELECT FIRM,CTCI_ORDER ORDER_NUMBER,ORDERID,--'2708' ORDER_ENTRY_DATE,
                SUBSTR(ORDERID,5,4) ORDER_ENTRY_DATE,
                       AdmendPrice
                FROM (
                SELECT ODM.CTCI_ORDER,S.VARVALUE FIRM, A.ORGORDERID ORDERID, e.quoteprice AdmendPrice
                FROM OOD A, SBSECURITIES B, ODMAST C,ODMAST E,
                      SYSVAR S,ORDERMAP ODM
                WHERE (A.CODEID = B.CODEID AND A.ORGORDERID = E.ORDERID
                  AND E.REFORDERID=C.ORDERID)
                  AND E.REFORDERID=ODM.ORGORDERID
                  AND B.CODEID = C.CODEID
                  AND C.ORSTATUS NOT IN ('3','0','6','8') AND C.MATCHTYPE ='N' AND C.REMAINQTTY >0
                  AND B.TRADEPLACE='001'
                  AND a.OODSTATUS IN ('N') AND E.exectype IN ('AS','AB') and e.deltd<>'Y'
                  AND S.GRNAME='SYSTEM' AND S.VARNAME='FIRM'
                  AND C.HOSESESSION <>'A'
                  AND INSTR((select inperiod from msgmast where msgtype ='1C'),
                    (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='CONTROLCODE')) >0
                  );
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_1C');
      FOR I IN C_1C
      LOOP
        INSERT INTO ho_1c
                    (order_entry_date, order_number, firm, orderid, date_time,
                     status
                    )
             VALUES (I.order_entry_date, I.order_number, I.firm, I.orderid, '',
                     'N'
                    );
      --XU LY LENH 1C
        --1.1 CAP NHAT OOD.
        UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
        --1.2 DAY LENH VAO ODQUEUE
        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;
      END LOOP;

       FOR I IN C_1C_ADMEND
      LOOP
        INSERT INTO ho_1c
                    (order_entry_date, order_number, firm, orderid, date_time,
                     status
                    )
             VALUES (I.order_entry_date, I.order_number, I.firm, I.orderid, '',
                     'N'
                    );
      --XU LY LENH 1C
        --1.1 CAP NHAT OOD.
        UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
        --1.2 DAY LENH VAO ODQUEUE
        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;
      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        RPAD(ORDER_ENTRY_DATE,4,' ') ORDER_ENTRY_DATE,
        RPAD(ORDER_NUMBER,8,' ') ORDER_NUMBER,
        RPAD(FIRM,3,' ') FIRM
   FROM ho_1c WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ho_1c SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_1C');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_1C');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_1C;

/*
  --Day message lenh thong thuong 1F len Gw
  Procedure PRC_1F(PV_REF IN OUT PKG_REPORT.REF_CURSOR) Is

    v_err VARCHAR2(200);

    CURSOR C_1F IS
        SELECT  SEQ_ORDERMAP.NEXTVAL ORDER_NUMBER,ORDERID,FIRM,FNC_CHECK_TRADERID('P',BORS) TRADER_ID_ALPH, BCLIENTID CLIENT_ID_BUYER_ALPH,SCLIENTID CLIENT_ID_SELLER_ALPH,SYMBOL SECURITY_SYMBOL_ALPH,'B' BOARD_ALPH,
        lpad(floor(QUOTEPRICE),6,'0')||rpad(replace((QUOTEPRICE -floor(QUOTEPRICE))*10,'.',''),6,'0') PRICE,'        ' FILLER_1,'        ' FILLER_2,'        ' FILLER_3,
        (CASE WHEN BCUSTODIAN='P' THEN ORDERQTTY ELSE 0 END) BROKER_PORTFOLIO_VOLUME_BUYER,
        (CASE WHEN SCUSTODIAN='P' THEN ORDERQTTY ELSE 0 END) BROKER_PORTFOLIO_VOLUME_SELLER,
        (CASE WHEN BCUSTODIAN='C' THEN ORDERQTTY ELSE 0 END) BROKER_CLIENT_VOLUME_BUYER,
        (CASE WHEN SCUSTODIAN='C' THEN ORDERQTTY ELSE 0 END) BROKER_CLIENT_VOLUME_SELLER,
        (CASE WHEN BCUSTODIAN='F' OR  BCUSTODIAN='E' THEN ORDERQTTY ELSE 0 END) BROKER_FOREIGN_VOLUME_BUYER,
        (CASE WHEN SCUSTODIAN='F' OR  SCUSTODIAN='E' THEN ORDERQTTY ELSE 0 END) BROKER_FOREIGN_VOLUME_SELLER,
        (CASE WHEN BCUSTODIAN='A' OR  BCUSTODIAN='B' THEN ORDERQTTY ELSE 0 END) MUTUAL_FUND_VOLUME_BUYER,
        (CASE WHEN SCUSTODIAN='A' OR  SCUSTODIAN='B' THEN ORDERQTTY ELSE 0 END) MUTUAL_FUND_VOLUME_SELLER,
        BUYORDERID BUYORDERID
        FROM
        SEND_PUTTHROUGH_ORDER_TO_HOSE
        WHERE  INSTR((select inperiod from msgmast where msgtype ='1F'),
         (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='CONTROLCODE')) >0
        And PCK_HOGW.FNC_CHECK_TRADERID('P',BORS) <> '0'
        And PCK_HOGW.fnc_check_P_stockbond('1F',SYMBOL) <>'0'
        and (SCUSTODIAN='F' or PCK_HOGW.FNC_CHECK_ROOM(SYMBOL,ORDERQTTY,BCLIENTID,'B')<>'0')
        And PCK_HOGW.FNC_CHECK_SEC_HCM(SYMBOL) <> '0';
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_1F');
      FOR I IN C_1F
      LOOP
        INSERT INTO ho_1f
            (board_alph, price, security_symbol_alph,
             client_id_seller_alph, client_id_buyer_alph, trader_id_alph,
             firm, order_number, filler_3, broker_foreign_volume_seller,
             mutual_fund_volume_seller, broker_client_volume_seller,
             broker_portfolio_volume_seller, filler_2,
             broker_foreign_volume_buyer, mutual_fund_volume_buyer,
             broker_client_volume_buyer, broker_portfolio_volume_buyer,
             filler_1, orderid, date_time, status
            )
     VALUES (I.board_alph, I.price, I.security_symbol_alph,
             I.client_id_seller_alph, I.client_id_buyer_alph, I.trader_id_alph,
             I.firm, I.order_number, I.filler_3, I.broker_foreign_volume_seller,
             I.mutual_fund_volume_seller, I.broker_client_volume_seller,
             I.broker_portfolio_volume_seller, I.filler_2,
             I.broker_foreign_volume_buyer, I.mutual_fund_volume_buyer,
             I.broker_client_volume_buyer, I.broker_portfolio_volume_buyer,
             I.filler_1, I.orderid, '','N'
             );
       --XU LY LENH 1F
        --1.1DAY VAO ORDERMAP.
        INSERT INTO ORDERMAP(ctci_order,orgorderid) VALUES (I.order_number,I.orderid);
        --1.2 CAP NHAT OOD.
        UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
        UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.buyorderid;
        --1.3 DAY LENH VAO ODQUEUE
        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;
      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        RPAD(BOARD_ALPH,1,' ') BOARD,
        RPAD(PRICE,12,' ') PRICE,
        RPAD(SECURITY_SYMBOL_ALPH,8,' ') SECURITY_SYMBOL,
        RPAD(CLIENT_ID_SELLER_ALPH,10,' ') CLIENT_ID_SELLER,
        RPAD(CLIENT_ID_BUYER_ALPH,10,' ') CLIENT_ID_BUYER,
        RPAD(TRADER_ID_ALPH,4,' ') TRADER_ID,
        RPAD(FIRM,3,' ') FIRM,
        RPAD(ORDER_NUMBER,5,' ') DEAL_ID,
        RPAD(FILLER_3,32,' ') FILLER_3,
        RPAD(BROKER_FOREIGN_VOLUME_SELLER,8,' ') BROKER_FOREIGN_VOLUME_SELLER,
        RPAD(MUTUAL_FUND_VOLUME_SELLER,8,' ') MUTUAL_FUND_VOLUME_SELLER,
        RPAD(BROKER_CLIENT_VOLUME_SELLER,8,' ') BROKER_CLIENT_VOLUME_SELLER,
        RPAD(BROKER_PORTFOLIO_VOLUME_SELLER,8,' ') BROKER_PORTFOLIO_VOLUME_SELLER,
        RPAD(FILLER_2,32,' ') FILLER_2,
        RPAD(BROKER_FOREIGN_VOLUME_BUYER,8,' ') BROKER_FOREIGN_VOLUME_BUYER,
        RPAD(MUTUAL_FUND_VOLUME_BUYER,8,' ') MUTUAL_FUND_VOLUME_BUYER,
        RPAD(BROKER_CLIENT_VOLUME_BUYER,8,' ') BROKER_CLIENT_VOLUME_BUYER,
        RPAD(BROKER_PORTFOLIO_VOLUME_BUYER,8,' ') BROKER_PORTFOLIO_VOLUME_BUYER,
        RPAD(FILLER_1,8,' ') FILLER_1

   FROM ho_1f WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ho_1f SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_1F');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_1F');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_1F;*/


 --Day message lenh thong thuong 1F len Gw
  Procedure PRC_1F(PV_REF IN OUT PKG_REPORT.REF_CURSOR) Is

    v_err VARCHAR2(200);
    v_Temp VARCHAR2(30);
    v_Check BOOLEAN;
    v_strSysCheckBuySell VARCHAR2(30);
    v_DblODQUEUE Number ;
    v_Order_Number VARCHAR2(10);
    CURSOR C_1F IS
        SELECT ORDERID,FIRM,FNC_CHECK_TRADERID('P',BORS) TRADER_ID_ALPH, BCLIENTID CLIENT_ID_BUYER_ALPH,SCLIENTID CLIENT_ID_SELLER_ALPH,SYMBOL SECURITY_SYMBOL_ALPH,'B' BOARD_ALPH,
        lpad(floor(QUOTEPRICE),6,'0')||rpad(replace((QUOTEPRICE -floor(QUOTEPRICE)),'.',''),6,'0') PRICE,'        ' FILLER_1,'        ' FILLER_2,'        ' FILLER_3,
        (CASE WHEN BCUSTODIAN='P' THEN ORDERQTTY ELSE 0 END) BROKER_PORTFOLIO_VOLUME_BUYER,
        (CASE WHEN SCUSTODIAN='P' THEN ORDERQTTY ELSE 0 END) BROKER_PORTFOLIO_VOLUME_SELLER,
        (CASE WHEN BCUSTODIAN='C' THEN ORDERQTTY ELSE 0 END) BROKER_CLIENT_VOLUME_BUYER,
        (CASE WHEN SCUSTODIAN='C' THEN ORDERQTTY ELSE 0 END) BROKER_CLIENT_VOLUME_SELLER,
        (CASE WHEN BCUSTODIAN='F' OR  BCUSTODIAN='E' THEN ORDERQTTY ELSE 0 END) BROKER_FOREIGN_VOLUME_BUYER,
        (CASE WHEN SCUSTODIAN='F' OR  SCUSTODIAN='E' THEN ORDERQTTY ELSE 0 END) BROKER_FOREIGN_VOLUME_SELLER,
        (CASE WHEN BCUSTODIAN='A' OR  BCUSTODIAN='B' THEN ORDERQTTY ELSE 0 END) MUTUAL_FUND_VOLUME_BUYER,
        (CASE WHEN SCUSTODIAN='A' OR  SCUSTODIAN='B' THEN ORDERQTTY ELSE 0 END) MUTUAL_FUND_VOLUME_SELLER, CODEID
        FROM
        SEND_PUTTHROUGH_ORDER_TO_HOSE
        WHERE  INSTR((select inperiod from msgmast where msgtype ='1F'),
         (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='CONTROLCODE')) >0
        And PCK_HOGW.FNC_CHECK_TRADERID('P',BORS) <> '0'
        And PCK_HOGW.fnc_check_P_stockbond('1F',SYMBOL) <>'0'
        AND ( SCUSTODIAN='F' or PCK_HOGW.FNC_CHECK_ROOM(SYMBOL,ORDERQTTY,BCLIENTID,'B')<>'0')
        --and PCK_HOGW.FNC_CHECK_ROOM(SYMBOL,ORDERQTTY,BCLIENTID,'B')<>'0'
    --    And PCK_HOGW.FNC_CHECK_SEC_HCM(SYMBOL) <> '0'
        AND symbol in (select trim(code) from ho_sec_info
                         where NVL(SUSPENSION,'1') <>'S'
                        And NVL(delist,'1') <>'D'
                        And NVL(halt_resume_flag,'1') not in ('H','P')
                        );

        Cursor c_Check_Doiung(v_BorS Varchar2, v_Custodycd Varchar2,v_Codeid Varchar2) is
                           SELECT ORGORDERID FROM ood o , odmast od
                           WHERE o.orgorderid = od.orderid and o.custodycd =v_Custodycd and o.codeid=v_Codeid
                                 And o.bors <> v_BorS
                                 And od.remainqtty >0
                                 AND od.EXECTYPE in ('NB','NS','MS')
                                 And o.oodstatus in ('B','S');

    l_strTRADEBUYSELLPT  VARCHAR2(10); -- Y Thi cho phep dat lenh thoa thuan doi ung
    l_controlcode varchar2(10);

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_1F');

    Begin
          Select VARVALUE into v_strSysCheckBuySell
          From sysvar
          Where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELL';
        Exception When OTHERS Then
            v_strSysCheckBuySell:='N';
    End;

    Begin
          Select VARVALUE Into l_strTRADEBUYSELLPT
          From sysvar
          Where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELLPT' ;
      EXCEPTION when OTHERS Then
          l_strTRADEBUYSELLPT:='N';
    End;


      FOR I IN C_1F
      LOOP

         --Kiem tra neu co lenh doi ung Block, Sent chua khop het thi khong day len GW.
         --Sysvar ko cho BuySell thi check doi ung.
         v_Check:=False;

        l_controlcode :=fn_get_controlcode(i.security_symbol_alph);
        If v_strSysCheckBuySell ='N' and l_controlcode in ('P','A')  and l_strTRADEBUYSELLPT ='N' Then
                 Open c_Check_Doiung('S', I.CLIENT_ID_SELLER_ALPH,I.CODEID);
                 Fetch c_Check_Doiung into v_Temp;
                   If c_Check_Doiung%found then
                    v_Check:=True;
                   End if;
                 Close c_Check_Doiung;
                 If Not v_Check Then
                     Open c_Check_Doiung('B', I.CLIENT_ID_BUYER_ALPH,I.CODEID);
                     Fetch c_Check_Doiung into v_Temp;
                       If c_Check_Doiung%found then
                        v_Check:=True;
                       End if;
                     Close c_Check_Doiung;
                 End if;
         End if;

         IF Not v_Check THEN

           --- Check Xem trong ODQUEUE da co lenh nay chua,neu co thi ko xu ly nua
                  v_DblODQUEUE :=1 ;
                  Begin
                    Select count(orgorderid) into v_DblODQUEUE  from ODQUEUE  where  orgorderid  =  I.orderid ;
                  Exception When OTHERS Then
                    v_DblODQUEUE :=1 ;
                  End;

                  IF v_DblODQUEUE = 0 THEN
                        SELECT  '8'||SEQ_ORDERMAP_PT.NEXTVAL INTO v_Order_Number FROM  dual;  --Prefix: 8 - thoa thuan, 6- lenh thuong; 9 -lenh FO
                        INSERT INTO ho_1f
                            (board_alph, price, security_symbol_alph,
                             client_id_seller_alph, client_id_buyer_alph, trader_id_alph,
                             firm, order_number, filler_3, broker_foreign_volume_seller,
                             mutual_fund_volume_seller, broker_client_volume_seller,
                             broker_portfolio_volume_seller, filler_2,
                             broker_foreign_volume_buyer, mutual_fund_volume_buyer,
                             broker_client_volume_buyer, broker_portfolio_volume_buyer,
                             filler_1, orderid, date_time, status
                            )
                     VALUES (I.board_alph, I.price, I.security_symbol_alph,
                             I.client_id_seller_alph, I.client_id_buyer_alph, I.trader_id_alph,
                             I.firm, v_Order_Number, I.filler_3, I.broker_foreign_volume_seller,
                             I.mutual_fund_volume_seller, I.broker_client_volume_seller,
                             I.broker_portfolio_volume_seller, I.filler_2,
                             I.broker_foreign_volume_buyer, I.mutual_fund_volume_buyer,
                             I.broker_client_volume_buyer, I.broker_portfolio_volume_buyer,
                             I.filler_1, I.orderid, '','N'
                             );
                       --XU LY LENH 1F
                        --1.1DAY VAO ORDERMAP.
                        INSERT INTO ORDERMAP(ctci_order,orgorderid) VALUES (v_Order_Number,I.orderid);
                        --1.2 CAP NHAT OOD.
                        UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
                        UPDATE ODMAST SET hosesession= l_controlcode WHERE ORDERID=I.orderid;
                        --1.3 DAY LENH VAO ODQUEUE
                        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;
                        EXIT;
                END IF ;
         END IF;
      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        RPAD(BOARD_ALPH,1,' ') BOARD,
        RPAD(PRICE,12,' ') PRICE,
        RPAD(SECURITY_SYMBOL_ALPH,8,' ') SECURITY_SYMBOL,
        RPAD(CLIENT_ID_SELLER_ALPH,10,' ') CLIENT_ID_SELLER,
        RPAD(CLIENT_ID_BUYER_ALPH,10,' ') CLIENT_ID_BUYER,
        RPAD(TRADER_ID_ALPH,4,' ') TRADER_ID,
        RPAD(FIRM,3,' ') FIRM,
        RPAD(ORDER_NUMBER,5,' ') DEAL_ID,
        RPAD(FILLER_3,32,' ') FILLER_3,
        RPAD(BROKER_FOREIGN_VOLUME_SELLER,8,' ') BROKER_FOREIGN_VOLUME_SELLER,
        RPAD(MUTUAL_FUND_VOLUME_SELLER,8,' ') MUTUAL_FUND_VOLUME_SELLER,
        RPAD(BROKER_CLIENT_VOLUME_SELLER,8,' ') BROKER_CLIENT_VOLUME_SELLER,
        RPAD(BROKER_PORTFOLIO_VOLUME_SELLER,8,' ') BROKER_PORTFOLIO_VOLUME_SELLER,
        RPAD(FILLER_2,32,' ') FILLER_2,
        RPAD(BROKER_FOREIGN_VOLUME_BUYER,8,' ') BROKER_FOREIGN_VOLUME_BUYER,
        RPAD(MUTUAL_FUND_VOLUME_BUYER,8,' ') MUTUAL_FUND_VOLUME_BUYER,
        RPAD(BROKER_CLIENT_VOLUME_BUYER,8,' ') BROKER_CLIENT_VOLUME_BUYER,
        RPAD(BROKER_PORTFOLIO_VOLUME_BUYER,8,' ') BROKER_PORTFOLIO_VOLUME_BUYER,
        RPAD(FILLER_1,8,' ') FILLER_1

   FROM ho_1f WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ho_1f SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_1F');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_1F');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_1F;


/*
--Day message lenh thong thuong 1F len Gw
  Procedure PRC_1G(PV_REF IN OUT PKG_REPORT.REF_CURSOR) Is

    v_err VARCHAR2(200);

    CURSOR C_1G IS
        SELECT  SEQ_ORDERMAP.NEXTVAL ORDER_NUMBER,ORDERID,FIRM FIRM_SELLER,FNC_CHECK_TRADERID('P',BORS) TRADER_ID_SELLER_ALPH,
        SCLIENTID CLIENT_ID_SELLER_ALPH,CONTRAFIRM CONTRA_FIRM_BUYER,
        BTRADERID TRADER_ID_BUYER_ALPH,SYMBOL SECURITY_SYMBOL_ALPH,'B' BOARD_ALPH,
        LPAD(FLOOR(QUOTEPRICE),6,'0')||RPAD(REPLACE((QUOTEPRICE -FLOOR(QUOTEPRICE))*10,'.',''),6,'0')  PRICE,'    ' FILLER_1,'        ' FILLER_2,
        (CASE WHEN SCUSTODIAN='P' THEN ORDERQTTY ELSE 0 END) BROKER_PORTFOLIO_VOLUME_SELLER,
        (CASE WHEN SCUSTODIAN='C' THEN ORDERQTTY ELSE 0 END) BROKER_CLIENT_VOLUME_SELLER,
        (CASE WHEN SCUSTODIAN='F' OR SCUSTODIAN='E' THEN ORDERQTTY ELSE 0 END) BROKER_FOREIGN_VOLUME_SELLER,
        (CASE WHEN SCUSTODIAN='A' OR SCUSTODIAN='B' THEN ORDERQTTY ELSE 0 END) MUTUAL_FUND_VOLUME_SELLER
        FROM
        send_2firm_pt_order_to_hose
        WHERE
        INSTR((select inperiod from msgmast where msgtype ='1G'),
         (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='CONTROLCODE')) >0
        AND PCK_HOGW.FNC_CHECK_TRADERID('P',BORS) <> '0'
        And PCK_HOGW.fnc_check_P_stockbond('1G',SYMBOL) <>'0'
        And PCK_HOGW.FNC_CHECK_SEC_HCM(SYMBOL) <> '0';
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_1G');
      FOR I IN C_1G
      LOOP
        INSERT INTO ho_1g
            (firm_seller, filler_2, client_id_seller_alph,
             broker_foreign_volume_seller, mutual_fund_volume_seller,
             broker_client_volume_seller, broker_portfolio_volume_seller,
             filler_1, order_number, board_alph, price,
             security_symbol_alph, trader_id_buyer_alph,
             contra_firm_buyer, trader_id_seller_alph, orderid,
             date_time, status
            )
     VALUES (I.firm_seller, I.filler_2, I.client_id_seller_alph,
             I.broker_foreign_volume_seller, I.mutual_fund_volume_seller,
             I.broker_client_volume_seller, I.broker_portfolio_volume_seller,
             I.filler_1, I.order_number, I.board_alph, I.price,
             I.security_symbol_alph, I.trader_id_buyer_alph,
             I.contra_firm_buyer, I.trader_id_seller_alph, I.orderid,
             '', 'N'
            );
       --XU LY LENH 1G
        --1.1DAY VAO ORDERMAP.
        INSERT INTO ORDERMAP(ctci_order,orgorderid) VALUES (I.order_number,I.orderid);
        --1.2 CAP NHAT OOD.
        UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
        --1.3 DAY LENH VAO ODQUEUE
        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;
      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        RPAD(FIRM_SELLER,3,' ') FIRM_SELLER,
        RPAD(FILLER_2,32,' ') FILLER_2,
        RPAD(CLIENT_ID_SELLER_ALPH,10,' ') CLIENT_ID_SELLER,
        RPAD(BROKER_FOREIGN_VOLUME_SELLER,8,' ') BROKER_FOREIGN_VOLUME_SELLER,
        RPAD(MUTUAL_FUND_VOLUME_SELLER,8,' ') MUTUAL_FUND_VOLUME_SELLER,
        RPAD(BROKER_CLIENT_VOLUME_SELLER,8,' ') BROKER_CLIENT_VOLUME_SELLER,
        RPAD(BROKER_PORTFOLIO_VOLUME_SELLER,8,' ') BROKER_PORTFOLIO_VOLUME_SELLER,
        RPAD(FILLER_1,4,' ') FILLER_1,
        RPAD(ORDER_NUMBER,5,' ') DEAL_ID,
        RPAD(BOARD_ALPH,1,' ') BOARD,
        RPAD(PRICE,12,' ') PRICE,
        RPAD(SECURITY_SYMBOL_ALPH,8,' ') SECURITY_SYMBOL,
        RPAD(TRADER_ID_BUYER_ALPH,4,' ') TRADER_ID_BUYER,
        RPAD(CONTRA_FIRM_BUYER,3,' ') CONTRA_FIRM_BUYER,
        RPAD(TRADER_ID_SELLER_ALPH,4,' ') TRADER_ID_SELLER

   FROM ho_1g WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ho_1g SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_1G');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_1G');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_1G;

*/


--Day message lenh thong thuong 1G len Gw
  Procedure PRC_1G(PV_REF IN OUT PKG_REPORT.REF_CURSOR) Is

    v_err VARCHAR2(200);
    v_Temp VARCHAR2(30);
    v_Check BOOLEAN;
    v_strSysCheckBuySell VARCHAR2(30);
    v_DblODQUEUE Number ;
    v_Order_Number varchar2(10);

    CURSOR C_1G IS
        SELECT ORDERID,FIRM FIRM_SELLER,FNC_CHECK_TRADERID('P',BORS) TRADER_ID_SELLER_ALPH,
        SCLIENTID CLIENT_ID_SELLER_ALPH,CONTRAFIRM CONTRA_FIRM_BUYER,
        BTRADERID TRADER_ID_BUYER_ALPH,SYMBOL SECURITY_SYMBOL_ALPH,'B' BOARD_ALPH,
        LPAD(FLOOR(QUOTEPRICE),6,'0')||RPAD(REPLACE((QUOTEPRICE -FLOOR(QUOTEPRICE)),'.',''),6,'0')  PRICE,'    ' FILLER_1,'        ' FILLER_2,
        (CASE WHEN SCUSTODIAN='P' THEN ORDERQTTY ELSE 0 END) BROKER_PORTFOLIO_VOLUME_SELLER,
        (CASE WHEN SCUSTODIAN='C' THEN ORDERQTTY ELSE 0 END) BROKER_CLIENT_VOLUME_SELLER,
        (CASE WHEN SCUSTODIAN='F' OR SCUSTODIAN='E' THEN ORDERQTTY ELSE 0 END) BROKER_FOREIGN_VOLUME_SELLER,
        (CASE WHEN SCUSTODIAN='A' OR SCUSTODIAN='B' THEN ORDERQTTY ELSE 0 END) MUTUAL_FUND_VOLUME_SELLER, BORS, CODEID
        FROM
        send_2firm_pt_order_to_hose
        WHERE
        INSTR((select inperiod from msgmast where msgtype ='1G'),
         (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='CONTROLCODE')) >0
        AND PCK_HOGW.FNC_CHECK_TRADERID('P',BORS) <> '0'
        And PCK_HOGW.fnc_check_P_stockbond('1G',SYMBOL) <>'0'
        --And PCK_HOGW.FNC_CHECK_SEC_HCM(SYMBOL) <> '0'
        AND symbol in (select trim(code) from ho_sec_info
                                 where NVL(SUSPENSION,'1') <>'S'
                                And NVL(delist,'1') <>'D'
                                And NVL(halt_resume_flag,'1') not in ('H','P')
                                );
        Cursor c_Check_Doiung(v_BorS Varchar2, v_Custodycd Varchar2,v_Codeid Varchar2) is
                           SELECT ORGORDERID FROM ood o , odmast od
                           WHERE o.orgorderid = od.orderid and o.custodycd =v_Custodycd and o.codeid=v_Codeid
                                 And o.bors <> v_BorS
                                 And od.remainqtty >0
                                 AND od.EXECTYPE in ('NB','NS','MS')
                                 And o.oodstatus in ('B','S');
   l_strTRADEBUYSELLPT  VARCHAR2(10); -- Y Thi cho phep dat lenh thoa thuan doi ung
   l_controlcode varchar2(10);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_1G');

     Begin
            Select VARVALUE into v_strSysCheckBuySell from sysvar where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELL';
        Exception When OTHERS Then
            v_strSysCheckBuySell:='N';
     End;

    Begin
          Select VARVALUE Into l_strTRADEBUYSELLPT
          From sysvar
          Where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELLPT' ;
      EXCEPTION when OTHERS Then
          l_strTRADEBUYSELLPT:='N';
    End;

      FOR I IN C_1G
      LOOP

         --Kiem tra neu co lenh doi ung Block, Sent chua khop het thi khong day len GW.
         --Sysvar ko cho BuySell thi check doi ung.
         v_Check:=False;

        l_controlcode :=fn_get_controlcode(i.security_symbol_alph);

        If v_strSysCheckBuySell ='N' and l_controlcode in ('P','A') and l_strTRADEBUYSELLPT='N' Then
                 Open c_Check_Doiung(I.BORS, I.CLIENT_ID_SELLER_ALPH,I.CODEID);
                 Fetch c_Check_Doiung into v_Temp;
                   If c_Check_Doiung%found then
                    v_Check:=True;
                   End if;
                 Close c_Check_Doiung;
         End if;

         IF Not v_Check THEN

                  -- Check xem da co lenh trong ODQUEUE chua neu co roi thi ko cho da lenh vao nua

                  v_DblODQUEUE :=1 ;
                  Begin
                    Select count(orgorderid) into v_DblODQUEUE  from ODQUEUE  where  orgorderid  =  I.orderid ;
                  Exception When OTHERS Then
                    v_DblODQUEUE :=1 ;
                  End;

                  IF v_DblODQUEUE = 0 THEN

                        SELECT  '8'||SEQ_ORDERMAP_PT.NEXTVAL INTO v_Order_Number FROM  dual;  --Prefix: 8 - thoa thuan, 6- lenh thuong; 9 -lenh FO
                        INSERT INTO ho_1g
                            (firm_seller, filler_2, client_id_seller_alph,
                             broker_foreign_volume_seller, mutual_fund_volume_seller,
                             broker_client_volume_seller, broker_portfolio_volume_seller,
                             filler_1, order_number, board_alph, price,
                             security_symbol_alph, trader_id_buyer_alph,
                             contra_firm_buyer, trader_id_seller_alph, orderid,
                             date_time, status
                            )
                     VALUES (I.firm_seller, I.filler_2, I.client_id_seller_alph,
                             I.broker_foreign_volume_seller, I.mutual_fund_volume_seller,
                             I.broker_client_volume_seller, I.broker_portfolio_volume_seller,
                             I.filler_1, v_Order_Number, I.board_alph, I.price,
                             I.security_symbol_alph, I.trader_id_buyer_alph,
                             I.contra_firm_buyer, I.trader_id_seller_alph, I.orderid,
                             '', 'N'
                            );
                       --XU LY LENH 1G
                        --1.1DAY VAO ORDERMAP.
                        INSERT INTO ORDERMAP(ctci_order,orgorderid) VALUES (v_Order_Number,I.orderid);
                        --1.2 CAP NHAT OOD.
                        UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
                        UPDATE ODMAST SET hosesession= l_controlcode WHERE ORDERID=I.orderid;
                        --1.3 DAY LENH VAO ODQUEUE
                        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;
                        EXIT;
                END IF ;
         End if;
      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        RPAD(FIRM_SELLER,3,' ') FIRM_SELLER,
        RPAD(FILLER_2,32,' ') FILLER_2,
        RPAD(CLIENT_ID_SELLER_ALPH,10,' ') CLIENT_ID_SELLER,
        RPAD(BROKER_FOREIGN_VOLUME_SELLER,8,' ') BROKER_FOREIGN_VOLUME_SELLER,
        RPAD(MUTUAL_FUND_VOLUME_SELLER,8,' ') MUTUAL_FUND_VOLUME_SELLER,
        RPAD(BROKER_CLIENT_VOLUME_SELLER,8,' ') BROKER_CLIENT_VOLUME_SELLER,
        RPAD(BROKER_PORTFOLIO_VOLUME_SELLER,8,' ') BROKER_PORTFOLIO_VOLUME_SELLER,
        RPAD(FILLER_1,4,' ') FILLER_1,
        RPAD(ORDER_NUMBER,5,' ') DEAL_ID,
        RPAD(BOARD_ALPH,1,' ') BOARD,
        RPAD(PRICE,12,' ') PRICE,
        RPAD(SECURITY_SYMBOL_ALPH,8,' ') SECURITY_SYMBOL,
        RPAD(TRADER_ID_BUYER_ALPH,4,' ') TRADER_ID_BUYER,
        RPAD(CONTRA_FIRM_BUYER,3,' ') CONTRA_FIRM_BUYER,
        RPAD(TRADER_ID_SELLER_ALPH,4,' ') TRADER_ID_SELLER

   FROM ho_1g WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ho_1g SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_1G');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_1G');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_1G;

  --Day message lenh thong thuong 1D len Gw
  Procedure PRC_1D(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);

    CURSOR C_1D IS
        SELECT ORDER_NUMBER ORDER_NUMBER,S.SYSVALUE FIRM ,SUBSTR(ORGORDERID,5,4) ORDER_ENTRY_DATE,
        ORGORDERID ORDERID , CUSTODYCD_CHANGE CLIENT_ID_ALPH,' ' FILLER
        From ORDER_CHANGE , ORDERSYS s
        WHERE
        S.SYSNAME ='FIRM'
        AND STATUS='N'
        AND INSTR((select inperiod from msgmast where msgtype ='1D'),
         (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='CONTROLCODE')) >0;
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_1D');
      FOR I IN C_1D
      LOOP
        INSERT INTO ho_1d
                    (client_id_alph, order_entry_date, order_number, firm,
                     filler, orderid, date_time, status
                    )
             VALUES (I.client_id_alph, I.order_entry_date, I.order_number, I.firm,
                     I.filler, I.orderid, '', 'N'
             );
      --XU LY LENH 1D
       Update ORDER_CHANGE SET status ='Y',TIME_SEND=sysdate WHERE ORGORDERID = I.orderid;
      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        RPAD(CLIENT_ID_ALPH,10,' ') CLIENT_ID,
        RPAD(ORDER_ENTRY_DATE,4,' ') ORDER_ENTRY_DATE,
        RPAD(ORDER_NUMBER,8,' ') ORDER_NUMBER,
        RPAD(FIRM,3,' ') FIRM,
        RPAD(FILLER,17,' ') FILLER

        FROM ho_1d WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ho_1D SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_1D');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_1D');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_1D;

/*  --Day message chap nhan/tu choi lenh thoa thuan len Gw
  Procedure PRC_3B(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);

    CURSOR C_3B IS
        SELECT FIRM,CONFIRMNUMBER CONFIRM_NUMBER,SEQ_ORDERMAP.NEXTVAL ORDER_NUMBER,CUSTODYCD CLIENT_ID_BUYER_ALPH,
        STATUS REPLY_CODE_ALPH,'    ' FILLER_1,ORGORDERID ORDERID,
        (CASE WHEN SUBSTR(CUSTODYCD,4,1)='P' THEN QTTY ELSE 0 END) BROKER_PORTFOLIO_VOLUME,
        (CASE WHEN SUBSTR(CUSTODYCD,4,1)='C' THEN QTTY ELSE 0 END) BROKER_CLIENT_VOLUME,
        (CASE WHEN SUBSTR(CUSTODYCD,4,1)='A' or SUBSTR(CUSTODYCD,4,1)='B' THEN QTTY ELSE 0 END) BROKER_MUTUAL_FUND_VOLUME,
        (CASE WHEN SUBSTR(CUSTODYCD,4,1)='F' or SUBSTR(CUSTODYCD,4,1)='E' THEN QTTY ELSE 0 END) BROKER_FOREIGN_VOLUME,
        '   ' FILLER_2
        FROM (SELECT A.*,C.CUSTODYCD,C.QTTY,C.ORGORDERID FROM ORDERPTACK A, ODMAST B,OOD C, SBSECURITIES S
         WHERE A.STATUS IN ('A') AND
         A.CONFIRMNUMBER=B.CONFIRM_NO AND B.ORDERID=C.ORGORDERID
        AND B.DELTD <>'Y' AND A.ISSEND <>'Y'
        AND C.SYMBOL =S.SYMBOL AND S.TRADEPLACE ='001')
        WHERE INSTR((select inperiod from msgmast where msgtype ='3B'),
                    (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='CONTROLCODE')) >0;
CURSOR C_3B_REJECT IS

        SELECT FIRM,CONFIRMNUMBER CONFIRM_NUMBER,0 ORDER_NUMBER,' ' CLIENT_ID_BUYER_ALPH,
        a.STATUS REPLY_CODE_ALPH,'    ' FILLER_1,' ' ORDERID,
        0 BROKER_PORTFOLIO_VOLUME,
        0 BROKER_CLIENT_VOLUME,
        0 BROKER_MUTUAL_FUND_VOLUME,
        0 BROKER_FOREIGN_VOLUME,
        '   ' FILLER_2
        FROM ORDERPTACK A, SBSECURITIES S
        WHERE A.STATUS = ('C') AND A.ISSEND <>'Y'
        AND TRIM(A.SECURITYSYMBOL) =S.SYMBOL AND S.TRADEPLACE ='001'
        AND INSTR((select inperiod from msgmast where msgtype ='3B'),
                    (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='CONTROLCODE')) >0;
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_3B');
      FOR I IN C_3B
      LOOP
        INSERT INTO ho_3b
                    (filler_2, broker_foreign_volume, broker_mutual_fund_volume,
                     broker_client_volume, broker_portfolio_volume, filler_1,
                     reply_code_alph, client_id_buyer_alph, order_number, firm,
                     confirm_number, orderid, date_time, status
                    )
             VALUES (I.filler_2, I.broker_foreign_volume, I.broker_mutual_fund_volume,
                     I.broker_client_volume, I.broker_portfolio_volume, I.filler_1,
                     I.reply_code_alph, I.client_id_buyer_alph, I.order_number, I.firm,
                     I.confirm_number, I.orderid, '', 'N'
                    );
      --XU LY LENH 3B
        --1.1DAY VAO ORDERMAP.
        INSERT INTO ORDERMAP(ctci_order,orgorderid) VALUES (I.order_number,I.orderid);
        --1.2 CAP NHAT OOD.

        UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
        --1.3 DAY LENH VAO ODQUEUE
        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;
        --1.4 Update msg chao ban da dc confirm
        UPDATE ORDERPTACK SET ISSEND='Y' WHERE  trim(CONFIRMNUMBER)=trim(I.confirm_number);
        -- Neu tu choi huy thi xoa lenh luon

        --IF I.reply_code_alph='C' then
          --   Update odmast set deltd ='Y', CANCELQTTY =ORDERQTTY,
            --                    REMAINQTTY=0,EXECQTTY =0 ,MATCHAMT =0,Execamt =0
             --Where MATCHTYPE ='P'
             --And Orderid = i.orderid;
             --UPDATE OOD SET OODSTATUS='S' WHERE ORGORDERID=I.orderid;
         -- End if;
      END LOOP;

       FOR I IN C_3B_REJECT
      LOOP
        INSERT INTO ho_3b
                    (filler_2, broker_foreign_volume, broker_mutual_fund_volume,
                     broker_client_volume, broker_portfolio_volume, filler_1,
                     reply_code_alph, client_id_buyer_alph, order_number, firm,
                     confirm_number, orderid, date_time, status
                    )
             VALUES (I.filler_2, I.broker_foreign_volume, I.broker_mutual_fund_volume,
                     I.broker_client_volume, I.broker_portfolio_volume, I.filler_1,
                     I.reply_code_alph, I.client_id_buyer_alph, I.order_number, I.firm,
                     I.confirm_number, I.orderid, '', 'N'
                    );
         UPDATE ORDERPTACK SET ISSEND='Y' WHERE  trim(CONFIRMNUMBER)=trim(I.confirm_number);
      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        RPAD(FILLER_2,32,' ') FILLER_2,
        RPAD(BROKER_FOREIGN_VOLUME,8,' ') BROKER_FOREIGN_VOLUME,
        RPAD(BROKER_MUTUAL_FUND_VOLUME,8,' ') BROKER_MUTUAL_FUND_VOLUME,
        RPAD(BROKER_CLIENT_VOLUME,8,' ') BROKER_CLIENT_VOLUME,
        RPAD(BROKER_PORTFOLIO_VOLUME,8,' ') BROKER_PORTFOLIO_VOLUME,
        RPAD(FILLER_1,4,' ') FILLER_1,
        RPAD(REPLY_CODE_ALPH,1,' ') REPLY_CODE,
        RPAD(CLIENT_ID_BUYER_ALPH,10,' ') CLIENT_ID_BUYER,
        RPAD(ORDER_NUMBER,5,' ') DEAL_ID,
        RPAD(FIRM,3,' ') FIRM,
        RPAD(CONFIRM_NUMBER,6,' ') CONFIRM_NUMBER

        FROM ho_3B WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ho_3B SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_3B');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_3B');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_3B;
  */


 --Day message chap nhan/tu choi lenh thoa thuan len Gw
  Procedure PRC_3B(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);
    v_Temp VARCHAR2(30);
    v_Check BOOLEAN;
    v_strSysCheckBuySell VARCHAR2(30);
    v_Order_Number varchar2(10);
    CURSOR C_3B IS
        SELECT FIRM,CONFIRMNUMBER CONFIRM_NUMBER,CUSTODYCD CLIENT_ID_BUYER_ALPH,
        STATUS REPLY_CODE_ALPH,'    ' FILLER_1,ORGORDERID ORDERID,
        (CASE WHEN SUBSTR(CUSTODYCD,4,1)='P' THEN QTTY ELSE 0 END) BROKER_PORTFOLIO_VOLUME,
        (CASE WHEN SUBSTR(CUSTODYCD,4,1)='C' THEN QTTY ELSE 0 END) BROKER_CLIENT_VOLUME,
        (CASE WHEN SUBSTR(CUSTODYCD,4,1)='A' or SUBSTR(CUSTODYCD,4,1)='B' THEN QTTY ELSE 0 END) BROKER_MUTUAL_FUND_VOLUME,
        (CASE WHEN SUBSTR(CUSTODYCD,4,1)='F' or SUBSTR(CUSTODYCD,4,1)='E' THEN QTTY ELSE 0 END) BROKER_FOREIGN_VOLUME,
        '   ' FILLER_2, CODEID
        FROM (SELECT A.*,C.CUSTODYCD,C.QTTY,C.ORGORDERID, B.CODEID FROM ORDERPTACK A, ODMAST B,OOD C, SBSECURITIES S
         WHERE A.STATUS IN ('A') AND
         A.CONFIRMNUMBER=B.CONFIRM_NO AND B.ORDERID=C.ORGORDERID
        AND B.DELTD <>'Y' AND A.ISSEND <>'Y'
        AND C.SYMBOL =S.SYMBOL AND S.TRADEPLACE ='001'
        AND NVL(b.ISFO_ORDER,'N') <>'Y'
        )
        WHERE INSTR((select inperiod from msgmast where msgtype ='3B'),
                    (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='CONTROLCODE')) >0;


        -- Lay message tu choi mua thoa thuan
        CURSOR C_3B_REJECT IS
        SELECT FIRM,CONFIRMNUMBER CONFIRM_NUMBER,0 ORDER_NUMBER,' ' CLIENT_ID_BUYER_ALPH,
        a.STATUS REPLY_CODE_ALPH,'    ' FILLER_1,' ' ORDERID,
        0 BROKER_PORTFOLIO_VOLUME,
        0 BROKER_CLIENT_VOLUME,
        0 BROKER_MUTUAL_FUND_VOLUME,
        0 BROKER_FOREIGN_VOLUME,
        '   ' FILLER_2
        FROM ORDERPTACK A, SBSECURITIES S
        WHERE A.STATUS = ('C') AND A.ISSEND <>'Y'
        AND TRIM(A.SECURITYSYMBOL) =S.SYMBOL AND S.TRADEPLACE ='001'
        AND INSTR((select inperiod from msgmast where msgtype ='3B'),
                    (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='CONTROLCODE')) >0;

        Cursor c_Check_Doiung(v_BorS Varchar2, v_Custodycd Varchar2,v_Codeid Varchar2) is
                           SELECT ORGORDERID FROM ood o , odmast od
                           WHERE o.orgorderid = od.orderid and o.custodycd =v_Custodycd and o.codeid=v_Codeid
                                 And o.bors <> v_BorS
                                 And od.remainqtty >0
                                 AND od.EXECTYPE in ('NB','NS','MS')
                                 And o.oodstatus in ('B','S');


  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_3B');
      FOR I IN C_3B
      LOOP
      --Kiem tra neu co lenh doi ung Block, Sent chua khop het thi khong day len GW.
         --Sysvar ko cho BuySell thi check doi ung.
         v_Check:=False;

         Begin
           Select VARVALUE into v_strSysCheckBuySell from sysvar where GRNAME ='SYSTEM' and VARNAME ='TRADEBUYSELL';
         Exception When OTHERS Then
           v_strSysCheckBuySell:='N';
         End;
         If v_strSysCheckBuySell ='N' Then

                 Open c_Check_Doiung('B', I.CLIENT_ID_BUYER_ALPH,I.CODEID);
                 Fetch c_Check_Doiung into v_Temp;
                   If c_Check_Doiung%found then
                    v_Check:=True;
                   End if;
                 Close c_Check_Doiung;
         End if;

         IF Not v_Check THEN
                SELECT  '8'||SEQ_ORDERMAP_PT.NEXTVAL INTO v_Order_Number FROM  dual;  --Prefix: 8 - thoa thuan, 6- lenh thuong; 9 -lenh FO
                INSERT INTO ho_3b
                            (filler_2, broker_foreign_volume, broker_mutual_fund_volume,
                             broker_client_volume, broker_portfolio_volume, filler_1,
                             reply_code_alph, client_id_buyer_alph, order_number, firm,
                             confirm_number, orderid, date_time, status
                            )
                     VALUES (I.filler_2, I.broker_foreign_volume, I.broker_mutual_fund_volume,
                             I.broker_client_volume, I.broker_portfolio_volume, I.filler_1,
                             I.reply_code_alph, I.client_id_buyer_alph, v_Order_Number, I.firm,
                             I.confirm_number, I.orderid, '', 'N'
                            );
              --XU LY LENH 3B
                --1.1DAY VAO ORDERMAP.
                INSERT INTO ORDERMAP(ctci_order,orgorderid) VALUES (v_Order_Number,I.orderid);
                --1.2 CAP NHAT OOD.
                UPDATE OOD SET OODSTATUS='B' WHERE ORGORDERID=I.orderid;
                --1.3 DAY LENH VAO ODQUEUE
                INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID = I.orderid;
                --1.4 Update msg chao ban da dc confirm
                UPDATE ORDERPTACK SET ISSEND='Y' WHERE  trim(CONFIRMNUMBER)=trim(I.confirm_number);

         END IF;
      END LOOP;

      FOR I IN C_3B_REJECT
      LOOP
        INSERT INTO ho_3b
                    (filler_2, broker_foreign_volume, broker_mutual_fund_volume,
                     broker_client_volume, broker_portfolio_volume, filler_1,
                     reply_code_alph, client_id_buyer_alph, order_number, firm,
                     confirm_number, orderid, date_time, status
                    )
             VALUES (I.filler_2, I.broker_foreign_volume, I.broker_mutual_fund_volume,
                     I.broker_client_volume, I.broker_portfolio_volume, I.filler_1,
                     I.reply_code_alph, I.client_id_buyer_alph, I.order_number, I.firm,
                     I.confirm_number, I.orderid, '', 'N'
                    );
         UPDATE ORDERPTACK SET ISSEND='Y' WHERE  trim(CONFIRMNUMBER)=trim(I.confirm_number);
      END LOOP;
   --LAY DU LIEU RA GW.


   OPEN PV_REF FOR
   SELECT
        RPAD(FILLER_2,32,' ') FILLER_2,
        RPAD(BROKER_FOREIGN_VOLUME,8,' ') BROKER_FOREIGN_VOLUME,
        RPAD(BROKER_MUTUAL_FUND_VOLUME,8,' ') BROKER_MUTUAL_FUND_VOLUME,
        RPAD(BROKER_CLIENT_VOLUME,8,' ') BROKER_CLIENT_VOLUME,
        RPAD(BROKER_PORTFOLIO_VOLUME,8,' ') BROKER_PORTFOLIO_VOLUME,
        RPAD(FILLER_1,4,' ') FILLER_1,
        RPAD(REPLY_CODE_ALPH,1,' ') REPLY_CODE,
        RPAD(CLIENT_ID_BUYER_ALPH,10,' ') CLIENT_ID_BUYER,
        RPAD(ORDER_NUMBER,5,' ') DEAL_ID,
        RPAD(FIRM,3,' ') FIRM,
        RPAD(CONFIRM_NUMBER,6,' ') CONFIRM_NUMBER

        FROM ho_3B WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ho_3B SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_3B');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_3B');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_3B;

  --Day message yeu cau huy lenh thoa thuan 3C len Gw
  Procedure PRC_3C(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);

    CURSOR C_3C IS
        SELECT FIRM,CONTRAFIRM CONTRAFIRM,TRADEID TRADEID,CONFIRMNUMBER CONFIRMNUMBER,
        SECURITYSYMBOL SECURITYSYMBOL,SIDE SIDE
        FROM CANCELORDERPTACK WHERE SORR='S' AND MESSAGETYPE='3C'
        AND STATUS='N' AND ISCONFIRM='N'
        AND PCK_HOGW.FNC_CHECK_SEC_HCM(SECURITYSYMBOL) <> '0'
        AND INSTR((select inperiod from msgmast where msgtype ='3C'  AND msgmast.RORS ='S'),
                    (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='CONTROLCODE')) >0;
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_3C');
      FOR I IN C_3C
      LOOP
        INSERT INTO ho_3c
            (contrafirm, securitysymbol, confirmnumber, firm, side,
             tradeid, date_time, status
            )
     VALUES (I.contrafirm, I.securitysymbol, I.confirmnumber, I.firm, I.side,
             I.tradeid, '', 'N'
            );
      --XU LY LENH 3C
        UPDATE CANCELORDERPTACK SET STATUS='S'
        WHERE MESSAGETYPE='3C' AND SORR='S' AND CONFIRMNUMBER=I.confirmnumber;
      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        RPAD(CONTRAFIRM,3,' ') CONTRA_FIRM,
        RPAD(SECURITYSYMBOL,8,' ') SECURITY_SYMBOL,
        RPAD(CONFIRMNUMBER,6,' ') CONFIRM_NUMBER,
        RPAD(FIRM,3,' ') FIRM,
        RPAD(SIDE,1,' ') SIDE,
        RPAD(TRADEID,4,' ') TRADER_ID

        FROM ho_3C WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ho_3C SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_3C');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_3C');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_3C;


--Day message yeu cau huy lenh thoa thuan 3C len Gw
  Procedure PRC_1E(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);

    CURSOR C_1E IS
      SELECT s.sectype,A.AUTOID, A.TIMESTAMP, A.MESSAGETYPE, A.FIRM, FNC_CHECK_TRADERID('P',A.SIDE)  TRADEID,
       A.SECURITYSYMBOL, A.SIDE, to_number(Replace(A.VOLUME,',','')) VOLUME, lpad(floor(A.PRICE),6,'0')||rpad(replace((A.PRICE -floor(A.PRICE)),'.',''),6,'0') PRICE , A.BOARD, A.SENDTIME,
       A.STATUS, A.CONTACT, A.OFFSET, A.ISSEND, A.ISACTIVE, A.DELETED,
       A.REFID, A.BRID, A.TLID, A.IPADDRESS, A.ADVDATE,to_char(sysdate,'HH24MISS') TIME
      FROM ORDERPTADV A,sbsecurities s
      WHERE A.DELETED <> 'Y' AND A.ISSEND='N' AND A.ISACTIVE='Y'
      and  PCK_HOGW.FNC_CHECK_TRADERID('P',A.SIDE) <> '0'
      AND trim(a.securitysymbol) =trim(s.SYMBOL)
      and PCK_HOGW.fnc_check_P_stockbond('1E',SECURITYSYMBOL) <>'0'
      And s.tradeplace ='001'
      And PCK_HOGW.FNC_CHECK_SEC_HCM(SECURITYSYMBOL) <> '0';
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_1E');

      --XU LY LENH 1E
    FOR I IN C_1E
      LOOP
        INSERT INTO ho_1e
            (contact, status, TIMESTAMP, firm, tradeid, securitysymbol,
             side, volume, board, price, autoid, SENTSTATUS
            )
     VALUES (I.contact, I.status, I.TIMESTAMP, I.firm, I.tradeid, I.securitysymbol,
             I.side, I.volume, I.board, I.price, I.autoid, 'N'
            );
      --XU LY LENH 1E
       UPDATE ORDERPTADV SET ISSEND='Y' WHERE AUTOID =I.autoid;
      END LOOP;

   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        RPAD(CONTACT,20,' ') CONTACT,
        RPAD(STATUS,1,' ') ADD_CANCEL_FLAG,
        RPAD(TIMESTAMP,6,' ') TIME,
        RPAD(FIRM,3,' ') FIRM,
        RPAD(TRADEID,4,' ') TRADER_ID,
        RPAD(SECURITYSYMBOL,8,' ') SECURITY_SYMBOL,
        RPAD(SIDE,1,' ') SIDE,
        RPAD(VOLUME,8,' ') VOLUME,
        RPAD(BOARD,1,' ') BOARD,
        RPAD(PRICE,12,' ') PRICE

   FROM ho_1e WHERE SENTSTATUS ='N';

   --Cap nhat trang thai bang tam ra GW.
   UPDATE ho_1E SET SENTSTATUS ='Y' WHERE SENTSTATUS ='N';
   plog.setendsection (pkgctx, 'PRC_1E');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_1E');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_1E;


  --Day message chap nhan/tu choi huy 3D len Gw
  Procedure PRC_3D(PV_REF IN OUT PKG_REPORT.REF_CURSOR) is

    v_err VARCHAR2(200);

    CURSOR C_3D IS
        SELECT FIRM,CONTRAFIRM CONTRAFIRM,TRADEID TRADEID,CONFIRMNUMBER CONFIRMNUMBER,
        SECURITYSYMBOL SECURITYSYMBOL,SIDE SIDE,STATUS REPLY_CODE
        FROM CANCELORDERPTACK WHERE SORR='R'
        --AND MESSAGETYPE='3D'
        AND STATUS in ('A','C') AND ISCONFIRM='N'
        AND SORR ='R'
        AND PCK_HOGW.FNC_CHECK_SEC_HCM(SECURITYSYMBOL) <> '0'
        AND INSTR((select inperiod from msgmast where msgtype ='3D'),
                    (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='CONTROLCODE')) >0;
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_3D');
      FOR I IN C_3D
      LOOP
        INSERT INTO ho_3d
            (reply_code, confirmnumber, firm, date_time, status
            )
     VALUES (I.reply_code, I.confirmnumber, I.firm, '', 'N'
            );
      --XU LY LENH 3D
        UPDATE CANCELORDERPTACK SET ISCONFIRM='Y'
        WHERE STATUS in ('A','C') AND SORR='R'
        AND Trim(CONFIRMNUMBER)=TRIM(I.confirmnumber);
      END LOOP;
   --LAY DU LIEU RA GW.
   OPEN PV_REF FOR
   SELECT
        RPAD(REPLY_CODE,1,' ') REPLY_CODE,
        RPAD(CONFIRMNUMBER,6,' ') CONFIRM_NUMBER,
        RPAD(FIRM,3,' ') FIRM

   FROM ho_3D WHERE STATUS ='N';
   --Cap nhat trang thai bang tam ra GW.
   UPDATE ho_3D SET STATUS ='Y',DATE_TIME = SYSDATE WHERE STATUS ='N';
   plog.setendsection (pkgctx, 'PRC_3D');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_3D');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_3D;

  --LAY MESSAGE DAY LEN GW.
  Procedure PRC_GETORDER(PV_REF IN OUT PKG_REPORT.REF_CURSOR, v_MsgType VARCHAR2) is
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_GETORDER');
      IF v_MsgType ='1I' THEN
        PRC_1I(PV_REF);
      ELSIF v_MsgType ='1C' THEN
        PRC_1C(PV_REF);
      ELSIF v_MsgType ='1D' THEN
        PRC_1D(PV_REF);
      ELSIF v_MsgType ='1F' THEN
        PRC_1F(PV_REF);
      ELSIF v_MsgType ='1G' THEN
        PRC_1G(PV_REF);
      ELSIF v_MsgType ='3B' THEN
        PRC_3B(PV_REF);
      ELSIF v_MsgType ='3C' THEN
        PRC_3C(PV_REF);
      ELSIF v_MsgType ='3D' THEN
        PRC_3D(PV_REF);
      ELSIF v_MsgType ='1E' THEN
        PRC_1E(PV_REF);
      END IF;
      plog.setendsection (pkgctx, 'PRC_GETORDER');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_GETORDER');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_GETORDER;

  --XU LY MESSAGE NHAN VE
  Procedure PRC_PROCESSMSG(V_MSGGROUP VARCHAR2) is
    CURSOR C_MSG_RECEIVE IS
    Select * from
    (
    SELECT MSGTYPE,ID, REPLACE(MSGXML,'&',' ') MSGXML, PROCESS, MSG_DATE FROM MSGRECEIVETEMP WHERE MSGGROUP =V_MSGGROUP  AND PROCESS ='N' order by ID
    )
    where  ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='HOSERECEIVESIZE');
    /*
   SELECT MSGTYPE,ID, REPLACE(MSGXML,'&',' ') MSGXML, PROCESS FROM MSGRECEIVETEMP WHERE MSGGROUP =V_MSGGROUP AND PROCESS ='N'
    AND ROWNUM BETWEEN 0 AND (SELECT SYSVALUE FROM ORDERSYS WHERE SYSNAME='HOSERECEIVESIZE');
    */
    V_MSG_RECEIVE C_MSG_RECEIVE%ROWTYPE;
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESSMSG');
      OPEN C_MSG_RECEIVE;
      LOOP
          FETCH C_MSG_RECEIVE INTO V_MSG_RECEIVE;
          EXIT WHEN C_MSG_RECEIVE%NOTFOUND;
          BEGIN
                v_CheckProcess := TRUE;
                plog.debug(pkgctx,'Process message ID = '||V_MSG_RECEIVE.ID);
                IF V_MSG_RECEIVE.MSGTYPE ='2B' THEN
                  PRC_PROCESS2B(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='2C' THEN
                  PRC_PROCESS2C(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='2E' THEN
                  PRC_PROCESS2E(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='2G' THEN
                  PRC_PROCESS2G(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='2D' THEN
                  PRC_PROCESS2D(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='2I' THEN
                  /*
                   INSERT INTO log_err
                        (id,date_log, POSITION, text
                        )
                 VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' PRC_PROCESSMSG 1 '||V_MSG_RECEIVE.ID,to_char(systimestamp)
                        );
                        */
                  PRC_PROCESS2I(V_MSG_RECEIVE.MSGXML);
                 /*
                  INSERT INTO log_err
                        (id,date_log, POSITION, text
                        )
                 VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' PRC_PROCESSMSG 2 '||V_MSG_RECEIVE.ID,to_char(systimestamp)
                        );
                         */
                ELSIF V_MSG_RECEIVE.MSGTYPE ='2L' THEN
                  PRC_PROCESS2L(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='2F' THEN
                  PRC_PROCESS2F(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='3B' THEN
                  PRC_PROCESS3B(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='3C' THEN
                  PRC_PROCESS3C(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='SC' THEN
                  PRC_PROCESSSC(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='TR' THEN
                  PRC_PROCESSTR(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='GA' THEN
                  PRC_PROCESSGA(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='SU' THEN
                  PRC_PROCESSSU(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='SS' THEN
                  PRC_PROCESSSS(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='TC' THEN
                  PRC_PROCESSTC(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='TS' THEN
                  PRC_PROCESSTS(V_MSG_RECEIVE.MSGXML,TO_CHAR(V_MSG_RECEIVE.MSG_DATE,'HH24MISS'));
                ELSIF V_MSG_RECEIVE.MSGTYPE ='BS' THEN
                  PRC_PROCESSBS(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='3D' THEN
                  PRC_PROCESS3D(V_MSG_RECEIVE.MSGXML);
                ELSIF V_MSG_RECEIVE.MSGTYPE ='AA' THEN
                  PRC_PROCESSAA(V_MSG_RECEIVE.MSGXML);
                END IF;
            IF v_CheckProcess = TRUE THEN
                  UPDATE MSGRECEIVETEMP SET PROCESS ='Y'WHERE ID =V_MSG_RECEIVE.ID;
            Else
                  UPDATE MSGRECEIVETEMP SET PROCESS ='E' WHERE ID =V_MSG_RECEIVE.ID;
                  plog.error(pkgctx,'PRC_PROCESSMSG '||'Cant not process MSG ID = '||V_MSG_RECEIVE.ID||' V_MSG_RECEIVE.MSGTYPE = '||V_MSG_RECEIVE.MSGTYPE);
            END IF;
            COMMIT;
        EXCEPTION WHEN OTHERS THEN
            plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
            rollback;
            UPDATE MSGRECEIVETEMP SET PROCESS ='R' WHERE ID =V_MSG_RECEIVE.ID;
            plog.error(pkgctx,'PRC_PROCESSMSG '||'exeption in process MSG ID = '||V_MSG_RECEIVE.ID||' V_MSG_RECEIVE.MSGTYPE = '||V_MSG_RECEIVE.MSGTYPE);
            commit;
         End;
         /* if V_MSG_RECEIVE.MSGTYPE ='2I' then
            INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
             VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' PRC_PROCESSMSG 3 '||V_MSG_RECEIVE.ID,to_char(systimestamp)
                  );
           end if;  */
      END LOOP;
      CLOSE C_MSG_RECEIVE;

      plog.setendsection (pkgctx, 'PRC_PROCESSMSG');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_PROCESSMSG');
    ROLLBACK;
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSMSG;
--DUCNV0704
Procedure PRC_PROCESSMSG_ERR is
 v_IsProcess VARCHAR2(1);
BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESSMSG_ERR');
    v_IsProcess:='N';
    Begin
       Select SYSVALUE Into v_IsProcess From Ordersys
       Where SYSNAME ='ISPROCESS';
    Exception When others then
         v_IsProcess:='N';
    End;
    If v_IsProcess = 'Y' then

        Update msgreceivetemp set process='N' WHERE PROCESS='E' ;
        COMMIT;
    End if;
    plog.setendsection (pkgctx, 'PRC_PROCESSMSG_ERR');
EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'PRC_PROCESSMSG_ERR');
    ROLLBACK;
    RAISE errnums.E_SYSTEM_ERROR;
END PRC_PROCESSMSG_ERR;
 --PROCESS MSG 2b
 Procedure PRC_PROCESS2B(V_MSGXML VARCHAR2) is
    V_TX2B   tx.msg_2B;
    V_ORGORDERID VARCHAR2(20);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESS2B');

      V_TX2B:=fn_xml2obj_2B(V_MSGXML);

      --XU LY MESSAGE 2B.
      BEGIN
        SELECT ORGORDERID INTO V_ORGORDERID
        FROM ORDERMAP WHERE ctci_order= V_TX2B.ORDER_NUMBER;
      EXCEPTION WHEN OTHERS THEN
        v_CheckProcess := FALSE;
        plog.debug(pkgctx,'PRC_PROCESS2B'||'Khong tim so hieu lenh goc V_TX2B.ORDER_NUMBER: '||V_TX2B.ORDER_NUMBER);
      END;

      UPDATE OOD SET OODSTATUS = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
      WHERE ORGORDERID = V_ORGORDERID;

      UPDATE ODMAST SET ORSTATUS = '2', HOSESESSION = (SELECT SYSVALUE  FROM ORDERSYS WHERE SYSNAME = 'CONTROLCODE')
      WHERE ORDERID = V_ORGORDERID AND ORSTATUS = '8';

      plog.setendsection (pkgctx, 'PRC_PROCESS2B');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESS2B');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS2B;

  --PROCESS MSG 2C
 Procedure PRC_PROCESS2C(V_MSGXML VARCHAR2) is
    V_TX2C   tx.msg_2C;
    V_ORGORDERID VARCHAR2(20);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESS2C');

      V_TX2C:=fn_xml2obj_2C(V_MSGXML);

      --XU LY MESSAGE 2C.
      BEGIN
          SELECT ORGORDERID INTO V_ORGORDERID FROM ORDERMAP
          WHERE ctci_order =TRIM(V_TX2C.order_number);

          CONFIRM_CANCEL_NORMAL_ORDER(V_ORGORDERID,V_TX2C.cancel_shares);
      EXCEPTION WHEN OTHERS THEN
        v_CheckProcess := FALSE;
        plog.debug(pkgctx,'PRC_PROCESS2C '||SQLERRM ||'Khong tim so hieu lenh goc V_TX2C.ORDER_NUMBER: '||V_TX2C.ORDER_NUMBER);
      END;


      plog.setendsection (pkgctx, 'PRC_PROCESS2C');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESS2C');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS2C;

 --PROCESS MSG 2E
 Procedure PRC_PROCESS2E(V_MSGXML VARCHAR2) is
    V_TX2E   tx.msg_2E;
    V_ORGORDERID VARCHAR2(20);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESS2E');

      V_TX2E:=fn_xml2obj_2E(V_MSGXML);

      --XU LY MESSAGE 2E.
      --1.1 Lay so hieu lenh
      BEGIN
          SELECT ORGORDERID INTO V_ORGORDERID FROM ORDERMAP
          WHERE ctci_order=V_TX2E.order_number;
          --1.2 Cap nhat trang thai lenh thanh Sent: S
          UPDATE OOD SET OODSTATUS = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
          WHERE ORGORDERID = V_ORGORDERID;

          --Goi thu thuc khop lenh
          MATCHING_NORMAL_ORDER (V_TX2E.firm,V_TX2E.order_number,V_TX2E.order_entry_date,
                                    V_TX2E.side,V_TX2E.filler,V_TX2E.volume,
                                    V_TX2E.price, V_TX2E.confirm_number);
      EXCEPTION WHEN OTHERS THEN
        v_CheckProcess := FALSE;
        plog.debug(pkgctx,'PRC_PROCESS2E'||SQLERRM ||'Khong tim so hieu lenh goc V_TX2E.ORDER_NUMBER: '||V_TX2E.ORDER_NUMBER);
      END;

      plog.setendsection (pkgctx, 'PRC_PROCESS2E');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESS2E');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS2E;

--- process 2g
 Procedure PRC_PROCESS2G(V_MSGXML VARCHAR2) is
    V_TX2G   tx.msg_2G;
    V_ORGORDERID VARCHAR2(20);
    v_msgReject varchar2(200);
    v_orderqtty number;
    v_codeid varchar2(10);
    v_contrafirm varchar2(10);
    v_custodycd varchar2(10);
    v_RefOrderID  varchar2(20);
    v_ptdeal      varchar2(20);
    v_qtty number;
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESS2g');
      V_TX2G:=fn_xml2obj_2G(V_MSGXML);

      --XU LY MESSAGE 2G.
      BEGIN
        SELECT ORGORDERID INTO V_ORGORDERID
        FROM ORDERMAP WHERE ctci_order = TRIM(V_TX2G.ORDER_NUMBER);
        --ly do tu choi
        BEGIN
            Select cdcontent  Into v_msgReject
            From allcode
            Where cdname = 'REJECT_REASON_CODE' and cdval =V_TX2G.reject_reason_code;
        EXCEPTION WHEN OTHERS THEN
        v_msgReject:='No define';
      END;

      EXCEPTION WHEN OTHERS THEN
            v_CheckProcess := FALSE;
            plog.debug(pkgctx,'PRC_PROCESS2G'||'Khong tim so hieu lenh goc V_TX2G.ORDER_NUMBER: '||V_TX2G.ORDER_NUMBER);
            RAISE errnums.E_SYSTEM_ERROR;

      END;

      If V_TX2G.msg_type='1I' then
             UPDATE OOD SET
                   OODSTATUS = 'S',
                   TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
             WHERE ORGORDERID = V_ORGORDERID and OODSTATUS <> 'S';

             Select remainqtty into v_qtty
             From odmast Where Orderid = V_ORGORDERID;

             CONFIRM_CANCEL_NORMAL_ORDER(V_ORGORDERID, v_qtty);

             Update odmast SET
                   ORSTATUS = '6',
                   FEEDBACKMSG= v_msgReject
             Where  Orderid = V_ORGORDERID;
       elsif V_TX2G.msg_type='1F' then --Thoa thuan cung cong ty (can huy lenh mua tuong ung)
            --Tim thong tin lenh mua doi ung
            select orderqtty, odmast.codeid, contrafirm, ood.custodycd, ptdeal
            into
                   v_orderqtty,
                   v_codeid,
                   v_contrafirm,
                   v_custodycd,
                   v_ptdeal
            from odmast, ood
            where Orderid = V_ORGORDERID   and odmast.orderid=ood.orgorderid;

            select max(orderid)  into v_RefOrderID
            from odmast
            where codeid = v_codeid
                  and orderqtty = v_orderqtty
                  and clientid = v_custodycd
                  and contrafirm = (select sysvalue from ordersys where sysname='FIRM')
                  and matchtype = 'P'
                  and ptdeal =v_ptdeal
                  AND txdate =getcurrdate
                  AND orstatus ='8' ;--tranh huy lenh da khop

            CONFIRM_CANCEL_NORMAL_ORDER(v_RefOrderID,v_orderqtty);
            CONFIRM_CANCEL_NORMAL_ORDER(V_ORGORDERID,v_orderqtty);

            UPDATE OOD SET
                   OODSTATUS = 'S',
                   TXTIME    = TO_CHAR(SYSDATE, 'HH24:MI:SS')
            WHERE ORGORDERID in ( v_RefOrderID,V_ORGORDERID) and OODSTATUS <> 'S';

            Update odmast   SET
                   ORSTATUS   = '6',
                   FEEDBACKMSG= v_msgReject
            Where Orderid  in (v_RefOrderID,V_ORGORDERID);
       elsif V_TX2G.msg_type='1G' then --Thoa thuan khac cong ty
            --Tim thong tin lenh ban goc
            select orderqtty   INTO  v_orderqtty
            from odmast
            where Orderid = V_ORGORDERID and matchtype = 'P' ;

            CONFIRM_CANCEL_NORMAL_ORDER(V_ORGORDERID,v_orderqtty);

            UPDATE OOD SET
                   OODSTATUS = 'S',
                   TXTIME    = TO_CHAR(SYSDATE, 'HH24:MI:SS')
            WHERE ORGORDERID = V_ORGORDERID  and OODSTATUS <> 'S';

            Update odmast   set
                   ORSTATUS   = '6',
                   FEEDBACKMSG= v_msgReject
            Where Orderid  in (V_ORGORDERID);
     elsIf v_tx2g.msg_type='1C' THEN
            --Tim orderid lenh yeu cau huy : v_RefOrderID
            --Cap nhat trang thai lenh yeu cau huy /suu
            Select orderid  Into v_RefOrderID
            From odmast
            Where reforderid  = V_ORGORDERID
                and exectype in ('CS','CB','AB','AS')
                and ORSTATUS <>'6' ; --huy ban/mua

            update ood  set
                  oodstatus='S'
            where oodstatus='B'
                  and BORS not in('B','S')
                  and reforderid=V_ORGORDERID;

            Update odmast  set
                   ORSTATUS   = '6',
                   FEEDBACKMSG= v_msgReject
            Where Orderid = v_RefOrderID;

             --Xu ly cho phep dat lai lenh huy
            DELETE odchanging WHERE orderid =v_RefOrderID;
            update  fomast set status='R', feedbackmsg=v_msgReject
            WHERE orgacctno=v_RefOrderID;
   elsIf v_tx2g.msg_type='3C'  then --Tu choi huy lenh

            --Tim orderid lenh yeu cau huy : v_RefOrderID
            --Cap nhat trang thai lenh yeu cau huy /sua
            UPDATE CANCELORDERPTACK   SET
                   status='S' ,
                   isconfirm='Y'
            WHERE ordernumber= V_ORGORDERID
                  AND SORR='S' AND MESSAGETYPE='3C'
                  AND STATUS='S';
  end if;
      insert into ctci_reject( firm,
                  order_number,
                  reject_reason_code,
                  original_message_text,
                  order_entry_date,
                  msgtype)
       VALUES(V_TX2G.FIRM,
                  V_TX2G.order_number,
                  V_TX2G.reject_reason_code,
                  V_TX2G.original_message_text,
                  V_TX2G.order_entry_date,
                  V_TX2G.msg_type);

      plog.setendsection (pkgctx, 'PRC_PROCESS2G');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESS2G');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS2G;

  --PROCESS MSG 2I
  Procedure PRC_PROCESS2I(V_MSGXML VARCHAR2) is
    V_TX2I   tx.msg_2I;
    V_ORGORDERID VARCHAR2(20);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESS2I');

   INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' PRC_PROCESS2I 1 : '||TRIM(V_TX2I.order_number_buy),to_char(systimestamp)
                  );

      V_TX2I:=fn_xml2obj_2I(V_MSGXML);

      --XU LY MESSAGE 2I.
      --1.1 Lay so hieu lenh
      BEGIN

         INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' PRC_PROCESS2I 1 : '||TRIM(V_TX2I.order_number_buy),to_char(systimestamp)
                  );

          UPDATE OOD SET OODSTATUS = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
          WHERE ORGORDERID IN  (SELECT ORGORDERID
                                 FROM ORDERMAP
                                 WHERE ctci_order=V_TX2I.order_number_buy
                                  OR
                                      ctci_order=V_TX2I.order_number_sell
                                );
         INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' PRC_PROCESS2I 2 : '||TRIM(V_TX2I.order_number_buy),to_char(systimestamp)
                  );

          --Goi thu thuc khop lenh voi lenh mua B
          MATCHING_NORMAL_ORDER (V_TX2I.firm,V_TX2I.order_number_buy,V_TX2I.order_entry_date_buy,
                                    'B','',V_TX2I.volume,
                                    V_TX2I.price, V_TX2I.confirm_number);
          INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' PRC_PROCESS2I 3 : '||TRIM(V_TX2I.order_number_buy),to_char(systimestamp)
                  );
          --Goi thu thuc khop lenh voi lenh ban S
          MATCHING_NORMAL_ORDER (V_TX2I.firm,V_TX2I.order_number_sell,V_TX2I.order_entry_date_sell,
                                    'S','',V_TX2I.volume,
                                    V_TX2I.price, V_TX2I.confirm_number);
           INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' PRC_PROCESS2I 4 : '||TRIM(V_TX2I.order_number_buy),to_char(systimestamp)
                  );
      EXCEPTION WHEN OTHERS THEN
        v_CheckProcess := FALSE;
        plog.debug(pkgctx,'PRC_PROCESS2I'||SQLERRM ||'Khong tim so hieu lenh goc V_TX2I.order_number_buy: '||V_TX2I.order_number_buy);
      END;

      plog.setendsection (pkgctx, 'PRC_PROCESS2I');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESS2I');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS2I;


  --PROCESS MSG 2L
  Procedure PRC_PROCESS2L(V_MSGXML VARCHAR2) is
    V_TX2L   tx.msg_2L;
    V_ORGORDERID VARCHAR2(20);
    v_strContraOrderId VARCHAR2(20);
    V_OneFirm Boolean;
    v_StrClientID Varchar2(20);
    v_strCUSTODYCD Varchar2(20);
    v_strBorS Varchar2(20);
    v_dblCTCI_order Varchar2(20);

    /*CURSOR C_TWOFIRM(v_strORDERID Varchar2) IS
      SELECT OD.ORDERID ORDERID,od.CONTRAFIRM CONTRAFIRM,OD.TRADERID TRADERID,
      OD.CLIENTID CLIENTID,OOD.CUSTODYCD CUSTODYCD,OOD.BORS BORS
      FROM ORDERMAP MAP,ODMAST OD,OOD
      WHERE OOD.ORGORDERID=OD.ORDERID AND TRIM(OD.CLIENTID) IS NOT NULL
      AND TRIM(OD.TRADERID) IS NOT NULL
      AND MAP.ORGORDERID=OD.orderid
      AND substr(OD.CLIENTID,1,3) = substr(OOD.CUSTODYCD,1,3)
      AND ORDERID=v_strORDERID
      ;
      */
      CURSOR C_TWOFIRM(v_strORDERID Varchar2) IS
      SELECT OD.ORDERID ORDERID,od.CONTRAFIRM CONTRAFIRM,OD.TRADERID TRADERID,
      OD.CLIENTID CLIENTID,O1.CUSTODYCD CUSTODYCD,O1.BORS BORS, o2.orgorderid ContraOrderId
      FROM ORDERMAP MAP,ODMAST OD,OOD O1, OOD O2, odmast om2
      WHERE O1.ORGORDERID=OD.ORDERID AND TRIM(OD.CLIENTID) IS NOT NULL
      AND TRIM(OD.TRADERID) IS NOT NULL
      AND MAP.ORGORDERID=OD.orderid
      AND od.ORDERID=v_strORDERID
      and od.clientid = O2.custodycd
      and o1.bors <> o2.bors
      and o1.qtty = o2.qtty
      and o1.price = o2.price
      and o2.norp='P'
      and o2.oodstatus<>'S'
      and o2.Deltd <>'Y'
      and o2.orgorderid=om2.orderid
      and om2.exectype in ('NB','NS')
      and om2.remainqtty = o2.qtty;

   v_TWOFIRM C_TWOFIRM%Rowtype;
   Cursor c_Ctci_Order(v_strORDERID Varchar2) is
   Select CTCI_ORDER
    From ORDERMAP
    WHERE Orgorderid=v_strORDERID;
   v_CTCI_order Varchar2(20);

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESS2L');

      V_TX2L:=fn_xml2obj_2L(V_MSGXML);

      --XU LY MESSAGE 2L.
      BEGIN
          --Neu la lenh thoa thuan mua:
          If V_TX2L.side ='B' Then
            Select ORDERID Into V_ORGORDERID from Odmast
            WHERE trim(CONFIRM_NO)=trim(V_TX2L.confirm_number ) and txdate = getcurrdate;
            v_strBORS:='B';

          Else --Thoa thuan ban, hoac Onefirm: Deal_ID chinh la so hieu lenh cty gui len

            Select ORGORDERID ORDERID  Into V_ORGORDERID
            From ORDERMAP WHERE CTCI_ORDER=trim(V_TX2L.deal_id);
            v_strBORS:='S';
          End if;
          --Lay so hieu lenh CTCI:
          OPEN c_Ctci_Order(V_ORGORDERID);
          Fetch c_Ctci_Order into v_CTCI_order;
          Close c_Ctci_Order;

          --Kiem tra xem day la lenh one-firm or two-firm put-through order

          Open C_TWOFIRM(V_ORGORDERID);
          Fetch C_TWOFIRM into v_TWOFIRM;
          If C_TWOFIRM%notfound then
            V_OneFirm := false;
          Else  --OneFirm
            V_OneFirm := true;
            v_StrClientID  :=v_TWOFIRM.CLIENTID;
            v_strCUSTODYCD :=v_TWOFIRM.CUSTODYCD;
            v_strBORS      :=v_TWOFIRM.BORS;
             v_strContraOrderId :=v_TWOFIRM.ContraOrderId;
          End if;
          Close C_TWOFIRM;

          UPDATE OOD SET OODSTATUS = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
          WHERE ORGORDERID = V_ORGORDERID;

          --Khop lenh
          -- 1.1 Neu khop cung cong ty
          If V_OneFirm=True then
            plog.debug(pkgctx,'Khop lenh cung cong ty');
            --1.1.1 Khop lenh ban
                  --Goi thu thuc khop lenh voi lenh ban S
            plog.debug(pkgctx,'Khop lenh ban '||V_TX2L.deal_id);
            MATCHING_NORMAL_ORDER (V_TX2L.firm,V_TX2L.deal_id,
                                     '',
                                     'S','',V_TX2L.volume,
                                    V_TX2L.price, V_TX2L.confirm_number);
            --1.1.2 Khop voi lenh doi ung mua
           /*
            Begin
                Select ood.orgorderid into v_strContraOrderId from ood
                Where ood.custodycd=v_StrClientID
                      And ood.bors <> v_strBORS
                      And ood.QTTY=V_TX2L.volume
                      And ood.PRICE = V_TX2L.PRICE * 1000
                      and norp='P';
            Exception when others then
               plog.error(pkgctx, SQLERRM);
            End;
            */

            If v_strContraOrderId is not null then
                --Lay so hieu lenh tu Ordermap de khop lenh.
                Select '8'||SEQ_ORDERMAP_PT.NEXTVAL into v_dblCTCI_order from dual;
                INSERT INTO ORDERMAP(ctci_order,orgorderid)
                VALUES (v_dblCTCI_order ,v_strContraOrderId);

                UPDATE OOD SET OODSTATUS = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
                  WHERE ORGORDERID = v_strContraOrderId;

                plog.debug(pkgctx,'Khop lenh doi ung '||v_dblCTCI_order);
                --Thuc hien khop
                MATCHING_NORMAL_ORDER (V_TX2L.firm,v_dblCTCI_order,
                                     '',
                                     'B','',V_TX2L.volume,
                                    V_TX2L.price, V_TX2L.confirm_number);
            End if;

          Else --Neu khop khac cong ty.
                plog.debug(pkgctx,'Khop lenh khac cong ty: '||v_CTCI_order);
                MATCHING_NORMAL_ORDER (V_TX2L.firm,v_CTCI_order,
                                     '',
                                    v_strBORS,'',V_TX2L.volume,
                                    V_TX2L.price, V_TX2L.confirm_number);

          End if;

      EXCEPTION WHEN OTHERS THEN
        v_CheckProcess := FALSE;
        plog.debug(pkgctx,'PRC_PROCESS2L'||SQLERRM);
      END;

      plog.setendsection (pkgctx, 'PRC_PROCESS2L');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESS2L');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS2L;

-- Process msg 3B
 Procedure PRC_PROCESS3B(V_MSGXML VARCHAR2) is
    V_TX3b   tx.msg_3B;
    V_ORGORDERID VARCHAR2(20);
    p_err_param varchar2(30);
    p_err_code varchar2(30);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESS3B');
      plog.debug(pkgctx,'BEGIN PRC_PROCESS3b');
      V_TX3b:=fn_xml2obj_3B(V_MSGXML);

      --XU LY MESSAGE 3B.
      BEGIN
        SELECT ORGORDERID INTO V_ORGORDERID
        FROM ORDERMAP WHERE ctci_order= TRIM(V_TX3b.deal_id);
      EXCEPTION WHEN OTHERS THEN
        v_CheckProcess := FALSE;
        plog.debug(pkgctx,'PRC_PROCESS3b'||'Khong tim so hieu lenh goc V_TX3b.deal_id: '||V_TX3b.deal_id);
      END;

      UPDATE OOD SET OODSTATUS = 'S', TXTIME = TO_CHAR(SYSDATE,'HH24:MI:SS')
      WHERE ORGORDERID = V_ORGORDERID;
      IF V_TX3b.reply_code='C' THEN
          Update odmast
          Set deltd ='Y', CANCELQTTY =ORDERQTTY,
               REMAINQTTY=0,EXECQTTY =0 ,MATCHAMT =0,Execamt =0, ORSTATUS = '2'
          Where MATCHTYPE ='P'
                  And Orderid = V_ORGORDERID;
          ----Ducnv + hailt
          Update ood set  deltd ='Y' where orgorderid = V_ORGORDERID;

          For vc in (select orderid
                  from odmast where grporder='Y' and  orderid= V_ORGORDERID)
          loop
              cspks_seproc.pr_executeod9996(V_ORGORDERID,p_err_code,p_err_param);
          End loop;

         ----End of Ducnv
      END IF;
     insert into orderptack( messagetype, firm, side,        confirmnumber,
     status, issend,        ordernumber,        trading_date )
     values ('3B',V_TX3b.firm,'S',V_TX3b.confirm_number,
     V_TX3b.reply_code,'S',V_ORGORDERID,trunc(sysdate));

      plog.setendsection (pkgctx, 'PRC_PROCESS3B');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESS3B');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS3B;

--PROCESS MSG 3C
 Procedure PRC_PROCESS3C(V_MSGXML VARCHAR2) is
    V_TX3C   tx.msg_3C;
    V_ORGORDERID VARCHAR2(20);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESS3C');

      V_TX3C:=fn_xml2obj_3C(V_MSGXML);

      --XU LY MESSAGE 3C.
      --1.1 Lay so hieu lenh
    INSERT INTO cancelorderptack
                (sorr, TIMESTAMP, messagetype, firm, contrafirm, tradeid,
                 side, securitysymbol, confirmnumber, status, isconfirm,
                 ordernumber, brid, tlid, txtime, ipaddress, trading_date
                )
         VALUES ('R', to_char(sysdate,'hh24miss'), '', V_TX3C.firm, V_TX3C.contra_firm, V_TX3C.trader_id,
                 V_TX3C.side, V_TX3C.security_symbol, V_TX3C.confirm_number, 'N', 'N',
                 '', '', '', '', '', trunc(sysdate)
                );

   plog.setendsection (pkgctx, 'PRC_PROCESS3C');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESS3C');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS3C;


--PROCESS MSG 3D
 Procedure PRC_PROCESS3D(V_MSGXML VARCHAR2) is
    V_TX3D   tx.msg_3D;
    V_ORGORDERID VARCHAR2(20);
    v_afaccount VARCHAR2(20);
    p_err_param varchar2(30);
    p_err_code varchar2(30);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESS3D');

      V_TX3D:=fn_xml2obj_3D(V_MSGXML);

      plog.debug (pkgctx, 'PRC_PROCESS3D Parse successful');

      --XU LY MESSAGE 3D.
      Insert into msg_3d(confirm_number,firm,reply_code)
           values(V_TX3D.CONFIRM_NUMBER ,V_TX3D.FIRM ,V_TX3D.REPLY_CODE);
      plog.debug (pkgctx, 'PRC_PROCESS3D Insert msg_3d successful');
      --Cap nhat trang thai

      If V_TX3D.REPLY_CODE = 'C' Then --CONTRA DISAPPROVE
          --THUC HIEN CAP NHAT YEU CAU HUY TRONG HE THONG KHONG THANH CONG
          UPDATE CANCELORDERPTACK
          SET STATUS='C', ISCONFIRM='Y'
          WHERE MESSAGETYPE='3C' AND SORR='S' AND CONFIRMNUMBER=V_TX3D.CONFIRM_NUMBER;
          plog.debug (pkgctx, 'PRC_PROCESS3D Update CONTRA DISAPPROVE successful');
      ElsIf V_TX3D.REPLY_CODE = 'S' Then --SYSTEM SET DISAPPROVE
          --THUC HIEN CAP NHAT YEU CAU HUY TRONG HE THONG KHONG THANH CONG
          UPDATE CANCELORDERPTACK SET STATUS='S', ISCONFIRM='Y'
          WHERE MESSAGETYPE='3C' AND SORR='S' AND CONFIRMNUMBER=V_TX3D.CONFIRM_NUMBER;
          plog.debug (pkgctx, 'PRC_PROCESS3D Update SYSTEM SET DISAPPROVE successful');
      ElsIf V_TX3D.REPLY_CODE = 'A' Then --DONG Y HUY
          --HUC HIEN CAP NHAT YEU CAU HUY TRONG HE THONG KHONG THANH CONG
          UPDATE CANCELORDERPTACK SET STATUS='A', ISCONFIRM='Y'
          WHERE MESSAGETYPE='3C' AND SORR='S'
          AND CONFIRMNUMBER=V_TX3D.CONFIRM_NUMBER;

          --Giai toa lenh thoa thuan da khop
             --Xu ly Odmast
          plog.debug (pkgctx, 'PRC_PROCESS3D Update CANCELORDERPTACK successful');

          For i in (Select orgorderid ,codeid,bors,matchprice,matchqtty,txnum,txdate ,custodycd
                            From iod
                            Where NorP ='P'
                            And trim(confirm_no) =trim(V_TX3D.CONFIRM_NUMBER))
          Loop

             Update odmast set deltd ='Y', CANCELQTTY =ORDERQTTY,
                                REMAINQTTY=0,EXECQTTY =0 ,MATCHAMT =0,Execamt =0
              Where MATCHTYPE ='P'
              And Orderid = i.orgorderid;

             Update ood set  deltd ='Y' where orgorderid = i.orgorderid;
             Update stschd set deltd = 'Y'
             where  orgorderid = i.orgorderid;

              For vc in (select orderid
                         from odmast where grporder='Y' and  orderid= i.orgorderid)
              Loop
                cspks_seproc.pr_executeod9996(i.orgorderid,p_err_code,p_err_param);
              End loop;


              if i.bors = 'B' then
                -- quyet.kieu : Them cho LINHLNB 21/02/2012
                -- Begin Danh sau tai san LINHLNB

                Select  afacctno into v_afaccount  from ODMAST   Where MATCHTYPE ='P' And Orderid = i.orgorderid;

                INSERT INTO odchanging_trigger_log (AFACCTNO,CODEID,AMT,TXNUM,TXDATE,ERRCODE,LAST_CHANGE,ORDERID,ACTIONFLAG, QTTY)
                VALUES( v_afaccount,i.codeid ,i.matchprice * i.matchqtty,i.txnum, i.txdate,NULL,systimestamp,i.orgorderid,'C', i.matchqtty);
                -- End Danh dau tai san LINHLNB
              end if ;


          End Loop;
          plog.debug (pkgctx, 'PRC_PROCESS3D Update odmast  successful');

            --Xu ly IOD
          Update iod set Deltd ='Y' where NorP ='P'
                         And trim(confirm_no) =trim(V_TX3D.CONFIRM_NUMBER);
          plog.debug (pkgctx, 'PRC_PROCESS3D Update odmast  successful');
      End if;

   plog.setendsection (pkgctx, 'PRC_PROCESS3D');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESS3D');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS3D;

 --Xu ly Message AA
  Procedure PRC_PROCESSAA(V_MSGXML VARCHAR2) is
    V_TXAA   tx.msg_AA;
  BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESS7');

     V_TXAA:=fn_xml2obj_AA(V_MSGXML);
      --XU LY MESSAGE AA.
    If V_TXAA.add_cancel_flag = 'A' Then
        INSERT INTO hoput_ad
                    (security_number ,
                        firm ,
                        volume ,
                        price,
                        trader ,
                        side ,
                        board ,
                        txtime ,
                        txdate,
                        add_cancel_flag ,
                        contact
                    )
             VALUES (v_txAA.security_number, v_txAA.firm, v_txAA.volume, v_txAA.price,
                     v_txAA.trader, v_txAA.side, v_txAA.board, v_txAA.txtime, to_date(getcurrdate,'DD/MM/RRRR'),
                     v_txAA.add_cancel_flag,v_txAA.contact
                    );
     Else

        UPDATE hoput_ad
           SET add_cancel_flag = v_txAA.add_cancel_flag
         WHERE txtime = v_txAA.txtime;
     End If;

    plog.setendsection (pkgctx, 'PRC_PROCESSAA');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESSAA');
    --RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSAA;


/*

--PROCESS MSG 2D
 Procedure PRC_PROCESS2D(V_MSGXML VARCHAR2) is
    V_TX2D   tx.msg_2D;
    V_ORGORDERID VARCHAR2(20);
    V_TXNUM VARCHAR2(20);
    V_CUSTID VARCHAR2(20);
    V_AFACCTNO VARCHAR2(20);
    v_ORDERID VARCHAR2(20);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESS2D');

      V_TX2D:=fn_xml2obj_2D(V_MSGXML);

      plog.debug (pkgctx, 'PRC_PROCESS2D Parse successful');

      --XU LY MESSAGE 2D.
      --Insert into msg_3d(confirm_number,firm,reply_code)
      --     values(V_TX3D.CONFIRM_NUMBER ,V_TX3D.FIRM ,V_TX3D.REPLY_CODE);
      plog.debug (pkgctx, 'PRC_PROCESS2D Insert msg_2d successful');
      --Cap nhat trang thai


      For i in (Select orgorderid
                        From ORDERMAP
                        Where
                        CTCI_ORDER =trim(V_TX2D.ORDERNUMBER))
      Loop
         plog.debug (pkgctx, 'PRC_PROCESS2D i.orgorderid ='||i.orgorderid);
        Update odmast set deltd ='Y', remainqtty =0,
cancelqtty =orderqtty
          Where Orderid = i.orgorderid;
        UPDATE OOD SET DELTD ='Y' Where orgorderid = i.orgorderid;

        SELECT CUSTID INTO V_CUSTID FROM  CFMAST WHERE CUSTODYCD =V_TX2D.clientid;
        SELECT MAX(ACCTNO) INTO V_AFACCTNO FROM AFMAST WHERE CUSTID =V_CUSTID;

      --TAO LENH MOI CHO TAI KHOAN DC CHUYENE
        Select '0001'||to_char(to_date('12/05/2011','dd/mm/yyyy'),'ddmmyy')||lpad(SEQ_ODMAST.NEXTVAL,6,'0')
     into v_OrderID from dual;

      SELECT    '8080'
             || SUBSTR ('000000' || seq_batchtxnum.NEXTVAL,
                        LENGTH ('000000' || seq_batchtxnum.NEXTVAL) - 5,
                        6
                       )
        INTO v_txnum
        FROM DUAL;

      INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO
                 ,SEACCTNO,CIACCTNO,
                 TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                 EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                 QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,SECUREDAMT,
                 EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,REFORDERID,CORRECTIONNUMBER)
          SELECT  v_ORDERID , v_CUSTID , ACTYPE , CODEID , v_AFACCTNO
                  ,V_AFACCTNO||CODEID ,v_AFACCTNO
                  , v_TXNUM ,TO_DATE (TXDATE, 'DD/MM/YYYY'), TXTIME
                  ,TO_DATE (TXDATE, 'DD/MM/YYYY'),BRATIO ,TIMETYPE
                  ,EXECTYPE ,NORK ,MATCHTYPE ,VIA ,CLEARDAY , CLEARCD ,'2','2',PRICETYPE
                  ,QUOTEPRICE ,STOPPRICE,LIMITPRICE ,ORDERQTTY,ORDERQTTY,EXPRICE,EXQTTY,SECUREDAMT,
                  0,0,0,0,0,'001', VOUCHER , CONSULTANT , v_ORDERID , 1
                  FROM ODMAST WHERE Orderid = i.orgorderid;

       --Ghi nhan vao so lenh day di
       INSERT INTO OOD (ORGORDERID,CODEID,SYMBOL,CUSTODYCD,
            BORS,NORP,AORN,PRICE,QTTY,SECUREDRATIO,OODSTATUS,
            TXDATE,TXTIME,TXNUM,DELTD,BRID,REFORDERID)
       SELECT v_ORDERID , CODEID , SYMBOL ,V_TX2D.clientid,
            BORS ,NORP ,AORN ,PRICE ,QTTY ,SECUREDRATIO ,'S' ,
            TO_DATE (TXDATE, 'DD/MM/YYYY'),  TXTIME , v_TXNUM ,'N',BRID , REFORDERID
            FROM OOD WHERE ORGOrderid = i.orgorderid;


      End Loop;
      plog.debug (pkgctx, 'PRC_PROCESS2D Update odmast  successful');





   plog.setendsection (pkgctx, 'PRC_PROCESS2D');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    plog.setendsection (pkgctx, 'PRC_PROCESS2D');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS2D;

  */
--PROCESS MSG 2F

--PROCESS MSG 2D
 Procedure PRC_PROCESS2D(V_MSGXML VARCHAR2) is
    V_TX2D   tx.msg_2D;
    V_ORGORDERID VARCHAR2(20);
    PV_ORDERID VARCHAR2(20);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESS2D');

      V_TX2D:=fn_xml2obj_2D(V_MSGXML);

      -- Cap nhat lai gia qua msg 2D de giai toa
      Select Orgorderid into PV_ORDERID from Ordermap where ctci_order =V_TX2D.ordernumber;
      UPDATE ODMAST Set quoteprice = V_TX2D.price *1000  WHERE ORDERID =PV_ORDERID;

      --XU LY MESSAGE 2D.
     -- CONFIRM_REPLACE_NORMAL_ORDER(V_TX2D.ordernumber,V_TX2D.price);

      plog.setendsection (pkgctx, 'PRC_PROCESS2D');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESS2D');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS2D;



 Procedure PRC_PROCESS2F(V_MSGXML VARCHAR2) is
    V_TX2F   tx.msg_2F;
    V_ORGORDERID VARCHAR2(20);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESS2F');

      V_TX2F:=fn_xml2obj_2F(V_MSGXML);

      --XU LY MESSAGE 2F.
      --1.1 Lay so hieu lenh
  INSERT INTO orderptack
            (TIMESTAMP, messagetype, firm, buyertradeid, side,
             sellercontrafirm, sellertradeid, securitysymbol, volume,
             price, board, confirmnumber, offset, status, issend,
             ordernumber, brid, tlid, txtime, ipaddress, trading_date,
             sclientid
            )
     VALUES (TO_CHAR(SYSDATE,'HH24MISS'), '', V_TX2F.firm_buy, V_TX2F.trader_id_buy, V_TX2F.side_b,
             V_TX2F.contra_firm_sell, V_TX2F.trader_id_contra_side_sell, V_TX2F.security_symbol, V_TX2F.volume,
             V_TX2F.price, V_TX2F.board, TRIM(V_TX2F.confirm_number), '', 'N', 'N',
             '', '', '', '', '', TRUNC(SYSDATE),
             ''
            );

   plog.setendsection (pkgctx, 'PRC_PROCESS2F');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESS2F');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESS2F;


 --PROCESS MSG SU
 Procedure PRC_PROCESSSU(V_MSGXML VARCHAR2) is
    V_TXSU   tx.msg_SU;
    V_ORGORDERID VARCHAR2(20);
    V_UpdatePrice Varchar2(10);
    v_Count Number(10);
    v_Halt  Varchar2(10);
    v_Security_Type Varchar2(10);
    v_strErrCode  Varchar2(20);
    v_strErrM Varchar2(200);
    l_CODEID Varchar2(10);
    V_EXERCISERATIO NUMBER;
    l_tradeplace_old Varchar2(20);  --1.5.1.3 | 1808
    l_codeid_old    Varchar2(20);   --1.5.1.3 | 1808
    v_tradelot_hsx        NUMBER;

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESSSU');

      V_TXSU:=fn_xml2obj_SU(V_MSGXML);

      V_EXERCISERATIO := ROUND(TO_NUMBER(SUBSTR(nvl(trim(V_TXSU.EXERCISERATIO),0),1,LENGTH(nvl(trim(V_TXSU.EXERCISERATIO),0))-2)),4);

      --XU LY MESSAGE SU.

      SELECT count(1) Into v_Count FROM Ho_Sec_Info
      WHERE Floor_code ='10'
      And Stock_ID = Trim(V_TXSU.security_number_new);

      If V_TXSU.security_type ='S' Then
         v_Security_Type:=1; --COMMON_STOCK
      Elsif V_TXSU.security_type ='D' Then
         v_Security_Type:=2; --DEBENTURE
      Elsif V_TXSU.security_type IN('U','E') Then
         v_Security_Type:=3; --UNIT_TRUST
      Elsif V_TXSU.security_type ='W' Then
         v_Security_Type:=4; --Covered Warrant
      End if;

      --Kiem tra trong bang HO_SEC_INFO: Neu co roi thi Update, chua co thi Insert.
      If v_Count >0 Then
         UPDATE Ho_Sec_info SET
             Time  =  to_char(sysdate,'hh24miss'),
             halt_resume_flag =   V_TXSU.HALT_RESUME_FLAG,
             ceiling_price =      V_TXSU.CEILING_PRICE ,
             floor_price =        V_TXSU.FLOOR_PRICE ,
             basic_price =        V_TXSU.PRIOR_CLOSE_PRICE ,
             prior_close_price =  V_TXSU.PRIOR_CLOSE_PRICE ,
             lowest_price =       V_TXSU.LOWEST_PRICE ,
             highest_price =      V_TXSU.HIGHEST_PRICE ,
             match_price =        V_TXSU.LAST_SALE_PRICE ,
             open_price =         V_TXSU.OPEN_PRICE ,
             suspension =         V_TXSU.SUSPENSION,
             delist =             V_TXSU.DELIST,
             underlyingsymbol = V_TXSU.UNDERLYINGSYMBOL, /*Ma CK co so*/
             issuername       = V_TXSU.ISSUERNAME,   /*Ten TCPH CKSC*/
             coveredwarranttype  = V_TXSU.COVEREDWARRANTTYPE,   /*Loai chung quyen*/
             maturitydate        = TO_DATE(trim(V_TXSU.MATURITYDATE),'RRRRMMDD'),   /*Ngay het han chung quyen*/
             lasttradingdate     = TO_DATE(TRIM(V_TXSU.LASTTRADINGDATE),'RRRRMMDD'),   /*Ngay giao dich cuoi cung*/
             exerciseprice       = ROUND(nvl(trim(V_TXSU.EXERCISEPRICE),0)/10000,4),   /*Gia thuc hien*/
             exerciseratio       = V_EXERCISERATIO    /*Ty le thuc hien*/

             Where FLOOR_CODE ='10' and STOCK_ID =  V_TXSU.security_number_new;
      Else
        INSERT INTO Ho_sec_info
             (floor_code, date_no, trading_date, TIME, stock_id, code,
             stock_type, trading_unit,
             highest_price, lowest_price, ceiling_price,
             floor_price,
             prior_close_price, PARVALUE ,
             halt_resume_flag , DELIST, SUSPENSION,
             underlyingsymbol, issuername, coveredwarranttype, maturitydate,
             lasttradingdate, exerciseprice, exerciseratio)
             VALUES ('10', '10',
             trunc(sysdate), to_char(sysdate,'hh24miss'), trim(V_TXSU.SECURITY_NUMBER_NEW) , trim(V_TXSU.SECURITY_SYMBOL),
             v_Security_Type, V_TXSU.BOARD_LOT ,
             V_TXSU.HIGHEST_PRICE , V_TXSU.LOWEST_PRICE , V_TXSU.CEILING_PRICE,
             V_TXSU.FLOOR_PRICE,
             V_TXSU.PRIOR_CLOSE_PRICE, V_TXSU.PAR_VALUE ,
             V_TXSU.HALT_RESUME_FLAG, V_TXSU.DELIST, V_TXSU.SUSPENSION,
             V_TXSU.UNDERLYINGSYMBOL, V_TXSU.ISSUERNAME, V_TXSU.COVEREDWARRANTTYPE, TO_DATE(trim(V_TXSU.MATURITYDATE),'RRRRMMDD'),
             TO_DATE(TRIM(V_TXSU.LASTTRADINGDATE),'RRRRMMDD'), ROUND(nvl(trim(V_TXSU.EXERCISEPRICE),0)/10000,4), V_EXERCISERATIO
             );
      End if;

     --Cap nhat thong tin HALT vao BO.
     If V_TXSU.HALT_RESUME_FLAG in ('H','A')
       or V_TXSU.suspension ='S' or V_TXSU.delist ='D' Then
         v_Halt:='Y';
     Else
         v_Halt:='N';
     End if;

     UPDATE SBSECURITIES SET
        HALT =  v_Halt,
        underlyingsymbol = V_TXSU.UNDERLYINGSYMBOL, /*Ma CK co so*/
        issuername       = V_TXSU.ISSUERNAME,   /*Ten TCPH CKSC*/
        coveredwarranttype  = V_TXSU.COVEREDWARRANTTYPE,   /*Loai chung quyen*/
        maturitydate        = TO_DATE(trim(V_TXSU.MATURITYDATE),'RRRRMMDD'),   /*Ngay het han chung quyen*/
        lasttradingdate     = TO_DATE(TRIM(V_TXSU.LASTTRADINGDATE),'RRRRMMDD'),   /*Ngay giao dich cuoi cung*/
        exerciseprice      = ROUND(nvl(trim(V_TXSU.EXERCISEPRICE),0)/10000,4),   /*Gia thuc hien*/
        exerciseratio       = REPLACE(nvl(trim(V_TXSU.EXERCISERATIO),''), ':', '/')   /*Ty le thuc hien*/
     /* CWTERM              = 6,
        settlementprice     = 1,
        settlementtype      = 'CWMS',
        underlyingtype      = 'S',
        nvalue              = 1*/

     WHERE SYMBOL=TRIM(V_TXSU.security_symbol);

     -- begin 1.5.1.3 | 1808

    BEGIN
        SELECT tradeplace,codeid  INTO l_tradeplace_old, l_codeid_old FROM sbsecurities WHERE symbol = TRIM(V_TXSU.security_symbol);
    EXCEPTION
        WHEN OTHERS THEN
        l_tradeplace_old:='';
        l_codeid_old:='';
    END ;

     BEGIN
      cspks_odproc.Pr_Update_SecInfo(TRIM(V_TXSU.security_symbol),nvl(V_TXSU.CEILING_PRICE*10,0),nvl(V_TXSU.FLOOR_PRICE*10,0),nvl(V_TXSU.PRIOR_CLOSE_PRICE*10,0),'001',V_TXSU.security_type,v_strErrCode);

      Exception when others then
           Null;
      End;
     -- end 1.5.1.3 | 1808

     COMMIT;

     IF  v_Security_Type=4 THEN
         UPDATE SECURITIES_INFO SET LISTINGQTTY=V_TXSU.LISTEDSHARE
         WHERE SYMBOL=TRIM(V_TXSU.security_symbol);
     END IF;

      Begin
         pr_updatepricefromgw(TRIM(V_TXSU.security_symbol), nvl(V_TXSU.LAST_SALE_PRICE *10,0),nvl(V_TXSU.FLOOR_PRICE *10,0) ,nvl(V_TXSU.CEILING_PRICE *10,0),'CN',v_strErrCode,v_strErrM);
      Exception when others THEN
        v_CheckProcess := FALSE;
           Null;
      End;
      COMMIT;

      --Cap nhat thong tin ticksize
      select codeid into l_CODEID from securities_info where SYMBOL =TRIM(V_TXSU.security_symbol);
      DELETE FROM securities_ticksize WHERE codeid=l_CODEID;
      If V_TXSU.security_type in ('U','S') THEN --Co phieu, chung chi quy dong
                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, TRIM(V_TXSU.security_symbol), 10, 0, 9999, 'Y');

                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, TRIM(V_TXSU.security_symbol), 50, 10000, 49999, 'Y');

                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, TRIM(V_TXSU.security_symbol), 100, 50000, 100000000, 'Y');
      Elsif V_TXSU.security_type ='D' Then
                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, TRIM(V_TXSU.security_symbol), 10, 0, 100000000, 'Y');
      Elsif V_TXSU.security_type in ('E') Then
                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, TRIM(V_TXSU.security_symbol), 10, 0, 100000000, 'Y');
      Elsif V_TXSU.security_type in ('W') THEN
                  INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, l_CODEID, TRIM(V_TXSU.security_symbol), 10, 0, 100000000, 'Y');
      End if;
      --End cap nhat thong tin ticksize

      -- Cap nhat tradelot
      --Lay thong tin lo default
      BEGIN
        SELECT to_number(varvalue) INTO v_tradelot_hsx FROM sysvar WHERE varname = 'HSX_DEFAULT_TRADELOT';
      EXCEPTION WHEN OTHERS THEN
        v_tradelot_hsx := 100;
      END;
      -- begin 1.5.1.3 | 1808
      update securities_info set tradelot = v_tradelot_hsx where symbol = V_TXSU.security_symbol;
      COMMIT;

    IF l_tradeplace_old <> '001' THEN
        --dong bo len FO
        BEGIN
            pr_t_fo_instruments;
        END;

        --Insert vao t_fo_event de GEN Msg sang FO
        INSERT INTO t_fo_event (AUTOID, TXNUM, TXDATE, ACCTNO, TLTXCD,LOGTIME,PROCESSTIME,PROCESS,ERRCODE,ERRMSG,NVALUE,CVALUE)
        SELECT seq_fo_event.NEXTVAL, 'AUTO-00000', getcurrdate, TRIM(V_TXSU.security_symbol),'2285',systimestamp,systimestamp,'N','0',NULL, NULL, NULL
        FROM DUAL WHERE EXISTS (SELECT TLTXCD FROM FOTXMAP WHERE TLTXCD = '2285');
    END IF;
    -- end 1.5.1.3 | 1808

  plog.setendsection (pkgctx, 'PRC_PROCESSSU');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESSSU');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSSU;



 --PROCESS MSG SS
 Procedure PRC_PROCESSSS(V_MSGXML VARCHAR2) is
    V_TXSS   tx.msg_SS;
    V_ORGORDERID VARCHAR2(20);
    v_Security_Type Varchar2(10);
    v_Halt  Varchar2(10);
    V_UpdatePrice  Varchar2(10);
    v_Symbol  Varchar2(10);
    v_strCodeID Varchar2(10);
     v_strErrCode Varchar2(20);
    v_strErrM Varchar2(200);
    V_EXERCISERATIO NUMBER;
    l_tradeplace_old Varchar2(20);  --1.5.1.3 | 1808
    l_codeid_old    Varchar2(20);   --1.5.1.3 | 1808

  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESSSS');

      V_TXSS:=fn_xml2obj_SS(V_MSGXML);

      If V_TXSS.security_type ='S' Then
         v_Security_Type:=1; --COMMON_STOCK
      Elsif V_TXSS.security_type ='D' Then
         v_Security_Type:=2; --DEBENTURE
      Elsif V_TXSS.security_type IN ('U','E') Then
         v_Security_Type:=3; --UNIT_TRUST
        Elsif V_TXSS.security_type ='W' Then
         v_Security_Type:=4; --Covered Warrant
      End if;

      V_EXERCISERATIO := ROUND(TO_NUMBER(SUBSTR(trim(V_TXSS.EXERCISERATIO),1,LENGTH(trim(V_TXSS.EXERCISERATIO))-2)),4);

      --XU LY MESSAGE SS.

      UPDATE HO_sec_info
             SET  ceiling_price = V_TXSS.CEILING,
             floor_price =       V_TXSS.FLOOR_PRICE,
             halt_resume_flag =  V_TXSS.HALT_RESUME_FLAG,
             delist =            V_TXSS.DELIST,
             suspension =        V_TXSS.SUSPENSION,
             prior_close_price = V_TXSS.PRIOR_CLOSE_PRICE,
             underlyingsymbol = V_TXSS.UNDERLYINGSYMBOL, /*Ma CK co so*/
             issuername       = V_TXSS.ISSUERNAME,   /*Ten TCPH CKSC*/
             coveredwarranttype  = V_TXSS.COVEREDWARRANTTYPE,   /*Loai chung quyen*/
             maturitydate        = TO_DATE(trim(V_TXSS.MATURITYDATE),'RRRRMMDD'),   /*Ngay het han chung quyen*/
             lasttradingdate     = TO_DATE(TRIM(V_TXSS.LASTTRADINGDATE),'RRRRMMDD'),   /*Ngay giao dich cuoi cung*/
             exerciseprice       = ROUND(nvl(trim(V_TXSS.EXERCISEPRICE),0)/10000,4),   /*Gia thuc hien*/
             exerciseratio       = V_EXERCISERATIO    /*Ty le thuc hien*/
            Where FLOOR_CODE ='10' and STOCK_ID =  V_TXSS.security_number;

     commit;
      --Cap nhat thong tin HALT vao BO.
     If nvl(V_TXSS.halt_resume_flag,'-') in ('H','A')
        or nvl(V_TXSS.suspension,'-') ='S'
        or nvl(V_TXSS.delist,'-') ='D' Then
         v_Halt:='Y';
     Else
         v_Halt:='N';
     End if;



     Begin
          v_strCodeID:='';
          select codeid into v_strCodeID from securities_info
          where SYMBOL In (SELECT CODE From HO_SEC_INFO
                                  Where STOCK_ID = TRIM(V_TXSS.security_number));

      Exception when others THEN
        v_CheckProcess := FALSE;
           Null;
      End;

      UPDATE SBSECURITIES SET
        HALT = v_Halt,
        underlyingsymbol = V_TXSS.UNDERLYINGSYMBOL, /*Ma CK co so*/
        issuername       = V_TXSS.ISSUERNAME,   /*Ten TCPH CKSC*/
        coveredwarranttype  = V_TXSS.COVEREDWARRANTTYPE,   /*Loai chung quyen*/
        maturitydate        = TO_DATE(trim(V_TXSS.MATURITYDATE),'RRRRMMDD'),   /*Ngay het han chung quyen*/
        lasttradingdate     = TO_DATE(TRIM(V_TXSS.LASTTRADINGDATE),'RRRRMMDD'),   /*Ngay giao dich cuoi cung*/
        exerciseprice       =  ROUND(nvl(trim(V_TXSS.EXERCISEPRICE),0)/10000,4),   /*Gia thuc hien*/
        exerciseratio       = REPLACE(nvl(trim(V_TXSS.EXERCISERATIO),''), ':', '/')   /*Ty le thuc hien*/
      WHERE codeid=v_strCodeID;
      commit;



        --Cap nhat gia vao BO.
          Begin
            Select SYSVALUE Into V_UpdatePrice
            From ordersys where sysname ='UPDATEPRICE';
          Exception when others THEN
            v_CheckProcess := FALSE;
            V_UpdatePrice:='N';
          End;

           v_Symbol:='';
           SELECT CODE into v_Symbol From HO_SEC_INFO  Where STOCK_ID = TRIM(V_TXSS.security_number);


      -- begin 1.5.1.3 | 1808
      v_Symbol:='';
      SELECT CODE into v_Symbol From HO_SEC_INFO  Where STOCK_ID = TRIM(V_TXSS.security_number);

    BEGIN
        SELECT tradeplace,codeid  INTO l_tradeplace_old, l_codeid_old FROM sbsecurities WHERE symbol = v_Symbol;
    EXCEPTION
        WHEN OTHERS THEN
        l_tradeplace_old:='';
        l_codeid_old:='';
    END ;

      BEGIN
        cspks_odproc.Pr_Update_SecInfo(v_Symbol,nvl(V_TXSS.CEILING*10,0),nvl(V_TXSS.FLOOR_PRICE*10,0),nvl(V_TXSS.PRIOR_CLOSE_PRICE*10,0),'001',V_TXSS.security_type,v_strErrCode);

      Exception when others then
           Null;
      End;
      --Cap nhat thong tin ticksize
      DELETE FROM securities_ticksize WHERE codeid=v_strCodeID;
      If V_TXSS.security_type in ('U','S') THEN --Co phieu, chung chi quy dong
                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, v_strCodeID, v_Symbol, 10, 0, 9999, 'Y');

                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, v_strCodeID, v_Symbol, 50, 10000, 49999, 'Y');

                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, v_strCodeID, v_Symbol, 100, 50000, 100000000, 'Y');
      Elsif V_TXSS.security_type ='D' Then
                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, v_strCodeID, v_Symbol, 10, 0, 100000000, 'Y');
      Elsif V_TXSS.security_type in ('E') Then
                 INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, v_strCodeID, v_Symbol, 10, 0, 100000000, 'Y');
      Elsif V_TXSS.security_type in ('W') THEN
                  INSERT INTO SECURITIES_TICKSIZE (AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, STATUS)
                 VALUES (SEQ_SECURITIES_TICKSIZE.NEXTVAL, v_strCodeID, v_Symbol, 10, 0, 100000000, 'Y');
      End if;
      --End cap nhat thong tin ticksize

     -- end 1.5.1.3 | 1808

      If V_UpdatePrice ='Y' Then
           UPDATE SECURITIES_INFO
           SET      BASICPRICE=     nvl(V_TXSS.PRIOR_CLOSE_PRICE * 10,0),
                    CEILINGPRICE=   nvl(V_TXSS.CEILING *10,0),
                    FLOORPRICE =    nvl(V_TXSS.FLOOR_PRICE *10,0)

            where ( CODEID=v_strCodeID
                     Or CODEID in (SELECT CODEID FROM SBSECURITIES WHERE REFCODEID=v_strCodeID)
                   ) ;
      End if;

      COMMIT;

       Begin

           pr_updatepricefromgw(v_Symbol, nvl(V_TXSS.PRIOR_CLOSE_PRICE * 10,0), nvl(V_TXSS.FLOOR_PRICE *10,0) ,nvl(V_TXSS.CEILING *10,0),'DN',v_strErrCode,v_strErrM);

       Exception when others THEN
         v_CheckProcess := FALSE;
       Null;
       End;

      COMMIT;

    -- 1.5.1.3 | 1808
    IF l_tradeplace_old <> '001' THEN
        --dong bo len FO
        BEGIN
            pr_t_fo_instruments;
        END;

        --Insert vao t_fo_event de GEN Msg sang FO
        INSERT INTO t_fo_event (AUTOID, TXNUM, TXDATE, ACCTNO, TLTXCD,LOGTIME,PROCESSTIME,PROCESS,ERRCODE,ERRMSG,NVALUE,CVALUE)
        SELECT seq_fo_event.NEXTVAL, 'AUTO-00000', getcurrdate, v_Symbol,'2285',systimestamp,systimestamp,'N','0',NULL, NULL, NULL
        FROM DUAL WHERE EXISTS (SELECT TLTXCD FROM FOTXMAP WHERE TLTXCD = '2285');
    END IF;
    -- end 1.5.1.3 | 1808
    plog.setendsection (pkgctx, 'PRC_PROCESSSS');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESSSS');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSSS;



  --PROCESS MSG SC
 Procedure PRC_PROCESSSC(V_MSGXML VARCHAR2) is
    V_TXSC   tx.msg_SC;
    V_ORGORDERID VARCHAR2(20);
    v_Controlcode VARCHAR2(20);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESSSC');

      V_TXSC:=fn_xml2obj_SC(V_MSGXML);

      --XU LY MESSAGE SC.

   BEGIN
        SELECT SYSVALUE INTO V_CONTROLCODE FROM  ORDERSYS   WHERE SYSNAME='CONTROLCODE';
   EXCEPTION WHEN OTHERS THEN
     v_CheckProcess := FALSE;
        V_CONTROLCODE:='';
   END;

   IF V_CONTROLCODE ='O' AND V_TXSC.SYSTEM_CONTROL_CODE ='F' THEN
       NULL;
   ELSE
        UPDATE ORDERSYS SET SYSVALUE=V_TXSC.SYSTEM_CONTROL_CODE  WHERE SYSNAME='CONTROLCODE';
        UPDATE ORDERSYS SET SYSVALUE= LPAD(V_TXSC.TIMESTAMP,6,'0') WHERE SYSNAME='TIMESTAMP';

        If V_TXSC.SYSTEM_CONTROL_CODE ='O' then
         UPDATE ORDERSYS SET SYSVALUE= to_char(sysdate + 10/3600/24,'hh24miss') WHERE SYSNAME='TIMESTAMPO';
        end if ;

   END IF;

   plog.setendsection (pkgctx, 'PRC_PROCESSSC');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESSSC');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSSC;

--PROCESS MSG TS
Procedure PRC_PROCESSTS(V_MSGXML VARCHAR2,V_MSG_DATE VARCHAR2) is
    V_TXTS   tx.msg_TS;
    V_ORGORDERID VARCHAR2(20);
    V_DELTA_TIME number;
    l_timemsg       VARCHAR2(10);
    l_timeordersys  VARCHAR2(10);
    l_delta_time      INTEGER;
BEGIN
    plog.setbeginsection (pkgctx, 'PRC_PROCESSTS');

    V_TXTS:=fn_xml2obj_TS(V_MSGXML);

    --XU LY MESSAGE TS.

    UPDATE ORDERSYS
    SET SYSVALUE= Lpad(V_TXTS.timestamp,6,'0')
    WHERE SYSNAME='TIMESTAMP';
   --phuongntn tinh thoi gian chenh lech HO-Flex, cap nhat odersys
         l_timemsg:=NVL(V_MSG_DATE,TO_CHAR(SYSDATE,'HH24MISS'));
         l_timeordersys:= Lpad(V_TXTS.timestamp,6,'0');
         l_delta_time:=TO_NUMBER(SUBSTR(l_timeordersys,1,2)) * 3600
                    + TO_NUMBER(SUBSTR(l_timeordersys,3,2)) * 60
                    + TO_NUMBER(SUBSTR(l_timeordersys,5,2))
                - (
                    TO_NUMBER(SUBSTR(l_timemsg,1,2)) * 3600
                        + TO_NUMBER(SUBSTR(l_timemsg,3,2)) * 60
                        + TO_NUMBER(SUBSTR(l_timemsg,5,2))
                    );
   UPDATE ORDERSYS SET SYSVALUE= tO_CHAR(l_delta_time) WHERE SYSNAME='DELTATIME';

    --phuongntn end
    plog.setendsection (pkgctx, 'PRC_PROCESSTS');

EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx,SQLERRM || '--' || dbms_utility.format_error_backtrace);
    plog.error(pkgctx,'PRC_PROCESSTS V_TXTS.timestamp= ' || V_TXTS.timestamp);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESSTS');
    rollback;
END PRC_PROCESSTS;


  --PROCESS MSG TC
 Procedure PRC_PROCESSTC(V_MSGXML VARCHAR2) is
    V_TXTC   tx.msg_TC;
    V_ORGORDERID VARCHAR2(20);
    v_Count Number(10);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESSTC');

      V_TXTC:=fn_xml2obj_TC(V_MSGXML);

      --XU LY MESSAGE TC.
   SELECT COUNT(1) Into v_Count FROM TRADERID WHERE TRADERID = '0' || TRIM(V_TXTC.TRADER_ID) and (FIRM='001' or FIRM='1');
   --Neu co thi Update, chua co thi Insert
   If v_Count >0 Then
    UPDATE TRADERID SET STATUS = TRIM(V_TXTC.TRADER_STATUS), TRADING_DATE = SYSDATE
    WHERE TRADERID = '0' || TRIM(V_TXTC.TRADER_ID) and (FIRM='001' or FIRM='1') ;
   Else
    INSERT INTO TRADERID(FIRM, TRADERID,STATUS,TRADING_DATE)
    VALUES(TRIM(V_TXTC.FIRM), TRIM(V_TXTC.TRADER_ID),TRIM(V_TXTC.TRADER_STATUS),SYSDATE);
   End if;



   plog.setendsection (pkgctx, 'PRC_PROCESSTC');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESSTC');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSTC;


  --PROCESS MSG BS
 Procedure PRC_PROCESSBS(V_MSGXML VARCHAR2) is
    V_TXBS   tx.msg_BS;
    V_ORGORDERID VARCHAR2(20);
    v_Count Number(10);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESSBS');

      V_TXBS:=fn_xml2obj_BS(V_MSGXML);

      --XU LY MESSAGE BS.
   UPDATE TRADERID SET AUTOMATCH_HALT = TRIM(V_TXBS.AUTOMATCH_HALT_FLAG)
                     , PUTTHROUGH_HALT = TRIM(V_TXBS.PUT_THROUGH_HALT_FLAG)
                     , TRADING_DATE = SYSDATE
   WHERE  TRIM(V_TXBS.FIRM)='1' and (FIRM='001' or FIRM='1') ;

   plog.setendsection (pkgctx, 'PRC_PROCESSBS');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESSBS');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSBS;


  --PROCESS MSG TR
 Procedure PRC_PROCESSTR(V_MSGXML VARCHAR2) is
    V_TXTR   tx.msg_TR;
    V_ORGORDERID VARCHAR2(20);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESSTR');

      V_TXTR:=fn_xml2obj_TR(V_MSGXML);

      --XU LY MESSAGE TR.
      UPDATE HO_SEC_INFO
      SET TRADING_DATE=trunc(SYSDATE), CURRENT_ROOM=V_TXTR.current_room,
          TOTAL_ROOM =V_TXTR.total_room
      WHERE FLOOR_CODE ='10' And STOCK_ID= V_TXTR.security_number;


      UPDATE SECURITIES_INFO
       SET    current_room=V_TXTR.current_room
       WHERE TRIM(SYMBOL) In (SELECT TRIM(CODE) From HO_SEC_INFO
                              Where TRIM(STOCK_ID) = TRIM(V_TXTR.security_number));

      plog.setendsection (pkgctx, 'PRC_PROCESSSC');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESSSC');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSTR;



 --PROCESS MSG GA
 Procedure PRC_PROCESSGA(V_MSGXML VARCHAR2) is
    V_TXGA   tx.msg_GA;
    V_ORGORDERID VARCHAR2(20);
  BEGIN
      plog.setbeginsection (pkgctx, 'PRC_PROCESSGA');

      V_TXGA:=fn_xml2obj_GA(V_MSGXML);

      --XU LY MESSAGE GA.
      INSERT INTO ga
            (trading_date, msg_length, msg_text
            )
     VALUES (sysdate, V_TXGA.admin_message_length, V_TXGA.admin_message_text
            );

      plog.setendsection (pkgctx, 'PRC_PROCESSGA');

  EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM);
    v_CheckProcess := FALSE;
    plog.setendsection (pkgctx, 'PRC_PROCESSGA');
    RAISE errnums.E_SYSTEM_ERROR;
  END PRC_PROCESSGA;

--Huy lenh thuong + giai toa lenh ATO
PROCEDURE          CONFIRM_CANCEL_NORMAL_ORDER (
   pv_orderid   IN   VARCHAR2,
   pv_qtty      IN   NUMBER
)
IS
   v_edstatus         VARCHAR2 (30);
   v_strCodeid        VARCHAR2 (30);
   v_tltxcd           VARCHAR2 (30);
   v_txnum            VARCHAR2 (30);
   v_txdate           VARCHAR2 (30);
   v_tlid             VARCHAR2 (30);
   v_brid             VARCHAR2 (30);
   v_ipaddress        VARCHAR2 (30);
   v_wsname           VARCHAR2 (30);
   v_symbol           VARCHAR2 (30);
   v_afaccount        VARCHAR2 (30);
   v_seacctno         VARCHAR2 (30);
   v_price            NUMBER (10,2);
   v_quantity         NUMBER (10,2);
   v_bratio           NUMBER (10,2);
   v_oldbratio        NUMBER (10,2);
   v_cancelqtty       NUMBER (10,2);
   v_amendmentqtty    NUMBER (10,2);
   v_amendmentprice   NUMBER (10,2);
   v_matchedqtty      NUMBER (10,2);
   v_advancedamount   NUMBER (10,2);
   v_execqtty         NUMBER (10,2);
   v_trExectype       VARCHAR2 (30);
   v_reforderid       VARCHAR2 (30);
   v_tradeunit        NUMBER (10,2);
   v_desc             VARCHAR2 (300);
   v_bors             VARCHAR2 (30);
   v_txtime           VARCHAR2 (30);
   v_Count_lenhhuy    Number(2);
   v_OrderQtty_Cur    Number(10);
   v_RemainQtty_Cur   Number(10);
   v_ExecQtty_Cur     Number(10);
   v_CancelQtty_Cur   Number(10);
   v_Orstatus_Cur     VARCHAR2(10);
   v_err              VARCHAR2(300);
   Cursor c_Odmast(v_OrgOrderID Varchar2) Is
   SELECT FOACCTNO,REMAINQTTY,EXECQTTY,EXECAMT,CANCELQTTY,ADJUSTQTTY
   FROM ODMAST WHERE TIMETYPE ='G' AND ORDERID=v_OrgOrderID;
   vc_Odmast c_Odmast%Rowtype;
    v_Count_lenhsua    Number(2);
    v_OrderID          VARCHAR2 (30);
    v_replaceqtty      Number(10,2);
     v_DFACCTNO         varchar(20); --TheNN added
     v_ISDISPOSAL       varchar(20); --GianhVG added
BEGIN
   --0 lay cac tham so
   v_brid := '0000';
   v_tlid := '0000';
   v_ipaddress := 'HOST';
   v_wsname := 'HOST';
   v_cancelqtty := pv_qtty;
   --Kiem tra thoa man dieu kien huy
   BEGIN
    SELECT ORDERQTTY,REMAINQTTY,EXECQTTY,CANCELQTTY,ORSTATUS,Exectype
    INTO V_ORDERQTTY_CUR,V_REMAINQTTY_CUR,V_EXECQTTY_CUR,V_CANCELQTTY_CUR,V_ORSTATUS_CUR,v_trExectype
    FROM ODMAST WHERE ORDERID =PV_ORDERID;
   EXCEPTION WHEN OTHERS THEN
     v_CheckProcess := FALSE;
     RETURN;
   END;
   IF V_REMAINQTTY_CUR - V_CANCELQTTY < 0 OR V_EXECQTTY_CUR >= V_ORDERQTTY_CUR
                 OR V_CANCELQTTY = 0
   THEN
    RETURN;
   END IF;

   --Lenh huy thong thuong: Co lenh huy 1C
   SELECT count(*) INTO v_Count_lenhhuy FROM odmast
   WHERE reforderid =pv_orderid AND exectype IN ('CB','CS') and orstatus <> '6';
   SELECT count(*) INTO v_Count_lenhsua FROM odmast WHERE reforderid =pv_orderid
   AND exectype IN ('AB','AS') and orstatus <> '6';
   IF v_Count_lenhhuy >0 OR  v_Count_lenhsua >0 Then
        SELECT (CASE
                      WHEN exectype LIKE '%B'
                         THEN '8890'
                      ELSE '8891'
                   END), sb.symbol,
                  od.afacctno, od.seacctno, od.quoteprice, od.orderqtty, od.bratio,
                  0, od.quoteprice, 0, od.orderqtty - pv_qtty,
                  od.reforderid, sb.tradeunit, od.edstatus,od.codeid
             INTO v_tltxcd, v_symbol,
                  v_afaccount, v_seacctno, v_price, v_quantity, v_bratio,
                  v_amendmentqtty, v_amendmentprice, v_matchedqtty, v_execqtty,
                  v_reforderid, v_tradeunit, v_edstatus,v_strCodeid
             FROM odmast od, securities_info sb
            WHERE od.codeid = sb.codeid AND reforderid = pv_orderid
            AND OD.ORSTATUS<>'6' ; --DUCNV0704
   ELSE
    --Giai toa ATO
            SELECT (CASE
                      WHEN EXECTYPE LIKE '%B'
                         THEN '8808'
                      ELSE '8807'
                   END), sb.symbol,
                  od.afacctno, od.seacctno, od.quoteprice, od.orderqtty, od.bratio,
                  0, od.quoteprice, 0, od.orderqtty - pv_qtty,
                  od.reforderid, sb.tradeunit, od.edstatus
             INTO v_tltxcd, v_symbol,
                  v_afaccount, v_seacctno, v_price, v_quantity, v_bratio,
                  v_amendmentqtty, v_amendmentprice, v_matchedqtty, v_execqtty,
                  v_reforderid, v_tradeunit, v_edstatus
             FROM odmast od, securities_info sb
            WHERE od.codeid = sb.codeid AND orderid = pv_orderid
             AND OD.ORSTATUS<>'6'; --DUCNV0704
    END IF;


   v_advancedamount := 0;


    SELECT bratio, DFACCTNO, ISDISPOSAL
     INTO v_oldbratio, v_DFACCTNO,v_ISDISPOSAL
     FROM odmast
    WHERE orderid = pv_orderid;

      --NEU CHUA BI HUY THI KHI NHAN DUOC MESSAGE TRA VE SE THUC HIEN HUY LENH
      SELECT varvalue
        INTO v_txdate
        FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

      SELECT    '8080'
             || SUBSTR ('000000' || seq_batchtxnum.NEXTVAL,
                        LENGTH ('000000' || seq_batchtxnum.NEXTVAL) - 5,
                        6
                       )
        INTO v_txnum
        FROM DUAL;

      SELECT TO_CHAR (SYSDATE, 'HH24:MI:SS')
        INTO v_txtime
        FROM DUAL;

      --1 them vao trong tllog
      INSERT INTO tllog
                  (autoid, txnum,
                   txdate, txtime, brid,
                   tlid, offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2,
                   tlid2, ccyusage, txstatus, msgacct, msgamt, chktime,
                   offtime, off_line, deltd, brdate,
                   busdate, msgsts, ovrsts, ipaddress,
                   wsname, batchname, txdesc
                  )
           VALUES (seq_tllog.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), v_txtime, v_brid,
                   v_tlid, '', 'N', '', '', v_tltxcd, 'Y', '',
                   '', '', '1', pv_orderid, v_quantity, '',
                   '', 'N', 'N', TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '', '', v_ipaddress,
                   v_wsname, 'DAY', v_desc
                  );
      --them vao tllogfld
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'07',0,v_symbol,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'03',0,v_afaccount,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'04',0,pv_orderid,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'06',0,v_seacctno,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'08',0,pv_orderid,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'14',v_cancelqtty,NULL,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'11',v_price,NULL,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'12',v_quantity,NULL,NULL);

      if  (v_tltxcd = '8890' and v_Count_lenhhuy >0 ) OR v_tltxcd = '8808' then
      --TungNT added , giai toa khi huy lenh
      BEGIN
        cspks_odproc.pr_RM_UnholdCancelOD(pv_orderid, v_cancelqtty, v_err);
      EXCEPTION WHEN OTHERS THEN
        v_CheckProcess := FALSE;
        plog.error(pkgctx,'Error when gen unhold for cancel order : ' || pv_orderid || ' qtty : ' || v_cancelqtty);
        plog.error(pkgctx, SQLERRM);
      END;
      eND IF;
      --End

      --2 THEM VAO TRONG TLLOGFLD
      If v_Count_lenhhuy >0 or v_Count_lenhsua>0 then
          v_edstatus := 'W';
          UPDATE odmast
             SET edstatus = v_edstatus
          WHERE orderid = pv_orderid;

          UPDATE OOD SET OODSTATUS = 'S'
          WHERE   ORGORDERID IN (SELECT ORDERID FROM ODMAST  WHERE REFORDERID = pv_orderid and orstatus <> '6')
          and OODSTATUS <> 'S';


      Else
        --OOD: Cap nhat E
        --ODMAST:
        --Update OOD set OODSTATUS ='E' where ORGORDERID =pv_orderid;
        --Update ODMAST set ORSTATUS ='5' where Orderqtty =Remainqtty And ORDERID =pv_orderid;
         Update OOD set OODSTATUS ='S' where ORGORDERID =pv_orderid And OODSTATUS ='B';
         Update ODMAST set ORSTATUS ='5' where Orderqtty =Remainqtty And ORDERID =pv_orderid;

      End if;
      --3 CAP NHAT TRAN VA MAST
      IF v_tltxcd = '8890' OR v_tltxcd = '8808'
      THEN
         --BUY
         UPDATE odmast
            SET cancelqtty = cancelqtty + v_cancelqtty,
                remainqtty = remainqtty - v_cancelqtty
          WHERE orderid = pv_orderid;

          if (v_tltxcd = '8890' and v_Count_lenhhuy >0 ) OR v_tltxcd = '8808' then
                -- quyet.kieu : Them cho LINHLNB 21/02/2012
                -- Begin Danh sau tai san LINHLNB
                INSERT INTO odchanging_trigger_log (AFACCTNO,CODEID,AMT,TXNUM,TXDATE,ERRCODE,LAST_CHANGE,ORDERID,ACTIONFLAG,QTTY)
                VALUES( v_afaccount,v_strCodeid ,v_cancelqtty * v_price ,v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),NULL,systimestamp,pv_orderid,'C',v_cancelqtty);
                -- End Danh dau tai san LINHLNB
          end if ;


         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      pv_orderid, '0014', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );

         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      pv_orderid, '0011', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );


      ELSE                                                   --v_tltxcd='8891' , '8807'
         --SELL
         UPDATE odmast
            SET cancelqtty = cancelqtty + v_cancelqtty,
                remainqtty = remainqtty - v_cancelqtty
          WHERE orderid = pv_orderid;


         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      pv_orderid, '0014', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );

         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      pv_orderid, '0011', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );


      END IF;
   --Cap nhat cho GTC
   OPEN C_ODMAST(pv_orderid);
   FETCH C_ODMAST INTO VC_ODMAST;
    IF C_ODMAST%FOUND THEN
         UPDATE FOMAST SET   REMAINQTTY= REMAINQTTY - v_cancelqtty
                            ,cancelqtty= cancelqtty + v_cancelqtty
          --WHERE ORGACCTNO= pv_orderid;
         WHERE ACCTNO= VC_ODMAST.FOACCTNO;

    END IF;
   CLOSE C_ODMAST;


   COMMIT;
   --- DUCNV LENH SUA HOSE, SAU KHI HUY PHAIR SINH LENH MOI
  If v_Count_lenhsua >0 then
       v_replaceqtty:=pv_qtty;
                --  UPDATE odmast  SET edstatus = 'C'                  WHERE orderid = pv_orderid;

                 UPDATE odmast set --deltd = 'Y',
                                  edstatus = 'C'
                 Where exectype in ('AB','AS') AND
                        orderid IN (SELECT ORDERID FROM ODMAST  WHERE REFORDERID = pv_orderid and orstatus <> '6');
               --  UPDATE OOD SET deltd = 'Y'
                -- Where ORGORDERID IN (SELECT ORDERID FROM ODMAST  WHERE REFORDERID = pv_orderid);

                 Select '8000'||to_char(to_date(v_txdate,'dd/mm/yyyy'),'ddmmyy')||lpad(SEQ_ODMAST.NEXTVAL,6,'0')
                 into v_OrderID from dual;

                 For vc in (Select od.AORN nork, od.norp matchtype,od.custodycd,od.codeid,od.symbol,od.bors,
                                   om.consultant,om.VOUCHER, om.pricetype,om.EXECTYPE   ,om.CLEARDAY , om.CLEARCD,om.BRATIO ,om.TIMETYPE,
                                   om.CUSTID , om.ACTYPE ,om.afacctno,om.SEACCTNO,
                                   oa.quoteprice  amendmentprice, oa.tlid,oa.VIA
                            From odmast om, ood od , odmast oa
                            where om.orderid=od.orgorderid
                                  and oa.reforderid= om.orderid
                                  and om.orderid = pv_orderid )
                 Loop

                         INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO
                         ,SEACCTNO,CIACCTNO,
                         TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                         EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                         QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,SECUREDAMT,
                         EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,REFORDERID,CORRECTIONNUMBER,TLID,DFACCTNO,ISDISPOSAL)
                          VALUES ( v_ORDERID , vc.CUSTID , vc.ACTYPE , vc.CODEID , vc.afacctno
                          ,vc.SEACCTNO ,vc.afacctno
                          , v_TXNUM ,TO_DATE (v_txdate, 'DD/MM/YYYY'), v_TXTIME
                          ,TO_DATE (v_txdate, 'DD/MM/YYYY'),vc.BRATIO ,vc.TIMETYPE
                          ,vc.EXECTYPE ,vc.NORK ,vc.MATCHTYPE ,vc.VIA ,vc.CLEARDAY , vc.CLEARCD ,'8','8',vc.PRICETYPE
                          ,vc.amendmentprice ,0,vc.amendmentprice ,v_ReplaceQTTY,v_ReplaceQTTY ,vc.amendmentprice ,v_ReplaceQTTY,0
                          ,0,0,0,0,0,'001', vc.VOUCHER , vc.CONSULTANT , pv_orderid , 1, vc.tlid, v_DFACCTNO,v_ISDISPOSAL);

               --Ghi nhan vao so lenh day di
                           INSERT INTO OOD (ORGORDERID,CODEID,SYMBOL,CUSTODYCD,
                                BORS,NORP,AORN,PRICE,QTTY,SECUREDRATIO,OODSTATUS,
                                TXDATE,TXTIME,TXNUM,DELTD,BRID,REFORDERID)
                                VALUES ( v_ORDERID , vc.CODEID , vc.Symbol ,vc.CUSTODYCD,
                                vc.BORS ,vc.MATCHTYPE ,vc.NORK ,vc.amendmentprice ,v_ReplaceQTTY ,vc.bratio ,'N' ,
                                TO_DATE (v_txdate, 'DD/MM/YYYY'),  v_TXTIME , v_TXNUM ,'N',v_BRID , pv_orderid );
                  End loop;


  End if;
EXCEPTION
   WHEN others
   THEN
   v_CheckProcess := FALSE;
   ROLLBACK;
   v_err:=substr(sqlerrm,1,200);
      INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' confirm_cancel_normal_order ', v_err
                  );

      COMMIT;

END;

PROCEDURE          MATCHING_NORMAL_ORDER (
   firm               IN   VARCHAR2,
   order_number       IN   NUMBER,
   order_entry_date   IN   VARCHAR2,
   side_alph          IN   VARCHAR2,
   filler             IN   VARCHAR2,
   deal_volume        IN   NUMBER,
   deal_price         IN   NUMBER,
   confirm_number     IN   Varchar2
)
IS
   v_tltxcd             VARCHAR2 (30);
   v_txnum              VARCHAR2 (30);
   v_txdate             VARCHAR2 (30);
   v_tlid               VARCHAR2 (30);
   v_brid               VARCHAR2 (30);
   v_ipaddress          VARCHAR2 (30);
   v_wsname             VARCHAR2 (30);
   v_txtime             VARCHAR2 (30);
   mv_strorgorderid     VARCHAR2 (30);
   mv_strcodeid         VARCHAR2 (30);
   mv_strsymbol         VARCHAR2 (30);
   mv_strcustodycd      VARCHAR2 (30);
   mv_strbors           VARCHAR2 (30);
   mv_strnorp           VARCHAR2 (30);
   mv_straorn           VARCHAR2 (30);
   mv_strafacctno       VARCHAR2 (30);
   mv_strciacctno       VARCHAR2 (30);
   mv_strseacctno       VARCHAR2 (30);
   mv_reforderid        VARCHAR2 (30);
   mv_refcustcd         VARCHAR2 (30);
   mv_strclearcd        VARCHAR2 (30);
   mv_strexprice        NUMBER (10);
   mv_strexqtty         NUMBER (10);
   mv_strprice          NUMBER (10);
   mv_strqtty           NUMBER (10);
   mv_strremainqtty     NUMBER (10);
   mv_strclearday       NUMBER (10);
   mv_strsecuredratio   NUMBER (10,2);
   mv_strconfirm_no     VARCHAR2 (30);
   mv_strmatch_date     VARCHAR2 (30);
   mv_desc              VARCHAR2 (30);
   v_strduetype         VARCHAR (2);
   v_matched            NUMBER (10,2);
   v_ex                 EXCEPTION;
   v_err                VARCHAR2 (100);
   v_temp               NUMBER(10);
   v_refconfirmno       VARCHAR2 (30);
   mv_mtrfday                NUMBER(10);
   --TungNT modified - for T2 late send money
   mv_strtradeplace      VARCHAR2(3);
   mv_dbltrfbuyext      number(20,0);
   mv_dbltrfbuyrate      number(20,4);
   mv_strtrfstatus      VARCHAR2(1);
   --End

   Cursor c_Odmast(v_OrgOrderID Varchar2) Is
   SELECT FOACCTNO,REMAINQTTY,EXECQTTY,EXECAMT,CANCELQTTY,ADJUSTQTTY
   FROM ODMAST WHERE TIMETYPE ='G' AND ORDERID=v_OrgOrderID;
   vc_Odmast c_Odmast%Rowtype;


BEGIN
   --0 lay cac tham so
   v_brid := '0000';
   v_tlid := '0000';
   v_ipaddress := 'HOST';
   v_wsname := 'HOST';
   v_tltxcd := '8804';
   --TungNT modified - for T2 late send money
   mv_strtradeplace:='001';
   mv_dbltrfbuyext:=0;
   mv_dbltrfbuyrate:=0;
   mv_strtrfstatus:='Y';
   --End

      INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' MATCHING_NORMAL_ORDER 0 : '|| To_char(order_number),to_char(systimestamp)
                  );



   SELECT    '8080'
          || SUBSTR ('000000' || seq_batchtxnum.NEXTVAL,
                     LENGTH ('000000' || seq_batchtxnum.NEXTVAL) - 5,
                     6
                    )
     INTO v_txnum
     FROM DUAL;

   SELECT TO_CHAR (SYSDATE, 'HH24:MI:SS')
     INTO v_txtime
     FROM DUAL;

   BEGIN
      SELECT varvalue
        INTO v_txdate
        FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
   EXCEPTION
      WHEN OTHERS
      THEN
        v_CheckProcess := FALSE;
         v_err := SUBSTR ('sysvar ' || SQLERRM, 1, 100);
         RAISE v_ex;
   END;

   BEGIN
      SELECT orgorderid
        INTO mv_strorgorderid
        FROM ordermap
       WHERE ctci_order = order_number;
   EXCEPTION
      WHEN OTHERS
      THEN
        v_CheckProcess := FALSE;
         v_err :=
            SUBSTR (   'select mv_strorgorderid order_number= '
                    || order_number
                    || SQLERRM,
                    1,
                    100
                   );
         RAISE v_ex;
   END;
  --Kiem tra doi da thuc hien khop voi confirm number hay chua, neu da khop exit

    BEGIN
      SELECT COUNT(*)
        INTO V_TEMP
        FROM IOD
       WHERE ORGORDERID = MV_STRORGORDERID
       AND   TRIM(CONFIRM_NO) = TRIM(CONFIRM_NUMBER)
       AND IOD.deltd <>'Y';

       IF V_TEMP > 0 THEN
         RETURN;
       END IF;
    EXCEPTION
      WHEN OTHERS
      THEN
        v_CheckProcess := FALSE;
         v_err :=
            SUBSTR (   'Kiem tra confirm_number   '
                    || confirm_number
                    || SQLERRM,
                    1,
                    100
                   );
         RAISE v_ex;
    END;

       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' MATCHING_NORMAL_ORDER 1 : '|| To_char(order_number),to_char(systimestamp)
                  );
--TungNT modified - for T2 late send money
   BEGIN
      SELECT od.remainqtty, sb.codeid, sb.symbol, ood.custodycd,
             ood.bors, ood.norp, ood.aorn, od.afacctno,
             od.ciacctno, od.seacctno, '', '',
             od.clearcd, ood.price, ood.qtty, deal_price * 1000,
             deal_volume, od.clearday, od.bratio,
             confirm_number, v_txdate, '', typ.mtrfday,
             ss.tradeplace,af.trfbuyext, af.trfbuyrate
        INTO mv_strremainqtty, mv_strcodeid, mv_strsymbol, mv_strcustodycd,
             mv_strbors, mv_strnorp, mv_straorn, mv_strafacctno,
             mv_strciacctno, mv_strseacctno, mv_reforderid, mv_refcustcd,
             mv_strclearcd, mv_strexprice, mv_strexqtty, mv_strprice,
             mv_strqtty, mv_strclearday, mv_strsecuredratio,
             mv_strconfirm_no, mv_strmatch_date, mv_desc,mv_mtrfday,
             mv_strtradeplace,mv_dbltrfbuyext, mv_dbltrfbuyrate
        FROM odmast od, ood, securities_info sb,odtype typ,afmast af,sbsecurities ss
       WHERE od.orderid = ood.orgorderid and od.actype = typ.actype
         AND od.codeid = sb.codeid and od.afacctno=af.acctno and od.codeid=ss.codeid
         AND orderid = mv_strorgorderid;
   EXCEPTION
      WHEN OTHERS
      THEN
        v_CheckProcess := FALSE;
         v_err :=
            SUBSTR (   'odmast ,securities_info mv_strorgorderid= '
                    || mv_strorgorderid
                    || SQLERRM,
                    1,
                    100
                   );
         RAISE v_ex;
   END;

   IF mv_dbltrfbuyext>0 THEN
        mv_strtrfstatus:='N';
   END IF;
--End

        INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' MATCHING_NORMAL_ORDER 2 : '|| To_char(order_number),to_char(systimestamp)
                  );

   --Day vao stctradebook, stctradeallocation de khong bi khop lai:
   v_refconfirmno :='VS'||mv_strbors||mv_strconfirm_no;

   /*
   INSERT INTO stctradebook
            (txdate, confirmnumber, refconfirmnumber, ordernumber, bors,
             volume, price
            )
     VALUES (to_date(v_txdate,'dd/mm/yyyy'), mv_strconfirm_no, v_refconfirmno, order_number, mv_strbors,
             mv_strqtty, mv_strprice
            );
  */

   INSERT INTO stctradeallocation
            (txdate, txnum, refconfirmnumber, orderid, bors, volume,
             price, deltd
            )
     VALUES (to_date(v_txdate,'dd/mm/yyyy'), v_txnum, v_refconfirmno, mv_strorgorderid, mv_strbors, mv_strqtty,
             mv_strprice, 'N'
            );


         INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' MATCHING_NORMAL_ORDER 3 : '|| To_char(order_number),to_char(systimestamp)
                  );

   mv_desc := 'Matching order';

   IF mv_strremainqtty >= mv_strqtty
   THEN
      --thuc hien khop voi ket qua tra ve

      --1 them vao trong tllog
      INSERT INTO tllog
                  (autoid, txnum,
                   txdate, txtime, brid,
                   tlid, offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2,
                   tlid2, ccyusage, txstatus, msgacct, msgamt, chktime,
                   offtime, off_line, deltd, brdate,
                   busdate, msgsts, ovrsts, ipaddress,
                   wsname, batchname, txdesc
                  )
           VALUES (seq_tllog.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), v_txtime, v_brid,
                   v_tlid, '', 'N', '', '', v_tltxcd, 'Y', '',
                   '', '', '1', mv_strorgorderid, mv_strqtty, '',
                   '', 'N', 'N', TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '', '', v_ipaddress,
                   v_wsname, 'DAY', mv_desc
                  );

      --tHEM VAO TRONG TLLOGFLD
            INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' MATCHING_NORMAL_ORDER 4 : '|| To_char(order_number),to_char(systimestamp)
                  );

      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue,
                   cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '03', 0,
                   mv_strorgorderid, NULL
                  );

      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue,
                   txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '80', 0, mv_strcodeid,
                   NULL
                  );

      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue,
                   txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '81', 0, mv_strsymbol,
                   NULL
                  );

      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue,
                   cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '82', 0,
                   mv_strcustodycd, NULL
                  );

      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue,
                   txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '04', 0, mv_strafacctno,
                   NULL
                  );

      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue,
                   txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '11', mv_strqtty, NULL,
                   NULL
                  );

      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue,
                   txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '10', mv_strprice, NULL,
                   NULL
                  );

      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '30', 0, mv_desc, NULL
                  );
      INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '05', 0, mv_strafacctno, NULL
                  );



      IF mv_strbors = 'B' THEN
          INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '86', mv_strprice*mv_strqtty, NULL, NULL
                  );

          INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '87', mv_strqtty, NULL, NULL
                  );
      ELSE
          INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '86', 0, NULL, NULL
                  );

          INSERT INTO tllogfld
                  (autoid, txnum,
                   txdate, fldcd, nvalue, cvalue, txdesc
                  )
           VALUES (seq_tllogfld.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '87', 0, NULL, NULL
                  );
      END IF;

          INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' MATCHING_NORMAL_ORDER 5 : '|| To_char(order_number),to_char(systimestamp)
                  );


      --2 THEM VAO TRONG orderdeal
      INSERT INTO orderdeal
                  (firm, order_number, orderid, order_entry_date,
                   side_alph, filler, volume, price,
                   confirm_number, MATCHED
                  )
           VALUES (firm, order_number, mv_strorgorderid, order_entry_date,
                   side_alph, filler, deal_volume, deal_price,
                   confirm_number, 'Y'
                  );

      --3 THEM VAO TRONG IOD

          INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' MATCHING_NORMAL_ORDER 6 : '|| To_char(order_number),to_char(systimestamp)
                  );

      INSERT INTO iod
                  (orgorderid, codeid, symbol,
                   custodycd, bors, norp,
                   txdate, txnum, aorn,
                   price, qtty, exorderid, refcustcd,
                   matchprice, matchqtty, confirm_no,txtime
                  )
           VALUES (mv_strorgorderid, mv_strcodeid, mv_strsymbol,
                   mv_strcustodycd, mv_strbors, mv_strnorp,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), v_txnum, mv_straorn,
                   mv_strexprice, mv_strexqtty, mv_reforderid, mv_refcustcd,
                   mv_strprice, mv_strqtty, mv_strconfirm_no,to_char(sysdate,'hh24:mi:ss')
                  );
                INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' MATCHING_NORMAL_ORDER 7 : '|| To_char(order_number),to_char(systimestamp)
                  );





      --4 CAP NHAT STSCHD
      SELECT COUNT (*)
        INTO v_matched
        FROM stschd
       WHERE orgorderid = mv_strorgorderid AND deltd <> 'Y';

      IF mv_strbors = 'B'
      THEN                                                          --Lenh mua
         --Tao lich thanh toan chung khoan
         v_strduetype := 'RS';

         IF v_matched > 0
         THEN
            UPDATE stschd
               SET qtty = qtty + mv_strqtty,
                   amt = amt + mv_strprice * mv_strqtty
             WHERE orgorderid = mv_strorgorderid AND duetype = v_strduetype;
         ELSE
            INSERT INTO stschd
                        (autoid, orgorderid, codeid,
                         duetype, afacctno, acctno,
                         reforderid, txnum,
                         txdate, clearday,
                         clearcd, amt, aamt,
                         qtty, aqtty, famt, status, deltd, costprice, cleardate
                        )
                 VALUES (seq_stschd.NEXTVAL, mv_strorgorderid, mv_strcodeid,
                         v_strduetype, mv_strafacctno, mv_strseacctno,
                         mv_reforderid, v_txnum,
                         TO_DATE (v_txdate, 'DD/MM/YYYY'), mv_strclearday,
                         mv_strclearcd, mv_strprice * mv_strqtty, 0,
                         mv_strqtty, 0, 0, 'N', 'N', 0, getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',mv_strclearday)
                        );
         END IF;

         --Tao lich thanh toan tien
         v_strduetype := 'SM';


             INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' MATCHING_NORMAL_ORDER 9 : '|| To_char(order_number),to_char(systimestamp)
                  );

         IF v_matched > 0
         THEN
            UPDATE stschd
               SET qtty = qtty + mv_strqtty,
                   amt = amt + mv_strprice * mv_strqtty
             WHERE orgorderid = mv_strorgorderid AND duetype = v_strduetype;
         ELSE
            INSERT INTO stschd
                        (autoid, orgorderid, codeid,
                         duetype, afacctno, acctno,
                         reforderid, txnum,
                         txdate, clearday,
                         clearcd, amt, aamt,
                         qtty, aqtty, famt, status, deltd, costprice, cleardate,trfbuydt,trfbuysts, trfbuyrate, trfbuyext
                        )
                 VALUES (seq_stschd.NEXTVAL, mv_strorgorderid, mv_strcodeid,
                         v_strduetype, mv_strafacctno, mv_strafacctno,
                         mv_reforderid, v_txnum,
                         TO_DATE (v_txdate, 'DD/MM/YYYY'), 0,
                         mv_strclearcd, mv_strprice * mv_strqtty, 0,
                         mv_strqtty, 0, 0, 'N', 'N', 0, getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',greatest(mv_mtrfday,mv_dbltrfbuyext)),
                         least(getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',mv_dbltrfbuyext),getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',mv_strclearday)),mv_strtrfstatus, mv_dbltrfbuyrate, mv_dbltrfbuyext
                        );
         END IF;

      ELSE                                                          --Lenh ban
         --Tao lich thanh toan chung khoan
         v_strduetype := 'SS';

         IF v_matched > 0
         THEN
            UPDATE stschd
               SET qtty = qtty + mv_strqtty,
                   amt = amt + mv_strprice * mv_strqtty
             WHERE orgorderid = mv_strorgorderid AND duetype = v_strduetype;
         ELSE
            INSERT INTO stschd
                        (autoid, orgorderid, codeid,
                         duetype, afacctno, acctno,
                         reforderid, txnum,
                         txdate, clearday,
                         clearcd, amt, aamt,
                         qtty, aqtty, famt, status, deltd, costprice, cleardate
                        )
                 VALUES (seq_stschd.NEXTVAL, mv_strorgorderid, mv_strcodeid,
                         v_strduetype, mv_strafacctno, mv_strseacctno,
                         mv_reforderid, v_txnum,
                         TO_DATE (v_txdate, 'DD/MM/YYYY'), 0,
                         mv_strclearcd, mv_strprice * mv_strqtty, 0,
                         mv_strqtty, 0, 0, 'N', 'N', 0, getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',0)
                        );
         END IF;

         --Tao lich thanh toan tien
         v_strduetype := 'RM';

         IF v_matched > 0
         THEN
            UPDATE stschd
               SET qtty = qtty + mv_strqtty,
                   amt = amt + mv_strprice * mv_strqtty
             WHERE orgorderid = mv_strorgorderid AND duetype = v_strduetype;
         ELSE
            INSERT INTO stschd
                        (autoid, orgorderid, codeid,
                         duetype, afacctno, acctno,
                         reforderid, txnum,
                         txdate, clearday,
                         clearcd, amt, aamt,
                         qtty, aqtty, famt, status, deltd, costprice, cleardate
                        )
                 VALUES (seq_stschd.NEXTVAL, mv_strorgorderid, mv_strcodeid,
                         v_strduetype, mv_strafacctno, mv_strafacctno,
                         mv_reforderid, v_txnum,
                         TO_DATE (v_txdate, 'DD/MM/YYYY'), mv_strclearday,
                         mv_strclearcd, mv_strprice * mv_strqtty, 0,
                         mv_strqtty, 0, 0, 'N', 'N', 0, getduedate(TO_DATE (v_txdate, 'DD/MM/YYYY'),mv_strclearcd,'000',mv_strclearday)
                        );
         END IF;
      END IF;

      --CAP NHAT TRAN VA MAST
            --BUY
      /*UPDATE odmast
         SET orstatus = '4'
       WHERE orderid = mv_strorgorderid;

      UPDATE odmast
         SET PORSTATUS = PORSTATUS||'4'
       WHERE orderid = mv_strorgorderid;

      UPDATE odmast
         SET execqtty = execqtty + mv_strqtty
       WHERE orderid = mv_strorgorderid;

      UPDATE odmast
         SET remainqtty = remainqtty - mv_strqtty
       WHERE orderid = mv_strorgorderid;

      UPDATE odmast
         SET execamt = execamt + mv_strqtty * mv_strprice
       WHERE orderid = mv_strorgorderid;

      UPDATE odmast
         SET matchamt = matchamt + mv_strqtty * mv_strprice
       WHERE orderid = mv_strorgorderid;*/
       -- ducnv rao lai, viet thanh 1 cau update

           INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' MATCHING_NORMAL_ORDER 11 : '|| To_char(order_number),to_char(systimestamp)
                  );

       UPDATE odmast
         SET orstatus = '4',
         PORSTATUS = PORSTATUS||'4',
         execqtty = execqtty + mv_strqtty,
         remainqtty = remainqtty - mv_strqtty,
         execamt = execamt + mv_strqtty * mv_strprice,
         matchamt = matchamt + mv_strqtty * mv_strprice
       WHERE orderid = mv_strorgorderid;

      For v_Session in (SELECT SYSVALUE  FROM ORDERSYS WHERE SYSNAME = 'CONTROLCODE')
      Loop
          UPDATE odmast
             SET HOSESESSION =v_Session.SYSVALUE
          WHERE orderid = mv_strorgorderid And NVL(HOSESESSION,'N') ='N';
      End Loop;

      --Neu khop het va co lenh huy cua lenh da khop thi cap nhat thanh refuse
      IF mv_strremainqtty = mv_strqtty THEN
          UPDATE odmast
             SET ORSTATUS = '0'
           WHERE REFORDERID = mv_strorgorderid;
        END IF;

      --Cap nhat tinh gia von
     /* IF mv_strbors = 'B' THEN
          UPDATE semast SET dcramt = dcramt + mv_strqtty*mv_strprice, dcrqtty = dcrqtty+mv_strqtty WHERE acctno = mv_strseacctno;
      END IF;*/


    INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' MATCHING_NORMAL_ORDER 12 : '|| To_char(order_number),to_char(systimestamp)
                  );

      INSERT INTO odtran
                  (txnum, txdate,
                   acctno, txcd, namt, camt, acctref, deltd,
                   REF, autoid
                  )
           VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   mv_strorgorderid, '0013', mv_strqtty, NULL, NULL, 'N',
                   NULL, seq_odtran.NEXTVAL
                  );

      INSERT INTO odtran
                  (txnum, txdate,
                   acctno, txcd, namt, camt, acctref, deltd,
                   REF, autoid
                  )
           VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   mv_strorgorderid, '0011', mv_strqtty, NULL, NULL, 'N',
                   NULL, seq_odtran.NEXTVAL
                  );

      INSERT INTO odtran
                  (txnum, txdate,
                   acctno, txcd, namt, camt,
                   acctref, deltd, REF, autoid
                  )
           VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   mv_strorgorderid, '0028', mv_strqtty * mv_strprice, NULL,
                   NULL, 'N', NULL, seq_odtran.NEXTVAL
                  );

      INSERT INTO odtran
                  (txnum, txdate,
                   acctno, txcd, namt, camt,
                   acctref, deltd, REF, autoid
                  )
           VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   mv_strorgorderid, '0034', mv_strqtty * mv_strprice, NULL,
                   NULL, 'N', NULL, seq_odtran.NEXTVAL
                  );

      /*IF mv_strbors = 'B' THEN
          INSERT INTO setran
                  (txnum, txdate,
                   acctno, txcd, namt, camt,
                   REF, deltd, autoid
                  )
           VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   mv_strseacctno, '0051', mv_strqtty * mv_strprice, NULL,
                   NULL, 'N', seq_setran.NEXTVAL
                  );

          INSERT INTO setran
                  (txnum, txdate,
                   acctno, txcd, namt, camt,
                   REF, deltd, autoid
                  )
           VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   mv_strseacctno, '0052', mv_strqtty, NULL,
                   NULL, 'N', seq_setran.NEXTVAL
                  );
      END IF;*/

   -- if instr('/NS/MS/SS/', :newval.exectype) > 0 then
        if mv_strbors = 'S' then
            -- quyet.kieu : Them cho LINHLNB 21/02/2012
            -- Begin Danh sau tai san LINHLNB
            INSERT INTO odchanging_trigger_log (AFACCTNO,CODEID,AMT,TXNUM,TXDATE,ERRCODE,LAST_CHANGE,ORDERID,ACTIONFLAG, QTTY)
            VALUES( mv_strafacctno,mv_strcodeid ,mv_strprice * mv_strqtty ,v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),NULL,systimestamp,mv_strorgorderid,'M',mv_strqtty);
            -- End Danh dau tai san LINHLNB
        end if;

            INSERT INTO log_err
              (id,date_log, POSITION, text
              )
       VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' MATCHING_NORMAL_ORDER 8 : '|| To_char(order_number),to_char(systimestamp)
              );

   ELSE
      --ket qua tra ve khong hop le
              --2 THEM VAO TRONG orderdeal
      INSERT INTO orderdeal
                  (firm, order_number, orderid, order_entry_date,
                   side_alph, filler, volume, price,
                   confirm_number, MATCHED
                  )
           VALUES (firm, order_number, mv_strorgorderid, order_entry_date,
                   side_alph, filler, deal_volume, deal_price,
                   confirm_number, 'N'
                  );
   END IF;
   --Cap nhat cho GTC

       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' MATCHING_NORMAL_ORDER 13 : '|| To_char(order_number),to_char(systimestamp)
                  );


   OPEN C_ODMAST(MV_STRORGORDERID);
   FETCH C_ODMAST INTO VC_ODMAST;
    IF C_ODMAST%FOUND THEN
          UPDATE FOMAST SET REMAINQTTY= REMAINQTTY - MV_STRQTTY
                            ,EXECQTTY= EXECQTTY + MV_STRQTTY
                            ,EXECAMT=  EXECAMT + MV_STRPRICE * MV_STRQTTY
          --WHERE ORGACCTNO= MV_STRORGORDERID;
          WHERE ACCTNO= VC_ODMAST.FOACCTNO;
    END IF;
   CLOSE C_ODMAST;

     INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,  ' MATCHING_NORMAL_ORDER 14 : '|| To_char(order_number),to_char(systimestamp)
                  );

   COMMIT;
EXCEPTION
   WHEN v_ex
   THEN
   v_CheckProcess := FALSE;
   ROLLBACK;
      INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' MATCHING_NORMAL_ORDER ', v_err
                  );

      COMMIT;
  END;



  --CHECK ROOM
  FUNCTION          FNC_CHECK_ROOM
  ( v_Symbol IN varchar2,
    v_Volumn In number,
    v_Custodycd in varchar2,
    v_BorS in  Varchar2)
  RETURN  number IS

    Cursor c_SecInfo(vc_Symbol varchar2) is
        Select CURRENT_ROOM from ho_Sec_info where
        CODE =Trim(vc_Symbol);
     v_CurrentRoom Number;
     v_Result varchar2(10);
    BEGIN
    --  return '1';
       If v_BorS ='B' and substr(v_Custodycd,4,1) ='F' then
            Open c_SecInfo(v_Symbol);
            Fetch c_SecInfo into v_CurrentRoom;
            If c_SecInfo%notfound  Or v_CurrentRoom < v_Volumn Then
               v_Result :='0';
            Else
               v_Result :='1';
            End if;
            Close c_SecInfo;
       Else
            v_Result :='1';
       End if;
       RETURN v_Result;
    END FNC_CHECK_ROOM;


    --CHECK HCM
    FUNCTION fnc_check_sec_hcm
      ( v_Symbol IN varchar2)
      RETURN  number IS

    Cursor c_SecInfo(vc_Symbol varchar2) is
        Select 1 from ho_Sec_info where
        Trim(CODE) =Trim(vc_Symbol) and FLOOR_CODE ='10'
        And NVL(SUSPENSION,'1') <>'S'
        And NVL(delist,'1') <>'D'
        And NVL(halt_resume_flag,'1') not in ('H','A','P');
      v_Number Number(10);
      v_Result varchar2(10);
    BEGIN
      Open c_SecInfo(v_Symbol);
      Fetch c_SecInfo into v_Number;
      If c_SecInfo%notfound  Then
          v_Result :='0';
      Else
         v_Result :='1';
      End if;
      Close c_SecInfo;
      RETURN v_Result;
    END;
    --CHECK TRADERID
    FUNCTION fnc_check_traderid
      ( v_Machtype IN varchar2,
        v_BORS IN varchar2,
        v_Via in varchar2 default null)
      RETURN  number IS

    Cursor c_Putthourgh(v_BuySell varchar2) is
        Select TRADERID from Traderid where
        substr(firm,-2,2) = (select substr(sysvalue,-2,2) from ordersys where SYSNAME ='FIRM')
        and nvl(status,' ') <>'S' And Via ='F'
        and nvl(PUTTHROUGH_HALT,' ') <> 'A' and  nvl(PUTTHROUGH_HALT,' ') <> trim(v_BuySell);

    Cursor c_Normal(v_BuySell varchar2,vc_Via varchar2) is
        Select TRADERID from Traderid where
        substr(firm,-2,2) = (select substr(sysvalue,-2,2) from ordersys where SYSNAME ='FIRM')
        and nvl(status,' ') <>'S' And Via =vc_Via
        and nvl(AUTOMATCH_HALT,' ') <> 'A' and  nvl(AUTOMATCH_HALT,' ') <> trim(v_BuySell);
     v_TraderID varchar2(10);
     v_Via_Tmp  varchar2(10);
    BEGIN
        v_TraderID :='1';

        If v_Via ='O' then
            v_Via_Tmp :='O';
        Else  --tai san, hoac Tele deu cho ve F
            v_Via_Tmp :='F';
        End if;

        If v_Machtype ='P' then
            Open c_Putthourgh(v_BORS);
            Fetch c_Putthourgh into v_TraderID;
            If c_Putthourgh%notfound then
               v_TraderID :='0';
            End if;
            Close c_Putthourgh;
            RETURN v_TraderID;
        Else
            Open c_Normal(v_BORS,v_Via_Tmp);
            Fetch c_Normal into v_TraderID;
            If c_Normal%notfound then
                 v_TraderID :='0';
            End if;
            Close c_Normal;
            RETURN v_TraderID;
        End if;
    END;



  FUNCTION    FNC_CHECK_ISNOTBOND
      ( v_Symbol IN Varchar2)
      RETURN  number IS
    Cursor c_Sbsecurities(v_Symbol_Sec varchar2)  is
        Select * from sbsecurities Where trim(SYMBOL) =trim(v_Symbol_Sec);
    v_Sbsecurities   c_Sbsecurities%Rowtype;
    v_Return Number;
    BEGIN
     Open c_Sbsecurities(v_Symbol);
     Fetch c_Sbsecurities into v_Sbsecurities;
     Close c_Sbsecurities;

     If v_Sbsecurities.SECTYPE ='006' then --Trai phieu
         v_Return:= 0;
     Else
        v_Return:= 1;
     End if;
     Return v_Return;
    END;

    FUNCTION          FNC_CHECK_P_STOCKBOND
      ( v_Msgtype Varchar2,v_Symbol IN Varchar2)
      RETURN  number IS

    Cursor c_Msgmast(v_Msgtype varchar2)  is
        Select * from Msgmast Where RORS ='S' And trim(msgtype) =trim(v_Msgtype);
    Cursor c_Sbsecurities(v_Symbol_Sec varchar2)  is
        Select * from sbsecurities Where trim(SYMBOL) =trim(v_Symbol_Sec);
    Cursor c_Sc is select SYSVALUE from ordersys where SYSNAME ='CONTROLCODE';
    v_Sc varchar2(10);

    v_Msgmast   c_Msgmast%Rowtype;
    v_Sbsecurities   c_Sbsecurities%Rowtype;
    v_Return Number;
    BEGIN
     Open c_Sc;
     Fetch c_Sc into v_Sc;
     Close c_Sc;

     Open c_Msgmast(v_Msgtype);
     Fetch c_Msgmast into v_Msgmast;
     Close c_Msgmast;

     Open c_Sbsecurities(v_Symbol);
     Fetch c_Sbsecurities into v_Sbsecurities;
     Close c_Sbsecurities;

     If v_Sbsecurities.SECTYPE ='006' then --Trai phieu
       If instr(Nvl(v_Msgmast.bond,' '),v_Sc)>0 then
         v_Return:= 1;
        Else
        v_Return:= 0;
        End if;
     Else
        If instr(nvl(v_Msgmast.stock,' '),v_Sc)>0 then
         v_Return:= 1;
        Else
         v_Return:= 0;
        End if;
     End if;
     Return v_Return;
    END FNC_CHECK_P_STOCKBOND;

     PROCEDURE CONFIRM_REPLACE_NORMAL_ORDER (
   pv_ordernumber   IN   VARCHAR2,
   pv_price         IN   NUMBER
)
  IS
   v_edstatus         VARCHAR2 (30);
   v_tltxcd           VARCHAR2 (30);
   v_txnum            VARCHAR2 (30);
   v_txdate           VARCHAR2 (30);
   v_tlid             VARCHAR2 (30);
   v_brid             VARCHAR2 (30);
   v_ipaddress        VARCHAR2 (30);
   v_wsname           VARCHAR2 (30);
   v_symbol           VARCHAR2 (30);
   v_afaccount        VARCHAR2 (30);
   v_seacctno         VARCHAR2 (30);
   v_price            NUMBER (10,2);
   v_quantity         NUMBER (10,2);
   v_bratio           NUMBER (10,2);
   v_oldbratio        NUMBER (10,2);
   v_cancelqtty       NUMBER (10,2);
   v_amendmentqtty    NUMBER (10,2);
   v_amendmentprice   NUMBER (10,2);
   v_matchedqtty      NUMBER (10,2);
   v_advancedamount   NUMBER (10,2);
   v_execqtty         NUMBER (10,2);
   v_trExectype       VARCHAR2 (30);
   v_reforderid       VARCHAR2 (30);
   v_tradeunit        NUMBER (10,2);
   v_desc             VARCHAR2 (300);
   v_bors             VARCHAR2 (30);
   v_txtime           VARCHAR2 (30);
   v_Count_lenhhuy    Number(2);
   v_OrderQtty_Cur    Number(10);
   v_RemainQtty_Cur   Number(10);
   v_ExecQtty_Cur     Number(10);
   v_ReplaceQtty_Cur   Number(10);
   v_Orstatus_Cur     VARCHAR2(10);
   v_CustID           VARCHAR2 (30);
   v_Actype           VARCHAR2 (30);
   v_CodeID           VARCHAR2 (30);
   v_TimeType         VARCHAR2 (30);
   v_ExecType         VARCHAR2 (30);
   v_NorK             VARCHAR2 (30);
   v_ClearDay         VARCHAR2 (30);
   v_MATCHTYPE        VARCHAR2 (30);
   v_Via              VARCHAR2 (30);
   v_CLEARCD          VARCHAR2 (30);
   v_PRICETYPE        VARCHAR2 (30);
   v_CUSTODYCD        VARCHAR2 (30);
   v_LIMITPRICE       Number(10,2);
   v_VOUCHER          VARCHAR2 (30);
   v_CONSULTANT       VARCHAR2 (30);
   v_OrderID          VARCHAR2 (30);
   v_replaceqtty      Number(10,2);
   PV_ORDERID          VARCHAR2 (30);
   pv_qtty              Number(10,2);
   v_err              VARCHAR2(300);
   V_hosesession       VARCHAR2 (30);
   v_ex                 EXCEPTION;
    ERR_TEX VARCHAR2(4000) ;

   Cursor c_Odmast(v_OrgOrderID Varchar2) Is
   SELECT REMAINQTTY,EXECQTTY,EXECAMT,CANCELQTTY,ADJUSTQTTY
   FROM ODMAST WHERE TIMETYPE ='G' AND ORDERID=v_OrgOrderID;
   vc_Odmast c_Odmast%Rowtype;

BEGIN
   --0 lay cac tham so
   v_brid := '0000';
   v_tlid := '0000';
   v_ipaddress := 'HOST';
   v_wsname := 'HOST';
   --v_replaceqtty := pv_qtty;


    INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' 123 Input pv_ordernumber HERE '||pv_ordernumber ||' '|| pv_qtty||' '|| pv_price,''
                  );

      COMMIT;

   --Kiem tra thoa man dieu kien sua
     BEGIN
     INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' 111 Input pv_ordernumber HERE '||pv_ordernumber ||' '|| pv_qtty||' '|| pv_price,''
                  );

      COMMIT;

        Select Orgorderid into PV_ORDERID from Ordermap where ctci_order =pv_ordernumber;

        INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' 222 Input pv_ordernumber HERE '|| PV_ORDERID ||' '|| pv_qtty||' '|| pv_price,''
                  );

      COMMIT;

     EXCEPTION
      WHEN OTHERS
      THEN
         v_CheckProcess := FALSE;
         v_err := SUBSTR ('ABC Order_number ' || SQLERRM, 1, 100);
         RAISE v_ex;
     End;
    V_hosesession :='';
   Begin

   SELECT ORDERQTTY,REMAINQTTY,EXECQTTY,CANCELQTTY,ORSTATUS,Exectype,TLID
    INTO V_ORDERQTTY_CUR,V_REMAINQTTY_CUR,V_EXECQTTY_CUR,V_REPLACEQTTY_CUR,V_ORSTATUS_CUR,v_Exectype,v_tlid
    FROM ODMAST WHERE ORDERID =PV_ORDERID;

    Select sysvalue Into V_hosesession  From ordersys where sysname ='CONTROLCODE' ;

   EXCEPTION
      WHEN OTHERS
      THEN
         v_CheckProcess := FALSE;
       ----------------quyet.kieu------------------------
       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '1. ODMAST WHERE ORDERID =PV_ORDERID '||pv_ordernumber ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;
        ----------------quyet.kieu------------------------


         v_err := SUBSTR ('ODMAST WHERE ORDERID =PV_ORDERID ' || SQLERRM, 1, 100);
         RAISE v_ex;
   END;

   v_replaceqtty:= V_REMAINQTTY_CUR;
   pv_qtty      := V_REMAINQTTY_CUR;

   --IF V_REMAINQTTY_CUR - v_replaceqtty < 0 OR V_EXECQTTY_CUR >= V_ORDERQTTY_CUR
   --              OR v_replaceqtty = 0
   --THEN
   -- RETURN;
   --END IF;

  Begin
   --Lay thong tin lenh goc
   SELECT (CASE
                      WHEN exectype = 'NB'
                         THEN '8890'
                      ELSE '8891'
                   END), sb.symbol,
                  od.afacctno, od.seacctno, od.quoteprice, od.orderqtty, od.bratio,
                  0, od.quoteprice, 0, od.orderqtty - pv_qtty,
                  od.reforderid, sb.tradeunit, od.edstatus,custid,actype,timetype,
                  NorK,MATCHTYPE,Via,CLEARDAY,CLEARCD,PRICETYPE,CUSTODYCD,
                  OD.LIMITPRICE,VOUCHER,CONSULTANT, od.codeid
             INTO v_tltxcd, v_symbol,
                  v_afaccount, v_seacctno, v_price, v_quantity, v_bratio,
                  v_amendmentqtty, v_amendmentprice, v_matchedqtty, v_execqtty,
                  v_reforderid, v_tradeunit, v_edstatus,v_custid,v_actype,v_timetype,
                  v_NorK,v_MATCHTYPE,v_Via,v_CLEARDAY,v_CLEARCD,v_PRICETYPE,v_CUSTODYCD,
                  v_LIMITPRICE,v_VOUCHER,v_CONSULTANT,v_codeid
             FROM odmast od, ood ,  securities_info sb
            WHERE od.codeid = sb.codeid AND od.orderid = ood.orgorderid AND od.orderid = pv_orderid;

  Exception when others then
   v_CheckProcess := FALSE;
      ----------------quyet.kieu------------------------
       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '2. Khong tim thay lenh goc orderid = pv_orderid '||pv_ordernumber ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;
        ----------------quyet.kieu------------------------

         v_err := SUBSTR ('Confirm Replace cancel: Khong tim thay lenh goc orderid = pv_orderid'||pv_orderid ||' '|| SQLERRM, 1, 100);
         RAISE v_ex;
  End;

   v_advancedamount := 0;
   v_price:=pv_price *1000;
   v_PRICETYPE:='LO';


   SELECT bratio
     INTO v_oldbratio
     FROM odmast
    WHERE orderid = pv_orderid;

       ----------------quyet.kieu------------------------
       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '3.SELECT bratio  INTO v_oldbratio '|| v_oldbratio ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;
        ----------------quyet.kieu------------------------


      SELECT varvalue
        INTO v_txdate
        FROM sysvar
       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

     Select '8001'||to_char(to_date(v_txdate,'dd/mm/yyyy'),'ddmmyy')||lpad(SEQ_ODMAST.NEXTVAL,6,'0')
     into v_OrderID from dual;

      SELECT    '8000'
             || SUBSTR ('000000' || seq_batchtxnum.NEXTVAL,
                        LENGTH ('000000' || seq_batchtxnum.NEXTVAL) - 5,
                        6
                       )
        INTO v_txnum
        FROM DUAL;

      SELECT TO_CHAR (SYSDATE, 'HH24:MI:SS')
        INTO v_txtime
        FROM DUAL;

      --1 them vao trong tllog
      INSERT INTO tllog
                  (autoid, txnum,
                   txdate, txtime, brid,
                   tlid, offid, ovrrqs, chid, chkid, tltxcd, ibt, brid2,
                   tlid2, ccyusage, txstatus, msgacct, msgamt, chktime,
                   offtime, off_line, deltd, brdate,
                   busdate, msgsts, ovrsts, ipaddress,
                   wsname, batchname, txdesc
                  )
           VALUES (seq_tllog.NEXTVAL, v_txnum,
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), v_txtime, v_brid,
                   v_tlid, '', 'N', '', '', v_tltxcd, 'Y', '',
                   '', '', '1', pv_orderid, v_quantity, '',
                   '', 'N', 'N', TO_DATE (v_txdate, 'DD/MM/YYYY'),
                   TO_DATE (v_txdate, 'DD/MM/YYYY'), '', '', v_ipaddress,
                   v_wsname, 'DAY', v_desc
                  );
      --them vao tllogfld
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'07',0,v_symbol,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'03',0,v_afaccount,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'04',0,pv_orderid,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'06',0,v_seacctno,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'08',0,pv_orderid,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'14',v_cancelqtty,NULL,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'11',v_price,NULL,NULL);
      INSERT INTO tllogfld(AUTOID,TXNUM,TXDATE,FLDCD,NVALUE,CVALUE,TXDESC)
      VALUES (seq_tllogfld.NEXTVAL,v_txnum,TO_DATE (v_txdate, 'DD/MM/YYYY'),'12',v_quantity,NULL,NULL);
      --2 THEM VAO TRONG TLLOGFLD

      v_edstatus := 'S';
      UPDATE odmast
         SET edstatus = v_edstatus
      WHERE orderid = pv_orderid;
      --Cap nhat lenh sua thanh da Send.
      UPDATE OOD SET OODSTATUS = 'S'
      WHERE ORGORDERID IN (SELECT ORDERID FROM ODMAST  WHERE REFORDERID = pv_orderid)
      and OODSTATUS <> 'S';
      UPDATE ODMAST SET ORSTATUS = '2' WHERE ORDERID IN (SELECT ORDERID FROM ODMAST  WHERE REFORDERID = pv_orderid)
                                       AND ORSTATUS = '8';


      --3 CAP NHAT TRAN VA MAST

        ----------------quyet.kieu------------------------
       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '4.CAP NHAT TRAN VA MAST '|| v_tltxcd ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;
        ----------------quyet.kieu------------------------

      IF v_tltxcd = '8890'
      THEN

         --BUY
        v_BORS :='B';
         UPDATE odmast
            SET adjustqtty = adjustqtty + v_replaceqtty,
                remainqtty = remainqtty - v_replaceqtty
          WHERE orderid = pv_orderid;


         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      pv_orderid, '0014', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );

         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      pv_orderid, '0011', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );

      ELSE                                                   --v_tltxcd='8891'
         --SELL
         v_BORS :='S';
         UPDATE odmast
            SET adjustqtty = adjustqtty + v_replaceqtty,
                remainqtty = remainqtty - v_replaceqtty
          WHERE orderid = pv_orderid;

         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      pv_orderid, '0014', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );

         INSERT INTO odtran
                     (txnum, txdate,
                      acctno, txcd, namt, camt, acctref, deltd,
                      REF, autoid
                     )
              VALUES (v_txnum, TO_DATE (v_txdate, 'DD/MM/YYYY'),
                      pv_orderid, '0011', v_cancelqtty, NULL, NULL, 'N',
                      NULL, seq_odtran.NEXTVAL
                     );
      END IF;

   --4 Sinh lenh moi.

    ----------------quyet.kieu------------------------
       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '5.Sinh lenh moi '|| v_tltxcd ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;
        ----------------quyet.kieu------------------------

   INSERT INTO ODMAST (ORDERID,CUSTID,ACTYPE,CODEID,AFACCTNO
                 ,SEACCTNO,CIACCTNO,
                 TXNUM,TXDATE,TXTIME,EXPDATE,BRATIO,TIMETYPE,
                 EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARCD,ORSTATUS,PORSTATUS,PRICETYPE,
                 QUOTEPRICE,STOPPRICE,LIMITPRICE,ORDERQTTY,REMAINQTTY,EXPRICE,EXQTTY,SECUREDAMT,
                 EXECQTTY,STANDQTTY,CANCELQTTY,ADJUSTQTTY,REJECTQTTY,REJECTCD,VOUCHER,CONSULTANT,REFORDERID,CORRECTIONNUMBER,TLID,HOSESESSION)
          VALUES ( v_ORDERID , v_CUSTID , v_ACTYPE , v_CODEID , v_afaccount
                  ,v_SEACCTNO ,v_afaccount
                  , v_TXNUM ,TO_DATE (v_txdate, 'DD/MM/YYYY'), v_TXTIME
                  ,TO_DATE (v_txdate, 'DD/MM/YYYY'),v_BRATIO ,v_TIMETYPE
                  ,v_EXECTYPE ,v_NORK ,v_MATCHTYPE ,v_VIA ,v_CLEARDAY , v_CLEARCD ,'2','2',v_PRICETYPE
                  ,v_price ,0,v_LIMITPRICE ,v_ReplaceQTTY,v_ReplaceQTTY ,v_price ,v_ReplaceQTTY,0
                  ,0,0,0,0,0,'001', v_VOUCHER , v_CONSULTANT , pv_orderid , 1,v_tlid,V_hosesession );

                   ----------------quyet.kieu------------------------
       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '6.Sinh lenh moi thanh cong '|| v_tltxcd ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;
        ----------------quyet.kieu------------------------

       --Ghi nhan vao so lenh day di
       INSERT INTO OOD (ORGORDERID,CODEID,SYMBOL,CUSTODYCD,
            BORS,NORP,AORN,PRICE,QTTY,SECUREDRATIO,OODSTATUS,
            TXDATE,TXTIME,TXNUM,DELTD,BRID,REFORDERID)
            VALUES ( v_ORDERID , v_CODEID , v_Symbol ,Replace(v_CUSTODYCD,'.',''),
            v_BORS ,v_MATCHTYPE ,v_NORK ,v_price ,v_ReplaceQTTY ,v_BRATIO ,'S' ,
            TO_DATE (v_txdate, 'DD/MM/YYYY'),  v_TXTIME , v_TXNUM ,'N',v_BRID , pv_orderid );


        ----------------quyet.kieu------------------------
       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '7.Sinh lenh moi thanh cong '|| v_tltxcd ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;
        ----------------quyet.kieu------------------------


        --Tao ban ghi trong ODQUEUE,ODQUEUELOG xac nhan lenh da day len san
        INSERT INTO ODQUEUE SELECT * FROM OOD WHERE ORGORDERID =  v_ORDERID;

          ----------------quyet.kieu------------------------
       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '8.Sinh lenh moi thanh cong '|| v_tltxcd ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;
        ----------------quyet.kieu------------------------


       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '9.Sinh lenh moi thanh cong '|| v_tltxcd ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;
        ----------------quyet.kieu------------------------
        --Cap nhat lai ODRERMAP_HA theo so hieu lenh moi cua lenh sua.

        BEGIN
        Update Ordermap set rejectcode =  orgorderid where orgorderid =pv_orderid;
         EXCEPTION
     when others then
    v_CheckProcess := FALSE;
    ERR_TEX:= SUBSTR(SQLERRM,0,3900);
    INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,'8 chet o day a Chet xac tiet .den day da chet roi' , ERR_TEX);

        commit ;

  END;

        INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '9 89 Chet o day '|| v_tltxcd ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;

        Update Ordermap set orgorderid =  v_ORDERID where orgorderid =pv_orderid;

INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '9 99 Chet o day '|| v_tltxcd ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;

 --Cap nhat cho GTC
 BEGIN

       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '10.bat dau corsor '|| v_tltxcd ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;

     OPEN C_ODMAST(pv_orderid);

    FETCH C_ODMAST INTO VC_ODMAST ;
    IF C_ODMAST%FOUND THEN
        --LENH YEU CAU GTO SE BI HUY, DO LENH CON TREN SAN DA THAY DOI
        UPDATE FOMAST SET DELTD='Y' WHERE ORGACCTNO= pv_orderid;

        ----------------quyet.kieu------------------------


       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '10.Vao trong GTO '|| v_tltxcd ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;
        --------------------------------------------

        INSERT INTO FOMAST (ACCTNO, ORGACCTNO, ACTYPE, AFACCTNO, STATUS, EXECTYPE, PRICETYPE,
                    TIMETYPE, MATCHTYPE, NORK, CLEARCD, CODEID, SYMBOL, CONFIRMEDVIA,
                    BOOK, FEEDBACKMSG, ACTIVATEDT, CREATEDDT,
                    CLEARDAY, QUANTITY, PRICE, QUOTEPRICE,
                    TRIGGERPRICE, EXECQTTY, EXECAMT, REMAINQTTY,TXDATE,TXNUM,
                    EFFDATE,EXPDATE,BRATIO,VIA,OUTPRICEALLOW)
             SELECT v_ORDERID,v_ORDERID,v_ACTYPE,v_afaccount,'A',EXECTYPE,v_PRICETYPE,
                    v_TIMETYPE,v_MATCHTYPE,v_NORK,CLEARCD,v_CODEID,v_Symbol,'N'
                    ,'A','',TO_CHAR(SYSDATE,'DD/MM/RRRR HH:MM:SS'),TO_CHAR(SYSDATE,'DD/MM/RRRR HH:MM:SS'),
                    v_CLEARDAY ,v_ReplaceQTTY, v_amendmentprice/ v_tradeunit ,v_amendmentprice / v_tradeunit ,
                     0 , 0 , 0 ,v_ReplaceQTTY ,TO_DATE(v_txdate, 'dd/mm/rrrr'),v_TXNUM,
                    EFFDATE,EXPDATE,v_BRATIO,v_VIA,OUTPRICEALLOW
                    FROM FOMAST WHERE ORGACCTNO= pv_orderid;

                       ----------------quyet.kieu------------------------


       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '10.Da qua duoc GTO '|| v_tltxcd ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;
        --------------------------------------------

    END IF;

   CLOSE C_ODMAST;


 EXCEPTION
     when others then
    v_CheckProcess := FALSE;
    ERR_TEX:= SUBSTR(SQLERRM,0,3900);
    INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE,'9.0000 Chet xac tiet .den day da chet roi' , ERR_TEX);

        commit ;

  END;



     ----------------quyet.kieu------------------------


       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '9.1 .den day da chet roi '|| v_tltxcd ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;
        --------------------------------------------



     ----------------quyet.kieu------------------------


       INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, '12.Sinh lenh moi thanh cong '|| v_tltxcd ||' '|| pv_qtty||' '|| pv_price,''
                  );

        commit ;


   COMMIT;


EXCEPTION
   WHEN v_ex
   THEN
   v_CheckProcess := FALSE;
   ROLLBACK;
   INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' ABC confirm_replace_normal_order ', v_err
                  );

      COMMIT;
   when others THEN
   v_CheckProcess := FALSE;
   ROLLBACK;
   INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, ' confirm_replace_normal_order ', 'others exception'
                  );

      COMMIT;

  END;

--Tinh thoi gian chenh lenh Giua HO va DB Flex
FUNCTION fn_get_delta_time
RETURN INTEGER as
    l_timeordersys  VARCHAR2(10);
    l_timemsg       VARCHAR2(10);
    l_delta_time      INTEGER;

BEGIN
    SELECT sysvalue INTO l_timeordersys FROM ordersys WHERE sysname = 'TIMESTAMP';
    SELECT NVL(TO_CHAR(MAX(msg_date),'HH24MISS'),'00:00:00') INTO l_timemsg FROM msgreceivetemp
    WHERE msgtype in ('SC','TS');


    IF l_timemsg = '00:00:00' THEN
        RETURN 0;
    END IF;

    SELECT TO_NUMBER(SUBSTR(l_timeordersys,1,2)) * 3600
                    + TO_NUMBER(SUBSTR(l_timeordersys,3,2)) * 60
                    + TO_NUMBER(SUBSTR(l_timeordersys,5,2))
                - (
                    TO_NUMBER(SUBSTR(l_timemsg,1,2)) * 3600
                        + TO_NUMBER(SUBSTR(l_timemsg,3,2)) * 60
                        + TO_NUMBER(SUBSTR(l_timemsg,5,2))
                    )
           INTO l_delta_time FROM DUAL;
  RETURN l_delta_time;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 0;
END fn_get_delta_time;
FUNCTION fn_caculate_hose_time

RETURN VARCHAR2 as
    l_delta_time  VARCHAR2(10);
    l_timesysdate   VARCHAR2(10);
    l_hosetime      INTEGER;
    l_returntime    VARCHAR2(10);

BEGIN
    SELECT sysvalue INTO l_delta_time FROM ordersys WHERE sysname = 'DELTATIME';
    SELECT TO_CHAR(systimestamp,'HH24MISS') INTO l_timesysdate FROM dual;

    IF l_delta_time = 9999 THEN
        RETURN TO_CHAR(systimestamp,'HH24MISS');
    END IF;

    SELECT l_delta_time
                + (
                    TO_NUMBER(SUBSTR(l_timesysdate,1,2)) * 3600
                        + TO_NUMBER(SUBSTR(l_timesysdate,3,2)) * 60
                        + TO_NUMBER(SUBSTR(l_timesysdate,5,2))
                    )
           INTO l_hosetime FROM DUAL;

    SELECT TRIM(TO_CHAR(MOD(FLOOR(l_hosetime/3600),24),'09'))
                || TRIM(TO_CHAR(FLOOR(MOD(l_hosetime,3600)/60),'09'))
                || TRIM(TO_CHAR(MOD(MOD(l_hosetime,3600),60),'09'))
           INTO l_returntime FROM DUAL;
  RETURN l_returntime;
EXCEPTION
  WHEN OTHERS THEN
    RETURN TO_CHAR(systimestamp,'HH24MISS');
END fn_caculate_hose_time;

BEGIN
  FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;

  pkgctx := plog.init('txpks_msg',
                      plevel => NVL(logrow.loglevel,30),
                      plogtable => (NVL(logrow.log4table,'Y') = 'Y'),
                      palert => (logrow.log4alert = 'Y'),
                      ptrace => (logrow.log4trace = 'Y'));
END PCK_HOGW;
/
