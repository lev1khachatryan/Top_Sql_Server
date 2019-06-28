USE [DBAMonitor]
GO
/****** Object:  StoredProcedure [dbo].[topspreport]    Script Date: 03/13/2014 08:19:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[topspreport]
	@database_name nvarchar(150),
	@path NVARCHAR(100),
	@totalnumber int,
	@startdate datetime,
	@enddate datetime
AS
BEGIN
if(@enddate is null)
set @enddate= '01/01/2016'
	CREATE TABLE #Temp 
( 
  dbname nvarchar(150),  	
  [object_name] nvarchar(200), 
  exec_count INT,
  [avg_cpu]  decimal(18,3), 
  [avg_elapsed] decimal(18,3), 
  [avg_logical_reads]  int
   
) 
INSERT INTO #Temp 
exec('
SELECT TOP '+@totalnumber+'  MAX([DBName]) AS DBname, [OBJECT_NAME],  MAX(execution_count) AS exec_count, avg(avg_cpu) AS avg_cpu, avg(avg_elapsed) AS avg_elapsed, AVG(avg_logical_reads) AS avg_logical_reads
      
  FROM [DBAMonitor].[dbo].[SPstatistics]
  where dbname='''+@database_name+''' and last_execution_time >=  '''+@startdate+''' 
	 	  and last_execution_time <dateadd(dd,1,'''+@enddate+''')
  GROUP BY [object_name]
  ORDER BY exec_count DESC
')
 SELECT * FROM #TEMP

DECLARE @xml NVARCHAR(MAX) 
DECLARE @body NVARCHAR(MAX)

SET @xml = CAST(( SELECT [dbname] AS 'td','',[object_name] AS 'td','', 
       [exec_count] AS 'td','', avg_cpu AS 'td','', [avg_elapsed] AS 'td','', [avg_logical_reads] AS 'td'
FROM  #Temp 
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX)) 


SET @body ='<html><body><H3>TOP SP BY EXEC COUNT</H3> 
<table border = 1> 
<tr> 
<th> DBNAME </th> <th> OBJECT_NAME </th> <th> EXEC_COUNT </th><th> AVERAGE_CPU_TIME </th><th> AVERAGE_DURATION </th><th> AVERAGE_LOGICAL_READS </th></tr>'    


SET @body = @body + @xml +'</table></body></html>'

insert into html
select @body
declare @result varchar(255); 
--select @result = 'bcp " select body FROM [DBAMonitor].[dbo].[html] " queryout "C:\z.txt" -c -t, -T -S' + @@servername;

--exec master..xp_cmdshell @result; 

DROP TABLE #Temp
CREATE TABLE #Temp2 
( 
  dbname nvarchar(150),  	
  [object_name] nvarchar(200), 
  exec_count INT,
  [avg_cpu]  decimal(18,3), 
  [avg_elapsed] decimal(18,3), 
  [avg_logical_reads]  int
   
) 
INSERT INTO #Temp2 
exec('
SELECT TOP '+@totalnumber+'  MAX([DBName]) AS DBname, [OBJECT_NAME],  MAX(execution_count) AS exec_count, avg(avg_cpu) AS avg_cpu, avg(avg_elapsed) AS avg_elapsed, AVG(avg_logical_reads) AS avg_logical_reads
      
  FROM [DBAMonitor].[dbo].[SPstatistics]
  where dbname='''+@database_name+''' and last_execution_time >=  '''+@startdate+''' 
	 	  and last_execution_time <dateadd(dd,1,'''+@enddate+''')
  GROUP BY [object_name]
  ORDER BY AVG_CPU DESC
')
 SELECT * FROM #TEMP2

DECLARE @xml2 NVARCHAR(MAX) 
DECLARE @body2 NVARCHAR(MAX)

SET @xml2 = CAST(( SELECT [dbname] AS 'td','',[object_name] AS 'td','', 
       [exec_count] AS 'td','', avg_cpu AS 'td','', [avg_elapsed] AS 'td','', [avg_logical_reads] AS 'td'
FROM  #Temp2 
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX)) 


SET @body2 ='<html><body><H3>TOP SP BY CPU TIME</H3> 
<table border = 1> 
<tr> 
<th> DBNAME </th> <th> OBJECT_NAME </th> <th> EXEC_COUNT </th><th> AVERAGE_CPU_TIME </th><th> AVERAGE_DURATION </th><th> AVERAGE_LOGICAL_READS </th></tr>'    


SET @body2 = @body2 + @xml2 +'</table></body></html>'

insert into html
select @body2
 
--select @result = 'bcp " select body FROM [DBAMonitor].[dbo].[html] " queryout "C:\z.txt" -c -t, -T -S' + @@servername;

--exec master..xp_cmdshell @result; 

DROP TABLE #Temp2
CREATE TABLE #Temp3 
( 
  dbname nvarchar(150),  	
  [object_name] nvarchar(200), 
  exec_count INT,
  [avg_cpu]  decimal(18,3), 
  [avg_elapsed] decimal(18,3), 
  [avg_logical_reads]  int
   
) 
INSERT INTO #Temp3 
exec('
SELECT TOP '+@totalnumber+'  MAX([DBName]) AS DBname, [OBJECT_NAME],  MAX(execution_count) AS exec_count, avg(avg_cpu) AS avg_cpu, avg(avg_elapsed) AS avg_elapsed, AVG(avg_logical_reads) AS avg_logical_reads
      
  FROM [DBAMonitor].[dbo].[SPstatistics]
  where dbname='''+@database_name+''' and last_execution_time >=  '''+@startdate+''' 
	 	  and last_execution_time <dateadd(dd,1,'''+@enddate+''')
  GROUP BY [object_name]
  ORDER BY AVG_ELAPSED DESC
')
 SELECT * FROM #TEMP3

DECLARE @xml3 NVARCHAR(MAX) 
DECLARE @body3 NVARCHAR(MAX)

SET @xml3 = CAST(( SELECT [dbname] AS 'td','',[object_name] AS 'td','', 
       [exec_count] AS 'td','', avg_cpu AS 'td','', [avg_elapsed] AS 'td','', [avg_logical_reads] AS 'td'
FROM  #Temp3 
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX)) 


SET @body3 ='<html><body><H3>TOP SP BY AVERAGE TIME</H3> 
<table border = 1> 
<tr> 
<th> DBNAME </th> <th> OBJECT_NAME </th> <th> EXEC_COUNT </th><th> AVERAGE_CPU_TIME </th><th> AVERAGE_DURATION </th><th> AVERAGE_LOGICAL_READS </th></tr>'    


SET @body3 = @body3 + @xml3 +'</table></body></html>'

insert into html
select @body3
 
 
--select @result = 'bcp " select body FROM [DBAMonitor].[dbo].[html] " queryout "C:\z.txt" -c -t, -T -S' + @@servername;

--exec master..xp_cmdshell @result; 

DROP TABLE #Temp3
CREATE TABLE #Temp4 
( 
  dbname nvarchar(150),  	
  [object_name] nvarchar(200), 
  exec_count INT,
  [avg_cpu]  decimal(18,3), 
  [avg_elapsed] decimal(18,3), 
  [avg_logical_reads]  int
   
) 
INSERT INTO #Temp4 
exec('
SELECT TOP '+@totalnumber+'  MAX([DBName]) AS DBname, [OBJECT_NAME],  MAX(execution_count) AS exec_count, avg(avg_cpu) AS avg_cpu, avg(avg_elapsed) AS avg_elapsed, AVG(avg_logical_reads) AS avg_logical_reads
      
  FROM [DBAMonitor].[dbo].[SPstatistics]
  where dbname='''+@database_name+''' and last_execution_time >=  '''+@startdate+''' 
	 	  and last_execution_time <dateadd(dd,1,'''+@enddate+''')
  GROUP BY [object_name]
  ORDER BY AVG_LOGICAL_READS DESC
')
 SELECT * FROM #TEMP4

DECLARE @xml4 NVARCHAR(MAX) 
DECLARE @body4 NVARCHAR(MAX)

SET @xml4 = CAST(( SELECT [dbname] AS 'td','',[object_name] AS 'td','', 
       [exec_count] AS 'td','', avg_cpu AS 'td','', [avg_elapsed] AS 'td','', [avg_logical_reads] AS 'td'
FROM  #Temp4 
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX)) 


SET @body4 ='<html><body><H3>TOP SP BY IO</H3> 
<table border = 1> 
<tr> 
<th> DBNAME </th> <th> OBJECT_NAME </th> <th> EXEC_COUNT </th><th> AVERAGE_CPU_TIME </th><th> AVERAGE_DURATION </th><th> AVERAGE_LOGICAL_READS </th></tr>'    


SET @body4 = @body4 + @xml4 +'</table></body></html>'

insert into html
select @body4
 
--select @result = 'bcp " select body FROM [DBAMonitor].[dbo].[html] " queryout "C:\z.txt" -c -t, -T -S' + @@servername;

--exec master..xp_cmdshell @result; 


 Declare  @getdate NVARCHAR(50)

 SET @getdate= CONVERT(CHAR(10),  GETDATE(), 120)


select @result = 'bcp " select body FROM [DBAMonitor].[dbo].[html] " queryout "'+@path+ @getdate +'_'+@database_name+'_topspreport.html" -c -t, -T -S ' + @@servername;

exec master..xp_cmdshell @result; 

DROP TABLE #Temp4
truncate table html

END
