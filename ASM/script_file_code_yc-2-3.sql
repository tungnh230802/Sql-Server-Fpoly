use QLNHATRO_PS17361
go

/*
1
-SP thứ nhất thực hiện chèn dữ liệu vào bảng NGUOIDUNG
*/
-- xóa sp_insert_nguoi_dung nếu đã tồn tại
if object_id ('sp_insert_nguoi_dung') is not null
drop proc sp_insert_nguoi_dung
go

create proc sp_insert_nguoi_dung
			@TenNguoiDung nvarchar(50) = null,
			@GioiTinh bit = null,
			@DienThoai char(12) = null,
			@DiaChi nvarchar(50) = null,
			@Quan nvarchar(50) = null,
			@Email char(50) = null
as 
-- kiểm tra thông tin đầu vào
if (@TenNguoiDung is null) or (@GioiTinh is null) or (@DienThoai is null) or (@DiaChi
is null) or (@Quan is null)
-- nếu thiếu thông tin đầu vào thì sẽ hiển thị lỗi
begin 
	print N'Lỗi!'
	print N'Thiếu thông tin đầu vào'
end
else
	begin -- chức năng nâng cao: nếu sai định dạng email sẽ báo lỗi!
		if (@Email not like '%[A-Z0-9][@][A-Z0-9]%[.][A-Z0-9]%')
		begin
			print N'Lỗi!'
			print N'Vui lòng nhập đúng email'
		end
		else
		begin
			insert into NGUOIDUNG
			values (@TenNguoiDung, @GioiTinh, @DienThoai, @DiaChi, @Quan, @Email)
			print N'Thêm thông tin thành công'
		end
	end
go

-- thêm dữ liệu bảng người dùng với thông báo thành công
exec sp_insert_nguoi_dung @TenNguoiDung=N'Đỗ Bùi Quý',
@GioiTinh=true,
@DienThoai='0933662633',
@DiaChi=N'41b Tôn Thất Tùng, Phạm Ngũ Lão',
@Quan=N'Quận 1',
@Email='Quydbps00389@fpt.edu.vn'
go

-- thêm dữ liệu bảng người dùng với thông báo lỗi
exec sp_insert_nguoi_dung @TenNguoiDung=N'Đỗ Bùi Quý'
go

-- -- thêm dữ liệu bảng người dùng với thông báo sai email
exec sp_insert_nguoi_dung @TenNguoiDung=N'Đỗ Bùi Quý',
@GioiTinh=true,
@DienThoai='0933662633',
@DiaChi=N'41b Tôn Thất Tùng, Phạm Ngũ Lão',
@Quan=N'Quận 1',
@Email='Quydbps00389'
go

------------------------------------------------------------------------------
/*
1.SP thứ hai thực hiện chèn dữ liệu vào bảng NHATRO
*/
if OBJECT_ID ('sp_insert_NhaTro') is not null
drop proc sp_insert_NhaTro
go
create proc sp_insert_NhaTro
			@MaLoaiNha int = null,
			@DienTich real = null,
			@GiaPhong money = null,
			@DiaChi nvarchar(50) = null,
			@Quan nvarchar(50) = null,
			@ThongTinNhaTro nvarchar(50) = null,
			@MaNguoiDung int = null
as
--Kiểm tra thông tin đầu vào
if (@MaLoaiNha is null) or (@DienTich is null) or (@GiaPhong is null) or (@DiaChi is
null) or (@Quan is null) or (@MaNguoiDung is null)
begin
	print N'Lỗi:'
	print N'Thiếu thông tin đầu vào'
end
else
begin
--Kiểm tra mã loại nhà có tồn tại hay không
if not exists (select * from LoaiNha where MaLoaiNha = @MaLoaiNha )
begin
	print N'Loại nhà này không tồn tại'
end
--Kiểm tra người dùng tồn tại hay không
else if not exists (select * from NguoiDung where MaNguoiDung = @MaNguoiDung )
begin
	print N'Người dùng này không tồn tại'
end
else
begin
	insert into NhaTro
	values (@MaLoaiNha, @DienTich, @GiaPhong, @DiaChi, @Quan, @ThongTinNhaTro,
	GETDATE(), @MaNguoiDung)
	print N'Thêm thông tin thành công'
