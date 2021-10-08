--Dựa vào dữ liệu và diagram của csdl QLDA thực hiện cac truy vấn đơn giản
--sau:


-- 1. Tìm các nhân viên làm việc ở phòng số 4
USE QLDACOM2034

SELECT count(*)
FROM NHANVIEN
where phai like 'Nam'

-- 2. Tìm các nhân viên có mức lương trên 30000
SELECT *FROM NHANVIEN
WHERE LUONG > 30000

-- 3. Tìm các nhân viên có mức lương trên 25,000 ở phòng 4 hoặc các nhân
-- viên có mức lương trên 30,000 ở phòng 5

SELECT *FROM NHANVIEN
WHERE LUONG > 30000 AND PHG = 5

-- 4. Cho biết họ tên đầy đủ của các nhân viên ở TP HCM
SELECT CONCAT(HONV,' ', TENLOT, ' ', TENNV) AS 'FULLNAME'
FROM NHANVIEN
WHERE DCHI LIKE '%Tp HCM%'

--5. Cho biết họ tên đầy đủ của các nhân viên có họ bắt đầu bằng ký tự
--'N'

SELECT CONCAT(HONV,' ', TENLOT, ' ', TENNV) AS 'FULLNAME'
FROM NHANVIEN
WHERE HONV LIKE 'N%'

-- 6. Cho biết ngày sinh và địa chỉ của nhân viên Dinh Ba Tie

SELECT DCHI, NGSINH, CONCAT(HONV,'', TENLOT, '', TENNV) AS 'HOTEN'
FROM NHANVIEN
WHERE CONCAT(HONV,' ', TENLOT, ' ', TENNV) LIKE N'%Đinh% %Bá% Tiên%'

