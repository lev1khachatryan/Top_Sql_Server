USE [DBAMonitor]
GO

/****** Object:  StoredProcedure [dbo].[top100byduration]    Script Date: 03/13/2014 15:58:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE procedure [dbo].[top100byduration]
	
	@totalnumber int,
	@dbname nvarchar(50)
as 
begin


if @dbname is null
begin
	exec ('select top '+@totalnumber+' row_rank, case when B.dbid = 32767 then ''Resource'' else
DB_Name(B.dbid) end database_name, execution_count, substring
(convert(char(23),DATEADD(ms,total_elapsed_time/1000,0),121),12,23)
total_elapsed_time_ms, substring(convert(char(23),DATEADD(ms,
(total_elapsed_time/execution_count)/1000,0),121),12,23)
average_elapsed_time_ms, last_execution_time, TSQL from (select
row_rank, total_elapsed_time, last_execution_time,
execution_count, sql_handle, substring(text, case when
statement_start_offset = 0 or statement_start_offset is NULL then 1 else
statement_start_offset/2 + 1 end, case when statement_end_offset =
0 or statement_end_offset = -1 or statement_end_offset is NULL then len(text) else
statement_end_offset/2 end - case when statement_start_offset = 0
or statement_start_offset is NULL then 1 else statement_start_offset/2 end + 1)
TSQL, plan_handle from (select *, row_number() over(order by substring
(convert(char(23),DATEADD(ms,
(total_elapsed_time/execution_count)/1000,0),121),12,23) desc,
last_execution_time desc) as row_rank from sys.dm_exec_query_stats where
max_elapsed_time > 0) rt cross apply sys.dm_exec_sql_text(rt.sql_handle)) A join
(select plan_handle, cast(value as int) dbid FROM sys.dm_exec_cached_plans
cp OUTER APPLY sys.dm_exec_plan_attributes(cp.plan_handle) WHERE
Attribute = ''dbid'') B on A.plan_handle = B.plan_handle ')
end
 else
exec ('select top '+@totalnumber+' row_rank, case when B.dbid = 32767 then ''Resource'' else
DB_Name(B.dbid) end database_name, execution_count, substring
(convert(char(23),DATEADD(ms,total_elapsed_time/1000,0),121),12,23)
total_elapsed_time_ms, substring(convert(char(23),DATEADD(ms,
(total_elapsed_time/execution_count)/1000,0),121),12,23)
average_elapsed_time_ms, last_execution_time, TSQL from (select
row_rank, total_elapsed_time, last_execution_time,
execution_count, sql_handle, substring(text, case when
statement_start_offset = 0 or statement_start_offset is NULL then 1 else
statement_start_offset/2 + 1 end, case when statement_end_offset =
0 or statement_end_offset = -1 or statement_end_offset is NULL then len(text) else
statement_end_offset/2 end - case when statement_start_offset = 0
or statement_start_offset is NULL then 1 else statement_start_offset/2 end + 1)
TSQL, plan_handle from (select *, row_number() over(order by substring
(convert(char(23),DATEADD(ms,
(total_elapsed_time/execution_count)/1000,0),121),12,23) desc,
last_execution_time desc) as row_rank from sys.dm_exec_query_stats where
max_elapsed_time > 0) rt cross apply sys.dm_exec_sql_text(rt.sql_handle)) A join
(select plan_handle, cast(value as int) dbid FROM sys.dm_exec_cached_plans
cp OUTER APPLY sys.dm_exec_plan_attributes(cp.plan_handle) WHERE
Attribute = ''dbid'') B on A.plan_handle = B.plan_handle and db_name(B.dbid)='''+@dbname+''' 
')


end




GO


