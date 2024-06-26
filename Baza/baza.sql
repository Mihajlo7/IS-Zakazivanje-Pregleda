USE [master]
GO
/****** Object:  Database [is_zakazivanje_pregleda]    Script Date: 4/20/2024 12:45:18 PM ******/
CREATE DATABASE [is_zakazivanje_pregleda]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'is_zakazivanje_pregleda', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\is_zakazivanje_pregleda.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'is_zakazivanje_pregleda_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\is_zakazivanje_pregleda_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [is_zakazivanje_pregleda].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET ARITHABORT OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET  DISABLE_BROKER 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET RECOVERY FULL 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET  MULTI_USER 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET DB_CHAINING OFF 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'is_zakazivanje_pregleda', N'ON'
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET QUERY_STORE = ON
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [is_zakazivanje_pregleda]
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateBMI]    Script Date: 4/20/2024 12:45:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CalculateBMI]
(
	@VisinaCM DECIMAL(5,2),
	@Tezina DECIMAL(5,2)
)
RETURNS DECIMAL(5,2)
AS
BEGIN
	DECLARE @BMI DECIMAL(5,2)

	IF @VisinaCM>0 AND @Tezina>0
	BEGIN
		SET @BMI=@Tezina / POWER(@VisinaCM/100,2)
	END
	ELSE
	SET @BMI=NULL
	
	RETURN @BMI
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnMaxVisina]    Script Date: 4/20/2024 12:45:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[fnMaxVisina]()
RETURNS DECIMAL(5,2)
AS
BEGIN
	DECLARE @maxVisina DECIMAL(5,2);
	SELECT @maxVisina = MAX(visina) FROM Osobe;

	RETURN @maxVisina;
