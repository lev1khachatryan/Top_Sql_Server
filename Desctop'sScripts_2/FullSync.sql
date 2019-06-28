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
IF OBJECT_ID('dbo.DE_AfterFullSync') IS NOT NULL
    DROP PROCEDURE dbo.DE_AfterFullSync;
GO
CREATE PROCEDURE dbo.DE_AfterFullSync
AS
    BEGIN
        DECLARE @sql AS NVARCHAR(MAX) = N'';
        SELECT  @sql += '
UPDATE ddxk
SET ' + sub.column_name + '='
                + CASE WHEN sub.column_name LIKE '%DayID'
                       THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                            + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                            + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                            + sub.date_name
                            + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                            + sub.date_name + ') AS NVARCHAR(10)) END ,
                         CASE WHEN DATEPART(wk, ' + sub.date_name
                            + ') < 10 THEN CONCAT(''0'', CAST(DATEPART(wk, '
                            + sub.date_name
                            + ') AS NVARCHAR(10))) ELSE CAST(DATEPART(wk, '
                            + sub.date_name + ') AS NVARCHAR(10)) END,
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
                       WHEN sub.column_name LIKE '%WeekID'
                       THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                            + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                            + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                            + sub.date_name
                            + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                            + sub.date_name + ') AS NVARCHAR(10)) END ,
                         CASE WHEN DATEPART(wk, ' + sub.date_name
                            + ') < 10 THEN CONCAT(''0'', CAST(DATEPART(wk, '
                            + sub.date_name
                            + ') AS NVARCHAR(10))) ELSE CAST(DATEPART(wk, '
                            + sub.date_name + ') AS NVARCHAR(10)) END
										 ) '
                       WHEN sub.column_name LIKE '%MonthID'
                       THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                            + ') AS NVARCHAR(10)),
                         CASE WHEN MONTH(' + sub.date_name
                            + ') < 10 THEN CONCAT(''0'',CAST(MONTH('
                            + sub.date_name
                            + ') AS NVARCHAR(10))) ELSE CAST(MONTH('
                            + sub.date_name + ') AS NVARCHAR(10)) END
										 ) '
                       WHEN sub.column_name LIKE '%QuarterID'
                       THEN 'CONCAT(
						 CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10)),
                         CAST(dbo.WhichQuarter(' + sub.date_name
                            + ') AS NVARCHAR(10))
										 ) '
                       WHEN sub.column_name LIKE '%YearID'
                       THEN 'CAST(YEAR(' + sub.date_name + ') AS NVARCHAR(10))
'
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
                ) AS sub;
        PRINT ( @sql );
    END;
GO

--EXEC dbo.DE_AfterFullSync;
