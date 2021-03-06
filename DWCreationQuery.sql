--Create Database BIProjektDW

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'BIProjektDW')
BEGIN 
CREATE DATABASE [BIProjektDW]
END
GO
USE [BIProjektDW]
GO

--Create Fact Schema

USE BIProjektDW
IF NOT EXISTS(SELECT * FROM sys.schemas WHERE name = 'Fact')
	EXEC('CREATE SCHEMA [Fact]');
ELSE
	PRINT 'Fact schema already Exists!'


--Create Dimension Schema

USE BIProjektDW
IF NOT EXISTS(SELECT * FROM sys.schemas WHERE name = 'Dimension')
	EXEC('CREATE SCHEMA [Dimension]');
ELSE
	PRINT 'Dimension schema already Exists!'

--SELECT * FROM sys.schemas

--DROP SCHEMA Dimension
--DROP SCHEMA Fact

--Create Product Dimension table 

USE BIProjektDW
IF object_id('Dimension.[Product]', 'U') IS NOT NULL
	PRINT 'Product table already created!'
ELSE
	BEGIN 
	PRINT 'Not present! Product table is being created'
	CREATE TABLE Dimension.[Product]
	(
	ProductKey INT IDENTITY(1,1),
	ProductID INT,
	[Name] NVARCHAR(255),
	ListedPrice MONEY,
	Category NVARCHAR(255),
	ValidFrom DATE,
	ValidTo DATE,

	PRIMARY KEY (ProductKey)
	);
	END

--Create Member Dimension table

USE BIProjektDW
IF object_id('Dimension.[Member]', 'U') IS NOT NULL
	PRINT 'Member table already created!'
ELSE
	BEGIN 
	PRINT 'Not present! Member table is being created'
	CREATE TABLE Dimension.[Member]
	(
	MemberKey INT IDENTITY(1,1),
	MemberID INT,
	YearJoined INT,
	Study NVARCHAR(50),
	SemesterPeriod NVARCHAR(50),
	Semester NVARCHAR(50),
	ValidFrom DATE,
	ValidTo DATE,

	PRIMARY KEY (MemberKey)
	);
	END

--Create Time Dimension table

USE BIProjektDW
IF object_id('Dimension.[Time]', 'U') IS NOT NULL
	PRINT 'Time table already created!'
ELSE
	BEGIN 
	PRINT 'Not present! Time table is being created'
	CREATE TABLE Dimension.[Time]
	(
	TimeKey TIME,
	HourOfDay INT,
	MinuteOfDay INT,
	TimeOfDay NVARCHAR(30),

	PRIMARY KEY (TimeKey)
	);
	END

--Create Date Dimension table

USE BIProjektDW
IF object_id('Dimension.[Date]', 'U') IS NOT NULL
    PRINT 'Date table already created!'
ELSE
    BEGIN 
    PRINT 'Not present! Date table is being created'
    CREATE TABLE Dimension.[Date]
    (
    [DateKey] DATE NOT NULL PRIMARY KEY,
    [Day] TinyINT NOT NULL,
    [DaySuffix] CHAR(2) NOT NULL,
    [Weekday] TINYINT NOT NULL,
    [WeekDayName] VARCHAR(10) NOT NULL,
    [WeekDayName_Short] CHAR(3) NOT NULL,
    [WeekDayName_FirstLetter] CHAR(1) NOT NULL,
    [DOWInMonth] TINYINT NOT NULL,
    [DayOfYear] SMALLINT NOT NULL,
    [WeekOfMonth] TINYINT NOT NULL,
    [WeekOfYear] TINYINT NOT NULL,
    [Year] INT NOT NULL,
    [Quarter] TINYINT NOT NULL,
    [Month] TINYINT NOT NULL,
    [MonthName] VARCHAR(10) NOT NULL,
    [MonthName_Short] CHAR(3) NOT NULL,
    [MonthName_FirstLetter] CHAR(1) NOT NULL,
    [QuarterName] VARCHAR(6) NOT NULL,
    [IsWeekend] BIT NOT NULL,
    [MMYYYY] CHAR(6) NOT NULL,
    [MonthYear] CHAR(7) NOT NULL,

    );
    END


--Create Sale Fact table

USE BIProjektDW
IF object_id('Fact.[Sale]', 'U') IS NOT NULL
	PRINT 'Sale table already created!'
