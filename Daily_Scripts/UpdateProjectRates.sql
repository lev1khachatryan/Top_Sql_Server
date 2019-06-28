-- This comment was added fօr merge

--ALTER TABLE dbo._report
--ADD RateUSD DECIMAL(18,5)

--ALTER PROCEDURE [dbo].[DE_LoadCurrencyRates]
--@CurrencyID INT ,
--@Date DATE
--AS
--BEGIN
---- SET NOCOUNT ON added to prevent extra result sets from
---- interfering with SELECT statements.
--    SET NOCOUNT ON;
--    DECLARE @YearID INT = DATEPART(YEAR, @Date);
--    DECLARE @QuarterID INT = @YearID * 10 + DATEPART(QUARTER, @Date);
--    DECLARE @USDCurrencyID INT = 49;
--	DECLARE @MROCurrencyID INT = 52;
--	DECLARE @RateUSD DECIMAL (18 , 5);
--	SET @RateUSD = (
--    SELECT TOP 1
--            --CASE WHEN @CurrencyID = @MROCurrencyID THEN 1
--            --        ELSE Rate
--            --END AS RateMRO ,
--             CASE WHEN @CurrencyID = @MROCurrencyID
--                    THEN ( SELECT TOP 1
--                                1/Rate
--                        FROM    dbo.C_CurrencyRate
--                        WHERE   CurrencyID = @USDCurrencyID
--                        ORDER BY ABS(DATEDIFF(QUARTER,
--                                                CAST(( CAST(YearID AS NVARCHAR(50))
--                                                        + '-'
--                                                        + CAST(( QuarterID
--                                                            % 10 ) * 3 AS NVARCHAR(50))
--                                                        + '-01' ) AS DATE),
--                                                @Date))
--                        )
--                    ELSE CAST(1/Rate
--                        / ( SELECT TOP 1
--                                    CASE WHEN @CurrencyID = @MROCurrencyID THEN 1
--                                            ELSE 1/Rate
--                                    END AS RateMRO
--                            FROM      dbo.C_CurrencyRate
--                            WHERE     CurrencyID = @USDCurrencyID
--                            ORDER BY  ABS(DATEDIFF(QUARTER,
--                                                    CAST(( CAST(YearID AS NVARCHAR(50))
--                                                        + '-'
--                                                        + CAST(( QuarterID
--                                                            % 10 ) * 3 AS NVARCHAR(50))
--                                                        + '-01' ) AS DATE),
--                                                    @Date))
--                        ) AS DECIMAL(18, 4)) 
--            END  AS RateUSD 
--    FROM    dbo.C_CurrencyRate
--    WHERE   CurrencyID = @CurrencyID
--            OR @CurrencyID = @MROCurrencyID
--    ORDER BY ABS(DATEDIFF(QUARTER,
--                            CAST(( CAST(YearID AS NVARCHAR(50)) + '-'
--                                    + CAST(( QuarterID % 10 ) * 3 AS NVARCHAR(50))
--                                    + '-01' ) AS DATE), @Date))
--									)
--	RETURN @RateUSD;
--END;


--DECLARE @ProjectCode AS NVARCHAR(50)
--DECLARE @MyDate      AS DATETIME
--DECLARE @RateUSD     AS DECIMAL(18 , 5)
--DECLARE db_cursor CURSOR FOR
--SELECT Projet , [Date Estime]
--FROM dbo._report
--OPEN db_cursor
--FETCH NEXT FROM db_cursor 
--INTO @ProjectCode , @MyDate

--WHILE @@FETCH_STATUS = 0
--BEGIN

--	EXEC @RateUSD = dbo.DE_LoadCurrencyRates  @CurrencyID = 52 ,@Date = @MyDate
--	UPDATE dbo._report
--	SET RateUSD = @RateUSD
--	WHERE projet = @ProjectCode
--	FETCH NEXT FROM db_cursor 
--	INTO @ProjectCode , @MyDate

--END

--CLOSE db_cursor
--DEALLOCATE db_cursor


UPDATE DE_Project
SET DE_Project.EstimatedAmountCurrencyID = 52,
	DE_Project.EstimatedAmountRateMRO = 1,
	DE_Project.EstimatedAmount_MRO = Report.[Montant estimé (MRO)],
	DE_Project.EstimatedAmountRateUSD = Report.RateUSD,
	DE_Project.EstimatedAmountDate = Report.[Date Estime]
FROM dbo.DE_Project AS DE_Project
INNER JOIN dbo._report AS Report
ON Report.projet = DE_Project.ProjectCode

UPDATE dbo.DE_Project
SET EstimatedAmount_USD = (EstimatedAmountRateMRO * EstimatedAmount_MRO/EstimatedAmountRateUSD)
GO

SELECT *
FROM dbo._report
