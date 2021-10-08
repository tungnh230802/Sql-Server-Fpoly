CREATE DATABASE QLNHATRO_PS17361
GO
USE QLNHATRO_PS17361
GO

-- tạo bảng
CREATE TABLE  DANHGIA(
	MANHATRO INT NOT NULL,
	MANGUOIDUNG INT NOT NULL,
	DANHGIA BIT NOT NULL,
	THONGTINDANHGIA NVARCHAR(50)
	PRIMARY KEY(MANHATRO,MANGUOIDUNG)
)
GO

CREATE TABLE LOAINHA(
	MALOAINHA INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	TENLOAINHA NVARCHAR(50) NOT NULL,
	THONGTINLOAINHA NVARCHAR(50)
)
GO

CREATE TABLE NGUOIDUNG(
	MANGUOIDUNG INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	TENNGUOIDUNG NVARCHAR(50) NOT NULL,
	GIOITINH BIT NOT NULL,
	DIENTHOAI CHAR(11) NOT NULL,
	DIACHI NVARCHAR(50) NOT NULL,
	QUAN NVARCHAR(50) NOT NULL,
	EMAIL CHAR(50)
)
GO

CREATE TABLE NHATRO(
	MANHATRO INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	MALOAINHA INT NOT NULL,
	DIENTICH REAL NOT NULL,
	GIAPHONG MONEY NOT NULL,
	DIACHI NVARCHAR(50) NOT NULL,
	QUAN NVARCHAR(50) NOT NULL,
	THONGTINNHATRO NVARCHAR(50),
	NGAYDANG DATE NOT NULL,
	MANGUOIDUNG INT NOT NULL
)

ALTER TABLE NHATRO
ADD CONSTRAINT FK1
	FOREIGN KEY (MALOAINHA)
	REFERENCES LOAINHA(MALOAINHA)
GO

ALTER TABLE NHATRO
ADD CONSTRAINT FK2
	FOREIGN KEY (MANGUOIDUNG)
	REFERENCES NGUOIDUNG(MANGUOIDUNG)
GO

ALTER TABLE DANHGIA
ADD CONSTRAINT FK3
	FOREIGN KEY (MANHATRO)
	REFERENCES NHATRO(MANHATRO)
GO

ALTER TABLE DANHGIA
ADD CONSTRAINT FK4
	FOREIGN KEY (MANGUOIDUNG)
	REFERENCES NGUOIDUNG(MANGUOIDUNG)
GO

-- thêm dữ liệu

INSERT INTO LOAINHA VALUES(N'Nhà Trọ Bình Dân', N'Nhà trọ giá rẻ cho hs,sv'),
						  (N'Cho thuê phòng', N'Phòng trọ dành cho người đi làm, sv...'),
						  (N'Nhà cho thuê nguyên căn', N'Dành cho hộ kinh doanh hoặc gia đình'),
						  (N'Cho thuê căn hộ', N'Căn hộ')
GO

INSERT INTO NGUOIDUNG VALUES(N'Đỗ Đầu Buồi', 1, N'0933662633', N'41b Tông thất tùng, Phạm Ngũ Lão', N'Quận 12', N'QuyDaubuoi423@gmail.com')
INSERT INTO NGUOIDUNG VALUES(N'Nguyễn Hoàng Tùng', 1, N'0849690585', N'170 nguyễn duy trinh, bình trưng tây', N'Quận 1', N'tungnh230802@gmail.com'),
							(N'Nguyễn Trung Nhân', 1, N'0930235234', N'463 Dương thị mười', N'Quận 2', N'Nhanvippro324@gmail.com'),
							(N'Hoàng Đình Tuấn', 1, N'0952342342', N'Gò Vấp. P10', N'Quận Gò Vấp', N'tuanhoang3234@gmail.com'),
							(N'Hoàng Thanh Thảo', 0, N'0532334232', N'Trần Nhân Tông P.7', N'Quận 3', N'ThaoThanh333@gmail.com'),
							(N'Nguyễn Thành Thủy', 0, N'0683453445', N'Nguyễn Thị Minh Khai, P.Bến thành', N'Quận 1', N'thanhthao9434@gmail.com'),
							(N'Nguyễn Thanh Trúc', 0, N'0394242343', N'Bùi Thị Xuân, P. Bến Thành', N'Quận 1', N'thixuan934@gmail.com'),
							(N'Nguyễn Việt Cường', 0, N'0834324232', N'Sương Nguyệt Ánh, P. Bến Thành', N'Quận 1', N'vietcuong342@gmail.com'),
							(N'Nguyễn Chí Dũng', 1, N'0395344533', N'Nguyễn Thái Học, P1', N'Quận 3', N'thaihoc323@gmail.com'),
							(N'Nguyễn Chí Mây', 0, N'0943534433', N'Trần Nhần Tông, P7', N'Quận 7', N'chimay339@gmail.com')
GO


INSERT INTO NHATRO VALUES(1, 40, 2000000, N'41b Tông thất tùng, Phạm Ngũ Lão', N'Quận 12', N'Giá cả phải chăng','20190803' ,1),
					     (2, 50, 3000000, N'170 nguyễn duy trinh, bình trưng tây', N'Quận 1', N'Cho thuê dài hạn','20190803' ,2),
						 (3, 60, 3500000, N'463 Dương thị mười', N'Quận 2', N'nhà rộng sạch sẽ','20190803' ,3),
						 (4, 100, 7000000, N'Gò Vấp. P10', N'Quận Gò Vấp', N'gần trần duy hưng','20190803' ,4),
						 (2, 40.5, 3400000, N'Trần Nhân Tông P.7', N'Quận 3', N'cho thuê','20190803' ,5),
						 (3, 65.5, 4000000, N'41b Tông thất tùng, Phạm Ngũ Lão', N'Quận 12', N'mặt bằng đẹp','20190803' ,6),
						 (4, 55, 4000000, N'Trần Nhân Tông P.7', N'Quận 3', N'mặt bằng đẹp','20190803' ,7),
						 (2, 65.5, 4500000,  N'Nguyễn Thị Minh Khai, P.Bến thành', N'Quận 1', N'ngõ rộng','20190803' ,8),
						 (1, 75, 5000000, N'Bùi Thị Xuân, P. Bến Thành', N'Quận 1', N'thoáng mát','20190803' ,9),
						 (3, 85.3, 6600000, N'Sương Nguyệt Ánh, P. Bến Thành', N'Quận 1', N'cho thuê','20190803' ,10),
						 (4, 56, 4000000,  N'Nguyễn Thái Học, P1', N'Quận 3', N'cho thuê','20190803' ,1),
						 (1, 73, 6000000, N'Trần Nhần Tông, P7', N'Quận 7', N'cho thuê','20190803' ,2)
