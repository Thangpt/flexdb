CREATE OR REPLACE FUNCTION FN_GEN_ADVDESC(pv_RATE In VARCHAR2, pv_CATYPE IN VARCHAR2,pv_RATE2 IN VARCHAR2)
    RETURN VARCHAR2 IS
    v_Result  VARCHAR2(250);
    v_strLeft VARCHAR2(250);
    v_strRight VARCHAR2(250);
BEGIN
    if(pv_CATYPE='011') THEN
    v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
    v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
    v_Result:= v_strLeft || ' c? phi?u s? h?u du?c hu?ng ' ||  v_strRight || ' c? phi?u m?i';
    ELSIF (pv_CATYPE='014') THEN
    v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
    v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
    v_Result:= v_strLeft || ' CP s? h?u du?c hu?ng ' ||  v_strRight || ' quy?n, ';

    v_strLeft:= substr(pv_RATE2,0,instr(pv_RATE2,'/') - 1);
    v_strRight:= substr(pv_RATE2,instr(pv_RATE2,'/') + 1,length(pv_RATE2));
    v_Result:= v_Result || v_strLeft || ' quy?n du?c mua ' ||  v_strRight || ' CP m?i ';

 ELSIF (pv_CATYPE='017') THEN
    v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
    v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
    v_Result:= v_strLeft || ' trái phi?u s? h?u du?c hu?ng ' ||  v_strRight || ' c? phi?u m?i ';

 ELSIF (pv_CATYPE='020') THEN
    v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
    v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
    v_Result:= v_strLeft || ' c? phi?u s? h?u du?c hu?ng ' ||  v_strRight || ' c? phi?u m?i ';

  ELSIF (pv_CATYPE='021') THEN
    v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
    v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
    v_Result:= v_strLeft || ' c? phi?u s? h?u du?c hu?ng ' ||  v_strRight || ' c? phi?u thu?ng ';

  ELSIF (pv_CATYPE='005') THEN
    v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
    v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
    v_Result:= v_strLeft || ' c? phi?u s? h?u du?c hu?ng ' ||  v_strRight || ' quy?n bi?u quy?t ';

   ELSIF (pv_CATYPE='006') THEN
    v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
    v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
    v_Result:= v_strLeft || ' c? phi?u s? h?u du?c hu?ng ' ||  v_strRight || ' quy?n bi?u quy?t ';

    ELSIF (pv_CATYPE='022') THEN
    v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
    v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
    v_Result:= v_strLeft || ' c? phi?u s? h?u du?c hu?ng ' ||  v_strRight || ' quy?n b? phi?u ';

    ELSIF (pv_CATYPE='023') THEN
    v_strLeft:= substr(pv_RATE,0,instr(pv_RATE,'/') - 1);
    v_strRight:= substr(pv_RATE,instr(pv_RATE,'/') + 1,length(pv_RATE));
    v_Result:= v_strLeft || ' trái phi?u s? h?u du?c hu?ng ' ||  v_strRight || ' c? phi?u m?i ';

     END IF;

    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/

