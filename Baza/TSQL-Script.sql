-- Database creation
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Appointment_db')
BEGIN
	CREATE DATABASE Appointment_db
END;
GO
---
-- Set TrustingWorty
--USE master;
--GO

--ALTER DATABASE Appointment_db SET TRUSTWORTHY ON;
------
-- Use Appointment db

USE Appointment_db;
GO
-- Set latin language and date 
ALTER DATABASE Appointment_db SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

ALTER DATABASE Appointment_db COLLATE Serbian_Latin_100_CI_AS;
GO

ALTER DATABASE Appointment_db SET MULTI_USER
GO

-- TABLE Persons ---
CREATE TABLE Persons(
Person_id UNIQUEIDENTIFIER PRIMARY KEY,
JMBG CHAR(13) UNIQUE CHECK(LEN(JMBG)=13),
First_Name NVARCHAR(30) NOT NULL CHECK(First_Name LIKE '[A-Š]%' AND LEN(First_Name)>=2),
Last_Name NVARCHAR(30) NOT NULL CHECK(Last_Name LIKE '[A-Š]%' AND LEN(Last_Name)>=2),
Weight_KG DECIMAL(5,2) NOT NULL,
Height_CM DECIMAL(5,2) NOT NULL,
BMI DECIMAL(5,2)
);
GO

ALTER TABLE Persons ADD CONSTRAINT JMBG_UNIQUE UNIQUE(JMBG);

-- Constraints for weight and height

ALTER TABLE Persons ADD CONSTRAINT Weight_CONS CHECK(Weight_KG BETWEEN 15 AND 500);
ALTER TABLE Persons ADD CONSTRAINT Height_CONS CHECK(Height_CM BETWEEN 30 AND 400);

-- TABLE Appointment ---
CREATE TABLE Appointments(
Appointment_id UNIQUEIDENTIFIER,
Person_id UNIQUEIDENTIFIER,
First_Name_Doctor NVARCHAR(30) NOT NULL CHECK(First_Name_Doctor LIKE '[A-Š]%' AND LEN(First_Name_Doctor)>=2),
Last_Name_Doctor NVARCHAR(30) NOT NULL CHECK(Last_Name_Doctor LIKE '[A-Š]%' AND LEN(Last_Name_Doctor)>=2),
Date_Appointment DATE NOT NULL CHECK(Date_Appointment> GETDATE()),
Time_Appointment TIME(0) NOT NULL,
PRIMARY KEY (Appointment_id,Person_id),
FOREIGN KEY (Person_id) REFERENCES Persons(Person_id)
);
GO

--EXEC sp_rename 'Appointment', 'Appointments';

-- Function for Calculating BMI
CREATE OR ALTER FUNCTION fnCalculateBMI
(
	@Height DECIMAL(5,2),
	@Weight DECIMAL(5,2)
)
RETURNS DECIMAL(5,2)
BEGIN
	DECLARE @Bmi DECIMAL(5,2);
	IF (@Height BETWEEN 30 AND 400) AND (@Weight BETWEEN 15 AND 500)
	BEGIN
		SET @Bmi= @Weight/ POWER(@Height/100,2);
	END
	ELSE
		SET @Bmi=-1; 

	RETURN @Bmi;
END;
GO

-- Creating trigger for BMI --
CREATE OR ALTER TRIGGER trg_Calculate_BMI
ON Persons
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @Person_id UNIQUEIDENTIFIER;
	DECLARE @Bmi DECIMAL(5,2);
	DECLARE @Weight DECIMAL(5,2);
	DECLARE @Height DECIMAL(5,2);

	SELECT @Person_id=Person_id, @Height=Height_CM, @Weight=Weight_KG FROM inserted;

	SET @Bmi=dbo.fnCalculateBMI(@Height,@Weight);

	IF @Bmi=-1
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 51001,'Incorrect range: Wieght should be between 15 and 500 kg, and height should be between 30 and 400',1;
	END

	UPDATE Persons
	SET BMI=@Bmi
	WHERE Person_id=@Person_id;
END;

-- Creating view for emergency appointments

CREATE VIEW view_Emergency_Appointments
AS
SELECT p.Person_id PersonId,p.JMBG "JMBG", p.First_Name "FirstName", p.Last_Name "LastName", p.Height_CM "Height",p.Weight_KG "Weight", p.BMI "BMI", 
a.Appointment_id "AppointmentId", a.First_Name_Doctor "DoctorFirstName", p.Last_Name "DoctorLastName",a.Date_Appointment "DateAppointment",a.Time_Appointment "TimeAppointment"
FROM Persons p INNER JOIN Appointments a ON (p.Person_id=a.Person_id)
WHERE a.Date_Appointment<=DATEADD(MONTH,1,GETDATE());

-- Creating function for emergency appointements

CREATE OR ALTER FUNCTION fn_Emergency_Appointments()
RETURNS TABLE
AS
RETURN
(
	SELECT p.Person_id PersonId,p.JMBG "JMBG", p.First_Name "FirstName", p.Last_Name "LastName", p.Height_CM "Height",p.Weight_KG "Weight", p.BMI "BMI", 
	a.Appointment_id "AppointmentId", a.First_Name_Doctor "DoctorFirstName", p.Last_Name "DoctorLastName",a.Date_Appointment "DateAppointment",a.Time_Appointment "TimeAppointment"
	FROM Persons p INNER JOIN Appointments a ON (p.Person_id=a.Person_id)
	WHERE a.Date_Appointment<=DATEADD(MONTH,1,GETDATE())
);