ELSE
	BEGIN 
	PRINT 'Not present! Sale table is being created'
	CREATE TABLE Fact.Sale
	(
	SaleKey INT IDENTITY(1,1),
	AlternativeSaleKey INT UNIQUE,
	MemberKey INT,
	ProductKey INT,
	TimeKey TIME,
	DateKey DATE,
	RoomKey INT,
	Price MONEY,
	

	PRIMARY KEY (SaleKey)
	);
END

--Add Fact Constraints to dimension tables.


--Constraint to Dimension.Member

USE BIProjektDW
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_CATALOG = 'BIProjektDW' AND 
CONSTRAINT_NAME = 'FK_Fact_Sale_MemberKey_Dimension_Member_MemberKey')
	BEGIN
		ALTER TABLE Fact.Sale ADD CONSTRAINT FK_Fact_Sale_MemberKey_Dimension_Member_MemberKey FOREIGN KEY (MemberKey)
		REFERENCES Dimension.Member(MemberKey)
	END
ELSE
	PRINT 'FK_Fact_Sale_MemberKey_Dimension_Member_MemberKey constraint already exists!'


--Constraint to Dimension.Date

USE BIProjektDW
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_CATALOG = 'BIProjektDW' AND 
CONSTRAINT_NAME = 'FK_Fact_Sale_DateKey_Dimension_Date_DateKey')
	BEGIN
		ALTER TABLE Fact.Sale ADD CONSTRAINT FK_Fact_Sale_DateKey_Dimension_Date_DateKey FOREIGN KEY (DateKey)
		REFERENCES Dimension.[Date](DateKey)
	END
ELSE
	PRINT 'FK_Fact_Sale_DateKey_Dimension_Date_DateKey constraint already exists!'


--Constraint to Dimension.Time

USE BIProjektDW
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_CATALOG = 'BIProjektDW' AND 
CONSTRAINT_NAME = 'FK_Fact_Sale_TimeKey_Dimension_Time_TimeKey')
	BEGIN
		ALTER TABLE Fact.Sale ADD CONSTRAINT FK_Fact_Sale_TimeKey_Dimension_Time_TimeKey FOREIGN KEY (TimeKey)
		REFERENCES Dimension.[Time](TimeKey)
	END
ELSE
	PRINT 'FK_Fact_Sale_TimeKey_Dimension_Time_TimeKey constraint already exists!'



--Constraint to Dimension.Product

USE BIProjektDW
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_CATALOG = 'BIProjektDW' AND 
CONSTRAINT_NAME = 'FK_Fact_Sale_ProductKey_Dimension_Product_ProductKey')
	BEGIN		
		ALTER TABLE Fact.Sale ADD CONSTRAINT FK_Fact_Sale_ProductKey_Dimension_Product_ProductKey FOREIGN KEY (ProductKey)
		REFERENCES Dimension.Product(ProductKey)
	END
ELSE
	PRINT 'FK_Fact_Sale_ProductKey_Dimension_Product_ProductKey constraint already exists!'

--Drop Everything

USE BIProjektDW
DROP TABLE Fact.Sale

DROP TABLE Dimension.[Product]
DROP TABLE Dimension.[Time]
DROP TABLE Dimension.[Member]
DROP TABLE Dimension.[Date]
DROP TABLE Dimension.[Room]



--OLD ROOM DIMENSION WHICH IS NOW A DEGENERATE DIMENSION REVERSED AGAIN. ONLY INT Values CAN BE IN A FACT. DET ER HURTIGERE

--Create Room Dimension table

USE BIProjektDW
IF object_id('Dimension.[Room]', 'U') IS NOT NULL
	PRINT 'Room table already created!'
ELSE
	BEGIN 
	PRINT 'Not present! Room table is being created'
	CREATE TABLE Dimension.[Room]
	(
	RoomKey INT IDENTITY(1,1),
	RoomName NVARCHAR(255),
	

	PRIMARY KEY (RoomKey)
	);
	END

--Constraint to Dimension.Room

USE BIProjektDW
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_CATALOG = 'BIProjektDW' AND 
CONSTRAINT_NAME = 'FK_Fact_Sale_RoomKey_Dimension_Room_RoomKey')
	BEGIN		
		ALTER TABLE Fact.Sale ADD CONSTRAINT FK_Fact_Sale_RoomKey_Dimension_Room_RoomKey FOREIGN KEY (RoomKey)
		REFERENCES Dimension.[Room](RoomKey)
	END
