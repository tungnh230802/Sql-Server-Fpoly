USE LAB2

/*
Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên
tham dự đề án đó
*/

--  Xuất định dạng “tổng số giờ làm việc” kiểu decimal với 2 số thập phân
SELECT TENDA , CAST(SUM(THOIGIAN) AS decimal(5,2)) AS 'TONG SO GIO LAM VIEC'
FROM CONGVIEC CV
INNER JOIN DEAN DA ON CV.MADA = DA.MADA
INNER JOIN PHANCONG PC ON CV.MADA = PC.MADA
GROUP BY TENDA


SELECT TENDA , CONVERT(DECIMAL(5,2), SUM(THOIGIAN)) AS 'TONG SO GIO LAM VIEC'
FROM CONGVIEC CV 
INNER JOIN DEAN DA ON CV.MADA = DA.MADA
INNER JOIN PHANCONG PC ON CV.MADA = PC.MADA
GROUP BY TENDA

-- Xuất định dạng “tổng số giờ làm việc” kiểu varchar

SELECT TENDA , CAST(SUM(THOIGIAN) AS NVARCHAR) AS 'TONG SO GIO LAM VIEC'
FROM CONGVIEC CV 
INNER JOIN DEAN DA ON CV.MADA = DA.MADA
INNER JOIN PHANCONG PC ON CV.MADA = PC.MADA
GROUP BY TENDA


SELECT TENDA , CONVERT(NVARCHAR, SUM(THOIGIAN)) AS 'TONG SO GIO LAM VIEC'
FROM CONGVIEC CV 
INNER JOIN DEAN DA ON CV.MADA = DA.MADA
INNER JOIN PHANCONG PC ON CV.MADA = PC.MADA
GROUP BY TENDA

/*
Với mỗi phòng ban, liệt kê tên phòng ban và lương trung bình của những nhân viên làm
việc cho phòng ban đó
*/

--  Xuất định dạng “luong trung bình” kiểu decimal với 2 số thập phân, sử dụng dấu
-- phẩy để phân biệt phần nguyên và phần thập phân.

SELECT TENPHG, CONVERT(DECIMAL(10,2), AVG(LUONG)) AS 'LUONG TRUNG BINH'
FROM PHONGBAN PB 
INNER JOIN NHANVIEN NV
ON PB.MAPHG = NV.PHG
GROUP BY TENPHG

-- Xuất định dạng “luong trung bình” kiểu varchar. Sử dụng dấu phẩy tách cứ mỗi 3
-- chữ số trong chuỗi ra, gợi ý dùng thêm các hàm Left, Replace

SELECT TENPHG, LEFT(CONVERT(NVARCHAR(10), AVG(LUONG)), 3) +
REPLACE(CONVERT(NVARCHAR(10), AVG(LUONG)), LEFT(CONVERT(NVARCHAR(10), AVG(LUONG)), 3), ',')

AS 'LUONG TRUNG BINH'
FROM PHONGBAN PB 
INNER JOIN NHANVIEN NV
ON PB.MAPHG = NV.PHG
GROUP BY TENPHG

-- Xuất định dạng “tổng số giờ làm việc” với hàm CEILING
SELECT TENDA , CEILING(CONVERT(NVARCHAR, SUM(THOIGIAN))) AS 'TONG SO GIO LAM VIEC'
FROM CONGVIEC CV 
INNER JOIN DEAN DA ON CV.MADA = DA.MADA
INNER JOIN PHANCONG PC ON CV.MADA = PC.MADA
GROUP BY TENDA

-- Xuất định dạng “tổng số giờ làm việc” với hàm FLOOR

SELECT TENDA , FLOOR(CONVERT(NVARCHAR, SUM(THOIGIAN))) AS 'TONG SO GIO LAM VIEC'
FROM CONGVIEC CV 
INNER JOIN DEAN DA ON CV.MADA = DA.MADA
INNER JOIN PHANCONG PC ON CV.MADA = PC.MADA
GROUP BY TENDA

-- Xuất định dạng “tổng số giờ làm việc” làm tròn tới 2 chữ số thập phân


SELECT TENDA , ROUND(CONVERT(NVARCHAR, SUM(THOIGIAN)), 2) AS 'TONG SO GIO LAM VIEC'
FROM CONGVIEC CV 
INNER JOIN DEAN DA ON CV.MADA = DA.MADA
INNER JOIN PHANCONG PC ON CV.MADA = PC.MADA
GROUP BY TENDA

/*
Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương
trung bình (làm tròn đến 2 số thập phân) của phòng "Nghiên cứu"
*/

DECLARE @LUONGTB FLOAT 
SELECT @LUONGTB = ROUND(AVG(LUONG),2)
FROM NHANVIEN NV 
INNER JOIN PHONGBAN PB
ON NV.PHG = PB.MAPHG 
AND TENPHG = N'Nghiên cứu'

