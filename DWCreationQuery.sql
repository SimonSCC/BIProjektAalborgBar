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
	ListedPrice INT,
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
	YearJoined DATE,
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
	DateKey DATE,
	[Year] INT,
	[Quarter] INT,
	[Month] INT,
	[Week] INT,
	WeekDayNumber INT,
	[DayOfWeek] INT,
	IsWeekend BIT,

	PRIMARY KEY (DateKey)
	);
	END

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
	[Name] NVARCHAR(255),
	[Description] NVARCHAR(255),
	

	PRIMARY KEY (RoomKey)
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


--USE MASTER 
--GO

----ALTER DATABASE BiProjektDW 
----SET multi_user WITH ROLLBACK IMMEDIATE
----GO