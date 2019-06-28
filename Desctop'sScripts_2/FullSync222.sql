IF OBJECT_ID('dbo.WhichQuarter') IS NOT NULL
    DROP FUNCTION dbo.WhichQuarter;
GO
CREATE FUNCTION dbo.WhichQuarter ( @input DATETIME )
RETURNS INT
AS
    BEGIN
        DECLARE @Quarter INT = 0;
        DECLARE @Month INT = MONTH(@input);
        SET @Quarter = CASE WHEN @Month BETWEEN 1 AND 3 THEN 1
                            WHEN @Month BETWEEN 4 AND 6 THEN 2
                            WHEN @Month BETWEEN 7 AND 9 THEN 3
                            WHEN @Month BETWEEN 10 AND 12 THEN 4
                       END;
        RETURN @Quarter;
    END;
GO
IF OBJECT_ID('dbo.WhichWeek') IS NOT NULL
    DROP FUNCTION dbo.WhichWeek;
GO
CREATE FUNCTION dbo.WhichWeek ( @input DATETIME )
RETURNS INT
AS
    BEGIN
        DECLARE @Week INT = 0;
        SET @Week = CASE WHEN DATEPART(wk, @input) < 10 THEN CONCAT('0', CAST(DATEPART(wk, @input) AS NVARCHAR(10))) ELSE CAST(DATEPART(wk, @input) AS NVARCHAR(10)) END
        RETURN @Week;
    END;
GO
IF OBJECT_ID('dbo.WhichDay') IS NOT NULL
    DROP FUNCTION dbo.WhichDay;
GO
CREATE FUNCTION dbo.WhichDay ( @input DATETIME )
RETURNS INT
AS
    BEGIN
        DECLARE @Day INT = 0;
		DECLARE @i AS INT = CAST(( DATEDIFF(DAY,
                                         STR(YEAR(@input), 4) + '0101',
                                         @input) + 1 ) AS INT)
        SET @Day = CASE WHEN @i < 10 THEN CONCAT('00',CAST(@i AS NVARCHAR(10)))
							WHEN @i > 10 AND 
							@i < 100 THEN CONCAT('0',CAST(@i AS NVARCHAR(10))) END
        RETURN @Day;
    END;
GO
IF OBJECT_ID('dbo.WhichMonth') IS NOT NULL
    DROP FUNCTION dbo.WhichMonth;
GO
CREATE FUNCTION dbo.WhichMonth ( @input DATETIME )
RETURNS INT
AS
    BEGIN
        DECLARE @Month INT = CASE WHEN MONTH(@input) < 10 THEN CONCAT('0',CAST(MONTH(@input) AS NVARCHAR(10))) ELSE CAST(MONTH(@input) AS NVARCHAR(10)) END;
        RETURN @Month;
    END;
GO
IF OBJECT_ID('dbo.IndexOfNthComma') IS NOT NULL
    DROP FUNCTION dbo.IndexOfNthComma;
GO
CREATE FUNCTION dbo.IndexOfNthComma
    (
      @InputString NVARCHAR(MAX) ,
      @NthComma INT
    )
RETURNS INT
AS
    BEGIN
        DECLARE @result AS INT = 0;
        DECLARE @i AS INT = 1;

        IF @NthComma < 1
            OR ( ( LEN(@InputString) - LEN(REPLACE(@InputString, ',', '')) ) < @NthComma )
            BEGIN
                SET @result = -1;
            END;
        ELSE
            BEGIN
                IF @NthComma = 1
                    BEGIN
                        SET @result = CHARINDEX(',', @InputString);
                    END;
                ELSE
                    BEGIN
                        WHILE 1 = 1
                            BEGIN
                                SET @result += CHARINDEX(',', @InputString);
                                SET @InputString = SUBSTRING(@InputString,
                                                             CHARINDEX(',',
                                                              @InputString)
                                                             + 1,
                                                             ( LEN(@InputString)
                                                              - CHARINDEX(',',
                                                              @InputString) ));
                                SET @i = @i + 1;
                                IF @i = @NthComma
                                    BEGIN
                                        SET @result += CHARINDEX(',',
                                                              @InputString);
                                        BREAK;
                                    END;
                            END;
                    END;
            END;
                
        RETURN @result;
    END;
