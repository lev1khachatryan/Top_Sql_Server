USE [DBAMonitor]
GO
/****** Object:  StoredProcedure [dbo].[topquerybyioalldb]    Script Date: 03/13/2014 08:17:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[topquerybyioalldb]
as
SELECT  COALESCE(DB_NAME(st.dbid), DB_NAME(CAST
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
	execution_count, total_logical_reads + total_logical_writes +
	total_physical_reads total_IOs, (total_logical_reads + total_logical_writes +
	total_physical_reads )/execution_count avg_IOs, total_logical_reads,
	total_logical_reads/execution_count average_logical_reads,
	total_logical_writes, total_logical_writes/execution_count
	average_logical_writes, total_physical_reads,
	total_physical_reads/execution_count average_physical_reads,
	last_execution_time FROM sys.dm_exec_query_stats qs join
	sys.dm_exec_cached_plans cp on qs.plan_handle = cp.plan_handle CROSS
	APPLY sys.dm_exec_sql_text(qs.plan_handle) st OUTER APPLY
	sys.dm_exec_plan_attributes(qs.plan_handle) pa WHERE attribute = 'dbid' and  COALESCE(DB_NAME(st.dbid), DB_NAME(CAST
	(pa.value as int)), 'Resource') not in ('master', 'model', 'msdb','model','resourse','DBAMonitor')