end
end
go


--Thêm dữ liệu bảng nhà trọ thành công
exec sp_insert_NhaTro @MaLoaiNha = 1,
@DienTich = 39,
@GiaPhong = 1000000,
@DiaChi = N'41b Tôn Thất Tùng, Phạm Ngũ Lão',
@Quan = N'Quận 1',
@ThongTinNhaTro = N'Giá cả phải chăng',
@MaNguoiDung = 1

-- thêm dữ liệu bảng nhà trọ thất bại
exec sp_insert_NhaTro @MaLoaiNha=1

----------------------------------------------------------------------------------
/*
1.
SP thứ ba thực hiện chèn dữ liệu vào bảng DANHGIA
*/

-- xóa pro nết đã tồn tại
if OBJECT_ID ('sp_insert_DanhGia') is not null
drop proc sp_insert_DanhGia
go

create proc sp_insert_DanhGia
	@MaNhaTro int = null,
	@MaNguoiDung int = null,
	@DanhGia bit = null,
	@ThongTinDanhGia nvarchar(50) = null
as
-- kiểm tra đầu vào
if (@MaNhaTro = null) or (@MaNguoiDung = null) or (@DanhGia = null) 
begin
	print N'Lỗi:'
	print N'Thiếu thông tin đầu vào'
end
else
begin
--Kiểm tra mã nhà trọ có tồn tại hay không
	if not exists (select * from NhaTro where MaNhaTro = @MaNhaTro )
begin
	print N'Nhà trọ này không tồn tại'
end
--Kiểm tra người dùng tồn tại hay không
else if not exists (select * from NguoiDung where MaNguoiDung = @MaNguoiDung )
begin
	print N'Người dùng này không tồn tại'
end
--Kiểm tra xem người dùng đã đánh giá nhà trọ hay chưa
else if exists (select * from DanhGia where MaNguoiDung = @MaNguoiDung and MaNhaTro =
@MaNhaTro)
begin
	print N'Người dùng này đã đánh giá nhà trọ này'
end
else
begin
	insert into DanhGia
	values (@MaNhaTro , @MaNguoiDung , @DanhGia , @ThongTinDanhGia)
	print N'Thêm thông tin thành công'
end
end
--------------------------------------------------
--Thêm dữ liệu bảng đánh giá thành công
exec sp_insert_DanhGia @MaNhaTro = 1,
@MaNguoiDung = 2,
@DanhGia = true,
@ThongTinDanhGia = N'Nhà trọ tốt'

--Thêm dữ liệu bảng đánh giá có thông báo lỗi
exec sp_insert_DanhGia @MaNhaTro=1

-------------------------------------------------------------------------
/*
2.
a. tìm nhà trọ
*/

-- xóa pro nếu đã tồn tại
if object_id ('sp_select_nhatro') is not null
drop proc sp_select_nhatro
go

create proc sp_select_nhatro
	@LoaiNhaTro nvarchar(50) = N'%',
	@quan nvarchar(50) = N'%',
	@DienTichMax real = null,
	@DienTichMin real = null,
	@NgayDangMin date = null,
	@NgayDangMax date = null,
	@GiaPhongMax money = null,
	@GiaPhongMin money = null
as
if @DienTichMax is null
	begin 
		select @DienTichMax = max(NHATRO.DIENTICH) from NHATRO
	end

if @DienTichMin is null
	begin 
		select @DienTichMin = min(NHATRO.DIENTICH) from NHATRO
	end

if @NgayDangMax is null
	begin
		select @NgayDangMax = max(nhatro.NGAYDANG) from NHATRO
	end

if @NgayDangMin is null
	begin
		select @NgayDangMin = min(nhatro.NGAYDANG) from NHATRO
	end

if @GiaPhongMax is null
	begin
		select @GiaPhongMax = max(nhatro.GIAPHONG) from NHATRO
	end

if @GiaPhongMin is null
	begin
		select @GiaPhongMin = min(nhatro.GIAPHONG) from NHATRO
	end