GO
IF OBJECT_ID('dbo.CountOfComma') IS NOT NULL
    DROP FUNCTION dbo.CountOfComma;
GO
CREATE FUNCTION dbo.CountOfComma
    (
      @inputString NVARCHAR(MAX)
    )
RETURNS INT
AS
    BEGIN
        DECLARE @result AS INT;
        SET @result = ( LEN(@inputString) - LEN(REPLACE(@inputString, ',', '')) );
        RETURN @result;
    END;
GO
IF OBJECT_ID('dbo.DE_AfterFullSync') IS NOT NULL
    DROP PROCEDURE dbo.DE_AfterFullSync;
GO
CREATE PROCEDURE dbo.DE_AfterFullSync
AS
    BEGIN
        DECLARE @sql AS NVARCHAR(MAX) = N'';
        SELECT  @sql += '
UPDATE ddxk
SET '
                + ISNULL(CASE WHEN dbo.IndexOfNthComma(sub.column_name, 1) < 0
                              THEN sub.column_name
                         END, '')
                + CASE WHEN dbo.IndexOfNthComma(sub.column_name, 1) < 0
                       THEN +'='
                            + CASE WHEN sub.column_name LIKE '%DayID'
                                   THEN 'CONCAT(YEAR(' + sub.date_name + '),
                         dbo.WhichQuarter(' + sub.date_name+ '),
						 dbo.WhichMonth(' + sub.date_name+ '),
						 dbo.WhichWeek(' + sub.date_name+ '),
						 dbo.WhichDay(' + sub.date_name+ '))'
                                   WHEN sub.column_name LIKE '%WeekID'
                                   THEN 'CONCAT(YEAR(' + sub.date_name + '),
						dbo.WhichQuarter(' + sub.date_name+ ') ,
                         dbo.WhichMonth(' + sub.date_name+ '),
						 dbo.WhichWeek(' + sub.date_name+ '))'
                                   WHEN sub.column_name LIKE '%MonthID'
                                   THEN 'CONCAT(YEAR(' + sub.date_name + '),
						dbo.WhichQuarter(' + sub.date_name+ ') ,
                         dbo.WhichMonth(' + sub.date_name+ '))'
                                   WHEN sub.column_name LIKE '%QuarterID'
                                   THEN 'CONCAT(YEAR(' + sub.date_name + '),
                         dbo.WhichQuarter(' + sub.date_name+ '))'
                                   WHEN sub.column_name LIKE '%YearID'
                                   THEN 'YEAR(' + sub.date_name + ')'
                              END
                       ELSE +''
                  END + '
'
                + ISNULL(CASE WHEN dbo.IndexOfNthComma(sub.column_name, 1) > 0
                              THEN SUBSTRING(sub.column_name, 0,
                                             dbo.IndexOfNthComma(sub.column_name,
                                                              1))
                         END, '')
                + CASE WHEN dbo.IndexOfNthComma(sub.column_name, 1) > 0
                       THEN +'='
                            + CASE WHEN SUBSTRING(sub.column_name, 0,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              1)) LIKE '%DayID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END ,
                         CASE WHEN DATEPART(wk, ' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'', CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END,
                         CASE WHEN CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS INT) < 10 THEN CONCAT(''00'',CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS NVARCHAR(10)))
							WHEN CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS INT) > 10 AND 
							CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS INT) < 100 THEN CONCAT(''0'',CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS NVARCHAR(10))) END
										 )'
                                   WHEN SUBSTRING(sub.column_name, 0,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              1)) LIKE '%WeekID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END ,
                         CASE WHEN DATEPART(wk, ' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'', CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END
										 ) '
                                   WHEN SUBSTRING(sub.column_name, 0,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              1)) LIKE '%MonthID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END
										 ) '
                                   WHEN SUBSTRING(sub.column_name, 0,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              1)) LIKE '%QuarterID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10))
										 ) '
                                   WHEN SUBSTRING(sub.column_name, 0,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              1)) LIKE '%YearID'
                                   THEN 'CAST(YEAR(' + sub.date_name
                                        + ') AS NVARCHAR(10))
