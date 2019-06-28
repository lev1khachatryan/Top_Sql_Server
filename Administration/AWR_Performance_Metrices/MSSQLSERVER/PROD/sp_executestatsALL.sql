USE [DBAMonitor]
GO
/****** Object:  StoredProcedure [dbo].[sp_statistics_alldb]    Script Date: 03/13/2014 08:14:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_statistics_alldb]
as
SELECT  CASE WHEN dbid = 32767 then 'Resource' ELSE DB_NAME(dbid)END AS DBName

      ,OBJECT_SCHEMA_NAME(objectid,dbid) AS [SCHEMA_NAME] 

      ,OBJECT_NAME(objectid,dbid)AS [OBJECT_NAME]

      ,MAX(qs.creation_time) AS 'cache_time'

      ,MAX(last_execution_time) AS 'last_execution_time'

      ,MAX(usecounts) AS [execution_count]

      ,CAST(SUM(total_worker_time) / SUM(usecounts) AS DECIMAL)/100000 AS AVG_CPU

      ,CAST(SUM(total_elapsed_time) / SUM(usecounts) AS DECIMAL)/100000 AS AVG_ELAPSED

      ,SUM(total_logical_reads) / SUM(usecounts) AS AVG_LOGICAL_READS

      ,SUM(total_logical_writes) / SUM(usecounts) AS AVG_LOGICAL_WRITES

      ,SUM(total_physical_reads) / SUM(usecounts)AS AVG_PHYSICAL_READS       

FROM sys.dm_exec_query_stats qs 

   join sys.dm_exec_cached_plans cp on qs.plan_handle = cp.plan_handle

   CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle)

WHERE objtype = 'PROC'

  AND text

       NOT LIKE '%CREATE FUNC%' AND DB_NAME(dbid) NOT IN ('master', 'model', 'msdb', 'tempdb', 'resource', 'dbamonitor')

       GROUP BY cp.plan_handle,DBID,objectid
