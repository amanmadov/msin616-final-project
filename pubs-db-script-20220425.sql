/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2019 (15.0.2000)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2019
    Target Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Target Database Engine Type : Standalone SQL Server
*/
USE [master]
GO
/****** Object:  Database [pubs]    Script Date: 4/24/2022 7:57:09 PM ******/
CREATE DATABASE [pubs]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'pubs', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\pubs.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'pubs_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\pubs_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [pubs] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [pubs].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [pubs] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [pubs] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [pubs] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [pubs] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [pubs] SET ARITHABORT OFF 
GO
ALTER DATABASE [pubs] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [pubs] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [pubs] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [pubs] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [pubs] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [pubs] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [pubs] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [pubs] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [pubs] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [pubs] SET  DISABLE_BROKER 
GO
ALTER DATABASE [pubs] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [pubs] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [pubs] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [pubs] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [pubs] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [pubs] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [pubs] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [pubs] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [pubs] SET  MULTI_USER 
GO
ALTER DATABASE [pubs] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [pubs] SET DB_CHAINING OFF 
GO
ALTER DATABASE [pubs] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [pubs] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [pubs] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [pubs] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'pubs', N'ON'
GO
ALTER DATABASE [pubs] SET QUERY_STORE = OFF
GO
USE [pubs]
GO
/****** Object:  Schema [Audit]    Script Date: 4/24/2022 7:57:09 PM ******/
CREATE SCHEMA [Audit]
GO
/****** Object:  UserDefinedDataType [dbo].[empid]    Script Date: 4/24/2022 7:57:09 PM ******/
CREATE TYPE [dbo].[empid] FROM [char](9) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[id]    Script Date: 4/24/2022 7:57:09 PM ******/
CREATE TYPE [dbo].[id] FROM [varchar](11) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tid]    Script Date: 4/24/2022 7:57:09 PM ******/
CREATE TYPE [dbo].[tid] FROM [varchar](6) NOT NULL
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GenerateFirstName]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_GenerateFirstName]()
RETURNS VARCHAR(100) AS
BEGIN
    DECLARE @fname VARCHAR(100)
    SET @fname = 
                    (
                        SELECT TOP 1 p.FirstName 
                        FROM AdventureWorks.Person.Person p  
                        ORDER BY (SELECT id FROM dbo.view_NewID)
                    )
    RETURN @fname
END;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GenerateLastName]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_GenerateLastName]()
RETURNS VARCHAR(100) AS
BEGIN
    DECLARE @lname VARCHAR(100)
    SET @lname = 
                    (
                        SELECT TOP 1 p.LastName 
                        FROM AdventureWorks.Person.Person p  
                        ORDER BY (SELECT id FROM dbo.view_NewID)
                    )
    RETURN @lname
END;



GO
/****** Object:  UserDefinedFunction [dbo].[fn_GenerateRandomAddress]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_GenerateRandomAddress]()
RETURNS VARCHAR(200) AS
BEGIN
    DECLARE @address VARCHAR(200)
    SET @address = 
                    (
                        SELECT TOP 1 ad.AddressLine1
                        FROM AdventureWorks.Person.Address ad
                        WHERE AddressLine1 IS NOT NULL
                        ORDER BY (SELECT id FROM dbo.view_NewID)
                    )
    RETURN @address
END;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GenerateRandomAuthorId]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[fn_GenerateRandomAuthorId](
    @RAND FLOAT 
)
RETURNS VARCHAR(11) AS
BEGIN
    DECLARE @author_id VARCHAR(11)
    DECLARE @isFound BIT = 0
    WHILE (@isFound = 0)
        BEGIN
            DECLARE @a1 AS CHAR(3) = (SELECT(CAST((FLOOR(@RAND*(999-100+1)+100)) AS CHAR)))
            DECLARE @a2 AS CHAR(2) = (SELECT(CAST((FLOOR(@RAND*(99-10+1)+10)) AS CHAR)))
            DECLARE @a3 AS CHAR(4) = (SELECT(CAST((FLOOR(@RAND*(9999-1000+1)+1000)) AS CHAR)))
            SET @author_id = (SELECT @a1 + '-' + @a2 + '-' + @a3)
            IF EXISTS(SELECT TOP 1 1 FROM [authors] WHERE au_id = @author_id)
                BEGIN
                    CONTINUE
                END
            ELSE 
                BEGIN
                    SET @isFound = 1
                END
        END
    RETURN @author_id
END;

/*
    DECLARE @author_id VARCHAR(11)
    SET @author_id = [dbo].[fn_GenerateRandomAuthorId](RAND())
    PRINT(@author_id)
*/




GO
/****** Object:  UserDefinedFunction [dbo].[fn_GenerateRandomDate]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_GenerateRandomTitleId](
    @RAND FLOAT 
)
RETURNS [dbo].[tid] AS
BEGIN
    DECLARE @random_title_id [dbo].[tid]
    DECLARE @isFound BIT = 0
    WHILE (@isFound = 0)
        BEGIN
            DECLARE @randomid1 UNIQUEIDENTIFIER = (SELECT id FROM dbo.view_NewID)
            DECLARE @randomid2 UNIQUEIDENTIFIER = (SELECT id FROM dbo.view_NewID)
            DECLARE @t1 AS CHAR(1) = (SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ',(ABS(CHECKSUM(@randomid1)) % 26) + 1, 1))
            DECLARE @t2 AS CHAR(1) = (SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ',(ABS(CHECKSUM(@randomid2)) % 26) + 1, 1))
            DECLARE @t3 AS CHAR(1) = (SELECT(CAST((FLOOR(@RAND*(9-1+1)+1)) AS CHAR)))
            DECLARE @t4 AS CHAR(1) = (SELECT(CAST((FLOOR(@RAND*(9-1+1)+1)) AS CHAR)))
            DECLARE @t5 AS CHAR(1) = (SELECT(CAST((FLOOR(@RAND*(9-1+1)+1)) AS CHAR)))
            DECLARE @t6 AS CHAR(1) = (SELECT(CAST((FLOOR(@RAND*(9-1+1)+1)) AS CHAR)))
            SET @random_title_id = (SELECT @t1 + @t2 + @t3 + @t4 + @t5 + @t6)
            
            IF EXISTS(SELECT TOP 1 1 FROM [titles] WHERE title_id = @random_title_id)
                BEGIN
                    CONTINUE
                END
            ELSE 
                BEGIN
                    SET @isFound = 1
                END
        END
    RETURN @random_title_id
END;

/*
    DECLARE @random_title_id [dbo].[tid] 
    SET @random_title_id = [dbo].[fn_GenerateRandomTitleId](RAND())
    PRINT(@random_title_id)
*/



GO
/****** Object:  UserDefinedFunction [dbo].[fn_GenerateRandomDate]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_GenerateRandomDate](
	 @DateStart	DATE
	,@DateEnd	DATE
    ,@RAND FLOAT
)
RETURNS DATE AS
BEGIN
    DECLARE @randomDate DATE
	SET	@randomDate = DateAdd(Day, @RAND * DateDiff(Day, @DateStart, @DateEnd), @DateStart)
	RETURN 	@randomDate
END;




GO
/****** Object:  UserDefinedFunction [dbo].[fn_GenerateRandomPhone]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_GenerateRandomPhone](
    @RAND FLOAT 
)
RETURNS VARCHAR(12) AS
BEGIN
    DECLARE @phone VARCHAR(12)
    DECLARE @p1 AS CHAR(3) = (SELECT(CAST((FLOOR(@RAND*(999-100+1)+100)) AS CHAR)))
    DECLARE @p2 AS CHAR(3) = (SELECT(CAST((FLOOR(@RAND*(999-100+1)+100)) AS CHAR)))
    DECLARE @p3 AS CHAR(4) = (SELECT(CAST((FLOOR(@RAND*(9999-1000+1)+1000)) AS CHAR)))
    SET @phone = (SELECT @p1 + '-' + @p2 + '-' + @p3)
    RETURN @phone
END;



GO
/****** Object:  UserDefinedFunction [dbo].[fn_GenerateRandomSsn]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_GenerateRandomSsn](
    @RAND FLOAT 
)
RETURNS VARCHAR(11) AS
BEGIN
    DECLARE @ssn VARCHAR(11)
    SET @ssn = (
                    CAST(CAST(100 + (898 * @RAND) AS INT) AS VARCHAR(3)) + 
                    '-' + 
                    CAST(CAST(10 + (88 * @RAND) AS INT) AS VARCHAR(2)) + 
                    '-' + 
                    CAST(CAST(1000 + (8998 * @RAND) AS INT) AS VARCHAR(4))
                  )
    RETURN @ssn
END;




GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetRandomNumber]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_GetRandomNumber] (
	@Lower INT, 
    @Upper INT,
    @RAND FLOAT 
)
RETURNS INT AS
BEGIN
	IF NOT (@Lower < @Upper) 
        BEGIN 
            --RAISERROR('@Lower parameter can not be greater than or equal to the @Upper parameter', 16, 1)
            RETURN -1
        END
    DECLARE @Random INT;
    SET @Random = ROUND(((@Upper - @Lower -1) * @RAND + @Lower), 0)
    RETURN @Random
END;



GO
/****** Object:  Table [dbo].[authors]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[authors](
	[au_id] [dbo].[id] NOT NULL,
	[au_lname] [varchar](40) NOT NULL,
	[au_fname] [varchar](20) NOT NULL,
	[phone] [char](12) NOT NULL,
	[address] [varchar](40) NULL,
	[city] [varchar](20) NULL,
	[state] [char](2) NULL,
	[zip] [char](5) NULL,
	[contract] [bit] NOT NULL,
 CONSTRAINT [UPKCL_auidind] PRIMARY KEY CLUSTERED 
(
	[au_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[titles]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[titles](
	[title_id] [dbo].[tid] NOT NULL,
	[title] [varchar](100) NULL,
	[pub_id] [char](4) NULL,
	[price] [money] NULL,
	[advance] [money] NULL,
	[royalty] [int] NULL,
	[ytd_sales] [int] NULL,
	[notes] [varchar](800) NULL,
	[pubdate] [datetime] NOT NULL,
	[prequel_id] [varchar](6) NULL,
	[ISBN] [varchar](17) NULL,
 CONSTRAINT [UPKCL_titleidind] PRIMARY KEY CLUSTERED 
(
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[titleauthor]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[titleauthor](
	[au_id] [dbo].[id] NOT NULL,
	[title_id] [dbo].[tid] NOT NULL,
	[au_ord] [tinyint] NULL,
	[royaltyper] [int] NULL,
 CONSTRAINT [UPKCL_taind] PRIMARY KEY CLUSTERED 
(
	[au_id] ASC,
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[titleview]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[view_NewID]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[view_NewID] As Select NEWID() as id

GO
/****** Object:  Table [Audit].[Book]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Audit].[Book](
	[pub_id] [char](4) NULL,
	[pub_name] [varchar](40) NULL,
	[pub_city] [varchar](20) NULL,
	[pub_state] [char](2) NULL,
	[pub_country] [varchar](30) NULL,
	[random_title_id] [dbo].[tid] NOT NULL,
	[prequel_id] [varchar](11) NULL,
	[book_title] [varchar](100) NULL,
	[book_type] [char](40) NULL,
	[book_price] [money] NULL,
	[book_advance] [money] NULL,
	[book_royalty] [int] NULL,
	[book_ytd_sales] [int] NULL,
	[book_notes] [varchar](800) NULL,
	[book_pubdate] [datetime] NULL,
	[random_au_id] [dbo].[id] NOT NULL,
	[au_lname] [varchar](40) NULL,
	[au_fname] [varchar](20) NULL,
	[au_phone] [char](12) NULL,
	[au_address] [varchar](40) NULL,
	[au_city] [varchar](20) NULL,
	[au_state] [char](2) NULL,
	[au_zip] [char](5) NULL,
	[au_contract] [bit] NULL,
	[royalty_per] [int] NULL,
	[au_ord] [tinyint] NULL,
	[created_date] [datetime] NULL,
	[created_by] [varchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bookcopies]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bookcopies](
	[copy_id] [int] NOT NULL,
	[title_id] [dbo].[tid] NOT NULL,
	[branch_id] [int] NOT NULL,
	[condition] [varchar](10) NOT NULL,
	[isavailable] [bit] NOT NULL,
	[isactive] [bit] NOT NULL,
 CONSTRAINT [PK__bookcopi__3C21D2D253AA47D8] PRIMARY KEY CLUSTERED 
(
	[copy_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bookcopy_history]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bookcopy_history](
	[id] [int] NOT NULL,
	[copy_id] [int] NOT NULL,
	[note] [varchar](400) NOT NULL,
	[createddate] [date] NOT NULL,
 CONSTRAINT [PK__bookcopy__3213E83F46802883] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[books_borrowed]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[books_borrowed](
	[id] [int] NOT NULL,
	[copy_id] [int] NOT NULL,
	[card_id] [int] NOT NULL,
	[borroweddate] [date] NOT NULL,
	[duedate] [date] NOT NULL,
	[isReturned] [bit] NOT NULL,
	[returndate] [date] NULL,
 CONSTRAINT [PK__books_bo__3213E83F6B6BA886] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[borrowers]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[borrowers](
	[id] [int] NOT NULL,
	[card_id] [int] NOT NULL,
	[ssn] [varchar](11) NOT NULL,
	[first_name] [varchar](100) NOT NULL,
	[last_name] [varchar](100) NOT NULL,
	[address] [varchar](200) NOT NULL,
	[phone] [char](12) NOT NULL,
	[birthdate] [date] NOT NULL,
	[card_issuedate] [date] NOT NULL,
	[balancedue] [decimal](6, 2) NOT NULL,
	[isexpired] [bit] NOT NULL,
	[lg_address] [varchar](200) NULL,
	[lg_name] [varchar](200) NULL,
	[lg_phoneNumber] [varchar](12) NULL,
 CONSTRAINT [PK__borrower__3213E83F5E95B92D] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[branchs]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[branchs](
	[branch_id] [int] NOT NULL,
	[name] [varchar](100) NOT NULL,
	[address] [varchar](200) NOT NULL,
	[phone] [char](12) NOT NULL,
	[fax] [char](12) NULL,
 CONSTRAINT [PK__branch__E55E37DE621CD3A4] PRIMARY KEY CLUSTERED 
(
	[branch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[category]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[category](
	[type_id] [int] NOT NULL,
	[type] [varchar](100) NOT NULL,
 CONSTRAINT [PK__title_ty__2C00059800C71E4A] PRIMARY KEY CLUSTERED 
(
	[type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[degrees]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[degrees](
	[id] [int] NOT NULL,
	[name] [varchar](100) NOT NULL,
 CONSTRAINT [PK__Degrees__3213E83FA6B40251] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[discounts]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[discounts](
	[discounttype] [varchar](40) NOT NULL,
	[stor_id] [char](4) NULL,
	[lowqty] [smallint] NULL,
	[highqty] [smallint] NULL,
	[discount] [decimal](4, 2) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[employee_type]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[employee_type](
	[id] [int] NOT NULL,
	[type] [varchar](100) NOT NULL,
 CONSTRAINT [PK__employee__3213E83FB416B887] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[employees]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[employees](
	[employee_id] [int] NOT NULL,
	[first_name] [varchar](100) NOT NULL,
	[last_name] [varchar](100) NOT NULL,
	[address] [varchar](200) NOT NULL,
	[homephone] [char](12) NULL,
	[cellphone] [char](12) NOT NULL,
	[salary_type] [char](1) NOT NULL,
	[salary] [decimal](6, 0) NULL,
	[birthdate] [date] NOT NULL,
	[hiredate] [date] NOT NULL,
	[vacation_hours] [int] NOT NULL,
	[degree_id] [int] NOT NULL,
	[school_id] [int] NOT NULL,
	[branch_id] [int] NOT NULL,
	[ishead_librarian] [bit] NOT NULL,
	[employee_type_id] [int] NOT NULL,
	[degreedate] [date] NULL,
	[isActive] [bit] NOT NULL,
 CONSTRAINT [PK__libraria__C52E0BA85F7A3A37] PRIMARY KEY CLUSTERED 
(
	[employee_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[paychecks]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[paychecks](
	[id] [int] NOT NULL,
	[employee_id] [int] NOT NULL,
	[amount] [decimal](8, 2) NOT NULL,
	[createddate] [date] NOT NULL,
 CONSTRAINT [PK__paycheck__3213E83F3EB48EB3] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pub_info]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pub_info](
	[pub_id] [char](4) NOT NULL,
	[logo] [image] NULL,
	[pr_info] [text] NULL,
 CONSTRAINT [UPKCL_pubinfo] PRIMARY KEY CLUSTERED 
(
	[pub_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[publishers]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[publishers](
	[pub_id] [char](4) NOT NULL,
	[pub_name] [varchar](40) NULL,
	[city] [varchar](20) NULL,
	[state] [char](2) NULL,
	[country] [varchar](30) NULL,
 CONSTRAINT [UPKCL_pubind] PRIMARY KEY CLUSTERED 
(
	[pub_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sales]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sales](
	[stor_id] [char](4) NOT NULL,
	[ord_num] [varchar](20) NOT NULL,
	[ord_date] [datetime] NOT NULL,
	[qty] [smallint] NOT NULL,
	[payterms] [varchar](12) NOT NULL,
	[title_id] [dbo].[tid] NOT NULL,
 CONSTRAINT [UPKCL_sales] PRIMARY KEY CLUSTERED 
(
	[stor_id] ASC,
	[ord_num] ASC,
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[schools]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[schools](
	[id] [int] NOT NULL,
	[name] [varchar](100) NOT NULL,
 CONSTRAINT [PK__Schools__3213E83FA4AD8ACB] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[shift_logs]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[shift_logs](
	[id] [int] NOT NULL,
	[employee_id] [int] NOT NULL,
	[hours] [int] NOT NULL,
	[shiftdate] [date] NOT NULL,
 CONSTRAINT [PK__shift_lo__3213E83F896BA1A4] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stores]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stores](
	[stor_id] [char](4) NOT NULL,
	[stor_name] [varchar](40) NULL,
	[stor_address] [varchar](40) NULL,
	[city] [varchar](20) NULL,
	[state] [char](2) NULL,
	[zip] [char](5) NULL,
 CONSTRAINT [UPK_storeid] PRIMARY KEY CLUSTERED 
(
	[stor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[titlecategory]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[titlecategory](
	[id] [int] NOT NULL,
	[title_id] [dbo].[tid] NOT NULL,
	[title_type_id] [int] NOT NULL,
 CONSTRAINT [UPKCL_ttind] PRIMARY KEY CLUSTERED 
(
	[title_type_id] ASC,
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9910', N'Allen & Unwin', N'London', NULL, N'UK', N'UX2157', N'EX5727', N'The Two Towers', N'	Fantasy', 40.0000, 200000.0000, 20, 50000000, N'The Two Towers is the second volume of J. R. R. Tolkiens high fantasy novel The Lord of the Rings. It is preceded by The Fellowship of the Ring and followed by The Return of the King.', CAST(N'1954-08-29T00:00:00.000' AS DateTime), N'254-26-6712', N'J.R.R.', N'Tolkien', N'', NULL, N'London', NULL, NULL, NULL, 100, 1, CAST(N'2022-04-16T18:40:36.707' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9910', N'Allen & Unwin', N'London', NULL, N'UK', N'ZJ4675', N'UX2157', N'The Return of the King', N'Fantasy', 40.0000, 200000.0000, 20, 50000000, N'The Return of the King is the third and final volume of J. R. R. Tolkiens The Lord of the Rings, following The Fellowship of the Ring and The Two Towers. It was published in 1955. The story begins in the kingdom of Gondor, which is soon to be attacked by the Dark Lord Sauron.', CAST(N'1955-10-20T00:00:00.000' AS DateTime), N'254-26-6712', N'J.R.R.', N'Tolkien', N'', NULL, N'London', NULL, NULL, NULL, 100, 1, CAST(N'2022-04-16T20:31:32.060' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9910', N'Allen & Unwin', N'London', NULL, N'UK', N'GE1743', NULL, N'The Hobbit', N'Fantasy', 60.0000, 50000.0000, 15, 50000000, N'The Hobbit, or There and Back Again is a childrens fantasy novel by English author J. R. R. Tolkien. It was published in 1937 to wide critical acclaim, being nominated for the Carnegie Medal and awarded a prize from the New York Herald Tribune for best juvenile fiction. The book remains popular and is recognized as a classic in childrens literature.', CAST(N'1937-09-21T00:00:00.000' AS DateTime), N'254-26-6712', N'J.R.R.', N'Tolkien', N'', NULL, N'London', NULL, NULL, NULL, 100, 1, CAST(N'2022-04-16T20:37:36.807' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9910', N'Allen & Unwin', N'London', NULL, N'UK', N'UU5128', NULL, N'The Silmarillion', N'Mythopoeia Fantasy', 45.0000, 2500000.0000, 40, 50000000, N'The Silmarillion is a collection of mythopoeic stories by the English writer J. R. R. Tolkien, edited and published posthumously by his son Christopher Tolkien in 1977 with assistance from the fantasy author Guy Gavriel Kay. The Silmarillion tells of Ea, a fictional universe that includes the Blessed Realm of Valinor, the once-great region of Beleriand, the sunken island of Numenor, and the continent of Middle-earth, where Tolkiens most popular works are set. After the success of The Hobbit, Tolkiens publisher Stanley Unwin requested a sequel, and Tolkien offered a draft of the stories that would later become The Silmarillion.', CAST(N'1977-09-15T00:00:00.000' AS DateTime), N'254-26-6712', N'J.R.R.', N'Tolkien', N'', NULL, N'London', NULL, NULL, NULL, 100, 1, CAST(N'2022-04-16T20:41:43.403' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9911', N'Crown Publishing Group', N'New York City', N'NY', N'US', N'BR5671', NULL, N'Why Nations Fail', N'Comparative Politics, Economics', 70.0000, 100000.0000, 30, 500000, N'Why Nations Fail: The Origins of Power, Prosperity, and Poverty, first published in 2012, is a book by economists Daron Acemoglu and James Robinson. It summarizes and popularizes previous research by the authors and many other scientists. Building on the new institutional economics, Robinson and Acemoglu see in political and economic institutions — a set of rules and enforcement mechanisms that exist in society — the main reason for differences in the economic and social development of different states, considering, that other factors (geography, climate, genetics, culture, religion, elite ignorance) are secondary.', CAST(N'2012-03-20T00:00:00.000' AS DateTime), N'408-40-8965', N'Acemoglu', N'Daron', N'999 000-0000', N'65, rue Faubourg St Antoine', N'Newton', N'MA', N'99402', 0, 50, 1, CAST(N'2022-04-16T21:07:32.383' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9912', N'Cambridge University Press', N'Cambridge', NULL, N'UK', N'FK3916', NULL, N'Economic Origins of Dictatorship and Democracy', N'Economics, Macroeconomics', 30.0000, 50000.0000, 15, 500000, N'Book develops a framework for analyzing the creation and consolidation of democracy. Different social groups prefer different political institutions because of the way they allocate political power and resources. Thus democracy is preferred by the majority of citizens, but opposed by elites. Dictatorship nevertheless is not stable when citizens can threaten social disorder and revolution.', CAST(N'2012-09-01T00:00:00.000' AS DateTime), N'408-40-8965', N'Acemoglu', N'Daron', N'999 000-0000', NULL, N'Newton', N'MA', NULL, NULL, 50, 1, CAST(N'2022-04-16T21:19:14.683' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9913', N'Bloomsbury Publishing', N'London', N'  ', N'UK', N'VC5136', NULL, N'Harry Potter and the Philosopher''s Stone', N'Fantasy', 45.0000, 1000000.0000, 40, 120000000, N'Harry Potter and the Philosopher''s Stone is a fantasy novel written by British author J. K. Rowling. The first novel in the Harry Potter series and Rowling''s debut novel, it follows Harry Potter, a young wizard who discovers his magical heritage on his eleventh birthday, when he receives a letter of acceptance to Hogwarts School of Witchcraft and Wizardry.', CAST(N'1997-06-26T00:00:00.000' AS DateTime), N'182-52-8743', N'Rowling', N'Joanne', N'999 000-0000', N'3833, boulevard Beau Marchais', N'YATE', N'  ', N'99796', 0, 100, 1, CAST(N'2022-04-17T17:09:52.727' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9913', N'Bloomsbury Publishing', N'London', N'  ', N'UK', N'BT6646', N'VC5136', N'Harry Potter and the Chamber of Secrets', N'Fantasy', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Chamber of Secrets is a fantasy novel written by British author J. K. Rowling and the second novel in the Harry Potter series. The plot follows Harry''s second year at Hogwarts School of Witchcraft and Wizardry, during which a series of messages on the walls of the school''s corridors warn that the "Chamber of Secrets" has been opened and that the "heir of Slytherin" would kill all pupils who do not come from all-magical families.', CAST(N'1998-07-02T00:00:00.000' AS DateTime), N'182-52-8743', N'Rowling', N'Joanne', N'999 000-0000', NULL, N'YATE', N'  ', NULL, NULL, 100, 1, CAST(N'2022-04-17T17:16:05.440' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9913', N'Bloomsbury Publishing', N'London', N'  ', N'UK', N'YE3356', N'BT6646', N'Harry Potter and the Prisoner of Azkaban', N'Fantasy', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Prisoner of Azkaban is a fantasy novel written by British author J. K. Rowling and is the third in the Harry Potter series. The book follows Harry Potter, a young wizard, in his third year at Hogwarts School of Witchcraft and Wizardry. Along with friends Ronald Weasley and Hermione Granger, Harry investigates Sirius Black, an escaped prisoner from Azkaban, the wizard prison, believed to be one of Lord Voldemort''s old allies.', CAST(N'1999-07-08T00:00:00.000' AS DateTime), N'182-52-8743', N'Rowling', N'Joanne', N'999 000-0000', NULL, N'YATE', N'  ', NULL, NULL, 100, 1, CAST(N'2022-04-17T17:17:20.160' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9913', N'Bloomsbury Publishing', N'London', N'  ', N'UK', N'TL7666', N'YE3356', N'Harry Potter and the Goblet of Fire', N'Fantasy', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Goblet of Fire is a fantasy novel written by British author J. K. Rowling and the fourth novel in the Harry Potter series. It follows Harry Potter, a wizard in his fourth year at Hogwarts School of Witchcraft and Wizardry, and the mystery surrounding the entry of Harry''s name into the Triwizard Tournament, in which he is forced to compete.', CAST(N'2000-07-08T00:00:00.000' AS DateTime), N'182-52-8743', N'Rowling', N'Joanne', N'999 000-0000', NULL, N'YATE', N'  ', NULL, NULL, 100, 1, CAST(N'2022-04-17T17:18:25.333' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9912', N'Cambridge University Press', N'Cambridge', NULL, N'UK', N'BL4371', NULL, N'Modern Computer Algebra', N'Computer Science', 100.0000, 50000.0000, 10, 10000, N'Computer algebra systems are now ubiquitous in all areas of science and engineering. This highly successful textbook, widely regarded as the bible of computer algebra, gives a thorough introduction to the algorithmic basis of the mathematical engine in computer algebra systems.', CAST(N'2013-01-01T00:00:00.000' AS DateTime), N'388-60-7495', N'Von Zur Gathen', N'Joachim', N'000 000-0000', N'9918 Scottsdale Rd.', N'Bonn', NULL, N'99409', 0, 50, 1, CAST(N'2022-04-16T21:39:33.237' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9913', N'Bloomsbury Publishing', N'London', N'  ', N'UK', N'QD5712', N'TL7666', N'Harry Potter and the Order of the Phoenix', N'Fantasy', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Order of the Phoenix is a fantasy novel written by British author J. K. Rowling and the fifth novel in the Harry Potter series. It follows Harry Potter''s struggles through his fifth year at Hogwarts School of Witchcraft and Wizardry, including the surreptitious return of the antagonist Lord Voldemort, O.W.L. exams, and an obstructive Ministry of Magic.', CAST(N'2003-06-27T00:00:00.000' AS DateTime), N'182-52-8743', N'Rowling', N'Joanne', N'999 000-0000', NULL, N'YATE', N'  ', NULL, NULL, 100, 1, CAST(N'2022-04-17T17:19:41.263' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9913', N'Bloomsbury Publishing', N'London', N'  ', N'UK', N'LS2238', N'QD5712', N'Harry Potter and the Half-Blood Prince', N'Fantasy', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Half-Blood Prince is a fantasy novel written by British author J.K. Rowling and the sixth and penultimate novel in the Harry Potter series. Set during Harry Potter''s sixth year at Hogwarts, the novel explores the past of the boy wizard''s nemesis, Lord Voldemort, and Harry''s preparations for the final battle against Voldemort alongside his headmaster and mentor Albus Dumbledore.', CAST(N'2005-07-16T00:00:00.000' AS DateTime), N'182-52-8743', N'Rowling', N'Joanne', N'999 000-0000', NULL, N'YATE', N'  ', NULL, NULL, 100, 1, CAST(N'2022-04-17T17:20:48.030' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9913', N'Bloomsbury Publishing', N'London', N'  ', N'UK', N'GU4539', N'LS2238', N'Harry Potter and the Deathly Hallows', N'Fantasy', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Deathly Hallows is a fantasy novel written by British author J. K. Rowling and the seventh and final novel of the main Harry Potter series. It was released on 14 July 2007 in the United Kingdom by Bloomsbury Publishing, in the United States by Scholastic, and in Canada by Raincoast Books. The novel chronicles the events directly following Harry Potter and the Half-Blood Prince (2005) and the final confrontation between the wizards Harry Potter and Lord Voldemort.', CAST(N'2007-07-14T00:00:00.000' AS DateTime), N'182-52-8743', N'Rowling', N'Joanne', N'999 000-0000', NULL, N'YATE', N'', NULL, NULL, 100, 1, CAST(N'2022-04-17T17:21:41.303' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9914', N'Bantam Spectra', N'New York City', N'NY', N'USA', N'CI5668', NULL, N'A Game of Thrones', N'Epic Fantasy', 70.0000, 1000000.0000, 40, 1000000, N'A Game of Thrones is the first novel in A Song of Ice and Fire, a series of fantasy novels by the American author George R. R. Martin. It was first published on August 1, 1996. The novel won the 1997 Locus Award and was nominated for both the 1997 Nebula Award and the 1997 World Fantasy Award. The novella Blood of the Dragon, comprising the Daenerys Targaryen chapters from the novel, won the 1997 Hugo Award for Best Novella. In January 2011, the novel became a New York Times Bestseller and reached No. 1 on the list in July 2011.', CAST(N'1996-08-01T00:00:00.000' AS DateTime), N'585-43-6756', N'Martin', N'George Raymond Richa', N'999 000-0000', N'5496 Village Pl.', N'New Jersey', N'NJ', N'99534', 1, 100, 1, CAST(N'2022-04-17T18:29:49.517' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9914', N'Bantam Spectra', N'New York City', N'NY', N'USA', N'OX4936', N'CI5668', N'A Clash of Kings', N'Epic Fantasy', 70.0000, 1000000.0000, 40, 1000000, N'A Clash of Kings is the second novel in A Song of Ice and Fire, an epic fantasy series by American author George R. R. Martin expected to consist of seven volumes. It was first published on November 16, 1998 in the United Kingdom; the first United States edition followed on February 2, 1999. Like its predecessor, A Game of Thrones, it won the Locus Award (in 1999) for Best Novel and was nominated for the Nebula Award (also in 1999) for best novel. In May 2005, Meisha Merlin released a limited edition of the novel, fully illustrated by John Howe.', CAST(N'1998-11-16T00:00:00.000' AS DateTime), N'585-43-6756', N'Martin', N'George Raymond Richa', N'999 000-0000', NULL, N'New Jersey', N'NJ', NULL, NULL, 100, 1, CAST(N'2022-04-17T18:34:23.980' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9914', N'Bantam Spectra', N'New York City', N'NY', N'USA', N'DU8845', N'OX4936', N'A Storm of Swords', N'Epic Fantasy', 70.0000, 1000000.0000, 40, 1000000, N'A Storm of Swords is the third of seven planned novels in A Song of Ice and Fire, a fantasy series by American author George R. R. Martin. It was first published on August 8, 2000, in the United Kingdom, with a United States edition following in November 2000. Its publication was preceded by a novella called Path of the Dragon, which collects some of the Daenerys Targaryen chapters from the novel into a single book.', CAST(N'2000-08-08T00:00:00.000' AS DateTime), N'585-43-6756', N'Martin', N'George Raymond Richa', N'999 000-0000', NULL, N'New Jersey', N'NJ', NULL, NULL, 100, 1, CAST(N'2022-04-17T18:35:30.763' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9914', N'Bantam Spectra', N'New York City', N'NY', N'USA', N'SU4434', N'DU8845', N'A Feast for Crows', N'Epic Fantasy', 70.0000, 1000000.0000, 40, 1000000, N'A Feast for Crows is the fourth of seven planned novels in the epic fantasy series A Song of Ice and Fire by American author George R. R. Martin. The novel was first published on October 17, 2005, in the United Kingdom, with a United States edition following on November 8, 2005.', CAST(N'2005-08-01T00:00:00.000' AS DateTime), N'585-43-6756', N'Martin', N'George Raymond Richa', N'999 000-0000', NULL, N'New Jersey', N'NJ', NULL, NULL, 100, 1, CAST(N'2022-04-17T18:36:25.470' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9914', N'Bantam Spectra', N'New York City', N'NY', N'USA', N'MW2447', N'SU4434', N'A Dance with Dragons', N'Epic Fantasy', 70.0000, 1000000.0000, 40, 1000000, N'A Dance with Dragons is the fifth novel of seven planned in the epic fantasy series A Song of Ice and Fire by American author George R. R. Martin. In some areas, the paperback edition was published in two parts, titled Dreams and Dust and After the Feast. It was the only novel in the series to be published during the eight-season run of the HBO adaptation of the series, Game of Thrones, and runs to 1,040 pages with a word count of almost 415,000.', CAST(N'2011-07-12T00:00:00.000' AS DateTime), N'585-43-6756', N'Martin', N'George Raymond Richa', N'999 000-0000', NULL, N'New Jersey', N'NJ', NULL, NULL, 100, 1, CAST(N'2022-04-17T18:37:44.370' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9914', N'Bantam Spectra', N'New York City', N'NY', N'USA', N'TC2266', N'MW2447', N'The Winds of Winter', N'Epic Fantasy', 70.0000, 1000000.0000, 40, 1000000, N'The Winds of Winter is the planned sixth novel in the epic fantasy series A Song of Ice and Fire by American writer George R. R. Martin. Martin believes the last two volumes of the series will total over 3,000 manuscript pages. Martin has refrained from making hard estimates for the final release date of the novel.', CAST(N'2023-01-01T00:00:00.000' AS DateTime), N'585-43-6756', N'Martin', N'George Raymond Richa', N'999 000-0000', NULL, N'New Jersey', N'NJ', NULL, NULL, 100, 1, CAST(N'2022-04-17T18:39:01.020' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9914', N'Bantam Spectra', N'New York City', N'NY', N'USA', N'SA4547', N'TC2266', N'A Dream of Spring', N'Epic Fantasy', 70.0000, 1000000.0000, 40, 1000000, N'A Dream of Spring is the planned title of the seventh volume of George R. R. Martin''s A Song of Ice and Fire series. The book is to follow The Winds of Winter and is intended to be the final volume of the series.', CAST(N'2024-01-01T00:00:00.000' AS DateTime), N'585-43-6756', N'Martin', N'George Raymond Richa', N'999 000-0000', NULL, N'New Jersey', N'NJ', NULL, NULL, 100, 1, CAST(N'2022-04-17T18:40:22.920' AS DateTime), N'sa')
GO
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'172-32-1176', N'White', N'Johnson', N'408 496-7223', N'10932 Bigge Rd.', N'Menlo Park', N'CA', N'94025', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'182-52-8743', N'Rowling', N'Joanne', N'999 000-0000', N'3833, boulevard Beau Marchais', N'YATE', N'  ', N'99796', 0)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'213-46-8915', N'Green', N'Marjorie', N'415 986-7020', N'309 63rd St. #411', N'Oakland', N'CA', N'94618', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'238-95-7766', N'Carson', N'Cheryl', N'415 548-7723', N'589 Darwin Ln.', N'Berkeley', N'CA', N'94705', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'254-26-6712', N'J.R.R.', N'Tolkien', N'            ', N'448 Roanoke Dr.', N'London', NULL, N'99852', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'267-41-2394', N'O''Leary', N'Michael', N'408 286-2428', N'22 Cleveland Av. #14', N'San Jose', N'CA', N'95128', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'274-80-9391', N'Straight', N'Dean', N'415 834-2919', N'5420 College Av.', N'Oakland', N'CA', N'94609', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'341-22-1782', N'Smith', N'Meander', N'913 843-0462', N'10 Mississippi Dr.', N'Lawrence', N'KS', N'66044', 0)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'388-60-7495', N'Von Zur Gathen', N'Joachim', N'000 000-0000', N'9918 Scottsdale Rd.', N'Bonn', NULL, N'99409', 0)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'408-40-8965', N'Acemoglu', N'Daron', N'999 000-0000', N'65, rue Faubourg St Antoine', N'Newton', N'MA', N'99402', 0)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'409-56-7008', N'Bennet', N'Abraham', N'415 658-9932', N'6223 Bateman St.', N'Berkeley', N'CA', N'94705', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'427-17-2319', N'Dull', N'Ann', N'415 836-7128', N'3410 Blonde St.', N'Palo Alto', N'CA', N'94301', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'472-27-2349', N'Gringlesby', N'Burt', N'707 938-6445', N'PO Box 792', N'Covelo', N'CA', N'95428', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'486-29-1786', N'Locksley', N'Charlene', N'415 585-4620', N'18 Broadway Av.', N'San Francisco', N'CA', N'94130', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'527-72-3246', N'Greene', N'Morningstar', N'615 297-2723', N'22 Graybar House Rd.', N'Nashville', N'TN', N'37215', 0)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'585-43-6756', N'Martin', N'George Raymond Richa', N'999 000-0000', N'5496 Village Pl.', N'New Jersey', N'NJ', N'99534', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'648-92-1872', N'Blotchet-Halls', N'Reginald', N'503 745-6402', N'55 Hillsdale Bl.', N'Corvallis', N'OR', N'97330', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'672-71-3249', N'Yokomoto', N'Akiko', N'415 935-4228', N'3 Silver Ct.', N'Walnut Creek', N'CA', N'94595', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'712-45-1867', N'del Castillo', N'Innes', N'615 996-8275', N'2286 Cram Pl. #86', N'Ann Arbor', N'MI', N'48105', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'722-51-5454', N'DeFrance', N'Michel', N'219 547-9982', N'3 Balding Pl.', N'Gary', N'IN', N'46403', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'724-08-9931', N'Stringer', N'Dirk', N'415 843-2991', N'5420 Telegraph Av.', N'Oakland', N'CA', N'94609', 0)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'724-80-9391', N'MacFeather', N'Stearns', N'415 354-7128', N'44 Upland Hts.', N'Oakland', N'CA', N'94612', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'756-30-7391', N'Karsen', N'Livia', N'415 534-9219', N'5720 McAuley St.', N'Oakland', N'CA', N'94609', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'807-91-6654', N'Panteley', N'Sylvia', N'301 946-8853', N'1956 Arlington Pl.', N'Rockville', N'MD', N'20853', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'846-92-7186', N'Hunter', N'Sheryl', N'415 836-7128', N'3410 Blonde St.', N'Palo Alto', N'CA', N'94301', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'893-72-1158', N'McBadden', N'Heather', N'707 448-4982', N'301 Putnam', N'Vacaville', N'CA', N'95688', 0)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'899-46-2035', N'Ringer', N'Anne', N'801 826-0752', N'67 Seventh Av.', N'Salt Lake City', N'UT', N'84152', 1)
INSERT [dbo].[authors] ([au_id], [au_lname], [au_fname], [phone], [address], [city], [state], [zip], [contract]) VALUES (N'998-72-3567', N'Ringer', N'Albert', N'801 826-0752', N'67 Seventh Av.', N'Salt Lake City', N'UT', N'84152', 1)
GO
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (1, N'BL4371', 1, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (2, N'BL4371', 2, N'NEW', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (3, N'BL4371', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (4, N'BL4371', 4, N'EXCELLENT', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (5, N'BL4371', 5, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (6, N'BL4371', 6, N'POOR', 0, 0)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (7, N'BL4371', 7, N'POOR', 0, 0)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (8, N'BR5671', 1, N'POOR', 0, 0)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (9, N'BR5671', 2, N'EXCELLENT', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (10, N'BR5671', 3, N'EXCELLENT', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (11, N'BR5671', 4, N'EXCELLENT', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (12, N'BR5671', 5, N'EXCELLENT', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (13, N'BR5671', 6, N'GOOD', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (14, N'BR5671', 7, N'WORN', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (15, N'BT6646', 1, N'NEW', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (16, N'BT6646', 2, N'NEW', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (17, N'BT6646', 3, N'EXCELLENT', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (18, N'BT6646', 4, N'EXCELLENT', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (19, N'BT6646', 5, N'POOR', 0, 0)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (20, N'BT6646', 6, N'POOR', 0, 0)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (21, N'ZJ4675', 1, N'POOR', 0, 0)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (22, N'ZJ4675', 2, N'POOR', 0, 0)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (23, N'ZJ4675', 3, N'POOR', 0, 0)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (24, N'ZJ4675', 4, N'GOOD', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (25, N'ZJ4675', 5, N'GOOD', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (26, N'ZJ4675', 6, N'GOOD', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (27, N'ZJ4675', 7, N'EXCELLENT', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (28, N'ZJ4675', 9, N'EXCELLENT', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (29, N'ZJ4675', 10, N'EXCELLENT', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (30, N'EX5727', 10, N'EXCELLENT', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (31, N'EX5727', 1, N'GOOD', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (32, N'EX5727', 2, N'GOOD', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (33, N'EX5727', 3, N'POOR', 0, 0)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (34, N'EX5727', 4, N'POOR', 0, 0)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (35, N'EX5727', 5, N'POOR', 0, 0)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (36, N'UX2157', 1, N'POOR', 0, 0)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (37, N'UX2157', 2, N'POOR', 0, 0)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (38, N'UX2157', 3, N'POOR', 0, 0)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (39, N'UX2157', 4, N'POOR', 0, 0)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (40, N'UX2157', 5, N'GOOD', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (41, N'UX2157', 6, N'GOOD', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (42, N'UX2157', 9, N'GOOD', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (43, N'UX2157', 10, N'GOOD', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (44, N'CI5668', 1, N'GOOD', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (45, N'CI5668', 10, N'GOOD', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (46, N'CI5668', 9, N'GOOD', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (47, N'CI5668', 2, N'GOOD', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (48, N'CI5668', 3, N'NEW', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (49, N'CI5668', 4, N'NEW', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (50, N'CI5668', 5, N'NEW', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (51, N'CI5668', 6, N'NEW', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (52, N'CI5668', 7, N'NEW', 0, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (53, N'OX4936', 1, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (54, N'MW2447', 1, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (55, N'SA4547', 1, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (56, N'SU4434', 1, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (57, N'DU8845', 1, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (58, N'PC1035', 1, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (59, N'PS1372', 1, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (60, N'BU1111', 1, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (61, N'FK3916', 1, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (62, N'PS7777', 1, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (63, N'TC4203', 1, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (64, N'GU4539', 1, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (65, N'TL7666', 1, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (66, N'LS2238', 1, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (67, N'QD5712', 1, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (68, N'VC5136', 1, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (69, N'YE3356', 1, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (70, N'OX4936', 2, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (71, N'MW2447', 2, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (72, N'SA4547', 2, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (73, N'SU4434', 2, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (74, N'DU8845', 2, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (75, N'PC1035', 2, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (76, N'PS1372', 2, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (77, N'BU1111', 2, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (78, N'FK3916', 2, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (79, N'PS7777', 2, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (80, N'TC4203', 2, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (81, N'GU4539', 2, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (82, N'TL7666', 2, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (83, N'LS2238', 2, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (84, N'QD5712', 2, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (85, N'VC5136', 2, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (86, N'YE3356', 2, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (87, N'PS2091', 2, N'EXCELLENT', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (88, N'PS2106', 2, N'EXCELLENT', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (89, N'PC9999', 2, N'EXCELLENT', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (90, N'TC3218', 2, N'EXCELLENT', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (91, N'PS3333', 2, N'EXCELLENT', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (92, N'PC8888', 2, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (93, N'MC2222', 2, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (94, N'OX4936', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (95, N'MW2447', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (96, N'SA4547', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (97, N'SU4434', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (98, N'DU8845', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (99, N'PC1035', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (100, N'PS1372', 3, N'NEW', 1, 1)
GO
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (101, N'BU1111', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (102, N'FK3916', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (103, N'PS7777', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (104, N'TC4203', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (105, N'GU4539', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (106, N'TL7666', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (107, N'LS2238', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (108, N'QD5712', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (109, N'VC5136', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (110, N'YE3356', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (111, N'PS2091', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (112, N'PS2106', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (113, N'PC9999', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (114, N'TC3218', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (115, N'PS3333', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (116, N'PC8888', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (117, N'MC2222', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (118, N'BU7832', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (119, N'TC7777', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (120, N'BU1032', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (121, N'MC3021', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (122, N'GE1743', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (123, N'UU5128', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (124, N'TC2266', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (125, N'BU2075', 3, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (126, N'OX4936', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (127, N'MW2447', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (128, N'SA4547', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (129, N'SU4434', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (130, N'DU8845', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (131, N'PC1035', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (132, N'PS1372', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (133, N'BU1111', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (134, N'FK3916', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (135, N'PS7777', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (136, N'TC4203', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (137, N'GU4539', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (138, N'TL7666', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (139, N'LS2238', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (140, N'QD5712', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (141, N'VC5136', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (142, N'YE3356', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (143, N'PS2091', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (144, N'PS2106', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (145, N'PC9999', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (146, N'TC3218', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (147, N'PS3333', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (148, N'PC8888', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (149, N'MC2222', 4, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (150, N'BU7832', 4, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (151, N'TC7777', 4, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (152, N'BU1032', 4, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (153, N'MC3021', 4, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (154, N'GE1743', 4, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (155, N'UU5128', 4, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (156, N'TC2266', 4, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (157, N'BU2075', 4, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (158, N'OX4936', 5, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (159, N'MW2447', 5, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (160, N'SA4547', 5, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (161, N'SU4434', 5, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (162, N'DU8845', 5, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (163, N'PC1035', 5, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (164, N'PS1372', 5, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (165, N'BU1111', 5, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (166, N'FK3916', 5, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (167, N'PS7777', 5, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (168, N'TC4203', 5, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (169, N'GU4539', 5, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (170, N'TL7666', 5, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (171, N'LS2238', 5, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (172, N'QD5712', 5, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (173, N'VC5136', 5, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (174, N'YE3356', 5, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (175, N'PS2091', 5, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (176, N'PS2106', 5, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (177, N'PC9999', 5, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (178, N'TC3218', 5, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (179, N'PS3333', 5, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (180, N'PC8888', 5, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (181, N'MC2222', 5, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (182, N'BU7832', 5, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (183, N'TC7777', 5, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (184, N'OX4936', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (185, N'MW2447', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (186, N'SA4547', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (187, N'SU4434', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (188, N'DU8845', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (189, N'PC1035', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (190, N'PS1372', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (191, N'BU1111', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (192, N'FK3916', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (193, N'PS7777', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (194, N'TC4203', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (195, N'GU4539', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (196, N'TL7666', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (197, N'LS2238', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (198, N'QD5712', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (199, N'VC5136', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (200, N'YE3356', 6, N'NEW', 1, 1)
GO
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (201, N'PS2091', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (202, N'PS2106', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (203, N'PC9999', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (204, N'TC3218', 6, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (205, N'OX4936', 7, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (206, N'MW2447', 7, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (207, N'SA4547', 7, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (208, N'SU4434', 7, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (209, N'DU8845', 7, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (210, N'PC1035', 7, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (211, N'PS1372', 7, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (212, N'BU1111', 7, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (213, N'FK3916', 7, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (214, N'PS7777', 7, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (215, N'TC4203', 7, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (216, N'BT6646', 7, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (217, N'GU4539', 7, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (218, N'OX4936', 8, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (219, N'MW2447', 8, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (220, N'SA4547', 8, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (221, N'SU4434', 8, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (222, N'CI5668', 8, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (223, N'DU8845', 8, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (224, N'PC1035', 8, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (225, N'PS1372', 8, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (226, N'BU1111', 8, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (227, N'FK3916', 8, N'GOOD', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (228, N'PS7777', 8, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (229, N'TC4203', 8, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (230, N'BT6646', 8, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (231, N'GU4539', 8, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (232, N'TL7666', 8, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (233, N'LS2238', 8, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (234, N'QD5712', 8, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (235, N'VC5136', 8, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (236, N'YE3356', 8, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (237, N'PS2091', 8, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (238, N'OX4936', 9, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (239, N'MW2447', 9, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (240, N'SA4547', 9, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (241, N'SU4434', 9, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (242, N'DU8845', 9, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (243, N'PC1035', 9, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (244, N'PS1372', 9, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (245, N'BU1111', 9, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (246, N'FK3916', 9, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (247, N'PS7777', 9, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (248, N'TC4203', 9, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (249, N'BT6646', 9, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (250, N'OX4936', 10, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (251, N'MW2447', 10, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (252, N'SA4547', 10, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (253, N'SU4434', 10, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (254, N'DU8845', 10, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (255, N'PC1035', 10, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (256, N'PS1372', 10, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (257, N'BU1111', 10, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (258, N'FK3916', 10, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (259, N'PS7777', 10, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (260, N'TC4203', 10, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (261, N'BT6646', 10, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (262, N'GU4539', 10, N'NEW', 1, 1)
INSERT [dbo].[bookcopies] ([copy_id], [title_id], [branch_id], [condition], [isavailable], [isactive]) VALUES (263, N'TL7666', 10, N'NEW', 1, 1)
GO
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (1, 10, 2, CAST(N'2022-04-01' AS Date), CAST(N'2022-04-15' AS Date), 1, CAST(N'2022-04-24' AS Date))
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (2, 9, 3, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (3, 11, 4, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (4, 52, 15, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (5, 24, 7, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (6, 51, 8, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (7, 26, 37, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (8, 44, 10, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (9, 25, 37, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (10, 28, 2, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (11, 16, 10, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (12, 50, 5, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (13, 45, 20, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (14, 30, 10, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (15, 27, 17, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (16, 46, 20, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (17, 42, 25, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (18, 15, 38, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (19, 47, 35, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (20, 48, 8, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (21, 31, 30, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (22, 12, 25, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (23, 29, 5, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (24, 43, 25, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (25, 13, 38, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (26, 41, 37, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (27, 17, 5, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (28, 14, 37, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (29, 18, 34, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (30, 49, 34, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (31, 32, 17, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
INSERT [dbo].[books_borrowed] ([id], [copy_id], [card_id], [borroweddate], [duedate], [isReturned], [returndate]) VALUES (32, 40, 33, CAST(N'2022-04-24' AS Date), CAST(N'2022-05-08' AS Date), 0, NULL)
GO
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (1, 1, N'153-32-2413', N'Victoria', N'Carlson', N'8871 Likins Ave.', N'280-555-0166', CAST(N'2007-05-01' AS Date), CAST(N'2019-10-19' AS Date), CAST(10.00 AS Decimal(6, 2)), 0, N'8871 Likins Ave.', N'Emily Brown', N'208-555-0143')
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (2, 2, N'373-31-6878', N'Lowell', N'Diaz', N'5452 Corte Gilberto', N'241-85-2006 ', CAST(N'1971-07-24' AS Date), CAST(N'2018-01-11' AS Date), CAST(7.30 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (3, 3, N'334-72-9174', N'Joshua', N'Shen', N'7538 Sherry Circle', N'517-11-4000 ', CAST(N'1978-01-29' AS Date), CAST(N'2013-08-24' AS Date), CAST(8.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (4, 4, N'770-97-9140', N'Franklin', N'Hughes', N'7185 St George Dr', N'801-51-6015 ', CAST(N'1956-01-16' AS Date), CAST(N'2018-01-21' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (5, 5, N'957-12-7676', N'Ann', N'Garcia', N'44, rue Saint Denis', N'593-91-6866 ', CAST(N'1989-11-10' AS Date), CAST(N'2019-10-01' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (6, 6, N'660-78-3774', N'Karen', N'Serrano', N'2226 Cleveland Avenue', N'839-87-2833 ', CAST(N'1977-01-10' AS Date), CAST(N'2014-06-25' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (7, 7, N'126-67-9837', N'Devin', N'Shen', N'655 Bidweld St.', N'740-39-8778 ', CAST(N'1984-08-25' AS Date), CAST(N'2022-01-29' AS Date), CAST(7.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (8, 8, N'251-36-8918', N'Alicia', N'Salanki', N'1440 Willow Pass Dr.', N'873-89-2932 ', CAST(N'1977-09-13' AS Date), CAST(N'2017-08-06' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (9, 9, N'415-10-3694', N'Timothy', N'Hayes', N'55, rue de Courtaboeuf', N'475-44-7331 ', CAST(N'1988-03-14' AS Date), CAST(N'2014-01-18' AS Date), CAST(55.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (10, 10, N'236-51-9575', N'Reginald', N'Liu', N'8467 Clifford Court', N'437-25-7353 ', CAST(N'1972-09-17' AS Date), CAST(N'2015-02-09' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (11, 11, N'523-82-8357', N'Tabitha', N'Patel', N'9, rue Saint-Lazare', N'772-92-2209 ', CAST(N'1984-12-08' AS Date), CAST(N'2015-01-17' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (12, 12, N'221-37-6992', N'Dwayne', N'Henderson', N'2973 Cardinal Drive', N'928-57-8369 ', CAST(N'1971-09-11' AS Date), CAST(N'2017-01-15' AS Date), CAST(12.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (13, 13, N'672-47-8652', N'Zoe', N'Luo', N'464 Ahneita Dr.', N'493-84-8116 ', CAST(N'1977-04-16' AS Date), CAST(N'2012-05-13' AS Date), CAST(0.00 AS Decimal(6, 2)), 1, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (14, 14, N'199-86-2277', N'Brad', N'Guo', N'Heiderweg 4284', N'569-51-4445 ', CAST(N'1985-09-23' AS Date), CAST(N'2011-11-07' AS Date), CAST(0.00 AS Decimal(6, 2)), 1, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (15, 15, N'551-91-5067', N'Alice', N'Gray', N'2612 Berry Dr', N'262-84-1293 ', CAST(N'1988-05-16' AS Date), CAST(N'2020-11-19' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (16, 16, N'739-96-2948', N'Jason', N'Zheng', N'7523 Surf View Drive', N'314-45-1702 ', CAST(N'1980-12-25' AS Date), CAST(N'2015-06-09' AS Date), CAST(50.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (17, 17, N'733-43-6010', N'William', N'Xu', N'402, boulevard Tremblay', N'364-88-4044 ', CAST(N'1991-01-04' AS Date), CAST(N'2019-09-25' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (18, 18, N'892-22-3905', N'Sebastian', N'Jimenez', N'1174 Ayers Rd', N'907-28-1794 ', CAST(N'1973-08-29' AS Date), CAST(N'2016-11-03' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (19, 19, N'717-87-9738', N'Stacey', N'Lum', N'1812, avenue de l´Europe', N'586-38-4905 ', CAST(N'1984-12-29' AS Date), CAST(N'2014-12-04' AS Date), CAST(32.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (20, 20, N'964-94-9663', N'Elizabeth', N'Adams', N'5415 San Gabriel Dr.', N'743-743-7436', CAST(N'2008-10-21' AS Date), CAST(N'2013-11-24' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, N'5537 Broadway', N'Michele', N'229-229-2298')
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (21, 21, N'484-47-4857', N'Ross', N'Lopez', N'7772 Golden Meadow', N'583-583-5832', CAST(N'1985-07-19' AS Date), CAST(N'1993-02-19' AS Date), CAST(0.00 AS Decimal(6, 2)), 1, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (22, 22, N'584-57-5853', N'Anthony', N'Phillips', N'133 Lorie Ln.', N'738-738-7384', CAST(N'2001-12-08' AS Date), CAST(N'2005-06-19' AS Date), CAST(20.00 AS Decimal(6, 2)), 1, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (23, 23, N'180-17-1803', N'Linda', N'Gonzales', N'236 Willow Lake Rd.', N'739-739-7390', CAST(N'1993-04-14' AS Date), CAST(N'2012-04-14' AS Date), CAST(0.00 AS Decimal(6, 2)), 1, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (24, 24, N'704-69-7061', N'Danielle', N'Zhu', N'5, avenue de la Gare', N'893-893-8939', CAST(N'1997-08-27' AS Date), CAST(N'2004-08-27' AS Date), CAST(0.00 AS Decimal(6, 2)), 1, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (25, 25, N'212-20-2124', N'Molly', N'Rai', N'Königsteiner Straße 449', N'185-185-1851', CAST(N'1984-09-17' AS Date), CAST(N'2015-09-17' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (26, 26, N'683-67-6849', N'Jasmine', N'Cox', N'1104 Colton Ln', N'122-122-1220', CAST(N'1956-06-01' AS Date), CAST(N'1991-06-01' AS Date), CAST(0.00 AS Decimal(6, 2)), 1, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (27, 27, N'941-92-9435', N'Jacqueline', N'Vazquez', N'4249 Heights Ave.', N'980-980-9808', CAST(N'1970-09-26' AS Date), CAST(N'1997-09-26' AS Date), CAST(0.00 AS Decimal(6, 2)), 1, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (28, 28, N'273-26-2738', N'Ricky', N'Randall', N'1814 Angi Lane', N'879-879-8792', CAST(N'1988-03-29' AS Date), CAST(N'2004-03-29' AS Date), CAST(0.00 AS Decimal(6, 2)), 1, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (29, 29, N'467-46-4687', N'Elijah', N'Ruiz', N'Lieblingsweg 543', N'533-533-5335', CAST(N'1986-08-10' AS Date), CAST(N'2004-08-10' AS Date), CAST(32.00 AS Decimal(6, 2)), 1, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (30, 30, N'941-92-9434', N'Amir', N'Butler', N'1742 Breck Court', N'932-932-9321', CAST(N'2008-08-01' AS Date), CAST(N'2014-08-01' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, N'Parkway Plaza', N'Madison', N'211-211-2112')
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (31, 31, N'570-56-5716', N'Jon', N'Rubio', N'1955 Glaze Dr.', N'696-696-6964', CAST(N'2008-01-12' AS Date), CAST(N'2017-01-12' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, N'1955 Glaze Dr.', N'Arturo', N'515-515-5157')
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (32, 32, N'434-42-4355', N'Rebecca', N'Sharma', N'14 Delta Road', N'425-425-4255', CAST(N'2003-05-14' AS Date), CAST(N'2017-05-14' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (33, 33, N'158-15-1584', N'Ruth', N'Henderson', N'8869 San Onofre Court', N'461-461-4614', CAST(N'2009-12-02' AS Date), CAST(N'2020-12-02' AS Date), CAST(5.00 AS Decimal(6, 2)), 0, N'8869 San Onofre Court', N'Allen', N'811-811-8116')
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (34, 34, N'991-97-9931', N'Jane', N'Madan', N'1930 Many Lane', N'252-252-2520', CAST(N'2002-10-29' AS Date), CAST(N'2016-10-29' AS Date), CAST(6.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (35, 35, N'353-34-3537', N'Erika', N'Powell', N'9279 Masonic Dr.', N'220-220-2206', CAST(N'1999-07-19' AS Date), CAST(N'2018-07-19' AS Date), CAST(8.00 AS Decimal(6, 2)), 0, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (36, 36, N'681-66-6823', N'Ruben', N'Kumar', N'2378 Joyce Dr.', N'372-372-3726', CAST(N'2003-08-24' AS Date), CAST(N'2009-08-24' AS Date), CAST(0.00 AS Decimal(6, 2)), 1, NULL, NULL, NULL)
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (37, 37, N'731-71-7329', N'Evelyn', N'Raji', N'4534 Blum Rd.', N'592-592-5929', CAST(N'2006-09-22' AS Date), CAST(N'2016-09-22' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, N'4534 Blum Rd.', N'Kendra', N'220-220-2201')
INSERT [dbo].[borrowers] ([id], [card_id], [ssn], [first_name], [last_name], [address], [phone], [birthdate], [card_issuedate], [balancedue], [isexpired], [lg_address], [lg_name], [lg_phoneNumber]) VALUES (38, 38, N'677-66-6788', N'Andy', N'Patterson', N'6111 Lancaster', N'527-527-5272', CAST(N'2009-12-28' AS Date), CAST(N'2019-12-28' AS Date), CAST(0.00 AS Decimal(6, 2)), 0, N'4977 Candlestick Dr.', N'Bianca', N'594-594-5946')
GO
INSERT [dbo].[branchs] ([branch_id], [name], [address], [phone], [fax]) VALUES (1, N'Brooklyn', N'10 Grand Army Plaza', N'718-230-2100', NULL)
INSERT [dbo].[branchs] ([branch_id], [name], [address], [phone], [fax]) VALUES (2, N'Central Valley', N'8871 Likins Ave.', N'999-555-0198', NULL)
INSERT [dbo].[branchs] ([branch_id], [name], [address], [phone], [fax]) VALUES (3, N'Cheektowaga', N'7779 Merry Drive', N'999-555-0183', NULL)
INSERT [dbo].[branchs] ([branch_id], [name], [address], [phone], [fax]) VALUES (4, N'Clay', N'6837 Pirate Lane', N'999-555-0155', NULL)
INSERT [dbo].[branchs] ([branch_id], [name], [address], [phone], [fax]) VALUES (5, N'Valley Stream', N'Green Acres Mall', N'999-555-0152', NULL)
INSERT [dbo].[branchs] ([branch_id], [name], [address], [phone], [fax]) VALUES (6, N'Ithaca', N'Pyramid Mall', N'999-555-0149', NULL)
INSERT [dbo].[branchs] ([branch_id], [name], [address], [phone], [fax]) VALUES (7, N'Lake George', N'Adirondack Factory Outlet', N'999-555-0133', NULL)
INSERT [dbo].[branchs] ([branch_id], [name], [address], [phone], [fax]) VALUES (8, N'De Witt', N'6405 Erie Blvd. Hills Plaza', N'999-555-0126', NULL)
INSERT [dbo].[branchs] ([branch_id], [name], [address], [phone], [fax]) VALUES (9, N'New Hartford', N'7505 Commercial Dr.', N'999-555-0111', NULL)
INSERT [dbo].[branchs] ([branch_id], [name], [address], [phone], [fax]) VALUES (10, N'New York', N'123 Union Square South', N'998-555-0194', NULL)
GO
INSERT [dbo].[category] ([type_id], [type]) VALUES (1, N'Fiction')
INSERT [dbo].[category] ([type_id], [type]) VALUES (2, N'Mystery')
INSERT [dbo].[category] ([type_id], [type]) VALUES (3, N'Science fiction')
INSERT [dbo].[category] ([type_id], [type]) VALUES (4, N'Juvenile')
INSERT [dbo].[category] ([type_id], [type]) VALUES (5, N'Reference')
INSERT [dbo].[category] ([type_id], [type]) VALUES (6, N'Adult')
INSERT [dbo].[category] ([type_id], [type]) VALUES (7, N'Business')
INSERT [dbo].[category] ([type_id], [type]) VALUES (8, N'Comparative Politics, Economics')
INSERT [dbo].[category] ([type_id], [type]) VALUES (9, N'Computer Science')
INSERT [dbo].[category] ([type_id], [type]) VALUES (10, N'Economics, Macroeconomics')
INSERT [dbo].[category] ([type_id], [type]) VALUES (11, N'Epic Fantasy')
INSERT [dbo].[category] ([type_id], [type]) VALUES (12, N'Fantasy')
INSERT [dbo].[category] ([type_id], [type]) VALUES (13, N'High Fantasy')
INSERT [dbo].[category] ([type_id], [type]) VALUES (14, N'Mod_cook')
INSERT [dbo].[category] ([type_id], [type]) VALUES (15, N'Mythopoeia Fantasy')
INSERT [dbo].[category] ([type_id], [type]) VALUES (16, N'Popular_comp')
INSERT [dbo].[category] ([type_id], [type]) VALUES (17, N'Psychology')
INSERT [dbo].[category] ([type_id], [type]) VALUES (18, N'Trad_cook')
INSERT [dbo].[category] ([type_id], [type]) VALUES (19, N'Adventure')
INSERT [dbo].[category] ([type_id], [type]) VALUES (20, N'Thriller')
INSERT [dbo].[category] ([type_id], [type]) VALUES (21, N'Romance')
INSERT [dbo].[category] ([type_id], [type]) VALUES (22, N'Westerns')
INSERT [dbo].[category] ([type_id], [type]) VALUES (23, N'Dystopian')
INSERT [dbo].[category] ([type_id], [type]) VALUES (24, N'Contemporary')
INSERT [dbo].[category] ([type_id], [type]) VALUES (25, N'Horror')
INSERT [dbo].[category] ([type_id], [type]) VALUES (26, N'Paranormal')
INSERT [dbo].[category] ([type_id], [type]) VALUES (27, N'Historical fiction')
INSERT [dbo].[category] ([type_id], [type]) VALUES (28, N'Art')
INSERT [dbo].[category] ([type_id], [type]) VALUES (29, N'Personal Development')
INSERT [dbo].[category] ([type_id], [type]) VALUES (30, N'Motivational')
INSERT [dbo].[category] ([type_id], [type]) VALUES (31, N'Health')
INSERT [dbo].[category] ([type_id], [type]) VALUES (32, N'History')
INSERT [dbo].[category] ([type_id], [type]) VALUES (33, N'Travel')
INSERT [dbo].[category] ([type_id], [type]) VALUES (34, N'Humor')
INSERT [dbo].[category] ([type_id], [type]) VALUES (999, N'Other')
GO
INSERT [dbo].[degrees] ([id], [name]) VALUES (1, N'Bachelors Degree in Library Science')
INSERT [dbo].[degrees] ([id], [name]) VALUES (2, N'Masters Degree in Library Science')
INSERT [dbo].[degrees] ([id], [name]) VALUES (3, N'Online Masters of Library Science')
INSERT [dbo].[degrees] ([id], [name]) VALUES (4, N'Graduate Certificate in Library Science')
INSERT [dbo].[degrees] ([id], [name]) VALUES (999, N'Other')
GO
INSERT [dbo].[discounts] ([discounttype], [stor_id], [lowqty], [highqty], [discount]) VALUES (N'Initial Customer', NULL, NULL, NULL, CAST(10.50 AS Decimal(4, 2)))
INSERT [dbo].[discounts] ([discounttype], [stor_id], [lowqty], [highqty], [discount]) VALUES (N'Volume Discount', NULL, 100, 1000, CAST(6.70 AS Decimal(4, 2)))
INSERT [dbo].[discounts] ([discounttype], [stor_id], [lowqty], [highqty], [discount]) VALUES (N'Customer Discount', N'8042', NULL, NULL, CAST(5.00 AS Decimal(4, 2)))
GO
INSERT [dbo].[employee_type] ([id], [type]) VALUES (1, N'Librarian')
INSERT [dbo].[employee_type] ([id], [type]) VALUES (2, N'Network Administrator')
INSERT [dbo].[employee_type] ([id], [type]) VALUES (3, N'Computer Programmer')
INSERT [dbo].[employee_type] ([id], [type]) VALUES (4, N'IT Manager')
INSERT [dbo].[employee_type] ([id], [type]) VALUES (5, N'Floor Manager')
INSERT [dbo].[employee_type] ([id], [type]) VALUES (6, N'Custodian')
INSERT [dbo].[employee_type] ([id], [type]) VALUES (7, N'Accountant')
INSERT [dbo].[employee_type] ([id], [type]) VALUES (8, N'Data Analyst')
GO
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (1, N'Tammy', N'Williams', N'7072 Meadow Lane', N'925-66-7082 ', N'963-43-4339 ', N'S', CAST(70000 AS Decimal(6, 0)), CAST(N'1973-08-04' AS Date), CAST(N'2015-01-20' AS Date), 154, 1, 1, 1, 0, 1, CAST(N'2012-04-09' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (2, N'Charles', N'Doe', N'Po Box 25484', N'649-50-4581 ', N'166-20-1609 ', N'S', CAST(90000 AS Decimal(6, 0)), CAST(N'1975-03-17' AS Date), CAST(N'2019-09-04' AS Date), 114, 2, 2, 1, 1, 1, CAST(N'2014-06-06' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (3, N'Sarah', N'Taylor', N'8474 Haynes Court', N'175-67-9063 ', N'213-57-2363 ', N'S', CAST(70000 AS Decimal(6, 0)), CAST(N'1980-12-25' AS Date), CAST(N'2019-04-19' AS Date), 114, 1, 2, 2, 0, 1, CAST(N'2013-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (4, N'Morgan', N'Butler', N'Haberstr 123', N'650-75-2184 ', N'215-14-2820 ', N'S', CAST(60000 AS Decimal(6, 0)), CAST(N'1970-12-23' AS Date), CAST(N'2011-07-09' AS Date), 200, 1, 5, 2, 0, 1, CAST(N'2014-09-05' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (5, N'Clayton', N'Gutierrez', N'2579 Des Plaines', N'623-34-2034 ', N'105-22-8066 ', N'S', CAST(85000 AS Decimal(6, 0)), CAST(N'1986-01-10' AS Date), CAST(N'2017-12-22' AS Date), 114, 2, 4, 2, 1, 1, CAST(N'2016-06-12' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (6, N'Cameron', N'Smith', N'22, De Schengen', N'583-20-3406 ', N'534-36-7483 ', N'S', CAST(95000 AS Decimal(6, 0)), CAST(N'1984-12-08' AS Date), CAST(N'2015-05-14' AS Date), 154, 3, 6, 3, 1, 1, CAST(N'2016-08-09' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (7, N'Alan', N'Pit', N'Rosemont 5538', N'337-41-2071 ', N'986-45-1303 ', N'S', CAST(65000 AS Decimal(6, 0)), CAST(N'1985-09-23' AS Date), CAST(N'2013-09-16' AS Date), 154, 3, 6, 2, 0, 1, CAST(N'2017-01-09' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (8, N'Chloe', N'Kane', N'4845 Lighthouse Road', N'606-29-1348 ', N'655-68-5935 ', N'S', CAST(68000 AS Decimal(6, 0)), CAST(N'1986-09-13' AS Date), CAST(N'2014-09-05' AS Date), 154, 1, 7, 2, 0, 1, CAST(N'2018-10-11' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (9, N'Tommy', N'Cane', N'6514 Morello Avenue', N'523-16-2966 ', N'372-22-9036 ', N'S', CAST(88000 AS Decimal(6, 0)), CAST(N'1967-03-02' AS Date), CAST(N'2013-06-12' AS Date), 154, 3, 8, 4, 1, 1, CAST(N'2019-10-11' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (10, N'Rick', N'Baker', N'6239 Monti Street', N'334-91-1501 ', N'737-45-4710 ', N'S', CAST(85000 AS Decimal(6, 0)), CAST(N'1990-10-07' AS Date), CAST(N'2021-10-21' AS Date), 114, 3, 3, 5, 1, 1, CAST(N'2016-10-15' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (11, N'Grace', N'Flores', N'2025 Greenwood Ct', N'704-704-7043', N'863-863-8634', N'C', CAST(21 AS Decimal(6, 0)), CAST(N'1975-12-21' AS Date), CAST(N'2019-04-23' AS Date), 114, 999, 9999, 10, 0, 6, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (12, N'Eduardo', N'Stone', N'1612 Geary Ct.', N'649-649-6494', N'637-637-6375', N'C', CAST(21 AS Decimal(6, 0)), CAST(N'1976-01-04' AS Date), CAST(N'2003-05-04' AS Date), 200, 999, 9999, 9, 0, 6, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (13, N'Karla', N'Wu', N'7554 Grammercy Lane', N'123-123-1239', N'525-525-5252', N'C', CAST(21 AS Decimal(6, 0)), CAST(N'1986-09-07' AS Date), CAST(N'2013-03-01' AS Date), 154, 999, 9999, 8, 0, 6, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (14, N'Lauren', N'Rodriguez', N'25300 Biddle Road', N'638-638-6387', N'789-789-7891', N'C', CAST(21 AS Decimal(6, 0)), CAST(N'1978-06-26' AS Date), CAST(N'1993-11-02' AS Date), 200, 999, 9999, 7, 0, 6, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (15, N'Maria', N'Bright', N'9759 Dover Way', N'538-538-5382', N'219-219-2193', N'C', CAST(21 AS Decimal(6, 0)), CAST(N'1985-11-24' AS Date), CAST(N'2016-03-06' AS Date), 154, 999, 9999, 6, 0, 6, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (16, N'Denise', N'Xu', N'5412 Iris Ct', N'722-722-7221', N'572-572-5724', N'C', CAST(21 AS Decimal(6, 0)), CAST(N'1990-11-01' AS Date), CAST(N'2014-03-14' AS Date), 154, 999, 9999, 5, 0, 6, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (17, N'Joe', N'Foster', N'1233 RiverRock Dr.', N'935-935-9358', N'392-392-3921', N'C', CAST(21 AS Decimal(6, 0)), CAST(N'1970-04-28' AS Date), CAST(N'2016-11-15' AS Date), 154, 999, 9999, 4, 0, 6, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (18, N'Willie', N'Shan', N'501, rue Henri Gagnon', N'114-114-1143', N'375-375-3756', N'C', CAST(21 AS Decimal(6, 0)), CAST(N'1971-09-11' AS Date), CAST(N'1995-05-17' AS Date), 200, 999, 9999, 3, 0, 6, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (19, N'Haley', N'Rubio', N'2157 Clark Creek Lane', N'860-860-8609', N'522-522-5221', N'C', CAST(21 AS Decimal(6, 0)), CAST(N'1966-12-08' AS Date), CAST(N'1992-01-27' AS Date), 200, 999, 9999, 2, 0, 6, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (20, N'Nina', N'Nara', N'9293 Clear View Circle', N'555-555-5555', N'121-121-1214', N'C', CAST(21 AS Decimal(6, 0)), CAST(N'1972-11-25' AS Date), CAST(N'1990-07-10' AS Date), 200, 999, 9999, 1, 0, 6, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (21, N'Charles', N'Yuan', N'Stevens Creek Shopping Center', N'796-796-7967', N'501-501-5014', N'C', CAST(18 AS Decimal(6, 0)), CAST(N'1991-01-04' AS Date), CAST(N'2021-03-03' AS Date), 114, 999, 9999, 1, 0, 5, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (22, N'Clarence', N'Hernandez', N'4256 Ashmount Way', N'694-694-6948', N'373-373-3732', N'C', CAST(18 AS Decimal(6, 0)), CAST(N'1980-02-27' AS Date), CAST(N'1997-06-29' AS Date), 200, 999, 9999, 2, 0, 5, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (23, N'Jan', N'Martin', N'Hochstr 8444', N'488-488-4880', N'732-732-7328', N'C', CAST(18 AS Decimal(6, 0)), CAST(N'1984-12-08' AS Date), CAST(N'1993-06-18' AS Date), 200, 999, 9999, 3, 0, 5, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (24, N'William', N'Allen', N'912 Valley Blvd.', N'373-373-3737', N'749-749-7496', N'C', CAST(18 AS Decimal(6, 0)), CAST(N'1968-03-17' AS Date), CAST(N'2016-08-11' AS Date), 154, 999, 9999, 4, 0, 5, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (25, N'Christine', N'Zheng', N'1207 Concerto Circle', N'260-260-2606', N'141-141-1419', N'C', CAST(18 AS Decimal(6, 0)), CAST(N'1989-06-25' AS Date), CAST(N'2009-02-13' AS Date), 200, 999, 9999, 5, 0, 5, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (26, N'Clayton', N'Lee', N'Zeiter Weg 9922', N'357-357-3570', N'173-173-1734', N'C', CAST(18 AS Decimal(6, 0)), CAST(N'1986-10-24' AS Date), CAST(N'1998-06-07' AS Date), 200, 999, 9999, 6, 0, 5, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (27, N'Meredith', N'Martinez', N'8562 Veale Ave.', N'136-136-1360', N'718-718-7187', N'C', CAST(18 AS Decimal(6, 0)), CAST(N'1983-05-13' AS Date), CAST(N'2000-11-01' AS Date), 200, 999, 9999, 7, 0, 5, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (28, N'Reginald', N'Turner', N'424 Yosemite Dr.', N'982-982-9821', N'823-823-8237', N'C', CAST(18 AS Decimal(6, 0)), CAST(N'1976-01-18' AS Date), CAST(N'2016-10-14' AS Date), 154, 999, 9999, 8, 0, 5, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (29, N'Gerald', N'Moreno', N'Klara Straße 8422', N'418-418-4185', N'961-961-9618', N'C', CAST(18 AS Decimal(6, 0)), CAST(N'1986-02-04' AS Date), CAST(N'1999-10-13' AS Date), 200, 999, 9999, 9, 0, 5, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (30, N'Louis', N'Hu', N'7384 Ironwood Drive.', N'289-289-2899', N'367-367-3675', N'C', CAST(18 AS Decimal(6, 0)), CAST(N'1988-03-14' AS Date), CAST(N'1990-05-08' AS Date), 200, 999, 9999, 10, 0, 5, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (31, N'Adrienne', N'Raje', N'3022 Black Walnut Court', N'970-970-9708', N'912-912-9123', N'C', CAST(30 AS Decimal(6, 0)), CAST(N'1971-08-01' AS Date), CAST(N'1996-11-02' AS Date), 200, 999, 9999, 1, 0, 2, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (32, N'Kendra', N'Pal', N'Am Gallberg 2345', N'623-623-6237', N'890-890-8909', N'C', CAST(30 AS Decimal(6, 0)), CAST(N'1976-01-06' AS Date), CAST(N'1992-07-02' AS Date), 200, 999, 9999, 2, 0, 2, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (33, N'Wyatt', N'Campbell', N'151, rue de la Centenaire', N'236-236-2367', N'582-582-5820', N'C', CAST(30 AS Decimal(6, 0)), CAST(N'1971-08-30' AS Date), CAST(N'2018-02-09' AS Date), 114, 999, 9999, 3, 0, 2, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (34, N'Bailey', N'Hu', N'2278 Rosa', N'318-318-3189', N'907-907-9075', N'S', CAST(90000 AS Decimal(6, 0)), CAST(N'1977-03-27' AS Date), CAST(N'2000-08-08' AS Date), 200, 999, 9999, 1, 0, 3, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (35, N'Heidi', N'Stewart', N'9340 Brook Way', N'763-763-7632', N'303-303-3036', N'S', CAST(120000 AS Decimal(6, 0)), CAST(N'1986-09-10' AS Date), CAST(N'2021-12-17' AS Date), 114, 999, 9999, 1, 0, 4, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (36, N'Robyn', N'Simmons', N'1899 Rosey View Drive', N'200-200-2001', N'975-975-9751', N'S', CAST(70000 AS Decimal(6, 0)), CAST(N'1988-10-17' AS Date), CAST(N'2009-09-10' AS Date), 200, 999, 9999, 1, 0, 7, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (37, N'Michele', N'Martinez', N'8982 Ricardo Drive', N'693-693-6934', N'496-496-4968', N'S', CAST(70000 AS Decimal(6, 0)), CAST(N'1986-09-07' AS Date), CAST(N'2006-08-13' AS Date), 200, 999, 9999, 2, 0, 7, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (38, N'Jenny', N'Perry', N'4683 Buchanan Pl.', N'844-844-8448', N'401-401-4011', N'S', CAST(70000 AS Decimal(6, 0)), CAST(N'1986-10-24' AS Date), CAST(N'2008-06-25' AS Date), 200, 999, 9999, 7, 0, 7, CAST(N'1900-01-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (39, N'Fernando', N'Gray', N'8650 Branch Street', N'274-274-2742', N'183-183-1837', N'S', CAST(65000 AS Decimal(6, 0)), CAST(N'1979-09-25' AS Date), CAST(N'1996-06-09' AS Date), 200, 1, 4, 3, 0, 1, CAST(N'2010-07-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (40, N'Jason', N'Fernandez', N'4627 Lakefield Place', N'409-409-4099', N'192-192-1927', N'S', CAST(65000 AS Decimal(6, 0)), CAST(N'1971-09-05' AS Date), CAST(N'1995-05-24' AS Date), 200, 1, 4, 4, 0, 1, CAST(N'2010-07-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (41, N'Jon', N'Kennedy', N'1064 Almond Drive', N'760-760-7601', N'759-759-7595', N'S', CAST(65000 AS Decimal(6, 0)), CAST(N'1988-09-24' AS Date), CAST(N'2018-10-16' AS Date), 114, 1, 3, 5, 0, 1, CAST(N'2010-07-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (42, N'Victoria', N'Xu', N'9992 Whipple Rd', N'907-907-9076', N'527-527-5279', N'S', CAST(65000 AS Decimal(6, 0)), CAST(N'1991-04-06' AS Date), CAST(N'2013-07-06' AS Date), 154, 2, 3, 6, 1, 1, CAST(N'2010-07-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (43, N'Colin', N'Nara', N'3828 Baltic Sea Ct', N'335-335-3355', N'300-300-3007', N'S', CAST(85000 AS Decimal(6, 0)), CAST(N'1975-12-13' AS Date), CAST(N'1996-09-04' AS Date), 200, 2, 6, 7, 1, 1, CAST(N'2010-07-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (44, N'Brenda', N'Jai', N'640 South 994th St. W.', N'949-949-9499', N'478-478-4780', N'S', CAST(80000 AS Decimal(6, 0)), CAST(N'1976-01-06' AS Date), CAST(N'1993-08-25' AS Date), 200, 2, 7, 8, 1, 1, CAST(N'2010-07-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (45, N'Anna', N'Goel', N'Räuscherweg 3456', N'171-171-1718', N'914-914-9144', N'S', CAST(80000 AS Decimal(6, 0)), CAST(N'1980-02-27' AS Date), CAST(N'2000-02-18' AS Date), 200, 2, 2, 9, 1, 1, CAST(N'2010-07-01' AS Date), 1)
INSERT [dbo].[employees] ([employee_id], [first_name], [last_name], [address], [homephone], [cellphone], [salary_type], [salary], [birthdate], [hiredate], [vacation_hours], [degree_id], [school_id], [branch_id], [ishead_librarian], [employee_type_id], [degreedate], [isActive]) VALUES (46, N'Ian', N'Zhao', N'Räuscherweg 6875', N'707-707-7072', N'762-762-7628', N'S', CAST(83000 AS Decimal(6, 0)), CAST(N'1984-07-25' AS Date), CAST(N'2001-08-23' AS Date), 200, 2, 1, 10, 1, 1, CAST(N'2012-01-01' AS Date), 1)
GO
INSERT [dbo].[pub_info] ([pub_id], [logo], [pr_info]) VALUES (N'0736', NULL, N'This is sample text data for New Moon Books, publisher 0736 in the pubs database. New Moon Books is located in Boston USA.')
INSERT [dbo].[pub_info] ([pub_id], [logo], [pr_info]) VALUES (N'0877', NULL, N'This is sample text data for Binnet & Hardley, publisher 0877 in the pubs database. Binnet & Hardley is located in Washington USA.')
INSERT [dbo].[pub_info] ([pub_id], [logo], [pr_info]) VALUES (N'1389', NULL, N'This is sample text data for Algodata Infosystems, publisher 1389 in the pubs database. Algodata Infosystems is located in Berkeley USA.')
INSERT [dbo].[pub_info] ([pub_id], [logo], [pr_info]) VALUES (N'1622', NULL, N'This is sample text data for Five Lakes Publishing, publisher 1622 in the pubs database. Five Lakes Publishing is located in Chicago USA.')
INSERT [dbo].[pub_info] ([pub_id], [logo], [pr_info]) VALUES (N'1756', NULL, N'This is sample text data for Ramona Publishers, publisher 1756 in the pubs database. Ramona Publishers is located in Dallas USA.')
INSERT [dbo].[pub_info] ([pub_id], [logo], [pr_info]) VALUES (N'9910', NULL, N'This is sample text data for Allen & Unwin, publisher 9910 in the pubs database. Allen & Unwin is located in London UK.')
INSERT [dbo].[pub_info] ([pub_id], [logo], [pr_info]) VALUES (N'9911', NULL, N'This is sample text data for Crown Publishing Group, publisher 9911 in the pubs database. Crown Publishing Group is located in New York City NY.')
INSERT [dbo].[pub_info] ([pub_id], [logo], [pr_info]) VALUES (N'9912', NULL, N'This is sample text data for Cambridge University Press, publisher 9912 in the pubs database. Cambridge University Press is located in Cambridge UK.')
INSERT [dbo].[pub_info] ([pub_id], [logo], [pr_info]) VALUES (N'9913', NULL, N'This is sample text data for Bloomsbury Publishing, publisher 9913 in the pubs database. Bloomsbury Publishing is located in London UK.')
INSERT [dbo].[pub_info] ([pub_id], [logo], [pr_info]) VALUES (N'9914', NULL, N'This is sample text data for Bantam Spectra, publisher 9914 in the pubs database. Bantam Spectra is located in New York City USA.')
GO
INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'0736', N'New Moon Books', N'Boston', N'MA', N'USA')
INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'0877', N'Binnet & Hardley', N'Washington', N'DC', N'USA')
INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'1389', N'Algodata Infosystems', N'Berkeley', N'CA', N'USA')
INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'1622', N'Five Lakes Publishing', N'Chicago', N'IL', N'USA')
INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'1756', N'Ramona Publishers', N'Dallas', N'TX', N'USA')
INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'9910', N'Allen & Unwin', N'London', NULL, N'UK')
INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'9911', N'Crown Publishing Group', N'New York City', N'NY', N'USA')
INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'9912', N'Cambridge University Press', N'Cambridge', NULL, N'UK')
INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'9913', N'Bloomsbury Publishing', N'London', N'  ', N'UK')
INSERT [dbo].[publishers] ([pub_id], [pub_name], [city], [state], [country]) VALUES (N'9914', N'Bantam Spectra', N'New York City', N'NY', N'USA')
GO
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'6380', N'6871', CAST(N'1994-09-14T00:00:00.000' AS DateTime), 5, N'Net 60', N'BU1032')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'6380', N'722a', CAST(N'1994-09-13T00:00:00.000' AS DateTime), 3, N'Net 60', N'PS2091')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'7066', N'A2976', CAST(N'1993-05-24T00:00:00.000' AS DateTime), 50, N'Net 30', N'PC8888')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'7066', N'QA7442.3', CAST(N'1994-09-13T00:00:00.000' AS DateTime), 75, N'ON invoice', N'PS2091')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'7067', N'D4482', CAST(N'1994-09-14T00:00:00.000' AS DateTime), 10, N'Net 60', N'PS2091')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'7067', N'P2121', CAST(N'1992-06-15T00:00:00.000' AS DateTime), 40, N'Net 30', N'TC3218')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'7067', N'P2121', CAST(N'1992-06-15T00:00:00.000' AS DateTime), 20, N'Net 30', N'TC4203')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'7067', N'P2121', CAST(N'1992-06-15T00:00:00.000' AS DateTime), 20, N'Net 30', N'TC7777')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'7131', N'N914008', CAST(N'1994-09-14T00:00:00.000' AS DateTime), 20, N'Net 30', N'PS2091')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'7131', N'N914014', CAST(N'1994-09-14T00:00:00.000' AS DateTime), 25, N'Net 30', N'MC3021')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'7131', N'P3087a', CAST(N'1993-05-29T00:00:00.000' AS DateTime), 20, N'Net 60', N'PS1372')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'7131', N'P3087a', CAST(N'1993-05-29T00:00:00.000' AS DateTime), 25, N'Net 60', N'PS2106')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'7131', N'P3087a', CAST(N'1993-05-29T00:00:00.000' AS DateTime), 15, N'Net 60', N'PS3333')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'7131', N'P3087a', CAST(N'1993-05-29T00:00:00.000' AS DateTime), 25, N'Net 60', N'PS7777')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'7896', N'QQ2299', CAST(N'1993-10-28T00:00:00.000' AS DateTime), 15, N'Net 60', N'BU7832')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'7896', N'TQ456', CAST(N'1993-12-12T00:00:00.000' AS DateTime), 10, N'Net 60', N'MC2222')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'7896', N'X999', CAST(N'1993-02-21T00:00:00.000' AS DateTime), 35, N'ON invoice', N'BU2075')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'8042', N'423LL922', CAST(N'1994-09-14T00:00:00.000' AS DateTime), 15, N'ON invoice', N'MC3021')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'8042', N'423LL930', CAST(N'1994-09-14T00:00:00.000' AS DateTime), 10, N'ON invoice', N'BU1032')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'8042', N'P723', CAST(N'1993-03-11T00:00:00.000' AS DateTime), 25, N'Net 30', N'BU1111')
INSERT [dbo].[sales] ([stor_id], [ord_num], [ord_date], [qty], [payterms], [title_id]) VALUES (N'8042', N'QA879.1', CAST(N'1993-05-22T00:00:00.000' AS DateTime), 30, N'Net 30', N'PC1035')
GO
INSERT [dbo].[schools] ([id], [name]) VALUES (1, N'Touro University')
INSERT [dbo].[schools] ([id], [name]) VALUES (2, N'University of North Carolina at Chapel Hill')
INSERT [dbo].[schools] ([id], [name]) VALUES (3, N'University of Washington')
INSERT [dbo].[schools] ([id], [name]) VALUES (4, N'University of Maryland at College Park')
INSERT [dbo].[schools] ([id], [name]) VALUES (5, N'University of Texas at Austin')
INSERT [dbo].[schools] ([id], [name]) VALUES (6, N'The State University of New Jersey at New Brunswick')
INSERT [dbo].[schools] ([id], [name]) VALUES (7, N'Syracuse University')
INSERT [dbo].[schools] ([id], [name]) VALUES (8, N'University of Illinois at Urbana-Champaign')
INSERT [dbo].[schools] ([id], [name]) VALUES (9999, N'Other')
GO
INSERT [dbo].[stores] ([stor_id], [stor_name], [stor_address], [city], [state], [zip]) VALUES (N'6380', N'Eric the Read Books', N'788 Catamaugus Ave.', N'Seattle', N'WA', N'98056')
INSERT [dbo].[stores] ([stor_id], [stor_name], [stor_address], [city], [state], [zip]) VALUES (N'7066', N'Barnum''s', N'567 Pasadena Ave.', N'Tustin', N'CA', N'92789')
INSERT [dbo].[stores] ([stor_id], [stor_name], [stor_address], [city], [state], [zip]) VALUES (N'7067', N'News & Brews', N'577 First St.', N'Los Gatos', N'CA', N'96745')
INSERT [dbo].[stores] ([stor_id], [stor_name], [stor_address], [city], [state], [zip]) VALUES (N'7131', N'Doc-U-Mat: Quality Laundry and Books', N'24-A Avogadro Way', N'Remulade', N'WA', N'98014')
INSERT [dbo].[stores] ([stor_id], [stor_name], [stor_address], [city], [state], [zip]) VALUES (N'7896', N'Fricative Bookshop', N'89 Madison St.', N'Fremont', N'CA', N'90019')
INSERT [dbo].[stores] ([stor_id], [stor_name], [stor_address], [city], [state], [zip]) VALUES (N'8042', N'Bookbeat', N'679 Carson St.', N'Portland', N'OR', N'89076')
GO
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'172-32-1176', N'PS3333', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'182-52-8743', N'BT6646', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'182-52-8743', N'GU4539', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'182-52-8743', N'LS2238', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'182-52-8743', N'QD5712', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'182-52-8743', N'TL7666', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'182-52-8743', N'VC5136', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'182-52-8743', N'YE3356', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'213-46-8915', N'BU1032', 2, 40)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'213-46-8915', N'BU2075', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'238-95-7766', N'PC1035', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'254-26-6712', N'EX5727', 2, 20)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'254-26-6712', N'GE1743', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'254-26-6712', N'UU5128', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'254-26-6712', N'UX2157', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'254-26-6712', N'ZJ4675', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'267-41-2394', N'BU1111', 2, 40)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'267-41-2394', N'TC7777', 2, 30)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'274-80-9391', N'BU7832', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'388-60-7495', N'BL4371', 1, 50)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'408-40-8965', N'BR5671', 1, 50)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'408-40-8965', N'FK3916', 1, 50)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'409-56-7008', N'BU1032', 1, 60)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'427-17-2319', N'PC8888', 1, 50)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'472-27-2349', N'TC7777', 3, 30)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'486-29-1786', N'PC9999', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'486-29-1786', N'PS7777', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'585-43-6756', N'CI5668', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'585-43-6756', N'DU8845', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'585-43-6756', N'MW2447', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'585-43-6756', N'OX4936', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'585-43-6756', N'SA4547', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'585-43-6756', N'SU4434', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'585-43-6756', N'TC2266', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'648-92-1872', N'TC4203', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'672-71-3249', N'TC7777', 1, 40)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'712-45-1867', N'MC2222', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'722-51-5454', N'MC3021', 1, 75)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'724-80-9391', N'BU1111', 1, 60)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'724-80-9391', N'PS1372', 2, 25)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'756-30-7391', N'PS1372', 1, 75)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'807-91-6654', N'TC3218', 1, 100)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'846-92-7186', N'PC8888', 2, 50)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'899-46-2035', N'MC3021', 2, 25)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'899-46-2035', N'PS2091', 2, 50)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'998-72-3567', N'PS2091', 1, 50)
INSERT [dbo].[titleauthor] ([au_id], [title_id], [au_ord], [royaltyper]) VALUES (N'998-72-3567', N'PS2106', 1, 100)
GO
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (59, N'BT6646', 2)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (60, N'GU4539', 2)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (61, N'LS2238', 2)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (62, N'QD5712', 2)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (63, N'TL7666', 2)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (64, N'VC5136', 2)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (65, N'YE3356', 2)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (66, N'BL4371', 5)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (1, N'BU1032', 7)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (2, N'BU1111', 7)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (3, N'BU2075', 7)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (4, N'BU7832', 7)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (5, N'BR5671', 8)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (6, N'BL4371', 9)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (7, N'FK3916', 10)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (8, N'CI5668', 11)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (9, N'DU8845', 11)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (10, N'MW2447', 11)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (11, N'OX4936', 11)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (12, N'SA4547', 11)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (13, N'SU4434', 11)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (14, N'TC2266', 11)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (15, N'BT6646', 12)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (16, N'GE1743', 12)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (17, N'GU4539', 12)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (18, N'LS2238', 12)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (19, N'QD5712', 12)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (20, N'TL7666', 12)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (21, N'UX2157', 12)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (22, N'VC5136', 12)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (23, N'YE3356', 12)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (24, N'ZJ4675', 12)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (25, N'EX5727', 13)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (26, N'MC2222', 14)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (27, N'MC3021', 14)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (28, N'UU5128', 15)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (29, N'PC1035', 16)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (30, N'PC8888', 16)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (31, N'PC9999', 16)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (32, N'PS1372', 17)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (33, N'PS2091', 17)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (34, N'PS2106', 17)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (35, N'PS3333', 17)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (36, N'PS7777', 17)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (37, N'TC3218', 18)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (38, N'TC4203', 18)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (39, N'TC7777', 18)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (40, N'BT6646', 19)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (41, N'GU4539', 19)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (42, N'LS2238', 19)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (43, N'QD5712', 19)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (44, N'TL7666', 19)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (45, N'VC5136', 19)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (46, N'YE3356', 19)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (52, N'BT6646', 22)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (47, N'EX5727', 22)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (48, N'GE1743', 22)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (53, N'GU4539', 22)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (54, N'LS2238', 22)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (55, N'QD5712', 22)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (56, N'TL7666', 22)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (49, N'UU5128', 22)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (50, N'UX2157', 22)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (57, N'VC5136', 22)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (58, N'YE3356', 22)
INSERT [dbo].[titlecategory] ([id], [title_id], [title_type_id]) VALUES (51, N'ZJ4675', 22)
GO
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'BL4371', N'Modern Computer Algebra', N'9912', 100.0000, 50000.0000, 10, 10000, N'Computer algebra systems are now ubiquitous in all areas of science and engineering. This highly successful textbook, widely regarded as the bible of computer algebra, gives a thorough introduction to the algorithmic basis of the mathematical engine in computer algebra systems.', CAST(N'2013-01-01T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'BR5671', N'Why Nations Fail', N'9911', 70.0000, 100000.0000, 30, 500000, N'Why Nations Fail: The Origins of Power, Prosperity, and Poverty, first published in 2012, is a book by economists Daron Acemoglu and James Robinson. It summarizes and popularizes previous research by the authors and many other scientists. Building on the new institutional economics, Robinson and Acemoglu see in political and economic institutions — a set of rules and enforcement mechanisms that exist in society — the main reason for differences in the economic and social development of different states, considering, that other factors (geography, climate, genetics, culture, religion, elite ignorance) are secondary.', CAST(N'2012-03-20T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'BT6646', N'Harry Potter and the Chamber of Secrets', N'9913', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Chamber of Secrets is a fantasy novel written by British author J. K. Rowling and the second novel in the Harry Potter series. The plot follows Harry''s second year at Hogwarts School of Witchcraft and Wizardry, during which a series of messages on the walls of the school''s corridors warn that the "Chamber of Secrets" has been opened and that the "heir of Slytherin" would kill all pupils who do not come from all-magical families.', CAST(N'1998-07-02T00:00:00.000' AS DateTime), N'VC5136', N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'BU1032', N'The Busy Executive''s Database Guide', N'1389', 19.9900, 5000.0000, 10, 4095, N'An overview of available database systems with emphasis on common business applications. Illustrated.', CAST(N'1991-06-12T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'BU1111', N'Cooking with Computers: Surreptitious Balance Sheets', N'1389', 11.9500, 5000.0000, 10, 3876, N'Helpful hints on how to use your electronic resources to the best advantage.', CAST(N'1991-06-09T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'BU2075', N'You Can Combat Computer Stress!', N'0736', 2.9900, 10125.0000, 24, 18722, N'The latest medical and psychological techniques for living with the electronic office. Easy-to-understand explanations.', CAST(N'1991-06-30T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'BU7832', N'Straight Talk About Computers', N'1389', 19.9900, 5000.0000, 10, 4095, N'Annotated analysis of what computers can do for you: a no-hype guide for the critical user.', CAST(N'1991-06-22T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'CI5668', N'A Game of Thrones', N'9914', 70.0000, 1000000.0000, 40, 1000000, N'A Game of Thrones is the first novel in A Song of Ice and Fire, a series of fantasy novels by the American author George R. R. Martin. It was first published on August 1, 1996. The novel won the 1997 Locus Award and was nominated for both the 1997 Nebula Award and the 1997 World Fantasy Award. The novella Blood of the Dragon, comprising the Daenerys Targaryen chapters from the novel, won the 1997 Hugo Award for Best Novella. In January 2011, the novel became a New York Times Bestseller and reached No. 1 on the list in July 2011.', CAST(N'1996-08-01T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'DU8845', N'A Storm of Swords', N'9914', 70.0000, 1000000.0000, 40, 1000000, N'A Storm of Swords is the third of seven planned novels in A Song of Ice and Fire, a fantasy series by American author George R. R. Martin. It was first published on August 8, 2000, in the United Kingdom, with a United States edition following in November 2000. Its publication was preceded by a novella called Path of the Dragon, which collects some of the Daenerys Targaryen chapters from the novel into a single book.', CAST(N'2000-08-08T00:00:00.000' AS DateTime), N'OX4936', N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'EX5727', N'The Fellowship of the Ring', N'9910', 40.0000, 20000.0000, 5000000, 150000000, N'The Lord of the Rings is an epic high-fantasy novel by English author and scholar J. R. R. Tolkien. Set in Middle-earth, intended to be Earth at some distant time in the past, the story began as a sequel to Tolkiens 1937 childrens book The Hobbit, but eventually developed into a much larger work. Written in stages between 1937 and 1949, The Lord of the Rings is one of the best-selling books ever written, with over 150 million copies sold.', CAST(N'1954-08-29T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'FK3916', N'Economic Origins of Dictatorship and Democracy', N'9912', 30.0000, 50000.0000, 15, 500000, N'Book develops a framework for analyzing the creation and consolidation of democracy. Different social groups prefer different political institutions because of the way they allocate political power and resources. Thus democracy is preferred by the majority of citizens, but opposed by elites. Dictatorship nevertheless is not stable when citizens can threaten social disorder and revolution.', CAST(N'2012-09-01T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'GE1743', N'The Hobbit', N'9910', 60.0000, 50000.0000, 15, 50000000, N'The Hobbit, or There and Back Again is a childrens fantasy novel by English author J. R. R. Tolkien. It was published in 1937 to wide critical acclaim, being nominated for the Carnegie Medal and awarded a prize from the New York Herald Tribune for best juvenile fiction. The book remains popular and is recognized as a classic in childrens literature.', CAST(N'1937-09-21T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'GU4539', N'Harry Potter and the Deathly Hallows', N'9913', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Deathly Hallows is a fantasy novel written by British author J. K. Rowling and the seventh and final novel of the main Harry Potter series. It was released on 14 July 2007 in the United Kingdom by Bloomsbury Publishing, in the United States by Scholastic, and in Canada by Raincoast Books. The novel chronicles the events directly following Harry Potter and the Half-Blood Prince (2005) and the final confrontation between the wizards Harry Potter and Lord Voldemort.', CAST(N'2007-07-14T00:00:00.000' AS DateTime), N'LS2238', N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'LS2238', N'Harry Potter and the Half-Blood Prince', N'9913', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Half-Blood Prince is a fantasy novel written by British author J.K. Rowling and the sixth and penultimate novel in the Harry Potter series. Set during Harry Potter''s sixth year at Hogwarts, the novel explores the past of the boy wizard''s nemesis, Lord Voldemort, and Harry''s preparations for the final battle against Voldemort alongside his headmaster and mentor Albus Dumbledore.', CAST(N'2005-07-16T00:00:00.000' AS DateTime), N'QD5712', N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'MC2222', N'Silicon Valley Gastronomic Treats', N'0877', 19.9900, 0.0000, 12, 2032, N'Favorite recipes for quick, easy, and elegant meals.', CAST(N'1991-06-09T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'MC3021', N'The Gourmet Microwave', N'0877', 2.9900, 15000.0000, 24, 22246, N'Traditional French gourmet recipes adapted for modern microwave cooking.', CAST(N'1991-06-18T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'MW2447', N'A Dance with Dragons', N'9914', 70.0000, 1000000.0000, 40, 1000000, N'A Dance with Dragons is the fifth novel of seven planned in the epic fantasy series A Song of Ice and Fire by American author George R. R. Martin. In some areas, the paperback edition was published in two parts, titled Dreams and Dust and After the Feast. It was the only novel in the series to be published during the eight-season run of the HBO adaptation of the series, Game of Thrones, and runs to 1,040 pages with a word count of almost 415,000.', CAST(N'2011-07-12T00:00:00.000' AS DateTime), N'SU4434', N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'OX4936', N'A Clash of Kings', N'9914', 70.0000, 1000000.0000, 40, 1000000, N'A Clash of Kings is the second novel in A Song of Ice and Fire, an epic fantasy series by American author George R. R. Martin expected to consist of seven volumes. It was first published on November 16, 1998 in the United Kingdom; the first United States edition followed on February 2, 1999. Like its predecessor, A Game of Thrones, it won the Locus Award (in 1999) for Best Novel and was nominated for the Nebula Award (also in 1999) for best novel. In May 2005, Meisha Merlin released a limited edition of the novel, fully illustrated by John Howe.', CAST(N'1998-11-16T00:00:00.000' AS DateTime), N'CI5668', N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'PC1035', N'But Is It User Friendly?', N'1389', 22.9500, 7000.0000, 16, 8780, N'A survey of software for the naive user, focusing on the ''friendliness'' of each.', CAST(N'1991-06-30T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'PC8888', N'Secrets of Silicon Valley', N'1389', 20.0000, 8000.0000, 10, 4095, N'Muckraking reporting on the world''s largest computer hardware and software manufacturers.', CAST(N'1994-06-12T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'PC9999', N'Net Etiquette', N'1389', NULL, NULL, NULL, NULL, N'A must-read for computer conferencing.', CAST(N'2022-04-10T23:30:33.463' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'PS1372', N'Computer Phobic AND Non-Phobic Individuals: Behavior Variations', N'0877', 21.5900, 7000.0000, 10, 375, N'A must for the specialist, this book examines the difference between those who hate and fear computers and those who don''t.', CAST(N'1991-10-21T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'PS2091', N'Is Anger the Enemy?', N'0736', 10.9500, 2275.0000, 12, 2045, N'Carefully researched study of the effects of strong emotions on the body. Metabolic charts included.', CAST(N'1991-06-15T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'PS2106', N'Life Without Fear', N'0736', 7.0000, 6000.0000, 10, 111, N'New exercise, meditation, and nutritional techniques that can reduce the shock of daily interactions. Popular audience. Sample menus included, exercise video available separately.', CAST(N'1991-10-05T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'PS3333', N'Prolonged Data Deprivation: Four Case Studies', N'0736', 19.9900, 2000.0000, 10, 4072, N'What happens when the data runs dry?  Searching evaluations of information-shortage effects.', CAST(N'1991-06-12T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'PS7777', N'Emotional Security: A New Algorithm', N'0736', 7.9900, 4000.0000, 10, 3336, N'Protecting yourself and your loved ones from undue emotional stress in the modern world. Use of computer and nutritional aids emphasized.', CAST(N'1991-06-12T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'QD5712', N'Harry Potter and the Order of the Phoenix', N'9913', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Order of the Phoenix is a fantasy novel written by British author J. K. Rowling and the fifth novel in the Harry Potter series. It follows Harry Potter''s struggles through his fifth year at Hogwarts School of Witchcraft and Wizardry, including the surreptitious return of the antagonist Lord Voldemort, O.W.L. exams, and an obstructive Ministry of Magic.', CAST(N'2003-06-27T00:00:00.000' AS DateTime), N'TL7666', N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'SA4547', N'A Dream of Spring', N'9914', 70.0000, 1000000.0000, 40, 1000000, N'A Dream of Spring is the planned title of the seventh volume of George R. R. Martin''s A Song of Ice and Fire series. The book is to follow The Winds of Winter and is intended to be the final volume of the series.', CAST(N'2024-01-01T00:00:00.000' AS DateTime), N'TC2266', N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'SU4434', N'A Feast for Crows', N'9914', 70.0000, 1000000.0000, 40, 1000000, N'A Feast for Crows is the fourth of seven planned novels in the epic fantasy series A Song of Ice and Fire by American author George R. R. Martin. The novel was first published on October 17, 2005, in the United Kingdom, with a United States edition following on November 8, 2005.', CAST(N'2005-08-01T00:00:00.000' AS DateTime), N'DU8845', N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'TC2266', N'The Winds of Winter', N'9914', 70.0000, 1000000.0000, 40, 1000000, N'The Winds of Winter is the planned sixth novel in the epic fantasy series A Song of Ice and Fire by American writer George R. R. Martin. Martin believes the last two volumes of the series will total over 3,000 manuscript pages. Martin has refrained from making hard estimates for the final release date of the novel.', CAST(N'2023-01-01T00:00:00.000' AS DateTime), N'MW2447', N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'TC3218', N'Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean', N'0877', 20.9500, 7000.0000, 10, 375, N'Profusely illustrated in color, this makes a wonderful gift book for a cuisine-oriented friend.', CAST(N'1991-10-21T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'TC4203', N'Fifty Years in Buckingham Palace Kitchens', N'0877', 11.9500, 4000.0000, 14, 15096, N'More anecdotes from the Queen''s favorite cook describing life among English royalty. Recipes, techniques, tender vignettes.', CAST(N'1991-06-12T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'TC7777', N'Sushi, Anyone?', N'0877', 14.9900, 8000.0000, 10, 4095, N'Detailed instructions on how to make authentic Japanese sushi in your spare time.', CAST(N'1991-06-12T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'TL7666', N'Harry Potter and the Goblet of Fire', N'9913', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Goblet of Fire is a fantasy novel written by British author J. K. Rowling and the fourth novel in the Harry Potter series. It follows Harry Potter, a wizard in his fourth year at Hogwarts School of Witchcraft and Wizardry, and the mystery surrounding the entry of Harry''s name into the Triwizard Tournament, in which he is forced to compete.', CAST(N'2000-07-08T00:00:00.000' AS DateTime), N'YE3356', N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'UU5128', N'The Silmarillion', N'9910', 45.0000, 2500000.0000, 40, 50000000, N'The Silmarillion is a collection of mythopoeic stories by the English writer J. R. R. Tolkien, edited and published posthumously by his son Christopher Tolkien in 1977 with assistance from the fantasy author Guy Gavriel Kay. The Silmarillion tells of Ea, a fictional universe that includes the Blessed Realm of Valinor, the once-great region of Beleriand, the sunken island of Numenor, and the continent of Middle-earth, where Tolkiens most popular works are set. After the success of The Hobbit, Tolkiens publisher Stanley Unwin requested a sequel, and Tolkien offered a draft of the stories that would later become The Silmarillion.', CAST(N'1977-09-15T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'UX2157', N'The Two Towers', N'9910', 40.0000, 200000.0000, 20, 50000000, N'The Two Towers is the second volume of J. R. R. Tolkiens high fantasy novel The Lord of the Rings. It is preceded by The Fellowship of the Ring and followed by The Return of the King.', CAST(N'1954-11-11T00:00:00.000' AS DateTime), N'EX5727', N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'VC5136', N'Harry Potter and the Philosopher''s Stone', N'9913', 45.0000, 1000000.0000, 40, 120000000, N'Harry Potter and the Philosopher''s Stone is a fantasy novel written by British author J. K. Rowling. The first novel in the Harry Potter series and Rowling''s debut novel, it follows Harry Potter, a young wizard who discovers his magical heritage on his eleventh birthday, when he receives a letter of acceptance to Hogwarts School of Witchcraft and Wizardry.', CAST(N'1997-06-26T00:00:00.000' AS DateTime), NULL, N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'YE3356', N'Harry Potter and the Prisoner of Azkaban', N'9913', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Prisoner of Azkaban is a fantasy novel written by British author J. K. Rowling and is the third in the Harry Potter series. The book follows Harry Potter, a young wizard, in his third year at Hogwarts School of Witchcraft and Wizardry. Along with friends Ronald Weasley and Hermione Granger, Harry investigates Sirius Black, an escaped prisoner from Azkaban, the wizard prison, believed to be one of Lord Voldemort''s old allies.', CAST(N'1999-07-08T00:00:00.000' AS DateTime), N'BT6646', N'999-0-999-99999-9')
INSERT [dbo].[titles] ([title_id], [title], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id], [ISBN]) VALUES (N'ZJ4675', N'The Return of the King', N'9910', 40.0000, 200000.0000, 20, 50000000, N'The Return of the King is the third and final volume of J. R. R. Tolkiens The Lord of the Rings, following The Fellowship of the Ring and The Two Towers. It was published in 1955. The story begins in the kingdom of Gondor, which is soon to be attacked by the Dark Lord Sauron.', CAST(N'1955-10-20T00:00:00.000' AS DateTime), N'UX2157', N'999-0-999-99999-9')
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [aunmind]    Script Date: 4/24/2022 7:57:09 PM ******/
CREATE NONCLUSTERED INDEX [aunmind] ON [dbo].[authors]
(
	[au_lname] ASC,
	[au_fname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__borrower__BDF201DCC7A08539]    Script Date: 4/24/2022 7:57:09 PM ******/
ALTER TABLE [dbo].[borrowers] ADD  CONSTRAINT [UQ__borrower__BDF201DCC7A08539] UNIQUE NONCLUSTERED 
(
	[card_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__borrower__DDDF0AE61D07F526]    Script Date: 4/24/2022 7:57:09 PM ******/
ALTER TABLE [dbo].[borrowers] ADD  CONSTRAINT [UQ__borrower__DDDF0AE61D07F526] UNIQUE NONCLUSTERED 
(
	[ssn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [titleidind]    Script Date: 4/24/2022 7:57:09 PM ******/
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[sales]
(
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [auidind]    Script Date: 4/24/2022 7:57:09 PM ******/
CREATE NONCLUSTERED INDEX [auidind] ON [dbo].[titleauthor]
(
	[au_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [titleidind]    Script Date: 4/24/2022 7:57:09 PM ******/
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[titleauthor]
(
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [titleind]    Script Date: 4/24/2022 7:57:09 PM ******/
CREATE NONCLUSTERED INDEX [titleind] ON [dbo].[titles]
(
	[title] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[authors] ADD  CONSTRAINT [DF__authors__phone__25869641]  DEFAULT ('UNKNOWN') FOR [phone]
GO
ALTER TABLE [dbo].[bookcopies] ADD  CONSTRAINT [DF__bookcopie__isava__6166761E]  DEFAULT ((1)) FOR [isavailable]
GO
ALTER TABLE [dbo].[bookcopies] ADD  CONSTRAINT [DF__bookcopie__isact__625A9A57]  DEFAULT ((1)) FOR [isactive]
GO
ALTER TABLE [dbo].[bookcopy_history] ADD  CONSTRAINT [DF__bookcopy___creat__5D95E53A]  DEFAULT (getdate()) FOR [createddate]
GO
ALTER TABLE [dbo].[books_borrowed] ADD  CONSTRAINT [DF__books_bor__borro__690797E6]  DEFAULT (getdate()) FOR [borroweddate]
GO
ALTER TABLE [dbo].[books_borrowed] ADD  CONSTRAINT [DF__books_bor__dueda__69FBBC1F]  DEFAULT (getdate()+(14)) FOR [duedate]
GO
ALTER TABLE [dbo].[books_borrowed] ADD  CONSTRAINT [DF__books_bor__isRet__6AEFE058]  DEFAULT ((0)) FOR [isReturned]
GO
ALTER TABLE [dbo].[borrowers] ADD  CONSTRAINT [DF__borrowers__isexp__4F47C5E3]  DEFAULT ((0)) FOR [isexpired]
GO
ALTER TABLE [dbo].[employees] ADD  CONSTRAINT [DF__librarian__hired__395884C4]  DEFAULT (getdate()) FOR [hiredate]
GO
ALTER TABLE [dbo].[employees] ADD  CONSTRAINT [DF__librarian__vacat__3A4CA8FD]  DEFAULT ((112)) FOR [vacation_hours]
GO
ALTER TABLE [dbo].[employees] ADD  CONSTRAINT [DF__librarian__ishea__3E1D39E1]  DEFAULT ((0)) FOR [ishead_librarian]
GO
ALTER TABLE [dbo].[employees] ADD  CONSTRAINT [DF__employees__isAct__03BB8E22]  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[paychecks] ADD  CONSTRAINT [DF__paychecks__creat__498EEC8D]  DEFAULT (getdate()) FOR [createddate]
GO
ALTER TABLE [dbo].[publishers] ADD  CONSTRAINT [DF__publisher__count__2A4B4B5E]  DEFAULT ('USA') FOR [country]
GO
ALTER TABLE [dbo].[shift_logs] ADD  CONSTRAINT [DF__shift_log__shift__45BE5BA9]  DEFAULT (getdate()) FOR [shiftdate]
GO
ALTER TABLE [dbo].[titles] ADD  CONSTRAINT [DF__titles__pubdate__2F10007B]  DEFAULT (getdate()) FOR [pubdate]
GO
ALTER TABLE [dbo].[titles] ADD  CONSTRAINT [DF__titles__ISBN__2B0A656D]  DEFAULT ('999-0-999-99999-9') FOR [ISBN]
GO
ALTER TABLE [dbo].[bookcopies]  WITH CHECK ADD  CONSTRAINT [FK_branchs_bookcopies] FOREIGN KEY([branch_id])
REFERENCES [dbo].[branchs] ([branch_id])
GO
ALTER TABLE [dbo].[bookcopies] CHECK CONSTRAINT [FK_branchs_bookcopies]
GO
ALTER TABLE [dbo].[bookcopies]  WITH CHECK ADD  CONSTRAINT [FK_titles_bookcopies] FOREIGN KEY([title_id])
REFERENCES [dbo].[titles] ([title_id])
GO
ALTER TABLE [dbo].[bookcopies] CHECK CONSTRAINT [FK_titles_bookcopies]
GO
ALTER TABLE [dbo].[bookcopy_history]  WITH CHECK ADD  CONSTRAINT [FK_bookcopyhistory_bookcopies] FOREIGN KEY([copy_id])
REFERENCES [dbo].[bookcopies] ([copy_id])
GO
ALTER TABLE [dbo].[bookcopy_history] CHECK CONSTRAINT [FK_bookcopyhistory_bookcopies]
GO
ALTER TABLE [dbo].[books_borrowed]  WITH CHECK ADD  CONSTRAINT [FK_booksborrowed_bookcopies] FOREIGN KEY([copy_id])
REFERENCES [dbo].[bookcopies] ([copy_id])
GO
ALTER TABLE [dbo].[books_borrowed] CHECK CONSTRAINT [FK_booksborrowed_bookcopies]
GO
ALTER TABLE [dbo].[books_borrowed]  WITH CHECK ADD  CONSTRAINT [FK_booksborrowed_borrowers] FOREIGN KEY([card_id])
REFERENCES [dbo].[borrowers] ([card_id])
GO
ALTER TABLE [dbo].[books_borrowed] CHECK CONSTRAINT [FK_booksborrowed_borrowers]
GO
ALTER TABLE [dbo].[discounts]  WITH CHECK ADD  CONSTRAINT [FK__discounts__stor___3C69FB99] FOREIGN KEY([stor_id])
REFERENCES [dbo].[stores] ([stor_id])
GO
ALTER TABLE [dbo].[discounts] CHECK CONSTRAINT [FK__discounts__stor___3C69FB99]
GO
ALTER TABLE [dbo].[employees]  WITH CHECK ADD  CONSTRAINT [FK_branchs_librarians] FOREIGN KEY([branch_id])
REFERENCES [dbo].[branchs] ([branch_id])
GO
ALTER TABLE [dbo].[employees] CHECK CONSTRAINT [FK_branchs_librarians]
GO
ALTER TABLE [dbo].[employees]  WITH CHECK ADD  CONSTRAINT [FK_degrees_librarians] FOREIGN KEY([degree_id])
REFERENCES [dbo].[degrees] ([id])
GO
ALTER TABLE [dbo].[employees] CHECK CONSTRAINT [FK_degrees_librarians]
GO
ALTER TABLE [dbo].[employees]  WITH CHECK ADD  CONSTRAINT [FK_employeetype_librarians] FOREIGN KEY([employee_type_id])
REFERENCES [dbo].[employee_type] ([id])
GO
ALTER TABLE [dbo].[employees] CHECK CONSTRAINT [FK_employeetype_librarians]
GO
ALTER TABLE [dbo].[employees]  WITH CHECK ADD  CONSTRAINT [FK_schools_librarians] FOREIGN KEY([school_id])
REFERENCES [dbo].[schools] ([id])
GO
ALTER TABLE [dbo].[employees] CHECK CONSTRAINT [FK_schools_librarians]
GO
ALTER TABLE [dbo].[paychecks]  WITH CHECK ADD  CONSTRAINT [FK_librarians_paychecks] FOREIGN KEY([employee_id])
REFERENCES [dbo].[employees] ([employee_id])
GO
ALTER TABLE [dbo].[paychecks] CHECK CONSTRAINT [FK_librarians_paychecks]
GO
ALTER TABLE [dbo].[pub_info]  WITH CHECK ADD  CONSTRAINT [FK__pub_info__pub_id__440B1D61] FOREIGN KEY([pub_id])
REFERENCES [dbo].[publishers] ([pub_id])
GO
ALTER TABLE [dbo].[pub_info] CHECK CONSTRAINT [FK__pub_info__pub_id__440B1D61]
GO
ALTER TABLE [dbo].[sales]  WITH CHECK ADD  CONSTRAINT [FK__sales__stor_id__37A5467C] FOREIGN KEY([stor_id])
REFERENCES [dbo].[stores] ([stor_id])
GO
ALTER TABLE [dbo].[sales] CHECK CONSTRAINT [FK__sales__stor_id__37A5467C]
GO
ALTER TABLE [dbo].[sales]  WITH CHECK ADD  CONSTRAINT [FK__sales__title_id__38996AB5] FOREIGN KEY([title_id])
REFERENCES [dbo].[titles] ([title_id])
GO
ALTER TABLE [dbo].[sales] CHECK CONSTRAINT [FK__sales__title_id__38996AB5]
GO
ALTER TABLE [dbo].[shift_logs]  WITH CHECK ADD  CONSTRAINT [FK_librarians_shiftlogs] FOREIGN KEY([employee_id])
REFERENCES [dbo].[employees] ([employee_id])
GO
ALTER TABLE [dbo].[shift_logs] CHECK CONSTRAINT [FK_librarians_shiftlogs]
GO
ALTER TABLE [dbo].[titleauthor]  WITH CHECK ADD  CONSTRAINT [FK__titleauth__au_id__31EC6D26] FOREIGN KEY([au_id])
REFERENCES [dbo].[authors] ([au_id])
GO
ALTER TABLE [dbo].[titleauthor] CHECK CONSTRAINT [FK__titleauth__au_id__31EC6D26]
GO
ALTER TABLE [dbo].[titleauthor]  WITH CHECK ADD  CONSTRAINT [FK__titleauth__title__32E0915F] FOREIGN KEY([title_id])
REFERENCES [dbo].[titles] ([title_id])
GO
ALTER TABLE [dbo].[titleauthor] CHECK CONSTRAINT [FK__titleauth__title__32E0915F]
GO
ALTER TABLE [dbo].[titlecategory]  WITH CHECK ADD  CONSTRAINT [FK_Titlecategory_Category] FOREIGN KEY([title_type_id])
REFERENCES [dbo].[category] ([type_id])
GO
ALTER TABLE [dbo].[titlecategory] CHECK CONSTRAINT [FK_Titlecategory_Category]
GO
ALTER TABLE [dbo].[titlecategory]  WITH CHECK ADD  CONSTRAINT [FK_TitleCategory_Titles] FOREIGN KEY([title_id])
REFERENCES [dbo].[titles] ([title_id])
GO
ALTER TABLE [dbo].[titlecategory] CHECK CONSTRAINT [FK_TitleCategory_Titles]
GO
ALTER TABLE [dbo].[titles]  WITH CHECK ADD  CONSTRAINT [FK__titles__pub_id__2E1BDC42] FOREIGN KEY([pub_id])
REFERENCES [dbo].[publishers] ([pub_id])
GO
ALTER TABLE [dbo].[titles] CHECK CONSTRAINT [FK__titles__pub_id__2E1BDC42]
GO
ALTER TABLE [dbo].[titles]  WITH CHECK ADD  CONSTRAINT [FK__titles__pub_id__5AEE82B9] FOREIGN KEY([pub_id])
REFERENCES [dbo].[publishers] ([pub_id])
GO
ALTER TABLE [dbo].[titles] CHECK CONSTRAINT [FK__titles__pub_id__5AEE82B9]
GO
ALTER TABLE [dbo].[authors]  WITH CHECK ADD  CONSTRAINT [CK__authors__au_id__24927208] CHECK  (([au_id] like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[authors] CHECK CONSTRAINT [CK__authors__au_id__24927208]
GO
ALTER TABLE [dbo].[authors]  WITH CHECK ADD  CONSTRAINT [CK__authors__zip__267ABA7A] CHECK  (([zip] like '[0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[authors] CHECK CONSTRAINT [CK__authors__zip__267ABA7A]
GO
ALTER TABLE [dbo].[bookcopies]  WITH CHECK ADD  CONSTRAINT [CK__bookcopie__condi__09746778] CHECK  (([condition]='NEW' OR [condition]='EXCELLENT' OR [condition]='GOOD' OR [condition]='WORN' OR [condition]='POOR' OR [condition]='LOST'))
GO
ALTER TABLE [dbo].[bookcopies] CHECK CONSTRAINT [CK__bookcopie__condi__09746778]
GO
ALTER TABLE [dbo].[bookcopies]  WITH CHECK ADD  CONSTRAINT [CK__bookcopie__condi__65370702] CHECK  (([condition]='NEW' OR [condition]='EXCELLENT' OR [condition]='GOOD' OR [condition]='WORN' OR [condition]='POOR'))
GO
ALTER TABLE [dbo].[bookcopies] CHECK CONSTRAINT [CK__bookcopie__condi__65370702]
GO
ALTER TABLE [dbo].[publishers]  WITH CHECK ADD  CONSTRAINT [CK__publisher__pub_i__29572725] CHECK  (([pub_id]='1756' OR [pub_id]='1622' OR [pub_id]='0877' OR [pub_id]='0736' OR [pub_id]='1389' OR [pub_id] like '99[0-9][0-9]'))
GO
ALTER TABLE [dbo].[publishers] CHECK CONSTRAINT [CK__publisher__pub_i__29572725]
GO
ALTER TABLE [dbo].[titles]  WITH CHECK ADD  CONSTRAINT [CK__titles__ISBN__2BFE89A6] CHECK  (([ISBN] like '[0-9][0-9][0-9]-[0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9]-[0-9]'))
GO
ALTER TABLE [dbo].[titles] CHECK CONSTRAINT [CK__titles__ISBN__2BFE89A6]

GO

/****** Object:  StoredProcedure [dbo].[USP_BorrowBook]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*

    Rules for borrowing a book:
    - Any reading item that is categorized as reference may not be borrowed.
    - Copies that are in POOR condition may not be borrowed.
    - When a book copy is borrowed, the copy is marked as BORROWED. BORROWED copies may not be borrowed.
    - A borrower can not use a card to borrow books, if he owes more than 10 dollars on that card.

*/

CREATE PROCEDURE [dbo].[USP_BorrowBook] 
    @copy_id AS INT,
    @card_id AS INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            --#region Check if copy is of type Reference
                IF EXISTS(
                    SELECT TOP 1 1 
                    FROM titlecategory tc
                    JOIN bookcopies bc ON bc.title_id = tc.title_id
                    WHERE bc.copy_id = @copy_id AND tc.title_type_id = (SELECT type_id FROM category c WHERE c.[type] = 'Reference')
                )
                    BEGIN
                        ;THROW 50001, 'Copy of type Reference can not be borrowed', 1 
                    END
            --#endregion
            --#region Check if copy is in POOR 
                IF EXISTS (
                    SELECT copy_id
                    FROM bookcopies 
                    WHERE condition = 'POOR' AND copy_id = @copy_id
                )
                    BEGIN
                        ;THROW 50002, 'Copies in POOR condition can not be borrowed', 1  
                    END
            --#endregion
            --#region Check if copy is BORROWED or Discarded
                IF EXISTS (
                    SELECT copy_id
                    FROM bookcopies 
                    WHERE (isactive = 0 OR isavailable = 0) AND copy_id = @copy_id
                )
                    BEGIN
                        ;THROW 50003, 'Copies that are Discarded or already Borrowed can not be borrowed.', 1  
                    END
            --#endregion
            --#region Check if borrower is available to borrow a book
                IF EXISTS (
                    SELECT * 
                    FROM borrowers 
                    WHERE card_id = @card_id AND (isexpired = 1 OR balancedue >= 10)
                )
                    BEGIN
                        ;THROW 50004, 'Either borrowers card expired or borrower owes over 10 dollars.', 1
                    END
            --#endregion
            UPDATE bookcopies SET isavailable = 0 WHERE copy_id = @copy_id
            DECLARE @id INT = (SELECT MAX(id) + 1 FROM books_borrowed)
            INSERT INTO books_borrowed 
            VALUES 
            (
                ISNULL(@id,1),
                @copy_id,
                @card_id,
                GETDATE(),
                GETDATE() + 14,
                0,
                NULL
            )
            PRINT('Book Has Been Sucessfully Borrowed')
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH
END


GO
/****** Object:  StoredProcedure [dbo].[USP_CreateAuthor]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
    Created by Nury Amanmadov
    Date created: 17.04.2022
*/

CREATE PROCEDURE [dbo].[USP_CreateAuthor]
     @au_lname VARCHAR(40)
    ,@au_fname VARCHAR(20)
    ,@au_phone CHAR(12) = '000 000-0000'
    ,@au_address VARCHAR(250) = NULL
    ,@au_city VARCHAR(20) = NULL
    ,@au_state CHAR(2) = NULL
    ,@au_zip CHAR(5) = NULL
    ,@au_contract BIT = 0
AS
BEGIN
    BEGIN TRY
        -- Generate Random AuthorID 
        DECLARE @au_id dbo.tid 
        SET @au_id = dbo.fn_GenerateRandomAuthorId(RAND())

        INSERT INTO authors 
        VALUES
        (
             @au_id
            ,@au_lname
            ,@au_fname
            ,@au_phone
            ,@au_address
            ,@au_city
            ,@au_state
            ,@au_zip
            ,@au_contract
        ) 
    END TRY 
    BEGIN CATCH
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH 
END

GO
/****** Object:  StoredProcedure [dbo].[USP_CreateBorrower]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

Rules for creating a card for borrower
    - A person can have only one valid library card at a given time.
    - A person can’t be issued a new library card, if he owes money on an expired card.
    - a person can not be younger than 10.

*/

CREATE PROCEDURE [dbo].[USP_CreateBorrower]
     @ssn VARCHAR(11)
    ,@fname VARCHAR(100)
    ,@lname VARCHAR(100)
    ,@address VARCHAR(200)
    ,@phone CHAR(12)
    ,@birthdate DATE
    ,@lg_address VARCHAR(200) = NULL
    ,@lg_name VARCHAR(100) = NULL 
    ,@lg_phone VARCHAR(12) = NULL
AS
BEGIN
    BEGIN TRY
        -- Check if borrower has an active card  
        IF EXISTS (SELECT TOP 1 1 FROM borrowers WHERE ssn = @ssn AND isexpired = 0)
            BEGIN  
                ;THROW 50001, 'A person already has an active card.', 1
            END

         -- Check if borrower has an a balancedue on expired card 
        IF EXISTS (SELECT TOP 1 1 FROM borrowers WHERE ssn = @ssn AND isexpired = 1 AND balancedue > 0)
            BEGIN 
                ;THROW 50002, 'A person owes library from previous card.', 1
            END

        -- Check if borrower is older than 10
        DECLARE @age INT = DATEDIFF(YY,@birthdate,GETDATE())
        IF(@age < 10)
            BEGIN 
                ;THROW 50003, 'Borrower can not be younger than 10.', 1 
            END
        
        DECLARE @id INT = (SELECT MAX(id) + 1 FROM borrowers)
        DECLARE @cardid INT = (SELECT MAX(card_id) + 1 FROM borrowers)

        -- validation of legal guardian details should be on the front-end 

        INSERT INTO borrowers 
        VALUES
        (
             ISNULL(@id,1) -- if first time 
            ,ISNULL(@cardid,1) -- if first time 
            ,@ssn  
            ,@fname 
            ,@lname 
            ,@address 
            ,@phone   
            ,@birthdate 
            ,GETDATE() 
            ,0 -- initial balance  
            ,0 -- default value
            ,@lg_address 
            ,@lg_name
            ,@lg_phone
        ) 
    END TRY 
    BEGIN CATCH
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH 
END

GO
/****** Object:  StoredProcedure [dbo].[USP_CreateEmployee]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
    Created by Nury Amanmadov
    Date created: 11.04.2022
*/

CREATE PROCEDURE [dbo].[USP_CreateEmployee]
(
     @firstname AS VARCHAR(100)
    ,@lastname AS VARCHAR(100)
    ,@address AS VARCHAR(200)
    ,@homephone AS CHAR(12)
    ,@cellphone AS CHAR(12)
    ,@salary_type AS CHAR(1)
    ,@salary AS DECIMAL(6,0)
    ,@birthdate DATE 
    ,@degee_id INT
    ,@school_id INT
    ,@branch_id INT
    ,@ishead_librarin BIT
    ,@emp_type_id INT
    ,@degreedate DATE
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY 
        BEGIN TRANSACTION
            DECLARE @id INT = (SELECT MAX(employee_id) + 1 FROM employees)
                INSERT INTO [pubs].[dbo].[employees] 
                VALUES (
                            ISNULL(@id,1)
                            ,@firstname 
                            ,@lastname 
                            ,@address 
                            ,@homephone 
                            ,@cellphone  
                            ,@salary_type 
                            ,@salary  
                            ,@birthdate 
                            ,GETDATE() 
                            ,114  
                            ,@degee_id 
                            ,@school_id 
                            ,@branch_id 
                            ,@ishead_librarin 
                            ,@emp_type_id 
                            ,@degreedate
                            ,1
                       )
            --#endregion
            PRINT('Employee Has Been Sucessfully Added')
        COMMIT TRANSACTION
    END TRY  
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH
END 
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteBook]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

Created by Nury Amanmadov
Date created: 16.04.2022

Rule for deleting a book  
    - Publisher related to that title will not be deleted
    - PublisherInfo related to the Publisher of that title will not be deleted
    - Author related to that title will not be deleted 
    - Records related to that title from Titles and TitleAuthor tables will be deleted 

Because there are publishers without any title on the initial database created by Microsoft (ex: pub_id with 1622 and 1756)

SELECT DISTINCT pub_id 
FROM publishers 
WHERE pub_id NOT IN 
(
    SELECT DISTINCT pub_id FROM titles 
)

*/

CREATE PROCEDURE [dbo].[USP_DeleteBook]
    @title_id dbo.tid,
    @au_id dbo.id
AS
BEGIN
    BEGIN TRY 
        BEGIN TRANSACTION
            DELETE FROM titles WHERE title_id = @title_id
            DELETE FROM titleauthor WHERE title_id = @title_id and au_id = @au_id
            PRINT('Book Has Been Sucessfully Deleted')
        COMMIT TRANSACTION
    END TRY 
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[USP_DiscardBook]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[USP_DiscardBook]
    @copy_id INT
AS 
BEGIN 
    -- Check if copy_id is valid
    IF NOT EXISTS(SELECT TOP 1 1 FROM bookcopies WHERE copy_id = @copy_id)
        BEGIN 
	        ;THROW 50001, 'Book copy with provided ID does not exist.', 1 
        END 

    -- Check if book is returned
    IF EXISTS(SELECT TOP 1 1 FROM bookcopies WHERE copy_id = @copy_id AND isavailable = 0)
        BEGIN 
	        ;THROW 50002, 'Book copy with provided ID has not been returned.', 1 
        END 

    -- Check if book has not been discarded
    IF EXISTS(SELECT TOP 1 1 FROM bookcopies WHERE copy_id = @copy_id AND isactive = 0)
        BEGIN 
	        ;THROW 50003, 'Book copy with provided ID has been already discarded.', 1 
        END  
END
GO
/****** Object:  StoredProcedure [dbo].[USP_DiscardLostBook]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_DiscardLostBook] 
    @copy_id AS INT,
    @card_id AS INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            --#region Check borrowed book exists
            IF NOT EXISTS(SELECT TOP 1 1 FROM books_borrowed WHERE card_id = @card_id AND copy_id = @copy_id AND isReturned = 0)
            BEGIN
                ;THROW 50001, 'There is no borrowed book with the given details.', 1 
            END
            --#endregion
            DECLARE @id INT = (SELECT id FROM books_borrowed WHERE card_id = @card_id AND copy_id = @copy_id AND isReturned = 0)
            DECLARE @daysElapsed INT = (SELECT DATEDIFF(DD,borroweddate,GETDATE()) FROM books_borrowed WHERE id = @id)
            
            -- Set isReturned to true
            UPDATE books_borrowed SET isReturned = 1, returndate = GETDATE() WHERE id = @id
            -- Set condition to LOST
            UPDATE bookcopies SET condition = 'LOST',isavailable = 0, isactive = 0 WHERE copy_id = @copy_id
            DECLARE @i INT = (SELECT MAX(id) + 1 FROM bookcopy_history)
            --Insert note to book history table
            INSERT INTO bookcopy_history 
            VALUES
            (
                ISNULL(@i,1),
                @copy_id,
                'Book with id:' + @copy_id + ' has been lost by user with cardid: ' + @card_id,
                GETDATE()
            )
            
            DECLARE @pr DECIMAL(6,2)
            IF(@daysElapsed > 14)
                BEGIN 
                    DECLARE @typeId INT = (SELECT tc.title_type_id FROM bookcopies bc JOIN titlecategory tc ON tc.title_id = bc.title_id WHERE copy_id = @copy_id)
                    -- Check if Juvenile
                    IF(@typeId = 4)
                        BEGIN 
                            SET @pr = .05
                        END 
                    ELSE 
                        BEGIN
                            SET @pr = .10 
                        END
                    --Update card balancedue 
                    UPDATE borrowers SET balancedue = balancedue + (@pr * @daysElapsed) WHERE card_id = @card_id
                END
        
            PRINT('Book Has Been Sucessfully discarded as LOST.')
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ExpireLibraryCards]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_ExpireLibraryCards]
AS 
BEGIN 
    UPDATE borrowers SET isexpired = 1
    WHERE DATEDIFF(YY,card_issuedate,GETDATE()) >= 10
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GenerateRandomAuthorId]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
    Created by Nury Amanmadov
    Date created: 16.04.2022 (ddMMyyyy)
*/

CREATE PROCEDURE [dbo].[USP_GenerateRandomAuthorId]
    @author_id VARCHAR(11) OUTPUT
AS
BEGIN
    DECLARE @a1 AS CHAR(3) = (SELECT(CAST((FLOOR(RAND()*(999-100+1)+100)) AS CHAR)))
    DECLARE @a2 AS CHAR(2) = (SELECT(CAST((FLOOR(RAND()*(99-10+1)+10)) AS CHAR)))
    DECLARE @a3 AS CHAR(4) = (SELECT(CAST((FLOOR(RAND()*(9999-1000+1)+1000)) AS CHAR)))
    SELECT @author_id = (SELECT @a1 + '-' + @a2 + '-' + @a3)
END

/*

DECLARE @id varchar(11) 
EXEC USP_GenerateRandomAuthorId @id OUTPUT
PRINT('Generated Random Id: ' + @id)

*/
 
GO
/****** Object:  StoredProcedure [dbo].[USP_GenerateRandomDate]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GenerateRandomDate]
    @birthdate DATE OUTPUT
AS
BEGIN
    DECLARE @StartDate DATE = '20110101', @EndDate DATE = '20220401'
    SET @birthdate = DATEADD(DAY,RAND(CHECKSUM(NEWID()))*(1 + DATEDIFF(DAY, @StartDate, @EndDate)), @StartDate)
    SELECT @birthdate
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GenerateRandomPhone]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GenerateRandomPhone]
    @phone VARCHAR(12) OUTPUT
AS
BEGIN
    DECLARE @p1 AS CHAR(3) = (SELECT(CAST((FLOOR(RAND()*(999-100+1)+100)) AS CHAR)))
    DECLARE @p2 AS CHAR(2) = (SELECT(CAST((FLOOR(RAND()*(999-100+1)+100)) AS CHAR)))
    DECLARE @p3 AS CHAR(4) = (SELECT(CAST((FLOOR(RAND()*(9999-1000+1)+1000)) AS CHAR)))
    SELECT @phone = (SELECT @p1 + '-' + @p2 + '-' + @p3)
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GenerateRandomSsn]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GenerateRandomSsn]
    @ssn VARCHAR(11) OUTPUT
AS
BEGIN
    SELECT @ssn = (
                    CAST(CAST(100 + (898 * RAND()) AS INT) AS VARCHAR(3)) + 
                    '-' + 
                    CAST(CAST(10 + (88 * RAND()) AS INT) AS VARCHAR(2)) + 
                    '-' + 
                    CAST(CAST(1000 + (8998 * RAND()) AS INT) AS VARCHAR(4))
                  )
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllAuthors]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
    Created by Nury Amanmadov
    Date created: 17.04.2022 ddMMyyyy

    Selects authors as in the form of HTML table row records 
    These records then rendered as an HTML elements on the front-end side

*/

CREATE PROCEDURE [dbo].[USP_GetAllAuthors]
AS 
BEGIN 
    SELECT TOP 20
    '<tr class="even pointer">
        <td class="a-center "><input type="checkbox" class="flat" name="table_records"></td>
        <td>'+ au_id +'</td>
        <td>'+ au_fname +'</td>
        <td>'+ au_lname +'</td>
        <td>'+ ISNULL(CAST(phone AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(address AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(city AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(state AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(zip AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(contract AS VARCHAR),'NA') +'</td>
        <td class="last"><a href="#">View</a></td>
    </tr>' AS TableRow
    FROM authors a
    ORDER BY zip DESC
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllAvailableBooks]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[USP_GetAllAvailableBooks]
AS 
BEGIN 
    SELECT *
    FROM bookcopies bc
    JOIN titles t ON t.title_id = bc.title_id
    JOIN titlecategory tc ON tc.title_id = bc.title_id
    JOIN category c ON c.type_id = tc.title_type_id
    WHERE bc.isactive = 1 AND isavailable = 1 AND c.type <> 'Reference'  
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllBooks]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
    Created by Nury Amanmadov
    Date created: 16.04.2022 ddMMyyyy

    Selects TOP 20 Book as in the form of HTML table row records 
    These records then rendered as an HTML elements on the front-end side

*/

CREATE PROCEDURE [dbo].[USP_GetAllBooks]
AS 
BEGIN 
    SELECT TOP 20
    '<tr class="even pointer">
        <td class="a-center "><input type="checkbox" class="flat" name="table_records"></td>
        <td>'+ t.title_id +'</td>
        <td>'+ title +'</td>
        <td>'+ a.au_fname + ' ' + a.au_lname +'</td>
        <td>'+ p.pub_name +'</td>
        <td>'+ type +'</td>
        <td>'+ ISNULL(CAST(price AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(advance AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(royalty AS VARCHAR),'NA') +'</td>
        <td>'+ ISNULL(CAST(ytd_sales AS VARCHAR),'NA') +'</td>
        <td class="last"><a href="#">View</a></td>
    </tr>' AS TableRow
    FROM titles t 
    JOIN publishers p ON t.pub_id = p.pub_id
    JOIN titleauthor ta ON ta.title_id = t.title_id
    JOIN authors a ON a.au_id = ta.au_id
    ORDER BY p.pub_id DESC
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllContinuingBooksByTitleId]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
    Created by Nury Amanmadov
    Date created: 18.04.2022 ddMMyyyy

    Selects all the continuing books in series

*/

CREATE PROCEDURE [dbo].[USP_GetAllContinuingBooksByTitleId]
    @title_id dbo.tid
AS 
BEGIN 
    IF NOT EXISTS(SELECT TOP 1 1 FROM titles WHERE title_id = @title_id)
        BEGIN 
            ;THROW 50001, 'Book with provided ID does not exist', 1
        END

    ;WITH CTEBooks
    AS 
    (
        SELECT   title_id AS TitleId
                ,title AS Book
                ,prequel_id
                ,CAST(t1.pubdate AS DATE) AS [Publication Date]
                ,p.pub_name AS Publisher
                ,[Order In Series] = 1
        FROM titles t1
        JOIN publishers p ON p.pub_id = t1.pub_id
        WHERE title_id = @title_id

        UNION ALL

        SELECT   t2.title_id AS TitleId
                ,t2.title AS Book
                ,t2.prequel_id
                ,CAST(t2.pubdate AS DATE) AS [Publication Date]
                ,p.pub_name AS Publisher
                ,[Order In Series] + 1
        FROM titles t2
        JOIN publishers p ON p.pub_id = t2.pub_id
        JOIN CTEBooks ON t2.prequel_id = CTEBooks.TitleId
    )
    SELECT  CTEBooks.TitleId 
            ,CTEBooks.Book
            ,ISNULL(t.title, 'No Prequel') AS PrequelBook
            ,[Publication Date]
            ,a.au_fname + ' ' + a.au_lname AS Author
            ,CTEBooks.Publisher
            ,[Order In Series]
    FROM CTEBooks
    LEFT JOIN titles t ON CTEBooks.prequel_id = t.title_id
    LEFT JOIN titleauthor ta ON ta.title_id = CTEBooks.TitleId
    LEFT JOIN authors a ON a.au_id = ta.au_id

END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllEmployee]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
    Created by Nury Amanmadov
    Date created: 17.04.2022 ddMMyyyy

    Selects employees as in the form of HTML table row records 
    These records then rendered as an HTML elements on the front-end side

*/

CREATE PROCEDURE [dbo].[USP_GetAllEmployee]
AS 
BEGIN 
    SELECT TOP 100
                    '<tr class="even pointer">
                        <td class="a-center "><input type="checkbox" class="flat" name="table_records"></td>
                        <td>'+ e.emp_id +'</td>
                        <td>'+ e.fname +'</td>
                        <td>'+ e.lname +'</td>
                        <td>'+ j.job_desc +'</td>
                        <td>'+ CAST((e.job_lvl) AS VARCHAR) +'</td>
                        <td>'+ p.pub_name +'</td>
                        <td>'+ CAST(CAST(e.hire_date AS DATE) AS VARCHAR) +'</td>
                        <td class="last"><a href="#">View</a></td>
                    </tr>' AS TableRow
    FROM employee e 
    JOIN publishers p On p.pub_id = e.pub_id 
    JOIN jobs j ON j.job_id = e.job_id
    ORDER BY hire_date 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllPrequelBooksByTitleId]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
    Created by Nury Amanmadov
    Date created: 17.04.2022 ddMMyyyy

    Selects all the prequel book series of a given book

*/

CREATE PROCEDURE [dbo].[USP_GetAllPrequelBooksByTitleId]
    @title_id dbo.tid
AS 
BEGIN 
    IF NOT EXISTS(SELECT TOP 1 1 FROM titles WHERE title_id = @title_id)
        BEGIN 
            ;THROW 50001, 'Book with provided ID does not exist', 1
        END
    ;WITH CTEBooks
    AS 
    (
        SELECT   title_id AS TitleId
                ,title AS Book
                ,prequel_id
                ,CAST(t1.pubdate AS DATE) AS [Publication Date]
                ,p.pub_name AS Publisher
        FROM titles t1
        JOIN publishers p ON p.pub_id = t1.pub_id
        WHERE title_id = @title_id

        UNION ALL

        SELECT   t2.title_id AS TitleId
                ,t2.title AS Book
                ,t2.prequel_id
                ,CAST(t2.pubdate AS DATE) AS [Publication Date]
                ,p.pub_name AS Publisher
        FROM titles t2
        JOIN publishers p ON p.pub_id = t2.pub_id
        JOIN CTEBooks ON t2.title_id = CTEBooks.prequel_id
    )
    SELECT  CTEBooks.TitleId 
            ,CTEBooks.Book
            ,ISNULL(t.title, 'No Prequel') AS PrequelBook
            ,[Publication Date]
            ,a.au_fname + ' ' + a.au_lname AS Author
            ,CTEBooks.Publisher
    FROM CTEBooks
    LEFT JOIN titles t ON CTEBooks.prequel_id = t.title_id
    LEFT JOIN titleauthor ta ON ta.title_id = CTEBooks.TitleId
    LEFT JOIN authors a ON a.au_id = ta.au_id
END

-- EXEC USP_GetAllPrequelBooksByTitleId @title_id = 'GU4539'
-- EXEC USP_GetAllPrequelBooksByTitleId @title_id = 'ZJ4675' 
-- EXEC USP_GetAllPrequelBooksByTitleId @title_id = 'SA4547'


GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllPublishers]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
    Created by Nury Amanmadov
    Date created: 17.04.2022 ddMMyyyy

    Selects publishers as in the form of HTML table row records 
    These records then rendered as an HTML elements on the front-end side

*/

CREATE PROCEDURE [dbo].[USP_GetAllPublishers]
AS 
BEGIN 
    SELECT TOP 20
                    '<tr class="even pointer">
                        <td class="a-center "><input type="checkbox" class="flat" name="table_records"></td>
                        <td>'+ p.pub_id +'</td>
                        <td>'+ p.pub_name +'</td>
                        <td>'+ p.city +'</td>
                        <td>'+ ISNULL(p.[state],'NA') +'</td>
                        <td>'+ p.country +'</td>
                        <td>'+ CAST(COUNT(DISTINCT t.title_id) AS VARCHAR) +'</td>
                        <td>'+ CAST(ISNULL(SUM(t.ytd_sales),0) AS VARCHAR) +'</td>
                        <td>'+ CAST(COUNT(DISTINCT e.emp_id) AS VARCHAR) +'</td>
                        <td class="last"><a href="#">View</a></td>
                    </tr>' AS TableRow
    FROM publishers p 
    LEFT JOIN titles t ON t.pub_id = p.pub_id
    LEFT JOIN employee e ON e.pub_id = p.pub_id
    GROUP BY p.pub_id
            ,p.pub_name
            ,p.city
            ,p.[state]
            ,p.country
    ORDER BY SUM(t.ytd_sales) DESC
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetRandomNumber]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
    Created by Nury Amanmadov
    Date created: 16.04.2022 (ddMMyyyy)
*/

CREATE PROCEDURE [dbo].[USP_GetRandomNumber] 
(
    @Lower INT, 
    @Upper INT 
)
AS
BEGIN
    IF NOT (@Lower < @Upper) 
        BEGIN 
            RAISERROR('@Lower parameter can not be greater than or equal to the @Upper parameter', 16, 1)
            RETURN -1
        END
    DECLARE @Random INT;
    SELECT @Random = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
    PRINT('Generated random number: ' + CAST(@Random AS VARCHAR))
    SELECT @Random
END


-- EXEC USP_GetRandomNumber 100,100  
-- EXEC USP_GetRandomNumber 101,100
-- EXEC USP_GetRandomNumber 100,102
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertBook]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
    Created by Nury Amanmadov
    Date created: 10.04.2022
*/


/*
    Created by Nury Amanmadov
    Date created: 10.04.2022
*/

CREATE PROCEDURE [dbo].[USP_InsertBook] 
     @book_title AS VARCHAR(100)
    ,@prequel_id AS VARCHAR(6) = NULL
    ,@book_price AS MONEY
    ,@book_advance AS MONEY
    ,@book_royalty INT
	,@book_ytd_sales INT
	,@book_notes VARCHAR(800)
	,@book_pubdate DATETIME
    ,@book_isbn VARCHAR(17)
    ,@pub_id AS CHAR(4) = NULL
    ,@pub_name AS VARCHAR(40) = NULL
    ,@pub_city AS VARCHAR(20) = NULL
    ,@pub_state AS CHAR(2) = NULL
    ,@pub_country AS VARCHAR(30) = NULL
    ,@author_id VARCHAR(11) = NULL
    ,@au_lname VARCHAR(40) = NULL
    ,@au_fname VARCHAR(20) = NULL
    ,@au_phone CHAR(12) = NULL
    ,@au_city VARCHAR(20) = NULL
    ,@au_state CHAR(2) = NULL
    ,@au_order TINYINT = 1
    ,@royalty_per INT = 100
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION

            --#region Insert into Publisher Table
                IF (@pub_id IS NULL)
                    --#region Create New Publisher
                    BEGIN 
                        -- Create pub_id as Max Id + 1
                        SET @pub_id = (SELECT CAST(MAX(CAST(pub_id AS INT) + 1) AS VARCHAR) FROM publishers AS VARCHAR)
                        
                        INSERT INTO [pubs].[dbo].[publishers] 
                        VALUES  (
                                    ISNULL(@pub_id,1)
                                    ,@pub_name
                                    ,@pub_city
                                    ,@pub_state
                                    ,@pub_country
                                )

                        --#region Insert into Pub_Info Table 
                            DECLARE @pr_info AS VARCHAR(255)
                            SET @pr_info = (
                                                SELECT  'This is sample text data for ' 
                                                        + pub_name + ', publisher ' 
                                                        + pub_id + ' in the pubs database. ' 
                                                        + pub_name + ' is located in ' + city + ' ' + country + '.' AS pr_info
                                                FROM [pubs].[dbo].[publishers] p 
                                                WHERE p.pub_id = @pub_id
                                            )

                            INSERT INTO [pubs].[dbo].[pub_info] 
                            VALUES  (
                                        ISNULL(@pub_id,1)
                                        ,NULL
                                        ,@pr_info
                                    )
                        --#endregion
                    END 
                    --#endregion
                ELSE 
                    BEGIN
                        -- Just to make sure that selected publisher exists in the database
                        IF NOT EXISTS (SELECT TOP 1 1 FROM publishers p WHERE pub_id = @pub_id)
                            BEGIN
                                ;THROW 50001, 'Publisher with selected ID does not exist', 1
                            END  
                        ELSE 
                            BEGIN 
                                -- Setting params. Will be inserted into Audit.Book table 
                                SELECT   @pub_name = p.pub_name
                                        ,@pub_city = p.city
                                        ,@pub_state = p.[state]
                                        ,@pub_country = p.country
                                FROM publishers p
                                WHERE p.pub_id = @pub_id 
                            END    
                    END 

            --#endregion

            --#region Insert into Titles Table

                --#region Creating Random TitleId
                    DECLARE @random_title_id [dbo].[tid] = [dbo].[fn_GenerateRandomTitleId](RAND())
                --#endregion

                INSERT INTO titles
                VALUES
                (
                     @random_title_id
                    ,@book_title
                    ,ISNULL(@pub_id,1)
                    ,@book_price
                    ,@book_advance
                    ,@book_royalty
                    ,@book_ytd_sales
                    ,@book_notes
                    ,@book_pubdate
                    ,@prequel_id
                    ,@book_isbn
                )

            --#endregion

            --#region Insert into Authors Table

                DECLARE @au_zip CHAR(5)
                DECLARE @au_contract BIT
                DECLARE @au_address VARCHAR(40)

                IF(@author_id IS NULL)
                    BEGIN 
                        -- Generate Random AuthorID
                        SET @author_id = dbo.fn_GenerateRandomAuthorId(RAND())
                        
                        -- Setting Random Zip in the 99xyz format
                        SET @au_zip = '99'+ (SELECT(CAST((FLOOR(RAND()*(999-100+1)+100)) AS CHAR)))

                        -- Setting @au_contract as random 
                        SET @au_contract = (SELECT(CAST((FLOOR(RAND()*(1-0+1)+0)) AS BIT)))

                        -- Setting Random Address from AdventureWorks DB Person.Address table
                        SET @au_address = (SELECT TOP 1 LEFT(AddressLine1,40) FROM AdventureWorks.Person.Address WHERE AddressLine1 IS NOT NULL ORDER BY NEWID())
                    
                        INSERT INTO authors 
                        VALUES
                        (
                             @author_id
                            ,@au_lname
                            ,@au_fname
                            ,@au_phone
                            ,@au_address
                            ,@au_city
                            ,@au_state
                            ,@au_zip
                            ,@au_contract
                        )
                    END
                ELSE
                    BEGIN
                        IF NOT EXISTS (SELECT TOP 1 1 FROM authors a WHERE a.au_id = @author_id)
                            BEGIN
                                ;THROW 50002, 'Author with selected ID does not exist', 1 
                            END
                        ELSE 
                            BEGIN  
                                SELECT   @au_lname = a.au_lname
                                        ,@au_fname = a.au_fname
                                        ,@au_phone = a.phone
                                        ,@au_city = a.city
                                        ,@au_state = a.[state]
                                FROM authors a 
                                WHERE a.au_id = @author_id
                            END 
                    END

            --#endregion

            --#region Insert into TitleAuthor Table
            
                INSERT INTO titleauthor
                VALUES
                (
                     @author_id
                    ,@random_title_id
                    ,@au_order
                    ,@royalty_per
                )
            --#endregion

            --#region Insert into Audit Table

                INSERT INTO Audit.Book 
                VALUES
                (
                    ISNULL(@pub_id,1) 
                    ,@pub_name 
                    ,@pub_city   
                    ,@pub_state  
                    ,@pub_country
                    ,@random_title_id 
                    ,@prequel_id
                    ,@book_title 
                    ,NULL 
                    ,@book_price 
                    ,@book_advance 
                    ,@book_royalty  
                    ,@book_ytd_sales  
                    ,@book_notes  
                    ,@book_pubdate  
                    ,@author_id  
                    ,@au_lname
                    ,@au_fname 
                    ,@au_phone 
                    ,@au_address 
                    ,@au_city 
                    ,@au_state
                    ,@au_zip
                    ,@au_contract 
                    ,@royalty_per 
                    ,@au_order 
                    ,GETDATE()
                    ,SYSTEM_USER
                )
            --#endregion

            PRINT('Book Has Been Sucessfully Added')

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH
END

/*

    EXEC USP_InsertBook @pub_id = 9910, @pub_name = 'Allen & Unwin'
    ,@city = 'London', @state = NULL, @country = 'UK' 
    ,@book_tite = 'LOTR1', @book_type = 'Fantasy' 
    ,@book_price = 40, @book_advance = 20000, @book_royalty = 5000000.0
	,@book_ytd_sales = 1234567, @book_notes = 'Best book', @book_pubdate = '1990-01-01' 
    ,@au_lname = 'J', @au_fname = 'Tolkien'
    ,@au_phone = '929 123-4567', @au_city = 'London', @au_state = NULL, @royalty_per = 20


*/

GO
/****** Object:  StoredProcedure [dbo].[USP_InsertCoAuthorForTitle]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
    Created by Nury Amanmadov
    Date created: 16.04.2022
*/

CREATE PROCEDURE [dbo].[USP_InsertCoAuthorForTitle]
     @title_id dbo.tid 
    ,@au_id VARCHAR(11) = NULL
    ,@au_lname VARCHAR(40) = NULL
    ,@au_fname VARCHAR(20) = NULL
    ,@au_phone CHAR(12) = '000-000-0000'
    ,@au_city VARCHAR(20) = NULL
    ,@au_state CHAR(2) = NULL
    ,@au_order TINYINT = 2
    ,@royalty_per INT = 0
AS
BEGIN
    BEGIN TRY 
        BEGIN TRANSACTION
            IF NOT EXISTS(SELECT TOP 1 1 FROM titles WHERE title_id = @title_id)
                BEGIN 
                    ;THROW 50001, 'Book with provided ID does not exist', 1
                END

            IF(@au_id IS NULL)
                BEGIN
                    DECLARE @au_zip CHAR(5)
                    DECLARE @au_contract BIT
                    DECLARE @au_address VARCHAR(40)

                    -- Generate Random AuthorID
                    SET @au_id = dbo.fn_GenerateRandomAuthorId(RAND())

                    -- Setting Random Zip in the 99xyz format
                    SET @au_zip = '99'+ (SELECT(CAST((FLOOR(RAND()*(999-100+1)+100)) AS CHAR)))

                    -- Setting @au_contract as random 
                    SET @au_contract = (SELECT(CAST((FLOOR(RAND()*(1-0+1)+0)) AS BIT)))

                    -- Setting Random Address from AdventureWorks DB Person.Address table
                    SET @au_address =   (
                                            SELECT TOP 1 LEFT(AddressLine1,40) 
                                            FROM AdventureWorks.Person.Address 
                                            WHERE AddressLine1 IS NOT NULL 
                                            ORDER BY NEWID()
                                        )
                
                    INSERT INTO authors 
                    VALUES
                    (
                         @au_id
                        ,@au_lname
                        ,@au_fname
                        ,@au_phone
                        ,@au_address
                        ,@au_city
                        ,@au_state
                        ,@au_zip
                        ,@au_contract
                    )     

                    INSERT INTO titleauthor
                    VALUES
                    (
                         @au_id
                        ,@title_id
                        ,@au_order
                        ,@royalty_per
                    )
                END
            ELSE 
                BEGIN 
                    IF NOT EXISTS(SELECT TOP 1 1 FROM authors WHERE au_id = @au_id)
                        BEGIN 
                            ;THROW 50002, 'Author with provided ID does not exist', 1
                        END
                    ELSE 
                        BEGIN 
                            INSERT INTO titleauthor
                            VALUES
                            (
                                 @au_id
                                ,@title_id
                                ,@au_order
                                ,@royalty_per
                            )
                        END
                END
            PRINT('CoAuthor for the Provided Book Has Been Sucessfully Added')
        COMMIT TRANSACTION
    END TRY 
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertRandomBorrower]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_InsertRandomBorrower]
AS
BEGIN
    DECLARE @id INT 
    DECLARE @ssn VARCHAR(11) 
    DECLARE @fname VARCHAR(100) 
    DECLARE @lname VARCHAR(100) 
    DECLARE @address VARCHAR(200) 
    DECLARE @phone CHAR(12) 
    DECLARE @birthdate DATE
    DECLARE @cardissuedate DATE
    DECLARE @balancedue DECIMAL(6,2)
    DECLARE @lgname VARCHAR(200) = NULL 
    DECLARE @lgaddress VARCHAR(200) = NULL 
    DECLARE @lgphone VARCHAR(200) = NULL 

    SET @id = (SELECT MAX(id) + 1 FROM borrowers )
    SET @fname = dbo.fn_GenerateFirstName()
    SET @lname = dbo.fn_GenerateLastName()
    SET @ssn = dbo.fn_GenerateRandomSsn(RAND())
    SET @address = dbo.fn_GenerateRandomAddress()
    SET @phone = dbo.fn_GenerateRandomPhone(RAND())

    SET @birthdate = dbo.fn_GenerateRandomDate('1999-01-01','2010-01-01',RAND())
    DECLARE @age INT = DATEDIFF(YY,@birthdate,GETDATE())
    SET @cardissuedate = DATEADD(year, dbo.fn_GetRandomNumber(5,@age,RAND()), @birthdate)
    
    SET @balancedue = 0
    
    IF(@age < 17)
        BEGIN
            SET @lgname = dbo.fn_GenerateFirstName()
            --Set randomly address of borrower same as guardians
            DECLARE @isSameAddress BIT = CAST(ROUND(RAND(),0) AS BIT)
            IF(@isSameAddress = 0) 
                BEGIN 
                    SET @lgaddress = @address 
                END  
            ELSE 
                BEGIN 
                    SET @lgaddress = dbo.fn_GenerateRandomAddress()
                END 
            SET @lgphone = dbo.fn_GenerateRandomPhone(RAND())
        END 

    INSERT INTO borrowers
    VALUES 
    (
         ISNULL(@id,1) -- if first time 
        ,ISNULL(@id,1) -- if first time 
        ,@ssn  
        ,@fname 
        ,@lname 
        ,@address 
        ,@phone   
        ,@birthdate 
        ,@cardissuedate 
        ,@balancedue 
        ,0 -- default value
        ,@lgaddress 
        ,@lgname
        ,@lgphone  
    )

    PRINT('Borrower sucessfully created.')
END





GO
/****** Object:  StoredProcedure [dbo].[USP_ReturnBook]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_ReturnBook]
    @card_id INT,
    @copy_id INT
AS 
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            --#region Check borrowed book exists
            IF NOT EXISTS(SELECT TOP 1 1 FROM books_borrowed WHERE card_id = @card_id AND copy_id = @copy_id AND isReturned = 0)
            BEGIN
                ;THROW 50001, 'There is no borrowed book with the given details.', 1 
            END
            --#endregion
            DECLARE @id INT = (SELECT id FROM books_borrowed WHERE card_id = @card_id AND copy_id = @copy_id AND isReturned = 0)
            DECLARE @daysElapsed INT = (SELECT DATEDIFF(DD,borroweddate,GETDATE()) FROM books_borrowed WHERE id = @id)
            --PRINT(CAST(@daysElapsed as varchar))

            -- Set book available to borrow
            UPDATE bookcopies SET isavailable = 1 WHERE copy_id = @copy_id
            -- Set isReturned to true
            UPDATE books_borrowed SET isReturned = 1, returndate = GETDATE() WHERE id = @id
            
            DECLARE @pr DECIMAL(6,2)
            IF(@daysElapsed > 14)
                BEGIN 
                    DECLARE @typeId INT = (SELECT tc.title_type_id FROM bookcopies bc JOIN titlecategory tc ON tc.title_id = bc.title_id WHERE copy_id = @copy_id)
                    -- Check if Juvenile
                    IF(@typeId = 4)
                        BEGIN 
                            SET @pr = .05
                        END 
                    ELSE 
                        BEGIN
                            SET @pr = .10 
                        END
                    --Update card balancedue 
                    UPDATE borrowers SET balancedue = balancedue + (@pr * @daysElapsed) WHERE card_id = @card_id
                END
            
            PRINT('Book Has Been Sucessfully Returned')
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT('An Error Occured During The Transaction. Error SP: ' + ERROR_PROCEDURE() + 'Error line: ' + CAST(ERROR_LINE() AS VARCHAR))
        PRINT(ERROR_MESSAGE())
    END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateEmployeeVacationHours]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_UpdateEmployeeVacationHours]
AS 
BEGIN 
    UPDATE employees 
    SET vacation_hours = CASE 
                            WHEN DATEDIFF(YY,hiredate,GETDATE()) BETWEEN 0 AND 5 THEN 114
                            WHEN DATEDIFF(YY,hiredate,GETDATE()) BETWEEN 5 AND 10 THEN 154
                            ELSE 200
                         END
    FROM employees
END

GO
/****** Object:  Trigger [dbo].[CheckBookcopies]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[CheckBookcopies] 
ON [dbo].[bookcopies]
INSTEAD OF INSERT
AS
BEGIN
IF EXISTS(
            SELECT TOP 1 1 
            FROM bookcopies 
            WHERE branch_id = (SELECT branch_id FROM inserted) 
            AND title_id = (SELECT title_id FROM inserted) AND isactive = 1
         )
            BEGIN
                RAISERROR('There is already a copy of this book on this branch', 10, 1)
                ROLLBACK
            END
END


-- insert into bookcopies values(53,'CI5668',1,'GOOD',1,1)
GO
ALTER TABLE [dbo].[bookcopies] ENABLE TRIGGER [CheckBookcopies]
GO
/****** Object:  Trigger [dbo].[CheckEmployees]    Script Date: 4/24/2022 7:57:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[CheckEmployees] 
ON [dbo].[employees]
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @branchId INT = (SELECT branch_id FROM inserted)
    DECLARE @isHead BIT = (SELECT ishead_librarian FROM inserted)
    DECLARE @empTypeId INT = (SELECT employee_type_id FROM inserted)
    DECLARE @salaryType CHAR(1) = (SELECT salary_type FROM inserted)
    DECLARE @salary DECIMAL(6,0) = (SELECT salary FROM inserted)
    DECLARE @degreeid INT = (SELECT degree_id FROM inserted)
    -- phone can be used as unique identifier
    DECLARE @phone VARCHAR(12) = (SELECT cellphone FROM inserted)

    
    IF(@isHead = 1)
    BEGIN 
        -- Check if head librarian exists for the branch
        IF EXISTS(SELECT TOP 1 1 FROM employees WHERE branch_id = @branchId AND ishead_librarian = 1)
        BEGIN
            RAISERROR('There is already a head librarian on this branch', 10, 1)
            ROLLBACK
        END

        -- Check if employee is of type librarian
        IF(@empTypeId <> 1)
            BEGIN
                RAISERROR('Only librarians can be head librarian', 10, 1)
                ROLLBACK
            END
    END
    
    -- Check if librarian exists
    IF EXISTS(SELECT TOP 1 1 FROM employees WHERE cellphone = @phone AND isActive = 1)
        BEGIN
            RAISERROR('Employee is already assigned to', 10, 1)
            ROLLBACK
        END

    -- Check if librarian exists
    IF(@salaryType = 'C' AND @salary < 15)
        BEGIN
            RAISERROR('Minimum hourly pay for clerical employees must be greater than 15 dollars.', 10, 1)
            ROLLBACK
        END
    
    IF(@empTypeId = 1 AND (@salary < 20000 OR @salary > 70000))
        BEGIN
            RAISERROR('Salary for librarians must be between 20000 and 70000', 10, 1)
            ROLLBACK
        END
    
    IF(@empTypeId = 1 AND @degreeid <> 2)
        BEGIN
            RAISERROR('Librarian must have earned MS degree in Library Sciences.', 10, 1)
            ROLLBACK
        END

    PRINT('Employee has been sucessfully added.')
END


GO
ALTER TABLE [dbo].[employees] ENABLE TRIGGER [CheckEmployees]
GO

GO 
CREATE TRIGGER [dbo].[CheckPaychecks] 
ON [dbo].[paychecks]
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @empid INT = (SELECT employee_id FROM inserted)
    DECLARE @amount BIT = (SELECT amount FROM inserted)
    DECLARE @createddate DATE = (SELECT createddate FROM inserted)

    -- Check if employee is of type clerical and with given id exists
    IF NOT EXISTS(SELECT TOP 1 1 FROM employees WHERE employee_id = @empid AND salary_type = 'C')
        BEGIN
            RAISERROR('There is no employee with given Id and of type clerical.', 10, 1)
            ROLLBACK
        END

    -- Check if amount is bigger than 15
    IF(@amount < 15)
        BEGIN
            RAISERROR('Amount must be bigger than 15.', 10, 1)
            ROLLBACK
        END
    
    PRINT('Paycheck has been sucessfully created.')
END


GO
ALTER TABLE [dbo].[employees] ENABLE TRIGGER [CheckEmployees]

GO
USE [master]
GO
ALTER DATABASE [pubs] SET  READ_WRITE 
GO
