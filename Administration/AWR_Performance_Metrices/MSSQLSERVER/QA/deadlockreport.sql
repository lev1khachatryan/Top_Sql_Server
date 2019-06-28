USE [DBAMonitor]
GO

/****** Object:  StoredProcedure [dbo].[deadlock_report]    Script Date: 03/13/2014 16:02:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[deadlock_report]
	-- Add the parameters for the stored procedure here
    @database_name VARCHAR(50) ,
    @path NVARCHAR(50),
    @startdate DATETIME,
    @enddate datetime
AS 
    BEGIN
        SET NOCOUNT ON ;
        DECLARE @Database_id INT
        DECLARE @t VARCHAR(5)
        SET @database_id = DB_ID(@database_name)
        SELECT  CAST(@database_id AS VARCHAR(5))
        SET @t = @Database_id

		IF EXISTS (SELECT  [AlertTime] ,
                        [DeadlockGraph]
                FROM    [DBAMonitor].[dbo].[DeadlockEvents]
                WHERE   CAST(deadlockgraph AS NVARCHAR(MAX)) LIKE '%currentdb='
                        + '"' + @t + '"%'
                        AND Alerttime >= ISNULL(@startdate, '01/01/2012')
                        AND Alerttime < DATEADD(dd, 1,
                                                ISNULL(@enddate, '01/01/2016')))
	BEGIN
        INSERT  INTO dlock
                SELECT  [AlertTime] ,
                        [DeadlockGraph]
                FROM    [DBAMonitor].[dbo].[DeadlockEvents]
                WHERE   CAST(deadlockgraph AS NVARCHAR(MAX)) LIKE '%currentdb='
                        + '"' + @t + '"%'
                        AND Alerttime >= ISNULL(@startdate, '01/01/2012')
                        AND Alerttime < DATEADD(dd, 1,
                                                ISNULL(@enddate, '01/01/2016'))
		
		 Declare  @getdate NVARCHAR(50)

 SET @getdate= CONVERT(CHAR(10),  GETDATE(), 120)

        DECLARE @result NVARCHAR(500)
        SET @result = 'bcp "SELECT  *  FROM [DBAMonitor].[dbo].[dlock]  " queryout "'+@path+@getdate+'_'+@database_name+'_deadlock_report.xml" -c -t, -T -S'
        PRINT @result
        EXEC xp_cmdshell @result
      TRUNCATE TABLE dlock
    END

	END 
GO


