--Create Database BIProjektDW

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'BIProjektDW')
BEGIN 
CREATE DATABASE [BIProjektDW]
END
GO
USE [BIProjektDW]
GO

--Create Fact Sale Table