SELECT HONV + ' ' + TENLOT + ' ' + TENNV AS 'HO TEN NV', @LUONGTB AS 'LUONGTB'
FROM NHANVIEN 
WHERE LUONG > @LUONGTB

/*
 Danh sách những nhân viên (HONV, TENLOT, TENNV, DCHI) có trên 2 thân nhân,
thỏa các yêu cầu
*/

-- Dữ liệu cột HONV được viết in hoa toàn bộ

SELECT UPPER(HONV) + ' ' + TENLOT + ' ' + TENNV AS 'HO TEN NV' , DIACHI
FROM NHANVIEN NV 
JOIN THANNHAN TN ON NV.MANV = TN.MA_NVIEN
GROUP BY HONV, TENLOT, TENNV, DIACHI
HAVING COUNT(MANV) > 2

-- Dữ liệu cột TENLOT được viết chữ thường toàn bộ
SELECT HONV + ' ' + LOWER(TENLOT) + ' ' + TENNV AS 'HO TEN NV', DIACHI
FROM NHANVIEN NV 
JOIN THANNHAN TN ON NV.MANV = TN.MA_NVIEN
GROUP BY HONV, TENLOT, TENNV, DIACHI
HAVING COUNT(MANV) > 2

-- Dữ liệu chột TENNV có ký tự thứ 2 được viết in hoa, các ký tự còn lại viết
-- thường( ví dụ: kHanh)

SELECT REPLACE(HONV + ' ' + TENLOT + ' ' + TENNV, SUBSTRING(TENLOT,2,1), UPPER(SUBSTRING(TENLOT,2,1)))
as 'HOTEN', DIACHI
FROM NHANVIEN NV 
JOIN THANNHAN TN ON NV.MANV = TN.MA_NVIEN
GROUP BY HONV, TENLOT, TENNV, DIACHI
HAVING COUNT(MANV) > 2

-- Dữ liệu cột DCHI chỉ hiển thị phần tên đường, không hiển thị các thông tin khác
-- như số nhà hay thành phố

SELECT HONV + ' ' + TENLOT + ' ' + TENNV AS 'HO TEN NV',
SUBSTRING(DIACHI, CHARINDEX(' ', DIACHI), CHARINDEX(',',DIACHI) - CHARINDEX(' ', DIACHI)) AS 'DIACHI'
FROM NHANVIEN NV 
JOIN THANNHAN TN ON NV.MANV = TN.MA_NVIEN
GROUP BY HONV, TENLOT, TENNV, DIACHI
HAVING COUNT(MANV) > 2

/*
Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất,
hiển thị thêm một cột thay thế tên trưởng phòng bằng tên “Fpoly”
*/

SELECT TOP 1 TENPHG,TRPHG, NV.TENNV, COUNT(NV.MANV) AS SOLUONG, REPLACE(NV.TENNV,NV.TENNV,'FPOLY') AS 'COT THAY THE HO TEN'
FROM NHANVIEN NV 
INNER JOIN PHONGBAN PB ON NV.MANV = PB.TRPHG
INNER JOIN NHANVIEN NV2 ON NV2.PHG = PB.MAPHG
GROUP BY TENPHG, TRPHG, NV.TENNV
ORDER BY SOLUONG DESC

-- Cho biết các nhân viên có năm sinh trong khoảng 1960 đến 1965.
SELECT MANV, TENNV, CONVERT(DATE,NGSINH) AS 'NG SINH'
FROM NHANVIEN
WHERE YEAR(NGSINH) BETWEEN 1960 AND 1965

-- Cho biết tuổi của các nhân viên tính đến thời điểm hiện tại.

SELECT MANV, TENNV, YEAR(GETDATE()) - YEAR(NGSINH) AS 'TUOI'
FROM NHANVIEN

-- Dựa vào dữ liệu NGSINH, cho biết nhân viên sinh vào thứ mấy.

SELECT MANV, TENNV,  CONVERT(DATE,NGSINH) AS 'NGSINH',
DATENAME(WEEKDAY, NGSINH) AS 'WEEKDAY'
FROM NHANVIEN

-- Cho biết số lượng nhân viên, tên trưởng phòng, ngày nhận chức trưởng phòng và ngày
-- nhận chức trưởng phòng hiển thi theo định dạng dd-mm-yy (ví dụ 25-04-2019)

SELECT COUNT(*) AS 'SL', TENNV, CONVERT(VARCHAR, NG_NHANCHUC, 105) AS 'NGAY NHAN CHUC'
FROM PHONGBAN PB, NHANVIEN NV
WHERE PB.TRPHG = NV.MANV
GROUP BY MANV, TENNV, NG_NHANCHUC