select (N'Cho thuê phòng tại ' + nt.DIACHI +', ' + nt.QUAN ) as N'Địa chỉ',
	   (replace(convert(varchar,nt.DIENTICH,103),'.',',') + ' m2') as N'Diện tích',
	   (replace(left(convert(varchar, nt.GIAPHONG,1),len(convert(varchar,giaphong,1))-3),',','.') + N' VNĐ') as 'Giá phòng',
	   nt.THONGTINNHATRO as N'Thông tin nhà trọ',
	   convert(varchar,nt.NGAYDANG,105) as 'Ngày đăng',
	   case nd.GIOITINH
			when 1 then 'A. ' + nd.TENNGUOIDUNG
			when 0 then 'C. ' + nd.TENNGUOIDUNG
		end as N'Người Đăng',
		nd.DIENTHOAI as N'Điện thoại liên hệ', 
		(nd.DIACHI + ', ' + nd.QUAN) as N'Địa chỉ liên hệ'
		from NHATRO nt
		join LOAINHA ln on nt.MALOAINHA = ln.MALOAINHA
		join NGUOIDUNG nd on nd.MANGUOIDUNG = nt.MANGUOIDUNG
		where(DIENTICH <= @DienTichMax) 
		and (DIENTICH >= @DienTichMin)
		and (NGAYDANG <= @NgayDangMax)
		and (NGAYDANG >= @NgayDangMin)
		and (GIAPHONG <= @GiaPhongMax)
		and (GIAPHONG >= @GiaPhongMin)
		and (nt.QUAN like @quan)
		and (TENLOAINHA like @LoaiNhaTro)
		order by NGAYDANG
go
-- truy vấn
exec sp_select_nhatro
exec sp_select_nhatro @LoaiNhaTro=N'%căn hộ%'
exec sp_select_nhatro @quan=N'%quận 1', @dientichmin = 70, @giaphongmax = 7000000
go
--------------------------------------------------------------

/*
2. 
-trả về mã người dùng
*/

if object_id ('fn_manguoidung') is not null
drop function fn_manguoidung
go

create function fn_manguoidung
	(@TenNguoiDung nvarchar(50) = N'%',
	 @DienThoai nvarchar(12) = N'%',
	 @DiaChi nvarchar(50) = N'%',
	 @Quan nvarchar(50) = N'%',
	 @email nvarchar(50) = N'%')
returns table
return (select MANGUOIDUNG, TENNGUOIDUNG
		from NGUOIDUNG 
		where(TENNGUOIDUNG like @TenNguoiDung)
		and (DIACHI like @DiaChi)
		and (QUAN like @Quan)
		and (DIENTHOAI like @DienThoai)
		and (email like @email))
go
--truy vẫn dữ liệu
select * from dbo.fn_manguoidung(N'%Nguyễn%', '0849690585 ', default, default, default)

------------------------------------------------------------------------
/*
2.
trả về tổng số like và dislike của nhà trọ
*/

-- hàm trả về tổng like
if object_id ('fn_tonglike') is not null
drop function fn_tonglike
go

create function fn_tonglike
		(@MaNhaTro int)
returns int
as	
	begin
	return
		(select count(DANHGIA)
		from DANHGIA
		where MANHATRO = @MaNhaTro 
		and DANHGIA = 1)
	end

select dbo.fn_tonglike(3)

-- hàm trả về tổng dislike
if object_id ('fn_tongdislike') is not null
drop function fn_tongdislike
go

create function fn_tongdislike
		(@MaNhaTro int)
returns int
as	
	begin
	return
		(select count(DANHGIA)
		from DANHGIA
		where MANHATRO = @MaNhaTro 
		and DANHGIA = 0)
	end

select dbo.fn_tonglike(3)


/*
2.
-tạo view hiện top 10 like nhiều nhất
*/

if object_id ('top5') is not null
drop view top5
go

create view top5
as
select top 5 nt.MANHATRO as 'Mã nhà trọ',
	(replace(convert(varchar,DienTich,103),'.',',') + ' m2') as 'Diện Tích',
	(replace(left(convert(varchar,giaphong,1),len(convert(varchar,giaphong,1))-3),',','.') + N'VNĐ') as 'Giá Phòng',
	THONGTINNHATRO as N'Thông tin nhà trọ',
	(nt.DIACHI + ', ' + nt.QUAN) as 'Địa chỉ nhà trọ',
	dbo.fn_tonglike(MANHATRO) as N'Tổng like',
	NGAYDANG as N'Ngày Đăng',
	nd.TENNGUOIDUNG as N'Người đăng',
	(nd.DIACHI + ', ' + nd.QUAN) as N'Địa chỉ liên hệ',
	nd.DIENTHOAI as N'Điện thoại',
	nd.EMAIL as 'email'
