CREATE OR REPLACE FORCE VIEW V_GETSECPRGRPINFO AS
(
    SELECT prgrp.custodycd, prgrp.afacctno, prgrp.actype, prgrp.codeid, sb.symbol, prgrp.autoid grp_code,
        prgrp.grpname, prgrp.selimit, prgrp.grp_pravlremain, prgrp.grp_prinused,
        prgrp.grp_prinused * nvl(rsk.mrratioloan,0)/100 * least(sb.marginprice,nvl(rsk.mrpriceloan,0)) TS_grp,
        nvl(rsk.mrratioloan,0) ratecl, least(sb.marginprice,nvl(rsk.mrpriceloan,0)) pricecl, prgrp.note
    FROM afserisk rsk, securities_info sb,
    (
        SELECT cf.custodycd, sel.autoid, sel.note, af.actype, afse.afacctno, sel.codeid, sel.grpname, sel.selimit,
            sel.selimit - fn_getUsedSeLimitByGroup(sel.autoid) grp_pravlremain,
            fn_getUsedSeLimit(afse.afacctno, sel.codeid) grp_prinused
        FROM selimitgrp sel, afselimitgrp afse, afmast af, cfmast cf
        WHERE cf.custid = af.custid AND af.acctno = afse.afacctno AND sel.autoid = afse.refautoid
    ) prgrp
    WHERE prgrp.codeid = sb.codeid AND prgrp.actype = rsk.actype(+) AND prgrp.codeid = rsk.codeid(+)
);

