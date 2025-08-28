SELECT * 
FROM dim_date

-- bang_fact_final
WITH bang_tam AS (
SELECT d.FullDate, 
    so_hop_dong_dummy AS key_hop_dong_trai_phieu,
    DATEDIFF(DAY,d.FullDate,t.ngay_dao_han) AS ky_han_con_lai,
    ((t.gia_mua * t.so_luong_trai_phieu * t.lai_suat_ban_dau) / 365) * (DATEDIFF(DAY,t.ngay_hop_dong,d.FullDate) + 1 ) AS lai_tich_luy,
    ((t.gia_mua * t.so_luong_trai_phieu * t.lai_suat_ban_dau) / 365) AS lai_trai_phieu,
    (t.gia_mua * t.so_luong_trai_phieu) AS gia_tri_dau_tu
FROM dim_hd_trai_phieu t 
INNER JOIN dim_date d 
ON d.FullDate >= t.ngay_hop_dong
    AND d.FullDate <= t.ngay_dao_han
) 
SELECT bt.FullDate, bt.key_hop_dong_trai_phieu, k.key_ky_han_con_lai, bt.lai_tich_luy, bt.lai_trai_phieu, bt.gia_tri_dau_tu
INTO fact_trai_phieu_uoc_ngay
FROM bang_tam bt
JOIN dim_ki_han_con_lai k 
ON bt.ky_han_con_lai >= k.tu_ngay AND bt.ky_han_con_lai <= k.den_ngay

-- Drop bang fact_trai_phieu
DROP TABLE fact_trai_phieu_uoc_ngay;

--------------
SELECT *
FROM dim_ki_han_con_lai

SELECT
    *,
    d.key_ky_han_goc,
    DATEDIFF(DAY,t.ngay_hop_dong,t.ngay_dao_han) AS ky_han_goc 
FROM dim_hd_trai_phieu t
INNER JOIN dim_ky_han_goc d 
ON DATEDIFF(DAY,t.ngay_hop_dong,t.ngay_dao_han) >= d.tu_ngay
    AND DATEDIFF(DAY,t.ngay_hop_dong,t.ngay_dao_han) <= d.den_ngay

SELECT *
FROM dim_ki_han_con_lai
SELECT *
FROM dim_hd_trai_phieu

SELECT *
FROM dim_date

-- Thêm cột mới vào dim_hd_trai_phieu
ALTER TABLE dim_hd_trai_phieu
ADD key_ky_han_goc INT

-- Cap nhat du lieu vao cot
UPDATE dim_hd_trai_phieu 
SET key_ky_han_goc = d.key_ky_han_goc
FROM dim_hd_trai_phieu t
JOIN dim_ky_han_goc d
ON DATEDIFF(DAY,t.ngay_hop_dong,t.ngay_dao_han) >= d.tu_ngay
    AND DATEDIFF(DAY,t.ngay_hop_dong,t.ngay_dao_han) <= d.den_ngay

-- Xoa cot co gia tri NULL
ALTER TABLE dim_hd_trai_phieu
DROP COLUMN ky_han_goc 

-- Chuyển đổi ngày gửi tiền từ Float => Date
EXEC sp_rename 'dim_hd_trai_phieu.ngay_hop_dong', 'ngay_hop_dong_float', 'COLUMN';
EXEC sp_rename 'dim_hd_trai_phieu.ngay_dao_han', 'ngay_dao_han_float', 'COLUMN';

ALTER TABLE dim_hd_trai_phieu
ADD ngay_hop_dong DATE, ngay_dao_han DATE;
 
UPDATE  dim_hd_trai_phieu
SET ngay_hop_dong = DATEADD(day,CAST(ngay_hop_dong_float as int)-2,0) -- 0 = '1900-01-01',  -2 là vi lịch excel bị lỗi thiếu ngày 29/02/1900

UPDATE  dim_hd_trai_phieu
SET ngay_dao_han = DATEADD(day,CAST(ngay_dao_han_float as int)-2,0)
 



-- Tạo bảng date
CREATE TABLE dim_date (
    DateKey INT PRIMARY KEY,                -- yyyyMMdd
    FullDate DATE,
    Day INT,
    Month INT,
    MonthName NVARCHAR(20),
    Quarter INT,
    Year INT,
    DayOfWeek INT,
    DayOfWeekName NVARCHAR(20),
    WeekOfYear INT,
    IsWeekend BIT
);
 
-- Tạo dữ liệu từ 01/01/2020 đến 31/12/2028 (tuỳ chỉnh khoảng thời gian)
DECLARE @StartDate DATE = '2020-01-01';
DECLARE @EndDate DATE = '2028-12-31';
 
WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO Dim_Date (
        DateKey,
        FullDate,
        Day,
        Month,
        MonthName,
        Quarter,
        Year,
        DayOfWeek,
        DayOfWeekName,
        WeekOfYear,
        IsWeekend
    )
    VALUES (
        CONVERT(INT, FORMAT(@StartDate, 'yyyyMMdd')),
        @StartDate,
        DAY(@StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        DATEPART(QUARTER, @StartDate),
        YEAR(@StartDate),
        DATEPART(WEEKDAY, @StartDate),
        DATENAME(WEEKDAY, @StartDate),
        DATEPART(WEEK, @StartDate),
        CASE WHEN DATENAME(WEEKDAY, @StartDate) IN ('Saturday', 'Sunday') THEN 1 ELSE 0 END
    );
 
    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;

SELECT *
FROM dim_hd_trai_phieu

--- Clean Data bang dim_hd_trai_phieu
-- Cach 1:
SELECT *
FROM dim_hd_trai_phieu
WHERE gia_mua IS NOT NULL

-- Cach 2 (permanantly):
DELETE FROM dim_hd_trai_phieu
WHERE gia_mua IS NULL

--- Clean Data bang dim_tai_san
DELETE FROM dim_tai_san
WHERE Loại_sản_phẩm_lv2_Tên_tiếng_Anh = 'Real Estate'
