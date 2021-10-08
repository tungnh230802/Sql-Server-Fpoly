use lab2
go

/*
bài1:
Ràng buộc khi thêm mới nhân viên thì mức lương phải lớn hơn 15000, nếu vi phạm thì
xuất thông báo “luong phải >15000
*/

--Ràng buộc khi thêm mới nhân viên thì độ tuổi phải nằm trong khoảng 18 <= tuổi <=65.
-- drop trigger trg_luong 
create trigger trg_luong on nhanvien
for insert 
as
begin
	if(select luong from inserted) < 15000
	begin
		print(N'Lương phải lớn hơn 150000')
		rollback transaction
	end
	else
	begin
		print(N'đã inserted thành công')
	end
	declare @tuoi int
	set @tuoi = (select datediff(yy,ngsinh,getdate()) from inserted)
	if(@tuoi >= 18 and @tuoi <=65)
	begin
		print(N'đã inserted thành công')
	end
	else
	begin
		print(N'tuổi phải <= 18 và tuổi <=65');
		rollback transaction
	end
end

--select * from NHANVIEN

-- delete from nhanvien where manv='050'

insert into nhanvien
values(N'Nguyễn',N'Văn',N'Ti','050','2001-03-11',N'45 Lê Văn Sỹ,TP HCM','Nam',40000,'005',4)  
go
/*
bài1
Ràng buộc khi cập nhật nhân viên thì không được cập nhật những nhân viên ở TP HCM
*/
--drop TRIGGER Checkdiachi_tphcm

create TRIGGER Checkdiachi_tphcm on NHANVIEN 
FOR update 
AS
BEGIN
	if (select DIACHI from inserted) like N'%TP HCM%'
	begin
		print N'không thể cập nhật nhân viên ở TP HCM'
		ROLLBACK TRANSACTION
	end
END


UPDATE NHANVIEN
SET LUONG = 4000
WHERE MANV = '003'
go

/*
bài2
Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động
thêm mới nhân viên
*/

--drop trigger bai2a

create trigger bai2a on nhanvien
after insert
as
begin
	declare @sum_nam int
	declare @sum_nu int
	select @sum_nam =  count(*) from nhanvien where phai like N'Nam' group by phai
	select @sum_nu =  count(*) from nhanvien where phai like N'Nữ' group by phai
	print(N'số lượng nhân viên nam là: ' + convert(nvarchar,@sum_nam))
	print(N'số lượng nhân viên nữ là: ' + convert(nvarchar,@sum_nu))
end

insert into nhanvien
values(N'Nguyễn',N'Văn',N'Ti','050','2001-03-11',N'45 Lê Văn Sỹ,TP HCM','Nam',40000,'005',4)  
go

/*
bài2
 Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động
cập nhật phần giới tính nhân viên
*/


--drop trigger bai2b
create trigger bai2b_update on nhanvien
after update
as
begin
	declare @sum_nam int
	declare @sum_nu int
	select @sum_nam =  count(*) from nhanvien where phai like N'Nam' group by phai
	select @sum_nu =  count(*) from nhanvien where phai like N'Nữ' group by phai
	print(N'số lượng nhân viên nam là: ' + convert(nvarchar,@sum_nam))
	print(N'số lượng nhân viên nữ là: ' + convert(nvarchar,@sum_nu))
end

update NHANVIEN set phai = N'Nữ' where manv = '001'
go
/*
Hiển thị tổng số lượng đề án mà mỗi nhân viên đã làm khi có hành động xóa trên bảng
DEAN
*/

--drop trigger bai2c_delete
create trigger bai2c_delete on dean
after delete
as
begin
	select PHANCONG.MA_NVIEN, count(*) from dean
	inner join CONGVIEC on DEAN.MADA = CONGVIEC.MADA
	inner join PHANCONG on CONGVIEC.MADA = PHANCONG.MADA and CONGVIEC.STT = PHANCONG.STT
	group by PHANCONG.MA_NVIEN
end

delete from dean where phong = 1
go

/*
 Xóa các thân nhân trong bảng thân nhân có liên quan khi thực hiện hành động xóa nhân
viên trong bảng nhân viên
*/

create trigger cau3a on nhanvien
instead of delete as
begin 
	delete from THANNHAN where MA_NVIEN in
	(select manv from deleted)
	print N'đã xóa'
end

delete from NHANVIEN where MANV = '002'
go


/*
bài3b
 Khi thêm một nhân viên mới thì tự động phân công cho nhân viên làm đề án có MADA
là 1
*/

create trigger cau3b on nhanvien
instead of insert as
begin 
	insert into PHANCONG(MADA, MA_NVIEN, STT)
		values(1,(select manv from inserted),2)
		select * from PHANCONG
end

insert into nhanvien
values(N'Nguyễn',N'Văn',N'Ti','200','1965-03-11',N'45 Lê Văn Sỹ,TP HCM','Nam',40000,'005',1,4)  
go