from NHATRO nt 
join NGUOIDUNG nd on nt.MANGUOIDUNG = nd.MANGUOIDUNG
join LOAINHA ln on ln.MALOAINHA = nt.MALOAINHA
order by N'Tổng Like' DESC

----------------------------------------------------------------
select *  from top5

/*
2.
truy vấn thông tin đánh giá nhà trọ
*/

if object_id ('sp_select_danhgia') is not null
drop proc sp_select_danhgia
go

create proc sp_select_danhgia
			@MaNhaTro int
as 
if not exists (select * from NHATRO where MANHATRO = @MaNhaTro)
	begin
		print N'Nhà trọ này không tồn tại'
	end
else
	begin
		if not exists (select *from DANHGIA where MANHATRO = @MaNhaTro)
			begin
				print N'Nhà trọ này chưa được đánh giá'
			end
		else 
			begin
				select dg.MANHATRO as N'mã nhà trọ',
				nd.TENNGUOIDUNG  as N'Người đánh giá',
				case dg.danhgia
					when 1 then 'like'
					when 0 then 'dislike'
				end as N'Đánh giá'
				from DANHGIA dg
				join NGUOIDUNG nd on dg.MANGUOIDUNG = nd.MANGUOIDUNG
				where dg.MANHATRO= @MaNhaTro
			end
	end
-- truy vấn thành công
exec sp_select_danhgia @manhatro = 1

-- truy vấn nhà trọ không tồn tại
exec sp_select_danhgia @manhatro = 111

/*
3. 
xóa thông tin nhà trọ
*/

if object_id('sp_delete_nhatro_dislike') is not null
drop proc sp_delete_nhatro_dislike
go

create proc sp_delete_nhatro_dislike
			@dislike int
as 
begin try
	begin tran
		declare @manhatro table (manhatro int)
			insert @manhatro
			select nt.MANHATRO from NHATRO nt where dbo.fn_tongdislike(nt.MANHATRO) > @dislike

		delete from DANHGIA 
			where DANHGIA.MANHATRO in ( select MANHATRO from @manhatro)
		
		delete from NHATRO
			where NHATRO.MANHATRO in (select MANHATRO from @manhatro)

		print N'Thao tác thành công!'
	commit tran
end try
begin catch 
	rollback tran
	print N'Thao tác không thành công'
end catch
go

-- backup bảng đánh giá
select * into danhgia_backup from danhgia

--xóa thành công
exec sp_delete_nhatro_dislike 
			@dislike = 2
			
------------------------------------------------------------------------

/*
3.
delete nhà trọ với 2 tham số
*/


if object_id('sp_delete_nhatro_ngaydang') is not null
drop proc sp_delete_nhatro_ngaydang
go

create proc sp_delete_nhatro_ngaydang
			@NgayDangMax date = null,
			@NgayDangMin date = null

as 
	begin try
		begin tran
			if(@NgayDangMin is null)
				select @NgayDangMin = min(NHATRO.NGAYDANG) from NHATRO
			if(@NgayDangMax is null)
				select @NgayDangMax = max(NHATRO.NGAYDANG) from NHATRO
			declare @MaNhaTro table (MaNhaTro int)
				insert @MaNhaTro
				select NHATRO.MANHATRO from NHATRO
				where (NGAYDANG <= @NgayDangMax) and ( NGAYDANG >= @NgayDangMin)
			
			delete from DANHGIA
				where DANHGIA.MANHATRO in (select MANHATRO from @MaNhaTro)

			delete from NHATRO
				where NHATRO.MANHATRO in (select MANHATRO from @MaNhaTro)
			
			print N'thao tác thành công'
		commit tran
	end try
begin catch
	rollback tran
	print N'thao tác không thành công'
end catch

-- xóa thành công
exec sp_delete_nhatro_ngaydang 
@NgayDangMin = '1/1/2021',
@NgayDangMax = '12/31/2021'
GO