ELSE
	PRINT 'FK_Fact_Sale_RoomKey_Dimension_Room_RoomKey constraint already exists!'





	--TESTS

SELECT * FROM Dimension.Product
SELECT * FROM Dimension.[Date]
SELECT * FROM Dimension.[Time]
SELECT * FROM Dimension.Member
SELECT * FROM Fact.Sale



--Errors in the OLAP storage engine: A duplicate attribute key has been found when processing: 
--Table: 'Dimension_Date', Column: 'Weekday', Value: '2'; Table: 'Dimension_Date', 
--Column: 'WeekOfMonth', Value: '4'; Table: 'Dimension_Date', Column: 'Month', Value: '1'; 
--Table: 'Dimension_Date', Column: 'Quarter', Value: '1'; Table: 'Dimension_Date', Column: 'Year', Value: '2002'. The attribute is 'Weekday'.
SELECT * FROM Dimension.[Date] Where WeekOfMonth = 4 AND [YEAR] = 2002 AND [Quarter] = 1 AND [MONTH] = 1 AND [WeekDay] = 2

--Gammel date
--USE BIProjektDW
--IF object_id('Dimension.[Date]', 'U') IS NOT NULL
--	PRINT 'Date table already created!'
--ELSE
--	BEGIN 
--	PRINT 'Not present! Date table is being created'
--	CREATE TABLE Dimension.[Date]
--	(
--	DateKey DATE,
--	[Year] INT,
--	[Quarter] INT,
--	[Month] INT,
--	[Week] INT,
--	WeekDayNumber INT,
--	[DayOfWeek] NVARCHAR(55),
--	IsWeekend BIT,

--	PRIMARY KEY (DateKey)
--	);
--	END
	--USE MASTER 
--GO

----ALTER DATABASE BiProjektDW 
----SET multi_user WITH ROLLBACK IMMEDIATE
----GO
--SELECT * FROM Dimension.Product
--INSERT INTO Dimension.Product(ProductID, [Name], ListedPrice, Category)
--VALUES (99, 'poo', 6.55, 'CoolStuff');

--SELECT ListedPrice from Dimension.Product



 -- SELECT * FROM Dimension.[Time] where TimeKey = '14:11'
 --DELETE FROM Dimension.[Time] where TimeKey = '12:10:00.0000000'



 --SELECT * FROM Fact.Sale WHERE TimeKey = '12:10'

 --6237

  --SELECT * FROm Dimension.Member WHE

-- Truncate and add member to handle null references 
--  USE BIProjektDW;
--ALTER TABLE Fact.Sale
--DROP CONSTRAINT FK_Fact_Sale_MemberKey_Dimension_Member_MemberKey;
--TRUNCATE TABLE Dimension.Member;
--  ALTER TABLE Fact.Sale ADD CONSTRAINT FK_Fact_Sale_MemberKey_Dimension_Member_MemberKey FOREIGN KEY (MemberKey)
--  REFERENCES Dimension.[Member](MemberKey)


--INSERT INTO Dimension.Member (MemberID, YearJoined, SemesterPeriod, Semester, Study, ValidFROM)
--VALUES (0, 0, 'NoSemesterPeriod', 'NoSemester', 'NoStudy', '1990-01-01');


USE BIProjektDW;
--SELECT * FROM  Dimension.Member
--select * FROM Dimension.Product
 
-- SELECT * FROM Dimension.[Time]

-- --Check function if the results of the cube is true
--SELECT * FROM Dimension.[Time] inner join Fact.Sale ON Dimension.[Time].TimeKey=Fact.Sale.TimeKey WHERE HourOfDay = 5 AND MinuteOfDay = 0
----SUM(price)

--SELECT SUM(price) FROM Dimension.[Product] inner join Fact.Sale ON Dimension.[Product].ProductKey = Fact.Sale.ProductKey WHERE ProductID = 11

--SELECT * FROm Dimension.[Time]

----Minute
--SELECT 
--DISTINCT
--[Dimension_Time].[MinuteOfDay] AS [Dimension_TimeMinuteOfDay0_0],[Dimension_Time].[HourOfDay] AS [Dimension_TimeHourOfDay0_1]
--FROM [Dimension].[Time] AS [Dimension_Time]


