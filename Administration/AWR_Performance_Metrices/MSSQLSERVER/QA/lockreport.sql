USE [DBAMonitor]
GO

/****** Object:  StoredProcedure [dbo].[lock_report]    Script Date: 03/13/2014 16:03:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[lock_report] 
	-- Add the parameters for the stored procedure here
	@database_name varchar(150),
	@path NVARCHAR(50),
	@startdate datetime,
	@enddate datetime
AS
BEGIN
	
	DECLARE @result NVARCHAR(200)
	declare @Database_id int
    declare @t varchar(5)
    set @database_id=db_id(@database_name)
    select cast(@database_id as varchar(5))
	set @t=@Database_id;
	CREATE TABLE #Temp
    (
      ALO DATETIME ,
      blocked_process XML ,
      blocking_process XML
    ) 

If exists(    SELECT  MIN(alerttime) ,
                CAST(blocked_process AS XML) ,
                CAST(blocking_process AS XML)
        FROM    ( SELECT    [AlertTime] ,
                            CAST([BlockedReport].query('/TextData/blocked-process-report/blocked-process/process/inputbuf') AS NVARCHAR(MAX)) AS blocked_process ,
                            CAST([BlockedReport].query('/TextData/blocked-process-report/blocking-process/process/inputbuf') AS NVARCHAR(MAX)) AS blocking_process
                  FROM      [DBAMonitor].[dbo].[BlockedEvents]
                  WHERE     CAST(BlockedReport.query('/TextData/blocked-process-report/blocking-process/process') AS NVARCHAR(MAX)) LIKE '%currentdb='+'"'+@t+'"%' 
                            AND Alerttime >= ISNULL(@startdate, '01/01/2012')
                            AND Alerttime < DATEADD(dd, 1,
                                                    ISNULL(@enddate, '01/01/2016'))
                ) a
        GROUP BY blocked_process ,
                blocking_process)
				
			
				Begin

INSERT  INTO #Temp




        SELECT  MIN(alerttime) ,
                CAST(blocked_process AS XML) ,
                CAST(blocking_process AS XML)
        FROM    ( SELECT    [AlertTime] ,
                            CAST([BlockedReport].query('/TextData/blocked-process-report/blocked-process/process/inputbuf') AS NVARCHAR(MAX)) AS blocked_process ,
                            CAST([BlockedReport].query('/TextData/blocked-process-report/blocking-process/process/inputbuf') AS NVARCHAR(MAX)) AS blocking_process
                  FROM      [DBAMonitor].[dbo].[BlockedEvents]
                  WHERE     CAST(BlockedReport.query('/TextData/blocked-process-report/blocking-process/process') AS NVARCHAR(MAX)) LIKE '%currentdb='+'"'+@t+'"%' 
                            AND Alerttime >= ISNULL(@startdate, '01/01/2012')
                            AND Alerttime < DATEADD(dd, 1,
                                                    ISNULL(@enddate, '01/01/2016'))
                ) a
        GROUP BY blocked_process ,
                blocking_process
	 
	 
 

DECLARE @xml NVARCHAR(MAX) 
DECLARE @body NVARCHAR(MAX)

SET @xml = CAST(( SELECT    [ALO] AS 'td' ,
                            '' ,
                            [blocked_process] AS 'td' ,
                            '' ,
                            [blocking_process] AS 'td'
                  FROM      #Temp
                FOR
                  XML PATH('tr') ,
                      ELEMENTS
                ) AS NVARCHAR(MAX)) 


SET @body = '<html><body><H3>Blocked process report</H3> 
<table border = 1> 
<tr> 
<th> Alertime </th> <th> blocked_process </th> <th> blocking_process </th></tr>'    


SET @body = @body + @xml + '</table></body></html>'

SELECT  @body   

 Declare  @getdate NVARCHAR(50)

 SET @getdate= CONVERT(CHAR(10),  GETDATE(), 120)



INSERT  INTO [DBAMonitor].[dbo].[html]
        SELECT  @body

SELECT  @result = 'bcp " select body FROM [DBAMonitor].[dbo].[html] " queryout "'+@path+@getdate+'_'+@database_name+'_lock_report.html" -c -t, -T -S'
        + @@servername ;

EXEC master..xp_cmdshell @result ; 

DROP TABLE #Temp
TRUNCATE TABLE html
end 

END


GO


