CREATE OR REPLACE FUNCTION fn_getprinusedre(p_ACCTNO IN VARCHAR2, p_CODEID_FR IN varchar2, p_CODEID_TO IN VARCHAR2, p_QTTY IN NUMBER)
RETURN NUMBER
IS

    l_mrratioratio          number(20,4);
    l_fr_marginPrice        number(20,0);
    l_to_marginPrice        number(20,0);
    l_fr_marginRate        number(20,0);
    l_to_marginRate        number(20,0);
    l_exec_outstanding      number(20,0);

    l_to_securedqtty        NUMBER(20,0);

BEGIN

              select 100 - mriratio -- Ti le vay
              into l_mrratioratio
              from afmast where acctno = p_ACCTNO;


              begin
                  SELECT least(nvl(sb.marginrefprice, 0), nvl(rsk.mrpriceloan, 0)),nvl(rsk.mrratioloan, 0)
                      INTO  l_fr_marginPrice, l_fr_marginRate
                  FROM  afmast af, afmrserisk rsk, securities_info sb
                  WHERE af.actype = rsk.actype(+) AND rsk.codeid = sb.codeid AND AF.ACCTNO = p_ACCTNO AND SB.CODEID = p_CODEID_FR;
              exception when others then
                  RETURN 0;
              end;


              begin
                  SELECT least(nvl(sb.marginrefprice, 0), nvl(rsk.mrpriceloan, 0)),nvl(rsk.mrratioloan, 0)
                      INTO  l_to_marginPrice, l_to_marginRate
                  FROM  afmast af, afmrserisk rsk, securities_info sb
                  WHERE af.actype = rsk.actype(+) AND rsk.codeid = sb.codeid AND AF.ACCTNO = p_ACCTNO AND SB.CODEID = p_CODEID_TO;
              exception when others then
                  RETURN 0;
              end;

                   --- GT chung khoan chuyen
                   l_exec_outstanding:= greatest(nvl(p_QTTY, 0) * l_fr_marginPrice * (least(l_mrratioratio,l_fr_marginRate)/100), 0);

                   --- QUI DOI SL CK NHAN TUONG UNG VOI SL CK CHUYEN
                   l_to_securedqtty     := CEIL(l_exec_outstanding / (l_to_marginPrice * (least(l_mrratioratio,l_to_marginRate)/100)));

              RETURN l_to_securedqtty;


EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/