'
                              END
                       ELSE +''
                  END
                + CASE WHEN dbo.IndexOfNthComma(sub.column_name, 2) > 0
                       THEN +','
                       ELSE +''
                  END + '
'
                + ISNULL(CASE WHEN dbo.IndexOfNthComma(sub.column_name, 2) > 0
                              THEN SUBSTRING(sub.column_name,
                                             dbo.IndexOfNthComma(sub.column_name,
                                                              1) + 1,
                                             dbo.IndexOfNthComma(sub.column_name,
                                                              2)
                                             - dbo.IndexOfNthComma(sub.column_name,
                                                              1) - 1)
                         END, '')
                + CASE WHEN dbo.IndexOfNthComma(sub.column_name, 2) > 0
                       THEN +'='
                            + CASE WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              1) + 1,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              2)
                                                  - dbo.IndexOfNthComma(sub.column_name,
                                                              1) - 1) LIKE '%DayID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END ,
                         CASE WHEN DATEPART(wk, ' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'', CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END,
                         CASE WHEN CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS INT) < 10 THEN CONCAT(''00'',CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS NVARCHAR(10)))
							WHEN CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS INT) > 10 AND 
							CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS INT) < 100 THEN CONCAT(''0'',CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS NVARCHAR(10))) END
										 )'
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              1) + 1,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              2)
                                                  - dbo.IndexOfNthComma(sub.column_name,
                                                              1) - 1) LIKE '%WeekID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END ,
                         CASE WHEN DATEPART(wk, ' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'', CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END
										 ) '
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              1) + 1,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              2)
                                                  - dbo.IndexOfNthComma(sub.column_name,
                                                              1) - 1) LIKE '%MonthID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END
										 ) '
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              1) + 1,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              2)
                                                  - dbo.IndexOfNthComma(sub.column_name,
                                                              1) - 1) LIKE '%QuarterID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10))
										 ) '
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              1) + 1,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              2)
                                                  - dbo.IndexOfNthComma(sub.column_name,
                                                              1) - 1) LIKE '%YearID'
                                   THEN 'CAST(YEAR(' + sub.date_name
                                        + ') AS NVARCHAR(10))
'
                              END
                       ELSE +''
                  END
                + CASE WHEN dbo.IndexOfNthComma(sub.column_name, 3) > 0
                       THEN +','
                       ELSE +''
                  END + '
'
                + ISNULL(CASE WHEN dbo.IndexOfNthComma(sub.column_name, 3) > 0
                              THEN SUBSTRING(sub.column_name,
                                             dbo.IndexOfNthComma(sub.column_name,
                                                              2) + 1,
                                             dbo.IndexOfNthComma(sub.column_name,
                                                              3)
                                             - dbo.IndexOfNthComma(sub.column_name,
                                                              2) - 1)
                         END, '')
                + CASE WHEN dbo.IndexOfNthComma(sub.column_name, 3) > 0
                       THEN +'='
                            + CASE WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              2) + 1,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              3)
                                                  - dbo.IndexOfNthComma(sub.column_name,
                                                              2) - 1) LIKE '%DayID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END ,
                         CASE WHEN DATEPART(wk, ' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'', CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END,
                         CASE WHEN CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS INT) < 10 THEN CONCAT(''00'',CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS NVARCHAR(10)))
							WHEN CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS INT) > 10 AND 
							CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS INT) < 100 THEN CONCAT(''0'',CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS NVARCHAR(10))) END
										 )'
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              2) + 1,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              3)
                                                  - dbo.IndexOfNthComma(sub.column_name,
                                                              2) - 1) LIKE '%WeekID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END ,
                         CASE WHEN DATEPART(wk, ' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'', CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END
										 ) '
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              2) + 1,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              3)
                                                  - dbo.IndexOfNthComma(sub.column_name,
                                                              2) - 1) LIKE '%MonthID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END
										 ) '
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              2) + 1,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              3)
                                                  - dbo.IndexOfNthComma(sub.column_name,
                                                              2) - 1) LIKE '%QuarterID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10))
										 ) '
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              2) + 1,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              3)
                                                  - dbo.IndexOfNthComma(sub.column_name,
                                                              2) - 1) LIKE '%YearID'
                                   THEN 'CAST(YEAR(' + sub.date_name
                                        + ') AS NVARCHAR(10))
