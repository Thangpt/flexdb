CREATE OR REPLACE PROCEDURE pr_remarkedafpralloc(pv_strAFACCTNO varchar2,pv_strErrorCode in out varchar2)
is
    p_err_code varchar2(100);
    p_value number;
begin

p_value:=fn_markedafpralloc(pv_strAFACCTNO,
                            null,
                            'A',
                            'T',
                            pv_strAFACCTNO,
                            'N',
                            'N',
                            getcurrdate,
                            '',
                            pv_strErrorCode);
end;
/

