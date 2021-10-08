use lab2
go
-- Bang Inserted
-- select * from PHONGBAN
-- drop trigger trg_test_insert
CREATE TRIGGER trg_test_insert ON PHONGBAN
FOR INSERT
AS
Begin
	select * from inserted
end

INSERT INTO PHONGBAN
VALUES('Tai chinh', 7, '004', '2020-06-11')

-- delete from PHONGBAN where MAPHG=7

-- Kiem tra du lieu chen vao bang nhan vien co luong phai lon hon 5000
-- drop trigger CheckLuong_NV
create TRIGGER CheckLuong_tphcm on NHANVIEN 
FOR INSERT 
AS
BEGIN
	if (select DIACHI from inserted) like N'%TP HCM%'
	begin
		print N'không thể xóa nhân viên ở TP HCM'
		ROLLBACK TRANSACTION
	end
END
-- Check thử
insert into nhanvien
values(N'Nguyễn',N'Văn',N'Ti','050','1960-03-11',N'45 Lê Văn Sỹ,TP HCM','Nam',4000,'005',4)  

select * from nhanvien
delete from nhanvien where MANV = '021' 

-- drop trigger Luong_NV
-- select * from NhanVien
-- Trigger update luong phai > 5000
CREATE TRIGGER Luong_NV on NHANVIEN FOR UPDATE AS
BEGIN
	if (SELECT LUONG FROM inserted) < 5000
	begin
		print N'Lương toi thieu phải lớn hơn 5000'
		ROLLBACK TRANSACTION
	end
END

UPDATE NHANVIEN
SET LUONG = 4000
WHERE MANV = '005'

-- Trigger khong cho phap xoa nhan vien co ma 010
-- drop trigger XoaNV
CREATE TRIGGER XoaNV ON NHANVIEN FOR DELETE AS
BEGIN
	IF '010' IN (SELECT MANV FROM deleted)
	Begin
		PRINT 'Khong the xoa nhan vien nay';
		ROLLBACK TRANSACTION
	end
END

DELETE FROM NHANVIEN
WHERE MANV = '010'

-- select * from NhanVien
---------- TRIGGER AFTER --------------
-- Viet trigger dem so luong nv bi xoa khi co cau lenh xoa tren bang NhanVien
CREATE TRIGGER Xoa_NV ON NHANVIEN
AFTER DELETE
AS
BEGIN
	Declare @num nchar;
	Select @num = COUNT(*) FROM deleted
	PRINT N'So luong NV da xoa = '+@num
END

DELETE FROM NHANVIEN WHERE MANV = '020'

-- Viết trigger đếm số lượng nhân viên bị xóa 
-- khi thực hiện xóa các nhân viên ở TP HCM
CREATE TRIGGER Count_NVTpHCM ON NHANVIEN
AFTER DELETE
AS
BEGIN
	Declare @num nchar;
	Select @num = COUNT(*) FROM deleted
	where DCHI like 'Tp HCM'
	PRINT N'So luong NV da xoa = '+@num
END

DELETE FROM NHANVIEN WHERE DCHI like 'Tp HCM';

-- Tao trigger xoa cac than nhan co lien quan den nhan vien
-- drop trigger Delete_NV_ThanNhan
CREATE TRIGGER Delete_NV_ThanNhan ON NHANVIEN INSTEAD OF DELETE
AS
BEGIN
	DELETE FROM THANNHAN WHERE MA_NVIEN IN (SELECT MANV FROM deleted)
	DELETE FROM NHANVIEN WHERE MANV IN (SELECT MANV FROM deleted)
END

DELETE FROM NHANVIEN WHERE MANV = '018'


-- Backup data -----------
-- delete from NVBackup
-- drop table NVBackup
select * into NVBackup
from NhanVien

-- delete from TNBackup
-- drop table TNBackup
select * into TNBackup
from THANNHAN

-- Data--------------------
select * from NHANVIEN
select * from THANNHAN
select * from NVBackup
select * from TNBackup
-- INSERT ------
insert into NHANVIEN
select * from NVBackup
where MANV = '018'

insert into THANNHAN
select * from TNBackup
where MA_NVIEN = '018'

-- DELETE FROM THANNHAN
-- drop trigger InserUpdatetAge

CREATE TRIGGER InserUpdatetAge on NHANVIEN FOR INSERT, UPDATE AS
BEGIN
	UPDATE NHANVIEN
	SET Tuoi = datediff(yy,ngsinh,getdate())
	Where MaNV = (Select MANV from inserted)
END