'
                              END
                       ELSE +''
                  END
                + CASE WHEN dbo.IndexOfNthComma(sub.column_name, 4) > 0
                       THEN +','
                       ELSE +''
                  END + '
'
                + ISNULL(CASE WHEN dbo.IndexOfNthComma(sub.column_name, 4) > 0
                              THEN SUBSTRING(sub.column_name,
                                             dbo.IndexOfNthComma(sub.column_name,
                                                              3) + 1,
                                             dbo.IndexOfNthComma(sub.column_name,
                                                              4)
                                             - dbo.IndexOfNthComma(sub.column_name,
                                                              3) - 1)
                         END, '')
                + CASE WHEN dbo.IndexOfNthComma(sub.column_name, 4) > 0
                       THEN +'='
                            + CASE WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              3) + 1,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              4)
                                                  - dbo.IndexOfNthComma(sub.column_name,
                                                              3) - 1) LIKE '%DayID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END ,
                         CASE WHEN DATEPART(wk, ' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'', CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END,
                         CASE WHEN CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS INT) < 10 THEN CONCAT(''00'',CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS NVARCHAR(10)))
							WHEN CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS INT) > 10 AND 
							CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS INT) < 100 THEN CONCAT(''0'',CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS NVARCHAR(10))) END
										 )'
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              3) + 1,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              4)
                                                  - dbo.IndexOfNthComma(sub.column_name,
                                                              3) - 1) LIKE '%WeekID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END ,
                         CASE WHEN DATEPART(wk, ' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'', CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END
										 ) '
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              3) + 1,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              4)
                                                  - dbo.IndexOfNthComma(sub.column_name,
                                                              3) - 1) LIKE '%MonthID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END
										 ) '
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              3) + 1,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              4)
                                                  - dbo.IndexOfNthComma(sub.column_name,
                                                              3) - 1) LIKE '%QuarterID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10))
										 ) '
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              3) + 1,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              4)
                                                  - dbo.IndexOfNthComma(sub.column_name,
                                                              3) - 1) LIKE '%YearID'
                                   THEN 'CAST(YEAR(' + sub.date_name
                                        + ') AS NVARCHAR(10))
'
                              END
                       ELSE +''
                  END
                + CASE WHEN dbo.IndexOfNthComma(sub.column_name, 5) < 0
                            AND dbo.CountOfComma(sub.column_name) > 0
                       THEN +','
                       ELSE +''
                  END + '
