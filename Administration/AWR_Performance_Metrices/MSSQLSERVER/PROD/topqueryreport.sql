USE [DBAMonitor]
GO
/****** Object:  StoredProcedure [dbo].[topqueryreport]    Script Date: 03/13/2014 08:18:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[topqueryreport]
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
  [TSQL]  nvarchar(max), 
  [average_duration]  decimal(18,4), 
  [total_elapsed_time] decimal(18,4), 
  [exec_count]  int,
  dbname nvarchar(50) 
) 
INSERT INTO #Temp 
exec('
select top '+@totalnumber+' tsql, max(total_elapsed_time)/max(exec_count)  average_duration
, max(total_elapsed_time) total_elapsed_time, max(exec_count) exec_count, max(dbname) dbname from [DBAMonitor].[dbo].[TOP_QUERY_BY_TIME]

  where dbname='''+@database_name+''' and last_exec_time >=  '''+@startdate+''' 
	 	  and last_exec_time <dateadd(dd,1,'''+@enddate+''' )
	 
 group by tsql
order by average_duration desc
')
 SELECT * FROM #TEMP

DECLARE @xml NVARCHAR(MAX) 
DECLARE @body NVARCHAR(MAX)

SET @xml = CAST(( SELECT [TSQL] AS 'td','',[average_duration] AS 'td','', 
       [total_elapsed_time] AS 'td','', exec_count AS 'td','', [dbname] AS 'td'
FROM  #Temp 
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX)) 


SET @body ='<html><body><H3>TOP QUERY BY AVERAGE ELAPSED TIME</H3> 
<table border = 1> 
<tr> 
<th> TSQL </th> <th> AVERAGE_DURATION </th> <th> TOTAL_ELAPSED_TIME </th> <th> EXEC_COUNT </th><th> DBNAME </th></tr>'    


SET @body = @body + @xml +'</table></body></html>'

insert into html
select @body
declare @result varchar(255); 
--select @result = 'bcp " select body FROM [DBAMonitor].[dbo].[html] " queryout "C:\z.txt" -c -t, -T -S' + @@servername;

--exec master..xp_cmdshell @result; 

DROP TABLE #Temp
CREATE TABLE #Temp2 
( 
  [TSQL]  nvarchar(max), 
  [average_duration]  decimal(18,4), 
  [total_elapsed_time] decimal(18,4), 
  [exec_count]  int,
  dbname nvarchar(50) 
) 

INSERT INTO #Temp2 
exec('
select top '+@totalnumber+' tsql, max(total_elapsed_time)/max(exec_count)  average_duration
, max(total_elapsed_time) total_elapsed_time, max(exec_count) exec_count, max(dbname) dbname from [DBAMonitor].[dbo].[TOP_QUERY_BY_TIME]

  where dbname='''+@database_name+''' and last_exec_time >=  '''+@startdate+''' 
	 	  and last_exec_time <dateadd(dd,1,'''+@enddate+''' )
	 
 group by tsql
order by total_elapsed_time desc
')
 SELECT * FROM #TEMP2


declare @xml2 nvarchar(max)
SET @xml2 = CAST(( SELECT [TSQL] AS 'td','',[average_duration] AS 'td','', 
       [total_elapsed_time] AS 'td','', exec_count AS 'td','', [dbname] AS 'td'
FROM  #Temp2 
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX)) 

declare @body2 nvarchar(max)
SET @body2 ='<html><body><H3>TOP QUERY BY TOTAL ELAPSED TIME</H3> 
<table border = 1> 
<tr> 
<th> TSQL </th> <th> AVERAGE_DURATION </th> <th> TOTAL_ELAPSED_TIME </th> <th> EXEC_COUNT </th><th> DBNAME </th></tr>'    


SET @body2 = @body2 + @xml2 +'</table></body></html>'

insert into html
select @body2
 
--select @result = 'bcp " select body FROM [DBAMonitor].[dbo].[html] " queryout "C:\z.txt" -c -t, -T -S' + @@servername;

--exec master..xp_cmdshell @result; 

DROP TABLE #Temp2
CREATE TABLE #Temp3 
( 
  [TSQL]  nvarchar(max), 
  [average_duration]  decimal(18,4), 
  [total_elapsed_time] decimal(18,4), 
  [exec_count]  int,
  dbname nvarchar(50) 
) 

INSERT INTO #Temp3 
exec('
select top '+@totalnumber+' tsql, max(total_elapsed_time)/max(exec_count)  average_duration
, max(total_elapsed_time) total_elapsed_time, max(exec_count) exec_count, max(dbname) dbname from [DBAMonitor].[dbo].[TOP_QUERY_BY_TIME]

  where dbname='''+@database_name+''' and last_exec_time >=  '''+@startdate+''' 
	 	  and last_exec_time <dateadd(dd,1,'''+@enddate+''' )
	 
 group by tsql
order by exec_count desc
')
 SELECT * FROM #TEMP3


declare @xml3 nvarchar(max)
SET @xml3 = CAST(( SELECT [TSQL] AS 'td','',[average_duration] AS 'td','', 
       [total_elapsed_time] AS 'td','', exec_count AS 'td','', [dbname] AS 'td'
FROM  #Temp3 
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX)) 

declare @body3 nvarchar(max)
SET @body3 ='<html><body><H3>TOP QUERY BY EXECUTION COUNT</H3> 
<table border = 1> 
<tr> 
<th> TSQL </th> <th> AVERAGE_DURATION </th> <th> TOTAL_ELAPSED_TIME </th> <th> EXEC_COUNT </th><th> DBNAME </th></tr>'    


SET @body3 = @body3 + @xml3 +'</table></body></html>'

insert into html
select @body3
 
--select @result = 'bcp " select body FROM [DBAMonitor].[dbo].[html] " queryout "C:\z.txt" -c -t, -T -S' + @@servername;

--exec master..xp_cmdshell @result; 

DROP TABLE #Temp3
CREATE TABLE #Temp4 
( 
  [TSQL]  nvarchar(max), 
  [average_cpu_time]  decimal(18,4), 
  [total_cpu_time] decimal(18,4), 
  [exec_count]  int,
  dbname nvarchar(50) 
) 

INSERT INTO #Temp4 
exec('select top '+@totalnumber+' tsql, max(total_cpu_time_ms)/max(execution_count) average_cpu_time
, max(total_cpu_time_ms) total_cpu_time, max(execution_count) exec_count, max(dbname) dbname from [DBAMonitor].[dbo].[TOP_QUERY_BY_CPU]



  where dbname='''+@database_name+''' and last_execution_time >=  '''+@startdate+'''
	 	  and last_execution_time <dateadd(dd,1,'''+@enddate+''')

  
  group by tsql
order by total_cpu_time desc')
 SELECT * FROM #TEMP4


declare @xml4 nvarchar(max)
SET @xml4 = CAST(( SELECT [TSQL] AS 'td','',[average_cpu_time] AS 'td','', 
       [total_cpu_time] AS 'td','', exec_count AS 'td','', [dbname] AS 'td'
FROM  #Temp4 
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX)) 

declare @body4 nvarchar(max)
SET @body4 ='<html><body><H3>TOP QUERY BY CPU TIME</H3> 
<table border = 1> 
<tr> 
<th> TSQL </th> <th> AVERAGE_CPU_TIME </th> <th> TOTAL_CPU_TIME </th> <th> EXEC_COUNT </th><th> DBNAME </th></tr>'    


SET @body4 = @body4 + @xml4 +'</table></body></html>'

insert into html
select @body4
 
--select @result = 'bcp " select body FROM [DBAMonitor].[dbo].[html] " queryout "C:\z.txt" -c -t, -T -S' + @@servername;

--exec master..xp_cmdshell @result; 

DROP TABLE #Temp4
CREATE TABLE #Temp5 
( 
  [TSQL]  nvarchar(max), 
  [average_logical_reads]  int, 
  [total_logical_reads] int, 
  [exec_count]  int,
  dbname nvarchar(50) 
) 

INSERT INTO #Temp5 
exec('SELECT TOP '+@totalnumber+' [TSQL],  
      
      max([total_logical_reads])/max([execution_count]) as average_logical_reads,
      max(total_logical_reads) as total_logical_reads,
      max([execution_count]) exec_count, max(dbname) dbname
      
  FROM [DBAMonitor].[dbo].[TOP_QUERY_BY_IO]
  
  where  dbname='''+@database_name+''' and last_execution_time >=  '''+@startdate+'''  
  and last_execution_time <dateadd(dd,1,'''+@enddate+''' )
	 	  
	 
  
  group by tsql
  order by average_logical_reads desc')
 SELECT * FROM #TEMP5


declare @xml5 nvarchar(max)
SET @xml5 = CAST(( SELECT [TSQL] AS 'td','',[average_logical_reads] AS 'td','', 
       [total_logical_reads] AS 'td','', exec_count AS 'td','', [dbname] AS 'td'
FROM  #Temp5 
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX)) 

declare @body5 nvarchar(max)
SET @body5 ='<html><body><H3>TOP QUERY BY IO</H3> 
<table border = 1> 
<tr> 
<th> TSQL </th> <th> AVERAGE_LOGICAL_READS </th> <th> TOTAL_LOGICAL_READS </th> <th> EXEC_COUNT </th><th> DBNAME </th></tr>'    


SET @body5 = @body5 + @xml5 +'</table></body></html>'

insert into html
select @body5
 Declare  @getdate NVARCHAR(50)

 SET @getdate= CONVERT(CHAR(10),  GETDATE(), 120)


select @result = 'bcp " select body FROM [DBAMonitor].[dbo].[html] " queryout "'+@path+ @getdate +'_'+@database_name+'_topqueryreport.html" -c -t, -T -S ' + @@servername;

exec master..xp_cmdshell @result; 

DROP TABLE #Temp5
truncate table html

END
