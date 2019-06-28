-- This comment was added fօr merge
BEGIN TRAN;
BEGIN TRY

--SELECT  ProjectDisbursementProjection.*
--    FROM    dbo.ProjectDisbursementProjection
--            LEFT JOIN dbo.Agreement ON Agreement.AgreementID = ProjectDisbursementProjection.AgreementID
--    WHERE   MajorVersion IS NULL;

    DECLARE @ProjectDisbursementProjectionID AS INT ,
        @PIPYearID AS NVARCHAR(100) ,
        @FundingAmount AS DECIMAL(18, 2);
    DECLARE db_cursor CURSOR
    FOR
        SELECT  ProjectDisbursementProjection.ProjectDisbursementProjectionID ,
                ProjectDisbursementProjection.PIPYearID ,
                ProjectDisbursementProjection.FundingAmount
        FROM    dbo.ProjectDisbursementProjection
                LEFT JOIN dbo.Agreement ON Agreement.AgreementID = ProjectDisbursementProjection.AgreementID
        WHERE   MajorVersion IS NULL;
    OPEN db_cursor;   
    FETCH NEXT FROM db_cursor INTO @ProjectDisbursementProjectionID,
        @PIPYearID, @FundingAmount;

    WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE  PDP
            SET     FundingAmount_USD = ( PDP.FundingAmount
                                          * ( SELECT TOP 1
                                                        Rate
                                              FROM      dbo.C_CurrencyRate
                                              WHERE     CurrencyID = 49
                                              ORDER BY  ABS(DATEDIFF(QUARTER,
                                                              CAST(( CAST(YearID AS NVARCHAR(50))
                                                              + '-'
                                                              + CAST(( QuarterID
                                                              % 10 ) * 3 AS NVARCHAR(50))
                                                              + '-01' ) AS DATE),
                                                              @PIPYearID))
                                            ) ) ,
                    PDP.FundingAmount_MRO = PDP.FundingAmount ,
                    PDP.FundingAmountRateUSD = ( SELECT TOP 1
                                                        Rate
                                                 FROM   dbo.C_CurrencyRate
                                                 WHERE  CurrencyID = 49
                                                 ORDER BY ABS(DATEDIFF(QUARTER,
                                                              CAST(( CAST(YearID AS NVARCHAR(50))
                                                              + '-'
                                                              + CAST(( QuarterID
                                                              % 10 ) * 3 AS NVARCHAR(50))
                                                              + '-01' ) AS DATE),
                                                              @PIPYearID))
                                               ) ,
                    PDP.FundingAmountRateMRO = 1.00000 ,
                    PDP.FundingAmountDate = @PIPYearID
            FROM    dbo.ProjectDisbursementProjection AS PDP
                    LEFT JOIN dbo.Agreement AS A ON A.AgreementID = PDP.AgreementID
            WHERE   MajorVersion IS NULL
                    AND PDP.ProjectDisbursementProjectionID = @ProjectDisbursementProjectionID;

            FETCH NEXT FROM db_cursor INTO @ProjectDisbursementProjectionID,
                @PIPYearID, @FundingAmount;
        END;
    CLOSE db_cursor;   
    DEALLOCATE db_cursor;

END TRY
BEGIN CATCH
    SELECT  ERROR_MESSAGE() ,
            ERROR_NUMBER();
    ROLLBACK;
END CATCH;
GO
