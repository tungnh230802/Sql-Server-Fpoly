USE LAB2
GO
/*
Bai1A: Viết chương trình xem xét có tăng lương cho nhân viên hay không. Hiển thị cột thứ 1 là
TenNV, cột thứ 2 nhận giá trị
o “TangLuong” nếu lương hiện tại của nhân viên nhở hơn trung bình lương trong
phòng mà nhân viên đó đang làm việc.
o “KhongTangLuong “ nếu lương hiện tại của nhân viên lớn hơn trung bình lương
trong phòng mà nhân viên đó đang làm việc
*/
DECLARE @LUONGTBPG TABLE (PHG INT, LUONGTB FLOAT)
INSERT INTO @LUONGTBPG
SELECT PHG, AVG(LUONG) AS 'TB'
FROM NHANVIEN
GROUP BY PHG

SELECT TENNV, CHEDO = CASE
					WHEN LUONG< LUONGTB THEN 'TĂNG LƯƠNG'
					WHEN LUONG >LUONGTB THEN 'KHÔNG TĂNG LƯƠNG'
					ELSE 'KHÔNG TĂNG LUONG'
				END
FROM @LUONGTBPG AS LTB, NHANVIEN
WHERE NHANVIEN.PHG =LTB.PHG

/*
Câu 1b-Viết chương trình phân loại nhân viên dựa vào mức lương.
o Nếu lương nhân viên nhỏ hơn trung bình lương mà nhân viên đó đang làm việc thì
xếp loại “nhanvien”, ngược lại xếp loại “truongphong
*/
DECLARE @LUONGTBPG2 TABLE (PHG INT, LUONGTB FLOAT)
INSERT INTO @LUONGTBPG2
SELECT PHG, AVG(LUONG) AS 'TB'
FROM NHANVIEN
GROUP BY PHG

SELECT TENNV, LUONG, LUONGTB, IIF(LUONG<LUONGTB, 'NHÂN VIÊN', 'TRƯỞNG PHÒNG') AS 'CHỨC VỤ'
FROM @LUONGTBPG2 AS LTB, NHANVIEN
WHERE LTB.PHG = NHANVIEN.PHG	

-- Câu1C-Viết chương trình hiển thị TenNV như hình bên dưới, tùy vào cột phái của nhân viên

SELECT TEN = CASE PHAI
				WHEN 'Nam' THEN 'Mr. ' + TENNV
				WHEN 'Nữ' THEN 'Ms. ' +TENNV
				ELSE 'FreeSex. ' + TENNV
			END, PHAI
FROM NHANVIEN

-- caua1d-Viết chương trình tính thuế mà nhân viên phải đóng theo công thứ
SELECT TENNV, LUONG,
THUE = CASE 
			WHEN LUONG BETWEEN 0 AND 25000 THEN LUONG * 0.1
			WHEN LUONG BETWEEN 0 AND 25000 THEN LUONG * 0.12
			WHEN LUONG BETWEEN 0 AND 25000 THEN LUONG * 0.15
			WHEN LUONG BETWEEN 0 AND 25000 THEN LUONG * 0.2
			ELSE LUONG * 0.25
		END
FROM NHANVIEN


-- Bài 2 :Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn
SELECT MANV, TENLOT, TENNV
FROM NHANVIEN
WHERE CONVERT(INT, MANV) % 2 = 0

-- Bài 2 :  Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn nhưng
-- không tính nhân viên có MaNV là 4

SELECT MANV, TENLOT, TENNV
FROM NHANVIEN
WHERE CONVERT(INT, MANV) % 2 = 0 AND CONVERT(INT, MANV) != 4

/* Bài 3: Thực hiện chèn thêm một dòng dữ liệu vào bảng PhongBan theo 2 bước
o Nhận thông báo “ thêm dư lieu thành cong” từ khối Try
o Chèn sai kiểu dữ liệu cột MaPHG để nhận thông báo lỗi “Them dư lieu that bai”
từ khối Catc*/

BEGIN TRY
	INSERT PHONGBAN
	VALUES ('KETOAN',2 ,003,'2020-06-02')
	PRINT 'SUCCESS:RECORD WAS INSERTED.'
END TRY

BEGIN CATCH
	PRINT 'FAILURE: RECORD WAS INSERTED.'
	PRINT 'ERROR' + CONVERT(VARCHAR, ERROR_NUMBER(), 1)
	+ ':' + ERROR_MESSAGE()
END CATCH

-- Bài 3: Viết chương trình khai báo biến @chia, thực hiện phép chia @chia cho số 0 và dùng
-- RAISERROR để thông báo lỗi.

BEGIN TRY
	DECLARE @CHIA INT
	SET @CHIA = 55/0
END TRY
BEGIN CATCH 
	DECLARE 
		@ERMESSAGE NVARCHAR(2048),
		@ERSEVERTY INT,
		@ERSTATE INT
		SELECT 
			@ERMESSAGE = ERROR_MESSAGE(),
			@ERSEVERTY = ERROR_SEVERITY(),
			@ERSTATE = ERROR_STATE()
			RAISERROR(@ERMESSAGE, @ERSEVERTY, @ERSTATE)
END CATCH