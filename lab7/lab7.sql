use lab2
go

/*
bài1
-Nhập vào MaNV cho biết tuổi của nhân viên này
*/
-- drop function tuoinv
create function tuoinv(@manv nvarchar(9))
returns int
begin 
	return (select year(GETDATE()) - year(ngsinh)
	from NHANVIEN where MANV = @manv)
end
go

print cast(dbo.tuoinv('001') as nvarchar(50))
go


/*
bài1
-Nhập vào Manv cho biết số lượng đề án nhân viên này đã tham gia
*/

create function sldean(@manv nvarchar(9))
returns int
begin
	return (select count(*) from PHANCONG where MA_NVIEN = @manv group by MA_NVIEN)
end
go

print dbo.sldean('001')
go

/*
bài1
-Truyền tham số vào phái nam hoặc nữ, xuất số lượng nhân viên theo phái
*/

create function slphai(@phai nvarchar(3))
returns int
begin
	return(select count(*) from NHANVIEN where	PHAI = @phai group by PHAI)
end
go

print dbo.slphai(N'Nam')
print dbo.slphai(N'Nữ')
go

/*
bài1
-Truyền tham số đầu vào là tên phòng, tính mức lương trung bình của phòng đó, Cho biết
họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình
của phòng đó.
*/
--drop function bai1d
create function bai1d(@phg int)
returns table
as
	return 
	(
		select HONV, TENLOT, TENNV, LUONG as N'lương nv',
		(select avg(luong) from NHANVIEN group by phg having phg = @phg) as N'lương tb phòng'
		from NHANVIEN where LUONG > 
		(select avg(luong) from NHANVIEN group by phg having phg = @phg) and phg = @phg 
	)
go

select * from bai1d(5)
go

/*
bài1 
 Tryền tham số đầu vào là Mã Phòng, cho biết tên phòng ban, họ tên người trưởng phòng
và số lượng đề án mà phòng ban đó chủ trì.
*/
-- drop function bai1e
create function bai1e(@phg int)
returns table
as
return
	(
		select TENPHG,HONV,TENLOT,TENNV, maphongban, tongsodean from 
		(
		select phg as maphongban, count(*) as tongsodean 
		from PHANCONG pc,PHONGBAN pb,NHANVIEN nv
		where pc.MA_NVIEN = nv.MANV
		and pb.MAPHG = nv.PHG and pb.MAPHG = @phg
		group by phg
		) as c, phongban, nhanvien
		where c.maphongban = PHONGBAN.MAPHG and nhanvien.phg = PHONGBAN.MAPHG  and manv = TRPHG
	)
go

select * from bai1e(1)
go

/*
bài2
-Hiển thị thông tin HoNV,TenNV,TenPHG, DiaDiemPhg.
*/
-- drop view thongtinnv
create view thongtinnv
as
select honv, tennv, tenphg, dd.DIADIEM
from PHONGBAN pb
inner join NHANVIEN nv on pb.MAPHG = nv.PHG
inner join DIADIEM_PHG dd on pb.MAPHG = dd.MAPHG
go

select * from thongtinnv
go


/*
bài2N
-Hiển thị thông tin TenNv, Lương, Tuổi
*/

create view bai2bview
as
select TENNV, LUONG, (year(getdate()) - year(NGSINH)) as N'tuổi' from NHANVIEN
go

select * from bai2bview
go
/*
bài2
-Hiển thị tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất
*/
-- drop view bai2cview
create view bai2cview
as
select TENPHG, HONV, TENNV from NHANVIEN nv inner join PHONGBAN pb 
on nv.PHG = pb.MAPHG
where TRPHG = MANV and MAPHG in
(select top(1) phg from NHANVIEN group by phg order by count(*) desc)
go

select * from bai2cview
go