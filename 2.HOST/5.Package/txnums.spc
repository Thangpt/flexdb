CREATE OR REPLACE PACKAGE txnums
    IS
       C_DELTD_TXDELETED CONSTANT CHAR(1) := 'Y';
       C_DELTD_TXNORMAL CONSTANT CHAR(1) := 'N';

       C_TXTYPE_WITDRAWAL  CONSTANT CHAR(1):= 'W';  -- Required Cash management, update host data before approve
       C_TXTYPE_REMITTANCE  CONSTANT CHAR(1):= 'R'; -- Required Cash management, update host data before approve
       C_TXTYPE_DEPOSIT  CONSTANT CHAR(1):= 'D';    -- Required Cash management
       C_TXTYPE_TRANSACTION  CONSTANT CHAR(1):= 'T';
       C_TXTYPE_ORDER  CONSTANT CHAR(1):= 'O'; -- update host data before approve
       C_TXTYPE_INQUIRY  CONSTANT CHAR(1):= 'I';
       C_TXTYPE_MAINTENANCE  CONSTANT CHAR(1):= 'M';

       C_TXACTION_DELETE CONSTANT CHAR(3) := 'DEL';
       C_TXACTION_APPROVE CONSTANT CHAR(3) := 'APR';
       C_TXACTION_REVERSE CONSTANT CHAR(3) := 'RVL';
       C_TXACTION_TRANSACT CONSTANT CHAR(3) := 'TXN';

       --C_TXINFO_PRINTINFO CONSTANT VARCHAR2(2) := '01';
       C_PRINTINFO_FLDNAME CONSTANT VARCHAR2(3):= '01';
       C_PRINTINFO_CUSTOMER_NAME CONSTANT VARCHAR2(3):= '02';
       C_PRINTINFO_ADDRESS CONSTANT VARCHAR2(3):= '03';
       C_PRINTINFO_LICENSE CONSTANT VARCHAR2(3):= '04';
       C_PRINTINFO_CUSTODYCD CONSTANT VARCHAR2(3):= '05';
       C_PRINTINFO_BANKACCOUNT CONSTANT VARCHAR2(3):= '06';
       C_PRINTINFO_BANKNAME CONSTANT VARCHAR2(3):= '07';

       C_TXINFO_VATTRAN CONSTANT VARCHAR2(2) := '02';
       C_VATTRAN_VOUCHERNO CONSTANT VARCHAR2(3):= '01';
       C_VATTRAN_VOUCHERTYPE CONSTANT VARCHAR2(3):= '02';
       C_VATTRAN_SERIALNO CONSTANT VARCHAR2(3):= '03';
       C_VATTRAN_VOUCHERDATE CONSTANT VARCHAR2(3):= '04';
       C_VATTRAN_CUSTID CONSTANT VARCHAR2(3):= '05';
       C_VATTRAN_TAXCODE CONSTANT VARCHAR2(3):= '06';
       C_VATTRAN_CUSTNAME CONSTANT VARCHAR2(3):= '07';
       C_VATTRAN_ADDRESS CONSTANT VARCHAR2(3):= '08';
       C_VATTRAN_CONTENTS CONSTANT VARCHAR2(3):= '09';
       C_VATTRAN_QTTY CONSTANT VARCHAR2(3):= '10';
       C_VATTRAN_PRICE CONSTANT VARCHAR2(3):= '11';
       C_VATTRAN_AMT CONSTANT VARCHAR2(3):= '12';
       C_VATTRAN_VATRATE CONSTANT VARCHAR2(3):= '13';
       C_VATTRAN_VATAMT CONSTANT VARCHAR2(3):= '14';
       C_VATTRAN_DESCRIPTION CONSTANT VARCHAR2(3):= '14';

       C_TXINFO_FEETRAN CONSTANT VARCHAR2(3) := '03';
       C_FEETRAN_FEECD CONSTANT VARCHAR2(3) := '01';
       C_FEETRAN_GLACCTNO CONSTANT VARCHAR2(3) := '02';
       C_FEETRAN_FEEAMT CONSTANT VARCHAR2(3) := '03';
       C_FEETRAN_VATAMT CONSTANT VARCHAR2(3) := '04';
       C_FEETRAN_TXAMT CONSTANT VARCHAR2(3) := '05';
       C_FEETRAN_FEERATE CONSTANT VARCHAR2(3) := '06';
       C_FEETRAN_VATRATE CONSTANT VARCHAR2(3) := '07';

END txnums;
/

