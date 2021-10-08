use lab2

select 100 * .5

select GETDATE();

select 'Today is ' + GETDATE();

select 'Today is ' + cast(GETDATE() AS NVARCHAR)
-------------------------
select  CAST('123.4' as decimal) as 'Decimal',
		CAST(123 as decimal(6,2)) as 'Decimal(6,2)',
		CAST(2.78128 as integer) as 'integer',
		CAST('05/25/2020' as datetime) as 'datetime',
		CAST('123' as int) as 'Int'

--------- Chuyen doi tuong minh ---------------------
select 50/100

select 50/CAST(100 as float)
----------
select luong,
CAST(luong as int) as 'IntLuong',
CAST(luong as varchar) as 'VarcharLuong'
from NHANVIEN

--- so sanh Cast va Convert
SELECT 'Today''s date is' + CAST(GETDATE() as varchar)

SELECT 'Today''s date is ' + CONVERT(VARCHAR, GETDATE(), 101)
---------------

SELECT NGSINH,
CAST(NGSINH as varchar) as 'VarcharDate',
CONVERT(Varchar, NGSINH, 103) as 'dd/mm/yyyy',
CONVERT(Varchar, NGSINH, 101) as 'mm/dd/yyyy',
CONVERT(Varchar, NGSINH, 105) as 'dd-mm-yyyy',
CONVERT(Varchar, NGSINH, 110) as 'mm-dd-yyyy'
FROM NHANVIEN

--------Cac ham toan hoc --------
select PI() as 'PI'

select sqrt(9) as 'Can bac 2'

select square(4) as 'Binh phuong'
-----------------
select ROUND(5.153745,0) 

select ROUND(5.153745,1) 

select abs(-10)
----
select luong, ABS(luong - 31000) MucDoChenhLech_usd
from nhanvien
order by MucDoChenhLech_usd

-----------Cac ham xu ly chuoi -------
select charindex('Se','SQL Server') as 'Vi tri'

declare @fullname varchar(25)
set  @fullname = 'www.poly.edu.vn'
select substring(@fullname,5,4)

-----
select REPLACE('0973.456.226','.','-')

select LOWER('LE VAN TEO')
select UPPER('nguyen thi gai')
select reverse('12345')

select HoNV, upper(TENLOT) from NhanVien
---------
-----------DB Examples -------------------
SELECT  *  FROM StringSample
ORDER BY ID 

SELECT  *  FROM StringSample
ORDER  BY CAST(ID AS int) 

-- select * from NHANVIEN
-- ORDER BY MANV
------------------------------------------
select Name, CHARINDEX(' ', Name) 
from StringSample

select Name,LEFT(name,CHARINDEX(' ', Name) - 1) from StringSample

SELECT	Name,
    	LEFT(Name, CHARINDEX(' ', Name) - 1)	         AS First,
    	RIGHT(Name, LEN(Name) - CHARINDEX(' ', Name) )    AS Last
FROM  StringSample
-------------------------
--------- Bai tap cat chuoi ho ten ---
declare @st as nvarchar(20)
set @st='Le Van teo'
select LEFT(@st,2)
select RIGHT(@st,len(@st) - charindex(' ',@st))
select substring(@st,charindex(' ',@st)+1,charindex(' ',@st,charindex(' ',@st)+1)-charindex(' ',@st)) 

----------Cac ham ngay thang nam -------
SELECT GETDATE()

SELECT CONVERT(date,GETDATE())

SELECT CONVERT(time,GETDATE())

SELECT year(GETDATE()) as year, month(GETDATE()) as month, day(GETDATE()) as day
--------------------------

SELECT DATENAME(year, GETDATE()) as 'Year',
	   DATENAME(month, GETDATE()) as 'Month',
	   DATENAME(day, GETDATE()) as 'Day',
	   DATENAME(week, GETDATE()) as 'Week',
	   DATENAME(dayofyear, GETDATE()) as 'DayOfYear',   
	   DATENAME(weekday, GETDATE()) as 'WEEKDAY'

------------
SELECT	MaNV,HoTen,
    	LEFT(HoTen, CHARINDEX(' ', HoTen) - 1)	         AS Ho,		
		left(RIGHT(HoTen, LEN(HoTen) - CHARINDEX(' ', HoTen)),CHARINDEX(' ',RIGHT(HoTen, LEN(HoTen) - CHARINDEX(' ', HoTen)) ) - 1) AS Middle,
		right(RIGHT(HoTen, LEN(HoTen) - CHARINDEX(' ', HoTen)),LEN(RIGHT(HoTen, LEN(HoTen) - CHARINDEX(' ', HoTen))) - CHARINDEX(' ', RIGHT(HoTen, LEN(HoTen) - CHARINDEX(' ', HoTen)))) as 'Ten'
FROM  NhanVien2
order by Ten 

select * from NhanVien


