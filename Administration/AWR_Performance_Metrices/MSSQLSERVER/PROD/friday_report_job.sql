DECLARE @enddate_enter datetime;
SET @enddate_enter = GETDATE()

DECLARE @startdate_enter datetime;
SET @startdate_enter = DATEADD(d, -7, GETDATE())


DECLARE @cur_db VARCHAR(50);
DECLARE db_cursor CURSOR FOR 
SELECT  name FROM  MASTER.dbo.sysdatabases 
WHERE name not IN ('master', 'model', 'tempdb', 'msdb', 'resource', 'DBAMonitor' )
OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @cur_db

WHILE @@FETCH_STATUS = 0  

BEGIN  


USE [DBAMonitor];

DECLARE	@return_value1 int

EXEC	@return_value1 = [dbo].[topqueryreport]
		@database_name = @cur_db ,
		@path = N'c:\DBAMonitor\',
		@totalnumber = 10,
		@startdate = @startdate_enter,
		@enddate = @enddate_enter

SELECT	'Return Value1' = @return_value1;

DECLARE	@return_value2 int

EXEC	@return_value2 = [dbo].[deadlock_report]
		@database_name = @cur_db,
		@path = N'c:\DBAMonitor\',
		@startdate = @startdate_enter,
		@enddate = @enddate_enter

SELECT	'Return Value2' = @return_value2;


DECLARE	@return_value3 int

EXEC	@return_value3 = [dbo].[lock_report]
		@database_name = @cur_db,
		@path = N'c:\DBAMonitor\',
		@startdate = @startdate_enter,
		@enddate = @enddate_enter

SELECT	'Return Value3' = @return_value3;



EXEC	         [dbo].[topspreport]
		@database_name = @cur_db ,
		@path = N'c:\DBAMonitor\',
		@totalnumber = 10,
		@startdate = @startdate_enter,
		@enddate = @enddate_enter



       FETCH NEXT FROM db_cursor INTO @cur_db 
END  

CLOSE db_cursor  
DEALLOCATE db_cursor 




