IF COL_LENGTH('Users', 'RegistrationYear') IS NULL
BEGIN
	ALTER TABLE Users
	ADD RegistrationYear INT,
		RegistrationMonth INT
END
GO
UPDATE Users
SET RegistrationYear = YEAR(RegisterDate),
	RegistrationMonth = MONTH(RegisterDate)
GO
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_Users_RegistrationYearMonth' AND object_id = OBJECT_ID('Users'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_Users_RegistrationYearMonth
			ON Users (RegistrationYear, RegistrationMonth)
		include(RegisterDate, Id)
    END
go

IF OBJECT_ID('DSRetentionAndroid') IS NOT NULL
BEGIN
	DROP TABLE DSRetentionAndroid
END
GO
CREATE TABLE [dbo].[DSRetentionAndroid](
	[RegistrationYear] [nvarchar](20) NULL,
	[RegistrationMonth] [nvarchar](10) NULL,
	[CohortMonth] [int] NULL,
	[CountOfUsers] [int] NULL,
	[NumberOfRegisteredUsers] [decimal](10, 2) NULL
)
IF OBJECT_ID('DSRetentionIOS') IS NOT NULL
BEGIN
	DROP TABLE DSRetentionIOS
END
GO
CREATE TABLE [dbo].[DSRetentionIOS](
	[RegistrationYear] [nvarchar](20) NULL,
	[RegistrationMonth] [nvarchar](10) NULL,
	[CohortMonth] [int] NULL,
	[CountOfUsers] [int] NULL,
	[NumberOfRegisteredUsers] [decimal](10, 2) NULL
)
GO
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 1, 77792, CAST(243562.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 2, 56597, CAST(243562.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 3, 43892, CAST(243562.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 4, 38573, CAST(243562.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 5, 32334, CAST(243562.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 6, 30022, CAST(243562.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 7, 27103, CAST(243562.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 8, 25746, CAST(243562.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 9, 23083, CAST(243562.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 10, 21601, CAST(243562.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 11, 19421, CAST(243562.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 12, 19643, CAST(243562.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 1, 58646, CAST(175363.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 2, 41767, CAST(175363.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 3, 34911, CAST(175363.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 4, 27616, CAST(175363.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 5, 25532, CAST(175363.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 6, 22735, CAST(175363.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 7, 22063, CAST(175363.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 8, 19512, CAST(175363.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 9, 17984, CAST(175363.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 10, 15894, CAST(175363.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 11, 16036, CAST(175363.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 12, 15819, CAST(175363.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 1, 58033, CAST(182151.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 2, 43860, CAST(182151.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 3, 33030, CAST(182151.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 4, 28976, CAST(182151.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 5, 25348, CAST(182151.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 6, 24061, CAST(182151.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 7, 21590, CAST(182151.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 8, 19963, CAST(182151.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 9, 16954, CAST(182151.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 10, 16687, CAST(182151.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 11, 16385, CAST(182151.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 12, 13360, CAST(182151.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 1, 61400, CAST(197484.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 2, 41403, CAST(197484.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 3, 34776, CAST(197484.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 4, 28825, CAST(197484.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 5, 26546, CAST(197484.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 6, 23355, CAST(197484.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 7, 21452, CAST(197484.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 8, 18236, CAST(197484.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 9, 17441, CAST(197484.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 10, 16833, CAST(197484.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 11, 13326, CAST(197484.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 1, 56039, CAST(195457.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 2, 42071, CAST(195457.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 3, 33320, CAST(195457.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 4, 29178, CAST(195457.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 5, 25025, CAST(195457.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 6, 22326, CAST(195457.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 7, 19090, CAST(195457.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 8, 18081, CAST(195457.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 9, 17167, CAST(195457.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 10, 13229, CAST(195457.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 1, 52573, CAST(171007.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 2, 37542, CAST(171007.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 3, 31135, CAST(171007.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 4, 25363, CAST(171007.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 5, 22254, CAST(171007.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 6, 18979, CAST(171007.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 7, 17928, CAST(171007.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 8, 16648, CAST(171007.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 9, 12360, CAST(171007.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 1, 58564, CAST(182173.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 2, 42999, CAST(182173.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 3, 33046, CAST(182173.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 4, 28276, CAST(182173.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 5, 23444, CAST(182173.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 6, 22167, CAST(182173.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 7, 20343, CAST(182173.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 8, 14308, CAST(182173.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'8', 1, 63118, CAST(193953.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'8', 2, 44056, CAST(193953.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'8', 3, 35144, CAST(193953.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'8', 4, 28085, CAST(193953.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'8', 5, 26166, CAST(193953.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'8', 6, 23836, CAST(193953.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'8', 7, 16204, CAST(193953.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'9', 1, 67016, CAST(220197.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'9', 2, 48500, CAST(220197.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'9', 3, 36652, CAST(220197.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'9', 4, 32408, CAST(220197.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'9', 5, 29780, CAST(220197.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'9', 6, 19833, CAST(220197.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'10', 1, 62335, CAST(204836.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'10', 2, 42227, CAST(204836.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'10', 3, 35351, CAST(204836.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'10', 4, 31266, CAST(204836.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'10', 5, 20625, CAST(204836.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'11', 1, 47829, CAST(160803.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'11', 2, 36063, CAST(160803.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'11', 3, 30354, CAST(160803.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'11', 4, 18632, CAST(160803.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'12', 1, 52158, CAST(173933.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'12', 2, 38906, CAST(173933.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'12', 3, 23229, CAST(173933.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2019', N'1', 1, 60632, CAST(194011.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2019', N'1', 2, 30941, CAST(194011.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionAndroid] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2019', N'2', 1, 41496, CAST(175541.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 1, 23546, CAST(68860.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 2, 17883, CAST(68860.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 3, 13951, CAST(68860.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 4, 12182, CAST(68860.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 5, 10670, CAST(68860.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 6, 9267, CAST(68860.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 7, 8103, CAST(68860.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 8, 8599, CAST(68860.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 9, 7819, CAST(68860.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 10, 7230, CAST(68860.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 11, 6664, CAST(68860.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'1', 12, 6565, CAST(68860.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 1, 18928, CAST(50398.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 2, 13718, CAST(50398.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 3, 11360, CAST(50398.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 4, 9487, CAST(50398.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 5, 8069, CAST(50398.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 6, 7017, CAST(50398.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 7, 7483, CAST(50398.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 8, 6802, CAST(50398.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 9, 6096, CAST(50398.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 10, 5474, CAST(50398.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 11, 5423, CAST(50398.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'2', 12, 5334, CAST(50398.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 1, 19426, CAST(53772.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 2, 14629, CAST(53772.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 3, 11637, CAST(53772.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 4, 9762, CAST(53772.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 5, 8174, CAST(53772.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 6, 8489, CAST(53772.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 7, 7805, CAST(53772.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 8, 6971, CAST(53772.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 9, 6092, CAST(53772.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 10, 5989, CAST(53772.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 11, 5845, CAST(53772.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'3', 12, 4588, CAST(53772.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 1, 17602, CAST(47262.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 2, 12564, CAST(47262.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 3, 9939, CAST(47262.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 4, 7857, CAST(47262.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 5, 8177, CAST(47262.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 6, 7324, CAST(47262.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 7, 6457, CAST(47262.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 8, 5727, CAST(47262.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 9, 5583, CAST(47262.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 10, 5327, CAST(47262.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'4', 11, 4095, CAST(47262.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 1, 16699, CAST(48188.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 2, 12110, CAST(48188.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 3, 9148, CAST(48188.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 4, 9205, CAST(48188.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 5, 7974, CAST(48188.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 6, 7024, CAST(48188.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 7, 6170, CAST(48188.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 8, 5931, CAST(48188.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 9, 5578, CAST(48188.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'5', 10, 4247, CAST(48188.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 1, 16450, CAST(49913.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 2, 11310, CAST(49913.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 3, 10541, CAST(49913.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 4, 8724, CAST(49913.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 5, 7660, CAST(49913.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 6, 6627, CAST(49913.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 7, 6274, CAST(49913.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 8, 5913, CAST(49913.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'6', 9, 4442, CAST(49913.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 1, 15278, CAST(47678.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 2, 12680, CAST(47678.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 3, 9949, CAST(47678.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 4, 8303, CAST(47678.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 5, 7168, CAST(47678.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 6, 6864, CAST(47678.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 7, 6256, CAST(47678.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'7', 8, 4349, CAST(47678.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'8', 1, 17991, CAST(51924.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'8', 2, 13158, CAST(51924.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'8', 3, 10509, CAST(51924.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'8', 4, 8614, CAST(51924.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'8', 5, 7917, CAST(51924.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'8', 6, 7221, CAST(51924.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'8', 7, 5058, CAST(51924.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'9', 1, 21292, CAST(57764.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'9', 2, 15283, CAST(57764.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'9', 3, 11793, CAST(57764.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'9', 4, 10671, CAST(57764.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'9', 5, 9714, CAST(57764.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'9', 6, 6418, CAST(57764.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'10', 1, 21730, CAST(61268.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'10', 2, 15170, CAST(61268.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'10', 3, 12727, CAST(61268.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'10', 4, 11217, CAST(61268.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'10', 5, 7370, CAST(61268.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'11', 1, 17231, CAST(52717.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'11', 2, 13165, CAST(52717.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'11', 3, 10898, CAST(52717.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'11', 4, 6665, CAST(52717.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'12', 1, 16696, CAST(52305.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'12', 2, 12162, CAST(52305.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2018', N'12', 3, 7427, CAST(52305.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2019', N'1', 1, 17109, CAST(51827.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2019', N'1', 2, 8629, CAST(51827.00 AS Decimal(10, 2)))
INSERT [dbo].[DSRetentionIOS] ([RegistrationYear], [RegistrationMonth], [CohortMonth], [CountOfUsers], [NumberOfRegisteredUsers]) VALUES (N'2019', N'2', 1, 11927, CAST(49167.00 AS Decimal(10, 2)))
GO


--------------------
--------------------
--    ANDROID     --
--------------------
--------------------
DECLARE @CORRENTYEAR AS INT = YEAR(GETDATE())
DECLARE @CURRENTMONTH AS INT = MONTH(GETDATE())
DECLARE @DIFFERENCE AS INT = @CURRENTMONTH +11

DECLARE @MONTH AS INT = @CURRENTMONTH - 1
DECLARE @DATE AS INT = 360

WHILE @MONTH <= 12
BEGIN
	insert into DSRetentionAndroid (RegistrationYear, RegistrationMonth,CohortMonth , CountOfUsers)
	SELECT U.RegistrationYear ,
			U.RegistrationMonth , 
				@DIFFERENCE - @MONTH as CohortMonth , 
				count(Distinct U.ID) as CountOfUsers
	FROM Users as U
	join DeviceClients as DC on U.Id = DC.UserID
	where ClientId = 1114 and
	U.RegistrationYear = 2018 and
	U.RegistrationMonth = @MONTH and exists
	(
	select 1
	from UserCheckins as UC
	where UC.UserId = U.Id and
	DATEDIFF(DAY,U.RegisterDate, UC.Date ) between @date and @date + 30
	)
	group by U.RegistrationYear, U.RegistrationMonth

	SET @DATE = @DATE - 30
	SET @MONTH = @MONTH + 1
END

WHILE @MONTH < @DIFFERENCE
BEGIN
	insert into DSRetentionAndroid (RegistrationYear, RegistrationMonth,CohortMonth , CountOfUsers)
	SELECT U.RegistrationYear ,
			U.RegistrationMonth , 
				@DIFFERENCE - @MONTH as CohortMonth , 
				count(Distinct U.ID) as CountOfUsers
	FROM Users as U
	join DeviceClients as DC on U.Id = DC.UserID
	where ClientId = 1114 and
	U.RegistrationYear = 2019 and
	U.RegistrationMonth = @MONTH - 12 and exists
	(
	select 1
	from UserCheckins as UC
	where UC.UserId = U.Id and
	DATEDIFF(DAY,U.RegisterDate, UC.Date ) between @date and @date + 30
	)
	group by U.RegistrationYear, U.RegistrationMonth

	SET @DATE = @DATE - 30
	SET @MONTH = @MONTH + 1
END
GO
UPDATE Retent
SET NumberOfRegisteredUsers = AllUsers.NumberOfUsers
from DSRetentionAndroid as Retent
join(
SELECT U.RegistrationYear, U.RegistrationMonth, COUNT(DISTINCT U.Id) AS NumberOfUsers
FROM Users as U
join DeviceClients as DC on U.Id = DC.UserID
where ClientId = 1114 and
	U.RegistrationYear >= 2018
group by U.RegistrationYear, U.RegistrationMonth
) as AllUsers on Retent.RegistrationYear = AllUsers.RegistrationYear and Retent.RegistrationMonth = AllUsers.RegistrationMonth
GO
----------------
----------------
--    IOS     --
----------------
----------------
DECLARE @CORRENTYEAR AS INT = YEAR(GETDATE())
DECLARE @CURRENTMONTH AS INT = MONTH(GETDATE())
DECLARE @DIFFERENCE AS INT = @CURRENTMONTH +11

DECLARE @MONTH AS INT = @CURRENTMONTH - 1
DECLARE @DATE AS INT = 360

WHILE @MONTH <= 12
BEGIN
	insert into DSRetentionIOS (RegistrationYear, RegistrationMonth,CohortMonth , CountOfUsers)
	SELECT U.RegistrationYear ,
			U.RegistrationMonth , 
				@DIFFERENCE - @MONTH as CohortMonth , 
				count(Distinct U.ID) as CountOfUsers
	FROM Users as U
	join DeviceClients as DC on U.Id = DC.UserID
	where ClientId = 1122 and
	U.RegistrationYear = 2018 and
	U.RegistrationMonth = @MONTH and exists
	(
	select 1
	from UserCheckins as UC
	where UC.UserId = U.Id and
	DATEDIFF(DAY,U.RegisterDate, UC.Date ) between @date and @date + 30
	)
	group by U.RegistrationYear, U.RegistrationMonth

	SET @DATE = @DATE - 30
	SET @MONTH = @MONTH + 1
END

WHILE @MONTH < @DIFFERENCE
BEGIN
	insert into DSRetentionIOS (RegistrationYear, RegistrationMonth,CohortMonth , CountOfUsers)
	SELECT U.RegistrationYear ,
			U.RegistrationMonth , 
				@DIFFERENCE - @MONTH as CohortMonth , 
				count(Distinct U.ID) as CountOfUsers
	FROM Users as U
	join DeviceClients as DC on U.Id = DC.UserID
	where ClientId = 1122 and
	U.RegistrationYear = 2019 and
	U.RegistrationMonth = @MONTH - 12 and exists
	(
	select 1
	from UserCheckins as UC
	where UC.UserId = U.Id and
	DATEDIFF(DAY,U.RegisterDate, UC.Date ) between @date and @date + 30
	)
	group by U.RegistrationYear, U.RegistrationMonth

	SET @DATE = @DATE - 30
	SET @MONTH = @MONTH + 1
END
GO
UPDATE Retent
SET NumberOfRegisteredUsers = AllUsers.NumberOfUsers
from DSRetentionIOS as Retent
join(
SELECT U.RegistrationYear, U.RegistrationMonth, COUNT(DISTINCT U.Id) AS NumberOfUsers
FROM Users as U
join DeviceClients as DC on U.Id = DC.UserID
where ClientId = 1122 and
	U.RegistrationYear >= 2018
group by U.RegistrationYear, U.RegistrationMonth
) as AllUsers on Retent.RegistrationYear = AllUsers.RegistrationYear and Retent.RegistrationMonth = AllUsers.RegistrationMonth
GO
