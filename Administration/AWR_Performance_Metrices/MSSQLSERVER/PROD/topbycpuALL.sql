USE [DBAMonitor]
GO
/****** Object:  StoredProcedure [dbo].[topquerybycpualldb]    Script Date: 03/13/2014 08:15:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[topquerybycpualldb]
as

SELECT COALESCE(DB_NAME(st.dbid), DB_NAME(CAST
(pa.value as int)), 'Resource') AS DBNAME, SUBSTRING(text,
CASE WHEN statement_start_offset = 0 OR statement_start_offset IS
NULL THEN 1 ELSE statement_start_offset/2 + 1 END,
CASE WHEN statement_end_offset = 0 OR statement_end_offset = -1
OR statement_end_offset IS NULL THEN LEN(text) ELSE
statement_end_offset/2 END - CASE WHEN statement_start_offset =
0 OR statement_start_offset IS NULL THEN 1
ELSE statement_start_offset/2 END + 1 ) AS TSQL, objtype,
OBJECT_SCHEMA_NAME(st.objectid,dbid)
Schema_Name ,OBJECT_NAME(st.objectid,dbid) Obect_Name,
execution_count, 
--substring(convert(char(23),DATEADD(ms,total_worker_time/1000,0),121),12,23) total_cpu_time_ms, 
--substring(convert(char(23),DATEADD(ms,(total_worker_time/execution_count *1.0)/1000,0),121),12,23) average_cpu_time_ms, 
cast(total_worker_time as decimal)/1000000,
cast(total_worker_time as decimal)/execution_count/1000000,
last_execution_time FROM
sys.dm_exec_query_stats qs join sys.dm_exec_cached_plans cp on
qs.plan_handle = cp.plan_handle CROSS APPLY sys.dm_exec_sql_text
(qs.plan_handle) st OUTER APPLY sys.dm_exec_plan_attributes
(qs.plan_handle) pa WHERE attribute = 'dbid' and COALESCE(DB_NAME(st.dbid), DB_NAME(CAST
(pa.value as int)), 'Resource') not in ('msdb', 'master', 'tempdb', 'model', 'resourse')
