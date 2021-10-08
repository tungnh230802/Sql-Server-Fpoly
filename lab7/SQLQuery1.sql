
-- Viet ham tinh tuoi cua nguoi co nam sinh la @ns
drop function fTuoi
sp_helptext fTuoi

create function fTuoi(@ns int)
RETURNS int  --with encryption
as
begin
	return year(getDate()) - @ns
end
go

print dbo.fTuoi(1980)
--------------------------------------------------------
-- Viet ham tra ve tong so luong nhan vien
-- drop function fDemNv
Create function fDemNv()
returns int
begin
	return (select count(MANV) from NHANVIEN)
end

-- select * from nhanvien
-- Goi ham cach 1
print 'Tong so luong
Phung Lê Văn13:25
---------------------
-- select * from nhanvien
-- Goi ham cach 1
print 'Tong so luong nhan vien: ' + convert(varchar, dbo.fDemNv())

-- Goi ham cach 2
declare @tong int
set @tong = dbo.fDemNv()
select @tong
-------------------------------------------------------
Phung Lê Văn13:27
-- select * from NHANVIEN
Create function fDemNv_gioitinh(@phai nvarchar(3))
returns int
begin
	return (select count(MANV) from NHANVIEN
			where PHAI like @phai)
end

print 'Tong sl nhan vien: '+ convert(varchar, dbo.fDemNv_gioitinh(N'Nam'))
----------------------------------------
Luu Duc Danh (FPL HCM_K16)13:29
rồi
Truong Nhat Vinh (FPL HCM_K16)13:29
Có
To Vi Khang (FPL HCM_K16)13:29
da roi thay
Do Dang Khoa (FPL HCM_K16)13:29
có
Nguyen Tien Dat (FPL HCM_K16)13:29
có
Nguyen Quang Son FPL HCM13:29
có
Nguyen Hoang Long (FPL HCM_K16)13:29
có
Ngo Thanh Quy (FPL HCM_K16)13:29
có
Phung Lê Văn13:31
----------------------------------------
-- Viet ham tra ve bang cac nhan vien lam viec o phong so 5
-- drop function fNhanVien_PB
create function fNhanVien_PB(@Maphg int)
returns table
as
	return (
		select MANV, HONV, TENNV, PHG from NHANVIEN
		where PHG = @Maphg )
go

-- goi ham
select * from fNhanVien_PB(5)
-------------------------------------------
Phung Lê Văn13:35
-- Viet ham nhan du lieu tu bang phong ban
-- drop function fListPhong
create function fListPhong(@phong int)
returns @ProdList Table(
	ten nvarchar(15), ma int, trphg nvarchar(9), ngay date
)
as
begin
	IF @phong IS NULL
	begin
		insert into @ProdList(ten, ma, trphg, ngay)
		select TENPHG, MAPHG, TRPHG, NG_NHANCHUC
		from PhongBan
	end
	ELSE
	begin
		insert into @ProdList(ten, ma, trphg, ngay)
		select TENPHG, MAPHG, TRPHG, NG_NHANCHUC
		from PhongBan
		where MAPHG = @phong
	end
	RETURN
end

-- 
Nguyen Quang Son FPL HCM13:36
có
Nguyen Tien Dat (FPL HCM_K16)13:36
có
Nguyen Quang Son FPL HCM13:37
thầy ơi cái gọi hàm function có cần bắt buộc có dbo.tenham không thầy
Truong Nhat Vinh (FPL HCM_K16)13:37
Có
Le Ngoc Sang (FPL HCM_K16)13:37
có
Truong Nhat Vinh (FPL HCM_K16)13:37
--goi ham
select * from dbo.fListPhong(null)
select * from dbo.fListPhong(6)
Luu Duc Danh (FPL HCM_K16)13:37
có
To Vi Khang (FPL HCM_K16)13:37
da co
Phan Thanh Hien (FPL HCM_K16)13:38
dạ có
Phung Lê Văn13:44
-- View -----------------------------------
-- Tao view chua thong tin ten NV va ten PB
-- drop view NV_PB
create view NV_PB
as
select TENNV, TENPHG
from NHANVIEN inner join PHONGBAN on
	NHANVIEN.PHG = PHONGBAN.MAPHG
	
-- goi View
Select * from NV_PB

---------------------------------
Phung Lê Văn13:48
--drop view ThongTinPhong
create view ThongTinPhong
as
select TENPHG, MAPHG
from PHONGBAN
where MAPHG=6

select * from ThongTinPhong

update ThongTinPhong
SET TENPHG = 'IT'
---------------
Truong Nhat Vinh (FPL HCM_K16)13:49
Có
To Vi Khang (FPL HCM_K16)13:49
da co a
Nguyen Quang Son FPL HCM13:49
có
Luu Duc Danh (FPL HCM_K16)13:49
có
Le Ngoc Sang (FPL HCM_K16)13:49
có
Nguyen Tien Dat (FPL HCM_K16)13:49
có
Vo Minh Chien (FPL HCM)13:49
co
Nguyen Hoang Long (FPL HCM_K16)13:49
co
Nguyen Thanh Hung (FPL HCM_K16)13:50
co thay
Phung Lê Văn13:51
-- Tao view xem thong tin NV co tuoi <57
-- drop view ThongtinNV
create view ThongtinNV
as
select TenNV, LUONG, YEAR(GetDate()) - YEAR(NGSINH) as Tuoi
from NHANVIEN
where YEAR(GetDate()) - YEAR(NGSINH) > 57

select * from ThongtinNV

---------------------------------
Phung Lê Văn13:52
Tạo hàm nhận tham số đầu vào là địa chỉ, trả về bảng chứa các nhân viên có địa chỉ truyền vào
Đếm số lượng nhân viên thuộc phòng ban, với tên phòng ban là tham số đầu vào
View
Tạo View hiển thị Danh sách những trưởng phòng (HONV, TENLOT, TENNV) có tối thiểu một thân nhân
Hiển thị thông tin HoNV,TenNV,TenPHG, DiaDiemPhg.