
update lnschd  set intovdprin = 0 where  intovdprin < 0 ;
update lnmast  set intovdacr = 0 where  intovdacr < 0 ;
commit;
