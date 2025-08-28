# Bond Portfolio Database Design & Analysis

A comprehensive SQL-based database system for managing and analyzing bond investment portfolios, featuring dimensional data modeling, financial calculations, and automated reporting capabilities.

## 🎯 Project Overview

This project demonstrates advanced database design and financial analysis skills through the implementation of a complete bond portfolio management system. The database architecture supports real-time portfolio valuation, maturity tracking, and comprehensive risk assessment for investment decision-making.

## 🛠️ Technologies & Skills

- **Database Management:** SQL Server, T-SQL
- **Data Modeling:** Dimensional modeling, Star schema design
- **Financial Analysis:** Interest calculations, maturity tracking, portfolio valuation
- **Data Engineering:** ETL processes, data cleaning, schema optimization
- **Advanced SQL:** CTEs, Window functions, Stored procedures, Complex joins

## 📊 Database Architecture

### Core Tables
- **`dim_date`** - Comprehensive date dimension (2020-2028)
- **`dim_hd_trai_phieu`** - Bond contract master data
- **`dim_ki_han_con_lai`** - Remaining maturity periods
- **`dim_ky_han_goc`** - Original maturity classifications
- **`fact_trai_phieu_uoc_ngay`** - Daily bond valuation fact table

### Key Relationships
```sql
dim_hd_trai_phieu → fact_trai_phieu_uoc_ngay (1:many)
dim_date → fact_trai_phieu_uoc_ngay (1:many)
dim_ki_han_con_lai → fact_trai_phieu_uoc_ngay (1:many)
```

## 🔍 Key Features

### 1. Automated Date Dimension
- **Comprehensive date attributes** including day, month, quarter, year
- **Weekend identification** using conditional logic
- **Time period calculations** with DATEDIFF functions
- **Flexible date range** (2020-2028) with easy extensibility

### 2. Financial Calculations Engine
```sql
-- Daily accumulated interest calculation
((t.gia_mua * t.so_luong_trai_phieu * t.lai_suat_ban_dau) / 365) * 
(DATEDIFF(DAY,t.ngay_hop_dong,d.FullDate) + 1 ) AS lai_tich_luy
```

- **Accumulated interest tracking** with daily precision
- **Investment value calculations** based on purchase price and quantity
- **Maturity period analysis** using date arithmetic

### 3. Advanced Data Transformation
- **Excel-to-SQL date conversion** handling calendar discrepancies
- **Dynamic schema modifications** using ALTER TABLE operations
- **Automated data population** with UPDATE/JOIN combinations
- **Data type conversions** using CAST/CONVERT functions

### 4. Portfolio Analytics
- **Maturity bucketing** with range-based classifications
- **Daily portfolio valuation** through fact table aggregations  
- **Bond performance tracking** across multiple time horizons
- **Risk assessment** through maturity distribution analysis

## 📁 Project Structure

```
bond-portfolio-database/
├── bond_portfolio_project.sql    # Main SQL implementation
├── README.md                      # Project documentation
└── docs/
    ├── database_schema.md         # Detailed schema documentation
    └── financial_formulas.md      # Calculation methodologies
```

## 🚀 Implementation Highlights

### Complex CTE Implementation
```sql
WITH bang_tam AS (
    SELECT d.FullDate, 
        so_hop_dong_dummy AS key_hop_dong_trai_phieu,
        DATEDIFF(DAY,d.FullDate,t.ngay_dao_han) AS ky_han_con_lai,
        -- Financial calculations...
    FROM dim_hd_trai_phieu t 
    INNER JOIN dim_date d ON d.FullDate >= t.ngay_hop_dong
        AND d.FullDate <= t.ngay_dao_han
)
```

### Automated Table Population
```sql
WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO Dim_Date (DateKey, FullDate, Day, Month, ...)
    VALUES (CONVERT(INT, FORMAT(@StartDate, 'yyyyMMdd')), ...)
    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
```

## 🎯 Business Value

- **Real-time portfolio valuation** enabling timely investment decisions
- **Automated maturity tracking** reducing manual oversight requirements
- **Comprehensive risk assessment** through maturity distribution analysis
- **Scalable architecture** supporting portfolio growth and complexity
- **Data quality assurance** through systematic cleaning procedures

## 🔧 Technical Skills Demonstrated

### Database Design
- Dimensional modeling with fact/dimension tables
- Primary key and foreign key constraint implementation
- Index optimization for query performance
- Schema evolution and migration strategies

### Advanced SQL Techniques
- Common Table Expressions (CTEs) for complex data processing
- Window functions for analytical calculations
- Stored procedure development for automation
- Dynamic SQL for flexible reporting

### Data Engineering
- ETL pipeline development using pure SQL
- Data type conversions and format standardization  
- Automated data quality validation
- Performance optimization through proper indexing

## 📈 Future Enhancements

- **Performance Analytics Dashboard** with visualization components
- **Risk Metrics Calculation** including duration and convexity
- **Automated Alerting System** for maturity and performance thresholds
- **Integration with Market Data APIs** for real-time pricing
- **Advanced Reporting Module** with parameterized queries

## 🎓 Learning Outcomes

This project demonstrates proficiency in:
- **Financial Database Design** for investment management systems
- **Complex SQL Development** with advanced analytical functions
- **Data Modeling** using dimensional modeling principles
- **Automated Data Processing** through procedural SQL techniques
- **Portfolio Management Concepts** applied to database design

---

*This project showcases advanced SQL skills essential for roles in financial technology, investment management, and data engineering within the financial services sector.*