'
                + ISNULL(CASE WHEN dbo.IndexOfNthComma(sub.column_name, 5) < 0
                                   AND dbo.CountOfComma(sub.column_name) > 0
                              THEN SUBSTRING(sub.column_name,
                                             dbo.IndexOfNthComma(sub.column_name,
                                                              4) + 1,
                                             LEN(sub.column_name))
                         END, '')
                + CASE WHEN dbo.IndexOfNthComma(sub.column_name, 5) < 0
                            AND dbo.CountOfComma(sub.column_name) > 0
                       THEN +'='
                            + CASE WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              4) + 1,
                                                  LEN(sub.column_name)) LIKE '%DayID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END ,
                         CASE WHEN DATEPART(wk, ' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'', CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END,
                         CASE WHEN CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS INT) < 10 THEN CONCAT(''00'',CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS NVARCHAR(10)))
							WHEN CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS INT) > 10 AND 
							CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS INT) < 100 THEN CONCAT(''0'',CAST(( DATEDIFF(DAY,
                                         STR(YEAR(' + sub.date_name
                                        + '), 4) + ''0101'',
                                         ' + sub.date_name
                                        + ') + 1 ) AS NVARCHAR(10))) END
										 )'
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              4) + 1,
                                                  LEN(sub.column_name)) LIKE '%WeekID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END ,
                         CASE WHEN DATEPART(wk, ' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'', CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(DATEPART(wk, '
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END
										 ) '
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              4) + 1,
                                                  LEN(sub.column_name)) LIKE '%MonthID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                                        + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                                        + sub.date_name
                                        + ') AS NVARCHAR(10)) END
										 ) '
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              4) + 1,
                                                  LEN(sub.column_name)) LIKE '%QuarterID'
                                   THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                                        + ') AS NVARCHAR(10))
										 ) '
                                   WHEN SUBSTRING(sub.column_name,
                                                  dbo.IndexOfNthComma(sub.column_name,
                                                              4) + 1,
                                                  LEN(sub.column_name)) LIKE '%YearID'
                                   THEN 'CAST(YEAR(' + sub.date_name
                                        + ') AS NVARCHAR(10))
'
                              END
                       ELSE +''
                  END + '
FROM dbo.' + sub.table_name + ' AS ddxk
WHERE ' + sub.date_name + ' IS NOT NULL
'
        FROM    ( SELECT    CASE WHEN c.name LIKE '%DayID'
                                 THEN REPLACE(c.name, 'DayID', '')
                                 WHEN c.name LIKE '%WeekID'
                                 THEN REPLACE(c.name, 'WeekID', '')
                                 WHEN c.name LIKE '%MonthID'
                                 THEN REPLACE(c.name, 'MonthID', '')
                                 WHEN c.name LIKE '%QuarterID'
                                 THEN REPLACE(c.name, 'QuarterID', '')
                                 WHEN c.name LIKE '%YearID'
                                 THEN REPLACE(c.name, 'YearID', '')
                            END AS date_name ,
                            t.name AS table_name ,
                            dbo.Concat(DISTINCT c.name, ',') AS column_name
                  FROM      sys.tables AS t
                            INNER JOIN sys.columns c ON t.object_id = c.object_id
                  WHERE     ( c.name LIKE '%YearID'
                              OR c.name LIKE '%QuarterID'
                              OR c.name LIKE '%MonthID'
                              OR c.name LIKE '%WeekID'
                              OR c.name LIKE '%DayID'
                            )
                            AND t.name NOT LIKE 'C!_%' ESCAPE '!'
							--AND C.name <> 'YearID'
                            AND t.name <> 'RCSCaseAddressYear'
                  GROUP BY  t.name ,
                            CASE WHEN c.name LIKE '%DayID'
                                 THEN REPLACE(c.name, 'DayID', '')
                                 WHEN c.name LIKE '%WeekID'
                                 THEN REPLACE(c.name, 'WeekID', '')
                                 WHEN c.name LIKE '%MonthID'
                                 THEN REPLACE(c.name, 'MonthID', '')
                                 WHEN c.name LIKE '%QuarterID'
                                 THEN REPLACE(c.name, 'QuarterID', '')
                                 WHEN c.name LIKE '%YearID'
                                 THEN REPLACE(c.name, 'YearID', '')
                            END
                ) AS sub
        WHERE   sub.table_name = 'CourtCaseWFAction'
        --        AND sub.date_name = 'ActionDate';
        PRINT ( @sql );
    END;
GO

EXEC dbo.DE_AfterFullSync;
