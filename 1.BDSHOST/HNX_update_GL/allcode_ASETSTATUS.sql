DELETE FROM allcode  WHERE cdname ='ASETSTATUS'; 

insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'ASETSTATUS', '0', 'Chưa có xác nhận từ Sở', 1, 'Y', 'Chưa có xác nhận từ Sở');

insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'ASETSTATUS', '3', '3: Không tồn tại user này', 2, 'Y', '3: User not Recognised');

insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'ASETSTATUS', '4', '4: Pass không đúng', 3, 'Y', '4: Password Incorrect');

insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'ASETSTATUS', '5', '5:Mật khẩu đã được đổi', 4, 'Y', '5: Password changed');

insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'ASETSTATUS', '6', '6:Khác', 5, 'Y', '6: Other');

insert into allcode (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT)
values ('SA', 'ASETSTATUS', '7', '7:Sở từ chối', 5, 'Y', '7: Asset refush ');

COMMIT; 