END;
GO
/****** Object:  Table [dbo].[Osobe]    Script Date: 4/20/2024 12:45:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Osobe](
	[osoba_id] [uniqueidentifier] NOT NULL,
	[jmbg] [char](13) NULL,
	[ime] [nvarchar](50) NOT NULL,
	[prezime] [nvarchar](50) NOT NULL,
	[visina] [decimal](5, 2) NOT NULL,
	[tezina] [decimal](5, 2) NOT NULL,
	[bmi] [decimal](5, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[osoba_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[jmbg] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[GojazneOsobePrikaz]    Script Date: 4/20/2024 12:45:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[GojazneOsobePrikaz]
AS
SELECT jmbg, ime, prezime, visina, tezina, bmi FROM Osobe WHERE bmi>=30;
GO
/****** Object:  Table [dbo].[Pregledi]    Script Date: 4/20/2024 12:45:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pregledi](
	[pregled_id] [bigint] IDENTITY(1000,1000) NOT NULL,
	[osoba_id] [uniqueidentifier] NOT NULL,
	[ime_doktora] [nvarchar](30) NOT NULL,
	[prezime_doktora] [nvarchar](30) NOT NULL,
	[datum_pregleda] [date] NOT NULL,
	[vreme_pregleda] [time](0) NULL,
PRIMARY KEY CLUSTERED 
(
	[pregled_id] ASC,
	[osoba_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[UrgentniPreglediPrikaz]    Script Date: 4/20/2024 12:45:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[UrgentniPreglediPrikaz]
AS
SELECT t.jmbg "Jmbg Osobe", t.ime "Ime Osobe", t.prezime "Prezime Osobe", p.ime_doktora "Ime Doktora",p.prezime_doktora "Prezime Doktora", p.datum_pregleda "Datum Pregleda", p.vreme_pregleda "Vreme pregleda"
FROM Osobe t INNER JOIN Pregledi p ON(t.osoba_id=p.osoba_id)
WHERE p.datum_pregleda<= DATEADD(MONTH,1,GETDATE());
GO
/****** Object:  UserDefinedFunction [dbo].[fnVratiSvePregledePoJmbg]    Script Date: 4/20/2024 12:45:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fnVratiSvePregledePoJmbg]
(
	@jmbg CHAR(13)
)
RETURNS TABLE
AS
RETURN
(
	SELECT t.pregled_id,t.ime_doktora, t.datum_pregleda, FORMAT(t.vreme_pregleda,'HH:mm') "vreme_pregleda"
	FROM Pregledi t
	WHERE t.osoba_id IN (SELECT osoba_id FROM Osobe o WHERE o.jmbg=@jmbg)
);
GO
/****** Object:  UserDefinedFunction [dbo].[fnUrgentniPregledi]    Script Date: 4/20/2024 12:45:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fnUrgentniPregledi]()
RETURNS TABLE
AS
RETURN
(
	SELECT o.jmbg "JmbgOsobe",o.ime "ImeOsobe", o.prezime "PrezimeOsobe", o.visina "VisinaOsobe", o.tezina "TezinaOsobe", o.bmi "BmiOsobe", 
	p.pregled_id "IdPregleda", p.ime_doktora "ImeDoktora", p.prezime_doktora "PrezimeDoktora", p.datum_pregleda "DatumPregleda", CONVERT(varchar(5),p.vreme_pregleda,108) "VremePregleda"
	FROM Osobe o INNER JOIN Pregledi p ON (o.osoba_id=p.osoba_id)
	WHERE p.datum_pregleda<=DATEADD(MONTH,1,GETDATE())
);
GO
/****** Object:  UserDefinedFunction [dbo].[fnGojazneOsobe]    Script Date: 4/20/2024 12:45:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   function [dbo].[fnGojazneOsobe]()
RETURNS TABLE
AS
RETURN
(	
	select o.osoba_id "osobaId", o.jmbg "jmbg", o.ime "ime", o.prezime "prezime", o.visina "visina",o.tezina "tezina", o.bmi "bmi"
	from Osobe o
	where o.bmi>=30
);
GO
/****** Object:  View [dbo].[viewUrgentniPregledi]    Script Date: 4/20/2024 12:45:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewUrgentniPregledi]
AS
SELECT o.jmbg "JmbgOsobe",o.ime "ImeOsobe", o.prezime "PrezimeOsobe", o.visina "VisinaOsobe", o.tezina "TezinaOsobe", o.bmi "BmiOsobe", 
p.pregled_id "IdPregleda", p.ime_doktora "ImeDoktora", p.prezime_doktora "PrezimeDoktora", p.datum_pregleda "DatumPregleda", CONVERT(varchar(5),p.vreme_pregleda,108) "VremePregleda"
FROM Osobe o INNER JOIN Pregledi p ON (o.osoba_id=p.osoba_id)
WHERE p.datum_pregleda<=DATEADD(MONTH,1,GETDATE());
GO
/****** Object:  View [dbo].[viewGojazneOsobe]    Script Date: 4/20/2024 12:45:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewGojazneOsobe] AS
select o.osoba_id "osobaId", o.jmbg "jmbg", o.ime "ime", o.prezime "prezime", o.visina "visina",o.tezina "tezina", o.bmi "bmi"
	from Osobe o
	where o.bmi>=30;
GO
/****** Object:  Table [dbo].[test]    Script Date: 4/20/2024 12:45:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test](
	[id] [int] NULL,
	[name] [varchar](1) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Osobe] ADD  DEFAULT (newid()) FOR [osoba_id]
GO
ALTER TABLE [dbo].[Pregledi]  WITH CHECK ADD FOREIGN KEY([osoba_id])
REFERENCES [dbo].[Osobe] ([osoba_id])
GO
ALTER TABLE [dbo].[Osobe]  WITH CHECK ADD CHECK  ((len([ime])>(0)))
GO
ALTER TABLE [dbo].[Osobe]  WITH CHECK ADD CHECK  ((len([jmbg])=(13) AND patindex('%[^0-9]%',[jmbg])=(0)))
GO
ALTER TABLE [dbo].[Osobe]  WITH CHECK ADD CHECK  ((len([prezime])>(0)))
GO
ALTER TABLE [dbo].[Osobe]  WITH CHECK ADD  CONSTRAINT [CK_Ime_UpperCase] CHECK  ((case when unicode(left([ime],(1)))>=unicode(N'A') AND unicode(left([ime],(1)))<=unicode(N'Z') then (1) when unicode(left([ime],(1)))=unicode(N'Đ') OR unicode(left([ime],(1)))=unicode(N'Š') OR unicode(left([ime],(1)))=unicode(N'Ć') OR unicode(left([ime],(1)))=unicode(N'Č') then (1) else (0) end=(1)))
GO
ALTER TABLE [dbo].[Osobe] CHECK CONSTRAINT [CK_Ime_UpperCase]
GO
ALTER TABLE [dbo].[Osobe]  WITH CHECK ADD  CONSTRAINT [CK_Prezime_UpperCase] CHECK  ((case when unicode(left([prezime],(1)))>=unicode(N'A') AND unicode(left([prezime],(1)))<=unicode(N'Z') then (1) when unicode(left([prezime],(1)))=unicode(N'Đ') OR unicode(left([prezime],(1)))=unicode(N'Š') OR unicode(left([prezime],(1)))=unicode(N'Ć') OR unicode(left([prezime],(1)))=unicode(N'Č') then (1) else (0) end=(1)))
GO
ALTER TABLE [dbo].[Osobe] CHECK CONSTRAINT [CK_Prezime_UpperCase]
GO
ALTER TABLE [dbo].[Osobe]  WITH CHECK ADD  CONSTRAINT [uppercase_name] CHECK  ((len([ime])>(0) AND upper(left([ime],(1)))=substring([ime],(1),(1))))
GO
ALTER TABLE [dbo].[Osobe] CHECK CONSTRAINT [uppercase_name]
GO
ALTER TABLE [dbo].[Pregledi]  WITH CHECK ADD CHECK  (([datum_pregleda]>getdate()))
GO
ALTER TABLE [dbo].[Pregledi]  WITH CHECK ADD CHECK  ((len([ime_doktora])>(1)))
GO
ALTER TABLE [dbo].[Pregledi]  WITH CHECK ADD CHECK  ((len([prezime_doktora])>(1)))
GO
ALTER TABLE [dbo].[Pregledi]  WITH CHECK ADD  CONSTRAINT [CK_Ime_Doktora_UpperCase] CHECK  ((case when unicode(left([ime_doktora],(1)))>=unicode(N'A') AND unicode(left([ime_doktora],(1)))<=unicode(N'Z') then (1) when unicode(left([ime_doktora],(1)))=unicode(N'Đ') OR unicode(left([ime_doktora],(1)))=unicode(N'Š') OR unicode(left([ime_doktora],(1)))=unicode(N'Ć') OR unicode(left([ime_doktora],(1)))=unicode(N'Č') then (1) else (0) end=(1)))
GO
ALTER TABLE [dbo].[Pregledi] CHECK CONSTRAINT [CK_Ime_Doktora_UpperCase]
GO
ALTER TABLE [dbo].[Pregledi]  WITH CHECK ADD  CONSTRAINT [CK_Prezime_Doktora_UpperCase] CHECK  ((case when unicode(left([prezime_doktora],(1)))>=unicode(N'A') AND unicode(left([prezime_doktora],(1)))<=unicode(N'Z') then (1) when unicode(left([prezime_doktora],(1)))=unicode(N'Đ') OR unicode(left([prezime_doktora],(1)))=unicode(N'Š') OR unicode(left([prezime_doktora],(1)))=unicode(N'Ć') OR unicode(left([prezime_doktora],(1)))=unicode(N'Č') then (1) else (0) end=(1)))
GO
ALTER TABLE [dbo].[Pregledi] CHECK CONSTRAINT [CK_Prezime_Doktora_UpperCase]
GO
/****** Object:  StoredProcedure [dbo].[delPregled]    Script Date: 4/20/2024 12:45:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delPregled]
(
	@jmbg CHAR(13),
	@PregledId BIGINT
)
AS
BEGIN
	DECLARE @osoba_id UNIQUEIDENTIFIER;
	SELECT @osoba_id = osoba_id FROM Osobe WHERE jmbg=@jmbg;
	
	IF @osoba_id IS NULL
	BEGIN
		THROW 70001, 'Osoba sa datim JMBG-om nije pronađena.', 1;
        RETURN;
	END;

	IF NOT EXISTS (SELECT 1 FROM Pregledi WHERE pregled_id=@PregledId)
	BEGIN
		THROW 70002, 'Pregled sa datim ID-om nije pronadjen.', 1;
        RETURN;
	END;

	DELETE FROM Pregledi
	WHERE osoba_id=@osoba_id;

END;
GO
/****** Object:  StoredProcedure [dbo].[insPregled]    Script Date: 4/20/2024 12:45:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insPregled]
(
	@jmbg CHAR(13),
	@ImeDoktora NVARCHAR(30),
	@PrezimeDoktora NVARCHAR(30),
	@DatumPregleda DATE,
	@VremePregleda TIME
)
AS
BEGIN
	DECLARE @osoba_id UNIQUEIDENTIFIER;
	SELECT @osoba_id= osoba_id FROM Osobe WHERE jmbg=@jmbg;
	IF @osoba_id IS NULL
	BEGIN
		THROW 70001, 'Osoba sa datim JMBG-om nije pronađena.', 1;
        RETURN;
	END;
    INSERT INTO Pregledi (osoba_id,ime_doktora,prezime_doktora,datum_pregleda,vreme_pregleda) VALUES (@osoba_id,@ImeDoktora,@PrezimeDoktora,@DatumPregleda,@VremePregleda);
END;
GO
/****** Object:  StoredProcedure [dbo].[updPregled]    Script Date: 4/20/2024 12:45:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[updPregled]
(
	@jmbg CHAR(13),
	@PregledId BIGINT,
	@ImeDoktora NVARCHAR(30),
	@PrezimeDoktora NVARCHAR(30),
	@DatumPregleda DATE,
	@VremePregleda TIME
)
AS
BEGIN
	DECLARE @osoba_id UNIQUEIDENTIFIER;
	SELECT @osoba_id = osoba_id FROM Osobe WHERE jmbg=@jmbg;
	
	IF @osoba_id IS NULL
	BEGIN
		THROW 70001, 'Osoba sa datim JMBG-om nije pronađena.', 1;
        RETURN;
	END;

	IF NOT EXISTS (SELECT 1 FROM Pregledi WHERE pregled_id=@PregledId)
	BEGIN
		THROW 70002, 'Pregled sa datim ID-om nije pronadjen.', 1;
        RETURN;
	END;

	UPDATE Pregledi
    SET ime_doktora = @ImeDoktora,
        prezime_doktora = @PrezimeDoktora,
        datum_pregleda = @DatumPregleda,
        vreme_pregleda = @VremePregleda
    WHERE pregled_id = @PregledId;

END;
GO
USE [master]
GO
ALTER DATABASE [is_zakazivanje_pregleda] SET  READ_WRITE 
GO