----Hour
--SELECT 
--DISTINCT
--[Dimension_Time].[HourOfDay] AS [Dimension_TimeHourOfDay0_0],[Dimension_Time].[TimeOfDay] AS [Dimension_TimeTimeOfDay0_1]
--FROM [Dimension].[Time] AS [Dimension_Time]


  --Trauncate Product 
-- USE BIProjektDW;
--ALTER TABLE Fact.Sale
--DROP CONSTRAINT FK_Fact_Sale_ProductKey_Dimension_Product_ProductKey;
--TRUNCATE TABLE Dimension.Product;
--  ALTER TABLE Fact.Sale ADD CONSTRAINT FK_Fact_Sale_ProductKey_Dimension_Product_ProductKey FOREIGN KEY (ProductKey)
--  REFERENCES Dimension.Product(ProductKey)

 --Truncate Room
-- USE BIProjektDW;
--ALTER TABLE Fact.Sale
--DROP CONSTRAINT FK_Fact_Sale_RoomKey_Dimension_Room_RoomKey;
--TRUNCATE TABLE Dimension.Room;
--  ALTER TABLE Fact.Sale ADD CONSTRAINT FK_Fact_Sale_RoomKey_Dimension_Room_RoomKey FOREIGN KEY (RoomKey)
--  REFERENCES Dimension.Room(RoomKey)


--Test Member

Use BIProjektDW
SELECT * FROm Dimension.Member where MemberID = 1175

SELECT * FROm Dimension.Member where MemberID = 1222 
--Fejlen her er at semestret vare et ?r, s? der pr?ves at pege p? et period som ikke er der. 
--Salget er F98 men brugeren er startet E98 og det n?ste semester starter f?rstom et ?r.
--L?sning m?ske v?re at 

SELECT * FROm Dimension.Member where MemberID = 864 
--Fejlen er er en fejl?


SELECT * FROm Dimension.Member where MemberID = 1132 


SELECT * FROm Dimension.Member where MemberID = 979 

SELECT * FROm Dimension.Member where MemberID = 191 


SELECT * FROm Dimension.Member where MemberID = 1152

SELECT * FROm Dimension.Member where MemberID = 1040 









select * from Dimension.member


SELECT * FROM Fact.Sale

SELECT * FROM Fact.Sale inner join Dimension.Member ON Fact.Sale.MemberKey = Dimension.Member.MemberKey WHERE MemberId = 864


SELECT * FROM Fact.Sale inner join Dimension.Member ON Fact.Sale.MemberKey = Dimension.Member.MemberKey WHERE MemberId = 1154

SELECT * FROM Fact.Sale inner join Dimension.Member ON Fact.Sale.MemberKey = Dimension.Member.MemberKey WHERE MemberId = 1025

SELECT * FROM Fact.Sale inner join Dimension.Member ON Fact.Sale.MemberKey = Dimension.Member.MemberKey WHERE MemberId = 1175

SELECT * FROM Fact.Sale inner join Dimension.Member ON Fact.Sale.MemberKey = Dimension.Member.MemberKey WHERE MemberId = 1048


SELECT * FROm Dimension.Member where MemberID = 1048 


--Hirakier
--  ? F7 Kan fortolke resultater fra line?r/logistisk/Cox-regressionsanalyse, samt diskutere konsekvenser af analysens forudsigelser
--  K1 Kan selvst?ndigt gennemf?re en struktureret litteraturs?gning med tilh?rende kritisk analyse og vurdering
--af epidemiologiske studier publiceret i internationale tidsskrifter med inddragelse af relevante videnskabeligguidelines og checklister
--? K2 Kan vurdere graden af evidens for forebyggende og sundhedsfremmende tiltag
--? K3 Kan planl?gge og gennemf?re basale, relevante statistiske beregninger i relation til hypotesetestning

--Mat
--Inf
--Dat
--Dat/Inf
--F7D
--F7SE
--F9SE
--F9D
--F10D
--F6SE
--F8SE
--F10SE
--F6S
--F8S
--KDE3
--F9S
--SSE3
--KDE3
--F7S
--F8D



--Mat
	--Mat1
		-- F99 
			-- 1154
			-- 2562
		-- F22 
			-- 1154


--Study
--Mat
--Dat
--Inf
--Dat/Inf
--Andet