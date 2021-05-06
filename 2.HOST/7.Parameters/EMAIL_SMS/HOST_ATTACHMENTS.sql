Delete attachments where 0=0;
insert into attachments (AUTOID, ATTACHMENT_ID, REPORT_ID)
values (2, '0214  ', 'SE0009');

insert into attachments (AUTOID, ATTACHMENT_ID, REPORT_ID)
values (3, '0215  ', 'OD0001');

insert into attachments (AUTOID, ATTACHMENT_ID, REPORT_ID)
values (1, '0214  ', 'CF1108');

insert into attachments (AUTOID, ATTACHMENT_ID, REPORT_ID)
values (seq_attachments.nextval, '2804', 'CFEIMP');

insert into attachments (AUTOID, ATTACHMENT_ID, REPORT_ID)
values (seq_attachments.nextval, '2302', 'CFECHL');

insert into attachments (AUTOID, ATTACHMENT_ID, REPORT_ID)
values (seq_attachments.nextval, '2302', 'CFECH1');

insert into attachments (AUTOID, ATTACHMENT_ID, REPORT_ID)
values (seq_attachments.nextval, '4000', 'HDTKDV');

insert into attachments (AUTOID, ATTACHMENT_ID, REPORT_ID)
values (seq_attachments.nextval, '4000', 'DNTKCK');

insert into attachments (AUTOID, ATTACHMENT_ID, REPORT_ID)
values (seq_attachments.nextval, '4000', 'HDGDKQ');

insert into attachments (AUTOID, ATTACHMENT_ID, REPORT_ID)
values (seq_attachments.nextval, '4000', 'HDGDPS');

insert into attachments (AUTOID, ATTACHMENT_ID, REPORT_ID)
values (seq_attachments.nextval, '2805', 'CFEIM1');
commit;
