SELECT DISTINCT TOP 10
t.TEXT QueryName,
s.execution_count AS ExecutionCount,
s.max_elapsed_time AS MaxElapsedTime,
ISNULL(s.total_elapsed_time / s.execution_count, 0) AS AvgElapsedTime,
s.creation_time AS LogCreatedOn,
ISNULL(s.execution_count / DATEDIFF(s, s.creation_time, GETDATE()), 0) AS FrequencyPerSec
FROM sys.dm_exec_query_stats s
CROSS APPLY sys.dm_exec_sql_text( s.sql_handle ) t
ORDER BY
ExecutionCount DESC ,
s.max_elapsed_time DESC
GO



SELECT sqltext.TEXT,
req.session_id,
req.status,
req.command,
req.cpu_time,
req.total_elapsed_time
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext


