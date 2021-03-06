USE [master]
GO
/****** Object:  Database [pubs]    Script Date: 4/18/2022 1:47:15 PM ******/
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
/****** Object:  Schema [Audit]    Script Date: 4/18/2022 1:47:15 PM ******/
CREATE SCHEMA [Audit]
GO
/****** Object:  UserDefinedDataType [dbo].[empid]    Script Date: 4/18/2022 1:47:15 PM ******/
CREATE TYPE [dbo].[empid] FROM [char](9) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[id]    Script Date: 4/18/2022 1:47:15 PM ******/
CREATE TYPE [dbo].[id] FROM [varchar](11) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tid]    Script Date: 4/18/2022 1:47:15 PM ******/
CREATE TYPE [dbo].[tid] FROM [varchar](6) NOT NULL
GO
/****** Object:  Table [dbo].[authors]    Script Date: 4/18/2022 1:47:15 PM ******/
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
/****** Object:  Table [dbo].[titles]    Script Date: 4/18/2022 1:47:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[titles](
	[title_id] [dbo].[tid] NOT NULL,
	[title] [varchar](100) NULL,
	[type] [char](40) NULL,
	[pub_id] [char](4) NULL,
	[price] [money] NULL,
	[advance] [money] NULL,
	[royalty] [int] NULL,
	[ytd_sales] [int] NULL,
	[notes] [varchar](800) NULL,
	[pubdate] [datetime] NOT NULL,
	[prequel_id] [varchar](6) NULL,
 CONSTRAINT [UPKCL_titleidind] PRIMARY KEY CLUSTERED 
(
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[titleauthor]    Script Date: 4/18/2022 1:47:15 PM ******/
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
/****** Object:  View [dbo].[titleview]    Script Date: 4/18/2022 1:47:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[titleview]
AS
select title, au_ord, au_lname, price, ytd_sales, pub_id
from authors, titles, titleauthor
where authors.au_id = titleauthor.au_id
   AND titles.title_id = titleauthor.title_id

GO
/****** Object:  Table [Audit].[Book]    Script Date: 4/18/2022 1:47:15 PM ******/
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
/****** Object:  Table [dbo].[discounts]    Script Date: 4/18/2022 1:47:15 PM ******/
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
/****** Object:  Table [dbo].[employee]    Script Date: 4/18/2022 1:47:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[employee](
	[emp_id] [dbo].[empid] NOT NULL,
	[fname] [varchar](20) NOT NULL,
	[minit] [char](1) NULL,
	[lname] [varchar](30) NOT NULL,
	[job_id] [smallint] NOT NULL,
	[job_lvl] [tinyint] NULL,
	[pub_id] [char](4) NOT NULL,
	[hire_date] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [employee_ind]    Script Date: 4/18/2022 1:47:15 PM ******/
CREATE CLUSTERED INDEX [employee_ind] ON [dbo].[employee]
(
	[lname] ASC,
	[fname] ASC,
	[minit] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[jobs]    Script Date: 4/18/2022 1:47:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[jobs](
	[job_id] [smallint] IDENTITY(1,1) NOT NULL,
	[job_desc] [varchar](50) NOT NULL,
	[min_lvl] [tinyint] NOT NULL,
	[max_lvl] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[job_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pub_info]    Script Date: 4/18/2022 1:47:15 PM ******/
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
/****** Object:  Table [dbo].[publishers]    Script Date: 4/18/2022 1:47:15 PM ******/
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
/****** Object:  Table [dbo].[roysched]    Script Date: 4/18/2022 1:47:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[roysched](
	[title_id] [dbo].[tid] NOT NULL,
	[lorange] [int] NULL,
	[hirange] [int] NULL,
	[royalty] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sales]    Script Date: 4/18/2022 1:47:15 PM ******/
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
/****** Object:  Table [dbo].[stores]    Script Date: 4/18/2022 1:47:15 PM ******/
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
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9910', N'Allen & Unwin', N'London', NULL, N'UK', N'UX2157', N'EX5727', N'The Two Towers', N'	Fantasy                                ', 40.0000, 200000.0000, 20, 50000000, N'The Two Towers is the second volume of J. R. R. Tolkiens high fantasy novel The Lord of the Rings. 
                                    It is preceded by The Fellowship of the Ring and followed by The Return of the King.', CAST(N'1954-08-29T00:00:00.000' AS DateTime), N'254-26-6712', N'J.R.R.', N'Tolkien', N'            ', NULL, N'London', NULL, NULL, NULL, 100, 1, CAST(N'2022-04-16T18:40:36.707' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9910', N'Allen & Unwin', N'London', NULL, N'UK', N'ZJ4675', N'UX2157', N'The Return of the King', N'Fantasy                                 ', 40.0000, 200000.0000, 20, 50000000, N'The Return of the King is the third and final volume of J. R. R. Tolkiens The Lord of the Rings, following The Fellowship of the Ring and The Two Towers. It was published in 1955. The story begins in the kingdom of Gondor, which is soon to be attacked by the Dark Lord Sauron.', CAST(N'1955-10-20T00:00:00.000' AS DateTime), N'254-26-6712', N'J.R.R.', N'Tolkien', N'            ', NULL, N'London', NULL, NULL, NULL, 100, 1, CAST(N'2022-04-16T20:31:32.060' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9910', N'Allen & Unwin', N'London', NULL, N'UK', N'GE1743', NULL, N'The Hobbit', N'Fantasy                                 ', 60.0000, 50000.0000, 15, 50000000, N'The Hobbit, or There and Back Again is a childrens fantasy novel by English author J. R. R. Tolkien. It was published in 1937 to wide critical acclaim, being nominated for the Carnegie Medal and awarded a prize from the New York Herald Tribune for best juvenile fiction. The book remains popular and is recognized as a classic in childrens literature.', CAST(N'1937-09-21T00:00:00.000' AS DateTime), N'254-26-6712', N'J.R.R.', N'Tolkien', N'            ', NULL, N'London', NULL, NULL, NULL, 100, 1, CAST(N'2022-04-16T20:37:36.807' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9910', N'Allen & Unwin', N'London', NULL, N'UK', N'UU5128', NULL, N'The Silmarillion', N'Mythopoeia Fantasy                      ', 45.0000, 2500000.0000, 40, 50000000, N'The Silmarillion is a collection of mythopoeic stories by the English writer J. R. R. Tolkien, edited and published posthumously by his son Christopher Tolkien in 1977 with assistance from the fantasy author Guy Gavriel Kay. The Silmarillion tells of Ea, a fictional universe that includes the Blessed Realm of Valinor, the once-great region of Beleriand, the sunken island of Numenor, and the continent of Middle-earth, where Tolkiens most popular works are set. After the success of The Hobbit, Tolkiens publisher Stanley Unwin requested a sequel, and Tolkien offered a draft of the stories that would later become The Silmarillion.', CAST(N'1977-09-15T00:00:00.000' AS DateTime), N'254-26-6712', N'J.R.R.', N'Tolkien', N'            ', NULL, N'London', NULL, NULL, NULL, 100, 1, CAST(N'2022-04-16T20:41:43.403' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9911', N'Crown Publishing Group', N'New York City', N'NY', N'US', N'BR5671', NULL, N'Why Nations Fail', N'Comparative Politics, Economics         ', 70.0000, 100000.0000, 30, 500000, N'Why Nations Fail: The Origins of Power, Prosperity, and Poverty, first published in 2012, is a book by economists Daron Acemoglu and James Robinson. It summarizes and popularizes previous research by the authors and many other scientists. Building on the new institutional economics, Robinson and Acemoglu see in political and economic institutions — a set of rules and enforcement mechanisms that exist in society — the main reason for differences in the economic and social development of different states, considering, that other factors (geography, climate, genetics, culture, religion, elite ignorance) are secondary.', CAST(N'2012-03-20T00:00:00.000' AS DateTime), N'408-40-8965', N'Acemoglu', N'Daron', N'999 000-0000', N'65, rue Faubourg St Antoine', N'Newton', N'MA', N'99402', 0, 50, 1, CAST(N'2022-04-16T21:07:32.383' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9912', N'Cambridge University Press', N'Cambridge', NULL, N'UK', N'FK3916', NULL, N'Economic Origins of Dictatorship and Democracy', N'Economics, Macroeconomics               ', 30.0000, 50000.0000, 15, 500000, N'Book develops a framework for analyzing the creation and consolidation of democracy. Different social groups prefer different political institutions because of the way they allocate political power and resources. Thus democracy is preferred by the majority of citizens, but opposed by elites. Dictatorship nevertheless is not stable when citizens can threaten social disorder and revolution.', CAST(N'2012-09-01T00:00:00.000' AS DateTime), N'408-40-8965', N'Acemoglu', N'Daron', N'999 000-0000', NULL, N'Newton', N'MA', NULL, NULL, 50, 1, CAST(N'2022-04-16T21:19:14.683' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9913', N'Bloomsbury Publishing', N'London', N'  ', N'UK', N'VC5136', NULL, N'Harry Potter and the Philosopher''s Stone', N'Fantasy                                 ', 45.0000, 1000000.0000, 40, 120000000, N'Harry Potter and the Philosopher''s Stone is a fantasy novel written by British author J. K. Rowling. The first novel in the Harry Potter series and Rowling''s debut novel, it follows Harry Potter, a young wizard who discovers his magical heritage on his eleventh birthday, when he receives a letter of acceptance to Hogwarts School of Witchcraft and Wizardry.', CAST(N'1997-06-26T00:00:00.000' AS DateTime), N'182-52-8743', N'Rowling', N'Joanne', N'999 000-0000', N'3833, boulevard Beau Marchais', N'YATE', N'  ', N'99796', 0, 100, 1, CAST(N'2022-04-17T17:09:52.727' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9913', N'Bloomsbury Publishing', N'London', N'  ', N'UK', N'BT6646', N'VC5136', N'Harry Potter and the Chamber of Secrets', N'Fantasy                                 ', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Chamber of Secrets is a fantasy novel written by British author J. K. Rowling and the second novel in the Harry Potter series. The plot follows Harry''s second year at Hogwarts School of Witchcraft and Wizardry, during which a series of messages on the walls of the school''s corridors warn that the "Chamber of Secrets" has been opened and that the "heir of Slytherin" would kill all pupils who do not come from all-magical families.', CAST(N'1998-07-02T00:00:00.000' AS DateTime), N'182-52-8743', N'Rowling', N'Joanne', N'999 000-0000', NULL, N'YATE', N'  ', NULL, NULL, 100, 1, CAST(N'2022-04-17T17:16:05.440' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9913', N'Bloomsbury Publishing', N'London', N'  ', N'UK', N'YE3356', N'BT6646', N'Harry Potter and the Prisoner of Azkaban', N'Fantasy                                 ', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Prisoner of Azkaban is a fantasy novel written by British author J. K. Rowling and is the third in the Harry Potter series. The book follows Harry Potter, a young wizard, in his third year at Hogwarts School of Witchcraft and Wizardry. Along with friends Ronald Weasley and Hermione Granger, Harry investigates Sirius Black, an escaped prisoner from Azkaban, the wizard prison, believed to be one of Lord Voldemort''s old allies.', CAST(N'1999-07-08T00:00:00.000' AS DateTime), N'182-52-8743', N'Rowling', N'Joanne', N'999 000-0000', NULL, N'YATE', N'  ', NULL, NULL, 100, 1, CAST(N'2022-04-17T17:17:20.160' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9913', N'Bloomsbury Publishing', N'London', N'  ', N'UK', N'TL7666', N'YE3356', N'Harry Potter and the Goblet of Fire', N'Fantasy                                 ', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Goblet of Fire is a fantasy novel written by British author J. K. Rowling and the fourth novel in the Harry Potter series. It follows Harry Potter, a wizard in his fourth year at Hogwarts School of Witchcraft and Wizardry, and the mystery surrounding the entry of Harry''s name into the Triwizard Tournament, in which he is forced to compete.', CAST(N'2000-07-08T00:00:00.000' AS DateTime), N'182-52-8743', N'Rowling', N'Joanne', N'999 000-0000', NULL, N'YATE', N'  ', NULL, NULL, 100, 1, CAST(N'2022-04-17T17:18:25.333' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9912', N'Cambridge University Press', N'Cambridge', NULL, N'UK', N'BL4371', NULL, N'Modern Computer Algebra', N'Computer Science                        ', 100.0000, 50000.0000, 10, 10000, N'Computer algebra systems are now ubiquitous in all areas of science and engineering. This highly successful textbook, widely regarded as the bible of computer algebra, gives a thorough introduction to the algorithmic basis of the mathematical engine in computer algebra systems.', CAST(N'2013-01-01T00:00:00.000' AS DateTime), N'388-60-7495', N'Von Zur Gathen', N'Joachim', N'000 000-0000', N'9918 Scottsdale Rd.', N'Bonn', NULL, N'99409', 0, 50, 1, CAST(N'2022-04-16T21:39:33.237' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9913', N'Bloomsbury Publishing', N'London', N'  ', N'UK', N'QD5712', N'TL7666', N'Harry Potter and the Order of the Phoenix', N'Fantasy                                 ', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Order of the Phoenix is a fantasy novel written by British author J. K. Rowling and the fifth novel in the Harry Potter series. It follows Harry Potter''s struggles through his fifth year at Hogwarts School of Witchcraft and Wizardry, including the surreptitious return of the antagonist Lord Voldemort, O.W.L. exams, and an obstructive Ministry of Magic.', CAST(N'2003-06-27T00:00:00.000' AS DateTime), N'182-52-8743', N'Rowling', N'Joanne', N'999 000-0000', NULL, N'YATE', N'  ', NULL, NULL, 100, 1, CAST(N'2022-04-17T17:19:41.263' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9913', N'Bloomsbury Publishing', N'London', N'  ', N'UK', N'LS2238', N'QD5712', N'Harry Potter and the Half-Blood Prince', N'Fantasy                                 ', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Half-Blood Prince is a fantasy novel written by British author J.K. Rowling and the sixth and penultimate novel in the Harry Potter series. Set during Harry Potter''s sixth year at Hogwarts, the novel explores the past of the boy wizard''s nemesis, Lord Voldemort, and Harry''s preparations for the final battle against Voldemort alongside his headmaster and mentor Albus Dumbledore.', CAST(N'2005-07-16T00:00:00.000' AS DateTime), N'182-52-8743', N'Rowling', N'Joanne', N'999 000-0000', NULL, N'YATE', N'  ', NULL, NULL, 100, 1, CAST(N'2022-04-17T17:20:48.030' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9913', N'Bloomsbury Publishing', N'London', N'  ', N'UK', N'GU4539', N'LS2238', N'Harry Potter and the Deathly Hallows', N'Fantasy                                 ', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Deathly Hallows is a fantasy novel written by British author J. K. Rowling and the seventh and final novel of the main Harry Potter series. It was released on 14 July 2007 in the United Kingdom by Bloomsbury Publishing, in the United States by Scholastic, and in Canada by Raincoast Books. The novel chronicles the events directly following Harry Potter and the Half-Blood Prince (2005) and the final confrontation between the wizards Harry Potter and Lord Voldemort.', CAST(N'2007-07-14T00:00:00.000' AS DateTime), N'182-52-8743', N'Rowling', N'Joanne', N'999 000-0000', NULL, N'YATE', N'  ', NULL, NULL, 100, 1, CAST(N'2022-04-17T17:21:41.303' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9914', N'Bantam Spectra', N'New York City', N'NY', N'USA', N'CI5668', NULL, N'A Game of Thrones', N'Epic Fantasy                            ', 70.0000, 1000000.0000, 40, 1000000, N'A Game of Thrones is the first novel in A Song of Ice and Fire, a series of fantasy novels by the American author George R. R. Martin. It was first published on August 1, 1996. The novel won the 1997 Locus Award and was nominated for both the 1997 Nebula Award and the 1997 World Fantasy Award. The novella Blood of the Dragon, comprising the Daenerys Targaryen chapters from the novel, won the 1997 Hugo Award for Best Novella. In January 2011, the novel became a New York Times Bestseller and reached No. 1 on the list in July 2011.', CAST(N'1996-08-01T00:00:00.000' AS DateTime), N'585-43-6756', N'Martin', N'George Raymond Richa', N'999 000-0000', N'5496 Village Pl.', N'New Jersey', N'NJ', N'99534', 1, 100, 1, CAST(N'2022-04-17T18:29:49.517' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9914', N'Bantam Spectra', N'New York City', N'NY', N'USA', N'OX4936', N'CI5668', N'A Clash of Kings', N'Epic Fantasy                            ', 70.0000, 1000000.0000, 40, 1000000, N'A Clash of Kings is the second novel in A Song of Ice and Fire, an epic fantasy series by American author George R. R. Martin expected to consist of seven volumes. It was first published on November 16, 1998 in the United Kingdom; the first United States edition followed on February 2, 1999. Like its predecessor, A Game of Thrones, it won the Locus Award (in 1999) for Best Novel and was nominated for the Nebula Award (also in 1999) for best novel. In May 2005, Meisha Merlin released a limited edition of the novel, fully illustrated by John Howe.', CAST(N'1998-11-16T00:00:00.000' AS DateTime), N'585-43-6756', N'Martin', N'George Raymond Richa', N'999 000-0000', NULL, N'New Jersey', N'NJ', NULL, NULL, 100, 1, CAST(N'2022-04-17T18:34:23.980' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9914', N'Bantam Spectra', N'New York City', N'NY', N'USA', N'DU8845', N'OX4936', N'A Storm of Swords', N'Epic Fantasy                            ', 70.0000, 1000000.0000, 40, 1000000, N'A Storm of Swords is the third of seven planned novels in A Song of Ice and Fire, a fantasy series by American author George R. R. Martin. It was first published on August 8, 2000, in the United Kingdom, with a United States edition following in November 2000. Its publication was preceded by a novella called Path of the Dragon, which collects some of the Daenerys Targaryen chapters from the novel into a single book.', CAST(N'2000-08-08T00:00:00.000' AS DateTime), N'585-43-6756', N'Martin', N'George Raymond Richa', N'999 000-0000', NULL, N'New Jersey', N'NJ', NULL, NULL, 100, 1, CAST(N'2022-04-17T18:35:30.763' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9914', N'Bantam Spectra', N'New York City', N'NY', N'USA', N'SU4434', N'DU8845', N'A Feast for Crows', N'Epic Fantasy                            ', 70.0000, 1000000.0000, 40, 1000000, N'A Feast for Crows is the fourth of seven planned novels in the epic fantasy series A Song of Ice and Fire by American author George R. R. Martin. The novel was first published on October 17, 2005, in the United Kingdom, with a United States edition following on November 8, 2005.', CAST(N'2005-08-01T00:00:00.000' AS DateTime), N'585-43-6756', N'Martin', N'George Raymond Richa', N'999 000-0000', NULL, N'New Jersey', N'NJ', NULL, NULL, 100, 1, CAST(N'2022-04-17T18:36:25.470' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9914', N'Bantam Spectra', N'New York City', N'NY', N'USA', N'MW2447', N'SU4434', N'A Dance with Dragons', N'Epic Fantasy                            ', 70.0000, 1000000.0000, 40, 1000000, N'A Dance with Dragons is the fifth novel of seven planned in the epic fantasy series A Song of Ice and Fire by American author George R. R. Martin. In some areas, the paperback edition was published in two parts, titled Dreams and Dust and After the Feast. It was the only novel in the series to be published during the eight-season run of the HBO adaptation of the series, Game of Thrones, and runs to 1,040 pages with a word count of almost 415,000.', CAST(N'2011-07-12T00:00:00.000' AS DateTime), N'585-43-6756', N'Martin', N'George Raymond Richa', N'999 000-0000', NULL, N'New Jersey', N'NJ', NULL, NULL, 100, 1, CAST(N'2022-04-17T18:37:44.370' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9914', N'Bantam Spectra', N'New York City', N'NY', N'USA', N'TC2266', N'MW2447', N'The Winds of Winter', N'Epic Fantasy                            ', 70.0000, 1000000.0000, 40, 1000000, N'The Winds of Winter is the planned sixth novel in the epic fantasy series A Song of Ice and Fire by American writer George R. R. Martin. Martin believes the last two volumes of the series will total over 3,000 manuscript pages. Martin has refrained from making hard estimates for the final release date of the novel.', CAST(N'2023-01-01T00:00:00.000' AS DateTime), N'585-43-6756', N'Martin', N'George Raymond Richa', N'999 000-0000', NULL, N'New Jersey', N'NJ', NULL, NULL, 100, 1, CAST(N'2022-04-17T18:39:01.020' AS DateTime), N'sa')
INSERT [Audit].[Book] ([pub_id], [pub_name], [pub_city], [pub_state], [pub_country], [random_title_id], [prequel_id], [book_title], [book_type], [book_price], [book_advance], [book_royalty], [book_ytd_sales], [book_notes], [book_pubdate], [random_au_id], [au_lname], [au_fname], [au_phone], [au_address], [au_city], [au_state], [au_zip], [au_contract], [royalty_per], [au_ord], [created_date], [created_by]) VALUES (N'9914', N'Bantam Spectra', N'New York City', N'NY', N'USA', N'SA4547', N'TC2266', N'A Dream of Spring', N'Epic Fantasy                            ', 70.0000, 1000000.0000, 40, 1000000, N'A Dream of Spring is the planned title of the seventh volume of George R. R. Martin''s A Song of Ice and Fire series. The book is to follow The Winds of Winter and is intended to be the final volume of the series.', CAST(N'2024-01-01T00:00:00.000' AS DateTime), N'585-43-6756', N'Martin', N'George Raymond Richa', N'999 000-0000', NULL, N'New Jersey', N'NJ', NULL, NULL, 100, 1, CAST(N'2022-04-17T18:40:22.920' AS DateTime), N'sa')
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
INSERT [dbo].[discounts] ([discounttype], [stor_id], [lowqty], [highqty], [discount]) VALUES (N'Initial Customer', NULL, NULL, NULL, CAST(10.50 AS Decimal(4, 2)))
INSERT [dbo].[discounts] ([discounttype], [stor_id], [lowqty], [highqty], [discount]) VALUES (N'Volume Discount', NULL, 100, 1000, CAST(6.70 AS Decimal(4, 2)))
INSERT [dbo].[discounts] ([discounttype], [stor_id], [lowqty], [highqty], [discount]) VALUES (N'Customer Discount', N'8042', NULL, NULL, CAST(5.00 AS Decimal(4, 2)))
GO
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'PMA42628M', N'Paolo', N'M', N'Accorti', 13, 35, N'0877', CAST(N'1992-08-27T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'PSA89086M', N'Pedro', N'S', N'Afonso', 14, 89, N'1389', CAST(N'1990-12-24T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'VPA30890F', N'Victoria', N'P', N'Ashworth', 6, 140, N'0877', CAST(N'1990-09-13T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'H-B39728F', N'Helen', N' ', N'Bennett', 12, 35, N'0877', CAST(N'1989-09-21T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'L-B31947F', N'Lesley', N' ', N'Brown', 7, 120, N'0877', CAST(N'1991-02-13T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'A-C71970F', N'Aria', N' ', N'Cruz', 10, 87, N'1389', CAST(N'1991-10-26T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'ARD36773F', N'Anabela', N'R', N'Domingues', 8, 100, N'0877', CAST(N'1993-01-27T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'PHF38899M', N'Peter', N'H', N'Franken', 10, 75, N'0877', CAST(N'1992-05-17T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'PXH22250M', N'Paul', N'X', N'Henriot', 5, 159, N'0877', CAST(N'1993-08-19T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'PDI47470M', N'Palle', N'D', N'Ibsen', 7, 195, N'0736', CAST(N'1993-05-09T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'KFJ64308F', N'Karin', N'F', N'Josephs', 14, 100, N'0736', CAST(N'1992-10-17T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'MGK44605M', N'Matti', N'G', N'Karttunen', 6, 220, N'0736', CAST(N'1994-05-01T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'M-L67958F', N'Maria', N' ', N'Larsson', 7, 135, N'1389', CAST(N'1992-03-27T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'Y-L77953M', N'Yoshi', N' ', N'Latimer', 12, 32, N'1389', CAST(N'1989-06-11T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'LAL21447M', N'Laurence', N'A', N'Lebihan', 5, 175, N'0736', CAST(N'1990-06-03T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'ENL44273F', N'Elizabeth', N'N', N'Lincoln', 14, 35, N'0877', CAST(N'1990-07-24T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'R-M53550M', N'Roland', N' ', N'Mendel', 11, 150, N'0736', CAST(N'1991-09-05T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'RBM23061F', N'Rita', N'B', N'Muller', 5, 198, N'1622', CAST(N'1993-10-09T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'TPO55093M', N'Timothy', N'P', N'O''Rourke', 13, 100, N'0736', CAST(N'1988-06-19T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'SKO22412M', N'Sven', N'K', N'Ottlieb', 5, 150, N'1389', CAST(N'1991-04-05T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'MAP77183M', N'Miguel', N'A', N'Paolino', 11, 112, N'1389', CAST(N'1992-12-07T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'PSP68661F', N'Paula', N'S', N'Parente', 8, 125, N'1389', CAST(N'1994-01-19T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'MJP25939M', N'Maria', N'J', N'Pontes', 5, 246, N'1756', CAST(N'1989-03-01T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'M-R38834F', N'Martine', N' ', N'Rance', 9, 75, N'0877', CAST(N'1992-02-05T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'OMA72793F', N'John', N'R', N'Richardson', 9, 170, N'9910', CAST(N'2009-02-26T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'DWR65030M', N'Diego', N'W', N'Roel', 6, 192, N'1389', CAST(N'1991-12-16T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'MMS49649F', N'Mary', N'M', N'Saveley', 8, 175, N'0736', CAST(N'1993-06-29T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'CGS88322F', N'Carine', N'G', N'Schmitt', 13, 64, N'1389', CAST(N'1992-07-07T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'MAS70474F', N'Margaret', N'A', N'Smith', 9, 78, N'1389', CAST(N'1988-09-29T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'HAS54740M', N'Howard', N'A', N'Snyder', 12, 100, N'0736', CAST(N'1988-11-19T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'MFS52347M', N'Martin', N'F', N'Sommer', 10, 165, N'0736', CAST(N'1990-04-13T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'GHT50241M', N'Gary', N'H', N'Thomas', 9, 170, N'0736', CAST(N'1988-08-09T00:00:00.000' AS DateTime))
INSERT [dbo].[employee] ([emp_id], [fname], [minit], [lname], [job_id], [job_lvl], [pub_id], [hire_date]) VALUES (N'DBT39435M', N'Daniel', N'B', N'Tonini', 11, 75, N'0877', CAST(N'1990-01-01T00:00:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[jobs] ON 

INSERT [dbo].[jobs] ([job_id], [job_desc], [min_lvl], [max_lvl]) VALUES (1, N'New Hire - Job not specified', 10, 10)
INSERT [dbo].[jobs] ([job_id], [job_desc], [min_lvl], [max_lvl]) VALUES (2, N'Chief Executive Officer', 200, 250)
INSERT [dbo].[jobs] ([job_id], [job_desc], [min_lvl], [max_lvl]) VALUES (3, N'Business Operations Manager', 175, 225)
INSERT [dbo].[jobs] ([job_id], [job_desc], [min_lvl], [max_lvl]) VALUES (4, N'Chief Financial Officier', 175, 250)
INSERT [dbo].[jobs] ([job_id], [job_desc], [min_lvl], [max_lvl]) VALUES (5, N'Publisher', 150, 250)
INSERT [dbo].[jobs] ([job_id], [job_desc], [min_lvl], [max_lvl]) VALUES (6, N'Managing Editor', 140, 225)
INSERT [dbo].[jobs] ([job_id], [job_desc], [min_lvl], [max_lvl]) VALUES (7, N'Marketing Manager', 120, 200)
INSERT [dbo].[jobs] ([job_id], [job_desc], [min_lvl], [max_lvl]) VALUES (8, N'Public Relations Manager', 100, 175)
INSERT [dbo].[jobs] ([job_id], [job_desc], [min_lvl], [max_lvl]) VALUES (9, N'Acquisitions Manager', 75, 175)
INSERT [dbo].[jobs] ([job_id], [job_desc], [min_lvl], [max_lvl]) VALUES (10, N'Productions Manager', 75, 165)
INSERT [dbo].[jobs] ([job_id], [job_desc], [min_lvl], [max_lvl]) VALUES (11, N'Operations Manager', 75, 150)
INSERT [dbo].[jobs] ([job_id], [job_desc], [min_lvl], [max_lvl]) VALUES (12, N'Editor', 25, 100)
INSERT [dbo].[jobs] ([job_id], [job_desc], [min_lvl], [max_lvl]) VALUES (13, N'Sales Representative', 25, 100)
INSERT [dbo].[jobs] ([job_id], [job_desc], [min_lvl], [max_lvl]) VALUES (14, N'Designer', 25, 100)
SET IDENTITY_INSERT [dbo].[jobs] OFF
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
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU1032', 0, 5000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU1032', 5001, 50000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PC1035', 0, 2000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PC1035', 2001, 3000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PC1035', 3001, 4000, 14)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PC1035', 4001, 10000, 16)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PC1035', 10001, 50000, 18)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU2075', 0, 1000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU2075', 1001, 3000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU2075', 3001, 5000, 14)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU2075', 5001, 7000, 16)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU2075', 7001, 10000, 18)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU2075', 10001, 12000, 20)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU2075', 12001, 14000, 22)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU2075', 14001, 50000, 24)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS2091', 0, 1000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS2091', 1001, 5000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS2091', 5001, 10000, 14)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS2091', 10001, 50000, 16)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS2106', 0, 2000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS2106', 2001, 5000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS2106', 5001, 10000, 14)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS2106', 10001, 50000, 16)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'MC3021', 0, 1000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'MC3021', 1001, 2000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'MC3021', 2001, 4000, 14)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'MC3021', 4001, 6000, 16)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'MC3021', 6001, 8000, 18)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'MC3021', 8001, 10000, 20)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'MC3021', 10001, 12000, 22)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'MC3021', 12001, 50000, 24)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC3218', 0, 2000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC3218', 2001, 4000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC3218', 4001, 6000, 14)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC3218', 6001, 8000, 16)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC3218', 8001, 10000, 18)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC3218', 10001, 12000, 20)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC3218', 12001, 14000, 22)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC3218', 14001, 50000, 24)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PC8888', 0, 5000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PC8888', 5001, 10000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PC8888', 10001, 15000, 14)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PC8888', 15001, 50000, 16)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS7777', 0, 5000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS7777', 5001, 50000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS3333', 0, 5000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS3333', 5001, 10000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS3333', 10001, 15000, 14)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS3333', 15001, 50000, 16)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU1111', 0, 4000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU1111', 4001, 8000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU1111', 8001, 10000, 14)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU1111', 12001, 16000, 16)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU1111', 16001, 20000, 18)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU1111', 20001, 24000, 20)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU1111', 24001, 28000, 22)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU1111', 28001, 50000, 24)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'MC2222', 0, 2000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'MC2222', 2001, 4000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'MC2222', 4001, 8000, 14)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'MC2222', 8001, 12000, 16)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'MC2222', 12001, 20000, 18)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'MC2222', 20001, 50000, 20)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC7777', 0, 5000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC7777', 5001, 15000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC7777', 15001, 50000, 14)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC4203', 0, 2000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC4203', 2001, 8000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC4203', 8001, 16000, 14)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC4203', 16001, 24000, 16)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC4203', 24001, 32000, 18)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC4203', 32001, 40000, 20)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'TC4203', 40001, 50000, 22)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU7832', 0, 5000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU7832', 5001, 10000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU7832', 10001, 15000, 14)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU7832', 15001, 20000, 16)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU7832', 20001, 25000, 18)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU7832', 25001, 30000, 20)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU7832', 30001, 35000, 22)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'BU7832', 35001, 50000, 24)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS1372', 0, 10000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS1372', 10001, 20000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS1372', 20001, 30000, 14)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS1372', 30001, 40000, 16)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'PS1372', 40001, 50000, 18)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'EX5727', 0, 5000, 10)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'EX5727', 5000, 20000, 12)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'EX5727', 20000, 50000, 14)
INSERT [dbo].[roysched] ([title_id], [lorange], [hirange], [royalty]) VALUES (N'EX5727', 50000, 100000, 16)
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
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'BL4371', N'Modern Computer Algebra', N'Computer Science                        ', N'9912', 100.0000, 50000.0000, 10, 10000, N'Computer algebra systems are now ubiquitous in all areas of science and engineering. This highly successful textbook, widely regarded as the bible of computer algebra, gives a thorough introduction to the algorithmic basis of the mathematical engine in computer algebra systems.', CAST(N'2013-01-01T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'BR5671', N'Why Nations Fail', N'Comparative Politics, Economics         ', N'9911', 70.0000, 100000.0000, 30, 500000, N'Why Nations Fail: The Origins of Power, Prosperity, and Poverty, first published in 2012, is a book by economists Daron Acemoglu and James Robinson. It summarizes and popularizes previous research by the authors and many other scientists. Building on the new institutional economics, Robinson and Acemoglu see in political and economic institutions — a set of rules and enforcement mechanisms that exist in society — the main reason for differences in the economic and social development of different states, considering, that other factors (geography, climate, genetics, culture, religion, elite ignorance) are secondary.', CAST(N'2012-03-20T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'BT6646', N'Harry Potter and the Chamber of Secrets', N'Fantasy                                 ', N'9913', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Chamber of Secrets is a fantasy novel written by British author J. K. Rowling and the second novel in the Harry Potter series. The plot follows Harry''s second year at Hogwarts School of Witchcraft and Wizardry, during which a series of messages on the walls of the school''s corridors warn that the "Chamber of Secrets" has been opened and that the "heir of Slytherin" would kill all pupils who do not come from all-magical families.', CAST(N'1998-07-02T00:00:00.000' AS DateTime), N'VC5136')
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'BU1032', N'The Busy Executive''s Database Guide', N'business                                ', N'1389', 19.9900, 5000.0000, 10, 4095, N'An overview of available database systems with emphasis on common business applications. Illustrated.', CAST(N'1991-06-12T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'BU1111', N'Cooking with Computers: Surreptitious Balance Sheets', N'business                                ', N'1389', 11.9500, 5000.0000, 10, 3876, N'Helpful hints on how to use your electronic resources to the best advantage.', CAST(N'1991-06-09T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'BU2075', N'You Can Combat Computer Stress!', N'business                                ', N'0736', 2.9900, 10125.0000, 24, 18722, N'The latest medical and psychological techniques for living with the electronic office. Easy-to-understand explanations.', CAST(N'1991-06-30T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'BU7832', N'Straight Talk About Computers', N'business                                ', N'1389', 19.9900, 5000.0000, 10, 4095, N'Annotated analysis of what computers can do for you: a no-hype guide for the critical user.', CAST(N'1991-06-22T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'CI5668', N'A Game of Thrones', N'Epic Fantasy                            ', N'9914', 70.0000, 1000000.0000, 40, 1000000, N'A Game of Thrones is the first novel in A Song of Ice and Fire, a series of fantasy novels by the American author George R. R. Martin. It was first published on August 1, 1996. The novel won the 1997 Locus Award and was nominated for both the 1997 Nebula Award and the 1997 World Fantasy Award. The novella Blood of the Dragon, comprising the Daenerys Targaryen chapters from the novel, won the 1997 Hugo Award for Best Novella. In January 2011, the novel became a New York Times Bestseller and reached No. 1 on the list in July 2011.', CAST(N'1996-08-01T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'DU8845', N'A Storm of Swords', N'Epic Fantasy                            ', N'9914', 70.0000, 1000000.0000, 40, 1000000, N'A Storm of Swords is the third of seven planned novels in A Song of Ice and Fire, a fantasy series by American author George R. R. Martin. It was first published on August 8, 2000, in the United Kingdom, with a United States edition following in November 2000. Its publication was preceded by a novella called Path of the Dragon, which collects some of the Daenerys Targaryen chapters from the novel into a single book.', CAST(N'2000-08-08T00:00:00.000' AS DateTime), N'OX4936')
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'EX5727', N'The Fellowship of the Ring', N'High Fantasy                            ', N'9910', 40.0000, 20000.0000, 5000000, 150000000, N'The Lord of the Rings is an epic high-fantasy novel by English author and scholar J. R. R. Tolkien. Set in Middle-earth, intended to be Earth at some distant time in the past, the story began as a sequel to Tolkiens 1937 childrens book The Hobbit, but eventually developed into a much larger work. Written in stages between 1937 and 1949, The Lord of the Rings is one of the best-selling books ever written, with over 150 million copies sold.', CAST(N'1954-08-29T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'FK3916', N'Economic Origins of Dictatorship and Democracy', N'Economics, Macroeconomics               ', N'9912', 30.0000, 50000.0000, 15, 500000, N'Book develops a framework for analyzing the creation and consolidation of democracy. Different social groups prefer different political institutions because of the way they allocate political power and resources. Thus democracy is preferred by the majority of citizens, but opposed by elites. Dictatorship nevertheless is not stable when citizens can threaten social disorder and revolution.', CAST(N'2012-09-01T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'GE1743', N'The Hobbit', N'Fantasy                                 ', N'9910', 60.0000, 50000.0000, 15, 50000000, N'The Hobbit, or There and Back Again is a childrens fantasy novel by English author J. R. R. Tolkien. It was published in 1937 to wide critical acclaim, being nominated for the Carnegie Medal and awarded a prize from the New York Herald Tribune for best juvenile fiction. The book remains popular and is recognized as a classic in childrens literature.', CAST(N'1937-09-21T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'GU4539', N'Harry Potter and the Deathly Hallows', N'Fantasy                                 ', N'9913', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Deathly Hallows is a fantasy novel written by British author J. K. Rowling and the seventh and final novel of the main Harry Potter series. It was released on 14 July 2007 in the United Kingdom by Bloomsbury Publishing, in the United States by Scholastic, and in Canada by Raincoast Books. The novel chronicles the events directly following Harry Potter and the Half-Blood Prince (2005) and the final confrontation between the wizards Harry Potter and Lord Voldemort.', CAST(N'2007-07-14T00:00:00.000' AS DateTime), N'LS2238')
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'LS2238', N'Harry Potter and the Half-Blood Prince', N'Fantasy                                 ', N'9913', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Half-Blood Prince is a fantasy novel written by British author J.K. Rowling and the sixth and penultimate novel in the Harry Potter series. Set during Harry Potter''s sixth year at Hogwarts, the novel explores the past of the boy wizard''s nemesis, Lord Voldemort, and Harry''s preparations for the final battle against Voldemort alongside his headmaster and mentor Albus Dumbledore.', CAST(N'2005-07-16T00:00:00.000' AS DateTime), N'QD5712')
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'MC2222', N'Silicon Valley Gastronomic Treats', N'mod_cook                                ', N'0877', 19.9900, 0.0000, 12, 2032, N'Favorite recipes for quick, easy, and elegant meals.', CAST(N'1991-06-09T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'MC3021', N'The Gourmet Microwave', N'mod_cook                                ', N'0877', 2.9900, 15000.0000, 24, 22246, N'Traditional French gourmet recipes adapted for modern microwave cooking.', CAST(N'1991-06-18T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'MW2447', N'A Dance with Dragons', N'Epic Fantasy                            ', N'9914', 70.0000, 1000000.0000, 40, 1000000, N'A Dance with Dragons is the fifth novel of seven planned in the epic fantasy series A Song of Ice and Fire by American author George R. R. Martin. In some areas, the paperback edition was published in two parts, titled Dreams and Dust and After the Feast. It was the only novel in the series to be published during the eight-season run of the HBO adaptation of the series, Game of Thrones, and runs to 1,040 pages with a word count of almost 415,000.', CAST(N'2011-07-12T00:00:00.000' AS DateTime), N'SU4434')
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'OX4936', N'A Clash of Kings', N'Epic Fantasy                            ', N'9914', 70.0000, 1000000.0000, 40, 1000000, N'A Clash of Kings is the second novel in A Song of Ice and Fire, an epic fantasy series by American author George R. R. Martin expected to consist of seven volumes. It was first published on November 16, 1998 in the United Kingdom; the first United States edition followed on February 2, 1999. Like its predecessor, A Game of Thrones, it won the Locus Award (in 1999) for Best Novel and was nominated for the Nebula Award (also in 1999) for best novel. In May 2005, Meisha Merlin released a limited edition of the novel, fully illustrated by John Howe.', CAST(N'1998-11-16T00:00:00.000' AS DateTime), N'CI5668')
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'PC1035', N'But Is It User Friendly?', N'popular_comp                            ', N'1389', 22.9500, 7000.0000, 16, 8780, N'A survey of software for the naive user, focusing on the ''friendliness'' of each.', CAST(N'1991-06-30T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'PC8888', N'Secrets of Silicon Valley', N'popular_comp                            ', N'1389', 20.0000, 8000.0000, 10, 4095, N'Muckraking reporting on the world''s largest computer hardware and software manufacturers.', CAST(N'1994-06-12T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'PC9999', N'Net Etiquette', N'popular_comp                            ', N'1389', NULL, NULL, NULL, NULL, N'A must-read for computer conferencing.', CAST(N'2022-04-10T23:30:33.463' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'PS1372', N'Computer Phobic AND Non-Phobic Individuals: Behavior Variations', N'psychology                              ', N'0877', 21.5900, 7000.0000, 10, 375, N'A must for the specialist, this book examines the difference between those who hate and fear computers and those who don''t.', CAST(N'1991-10-21T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'PS2091', N'Is Anger the Enemy?', N'psychology                              ', N'0736', 10.9500, 2275.0000, 12, 2045, N'Carefully researched study of the effects of strong emotions on the body. Metabolic charts included.', CAST(N'1991-06-15T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'PS2106', N'Life Without Fear', N'psychology                              ', N'0736', 7.0000, 6000.0000, 10, 111, N'New exercise, meditation, and nutritional techniques that can reduce the shock of daily interactions. Popular audience. Sample menus included, exercise video available separately.', CAST(N'1991-10-05T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'PS3333', N'Prolonged Data Deprivation: Four Case Studies', N'psychology                              ', N'0736', 19.9900, 2000.0000, 10, 4072, N'What happens when the data runs dry?  Searching evaluations of information-shortage effects.', CAST(N'1991-06-12T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'PS7777', N'Emotional Security: A New Algorithm', N'psychology                              ', N'0736', 7.9900, 4000.0000, 10, 3336, N'Protecting yourself and your loved ones from undue emotional stress in the modern world. Use of computer and nutritional aids emphasized.', CAST(N'1991-06-12T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'QD5712', N'Harry Potter and the Order of the Phoenix', N'Fantasy                                 ', N'9913', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Order of the Phoenix is a fantasy novel written by British author J. K. Rowling and the fifth novel in the Harry Potter series. It follows Harry Potter''s struggles through his fifth year at Hogwarts School of Witchcraft and Wizardry, including the surreptitious return of the antagonist Lord Voldemort, O.W.L. exams, and an obstructive Ministry of Magic.', CAST(N'2003-06-27T00:00:00.000' AS DateTime), N'TL7666')
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'SA4547', N'A Dream of Spring', N'Epic Fantasy                            ', N'9914', 70.0000, 1000000.0000, 40, 1000000, N'A Dream of Spring is the planned title of the seventh volume of George R. R. Martin''s A Song of Ice and Fire series. The book is to follow The Winds of Winter and is intended to be the final volume of the series.', CAST(N'2024-01-01T00:00:00.000' AS DateTime), N'TC2266')
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'SU4434', N'A Feast for Crows', N'Epic Fantasy                            ', N'9914', 70.0000, 1000000.0000, 40, 1000000, N'A Feast for Crows is the fourth of seven planned novels in the epic fantasy series A Song of Ice and Fire by American author George R. R. Martin. The novel was first published on October 17, 2005, in the United Kingdom, with a United States edition following on November 8, 2005.', CAST(N'2005-08-01T00:00:00.000' AS DateTime), N'DU8845')
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'TC2266', N'The Winds of Winter', N'Epic Fantasy                            ', N'9914', 70.0000, 1000000.0000, 40, 1000000, N'The Winds of Winter is the planned sixth novel in the epic fantasy series A Song of Ice and Fire by American writer George R. R. Martin. Martin believes the last two volumes of the series will total over 3,000 manuscript pages. Martin has refrained from making hard estimates for the final release date of the novel.', CAST(N'2023-01-01T00:00:00.000' AS DateTime), N'MW2447')
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'TC3218', N'Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean', N'trad_cook                               ', N'0877', 20.9500, 7000.0000, 10, 375, N'Profusely illustrated in color, this makes a wonderful gift book for a cuisine-oriented friend.', CAST(N'1991-10-21T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'TC4203', N'Fifty Years in Buckingham Palace Kitchens', N'trad_cook                               ', N'0877', 11.9500, 4000.0000, 14, 15096, N'More anecdotes from the Queen''s favorite cook describing life among English royalty. Recipes, techniques, tender vignettes.', CAST(N'1991-06-12T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'TC7777', N'Sushi, Anyone?', N'trad_cook                               ', N'0877', 14.9900, 8000.0000, 10, 4095, N'Detailed instructions on how to make authentic Japanese sushi in your spare time.', CAST(N'1991-06-12T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'TL7666', N'Harry Potter and the Goblet of Fire', N'Fantasy                                 ', N'9913', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Goblet of Fire is a fantasy novel written by British author J. K. Rowling and the fourth novel in the Harry Potter series. It follows Harry Potter, a wizard in his fourth year at Hogwarts School of Witchcraft and Wizardry, and the mystery surrounding the entry of Harry''s name into the Triwizard Tournament, in which he is forced to compete.', CAST(N'2000-07-08T00:00:00.000' AS DateTime), N'YE3356')
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'UU5128', N'The Silmarillion', N'Mythopoeia Fantasy                      ', N'9910', 45.0000, 2500000.0000, 40, 50000000, N'The Silmarillion is a collection of mythopoeic stories by the English writer J. R. R. Tolkien, edited and published posthumously by his son Christopher Tolkien in 1977 with assistance from the fantasy author Guy Gavriel Kay. The Silmarillion tells of Ea, a fictional universe that includes the Blessed Realm of Valinor, the once-great region of Beleriand, the sunken island of Numenor, and the continent of Middle-earth, where Tolkiens most popular works are set. After the success of The Hobbit, Tolkiens publisher Stanley Unwin requested a sequel, and Tolkien offered a draft of the stories that would later become The Silmarillion.', CAST(N'1977-09-15T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'UX2157', N'The Two Towers', N'Fantasy                                 ', N'9910', 40.0000, 200000.0000, 20, 50000000, N'The Two Towers is the second volume of J. R. R. Tolkiens high fantasy novel The Lord of the Rings. 
                                    It is preceded by The Fellowship of the Ring and followed by The Return of the King.', CAST(N'1954-11-11T00:00:00.000' AS DateTime), N'EX5727')
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'VC5136', N'Harry Potter and the Philosopher''s Stone', N'Fantasy                                 ', N'9913', 45.0000, 1000000.0000, 40, 120000000, N'Harry Potter and the Philosopher''s Stone is a fantasy novel written by British author J. K. Rowling. The first novel in the Harry Potter series and Rowling''s debut novel, it follows Harry Potter, a young wizard who discovers his magical heritage on his eleventh birthday, when he receives a letter of acceptance to Hogwarts School of Witchcraft and Wizardry.', CAST(N'1997-06-26T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'YE3356', N'Harry Potter and the Prisoner of Azkaban', N'Fantasy                                 ', N'9913', 45.0000, 1500000.0000, 40, 100000000, N'Harry Potter and the Prisoner of Azkaban is a fantasy novel written by British author J. K. Rowling and is the third in the Harry Potter series. The book follows Harry Potter, a young wizard, in his third year at Hogwarts School of Witchcraft and Wizardry. Along with friends Ronald Weasley and Hermione Granger, Harry investigates Sirius Black, an escaped prisoner from Azkaban, the wizard prison, believed to be one of Lord Voldemort''s old allies.', CAST(N'1999-07-08T00:00:00.000' AS DateTime), N'BT6646')
INSERT [dbo].[titles] ([title_id], [title], [type], [pub_id], [price], [advance], [royalty], [ytd_sales], [notes], [pubdate], [prequel_id]) VALUES (N'ZJ4675', N'The Return of the King', N'Fantasy                                 ', N'9910', 40.0000, 200000.0000, 20, 50000000, N'The Return of the King is the third and final volume of J. R. R. Tolkiens The Lord of the Rings, following The Fellowship of the Ring and The Two Towers. It was published in 1955. The story begins in the kingdom of Gondor, which is soon to be attacked by the Dark Lord Sauron.', CAST(N'1955-10-20T00:00:00.000' AS DateTime), N'UX2157')
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [aunmind]    Script Date: 4/18/2022 1:47:15 PM ******/
CREATE NONCLUSTERED INDEX [aunmind] ON [dbo].[authors]
(
	[au_lname] ASC,
	[au_fname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [PK_emp_id]    Script Date: 4/18/2022 1:47:15 PM ******/
ALTER TABLE [dbo].[employee] ADD  CONSTRAINT [PK_emp_id] PRIMARY KEY NONCLUSTERED 
(
	[emp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [titleidind]    Script Date: 4/18/2022 1:47:15 PM ******/
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[roysched]
(
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [titleidind]    Script Date: 4/18/2022 1:47:15 PM ******/
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[sales]
(
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [auidind]    Script Date: 4/18/2022 1:47:15 PM ******/
CREATE NONCLUSTERED INDEX [auidind] ON [dbo].[titleauthor]
(
	[au_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [titleidind]    Script Date: 4/18/2022 1:47:15 PM ******/
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[titleauthor]
(
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [titleind]    Script Date: 4/18/2022 1:47:15 PM ******/
CREATE NONCLUSTERED INDEX [titleind] ON [dbo].[titles]
(
	[title] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[authors] ADD  DEFAULT ('UNKNOWN') FOR [phone]
GO
ALTER TABLE [dbo].[employee] ADD  DEFAULT ((1)) FOR [job_id]
GO
ALTER TABLE [dbo].[employee] ADD  DEFAULT ((10)) FOR [job_lvl]
GO
ALTER TABLE [dbo].[employee] ADD  DEFAULT ('9952') FOR [pub_id]
GO
ALTER TABLE [dbo].[employee] ADD  DEFAULT (getdate()) FOR [hire_date]
GO
ALTER TABLE [dbo].[jobs] ADD  DEFAULT ('New Position - title not formalized yet') FOR [job_desc]
GO
ALTER TABLE [dbo].[publishers] ADD  DEFAULT ('USA') FOR [country]
GO
ALTER TABLE [dbo].[titles] ADD  DEFAULT ('UNDECIDED') FOR [type]
GO
ALTER TABLE [dbo].[titles] ADD  DEFAULT (getdate()) FOR [pubdate]
GO
ALTER TABLE [dbo].[discounts]  WITH CHECK ADD FOREIGN KEY([stor_id])
REFERENCES [dbo].[stores] ([stor_id])
GO
ALTER TABLE [dbo].[employee]  WITH CHECK ADD FOREIGN KEY([job_id])
REFERENCES [dbo].[jobs] ([job_id])
GO
ALTER TABLE [dbo].[employee]  WITH CHECK ADD FOREIGN KEY([pub_id])
REFERENCES [dbo].[publishers] ([pub_id])
GO
ALTER TABLE [dbo].[pub_info]  WITH CHECK ADD FOREIGN KEY([pub_id])
REFERENCES [dbo].[publishers] ([pub_id])
GO
ALTER TABLE [dbo].[roysched]  WITH CHECK ADD FOREIGN KEY([title_id])
REFERENCES [dbo].[titles] ([title_id])
GO
ALTER TABLE [dbo].[sales]  WITH CHECK ADD FOREIGN KEY([stor_id])
REFERENCES [dbo].[stores] ([stor_id])
GO
ALTER TABLE [dbo].[sales]  WITH CHECK ADD FOREIGN KEY([title_id])
REFERENCES [dbo].[titles] ([title_id])
GO
ALTER TABLE [dbo].[titleauthor]  WITH CHECK ADD FOREIGN KEY([au_id])
REFERENCES [dbo].[authors] ([au_id])
GO
ALTER TABLE [dbo].[titleauthor]  WITH CHECK ADD FOREIGN KEY([title_id])
REFERENCES [dbo].[titles] ([title_id])
GO
ALTER TABLE [dbo].[titles]  WITH CHECK ADD FOREIGN KEY([pub_id])
REFERENCES [dbo].[publishers] ([pub_id])
GO
ALTER TABLE [dbo].[titles]  WITH CHECK ADD FOREIGN KEY([pub_id])
REFERENCES [dbo].[publishers] ([pub_id])
GO
ALTER TABLE [dbo].[authors]  WITH CHECK ADD CHECK  (([au_id] like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[authors]  WITH CHECK ADD CHECK  (([zip] like '[0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[employee]  WITH CHECK ADD  CONSTRAINT [CK_emp_id] CHECK  (([emp_id] like '[A-Z][A-Z][A-Z][1-9][0-9][0-9][0-9][0-9][FM]' OR [emp_id] like '[A-Z]-[A-Z][1-9][0-9][0-9][0-9][0-9][FM]'))
GO
ALTER TABLE [dbo].[employee] CHECK CONSTRAINT [CK_emp_id]
GO
ALTER TABLE [dbo].[jobs]  WITH CHECK ADD CHECK  (([max_lvl]<=(250)))
GO
ALTER TABLE [dbo].[jobs]  WITH CHECK ADD CHECK  (([min_lvl]>=(10)))
GO
ALTER TABLE [dbo].[publishers]  WITH CHECK ADD CHECK  (([pub_id]='1756' OR [pub_id]='1622' OR [pub_id]='0877' OR [pub_id]='0736' OR [pub_id]='1389' OR [pub_id] like '99[0-9][0-9]'))
GO
/****** Object:  StoredProcedure [dbo].[byroyalty]    Script Date: 4/18/2022 1:47:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[byroyalty] @percentage int
AS
select au_id from titleauthor
where titleauthor.royaltyper = @percentage

GO
/****** Object:  StoredProcedure [dbo].[reptq1]    Script Date: 4/18/2022 1:47:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[reptq1] AS
select 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	avg(price) as avg_price
from titles
where price is NOT NULL
group by pub_id with rollup
order by pub_id

GO
/****** Object:  StoredProcedure [dbo].[reptq2]    Script Date: 4/18/2022 1:47:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[reptq2] AS
select 
	case when grouping(type) = 1 then 'ALL' else type end as type, 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	avg(ytd_sales) as avg_ytd_sales
from titles
where pub_id is NOT NULL
group by pub_id, type with rollup

GO
/****** Object:  StoredProcedure [dbo].[reptq3]    Script Date: 4/18/2022 1:47:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[reptq3] @lolimit money, @hilimit money,
@type char(12)
AS
select 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	case when grouping(type) = 1 then 'ALL' else type end as type, 
	count(title_id) as cnt
from titles
where price >@lolimit AND price <@hilimit AND type = @type OR type LIKE '%cook%'
group by pub_id, type with rollup

GO
/****** Object:  StoredProcedure [dbo].[USP_CreateAuthor]    Script Date: 4/18/2022 1:47:15 PM ******/
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
        DECLARE @au_id dbo.tid 
        -- Generate Random AuthorID using USP_GenerateRandomAuthorId stored procedure
        EXEC USP_GenerateRandomAuthorId @au_id OUTPUT

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
/****** Object:  StoredProcedure [dbo].[USP_CreateEmployee]    Script Date: 4/18/2022 1:47:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
    Created by Nury Amanmadov
    Date created: 11.04.2022
*/

CREATE PROCEDURE [dbo].[USP_CreateEmployee]
     @pub_id AS CHAR(4)
    ,@emp_firstname AS VARCHAR(255) = NULL
    ,@emp_minit AS VARCHAR(255) = NULL 
    ,@emp_lastname AS VARCHAR(255) = NULL
    ,@emp_job_id AS INT
    ,@emp_job_lvl AS INT = NULL
    ,@emp_hire_date AS DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY 
        BEGIN TRANSACTION
            --#region Insert into Employee Table

                --#region Create Random Id for Emp_id
                    -- Emp Id pattern: '[A-Z][A-Z][A-Z][1-9][0-9][0-9][0-9][0-9][FM]'
                    DECLARE @random_emp_id AS dbo.empid
                    DECLARE @l1 AS CHAR(1) = (SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ',(ABS(CHECKSUM(NEWID())) % 26) + 1, 1))
                    DECLARE @l2 AS CHAR(1) = (SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ',(ABS(CHECKSUM(NEWID())) % 26) + 1, 1))
                    DECLARE @l3 AS CHAR(1) = (SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ',(ABS(CHECKSUM(NEWID())) % 26) + 1, 1))
                    DECLARE @l4 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-1+1)+1)) AS CHAR)))
                    DECLARE @l5 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-0+1)+0)) AS CHAR)))
                    DECLARE @l6 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-0+1)+0)) AS CHAR)))
                    DECLARE @l7 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-0+1)+0)) AS CHAR)))
                    DECLARE @l8 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-0+1)+0)) AS CHAR)))
                    DECLARE @l9 AS CHAR(1) = (SELECT((SUBSTRING('FM',(ABS(CHECKSUM(NEWID())) % 2) + 1, 1))))
                    SET @random_emp_id = (SELECT @l1 + @l2 + @l3 + @l4 + @l5 + @l6 + @l7 + @l8 + @l9)
                    -- PRINT('EmpID with value: '+ CAST(@random_emp_id AS VARCHAR) + ' is created.')
                --#endregion

                -- Using Person table on AdventureWorks DB we can generate random names for employee
                IF (@emp_firstname IS NULL) 
                    SET @emp_firstname = (SELECT TOP 1 LEFT(p.FirstName,20) FROM AdventureWorks.Person.Person p ORDER BY NEWID())
                
                IF (@emp_minit IS NULL) 
                    SET @emp_minit = (SELECT TOP 1 LEFT(p.MiddleName,1) FROM AdventureWorks.Person.Person p WHERE p.MiddleName IS NOT NULL ORDER BY NEWID())
                
                IF (@emp_lastname IS NULL) 
                    SET @emp_lastname = (SELECT TOP 1 LEFT(p.LastName,30) FROM AdventureWorks.Person.Person p ORDER BY NEWID())
                
                -- Using jobs table we can get random job level between max_lvl and min_lvl of the generated @emp_job_id
                IF (@emp_job_lvl IS NULL)
                    SET @emp_job_lvl = (SELECT TOP 1 FLOOR(RAND() * (max_lvl - min_lvl + 1) + min_lvl) FROM [pubs].[dbo].[jobs] WHERE job_id = @emp_job_id ORDER BY NEWID())
                
                -- Using Employee table on AdventureWorks DB we can generate random hiredate for employee
                IF (@emp_hire_date IS NULL)
                    SET @emp_hire_date = (SELECT TOP 1 CAST(e.HireDate AS DATETIME) FROM AdventureWorks.HumanResources.Employee e ORDER BY NEWID())

                INSERT INTO [pubs].[dbo].[employee] 
                VALUES (
                             @random_emp_id
                            ,@emp_firstname
                            ,@emp_minit
                            ,@emp_lastname
                            ,@emp_job_id
                            ,@emp_job_lvl
                            ,@pub_id
                            ,@emp_hire_date
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



/*


EXEC USP_CreateEmployee 1756
EXEC USP_CreateEmployee 1756, 'Nury'
EXEC USP_CreateEmployee 1756, 'Nury', 'A'
EXEC USP_CreateEmployee 1756, 'Nury', 'A', 'Amanmadov'

SELECT * FROM Employee WHERE pub_id = 1756 AND emp_id <> 'MJP25939M'
DELETE FROM Employee WHERE pub_id = 1756 AND emp_id <> 'MJP25939M'


*/
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteBook]    Script Date: 4/18/2022 1:47:15 PM ******/
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
/****** Object:  StoredProcedure [dbo].[USP_GenerateRandomAuthorId]    Script Date: 4/18/2022 1:47:15 PM ******/
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
/****** Object:  StoredProcedure [dbo].[USP_GetAllAuthors]    Script Date: 4/18/2022 1:47:15 PM ******/
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
/****** Object:  StoredProcedure [dbo].[USP_GetAllBooks]    Script Date: 4/18/2022 1:47:15 PM ******/
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
/****** Object:  StoredProcedure [dbo].[USP_GetAllContinuingBooksByTitleId]    Script Date: 4/18/2022 1:47:15 PM ******/
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
            RAISERROR('Book with provided ID does not exist', 16, 1)
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
/****** Object:  StoredProcedure [dbo].[USP_GetAllEmployee]    Script Date: 4/18/2022 1:47:15 PM ******/
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
/****** Object:  StoredProcedure [dbo].[USP_GetAllPrequelBooksByTitleId]    Script Date: 4/18/2022 1:47:15 PM ******/
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
            RAISERROR('Book with provided ID does not exist', 16, 1)
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
/****** Object:  StoredProcedure [dbo].[USP_GetAllPublishers]    Script Date: 4/18/2022 1:47:15 PM ******/
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
/****** Object:  StoredProcedure [dbo].[USP_GetRandomNumber]    Script Date: 4/18/2022 1:47:15 PM ******/
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
/****** Object:  StoredProcedure [dbo].[USP_InsertBook]    Script Date: 4/18/2022 1:47:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
    Created by Nury Amanmadov
    Date created: 10.04.2022
*/

CREATE PROCEDURE [dbo].[USP_InsertBook] 

     @book_title AS VARCHAR(100)
    ,@prequel_id AS VARCHAR(6) = NULL
    ,@book_type AS CHAR(40)
    ,@book_price AS MONEY
    ,@book_advance AS MONEY
    ,@book_royalty INT
	,@book_ytd_sales INT
	,@book_notes VARCHAR(800)
	,@book_pubdate DATETIME

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
                                     @pub_id
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
                                        @pub_id
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
                                RAISERROR('Publisher with selected ID does not exist', 16, 1) 
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
                    DECLARE @t1 AS CHAR(1) = (SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ',(ABS(CHECKSUM(NEWID())) % 26) + 1, 1))
                    DECLARE @t2 AS CHAR(1) = (SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ',(ABS(CHECKSUM(NEWID())) % 26) + 1, 1))
                    DECLARE @t3 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-1+1)+1)) AS CHAR)))
                    DECLARE @t4 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-1+1)+1)) AS CHAR)))
                    DECLARE @t5 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-1+1)+1)) AS CHAR)))
                    DECLARE @t6 AS CHAR(1) = (SELECT(CAST((FLOOR(RAND()*(9-1+1)+1)) AS CHAR)))
                    DECLARE @random_title_id [dbo].[tid] = (SELECT @t1 + @t2 + @t3 + @t4 + @t5 + @t6)
                --#endregion

                INSERT INTO titles
                VALUES
                (
                     @random_title_id
                    ,@book_title
                    ,@book_type
                    ,@pub_id
                    ,@book_price
                    ,@book_advance
                    ,@book_royalty
                    ,@book_ytd_sales
                    ,@book_notes
                    ,@book_pubdate
                    ,@prequel_id
                )

            --#endregion

            --#region Insert into Authors Table

                DECLARE @au_zip CHAR(5)
                DECLARE @au_contract BIT
                DECLARE @au_address VARCHAR(40)

                IF(@author_id IS NULL)
                    BEGIN 
                        -- Generate Random AuthorID
                        DECLARE @a1 AS CHAR(3) = (SELECT(CAST((FLOOR(RAND()*(999-100+1)+100)) AS CHAR)))
                        DECLARE @a2 AS CHAR(2) = (SELECT(CAST((FLOOR(RAND()*(99-10+1)+10)) AS CHAR)))
                        DECLARE @a3 AS CHAR(4) = (SELECT(CAST((FLOOR(RAND()*(9999-1000+1)+1000)) AS CHAR)))
                        SET @author_id = (SELECT @a1 + '-' + @a2 + '-' + @a3)

                        -- Setting Random Zip in the 99xyz format
                        SET @au_zip = '99'+ (SELECT(CAST((FLOOR(RAND()*(999-100+1)+100)) AS CHAR)))
                        -- SELECT @au_zip

                        -- Setting @au_contract as random 
                        SET @au_contract = (SELECT(CAST((FLOOR(RAND()*(1-0+1)+0)) AS BIT)))
                        -- SELECT @au_contract

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
                                RAISERROR('Author with selected ID does not exist', 16, 1) 
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
                     @pub_id 
                    ,@pub_name 
                    ,@pub_city   
                    ,@pub_state  
                    ,@pub_country
                    ,@random_title_id 
                    ,@prequel_id
                    ,@book_title 
                    ,@book_type 
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


    SELECT * FROM publishers    -- 6  records
    SELECT * FROM pub_info      -- 6  records
    SELECT * FROM titles        -- 18 records
    SELECT * FROM authors       -- 24 records
    SELECT * FROM titleauthor   -- 26 records

    DELETE FROM pub_info WHERE pub_id = 9910
    DELETE FROM publishers WHERE pub_id = 991
    DELETE FROM titles WHERE pub_id = 9910


*/



GO
/****** Object:  StoredProcedure [dbo].[USP_InsertCoAuthorForTitle]    Script Date: 4/18/2022 1:47:15 PM ******/
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
    ,@au_phone CHAR(12) = '000 000-0000'
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
                    RAISERROR('Book with provided ID does not exist', 16, 1)
                END

            IF(@au_id IS NULL)
                BEGIN
                    DECLARE @au_zip CHAR(5)
                    DECLARE @au_contract BIT
                    DECLARE @au_address VARCHAR(40)
                    -- Generate Random AuthorID using USP_GenerateRandomAuthorId stored procedure
                    EXEC USP_GenerateRandomAuthorId @au_id OUTPUT

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
                            RAISERROR('Author with provided ID does not exist', 16, 1)
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
/****** Object:  Trigger [dbo].[employee_insupd]    Script Date: 4/18/2022 1:47:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[employee_insupd]
ON [dbo].[employee]
FOR insert, UPDATE
AS
--Get the range of level for this job type from the jobs table.
declare @min_lvl tinyint,
   @max_lvl tinyint,
   @emp_lvl tinyint,
   @job_id smallint
select @min_lvl = min_lvl,
   @max_lvl = max_lvl,
   @emp_lvl = i.job_lvl,
   @job_id = i.job_id
from employee e, jobs j, inserted i
where e.emp_id = i.emp_id AND i.job_id = j.job_id
IF (@job_id = 1) and (@emp_lvl <> 10)
begin
   raiserror ('Job id 1 expects the default level of 10.',16,1)
   ROLLBACK TRANSACTION
end
ELSE
IF NOT (@emp_lvl BETWEEN @min_lvl AND @max_lvl)
begin
   raiserror ('The level for job_id:%d should be between %d and %d.',
      16, 1, @job_id, @min_lvl, @max_lvl)
   ROLLBACK TRANSACTION
end

GO
ALTER TABLE [dbo].[employee] ENABLE TRIGGER [employee_insupd]
GO
USE [master]
GO
ALTER DATABASE [pubs] SET  READ_WRITE 
GO