-- Creating view for overweight

CREATE VIEW view_Overweight_People
AS
SELECT p.Person_id PersonId, p.JMBG "JMBG", p.First_Name "FirstName", p.Last_Name "LastName", p.Height_CM "Height", p.Weight_KG "Weight", p.BMI "BMI" FROM Persons p
WHERE p.BMI>=30;
GO

-- Creating function for overweight

CREATE OR ALTER FUNCTION fn_Overweight_People()
RETURNS TABLE
AS
RETURN
(
	SELECT p.Person_id PersonId, p.JMBG "JMBG", p.First_Name "FirstName", p.Last_Name "LastName", p.Height_CM "Height", p.Weight_KG "Weight", p.BMI "BMI" FROM Persons p
	WHERE p.BMI>=30
);
GO

-- Creating function for geting max height

CREATE OR ALTER FUNCTION fn_Max_Height()
RETURNS DECIMAL(5,2)
AS
BEGIN
	DECLARE @MaxHeight DECIMAL(5,2);
	SELECT @MaxHeight= MAX(p.Height_CM) FROM Persons p;
	RETURN @MaxHeight;
END;
GO

-- Function return all appointments for jmbg ---

CREATE OR ALTER FUNCTION fn_GetAllAppointments_ByJMBG
(
	 @Jmbg CHAR(13)
)
RETURNS TABLE
AS
RETURN
(
	SELECT p.Person_id PersonId,p.JMBG "JMBG", p.First_Name "FirstName", p.Last_Name "LastName", p.Height_CM "Height",p.Weight_KG "Weight", p.BMI "BMI", 
	a.Appointment_id "AppointmentId", a.First_Name_Doctor "DoctorFirstName", p.Last_Name "DoctorLastName",a.Date_Appointment "DateAppointment",a.Time_Appointment "TimeAppointment"
	FROM Persons p INNER JOIN Appointments a ON (p.Person_id=a.Person_id)
	WHERE p.JMBG=@Jmbg
);

GO

-- Creating procedure for insert Appointment

CREATE OR ALTER PROCEDURE ins_Appointment
(
	@Jmbg CHAR(13),
	@DoctorFirstName NVARCHAR(30),
	@DoctorLastName NVARCHAR(30),
	@DateAppointment DATE,
	@TimeAppointment TIME
)
AS
BEGIN
	DECLARE @PersonId UNIQUEIDENTIFIER;
	SELECT @PersonId= p.Person_id FROM Persons p WHERE p.JMBG=@Jmbg

	IF @PersonId IS NULL
	BEGIN
		THROW 70001, 'Person with this JMBG has not found!',1;
		RETURN;
	END;
	INSERT INTO Appointments(Person_id,Appointment_id,First_Name_Doctor,Last_Name_Doctor,Date_Appointment,Time_Appointment)
	VALUES (@PersonId,NEWID(),@DoctorFirstName,@DoctorLastName,@DateAppointment,@TimeAppointment);
END;

GO

-- Creating procedure for update Appointment

CREATE OR ALTER PROCEDURE upd_Appointment
(
	@Jmbg CHAR(13),
	@AppointmentId UNIQUEIDENTIFIER,
	@DoctorFirstName NVARCHAR(30),
	@DoctorLastName NVARCHAR(30),
	@DateAppointment DATE,
	@TimeAppointment TIME
)AS
BEGIN
	DECLARE @Personid UNIQUEIDENTIFIER;
	SELECT @PersonId= p.Person_id FROM Persons p WHERE p.JMBG=@Jmbg

	IF @PersonId IS NULL
	BEGIN
		THROW 70001, 'Person with this JMBG has not found!',1;
		RETURN;
	END;

	IF NOT EXISTS (SELECT 1 FROM Appointments a WHERE a.Appointment_id=@AppointmentId)
	BEGIN
		THROW 70002, 'Appointment with this id has not found!',1;
		RETURN;
	END;

	UPDATE Appointments
	SET 
	First_Name_Doctor=@DoctorFirstName,
	Last_Name_Doctor=@DoctorLastName,
	Date_Appointment=@DateAppointment,
	Time_Appointment=@TimeAppointment
	WHERE Appointment_id=@AppointmentId;

END;

-- Creating procedure for delete Appointment

CREATE OR ALTER PROCEDURE del_Appointment
(
	@Jmbg CHAR(13),
	@AppointmentId UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @Personid UNIQUEIDENTIFIER;
	SELECT @PersonId= p.Person_id FROM Persons p WHERE p.JMBG=@Jmbg

	IF @PersonId IS NULL
	BEGIN
		THROW 70001, 'Person with this JMBG has not found!',1;
		RETURN;
	END;

	IF NOT EXISTS (SELECT 1 FROM Appointments a WHERE a.Appointment_id=@AppointmentId)
	BEGIN
		THROW 70002, 'Appointment with this id has not found!',1;
		RETURN;
	END;

	DELETE FROM Appointments WHERE Appointment_id=@AppointmentId AND Person_id=@Personid;
END;

